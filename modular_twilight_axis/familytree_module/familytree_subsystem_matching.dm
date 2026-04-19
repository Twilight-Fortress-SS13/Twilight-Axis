/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	ftlog("AddLocal: [H?.real_name] ([H?.ckey]) status=[status]")
	if(!H || !status || istype(H, /mob/living/carbon/human/dummy))
		return

	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		pause_familytree_human(H, "local assignment blocked: dead")
		return
	if(block_reason == "no client")
		return
	if(block_reason)
		unsubscribe_familytree_human(H, "local assignment blocked: [block_reason]")
		return

	var/royal_status = get_royal_status(H)
	if(royal_status && royal_status != FAMILY_OMMER)
		ftlog("AddLocal SKIP: [H.real_name] royal flow")
		stop_tracking_human(H, "local assignment skipped; handled by royal flow")
		return
	if(is_royal_suitor_job(get_familytree_job(H)))
		ftlog("AddLocal SKIP: [H.real_name] suitor job")
		stop_tracking_human(H, "local assignment skipped; suitor job")
		return

	if(H.setspouse && length(H.setspouse))
		ftlog("AddLocal: [H.real_name] has favorite=[H.setspouse], trying favorite assign (retry #[H.familytree_setspouse_retries])")
		var/favorite_result = TryAssignToFavorite(H, status)
		if(favorite_result == "assigned")
			stop_tracking_human(H, "assigned via favorite")
			return
		if(favorite_result == "waiting")
			H.familytree_setspouse_retries++
			if(H.familytree_setspouse_retries >= 30 && !H.familytree_setspouse_timeout_offered)
				H.familytree_setspouse_timeout_offered = TRUE
				ftlog("AddLocal: [H.real_name] setspouse timeout reached (30 retries), offering reset")
				INVOKE_ASYNC(src, PROC_REF(offer_setspouse_reset), H, status)
				return
			ftlog("AddLocal: [H.real_name] favorite not found, waiting 60s")
			H.familytree_assignment_scheduled = TRUE
			addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, status), 60 SECONDS)
			return

	if(status == FAMILY_PARTIAL && H.desired_relative_role == RELATIVE_ANY && try_assign_noble_to_dynasty(H))
		return

	if(status == FAMILY_PARTIAL && H.desired_relative_role != RELATIVE_ANY)
		ftlog("AddLocal: [H.real_name] desired_role=[H.desired_relative_role], trying role assign")
		if(H.desired_relative_role == RELATIVE_SPOUSE)
			INVOKE_ASYNC(src, PROC_REF(find_and_confirm_family), H, FALSE)
		else
			var/forced_role = familytree_forced_role_from_relative_role(H.desired_relative_role)
			if(forced_role && !HasSuitableHouseForRelative(H, forced_role))
				wait_for_relative_house(H, "no suitable house for selected role")
				return
			request_family_confirmation(H, CALLBACK(src, PROC_REF(do_assign_desired_role), H), "house")
		return

	switch(status)
		if(FAMILY_PARTIAL)
			if(HasSuitableHouseForRelative(H))
				ftlog("AddLocal: [H.real_name] -> AssignToHouse (pending confirm)")
				request_family_confirmation(H, CALLBACK(src, PROC_REF(do_assign_house), H), "house")
			else
				ftlog("AddLocal: [H.real_name] → NO suitable house, trying to form sibling house")
				if(TryFormSiblingHouseFromPartial(H))
					return
				wait_for_relative_house(H, "no suitable house for relative")

		if(FAMILY_NEWLYWED)
			ftlog("AddLocal: [H.real_name] -> FindNewlyWedMatch")
			INVOKE_ASYNC(src, PROC_REF(find_and_confirm_newlywed), H)

		if(FAMILY_FULL)
			if(H.virginity)
				ftlog("AddLocal: [H.real_name] SKIP: virginity gate")
				stop_tracking_human(H, "full family flow skipped; virginity gate")
				return
			ftlog("AddLocal: [H.real_name] -> FindFamilyMatch")
			INVOKE_ASYNC(src, PROC_REF(find_and_confirm_family), H)

/datum/controller/subsystem/familytree/proc/do_assign_house(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.family_datum)
		return
	ftlog("do_assign_house: [H.real_name] confirmed, calling AssignToHouse")
	AssignToHouse(H)
	if(H.family_datum)
		to_chat(H, span_love("Вы успешно присоединились к семье!"))
		stop_tracking_human(H, "assigned to house")
	else
		retry_local_assignment(H, "no suitable house found after confirm")

/datum/controller/subsystem/familytree/proc/do_assign_desired_role(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.family_datum)
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason)
		retry_local_assignment(H, "desired role blocked: [block_reason]")
		return
	AssignWithDesiredRole(H)
	if(H.family_datum || H.spouse_mob)
		ftlog("AddLocal: [H.real_name] assigned via desired role")
		stop_tracking_human(H, "assigned via desired relative role")
	else
		retry_local_assignment(H, "no suitable family found for selected role")

