/datum/particle_weather
	var/warning_message
	var/late_warning_message
	var/forecast_tag

/datum/particle_weather/rain_gentle
	forecast_tag = "rain"

/datum/particle_weather/rain_storm
	forecast_tag = "rain"

/datum/particle_weather/hurricane
	forecast_tag = "rain"

/datum/particle_weather/dry_thunderstorm
	forecast_tag = "rain"

/datum/particle_weather/snow_gentle
	forecast_tag = "snow"

/datum/particle_weather/snow_storm
	forecast_tag = "snow"

/datum/particle_weather/fog
	forecast_tag = "fog"

/datum/particle_weather/fireflies
	forecast_tag = "fireflies"

/datum/particle_weather/leaves_gentle
	forecast_tag = PARTICLEWEATHER_LEAVES

/datum/particle_weather/sakura_gentle
	forecast_tag = PARTICLEWEATHER_SAKURA

/datum/particle_weather/blood_rain_storm
	forecast_tag = PARTICLEWEATHER_BLOODRAIN

/datum/particle_weather/blood_rain_gentle
	forecast_tag = PARTICLEWEATHER_BLOODRAIN

/datum/particle_weather/heatwave
	forecast_tag = "heatwave"

/datum/particle_weather/sand_gentle
	forecast_tag = "sand"

/datum/particle_weather/sandstorm
	forecast_tag = "sandstorm"

/datum/particle_weather/ashstorm
	forecast_tag = "ash"

/datum/particle_weather/dust_storm
	forecast_tag = "dust"

/datum/particle_weather/hail
	forecast_tag = "hail"

SUBSYSTEM_DEF(ta_climate_weather)
	name = "Twilight Seasonal Climate"
	flags = SS_BACKGROUND
	wait = 30 SECONDS
	runlevels = RUNLEVEL_GAME
	var/weather_queued = FALSE
	var/last_forecast_period
	var/queued_weather_type
	var/queued_forecast_tag
	var/queued_weather_start_time = 0
	var/queued_weather_expiration = 0
	var/queue_serial = 0

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_has_active_players()
	for(var/mob/living/M in GLOB.player_list)
		if(M.client && M.stat != DEAD)
			return TRUE
	return FALSE

/datum/controller/subsystem/ta_climate_weather/proc/get_weather_period()
	var/period = GLOB.tod
	if(period == "dawn" || period == "day" || period == "dusk" || period == "night")
		return period
	return null

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_desert_weather_allowed(weather_type)
	if(!ispath(weather_type, /datum/particle_weather))
		return FALSE
	return ispath(weather_type, /datum/particle_weather/fog) || \
		ispath(weather_type, /datum/particle_weather/blood_rain_gentle) || \
		ispath(weather_type, /datum/particle_weather/blood_rain_storm) || \
		ispath(weather_type, /datum/particle_weather/dust_storm) || \
		ispath(weather_type, /datum/particle_weather/sand_gentle) || \
		ispath(weather_type, /datum/particle_weather/sandstorm) || \
		ispath(weather_type, /datum/particle_weather/dry_thunderstorm) || \
		ispath(weather_type, /datum/particle_weather/heatwave) || \
		ispath(weather_type, /datum/particle_weather/ashstorm) || \
		ispath(weather_type, /datum/particle_weather/fireflies)

/datum/controller/subsystem/ta_climate_weather/proc/get_weather_pool(map_name, daypart)
	var/datum/ta_climate_forecast/forecast
	switch(map_name)
		if("Desert Town")
			forecast = new /datum/ta_climate_forecast/alashur()
		if("Dun World", "Pilgrim")
			forecast = new /datum/ta_climate_forecast/dunworld()
		if("Build Your Own Settlement")
			forecast = new /datum/ta_climate_forecast/byos()
		else
			forecast = new /datum/ta_climate_forecast/rockhill()
	var/list/pool = forecast.get_weather_pool(daypart)
	qdel(forecast)
	var/season = SSseason?.current_season
	if(map_name == "Desert Town")
		pool[/datum/particle_weather/dust_storm] = 15
		if(season == SEASON_SUMMER)
			pool[/datum/particle_weather/heatwave] = 32
			pool[/datum/particle_weather/sandstorm] = 30
		else if(season == SEASON_WINTER)
			pool[/datum/particle_weather/heatwave] = 2
			pool[/datum/particle_weather/sandstorm] = 8
		if(daypart == "night")
			pool[/datum/particle_weather/heatwave] = 0
		for(var/weather_type in pool.Copy())
			if(!ta_climate_desert_weather_allowed(weather_type))
				pool -= weather_type
		return pool
	pool[/datum/particle_weather/hurricane] = 3
	if(season != SEASON_WINTER)
		pool[/datum/particle_weather/snow_gentle] = 0
		pool[/datum/particle_weather/snow_storm] = 0
	if(season == SEASON_WINTER)
		pool[/datum/particle_weather/snow_gentle] = 35
		pool[/datum/particle_weather/snow_storm] = 18
		pool[/datum/particle_weather/heatwave] = 0
	else if(season == SEASON_SUMMER)
		pool[/datum/particle_weather/heatwave] = 24
	else if(season == SEASON_SPRING)
		pool[/datum/particle_weather/rain_gentle] = 32
	else if(season == SEASON_AUTUMN)
		pool[/datum/particle_weather/leaves_gentle] = 28
	return pool

