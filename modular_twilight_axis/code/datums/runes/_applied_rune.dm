/datum/applied_rune
	/// The rune datum itself
	var/datum/rune/rune

	/// Who applied it, if known
	var/mob/living/applier

	/// Next world.time this rune may trigger
	var/next_trigger_time = 0

/datum/applied_rune/New(datum/rune/new_rune, mob/living/new_applier)
	. = ..()
	rune = new_rune
	applier = new_applier
