/datum/particle_weather/blood_rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "rain"
	weather_visual_color = "#ff0000"
	weather_scroll_y = -512
	weather_scroll_time = 20
	weather_alpha_min = 100
	weather_alpha_max = 195
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_BLOODRAIN

/datum/particle_weather/blood_rain_gentle/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED))
		return
	if(HAS_TRAIT(L, TRAIT_HORDE))
		L.add_stress(/datum/stressevent/graggarite_blood_rain)
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)

/datum/particle_weather/blood_rain_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "rain_storm"
	weather_visual_color = "#ff0000"
	weather_scroll_y = -512
	weather_scroll_time = 12
	weather_alpha_min = 120
	weather_alpha_max = 220
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 10
	target_trait = PARTICLEWEATHER_BLOODRAIN

/datum/particle_weather/blood_rain_storm/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_HORDE))
		L.add_stress(/datum/stressevent/graggarite_blood_rain)
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
