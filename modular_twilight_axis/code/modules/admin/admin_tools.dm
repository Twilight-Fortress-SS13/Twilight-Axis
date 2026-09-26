/client/proc/view_admin_favorites()
	set name = "View Favorites"
	set category = "Admin.Admin"
	set desc = "View round-local favorite players, atoms and datums."
	if(!hascall(src, "view_admin_favorites_impl"))
		return
	return call(src, "view_admin_favorites_impl")()

/client/proc/cmd_admin_select_equipment(mob/M in GLOB.mob_list)
	set category = "Game Master"
	set name = "Select equipment"
	if(!hascall(src, "cmd_admin_select_equipment_impl"))
		return
	return call(src, "cmd_admin_select_equipment_impl")(M)

/client/proc/ta_modify_spells(mob/living/carbon/human/H)
	if(!hascall(src, "ta_modify_spells_impl"))
		return
	return call(src, "ta_modify_spells_impl")(H)

/datum/admins/proc/ta_modify_traits(datum/D)
	if(!hascall(src, "ta_modify_traits_impl"))
		return
	return call(src, "ta_modify_traits_impl")(D)

/datum/admins/proc/ta_get_spawn_advanced_options(list/href_list)
	if(!hascall(src, "ta_get_spawn_advanced_options_impl"))
		return
	return call(src, "ta_get_spawn_advanced_options_impl")(href_list)

/datum/admins/proc/ta_apply_spawn_advanced_options(atom/A, list/options)
	if(!hascall(src, "ta_apply_spawn_advanced_options_impl"))
		return
	return call(src, "ta_apply_spawn_advanced_options_impl")(A, options)

/datum/admins/proc/toggle_favorite_datum(datum/D)
	if(!hascall(src, "toggle_favorite_datum_impl"))
		return
	return call(src, "toggle_favorite_datum_impl")(D)

#define TA_ADMIN_LOADOUT_TRAIT "ta_admin_loadout"
#define TA_ADMIN_LOADOUT_FILE "data/admin_saved_loadouts.json"

GLOBAL_LIST_EMPTY(ta_admin_saved_loadouts)
GLOBAL_VAR_INIT(ta_admin_saved_loadouts_loaded, FALSE)

GLOBAL_DATUM_INIT(ta_round_favorites, /datum/ta_round_favorites, new)

/datum/admins
	var/list/favorite_datums = list()

/client/proc/view_admin_favorites_impl()
	if(!holder || !check_rights(R_ADMIN))
		return
	holder.show_favorites(mob)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "View Favorites")

/datum/admins/proc/add_favorite_datum(datum/D)
	if(!D || QDELETED(D))
		return FALSE
	if(!favorite_datums)
		favorite_datums = list()
	if(D in favorite_datums)
		return FALSE
	favorite_datums += D
	RegisterSignal(D, COMSIG_PARENT_QDELETING, PROC_REF(on_favorite_qdel))
	SStgui.update_uis(GLOB.ta_round_favorites)
	return TRUE

/datum/admins/proc/remove_favorite_datum(datum/D)
	if(!favorite_datums || !(D in favorite_datums))
		return FALSE
	favorite_datums -= D
	if(D && !QDELETED(D))
		UnregisterSignal(D, COMSIG_PARENT_QDELETING)
	SStgui.update_uis(GLOB.ta_round_favorites)
	return TRUE

/datum/admins/proc/toggle_favorite_datum_impl(datum/D)
	if(!D || QDELETED(D))
		return FALSE
	if(D in favorite_datums)
		remove_favorite_datum(D)
		to_chat(usr, span_notice("Removed [D] from round favorites."))
		return FALSE
	add_favorite_datum(D)
	to_chat(usr, span_notice("Added [D] to round favorites."))
	return TRUE

/datum/admins/proc/on_favorite_qdel(datum/source)
	SIGNAL_HANDLER
	if(favorite_datums)
		favorite_datums -= source
	SStgui.update_uis(GLOB.ta_round_favorites)

/datum/admins/proc/show_favorites(mob/admin)
	if(!admin?.client || admin.client.holder != src)
		return
	GLOB.ta_round_favorites.ui_interact(admin)

/datum/ta_round_favorites/ui_state(mob/user)
	if(user?.client?.holder && check_rights_for(user.client, R_ADMIN))
		return GLOB.always_state
	return GLOB.never_state

/datum/ta_round_favorites/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoundFavorites", "Round Favorites")
		ui.open()

/datum/ta_round_favorites/proc/get_favorite(mob/user, list/params)
	var/datum/admins/holder = user?.client?.holder
	if(!holder?.favorite_datums)
		return null
	var/datum/D = locate(params["favorite_ref"])
	if(!D || QDELETED(D) || !(D in holder.favorite_datums))
		return null
	return D

/datum/ta_round_favorites/ui_data(mob/user)
	var/list/favorites = list()
	var/datum/admins/holder = user?.client?.holder
	if(!holder?.favorite_datums)
		return list("favorites" = favorites)

	for(var/datum/D as anything in holder.favorite_datums.Copy())
		if(!D || QDELETED(D))
			holder.favorite_datums -= D
			continue

		var/kind = "Datum"
		var/display_name = html_decode("[D]")
		var/location = "N/A"
		var/can_jump = FALSE
		var/can_follow = FALSE
		var/can_player_panel = FALSE
		var/can_narrate = FALSE
		var/connected = FALSE

		if(isatom(D))
			var/atom/A = D
			var/turf/T = get_turf(A)
			if(ismob(A))
				kind = "Mob"
				var/mob/M = A
				if(M.real_name)
					display_name = html_decode("[M.real_name]")
				can_player_panel = TRUE
				can_narrate = TRUE
				connected = !!M.client
			else if(isturf(A))
				kind = "Turf"
			else if(istype(A, /obj/item))
				kind = "Item"
			else if(istype(A, /obj))
				kind = "Object"
			else if(istype(A, /area))
				kind = "Area"
			else
				kind = "Atom"

			if(T)
				var/area/AR = get_area(T)
				var/area_name = AR?.name || "N/A"
				location = "[html_decode(area_name)] ([T.x], [T.y], [T.z])"
				can_jump = TRUE
			can_follow = ismovable(A)

		favorites += list(list(
			"favorite_ref" = REF(D),
			"name" = display_name,
			"type" = "[D.type]",
			"kind" = kind,
			"location" = location,
			"can_jump" = can_jump,
			"can_follow" = can_follow,
			"can_player_panel" = can_player_panel,
			"can_narrate" = can_narrate,
			"connected" = connected,
		))

	return list("favorites" = favorites)

/datum/ta_round_favorites/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	var/datum/admins/holder = user?.client?.holder
	if(!holder || !check_rights_for(user.client, R_ADMIN))
		return

	if(action == "refresh")
		return TRUE

	var/datum/D = get_favorite(user, params)
	if(!D)
		to_chat(user, span_warning("That favorite no longer exists."))
		return TRUE

	switch(action)
		if("remove")
			holder.remove_favorite_datum(D)
			return TRUE

		if("view-variables")
			user.client.debug_variables(D)
			return TRUE

		if("jump")
			if(!isatom(D))
				return TRUE
			var/atom/A = D
			var/turf/T = get_turf(A)
			if(!T)
				return TRUE
			if(!isobserver(user))
				if(!user.client.admin_ghost())
					return TRUE
			user.client.jumptocoord(T.x, T.y, T.z)
			return TRUE

		if("follow")
			if(!ismovable(D))
				return TRUE
			var/atom/movable/AM = D
			if(!isobserver(user))
				if(!user.client.admin_ghost())
					return TRUE
			if(isobserver(user.client.mob))
				var/mob/dead/observer/O = user.client.mob
				O.ManualFollow(AM)
			return TRUE

		if("player-panel")
			if(ismob(D))
				var/mob/M = D
				holder.show_player_panel(M)
			return TRUE

		if("private-message")
			if(ismob(D))
				var/mob/M = D
				if(M.client)
					user.client.cmd_admin_pm(M.client, null)
			return TRUE

		if("narrate")
			if(ismob(D))
				var/mob/M = D
				user.client.cmd_admin_direct_narrate(M)
			return TRUE

/datum/ta_admin_saved_loadout
	var/name = "Unnamed loadout"
	var/owner_ckey
	var/list/equipment = list()
	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/spells = list()

