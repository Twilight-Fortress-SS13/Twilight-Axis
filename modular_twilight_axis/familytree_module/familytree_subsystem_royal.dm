/datum/controller/subsystem/familytree/proc/ensure_royal_partner_job_baselines()
	if(royal_partner_job_baselines.len)
		return TRUE

	var/datum/job/consort_job = find_job_by_type(/datum/job/roguetown/lady)
	var/datum/job/suitor_job = find_job_by_type(/datum/job/roguetown/suitor)

	if(consort_job)
		royal_partner_job_baselines["consort"] = list(
			"forbidden_races" = islist(consort_job.forbidden_races) ? consort_job.forbidden_races.Copy() : list(),
			"allowed_sexes" = islist(consort_job.allowed_sexes) ? consort_job.allowed_sexes.Copy() : list(),
			"total_positions" = consort_job.total_positions,
			"spawn_positions" = consort_job.spawn_positions,
		)

	if(suitor_job)
		royal_partner_job_baselines["suitor"] = list(
			"forbidden_races" = islist(suitor_job.forbidden_races) ? suitor_job.forbidden_races.Copy() : list(),
			"allowed_sexes" = islist(suitor_job.allowed_sexes) ? suitor_job.allowed_sexes.Copy() : list(),
			"total_positions" = suitor_job.total_positions,
			"spawn_positions" = suitor_job.spawn_positions,
		)

	return royal_partner_job_baselines.len >= 2

/datum/controller/subsystem/familytree/proc/get_royal_partner_mode_from_preferences(datum/preferences/P)
	if(!P)
		return "consort"

	if(duke_forced_hetero_mode(P))
		return "consort"

	if(familytree_pref_is_join(P.family) || familytree_pref_is_legacy_spouse(P.family))
		return "suitor"
	if(familytree_pref_is_create(P.family) || !familytree_pref_enabled(P.family))
		return "consort"

	return "consort"

/datum/controller/subsystem/familytree/proc/duke_forced_hetero_mode(datum/preferences/P)
	if(!P)
		return FALSE
	if(familytree_pref_enabled(P.family))
		return FALSE
	return allow_nobles_in_ruling_family

/datum/controller/subsystem/familytree/proc/get_familytree_species_type_list(list/preferred_species_types) as /list
	var/list/result = list()
	if(!islist(preferred_species_types))
		return result

	for(var/entry in preferred_species_types)
		var/species_type = entry
		if(istext(species_type))
			species_type = GLOB.species_list[species_type]
		if(!ispath(species_type, /datum/species))
			continue
		if(species_type in result)
			continue
		result += species_type

	return result

/datum/controller/subsystem/familytree/proc/get_preference_species_type_list(datum/preferences/P) as /list
	if(!P)
		return list()
	return get_familytree_species_type_list(P.preferred_species_types)

/datum/controller/subsystem/familytree/proc/get_royal_partner_allowed_races(mob/living/carbon/human/duke, datum/preferences/P) as /list
	if(!P)
		return list()

	var/duke_species_type = duke?.dna?.species?.type
	if(!ispath(duke_species_type, /datum/species))
		duke_species_type = P?.pref_species?.type

	if(duke_forced_hetero_mode(P))
		if(ispath(duke_species_type, /datum/species))
			return list(duke_species_type)
		return list()

	switch(P.species_preference_mode)
		if("SAME_TYPE")
			if(ispath(duke_species_type, /datum/species))
				return list(duke_species_type)
		if("SPECIFIC_TYPE")
			var/list/preferred_species = get_preference_species_type_list(P)
			if(preferred_species.len)
				return preferred_species

	return list()

/datum/controller/subsystem/familytree/proc/get_royal_partner_allowed_sexes(mob/living/carbon/human/duke, datum/preferences/P, list/default_sexes) as /list
	var/list/allowed_sexes = islist(default_sexes) ? default_sexes.Copy() : list()
	if(!P)
		return allowed_sexes

	var/duke_body_type = duke?.gender
	if(duke_body_type != MALE && duke_body_type != FEMALE)
		duke_body_type = P?.gender

	if(duke_forced_hetero_mode(P))
		if(duke_body_type == MALE)
			return list(FEMALE)
		if(duke_body_type == FEMALE)
			return list(MALE)
		return allowed_sexes

	switch(P.gender_choice_pref)
		if(SAME_GENDER)
			if(duke_body_type == MALE || duke_body_type == FEMALE)
				return list(duke_body_type)
		if(DIFFERENT_GENDER)
			if(duke_body_type == MALE)
				return list(FEMALE)
			if(duke_body_type == FEMALE)
				return list(MALE)

	return allowed_sexes

