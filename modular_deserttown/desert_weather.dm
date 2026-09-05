/datum/controller/subsystem/ParticleWeather/run_weather(datum/particle_weather/weather_datum_type, force = 0, color)
	if(!force && SSmapping && SSmapping.config && SSmapping.config.map_name == "Desert Town")
		var/path_to_check = weather_datum_type
		
		if(istext(weather_datum_type))
			for(var/V in subtypesof(/datum/particle_weather))
				var/datum/particle_weather/W = V
				if(initial(W.name) == weather_datum_type)
					path_to_check = V
					break
		
		if(ispath(path_to_check))
			var/is_allowed = FALSE
			
			// Allow fog, blood rain and dust storm
			if(ispath(path_to_check, /datum/particle_weather/fog) || \
			   ispath(path_to_check, /datum/particle_weather/blood_rain_gentle) || \
			   ispath(path_to_check, /datum/particle_weather/blood_rain_storm) || \
			   ispath(path_to_check, /datum/particle_weather/dust_storm))
				is_allowed = TRUE
				
			// If not allowed, we just return and cancel the weather
			if(!is_allowed)
				return
				
	return ..()

// ----------------------------------------------------
// DUST STORM SOUNDS (PLACEHOLDERS)
// ----------------------------------------------------

/datum/looping_sound/dust_storm
	mid_sounds = 'sound/weather/dust_storm/dust_storm.ogg'
	mid_length = 100 SECONDS
	volume = 200
	direct = TRUE

/datum/looping_sound/indoor_dust_storm
	mid_sounds = 'sound/weather/dust_storm/dust_storm_indoors.ogg'
	mid_length = 8 SECONDS
	volume = 500
	direct = TRUE


// ----------------------------------------------------
// DUST STORM PARTICLE
// ----------------------------------------------------

/particles/weather/dust_storm
	icon 				   = 'icons/effects/96x96.dmi'
	icon_state             = list("smoke-static" = 5)
	gradient               = list(0,"#c2b280e3", 100,"#e6d299e3", "loop") // Sandy desert colors
	color                  = 0
	color_change		   = generator("num",0,3)
	position               = generator("box", list(-500,-256,0), list(500,500,0))
	gravity                = list(-5 -1, 0.1)
	drift                  = generator("circle", 0, 3) 
	friction               = 0.3
	//Weather effects, max values
	maxSpawning            = 120
	minSpawning            = 40
	wind                   = 5


// ----------------------------------------------------
// DUST STORM WEATHER DATUM
// ----------------------------------------------------

/datum/particle_weather/dust_storm
	name = "Dust Storm"
	desc = "A fierce dust storm sweeps across the desert."
	particleEffectType = /particles/weather/dust_storm

	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/dust_storm)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_dust_storm)
	weather_messages = null

	weather_duration_lower = 5 MINUTES
	weather_duration_upper = 15 MINUTES
	
	minSeverity = 5
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 30
	target_trait = PARTICLEWEATHER_RAIN // Acts like rain to wash away blood and dirt from objects and turfs

	#ifndef SPACEMAN_DMM
	filter_type = filter(type="alpha", render_source = O_LIGHTING_VISUAL_RENDER_TARGET, flags = MASK_INVERSE)
	secondary_filter_type = filter(type="alpha", render_source = FOG_RENDER_TARGET, flags = MASK_INVERSE)
	#endif

	var/old_plane

/datum/particle_weather/dust_storm/start()
	. = ..()
	for(var/area/area as anything in GLOB.areas)
		if(area.outdoors)
			if(!old_plane)
				old_plane = area.plane
			area.icon = 'icons/effects/weather_overlay.dmi'
			area.icon_state = "weather_overlay"
			area.plane = WEATHER_OVERLAY_PLANE
			area.blend_mode = BLEND_OVERLAY
			area.invisibility = INVISIBILITY_LIGHTING

/datum/particle_weather/dust_storm/end()
	. = ..()
	for(var/area/area as anything in GLOB.areas)
		if(area.outdoors)
			area.icon = initial(area.icon)
			area.icon_state = ""
			area.plane = old_plane
			area.blend_mode = initial(area.blend_mode)
			area.invisibility = initial(area.invisibility)
	old_plane = null

// Washes away blood and dirt from the mob itself.
/datum/particle_weather/dust_storm/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED))
		return
	wash_atom(L, CLEAN_WEAK)
