/datum/preferences
	var/setspouse = ""
	var/datum/family_options/family_options
	var/gender_choice_pref = ANY_GENDER
	var/species_preference_mode = "ANY"
	var/list/preferred_species_types = list()
	var/preferred_species_anatomy = 0
	var/desired_relative_role = RELATIVE_ANY
	var/allow_low_status_marriage = FALSE
	var/tmp/familytree_module_loaded_slot
	var/tmp/familytree_module_loaded_path
	var/allow_relatives_in_family = TRUE

/mob/living/carbon/human
	var/family_UI = TRUE
	var/mob/living/carbon/spouse_mob
	var/image/spouse_indicator
	var/setspouse
	var/gender_choice_pref = ANY_GENDER
	var/familytree_pref = FAMILY_NONE
	var/datum/heritage/family_datum
	var/datum/family_member/family_member_datum
	var/desired_relative_role = RELATIVE_ANY
	var/allow_low_status_marriage = FALSE
	var/tmp/familytree_module_signal_bound = FALSE
	var/tmp/familytree_assignment_scheduled = FALSE
	var/tmp/familytree_confirmation_pending = FALSE
	var/tmp/familytree_opted_out = FALSE
	var/tmp/familytree_setspouse_timeout_offered = FALSE
	var/tmp/familytree_setspouse_retries = 0
	var/allow_relatives_in_family = TRUE

/proc/familytree_module_get_selectable_species() as /list
	if(!GLOB.roundstart_races.len)
		generate_selectable_species()

	var/list/species_names = list()
	for(var/species_name in GLOB.roundstart_races)
		if(!istext(species_name))
			continue
		var/species_type = GLOB.species_list[species_name]
		if(!ispath(species_type, /datum/species))
			continue
		species_names += species_name

	if(!species_names.len)
		species_names += "Humen"

	return species_names

/proc/familytree_module_get_selectable_species_types() as /list
	var/list/species_types = list()
	for(var/species_name in familytree_module_get_selectable_species())
		var/species_type = GLOB.species_list[species_name]
		if(!ispath(species_type, /datum/species))
			continue
		if(species_type in species_types)
			continue
		species_types += species_type

	if(!species_types.len)
		species_types += /datum/species/human/northern

	return species_types

/datum/preferences/proc/familytree_module_get_slot(slot)
	if(!slot)
		slot = loaded_slot || default_slot
	return sanitize_integer(slot, 1, max_save_slots, initial(default_slot))

/datum/preferences/proc/familytree_module_get_cd(slot)
	slot = familytree_module_get_slot(slot)
	return "/familytree_module/character[slot]"

/datum/preferences/proc/familytree_module_reset_character()
	family = initial(family)
	setspouse = initial(setspouse)
	gender_choice_pref = initial(gender_choice_pref)
	species_preference_mode = initial(species_preference_mode)
	preferred_species_types = list()
	preferred_species_anatomy = initial(preferred_species_anatomy)
	polygamy_mode = initial(polygamy_mode)
	desired_relative_role = initial(desired_relative_role)
	allow_low_status_marriage = initial(allow_low_status_marriage)
	allow_relatives_in_family = initial(allow_relatives_in_family)

/datum/preferences/proc/familytree_module_sanitize_character()
	family = sanitize_integer(family, FAMILY_NONE, FAMILY_NEWLYWED, FAMILY_NONE)
	if(family == FAMILY_FULL)
		family = FAMILY_PARTIAL
	gender_choice_pref = sanitize_integer(gender_choice_pref, ANY_GENDER, DIFFERENT_GENDER, ANY_GENDER)
	species_preference_mode = sanitize_text(species_preference_mode, "ANY")

	if(!(species_preference_mode in list("ANY", "SAME_TYPE", "SPECIFIC_TYPE")))
		species_preference_mode = "ANY"

	var/list/valid_species = familytree_module_get_selectable_species()
	var/list/sanitized_species = list()

	if(islist(preferred_species_types))
		for(var/entry in preferred_species_types)
			if(!istext(entry))
				continue
			if(!(entry in valid_species))
				continue
			if(entry in sanitized_species)
				continue
			sanitized_species += entry

	preferred_species_types = sanitized_species

	if(species_preference_mode == "SPECIFIC_TYPE")
		if(!preferred_species_types.len)
			species_preference_mode = "ANY"
	else
		preferred_species_types = list()

	preferred_species_anatomy = text2num("[preferred_species_anatomy]")
	if(!(preferred_species_anatomy in list(0, 1, 2)))
		preferred_species_anatomy = 0

	if(!istext(setspouse))
		setspouse = ""
	else
		setspouse = copytext(setspouse, 1, 65)

	polygamy_mode = sanitize_integer(polygamy_mode, POLYGAMY_DISABLED, POLYGAMY_ALLOW_BOTH, POLYGAMY_DISABLED)
	desired_relative_role = sanitize_integer(desired_relative_role, RELATIVE_ANY, RELATIVE_SPOUSE, RELATIVE_ANY)
	if(!(family in list(FAMILY_PARTIAL, FAMILY_NEWLYWED)))
		desired_relative_role = RELATIVE_ANY
	allow_low_status_marriage = sanitize_integer(allow_low_status_marriage, 0, 1, 0)
	allow_relatives_in_family = sanitize_integer(allow_relatives_in_family, 0, 1, TRUE)