/datum/controller/subsystem/familytree/proc/compute_royal_forbidden_races(list/baseline_forbidden, list/allowed_races) as /list
	var/list/result = islist(baseline_forbidden) ? baseline_forbidden.Copy() : list()
	if(!islist(allowed_races) || !allowed_races.len)
		return result
	var/list/all_selectable = familytree_module_get_selectable_species_types()
	for(var/species_type in all_selectable)
		if(!(species_type in allowed_races))
			result |= species_type
	return result

/datum/controller/subsystem/familytree/proc/apply_royal_partner_job_state(job_key, enabled, open_slots = 0, list/allowed_races, list/allowed_sexes)
	if(!ensure_royal_partner_job_baselines())
		return FALSE

	var/datum/job/job = null
	switch(job_key)
		if("consort")
			job = find_job_by_type(/datum/job/roguetown/lady)
		if("suitor")
			job = find_job_by_type(/datum/job/roguetown/suitor)

	var/list/baseline = royal_partner_job_baselines[job_key]
	if(!job || !baseline)
		return FALSE

	var/list/baseline_forbidden_races = baseline["forbidden_races"]
	var/list/baseline_allowed_sexes = baseline["allowed_sexes"]
	job.forbidden_races = islist(baseline_forbidden_races) ? baseline_forbidden_races.Copy() : list()
	job.allowed_sexes = islist(baseline_allowed_sexes) ? baseline_allowed_sexes.Copy() : list()
	job.total_positions = baseline["total_positions"]
	job.spawn_positions = baseline["spawn_positions"]

	if(enabled)
		job.forbidden_races = compute_royal_forbidden_races(baseline_forbidden_races, allowed_races)
		job.allowed_sexes = islist(allowed_sexes) ? allowed_sexes.Copy() : list()
		job.total_positions = open_slots
		job.spawn_positions = open_slots
	else
		job.total_positions = 0
		job.spawn_positions = 0

	return TRUE

/datum/controller/subsystem/familytree/proc/reset_royal_partner_jobs()
	current_royal_partner_owner = null
	current_royal_partner_mode = "closed"
	current_royal_partner_snapshot = list()

	apply_royal_partner_job_state("consort", FALSE)
	apply_royal_partner_job_state("suitor", FALSE)

/datum/controller/subsystem/familytree/proc/refresh_royal_partner_jobs(mob/living/carbon/human/duke, datum/preferences/P)
	if(!duke?.client)
		return FALSE

	if(!ensure_royal_partner_job_baselines())
		return FALSE

	if(!P)
		P = duke.client.prefs
	if(!P)
		return FALSE

	if(current_royal_partner_owner == duke && current_royal_partner_snapshot.len)
		return TRUE

	if(current_royal_partner_owner && current_royal_partner_owner != duke)
		return FALSE

	load_familytree_runtime_preferences(duke, P)

	var/mode = get_royal_partner_mode_from_preferences(P)
	var/list/consort_baseline = royal_partner_job_baselines["consort"]
	var/list/suitor_baseline = royal_partner_job_baselines["suitor"]
	if(!consort_baseline || !suitor_baseline)
		return FALSE

	var/list/consort_allowed_races = get_royal_partner_allowed_races(duke, P)
	var/list/consort_allowed_sexes = get_royal_partner_allowed_sexes(duke, P, consort_baseline["allowed_sexes"])
	var/list/suitor_allowed_races = get_royal_partner_allowed_races(duke, P)
	var/list/suitor_allowed_sexes = get_royal_partner_allowed_sexes(duke, P, suitor_baseline["allowed_sexes"])

	switch(mode)
		if("consort")
			apply_royal_partner_job_state("consort", TRUE, 1, consort_allowed_races, consort_allowed_sexes)
			apply_royal_partner_job_state("suitor", FALSE)
		if("suitor")
			apply_royal_partner_job_state("consort", FALSE)
			apply_royal_partner_job_state("suitor", TRUE, 2, suitor_allowed_races, suitor_allowed_sexes)
		else
			apply_royal_partner_job_state("consort", FALSE)
			apply_royal_partner_job_state("suitor", FALSE)

	var/effective_gender_pref = P.gender_choice_pref
	var/effective_species_mode = P.species_preference_mode
	var/effective_anatomy = P.preferred_species_anatomy
	if(duke_forced_hetero_mode(P))
		effective_gender_pref = DIFFERENT_GENDER
		effective_species_mode = "SAME_TYPE"
		effective_anatomy = 0

	current_royal_partner_owner = duke
	current_royal_partner_mode = mode
	current_royal_partner_snapshot = list(
		"family" = duke.familytree_pref,
		"duke_gender" = duke.gender,
		"duke_pronouns" = duke.pronouns,
		"duke_species_type" = duke.dna?.species?.type,
		"gender_choice_pref" = effective_gender_pref,
		"species_preference_mode" = effective_species_mode,
		"preferred_species_types" = islist(duke.preferred_species_types) ? duke.preferred_species_types.Copy() : list(),
		"preferred_species_anatomy" = effective_anatomy,
		"setspouse" = duke.setspouse,
	)
	return TRUE

