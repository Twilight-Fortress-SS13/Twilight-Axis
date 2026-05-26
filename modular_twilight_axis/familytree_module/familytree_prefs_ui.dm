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
	var/know_your_fate = FALSE
	var/familytree_father_name = ""
	var/familytree_mother_name = ""
	var/familytree_father_species = ""
	var/familytree_mother_species = ""
	var/familytree_random_siblings = 0
	var/familytree_random_children = 0

/mob/living/carbon/human
	var/family_UI = TRUE
	var/mob/living/carbon/spouse_mob
	var/image/spouse_indicator
	var/setspouse
	var/gender_choice_pref = ANY_GENDER
	var/species_preference_mode = "ANY"
	var/list/preferred_species_types = list()
	var/preferred_species_anatomy = 0
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
	var/know_your_fate = FALSE
	var/familytree_father_name = ""
	var/familytree_mother_name = ""
	var/familytree_father_species = ""
	var/familytree_mother_species = ""
	var/familytree_random_siblings = 0
	var/familytree_random_children = 0
	var/tmp/list/familytree_blocked_ckeys = list()

/proc/familytree_pref_mask(pref)
	if(isnum(pref))
		var/runtime_mode = pref & FAMILYTREE_MODE_ALL
		if(runtime_mode)
			return runtime_mode
	switch(pref)
		if(FAMILY_PARTIAL)
			return FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_CREATE
		if(FAMILY_NEWLYWED)
			return FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_CREATE
		if(FAMILY_FULL)
			return FAMILYTREE_MODE_LEGACY_SPOUSE
	return FAMILYTREE_MODE_DISABLED

/proc/familytree_pref_enabled(pref)
	return !!familytree_pref_mask(pref)

/proc/familytree_pref_is_join(pref)
	return !!(familytree_pref_mask(pref) & FAMILYTREE_MODE_JOIN)

/proc/familytree_pref_is_join_only(pref)
	return familytree_pref_mask(pref) == FAMILYTREE_MODE_JOIN

/proc/familytree_pref_is_create(pref)
	return !!(familytree_pref_mask(pref) & FAMILYTREE_MODE_CREATE)

/proc/familytree_pref_is_legacy_spouse(pref)
	return !!(familytree_pref_mask(pref) & FAMILYTREE_MODE_LEGACY_SPOUSE)

/proc/familytree_pref_uses_relative_role(pref)
	var/mode = familytree_pref_mask(pref)
	return !!(mode & (FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_CREATE))

/proc/familytree_sanitize_pref(pref)
	var/mode = familytree_pref_mask(pref)
	if(mode & (FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_CREATE | FAMILYTREE_MODE_LEGACY_SPOUSE))
		return FAMILY_PARTIAL
	return FAMILY_NONE

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
	return "/character[slot]"

/datum/preferences/proc/familytree_module_save_key_map() as /list
	var/static/list/key_map
	if(!key_map)
		key_map = list(
			"family" = "family",
			"gender_choice_pref" = "gender_choice_pref",
			"setspouse" = "setspouse",
			"species_preference_mode" = "species_preference_mode",
			"preferred_species_types" = "preferred_species_types",
			"preferred_species_anatomy" = "preferred_species_anatomy",
			"polygamy_mode" = "polygamy_mode",
			"desired_relative_role" = "desired_relative_role",
			"allow_low_status_marriage" = "allow_low_status_marriage",
			"allow_relatives_in_family" = "allow_relatives_in_family",
			"know_your_fate" = "know_your_fate",
			"familytree_father_name" = "familytree_father_name",
			"familytree_mother_name" = "familytree_mother_name",
			"familytree_father_species" = "familytree_father_species",
			"familytree_mother_species" = "familytree_mother_species",
			"familytree_random_siblings" = "familytree_random_siblings",
			"familytree_random_children" = "familytree_random_children",
		)
	return key_map

/datum/preferences/proc/familytree_module_read_savefile(savefile/S)
	if(!S)
		return FALSE
	var/list/key_map = familytree_module_save_key_map()
	for(var/save_key in key_map)
		var/var_name = key_map[save_key]
		S[save_key] >> vars[var_name]
	return TRUE

/datum/preferences/proc/familytree_module_write_savefile(savefile/S)
	if(!S)
		return FALSE
	var/list/key_map = familytree_module_save_key_map()
	for(var/save_key in key_map)
		var/var_name = key_map[save_key]
		WRITE_FILE(S[save_key], vars[var_name])
	return TRUE

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
	know_your_fate = initial(know_your_fate)
	familytree_father_name = initial(familytree_father_name)
	familytree_mother_name = initial(familytree_mother_name)
	familytree_father_species = initial(familytree_father_species)
	familytree_mother_species = initial(familytree_mother_species)
	familytree_random_siblings = initial(familytree_random_siblings)
	familytree_random_children = initial(familytree_random_children)