/datum/ta_admin_saved_loadout/proc/capture_from(mob/living/carbon/human/H)
	if(!ishuman(H))
		return FALSE
	equipment = list()
	stats = list()
	skills = list()
	traits = list()
	spells = list()
	var/static/list/loadout_slots = list(
		SLOT_BACK,
		SLOT_WEAR_MASK,
		SLOT_NECK,
		SLOT_BELT,
		SLOT_RING,
		SLOT_WRISTS,
		SLOT_MOUTH,
		SLOT_SHIRT,
		SLOT_CLOAK,
		SLOT_BACK_R,
		SLOT_BACK_L,
		SLOT_BELT_L,
		SLOT_BELT_R,
		SLOT_GLASSES,
		SLOT_GLOVES,
		SLOT_HEAD,
		SLOT_SHOES,
		SLOT_ARMOR,
		SLOT_PANTS,
		SLOT_L_STORE,
		SLOT_R_STORE,
		SLOT_S_STORE
	)
	for(var/slot in loadout_slots)
		var/obj/item/I = H.get_item_by_slot(slot)
		if(!I)
			continue
		equipment += list(list("slot" = slot, "type" = "[I.type]"))
	for(var/hand_index in 1 to length(H.held_items))
		var/obj/item/held = H.held_items[hand_index]
		if(!held)
			continue
		equipment += list(list("hand" = hand_index, "type" = "[held.type]"))
	var/static/list/stat_names = list(
		STAT_STRENGTH,
		STAT_PERCEPTION,
		STAT_INTELLIGENCE,
		STAT_CONSTITUTION,
		STAT_WILLPOWER,
		STAT_SPEED,
		STAT_FORTUNE
	)
	for(var/stat in stat_names)
		stats[stat] = H.get_stat(stat)
	for(var/skill_type in subtypesof(/datum/skill))
		var/rank = H.get_skill_level(skill_type)
		if(rank)
			skills["[skill_type]"] = rank
	if(H.status_traits)
		for(var/trait in H.status_traits)
			traits |= trait
	if(H.mind)
		for(var/datum/spell as anything in H.mind.spell_list)
			if(spell)
				spells += "[spell.type]"
	return TRUE

/datum/ta_admin_saved_loadout/proc/apply_to(mob/living/carbon/human/H)
	if(!ishuman(H))
		return FALSE
	H.delete_equipment()
	for(var/list/item_data as anything in equipment)
		if(!islist(item_data))
			continue
		var/item_path = text2path(item_data["type"])
		if(!ispath(item_path, /obj/item))
			continue
		var/obj/item/I = new item_path(get_turf(H))
		var/hand_index = text2num(item_data["hand"])
		if(hand_index)
			if(!H.put_in_hand(I, hand_index))
				I.forceMove(get_turf(H))
			continue
		var/slot = text2num(item_data["slot"])
		if(slot)
			H.equip_to_slot_or_del(I, slot, TRUE)
	for(var/stat in stats)
		var/saved_stat = text2num(stats[stat])
		var/current_stat = H.get_stat(stat)
		if(saved_stat != current_stat)
			H.change_stat(stat, saved_stat - current_stat)
	for(var/skill_type in subtypesof(/datum/skill))
		var/saved_rank = text2num(skills["[skill_type]"])
		var/current_rank = H.get_skill_level(skill_type)
		if(saved_rank != current_rank)
			H.adjust_skillrank(skill_type, saved_rank - current_rank, TRUE)
	REMOVE_TRAITS_IN(H, list(TA_ADMIN_LOADOUT_TRAIT, JOB_TRAIT))
	for(var/trait in traits)
		ADD_TRAIT(H, trait, TA_ADMIN_LOADOUT_TRAIT)
	if(H.mind)
		H.mind.RemoveAllSpells()
		for(var/spell_path_text in spells)
			var/spell_path = text2path(spell_path_text)
			if(!ispath(spell_path, /datum/action/cooldown/spell) && !ispath(spell_path, /obj/effect/proc_holder))
				continue
			var/datum/spell = new spell_path
			H.mind.AddSpell(spell, H)
	H.regenerate_icons()
	return TRUE

/datum/ta_admin_saved_loadout/proc/to_json()
	return list(
		"name" = name,
		"owner_ckey" = owner_ckey,
		"equipment" = equipment,
		"stats" = stats,
		"skills" = skills,
		"traits" = traits,
		"spells" = spells
	)

/datum/ta_admin_saved_loadout/proc/load_from_json(list/data)
	if(!islist(data) || !length(data["name"]))
		return FALSE
	name = data["name"]
	owner_ckey = length(data["owner_ckey"]) ? ckey(data["owner_ckey"]) : null
	equipment = islist(data["equipment"]) ? data["equipment"] : list()
	stats = islist(data["stats"]) ? data["stats"] : list()
	skills = islist(data["skills"]) ? data["skills"] : list()
	traits = islist(data["traits"]) ? data["traits"] : list()
	spells = islist(data["spells"]) ? data["spells"] : list()
	return TRUE

/proc/ta_load_admin_saved_loadouts()
	if(GLOB.ta_admin_saved_loadouts_loaded)
		return
	GLOB.ta_admin_saved_loadouts_loaded = TRUE
	if(!fexists(TA_ADMIN_LOADOUT_FILE))
		return
	var/raw_data = file2text(TA_ADMIN_LOADOUT_FILE)
	if(!length(raw_data))
		return
	var/list/decoded = json_decode(raw_data)
	if(!islist(decoded))
		return
	for(var/entry in decoded)
		var/list/loadout_data = entry
		if(!islist(loadout_data))
			continue
		var/datum/ta_admin_saved_loadout/S = new
		if(S.load_from_json(loadout_data) && length(S.owner_ckey))
			GLOB.ta_admin_saved_loadouts += S
		else
			qdel(S)

/proc/ta_save_admin_saved_loadouts()
	ta_load_admin_saved_loadouts()
	var/list/serialized = list()
	for(var/datum/ta_admin_saved_loadout/S in GLOB.ta_admin_saved_loadouts)
		if(!length(S.owner_ckey))
			continue
		serialized += list(S.to_json())
	var/F = file(TA_ADMIN_LOADOUT_FILE)
	fdel(F)
	WRITE_FILE(F, json_encode(serialized))

/client/proc/ta_save_admin_loadout(mob/living/carbon/human/H)
	if(!ishuman(H) || !check_rights(R_SPAWN))
		return null
	ta_load_admin_saved_loadouts()
	var/loadout_name = input(usr, "Name this loadout:", "Save Loadout", H.name) as text|null
	if(isnull(loadout_name))
		return null
	loadout_name = trim(loadout_name)
	if(!length(loadout_name))
		return null
	var/datum/ta_admin_saved_loadout/existing
	for(var/datum/ta_admin_saved_loadout/S in GLOB.ta_admin_saved_loadouts)
		if(S.owner_ckey != ckey)
			continue
		if(LOWER_TEXT(S.name) == LOWER_TEXT(loadout_name))
			existing = S
			break
	if(existing)
		if(alert(usr, "A saved loadout named '[existing.name]' already exists. Replace it?", "Save Loadout", "Replace", "Cancel") != "Replace")
			return null
	else
		existing = new
		GLOB.ta_admin_saved_loadouts += existing
	existing.name = loadout_name
	existing.owner_ckey = ckey
	if(!existing.capture_from(H))
		return null
	ta_save_admin_saved_loadouts()
	to_chat(usr, span_notice("Saved full loadout '[loadout_name]' from [H]."))
	log_admin("[key_name(usr)] saved full admin loadout '[loadout_name]' from [key_name(H)].")
	return existing

