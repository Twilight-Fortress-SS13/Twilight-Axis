// Smooth HUD updates, but low priority
PROCESSING_SUBSYSTEM_DEF(mousecharge)
	name = "mouse charging prog"
	wait = 1
	flags = SS_KEEP_TIMING //Surely nothing bad will happen.
	priority = FIRE_PRIORITY_MOUSECHARGE
	stat_tag = "MOUSE"
	var/list/mouse_icons = list( // TA EDIT START
	"charge_0",\
	"charge_5",\
	"charge_10",\
	"charge_15",\
	"charge_20",\
	"charge_25",\
	"charge_30",\
	"charge_35",\
	"charge_40",\
	"charge_45",\
	"charge_50",\
	"charge_55",\
	"charge_60",\
	"charge_65",\
	"charge_70",\
	"charge_75",\
	"charge_80",\
	"charge_85",\
	"charge_90",\
	"charge_95",\
	"charge_100"
) // TA EDIT END
/datum/controller/subsystem/processing/mousecharge/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/client/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		else if(thing.process(wait) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/processing/mousecharge/proc/access(percentage)
	percentage = clamp(percentage,0,100)///Only here bc I'm a lazy ass and want all my math on one screen.
	return SSmousecharge.mouse_icons[floor(percentage / 5) + 1]