/datum/ta_climate_weather_round_modifier
	var/name
	var/desc
	var/list/weather_weights

/datum/ta_climate_weather_round_modifier/clear
	name = "Clear Skies"
	desc = "No interesting weather."
	weather_weights = list(
		/datum/particle_weather/rain_storm = 0,
		/datum/particle_weather/snow_storm = 0,
		/datum/particle_weather/dry_thunderstorm = 0,
		/datum/particle_weather/hurricane = 0,
		/datum/particle_weather/hail = 0,
		/datum/particle_weather/sandstorm = 0,
		/datum/particle_weather/dust_storm = 0,
		/datum/particle_weather/blood_rain_storm = 0,
		/datum/particle_weather/fog = 0,
		/datum/particle_weather/snow_gentle = 0,
		/datum/particle_weather/heatwave = 0
	)

/datum/ta_climate_weather_round_modifier/fog
	name = "Fog"
	desc = "It's gonna fog."
	weather_weights = list(/datum/particle_weather/fog = 4)

/datum/ta_climate_weather_round_modifier/stormy
	name = "Stormy"
	desc = "It's gonna storm."
	weather_weights = list(
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/snow_storm = 3,
		/datum/particle_weather/dry_thunderstorm = 3
	)

/datum/controller/subsystem/ta_climate_weather
	var/round_weather_rolled = FALSE
	var/ta_climate_round_chaos_level = 2
	var/datum/ta_climate_weather_round_modifier/round_weather_modifier

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_roll_round_weather_modifier()
	if(round_weather_rolled || !SSgamemode)
		return
	round_weather_rolled = TRUE
	var/list/existing_modifiers = ("active_modifiers" in SSgamemode.vars) ? SSgamemode.vars["active_modifiers"] : null
	if(islist(existing_modifiers))
		for(var/datum/existing_modifier as anything in existing_modifiers)
			if(istype(existing_modifier) && islist(existing_modifier.vars["weather_weights"]))
				return
	var/level = clamp(ta_climate_round_chaos_level, 0, 3)
	if(level <= 0)
		return
	var/list/profiles = list(
		"clear" = 10,
		"fog" = 10
	)
	if(level >= 2)
		profiles["stormy"] = 8
	var/selected_weather = pickweight(profiles)
	switch(selected_weather)
		if("clear")
			round_weather_modifier = new /datum/ta_climate_weather_round_modifier/clear
		if("fog")
			round_weather_modifier = new /datum/ta_climate_weather_round_modifier/fog
		if("stormy")
			round_weather_modifier = new /datum/ta_climate_weather_round_modifier/stormy
	if(round_weather_modifier)
		to_chat(world, span_notice("<b>Weather modifier: [round_weather_modifier.name] - [round_weather_modifier.desc]</b>"))

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_multiply_weather_pool(list/pool, list/weather_weights)
	if(!islist(weather_weights))
		return
	for(var/weather_type in weather_weights)
		var/target_type = weather_type
		switch("[weather_type]")
			if("/datum/particle_weather/dry_thunderstorm")
				target_type = /datum/particle_weather/dry_thunderstorm
			if("/datum/particle_weather/heat_wave")
				target_type = /datum/particle_weather/heatwave
		if(!(target_type in pool))
			continue
		var/multiplier = weather_weights[weather_type]
		if(isnum(multiplier) && multiplier >= 0)
			pool[target_type] = round(pool[target_type] * multiplier)

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_apply_round_weather_weights(list/pool)
	if(!islist(pool))
		return pool
	if(round_weather_modifier)
		ta_climate_multiply_weather_pool(pool, round_weather_modifier.weather_weights)
	if(!SSgamemode)
		return pool
	var/list/active_modifiers = ("active_modifiers" in SSgamemode.vars) ? SSgamemode.vars["active_modifiers"] : null
	if(!islist(active_modifiers))
		return pool
	for(var/datum/active_modifier as anything in active_modifiers)
		if(!istype(active_modifier) || QDELETED(active_modifier))
			continue
		ta_climate_multiply_weather_pool(pool, active_modifier.vars["weather_weights"])
	return pool

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_filter_weather_pool(list/pool)
	if(!islist(pool))
		return list()
	for(var/weather_type in pool.Copy())
		if(weather_type == /datum/particle_weather/ashstorm || !ispath(weather_type, /datum/particle_weather) || !isnum(pool[weather_type]) || pool[weather_type] <= 0)
			pool -= weather_type
	return pool

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_send_forecast_notice(weather_type, late = FALSE)
	if(!ispath(weather_type, /datum/particle_weather))
		return
	var/datum/particle_weather/weather_definition = weather_type
	var/weather_name = initial(weather_definition.name)
	var/notice_message = late ? initial(weather_definition.late_warning_message) : initial(weather_definition.warning_message)
	if(!notice_message)
		if(late)
			notice_message = span_warning("[weather_name] уже совсем близко.")
		else
			notice_message = span_notice("Погода меняется. Приближается [weather_name].")
	for(var/mob/living/M in GLOB.player_list)
		if(!M.client || M.stat == DEAD || !isturf(M.loc) || !ta_climate_valid_outdoors(get_turf(M)))
			continue
		to_chat(M, notice_message)

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_cancel_forecast()
	if(weather_queued && GLOB.forecast == queued_forecast_tag)
		GLOB.forecast = null
	weather_queued = FALSE
	queued_weather_type = null
	queued_forecast_tag = null
	queued_weather_start_time = 0
	queued_weather_expiration = 0
	queue_serial++

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_late_forecast(expected_serial)
	if(!weather_queued || queue_serial != expected_serial)
		return
	if(GLOB.todoverride || !ta_climate_has_active_players() || SSParticleWeather?.runningWeather || GLOB.forecast != queued_forecast_tag || world.time > queued_weather_expiration)
		ta_climate_cancel_forecast()
		return
	ta_climate_send_forecast_notice(queued_weather_type, TRUE)

