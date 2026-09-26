/datum/preferences
	var/list/erp_custom_actions = list()
	var/list/erp_kink_prefs = list()
	var/list/erp_organ_prefs = list()

/datum/preferences/proc/apply_erp_kinks_to_mob(mob/living/carbon/human/H)
	if(!H || !islist(erp_kink_prefs) || !erp_kink_prefs.len)
		return

	var/datum/component/kinks/K = H.GetComponent(/datum/component/kinks)
	if(!K)
		K = H.AddComponent(/datum/component/kinks)

	if(!islist(K.prefs_by_type))
		K.prefs_by_type = list()

	for(var/key in erp_kink_prefs)
		var/path = text2path(key)
		if(!ispath(path, /datum/kink))
			continue
		K.prefs_by_type[path] = clamp(round(erp_kink_prefs[key]), -1, 1)

/datum/preferences/proc/capture_erp_kinks_from_mob(mob/living/carbon/human/H)
	if(!H)
		return

	var/datum/component/kinks/K = H.GetComponent(/datum/component/kinks)
	if(!K || !islist(K.prefs_by_type))
		return

	if(!islist(erp_kink_prefs))
		erp_kink_prefs = list()
	else
		erp_kink_prefs.Cut()

	for(var/typepath in K.prefs_by_type)
		if(!ispath(typepath, /datum/kink))
			continue
		erp_kink_prefs["[typepath]"] = clamp(round(K.prefs_by_type[typepath]), -1, 1)

/datum/preferences/proc/sanitize_erp_kink_prefs()
	if(!islist(erp_kink_prefs))
		erp_kink_prefs = list()
		return

	for(var/key in erp_kink_prefs)
		if(!istext(key))
			erp_kink_prefs -= key
			continue

		var/path = text2path(key)
		if(!ispath(path, /datum/kink))
			erp_kink_prefs -= key
			continue

		var/v = erp_kink_prefs[key]
		if(!isnum(v))
			erp_kink_prefs[key] = 0
			continue

		erp_kink_prefs[key] = clamp(round(v), -1, 1)

/datum/preferences/proc/sanitize_erp_organ_prefs()
	if(!islist(erp_organ_prefs))
		erp_organ_prefs = list()
		return

	for(var/organ_key in erp_organ_prefs)
		var/list/prefs = erp_organ_prefs[organ_key]

		if(!istext(organ_key) || !islist(prefs))
			erp_organ_prefs -= organ_key
			continue

		if("sensitivity" in prefs)
			if(!isnum(prefs["sensitivity"]))
				prefs["sensitivity"] = 1
			else
				prefs["sensitivity"] = clamp(prefs["sensitivity"], 0, SEX_SENSITIVITY_MAX)

		if("overflow" in prefs)
			prefs["overflow"] = !!prefs["overflow"]

/datum/preferences/proc/sanitize_erp_custom_actions()
	if(!islist(erp_custom_actions))
		erp_custom_actions = list()
		return

	for(var/id in erp_custom_actions)
		var/list/data = erp_custom_actions[id]

		if(!istext(id) || !islist(data))
			erp_custom_actions -= id
			continue

		if(data["id"] != id)
			data["id"] = id

		if(!istext(data["name"]))
			data["name"] = "Custom action"

/datum/preferences/proc/apply_customizer_organs_to_mob(mob/living/carbon/human/H)
	if(!H || !pref_species)
		return

	var/list/organ_dna_by_slot = get_organ_dna_list()
	if(!length(organ_dna_by_slot))
		return

	for(var/slot as anything in organ_dna_by_slot)
		var/obj/item/organ/existing = H.getorganslot(slot)
		if(existing)
			continue

		var/datum/organ_dna/dna = organ_dna_by_slot[slot]
		if(!dna)
			continue

		var/obj/item/organ/new_organ = dna.create_organ(H)
		if(!new_organ)
			continue

		new_organ.Insert(H)
		customize_organ(new_organ)

	apply_customizers_to_character(H, src)
