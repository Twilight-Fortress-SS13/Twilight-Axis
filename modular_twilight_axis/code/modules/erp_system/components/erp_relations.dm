/datum/relationship
	var/mob/living/from_mob
	var/datum/weakref/to_ref
	var/flags = 0

/datum/relationship/proc/get_target()
	if(!to_ref)
		return null
	var/mob/living/M = to_ref.resolve()
	if(!M || QDELETED(M))
		to_ref = null
		return null
	return M

/datum/relationship/proc/set_target(mob/living/target)
	if(!target || QDELETED(target))
		return FALSE
	to_ref = WEAKREF(target)
	return TRUE

#define REL_OBSERVE_RADIUS 7

/datum/component/relationships
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/relations

/datum/component/relationships/Initialize()
	. = ..()
	relations = list()

/datum/component/relationships/RegisterWithParent()
	. = ..()
	START_PROCESSING(SSobj, src)

/datum/component/relationships/UnregisterFromParent()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/relationships/Destroy()
	STOP_PROCESSING(SSobj, src)
	relations = null
	return ..()

/datum/component/relationships/proc/_cleanup_invalid()
	if(!relations || !relations.len)
		return
	for(var/datum/relationship/R as anything in relations)
		if(!R)
			continue
		if(!R.get_target())
			relations -= R
			qdel(R)

/datum/component/relationships/proc/_find_by_mob(mob/living/target)
	if(!relations || !target)
		return null
	for(var/datum/relationship/R as anything in relations)
		if(!R)
			continue
		var/mob/living/T = R.get_target()
		if(T && T == target)
			return R
	return null

/datum/component/relationships/proc/has_relation_mob(mob/living/target, flags)
	if(!target || !flags)
		return FALSE
	_cleanup_invalid()
	var/datum/relationship/R = _find_by_mob(target)
	return !!(R && (R.flags & flags))

/datum/component/relationships/proc/add_relation_mob(mob/living/target, flags)
	if(!target || !flags)
		return FALSE

	_cleanup_invalid()
	var/datum/relationship/R = _find_by_mob(target)
	if(!R)
		R = new
		R.from_mob = parent
		R.set_target(target)
		relations += R

	var/old = R.flags
	R.flags |= flags
	return (R.flags != old)

/datum/component/relationships/proc/remove_relation_mob(mob/living/target, flags)
	if(!relations || !target || !flags)
		return FALSE

	_cleanup_invalid()
	var/datum/relationship/R = _find_by_mob(target)
	if(!R)
		return FALSE

	var/old = R.flags
	R.flags &= ~flags
	if(R.flags == 0)
		relations -= R
		qdel(R)
	return (R.flags != old)

/datum/component/relationships/proc/get_sex_multiplier(mob/living/partner)
	if(!relations || !relations.len || !partner)
		return 1

	_cleanup_invalid()
	var/match_mult = 1
	var/has_match = FALSE
	var/other_penalty = 1
	var/has_exclusive_someone = FALSE

	for(var/datum/relationship/R as anything in relations)
		if(!R || !R.flags)
			continue

		var/mob/living/T = R.get_target()
		if(!T)
			continue

		var/is_partner = (T == partner)

		for(var/flag in GLOB.relationship_settings)
			if(!(R.flags & flag))
				continue

			var/list/cfg = GLOB.relationship_settings[flag]
			if(!cfg)
				continue

			if(is_partner)
				if(isnum(cfg["sex_mult"]))
					match_mult = max(match_mult, cfg["sex_mult"])
					has_match = TRUE
			else
				if(isnum(cfg["other_sex_mult"]))
					other_penalty = min(other_penalty, cfg["other_sex_mult"])
					has_exclusive_someone = TRUE

	if(has_match)
		return match_mult

	if(has_exclusive_someone)
		return other_penalty

	return 1

/datum/component/relationships/proc/get_observe_params()
	if(!relations || !relations.len)
		return null

	var/mob/living/me = parent
	if(!istype(me) || QDELETED(me) || me.stat == DEAD)
		return null

	_cleanup_invalid()

	var/best_gain = 0
	var/best_cap = 0
	var/best_min = 0

	for(var/datum/relationship/R as anything in relations)
		if(!R || !R.flags)
			continue

		var/mob/living/T = R.get_target()
		if(!T)
			continue

		if(!(T in view(REL_OBSERVE_RADIUS, me)))
			continue

		for(var/flag in GLOB.relationship_settings)
			if(!(R.flags & flag))
				continue

			var/list/cfg = GLOB.relationship_settings[flag]
			if(!cfg)
				continue

			if(isnum(cfg["observe_min"]))
				best_min = max(best_min, cfg["observe_min"])
			if(isnum(cfg["observe_gain"]))
				best_gain = max(best_gain, cfg["observe_gain"])
			if(isnum(cfg["observe_cap"]))
				best_cap = max(best_cap, cfg["observe_cap"])

	if(best_gain <= 0 || best_cap <= 0)
		return null

	return list("observe_min" = best_min, "observe_gain" = best_gain, "observe_cap" = best_cap)

/datum/component/relationships/process(dt)
	if(!relations || !relations.len)
		return

	var/mob/living/me = parent
	if(!istype(me) || QDELETED(me) || me.stat == DEAD)
		return

	_cleanup_invalid()

	var/list/p = get_observe_params()
	if(!p)
		return

	var/minv = p["observe_min"] || 0
	var/gain = p["observe_gain"] || 0
	var/cap  = p["observe_cap"] || 0
	if(gain <= 0 || cap <= 0)
		return

	var/list/ad = list()
	SEND_SIGNAL(me, COMSIG_SEX_GET_AROUSAL, ad)
	var/current = ad["arousal"]
	if(!isnum(current))
		return

	if(current >= cap)
		return

	if(current < minv)
		var/add = min(gain * dt, minv - current)
		if(add > 0)
			SEND_SIGNAL(me, COMSIG_SEX_ADJUST_AROUSAL, add)
		return

	var/add2 = min(gain * dt, cap - current)
	if(add2 > 0)
		SEND_SIGNAL(me, COMSIG_SEX_ADJUST_AROUSAL, add2)

#undef REL_OBSERVE_RADIUS
