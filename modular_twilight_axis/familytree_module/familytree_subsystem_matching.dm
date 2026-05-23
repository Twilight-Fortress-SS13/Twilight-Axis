/datum/controller/subsystem/familytree/proc/familytree_join_create_phase_open()
	if(!SSticker?.round_start_time)
		return TRUE
	return (world.time - SSticker.round_start_time) >= FAMILYTREE_JOIN_CREATE_DELAY

/datum/controller/subsystem/familytree/proc/familytree_join_create_delay_remaining()
	if(familytree_join_create_phase_open())
		return 0
	if(!SSticker?.round_start_time)
		return 0
	return max(0, FAMILYTREE_JOIN_CREATE_DELAY - (world.time - SSticker.round_start_time))

/datum/controller/subsystem/familytree/proc/familytree_relative_join_phase_open()
	if(!SSticker?.round_start_time)
		return TRUE
	return (world.time - SSticker.round_start_time) >= FAMILYTREE_RELATIVE_JOIN_DELAY

/datum/controller/subsystem/familytree/proc/familytree_join_create_fallback_open()
	return familytree_join_create_phase_open() && !familytree_relative_join_phase_open()

/datum/controller/subsystem/familytree/proc/familytree_relative_join_delay_remaining()
	if(familytree_relative_join_phase_open())
		return 0
	if(!SSticker?.round_start_time)
		return 0
	return max(0, FAMILYTREE_RELATIVE_JOIN_DELAY - (world.time - SSticker.round_start_time))

/datum/controller/subsystem/familytree/proc/wait_for_relative_join_phase(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum || H.familytree_opted_out)
		return
	if(H.familytree_assignment_scheduled)
		ftlog("WAIT_JOIN_PHASE SKIP: [H.real_name] already scheduled reason=[reason]")
		return
	var/jitter = rand(10, 100)
	var/delay = max(10 SECONDS, familytree_relative_join_delay_remaining() + jitter)
	ftlog("WAIT_JOIN_PHASE: [H.real_name] reason=[reason], scheduling re-assignment in [delay / 10]s")
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), delay)

/datum/controller/subsystem/familytree/proc/wait_for_join_create_phase(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum || H.familytree_opted_out)
		return
	if(H.familytree_assignment_scheduled)
		ftlog("WAIT_JOIN_CREATE_PHASE SKIP: [H.real_name] already scheduled reason=[reason]")
		return
	var/jitter = rand(10, 100)
	var/delay = max(10 SECONDS, familytree_join_create_delay_remaining() + jitter)
	ftlog("WAIT_JOIN_CREATE_PHASE: [H.real_name] reason=[reason], scheduling re-assignment in [delay / 10]s")
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), delay)

/datum/controller/subsystem/familytree/proc/familytree_online_player_count()
	var/count = 0
	for(var/mob/living/carbon/human/H as anything in GLOB.player_list)
		if(!H?.client || QDELETED(H) || istype(H, /mob/living/carbon/human/dummy))
			continue
		if(H.stat == DEAD)
			continue
		count++
	return count

/datum/controller/subsystem/familytree/proc/familytree_target_player_house_count()
	var/online_count = familytree_online_player_count()
	return max(1, CEILING(online_count / FAMILYTREE_PLAYERS_PER_TARGET_HOUSE, 1))

/datum/controller/subsystem/familytree/proc/familytree_active_player_house_count()
	var/count = 0
	for(var/datum/heritage/house as anything in families)
		if(!house || house == ruling_family)
			continue
		if(!house.member_nodes.len)
			continue
		if(!house_has_online_member(house))
			continue
		count++
	return count

/datum/controller/subsystem/familytree/proc/familytree_should_seed_player_house(mob/living/carbon/human/H)
	if(!H || H.family_datum || !familytree_can_found_new_family(H))
		return FALSE
	return familytree_active_player_house_count() < familytree_target_player_house_count()

/datum/controller/subsystem/familytree/proc/familytree_found_new_house(mob/living/carbon/human/H, audit_reason = "created new house")
	if(!H || QDELETED(H) || H.family_datum)
		return null
	viable_spouses -= H
	var/datum/heritage/new_house = new /datum/heritage(H, null)
	if(!new_house?.founder)
		return null
	if(!new_house.house_leader)
		new_house.house_leader = new_house.founder
	register_family(new_house)
	GenerateCommonerParents(new_house, new_house.founder)
	GenerateRandomSiblings(new_house, new_house.founder, H.familytree_random_siblings)
	GenerateRandomChildren(new_house, new_house.founder, H.familytree_random_children)
	on_family_formed(new_house)
	wake_waiting_relative_seekers(new_house)
	ftlog("AddLocal: [H.real_name] founded new house '[new_house.housename]' ([audit_reason])")
	familytree_admin_log_house_assignment(H, new_house, audit_reason)
	stop_tracking_human(H, audit_reason)
	return new_house

/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	ftlog("AddLocal: [H?.real_name] ([H?.ckey]) status=[status]")
	if(!H || istype(H, /mob/living/carbon/human/dummy))
		return
	var/family_mode = familytree_pref_mask(status)
	if(!family_mode)
		return
	if(H.familytree_opted_out)
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

	var/join_create_phase_open = familytree_join_create_phase_open()
	var/relative_join_phase_open = familytree_relative_join_phase_open()

	var/target_name = familytree_get_target_name(H)
	if(target_name && length(target_name))
		ftlog("AddLocal: [H.real_name] has favorite=[target_name], trying favorite assign (retry #[H.familytree_setspouse_retries])")
		var/favorite_result = TryAssignToFavorite(H, status)
		if(favorite_result == "assigned")
			stop_tracking_human(H, "assigned via favorite")
			return
		if(favorite_result == "phase_locked")
			wait_for_relative_join_phase(H, "favorite house join is phase locked")
			return
		if(favorite_result == "waiting")
			if(!relative_join_phase_open && (family_mode & FAMILYTREE_MODE_JOIN) && !(family_mode & FAMILYTREE_MODE_CREATE))
				if(!join_create_phase_open)
					wait_for_join_create_phase(H, "favorite unavailable before join/create fallback phase")
					return
				find_and_confirm_newlywed(H)
				wait_for_relative_join_phase(H, "favorite unavailable during join/create fallback phase")
				return
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

	var/can_try_relative_join = relative_join_phase_open && (family_mode & FAMILYTREE_MODE_JOIN)

	if(!relative_join_phase_open && (family_mode & FAMILYTREE_MODE_JOIN))
		ftlog("AddLocal: [H.real_name] relative join phase locked; join_create_phase=[join_create_phase_open], create_mode=[!!(family_mode & FAMILYTREE_MODE_CREATE)]")

	if(can_try_relative_join && H.desired_relative_role == RELATIVE_ANY && try_assign_noble_to_dynasty(H))
		return

	if((family_mode & FAMILYTREE_MODE_CREATE) && familytree_should_seed_player_house(H))
		ftlog("AddLocal: [H.real_name] target house count is not met; trying to seed a new house before filling existing houses")
		if(find_and_confirm_newlywed(H))
			return
		if(H.desired_relative_role != RELATIVE_ANY)
			wait_for_new_family_match(H, "target house count not met for selected relative role")
			return
		familytree_found_new_house(H, "created new house; target house count not met")
		return

	var/can_fill_seeded_house = !relative_join_phase_open && join_create_phase_open && (family_mode & FAMILYTREE_MODE_JOIN) && (family_mode & FAMILYTREE_MODE_CREATE) && H.desired_relative_role == RELATIVE_ANY
	if(can_fill_seeded_house && request_house_join_confirmation(H, null, TRUE, familytree_role_text_ru("relative")))
		ftlog("AddLocal: [H.real_name] target house count met; trying seeded house fill during join/create phase")
		return

	if(can_try_relative_join && H.desired_relative_role != RELATIVE_ANY)
		ftlog("AddLocal: [H.real_name] desired_role=[H.desired_relative_role], trying role assign")
		if(H.desired_relative_role == RELATIVE_SPOUSE)
			INVOKE_ASYNC(src, PROC_REF(find_and_confirm_family), H, FALSE)
		else
			var/forced_role = familytree_forced_role_from_relative_role(H.desired_relative_role)
			var/desired_role_text = familytree_desired_role_text_ru(H.desired_relative_role)
			if(forced_role && request_house_join_confirmation(H, forced_role, FALSE, desired_role_text))
				return
			if(forced_role)
				wait_for_relative_house(H, "no suitable house for selected role")
				return
		return

	var/can_fallthrough_from_join = !!(family_mode & (FAMILYTREE_MODE_CREATE | FAMILYTREE_MODE_LEGACY_SPOUSE))
	if(can_try_relative_join)
		if(request_house_join_confirmation(H, null, FALSE, familytree_role_text_ru("relative")))
			ftlog("AddLocal: [H.real_name] -> AssignToHouse (pending confirm)")
			return
		else
			ftlog("AddLocal: [H.real_name] -> NO suitable house")
			if(!can_fallthrough_from_join)
				wait_for_relative_house(H, "no suitable house for relative")
				return

	if(family_mode & FAMILYTREE_MODE_CREATE)
		ftlog("AddLocal: [H.real_name] -> FindNewlyWedMatch")
		if(find_and_confirm_newlywed(H))
			return
		if(!(family_mode & FAMILYTREE_MODE_LEGACY_SPOUSE))
			wait_for_new_family_match(H, "no suitable new-family match")
			return
		if(!relative_join_phase_open)
			if(!join_create_phase_open)
				wait_for_join_create_phase(H, "legacy spouse fallback locked before join/create phase")
			else
				wait_for_relative_join_phase(H, "legacy spouse fallback locked during join/create phase")
			return
		viable_spouses -= H

	if(!relative_join_phase_open && (family_mode & FAMILYTREE_MODE_JOIN))
		if(!join_create_phase_open)
			ftlog("AddLocal: [H.real_name] waiting for join/create fallback phase")
			wait_for_join_create_phase(H, "join/create fallback phase locked")
			return
		ftlog("AddLocal: [H.real_name] waiting for relative join phase while available as new-family partner")
		find_and_confirm_newlywed(H)
		wait_for_relative_join_phase(H, "relative join phase locked")
		return

	if(!relative_join_phase_open && (family_mode & FAMILYTREE_MODE_LEGACY_SPOUSE))
		if(!join_create_phase_open)
			wait_for_join_create_phase(H, "legacy spouse flow locked before join/create phase")
		else
			wait_for_relative_join_phase(H, "legacy spouse flow locked during join/create phase")
		return

	if(family_mode & FAMILYTREE_MODE_LEGACY_SPOUSE)
		if(H.virginity)
			ftlog("AddLocal: [H.real_name] SKIP: virginity gate")
			stop_tracking_human(H, "legacy full family flow skipped; virginity gate")
			return
		ftlog("AddLocal: [H.real_name] -> FindFamilyMatch")
		INVOKE_ASYNC(src, PROC_REF(find_and_confirm_family), H)

