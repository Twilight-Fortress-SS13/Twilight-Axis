GLOBAL_LIST_INIT(vanderlin_weather, list(PARTICLEWEATHER_RAIN, PARTICLEWEATHER_BLOODRAIN, PARTICLEWEATHER_LEAVES))
SUBSYSTEM_DEF(ParticleWeather)
	name = "Particle Weather"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/elligble_weather = list()
	var/datum/particle_weather/runningWeather
	// var/list/next_hit = list() //Used by barometers to know when the next storm is coming

	var/list/obj/weather_effect/weatherEffects = list()
	var/current_effect_color

	var/list/turfs_to_process = list()
	var/list/weathered_turfs = list()

	var/list/currentrun_mobs
	var/list/currentrun_objs

	var/obj_act_interval = 3 SECONDS
	var/next_obj_act = 0

/datum/controller/subsystem/ParticleWeather/fire(resumed = FALSE)
	// process active weather
	if(!runningWeather || !runningWeather.running)
		return

	if(!resumed)
		runningWeather.tick()
		if(runningWeather.parallax_weather)
			for(var/client/C as anything in GLOB.clients)
				C.ensure_particle_weather_parallax()
		currentrun_mobs = GLOB.player_list.Copy()
		// Every registered obj's weather_act_on() gates on PARTICLEWEATHER_RAIN, and target_trait is
		// what we pass it - so only rain-trait weather (incl. fog) can affect objs. Skip the whole
		// sweep for leaves/snow/blood rain, and throttle it otherwise.
		if(runningWeather.target_trait == PARTICLEWEATHER_RAIN && world.time >= next_obj_act)
			next_obj_act = world.time + obj_act_interval
			currentrun_objs = GLOB.weather_act_upon_list.Copy()
		else
			currentrun_objs = null

	var/list/curr_mobs = currentrun_mobs
	while(curr_mobs.len)
		var/mob/act_on = curr_mobs[curr_mobs.len]
		curr_mobs.len--
		if(isliving(act_on))
			runningWeather.try_weather_act(act_on)
		if(MC_TICK_CHECK)
			return

	var/list/curr_objs = currentrun_objs
	while(curr_objs?.len)
		var/obj/act_on = curr_objs[curr_objs.len]
		curr_objs.len--
		runningWeather.weather_obj_act(act_on)
		if(MC_TICK_CHECK)
			return


//This has been mangled - currently only supports 1 weather effect serverwide so I can finish this
/datum/controller/subsystem/ParticleWeather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/particle_weather))
		var/datum/particle_weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (prob(probability) && (target_trait in GLOB.vanderlin_weather)) //TODO VANDERLIN: Map trait this.
			LAZYINITLIST(elligble_weather)
			elligble_weather[W] = probability
	return ..()

/datum/controller/subsystem/ParticleWeather/proc/run_weather(datum/particle_weather/weather_datum_type, force = 0, color)
	if(runningWeather)
		if(force)
			runningWeather.end()
		else
			return
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/particle_weather))
			var/datum/particle_weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/particle_weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	runningWeather = new weather_datum_type()

	if(force)
		runningWeather.start(color)
	else
		var/randTime = rand(0, 6000) + initial(runningWeather.weather_duration_upper)
		addtimer(CALLBACK(runningWeather, /datum/particle_weather/proc/start), randTime, TIMER_UNIQUE|TIMER_STOPPABLE) //Around 0-10 minutes between weathers


/datum/controller/subsystem/ParticleWeather/proc/make_eligible(possible_weather)
	elligble_weather = possible_weather
//	next_hit = null

/datum/controller/subsystem/ParticleWeather/proc/registerWeatherEffect(obj/weather_effect/effect)
	if(!effect)
		return
	weatherEffects |= effect
	syncWeatherEffect(effect)

/datum/controller/subsystem/ParticleWeather/proc/unregisterWeatherEffect(obj/weather_effect/effect)
	weatherEffects -= effect

