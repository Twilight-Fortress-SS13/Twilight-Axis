/client/proc/familytree_module_open_preferences(mob/user = mob)
	if(!prefs)
		return FALSE

	if(!user)
		user = mob
	if(!user)
		return FALSE

	prefs.familytree_module_load_character()
	if(!prefs.family_options)
		prefs.family_options = new /datum/family_options
	prefs.family_options.ui_interact(user)
	return TRUE

/mob/living/carbon/human/proc/MarryTo(mob/living/carbon/human/spouse)
	if(!ishuman(spouse))
		return null

	spouse_mob = spouse
	spouse.spouse_mob = src

	var/datum/heritage/primary_family = null
	var/datum/family_member/primary_member = null
	var/datum/family_member/secondary_member = null

	if(family_datum && !spouse.family_datum)
		primary_family = family_datum
		primary_member = family_member_datum
		secondary_member = primary_family.CreateFamilyMember(spouse)

	else if(!family_datum && spouse.family_datum)
		primary_family = spouse.family_datum
		primary_member = spouse.family_member_datum
		secondary_member = primary_family.CreateFamilyMember(src)

	else if(family_datum && spouse.family_datum)
		primary_family = family_datum
		primary_member = family_member_datum
		secondary_member = spouse.family_member_datum
		if(mind && spouse.mind)
			mind.i_know_person(spouse)
			spouse.mind.i_know_person(src)

	else
		var/new_family_name = null
		if(gender == MALE)
			new_family_name = family_datum?.SurnameFormatting(src)
		else if(spouse.gender == MALE)
			new_family_name = family_datum?.SurnameFormatting(spouse)

		primary_family = new /datum/heritage(src, new_family_name)
		primary_member = primary_family.founder
		secondary_member = primary_family.CreateFamilyMember(spouse)
		if(primary_family.founder && !primary_family.house_leader)
			primary_family.house_leader = primary_family.founder

	if(primary_member && secondary_member && primary_family)
		primary_family.MarryMembers(primary_member, secondary_member)

	if(primary_family)
		SSfamilytree.register_family(primary_family)

	if(SSfamilytree.xylix_roulette_active)
		var/xylix_msg = span_danger("<font size='2'>Ксайликс пошутил над вашей судьбой, подтасовав карты.</font>")
		to_chat(src, xylix_msg)
		to_chat(spouse, xylix_msg)

	return primary_family

/mob/living/carbon/human/proc/ReturnRelation(mob/living/carbon/human/stranger)
	return family_datum.ReturnRelation(src, stranger)

/mob/living/carbon/human/proc/familytree_get_parental_style()
	var/has_penis = getorganslot(ORGAN_SLOT_PENIS) != null
	var/has_vagina = getorganslot(ORGAN_SLOT_VAGINA) != null

	if(has_penis && !has_vagina)
		return "masculine"
	if(has_vagina && !has_penis)
		return "feminine"
	if(has_penis && has_vagina)
		if(titles_pref == TITLES_M)
			return "masculine"
		if(titles_pref == TITLES_F)
			return "feminine"

	if(titles_pref == TITLES_M)
		return "masculine"
	if(titles_pref == TITLES_F)
		return "feminine"

	switch(pronouns)
		if(HE_HIM)
			return "masculine"
		if(SHE_HER)
			return "feminine"
		if(THEY_THEM)
			return "neutral"
		if(IT_ITS)
			return "neuter"

	switch(gender)
		if(MALE)
			return "masculine"
		if(FEMALE)
			return "feminine"

	return "neutral"

/datum/mind/proc/familytree_get_known_family_relation(mob/living/carbon/human/viewer, mob/living/carbon/human/known_person)
	if(!viewer || !known_person || !viewer.family_datum || viewer.family_datum != known_person.family_datum)
		return null

	var/datum/family_member/viewer_member = viewer.family_member_datum
	var/datum/family_member/known_member = known_person.family_member_datum
	if(!viewer_member || !known_member)
		return null

	return SSfamilytree.get_cached_relation(viewer.family_datum, viewer_member, known_member)

/datum/mind/proc/familytree_display_known_families(mob/living/carbon/human/user)
	if(!user)
		return

	if(!known_people || !known_people.len)
		to_chat(user, span_warning("Я не знаю ни одной семьи."))
		return

	var/list/house_entries = list()
	var/list/house_names = list()
	var/list/added_names = list()

	for(var/datum/mind/M as anything in SSticker.minds)
		if(!ishuman(M.current))
			continue

		var/mob/living/carbon/human/H = M.current
		if(!H.family_datum || !known_people[H.real_name] || added_names[H.real_name])
			continue

		added_names[H.real_name] = TRUE

		var/house_name = trim("[H.family_datum.housename]")
		if(!house_name)
			house_name = "Nameless"

		var/house_key = uppertext(house_name)
		if(!house_entries[house_key])
			house_entries[house_key] = list()
			house_names += house_key
		var/list/entries = house_entries[house_key]

		var/list/person_info = known_people[H.real_name]
		var/list/details = list()
		var/relation = familytree_get_known_family_relation(user, H)
		if(relation)
			details += capitalize(relation)

		var/fjob = person_info["FJOB"]
		if(fjob)
			details += fjob

		var/fgender = person_info["FGENDER"]
		if(fgender)
			details += capitalize(fgender)

		var/fspecies = person_info["FSPECIES"]
		if(fspecies)
			details += fspecies

		var/fage = person_info["FAGE"]
		if(fage)
			details += "[fage]"

		var/fheresy = person_info["FHERESY"]
		entries += list(list(
			"name" = H.real_name,
			"label" = fheresy,
			"details" = details,
		))

	if(!house_names.len)
		to_chat(user, span_warning("Я не знаю ни одной семьи."))
		return

	house_names = sortList(house_names)

	var/datum/familytree_display_panel/panel = new(
		user,
		"Known Families of [name || user.real_name]",
		"Shows currently present known people with active family data.",
		"I don't know any families.",
	)

	for(var/house_key in house_names)
		panel.add_section("THE [house_key] HOUSE", house_entries[house_key])

	panel.ui_interact(user)

