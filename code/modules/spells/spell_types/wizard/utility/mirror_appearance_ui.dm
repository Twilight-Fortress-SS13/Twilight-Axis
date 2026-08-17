/**
 * MIRROR APPEARANCE - TGUI EDITOR
 * --------------------------------
 * A tgui replacement for the legacy input()-popup-chain in
 * mirror_transform.dm (see /proc/perform_mirror_transform). Exposes hair,
 * face, creature features, chest, genitals, body markings and species
 * descriptors through a single reactive panel instead of a chain of
 * native OS popups. Color fields open the game's own native
 * color_pick_sanitized() dialog rather than a custom web picker.
 *
 * Open it with:  perform_mirror_transform_ui(H, source_atom)
 * (see the bottom of mirror_transform.dm and mirror.dm's call sites)
 *
 * The panel keeps itself honest while open: a self-rescheduling timer
 * (schedule_validity_check/periodic_validity_check) checks every second
 * that TRAIT_MIRROR_MAGIC/TRAIT_EDIT_DESCRIPTORS is still present and
 * the player is still near the mirror, independent of whether they're
 * actively interacting with the panel. On failure it waits a few
 * seconds (showing "Зеркало гаснет...") before closing itself.
 *
 * A NOTE ON A PRE-EXISTING BUG SPOTTED WHILE PORTING THE LEGACY MENU:
 *   In the original "Testicles" case, `testicles_type.get_default_colors(...)`
 *   is called but its return value is never assigned to
 *   `testicles.accessory_colors` - so testicle colors silently never get
 *   set on creation there. That legacy code wasn't touched, but the
 *   generic color/style helpers here do the assignment correctly, so
 *   the bug doesn't carry over into this panel's "Testicle Color" field.
 */

// ----------------------------------------------------------------------
// SECURITY HELPER - never trust a typepath string sent from the client.
// Only accept it if it resolves to an actual path AND that path is a
// subtype of the base type we asked for.
// ----------------------------------------------------------------------
/proc/mirror_resolve_path(text_path, base_type)
	if(!istext(text_path))
		return null
	var/resolved = text2path(text_path)
	if(!resolved || !ispath(resolved, base_type))
		return null
	return resolved

// Some color fields in this codebase (H.skin_tone in particular, to
// match how it's read elsewhere) are stored WITHOUT a leading "#",
// which is invalid as a raw CSS color and renders as blank/white in
// the UI. This normalizes for display without touching how the value
// is actually stored (other systems may depend on that convention).
/proc/mirror_ensure_hash(color)
	if(!color || !length(color))
		return "#FFFFFF"
	if(copytext(color, 1, 2) != "#")
		return "#[color]"
	return color

/proc/mirror_organ_slot_map()
	var/static/list/slot_map = list(
		"ears" = ORGAN_SLOT_EARS,
		"horns" = ORGAN_SLOT_HORNS,
		"wings" = ORGAN_SLOT_WINGS,
		"tail" = ORGAN_SLOT_TAIL,
		"snout" = ORGAN_SLOT_SNOUT,
		"fluff" = ORGAN_SLOT_NECK_FEATURE,
		"breasts" = ORGAN_SLOT_BREASTS,
		"penis" = ORGAN_SLOT_PENIS,
		"testicles" = ORGAN_SLOT_TESTICLES,
		"vagina" = ORGAN_SLOT_VAGINA,
	)
	return slot_map

/proc/mirror_organ_feature_map()
	var/static/list/feature_map = list(
		"ears" = "ears_color",
		"horns" = "horns_color",
		"wings" = "wings_color",
		"tail" = "tail_color",
		"snout" = "snout_color",
		"fluff" = "neck_feature_color",
	)
	return feature_map

// ----------------------------------------------------------------------
// GENERIC COLOR HELPER
// Covers every organ that stores an accessory_colors string keyed by
// index (Ears, Horns, Wings, Tail, Snout, Fluff/neck_feature, Breasts,
// and - newly exposed here - Penis and Testicles). This is the same
// Remove -> edit -> Insert -> update_body sequence used throughout the
// original file, just parameterized instead of copy-pasted per organ.
// ----------------------------------------------------------------------
/proc/mirror_set_organ_color(mob/living/carbon/human/H, organ_slot, index, hex_color, feature_key)
	var/obj/item/organ/organ = H.getorganslot(organ_slot)
	if(!organ)
		return FALSE

	index = round(text2num(index))
	if(!index || index < 1)
		return FALSE

	var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(organ.accessory_type)
	var/color_keys = accessory_datum ? accessory_datum.color_keys : index

	organ.Remove(H)

	var/list/colors = list()
	if(organ.accessory_colors)
		colors = color_string_to_list(organ.accessory_colors)
	while(length(colors) < max(color_keys, index))
		colors += "#FFFFFF"

	colors[index] = sanitize_hexcolor(hex_color, 6, TRUE)
	organ.accessory_colors = color_list_to_string(colors)
	organ.Insert(H, TRUE, FALSE)

	if(feature_key)
		H.dna.features[feature_key] = colors[index]

	H.update_body()
	return TRUE

// Builds the {present, style, colors[]} block ui_data() sends per organ.
/datum/mirror_appearance_ui/proc/describe_organ_colors(obj/item/organ/organ)
	var/list/info = list()
	if(!organ)
		info["present"] = FALSE
		return info

	info["present"] = TRUE
	var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(organ.accessory_type)
	info["style"] = accessory_datum ? accessory_datum.name : "Unknown"

	var/list/colors = list()
	if(organ.accessory_colors)
		colors = color_string_to_list(organ.accessory_colors)

	// color_disabled is a separate gate from color_keys - confirmed in
	// customizer_choice.dm's generate_pref_choices():
	// "if(allows_accessory_color_customization && !(accessory.color_disabled))"
	// Some accessories have color_keys > 0 but are still marked
	// non-colorable via this flag, which was being missed before.
	var/color_keys = (accessory_datum && !accessory_datum.color_disabled) ? accessory_datum.color_keys : 0
	var/list/labels = (accessory_datum && accessory_datum.color_key_names) ? accessory_datum.color_key_names : list()

	var/list/out_colors = list()
	for(var/i in 1 to color_keys)
		out_colors += list(list(
			"index" = i,
			"label" = (length(labels) >= i) ? labels[i] : "Цвет [i]",
			"value" = (length(colors) >= i) ? colors[i] : "#FFFFFF",
		))
	info["colors"] = out_colors
	return info

