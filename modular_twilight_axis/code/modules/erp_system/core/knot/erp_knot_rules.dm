/datum/erp_knot_rules

/// Returns a non-null reason string if knot cannot be started; otherwise returns null.
/datum/erp_knot_rules/proc/can_start_knot(mob/living/user, mob/living/target, datum/erp_sex_organ/penis/penis_org, datum/erp_sex_organ/receiving_org, penis_unit_id = 0, force_level = 0)
	if(!istype(user) || !istype(target))
		return "bad_actor"
	if(!penis_org || !receiving_org)
		return "bad_organs"
	if(get_dist(user, target) > 1)
		return "too_far"
	if(!penis_org.have_knot)
		return "no_knot"

	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/arous = arousal_data["arousal"] || 0
	if(arous < AROUSAL_HARD_ON_THRESHOLD)
		return "too_soft"

	return null

/// Returns pull-out chance for the actor (top/btm), including link bonuses.
/datum/erp_knot_rules/proc/get_pull_out_chance(datum/erp_knot_link/L, mob/living/actor)
	if(!L || !L.is_valid() || !istype(actor))
		return 0

	var/is_owner = (actor == L.top)
	var/is_btm = (actor == L.btm)
	if(!is_owner && !is_btm)
		return 0

	var/chance = is_owner ? ERP_KNOT_PULL_OWNER_BASE : ERP_KNOT_PULL_BTM_BASE

	if(is_owner)
		chance += L.get_owner_bonus()

	if(is_btm)
		chance -= round((L.strength / 100) * 20)

	return chance

/// Returns TRUE if link should be broken due to missing clients (policy gate).
/datum/erp_knot_rules/proc/should_break_for_missing_clients(datum/erp_knot_link/L)
	#ifndef LOCALTEST
	if(!L || !L.is_valid())
		return TRUE
	if(isnull(L.top?.client) || isnull(L.btm?.client))
		return TRUE
	#endif
	return FALSE