/datum/controller/subsystem/familytree/proc/get_royal_partner_job_key(role_or_job)
	var/datum/job/job = resolve_job_datum(role_or_job)
	if(is_royal_consort_job(job))
		return "consort"
	if(is_royal_suitor_job(job))
		return "suitor"
	return null

/datum/controller/subsystem/familytree/proc/royal_partner_species_match(datum/preferences/P)
	if(!P)
		return FALSE

	var/species_type = P.pref_species?.type
	if(!ispath(species_type, /datum/species))
		return FALSE

	var/preference_mode = current_royal_partner_snapshot["species_preference_mode"]
	var/duke_species_type = current_royal_partner_snapshot["duke_species_type"]
	var/list/preferred_species_types = current_royal_partner_snapshot["preferred_species_types"]

	if(!islist(preferred_species_types))
		preferred_species_types = list()

	var/list/resolved_species = list()
	for(var/entry in preferred_species_types)
		var/species_entry = entry
		if(istext(species_entry))
			species_entry = GLOB.species_list[species_entry]
		if(ispath(species_entry, /datum/species))
			resolved_species += species_entry

	switch(preference_mode)
		if("SAME_TYPE")
			return species_type == duke_species_type
		if("SPECIFIC_TYPE")
			return species_type in resolved_species

	return TRUE

/datum/controller/subsystem/familytree/proc/royal_partner_gender_match(datum/preferences/P)
	if(!P)
		return FALSE

	var/gender_pref = current_royal_partner_snapshot["gender_choice_pref"]
	if(!gender_pref || gender_pref == ANY_GENDER)
		return TRUE

	var/duke_pronouns = current_royal_partner_snapshot["duke_pronouns"]
	var/candidate_pronouns = P.pronouns
	if(!isnull(duke_pronouns) && !isnull(candidate_pronouns))
		if(gender_pref == SAME_GENDER)
			return duke_pronouns == candidate_pronouns
		if(gender_pref == DIFFERENT_GENDER)
			return duke_pronouns != candidate_pronouns

	var/duke_gender = current_royal_partner_snapshot["duke_gender"]
	var/candidate_gender = P.gender
	if(gender_pref == SAME_GENDER)
		return duke_gender == candidate_gender
	if(gender_pref == DIFFERENT_GENDER)
		return duke_gender != candidate_gender

	return TRUE

/datum/controller/subsystem/familytree/proc/royal_partner_anatomy_match(datum/preferences/P)
	if(!P)
		return FALSE

	var/anatomy_pref = current_royal_partner_snapshot["preferred_species_anatomy"]
	switch(anatomy_pref)
		if(0)
			return TRUE
		if(1)
			return P.familytree_module_has_penis()
		if(2)
			return P.familytree_module_has_vagina()

	return TRUE

/datum/controller/subsystem/familytree/proc/royal_partner_name_match(datum/preferences/P)
	if(!P)
		return FALSE

	var/required_name = current_royal_partner_snapshot["setspouse"]
	if(!istext(required_name) || !length(required_name))
		return TRUE

	return familytree_names_match(P.real_name, required_name)