/datum/preferences/proc/familytree_module_sanitize_character()
	family = sanitize_integer(family, FAMILY_NONE, FAMILY_NEWLYWED, FAMILY_NONE)
	family = familytree_sanitize_pref(family)
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
	if(!familytree_pref_uses_relative_role(family))
		desired_relative_role = RELATIVE_ANY
	allow_low_status_marriage = sanitize_integer(allow_low_status_marriage, 0, 1, 0)
	allow_relatives_in_family = sanitize_integer(allow_relatives_in_family, 0, 1, TRUE)
	know_your_fate = sanitize_integer(know_your_fate, 0, 1, 0)

	if(!istext(familytree_father_name))
		familytree_father_name = ""
	else
		familytree_father_name = copytext(familytree_father_name, 1, 65)
	if(!istext(familytree_mother_name))
		familytree_mother_name = ""
	else
		familytree_mother_name = copytext(familytree_mother_name, 1, 65)

	if(desired_relative_role == RELATIVE_CHILD && (length(familytree_father_name) || length(familytree_mother_name)))
		desired_relative_role = RELATIVE_ANY

	if(!istext(familytree_father_species) || !(familytree_father_species in valid_species))
		familytree_father_species = ""
	if(!istext(familytree_mother_species) || !(familytree_mother_species in valid_species))
		familytree_mother_species = ""

	familytree_random_siblings = sanitize_integer(text2num("[familytree_random_siblings]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
	familytree_random_children = sanitize_integer(text2num("[familytree_random_children]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
	if(!familytree_donator_relatives_enabled(parent?.ckey))
		familytree_random_siblings = 0
		familytree_random_children = 0

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
			familytree_module_load_character_from_savefile(S, slot, force)

	familytree_module_sanitize_character()
	familytree_module_loaded_slot = slot
	familytree_module_loaded_path = path
	return TRUE

/datum/preferences/proc/familytree_module_load_character_from_savefile(savefile/S, slot, force = FALSE)
	slot = familytree_module_get_slot(slot)
	if(!force && (familytree_module_loaded_path == path) && (familytree_module_loaded_slot == slot))
		return TRUE

	familytree_module_reset_character()

	if(S)
		S.cd = familytree_module_get_cd(slot)
		if(S["family"])
			familytree_module_read_savefile(S)

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
	familytree_module_write_savefile(S)

	familytree_module_loaded_slot = slot
	familytree_module_loaded_path = path
	return TRUE

/datum/preferences/proc/familytree_module_save_character_to_savefile(savefile/S, slot)
	if(!S)
		return FALSE

	slot = familytree_module_get_slot(slot)
	familytree_module_sanitize_character()

	S.cd = familytree_module_get_cd(slot)
	familytree_module_write_savefile(S)

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

/datum/familytree_display_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	return FALSE

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
		"allowRelativesInFamily" = P.allow_relatives_in_family,
		"knowYourFate" = P.know_your_fate,
		"fatherName" = istext(P.familytree_father_name) ? P.familytree_father_name : "",
		"motherName" = istext(P.familytree_mother_name) ? P.familytree_mother_name : "",
		"fatherSpecies" = istext(P.familytree_father_species) ? P.familytree_father_species : "",
		"motherSpecies" = istext(P.familytree_mother_species) ? P.familytree_mother_species : "",
		"randomSiblings" = P.familytree_random_siblings,
		"randomChildren" = P.familytree_random_children,
		"isDonator" = familytree_donator_relatives_enabled(user?.ckey) ? 1 : 0,
		"maxRandomRelatives" = FAMILYTREE_MAX_RANDOM_RELATIVES,
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
			var/old_setspouse = null
			var/mob/living/carbon/human/H = null
			if(ishuman(user))
				H = user
				old_setspouse = SSfamilytree.familytree_get_target_name(H)

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
			P.know_your_fate = text2num("[params["knowYourFate"]]")
			P.familytree_father_name = istext(params["fatherName"]) ? params["fatherName"] : ""
			P.familytree_mother_name = istext(params["motherName"]) ? params["motherName"] : ""
			P.familytree_father_species = istext(params["fatherSpecies"]) ? params["fatherSpecies"] : ""
			P.familytree_mother_species = istext(params["motherSpecies"]) ? params["motherSpecies"] : ""
			P.familytree_random_siblings = text2num("[params["randomSiblings"]]")
			P.familytree_random_children = text2num("[params["randomChildren"]]")

			P.familytree_module_sanitize_character()
			P.familytree_module_save_character()
			if(H)
				SSfamilytree.load_familytree_runtime_preferences(H, P)
				SSfamilytree.on_familytree_target_preference_changed(H, old_setspouse)

			SStgui.update_uis(src)
			return TRUE

	return FALSE

/datum/family_options/proc/_family_to_ui(val)
	if(familytree_pref_enabled(val))
		return "member"
	return "none"

/datum/family_options/proc/_gender_to_ui(val)
	switch(val)
		if(SAME_GENDER) return "same"
		if(DIFFERENT_GENDER) return "opposite"
	return "any"

/datum/family_options/proc/_ui_to_family(val)
	switch(val)
		if("member") return FAMILY_PARTIAL
		if("couple") return FAMILY_PARTIAL
		if("parent") return FAMILY_PARTIAL
	return FAMILY_NONE

/datum/family_options/proc/_ui_to_gender(val)
	switch(val)
		if("same") return SAME_GENDER
		if("opposite") return DIFFERENT_GENDER
	return ANY_GENDER