/datum/controller/subsystem/familytree/proc/do_assign_house(mob/living/carbon/human/H, allow_join_create_phase = FALSE)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!familytree_relative_join_phase_open())
		if(allow_join_create_phase && familytree_join_create_phase_open())
			ftlog("do_assign_house: [H.real_name] confirmed during join/create phase")
		else
			wait_for_relative_join_phase(H, "house confirmation accepted before join phase")
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
	if(!familytree_relative_join_phase_open())
		wait_for_relative_join_phase(H, "desired role confirmation accepted before join phase")
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
		return FALSE
	if(H.family_datum)
		return FALSE
	if(H.familytree_confirmation_pending)
		return FALSE
	if(!familytree_is_new_family_candidate(H))
		return FALSE
	var/mob/living/carbon/human/match = FindNewlyWedMatch(H)
	if(!match)
		ftlog("AddLocal: [H.real_name] newlywed no match found")
		return FALSE
	var/relation = familytree_new_family_pair_relation(H, match)
	if(relation == "spouse")
		if(H.spouse_mob && !familytree_can_have_multiple_spouses(H))
			return FALSE
		ftlog("AddLocal: [H.real_name] newlywed match=[match.real_name], requesting mutual confirm")
		var/confirm_type = familytree_mutual_setspouse(H, match) ? "targeted_spouse" : "spouse"
		var/spouse_text = familytree_role_text_ru("spouse")
		request_mutual_confirmation(H, match, CALLBACK(src, PROC_REF(do_execute_newlywed), H, match), confirm_type, spouse_text, spouse_text)
		return TRUE
	if(relation)
		ftlog("AddLocal: [H.real_name] new-family relation=[relation] match=[match.real_name], requesting mutual confirm")
		var/relation_text_a = familytree_new_family_role_text_ru(relation, TRUE)
		var/relation_text_b = familytree_new_family_role_text_ru(relation, FALSE)
		request_mutual_confirmation(H, match, CALLBACK(src, PROC_REF(do_execute_new_family_relative), H, match, relation), "family", relation_text_a, relation_text_b)
		return TRUE
	return FALSE

/datum/controller/subsystem/familytree/proc/do_execute_newlywed(mob/living/carbon/human/H, mob/living/carbon/human/spouse)
	if(!H || QDELETED(H))
		return
	if(!spouse || QDELETED(spouse))
		retry_local_assignment(H, "spouse unavailable after confirm")
		return
	if(H.family_datum || spouse.family_datum)
		retry_local_assignment(H, "new family spouse already has a family")
		return
	if(familytree_new_family_pair_relation(H, spouse) != "spouse")
		retry_local_assignment(H, "spouse no longer wants to create a new family")
		return
	if(!familytree_new_family_relation_valid(H, spouse, "spouse"))
		retry_local_assignment(H, "spouse role no longer compatible")
		return
	if(familytree_new_family_pair_pref_reject_mask(H, spouse))
		retry_local_assignment(H, "spouse no longer matches creator preferences")
		return
	if(!familytree_estates_compatible(H, spouse))
		retry_local_assignment(H, "spouse estate no longer compatible")
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
		GenerateCommonerParents(family, founder.family_member_datum)
		GenerateCommonerParents(family, partner.family_member_datum)
		GenerateRandomSiblings(family, founder.family_member_datum, founder.familytree_random_siblings)
		GenerateRandomSiblings(family, partner.family_member_datum, partner.familytree_random_siblings)
		GenerateRandomChildren(family, founder.family_member_datum, founder.familytree_random_children)
		GenerateRandomChildren(family, partner.family_member_datum, partner.familytree_random_children)
		on_family_formed(family)
		wake_waiting_relative_seekers(family)
		familytree_admin_log_house_assignment(H, family, "created new house with spouse [key_name(spouse)]", spouse.family_member_datum)
		familytree_admin_log_house_assignment(spouse, family, "created new house with spouse [key_name(H)]", H.family_member_datum)
	introduce_pair(H, spouse)
	bestow_wedding_rings(H, spouse)
	stop_tracking_human(H, "newlywed flow matched spouse")
	stop_tracking_human(spouse, "newlywed flow matched spouse")

/datum/controller/subsystem/familytree/proc/do_execute_new_family_relative(mob/living/carbon/human/H, mob/living/carbon/human/relative, expected_relation)
	if(!H || QDELETED(H))
		return
	if(!relative || QDELETED(relative))
		retry_local_assignment(H, "relative unavailable after confirm")
		return
	if(H.family_datum || relative.family_datum)
		retry_local_assignment(H, "new family relative already has a family")
		return
	var/relation = familytree_new_family_pair_relation(H, relative)
	if(relation != expected_relation)
		retry_local_assignment(H, "relative no longer wants this new family role")
		return
	if(!familytree_new_family_relation_valid(H, relative, relation))
		retry_local_assignment(H, "relative role no longer compatible")
		return
	if(familytree_new_family_pair_pref_reject_mask(H, relative))
		retry_local_assignment(H, "relative no longer matches creator preferences")
		return
	if(!familytree_estates_compatible(H, relative))
		retry_local_assignment(H, "relative estate no longer compatible")
		return
	if(!familytree_role_tiers_compatible(H, relative))
		retry_local_assignment(H, "relative role tier no longer compatible")
		return
	var/mob/living/carbon/human/leader = familytree_new_family_founder(H, relative)
	var/datum/heritage/family = familytree_create_new_relative_house(leader, H, relative, relation)
	if(!family)
		retry_local_assignment(H, "relative house creation failed")
		return
	on_family_formed(family)
	wake_waiting_relative_seekers(family)
	introduce_pair(H, relative)
	familytree_admin_log_house_assignment(H, family, familytree_new_family_relation_audit_text(H, relative, relation, TRUE), relative.family_member_datum)
	familytree_admin_log_house_assignment(relative, family, familytree_new_family_relation_audit_text(H, relative, relation, FALSE), H.family_member_datum)
	stop_tracking_human(H, "new family relative flow matched")
	stop_tracking_human(relative, "new family relative flow matched")
	ask_open_sibling_house(leader, family)

/datum/controller/subsystem/familytree/proc/find_and_confirm_family(mob/living/carbon/human/H, create_if_no_match = TRUE)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(H.familytree_confirmation_pending)
		return
	var/list/match = FindFamilyMatch(H)
	if(!match)
		if(!create_if_no_match)
			ftlog("AddLocal: [H.real_name] family no match found, waiting for a family founder")
			wait_for_new_family_founder(H)
			return
		ftlog("AddLocal: [H.real_name] family no match found, creating new house")
		familytree_found_new_house(H, "created new house; no compatible family match")
		return
	var/datum/heritage/house = match[1]
	var/datum/family_member/partner_member = match[2]
	var/mob/living/carbon/human/partner = partner_member?.person
	if(!partner)
		return
	ftlog("AddLocal: [H.real_name] family match=[partner.real_name] in house=[house.housename], requesting mutual confirm")
	var/spouse_text = familytree_role_text_ru("spouse")
	request_mutual_confirmation(H, partner, CALLBACK(src, PROC_REF(do_execute_family), H, house, partner_member), "family", spouse_text, spouse_text)