/datum/controller/subsystem/familytree/proc/find_and_confirm_newlywed(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return
	if(H.family_datum)
		return
	if(!familytree_is_new_family_candidate(H))
		return
	if(H.spouse_mob && !familytree_can_have_multiple_spouses(H))
		return
	var/mob/living/carbon/human/spouse = FindNewlyWedMatch(H)
	if(!spouse)
		ftlog("AddLocal: [H.real_name] newlywed no match found")
		return
	ftlog("AddLocal: [H.real_name] newlywed match=[spouse.real_name], requesting mutual confirm")
	request_mutual_confirmation(H, spouse, CALLBACK(src, PROC_REF(do_execute_newlywed), H, spouse), "spouse")

/datum/controller/subsystem/familytree/proc/do_execute_newlywed(mob/living/carbon/human/H, mob/living/carbon/human/spouse)
	if(!H || QDELETED(H))
		return
	if(!spouse || QDELETED(spouse))
		retry_local_assignment(H, "spouse unavailable after confirm")
		return
	if(H.family_datum || spouse.family_datum)
		retry_local_assignment(H, "new family spouse already has a family")
		return
	if(!familytree_new_family_pair_eligible(H, spouse))
		retry_local_assignment(H, "spouse no longer wants to create a new family")
		return
	if(!familytree_polygamy_compatible(H, spouse))
		retry_local_assignment(H, "spouse already married")
		return
	ftlog("AddLocal: [H.real_name] + [spouse.real_name] -> MarryTo (both confirmed)")
	viable_spouses -= H
	viable_spouses -= spouse
	var/mob/living/carbon/human/founder = familytree_new_family_founder(H, spouse)
	var/mob/living/carbon/human/partner = founder == H ? spouse : H
	var/datum/heritage/family = founder.MarryTo(partner)
	if(family)
		family.closed = FALSE
		if(!family.house_leader)
			family.house_leader = founder.family_member_datum || family.founder
		on_family_formed(family)
		wake_waiting_relative_seekers(family)
		familytree_admin_log_house_assignment(H, family, "created new house with spouse [key_name(spouse)]", spouse.family_member_datum)
		familytree_admin_log_house_assignment(spouse, family, "created new house with spouse [key_name(H)]", H.family_member_datum)
	introduce_pair(H, spouse)
	bestow_wedding_rings(H, spouse)
	stop_tracking_human(H, "newlywed flow matched spouse")
	stop_tracking_human(spouse, "newlywed flow matched spouse")

/datum/controller/subsystem/familytree/proc/find_and_confirm_family(mob/living/carbon/human/H, create_if_no_match = TRUE)
	if(!H || QDELETED(H) || H.family_datum)
		return
	var/list/match = FindFamilyMatch(H)
	if(!match)
		if(!create_if_no_match)
			ftlog("AddLocal: [H.real_name] family no match found, waiting for a family founder")
			wait_for_new_family_founder(H)
			return
		ftlog("AddLocal: [H.real_name] family no match found, creating new house")
		var/datum/heritage/new_house = new /datum/heritage(H, null)
		register_family(new_house)
		ftlog("AddLocal: [H.real_name] founded new house '[new_house.housename]'")
		familytree_admin_log_house_assignment(H, new_house, "created new house; no compatible family match")
		stop_tracking_human(H, "founded new house (no match)")
		return
	var/datum/heritage/house = match[1]
	var/datum/family_member/partner_member = match[2]
	var/mob/living/carbon/human/partner = partner_member?.person
	if(!partner)
		return
	ftlog("AddLocal: [H.real_name] family match=[partner.real_name] in house=[house.housename], requesting mutual confirm")
	request_mutual_confirmation(H, partner, CALLBACK(src, PROC_REF(do_execute_family), H, house, partner_member), "family")

/datum/controller/subsystem/familytree/proc/do_execute_family(mob/living/carbon/human/H, datum/heritage/house, datum/family_member/partner_member)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!house || !partner_member?.person)
		retry_local_assignment(H, "partner lost")
		return
	if(!familytree_polygamy_compatible(H, partner_member.person))
		retry_local_assignment(H, "partner already married")
		return
	ftlog("AddLocal: [H.real_name] -> AssignToFamily in house=[house.housename] (both confirmed)")
	var/datum/family_member/new_member = house.CreateFamilyMember(H)
	if(new_member)
		house.MarryMembers(new_member, partner_member)
		on_family_formed(house)
		introduce_pair(H, partner_member.person)
		bestow_wedding_rings(H, partner_member.person)
	if(H.family_datum)
		familytree_admin_log_house_assignment(H, house, "joined existing house as spouse of [key_name(partner_member.person)]", partner_member)
		stop_tracking_human(H, "assigned to family")
	else
		retry_local_assignment(H, "family assignment failed")

/datum/controller/subsystem/familytree/proc/TryAssignToFavorite(mob/living/carbon/human/H, status)
	if(!H?.setspouse || !length(H.setspouse))
		ftlog("TryFavorite SKIP: [H?.real_name] no setspouse")
		return "skip"

	ftlog("TryFavorite: [H.real_name] looking for '[H.setspouse]'")
	var/mob/living/carbon/human/favorite = FindFavoriteMob(H)

	if(!favorite)
		ftlog("TryFavorite: [H.real_name] favorite NOT FOUND, waiting")
		return "waiting"

	ftlog("TryFavorite: [H.real_name] found favorite=[favorite.real_name] ([favorite.ckey])")

	if(favorite.setspouse && length(favorite.setspouse))
		if(!familytree_names_match(favorite.setspouse, H.real_name))
			return "waiting"

	var/mutual_sibling = (H.desired_relative_role == RELATIVE_SIBLING && favorite.desired_relative_role == RELATIVE_SIBLING)

	if(mutual_sibling)
		ftlog("TryFavorite: [H.real_name] + [favorite.real_name] mutual sibling -> mutual confirm")
		request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_form_sibling_house), H, favorite), "sibling_house")
		return "assigned"

	if(favorite.family_datum)
		var/datum/heritage/house = favorite.family_datum
		if(status == FAMILY_NEWLYWED)
			ftlog("TryFavorite: [H.real_name] favorite [favorite.real_name] already has a family; new-family mode will wait")
			return "waiting"
		if(status == FAMILY_PARTIAL && H.desired_relative_role == RELATIVE_SPOUSE)
			if(!familytree_polygamy_compatible(H, favorite))
				return "skip"
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_family), H, house, favorite.family_member_datum), "family")
			return "assigned"
		if(status == FAMILY_FULL)
			var/favorite_has_dummy_spouse = FALSE
			var/list/favorite_spouses = favorite.family_member_datum?.get_spouse_members()
			if(favorite_spouses?.len)
				var/datum/family_member/existing_spouse_member = favorite_spouses[1]
				if(existing_spouse_member?.person && istype(existing_spouse_member.person, /mob/living/carbon/human/dummy))
					favorite_has_dummy_spouse = TRUE
			if(!favorite_has_dummy_spouse && !familytree_polygamy_compatible(H, favorite))
				return "skip"
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_family), H, house, favorite.family_member_datum), "family")
		else
			request_family_confirmation(H, CALLBACK(src, PROC_REF(do_assign_to_favorite_house), H, house), "house")
		return "assigned"

	if(status == FAMILY_NEWLYWED || (status == FAMILY_PARTIAL && H.desired_relative_role == RELATIVE_SPOUSE) || status == FAMILY_FULL)
		if(!familytree_new_family_pair_eligible(H, favorite))
			return "waiting"
		if(!familytree_polygamy_compatible(H, favorite))
			return "skip"
		request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_newlywed), H, favorite), "spouse")
		return "assigned"

	return "waiting"

