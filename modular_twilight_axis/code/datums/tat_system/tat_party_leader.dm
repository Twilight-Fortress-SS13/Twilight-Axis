/mob/living/carbon/human/proc/get_tat_party_leader_component()
	return GetComponent(/datum/component/tat_party_leader)

/mob/living/carbon/human/proc/tat_party_leader_invite()
	set name = "Invite to Party"
	set category = TAT_PARTY_LEADER_VERB_CATEGORY

	var/datum/component/tat_party_leader/C = get_tat_party_leader_component()
	if(!C)
		return FALSE
	return C.invite_member()

/mob/living/carbon/human/proc/tat_party_leader_remove()
	set name = "Remove Party Member"
	set category = TAT_PARTY_LEADER_VERB_CATEGORY

	var/datum/component/tat_party_leader/C = get_tat_party_leader_component()
	if(!C)
		return FALSE
	return C.remove_member()

/mob/living/carbon/human/proc/tat_party_leader_list()
	set name = "Check Party"
	set category = TAT_PARTY_LEADER_VERB_CATEGORY

	var/datum/component/tat_party_leader/C = get_tat_party_leader_component()
	if(!C)
		return FALSE
	return C.list_members()

/mob/living/carbon/human/proc/tat_party_leader_disband()
	set name = "Disband Party"
	set category = TAT_PARTY_LEADER_VERB_CATEGORY

	var/datum/component/tat_party_leader/C = get_tat_party_leader_component()
	if(!C)
		return FALSE
	return C.disband_party()

/datum/component/tat_party_leader
	var/mob/living/carbon/human/leader
	var/list/members = list()
	var/list/pending_invites = list()
	var/bonus_applied = FALSE

/datum/component/tat_party_leader/Initialize(mob/living/carbon/human/H)
	. = ..()
	if(!istype(H))
		return COMPONENT_INCOMPATIBLE

	leader = H
	add_verbs()
	refresh_bonus()
	return .

/datum/component/tat_party_leader/Destroy(force)
	remove_bonus()
	remove_verbs()

	for(var/mob/living/carbon/human/H as anything in members)
		if(H)
			to_chat(H, span_warning("[leader?.real_name || "Your leader"] disbands the party."))

	members = null
	pending_invites = null
	leader = null
	return ..()

/datum/component/tat_party_leader/proc/add_verbs()
	if(!leader)
		return
	leader.verbs += /mob/living/carbon/human/proc/tat_party_leader_invite
	leader.verbs += /mob/living/carbon/human/proc/tat_party_leader_remove
	leader.verbs += /mob/living/carbon/human/proc/tat_party_leader_list
	leader.verbs += /mob/living/carbon/human/proc/tat_party_leader_disband

/datum/component/tat_party_leader/proc/remove_verbs()
	if(!leader)
		return
	leader.verbs -= /mob/living/carbon/human/proc/tat_party_leader_invite
	leader.verbs -= /mob/living/carbon/human/proc/tat_party_leader_remove
	leader.verbs -= /mob/living/carbon/human/proc/tat_party_leader_list
	leader.verbs -= /mob/living/carbon/human/proc/tat_party_leader_disband

/datum/component/tat_party_leader/proc/get_nearby_candidates()
	var/list/candidates = list()
	if(!leader || !leader.loc)
		return candidates

	for(var/mob/living/carbon/human/H in view(TAT_PARTY_LEADER_INVITE_RANGE, leader))
		if(H == leader)
			continue
		if(QDELETED(H))
			continue
		if(H in members)
			continue
		if(H in pending_invites)
			continue
		candidates += H

	return candidates

