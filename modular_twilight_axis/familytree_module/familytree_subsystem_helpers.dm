// Title prefixes that may be prepended to real_name
GLOBAL_LIST_INIT(familytree_title_prefixes, list(
	"Lord ", "Lady ", "Ser ", "Dame ",
	"Sir ", "Brother ", "Sister ",
	"Father ", "Mother ",
	"King ", "Queen ", "Prince ", "Princess ",
	"Sultan ", "Sultana ", "Vizier ", "Sheikh ",
	"Amir ", "Amirah ",
))

/proc/familytree_strip_title(name)
	if(!istext(name) || !length(name))
		return name
	for(var/prefix in GLOB.familytree_title_prefixes)
		if(findtext(name, prefix, 1, length(prefix) + 1))
			return copytext(name, length(prefix) + 1)
	return name

/proc/familytree_names_match(name_a, name_b)
	if(!istext(name_a) || !istext(name_b))
		return FALSE
	if(name_a == name_b)
		return TRUE
	return familytree_strip_title(name_a) == familytree_strip_title(name_b)

/proc/pronoun_preference_matches(preference, same_pronouns)
	if(!preference)
		preference = ANY_GENDER

	switch(preference)
		if(ANY_GENDER)
			return TRUE
		if(SAME_GENDER)
			return same_pronouns
		if(DIFFERENT_GENDER)
			return !same_pronouns

	return FALSE

/proc/pronouns_compatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return FALSE

	var/pref_a = A.gender_choice_pref || ANY_GENDER
	var/pref_b = B.gender_choice_pref || ANY_GENDER
	var/same_pronouns = (A.pronouns == B.pronouns)

	return pronoun_preference_matches(pref_a, same_pronouns) && pronoun_preference_matches(pref_b, same_pronouns)

/datum/controller/subsystem/familytree/proc/SpeciesCompatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	return !GetSpeciesCompatibilityFailureReason(A, B)

/datum/controller/subsystem/familytree/proc/familytree_species_preference_allows(mob/living/carbon/human/seeker, mob/living/carbon/human/target)
	if(!seeker || !target)
		return FALSE
	var/species_mode = seeker.species_preference_mode
	if(!species_mode)
		species_mode = "ANY"
	switch(species_mode)
		if("ANY")
			return TRUE
		if("SAME_TYPE")
			return seeker.dna?.species?.type == target.dna?.species?.type
		if("SPECIFIC_TYPE")
			var/list/pref_types = get_familytree_species_type_list(seeker.preferred_species_types)
			return (target.dna?.species?.type in pref_types)
	return TRUE

/datum/controller/subsystem/familytree/proc/familytree_relative_species_compatible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return FALSE
	var/a_isolated = is_isolated(A)
	var/b_isolated = is_isolated(B)
	if(a_isolated || b_isolated)
		return a_isolated && b_isolated
	return familytree_species_preference_allows(A, B) && familytree_species_preference_allows(B, A)

