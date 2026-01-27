SUBSYSTEM_DEF(combo_expire)
	name = "Combo Expire"
	wait = 0.25 SECONDS
	priority = FIRE_PRIORITY_DEFAULT
	flags = SS_BACKGROUND
	var/list/tracked = list()

/datum/controller/subsystem/combo_expire/proc/Track(datum/component/combo_core/C, wake_at)
	if(!C || QDELETED(C))
		return
	if(!isnum(wake_at) || wake_at <= 0)
		return
	tracked[C] = wake_at

/datum/controller/subsystem/combo_expire/proc/Untrack(datum/component/combo_core/C)
	if(!C)
		return
	tracked -= C

/datum/controller/subsystem/combo_expire/fire(resumed)
	if(!tracked?.len)
		return

	var/now = world.time
	for(var/datum/component/combo_core/C as anything in tracked.Copy())
		if(!C || QDELETED(C))
			tracked -= C
			continue

		var/wake_at = tracked[C]
		if(!isnum(wake_at) || now < wake_at)
			continue

		C.ProcessTimers(now)
		if(QDELETED(C))
			tracked -= C