// Same idea as describe_organ_colors(), but for a head bodypart_feature
// (accessory / face_detail) instead of an organ. Both share the exact
// same accessory_type/accessory_colors field names (confirmed in
// code\modules\surgery\bodyparts\bodypart_features\_bodypart_feature.dm),
// so this is basically a copy with a different input type.
/datum/mirror_appearance_ui/proc/describe_feature_colors(datum/bodypart_feature/feature)
	var/list/info = list()
	if(!feature)
		info["colors"] = list()
		return info

	var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(feature.accessory_type)
	var/list/colors = list()
	if(feature.accessory_colors)
		colors = color_string_to_list(feature.accessory_colors)

	var/color_keys = (accessory_datum && !accessory_datum.color_disabled) ? accessory_datum.color_keys : 0
	var/list/labels = (accessory_datum && accessory_datum.color_key_names) ? accessory_datum.color_key_names : list()

	var/list/out_colors = list()
	for(var/i in 1 to color_keys)
		out_colors += list(list(
			"index" = i,
			"label" = (length(labels) >= i) ? labels[i] : "Цвет [i]",
			"value" = (length(colors) >= i) ? colors[i] : "#FFFFFF",
		))
	info["colors"] = out_colors
	return info

// ----------------------------------------------------------------------
// Body markings (tattoos, scars, patterns, etc). Confirmed structure:
//   H.dna.body_markings = list(zone = list(marking_name = "RRGGBB", ...), ...)
// (no # prefix on the stored color, matching /datum/body_marking's own
// default_color format and preferences_body_markings.dm's convention).
// GLOB.body_markings[name] gives the /datum/body_marking instance.
// marking_list_of_zone_for_species()/apply_markings_to_body_parts() are
// existing procs in body_markings_helpers.dm - reused here rather than
// reimplemented.
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/proc/marking_thumb(datum/body_marking/BM)
	if(!BM || !BM.icon || !BM.icon_state)
		return null
	var/icon/thumb_icon = icon(BM.icon, BM.icon_state)
	if(!thumb_icon)
		return null
	return icon2base64(thumb_icon)

/datum/mirror_appearance_ui/proc/describe_markings(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/zone in GLOB.marking_zones)
		var/list/zone_markings = list()
		var/list/current = (H.dna.body_markings) ? H.dna.body_markings[zone] : null
		if(current)
			for(var/marking_name in current)
				var/datum/body_marking/BM = GLOB.body_markings[marking_name]
				zone_markings += list(list(
					"name" = marking_name,
					"color" = "#[current[marking_name]]",
					"thumb" = marking_thumb(BM),
				))
		out["[zone]"] = zone_markings
	return out

/datum/mirror_appearance_ui/proc/describe_marking_candidates(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/zone in GLOB.marking_zones)
		var/list/candidates = marking_list_of_zone_for_species(zone, H.dna.species)
		var/list/used = (H.dna.body_markings && H.dna.body_markings[zone]) ? H.dna.body_markings[zone] : list()
		var/list/zone_candidates = list()
		if(candidates)
			for(var/marking_name in candidates)
				if(marking_name in used)
					continue
				var/datum/body_marking/BM = GLOB.body_markings[marking_name]
				zone_candidates += list(list("name" = marking_name, "path" = marking_name, "thumb" = marking_thumb(BM)))
		out["[zone]"] = zone_candidates
	return out


/datum/mirror_appearance_ui/proc/mirror_set_feature_color(mob/living/carbon/human/H, obj/item/bodypart/head/head, datum/bodypart_feature/current, index, hex_color)
	if(!head || !current)
		return FALSE
	index = round(text2num(index))
	if(!index || index < 1)
		return FALSE

	var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(current.accessory_type)
	var/color_keys = accessory_datum ? accessory_datum.color_keys : index

	var/list/colors = list()
	if(current.accessory_colors)
		colors = color_string_to_list(current.accessory_colors)
	while(length(colors) < max(color_keys, index))
		colors += "#FFFFFF"
	colors[index] = sanitize_hexcolor(hex_color, 6, TRUE)

	var/datum/bodypart_feature/new_feature = new current.type()
	new_feature.set_accessory_type(current.accessory_type, color_list_to_string(colors), H)
	head.remove_bodypart_feature(current)
	head.add_bodypart_feature(new_feature)
	return TRUE

// Style-option list for a subtypesof(base_type) scan, sent once via
// ui_static_data so the frontend has dropdown contents without needing a
// round trip. "none" is prepended for organs that support removal.
// Entries with a blank name (unfinished/leftover types in the codebase)
// are skipped, and entries sharing a name with one already added are
// skipped too (several codebases have multiple typepaths - old
// variants, per-race copies, etc - that happen to render under the
// same display name; showing every one is just visual noise/duplicate
// list entries, so only the first is kept).
/datum/mirror_appearance_ui/proc/build_style_options(base_type, include_none = TRUE, list/exclude_names = null)
	var/list/out = list()
	var/list/seen_names = list()
	if(include_none)
		out += list(list("name" = "Нет", "path" = ""))
		seen_names["Нет"] = TRUE
	for(var/sub_type in subtypesof(base_type))
		var/datum/sprite_accessory/instance = new sub_type()
		var/instance_name = instance.name
		if(!instance_name || !length(instance_name))
			continue
		if(seen_names[instance_name])
			continue
		if(exclude_names && (instance_name in exclude_names))
			continue
		seen_names[instance_name] = TRUE
		out += list(list("name" = instance_name, "path" = "[sub_type]"))
	return out

// ----------------------------------------------------------------------
// THE UI DATUM ITSELF
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui
	var/mob/living/carbon/human/human
	var/atom/source_mirror
	var/datum/tgui/open_ui
	var/invalid_since = 0

/datum/mirror_appearance_ui/New(mob/living/carbon/human/H, atom/source)
	. = ..()
	human = H
	source_mirror = source
	schedule_validity_check()

/datum/mirror_appearance_ui/Destroy()
	human = null
	source_mirror = null
	open_ui = null
	return ..()

/datum/mirror_appearance_ui/ui_state(mob/user)
	return GLOB.always_state

/**
 * Re-checks the same gate mirror.dm's attack_hand()/attack_self() already
 * use before opening this UI in the first place - TRAIT_MIRROR_MAGIC (or
 * TRAIT_EDIT_DESCRIPTORS) must still be present, and if we were opened
 * from a stationary mirror (not a carried hand mirror), the user must
 * still be near it. Without this, the panel - once opened - would stay
 * usable forever from anywhere, since tgui windows don't auto-close on
 * their own.
 */
/datum/mirror_appearance_ui/proc/check_still_valid()
	var/mob/living/carbon/human/H = human
	if(!H || QDELETED(H) || H.stat == DEAD)
		return FALSE
	if(!HAS_TRAIT(H, TRAIT_MIRROR_MAGIC) && !HAS_TRAIT(H, TRAIT_EDIT_DESCRIPTORS))
		return FALSE
	if(source_mirror && !QDELETED(source_mirror) && !H.Adjacent(source_mirror))
		return FALSE
	return TRUE