/datum/controller/subsystem/ta_climate_weather/proc/start_forecast(expected_serial)
	if(!weather_queued || queue_serial != expected_serial)
		return
	if(GLOB.todoverride || !ta_climate_has_active_players() || !SSParticleWeather || SSParticleWeather.runningWeather || GLOB.forecast != queued_forecast_tag || world.time > queued_weather_expiration)
		ta_climate_cancel_forecast()
		return
	var/weather_type = queued_weather_type
	SSParticleWeather.run_weather(weather_type, TRUE)
	ta_climate_cancel_forecast()

/datum/controller/subsystem/ta_climate_weather/proc/ta_climate_queue_forecast(weather_type)
	if(!ispath(weather_type, /datum/particle_weather) || weather_queued || !SSParticleWeather || SSParticleWeather.runningWeather || GLOB.todoverride || GLOB.forecast || !ta_climate_has_active_players())
		return
	var/datum/particle_weather/weather_definition = weather_type
	var/forecast_delay = rand(2 MINUTES, 5 MINUTES)
	queued_weather_type = weather_type
	queued_forecast_tag = initial(weather_definition.forecast_tag)
	if(!queued_forecast_tag)
		queued_forecast_tag = "[weather_type]"
	GLOB.forecast = queued_forecast_tag
	queued_weather_start_time = world.time + forecast_delay
	queued_weather_expiration = queued_weather_start_time + 15 MINUTES
	weather_queued = TRUE
	queue_serial++
	var/expected_serial = queue_serial
	for(var/obj/item/barometer/barometer as anything in ta_climate_barometers)
		if(barometer && !QDELETED(barometer))
			barometer.on_weather_queued(weather_type)
	ta_climate_send_forecast_notice(weather_type)
	if(forecast_delay > 30 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(ta_climate_late_forecast), expected_serial), forecast_delay - (30 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(start_forecast), expected_serial), forecast_delay)

/datum/controller/subsystem/ta_climate_weather/proc/check_forecast(period)
	if(!SSmapping?.config || !SSParticleWeather || !SSgamemode || !SSseason || GLOB.todoverride)
		return
	if(period != "dawn" && period != "day" && period != "dusk" && period != "night")
		return
	if(period == last_forecast_period || !ta_climate_has_active_players())
		return
	if(weather_queued || SSParticleWeather.runningWeather || GLOB.forecast)
		return
	last_forecast_period = period
	var/map_name = SSmapping.config.map_name
	var/datum/ta_climate_forecast/forecast
	switch(map_name)
		if("Desert Town")
			forecast = new /datum/ta_climate_forecast/alashur()
		if("Dun World", "Pilgrim")
			forecast = new /datum/ta_climate_forecast/dunworld()
		if("Build Your Own Settlement")
			forecast = new /datum/ta_climate_forecast/byos()
		else
			forecast = new /datum/ta_climate_forecast/rockhill()
	var/chance = forecast.get_period_probability(period)
	qdel(forecast)
	if(!prob(chance))
		return
	var/list/pool = get_weather_pool(map_name, period)
	pool = ta_climate_apply_round_weather_weights(pool)
	pool = ta_climate_filter_weather_pool(pool)
	if(!length(pool))
		return
	var/weather_type = pickweight(pool)
	ta_climate_queue_forecast(weather_type)

/datum/controller/subsystem/ta_climate_weather/fire(resumed = FALSE)
	if(weather_queued && (SSParticleWeather?.runningWeather || GLOB.forecast != queued_forecast_tag || !ta_climate_has_active_players()))
		ta_climate_cancel_forecast()
	if(GLOB.todoverride)
		if(weather_queued)
			ta_climate_cancel_forecast()
		return
	var/period = get_weather_period()
	if(period && period != last_forecast_period)
		check_forecast(period)
