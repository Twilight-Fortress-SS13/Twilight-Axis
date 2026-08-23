/datum/particle_weather/rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "rain"
	weather_visual_color = "#ccffff"
	weather_scroll_y = -512
	weather_scroll_time = 20
	weather_alpha_min = 75
	weather_alpha_max = 165
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 70
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a little chilly
/datum/particle_weather/rain_gentle/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED))
		L.add_stress(/datum/stressevent/parasol_rain)
		return

	// Abyssorites like to be in the rain! They still get wet without a parasol, though.
	if(HAS_TRAIT(L, TRAIT_ABYSSOR_SWIM))
		L.add_stress(/datum/stressevent/abyssor_rain)

	L.adjust_bodytemperature(-rand(3,9))
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L, CLEAN_WEAK)

/datum/particle_weather/rain_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "rain_storm"
	weather_visual_color = "#ccffff"
	weather_scroll_y = -512
	weather_scroll_time = 12
	weather_alpha_min = 95
	weather_alpha_max = 190
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_RAIN

//Makes you a bit chilly
/datum/particle_weather/rain_storm/weather_act(mob/living/L)
	// Abyssorites like storms even more than they like rain!
	if(HAS_TRAIT(L, TRAIT_ABYSSOR_SWIM))
		L.add_stress(/datum/stressevent/abyssor_storm)

	L.adjust_bodytemperature(-rand(9,15))
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L,CLEAN_STRONG)