/datum/controller/subsystem/familytree/proc/do_assign_to_favorite_house(mob/living/carbon/human/H, datum/heritage/house)
	if(!H || QDELETED(H) || H.family_datum || !house)
		return
	var/forced_role = familytree_forced_role_from_relative_role(H.desired_relative_role)
	if(forced_role)
		AddPersonToHouse(house, H, FALSE, forced_role)
	else
		house.CreateFamilyMember(H)
	if(H.family_datum)
		var/favorite_role = forced_role ? forced_role : "direct member"
		familytree_admin_log_house_assignment(H, house, "joined favorite house as [favorite_role]")
		to_chat(H, span_love("Вы успешно присоединились к семье!"))
		stop_tracking_human(H, "assigned to favorite house")
	else
		retry_local_assignment(H, "favorite house assignment failed")

/datum/controller/subsystem/familytree/proc/FindFavoriteMob(mob/living/carbon/human/H)
	if(!H?.setspouse)
		return null

	for(var/datum/heritage/house as anything in families)
		for(var/datum/family_node/node as anything in house.member_nodes)
			if(node.person && familytree_names_match(node.person.real_name, H.setspouse))
				return node.person

	for(var/mob/living/carbon/human/candidate as anything in viable_spouses)
		if(candidate == H)
			continue
		if(familytree_names_match(candidate.real_name, H.setspouse))
			return candidate

	for(var/mob/living/carbon/human/candidate in GLOB.alive_mob_list)
		if(candidate == H)
			continue
		if(!candidate.client || candidate.stat == DEAD)
			continue
		if(candidate.familytree_pref == FAMILY_NONE)
			continue
		if(familytree_names_match(candidate.real_name, H.setspouse))
			return candidate

	return null

/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H, forced_role = null)
	if(!H)
		return
	ftlog("AssignToHouse START: [H.real_name] race=[H.dna?.species?.name] isolated=[is_isolated(H)] pref=[H.familytree_pref]")

	var/our_race = H.dna.species.name
	var/we_are_isolated = is_isolated(H)

	var/list/candidates = list()
	var/reject_mask = 0

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			reject_mask |= FTREJ_H_CLOSED
			continue
		if(!house.housename || house.housename == "no name")
			reject_mask |= FTREJ_H_NONAME
			continue
		if(!house_allows_relatives(house))
			reject_mask |= FTREJ_H_RELATIVES
			continue
		if(!house_race_compatible(house, our_race, we_are_isolated))
			reject_mask |= FTREJ_H_RACE
			continue
		if(!forced_role && WouldCreateAgeConflict(house, H))
			reject_mask |= FTREJ_H_AGE
			continue
		if(house.member_nodes.len < 1)
			reject_mask |= FTREJ_H_EMPTY
			continue
		if(!house_has_online_member(house))
			reject_mask |= FTREJ_H_OFFLINE
			continue
		if(!familytree_house_supports_role(house, H, forced_role))
			reject_mask |= FTREJ_H_AGE
			continue

		candidates += house

	ftlog("AssignToHouse REJECTS [H.real_name]: mask=[reject_mask] ([ftreject_decode_house(reject_mask)]) -> candidates=[candidates.len]", FTLOG_DEBUG)

	if(candidates.len)
		var/datum/heritage/chosen_house = pick_weighted_house(candidates, forced_role)
		ftlog("AssignToHouse: [H.real_name] → JOINED existing house '[chosen_house.housename || "no name"]' (members=[chosen_house.member_nodes.len])")
		var/assigned_role = forced_role || DetermineAppropriateRole(chosen_house, H)
		AddPersonToHouse(chosen_house, H, FALSE, assigned_role)
		if(H.family_datum)
			var/assigned_role_text = assigned_role || "relative"
			familytree_admin_log_house_assignment(H, chosen_house, "joined existing house as [assigned_role_text]")
			stop_tracking_human(H, "assigned to house")
		else
			ftlog("AssignToHouse: [H.real_name] selected house did not accept assigned_role=[assigned_role]", FTLOG_WARN)
	else
		ftlog("AssignToHouse: [H.real_name] → NO suitable existing house found. Staying without family.", FTLOG_WARN)

