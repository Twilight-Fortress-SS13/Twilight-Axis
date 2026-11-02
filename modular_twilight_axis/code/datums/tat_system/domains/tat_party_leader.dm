/datum/component/tat_party_leader
	var/mob/living/carbon/human/leader
	var/list/applied_bonuses = list()
	var/refresh_queued = FALSE

/datum/component/tat_party_leader/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	leader = parent
	queue_refresh()
	return

/datum/component/tat_party_leader/Destroy(force)
	clear_all_bonuses()
	leader = null
	applied_bonuses = null
	return ..()

/datum/component/tat_party_leader/proc/queue_refresh()
	if(refresh_queued || QDELETED(src))
		return
	refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(refresh_bonus)), TAT_PARTY_LEADER_REFRESH_INTERVAL)

/datum/component/tat_party_leader/proc/refresh_bonus()
	refresh_queued = FALSE
	if(QDELETED(src))
		return
	if(!leader || QDELETED(leader))
		clear_all_bonuses()
		return

	var/list/desired_bonuses = build_desired_bonuses()
	reconcile_bonuses(desired_bonuses)
	queue_refresh()

/datum/component/tat_party_leader/proc/build_desired_bonuses()
	var/list/desired = list()
	if(!can_leader_project_aura())
		return desired

	var/datum/fellowship/fellowship = leader.current_fellowship
	if(!fellowship || fellowship.get_leader() != leader)
		return desired

	var/list/nearby_members = list()
	for(var/mob/living/carbon/human/member as anything in fellowship.get_members())
		if(member == leader)
			continue
		if(!can_receive_fellowship_bonus(member))
			continue
		nearby_members += member
		desired[member] = list(STATKEY_CON = TAT_PARTY_LEADER_MEMBER_CON)

	if(length(nearby_members))
		desired[leader] = list(
			STATKEY_CON = TAT_PARTY_LEADER_BONUS_CON,
			STATKEY_WIL = TAT_PARTY_LEADER_BONUS_WIL,
			STATKEY_LCK = TAT_PARTY_LEADER_LUCK_PER_MEMBER * length(nearby_members),
		)

	return desired

/datum/component/tat_party_leader/proc/can_leader_project_aura()
	if(!leader || QDELETED(leader))
		return FALSE
	if(leader.stat == DEAD)
		return FALSE
	if(!leader.current_fellowship)
		return FALSE
	return TRUE

/datum/component/tat_party_leader/proc/can_receive_fellowship_bonus(mob/living/carbon/human/member)
	if(!member || QDELETED(member))
		return FALSE
	if(member.stat == DEAD)
		return FALSE
	if(member.z != leader.z)
		return FALSE
	return get_dist(leader, member) <= TAT_PARTY_LEADER_AURA_RANGE

/datum/component/tat_party_leader/proc/reconcile_bonuses(list/desired_bonuses)
	if(!applied_bonuses)
		applied_bonuses = list()

	for(var/mob/living/carbon/human/target as anything in applied_bonuses.Copy())
		if(!(target in desired_bonuses))
			remove_bonus_set(target, applied_bonuses[target])
			applied_bonuses -= target
			continue
		var/list/old_stats = applied_bonuses[target]
		var/list/new_stats = desired_bonuses[target]
		reconcile_bonus_set(target, old_stats, new_stats)
		applied_bonuses[target] = new_stats.Copy()

	for(var/mob/living/carbon/human/target as anything in desired_bonuses)
		if(target in applied_bonuses)
			continue
		var/list/new_stats = desired_bonuses[target]
		apply_bonus_set(target, new_stats)
		applied_bonuses[target] = new_stats.Copy()

/datum/component/tat_party_leader/proc/reconcile_bonus_set(mob/living/carbon/human/target, list/old_stats, list/new_stats)
	if(!target || QDELETED(target))
		return
	for(var/stat_id in old_stats)
		var/old_delta = old_stats[stat_id]
		var/new_delta = new_stats[stat_id]
		if(!new_delta)
			target.change_stat(stat_id, -old_delta)
			continue
		var/diff = new_delta - old_delta
		if(diff)
			target.change_stat(stat_id, diff)
	for(var/stat_id in new_stats)
		if(stat_id in old_stats)
			continue
		var/new_delta = new_stats[stat_id]
		if(new_delta)
			target.change_stat(stat_id, new_delta)

/datum/component/tat_party_leader/proc/apply_bonus_set(mob/living/carbon/human/target, list/stats)
	if(!target || QDELETED(target))
		return
	for(var/stat_id in stats)
		var/delta = stats[stat_id]
		if(delta)
			target.change_stat(stat_id, delta)

/datum/component/tat_party_leader/proc/remove_bonus_set(mob/living/carbon/human/target, list/stats)
	if(!target || QDELETED(target))
		return
	for(var/stat_id in stats)
		var/delta = stats[stat_id]
		if(delta)
			target.change_stat(stat_id, -delta)

/datum/component/tat_party_leader/proc/clear_all_bonuses()
	if(!applied_bonuses)
		return
	for(var/mob/living/carbon/human/target as anything in applied_bonuses.Copy())
		remove_bonus_set(target, applied_bonuses[target])
	applied_bonuses.Cut()

/proc/tat_try_fellowship_headpat_mood(mob/living/carbon/human/patter, mob/living/carbon/human/target)
	if(!patter || !target || QDELETED(patter) || QDELETED(target))
		return FALSE
	var/datum/fellowship/fellowship = patter.current_fellowship
	if(!fellowship || fellowship.get_leader() != patter || !fellowship.has_member(target))
		return FALSE
	if(target == patter)
		return FALSE
	if(target.z != patter.z || get_dist(patter, target) > 1)
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	target.add_stress(/datum/stressevent/fellowship_headpat)
	return TRUE

/datum/stressevent/fellowship_headpat
	timer = 5 MINUTES
	stressadd = -1
	desc = span_green("My leader's reassurance steadies me.")


/datum/emote/living/pat/adjacentaction(mob/user, mob/target)
	. = ..()
	tat_try_fellowship_headpat_mood(user, target)