/datum/preferences/proc/familytree_module_has_enabled_customizer_entry(entry_type)
	validate_customizer_entries()
	var/datum/customizer_entry/entry = get_customizer_entry_of_type(entry_type)
	return entry && !entry.disabled

/datum/preferences/proc/familytree_module_has_penis()
	return familytree_module_has_enabled_customizer_entry(/datum/customizer_entry/organ/penis)

/datum/preferences/proc/familytree_module_has_vagina()
	return familytree_module_has_enabled_customizer_entry(/datum/customizer_entry/organ/vagina)

/datum/preferences/proc/familytree_module_load_character(slot, force = FALSE)
	slot = familytree_module_get_slot(slot)
	if(!force && (familytree_module_loaded_path == path) && (familytree_module_loaded_slot == slot))
		return TRUE

	familytree_module_reset_character()

	if(path && fexists(path))
		var/savefile/S = new /savefile(path)
		if(S)
			S.cd = familytree_module_get_cd(slot)
			S["family"] >> family
			S["gender_choice_pref"] >> gender_choice_pref
			S["setspouse"] >> setspouse
			S["species_preference_mode"] >> species_preference_mode
			S["preferred_species_types"] >> preferred_species_types
			S["preferred_species_anatomy"] >> preferred_species_anatomy
			S["polygamy_mode"] >> polygamy_mode
			S["desired_relative_role"] >> desired_relative_role
			S["allow_low_status_marriage"] >> allow_low_status_marriage
			S["allow_relatives_in_family"] >> allow_relatives_in_family

	familytree_module_sanitize_character()
	familytree_module_loaded_slot = slot
	familytree_module_loaded_path = path
	return TRUE

/datum/preferences/proc/familytree_module_save_character(slot)
	if(!path)
		return FALSE

	slot = familytree_module_get_slot(slot)
	familytree_module_sanitize_character()

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE

	S.cd = familytree_module_get_cd(slot)
	WRITE_FILE(S["family"], family)
	WRITE_FILE(S["gender_choice_pref"], gender_choice_pref)
	WRITE_FILE(S["setspouse"], setspouse)
	WRITE_FILE(S["species_preference_mode"], species_preference_mode)
	WRITE_FILE(S["preferred_species_types"], preferred_species_types)
	WRITE_FILE(S["preferred_species_anatomy"], preferred_species_anatomy)
	WRITE_FILE(S["polygamy_mode"], polygamy_mode)
	WRITE_FILE(S["desired_relative_role"], desired_relative_role)
	WRITE_FILE(S["allow_low_status_marriage"], allow_low_status_marriage)
	WRITE_FILE(S["allow_relatives_in_family"], allow_relatives_in_family)

	familytree_module_loaded_slot = slot
	familytree_module_loaded_path = path
	return TRUE

/datum/familytree_display_panel
	var/mob/living/carbon/human/viewer
	var/panel_title = "Family"
	var/panel_subtitle = ""
	var/empty_message = "Nothing to show."
	var/list/sections = list()
	var/list/tree_data = list()

/datum/familytree_display_panel/New(mob/living/carbon/human/new_viewer, panel_title = "Family", panel_subtitle = "", panel_empty_message = "Nothing to show.")
	. = ..()
	viewer = new_viewer
	src.panel_title = panel_title
	src.panel_subtitle = panel_subtitle
	empty_message = panel_empty_message
	sections = list()
	tree_data = list()

/datum/familytree_display_panel/Destroy(force)
	viewer = null
	sections = null
	tree_data = null
	return ..()

/datum/familytree_display_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/familytree_display_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FamilyDisplayPanel")
		ui.open()

	return TRUE