/datum/controller/subsystem/familytree/proc/do_execute_family(mob/living/carbon/human/H, datum/heritage/house, datum/family_member/partner_member)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!familytree_relative_join_phase_open())
		wait_for_relative_join_phase(H, "family spouse confirmation accepted before join phase")
		return
	if(!house || !partner_member?.person)
		retry_local_assignment(H, "partner lost")
		return
	if(!familytree_polygamy_compatible(H, partner_member.person))
		retry_local_assignment(H, "partner already married")
		return
	var/soft_reject_mask = familytree_pair_soft_pref_reject_mask(H, partner_member.person)
	if(soft_reject_mask & FTREJ_N_PRONOUNS)
		retry_local_assignment(H, "partner pronouns no longer compatible")
		return
	if(soft_reject_mask & FTREJ_N_SPECIES)
		retry_local_assignment(H, "partner species or anatomy no longer compatible")
		return
	if(!familytree_estates_compatible(H, partner_member.person))
		retry_local_assignment(H, "partner estate no longer compatible")
		return
	if(!familytree_role_tiers_compatible(H, partner_member.person))
		retry_local_assignment(H, "partner role tier no longer compatible")
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
	var/target_name = familytree_get_target_name(H)
	if(!target_name || !length(target_name))
		ftlog("TryFavorite SKIP: [H?.real_name] no setspouse")
		return "skip"

	var/status_mode = familytree_pref_mask(status)
	ftlog("TryFavorite: [H.real_name] looking for '[target_name]'")
	var/mob/living/carbon/human/favorite = FindFavoriteMob(H)

	if(!favorite)
		ftlog("TryFavorite: [H.real_name] favorite NOT FOUND, waiting")
		return "waiting"

	ftlog("TryFavorite: [H.real_name] found favorite=[favorite.real_name] ([favorite.ckey])")

	if(favorite.familytree_opted_out)
		return "waiting"
	if(!familytree_name_lock_allows_pair(H, favorite))
		return "waiting"
	if(favorite.familytree_confirmation_pending)
		return "waiting"

	var/mutual_sibling = (H.desired_relative_role == RELATIVE_SIBLING && favorite.desired_relative_role == RELATIVE_SIBLING)

	if(mutual_sibling)
		ftlog("TryFavorite: [H.real_name] + [favorite.real_name] mutual sibling -> mutual confirm")
		var/sibling_text = familytree_role_text_ru("sibling")
		request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_form_sibling_house), H, favorite), "sibling_house", sibling_text, sibling_text)
		return "assigned"

	if(favorite.family_datum)
		var/datum/heritage/house = favorite.family_datum
		if(!(status_mode & FAMILYTREE_MODE_JOIN) && (status_mode & FAMILYTREE_MODE_CREATE))
			ftlog("TryFavorite: [H.real_name] favorite [favorite.real_name] already has a family; pure new-family mode will wait")
			return "waiting"
		if(!familytree_relative_join_phase_open())
			ftlog("TryFavorite: [H.real_name] favorite has house but relative join phase is locked")
			return "phase_locked"
		if((status_mode & FAMILYTREE_MODE_JOIN) && H.desired_relative_role == RELATIVE_SPOUSE)
			if(!familytree_polygamy_compatible(H, favorite))
				return "skip"
			if(familytree_pair_soft_pref_reject_mask(H, favorite))
				return "skip"
			if(!familytree_estates_compatible(H, favorite) || !familytree_role_tiers_compatible(H, favorite))
				return "skip"
			var/spouse_text = familytree_role_text_ru("spouse")
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_family), H, house, favorite.family_member_datum), "family", spouse_text, spouse_text)
			return "assigned"
		if(status_mode & FAMILYTREE_MODE_LEGACY_SPOUSE)
			var/favorite_has_dummy_spouse = FALSE
			var/list/favorite_spouses = favorite.family_member_datum?.get_spouse_members()
			if(favorite_spouses?.len)
				var/datum/family_member/existing_spouse_member = favorite_spouses[1]
				if(existing_spouse_member?.person && istype(existing_spouse_member.person, /mob/living/carbon/human/dummy))
					favorite_has_dummy_spouse = TRUE
			if(!favorite_has_dummy_spouse && !familytree_polygamy_compatible(H, favorite))
				return "skip"
			if(familytree_pair_soft_pref_reject_mask(H, favorite))
				return "skip"
			if(!familytree_estates_compatible(H, favorite) || !familytree_role_tiers_compatible(H, favorite))
				return "skip"
			var/spouse_text = familytree_role_text_ru("spouse")
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_family), H, house, favorite.family_member_datum), "family", spouse_text, spouse_text)
		else
			var/forced_role_text = familytree_desired_role_text_ru(H.desired_relative_role) || familytree_role_text_ru("relative")
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_assign_to_favorite_house), H, house, favorite.family_member_datum), "house", forced_role_text, forced_role_text)
		return "assigned"

	if((status_mode & (FAMILYTREE_MODE_CREATE | FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_LEGACY_SPOUSE)) && familytree_new_family_pair_eligible(H, favorite))
		var/relation = familytree_new_family_pair_relation(H, favorite)
		if(relation && !familytree_new_family_relation_valid(H, favorite, relation))
			return "skip"
		if(familytree_new_family_pair_pref_reject_mask(H, favorite))
			return "skip"
		if(!familytree_estates_compatible(H, favorite))
			return "skip"
		if(relation == "spouse")
			if(!familytree_polygamy_compatible(H, favorite))
				return "skip"
			var/confirm_type = familytree_mutual_setspouse(H, favorite) ? "targeted_spouse" : "spouse"
			var/spouse_text = familytree_role_text_ru("spouse")
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_newlywed), H, favorite), confirm_type, spouse_text, spouse_text)
			return "assigned"
		if(relation)
			var/relation_text_a = familytree_new_family_role_text_ru(relation, TRUE)
			var/relation_text_b = familytree_new_family_role_text_ru(relation, FALSE)
			request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_new_family_relative), H, favorite, relation), "family", relation_text_a, relation_text_b)
			return "assigned"

	return "waiting"

/datum/controller/subsystem/familytree/proc/familytree_get_target_name(mob/living/carbon/human/H)
	if(!H)
		return null
	if(H.setspouse && length(H.setspouse))
		return H.setspouse
	var/datum/preferences/P = H.client?.prefs
	if(!P)
		return null
	P.familytree_module_load_character()
	if(P.setspouse && length(P.setspouse))
		return P.setspouse
	return null

/datum/controller/subsystem/familytree/proc/familytree_targets_name(mob/living/carbon/human/seeker, mob/living/carbon/human/target)
	var/target_name = familytree_get_target_name(seeker)
	if(!target || !target_name || !length(target_name))
		return FALSE
	return familytree_names_match(target_name, target.real_name)

/datum/controller/subsystem/familytree/proc/familytree_mutual_setspouse(mob/living/carbon/human/A, mob/living/carbon/human/B)
	return familytree_targets_name(A, B) && familytree_targets_name(B, A)

/datum/controller/subsystem/familytree/proc/familytree_name_lock_allows_pair(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!A || !B)
		return FALSE
	if(A.setspouse && length(A.setspouse) && !familytree_targets_name(A, B))
		return FALSE
	if(B.setspouse && length(B.setspouse) && !familytree_targets_name(B, A))
		return FALSE
	return TRUE

/datum/controller/subsystem/familytree/proc/do_assign_to_favorite_house(mob/living/carbon/human/H, datum/heritage/house, datum/family_member/favorite_member)
	if(!H || QDELETED(H) || H.family_datum || !house)
		return
	if(!familytree_relative_join_phase_open())
		wait_for_relative_join_phase(H, "favorite house confirmation accepted before join phase")
		return
	if(!favorite_member?.person || favorite_member.family != house)
		retry_local_assignment(H, "favorite house anchor lost")
		return
	var/forced_role = familytree_forced_role_from_relative_role(H.desired_relative_role)
	var/list/assignment = AddPersonToHouse(house, H, FALSE, forced_role)
	if(H.family_datum)
		var/favorite_role = familytree_relative_assignment_audit_text(assignment)
		familytree_admin_log_house_assignment(H, house, "joined favorite house as [favorite_role]")
		to_chat(H, span_love("Вы успешно присоединились к семье!"))
		stop_tracking_human(H, "assigned to favorite house")
	else
		retry_local_assignment(H, "favorite house assignment failed")

/datum/controller/subsystem/familytree/proc/FindFavoriteMob(mob/living/carbon/human/H)
	var/target_name = familytree_get_target_name(H)
	if(!target_name)
		return null

	for(var/datum/heritage/house as anything in families)
		for(var/datum/family_node/node as anything in house.member_nodes)
			if(node.person && familytree_names_match(node.person.real_name, target_name))
				return node.person

	for(var/mob/living/carbon/human/candidate as anything in viable_spouses.Copy())
		if(!candidate || QDELETED(candidate))
			viable_spouses -= candidate
			continue
		if(candidate == H)
			continue
		if(candidate.familytree_opted_out)
			viable_spouses -= candidate
			continue
		if(familytree_names_match(candidate.real_name, target_name))
			return candidate

	for(var/mob/living/carbon/human/candidate in GLOB.alive_mob_list)
		if(candidate == H)
			continue
		if(!candidate.client || candidate.stat == DEAD)
			continue
		if(candidate.familytree_opted_out)
			continue
		var/candidate_pref = candidate.familytree_pref
		var/datum/preferences/candidate_prefs = candidate.client?.prefs
		if(candidate_prefs)
			load_familytree_runtime_preferences(candidate, candidate_prefs)
			candidate_pref = candidate.familytree_pref
		if(!familytree_pref_enabled(candidate_pref))
			continue
		if(familytree_names_match(candidate.real_name, target_name))
			return candidate

	return null

/datum/controller/subsystem/familytree/proc/try_force_mutual_targeted_match(mob/living/carbon/human/H)
	var/target_name = familytree_get_target_name(H)
	if(!H || !target_name || !length(target_name))
		return FALSE
	if(H.family_datum || H.familytree_opted_out || H.familytree_confirmation_pending)
		return FALSE

	var/mob/living/carbon/human/favorite = FindFavoriteMob(H)
	if(!favorite || favorite == H)
		return FALSE
	if(!familytree_mutual_setspouse(H, favorite))
		return FALSE
	if(favorite.familytree_opted_out || favorite.familytree_confirmation_pending)
		return FALSE
	if(favorite.family_datum)
		return FALSE

	var/h_block = get_familytree_runtime_block_reason(H, TRUE)
	var/f_block = get_familytree_runtime_block_reason(favorite, TRUE)
	if(h_block || f_block)
		return FALSE

	var/relation = familytree_new_family_pair_relation(H, favorite)
	if(relation != "spouse")
		var/relation_text = relation || "none"
		ftlog("TARGETED MATCH SKIP: [H.real_name] <-> [favorite.real_name] mutual target relation=[relation_text], falling back to regular matching")
		return FALSE
	if(!familytree_targeted_spouse_pair_valid(H, favorite))
		return FALSE

	ftlog("TARGETED MATCH: [H.real_name] <-> [favorite.real_name] forcing mutual spouse confirmation before regular matching")
	var/spouse_text = familytree_role_text_ru("spouse")
	request_mutual_confirmation(H, favorite, CALLBACK(src, PROC_REF(do_execute_targeted_spouse_match), H, favorite), "targeted_spouse", spouse_text, spouse_text)
	return TRUE

/datum/controller/subsystem/familytree/proc/familytree_targeted_spouse_pair_valid(mob/living/carbon/human/H, mob/living/carbon/human/favorite)
	if(!familytree_new_family_relation_valid(H, favorite, "spouse"))
		return FALSE
	if(familytree_new_family_pair_pref_reject_mask(H, favorite))
		return FALSE
	if(!familytree_estates_compatible(H, favorite))
		return FALSE
	if(familytree_pair_blocked(H, favorite))
		return FALSE
	return TRUE

/datum/controller/subsystem/familytree/proc/do_execute_targeted_spouse_match(mob/living/carbon/human/H, mob/living/carbon/human/favorite)
	if(!H || QDELETED(H))
		return
	if(!favorite || QDELETED(favorite))
		retry_local_assignment(H, "targeted spouse unavailable after confirm")
		return
	if(H.family_datum || favorite.family_datum)
		retry_local_assignment(H, "targeted spouse already has a family")
		return
	if(familytree_new_family_pair_relation(H, favorite) != "spouse")
		retry_local_assignment(H, "targeted pair no longer wants spouse relation")
		return
	if(!familytree_targeted_spouse_pair_valid(H, favorite))
		retry_local_assignment(H, "targeted spouse pair no longer compatible")
		return
	ftlog("TARGETED MATCH: [H.real_name] + [favorite.real_name] -> forced spouse match")
	viable_spouses -= H
	viable_spouses -= favorite
	var/mob/living/carbon/human/founder = familytree_new_family_founder(H, favorite)
	var/mob/living/carbon/human/partner = founder == H ? favorite : H
	var/datum/heritage/family = founder.MarryTo(partner)
	if(!family)
		retry_local_assignment(H, "targeted spouse family creation failed")
		retry_local_assignment(favorite, "targeted spouse family creation failed")
		return
	family.closed = FALSE
	if(!family.house_leader)
		family.house_leader = founder.family_member_datum || family.founder
	on_family_formed(family)
	wake_waiting_relative_seekers(family)
	familytree_admin_log_house_assignment(H, family, "created targeted house with spouse [key_name(favorite)]", favorite.family_member_datum)
	familytree_admin_log_house_assignment(favorite, family, "created targeted house with spouse [key_name(H)]", H.family_member_datum)
	introduce_pair(H, favorite)
	bestow_wedding_rings(H, favorite)
	stop_tracking_human(H, "targeted spouse match completed")
	stop_tracking_human(favorite, "targeted spouse match completed")

