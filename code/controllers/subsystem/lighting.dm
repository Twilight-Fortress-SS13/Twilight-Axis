SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 0
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER
	priority = FIRE_PRIORITY_DEFAULT
	var/static/list/sources_queue = list() // List of lighting sources queued for update.
	var/static/list/corners_queue = list() // List of lighting corners queued for update.
	var/static/list/objects_queue = list() // List of lighting objects queued for update.
	processing_flag = PROCESSING_LIGHTING

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[length(sources_queue)]|C:[length(corners_queue)]|O:[length(objects_queue)]")


/datum/controller/subsystem/lighting/Initialize(timeofday)
	if(!initialized)
		if (CONFIG_GET(flag/starlight))
			for(var/I in GLOB.sortedAreas)
				var/area/A = I
				if (A.dynamic_lighting == DYNAMIC_LIGHTING_IFSTARLIGHT)
					A.luminosity = 0

		create_all_lighting_objects()
		initialized = TRUE

	fire(FALSE, TRUE)

	return ..()

/datum/controller/subsystem/lighting/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)

	var/list/queue
	var/list/local_queue
	var/processed

	// -------- SOURCES --------
	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = sources_queue
	if(length(queue))
		local_queue = queue.Copy()
		processed = 0

		for(var/datum/light_source/L in local_queue)
			if(!L)
				processed++
				continue

			L.update_corners()
			L.needs_update = LIGHTING_NO_UPDATE
			processed++

			if(init_tick_checks)
				CHECK_TICK
			else if(MC_TICK_CHECK)
				break

		if(processed)
			queue.Cut(1, min(processed + 1, length(queue) + 1))

	// -------- CORNERS --------
	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = corners_queue
	if(length(queue))
		local_queue = queue.Copy()
		processed = 0

		for(var/datum/lighting_corner/C in local_queue)
			if(!C)
				processed++
				continue

			C.update_objects()
			C.needs_update = FALSE
			processed++

			if(init_tick_checks)
				CHECK_TICK
			else if(MC_TICK_CHECK)
				break

		if(processed)
			queue.Cut(1, min(processed + 1, length(queue) + 1))

	// -------- OBJECTS --------
	if(!init_tick_checks)
		MC_SPLIT_TICK

	queue = objects_queue
	if(length(queue))
		local_queue = queue.Copy()
		processed = 0

		for(var/atom/movable/lighting_object/O in local_queue)
			if(QDELETED(O))
				processed++
				continue

			O.update()
			O.needs_update = FALSE
			processed++

			if(init_tick_checks)
				CHECK_TICK
			else if(MC_TICK_CHECK)
				break

		if(processed)
			queue.Cut(1, min(processed + 1, length(queue) + 1))

/datum/controller/subsystem/lighting/Recover()
	initialized = SSlighting.initialized
	..()
