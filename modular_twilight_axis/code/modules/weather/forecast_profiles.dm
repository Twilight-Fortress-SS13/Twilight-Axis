/datum/ta_climate_forecast
	var/name = "Base Forecast"

	var/list/dusk_weather = list()
	var/list/day_weather = list()
	var/list/night_weather = list()
	var/list/dawn_weather = list()

	var/dawn_prob  = 35
	var/day_prob  = 25
	var/night_prob  = 35
	var/dusk_prob = 35

/datum/ta_climate_forecast/proc/pick_weather(time_of_day)
	if(!prob(get_period_probability(time_of_day)))
		return
	var/list/weather_pool = get_weather_pool(time_of_day)
	if(!length(weather_pool))
		return
	return pickweight(weather_pool)

/datum/ta_climate_forecast/proc/get_weather_pool(time_of_day)
	var/list/pool
	switch(time_of_day)
		if("dawn")
			pool = dawn_weather.Copy()
		if("dusk")
			pool = dusk_weather.Copy()
		if("night")
			pool = night_weather.Copy()
		else
			pool = day_weather.Copy()
	if(!islist(pool))
		return list()
	if(time_of_day == "night")
		pool[/datum/particle_weather/blood_rain_storm] = 1
	if(time_of_day == "dawn" || time_of_day == "day")
		pool[/datum/particle_weather/sakura_gentle] = 2
	return pool

/datum/ta_climate_forecast/proc/get_period_probability(time_of_day)
	switch(time_of_day)
		if("dawn")
			return dawn_prob
		if("dusk")
			return dusk_prob
		if("night")
			return night_prob
	return day_prob

//Rockhill is meant to be wet, foggy sort of weather. On occasion, snow, leafs and fireflies.
/datum/ta_climate_forecast/rockhill
	dawn_prob = 20
	day_prob = 15
	night_prob = 20
	dusk_prob = 20
	day_weather = list(
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/leaves_gentle = 20,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/heatwave = 10,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/dry_thunderstorm = 3,
	)
	dawn_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 10,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/heatwave = 5,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/dry_thunderstorm = 2,
		/datum/particle_weather/snow_storm = 2,
	)
	dusk_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 10,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/heatwave = 5,
		/datum/particle_weather/dry_thunderstorm = 2,
		/datum/particle_weather/snow_storm = 2,
	)
	night_weather =  list(
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/fireflies = 25,
		/datum/particle_weather/fog = 15,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/leaves_gentle = 10,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/snow_storm = 2,
		/datum/particle_weather/heatwave = 2,
		/datum/particle_weather/dry_thunderstorm = 2,
	)

//The island is supposed to be hot and wet, with ash storms from the volcano
/datum/ta_climate_forecast/byos
	day_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/leaves_gentle = 10,
		/datum/particle_weather/heatwave = 20,

		/datum/particle_weather/fireflies = 5,
	)
	dawn_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heatwave = 20,

		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/fog = 5,
	)
	dusk_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heatwave = 20,

		/datum/particle_weather/fireflies = 15,
	)
	night_weather =  list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heatwave = 20,

		/datum/particle_weather/fog = 5,
	)

//Al Ashur is meant to be Sandy, dry thunderstorm sort of weather. Cold at night and fireflies.
/datum/ta_climate_forecast/alashur
	day_weather = list(
		/datum/particle_weather/sand_gentle = 25,
		/datum/particle_weather/sandstorm = 20,
		/datum/particle_weather/dry_thunderstorm = 20,
		/datum/particle_weather/heatwave = 20,

		/datum/particle_weather/fireflies = 5,
	)
	dawn_weather = list(
		/datum/particle_weather/sand_gentle = 25,
		/datum/particle_weather/sandstorm = 20,
		/datum/particle_weather/dry_thunderstorm = 20,
		/datum/particle_weather/heatwave = 15,

		/datum/particle_weather/fireflies = 15,
	)
	dusk_weather = list(
		/datum/particle_weather/sand_gentle = 25,
		/datum/particle_weather/sandstorm = 20,
		/datum/particle_weather/dry_thunderstorm = 20,
		/datum/particle_weather/heatwave = 15,

		/datum/particle_weather/fireflies = 15,
	)
	night_weather =  list(
		/datum/particle_weather/sand_gentle = 25,
		/datum/particle_weather/sandstorm = 20,
		/datum/particle_weather/dry_thunderstorm = 20,

		/datum/particle_weather/fireflies = 15,
	)

//Dunworld is meant to be wet, leafy, snowy sort of weather. On occasion, ash storms from mountdecap and fireflies.
/datum/ta_climate_forecast/dunworld
	dawn_prob = 20
	day_prob = 15
	night_prob = 20
	dusk_prob = 20
	day_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/leaves_gentle = 20,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/hail = 3,

		/datum/particle_weather/fog = 3,
	)
	dawn_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/snow_storm = 4,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/hail = 3,

	)
	dusk_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/snow_storm = 4,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/hail = 3,

	)
	night_weather =  list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 3,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/hail = 3,

	)