/datum/familytree_display_panel/ui_data(mob/user)
	if(user != viewer)
		return list(
			"title" = panel_title,
			"subtitle" = panel_subtitle,
			"emptyMessage" = empty_message,
			"sections" = list(),
			"tree" = list(),
		)

	return list(
		"title" = panel_title,
		"subtitle" = panel_subtitle,
		"emptyMessage" = empty_message,
		"sections" = sections,
		"tree" = tree_data,
	)

/datum/familytree_display_panel/ui_close()
	QDEL_NULL(src)

/datum/familytree_display_panel/proc/add_section(section_title, list/entries)
	if(!entries?.len)
		return

	sections += list(list(
		"title" = section_title,
		"entries" = entries,
	))

/datum/familytree_display_panel/proc/set_tree_data(list/new_tree_data)
	tree_data = new_tree_data ? new_tree_data : list()

/datum/family_options

/datum/family_options/ui_state(mob/user)
	return GLOB.always_state

/datum/family_options/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FamilySettingsPanel")
		ui.open()
	return TRUE

/datum/family_options/ui_data(mob/user)
	var/list/data = list()

	var/datum/preferences/P = user?.client?.prefs
	if(!P)
		data["familySettings"] = list()
		data["availableSpecies"] = list()
		return data

	P.familytree_module_load_character()

	data["familySettings"] = list(
		"familyType" = _family_to_ui(P.family),
		"genderPreference" = _gender_to_ui(P.gender_choice_pref),
		"speciesPreferenceMode" = P.species_preference_mode ? P.species_preference_mode : "ANY",
		"preferredSpeciesTypes" = islist(P.preferred_species_types) ? P.preferred_species_types.Copy() : list(),
		"preferredSpeciesAnatomy" = P.preferred_species_anatomy,
		"favoriteName" = istext(P.setspouse) ? P.setspouse : "",
		"age" = P.age,
		"polygamyMode" = P.polygamy_mode,
		"desiredRelativeRole" = P.desired_relative_role,
		"allowLowStatusMarriage" = P.allow_low_status_marriage,
		"allowRelativesInFamily" = P.allow_relatives_in_family
	)

	var/list/species_names = list()
	for(var/species_name in familytree_module_get_selectable_species())
		species_names += species_name
	data["availableSpecies"] = species_names

	return data

/datum/family_options/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui?.user
	var/datum/preferences/P = user?.client?.prefs
	if(!P)
		return FALSE

	switch(action)
		if("save")
			var/new_family = _ui_to_family(params["familyType"])

			P.family = new_family
			P.gender_choice_pref = _ui_to_gender(params["genderPreference"])
			P.species_preference_mode = istext(params["speciesPreferenceMode"]) ? params["speciesPreferenceMode"] : "ANY"

			var/list/new_species_types = list()
			if(islist(params["preferredSpeciesTypes"]))
				for(var/entry in params["preferredSpeciesTypes"])
					if(istext(entry))
						new_species_types += entry

			P.preferred_species_types = new_species_types
			P.preferred_species_anatomy = text2num("[params["preferredSpeciesAnatomy"]]")
			P.setspouse = istext(params["favoriteName"]) ? params["favoriteName"] : ""
			P.polygamy_mode = text2num("[params["polygamyMode"]]")
			P.desired_relative_role = text2num("[params["desiredRelativeRole"]]")
			P.allow_low_status_marriage = text2num("[params["allowLowStatusMarriage"]]")
			P.allow_relatives_in_family = text2num("[params["allowRelativesInFamily"]]")

			P.familytree_module_sanitize_character()
			P.familytree_module_save_character()

			SStgui.update_uis(src)
			return TRUE

	return FALSE

/datum/family_options/proc/_family_to_ui(val)
	switch(val)
		if(FAMILY_PARTIAL) return "member"
		if(FAMILY_NEWLYWED) return "couple"
		if(FAMILY_FULL) return "member"
	return "none"

/datum/family_options/proc/_gender_to_ui(val)
	switch(val)
		if(SAME_GENDER) return "same"
		if(DIFFERENT_GENDER) return "opposite"
	return "any"

/datum/family_options/proc/_ui_to_family(val)
	switch(val)
		if("member") return FAMILY_PARTIAL
		if("couple") return FAMILY_NEWLYWED
		if("parent") return FAMILY_PARTIAL
	return FAMILY_NONE

/datum/family_options/proc/_ui_to_gender(val)
	switch(val)
		if("same") return SAME_GENDER
		if("opposite") return DIFFERENT_GENDER
	return ANY_GENDER