/**
 * Reschedules itself once a second, independent of tgui polling, so the
 * panel reliably reacts within ~1s of the effect ending or the player
 * leaving range, not "whenever the next unrelated update happens to
 * occur". When check_still_valid() first fails, it doesn't close right
 * away - it keeps the panel open (showing the frontend's "Зеркало
 * гаснет..." placeholder) for a few seconds first, so the player sees
 * why it's closing instead of it just vanishing.
 */
/datum/mirror_appearance_ui/proc/schedule_validity_check()
	addtimer(CALLBACK(src, PROC_REF(periodic_validity_check)), 10)

/datum/mirror_appearance_ui/proc/periodic_validity_check()
	if(QDELETED(src))
		return
	if(!check_still_valid())
		if(!invalid_since)
			invalid_since = world.time
			SStgui.update_uis(src)
		if(world.time >= invalid_since + 30) // 3 second grace period
			close_panel()
			return
	else
		invalid_since = 0
	schedule_validity_check()

/**
 * Closes the panel via two mechanisms for reliability: calling .close()
 * directly on the tgui instance we opened (the most direct way to tell
 * the client to close its window) as well as SStgui.close_uis(src) (the
 * standard subsystem-level cleanup call).
 */
/datum/mirror_appearance_ui/proc/close_panel()
	if(open_ui)
		open_ui.close()
	SStgui.close_uis(src)

/datum/mirror_appearance_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MirrorAppearance", "Mirror")
		ui.open()
	open_ui = ui

/datum/mirror_appearance_ui/ui_close(mob/user)
	. = ..()
	qdel(src)