/datum/controller/subsystem/familytree/proc/familytree_find_house_join_plan(mob/living/carbon/human/H, forced_role = null)
	if(!H)
		return null
	var/list/candidates = list()
	var/list/assignments_by_house = list()
	var/reject_mask = 0

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			reject_mask |= FTREJ_H_CLOSED
			continue
		if(!house.housename || house.housename == "no name")
			reject_mask |= FTREJ_H_NONAME
			continue
		if(!house_allows_relatives(house, H))
			reject_mask |= FTREJ_H_RELATIVES
			continue
		if(!house_relative_compatible(house, H))
			reject_mask |= FTREJ_H_RACE
			continue
		if(house.member_nodes.len < 1)
			reject_mask |= FTREJ_H_EMPTY
			continue
		if(!house_has_online_member(house))
			reject_mask |= FTREJ_H_OFFLINE
			continue
		var/list/assignment = familytree_pick_random_relative_assignment(house, H, forced_role)
		if(!assignment)
			reject_mask |= FTREJ_H_AGE
			continue
		candidates += house
		assignments_by_house[house] = assignment

	ftlog("FindHouseJoinPlan REJECTS [H.real_name]: mask=[reject_mask] ([ftreject_decode_house(reject_mask)]) -> candidates=[candidates.len]", FTLOG_DEBUG)

	var/list/remaining_candidates = candidates.Copy()
	while(remaining_candidates.len)
		var/datum/heritage/chosen_house = pick_preferred_family_house(remaining_candidates)
		if(!chosen_house)
			break
		remaining_candidates -= chosen_house
		var/list/assignment = assignments_by_house[chosen_house]
		if(assignment)
			return list("house" = chosen_house, "assignment" = assignment)
	return null

/datum/controller/subsystem/familytree/proc/familytree_house_join_confirmation_partner(datum/heritage/house, list/assignment)
	if(!house)
		return null
	var/datum/family_member/anchor = assignment?["anchor"]
	if(anchor?.person?.client)
		return anchor.person
	if(house.house_leader?.person?.client)
		return house.house_leader.person
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(node.person?.client)
			return node.person
	return null

/datum/controller/subsystem/familytree/proc/familytree_house_join_role_text(role, for_joiner = TRUE)
	switch(role)
		if("child")
			return for_joiner ? familytree_role_text_ru("child") : familytree_role_text_ru("parent")
		if("parent")
			return for_joiner ? familytree_role_text_ru("parent") : familytree_role_text_ru("child")
		if("sibling")
			return familytree_role_text_ru("sibling")
		if("uncle_aunt")
			return for_joiner ? familytree_role_text_ru("uncle_aunt") : familytree_role_text_ru("nibling")
	return familytree_role_text_ru("relative")

/datum/controller/subsystem/familytree/proc/request_house_join_confirmation(mob/living/carbon/human/H, forced_role = null, allow_join_create_phase = FALSE, relation_text = null)
	if(!H || QDELETED(H) || H.family_datum)
		return FALSE
	var/list/join_plan = familytree_find_house_join_plan(H, forced_role)
	if(!join_plan)
		return FALSE
	var/datum/heritage/house = join_plan["house"]
	var/list/assignment = join_plan["assignment"]
	var/mob/living/carbon/human/partner = familytree_house_join_confirmation_partner(house, assignment)
	if(!partner)
		return FALSE
	if(partner.familytree_confirmation_pending)
		return FALSE
	var/role = assignment?["role"]
	var/joiner_text = relation_text || familytree_house_join_role_text(role, TRUE)
	var/partner_text = familytree_house_join_role_text(role, FALSE)
	ftlog("REQUEST_HOUSE_JOIN: [H.real_name] -> '[house.housename || "no name"]' via [partner.real_name] role=[role]")
	request_mutual_confirmation(H, partner, CALLBACK(src, PROC_REF(do_assign_house_join_plan), H, house, assignment, allow_join_create_phase), "house", joiner_text, partner_text)
	return TRUE

/datum/controller/subsystem/familytree/proc/do_assign_house_join_plan(mob/living/carbon/human/H, datum/heritage/house, list/assignment, allow_join_create_phase = FALSE)
	if(!H || QDELETED(H) || H.family_datum || !house || !islist(assignment))
		return
	if(!familytree_relative_join_phase_open())
		if(allow_join_create_phase && familytree_join_create_phase_open())
			ftlog("do_assign_house_join_plan: [H.real_name] confirmed during join/create phase")
		else
			wait_for_relative_join_phase(H, "house confirmation accepted before join phase")
			return
	var/datum/family_member/anchor = assignment["anchor"]
	var/role = assignment["role"]
	if(!anchor?.person || anchor.family != house || !(anchor in house.members))
		retry_local_assignment(H, "house join anchor lost")
		return
	if(!(role in familytree_possible_roles_for_anchor(house, H, anchor, role, FALSE)))
		retry_local_assignment(H, "house join role no longer valid")
		return
	ftlog("AssignToHouse: [H.real_name] -> JOINING confirmed existing house '[house.housename || "no name"]' (members=[house.member_nodes.len])")
	var/datum/family_member/new_member = familytree_apply_relative_role_to_anchor(house, H, anchor, role, FALSE)
	if(new_member)
		assignment["member"] = new_member
		familytree_admin_log_house_assignment(H, house, "joined existing house as [familytree_relative_assignment_audit_text(assignment)]")
		stop_tracking_human(H, "assigned to house")
		return
	retry_local_assignment(H, "house join assignment failed")

/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H, forced_role = null)
	if(!H)
		return
	ftlog("AssignToHouse START: [H.real_name] race=[H.dna?.species?.name] isolated=[is_isolated(H)] pref=[H.familytree_pref]")

	var/list/candidates = list()
	var/reject_mask = 0

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			reject_mask |= FTREJ_H_CLOSED
			continue
		if(!house.housename || house.housename == "no name")
			reject_mask |= FTREJ_H_NONAME
			continue
		if(!house_allows_relatives(house, H))
			reject_mask |= FTREJ_H_RELATIVES
			continue
		if(!house_relative_compatible(house, H))
			reject_mask |= FTREJ_H_RACE
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
		var/list/remaining_candidates = candidates.Copy()
		while(remaining_candidates.len)
			var/datum/heritage/chosen_house = pick_preferred_family_house(remaining_candidates)
			if(!chosen_house)
				break
			remaining_candidates -= chosen_house
			ftlog("AssignToHouse: [H.real_name] → JOINING preferred existing house '[chosen_house.housename || "no name"]' (members=[chosen_house.member_nodes.len])")
			var/list/assignment = AddPersonToHouse(chosen_house, H, FALSE, forced_role)
			if(H.family_datum)
				familytree_admin_log_house_assignment(H, chosen_house, "joined existing house as [familytree_relative_assignment_audit_text(assignment)]")
				stop_tracking_human(H, "assigned to house")
				return
			ftlog("AssignToHouse: [H.real_name] selected house did not accept forced_role=[forced_role]", FTLOG_WARN)
		ftlog("AssignToHouse: [H.real_name] → NO random candidate accepted the relative assignment.", FTLOG_WARN)
	else
		ftlog("AssignToHouse: [H.real_name] → NO suitable existing house found. Staying without family.", FTLOG_WARN)

/datum/controller/subsystem/familytree/proc/AddPersonToHouse(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE, forced_role = null)
	return familytree_assign_random_relative_role(house, person, adopted, forced_role)

/datum/controller/subsystem/familytree/proc/familytree_assign_random_relative_role(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE, forced_role = null)
	var/list/assignment = familytree_pick_random_relative_assignment(house, person, forced_role, adopted)
	if(!assignment)
		return null
	var/datum/family_member/anchor = assignment["anchor"]
	var/role = assignment["role"]
	var/datum/family_member/new_member = familytree_apply_relative_role_to_anchor(house, person, anchor, role, adopted)
	if(!new_member)
		return null
	assignment["member"] = new_member
	return assignment

/datum/controller/subsystem/familytree/proc/familytree_pick_random_relative_assignment(datum/heritage/house, mob/living/carbon/human/person, forced_role = null, adopted = FALSE)
	if(!house || !person)
		return null
	var/list/eligible_assignments_by_role = list()
	for(var/datum/family_member/member as anything in house.members)
		var/list/roles = familytree_possible_roles_for_anchor(house, person, member, forced_role, adopted)
		for(var/role as anything in roles)
			if(!eligible_assignments_by_role[role])
				eligible_assignments_by_role[role] = list()
			var/list/role_assignments = eligible_assignments_by_role[role]
			role_assignments += list(list("anchor" = member, "role" = role))
	if(!eligible_assignments_by_role.len)
		return null
	var/list/role_pool = list()
	for(var/role as anything in eligible_assignments_by_role)
		role_pool += role
	var/chosen_role = pick(role_pool)
	var/list/eligible_assignments = eligible_assignments_by_role[chosen_role]
	if(!eligible_assignments?.len)
		return null
	return pick(eligible_assignments)

/datum/controller/subsystem/familytree/proc/familytree_possible_roles_for_anchor(datum/heritage/house, mob/living/carbon/human/person, datum/family_member/anchor, forced_role = null, adopted = FALSE)
	var/list/possible_roles = list()
	if(!house || !person || !anchor?.person || anchor.person == person)
		return possible_roles
	if(anchor.cosmetic || anchor.phantom)
		return possible_roles
	if(!familytree_relative_species_compatible(person, anchor.person))
		return possible_roles

	var/first_degree_ok = familytree_first_degree_tier_compatible(person, anchor.person)

	if(first_degree_ok && CanBeParentOf(anchor.person, person) && familytree_parent_link_mode(anchor.person, person, house, adopted))
		possible_roles += "child"
	if(first_degree_ok && familytree_can_be_sibling_of_anchor(house, person, anchor))
		possible_roles += "sibling"
	if(first_degree_ok && anchor.get_parent_members().len < 2 && CanBeParentOf(person, anchor.person))
		if(familytree_parent_link_mode(person, anchor.person, house, adopted))
			possible_roles += "parent"
	if((!forced_role || forced_role == "uncle_aunt") && familytree_can_be_uncle_aunt_of(person, anchor.person))
		possible_roles += "uncle_aunt"

	if(!forced_role)
		return possible_roles
	if(forced_role in possible_roles)
		return list(forced_role)
	return list()