/client/proc/ta_robust_dress_shop(mob/living/carbon/human/target)
	ta_load_admin_saved_loadouts()
	var/list/baseoutfits = list("Naked", "Custom", "Save Loadout", "As Roguetown Job...", "Search Jobs...")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job) - typesof(/datum/outfit/job/roguetown)
	for(var/path in paths)
		var/datum/outfit/O = path
		if(initial(O.can_be_admin_equipped))
			outfits[initial(O.name)] = path
	var/dresscode = input(usr, "Select outfit", "Robust quick dress shop") as null|anything in baseoutfits + sortList(outfits)
	if(isnull(dresscode))
		return null
	if(outfits[dresscode])
		dresscode = outfits[dresscode]
	if(dresscode == "Save Loadout")
		ta_save_admin_loadout(target)
		return ta_robust_dress_shop(target)
	if(dresscode == "Custom")
		var/list/custom_names = list()
		for(var/datum/ta_admin_saved_loadout/S in GLOB.ta_admin_saved_loadouts)
			if(S.owner_ckey == ckey)
				custom_names[S.name] = S
		for(var/datum/outfit/D in GLOB.custom_outfits)
			if(custom_names[D.name])
				custom_names["[D.name] (Outfit Manager)"] = D
			else
				custom_names[D.name] = D
		if(!length(custom_names))
			to_chat(usr, span_warning("No custom outfits or saved loadouts exist yet."))
			return ta_robust_dress_shop(target)
		var/selected_name = input(usr, "Select outfit", "Robust quick dress shop") as null|anything in sortList(custom_names)
		dresscode = custom_names[selected_name]
		if(isnull(dresscode))
			return null
	if(dresscode == "Search Jobs...")
		var/search_term = input(usr, "Search for a job (enter keywords):", "Job Search") as text|null
		if(!search_term)
			return null
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/matching_jobs = list()
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			var/path_string = "[path]"
			if(findtext(LOWER_TEXT(path_string), LOWER_TEXT(search_term)))
				if(initial(O.can_be_admin_equipped))
					matching_jobs["[path]"] = path
		if(!length(matching_jobs))
			to_chat(usr, span_warning("No jobs found matching '[search_term]'."))
			return null
		dresscode = input(usr, "Select job (found [length(matching_jobs)] matches)", "Job Search Results") as null|anything in sortList(matching_jobs)
		dresscode = matching_jobs[dresscode]
		if(isnull(dresscode))
			return null
	if(dresscode == "As Roguetown Job...")
		var/list/roguejob_paths = subtypesof(/datum/outfit/job/roguetown)
		var/list/roguejob_outfits = list()
		for(var/path in roguejob_paths)
			var/datum/outfit/O = path
			if(initial(O.can_be_admin_equipped))
				roguejob_outfits["[path]"] = path
		dresscode = input(usr, "Select job equipment", "Robust quick dress shop") as null|anything in sortList(roguejob_outfits)
		dresscode = roguejob_outfits[dresscode]
		if(isnull(dresscode))
			return null
	return dresscode

/client/proc/ta_reset_select_equipment_character(mob/living/carbon/human/H)
	if(!ishuman(H) || !check_rights(R_SPAWN))
		return FALSE

	H.delete_equipment()

	for(var/skill_type in subtypesof(/datum/skill))
		var/current_rank = H.get_skill_level(skill_type)
		if(current_rank)
			H.adjust_skillrank(skill_type, -current_rank, TRUE)

	var/old_true_willpower = H.STAWIL + H.BUFEND
	H.pain_threshold -= (old_true_willpower - initial(H.STAWIL)) * 10
	H.STASTR = initial(H.STASTR)
	H.STAPER = initial(H.STAPER)
	H.STAINT = initial(H.STAINT)
	H.STACON = initial(H.STACON)
	H.STAWIL = initial(H.STAWIL)
	H.STASPD = initial(H.STASPD)
	H.STALUC = initial(H.STALUC)
	H.BUFSTR = 0
	H.BUFPER = 0
	H.BUFINT = 0
	H.BUFCON = 0
	H.BUFEND = 0
	H.BUFSPE = 0
	H.BUFLUC = 0
	H.statbuf = FALSE
	H.statindex = list()

	if(H.statpack)
		var/list/stat_array = H.statpack.get_stat_array(H, null)
		if(islist(stat_array))
			for(var/stat in stat_array)
				var/stat_value = stat_array[stat]
				if(islist(stat_value))
					var/list/stat_range = stat_value
					if(length(stat_range) >= 2)
						stat_value = rand(stat_range[1], stat_range[2])
				if(isnum(stat_value) && stat_value)
					H.change_stat(stat, stat_value)

	if(H.dna?.species?.race_bonus)
		for(var/stat in H.dna.species.race_bonus)
			var/amount = H.dna.species.race_bonus[stat]
			if(amount)
				H.change_stat(stat, amount)

	switch(H.age)
		if(AGE_MIDDLEAGED)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_LCK, 1)
		if(AGE_OLD)
			H.change_stat(STATKEY_STR, -1)
			H.change_stat(STATKEY_SPD, -2)
			H.change_stat(STATKEY_PER, -1)
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_LCK, 1)

	H.update_fov_angles()
	H.update_move_intent_slowdown()

	var/patron_trait_source = H.patron ? "[H.patron.type]" : null
	if(H.status_traits)
		for(var/trait in H.status_traits.Copy())
			var/list/sources = H.status_traits[trait]
			if(!islist(sources))
				continue
			for(var/source in sources.Copy())
				if(patron_trait_source && source == patron_trait_source)
					continue
				REMOVE_TRAIT(H, trait, source)

	if(H.mind)
		H.mind.remove_all_aspects()
		H.mind.RemoveAllSpells()
		H.mind.major_aspects = null
		H.mind.minor_aspects = null
		H.mind.mage_aspect_config = null
		H.mind.aspect_resets_used = 0
		H.mind.has_arcyne_momentum = FALSE
		H.mind.picked_advclass = null
		H.mind.isholy = FALSE
		if(H.mind.special_items)
			H.mind.special_items.Cut()
		if(H.mind.special_items_metadata)
			H.mind.special_items_metadata.Cut()

	QDEL_NULL(H.devotion)
	H.regenerate_icons()
	return TRUE

/proc/ta_admin_get_advclass_by_type(class_path)
	if(!ispath(class_path, /datum/advclass))
		return null
	if(SSrole_class_handler?.sorted_class_categories)
		for(var/category in SSrole_class_handler.sorted_class_categories)
			var/list/category_classes = SSrole_class_handler.sorted_class_categories[category]
			if(!islist(category_classes))
				continue
			for(var/datum/advclass/A as anything in category_classes)
				if(A.type == class_path)
					return A
	return new class_path

/client/proc/ta_apply_robust_dress_selection(mob/living/carbon/human/H, selection)
	if(!ishuman(H) || isnull(selection))
		return FALSE
	if(selection == "Naked")
		H.delete_equipment()
		H.regenerate_icons()
		return TRUE
	if(istype(selection, /datum/ta_admin_saved_loadout))
		var/datum/ta_admin_saved_loadout/S = selection
		return S.apply_to(H)
	if(ispath(selection, /datum/advclass))
		var/datum/advclass/A = ta_admin_get_advclass_by_type(selection)
		if(!A)
			return FALSE
		H.delete_equipment()
		H.ensure_skills()
		if(H.mind)
			H.mind.picked_advclass = A
		A.equipme(H)
		return TRUE
	if(ispath(selection, /datum/outfit))
		H.delete_equipment()
		H.equipOutfit(selection)
		H.regenerate_icons()
		return TRUE
	return FALSE

/proc/ta_admin_roguetown_outfit_name_map()
	var/static/list/outfit_names
	if(outfit_names)
		return outfit_names
	outfit_names = list()
	for(var/class_path in subtypesof(/datum/advclass))
		var/datum/advclass/A = class_path
		var/outfit_path = initial(A.outfit)
		var/class_name = initial(A.name)
		if(ispath(outfit_path, /datum/outfit/job/roguetown) && length(class_name) && !outfit_names["[outfit_path]"])
			outfit_names["[outfit_path]"] = html_decode("[class_name]")
	for(var/job_path in subtypesof(/datum/job/roguetown))
		var/datum/job/J = job_path
		var/outfit_path = initial(J.outfit)
		var/job_name = initial(J.display_title)
		if(!length(job_name))
			job_name = initial(J.title)
		if(ispath(outfit_path, /datum/outfit/job/roguetown) && length(job_name) && !outfit_names["[outfit_path]"])
			outfit_names["[outfit_path]"] = html_decode("[job_name]")
	return outfit_names

/proc/ta_admin_outfit_display_name(outfit_path)
	var/datum/outfit/O = outfit_path
	var/display_name = initial(O.name)
	var/lower_name = LOWER_TEXT("[display_name]")
	if(length(display_name) && lower_name != "outfit" && lower_name != "standard gear")
		return html_decode("[display_name]")
	if(ispath(outfit_path, /datum/outfit/job/roguetown))
		var/list/outfit_names = ta_admin_roguetown_outfit_name_map()
		var/mapped_name = outfit_names["[outfit_path]"]
		if(length(mapped_name))
			return mapped_name
	var/list/path_parts = splittext("[outfit_path]", "/")
	if(!length(path_parts))
		return "Unnamed outfit"
	display_name = path_parts[length(path_parts)]
	display_name = replacetext(display_name, "_", " ")
	return capitalize(display_name)