// ----------------------------------------------------------------------
// STATIC DATA - expensive subtypesof() scans + option lists, sent once
// per panel open rather than recomputed on every keystroke.
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/ui_static_data(mob/user)
	var/mob/living/carbon/human/H = human
	var/list/data = list()

	data["ears_styles"] = build_style_options(/datum/sprite_accessory/ears)
	data["horns_styles"] = build_style_options(/datum/sprite_accessory/horns)
	data["wings_styles"] = build_style_options(/datum/sprite_accessory/wings, TRUE, list("mechanical dragon wings", "Megamoth", "Mothra", "Robotic"))
	data["tail_styles"] = build_style_options(/datum/sprite_accessory/tail)
	data["snout_styles"] = build_style_options(/datum/sprite_accessory/snout)
	data["fluff_styles"] = build_style_options(/datum/sprite_accessory/neck_feature)
	data["breast_styles"] = build_style_options(/datum/sprite_accessory/breasts)
	data["testicle_styles"] = build_style_options(/datum/sprite_accessory/testicles)

	// Built from /datum/customizer_choice/organ/penis/* rather than scanning
	// /obj/item/organ/penis subtypes directly. Each customizer_choice pairs
	// a specific organ_type with a specific sprite_accessories entry - that
	// pairing is the actual source of truth for "what does this type look
	// like". Scanning organ subtypes directly and trusting each one's own
	// default accessory_type was the bug behind "tentacle looks like plain
	// penis" - some organ subtypes just don't set their own accessory_type,
	// so they silently inherited the base class's default appearance.
	// Where a choice offers multiple sprite_accessories (e.g. "Knotted"
	// has 2 variants), only the first/default one is exposed here.
	var/list/penis_options = list(list("name" = "Нет", "path" = ""))
	var/list/seen_penis_names = list("Нет" = TRUE)
	for(var/choice_type in subtypesof(/datum/customizer_choice/organ/penis))
		var/datum/customizer_choice/organ/penis/choice = new choice_type()
		var/choice_name = choice.name
		if(!choice_name || !length(choice_name) || seen_penis_names[choice_name])
			qdel(choice)
			continue
		if(!choice.organ_type || !length(choice.sprite_accessories))
			qdel(choice)
			continue
		seen_penis_names[choice_name] = TRUE
		var/encoded_path = "[choice.organ_type]|[choice.sprite_accessories[1]]"
		penis_options += list(list("name" = choice_name, "path" = encoded_path))
		qdel(choice)
	data["penis_styles"] = penis_options

	data["vagina_styles"] = build_style_options(/datum/sprite_accessory/vagina)
	data["breast_sizes"] = list("Flat", "Slight", "Small", "Moderate", "Large", "Generous", "Heavy", "Massive", "Heaping", "Obscene")
	data["organ_sizes"] = list("small", "average", "large")

	if(H)
		var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
		var/list/hairstyles = list()
		var/list/seen_hair_names = list()
		for(var/hair_type in hair_choice.sprite_accessories)
			var/datum/sprite_accessory/hair/head/instance = new hair_type()
			var/instance_name = instance.name
			if(!instance_name || !length(instance_name) || seen_hair_names[instance_name])
				continue
			seen_hair_names[instance_name] = TRUE
			var/thumb_b64 = null
			if(instance.icon && instance.icon_state)
				var/icon/thumb_icon = icon(instance.icon, instance.icon_state, SOUTH, 1)
				if(thumb_icon)
					thumb_b64 = icon2base64(thumb_icon)
			hairstyles += list(list("name" = instance_name, "path" = "[hair_type]", "thumb" = thumb_b64))
		data["hairstyles"] = hairstyles

		var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
		var/list/facial_styles = list(list("name" = "Нет", "path" = "", "thumb" = null))
		var/list/seen_facial_names = list("Нет" = TRUE)
		for(var/facial_type in facial_choice.sprite_accessories)
			var/datum/sprite_accessory/hair/facial/instance = new facial_type()
			var/instance_name = instance.name
			if(!instance_name || !length(instance_name) || seen_facial_names[instance_name])
				continue
			seen_facial_names[instance_name] = TRUE
			var/thumb_b64 = null
			if(instance.icon && instance.icon_state)
				var/icon/thumb_icon = icon(instance.icon, instance.icon_state, SOUTH, 1)
				if(thumb_icon)
					thumb_b64 = icon2base64(thumb_icon)
			facial_styles += list(list("name" = instance_name, "path" = "[facial_type]", "thumb" = thumb_b64))
		data["facial_hairstyles"] = facial_styles

		var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
		var/list/accessory_opts = list(list("name" = "Нет", "path" = ""))
		var/list/seen_accessory_names = list("Нет" = TRUE)
		for(var/accessory_type in accessory_choice.sprite_accessories)
			var/datum/sprite_accessory/accessory/instance = new accessory_type()
			var/instance_name = instance.name
			if(!instance_name || !length(instance_name) || seen_accessory_names[instance_name])
				continue
			seen_accessory_names[instance_name] = TRUE
			accessory_opts += list(list("name" = instance_name, "path" = "[accessory_type]"))
		data["accessory_styles"] = accessory_opts

		var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
		var/list/face_opts = list(list("name" = "Нет", "path" = ""))
		var/list/seen_face_names = list("Нет" = TRUE)
		for(var/detail_type in face_choice.sprite_accessories)
			var/datum/sprite_accessory/face_detail/instance = new detail_type()
			var/instance_name = instance.name
			if(!instance_name || !length(instance_name) || seen_face_names[instance_name])
				continue
			seen_face_names[instance_name] = TRUE
			face_opts += list(list("name" = instance_name, "path" = "[detail_type]"))
		data["face_detail_styles"] = face_opts

		var/list/gradients = list()
		for(var/gradient_type in GLOB.hair_gradients)
			gradients += "[gradient_type]"
		data["hair_gradients"] = gradients

		var/list/descriptor_categories = list()
		for(var/path in H.dna.species.descriptor_choices)
			var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(path)
			var/list/options = list()
			for(var/desc_type in choice.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				if(descriptor)
					options += list(list("name" = descriptor.name, "path" = "[desc_type]"))
			descriptor_categories += list(list("name" = choice.name, "path" = "[path]", "options" = options))
		data["descriptor_categories"] = descriptor_categories

		// Zone list + Russian labels, mirroring the exact same
		// zone -> name switch used in preferences_body_markings.dm's
		// print_body_markings_page(), just translated.
		var/list/marking_zone_list = list()
		for(var/zone in GLOB.marking_zones)
			var/named_zone = "?"
			switch(zone)
				if(BODY_ZONE_R_ARM)
					named_zone = "Правая рука"
				if(BODY_ZONE_L_ARM)
					named_zone = "Левая рука"
				if(BODY_ZONE_HEAD)
					named_zone = "Голова"
				if(BODY_ZONE_CHEST)
					named_zone = "Грудь"
				if(BODY_ZONE_R_LEG)
					named_zone = "Правая нога"
				if(BODY_ZONE_L_LEG)
					named_zone = "Левая нога"
				if(BODY_ZONE_PRECISE_R_HAND)
					named_zone = "Правая кисть"
				if(BODY_ZONE_PRECISE_L_HAND)
					named_zone = "Левая кисть"
			marking_zone_list += list(list("zone" = "[zone]", "label" = named_zone))
		data["marking_zone_list"] = marking_zone_list

	return data

// ----------------------------------------------------------------------
// LIVE DATA - current values, refreshed on every ui_data() poll.
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/ui_data(mob/user)
	var/mob/living/carbon/human/H = human
	var/list/data = list()
	if(!H)
		data["closing"] = TRUE
		return data

	if(!check_still_valid())
		data["closing"] = TRUE
		return data

	data["closing"] = FALSE
	data["skin"] = list(
		"uses_tones" = !!H.dna.species.use_skintones,
		"color1" = mirror_ensure_hash(H.dna.species.use_skintones ? H.skin_tone : H.dna.features["mcolor"]),
		"color2" = mirror_ensure_hash(H.dna.features["mcolor2"]),
		"color3" = mirror_ensure_hash(H.dna.features["mcolor3"]),
	)
	data["eye_color"] = H.eye_color
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	data["heterochromia"] = eyes ? !!eyes.heterochromia : FALSE
	data["second_eye_color"] = eyes ? eyes.second_color : "#FFFFFF"

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/bodypart_feature/hair/head/current_hair = null
	var/datum/bodypart_feature/hair/facial/current_facial = null
	var/datum/bodypart_feature/accessory/current_accessory = null
	var/datum/bodypart_feature/face_detail/current_detail = null
	if(head && head.bodypart_features)
		for(var/datum/bodypart_feature/feature in head.bodypart_features)
			if(istype(feature, /datum/bodypart_feature/hair/head) && !current_hair)
				current_hair = feature
			else if(istype(feature, /datum/bodypart_feature/hair/facial) && !current_facial)
				current_facial = feature
			else if(istype(feature, /datum/bodypart_feature/accessory) && !current_accessory)
				current_accessory = feature
			else if(istype(feature, /datum/bodypart_feature/face_detail) && !current_detail)
				current_detail = feature

	data["hair"] = list(
		"color" = H.hair_color,
		"style" = current_hair ? "[current_hair.accessory_type]" : "",
		"secondary_gradient" = current_hair ? current_hair.natural_gradient : "",
		"secondary_color" = current_hair ? current_hair.natural_color : H.hair_color,
		"third_gradient" = (current_hair && hasvar(current_hair, "hair_dye_gradient")) ? current_hair.hair_dye_gradient : "",
		"third_color" = (current_hair && hasvar(current_hair, "hair_dye_color")) ? current_hair.hair_dye_color : H.hair_color,
	)
	data["facial_hair"] = list(
		"style" = current_facial ? "[current_facial.accessory_type]" : "",
		"color" = H.facial_hair_color,
	)
	data["accessory_style"] = current_accessory ? "[current_accessory.accessory_type]" : ""
	data["accessory_colors"] = describe_feature_colors(current_accessory)["colors"]
	data["face_detail_style"] = current_detail ? "[current_detail.accessory_type]" : ""
	data["face_detail_colors"] = describe_feature_colors(current_detail)["colors"]

	data["ears"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_EARS))
	data["horns"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_HORNS))
	data["wings"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_WINGS))
	data["tail"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_TAIL))
	data["snout"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_SNOUT))
	data["fluff"] = describe_organ_colors(H.getorganslot(ORGAN_SLOT_NECK_FEATURE))

	var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
	data["breasts"] = describe_organ_colors(breasts)
	data["breasts"]["size"] = breasts ? breasts.breast_size : 0

	var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
	data["penis"] = describe_organ_colors(penis)
	data["penis"]["size"] = penis ? penis.penis_size : 2
	data["penis"]["style_path"] = penis ? "[penis.type]|[penis.accessory_type]" : ""

	var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
	data["testicles"] = describe_organ_colors(testicles)
	data["testicles"]["size"] = testicles ? testicles.ball_size : 2

	var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
	data["vagina"] = describe_organ_colors(vagina)

	// Note: there's no getter for "which descriptor is currently active"
	// in the legacy system either (H.add_mob_descriptor/remove_mob_descriptor
	// are write-only) - so, same as the old popup menu, this tab lets you
	// pick a new value without pre-highlighting the current one.
	data["descriptors"] = list()

	data["markings"] = describe_markings(H)
	data["marking_candidates"] = describe_marking_candidates(H)

	return data