/datum/controller/subsystem/familytree/proc/familytree_can_be_sibling_of_anchor(datum/heritage/house, mob/living/carbon/human/person, datum/family_member/anchor)
	if(!house || !person || !anchor?.person)
		return FALSE
	if(!CanBeSiblings(anchor.person.age, person.age))
		return FALSE
	var/list/anchor_parents = anchor.get_parent_members()
	for(var/datum/family_member/parent as anything in anchor_parents)
		if(!parent?.person)
			continue
		if(parent.cosmetic)
			continue
		if(!familytree_relative_species_compatible(person, parent.person))
			return FALSE
		if(!CanBeParentOf(parent.person, person))
			return FALSE
	return TRUE

/datum/controller/subsystem/familytree/proc/familytree_parent_link_mode(mob/living/carbon/human/parent, mob/living/carbon/human/child, datum/heritage/house, adopted = FALSE)
	if(!parent || !child)
		return null
	if(adopted)
		return "adoptive"
	if(familytree_biological_parent_allowed(parent, child, house))
		return "biological"
	return "adoptive"

/datum/controller/subsystem/familytree/proc/familytree_coparent_link_mode(datum/family_member/anchor, datum/family_member/coparent, mob/living/carbon/human/child, datum/heritage/house, adopted = FALSE)
	if(!coparent?.person || !child)
		return null
	if(!familytree_relative_species_compatible(child, coparent.person))
		return null
	if(adopted)
		return "adoptive"
	if(CanBeParentOf(coparent.person, child) && anchor?.person && CanBeParentOf(anchor.person, child))
		if(familytree_biological_parent_pair_allowed(anchor.person, coparent.person, child, house))
			return "biological"
	return "adoptive"

/datum/controller/subsystem/familytree/proc/familytree_add_parent_link(datum/family_member/child, datum/family_member/parent, link_mode)
	if(!child || !parent || !link_mode)
		return FALSE
	var/old_adoption_status = child.adoption_status
	child.adoption_status = (link_mode == "adoptive")
	var/success = child.AddParent(parent)
	if(!success && link_mode == "biological")
		child.adoption_status = TRUE
		success = child.AddParent(parent)
		if(success)
			link_mode = "adoptive"
	child.adoption_status = success ? (old_adoption_status || link_mode == "adoptive") : old_adoption_status
	return success

/datum/controller/subsystem/familytree/proc/familytree_pick_spouse_coparent(datum/heritage/house, datum/family_member/anchor, mob/living/carbon/human/child, adopted = FALSE)
	if(!house || !anchor?.person || !child)
		return null
	var/list/candidates = list()
	for(var/datum/family_member/spouse as anything in anchor.get_spouse_members())
		if(!spouse?.person || spouse.family != house)
			continue
		if(spouse == anchor)
			continue
		if(familytree_coparent_link_mode(anchor, spouse, child, house, adopted))
			candidates += spouse
	if(!candidates.len)
		return null
	return pick(candidates)

/datum/controller/subsystem/familytree/proc/familytree_apply_relative_role_to_anchor(datum/heritage/house, mob/living/carbon/human/person, datum/family_member/anchor, role, adopted = FALSE)
	if(!house || !person || !anchor?.person || !role)
		return null

	var/datum/family_member/new_member = house.CreateFamilyMember(person)
	if(!new_member)
		return null
	new_member.adoption_status = adopted

	var/success = FALSE
	var/datum/family_member/created_phantom_parent = null

	switch(role)
		if("child")
			var/datum/family_member/coparent = familytree_pick_spouse_coparent(house, anchor, person, adopted)
			var/coparent_link_mode = familytree_coparent_link_mode(anchor, coparent, person, house, adopted)
			var/link_mode = coparent_link_mode ? coparent_link_mode : familytree_parent_link_mode(anchor.person, person, house, adopted)
			success = familytree_add_parent_link(new_member, anchor, link_mode)
			if(success && coparent_link_mode && new_member.get_parent_members().len < 2)
				familytree_add_parent_link(new_member, coparent, coparent_link_mode)
		if("sibling")
			var/list/all_anchor_parents = anchor.get_parent_members()
			var/list/anchor_parents = list()
			for(var/datum/family_member/p as anything in all_anchor_parents)
				if(p && !p.cosmetic)
					anchor_parents += p
			if(anchor_parents.len)
				success = TRUE
				var/force_adoptive_sibling_parentage = adopted
				if(anchor_parents.len >= 2)
					var/datum/family_member/anchor_parent_a = anchor_parents[1]
					var/datum/family_member/anchor_parent_b = anchor_parents[2]
					if(anchor_parent_a?.person && anchor_parent_b?.person && !familytree_biological_parent_pair_allowed(anchor_parent_a.person, anchor_parent_b.person, person, house))
						force_adoptive_sibling_parentage = TRUE
				for(var/datum/family_member/parent as anything in anchor_parents)
					if(parent?.person && !familytree_relative_species_compatible(person, parent.person))
						success = FALSE
						break
					var/sibling_parent_mode = (parent?.person && !force_adoptive_sibling_parentage) ? familytree_parent_link_mode(parent.person, person, house, FALSE) : "adoptive"
					if(!familytree_add_parent_link(new_member, parent, sibling_parent_mode))
						success = FALSE
						break
			else
				var/datum/family_member/canonical_parent = familytree_find_canonical_phantom(house, anchor.generation - 1)
				if(canonical_parent)
					if(anchor.AddParent(canonical_parent))
						success = new_member.AddParent(canonical_parent)
				else
					created_phantom_parent = familytree_create_phantom_member(house, anchor.generation - 1)
					if(created_phantom_parent && anchor.AddParent(created_phantom_parent))
						success = new_member.AddParent(created_phantom_parent)
		if("parent")
			var/parent_link_mode = familytree_parent_link_mode(person, anchor.person, house, adopted)
			if(!adopted)
				for(var/datum/family_member/existing_parent as anything in anchor.get_parent_members())
					if(existing_parent?.cosmetic)
						continue
					if(existing_parent?.person && !familytree_biological_parent_pair_allowed(person, existing_parent.person, anchor.person, house))
						parent_link_mode = "adoptive"
						break
			success = familytree_add_parent_link(anchor, new_member, parent_link_mode)
		if("uncle_aunt")
			success = familytree_apply_uncle_aunt_relation(house, new_member, anchor)

	if(!success)
		house.RemoveFamilyMember(new_member)
		if(created_phantom_parent)
			house.RemoveFamilyMember(created_phantom_parent)
		return null

	if(!house.founder)
		house.founder = new_member
		new_member.generation = 0
	if(!house.housename)
		house.housename = house.SurnameFormatting(person)
	to_chat(person, span_notice("Вы были добавлены в семью [house.housename]."))
	house.InheritCurses(new_member)
	return new_member

/datum/controller/subsystem/familytree/proc/familytree_relative_assignment_audit_text(list/assignment)
	if(!islist(assignment))
		return "relative"
	var/role = assignment["role"] || "relative"
	switch(role)
		if("uncle_aunt")
			role = "uncle/aunt"
	var/datum/family_member/anchor = assignment["anchor"]
	if(anchor?.person)
		return "[role] of [key_name(anchor.person)]"
	return role

/datum/controller/subsystem/familytree/proc/familytree_forced_role_from_relative_role(relative_role)
	switch(relative_role)
		if(RELATIVE_SIBLING)
			return "sibling"
		if(RELATIVE_PARENT)
			return "parent"
		if(RELATIVE_CHILD)
			return "child"
		if(RELATIVE_UNCLE_AUNT)
			return "uncle_aunt"
	return null

/datum/controller/subsystem/familytree/proc/familytree_best_parent_member(datum/heritage/house, mob/living/carbon/human/child, datum/family_member/exclude = null)
	if(!house || !child)
		return null
	var/list/candidates = list()
	for(var/datum/family_member/member as anything in house.members)
		if(member == exclude || !member?.person)
			continue
		if(member.cosmetic || member.phantom)
			continue
		if(!CanBeParentOf(member.person, child))
			continue
		if(!familytree_biological_parent_allowed(member.person, child, house))
			continue
		if(exclude?.person && !familytree_biological_parent_pair_allowed(member.person, exclude.person, child, house))
			continue
		candidates += member
	if(!candidates.len)
		return null
	return pick(candidates)

/datum/controller/subsystem/familytree/proc/familytree_best_sibling_member(datum/heritage/house, mob/living/carbon/human/person)
	if(!house || !person)
		return null
	var/list/candidates = list()
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person)
			continue
		if(member.cosmetic || member.phantom)
			continue
		if(!CanBeSiblings(member.person.age, person.age))
			continue
		candidates += member
	if(!candidates.len)
		return null
	return pick(candidates)

/datum/controller/subsystem/familytree/proc/familytree_best_child_member_for_parent(datum/heritage/house, mob/living/carbon/human/parent)
	if(!house || !parent)
		return null
	var/list/candidates = list()
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person)
			continue
		if(member.cosmetic || member.phantom)
			continue
		if(member.get_parent_members().len >= 2)
			continue
		if(!CanBeParentOf(parent, member.person))
			continue
		if(!familytree_biological_parent_allowed(parent, member.person, house))
			continue
		var/parent_pair_allowed = TRUE
		for(var/datum/family_member/existing_parent as anything in member.get_parent_members())
			if(existing_parent?.person && !existing_parent.cosmetic && !familytree_biological_parent_pair_allowed(parent, existing_parent.person, member.person, house))
				parent_pair_allowed = FALSE
				break
		if(!parent_pair_allowed)
			continue
		candidates += member
	if(!candidates.len)
		return null
	return pick(candidates)

