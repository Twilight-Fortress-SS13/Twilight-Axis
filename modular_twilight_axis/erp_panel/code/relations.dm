/datum/relationship
	var/mob/living/carbon/human/from_mob
	var/mob/living/carbon/human/to_mob
	var/flags

/datum/component/relationships
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/relations

/datum/component/relationships/Initialize()
	. = ..()
	relations = list()

/datum/component/relationships/Destroy()
	relations = null
	return ..()

/datum/component/relationships/proc/has_relation(mob/living/carbon/human/target, flags)
	if(!relations)
		return FALSE
	for(var/datum/relationship/R in relations)
		if(R.to_mob == target && (R.flags & flags))
			return TRUE
	return FALSE

/datum/component/relationships/proc/add_relation(mob/living/carbon/human/target, flags)
	if(!target)
		return FALSE
	for(var/datum/relationship/R in relations)
		if(R.to_mob == target && R.flags == flags)
			return FALSE

	var/datum/relationship/N = new
	N.from_mob = parent
	N.to_mob = target
	N.flags = flags
	relations += N
	return TRUE

/datum/component/relationships/proc/remove_relation(flags)
	if(!relations)
		return FALSE

	var/removed = FALSE
	for(var/i = relations.len, i >= 1, i--)
		var/datum/relationship/R = relations[i]
		if(R.flags & flags)
			relations.Cut(i, i+1)
			removed = TRUE
	return removed

/datum/component/relationships/proc/get_sex_multiplier(mob/living/carbon/human/partner)
	if(!relations || !relations.len)
		return 1

	for(var/datum/relationship/R in relations)
		if(R.to_mob == partner)
			return 1

	var/min_mult = 1
	for(var/datum/relationship/R in relations)
		var/list/cfg = GLOB.relationship_settings[R.flags]
		if(cfg)
			min_mult = min(min_mult, cfg["sex_mult"])
	return min_mult

/datum/component/relationships/proc/get_observe_min()
	if(!relations || !relations.len)
		return 0

	var/min_arousal = 0
	for(var/datum/relationship/R in relations)
		if(R.to_mob && (R.to_mob in view(7, parent)))
			var/list/cfg = GLOB.relationship_settings[R.flags]
			if(cfg)
				min_arousal = max(min_arousal, cfg["observe_min"])
	return min_arousal