// ----------------------------------------------------------------------
// ACTIONS
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/H = human
	if(!H || !istype(H))
		return

	if(!check_still_valid())
		return

	var/should_update = FALSE

	switch(action)
		// ---- generic color setter, used by every accessory-color field ----
		if("set_organ_color")
			var/list/slot_map = mirror_organ_slot_map()
			var/list/feature_map = mirror_organ_feature_map()
			var/slot = slot_map[params["organ"]]
			if(slot)
				var/feature_key = (params["index"] == 1) ? feature_map[params["organ"]] : null
				should_update = mirror_set_organ_color(H, slot, params["index"], params["color"], feature_key)

		// Opens the game's own native color-picker dialog (the same one
		// the legacy input()-menu uses via color_pick_sanitized) instead
		// of a custom web widget, then applies the result the same way.
		if("pick_organ_color")
			var/list/slot_map = mirror_organ_slot_map()
			var/list/feature_map = mirror_organ_feature_map()
			var/slot = slot_map[params["organ"]]
			if(slot)
				var/obj/item/organ/organ = H.getorganslot(slot)
				if(organ)
					var/idx = round(text2num(params["index"]))
					var/current = "#FFFFFF"
					if(organ.accessory_colors)
						var/list/colors = color_string_to_list(organ.accessory_colors)
						if(length(colors) >= idx)
							current = colors[idx]
					var/new_color = color_pick_sanitized(H, "Choose a color", "[params["organ"]]", current)
					if(new_color)
						var/feature_key = (idx == 1) ? feature_map[params["organ"]] : null
						should_update = mirror_set_organ_color(H, slot, idx, new_color, feature_key)

		// ---- skin / eyes ----
		if("set_skin_color")
			should_update = apply_skin_color(H, text2num(params["tier"]), params["color"])

		if("pick_skin_color")
			var/tier = text2num(params["tier"])
			var/current = get_current_skin_color(H, tier)
			var/new_color = color_pick_sanitized(H, "Choose skin color", "Skin Color", current)
			if(new_color)
				should_update = apply_skin_color(H, tier, new_color)

		if("set_eye_color")
			should_update = apply_eye_color(H, params["color"])

		if("pick_eye_color")
			var/new_color = color_pick_sanitized(H, "Choose eye color", "Eye Color", H.eye_color)
			if(new_color)
				should_update = apply_eye_color(H, new_color)

		if("toggle_heterochromia")
			should_update = toggle_heterochromia(H)

		if("pick_second_eye_color")
			var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
			var/current = eyes ? eyes.second_color : "#FFFFFF"
			var/new_color = color_pick_sanitized(H, "Choose second eye color", "Second Eye Color", current)
			if(new_color)
				should_update = apply_second_eye_color(H, new_color)

		// ---- hair ----
		if("set_hairstyle")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/hair/head)
			if(new_style && head_has_slot(H))
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
				var/datum/bodypart_feature/hair/head/current_hair = get_current_feature(head, /datum/bodypart_feature/hair/head)

				var/datum/customizer_entry/hair/hair_entry = new()
				hair_entry.hair_color = current_hair ? current_hair.hair_color : H.hair_color
				if(current_hair)
					hair_entry.natural_gradient = current_hair.natural_gradient
					hair_entry.natural_color = current_hair.natural_color
					if(hasvar(current_hair, "hair_dye_gradient"))
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
					if(hasvar(current_hair, "hair_dye_color"))
						hair_entry.dye_color = current_hair.hair_dye_color

				var/datum/bodypart_feature/hair/head/new_hair = new()
				new_hair.set_accessory_type(new_style, hair_entry.hair_color, H)
				hair_choice.customize_feature(new_hair, H, null, hair_entry)

				if(current_hair)
					head.remove_bodypart_feature(current_hair)
				head.add_bodypart_feature(new_hair)
				H.update_hair()
				should_update = TRUE

		if("set_hair_color")
			should_update = apply_hair_color(H, params["color"])

		if("pick_hair_color")
			var/new_color = color_pick_sanitized(H, "Choose hair color", "Hair Color", H.hair_color)
			if(new_color)
				should_update = apply_hair_color(H, new_color)

		if("set_hair_gradient")
			should_update = apply_hair_gradient(H, text2num(params["tier"]), params["style"], null)

		if("set_hair_gradient_color")
			should_update = apply_hair_gradient(H, text2num(params["tier"]), null, params["color"])

		if("pick_hair_gradient_color")
			var/tier = text2num(params["tier"])
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			var/datum/bodypart_feature/hair/head/current_hair = get_current_feature(head, /datum/bodypart_feature/hair/head)
			var/current = H.hair_color
			if(current_hair)
				current = (tier == 2) ? current_hair.natural_color : current_hair.hair_dye_color
			var/new_color = color_pick_sanitized(H, "Choose gradient color", "Gradient Color", current)
			if(new_color)
				should_update = apply_hair_gradient(H, tier, null, new_color)

		if("set_facial_hairstyle")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/hair/facial)
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			var/datum/bodypart_feature/hair/facial/current_facial = get_current_feature(head, /datum/bodypart_feature/hair/facial)
			if(head)
				if(current_facial)
					head.remove_bodypart_feature(current_facial)
				if(new_style)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/datum/customizer_entry/hair/facial/facial_entry = new()
					facial_entry.hair_color = current_facial ? current_facial.hair_color : H.facial_hair_color

					var/datum/bodypart_feature/hair/facial/new_facial = new()
					new_facial.set_accessory_type(new_style, facial_entry.hair_color, H)
					facial_choice.customize_feature(new_facial, H, null, facial_entry)
					head.add_bodypart_feature(new_facial)
				H.update_hair()
				should_update = TRUE

		if("set_facial_hair_color")
			should_update = apply_facial_hair_color(H, params["color"])

		if("pick_facial_hair_color")
			var/new_color = color_pick_sanitized(H, "Choose facial hair color", "Facial Hair Color", H.facial_hair_color)
			if(new_color)
				should_update = apply_facial_hair_color(H, new_color)

		if("set_accessory")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/accessory)
			should_update = apply_accessory_style(H, new_style)

		if("pick_accessory_color")
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			var/datum/bodypart_feature/accessory/current = get_current_feature(head, /datum/bodypart_feature/accessory)
			if(head && current)
				var/idx = round(text2num(params["index"]))
				var/current_color = "#FFFFFF"
				if(current.accessory_colors)
					var/list/colors = color_string_to_list(current.accessory_colors)
					if(length(colors) >= idx)
						current_color = colors[idx]
				var/new_color = color_pick_sanitized(H, "Choose accessory color", "Accessory Color", current_color)
				if(new_color)
					should_update = mirror_set_feature_color(H, head, current, idx, new_color)

		if("set_face_detail")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/face_detail)
			should_update = apply_face_detail_style(H, new_style)

		if("pick_face_detail_color")
			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			var/datum/bodypart_feature/face_detail/current = get_current_feature(head, /datum/bodypart_feature/face_detail)
			if(head && current)
				var/idx = round(text2num(params["index"]))
				var/current_color = "#FFFFFF"
				if(current.accessory_colors)
					var/list/colors = color_string_to_list(current.accessory_colors)
					if(length(colors) >= idx)
						current_color = colors[idx]
				var/new_color = color_pick_sanitized(H, "Choose face detail color", "Face Detail Color", current_color)
				if(new_color)
					should_update = mirror_set_feature_color(H, head, current, idx, new_color)

		// ---- simple "bare new(), default colors" organs ----
		if("set_ears")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/ears)
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(!ears)
				ears = new()
				ears.Insert(H, TRUE, FALSE)
			if(new_style)
				ears.Remove(H)
				ears.accessory_type = new_style
				var/datum/sprite_accessory/ears/ears_type = SPRITE_ACCESSORY(ears.accessory_type)
				ears.accessory_colors = ears_type.get_default_colors(color_key_source_list_from_carbon(H))
				ears.Insert(H, TRUE, FALSE)
			else
				ears.Remove(H)
				ears.accessory_type = initial(ears.accessory_type)
				ears.accessory_colors = initial(ears.accessory_colors)
				ears.Insert(H, TRUE, FALSE)
			H.update_body()
			should_update = TRUE

		if("set_horns", "set_wings", "set_testicles", "set_vagina")
			var/static/list/config = list(
				"set_horns" = list(ORGAN_SLOT_HORNS, /datum/sprite_accessory/horns, /obj/item/organ/horns),
				"set_wings" = list(ORGAN_SLOT_WINGS, /datum/sprite_accessory/wings, /obj/item/organ/wings),
				"set_testicles" = list(ORGAN_SLOT_TESTICLES, /datum/sprite_accessory/testicles, /obj/item/organ/testicles),
				"set_vagina" = list(ORGAN_SLOT_VAGINA, /datum/sprite_accessory/vagina, /obj/item/organ/vagina),
			)
			var/list/cfg = config[action]
			var/slot = cfg[1]
			var/datum/sprite_accessory/base = cfg[2]
			var/organ_base = cfg[3]

			var/new_style = mirror_resolve_path(params["path"], base)
			var/obj/item/organ/organ = H.getorganslot(slot)
			if(!new_style)
				if(organ)
					organ.Remove(H)
					qdel(organ)
					H.update_body()
					should_update = TRUE
			else
				if(!organ)
					organ = new organ_base()
					organ.Insert(H, TRUE, FALSE)
				organ.accessory_type = new_style
				var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(organ.accessory_type)
				organ.accessory_colors = accessory_datum.get_default_colors(color_key_source_list_from_carbon(H))
				H.update_body()
				should_update = TRUE

		// ---- "specific default subtype" organs ----
		if("set_tail", "set_snout", "set_fluff")
			var/static/list/config = list(
				"set_tail" = list(ORGAN_SLOT_TAIL, /datum/sprite_accessory/tail, /obj/item/organ/tail/anthro),
				"set_snout" = list(ORGAN_SLOT_SNOUT, /datum/sprite_accessory/snout, /obj/item/organ/snout/anthro),
				"set_fluff" = list(ORGAN_SLOT_NECK_FEATURE, /datum/sprite_accessory/neck_feature, /obj/item/organ/neck_feature/anthro_fluff),
			)
			var/list/cfg = config[action]
			var/slot = cfg[1]
			var/datum/sprite_accessory/base = cfg[2]
			var/organ_base = cfg[3]

			var/new_style = mirror_resolve_path(params["path"], base)
			var/obj/item/organ/organ = H.getorganslot(slot)
			if(!new_style)
				if(organ)
					organ.Remove(H)
					qdel(organ)
					H.update_body()
					should_update = TRUE
			else
				if(!organ)
					organ = new organ_base()
					organ.Insert(H, TRUE, FALSE)
				organ.accessory_type = new_style
				var/datum/sprite_accessory/accessory_datum = SPRITE_ACCESSORY(organ.accessory_type)
				organ.accessory_colors = accessory_datum.get_default_colors(color_key_source_list_from_carbon(H))
				H.update_body()
				should_update = TRUE

		// ---- breasts (style / size / NEW color) ----
		if("set_breast_style")
			var/new_style = mirror_resolve_path(params["path"], /datum/sprite_accessory/breasts)
			var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
			if(!new_style)
				if(breasts)
					breasts.Remove(H)
					qdel(breasts)
					H.update_body()
					should_update = TRUE
			else
				if(!breasts)
					breasts = new()
					breasts.Insert(H, TRUE, FALSE)
				breasts.accessory_type = new_style
				var/datum/sprite_accessory/breasts/breasts_type = SPRITE_ACCESSORY(breasts.accessory_type)
				breasts.accessory_colors = breasts_type.get_default_colors(color_key_source_list_from_carbon(H))
				H.update_body()
				should_update = TRUE

		if("set_breast_size")
			var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts)
				breasts.breast_size = clamp(round(text2num(params["size"])), 0, 5)
				H.update_body()
				should_update = TRUE

		// ---- penis (style / size) ----
		if("set_penis_style")
			// params["path"] is "organtype|spritetype" (see penis_styles
			// in ui_static_data) - both pieces are needed since several
			// customizer_choice entries share the same organ_type but
			// differ only in which sprite_accessory they pair it with
			// (e.g. "Plain Penis" vs "Plain Penis (anthro)").
			var/list/path_parts = splittext(params["path"], "|")
			var/organ_path = (length(path_parts) == 2) ? mirror_resolve_path(path_parts[1], /obj/item/organ/penis) : null
			var/sprite_path = (length(path_parts) == 2) ? mirror_resolve_path(path_parts[2], /datum/sprite_accessory/penis) : null
			var/obj/item/organ/penis/old_penis = H.getorganslot(ORGAN_SLOT_PENIS)
			if(!organ_path || !sprite_path)
				if(old_penis)
					old_penis.Remove(H)
					qdel(old_penis)
					H.update_body()
					should_update = TRUE
			else
				var/old_size = DEFAULT_PENIS_SIZE
				var/old_colors = null
				var/old_functional = TRUE
				var/old_manual_override = FALSE
				var/old_erect_state = ERECT_STATE_NONE

				if(old_penis)
					old_size = old_penis.penis_size
					old_colors = old_penis.accessory_colors
					old_functional = old_penis.functional
					old_manual_override = old_penis.manual_erection_override
					old_erect_state = old_penis.erect_state
					old_penis.Remove(H)
					qdel(old_penis)

				var/obj/item/organ/penis/new_penis = new organ_path()
				new_penis.penis_size = old_size
				new_penis.functional = old_functional
				// Force the correct sprite explicitly instead of trusting
				// whatever accessory_type this organ class defaults to -
				// that default was the actual bug (some organ subtypes
				// never override it, so they silently looked identical
				// to the plain/default penis).
				new_penis.accessory_type = sprite_path
				new_penis.Insert(H, TRUE, FALSE)

				var/datum/sprite_accessory/penis/penis_accessory = SPRITE_ACCESSORY(new_penis.accessory_type)
				// Was: mirror_pick_accessory_colors(H, penis_accessory, old_colors) - that's
				// the legacy chain of native input() popups, which made no sense to keep
				// popping up here now that colors have their own proper pickers in this UI
				// (Пенис tab, color swatches). Just carry over old colors if there were any,
				// otherwise fall back to sensible defaults - same as every other organ does
				// on style change (set_ears/set_horns/etc).
				new_penis.accessory_colors = old_colors ? old_colors : penis_accessory.get_default_colors(color_key_source_list_from_carbon(H))

				if(old_manual_override)
					new_penis.set_manual_erect_state(old_erect_state)
				else
					new_penis.on_arousal_changed()

				if(new_penis.sex_organ)
					var/datum/erp_sex_organ/penis/sex_organ = new_penis.sex_organ
					sex_organ.refresh_from_organ(new_penis)
				else
					new_penis.refresh_sex_organ()

				H.update_body()
				should_update = TRUE

		if("set_penis_size")
			var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
			if(penis)
				penis.penis_size = clamp(round(text2num(params["size"])), 1, 3)
				H.update_body()
				should_update = TRUE

		if("set_testicle_size")
			var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testicles)
				testicles.ball_size = clamp(round(text2num(params["size"])), 1, 3)
				H.update_body()
				should_update = TRUE

		// ---- descriptors ----
		if("set_descriptor")
			var/category_path = mirror_resolve_path(params["category"], /datum/descriptor_choice)
			var/desc_path = mirror_resolve_path(params["value"], /datum/mob_descriptor)
			if(category_path && desc_path)
				var/datum/descriptor_choice/chosen_datum = DESCRIPTOR_CHOICE(category_path)
				if(!(desc_path in chosen_datum.descriptors))
					return
				for(var/desc_type in chosen_datum.descriptors)
					H.remove_mob_descriptor(desc_type)
				H.add_mob_descriptor(desc_path)
				should_update = TRUE

		// ---- body markings ----
		if("add_marking")
			var/zone = params["zone"]
			var/marking_name = params["name"]
			if(!(zone in GLOB.marking_zones))
				return
			var/list/candidates = marking_list_of_zone_for_species(zone, H.dna.species)
			if(!candidates || !(marking_name in candidates))
				return
			if(!H.dna.body_markings)
				H.dna.body_markings = list()
			if(!H.dna.body_markings[zone])
				H.dna.body_markings[zone] = list()
			if(H.dna.body_markings[zone].len >= MAXIMUM_MARKINGS_PER_LIMB)
				return
			if(H.dna.body_markings[zone][marking_name])
				return
			var/datum/body_marking/BM = GLOB.body_markings[marking_name]
			if(!BM)
				return
			H.dna.body_markings[zone][marking_name] = BM.get_default_color(H.dna.features, H.dna.species)
			apply_markings_to_body_parts(H.dna.body_markings, H)
			should_update = TRUE

		if("remove_marking")
			var/zone = params["zone"]
			var/marking_name = params["name"]
			if(!H.dna.body_markings || !H.dna.body_markings[zone] || !H.dna.body_markings[zone][marking_name])
				return
			H.dna.body_markings[zone] -= marking_name
			if(!H.dna.body_markings[zone].len)
				H.dna.body_markings -= zone
			apply_markings_to_body_parts(H.dna.body_markings, H)
			should_update = TRUE

		if("pick_marking_color")
			var/zone = params["zone"]
			var/marking_name = params["name"]
			if(!H.dna.body_markings || !H.dna.body_markings[zone] || !H.dna.body_markings[zone][marking_name])
				return
			var/current_color = H.dna.body_markings[zone][marking_name]
			var/new_color = color_pick_sanitized(H, "Choose marking color", "Marking Color", "#[current_color]")
			if(new_color)
				H.dna.body_markings[zone][marking_name] = sanitize_hexcolor(new_color, 6)
				apply_markings_to_body_parts(H.dna.body_markings, H)
				should_update = TRUE

		if("reset_marking_color")
			var/zone = params["zone"]
			var/marking_name = params["name"]
			if(!H.dna.body_markings || !H.dna.body_markings[zone] || !H.dna.body_markings[zone][marking_name])
				return
			var/datum/body_marking/BM = GLOB.body_markings[marking_name]
			if(!BM)
				return
			H.dna.body_markings[zone][marking_name] = BM.get_default_color(H.dna.features, H.dna.species)
			apply_markings_to_body_parts(H.dna.body_markings, H)
			should_update = TRUE

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
		erp_mark_actor_organs_dirty(H)
		. = TRUE