/mob/living/carbon/human/verb/known_families()
	set name = "Known Families"
	set category = "IC"

	if(!mind)
		to_chat(src, span_warning("Я не знаю ни одной семьи."))
		return

	mind.familytree_display_known_families(src)

/mob/living/carbon/human/get_villain_text(mob/examiner)
	. = ..()

	if(!ishuman(examiner) || !family_datum)
		return

	var/mob/living/carbon/human/H = examiner
	if(family_datum != H.family_datum)
		return

	var/family_text = ReturnRelation(H)
	if(!family_text)
		return

	if(.)
		. += "<br>"
	. += family_text

/mob/living/carbon/human/proc/MixDNA(mob/living/carbon/human/parent1, mob/living/carbon/human/parent2, override = FALSE)
	// Legacy compatibility hook. Family assignment must not mutate a live character's body or appearance.
	return TRUE

/mob/living/carbon/human/proc/familytree_build_bond_display_entry(mob/living/carbon/human/bonded_person, relation_text = "spouse")
	if(!bonded_person || QDELETED(bonded_person))
		return null

	var/list/details = list()
	if(bonded_person.dna?.species?.name)
		details += bonded_person.dna.species.name

	var/role = bonded_person.mind?.assigned_role
	if(!role)
		role = bonded_person.job
	var/title = role
	if(istype(role, /datum/job))
		var/datum/job/J = role
		title = J.get_informed_title(bonded_person)
	if(title)
		details += "[title]"

	return list(
		"name" = bonded_person.real_name,
		"label" = uppertext(relation_text),
		"details" = details,
		"accentColor" = "#FF69B4",
	)

/mob/living/carbon/human/proc/familytree_build_bond_display_entries()
	var/list/entries = list()
	var/list/seen = list()

	if(family_member_datum)
		for(var/datum/family_member/spouse_member as anything in family_member_datum.get_spouse_members())
			var/mob/living/carbon/human/spouse = spouse_member?.person
			if(!spouse || QDELETED(spouse) || seen[spouse])
				continue
			var/list/spouse_entry = familytree_build_bond_display_entry(spouse, spouse_member.GetSpouseTerm())
			if(spouse_entry)
				entries += list(spouse_entry)
				seen[spouse] = TRUE

	if(ishuman(spouse_mob))
		var/mob/living/carbon/human/legacy_spouse = spouse_mob
		if(!QDELETED(legacy_spouse) && !seen[legacy_spouse])
			var/list/legacy_entry = familytree_build_bond_display_entry(legacy_spouse, "spouse")
			if(legacy_entry)
				entries += list(legacy_entry)
	else if(spouse_mob && QDELETED(spouse_mob))
		spouse_mob = null

	return entries

/mob/living/carbon/human/proc/familytree_open_family_panel(panel_title = "My Family")
	var/panel_subtitle = family_datum ? family_datum.GetDisplayHouseTitle() : ""
	var/panel_empty_message = family_datum ? "No family members found." : "You're not part of any notable family."
	var/datum/familytree_display_panel/panel = new(
		src,
		panel_title,
		panel_subtitle,
		panel_empty_message,
	)

	var/list/bond_entries = familytree_build_bond_display_entries()
	if(bond_entries.len)
		panel.add_section("Current Bonds", bond_entries)

	if(family_datum)
		panel.set_tree_data(SSfamilytree.get_display_tree_for(family_datum, src))

	panel.ui_interact(src)
	return TRUE

/mob/living/carbon/human/verb/my_family()
	set name = "My Family"
	set category = "IC"

	familytree_open_family_panel("My Family")

/mob/living/carbon/human/verb/ReturnFamilyList()
	set name = "List Family"
	set category = "IC"

	familytree_open_family_panel("List Family")

/mob/living/carbon/human/verb/ToggleFamilyUI()
	set name = "Family UI"
	set category = "IC"
	ShowFamilyUI(FALSE)

/mob/living/carbon/human/proc/ShowFamilyUI(silent)
	if(spouse_mob && !QDELETED(spouse_mob))
		ApplySpouseUI(family_UI)
	else if(spouse_mob)
		spouse_mob = null
	if(family_datum)
		family_datum.ApplyUI(src, family_UI)
	else if(!silent)
		to_chat(src, "You're not part of any notable family.")

	family_UI = !family_UI

	if(!silent)
		to_chat(src, "FamilyUI Toggled [family_UI ? "On" : "Off"]")

/mob/living/carbon/human/proc/ApplySpouseUI(toggle_true = FALSE)
	if(!spouse_mob || !client)
		return
	if(QDELETED(spouse_mob))
		spouse_mob = null
		return
	if(!spouse_indicator)
		spouse_indicator = new('modular_twilight_axis/familytree_module/relations.dmi', loc = spouse_mob, icon_state = "related")
	if(toggle_true)
		client.images.Remove(spouse_indicator)
		return
	client.images.Add(spouse_indicator)
