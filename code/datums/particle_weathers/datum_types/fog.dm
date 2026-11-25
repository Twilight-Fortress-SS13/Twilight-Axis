/obj/effect/fog_parter
	icon = 'icons/effects/light_overlays/light_288.dmi'
	icon_state = "light2"
	alpha = 160
	plane = PLANE_FOG_CUTTER
	invisibility = INVISIBILITY_LIGHTING
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = NONE
	///Cache of the possible light overlays, according to size.
	var/static/list/light_overlays = list(
		"32" = 'icons/effects/light_overlays/light_32.dmi',
		"64" = 'icons/effects/light_overlays/light_64.dmi',
		"96" = 'icons/effects/light_overlays/light_96.dmi',
		"128" = 'icons/effects/light_overlays/light_128.dmi',
		"160" = 'icons/effects/light_overlays/light_160.dmi',
		"192" = 'icons/effects/light_overlays/light_192.dmi',
		"224" = 'icons/effects/light_overlays/light_224.dmi',
		"256" = 'icons/effects/light_overlays/light_256.dmi',
		"288" = 'icons/effects/light_overlays/light_288.dmi',
		"320" = 'icons/effects/light_overlays/light_320.dmi',
		"352" = 'icons/effects/light_overlays/light_352.dmi',
	)

/obj/effect/fog_parter/Initialize(mapload, range = 5)
	. = ..()
	set_range(range)

/obj/effect/fog_parter/proc/set_range(range)
	if(range <= 0)
		return
	range = clamp(CEILING(range, 0.5), 1, 6)
	var/pixel_bounds = ((range - 1) * 64) + 32
	icon = light_overlays["[pixel_bounds]"]
	if(pixel_bounds == 32)
		transform = null
		return
	var/offset = (pixel_bounds - 32) * 0.5
	var/matrix/new_transform = new
	new_transform.Translate(-offset, -offset)
	transform = new_transform

/datum/particle_weather/fog
	name = "Fog"
	desc = "Gentle fog, la la description."
	weather_icon = 'icons/effects/weather_fog.dmi'
	weather_icon_state = "fog"
	weather_visual_color = "#ffffff"
	weather_scroll_x = 512
	weather_scroll_y = 0
	weather_scroll_time = 480
	weather_alpha_min = 132
	weather_alpha_max = 205
	weather_tile_size = 512
	weather_tile_count = 3
	weather_scroll_pingpong = FALSE
	parallax_weather = TRUE
	weather_parallax_speed = 32

	scale_vol_with_severity = TRUE
	//weather_sounds = list(/datum/looping_sound/rain)
	//indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)
	weather_messages = null

	weather_duration_upper = 10 MINUTES
	minSeverity = 5
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 30
	target_trait = PARTICLEWEATHER_RAIN
	#ifndef	SPACEMAN_DMM
	filter_type = filter(type="alpha", render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE)
	secondary_filter_type = filter(type="alpha", render_source = FOG_RENDER_TARGET, flags = MASK_INVERSE)
	#endif

/datum/particle_weather/fog/swamp
	name = "Swamp Fog"
	weather_visual_color = "#7cc572"
	probability = 10

/datum/particle_weather/fog/darkness
	name = "Omen of Darkness Fog"
	weather_visual_color = "#55505f"
	weather_alpha_min = 155
	weather_alpha_max = 220
	probability = 1

/datum/particle_weather/fog/blood
	name = "Omen of Blood Feat Fog"
	weather_visual_color = "#c91622"
	weather_alpha_min = 150
	weather_alpha_max = 225
	probability = 1


/datum/particle_weather/fog/necra
	name = "Necra Fog"
	weather_duration_upper = 5 HOURS
	weather_visual_color = "#bed7d8"