/datum/ta_select_equipment
	var/client/owner
	var/mob/target_mob
	var/selected_identifier = "Naked"
	var/reset_before_apply = FALSE

/datum/ta_select_equipment/New(client/_owner, mob/target)
	owner = _owner
	if(!ishuman(target) && !isobserver(target))
		qdel(src)
		return
	target_mob = target
	ta_load_admin_saved_loadouts()

/datum/ta_select_equipment/proc/ensure_human_target(mob/user)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/existing_human = target_mob
		existing_human.ensure_skills()
		if(existing_human.mind && !existing_human.mind.sleep_adv)
			existing_human.mind.sleep_adv = new /datum/sleep_adv(existing_human.mind)
		return existing_human
	if(!isobserver(target_mob) || QDELETED(target_mob))
		return null

	var/mob/dead/observer/old_ghost = target_mob
	var/datum/mind/ghost_mind = old_ghost.mind
	var/mob/living/carbon/human/H

	if(!ghost_mind)
		ghost_mind = new /datum/mind(old_ghost.key)
		old_ghost.mind = ghost_mind

	if(!ghost_mind.current)
		ghost_mind.current = old_ghost

	old_ghost.ensure_skills()
	H = old_ghost.change_mob_type(/mob/living/carbon/human, null, null, TRUE)

	if(!ishuman(H))
		to_chat(user, span_warning("Could not create a human body for that ghost."))
		return null

	H.ensure_skills()
	if(H.mind && !H.mind.sleep_adv)
		H.mind.sleep_adv = new /datum/sleep_adv(H.mind)
	target_mob = H
	return H

/datum/ta_select_equipment/ui_state(mob/user)
	if(user?.client == owner && check_rights_for(owner, R_SPAWN))
		return GLOB.always_state
	return GLOB.never_state

/datum/ta_select_equipment/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SelectEquipment", "Select Equipment")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/ta_select_equipment/proc/resolve_selection(identifier)
	if(identifier == "Naked")
		return "Naked"
	var/selection_path = text2path(identifier)
	if(ispath(selection_path, /datum/advclass))
		return selection_path
	if(ispath(selection_path, /datum/outfit))
		return selection_path
	var/datum/D = locate(identifier)
	if(istype(D, /datum/ta_admin_saved_loadout) && (D in GLOB.ta_admin_saved_loadouts))
		var/datum/ta_admin_saved_loadout/S = D
		if(S.owner_ckey == owner?.ckey)
			return S
	if(istype(D, /datum/outfit) && (D in GLOB.custom_outfits))
		return D
	return null

/datum/ta_select_equipment/ui_data(mob/user)
	var/list/entries = list()
	entries += list(list(
		"id" = "Naked",
		"name" = "Naked",
		"category" = "General",
		"type" = "special",
		"deletable" = FALSE,
	))

	var/list/general_paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job) - typesof(/datum/outfit/job/roguetown)
	for(var/path in general_paths)
		var/datum/outfit/O = path
		if(!initial(O.can_be_admin_equipped))
			continue
		entries += list(list(
			"id" = "[path]",
			"name" = ta_admin_outfit_display_name(path),
			"category" = "General",
			"type" = "outfit",
			"path" = "[path]",
			"deletable" = FALSE,
		))

	var/list/represented_job_outfits = list()
	for(var/class_path in subtypesof(/datum/advclass))
		var/datum/advclass/A = class_path
		var/outfit_path = initial(A.outfit)
		if(!ispath(outfit_path, /datum/outfit/job/roguetown))
			continue
		var/datum/outfit/O = outfit_path
		if(!initial(O.can_be_admin_equipped))
			continue
		var/class_name = initial(A.name)
		if(!length(class_name))
			class_name = ta_admin_outfit_display_name(outfit_path)
		represented_job_outfits["[outfit_path]"] = TRUE
		entries += list(list(
			"id" = "[class_path]",
			"name" = html_decode("[class_name]"),
			"category" = "Roguetown Jobs",
			"type" = "job",
			"path" = "[outfit_path]",
			"deletable" = FALSE,
		))

	for(var/path in subtypesof(/datum/outfit/job/roguetown))
		if(represented_job_outfits["[path]"])
			continue
		var/datum/outfit/O = path
		if(!initial(O.can_be_admin_equipped))
			continue
		entries += list(list(
			"id" = "[path]",
			"name" = ta_admin_outfit_display_name(path),
			"category" = "Roguetown Jobs",
			"type" = "job",
			"path" = "[path]",
			"deletable" = FALSE,
		))

	for(var/datum/ta_admin_saved_loadout/S in GLOB.ta_admin_saved_loadouts)
		if(S.owner_ckey != owner?.ckey)
			continue
		entries += list(list(
			"id" = REF(S),
			"name" = html_decode("[S.name]"),
			"category" = "Custom",
			"type" = "preset",
			"deletable" = TRUE,
		))

	for(var/datum/outfit/O in GLOB.custom_outfits)
		entries += list(list(
			"id" = REF(O),
			"name" = html_decode("[O.name] (Outfit Manager)"),
			"category" = "Custom",
			"type" = "custom",
			"deletable" = FALSE,
		))

	var/list/magic_data = list(
		"available" = FALSE,
		"major_aspects" = list(),
		"minor_aspects" = list(),
		"major_slots" = MAX_MAJOR_ASPECTS,
		"minor_slots" = MAX_MINOR_ASPECTS,
		"mastery" = FALSE,
		"patron" = "None",
		"devotion_tier" = "None",
	)
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		magic_data["available"] = TRUE
		if(H.mind)
			var/list/major_names = list()
			for(var/datum/magic_aspect/A in H.mind.major_aspects)
				major_names += A.name
			var/list/minor_names = list()
			for(var/datum/magic_aspect/A in H.mind.minor_aspects)
				minor_names += A.name
			magic_data["major_aspects"] = major_names
			magic_data["minor_aspects"] = minor_names
			if(islist(H.mind.mage_aspect_config))
				var/list/config = H.mind.mage_aspect_config
				if(!isnull(config["major"]))
					magic_data["major_slots"] = config["major"]
				if(!isnull(config["minor"]))
					magic_data["minor_slots"] = config["minor"]
				magic_data["mastery"] = config["mastery"] ? TRUE : FALSE
		if(H.patron)
			magic_data["patron"] = H.patron.name
		if(H.devotion && owner)
			magic_data["devotion_tier"] = owner.ta_get_miracle_tier_name(H.devotion.level)

	return list(
		"target_name" = html_decode("[target_mob.real_name || target_mob.name]"),
		"selected" = selected_identifier,
		"reset_before_apply" = reset_before_apply,
		"entries" = entries,
		"magic" = magic_data,
	)