/datum/controller/subsystem/ParticleWeather/proc/configureWeatherEffect(obj/weather_effect/effect, icon_file, icon_state, effect_color, blend_type, filter_type, secondary_filter_type, scroll_x, scroll_y, scroll_time, tile_size, tile_count, scroll_pingpong, offset_x = 0, offset_y = 0)
	if(!effect)
		return
	effect.configure(icon_file, icon_state, scroll_x, scroll_y, scroll_time, tile_size, tile_count, scroll_pingpong, offset_x, offset_y)
	effect.color = effect_color
	effect.blend_mode = blend_type ? blend_type : BLEND_DEFAULT
	effect.filters = list()
	if(filter_type)
		effect.filters += filter_type
	if(secondary_filter_type)
		effect.filters += secondary_filter_type

/datum/controller/subsystem/ParticleWeather/proc/syncWeatherEffect(obj/weather_effect/effect)
	if(!runningWeather || !runningWeather.running || !runningWeather.weather_icon_state)
		effect.clear_visual()
		return
	if(runningWeather.parallax_weather)
		effect.clear_visual()
		return
	var/effect_color = current_effect_color ? current_effect_color : runningWeather.weather_visual_color
	configureWeatherEffect(effect, runningWeather.weather_icon, runningWeather.weather_icon_state, effect_color, runningWeather.blend_type, runningWeather.filter_type, runningWeather.secondary_filter_type, runningWeather.weather_scroll_x, runningWeather.weather_scroll_y, runningWeather.weather_scroll_time, runningWeather.weather_tile_size, runningWeather.weather_tile_count, runningWeather.weather_scroll_pingpong, runningWeather.weather_offset_x, runningWeather.weather_offset_y)
	var/severity_mod = runningWeather.severityMod()
	if(severity_mod <= 0)
		effect.alpha = 0
	else
		var/clamped_severity = min(1, max(0, severity_mod))
		effect.alpha = round(runningWeather.weather_alpha_min + ((runningWeather.weather_alpha_max - runningWeather.weather_alpha_min) * clamped_severity))

/datum/controller/subsystem/ParticleWeather/proc/SetweatherEffect(icon_file, icon_state, effect_color, blend_type, filter_type, secondary_filter_type, scroll_x, scroll_y, scroll_time, tile_size, tile_count, scroll_pingpong)
	current_effect_color = effect_color
	for(var/obj/weather_effect/effect as anything in weatherEffects)
		syncWeatherEffect(effect)
		if(effect)
			effect.alpha = 0
	for(var/client/C as anything in GLOB.clients)
		C.update_particle_weather_parallax(TRUE)

/datum/controller/subsystem/ParticleWeather/proc/setWeatherSeverity(severity_mod, transition_time = 0)
	if(!runningWeather)
		return
	var/new_alpha = 0
	if(severity_mod > 0)
		var/clamped_severity = min(1, max(0, severity_mod))
		new_alpha = round(runningWeather.weather_alpha_min + ((runningWeather.weather_alpha_max - runningWeather.weather_alpha_min) * clamped_severity))
	for(var/obj/weather_effect/effect as anything in weatherEffects)
		if(!effect?.icon_state)
			continue
		if(transition_time > 0)
			animate(effect, alpha = new_alpha, time = transition_time, tag = "weather_alpha")
		else
			animate(effect, tag = "weather_alpha")
			effect.alpha = new_alpha
	for(var/client/C as anything in GLOB.clients)
		C.set_particle_weather_parallax_alpha(severity_mod, transition_time > 0 ? transition_time : 5)

/datum/controller/subsystem/ParticleWeather/proc/stopWeather()
	for(var/client/C as anything in GLOB.clients)
		C.clear_particle_weather_parallax()
	for(var/obj/act_on as anything in GLOB.weather_act_upon_list)
		act_on.weather = FALSE
	for(var/obj/weather_effect/effect as anything in weatherEffects)
		if(effect)
			effect.clear_visual()
	current_effect_color = null
	QDEL_NULL(runningWeather)
