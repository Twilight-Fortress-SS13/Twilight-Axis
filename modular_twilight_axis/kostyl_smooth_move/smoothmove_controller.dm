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
		ask_preload_sounds(C)

	. = ..()

/datum/controller/subsystem/ta_antilag/proc/ask_preload_sounds(client/C)
	var/preload_length = length(preload_sounds)

	var/preload_force_option = "Загрузить всё и сейчас(Возможен краш на старых ПК)"
	var/preload_overtime_option = "Загрузить более мягко, не блокируя вам настройку персонажа."
	var/cancel_option = "НЕ ЗАГРУЖАТЬ."

	var/selected_option = tgui_alert(C, "Для того чтобы избежать фризов и статтеров при переходе из зоны в зону и при смене Z-уровня, можно предзагрузить звуки требуемые в них.", "Предзагрузка звуков", list(preload_force_option, preload_overtime_option, cancel_option))

	if(selected_option == preload_force_option)
		for(var/snd in preload_sounds)
			C << load_resource(snd, -1)
		to_chat(C, "<h2>Предзагрузка завершена</h2>")

	if(selected_option == preload_overtime_option)
		var/iterator
		for(var/snd in preload_sounds)
			iterator++
			spawn(iterator * 2)
				C << load_resource(snd, -1)
				if(preload_length == iterator)
					to_chat(C, "<h2>Предзагрузка завершена</h2>")

		to_chat(C, "<h2>Предзагрузка запущена</h2>")

	if(selected_option == cancel_option)
		to_chat(C, "<h2>Предзагрузка отменена</h2>")

/datum/controller/subsystem/ta_antilag/fire()

	var/current_realtime = REALTIMEOFDAY
	var/current_byondtime = world.time

	if (!first_run)
		var/byond_tick_delta = current_byondtime - last_tick_byond_time
		var/realtime_tick_delta = current_realtime - last_tick_realtime
		if(realtime_tick_delta && byond_tick_delta)
			var/target = byond_tick_delta / realtime_tick_delta
			GLOB.glide_size_multiplier = LERP(GLOB.glide_size_multiplier, target, 0.1)
	else
		first_run = FALSE

	last_tick_realtime = current_realtime
	last_tick_byond_time = current_byondtime