/datum/ta_select_equipment/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!owner || !target_mob || QDELETED(target_mob))
		return

	switch(action)
		if("select")
			var/selection = resolve_selection(params["id"])
			if(isnull(selection))
				return TRUE
			selected_identifier = params["id"]
			return TRUE

		if("toggle-reset-before-apply")
			reset_before_apply = !reset_before_apply
			return TRUE

		if("reset-character")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("A ghost has no class state to clear. Apply an outfit first."))
				return TRUE
			var/mob/living/carbon/human/reset_target = target_mob
			if(alert(ui.user, "Clear equipment, class stats, all skills, spells, miracles, mage aspects and every trait except traits granted directly by [reset_target.real_name]'s patron?", "Full Class Reset", "Reset", "Cancel") != "Reset")
				return TRUE
			if(!owner.ta_reset_select_equipment_character(reset_target))
				return TRUE
			message_admins("[key_name_admin(ui.user)] fully reset class/loadout state for [ADMIN_LOOKUPFLW(reset_target)].")
			log_admin("[key_name(ui.user)] fully reset class/loadout state for [key_name(reset_target)].")
			return TRUE

		if("magic-give-major")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_give_magic_aspects(target_mob, ASPECT_MAJOR)
			return TRUE

		if("magic-remove-major")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_remove_magic_aspects(target_mob, ASPECT_MAJOR)
			return TRUE

		if("magic-give-minor")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_give_magic_aspects(target_mob, ASPECT_MINOR)
			return TRUE

		if("magic-remove-minor")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_remove_magic_aspects(target_mob, ASPECT_MINOR)
			return TRUE

		if("magic-adjust-aspect-cap")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			var/aspect_type
			switch(params["kind"])
				if("major")
					aspect_type = ASPECT_MAJOR
				if("minor")
					aspect_type = ASPECT_MINOR
				else
					return TRUE
			var/delta = clamp(text2num(params["delta"]), -1, 1)
			if(delta)
				owner.ta_adjust_aspect_capacity(target_mob, aspect_type, delta)
			return TRUE

		if("magic-toggle-mastery")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_toggle_aspect_mastery(target_mob)
			return TRUE

		if("magic-give-miracles")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_give_miracles_by_tier(target_mob)
			return TRUE

		if("magic-remove-miracles")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_remove_miracles(target_mob)
			return TRUE

		if("magic-clear-devotion")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("Create or apply a human body before editing magic."))
				return TRUE
			owner.ta_clear_devotion(target_mob)
			return TRUE

		if("apply")
			var/identifier = params["id"] || selected_identifier
			var/selection = resolve_selection(identifier)
			if(isnull(selection))
				to_chat(ui.user, span_warning("That outfit or preset no longer exists."))
				return TRUE
			var/mob/living/carbon/human/target_human = ensure_human_target(ui.user)
			if(!target_human)
				return TRUE
			if(reset_before_apply && !owner.ta_reset_select_equipment_character(target_human))
				return TRUE
			if(!owner.ta_apply_robust_dress_selection(target_human, selection))
				return TRUE
			selected_identifier = identifier
			message_admins("[key_name_admin(ui.user)] changed equipment/loadout for [ADMIN_LOOKUPFLW(target_human)].")
			log_admin("[key_name(ui.user)] changed equipment/loadout for [key_name(target_human)].")
			SSblackbox.record_feedback("tally", "admin_verb", 1, "Select Equipment")
			return TRUE

		if("save")
			if(!ishuman(target_mob))
				to_chat(ui.user, span_warning("A ghost has no equipment to save. Apply an outfit first."))
				return TRUE
			var/mob/living/carbon/human/save_target = target_mob
			var/datum/ta_admin_saved_loadout/S = owner.ta_save_admin_loadout(save_target)
			if(S)
				selected_identifier = REF(S)
			return TRUE

		if("delete")
			var/datum/ta_admin_saved_loadout/S = locate(params["id"])
			if(!S || !(S in GLOB.ta_admin_saved_loadouts) || S.owner_ckey != owner.ckey)
				return TRUE
			if(alert(ui.user, "Delete saved preset '[S.name]'?", "Delete Preset", "Delete", "Cancel") != "Delete")
				return TRUE
			var/deleted_ref = REF(S)
			GLOB.ta_admin_saved_loadouts -= S
			ta_save_admin_saved_loadouts()
			qdel(S)
			if(selected_identifier == deleted_ref)
				selected_identifier = "Naked"
			return TRUE


/client/proc/cmd_admin_select_equipment_impl(mob/M)
	if(!(ishuman(M) || isobserver(M)))
		alert(src, "Invalid mob")
		return
	var/datum/ta_select_equipment/menu = new(src, M)
	if(QDELETED(menu))
		return
	menu.ui_interact(src.mob)

/datum/admins/proc/ta_get_spawn_advanced_options_impl(list/href_list)
	var/list/options = list("cancelled" = FALSE)
	options["name"] = html_decode(trim(href_list["object_advanced_name"]))
	options["description"] = html_decode(trim(href_list["object_desc"]))
	options["icon_state"] = sanitize(href_list["object_icon_state"])
	if(href_list["object_custom_icon"])
		var/icon/custom_icon = input(usr, "Choose an icon file for the spawned atom(s).", "Custom Spawn Icon") as icon|null
		if(!custom_icon)
			options["cancelled"] = TRUE
			return options
		options["icon"] = custom_icon
	return options

/datum/admins/proc/ta_apply_spawn_advanced_options_impl(atom/A, list/options)
	if(!A || !islist(options))
		return
	var/custom_name = options["name"]
	if(length(custom_name))
		A.name = custom_name
		if(ismob(A))
			var/mob/M = A
			M.real_name = custom_name
	var/custom_description = options["description"]
	if(length(custom_description))
		A.desc = custom_description
	var/icon/custom_icon = options["icon"]
	if(custom_icon)
		A.icon = custom_icon
	var/custom_icon_state = options["icon_state"]
	if(length(custom_icon_state))
		A.icon_state = custom_icon_state

