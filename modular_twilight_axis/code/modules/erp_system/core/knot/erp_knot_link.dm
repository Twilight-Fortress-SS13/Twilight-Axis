/datum/erp_knot_link
	var/mob/living/top
	var/mob/living/btm
	var/datum/erp_sex_organ/penis/penis_org
	var/datum/erp_sex_organ/receiving_org
	var/penis_unit_id = 0
	var/strength = ERP_KNOT_MAX_STRENGTH
	var/last_activity_time = 0
	var/started = FALSE

/datum/erp_knot_link/New(mob/living/_top, mob/living/_btm, datum/erp_sex_organ/penis/_penis, datum/erp_sex_organ/_recv, _unit_id = 0)
	. = ..()
	top = _top
	btm = _btm
	penis_org = _penis
	receiving_org = _recv
	penis_unit_id = _unit_id
	last_activity_time = world.time

/datum/erp_knot_link/proc/is_valid()
	if(!istype(top) || QDELETED(top))
		return FALSE
	if(!istype(btm) || QDELETED(btm))
		return FALSE
	if(!penis_org || QDELETED(penis_org))
		return FALSE
	if(!receiving_org || QDELETED(receiving_org))
		return FALSE

	return TRUE

/datum/erp_knot_link/proc/note_activity()
	last_activity_time = world.time

/datum/erp_knot_link/proc/is_decay_blocked()
	return (world.time - last_activity_time) <= ERP_KNOT_ACTIVITY_GRACE

/datum/erp_knot_link/proc/decay_tick()
	if(!is_valid())
		return FALSE

	if(is_decay_blocked())
		return TRUE

	if(strength <= 0)
		strength = 0
		return TRUE

	strength = max(0, strength - ERP_KNOT_DECAY_STEP)
	return TRUE

/datum/erp_knot_link/proc/get_owner_bonus()
	return round((strength / ERP_KNOT_MAX_STRENGTH) * 30)

/datum/erp_knot_link/proc/try_increase_strength_from_movement()
	var/ch = 5 + round((strength / 100) * 10)
	if(prob(ch))
		strength = min(ERP_KNOT_MAX_STRENGTH, strength + 2)
		note_activity()
		return TRUE
	return FALSE

/datum/erp_knot_link/proc/get_pain_damage_on_removal()
	if(strength <= ERP_KNOT_PAIN_THRESHOLD)
		return 0
	return round(strength * 0.5)

/datum/erp_knot_link/proc/apply_fun_counter_message()
	return

/datum/erp_knot_link/proc/on_removed(forceful = FALSE, who_pulled = null)
	return
