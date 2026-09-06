/datum/particle_weather/hail
	name = "Hail"
	desc = "Hailstorm"
	weather_icon_state = "hail"
	weather_visual_color = "#ccffff"
	weather_scroll_y = -512
	weather_scroll_time = 16
	weather_alpha_min = 125
	weather_alpha_max = 245
	weather_tile_count = 4

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/hail)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_hail)

	minSeverity = 30
	maxSeverity = 60
	maxSeverityChange = 5
	severitySteps = 5
	immunity_type = TRAIT_SNOWSTORM_IMMUNE
	probability = 5
	target_trait = PARTICLEWEATHER_SNOW

/datum/particle_weather/hail/weather_act(mob/living/L)
	if(issimple(L))
		return

	L.adjust_bodytemperature(-rand(5, 15))
	var/armor_block = L.run_armor_check(BODY_ZONE_HEAD, "blunt", blade_dulling=BCLASS_BLUNT)
	if(L.apply_damage(rand(5, 10), UNARMED_ATTACK, BODY_ZONE_HEAD, armor_block))
		if(prob(25))
			to_chat(L, span_danger("You're being assailed by an onslaught of hail!"))
	else
		if(prob(25))
			to_chat(L, span_warning("Rocks of ice plink off of your headcover."))

