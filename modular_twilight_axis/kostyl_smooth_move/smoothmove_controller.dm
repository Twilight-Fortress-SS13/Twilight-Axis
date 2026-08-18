SUBSYSTEM_DEF(ta_antilag)
	name = "TA Anti lag"
	wait = 1
	priority = FIRE_PRIORITY_TIMER
	flags = SS_TICKER
	init_order = INIT_ORDER_MINOR_MAPPING - 5
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/first_run = TRUE

	var/last_tick_realtime = 0
	var/last_tick_byond_time = 0
	var/list/preload_sounds = list()

/datum/controller/subsystem/ta_antilag/Initialize(start_timeofday)
	for(var/area/A as anything in GLOB.areas)
		for(var/field in list(A.droning_sound, A.droning_sound_dusk, A.droning_sound_night,
							  A.droning_sound_dawn, A.ambientsounds, A.ambientnight, A.spookysounds,
							  A.ambientnight, A.ambientsounds, A.spookynight))
			if(!field)
				continue
			if(islist(field))
				for(var/snd in field)
					if(snd && !(snd in preload_sounds))
						preload_sounds += snd
			else
				if(!(field in preload_sounds))
					preload_sounds += field


	for(var/client/C as anything in GLOB.clients)
		var/iterator
		for(var/snd in preload_sounds)
			iterator++
			spawn(iterator)
				C << load_resource(snd, -1)

	. = ..()

/datum/controller/subsystem/ta_antilag/fire()

	var/current_realtime = REALTIMEOFDAY
	var/current_byondtime = world.time

	if (!first_run)
		var/target = (current_byondtime - last_tick_byond_time) / (current_realtime - last_tick_realtime)
		GLOB.glide_size_multiplier = LERP(GLOB.glide_size_multiplier, target, 0.1)
	else
		first_run = FALSE

	last_tick_realtime = current_realtime
	last_tick_byond_time = current_byondtime
