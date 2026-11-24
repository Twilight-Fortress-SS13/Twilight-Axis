/datum/controller/subsystem/ticker/sunsteal(mob/living/sunstealer)
	if(sunstolen || QDELETED(sunstealer))
		return FALSE
	sunstolen = TRUE
	..()
	return TRUE

/datum/controller/subsystem/ticker/on_sunstealer_death(datum/source)
	if(source)
		UnregisterSignal(source, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	return ..()