// ----------------------------------------------------------------------
// Color-application helpers - each one is shared between the direct
// "set_X" action (used by the "Match Skin" button, which already knows
// the exact color to apply) and the "pick_X" action (which opens the
// game's native color_pick_sanitized() dialog first, then calls the
// same helper with whatever the player picked).
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/proc/get_current_skin_color(mob/living/carbon/human/H, tier)
	switch(tier)
		if(1)
			return mirror_ensure_hash(H.dna.species.use_skintones ? H.skin_tone : H.dna.features["mcolor"])
		if(2)
			return mirror_ensure_hash(H.dna.features["mcolor2"])
		if(3)
			return mirror_ensure_hash(H.dna.features["mcolor3"])
	return "#FFFFFF"

/datum/mirror_appearance_ui/proc/apply_skin_color(mob/living/carbon/human/H, tier, new_color)
	if(!new_color)
		return FALSE
	switch(tier)
		if(1)
			if(H.dna.species.use_skintones)
				H.skin_tone = sanitize_hexcolor(new_color, 6, FALSE)
			else
				H.dna.features["mcolor"] = sanitize_hexcolor(new_color, 6, TRUE)
		if(2)
			H.dna.features["mcolor2"] = sanitize_hexcolor(new_color, 6, TRUE)
		if(3)
			H.dna.features["mcolor3"] = sanitize_hexcolor(new_color, 6, TRUE)
		else
			return FALSE
	H.update_body_parts()
	return TRUE