/datum/controller/subsystem/familytree/proc/AddPersonToHouse(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE, forced_role = null)
	var/role = forced_role || DetermineAppropriateRole(house, person, adopted)

	switch(role)
		if("child")
			var/list/potential_parents = list()
			for(var/datum/family_member/member as anything in house.members)
				if(member.person && CanBeParentOf(member.person, person))
					potential_parents += member

			var/datum/family_member/parent1
			var/datum/family_member/parent2
			var/best_pair_score = -100000

			for(var/i = 1 to potential_parents.len)
				var/datum/family_member/candidate1 = potential_parents[i]
				if(!candidate1?.person)
					continue

				for(var/j = i + 1 to potential_parents.len)
					var/datum/family_member/candidate2 = potential_parents[j]
					if(!candidate2?.person)
						continue
					if(house.SpeciesCalculation(person, candidate1.person, candidate2.person))
						var/pair_score = familytree_parent_candidate_score(candidate1) + familytree_parent_candidate_score(candidate2)
						if(pair_score <= best_pair_score)
							continue
						parent1 = candidate1
						parent2 = candidate2
						best_pair_score = pair_score

			if(!parent1)
				parent1 = familytree_best_parent_member(house, person)
			if(parent1 && !parent2)
				parent2 = familytree_best_parent_member(house, person, parent1)
				if(parent2 && !house.SpeciesCalculation(person, parent1.person, parent2.person) && house.SingleParentSpeciesCalculation(person, parent1.person))
					parent2 = null
			if(!parent1 && !parent2)
				return FALSE

			return house.AddToFamily(person, parent1, parent2, adopted)

		if("sibling")
			var/datum/family_member/member = familytree_best_sibling_member(house, person)
			if(!member)
				return FALSE
			var/list/member_parents = member.get_parent_members()
			var/datum/family_member/parent1 = member_parents.len > 0 ? member_parents[1] : null
			var/datum/family_member/parent2 = member_parents.len > 1 ? member_parents[2] : null
			return house.AddToFamily(person, parent1, parent2, adopted)

		if("parent")
			var/datum/family_member/child_member = familytree_best_child_member_for_parent(house, person)
			if(!child_member)
				return FALSE
			var/datum/family_member/new_member = house.CreateFamilyMember(person)
			if(!new_member)
				return FALSE
			if(!child_member.AddParent(new_member))
				house.RemoveFamilyMember(new_member)
				return FALSE
			if(!house.founder)
				house.founder = new_member
				new_member.generation = 0
			if(!house.housename)
				house.housename = house.SurnameFormatting(person)
			return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_forced_role_from_relative_role(relative_role)
	switch(relative_role)
		if(RELATIVE_SIBLING)
			return "sibling"
		if(RELATIVE_PARENT)
			return "parent"
		if(RELATIVE_CHILD)
			return "child"
	return null

/datum/controller/subsystem/familytree/proc/familytree_member_attachment_load(datum/family_member/member)
	if(!member)
		return 1000
	return member.get_parent_members().len + member.get_child_members().len + member.get_spouse_members().len

/datum/controller/subsystem/familytree/proc/familytree_parent_candidate_score(datum/family_member/member)
	if(!member?.person)
		return -100000
	var/score = 100
	score -= member.get_child_members().len * 10
	score -= member.get_parent_members().len
	score -= member.get_spouse_members().len
	if(member.person.familytree_pref == FAMILY_NEWLYWED && member.person.desired_relative_role == RELATIVE_PARENT)
		score += 100
	return score

/datum/controller/subsystem/familytree/proc/familytree_sibling_candidate_score(datum/family_member/member)
	if(!member?.person)
		return -100000
	var/score = 100 - familytree_member_attachment_load(member)
	if(member.person.familytree_pref == FAMILY_NEWLYWED && member.person.desired_relative_role == RELATIVE_SIBLING)
		score += 100
	return score

/datum/controller/subsystem/familytree/proc/familytree_child_candidate_score(datum/family_member/member)
	if(!member?.person)
		return -100000
	var/score = 100
	score -= member.get_parent_members().len * 50
	score -= member.get_child_members().len
	score -= member.get_spouse_members().len
	if(member.person.familytree_pref == FAMILY_NEWLYWED && member.person.desired_relative_role == RELATIVE_CHILD)
		score += 100
	return score

/datum/controller/subsystem/familytree/proc/familytree_best_parent_member(datum/heritage/house, mob/living/carbon/human/child, datum/family_member/exclude = null)
	if(!house || !child)
		return null
	var/datum/family_member/best
	var/best_score = -100000
	for(var/datum/family_member/member as anything in house.members)
		if(member == exclude || !member?.person)
			continue
		if(!CanBeParentOf(member.person, child))
			continue
		var/score = familytree_parent_candidate_score(member)
		if(house.SingleParentSpeciesCalculation(child, member.person))
			score += 20
		if(score > best_score)
			best = member
			best_score = score
	return best

/datum/controller/subsystem/familytree/proc/familytree_best_sibling_member(datum/heritage/house, mob/living/carbon/human/person)
	if(!house || !person)
		return null
	var/datum/family_member/best
	var/best_score = -100000
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person)
			continue
		if(!CanBeSiblings(member.person.age, person.age))
			continue
		var/score = familytree_sibling_candidate_score(member)
		if(score > best_score)
			best = member
			best_score = score
	return best

/datum/controller/subsystem/familytree/proc/familytree_best_child_member_for_parent(datum/heritage/house, mob/living/carbon/human/parent)
	if(!house || !parent)
		return null
	var/datum/family_member/best
	var/best_score = -100000
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person)
			continue
		if(member.get_parent_members().len >= 2)
			continue
		if(!CanBeParentOf(parent, member.person))
			continue
		var/score = familytree_child_candidate_score(member)
		if(score > best_score)
			best = member
			best_score = score
	return best

