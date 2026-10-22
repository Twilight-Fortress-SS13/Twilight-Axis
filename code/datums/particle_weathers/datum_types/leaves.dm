/datum/particle_weather/leaves_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "leaves"
	weather_visual_color = null
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 80
	weather_alpha_min = 100
	weather_alpha_max = 220
	weather_tile_count = 4

	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/leaves_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "leaves_storm"
	weather_visual_color = null
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 36
	weather_alpha_min = 125
	weather_alpha_max = 245
	weather_tile_count = 4

	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 20
	target_trait = PARTICLEWEATHER_LEAVES

/datum/particle_weather/sakura_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "sakura"
	weather_visual_color = null
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 80
	weather_alpha_min = 100
	weather_alpha_max = 220
	weather_tile_count = 4

	scale_vol_with_severity = TRUE

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA

/datum/particle_weather/sakura_storm
	name = "Rain"
	desc = "Gentle Rain, la la description."
	weather_icon_state = "sakura_storm"
	weather_visual_color = null
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 36
	weather_alpha_min = 125
	weather_alpha_max = 245
	weather_tile_count = 4

	scale_vol_with_severity = TRUE

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 0
	target_trait = PARTICLEWEATHER_SAKURA
