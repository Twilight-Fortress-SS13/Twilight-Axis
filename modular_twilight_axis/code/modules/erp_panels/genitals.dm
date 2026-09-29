/obj/item/organ
	/// Optional pubic hair accessory rendered with visible groin organs.
	var/pubic_hair_type
	/// Color list string for pubic hair overlay generation.
	var/pubic_hair_colors

/datum/organ_dna
	/// Optional pubic hair accessory type.
	var/pubic_hair_type
	/// Optional pubic hair accessory colors.
	var/pubic_hair_colors

/datum/customizer_entry/organ/vagina
	var/pubic_hair_type = /datum/sprite_accessory/none
	var/pubic_hair_colors

/proc/ta_pubic_hair_accessories()
	return list(
		/datum/sprite_accessory/none,
		/datum/sprite_accessory/public_hair/human,
		/datum/sprite_accessory/public_hair/trimmed,
		/datum/sprite_accessory/public_hair/hairy,
		/datum/sprite_accessory/public_hair/gaping,
		/datum/sprite_accessory/public_hair/furred,
		/datum/sprite_accessory/public_hair/spade,
		/datum/sprite_accessory/public_hair/cloaca,
	)

/datum/sprite_accessory/public_hair
	abstract_type = /datum/sprite_accessory/public_hair
	icon = 'modular_twilight_axis/icons/mob/sprite_accessory/public_hair/public_hair.dmi'
	color_key_name = "Pubic hair"
	color_key_defaults = list(KEY_HAIR_COLOR)
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/public_hair/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDECROTCH|HIDEJUMPSUIT)

/datum/sprite_accessory/public_hair/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/public_hair/human
	icon_state = "human"
	name = "Natural"

/datum/sprite_accessory/public_hair/trimmed
	icon_state = "trimmed"
	name = "Trimmed"

/datum/sprite_accessory/public_hair/hairy
	icon_state = "hairy"
	name = "Bush"

/datum/sprite_accessory/public_hair/gaping
	icon_state = "gaping"
	name = "Lower"

/datum/sprite_accessory/public_hair/furred
	icon_state = "furred"
	name = "Furred"

/datum/sprite_accessory/public_hair/spade
	icon_state = "spade"
	name = "Spade"

/datum/sprite_accessory/public_hair/cloaca
	icon_state = "cloaca"
	name = "Cloaca"

/datum/customizer_choice/organ/vagina/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	validate_pubic_hair_entry(prefs, vagina_entry)

/datum/customizer_choice/organ/vagina/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/customizer_entry/organ/vagina/vagina_entry = entry
	imprint_pubic_hair_organ_dna(organ_dna, vagina_entry, prefs)

/datum/customizer_choice/organ/proc/validate_pubic_hair_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	var/list/valid_accessories = ta_pubic_hair_accessories()
	if(!entry.vars.Find("pubic_hair_type"))
		return

	if(!entry.vars["pubic_hair_type"] || !(entry.vars["pubic_hair_type"] in valid_accessories))
		entry.vars["pubic_hair_type"] = /datum/sprite_accessory/none

	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.vars["pubic_hair_type"])
	if(!accessory || !accessory.color_keys)
		entry.vars["pubic_hair_colors"] = null
		return

	var/reset_colors = FALSE
	if(!entry.vars["pubic_hair_colors"])
		reset_colors = TRUE
	else
		var/list/color_list = color_string_to_list(entry.vars["pubic_hair_colors"])
		if(color_list.len != accessory.color_keys)
			reset_colors = TRUE

	if(reset_colors)
		entry.vars["pubic_hair_colors"] = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))

/datum/customizer_choice/organ/proc/imprint_pubic_hair_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	if(!entry.vars.Find("pubic_hair_type"))
		return

	validate_pubic_hair_entry(prefs, entry)
	organ_dna.pubic_hair_type = entry.vars["pubic_hair_type"]
	organ_dna.pubic_hair_colors = entry.vars["pubic_hair_colors"]

/datum/customizer_choice/organ/proc/generate_pubic_hair_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	if(!entry.vars.Find("pubic_hair_type"))
		return

	validate_pubic_hair_entry(prefs, entry)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.vars["pubic_hair_type"])
	dat += "<br>Pubic hair: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=pubic_hair''>[accessory ? accessory.name : "None"]</a>"
	if(accessory?.color_keys)
		var/list/color_list = color_string_to_list(entry.vars["pubic_hair_colors"])
		dat += "<br>Pubic hair color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=pubic_hair_color''><span class='color_holder_box' style='background-color:[color_list[1]]'></span></a>"

