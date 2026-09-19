/datum/particle_weather/snow_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "snow"
	weather_visual_color = "#ffffff"
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 64
	weather_alpha_min = 105
	weather_alpha_max = 225
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)

	minSeverity = 5
	maxSeverity = 20
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 15
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a little chilly
/datum/particle_weather/snow_gentle/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED))
		L.add_stress(/datum/stressevent/parasol_snow)
		return

	L.adjust_bodytemperature(-rand(5,10))


/datum/particle_weather/snow_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "snow_storm"
	weather_visual_color = "#ffffff"
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 36
	weather_alpha_min = 130
	weather_alpha_max = 245
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/snow)

	minSeverity = 40
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_SNOW

//Makes you a lot little chilly
/datum/particle_weather/snow_storm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(10,25))
