/datum/time_of_day
	var/name = ""
	var/color = ""
	var/start = 6 HOURS // 6:00 am

/datum/time_of_day/dawn
	name = "Dawn"
	color = list("#394579", "#49385d", "#3a1537")
	start = 8 HOURS //8:00:00 AM

/datum/time_of_day/sunrise
	name = "Sunrise"
	color = "#F598AB"
	start = 9.5 HOURS	//9:30:00 AM

/datum/time_of_day/daytime
	name = "Daytime"
	color = list("#dbbfbf", "#ddd7bd", "#add1b0", "#a4c0ca", "#ae9dc6", "#d09fbf")
	start = 10 HOURS //10:00:00 AM

/datum/time_of_day/sunset
	name = "Sunset"
	color = "#ff8a63"
	start = 15 HOURS //3:00:00 PM

/datum/time_of_day/dusk
	name = "Dusk"
	color = list("#c26f56", "#c05271", "#b84933")
	start = 15.5 HOURS //3:30:00 PM

/datum/time_of_day/midnight
	name = "Midnight"
	color = "#000000"
	start = 16 HOURS //4:00:00 PM

GLOBAL_VAR_INIT(GLOBAL_LIGHT_RANGE, 3)
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_WORK)	/* turfs to be stateChecked */
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_UPDATE) /* turfs to have their colors updated via corners (filter out the unroofed dudes) */
GLOBAL_LIST_EMPTY(SUNLIGHT_QUEUE_CORNER) /* turfs to have their color/lights/etc updated */

SUBSYSTEM_DEF(outdoor_effects)
	name = "Outdoor Weather Calc"
	wait = LIGHTING_INTERVAL
	flags = SS_TICKER
	init_order = INIT_ORDER_OUTDOOR_EFFECTS

	var/list/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/sunlighting_planes = list()
	var/datum/time_of_day/current_step_datum
	var/datum/time_of_day/next_step_datum
	var/list/mutable_appearance/sunlight_overlays

	var/last_color = null
	var/picked_color
	//Ensure midnight is the liast step
	var/list/datum/time_of_day/time_cycle_steps = list(new /datum/time_of_day/dawn(),
														new /datum/time_of_day/sunrise(),
														new /datum/time_of_day/daytime(),
														new /datum/time_of_day/sunset(),
														new /datum/time_of_day/dusk(),
														new /datum/time_of_day/midnight())
	var/alist/turf_weather_affectable_z_levels = alist()
	var/next_day = FALSE // Resets when station_time is less than the next start time.

// /datum/controller/subsystem/outdoor_effects/proc/fullPlonk()
//	for(var/zlevel in SSmapping.levels_by_trait(ZTRAIT_WEATHER_STUFF))
//		if(SSmapping.level_trait(zlevel, ZTRAIT_IGNORE_WEATHER_TRAIT))
//			continue
//		turf_weather_affectable_z_levels[zlevel] = TRUE

/datum/controller/subsystem/outdoor_effects/Initialize(timeofday)
	if(!initialized)
		for(var/zlevel in SSmapping.levels_by_trait(ZTRAIT_WEATHER_STUFF))
			if(SSmapping.level_trait(zlevel, ZTRAIT_IGNORE_WEATHER_TRAIT))
				continue
			turf_weather_affectable_z_levels[zlevel] = TRUE
		get_time_of_day()
		InitializeTurfs()
		initialized = TRUE
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/outdoor_effects/stat_entry(msg)
	msg = "W:[GLOB.SUNLIGHT_QUEUE_WORK.len]|U:[GLOB.SUNLIGHT_QUEUE_UPDATE.len]|C:[GLOB.SUNLIGHT_QUEUE_CORNER.len]"
	return ..()

/datum/controller/subsystem/outdoor_effects/proc/InitializeTurfs(list/targets)
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_STATION))
		if(SSmapping.level_trait(z, ZTRAIT_IGNORE_WEATHER_TRAIT))
			continue
		GLOB.SUNLIGHT_QUEUE_WORK += Z_TURFS(z)
	for(var/z in SSmapping.levels_by_trait(ZTRAIT_CENTCOM))
		if(SSmapping.level_trait(z, ZTRAIT_IGNORE_WEATHER_TRAIT))
			continue
		GLOB.SUNLIGHT_QUEUE_WORK += Z_TURFS(z)


/datum/controller/subsystem/outdoor_effects/proc/check_cycle()
	if(!next_step_datum)
		get_time_of_day()
		return TRUE

	if(station_time() > next_step_datum.start)
		if(next_day)
			return FALSE
		get_time_of_day()
		return TRUE
	else if (next_day) // It is now the next morning, reset our next day
		next_day = FALSE

	return FALSE

/datum/controller/subsystem/outdoor_effects/proc/get_time_of_day()
	//Set our current color as last_color so newly initialized sunlight screens have a color
	if(current_step_datum)
		last_color = picked_color

	//Get the next time step (first time where NOW > START_TIME)
	//If we don't find one - grab the LAST time step (which should be midnight)
	var/time = station_time()
	var/datum/time_of_day/new_step = null

	for(var/i in 1 to length(time_cycle_steps))
		if(time >= time_cycle_steps[i].start)
			new_step = time_cycle_steps[i]
			next_step_datum = i == length(time_cycle_steps) ? time_cycle_steps[1] : time_cycle_steps[i + 1]

	//New time is the last time step in list (midnight) - next time will be the first step
	if(!new_step)
		new_step = time_cycle_steps[length(time_cycle_steps)]
		next_step_datum = time_cycle_steps[1]

	current_step_datum = new_step
	picked_color = pick(current_step_datum.color)

	// If the next start time is less than the current start time (i.e 10 PM vs 5 AM) then set our NextDay value
	if(next_step_datum.start <= current_step_datum.start)
		next_day = TRUE

	//If it is round-start, we wouldn't have had a current_step_datum, so set our last_color to the current one
	if(!last_color)
		last_color = picked_color