/datum/customizer_choice/organ/proc/handle_pubic_hair_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry)
	if(!entry.vars.Find("pubic_hair_type"))
		return FALSE

	switch(href_list["customizer_task"])
		if("pubic_hair")
			var/list/choice_list = list()
			for(var/choice_type in ta_pubic_hair_accessories())
				var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(choice_type)
				choice_list[accessory.name] = choice_type

			var/chosen_input = tgui_input_list(user, "Choose your pubic hair:", "Character Preference", choice_list)
			if(!chosen_input)
				return TRUE

			var/choice_type = choice_list[chosen_input]
			entry.vars["pubic_hair_type"] = choice_type
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(choice_type)
			entry.vars["pubic_hair_colors"] = accessory.get_default_colors(color_key_source_list_from_prefs(prefs))
			return TRUE

		if("pubic_hair_color")
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(entry.vars["pubic_hair_type"])
			if(!accessory?.color_keys)
				return TRUE

			var/list/color_list = color_string_to_list(entry.vars["pubic_hair_colors"])
			var/new_color = color_pick_sanitized(user, "Choose your pubic hair color:", "Character Preference", "[color_list[1]]")
			if(!new_color)
				return TRUE

			color_list[1] = sanitize_hexcolor(new_color, 6, TRUE)
			entry.vars["pubic_hair_colors"] = color_list_to_string(color_list)
			return TRUE

	return FALSE

/obj/item/organ/proc/get_additional_bodypart_overlays(obj/item/bodypart/bodypart)
	return null

/obj/item/organ/proc/get_pubic_hair_overlay(obj/item/bodypart/bodypart)
	if(!pubic_hair_type)
		return null

	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(pubic_hair_type)
	return accessory?.get_appearance(src, bodypart, pubic_hair_colors)

/obj/item/organ/vagina/get_additional_bodypart_overlays(obj/item/bodypart/bodypart)
	return get_pubic_hair_overlay(bodypart)

/obj/item/organ/get_bodypart_overlay(obj/item/bodypart/bodypart)
	if(!bodypart_icon && !accessory_type)
		return

	if(accessory_type)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		var/list/appearances = accessory?.get_appearance(src, bodypart, accessory_colors)
		if(!appearances)
			return
		var/list/additional_appearances = get_additional_bodypart_overlays(bodypart)
		if(length(additional_appearances))
			appearances += additional_appearances
		for(var/standing in appearances)
			bodypart_icon(standing)
			bodypart_overlays(standing)
		return appearances

	var/mutable_appearance/organ_overlay = mutable_appearance(bodypart_icon, bodypart_icon_state, layer = -bodypart_layer)
	organ_overlay.color = color
	bodypart_icon(organ_overlay)
	bodypart_overlays(organ_overlay)
	return organ_overlay

/obj/item/organ/get_cache_key()
	return "[accessory_type]-[accessory_colors]-[pubic_hair_type]-[pubic_hair_colors]-[bodypart_icon]-[bodypart_icon_state]-[color]-[bodypart_layer]"

/obj/item/organ/imprint_organ_dna(datum/organ_dna/organ_dna)
	..()
	if(pubic_hair_type)
		organ_dna.pubic_hair_type = pubic_hair_type
		organ_dna.pubic_hair_colors = pubic_hair_colors

/datum/organ_dna/imprint_organ(obj/item/organ/organ)
	..()
	organ.pubic_hair_type = pubic_hair_type
	organ.pubic_hair_colors = pubic_hair_colors

/proc/ta_uses_wide_taur_genitals(mob/living/carbon/owner)
	var/obj/item/bodypart/taur/taur_body = owner?.get_taur_tail()
	return istype(taur_body, /obj/item/bodypart/taur/spider) || istype(taur_body, /obj/item/bodypart/taur/horse)

/datum/sprite_accessory/penis/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/mob/living/carbon/owner = organ?.owner
	if(ta_uses_wide_taur_genitals(owner))
		var/obj/item/organ/penis/pp = organ
		if(istype(pp) && pp.erect_state == ERECT_STATE_NONE)
			return null

		var/datum/sprite_accessory/penis/penis_accessory = SPRITE_ACCESSORY(organ.accessory_type)
		if(penis_accessory?.icon_state == "human")
			return ..()

		var/datum/sprite_accessory/taur_penis/taur_accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/taur_penis)
		if(taur_accessory.can_render_taur_state(organ, bodypart, owner))
			return taur_accessory.get_appearance(organ, bodypart, color_string)

	return ..()

