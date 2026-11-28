/datum/controller/subsystem/ticker/sunsteal(mob/living/sunstealer)
	if(!sunstealer?.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		sunstealer = ta_get_vampire_lord_body() || sunstealer
	if(sunstolen || QDELETED(sunstealer) || sunstealer.stat == DEAD)
		return FALSE
	sunstolen = TRUE
	..(sunstealer)
	return TRUE

/datum/controller/subsystem/ticker/on_sunstealer_death(datum/source)
	if(source)
		UnregisterSignal(source, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	return ..()