/datum/controller/subsystem/familytree/proc/familytree_house_supports_role(datum/heritage/house, mob/living/carbon/human/person, forced_role)
	if(!house || !person)
		return FALSE
	if(!forced_role)
		return DetermineAppropriateRole(house, person) ? TRUE : FALSE
	switch(forced_role)
		if("child")
			return familytree_best_parent_member(house, person) ? TRUE : FALSE
		if("sibling")
			return familytree_best_sibling_member(house, person) ? TRUE : FALSE
		if("parent")
			return familytree_best_child_member_for_parent(house, person) ? TRUE : FALSE
	return TRUE

/datum/controller/subsystem/familytree/proc/AssignToFamily(mob/living/carbon/human/H)
	if(!H)
		return
	ftlog("AssignToFamily: [H.real_name] species=[H.dna?.species?.name] isolated=[is_isolated(H)]")
	var/our_race = H.dna.species.name
	var/our_isolated = is_isolated(H)
	var/list/eligible_houses = list()

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			continue
		if(!house_race_compatible(house, our_race, our_isolated))
			continue

		var/has_single_adult = FALSE
		for(var/datum/family_member/member as anything in house.members)
			if(member.person && familytree_polygamy_compatible(H, member.person))
				if(!member.person.client)
					continue
				if(!member.person.setspouse || familytree_names_match(member.person.setspouse, H.real_name))
					if(!pronouns_compatible(H, member.person))
						continue
					if(GetSpeciesCompatibilityFailureReason(H, member.person))
						continue
					if(!familytree_estates_compatible(H, member.person))
						continue
					if(!familytree_role_tiers_compatible(H, member.person))
						continue
					if(member.person.familytree_pref == FAMILY_PARTIAL)
						continue
					has_single_adult = TRUE
					eligible_houses += house
					break

		if(!has_single_adult && !house.housename)
			eligible_houses += house

	ftlog("AssignToFamily: [H.real_name] eligible_houses=[eligible_houses.len]")
	if(!eligible_houses.len)
		ftlog("AssignToFamily: [H.real_name] no eligible houses, creating new")
		var/datum/heritage/new_house = new /datum/heritage(H, null)
		register_family(new_house)
		ftlog("AssignToFamily: [H.real_name] founded new house '[new_house.housename]'")
		familytree_admin_log_house_assignment(H, new_house, "created new house; spouse role found no eligible house")
		return

	for(var/datum/heritage/house as anything in eligible_houses)
		for(var/datum/family_member/member as anything in house.members)
			if(member.person && familytree_polygamy_compatible(H, member.person))
				if(!member.person.client)
					continue
				if(!member.person.setspouse || familytree_names_match(member.person.setspouse, H.real_name))
					if(pronouns_compatible(H, member.person) && SpeciesCompatible(H, member.person) && familytree_estates_compatible(H, member.person) && familytree_role_tiers_compatible(H, member.person))
						var/datum/family_member/new_member = house.CreateFamilyMember(H)
						if(new_member)
							house.MarryMembers(new_member, member)
							on_family_formed(house)
							familytree_admin_log_house_assignment(H, house, "joined existing house as spouse of [key_name(member.person)]", member)
							return

		if(!house.housename)
			var/datum/family_member/new_member = house.CreateFamilyMember(H)
			if(new_member)
				house.founder = new_member
				new_member.generation = 0
				house.housename = house.SurnameFormatting(H)
				familytree_admin_log_house_assignment(H, house, "founded unnamed eligible house")
				return

/datum/controller/subsystem/familytree/proc/familytree_is_new_family_candidate(mob/living/carbon/human/H)
	if(!H || H.family_datum)
		return FALSE
	if(H.familytree_pref == FAMILY_NEWLYWED)
		return TRUE
	if(H.familytree_pref == FAMILY_PARTIAL && H.desired_relative_role == RELATIVE_SPOUSE)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_new_family_pair_eligible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!familytree_is_new_family_candidate(A) || !familytree_is_new_family_candidate(B))
		return FALSE
	var/a_creates = A.familytree_pref == FAMILY_NEWLYWED
	var/b_creates = B.familytree_pref == FAMILY_NEWLYWED
	if(a_creates && b_creates)
		return TRUE
	if(a_creates && B.familytree_pref == FAMILY_PARTIAL && B.desired_relative_role == RELATIVE_SPOUSE)
		return TRUE
	if(b_creates && A.familytree_pref == FAMILY_PARTIAL && A.desired_relative_role == RELATIVE_SPOUSE)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_new_family_founder(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(B?.familytree_pref == FAMILY_NEWLYWED && A?.familytree_pref != FAMILY_NEWLYWED)
		return B
	return A

/datum/controller/subsystem/familytree/proc/wait_for_new_family_founder(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!familytree_is_new_family_candidate(H))
		return
	if(!(H in viable_spouses))
		viable_spouses += H
	INVOKE_ASYNC(src, PROC_REF(find_and_confirm_newlywed), H)

/datum/controller/subsystem/familytree/proc/FindNewlyWedMatch(mob/living/carbon/human/H)
	if(!H)
		return null
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason)
		return null
	if(H.family_datum || !familytree_is_new_family_candidate(H))
		return null
	if(!(H in viable_spouses))
		viable_spouses += H

	var/reject_mask = 0
	var/list/potential_matches = list()
	for(var/mob/living/carbon/human/candidate as anything in viable_spouses)
		if(!candidate || candidate == H)
			continue
		if(candidate.family_datum || !familytree_new_family_pair_eligible(H, candidate))
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(!familytree_polygamy_compatible(H, candidate))
			reject_mask |= FTREJ_N_POLY
			continue
		if(candidate.familytree_opted_out)
			reject_mask |= FTREJ_N_OPTOUT
			continue
		var/cand_block = get_familytree_runtime_block_reason(candidate, TRUE)
		if(cand_block)
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(!pronouns_compatible(H, candidate))
			reject_mask |= FTREJ_N_PRONOUNS
			continue
		if(GetSpeciesCompatibilityFailureReason(H, candidate))
			reject_mask |= FTREJ_N_SPECIES
			continue
		if(!familytree_estates_compatible(H, candidate))
			reject_mask |= FTREJ_N_ESTATE
			continue
		if(!familytree_role_tiers_compatible(H, candidate))
			reject_mask |= FTREJ_N_TIER
			continue
		if(candidate.setspouse && length(candidate.setspouse))
			if(!familytree_names_match(candidate.setspouse, H.real_name))
				reject_mask |= FTREJ_N_SETSPOUSE
				continue
		var/priority = 0
		if(familytree_names_match(candidate.setspouse, H.real_name))
			priority = 1
		potential_matches += list(list(candidate, priority))

	ftlog("FindNewlyWedMatch REJECTS [H.real_name] (pool=[viable_spouses.len]): mask=[reject_mask] ([ftreject_decode_newlywed(reject_mask)]) -> matches=[potential_matches.len]", FTLOG_DEBUG)

	if(!potential_matches.len)
		return null

	var/best_priority = -1
	var/list/best_matches = list()
	for(var/list/match_data in potential_matches)
		var/match_priority = match_data[2]
		if(match_priority > best_priority)
			best_priority = match_priority
			best_matches = list(match_data[1])
		else if(match_priority == best_priority)
			best_matches += match_data[1]

	if(!best_matches.len)
		return null
	return pick(best_matches)