/datum/controller/subsystem/familytree/proc/familytree_house_supports_role(datum/heritage/house, mob/living/carbon/human/person, forced_role)
	if(!house || !person)
		return FALSE
	if(!forced_role)
		return familytree_pick_random_relative_assignment(house, person) ? TRUE : FALSE
	switch(forced_role)
		if("child")
			return familytree_pick_random_relative_assignment(house, person, "child") ? TRUE : FALSE
		if("sibling")
			return familytree_pick_random_relative_assignment(house, person, "sibling") ? TRUE : FALSE
		if("parent")
			return familytree_pick_random_relative_assignment(house, person, "parent") ? TRUE : FALSE
		if("uncle_aunt")
			return familytree_pick_random_relative_assignment(house, person, "uncle_aunt") ? TRUE : FALSE
	return FALSE

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
		if(!house_race_compatible(house, our_race, our_isolated, H))
			continue

		var/has_single_adult = FALSE
		for(var/datum/family_member/member as anything in house.members)
			if(member.person && familytree_polygamy_compatible(H, member.person))
				if(!member.person.client)
					continue
				if(!member.person.setspouse || !length(member.person.setspouse) || familytree_targets_name(member.person, H))
					var/candidate_soft_reject_mask = familytree_pair_soft_pref_reject_mask(H, member.person)
					if(candidate_soft_reject_mask & FTREJ_N_PRONOUNS)
						continue
					if(candidate_soft_reject_mask & FTREJ_N_SPECIES)
						continue
					if(!familytree_estates_compatible(H, member.person))
						continue
					if(!familytree_role_tiers_compatible(H, member.person))
						continue
					if(familytree_pref_is_join_only(member.person.familytree_pref))
						continue
					has_single_adult = TRUE
					eligible_houses += house
					break

		if(!has_single_adult && !house.housename)
			eligible_houses += house

	ftlog("AssignToFamily: [H.real_name] eligible_houses=[eligible_houses.len]")
	if(!eligible_houses.len)
		ftlog("AssignToFamily: [H.real_name] no eligible houses, creating new")
		familytree_found_new_house(H, "created new house; spouse role found no eligible house")
		return

	for(var/datum/heritage/house as anything in eligible_houses)
		for(var/datum/family_member/member as anything in house.members)
			if(member.person && familytree_polygamy_compatible(H, member.person))
				if(!member.person.client)
					continue
				if(!member.person.setspouse || !length(member.person.setspouse) || familytree_targets_name(member.person, H))
					var/final_soft_reject_mask = familytree_pair_soft_pref_reject_mask(H, member.person)
					if(!final_soft_reject_mask && familytree_estates_compatible(H, member.person) && familytree_role_tiers_compatible(H, member.person))
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
				GenerateCommonerParents(house, new_member)
				GenerateRandomSiblings(house, new_member, H.familytree_random_siblings)
				GenerateRandomChildren(house, new_member, H.familytree_random_children)
				familytree_admin_log_house_assignment(H, house, "founded unnamed eligible house")
				return

/datum/controller/subsystem/familytree/proc/familytree_is_new_family_candidate(mob/living/carbon/human/H)
	if(!H || H.family_datum)
		return FALSE
	var/family_mode = familytree_pref_mask(H.familytree_pref)
	if(family_mode & FAMILYTREE_MODE_CREATE)
		return TRUE
	if(family_mode & FAMILYTREE_MODE_JOIN)
		return familytree_join_create_fallback_open()
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_can_found_new_family(mob/living/carbon/human/H)
	if(!H || H.family_datum)
		return FALSE
	return !!(familytree_pref_mask(H.familytree_pref) & FAMILYTREE_MODE_CREATE)

/datum/controller/subsystem/familytree/proc/familytree_new_family_pair_eligible(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!familytree_is_new_family_candidate(A) || !familytree_is_new_family_candidate(B))
		return FALSE
	var/a_mode = familytree_pref_mask(A.familytree_pref)
	var/b_mode = familytree_pref_mask(B.familytree_pref)
	var/a_creates = !!(a_mode & FAMILYTREE_MODE_CREATE)
	var/b_creates = !!(b_mode & FAMILYTREE_MODE_CREATE)
	return a_creates || b_creates