/datum/controller/subsystem/familytree/proc/GetSpeciesCompatibilityFailureReason(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return "missing mob"

	// Isolated group: gnolls and goblins can match with each other but not with outsiders
	var/a_isolated = is_isolated(A)
	var/b_isolated = is_isolated(B)
	if(a_isolated || b_isolated)
		if(!a_isolated || !b_isolated)
			return "isolated group mismatch"

	var/typeA = A.dna.species.type
	var/typeB = B.dna.species.type
	var/list/pref_types_a = get_familytree_species_type_list(A.preferred_species_types)
	var/list/pref_types_b = get_familytree_species_type_list(B.preferred_species_types)
	var/mode_a = A.species_preference_mode
	var/mode_b = B.species_preference_mode
	if(!mode_a)
		mode_a = "ANY"
	if(!mode_b)
		mode_b = "ANY"

	switch(mode_a)
		if("ANY")
			;
		if("SAME_TYPE")
			if(typeA != typeB)
				return "species mismatch"
		if("SPECIFIC_TYPE")
			if(!(typeB in pref_types_a))
				return "species mismatch"

	switch(mode_b)
		if("ANY")
			;
		if("SAME_TYPE")
			if(typeA != typeB)
				return "species mismatch"
		if("SPECIFIC_TYPE")
			if(!(typeA in pref_types_b))
				return "species mismatch"

	if(!AnatomyCompatible(A.preferred_species_anatomy, B))
		return "anatomy mismatch"

	if(!AnatomyCompatible(B.preferred_species_anatomy, A))
		return "anatomy mismatch"

	return null

/datum/controller/subsystem/familytree/proc/AnatomyCompatible(pref, mob/living/carbon/human/target)
	switch(pref)
		if(0)
			return TRUE
		if(1)
			return target.getorganslot(ORGAN_SLOT_PENIS) != null
		if(2)
			return target.getorganslot(ORGAN_SLOT_VAGINA) != null
	return TRUE

/datum/controller/subsystem/familytree/proc/find_job_by_type(job_type)
	if(!job_type)
		return null

	for(var/datum/job/candidate as anything in SSjob.occupations)
		if(candidate.type == job_type)
			return candidate

	for(var/datum/job/candidate as anything in SSjob.occupations)
		if(istype(candidate, job_type))
			return candidate

	return null

/datum/controller/subsystem/familytree/proc/resolve_job_datum(role_or_job)
	if(istype(role_or_job, /datum/job))
		return role_or_job
	if(!role_or_job)
		return null

	var/datum/job/job = SSjob.GetJob(role_or_job)
	if(job)
		return job

	var/role_text = "[role_or_job]"
	for(var/datum/job/candidate as anything in SSjob.occupations)
		if(candidate.title == role_text || candidate.display_title == role_text || candidate.f_title == role_text)
			return candidate

	return null

/datum/controller/subsystem/familytree/proc/get_familytree_job(mob/living/carbon/human/H)
	if(!H)
		return null

	var/datum/job/job = resolve_job_datum(H.mind?.assigned_role)
	if(job)
		return job

	return resolve_job_datum(H.job)

/datum/controller/subsystem/familytree/proc/is_isolated(mob/living/carbon/human/H)
	if(!H?.dna?.species)
		return FALSE
	// Gnolls are always isolated by species alone
	if(istype(H.dna.species, /datum/species/gnoll))
		return TRUE
	// Antag goblins: species goblin + antagonist special_role
	if(istype(H.dna.species, /datum/species/goblin))
		if(H.mind?.special_role)
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/is_sterile_species(mob/living/carbon/human/H)
	if(!H?.dna?.species)
		return FALSE
	for(var/species_type in sterile_species_types)
		if(istype(H.dna.species, species_type))
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/is_banned_antag(mob/living/carbon/human/H)
	var/datum/mind/mind = H?.mind
	if(!mind)
		return FALSE
	for(var/antag_type in banned_antag_types)
		if(mind.has_antag_datum(antag_type))
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/is_familytree_wildshape(mob/living/carbon/human/H)
	return istype(H, /mob/living/carbon/human/species/wildshape)

/datum/controller/subsystem/familytree/proc/is_valid_familytree_species(mob/living/carbon/human/H)
	if(!H?.dna?.species)
		return FALSE
	var/datum/species/S = H.dna.species
	for(var/species_type in isolated_group_types)
		if(istype(S, species_type))
			return TRUE
	for(var/species_type in sterile_species_types)
		if(istype(S, species_type))
			return TRUE
	if(S.check_roundstart_eligible())
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/is_house_isolated(datum/heritage/house)
	if(!house?.dominant_race)
		return FALSE
	var/house_species_type
	if(istype(house.dominant_race, /datum/species))
		house_species_type = house.dominant_race.type
	else if(ispath(house.dominant_race))
		house_species_type = house.dominant_race
	else
		return FALSE
	for(var/species_type in isolated_group_types)
		if(ispath(house_species_type, species_type))
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/house_race_compatible(datum/heritage/house, our_race, we_are_isolated, mob/living/carbon/human/seeker = null)
	if(we_are_isolated)
		return is_house_isolated(house)
	if(is_house_isolated(house))
		return FALSE
	if(!house.dominant_race)
		return FALSE
	if(istype(house.dominant_race, /datum/species))
		return house.dominant_race.name == our_race
	return FALSE

/datum/controller/subsystem/familytree/proc/house_relative_compatible(datum/heritage/house, mob/living/carbon/human/seeker)
	if(!house || !seeker?.dna?.species)
		return FALSE
	var/seeker_isolated = is_isolated(seeker)
	var/house_isolated = is_house_isolated(house)
	if(seeker_isolated || house_isolated)
		return seeker_isolated && house_isolated
	return TRUE

/datum/controller/subsystem/familytree/proc/get_familytree_unsubscribe_reason(mob/living/carbon/human/H)
	if(!H)
		return "null human"
	if(QDELETED(H))
		return "qdeleted"
	if(!H.ckey)
		if(!H.client)
			ftlog("UNSUB_CHECK DEFER: [H.real_name] no ckey+no client, not unsubscribing (mob not ready)")
			return null
		return "npc"
	if(istype(H, /mob/living/carbon/human/dummy))
		return "dummy mob"
	if(is_familytree_wildshape(H))
		ftlog("unsub_reason: [H.real_name] is wildshape")
		return "wildshape form"
	if(!is_valid_familytree_species(H))
		ftlog("unsub_reason: [H.real_name] invalid species [H.dna?.species?.type]")
		return "invalid species"
	if(is_banned_antag(H))
		ftlog("unsub_reason: [H.real_name] banned antag")
		return "banned antag"
	return null

/datum/controller/subsystem/familytree/proc/get_familytree_runtime_block_reason(mob/living/carbon/human/H, require_client = FALSE)
	var/reason = get_familytree_unsubscribe_reason(H)
	if(reason)
		return reason
	if(H.stat == DEAD)
		return "dead"
	if(require_client && !H.client)
		return "no client"
	return null

/datum/controller/subsystem/familytree/proc/pause_familytree_human(mob/living/carbon/human/H, reason)
	if(!H)
		return
	ftlog("pause_human: [H.real_name] ([H.ckey]) reason=[reason]")
	viable_spouses -= H
	H.familytree_assignment_scheduled = FALSE
	H.familytree_confirmation_pending = FALSE

/datum/controller/subsystem/familytree/proc/unsubscribe_familytree_human(mob/living/carbon/human/H, reason)
	if(!H)
		return
	ftlog("unsubscribe_human: [H.real_name] ([H.ckey]) reason=[reason]")
	viable_spouses -= H
	H.familytree_assignment_scheduled = FALSE
	H.familytree_confirmation_pending = FALSE
	stop_tracking_human(H, reason)

// Admin audit helpers are intentionally not guarded by FAMILYTREE_DEBUG_LOGGING.
/datum/controller/subsystem/familytree/proc/familytree_pref_label(pref)
	if(familytree_pref_mask(pref) == FAMILYTREE_MODE_ALL)
		return "any family"
	if(familytree_pref_is_join(pref))
		return "join family"
	if(familytree_pref_is_create(pref))
		return "create family"
	if(familytree_pref_is_legacy_spouse(pref))
		return "legacy spouse family"
	if(!familytree_pref_enabled(pref))
		return "no family"
	return "unknown([pref])"

/datum/controller/subsystem/familytree/proc/familytree_relative_pref_label(relative_role)
	switch(relative_role)
		if(RELATIVE_ANY)
			return "auto"
		if(RELATIVE_SIBLING)
			return "sibling"
		if(RELATIVE_PARENT)
			return "parent"
		if(RELATIVE_CHILD)
			return "child"
		if(RELATIVE_UNCLE_AUNT)
			return "uncle/aunt"
		if(RELATIVE_SPOUSE)
			return "spouse"
	return "unknown([relative_role])"

/datum/controller/subsystem/familytree/proc/familytree_gender_pref_label(gender_pref)
	switch(gender_pref)
		if(ANY_GENDER)
			return "any"
		if(SAME_GENDER)
			return "same"
		if(DIFFERENT_GENDER)
			return "different"
	return "unknown([gender_pref])"

/datum/controller/subsystem/familytree/proc/familytree_polygamy_pref_label(polygamy_pref)
	switch(polygamy_pref)
		if(POLYGAMY_DISABLED)
			return "monogamy"
		if(POLYGAMY_ALLOW_MULTIPLE)
			return "can have multiple spouses"
		if(POLYGAMY_ALLOW_BE_SECOND)
			return "can be additional spouse"
		if(POLYGAMY_ALLOW_BOTH)
			return "both"
	return "unknown([polygamy_pref])"

/datum/controller/subsystem/familytree/proc/familytree_species_pref_summary(mob/living/carbon/human/H)
	if(!H)
		return "species=no mob"

	var/mode = H.species_preference_mode
	if(!mode)
		mode = "ANY"
	var/species_text = "species_mode=[mode]"
	if(mode == "SPECIFIC_TYPE")
		var/list/species_names = islist(H.preferred_species_types) ? H.preferred_species_types : list()
		var/specific_species_text = species_names.len ? species_names.Join(", ") : "none"
		species_text += "; species=[specific_species_text]"
	species_text += "; anatomy=[H.preferred_species_anatomy]"
	return species_text

/datum/controller/subsystem/familytree/proc/familytree_search_summary(mob/living/carbon/human/H)
	if(!H)
		return "unknown"

	var/list/parts = list()
	var/datum/job/job = get_familytree_job(H)
	parts += "pref=[familytree_pref_label(H.familytree_pref)]"
	parts += "desired_role=[familytree_relative_pref_label(H.desired_relative_role)]"
	parts += "gender=[familytree_gender_pref_label(H.gender_choice_pref)]"
	parts += "polygamy=[familytree_polygamy_pref_label(H.polygamy_mode)]"
	parts += familytree_species_pref_summary(H)
	if(H.setspouse && length(H.setspouse))
		parts += "favorite='[H.setspouse]'"
	if(job)
		parts += "job='[job.title]'"
	return parts.Join("; ")

/datum/controller/subsystem/familytree/proc/familytree_closest_relative_member(mob/living/carbon/human/H, datum/family_member/hint = null)
	if(hint?.person && hint.person != H)
		return hint
	var/datum/family_member/member = H?.family_member_datum
	if(!member)
		return null

	for(var/datum/family_member/spouse_relative as anything in member.get_spouse_members())
		if(spouse_relative?.person && spouse_relative.person != H)
			return spouse_relative
	for(var/datum/family_member/parent_relative as anything in member.get_parent_members())
		if(parent_relative?.person && parent_relative.person != H)
			return parent_relative
	for(var/datum/family_member/child_relative as anything in member.get_child_members())
		if(child_relative?.person && child_relative.person != H)
			return child_relative

	for(var/datum/family_member/parent as anything in member.get_parent_members())
		for(var/datum/family_member/sibling as anything in parent.get_child_members())
			if(sibling && sibling != member && sibling.person && sibling.person != H)
				return sibling

	var/datum/heritage/family = member.family
	if(family)
		for(var/datum/family_member/any_relative as anything in family.members)
			if(any_relative?.person && any_relative.person != H)
				return any_relative

	return null

/datum/controller/subsystem/familytree/proc/familytree_relative_audit_text(mob/living/carbon/human/H, datum/family_member/relative)
	if(!relative?.person)
		return "none"
	var/relation = H?.family_member_datum?.GetRelationshipTo(relative) || "relative"
	return "[key_name(relative.person)] ([relation])"

/datum/controller/subsystem/familytree/proc/familytree_admin_log_house_assignment(mob/living/carbon/human/H, datum/heritage/house, found_summary, datum/family_member/nearest_hint = null)
	if(!H || QDELETED(H) || !house)
		return
	var/datum/family_member/nearest = familytree_closest_relative_member(H, nearest_hint)
	var/house_name = house.housename || "no name"
	var/search_summary = familytree_search_summary(H)
	var/nearest_summary = familytree_relative_audit_text(H, nearest)
	var/found_text = found_summary || "unknown"
	var/message = "FAMILYTREE: [key_name(H)] joined house '[house_name]'. searched=[search_summary]; found=[found_text]; nearest_relative=[nearest_summary]"
	log_admin(message)
	ftlog(message, FTLOG_INFO)

/datum/controller/subsystem/familytree/proc/is_job_of_type(datum/job/job, list/type_list)
	if(!job || !type_list)
		return FALSE
	for(var/job_type in type_list)
		if(istype(job, job_type))
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/is_human_job_of_type(mob/living/carbon/human/H, list/type_list)
	if(!H || !type_list)
		return FALSE
	var/datum/job/job = get_familytree_job(H)
	if(!job)
		return FALSE
	return is_job_of_type(job, type_list)

/datum/controller/subsystem/familytree/proc/is_human_job_in_list(mob/living/carbon/human/H, list/title_list)
	if(!H || !title_list)
		return FALSE

	var/datum/job/job = get_familytree_job(H)
	if(job)
		if(job.title in title_list)
			return TRUE
		if(job.display_title && (job.display_title in title_list))
			return TRUE
		if(job.f_title && (job.f_title in title_list))
			return TRUE

	var/mind_role = H.mind?.assigned_role
	if(istext(mind_role) && (mind_role in title_list))
		return TRUE
	if(istext(H.job) && (H.job in title_list))
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/is_royal_monarch_job(datum/job/job)
	return istype(job, /datum/job/roguetown/lord) || istype(job, /datum/job/roguetown/sultan)

/datum/controller/subsystem/familytree/proc/is_royal_consort_job(datum/job/job)
	return istype(job, /datum/job/roguetown/lady) || is_royal_harem_job(job)

/datum/controller/subsystem/familytree/proc/is_royal_suitor_job(datum/job/job)
	return istype(job, /datum/job/roguetown/suitor)

/datum/controller/subsystem/familytree/proc/is_royal_progeny_job(datum/job/job)
	return istype(job, /datum/job/roguetown/prince)

/datum/controller/subsystem/familytree/proc/is_royal_hand_job(datum/job/job)
	return istype(job, /datum/job/roguetown/hand) || istype(job, /datum/job/roguetown/vizier)

/datum/controller/subsystem/familytree/proc/get_royal_status(mob/living/carbon/human/H)
	var/datum/job/job = get_familytree_job(H)
	if(is_royal_monarch_job(job) || is_royal_consort_job(job))
		return H.familytree_get_parental_style() == "feminine" ? FAMILY_MOTHER : FAMILY_FATHER
	if(is_royal_progeny_job(job))
		return FAMILY_PROGENY
	if(is_royal_hand_job(job))
		return FAMILY_OMMER
	return null

/datum/controller/subsystem/familytree/proc/get_royal_delay(mob/living/carbon/human/H)
	var/datum/job/job = get_familytree_job(H)
	if(is_royal_monarch_job(job))
		return 41
	if(is_royal_consort_job(job))
		return 43
	if(is_royal_progeny_job(job) || is_royal_hand_job(job))
		return 45
	return 45

/datum/controller/subsystem/familytree/proc/GetAgeValue(age_string)
	switch(age_string)
		if(AGE_ADULT)
			return 1
		if(AGE_MIDDLEAGED)
			return 2
		if(AGE_OLD)
			return 3
		else
			return 1

/datum/controller/subsystem/familytree/proc/CanBeParentOf(mob/living/carbon/human/parent, mob/living/carbon/human/child)
	if(!parent || !child)
		return FALSE
	var/parent_age = parent.age
	var/child_age = child.age
	if(parent_age == AGE_ADULT)
		return FALSE
	if(parent_age == AGE_MIDDLEAGED && child_age == AGE_ADULT)
		return TRUE
	if(parent_age == AGE_OLD && child_age != AGE_OLD)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_single_parent_species_compatible(mob/living/carbon/human/child, mob/living/carbon/human/parent, datum/heritage/house = null)
	if(!child || !parent)
		return FALSE
	var/datum/heritage/context = house || child.family_datum || parent.family_datum || ruling_family
	if(!context)
		return FALSE
	return context.SingleParentSpeciesCalculation(child, parent)

/datum/controller/subsystem/familytree/proc/familytree_biological_parent_allowed(mob/living/carbon/human/parent, mob/living/carbon/human/child, datum/heritage/house = null)
	if(!parent || !child)
		return FALSE
	return familytree_single_parent_species_compatible(child, parent, house)

/datum/controller/subsystem/familytree/proc/familytree_genital_signature(mob/living/carbon/human/H)
	if(!H)
		return null
	var/signature = 0
	if(H.getorganslot(ORGAN_SLOT_PENIS))
		signature |= 1
	if(H.getorganslot(ORGAN_SLOT_VAGINA))
		signature |= 2
	return signature

/datum/controller/subsystem/familytree/proc/familytree_biological_parent_genitals_compatible(mob/living/carbon/human/parent1, mob/living/carbon/human/parent2)
	var/parent1_signature = familytree_genital_signature(parent1)
	var/parent2_signature = familytree_genital_signature(parent2)
	if(isnull(parent1_signature) || isnull(parent2_signature))
		return FALSE
	if(parent1_signature == parent2_signature)
		return FALSE
	var/combined_signature = parent1_signature | parent2_signature
	return (combined_signature & 1) && (combined_signature & 2)

/datum/controller/subsystem/familytree/proc/familytree_biological_parent_pair_allowed(mob/living/carbon/human/parent1, mob/living/carbon/human/parent2, mob/living/carbon/human/child, datum/heritage/house = null)
	if(!child)
		return FALSE
	if(!parent1)
		return familytree_biological_parent_allowed(parent2, child, house)
	if(!parent2)
		return familytree_biological_parent_allowed(parent1, child, house)
	if(!familytree_biological_parent_genitals_compatible(parent1, parent2))
		return FALSE
	var/datum/heritage/context = house || child.family_datum || parent1.family_datum || parent2.family_datum || ruling_family
	if(!context)
		return FALSE
	return context.SpeciesCalculation(child, parent1, parent2)

/datum/controller/subsystem/familytree/proc/familytree_pair_blocked(mob/living/carbon/human/seeker, mob/living/carbon/human/partner)
	if(!seeker || !partner)
		return FALSE
	if(seeker.familytree_blocked_ckeys && (partner.ckey in seeker.familytree_blocked_ckeys))
		return TRUE
	if(partner.familytree_blocked_ckeys && (seeker.ckey in partner.familytree_blocked_ckeys))
		return TRUE
	return FALSE

/proc/familytree_donator_relatives_enabled(ckey)
	if(!ckey)
		return FALSE
	var/plevel = check_patreon_lvl(ckey)
	if(!isnum(plevel))
		return FALSE
	return plevel >= FAMILYTREE_DONATOR_RELATIVES_TIER

/proc/familytree_role_text_ru(role)
	switch(role)
		if("spouse")
			return "супруг(а)"
		if("sibling")
			return "брат/сестра"
		if("child")
			return "ребёнок"
		if("parent")
			return "родитель"
		if("uncle_aunt")
			return "дядя/тётя"
		if("nibling")
			return "племянник(ца)"
		if("relative")
			return "родственник"
	return null

/proc/familytree_new_family_role_text_ru(relation, is_a)
	switch(relation)
		if("spouse")
			return familytree_role_text_ru("spouse")
		if("sibling")
			return familytree_role_text_ru("sibling")
		if("a_parent")
			return is_a ? familytree_role_text_ru("parent") : familytree_role_text_ru("child")
		if("b_parent")
			return is_a ? familytree_role_text_ru("child") : familytree_role_text_ru("parent")
		if("a_uncle_aunt")
			return is_a ? familytree_role_text_ru("uncle_aunt") : familytree_role_text_ru("nibling")
		if("b_uncle_aunt")
			return is_a ? familytree_role_text_ru("nibling") : familytree_role_text_ru("uncle_aunt")
	return null

/proc/familytree_forced_role_text_ru(forced_role)
	switch(forced_role)
		if("sibling")
			return familytree_role_text_ru("sibling")
		if("parent")
			return familytree_role_text_ru("parent")
		if("child")
			return familytree_role_text_ru("child")
		if("uncle_aunt")
			return familytree_role_text_ru("uncle_aunt")
	return null

/proc/familytree_desired_role_text_ru(desired_role)
	switch(desired_role)
		if(RELATIVE_SIBLING)
			return familytree_role_text_ru("sibling")
		if(RELATIVE_PARENT)
			return familytree_role_text_ru("parent")
		if(RELATIVE_CHILD)
			return familytree_role_text_ru("child")
		if(RELATIVE_UNCLE_AUNT)
			return familytree_role_text_ru("uncle_aunt")
		if(RELATIVE_SPOUSE)
			return familytree_role_text_ru("spouse")
	return null

/datum/controller/subsystem/familytree/proc/familytree_build_member_descriptor(datum/family_member/member)
	if(!member?.person)
		return null
	var/mob/living/carbon/human/H = member.person
	var/list/descriptors = H.get_mob_descriptors(FALSE, H)
	if(!descriptors?.len)
		return null

	var/list/lines = list()
	var/list/desc_copy = descriptors.Copy()

	var/first_line = build_coalesce_description(desc_copy, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT, MOB_DESCRIPTOR_SLOT_BODY, MOB_DESCRIPTOR_SLOT_STATURE, MOB_DESCRIPTOR_SLOT_FACE_SHAPE, MOB_DESCRIPTOR_SLOT_FACE_EXPRESSION), "You see %DESC1%, %DESC2% %DESC3% with %DESC4%, %DESC5%.")
	if(first_line)
		lines += first_line

	var/second_line = build_coalesce_description(desc_copy, H, list(MOB_DESCRIPTOR_SLOT_AGE, MOB_DESCRIPTOR_SLOT_SKIN, MOB_DESCRIPTOR_SLOT_VOICE), "%THEY% %DESC1%, %DESC2% and %DESC3%.")
	if(second_line)
		lines += second_line

	var/third_line = build_coalesce_description(desc_copy, H, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.")
	if(third_line)
		lines += third_line

	var/fourth_line = build_coalesce_description(desc_copy, H, list(MOB_DESCRIPTOR_SLOT_PROMINENT, MOB_DESCRIPTOR_SLOT_PROMINENT), "%THEY% %DESC1% and %DESC2%.")
	if(fourth_line)
		lines += fourth_line

	if(!lines.len)
		return null
	return lines.Join("\n")

/datum/controller/subsystem/familytree/proc/familytree_format_fate_reveal(mob/living/carbon/human/partner)
	if(!partner)
		return ""
	var/species_name = partner.dna?.species?.name || "неизвестный вид"
	var/gender_text
	switch(partner.gender)
		if(MALE)
			gender_text = "мужской"
		if(FEMALE)
			gender_text = "женский"
		if(PLURAL)
			gender_text = "множественный"
		if(NEUTER)
			gender_text = "средний"
		else
			gender_text = "неопределённый"
	var/has_penis = partner.getorganslot(ORGAN_SLOT_PENIS) != null
	var/has_vagina = partner.getorganslot(ORGAN_SLOT_VAGINA) != null
	var/anatomy_text
	if(has_penis && has_vagina)
		anatomy_text = "обоеполая"
	else if(has_penis)
		anatomy_text = "мужская"
	else if(has_vagina)
		anatomy_text = "женская"
	else
		anatomy_text = "без половых признаков"
	return "\nРаса: [species_name]\nПол: [gender_text]\nАнатомия: [anatomy_text]"

/datum/controller/subsystem/familytree/proc/CanBeSiblings(age1, age2)
	if(!age1 || !age2)
		return FALSE
	if(age1 == age2)
		return TRUE

	var/age1_value = GetAgeValue(age1)
	var/age2_value = GetAgeValue(age2)

	if(abs(age1_value - age2_value) <= 1)
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/WouldCreateAgeConflict(datum/heritage/house, mob/living/carbon/human/person)
	if(!house.member_nodes.len)
		return FALSE
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(!node.person)
			continue

		for(var/datum/family_node/child_node as anything in node.get_child_nodes())
			if(child_node.person && !CanBeParentOf(person, child_node.person))
				return TRUE

		for(var/datum/family_node/parent_node as anything in node.get_parent_nodes())
			if(parent_node.person && !CanBeParentOf(parent_node.person, person))
				return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/DetermineAppropriateRole(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE)
	var/list/possible_roles = list()

	var/can_be_child = FALSE
	var/can_be_sibling = FALSE
	var/can_be_parent = FALSE
	for(var/datum/family_node/node as anything in house.member_nodes)
		var/mob/living/carbon/human/other = node.person
		if(!other)
			continue
		if(!can_be_child && CanBeParentOf(other, person) && (adopted || familytree_biological_parent_allowed(other, person, house)))
			can_be_child = TRUE
		if(!can_be_sibling && CanBeSiblings(other.age, person.age))
			can_be_sibling = TRUE
		if(!can_be_parent && CanBeParentOf(person, other) && (adopted || familytree_biological_parent_allowed(person, other, house)))
			can_be_parent = TRUE
		if(can_be_child && can_be_sibling && can_be_parent)
			break

	if(can_be_child)
		possible_roles += "child"
	if(can_be_sibling)
		possible_roles += "sibling"
	if(can_be_parent)
		possible_roles += "parent"

	if(!possible_roles.len)
		return null

	return pick(possible_roles)

/datum/controller/subsystem/familytree/proc/ValidateAllFamilies()
	if(ruling_family && ruling_family.member_nodes.len)
		ValidateFamily(ruling_family)
	for(var/datum/heritage/family as anything in families)
		if(family.member_nodes.len)
			ValidateFamily(family)

/datum/controller/subsystem/familytree/proc/ValidateFamily(datum/heritage/family)
	if(!family)
		return
	for(var/datum/family_member/member as anything in family.members.Copy())
		if(!member.person && !member.phantom)
			family.members -= member