/datum/controller/subsystem/familytree/proc/FindFamilyMatch(mob/living/carbon/human/H)
	if(!H)
		return null
	var/our_race = H.dna.species.name
	var/our_isolated = is_isolated(H)
	var/houses_scanned = 0
	var/reject_mask = 0

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			reject_mask |= FTREJ_F_CLOSED
			continue
		if(!house_race_compatible(house, our_race, our_isolated))
			reject_mask |= FTREJ_F_RACE
			continue
		houses_scanned++
		for(var/datum/family_member/member as anything in house.members)
			if(!member.person)
				continue
			if(!familytree_polygamy_compatible(H, member.person))
				reject_mask |= FTREJ_F_POLY
				continue
			if(!member.person.client)
				reject_mask |= FTREJ_F_OFFLINE
				continue
			if(member.person.setspouse && !familytree_names_match(member.person.setspouse, H.real_name))
				reject_mask |= FTREJ_F_SETSPOUSE
				continue
			if(!pronouns_compatible(H, member.person))
				reject_mask |= FTREJ_F_PRONOUNS
				continue
			if(GetSpeciesCompatibilityFailureReason(H, member.person))
				reject_mask |= FTREJ_F_SPECIES
				continue
			if(!familytree_estates_compatible(H, member.person))
				reject_mask |= FTREJ_F_ESTATE
				continue
			if(!familytree_role_tiers_compatible(H, member.person))
				reject_mask |= FTREJ_F_TIER
				continue
			if(member.person.familytree_pref == FAMILY_PARTIAL)
				reject_mask |= FTREJ_F_PARTIAL
				continue
			if(member.person.familytree_opted_out)
				reject_mask |= FTREJ_F_OPTOUT
				continue
			ftlog("FindFamilyMatch [H.real_name] -> [member.person.real_name] in '[house.housename]' (scanned=[houses_scanned]h)", FTLOG_DEBUG)
			return list(house, member)
	ftlog("FindFamilyMatch REJECTS [H.real_name] (houses=[families.len]): mask=[reject_mask] ([ftreject_decode_family(reject_mask)]) -> no_match", FTLOG_WARN)
	return null

/datum/controller/subsystem/familytree/proc/AssignNewlyWed(mob/living/carbon/human/H)
	if(!H)
		return
	find_and_confirm_newlywed(H)

/datum/controller/subsystem/familytree/proc/AssignAuntUncle(mob/living/carbon/human/H)
	var/base_species = H.dna.species.name
	var/base_isolated = is_isolated(H)
	var/datum/heritage/chosen_house

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			continue
		if(!house_race_compatible(house, base_species, base_isolated))
			continue
		if(!house.housename || house.member_nodes.len < 2)
			continue

		var/has_compatible_parent = FALSE
		for(var/datum/family_member/member as anything in house.members)
			if(member.get_child_members().len > 0 && member.person?.client)
				if(!GetSpeciesCompatibilityFailureReason(H, member.person))
					has_compatible_parent = TRUE
					break

		if(has_compatible_parent && !WouldCreateAgeConflict(house, H))
			chosen_house = house
			break

	if(chosen_house)
		var/datum/family_member/new_member = chosen_house.CreateFamilyMember(H)
		if(new_member)
			for(var/datum/family_member/member as anything in chosen_house.members)
				if(member.get_child_members().len > 0 && member.person && CanBeSiblings(H.age, member.person.age))
					for(var/datum/family_member/grandparent as anything in member.get_parent_members())
						new_member.AddParent(grandparent)
					break
			familytree_admin_log_house_assignment(H, chosen_house, "joined existing house as uncle/aunt")