/* set sunlight color + add weather effect to clients */
/datum/controller/subsystem/outdoor_effects/fire(resumed, init_tick_checks)
	MC_SPLIT_TICK_INIT(3)
	if(!init_tick_checks)
		MC_SPLIT_TICK
	var/i = 0

	//Add our weather particle obj to any new weather screens
	for (i in 1 to GLOB.SUNLIGHT_QUEUE_WORK.len)
		var/turf/T = GLOB.SUNLIGHT_QUEUE_WORK[i]
		if(T)
			T.update_sky_and_weather_states()
			if(T.outdoor_effect)
				GLOB.SUNLIGHT_QUEUE_UPDATE += T.outdoor_effect

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.SUNLIGHT_QUEUE_WORK.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for (i in 1 to GLOB.SUNLIGHT_QUEUE_UPDATE.len)
		var/atom/movable/outdoor_effect/U = GLOB.SUNLIGHT_QUEUE_UPDATE[i]
		if(U)
			U.process_state()
			update_outdoor_effect_overlays(U)

		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break
	if (i)
		GLOB.SUNLIGHT_QUEUE_UPDATE.Cut(1, i+1)
		i = 0


	if(!init_tick_checks)
		MC_SPLIT_TICK

	for (i in 1 to GLOB.SUNLIGHT_QUEUE_CORNER.len)
		var/turf/T = GLOB.SUNLIGHT_QUEUE_CORNER[i]
		T.turf_flags &= ~TURF_SUNLIGHT_QUEUED
		var/atom/movable/outdoor_effect/U = T.outdoor_effect

		/* if we haven't initialized but we are affected, create new and check state */
		if(!U)
			T.outdoor_effect = new /atom/movable/outdoor_effect(T)
			T.update_sky_and_weather_states()
			U = T.outdoor_effect

			/* in case we aren't indoor somehow, wack us into the proc queue, we will be skipped on next indoor check */
			if(U.state != SKY_BLOCKED)
				GLOB.SUNLIGHT_QUEUE_UPDATE += T.outdoor_effect

		if(U.state != SKY_BLOCKED)
			continue

		//This might need to be run more liberally
		update_outdoor_effect_overlays(U)


		if(init_tick_checks)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (i)
		GLOB.SUNLIGHT_QUEUE_CORNER.Cut(1, i+1)
		i = 0

	if(check_cycle())
		for (var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in sunlighting_planes)
			transition_sunlight_color(SP)


//Transition from our last color to our current color (i.e if it is going from daylight (white) to sunset (red), we transition to red in the first hour of sunset)
/datum/controller/subsystem/outdoor_effects/proc/transition_sunlight_color(atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP)
	/* transistion in an hour or time diff from now to our next step, whichever is smaller */
	if(!next_step_datum)
		get_time_of_day()

	var timeDiff = min((1 HOURS / SSticker.station_time_rate_multiplier ),daytimeDiff(station_time(), next_step_datum.start))
	animate(SP,color=picked_color, time = timeDiff)

// Updates overlays and vis_contents for outdoor effects
/datum/controller/subsystem/outdoor_effects/proc/update_outdoor_effect_overlays(atom/movable/outdoor_effect/OE)

	// One packed mask per tile: R = sun, G = weather gate (outdoor_masks.dmi states: yellow =
	// sun+rain, red = sun only, green = rain only). The sun fullscreen's color matrix
	// extracts R (tinted by the tod color), the WEATHER_OVERLAY plane master converts G
	// into the alpha mask for weather particles. The blur on the sunlight plane master
	// softens both. Corner falloff math still exists in
	// /datum/lighting_corner/sunFalloff, but only gameplay (get_lumcount) reads it.
	var/sky = OE.state != SKY_BLOCKED
	var/mutable_appearance/MA = get_sunlight_overlay(sky, !OE.weatherproof)

	OE.sunlight_overlay = MA
	OE.overlays = list(OE.sunlight_overlay)
	OE.luminosity = MA.luminosity


//Retrieve an overlay from the list - create if necessary
/datum/controller/subsystem/outdoor_effects/proc/get_sunlight_overlay(sky = TRUE, weather = TRUE)
	LAZYINITLIST(sunlight_overlays)
	var/index = "[sky]|[weather]"
	if(!sunlight_overlays[index])
		sunlight_overlays[index] = create_sunlight_overlay(sky, weather)
	return sunlight_overlays[index]

//Create a flat packed mask overlay: R = sun, G = weather gate
/datum/controller/subsystem/outdoor_effects/proc/create_sunlight_overlay(sky, weather)

	var/mutable_appearance/MA = new /mutable_appearance()

	MA.blend_mode	= BLEND_OVERLAY
	MA.icon			= 'icons/effects/outdoor_masks.dmi'
	MA.icon_state	= weather ? (sky ? "yellow" : "green") : "red"
	MA.plane		= SUNLIGHTING_PLANE /* we put this on a lower level than lighting so we dont multiply anything */
	MA.invisibility = INVISIBILITY_LIGHTING

	//MA gets applied as an overlay, but we pull luminosity out to set our outdoor_effect object's lum
	MA.luminosity = sky
	return MA