/datum/sprite_accessory/taur_penis
	icon = 'modular_twilight_axis/icons/mob/sprite_accessory/penis/taur_penis_onmob.dmi'
	color_keys = 2
	color_key_names = list("Member", "Skin")
	relevant_layers = null
	layer = BODY_BEHIND_LAYER

/datum/sprite_accessory/taur_penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/datum/sprite_accessory/penis/penis_accessory = SPRITE_ACCESSORY(organ.accessory_type)
	return penis_accessory.is_visible(organ, bodypart, owner)

/datum/sprite_accessory/taur_penis/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/bodypart/taur/taur_body = owner.get_taur_tail()
	if(!taur_body)
		return
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.pixel_x += taur_body.offset_x

/datum/sprite_accessory/taur_penis/proc/can_render_taur_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/taur_icon_state = get_icon_state(organ, bodypart, owner)
	return taur_icon_state && icon_exists(icon, "[taur_icon_state]_primary")

/datum/sprite_accessory/taur_penis/get_overlay(overlay_icon_state, color_string)
	var/list/color_list = color_string_to_list(sanitize_color_string(color_string))
	var/icon/result_icon = icon(icon, "[overlay_icon_state]_primary")
	result_icon.Blend(color_list[1], ICON_MULTIPLY)

	var/secondary_state = "[overlay_icon_state]_secondary"
	if(icon_exists(icon, secondary_state))
		var/icon/secondary_icon = icon(icon, secondary_state)
		secondary_icon.Blend(color_list[2], ICON_MULTIPLY)
		result_icon.Blend(secondary_icon, ICON_OVERLAY)

	result_icon.GetPixel(1, 1)

	var/list/appearance_list = list()
	var/mutable_appearance/appearance = mutable_appearance(result_icon, layer = -layer)
	appearance.pixel_x = pixel_x
	appearance.pixel_y = pixel_y
	appearance_list += appearance
	return appearance_list

/datum/sprite_accessory/taur_penis/proc/get_taur_icon_family(obj/item/organ/organ)
	var/datum/sprite_accessory/penis/penis_accessory = SPRITE_ACCESSORY(organ.accessory_type)
	switch(penis_accessory?.icon_state)
		if("flared")
			return "flared"
		if("knotted", "knotted2", "hemiknot", "taperedknot")
			return "knotted"
		if("tapered", "hemi")
			return "tapered"
		if("barbknot")
			return "barbknot"
		if("tentacle")
			return "tentacle"
	return null

/datum/sprite_accessory/taur_penis/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/penis/pp = organ
	if(!istype(pp))
		return null

	var/taur_icon_state = get_taur_icon_family(organ)
	if(!taur_icon_state)
		return null

	var/erect_suffix = (pp.erect_state == ERECT_STATE_HARD) ? 1 : 0
	return "m_penis_[taur_icon_state]_[pp.penis_size]_[erect_suffix]_BEHIND"

/datum/sprite_accessory/testicles/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/mob/living/carbon/owner = organ?.owner
	if(ta_uses_wide_taur_genitals(owner))
		var/obj/item/organ/penis/pp = owner.getorganslot(ORGAN_SLOT_PENIS)
		if(pp && pp.erect_state == ERECT_STATE_NONE)
			return null

		var/datum/sprite_accessory/taur_testicles/taur_accessory = SPRITE_ACCESSORY(/datum/sprite_accessory/taur_testicles)
		return taur_accessory.get_appearance(organ, bodypart, color_string)

	return ..()

/datum/sprite_accessory/taur_testicles
	icon = 'modular_twilight_axis/icons/mob/sprite_accessory/penis/taur_testicles_onmob.dmi'
	color_key_name = "Sack"
	color_key_defaults = list(KEY_SKIN_COLOR)
	relevant_layers = null
	layer = BODY_FRONT_LAYER

/datum/sprite_accessory/taur_testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/datum/sprite_accessory/testicles/testicles_accessory = SPRITE_ACCESSORY(organ.accessory_type)
	return testicles_accessory.is_visible(organ, bodypart, owner)

/datum/sprite_accessory/taur_testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/bodypart/taur/taur_body = owner.get_taur_tail()
	if(!taur_body)
		return
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.pixel_x += taur_body.offset_x

/datum/sprite_accessory/taur_testicles/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/testicles/testes = organ
	if(!istype(testes))
		return null

	return "m_testicles_pair_[testes.ball_size]_FRONT"