/datum/controller/subsystem/familytree/proc/do_form_sibling_house(mob/living/carbon/human/initiator, mob/living/carbon/human/partner)
	if(!initiator || QDELETED(initiator) || initiator.family_datum)
		return
	if(!partner || QDELETED(partner) || partner.family_datum)
		return

	var/datum/heritage/new_house = new /datum/heritage(initiator, null)
	new_house.closed = TRUE
	new_house.house_leader = new_house.founder
	register_family(new_house)

	var/datum/family_member/phantom_parent = new /datum/family_member(null, new_house)
	phantom_parent.generation = -1
	phantom_parent.phantom = TRUE
	new_house.members += phantom_parent
	new_house.founder.AddParent(phantom_parent)

	var/datum/family_member/partner_member = new_house.CreateFamilyMember(partner)
	if(partner_member)
		partner_member.generation = 1
		partner_member.AddParent(phantom_parent)

	introduce_pair(initiator, partner)
	ftlog("SIBLING HOUSE: [initiator.real_name] + [partner.real_name] formed closed house '[new_house.housename]', leader=[initiator.real_name]")
	on_family_formed(new_house)
	familytree_admin_log_house_assignment(initiator, new_house, "formed sibling house with [key_name(partner)]", partner_member)
	familytree_admin_log_house_assignment(partner, new_house, "joined sibling house with [key_name(initiator)]", new_house.founder)

	to_chat(initiator, span_love("Вы основали дом [new_house.housename]!"))
	to_chat(partner, span_love("Вы вступили в дом [new_house.housename]."))

	stop_tracking_human(initiator, "formed sibling house")
	stop_tracking_human(partner, "joined sibling house")

	ask_open_sibling_house(initiator, new_house)

/datum/controller/subsystem/familytree/proc/ask_open_sibling_house(mob/living/carbon/human/leader, datum/heritage/house)
	if(!leader?.client)
		return
	INVOKE_ASYNC(src, PROC_REF(do_ask_open_sibling_house), leader, house)

/datum/controller/subsystem/familytree/proc/do_ask_open_sibling_house(mob/living/carbon/human/leader, datum/heritage/house)
	if(!leader?.client)
		return

	var/result = tgui_alert(leader, "Открыть дом [house.housename] для вступления родственников?", "Дом [house.housename]", list("Да", "Нет"))

	if(!leader || QDELETED(leader))
		return
	if(!house)
		return

	if(result == "Да")
		house.closed = FALSE
		ftlog("SIBLING HOUSE: [leader.real_name] opened house '[house.housename]' for relatives")
		to_chat(leader, span_notice("Дом [house.housename] открыт для родственников."))
	else
		ftlog("SIBLING HOUSE: [leader.real_name] kept house '[house.housename]' closed")
		to_chat(leader, span_notice("Дом [house.housename] останется закрытым. Вступить можно только через обряд жреца."))

/datum/controller/subsystem/familytree/proc/HasSuitableHouseForRelative(mob/living/carbon/human/H, forced_role = null)
	if(!H)
		return FALSE

	var/our_race = H.dna.species.name
	var/we_are_isolated = is_isolated(H)

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			continue
		if(!house.housename || house.housename == "no name")
			continue
		if(!house_allows_relatives(house))
			continue
		if(!house_race_compatible(house, our_race, we_are_isolated))
			continue
		if(!forced_role && WouldCreateAgeConflict(house, H))
			continue
		if(!familytree_house_supports_role(house, H, forced_role))
			continue
		if(house.member_nodes.len >= 1 && house_has_online_member(house))
			return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/TryFormSiblingHouseFromPartial(mob/living/carbon/human/H)
	if(!H || H.family_datum)
		return FALSE

	for(var/mob/living/carbon/human/candidate as anything in GLOB.alive_mob_list)
		if(candidate == H || !candidate.client || candidate.stat == DEAD || candidate.familytree_pref != FAMILY_PARTIAL || candidate.family_datum)
			continue
		if(!pronouns_compatible(H, candidate))
			continue
		if(GetSpeciesCompatibilityFailureReason(H, candidate))
			continue
		if(!familytree_estates_compatible(H, candidate))
			continue
		if(!familytree_role_tiers_compatible(H, candidate))
			continue
		if(!CanBeSiblings(H.age, candidate.age))
			continue

		ftlog("TryFormSiblingHouseFromPartial: [H.real_name] + [candidate.real_name] → forming sibling house")
		request_mutual_confirmation(H, candidate, CALLBACK(src, PROC_REF(do_form_sibling_house), H, candidate), "sibling_house")
		return TRUE

	ftlog("TryFormSiblingHouseFromPartial: [H.real_name] → no mutual sibling found")

	return FALSE

/datum/controller/subsystem/familytree/proc/house_has_online_member(datum/heritage/house)
	if(!house)
		return FALSE
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(node.person?.client)
			return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/count_online_members(datum/heritage/house)
	if(!house)
		return 0
	var/online_count = 0
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(node.person?.client)
			online_count++
	return online_count

/datum/controller/subsystem/familytree/proc/pick_weighted_house(list/candidates, forced_role = null)
	if(!candidates.len)
		return null
	if(candidates.len == 1)
		return candidates[1]
	var/total_weight = 0
	var/list/weights = list()
	for(var/datum/heritage/house as anything in candidates)
		var/online_count = count_online_members(house)
		var/weight = 1
		if(online_count >= 2 && online_count < 4)
			weight = 5
		else if(online_count == 1)
			weight = 2
		var/member_bias = max(1, 8 - min(house.member_nodes.len, 7))
		if(forced_role)
			weight += member_bias
		else if(house.member_nodes.len <= 2)
			weight += 2
		weights[house] = weight
		total_weight += weight
	var/roll = rand(1, total_weight)
	var/cumulative = 0
	for(var/datum/heritage/house as anything in weights)
		cumulative += weights[house]
		if(roll <= cumulative)
			return house
	return candidates[candidates.len]

/datum/controller/subsystem/familytree/proc/bestow_wedding_rings(mob/living/carbon/human/A, mob/living/carbon/human/B)
	give_wedding_ring(A)
	give_wedding_ring(B)

