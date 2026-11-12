#define KINK_PREF_DISLIKE	-1
#define KINK_PREF_NEUTRAL	0
#define KINK_PREF_LIKE		1

/datum/component/kinks
	var/list/prefs_by_type = list()

/datum/component/kinks/proc/get_pref(kink_typepath)
	var/v = prefs_by_type[kink_typepath]
	if(!isnum(v))
		return KINK_PREF_NEUTRAL
	return clamp(round(v), -1, 1)

/datum/component/kinks/proc/set_pref(kink_typepath, value)
	prefs_by_type[kink_typepath] = clamp(round(value), -1, 1)

/datum/component/kinks/proc/pref_to_mult(pref)
	switch(pref)
		if(KINK_PREF_DISLIKE) return 0.5
		if(KINK_PREF_LIKE)    return 2
	return 1

/datum/component/kinks/proc/get_arousal_multiplier(datum/erp_actor/owner, datum/erp_actor/partner, datum/erp_sex_link/L)
	if(!owner || !partner || !L)
		return 1

	var/total_pref = 0

	for(var/kink_type in GLOB.available_kinks)
		var/datum/kink/K = GLOB.available_kinks[kink_type]
		if(!K)
			continue

		var/pref = get_pref(K.type)
		if(pref == KINK_PREF_NEUTRAL)
			continue

		if(!K.is_active_for(owner, partner, L))
			continue

		total_pref += pref

	total_pref = clamp(total_pref, -2, 2)
	var/mult = 1 + (total_pref * 0.5)
	return max(mult, 0.25)

/datum/component/kinks/proc/has_pref(kink_typepath)
	return (kink_typepath in prefs_by_type)

/mob/living/proc/ensure_kinks_component()
	var/datum/component/kinks/K = GetComponent(/datum/component/kinks)
	if(!K)
		K = AddComponent(/datum/component/kinks)
	return K

#undef KINK_PREF_DISLIKE
#undef KINK_PREF_NEUTRAL
#undef KINK_PREF_LIKE
