/datum/familytree_prefs
	var/owner_ckey
	var/family_pref = FAMILY_NONE
	var/gender_choice_pref
	var/setspouse
	var/species_preference_mode
	var/list/preferred_species_types
	var/preferred_species_anatomy
	var/polygamy_mode
	var/desired_relative_role = RELATIVE_ANY
	var/allow_low_status_marriage = FALSE
	var/allow_relatives_in_family = FALSE
	var/know_your_fate = FALSE
	var/father_name = ""
	var/mother_name = ""
	var/father_species = ""
	var/mother_species = ""
	var/random_siblings = 0
	var/random_children = 0

/datum/familytree_prefs/proc/capture(datum/preferences/P, ckey_owner)
	if(!P)
		return FALSE
	P.familytree_module_load_character()
	owner_ckey = ckey_owner
	family_pref = P.family
	gender_choice_pref = P.gender_choice_pref
	setspouse = P.setspouse
	species_preference_mode = P.species_preference_mode
	preferred_species_types = islist(P.preferred_species_types) ? P.preferred_species_types.Copy() : list()
	preferred_species_anatomy = P.preferred_species_anatomy
	polygamy_mode = P.polygamy_mode
	desired_relative_role = P.desired_relative_role
	allow_low_status_marriage = P.allow_low_status_marriage
	allow_relatives_in_family = P.allow_relatives_in_family
	know_your_fate = P.know_your_fate
	father_name = istext(P.familytree_father_name) ? P.familytree_father_name : ""
	mother_name = istext(P.familytree_mother_name) ? P.familytree_mother_name : ""
	father_species = istext(P.familytree_father_species) ? P.familytree_father_species : ""
	mother_species = istext(P.familytree_mother_species) ? P.familytree_mother_species : ""
	if(familytree_donator_relatives_enabled(owner_ckey))
		random_siblings = sanitize_integer(text2num("[P.familytree_random_siblings]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
		random_children = sanitize_integer(text2num("[P.familytree_random_children]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
	else
		random_siblings = 0
		random_children = 0
	return TRUE

/datum/familytree_prefs/proc/apply_to(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return FALSE
	H.familytree_pref = family_pref
	H.gender_choice_pref = gender_choice_pref
	H.setspouse = setspouse
	H.species_preference_mode = species_preference_mode
	H.preferred_species_types = islist(preferred_species_types) ? preferred_species_types.Copy() : list()
	H.preferred_species_anatomy = preferred_species_anatomy
	H.polygamy_mode = polygamy_mode
	H.desired_relative_role = desired_relative_role
	H.allow_low_status_marriage = allow_low_status_marriage
	H.allow_relatives_in_family = allow_relatives_in_family
	H.know_your_fate = know_your_fate
	H.familytree_father_name = father_name
	H.familytree_mother_name = mother_name
	H.familytree_father_species = father_species
	H.familytree_mother_species = mother_species
	H.familytree_random_siblings = random_siblings
	H.familytree_random_children = random_children
	return TRUE

/proc/familytree_synthetic_prefs_allowed(ckey_owner)
	if(!ckey_owner)
		return FALSE
#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
	if(findtext(ckey_owner, "FTTEST") == 1)
		return TRUE
#endif
	return findtext(ckey_owner, "FTDEBUG") == 1

/datum/familytree_prefs/proc/capture_from_mob(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return FALSE
	owner_ckey = H.ckey
	family_pref = H.familytree_pref
	gender_choice_pref = H.gender_choice_pref
	setspouse = H.setspouse
	species_preference_mode = H.species_preference_mode
	preferred_species_types = islist(H.preferred_species_types) ? H.preferred_species_types.Copy() : list()
	preferred_species_anatomy = H.preferred_species_anatomy
	polygamy_mode = H.polygamy_mode
	desired_relative_role = H.desired_relative_role
	allow_low_status_marriage = H.allow_low_status_marriage
	allow_relatives_in_family = H.allow_relatives_in_family
	know_your_fate = H.know_your_fate
	return TRUE

/datum/familytree_prefs/proc/clear_setspouse()
	setspouse = ""

/datum/controller/subsystem/familytree/proc/familytree_get_round_prefs(mob/living/carbon/human/H, create = FALSE)
	if(!H || QDELETED(H))
		return null
	if(H.familytree_round_prefs)
		return H.familytree_round_prefs
	if(!H.ckey)
		return null
	var/datum/familytree_prefs/stored = familytree_round_prefs_by_ckey[H.ckey]
	if(!stored && create)
		var/datum/preferences/P = H.client?.prefs
		if(!P)
			if(!familytree_synthetic_prefs_allowed(H.ckey))
				return null
			stored = new /datum/familytree_prefs
			stored.capture_from_mob(H)
			familytree_round_prefs_by_ckey[H.ckey] = stored
			H.familytree_round_prefs = stored
			return stored
		stored = new /datum/familytree_prefs
		if(!stored.capture(P, H.ckey))
			return null
		familytree_round_prefs_by_ckey[H.ckey] = stored
		ftlog("ROUND_PREFS: locked for [H.real_name] ([H.ckey]) pref=[stored.family_pref] role=[stored.desired_relative_role] target='[stored.setspouse]'", FTLOG_INFO)
	if(stored)
		H.familytree_round_prefs = stored
	return stored

/datum/controller/subsystem/familytree/proc/familytree_has_round_prefs(mob/living/carbon/human/H)
	return !isnull(familytree_get_round_prefs(H, FALSE))