/datum/controller/subsystem/familytree/proc/royal_partner_candidate_allowed(client/C, role_or_job)
	if(!C?.prefs || !current_royal_partner_owner || !current_royal_partner_snapshot.len)
		return FALSE

	var/job_key = get_royal_partner_job_key(role_or_job)
	if(!job_key || current_royal_partner_mode != job_key)
		return FALSE

	var/datum/preferences/P = C.prefs
	var/datum/job/job = resolve_job_datum(role_or_job)
	if(job?.title)
		P = C.prefs.get_job_prefs(job.title)
	if(!royal_partner_species_match(P))
		return FALSE
	if(!royal_partner_gender_match(P))
		return FALSE
	if(!royal_partner_anatomy_match(P))
		return FALSE
	if(job_key == "consort" && !royal_partner_name_match(P))
		return FALSE

	return TRUE

/datum/controller/subsystem/familytree/proc/run_royal_hand_assignment_offer(mob/living/carbon/human/H)
	ftlog("run_royal_hand_assignment_offer: [H?.real_name] ([H?.ckey])")
	if(!H || QDELETED(H))
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		pause_familytree_human(H, "royal hand offer deferred: dead")
		return
	if(block_reason == "no client")
		H.familytree_assignment_scheduled = FALSE
		return
	if(block_reason)
		unsubscribe_familytree_human(H, "royal hand offer aborted: [block_reason]")
		return
	if(H.family_datum)
		H.familytree_assignment_scheduled = FALSE
		stop_tracking_human(H, "royal hand offer skipped; family already assigned")
		return
	H.familytree_assignment_scheduled = FALSE
	if(!GetCurrentMonarch())
		fallback_royal_hand_to_local(H, "no monarch for royal hand family")
		return
	INVOKE_ASYNC(src, PROC_REF(do_royal_hand_assignment_offer), H)

/datum/controller/subsystem/familytree/proc/do_royal_hand_assignment_offer(mob/living/carbon/human/H)
	if(!H?.client || H.family_datum)
		return
	var/datum/family_member/monarch = GetCurrentMonarch()
	if(!monarch?.person)
		fallback_royal_hand_to_local(H, "no monarch for royal hand family")
		return

	var/result = tgui_alert(H, "Герцог [monarch.person.real_name] уже в раунде. Хотите стать частью его семьи как родственник?\n\nЕсли отказаться, семейная система продолжит работать по вашим обычным настройкам.", "Герцогская семья", list("Да", "Нет"), 60 SECONDS)

	if(!H || QDELETED(H) || H.family_datum)
		return
	if(result == "Да")
		ftlog("ROYAL HAND OFFER: [H.real_name] accepted ruling family")
		AddRoyal(H, FAMILY_OMMER)
	else
		ftlog("ROYAL HAND OFFER: [H.real_name] declined ruling family")
		fallback_royal_hand_to_local(H, "royal hand declined ruling family")

/datum/controller/subsystem/familytree/proc/fallback_royal_hand_to_local(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum)
		return
	H.familytree_assignment_scheduled = FALSE
	if(familytree_pref_enabled(H.familytree_pref))
		var/timer = rand(1, 10)
		ftlog("ROYAL HAND FALLBACK: [H.real_name] normal pref=[H.familytree_pref] timer=[timer]s reason=[reason]")
		H.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), timer SECONDS)
		return
	stop_tracking_human(H, reason)