/client/proc/ta_modify_spells_impl(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	switch(alert(usr, "Add or remove spells from [H.name]?", "Add/Remove Spell", "Add", "Remove", "Cancel"))
		if("Add")
			return ta_add_spells(H)
		if("Remove")
			return ta_remove_spells(H)

/client/proc/ta_get_admin_spell_choices()
	var/list/spells = list()
	for(var/path in subtypesof(/datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = path
		spells["[initial(S.name)] ([path])"] = path
	for(var/path in subtypesof(/obj/effect/proc_holder))
		var/obj/effect/proc_holder/S = path
		spells["[initial(S.name)] ([path])"] = path
	return spells

/client/proc/ta_add_spells(mob/T)
	var/list/spells = ta_get_admin_spell_choices()
	var/list/labels = list()
	for(var/label in spells)
		labels += label
	labels = sortList(labels)
	var/list/selected = tgui_input_checkboxes(usr, "Select one or more spells to add.", "Spell Adder", labels, 1, length(labels))
	if(!length(selected))
		return null
	var/list/granted = list()
	var/mindless_grant = FALSE
	for(var/label in selected)
		var/path = spells[label]
		if(!path)
			continue
		var/datum/spell = new path
		if(T.mind)
			T.mind.AddSpell(spell, T)
		else
			if(istype(spell, /datum/action/cooldown/spell))
				var/datum/action/cooldown/spell/action_spell = spell
				action_spell.Grant(T)
			else
				T.AddSpell(spell)
			mindless_grant = TRUE
		granted += label
	if(mindless_grant)
		message_admins(span_danger("Spells given to mindless mobs will not be transferred in mindswap or cloning!"))
	if(length(granted))
		message_admins("[key_name_admin(usr)] has granted [english_list(granted)] to [ADMIN_LOOKUPFLW(T)].")
		log_admin("[key_name(usr)] has granted [english_list(granted)] to [key_name(T)].")
	return granted

/client/proc/ta_remove_spells(mob/H)
	if(!H.mind || !length(H.mind.spell_list))
		to_chat(usr, span_warning("[H] has no mind spells to remove."))
		return null
	var/list/spell_lookup = list()
	var/list/labels = list()
	var/counter = 0
	for(var/datum/spell as anything in H.mind.spell_list)
		if(!spell)
			continue
		counter++
		var/spell_name = ("name" in spell.vars) ? spell.vars["name"] : "Unnamed spell"
		var/label = "[spell_name] ([spell.type])"
		if(spell_lookup[label])
			label = "[label] #[counter]"
		labels += label
		spell_lookup[label] = spell
	var/list/selected = tgui_input_checkboxes(usr, "Select one or more spells to remove.", "Spell Remover", sortList(labels), 1, length(labels))
	if(!length(selected))
		return null
	var/list/removed = list()
	for(var/label in selected)
		var/datum/spell = spell_lookup[label]
		if(!spell)
			continue
		var/spell_name = ("name" in spell.vars) ? spell.vars["name"] : "[spell.type]"
		if(H.mind.RemoveSpell(spell))
			removed += spell_name
	if(length(removed))
		message_admins("[key_name_admin(usr)] has removed [english_list(removed)] from [ADMIN_LOOKUPFLW(H)].")
		log_admin("[key_name(usr)] has removed [english_list(removed)] from [key_name(H)].")
	return removed


/client/proc/ta_admin_spell_name(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return "[initial(S.name)]"
	if(ispath(spell_path, /obj/effect/proc_holder))
		var/obj/effect/proc_holder/S = spell_path
		return "[initial(S.name)]"
	return "[spell_path]"

/client/proc/ta_choose_aspect_spell(datum/magic_aspect/aspect)
	if(!aspect || !length(aspect.choice_spells))
		return null
	if(length(aspect.choice_spells) == 1)
		return aspect.choice_spells[1]
	var/list/spell_choices = list()
	for(var/spell_path in aspect.choice_spells)
		var/label = "[ta_admin_spell_name(spell_path)] ([spell_path])"
		if(length(aspect.mastery_choice_spells) && (spell_path in aspect.mastery_choice_spells))
			label = "[label] (Mastery)"
		spell_choices[label] = spell_path
	var/selected = tgui_input_list(usr, "Choose the aspect's choice spell.", "[aspect.name] - Choice Spell", sortList(spell_choices))
	if(!selected)
		return null
	return spell_choices[selected]

/client/proc/ta_choose_aspect_variant(datum/magic_aspect/aspect)
	if(!aspect || !length(aspect.variants))
		return null
	var/list/variants = list("Default")
	for(var/variant_name in aspect.variants)
		variants += "[variant_name]"
	var/selected = tgui_input_list(usr, "Choose which variant of the aspect to grant.", "[aspect.name] - Variant", sortList(variants))
	if(!selected || selected == "Default")
		return null
	return selected

/client/proc/ta_give_magic_aspects(mob/living/carbon/human/H, aspect_type)
	if(!ishuman(H))
		to_chat(usr, span_warning("Magic aspects can only be granted to humans."))
		return null
	if(!H.mind)
		H.mind_initialize()
	if(!H.mind)
		to_chat(usr, span_warning("Could not initialize a mind for [H]."))
		return null

	var/list/source_paths
	var/aspect_title
	switch(aspect_type)
		if(ASPECT_MAJOR)
			source_paths = GLOB.magic_aspects_major
			aspect_title = "Major"
		if(ASPECT_MINOR)
			source_paths = GLOB.magic_aspects_minor
			aspect_title = "Minor"
		else
			return null

	var/list/aspect_lookup = list()
	var/list/labels = list()
	for(var/aspect_path in source_paths)
		if(H.mind.has_aspect(aspect_path))
			continue
		var/datum/magic_aspect/singleton = GLOB.magic_aspect_singletons[aspect_path]
		if(!singleton)
			continue
		var/label = "[singleton.name] ([aspect_path])"
		aspect_lookup[label] = aspect_path
		labels += label

	if(!length(labels))
		to_chat(usr, span_warning("[H] already has every available [LOWER_TEXT(aspect_title)] aspect."))
		return null

	var/list/selected = tgui_input_checkboxes(usr, "Select one or more [LOWER_TEXT(aspect_title)] aspects to grant. Choice spells and variants can be configured afterwards.", "Give [aspect_title] Aspects", sortList(labels), 1, length(labels))
	if(!length(selected))
		return null

	var/list/original_config = H.mind.mage_aspect_config
	var/list/admin_config = islist(original_config) ? original_config.Copy() : list()
	admin_config["major"] = max(admin_config["major"] || 0, LAZYLEN(H.mind.major_aspects) + (aspect_type == ASPECT_MAJOR ? length(selected) : 0))
	admin_config["minor"] = max(admin_config["minor"] || 0, LAZYLEN(H.mind.minor_aspects) + (aspect_type == ASPECT_MINOR ? length(selected) : 0))
	H.mind.mage_aspect_config = admin_config

	if(!HAS_TRAIT(H, TRAIT_ARCYNE))
		ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)

	var/list/granted = list()
	for(var/label in selected)
		var/aspect_path = aspect_lookup[label]
		if(!aspect_path || H.mind.has_aspect(aspect_path))
			continue
		var/datum/magic_aspect/aspect = new aspect_path
		var/choice_spell
		if(length(aspect.choice_spells))
			choice_spell = ta_choose_aspect_spell(aspect)
			if(!choice_spell)
				qdel(aspect)
				continue
		var/variant = ta_choose_aspect_variant(aspect)
		if(H.mind.attune_aspect(aspect, variant, choice_spell))
			granted += "[aspect.name]"
		else
			qdel(aspect)

	H.mind.mage_aspect_config = original_config
	H.mind.rebuild_action_order()

	if(length(granted))
		message_admins("[key_name_admin(usr)] granted [LOWER_TEXT(aspect_title)] aspects [english_list(granted)] to [ADMIN_LOOKUPFLW(H)].")
		log_admin("[key_name(usr)] granted [LOWER_TEXT(aspect_title)] aspects [english_list(granted)] to [key_name(H)].")
	return granted


/client/proc/ta_get_magic_aspect_config(mob/living/carbon/human/H)
	if(!ishuman(H))
		return null
	if(!H.mind)
		H.mind_initialize()
	if(!H.mind)
		return null

	var/list/config = islist(H.mind.mage_aspect_config) ? H.mind.mage_aspect_config.Copy() : list()
	if(isnull(config["major"]))
		config["major"] = max(MAX_MAJOR_ASPECTS, LAZYLEN(H.mind.major_aspects))
	if(isnull(config["minor"]))
		config["minor"] = max(MAX_MINOR_ASPECTS, LAZYLEN(H.mind.minor_aspects))
	if(isnull(config["mastery"]))
		config["mastery"] = FALSE
	if(isnull(config["utilities"]))
		config["utilities"] = 0
	return config

/client/proc/ta_apply_magic_aspect_config(mob/living/carbon/human/H, list/config)
	if(!ishuman(H) || !H.mind || !islist(config))
		return FALSE
	if(!HAS_TRAIT(H, TRAIT_ARCYNE))
		ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
	H.mind.setup_mage_aspects(config)
	H.mind.check_learnspell()
	H.mind.rebuild_action_order()
	return TRUE

/client/proc/ta_adjust_aspect_capacity(mob/living/carbon/human/H, aspect_type, delta)
	var/list/config = ta_get_magic_aspect_config(H)
	if(!islist(config))
		return FALSE

	var/config_key
	var/aspect_label
	var/current_attuned = 0
	switch(aspect_type)
		if(ASPECT_MAJOR)
			config_key = "major"
			aspect_label = "major"
			current_attuned = LAZYLEN(H.mind.major_aspects)
		if(ASPECT_MINOR)
			config_key = "minor"
			aspect_label = "minor"
			current_attuned = LAZYLEN(H.mind.minor_aspects)
		else
			return FALSE

	var/old_limit = config[config_key]
	if(isnull(old_limit))
		old_limit = 0
	var/new_limit = max(current_attuned, old_limit + delta, 0)
	if(new_limit == old_limit)
		return TRUE
	config[config_key] = new_limit
	if(!ta_apply_magic_aspect_config(H, config))
		return FALSE

	message_admins("[key_name_admin(usr)] changed [aspect_label] aspect capacity for [ADMIN_LOOKUPFLW(H)] from [old_limit] to [new_limit].")
	log_admin("[key_name(usr)] changed [aspect_label] aspect capacity for [key_name(H)] from [old_limit] to [new_limit].")
	return TRUE

/client/proc/ta_collect_surviving_aspect_spells(datum/mind/M, list/excluded_aspects)
	var/list/surviving = list()
	if(!M)
		return surviving
	for(var/datum/magic_aspect/A in M.major_aspects + M.minor_aspects)
		if(excluded_aspects && (A in excluded_aspects))
			continue
		surviving |= A.fixed_spells
		surviving |= A.pointbuy_spells
		if(A.chosen_spell)
			surviving |= A.chosen_spell
			var/resolved_choice = A.resolve_variant_spell(A.chosen_spell)
			if(resolved_choice)
				surviving |= resolved_choice
		if(A.applied_variant && length(A.variants) && (A.applied_variant in A.variants))
			var/list/swaps = A.variants[A.applied_variant]
			for(var/base_path in swaps)
				if(base_path != VARIANT_ADDITIVE)
					surviving |= base_path
				var/upgrade_path = swaps[base_path]
				if(upgrade_path)
					surviving |= upgrade_path
	return surviving

/client/proc/ta_remove_magic_aspects(mob/living/carbon/human/H, aspect_type)
	if(!ishuman(H) || !H.mind)
		to_chat(usr, span_warning("[H] has no magic aspects to remove."))
		return null

	var/list/source
	var/aspect_title
	switch(aspect_type)
		if(ASPECT_MAJOR)
			source = H.mind.major_aspects
			aspect_title = "Major"
		if(ASPECT_MINOR)
			source = H.mind.minor_aspects
			aspect_title = "Minor"
		else
			return null
	if(!length(source))
		to_chat(usr, span_warning("[H] has no [LOWER_TEXT(aspect_title)] aspects to remove."))
		return null

	var/list/aspect_lookup = list()
	var/list/labels = list()
	for(var/datum/magic_aspect/A in source)
		var/label = "[A.name] ([A.type])"
		aspect_lookup[label] = A
		labels += label

	var/list/selected = tgui_input_checkboxes(usr, "Select one or more [LOWER_TEXT(aspect_title)] aspects to remove.", "Remove [aspect_title] Aspects", sortList(labels), 1, length(labels))
	if(!length(selected))
		return null

	var/list/removing = list()
	for(var/label in selected)
		var/datum/magic_aspect/A = aspect_lookup[label]
		if(A)
			removing += A
	var/list/surviving_spells = ta_collect_surviving_aspect_spells(H.mind, removing)
	var/list/removed = list()
	for(var/datum/magic_aspect/A in removing)
		removed += A.name
		H.mind.remove_aspect(A, surviving_spells)
		qdel(A)

	H.mind.ensure_mage_basics()
	H.mind.check_learnspell()
	H.mind.rebuild_action_order()
	if(length(removed))
		message_admins("[key_name_admin(usr)] removed [LOWER_TEXT(aspect_title)] aspects [english_list(removed)] from [ADMIN_LOOKUPFLW(H)].")
		log_admin("[key_name(usr)] removed [LOWER_TEXT(aspect_title)] aspects [english_list(removed)] from [key_name(H)].")
	return removed

/client/proc/ta_toggle_aspect_mastery(mob/living/carbon/human/H)
	var/list/config = ta_get_magic_aspect_config(H)
	if(!islist(config))
		return FALSE
	var/enable_mastery = !config["mastery"]
	config["mastery"] = enable_mastery
	if(!ta_apply_magic_aspect_config(H, config))
		return FALSE

	if(enable_mastery)
		for(var/datum/magic_aspect/A in H.mind.major_aspects + H.mind.minor_aspects)
			if(A.applied_variant && A.applied_variant != "mastery")
				continue
			if(A.applied_variant == "mastery")
				continue
			if(length(A.variants) && ("mastery" in A.variants))
				A.apply_variant(H.mind, "mastery")
	else
		var/list/mastery_aspects = list()
		for(var/datum/magic_aspect/A in H.mind.major_aspects + H.mind.minor_aspects)
			if(A.applied_variant == "mastery")
				mastery_aspects += A
		for(var/datum/magic_aspect/A in mastery_aspects)
			var/list/surviving_spells = ta_collect_surviving_aspect_spells(H.mind, list(A))
			A.revoke_spells(H.mind, surviving_spells)
			A.applied_variant = null
			var/choice_spell = A.chosen_spell
			A.chosen_spell = null
			if(choice_spell && (choice_spell in A.mastery_choice_spells))
				choice_spell = null
				for(var/candidate in A.choice_spells)
					if(!(candidate in A.mastery_choice_spells))
						choice_spell = candidate
						break
			A.grant_ordered(H.mind, choice_spell)

	H.mind.ensure_mage_basics()
	H.mind.check_learnspell()
	H.mind.rebuild_action_order()
	message_admins("[key_name_admin(usr)] [enable_mastery ? "enabled" : "disabled"] magic aspect mastery for [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] [enable_mastery ? "enabled" : "disabled"] magic aspect mastery for [key_name(H)].")
	return TRUE

/client/proc/ta_remove_miracles(mob/living/carbon/human/H)
	if(!ishuman(H) || !H.mind)
		to_chat(usr, span_warning("[H] has no miracles to remove."))
		return null

	var/list/candidates = list()
	if(H.devotion?.granted_spells)
		for(var/datum/spell as anything in H.devotion.granted_spells)
			if(spell && (spell in H.mind.spell_list))
				candidates |= spell

	var/list/miracle_paths = list()
	if(H.patron && islist(H.patron.miracles))
		for(var/spell_path in H.patron.miracles)
			miracle_paths |= spell_path
	if(istype(H.patron, /datum/patron/divine/abyssor))
		var/datum/patron/divine/abyssor/A = H.patron
		if(islist(A.paint_miracles))
			for(var/spell_path in A.paint_miracles)
				miracle_paths |= spell_path
	for(var/spell_path in miracle_paths)
		var/datum/spell = H.mind.get_spell(spell_path, TRUE)
		if(spell)
			candidates |= spell

	if(!length(candidates))
		to_chat(usr, span_warning("[H] has no current patron miracles to remove."))
		return null

	var/list/spell_lookup = list()
	var/list/labels = list()
	var/counter = 0
	for(var/datum/spell as anything in candidates)
		counter++
		var/spell_name = ("name" in spell.vars) ? spell.vars["name"] : "Unnamed miracle"
		var/label = "[spell_name] ([spell.type])"
		if(spell_lookup[label])
			label = "[label] #[counter]"
		spell_lookup[label] = spell
		labels += label

	var/list/selected = tgui_input_checkboxes(usr, "Select one or more miracles to remove.", "Remove Miracles", sortList(labels), 1, length(labels))
	if(!length(selected))
		return null

	var/list/removed = list()
	for(var/label in selected)
		var/datum/spell = spell_lookup[label]
		if(!spell)
			continue
		var/spell_name = ("name" in spell.vars) ? spell.vars["name"] : "[spell.type]"
		if(H.devotion?.granted_spells)
			H.devotion.granted_spells -= spell
		if(H.mind.RemoveSpell(spell))
			removed += spell_name
	H.mind.rebuild_action_order()
	if(length(removed))
		message_admins("[key_name_admin(usr)] removed miracles [english_list(removed)] from [ADMIN_LOOKUPFLW(H)].")
		log_admin("[key_name(usr)] removed miracles [english_list(removed)] from [key_name(H)].")
	return removed

/client/proc/ta_clear_devotion(mob/living/carbon/human/H)
	if(!ishuman(H))
		return FALSE
	if(alert(usr, "Remove all patron miracles and completely delete devotion from [H.real_name]?", "Remove Devotion", "Remove", "Cancel") != "Remove")
		return FALSE

	var/list/candidates = list()
	if(H.devotion?.granted_spells)
		for(var/datum/S as anything in H.devotion.granted_spells)
			if(S)
				candidates |= S

	var/list/patrons_to_check = list()
	if(H.patron)
		patrons_to_check |= H.patron
	if(H.devotion?.patron)
		patrons_to_check |= H.devotion.patron

	if(H.mind)
		for(var/datum/patron/P as anything in patrons_to_check)
			if(islist(P.miracles))
				for(var/spell_path in P.miracles)
					var/datum/found_spell = H.mind.get_spell(spell_path, TRUE)
					if(found_spell)
						candidates |= found_spell
			if(istype(P, /datum/patron/divine/abyssor))
				var/datum/patron/divine/abyssor/A = P
				if(islist(A.paint_miracles))
					for(var/spell_path in A.paint_miracles)
						var/datum/found_paint_spell = H.mind.get_spell(spell_path, TRUE)
						if(found_paint_spell)
							candidates |= found_paint_spell

	var/list/removed = list()
	if(H.mind)
		for(var/datum/S as anything in candidates)
			if(!S)
				continue
			var/spell_name = ("name" in S.vars) ? S.vars["name"] : "[S.type]"
			if(H.mind.RemoveSpell(S))
				removed += spell_name
		H.mind.rebuild_action_order()

	remove_verb(H, list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray))
	QDEL_NULL(H.devotion)

	var/removed_text = length(removed) ? " and miracles [english_list(removed)]" : ""
	message_admins("[key_name_admin(usr)] completely removed devotion[removed_text] from [ADMIN_LOOKUPFLW(H)].")
	log_admin("[key_name(usr)] completely removed devotion[removed_text] from [key_name(H)].")
	return TRUE

/client/proc/ta_get_miracle_tier_requirement(cleric_tier)
	switch(cleric_tier)
		if(CLERIC_T1)
			return CLERIC_REQ_1
		if(CLERIC_T2)
			return CLERIC_REQ_2
		if(CLERIC_T3)
			return CLERIC_REQ_3
		if(CLERIC_T4)
			return CLERIC_REQ_4
	return 0

/client/proc/ta_get_miracle_tier_name(cleric_tier)
	switch(cleric_tier)
		if(CLERIC_ORI)
			return "Orison"
		if(CLERIC_T0)
			return "T0"
		if(CLERIC_T1)
			return "T1"
		if(CLERIC_T2)
			return "T2"
		if(CLERIC_T3)
			return "T3"
		if(CLERIC_T4)
			return "T4"
	return "Unknown"

/client/proc/ta_get_patron_miracle_tier(datum/patron/P, spell_type)
	if(!P || !spell_type)
		return null

	var/required_tier = null
	if(islist(P.miracles) && !isnull(P.miracles[spell_type]))
		required_tier = P.miracles[spell_type]

	if(istype(P, /datum/patron/divine/abyssor))
		var/datum/patron/divine/abyssor/A = P
		if(islist(A.paint_miracles) && !isnull(A.paint_miracles[spell_type]))
			var/paint_tier = A.paint_miracles[spell_type]
			if(isnull(required_tier) || paint_tier < required_tier)
				required_tier = paint_tier

	return required_tier

/client/proc/ta_remove_miracles_above_tier(mob/living/carbon/human/H, datum/devotion/D, target_tier)
	var/list/removed = list()
	if(!H?.mind || !D?.patron)
		return removed

	for(var/datum/spell as anything in H.mind.spell_list.Copy())
		if(!spell)
			continue
		var/spell_tier = ta_get_patron_miracle_tier(D.patron, spell.type)
		if(isnull(spell_tier) || spell_tier <= target_tier)
			continue
		var/spell_name = ("name" in spell.vars) ? spell.vars["name"] : "[spell.type]"
		removed += spell_name
		if(D.granted_spells)
			D.granted_spells -= spell
		H.mind.RemoveSpell(spell)

	if(D.granted_spells)
		for(var/datum/spell as anything in D.granted_spells.Copy())
			if(!spell || QDELETED(spell))
				D.granted_spells -= spell
				continue
			var/granted_tier = ta_get_patron_miracle_tier(D.patron, spell.type)
			if(!isnull(granted_tier) && granted_tier > target_tier)
				D.granted_spells -= spell

	if(islist(D.patron.traits_tier))
		for(var/trait in D.patron.traits_tier)
			var/trait_tier = D.patron.traits_tier[trait]
			if(trait_tier > target_tier)
				REMOVE_TRAIT(H, trait, ROUNDSTART_TRAIT)

	return removed

/client/proc/ta_give_miracles_by_tier(mob/living/carbon/human/H)
	if(!ishuman(H))
		to_chat(usr, span_warning("Miracles can only be granted to humans."))
		return FALSE
	if(!H.patron)
		to_chat(usr, span_warning("[H] has no patron. Set a patron before granting miracles."))
		return FALSE
	if(!H.mind)
		H.mind_initialize()
	if(!H.mind)
		to_chat(usr, span_warning("Could not initialize a mind for [H]."))
		return FALSE

	var/list/tier_choices = list(
		"Orison only" = CLERIC_ORI,
		"Tier 0" = CLERIC_T0,
		"Tier 1" = CLERIC_T1,
		"Tier 2" = CLERIC_T2,
		"Tier 3" = CLERIC_T3,
		"Tier 4" = CLERIC_T4
	)
	var/selected_label = tgui_input_list(usr, "Set [H.patron.name] miracles to which tier? Higher-tier miracles will be removed when lowering the tier.", "Set Miracles by Tier", tier_choices)
	if(!selected_label)
		return FALSE
	var/selected_tier = tier_choices[selected_label]

	var/abyssor_path
	if(istype(H.patron, /datum/patron/divine/abyssor) && selected_tier >= CLERIC_T1)
		var/list/abyssor_paths = list(
			"Dreamer - standard miracles" = "dreamer",
			"Painter - support miracles" = "painter"
		)
		var/path_label = tgui_input_list(usr, "Choose which Abyssor miracle path to grant.", "Abyssor Path", abyssor_paths)
		if(!path_label)
			return FALSE
		abyssor_path = abyssor_paths[path_label]

	if(H.devotion && H.devotion.patron != H.patron)
		QDEL_NULL(H.devotion)
	if(!H.devotion)
		var/datum/devotion/created_devotion = new(H, H.patron)
		if(!created_devotion)
			return FALSE
	var/datum/devotion/D = H.devotion
	if(!D)
		to_chat(usr, span_warning("Could not initialize devotion for [H]."))
		return FALSE

	var/old_tier = D.level
	var/list/removed_miracles = ta_remove_miracles_above_tier(H, D, selected_tier)

	D.level = selected_tier
	var/required_progression = ta_get_miracle_tier_requirement(selected_tier)
	D.progression = required_progression
	if(selected_tier >= CLERIC_T1)
		D.max_devotion = max(D.max_devotion, required_progression)
	D.max_progression = max(D.max_progression, required_progression)

	if(istype(D.patron, /datum/patron/divine/abyssor) && selected_tier >= CLERIC_T1)
		var/datum/patron/divine/abyssor/A = D.patron
		if(abyssor_path == "painter")
			D.grant_paint_miracles(A, silent = TRUE)
			ADD_TRAIT(H, TRAIT_INK_AFFINITY, ROUNDSTART_TRAIT)
		else
			D.allocate_standard_miracles(silent = TRUE)
			if(!HAS_TRAIT(H, TRAIT_HERESIARCH))
				ADD_TRAIT(H, TRAIT_INK_AFFINITY, ROUNDSTART_TRAIT)
		D.path_choice_prompt = TRUE
		D.lock_down_progression()
	else
		D.try_add_spells(silent = TRUE)

	D.last_level = D.level
	D.update_devotion(D.max_devotion - D.devotion, 0, silent = TRUE)
	H.mind.rebuild_action_order()
	add_verb(H, list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray))

	var/tier_name = ta_get_miracle_tier_name(D.level)
	var/old_tier_name = ta_get_miracle_tier_name(old_tier)
	var/removed_text = length(removed_miracles) ? " Removed higher-tier miracles: [english_list(removed_miracles)]." : ""
	message_admins("[key_name_admin(usr)] set [H.patron.name] miracles from [old_tier_name] to [tier_name] for [ADMIN_LOOKUPFLW(H)].[removed_text]")
	log_admin("[key_name(usr)] set [H.patron.name] miracles from [old_tier_name] to [tier_name] for [key_name(H)].[removed_text]")
	return TRUE

/datum/admins/proc/ta_modify_traits_impl(datum/D)
	if(!D)
		return
	var/add_or_remove = input(usr, "Remove/Add?", "Trait Remove/Add") as null|anything in list("Add", "Remove")
	if(!add_or_remove)
		return
	var/list/available_traits = list()
	if(add_or_remove == "Add")
		for(var/key in GLOB.traits_by_type)
			if(istype(D, key))
				for(var/trait in GLOB.traits_by_type[key])
					available_traits |= trait
	else
		if(!D.status_traits || !length(D.status_traits))
			to_chat(usr, span_warning("[D] has no traits to remove."))
			return
		for(var/trait in D.status_traits)
			available_traits |= trait
	if(!length(available_traits))
		to_chat(usr, span_warning("No applicable traits found for [D]."))
		return
	var/list/chosen_traits = tgui_input_checkboxes(usr, "Select one or more traits to [LOWER_TEXT(add_or_remove)].", "Trait [add_or_remove]", sortList(available_traits), 1, length(available_traits))
	if(!length(chosen_traits))
		return
	if(add_or_remove == "Add")
		for(var/trait in chosen_traits)
			ADD_TRAIT(D, trait, TRAIT_GENERIC)
		message_admins("Admin [key_name_admin(usr)] added traits [english_list(chosen_traits)] to [D]!")
		log_admin("Admin [key_name(usr)] added traits [english_list(chosen_traits)] to [D]!")
		return
	var/remove_mode = input(usr, "How should the selected traits be removed?", "Trait Remove") as null|anything in list(
		"All non-roundstart sources",
		"Generic/admin source only",
		"Choose source for each trait"
	)
	if(!remove_mode)
		return
	var/list/removed_traits = list()
	for(var/trait in chosen_traits)
		var/source
		switch(remove_mode)
			if("All non-roundstart sources")
				source = null
			if("Generic/admin source only")
				if(!HAS_TRAIT_FROM(D, trait, TRAIT_GENERIC))
					continue
				source = TRAIT_GENERIC
			if("Choose source for each trait")
				var/list/sources = D.status_traits?[trait]
				if(!length(sources))
					continue
				source = input(usr, "Source to remove for [trait]", "Trait Remove") as null|anything in sortList(sources)
				if(!source)
					continue
		REMOVE_TRAIT(D, trait, source)
		removed_traits |= trait
	if(length(removed_traits))
		message_admins("Admin [key_name_admin(usr)] removed traits [english_list(removed_traits)] from [D]!")
		log_admin("Admin [key_name(usr)] removed traits [english_list(removed_traits)] from [D]!")

#undef TA_ADMIN_LOADOUT_TRAIT
#undef TA_ADMIN_LOADOUT_FILE