/datum/controller/subsystem/familytree/proc/give_wedding_ring(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || !ishuman(H))
		return
	if(istype(H, /mob/living/carbon/human/dummy))
		return
	if(H.mind)
		H.mind.special_items["Silver wedding ring"] = /obj/item/clothing/ring/band
		to_chat(H, span_love("Серебряное свадебное кольцо добавлено в ваш стеш в знак союза."))
		return
	var/obj/item/clothing/ring/band/ring = new(H)
	ring.forceMove(get_turf(H))
	to_chat(H, span_love("Серебряное свадебное кольцо упало у ваших ног в знак союза."))

/datum/controller/subsystem/familytree/proc/house_allows_relatives(datum/heritage/house)
	if(!house)
		return FALSE
	if(!house.house_leader?.person)
		return TRUE
	var/mob/living/carbon/human/leader = house.house_leader.person
	if(!leader.setspouse || !length(leader.setspouse))
		return TRUE
	return leader.allow_relatives_in_family

/datum/controller/subsystem/familytree/proc/wait_for_relative_house(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum || H.familytree_opted_out)
		return
	if(H.familytree_assignment_scheduled)
		ftlog("WAIT_RELATIVE SKIP: [H.real_name] already scheduled reason=[reason]")
		return
	ftlog("WAIT_RELATIVE: [H.real_name] reason=[reason], scheduling re-assignment in 20s")
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 20 SECONDS)

/datum/controller/subsystem/familytree/proc/wake_waiting_relative_seekers(datum/heritage/house)
	if(!house || house.closed)
		return
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H?.client || H.family_datum || H.familytree_pref != FAMILY_PARTIAL)
			continue
		if(!H.familytree_module_signal_bound || !H.familytree_assignment_scheduled)
			continue
		addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 1 SECONDS)

/datum/controller/subsystem/familytree/proc/retry_local_assignment(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum || H.familytree_opted_out)
		return
	if(H.familytree_assignment_scheduled)
		ftlog("RETRY SKIP: [H.real_name] already scheduled reason=[reason]")
		return
	ftlog("RETRY: [H.real_name] reason=[reason], scheduling re-assignment in 10s")
	to_chat(H, span_warning("Не удалось найти подходящую семью. Система попробует снова."))
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 10 SECONDS)

/datum/controller/subsystem/familytree/proc/introduce_pair(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return
	if(A.mind && B.mind)
		A.mind.i_know_person(B)
		B.mind.i_know_person(A)
		fix_family_fjob(A, B)
		fix_family_fjob(B, A)
	else
		addtimer(CALLBACK(src, PROC_REF(delayed_introduce_pair), A, B), 3 SECONDS)

/datum/controller/subsystem/familytree/proc/delayed_introduce_pair(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || QDELETED(A) || !B || QDELETED(B))
		return
	if(A.mind && B.mind)
		A.mind.i_know_person(B)
		B.mind.i_know_person(A)
		fix_family_fjob(A, B)
		fix_family_fjob(B, A)

/datum/controller/subsystem/familytree/proc/fix_family_fjob(mob/living/carbon/human/knower, mob/living/carbon/human/known)
	if(!knower?.mind?.known_people || !known?.mind)
		return
	var/list/info = knower.mind.known_people[known.real_name]
	if(!info)
		return
	if(LAZYLEN(known.mind.antag_datums))
		info["FJOB"] = "Adventurer"

// --- Reject-mask decoders (log-time only, not on hot path) ---

/proc/ftreject_decode_house(mask)
	if(!mask)
		return "none"
	var/list/parts = list()
	if(mask & FTREJ_H_CLOSED)    parts += "closed"
	if(mask & FTREJ_H_NONAME)    parts += "noname"
	if(mask & FTREJ_H_RELATIVES) parts += "no_relatives"
	if(mask & FTREJ_H_RACE)      parts += "race"
	if(mask & FTREJ_H_AGE)       parts += "age"
	if(mask & FTREJ_H_EMPTY)     parts += "empty"
	if(mask & FTREJ_H_OFFLINE)   parts += "offline"
	return parts.Join(",")

/proc/ftreject_decode_newlywed(mask)
	if(!mask)
		return "none"
	var/list/parts = list()
	if(mask & FTREJ_N_POLY)      parts += "poly"
	if(mask & FTREJ_N_OPTOUT)    parts += "optout"
	if(mask & FTREJ_N_BLOCK)     parts += "block"
	if(mask & FTREJ_N_PRONOUNS)  parts += "pronouns"
	if(mask & FTREJ_N_SPECIES)   parts += "species"
	if(mask & FTREJ_N_ESTATE)    parts += "estate"
	if(mask & FTREJ_N_TIER)      parts += "tier"
	if(mask & FTREJ_N_SETSPOUSE) parts += "setspouse"
	return parts.Join(",")

/proc/ftreject_decode_family(mask)
	if(!mask)
		return "none"
	var/list/parts = list()
	if(mask & FTREJ_F_CLOSED)    parts += "closed"
	if(mask & FTREJ_F_RACE)      parts += "race"
	if(mask & FTREJ_F_POLY)      parts += "poly"
	if(mask & FTREJ_F_OFFLINE)   parts += "offline"
	if(mask & FTREJ_F_SETSPOUSE) parts += "setspouse"
	if(mask & FTREJ_F_PRONOUNS)  parts += "pronouns"
	if(mask & FTREJ_F_SPECIES)   parts += "species"
	if(mask & FTREJ_F_ESTATE)    parts += "estate"
	if(mask & FTREJ_F_TIER)      parts += "tier"
	if(mask & FTREJ_F_PARTIAL)   parts += "partial"
	if(mask & FTREJ_F_OPTOUT)    parts += "optout"
	return parts.Join(",")
