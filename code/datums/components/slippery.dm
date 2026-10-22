/datum/component/slippery
	var/force_drop_items = FALSE
	var/knockdown_time = 0
	var/paralyze_time = 0
	var/lube_flags
	var/datum/callback/callback
	var/slip_chance = 100 //TA EDIT
	var/use_stat_modifier = FALSE //TA EDIT

/datum/component/slippery/Initialize(_knockdown, _lube_flags = NONE, datum/callback/_callback, _paralyze, _force_drop = FALSE, _slip_chance = 100, _use_stat_modifier = FALSE) //TA EDIT
	knockdown_time = max(_knockdown, 0)
	paralyze_time = max(_paralyze, 0)
	force_drop_items = _force_drop
	lube_flags = _lube_flags
	callback = _callback
	slip_chance = _slip_chance //TA EDIT
	use_stat_modifier = _use_stat_modifier //TA EDIT
	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_ATOM_ENTERED), PROC_REF(Slip))
	RegisterSignal(parent, COMSIG_ITEM_WEARERCROSSED, PROC_REF(Slip_on_wearer))

/datum/component/slippery/proc/Slip(datum/source, atom/movable/AM)
	var/mob/victim = AM
	if(!istype(victim) || victim.is_flying()) //TA EDIT
		return
	//TA EDIT START
	var/actual_chance = slip_chance
	if(use_stat_modifier && ishuman(victim))
		var/mob/living/carbon/human/H = victim
		actual_chance += (20 - H.get_stat(STATKEY_LCK)) * 10
		actual_chance = clamp(actual_chance, 0, 100)
	if(!prob(actual_chance))
		return
	//TA EDIT END
	if(victim.slip(knockdown_time, parent, lube_flags, paralyze_time, force_drop_items) && callback)
		callback.Invoke(victim)


/datum/component/slippery/proc/Slip_on_wearer(datum/source, atom/movable/AM, mob/living/crossed)
	if(crossed.lying && !crossed.buckle_lying)
		Slip(source, AM)
