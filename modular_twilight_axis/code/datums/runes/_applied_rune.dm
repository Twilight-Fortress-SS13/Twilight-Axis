/datum/applied_rune
	/// Rune instance stored on the weapon
	var/datum/rune/rune

	/// Who applied it
	var/mob/living/applier

	/// Next world.time this rune may trigger
	var/next_trigger_time = 0


/datum/applied_rune/New(datum/rune/new_rune, mob/living/new_applier)
	. = ..()

	if(!new_rune)
		CRASH("applied_rune created without rune")

	rune = new_rune
	applier = new_applier


/datum/applied_rune/proc/is_valid()
	if(!rune)
		return FALSE
	return TRUE


/datum/applied_rune/proc/get_rune()
	if(!rune)
		return null
	return rune


/datum/applied_rune/proc/can_trigger()
	if(!rune)
		return FALSE

	if(next_trigger_time > world.time)
		return FALSE

	return TRUE


/datum/applied_rune/proc/set_cooldown(cooldown)
	if(!isnum(cooldown))
		return

	next_trigger_time = world.time + cooldown


/datum/applied_rune/proc/reset_cooldown()
	next_trigger_time = 0


/datum/applied_rune/proc/clear()
	rune = null
	applier = null
	next_trigger_time = 0