/datum/controller/subsystem/familytree/proc/familytree_new_family_join_any_relation(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/a_join_only = familytree_pref_is_join_only(A?.familytree_pref)
	var/b_join_only = familytree_pref_is_join_only(B?.familytree_pref)
	if(a_join_only == b_join_only)
		return null
	var/list/relations = familytree_new_family_any_relation_options(A, B, FALSE)
	return familytree_stable_pick_new_family_relation(A, B, relations)

/datum/controller/subsystem/familytree/proc/familytree_new_family_any_relation_options(mob/living/carbon/human/A, mob/living/carbon/human/B, include_spouse = TRUE)
	var/list/relations = list()
	if(!A || !B)
		return relations
	if(include_spouse && familytree_polygamy_compatible(A, B))
		relations += "spouse"
	if(CanBeParentOf(A, B) && familytree_biological_parent_allowed(A, B))
		relations += "a_parent"
	if(CanBeParentOf(B, A) && familytree_biological_parent_allowed(B, A))
		relations += "b_parent"
	if(CanBeSiblings(A.age, B.age))
		relations += "sibling"
	if(familytree_can_be_uncle_aunt_of(A, B))
		relations += "a_uncle_aunt"
	if(familytree_can_be_uncle_aunt_of(B, A))
		relations += "b_uncle_aunt"
	return relations

/datum/controller/subsystem/familytree/proc/familytree_stable_pick_new_family_relation(mob/living/carbon/human/A, mob/living/carbon/human/B, list/relations)
	if(!relations?.len)
		return null
	var/seed_text = "[A?.ckey || A?.real_name || REF(A)]|[B?.ckey || B?.real_name || REF(B)]|[GLOB.round_id]"
	var/seed = 0
	for(var/i = 1 to length(seed_text))
		seed += (text2ascii(seed_text, i) || 0) * i
	var/index = (seed % relations.len) + 1
	return relations[index]

/datum/controller/subsystem/familytree/proc/familytree_new_family_pair_relation(mob/living/carbon/human/A, mob/living/carbon/human/B)
	if(!familytree_new_family_pair_eligible(A, B))
		return null

	var/a_role = A.desired_relative_role || RELATIVE_ANY
	var/b_role = B.desired_relative_role || RELATIVE_ANY
	var/a_join_only = familytree_pref_is_join_only(A.familytree_pref)
	var/b_join_only = familytree_pref_is_join_only(B.familytree_pref)

	if(a_role == RELATIVE_SPOUSE || b_role == RELATIVE_SPOUSE)
		var/a_allows_spouse = (a_role == RELATIVE_SPOUSE || (!a_join_only && a_role == RELATIVE_ANY))
		var/b_allows_spouse = (b_role == RELATIVE_SPOUSE || (!b_join_only && b_role == RELATIVE_ANY))
		if(a_allows_spouse && b_allows_spouse)
			return "spouse"
		return null

	if(a_role == RELATIVE_SIBLING || b_role == RELATIVE_SIBLING)
		if((a_role == RELATIVE_SIBLING || a_role == RELATIVE_ANY) && (b_role == RELATIVE_SIBLING || b_role == RELATIVE_ANY))
			return "sibling"
		return null

	if(a_role == RELATIVE_PARENT)
		if(b_role == RELATIVE_CHILD || b_role == RELATIVE_ANY)
			return "a_parent"
		return null
	if(b_role == RELATIVE_PARENT)
		if(a_role == RELATIVE_CHILD || a_role == RELATIVE_ANY)
			return "b_parent"
		return null

	if(a_role == RELATIVE_CHILD)
		if(b_role == RELATIVE_PARENT || b_role == RELATIVE_ANY)
			return "b_parent"
		return null
	if(b_role == RELATIVE_CHILD)
		if(a_role == RELATIVE_PARENT || a_role == RELATIVE_ANY)
			return "a_parent"
		return null

	if(a_role == RELATIVE_UNCLE_AUNT)
		if(b_role == RELATIVE_ANY)
			return "a_uncle_aunt"
		return null
	if(b_role == RELATIVE_UNCLE_AUNT)
		if(a_role == RELATIVE_ANY)
			return "b_uncle_aunt"
		return null

	if(a_role == RELATIVE_ANY && b_role == RELATIVE_ANY)
		if(!(a_join_only || b_join_only) && familytree_mutual_setspouse(A, B) && familytree_polygamy_compatible(A, B))
			return "spouse"
		var/list/relations = familytree_new_family_any_relation_options(A, B, !(a_join_only || b_join_only))
		return familytree_stable_pick_new_family_relation(A, B, relations)

	return null

/datum/controller/subsystem/familytree/proc/familytree_can_be_uncle_aunt_of(mob/living/carbon/human/uncle_aunt, mob/living/carbon/human/nibling)
	if(!uncle_aunt || !nibling)
		return FALSE
	if(CanBeParentOf(uncle_aunt, nibling))
		return TRUE
	return CanBeSiblings(uncle_aunt.age, nibling.age)

/datum/controller/subsystem/familytree/proc/familytree_new_family_relation_valid(mob/living/carbon/human/A, mob/living/carbon/human/B, relation)
	switch(relation)
		if("spouse")
			return familytree_polygamy_compatible(A, B)
		if("sibling")
			return CanBeSiblings(A.age, B.age)
		if("a_parent")
			return CanBeParentOf(A, B) && familytree_biological_parent_allowed(A, B)
		if("b_parent")
			return CanBeParentOf(B, A) && familytree_biological_parent_allowed(B, A)
		if("a_uncle_aunt")
			return familytree_can_be_uncle_aunt_of(A, B)
		if("b_uncle_aunt")
			return familytree_can_be_uncle_aunt_of(B, A)
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_create_phantom_member(datum/heritage/house, generation = 0)
	if(!house)
		return null
	var/datum/family_member/phantom = new /datum/family_member(null, house)
	phantom.generation = generation
	phantom.phantom = TRUE
	house.members += phantom
	return phantom

/datum/controller/subsystem/familytree/proc/familytree_apply_uncle_aunt_relation(datum/heritage/house, datum/family_member/uncle_aunt, datum/family_member/nibling)
	if(!house || !uncle_aunt || !nibling)
		return FALSE

	var/datum/family_member/parent_link = familytree_first_parent_for_uncle_aunt(nibling)
	if(!parent_link)
		parent_link = familytree_create_phantom_member(house, nibling.generation - 1)
		if(!parent_link)
			return FALSE
		if(!nibling.AddParent(parent_link))
			return FALSE

	var/datum/family_member/grandparent_link = familytree_first_parent_for_uncle_aunt(parent_link)
	if(!grandparent_link)
		grandparent_link = familytree_find_canonical_phantom(house, nibling.generation - 2)
		if(!grandparent_link)
			grandparent_link = familytree_create_phantom_member(house, nibling.generation - 2)
		if(!grandparent_link)
			return FALSE
		if(!parent_link.AddParent(grandparent_link))
			return FALSE

	return uncle_aunt.AddParent(grandparent_link)

/datum/controller/subsystem/familytree/proc/familytree_first_parent_for_uncle_aunt(datum/family_member/member)
	if(!member)
		return null
	var/datum/family_member/fallback = null
	for(var/datum/family_member/p as anything in member.get_parent_members())
		if(!p)
			continue
		if(p.person)
			return p
		if(!fallback)
			fallback = p
	return fallback

/datum/controller/subsystem/familytree/proc/familytree_first_phantom_parent(datum/family_member/member)
	if(!member)
		return null
	for(var/datum/family_member/p as anything in member.get_parent_members())
		if(p?.phantom)
			return p
	return null

/datum/controller/subsystem/familytree/proc/familytree_find_canonical_phantom(datum/heritage/house, generation)
	if(!house)
		return null
	var/datum/family_member/best = null
	var/best_descendants = -1
	for(var/datum/family_member/m as anything in house.members)
		if(!m?.phantom)
			continue
		if(m.generation != generation)
			continue
		if(m.get_parent_members().len)
			continue
		var/desc_count = m.get_child_members().len
		if(desc_count > best_descendants)
			best_descendants = desc_count
			best = m
	return best

/datum/controller/subsystem/familytree/proc/familytree_apply_new_family_relation(datum/heritage/house, mob/living/carbon/human/A, mob/living/carbon/human/B, relation)
	if(!house || !A || !B)
		return FALSE
	var/datum/family_member/member_a = house.GetFamilyMember(A)
	if(!member_a)
		member_a = house.CreateFamilyMember(A)
	var/datum/family_member/member_b = house.GetFamilyMember(B)
	if(!member_b)
		member_b = house.CreateFamilyMember(B)
	if(!member_a || !member_b)
		return FALSE

	switch(relation)
		if("sibling")
			var/datum/family_member/phantom_parent = familytree_create_phantom_member(house, min(member_a.generation, member_b.generation) - 1)
			if(!phantom_parent)
				return FALSE
			if(!member_a.AddParent(phantom_parent))
				return FALSE
			return member_b.AddParent(phantom_parent)
		if("a_parent")
			return member_b.AddParent(member_a)
		if("b_parent")
			return member_a.AddParent(member_b)
		if("a_uncle_aunt")
			return familytree_apply_uncle_aunt_relation(house, member_a, member_b)
		if("b_uncle_aunt")
			return familytree_apply_uncle_aunt_relation(house, member_b, member_a)
	return FALSE

/datum/controller/subsystem/familytree/proc/familytree_create_new_relative_house(mob/living/carbon/human/leader, mob/living/carbon/human/A, mob/living/carbon/human/B, relation)
	if(!leader || !A || !B || relation == "spouse")
		return null
	var/datum/heritage/new_house = new /datum/heritage(leader, null)
	new_house.closed = TRUE
	new_house.house_leader = new_house.founder
	register_family(new_house)
	if(!familytree_apply_new_family_relation(new_house, A, B, relation))
		new_house.RemovePersonFromFamily(A)
		new_house.RemovePersonFromFamily(B)
		families -= new_house
		return null
	return new_house

/datum/controller/subsystem/familytree/proc/familytree_new_family_relation_audit_text(mob/living/carbon/human/A, mob/living/carbon/human/B, relation, for_a)
	var/mob/living/carbon/human/other = for_a ? B : A
	switch(relation)
		if("sibling")
			return "created new house as sibling of [key_name(other)]"
		if("a_parent")
			return for_a ? "created new house as parent of [key_name(B)]" : "joined new house as child of [key_name(A)]"
		if("b_parent")
			return for_a ? "joined new house as child of [key_name(B)]" : "created new house as parent of [key_name(A)]"
		if("a_uncle_aunt")
			return for_a ? "created new house as uncle/aunt of [key_name(B)]" : "joined new house as niece/nephew of [key_name(A)]"
		if("b_uncle_aunt")
			return for_a ? "joined new house as niece/nephew of [key_name(B)]" : "created new house as uncle/aunt of [key_name(A)]"
	return "created new house as relative of [key_name(other)]"

/datum/controller/subsystem/familytree/proc/familytree_creator_pronouns_compatible(mob/living/carbon/human/creator, mob/living/carbon/human/partner)
	if(!creator || !partner)
		return FALSE
	var/pref = creator.gender_choice_pref || ANY_GENDER
	return pronoun_preference_matches(pref, creator.pronouns == partner.pronouns)

/datum/controller/subsystem/familytree/proc/GetCreatorSpeciesPreferenceFailureReason(mob/living/carbon/human/creator, mob/living/carbon/human/partner)
	if(!creator || !partner)
		return "missing mob"

	var/creator_isolated = is_isolated(creator)
	var/partner_isolated = is_isolated(partner)
	if(creator_isolated || partner_isolated)
		if(!creator_isolated || !partner_isolated)
			return "isolated group mismatch"

	var/creator_type = creator.dna.species.type
	var/partner_type = partner.dna.species.type
	var/list/pref_types = get_familytree_species_type_list(creator.preferred_species_types)
	var/species_mode = creator.species_preference_mode
	if(!species_mode)
		species_mode = "ANY"

	switch(species_mode)
		if("ANY")
			;
		if("SAME_TYPE")
			if(creator_type != partner_type)
				return "species mismatch"
		if("SPECIFIC_TYPE")
			if(!(partner_type in pref_types))
				return "species mismatch"

	if(!AnatomyCompatible(creator.preferred_species_anatomy, partner))
		return "anatomy mismatch"

	return null

/datum/controller/subsystem/familytree/proc/familytree_creator_role_tiers_compatible(mob/living/carbon/human/creator, mob/living/carbon/human/partner)
	var/creator_tier = familytree_get_role_tier(creator)
	var/partner_tier = familytree_get_role_tier(partner)

	if((creator_tier == ROLE_TIER_LOW && partner_tier == ROLE_TIER_HIGH) || (creator_tier == ROLE_TIER_HIGH && partner_tier == ROLE_TIER_LOW))
		return FALSE

	if(creator_tier == partner_tier)
		return TRUE
	if(creator_tier == ROLE_TIER_NONE && partner_tier != ROLE_TIER_LOW)
		return TRUE
	if(partner_tier == ROLE_TIER_NONE && creator_tier != ROLE_TIER_LOW)
		return TRUE
	if(creator_tier == ROLE_TIER_LOW && partner_tier != ROLE_TIER_LOW)
		return partner.allow_low_status_marriage
	if(partner_tier == ROLE_TIER_LOW && creator_tier != ROLE_TIER_LOW)
		return creator.allow_low_status_marriage
	return TRUE

/datum/controller/subsystem/familytree/proc/familytree_new_family_creator_pref_reject_mask(mob/living/carbon/human/creator, mob/living/carbon/human/partner)
	var/reject_mask = 0
	if(!familytree_creator_pronouns_compatible(creator, partner))
		reject_mask |= FTREJ_N_PRONOUNS
	if(GetCreatorSpeciesPreferenceFailureReason(creator, partner))
		reject_mask |= FTREJ_N_SPECIES
	if(!familytree_creator_role_tiers_compatible(creator, partner))
		reject_mask |= FTREJ_N_TIER
	return reject_mask

/datum/controller/subsystem/familytree/proc/familytree_soft_pref_reject_mask(mob/living/carbon/human/seeker, mob/living/carbon/human/partner)
	var/reject_mask = 0
	if(!familytree_creator_pronouns_compatible(seeker, partner))
		reject_mask |= FTREJ_N_PRONOUNS
	if(GetCreatorSpeciesPreferenceFailureReason(seeker, partner))
		reject_mask |= FTREJ_N_SPECIES
	return reject_mask

/datum/controller/subsystem/familytree/proc/familytree_pair_soft_pref_reject_mask(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/reject_mask = 0
	if(!familytree_targets_name(A, B))
		reject_mask |= familytree_soft_pref_reject_mask(A, B)
	if(!familytree_targets_name(B, A))
		reject_mask |= familytree_soft_pref_reject_mask(B, A)
	return reject_mask

/datum/controller/subsystem/familytree/proc/familytree_new_family_pair_pref_reject_mask(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/reject_mask = familytree_pair_soft_pref_reject_mask(A, B)
	if(!familytree_role_tiers_compatible(A, B))
		reject_mask |= FTREJ_N_TIER
	return reject_mask

/datum/controller/subsystem/familytree/proc/familytree_new_family_founder(mob/living/carbon/human/A, mob/living/carbon/human/B)
	var/a_creates = familytree_pref_is_create(A?.familytree_pref)
	var/b_creates = familytree_pref_is_create(B?.familytree_pref)
	if(b_creates && !a_creates)
		return B
	return A

/datum/controller/subsystem/familytree/proc/wait_for_new_family_founder(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.family_datum)
		return
	if(!familytree_is_new_family_candidate(H))
		if(familytree_pref_is_join(H.familytree_pref))
			wait_for_relative_house(H, "new-family fallback is not active")
		return
	if(!(H in viable_spouses))
		viable_spouses += H
	INVOKE_ASYNC(src, PROC_REF(find_and_confirm_newlywed), H)
	wait_for_new_family_match(H, "waiting for a new family founder")

/datum/controller/subsystem/familytree/proc/wait_for_new_family_match(mob/living/carbon/human/H, reason)
	if(!H || QDELETED(H) || H.family_datum || H.familytree_opted_out)
		return
	if(H.familytree_confirmation_pending)
		ftlog("WAIT_NEW_FAMILY SKIP: [H.real_name] confirmation pending reason=[reason]")
		return
	if(H.familytree_assignment_scheduled)
		ftlog("WAIT_NEW_FAMILY SKIP: [H.real_name] already scheduled reason=[reason]")
		return
	if(!(H in viable_spouses))
		viable_spouses += H
	ftlog("WAIT_NEW_FAMILY: [H.real_name] reason=[reason], scheduling re-assignment in 20s")
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 20 SECONDS)

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
	for(var/mob/living/carbon/human/candidate as anything in viable_spouses.Copy())
		if(!candidate || QDELETED(candidate))
			viable_spouses -= candidate
			continue
		if(candidate == H)
			continue
		if(candidate.family_datum)
			viable_spouses -= candidate
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(candidate.familytree_opted_out)
			viable_spouses -= candidate
			reject_mask |= FTREJ_N_OPTOUT
			continue
		if(!familytree_is_new_family_candidate(candidate))
			viable_spouses -= candidate
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(!familytree_new_family_pair_eligible(H, candidate))
			reject_mask |= FTREJ_N_BLOCK
			continue
		var/relation = familytree_new_family_pair_relation(H, candidate)
		if(!relation)
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(candidate.familytree_confirmation_pending)
			reject_mask |= FTREJ_N_BLOCK
			continue
		var/cand_block = get_familytree_runtime_block_reason(candidate, TRUE)
		if(cand_block)
			viable_spouses -= candidate
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(familytree_pair_blocked(H, candidate))
			reject_mask |= FTREJ_N_BLOCK
			continue
		if(relation == "spouse" && !familytree_polygamy_compatible(H, candidate))
			reject_mask |= FTREJ_N_POLY
			continue
		if(!familytree_new_family_relation_valid(H, candidate, relation))
			reject_mask |= FTREJ_N_BLOCK
			continue
		var/pref_reject_mask = familytree_new_family_pair_pref_reject_mask(H, candidate)
		if(pref_reject_mask)
			reject_mask |= pref_reject_mask
			continue
		if(!familytree_estates_compatible(H, candidate))
			reject_mask |= FTREJ_N_ESTATE
			continue
		if(!familytree_name_lock_allows_pair(H, candidate))
			reject_mask |= FTREJ_N_SETSPOUSE
			continue
		var/priority = 0
		if(familytree_mutual_setspouse(H, candidate))
			priority += 100
		else
			if(familytree_targets_name(H, candidate))
				priority += 10
			if(familytree_targets_name(candidate, H))
				priority += 10
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
	var/list/potential_matches = list()

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			reject_mask |= FTREJ_F_CLOSED
			continue
		if(!house_race_compatible(house, our_race, our_isolated, H))
			reject_mask |= FTREJ_F_RACE
			continue
		houses_scanned++
		for(var/datum/family_member/member as anything in house.members)
			if(!member.person)
				continue
			if(member.person.familytree_confirmation_pending)
				reject_mask |= FTREJ_F_OFFLINE
				continue
			if(!familytree_polygamy_compatible(H, member.person))
				reject_mask |= FTREJ_F_POLY
				continue
			if(!member.person.client)
				reject_mask |= FTREJ_F_OFFLINE
				continue
			if(!familytree_name_lock_allows_pair(H, member.person))
				reject_mask |= FTREJ_F_SETSPOUSE
				continue
			var/soft_reject_mask = familytree_pair_soft_pref_reject_mask(H, member.person)
			if(soft_reject_mask & FTREJ_N_PRONOUNS)
				reject_mask |= FTREJ_F_PRONOUNS
				continue
			if(soft_reject_mask & FTREJ_N_SPECIES)
				reject_mask |= FTREJ_F_SPECIES
				continue
			if(!familytree_estates_compatible(H, member.person))
				reject_mask |= FTREJ_F_ESTATE
				continue
			if(!familytree_role_tiers_compatible(H, member.person))
				reject_mask |= FTREJ_F_TIER
				continue
			if(familytree_pref_is_join_only(member.person.familytree_pref))
				reject_mask |= FTREJ_F_PARTIAL
				continue
			if(member.person.familytree_opted_out)
				reject_mask |= FTREJ_F_OPTOUT
				continue
			if(familytree_pair_blocked(H, member.person))
				reject_mask |= FTREJ_F_OPTOUT
				continue
			potential_matches += list(list(house, member, house.member_nodes.len))

	ftlog("FindFamilyMatch REJECTS [H.real_name] (houses=[families.len]): mask=[reject_mask] ([ftreject_decode_family(reject_mask)]) -> matches=[potential_matches.len]", potential_matches.len ? FTLOG_DEBUG : FTLOG_WARN)
	if(!potential_matches.len)
		return null

	var/list/preferred_matches = list()
	for(var/list/match_data in potential_matches)
		if(match_data[3] < FAMILYTREE_PREFERRED_MIN_HOUSE_SIZE)
			preferred_matches += list(match_data)

	var/list/match_pool = preferred_matches.len ? preferred_matches : potential_matches
	var/list/best_matches = list()
	if(preferred_matches.len)
		var/min_house_size = 100000
		for(var/list/match_data in match_pool)
			min_house_size = min(min_house_size, match_data[3])
		for(var/list/match_data in match_pool)
			if(match_data[3] == min_house_size)
				best_matches += list(match_data)
	else
		best_matches = match_pool.Copy()

	var/list/chosen = pick(best_matches)
	var/datum/heritage/chosen_house = chosen[1]
	var/datum/family_member/chosen_member = chosen[2]
	ftlog("FindFamilyMatch [H.real_name] -> [chosen_member.person.real_name] in '[chosen_house.housename]' (scanned=[houses_scanned]h matches=[potential_matches.len] chosen_size=[chosen[3]] preferred_min=[FAMILYTREE_PREFERRED_MIN_HOUSE_SIZE])", FTLOG_DEBUG)
	return list(chosen_house, chosen_member)

/datum/controller/subsystem/familytree/proc/AssignNewlyWed(mob/living/carbon/human/H)
	if(!H)
		return
	find_and_confirm_newlywed(H)

/datum/controller/subsystem/familytree/proc/AssignAuntUncle(mob/living/carbon/human/H)
	AssignToHouse(H, "uncle_aunt")

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

	for(var/datum/heritage/house as anything in families)
		if(house.closed)
			continue
		if(!house.housename || house.housename == "no name")
			continue
		if(!house_allows_relatives(house, H))
			continue
		if(!house_relative_compatible(house, H))
			continue
		if(!familytree_house_supports_role(house, H, forced_role))
			continue
		if(house.member_nodes.len >= 1 && house_has_online_member(house))
			return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/TryFormSiblingHouseFromPartial(mob/living/carbon/human/H)
	if(!H || H.family_datum)
		return FALSE

	var/list/candidates = list()
	for(var/mob/living/carbon/human/candidate as anything in GLOB.alive_mob_list)
		if(candidate == H || !candidate.client || candidate.stat == DEAD || !familytree_pref_is_join_only(candidate.familytree_pref) || candidate.family_datum)
			continue
		if(candidate.familytree_confirmation_pending)
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
		candidates += candidate

	if(candidates.len)
		var/mob/living/carbon/human/chosen = pick(candidates)
		ftlog("TryFormSiblingHouseFromPartial: [H.real_name] + [chosen.real_name] -> forming sibling house (candidates=[candidates.len])")
		var/sibling_text = familytree_role_text_ru("sibling")
		request_mutual_confirmation(H, chosen, CALLBACK(src, PROC_REF(do_form_sibling_house), H, chosen), "sibling_house", sibling_text, sibling_text)
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

/datum/controller/subsystem/familytree/proc/pick_least_filled_house(list/candidates)
	if(!candidates.len)
		return null
	if(candidates.len == 1)
		return candidates[1]
	var/min_member_count = 100000
	for(var/datum/heritage/house as anything in candidates)
		min_member_count = min(min_member_count, house.member_nodes.len)
	var/list/least_filled = list()
	for(var/datum/heritage/house as anything in candidates)
		if(house.member_nodes.len == min_member_count)
			least_filled += house
	return pick(least_filled)

/datum/controller/subsystem/familytree/proc/pick_preferred_family_house(list/candidates)
	if(!candidates.len)
		return null
	if(candidates.len == 1)
		return candidates[1]

	var/list/weighted = list()
	for(var/datum/heritage/house as anything in candidates)
		var/size = house.member_nodes.len
		var/weight = 1
		if(size < FAMILYTREE_PREFERRED_MIN_HOUSE_SIZE)
			weight = (FAMILYTREE_PREFERRED_MIN_HOUSE_SIZE - size) * 3 + 1
		weighted[house] = weight

	var/datum/heritage/picked = pickweight(weighted)
	if(picked)
		return picked
	return pick(candidates)

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

/datum/controller/subsystem/familytree/proc/house_allows_relatives(datum/heritage/house, mob/living/carbon/human/seeker = null)
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
	if(!familytree_relative_join_phase_open())
		return
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H?.client || H.family_datum || !familytree_pref_is_join(H.familytree_pref))
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

/datum/controller/subsystem/familytree/proc/schedule_house_member_resync(datum/heritage/house, delay = 1 SECONDS, attempt = 1)
	if(!house || QDELETED(house))
		return
	addtimer(CALLBACK(src, PROC_REF(resync_house_members), house, attempt), delay)

/datum/controller/subsystem/familytree/proc/resync_house_members(datum/heritage/house, attempt = 1)
	if(!house || QDELETED(house))
		return
	var/list/people = list()
	var/needs_retry = FALSE
	for(var/datum/family_node/node as anything in house.member_nodes)
		var/mob/living/carbon/human/H = node?.person
		if(!H || QDELETED(H))
			continue
		people += H
		if(!H.mind)
			needs_retry = TRUE
	for(var/i = 1 to people.len)
		var/mob/living/carbon/human/A = people[i]
		for(var/j = i + 1 to people.len)
			var/mob/living/carbon/human/B = people[j]
			introduce_pair(A, B)
	if(needs_retry && attempt < 10)
		schedule_house_member_resync(house, 3 SECONDS, attempt + 1)

/datum/controller/subsystem/familytree/proc/introduce_pair(mob/living/carbon/human/A, mob/living/carbon/human/B, retry_count = 0)
	if(!A || !B || A == B)
		return
	var/needs_retry = FALSE
	if(A.mind)
		A.mind.i_know_person(B)
		if(B.mind)
			fix_family_fjob(A, B)
	else
		needs_retry = TRUE
	if(B.mind)
		B.mind.i_know_person(A)
		if(A.mind)
			fix_family_fjob(B, A)
	else
		needs_retry = TRUE
	if(needs_retry && retry_count < 10)
		addtimer(CALLBACK(src, PROC_REF(delayed_introduce_pair), A, B, retry_count + 1), 3 SECONDS)

/datum/controller/subsystem/familytree/proc/delayed_introduce_pair(mob/living/carbon/human/A, mob/living/carbon/human/B, retry_count = 1)
	if(!A || QDELETED(A) || !B || QDELETED(B))
		return
	introduce_pair(A, B, retry_count)

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