/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(!H)
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		pause_familytree_human(H, "royal assignment blocked: dead")
		return
	if(block_reason == "no client")
		return
	if(block_reason)
		unsubscribe_familytree_human(H, "royal assignment blocked: [block_reason]")
		return
	if(status == FAMILY_OMMER && !GetCurrentMonarch())
		fallback_royal_hand_to_local(H, "royal hand assignment blocked: no monarch")
		return
	if(!ruling_family.housename)
		ruling_family.housename = " Royal"
	var/datum/family_member/member = ruling_family.CreateFamilyMember(H)
	if(!member)
		stop_tracking_human(H, "royal assignment failed; member creation returned null")
		return

	if(!ruling_family.founder)
		GenerateRoyalLineage(member, status)
		familytree_admin_log_house_assignment(H, ruling_family, "generated ruling family lineage as [status]")
		H.ShowFamilyUI(TRUE)
		stop_tracking_human(H, "royal lineage generated")
		ask_monarch_noble_permission(H)
		return

	switch(status)
		if(FAMILY_FATHER, FAMILY_MOTHER)
			var/datum/family_member/existing_monarch = GetCurrentMonarch()
			member.generation = 12
			if(existing_monarch)
				ruling_family.MarryMembers(existing_monarch, member)

		if(FAMILY_PROGENY)
			var/datum/family_member/monarch = GetCurrentMonarch()
			if(monarch)
				member.generation = monarch.generation + 1
				member.AddParent(monarch)
				var/list/monarch_spouses = monarch.get_spouse_members()
				if(monarch_spouses.len)
					member.AddParent(monarch_spouses[1])

		if(FAMILY_OMMER)
			CreateBranchFamily(member)

	familytree_admin_log_house_assignment(H, ruling_family, "joined ruling family as [status]")
	H.ShowFamilyUI(TRUE)
	stop_tracking_human(H, "royal assignment completed")

/datum/controller/subsystem/familytree/proc/GetCurrentMonarch()
	for(var/datum/family_member/member as anything in ruling_family.members)
		if(member.generation == 12 && is_royal_monarch_job(get_familytree_job(member.person)))
			return member
	return null

/datum/controller/subsystem/familytree/proc/CreateBranchFamily(datum/family_member/hand_member)
	var/datum/family_member/monarch = GetCurrentMonarch()
	if(!monarch)
		return

	hand_member.generation = monarch.generation

	var/list/monarch_parents = monarch.get_parent_members()
	if(monarch_parents.len)
		var/datum/family_member/monarch_parent = monarch_parents[1]
		var/datum/family_member/monarch_parent_second = monarch_parents.len > 1 ? monarch_parents[2] : null
		if(monarch_parent)
			hand_member.AddParent(monarch_parent)
		if(monarch_parent_second)
			hand_member.AddParent(monarch_parent_second)