/**
 * Uses the existing global /proc/set_eye_color(mob, color_one, color_two)
 * helper (confirmed in code\modules\surgery\organs\eyes.dm) instead of
 * manually Remove()/Insert()-ing the organ - it already handles
 * update_accessory_colors() + update_body_parts() correctly, including
 * respecting heterochromia (it only touches color_one here, leaving
 * second_color/heterochromia alone).
 */
/datum/mirror_appearance_ui/proc/apply_eye_color(mob/living/carbon/human/H, new_color)
	if(!new_color)
		return FALSE
	new_color = sanitize_hexcolor(new_color, 6, TRUE)
	set_eye_color(H, new_color, null)
	H.eye_color = new_color
	H.dna.features["eye_color"] = new_color
	H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	return TRUE

/datum/mirror_appearance_ui/proc/apply_second_eye_color(mob/living/carbon/human/H, new_color)
	if(!new_color)
		return FALSE
	new_color = sanitize_hexcolor(new_color, 6, TRUE)
	set_eye_color(H, null, new_color)
	return TRUE

/datum/mirror_appearance_ui/proc/toggle_heterochromia(mob/living/carbon/human/H)
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return FALSE
	eyes.heterochromia = !eyes.heterochromia
	eyes.update_accessory_colors()
	H.update_body_parts(TRUE)
	return TRUE