/datum/component/tat_party_leader/proc/invite_member()
	if(!leader)
		return FALSE

	var/list/candidates = get_nearby_candidates()
	if(!length(candidates))
		to_chat(leader, span_warning("There is no one nearby to invite."))
		return FALSE

	var/mob/living/carbon/human/target = tgui_input_list(leader, "Who do you want to invite into your party?", "Invite Party Member", candidates)
	if(!target)
		return FALSE

	if(target == leader || QDELETED(target))
		return FALSE

	if(target in members)
		to_chat(leader, span_warning("[target.real_name] is already in your party."))
		return FALSE

	if(target in pending_invites)
		to_chat(leader, span_warning("[target.real_name] already has a pending invitation."))
		return FALSE

	pending_invites += target
	to_chat(leader, span_notice("You invite [target.real_name] into your party."))

	var/answer = alert(target, "[leader.real_name] wants you to join their party.", "Party Invitation", "Accept", "Decline")

	pending_invites -= target

	if(QDELETED(src) || !leader || QDELETED(leader) || QDELETED(target))
		return FALSE

	if(answer != "Accept")
		to_chat(leader, span_warning("[target.real_name] declines your invitation."))
		to_chat(target, span_warning("You decline [leader.real_name]'s invitation."))
		refresh_bonus()
		return FALSE

	if(target in members)
		refresh_bonus()
		return FALSE

	members += target
	to_chat(leader, span_notice("[target.real_name] joins your party."))
	to_chat(target, span_notice("You join [leader.real_name]'s party."))
	refresh_bonus()
	return TRUE

/datum/component/tat_party_leader/proc/remove_member()
	if(!leader)
		return FALSE

	prune_invalid_members()

	if(!length(members))
		to_chat(leader, span_warning("Your party is empty."))
		return FALSE

	var/mob/living/carbon/human/target = tgui_input_list(leader, "Who do you want to remove from your party?", "Remove Party Member", members)
	if(!target)
		return FALSE

	if(!(target in members))
		return FALSE

	members -= target
	to_chat(leader, span_warning("[target.real_name] is removed from your party."))
	if(target)
		to_chat(target, span_warning("You have been removed from [leader.real_name]'s party."))

	refresh_bonus()
	return TRUE

/datum/component/tat_party_leader/proc/list_members()
	if(!leader)
		return FALSE

	prune_invalid_members()

	if(!length(members))
		to_chat(leader, span_notice("Your party currently has no members."))
		return TRUE

	var/list/names = list()
	for(var/mob/living/carbon/human/H as anything in members)
		if(QDELETED(H))
			continue
		names += H.real_name

	to_chat(leader, span_info("Your party members: [english_list(names)]."))
	to_chat(leader, span_smallnotice("Leader bonus is [has_minimum_party() ? "active" : "inactive"]."))
	return TRUE

/datum/component/tat_party_leader/proc/disband_party()
	if(!leader)
		return FALSE

	for(var/mob/living/carbon/human/H as anything in members)
		if(H)
			to_chat(H, span_warning("[leader.real_name] disbands the party."))

	members.Cut()
	pending_invites.Cut()
	refresh_bonus()
	to_chat(leader, span_warning("You disband your party."))
	return TRUE

/datum/component/tat_party_leader/proc/prune_invalid_members()
	if(!leader)
		return

	for(var/mob/living/carbon/human/H as anything in members.Copy())
		if(QDELETED(H))
			members -= H
			continue
		if(get_dist(leader, H) > TAT_PARTY_LEADER_INVITE_RANGE)
			members -= H
			to_chat(leader, span_warning("[H.real_name] is no longer close enough to remain in your party."))
			if(H)
				to_chat(H, span_warning("You are no longer close enough to [leader.real_name] to remain in the party."))

	for(var/mob/living/carbon/human/H as anything in pending_invites.Copy())
		if(QDELETED(H))
			pending_invites -= H

/datum/component/tat_party_leader/proc/has_minimum_party()
	prune_invalid_members()
	return length(members) >= TAT_PARTY_LEADER_MIN_MEMBERS

/datum/component/tat_party_leader/proc/apply_bonus()
	if(!leader || bonus_applied)
		return

	leader.change_stat(STATKEY_CON, TAT_PARTY_LEADER_BONUS_CON)
	leader.change_stat(STATKEY_WIL, TAT_PARTY_LEADER_BONUS_WIL)
	bonus_applied = TRUE
	to_chat(leader, span_notice("Your leadership strengthens you. (+1 CON, +1 WIL)"))

/datum/component/tat_party_leader/proc/remove_bonus()
	if(!leader || !bonus_applied)
		return

	leader.change_stat(STATKEY_CON, -TAT_PARTY_LEADER_BONUS_CON)
	leader.change_stat(STATKEY_WIL, -TAT_PARTY_LEADER_BONUS_WIL)
	bonus_applied = FALSE
	to_chat(leader, span_warning("Your leadership bonus fades."))

/datum/component/tat_party_leader/proc/refresh_bonus()
	if(has_minimum_party())
		apply_bonus()
	else
		remove_bonus()