/datum/controller/subsystem/familytree/proc/GenerateRoyalLineage(datum/family_member/current_royal, status)
	if(!current_royal?.person)
		return

	ruling_family.founder = current_royal
	current_royal.generation = 12

	ruling_family.dominant_species = current_royal.person.dna.species.type

	var/datum/family_member/current_ancestor = current_royal
	var/list/age_progression = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_OLD)

	for(var/i = current_royal.generation - 1; i >= 6; i--)
		var/mob/living/carbon/human/dummy/ancestor = new()
		ancestor.age = age_progression[min(current_royal.generation - i, age_progression.len)]
		ancestor.gender = prob(50) ? MALE : FEMALE
		ancestor.real_name = GenerateRoyalName(ancestor.gender, i)
		set_species_type(ancestor, ruling_family.dominant_species)
		var/datum/family_member/parent = ruling_family.CreateFamilyMember(ancestor)
		parent.generation = i

		var/mob/living/carbon/human/dummy/spouse = new()
		spouse.age = ancestor.age
		spouse.gender = ancestor.gender == MALE ? FEMALE : MALE
		spouse.real_name = GenerateRoyalName(spouse.gender, i)
		set_species_type(spouse, ruling_family.dominant_species)
		var/datum/family_member/parent_spouse = ruling_family.CreateFamilyMember(spouse)
		parent_spouse.generation = i

		ruling_family.MarryMembers(parent, parent_spouse)
		current_ancestor.AddParent(parent)
		current_ancestor.AddParent(parent_spouse)

		var/sibling_rolls = 0
		if(prob(60))
			sibling_rolls = 1
		if(prob(25))
			sibling_rolls = 2
		for(var/s_idx = 1, s_idx <= sibling_rolls, s_idx++)
			var/mob/living/carbon/human/dummy/sibling = new()
			sibling.age = pick(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
			sibling.gender = prob(50) ? MALE : FEMALE
			sibling.real_name = GenerateRoyalName(sibling.gender, i + 1)
			set_species_type(sibling, ruling_family.dominant_species)
			var/datum/family_member/sibling_member = ruling_family.CreateFamilyMember(sibling)
			sibling_member.generation = i + 1
			sibling_member.AddParent(parent)
			sibling_member.AddParent(parent_spouse)

			var/datum/family_member/sibling_spouse_member = null
			if(prob(55))
				var/mob/living/carbon/human/dummy/sibling_spouse = new()
				sibling_spouse.age = sibling.age
				sibling_spouse.gender = sibling.gender == MALE ? FEMALE : MALE
				sibling_spouse.real_name = GenerateRoyalName(sibling_spouse.gender, i + 1)
				set_species_type(sibling_spouse, ruling_family.dominant_species)
				sibling_spouse_member = ruling_family.CreateFamilyMember(sibling_spouse)
				sibling_spouse_member.generation = i + 1
				ruling_family.MarryMembers(sibling_member, sibling_spouse_member)

			if(sibling_spouse_member && prob(45))
				var/cousin_count = prob(30) ? 2 : 1
				for(var/c_idx = 1, c_idx <= cousin_count, c_idx++)
					var/mob/living/carbon/human/dummy/cousin = new()
					cousin.age = AGE_ADULT
					cousin.gender = prob(50) ? MALE : FEMALE
					cousin.real_name = GenerateRoyalName(cousin.gender, i + 2)
					set_species_type(cousin, ruling_family.dominant_species)
					var/datum/family_member/cousin_member = ruling_family.CreateFamilyMember(cousin)
					cousin_member.generation = i + 2
					cousin_member.AddParent(sibling_member)
					cousin_member.AddParent(sibling_spouse_member)

		current_ancestor = parent

/datum/controller/subsystem/familytree/proc/set_species_type(mob/living/carbon/human/H, species_type)
	if(!H || !species_type)
		return

	var/datum/species/S = new species_type
	H.set_species(S)
	H.dna.species = S

/datum/controller/subsystem/familytree/proc/familytree_species_type_from_name(species_name)
	if(!istext(species_name) || !length(species_name))
		return null
	var/species_type = GLOB.species_list[species_name]
	if(ispath(species_type, /datum/species))
		return species_type
	return null

/datum/controller/subsystem/familytree/proc/familytree_create_commoner_parent(datum/heritage/house, parent_name, parent_species_name, parent_gender, default_species_type, parent_generation)
	if(!house || !istext(parent_name) || !length(parent_name))
		return null
	var/chosen_species_type = familytree_species_type_from_name(parent_species_name) || default_species_type
	var/mob/living/carbon/human/dummy/parent_mob = new()
	parent_mob.gender = parent_gender
	parent_mob.age = AGE_MIDDLEAGED
	parent_mob.real_name = parent_name
	if(chosen_species_type)
		set_species_type(parent_mob, chosen_species_type)

	var/datum/family_member/parent_member = house.CreateCosmeticFamilyMember(parent_mob)
	if(!parent_member)
		return null
	parent_member.generation = parent_generation
	return parent_member

/datum/controller/subsystem/familytree/proc/GenerateCommonerParents(datum/heritage/house, datum/family_member/founder_member)
	if(!house || !founder_member?.person)
		return
	if(istype(founder_member.person, /mob/living/carbon/human/dummy))
		return
	if(founder_member.get_parent_members().len)
		return

	var/mob/living/carbon/human/founder_human = founder_member.person
	var/father_name = istext(founder_human.familytree_father_name) ? founder_human.familytree_father_name : ""
	var/mother_name = istext(founder_human.familytree_mother_name) ? founder_human.familytree_mother_name : ""
	var/father_species_name = istext(founder_human.familytree_father_species) ? founder_human.familytree_father_species : ""
	var/mother_species_name = istext(founder_human.familytree_mother_species) ? founder_human.familytree_mother_species : ""

	if(!length(father_name) && !length(mother_name))
		return

	var/default_species_type = founder_human.dna?.species?.type
	var/parent_generation = founder_member.generation - 1
	var/list/created_parents = list()

	var/datum/family_member/father_member = familytree_create_commoner_parent(house, father_name, father_species_name, MALE, default_species_type, parent_generation)
	if(father_member)
		created_parents += father_member

	var/datum/family_member/mother_member = familytree_create_commoner_parent(house, mother_name, mother_species_name, FEMALE, default_species_type, parent_generation)
	if(mother_member)
		created_parents += mother_member

	for(var/datum/family_member/parent_member as anything in created_parents)
		founder_member.AddParent(parent_member)

	if(father_member && mother_member)
		father_member.AddSpouse(mother_member)

/datum/controller/subsystem/familytree/proc/familytree_get_or_create_shared_parent(datum/heritage/house, datum/family_member/anchor_member)
	if(!house || !anchor_member)
		return null
	var/list/anchor_parents = anchor_member.get_parent_members()
	if(anchor_parents.len)
		return anchor_parents[1]
	var/datum/family_member/phantom = familytree_create_phantom_member(house, anchor_member.generation - 1)
	if(!phantom)
		return null
	if(!anchor_member.AddParent(phantom))
		house.RemoveFamilyMember(phantom)
		return null
	return phantom

/datum/controller/subsystem/familytree/proc/GenerateRandomSiblings(datum/heritage/house, datum/family_member/founder_member, count)
	if(!house || !founder_member?.person || count <= 0)
		return
	if(istype(founder_member.person, /mob/living/carbon/human/dummy))
		return

	var/mob/living/carbon/human/founder_human = founder_member.person
	var/datum/species/founder_species = founder_human.dna?.species
	var/species_type = founder_species?.type
	if(!species_type)
		return

	var/datum/family_member/shared_parent = familytree_get_or_create_shared_parent(house, founder_member)
	if(!shared_parent)
		return

	for(var/i in 1 to count)
		var/sibling_gender = prob(50) ? MALE : FEMALE
		var/sibling_name = founder_species.random_name(sibling_gender, TRUE) || "Unknown"

		var/mob/living/carbon/human/dummy/sibling = new()
		sibling.gender = sibling_gender
		sibling.age = founder_human.age
		sibling.real_name = sibling_name
		set_species_type(sibling, species_type)

		var/datum/family_member/sibling_member = house.CreateCosmeticFamilyMember(sibling)
		if(!sibling_member)
			qdel(sibling)
			continue
		sibling_member.generation = founder_member.generation
		sibling_member.adoption_status = TRUE
		if(!sibling_member.AddParent(shared_parent))
			house.RemoveFamilyMember(sibling_member)

/datum/controller/subsystem/familytree/proc/GenerateRandomChildren(datum/heritage/house, datum/family_member/founder_member, count)
	if(!house || !founder_member?.person || count <= 0)
		return
	if(istype(founder_member.person, /mob/living/carbon/human/dummy))
		return

	var/mob/living/carbon/human/founder_human = founder_member.person
	var/datum/species/founder_species = founder_human.dna?.species
	var/species_type = founder_species?.type
	if(!species_type)
		return

	for(var/i in 1 to count)
		var/child_gender = prob(50) ? MALE : FEMALE
		var/child_name = founder_species.random_name(child_gender, TRUE) || "Unknown"

		var/mob/living/carbon/human/dummy/child = new()
		child.gender = child_gender
		child.age = AGE_ADULT
		child.real_name = child_name
		set_species_type(child, species_type)

		var/datum/family_member/child_member = house.CreateCosmeticFamilyMember(child)
		if(!child_member)
			qdel(child)
			continue
		child_member.generation = founder_member.generation + 1
		child_member.adoption_status = TRUE
		if(!child_member.AddParent(founder_member))
			house.RemoveFamilyMember(child_member)

/datum/controller/subsystem/familytree/proc/GenerateRoyalName(gender, generation)
	var/list/male_names = list(
		"King" = list("Otto", "Arnulf", "Ludwig", "Henri", "Louis", "Francois"),
		"Prince" = list("Karl", "Konrad", "Heinrich", "Raoul", "Hugues")
	)
	var/list/female_names = list(
		"Queen" = list("Hildegard", "Freya", "Helga", "Jeanne", "Adeline"),
		"Princess" = list("Karoline", "Hedwig", "Anneliese", "Elise")
	)

	var/title
	var/list/names
	if(gender == MALE)
		title = generation > 2 ? "King" : "Prince"
		names = male_names[title]
	else
		title = generation > 2 ? "Queen" : "Princess"
		names = female_names[title]

	var/list/roman_numerals = list("I", "II", "III", "IV", "V")
	return "[title] [pick(names)] [pick(roman_numerals)]"