/datum/mirror_appearance_ui/proc/apply_hair_color(mob/living/carbon/human/H, new_color)
	if(!new_color)
		return FALSE
	new_color = sanitize_hexcolor(new_color, 6, TRUE)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/bodypart_feature/hair/head/current_hair = get_current_feature(head, /datum/bodypart_feature/hair/head)
	if(!current_hair)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/customizer_entry/hair/hair_entry = new()
	hair_entry.hair_color = new_color

	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current_hair.accessory_type, null, H)
	hair_choice.customize_feature(new_hair, H, null, hair_entry)

	H.hair_color = new_color
	H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

	head.remove_bodypart_feature(current_hair)
	head.add_bodypart_feature(new_hair)

	H.dna.species.handle_body(H)
	H.update_body()
	H.update_hair()
	H.update_body_parts()
	return TRUE

/datum/mirror_appearance_ui/proc/apply_hair_gradient(mob/living/carbon/human/H, tier, new_style, new_color)
	if(!(tier == 2 || tier == 3))
		return FALSE
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/bodypart_feature/hair/head/current_hair = get_current_feature(head, /datum/bodypart_feature/hair/head)
	if(!current_hair)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/customizer_entry/hair/hair_entry = new()
	hair_entry.hair_color = current_hair.hair_color
	hair_entry.natural_gradient = current_hair.natural_gradient
	hair_entry.natural_color = current_hair.natural_color
	hair_entry.dye_gradient = current_hair.hair_dye_gradient
	hair_entry.dye_color = current_hair.hair_dye_color
	hair_entry.accessory_type = current_hair.accessory_type

	if(new_style)
		var/resolved_gradient = text2path(new_style)
		if(!resolved_gradient || !(resolved_gradient in GLOB.hair_gradients))
			return FALSE
		if(tier == 2)
			hair_entry.natural_gradient = resolved_gradient
		else
			hair_entry.dye_gradient = resolved_gradient
	else if(new_color)
		new_color = sanitize_hexcolor(new_color, 6, TRUE)
		if(tier == 2)
			hair_entry.natural_color = new_color
		else
			hair_entry.dye_color = new_color
	else
		return FALSE

	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current_hair.accessory_type, null, H)
	hair_choice.customize_feature(new_hair, H, null, hair_entry)

	head.remove_bodypart_feature(current_hair)
	head.add_bodypart_feature(new_hair)
	return TRUE

/datum/mirror_appearance_ui/proc/apply_facial_hair_color(mob/living/carbon/human/H, new_color)
	if(!new_color)
		return FALSE
	new_color = sanitize_hexcolor(new_color, 6, TRUE)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	var/datum/bodypart_feature/hair/facial/current_facial = get_current_feature(head, /datum/bodypart_feature/hair/facial)
	if(!current_facial)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
	var/datum/customizer_entry/hair/facial/facial_entry = new()
	facial_entry.hair_color = new_color
	facial_entry.accessory_type = current_facial.accessory_type

	var/datum/bodypart_feature/hair/facial/new_facial = new()
	new_facial.set_accessory_type(current_facial.accessory_type, null, H)
	facial_choice.customize_feature(new_facial, H, null, facial_entry)

	H.facial_hair_color = new_color
	H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
	head.remove_bodypart_feature(current_facial)
	head.add_bodypart_feature(new_facial)
	return TRUE

/**
 * CONFIRMED against code\modules\surgery\bodyparts\bodypart_features\_bodypart_feature.dm:
 * accessory/face_detail features store color via `accessory_colors`
 * (a colon-joined hex string, keyed same as organs - NOT a single
 * `.hair_color` var, which was my earlier wrong guess). When swapping
 * style, the existing accessory_colors string is passed through so
 * colors survive the change; set_accessory_type() itself falls back to
 * get_default_colors() when passed null, same as fresh organ creation.
 */
/datum/mirror_appearance_ui/proc/apply_accessory_style(mob/living/carbon/human/H, new_style)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		return FALSE
	var/datum/bodypart_feature/accessory/current = get_current_feature(head, /datum/bodypart_feature/accessory)
	var/colors_to_use = current ? current.accessory_colors : null
	if(current)
		head.remove_bodypart_feature(current)
	if(new_style)
		var/datum/bodypart_feature/accessory/feature = new()
		feature.set_accessory_type(new_style, colors_to_use, H)
		head.add_bodypart_feature(feature)
	return TRUE

/datum/mirror_appearance_ui/proc/apply_face_detail_style(mob/living/carbon/human/H, new_style)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		return FALSE
	var/datum/bodypart_feature/face_detail/current = get_current_feature(head, /datum/bodypart_feature/face_detail)
	var/colors_to_use = current ? current.accessory_colors : null
	if(current)
		head.remove_bodypart_feature(current)
	if(new_style)
		var/datum/bodypart_feature/face_detail/feature = new()
		feature.set_accessory_type(new_style, colors_to_use, H)
		head.add_bodypart_feature(feature)
	return TRUE

// ----------------------------------------------------------------------
// Small shared lookups used above.
// ----------------------------------------------------------------------
/datum/mirror_appearance_ui/proc/get_current_feature(obj/item/bodypart/head/head, base_type)
	if(!head || !head.bodypart_features)
		return null
	for(var/datum/bodypart_feature/feature in head.bodypart_features)
		if(istype(feature, base_type))
			return feature
	return null

/datum/mirror_appearance_ui/proc/head_has_slot(mob/living/carbon/human/H)
	return !!H.get_bodypart(BODY_ZONE_HEAD)
