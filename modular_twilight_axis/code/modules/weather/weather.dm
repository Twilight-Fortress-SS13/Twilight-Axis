/datum/looping_sound/ta_climate_sandstorm
	mid_sounds = list('modular_twilight_axis/sound/weather/sandstorm.ogg')
	mid_length = 14 SECONDS
	volume = 80
	direct = TRUE

/datum/looping_sound/ta_climate_sandstorm/indoors
	volume = 35

/datum/looping_sound/ta_climate_thunder
	mid_sounds = list(
		'modular_twilight_axis/sound/weather/thunder_1.ogg' = 1,
		'modular_twilight_axis/sound/weather/thunder_2.ogg' = 1,
		'modular_twilight_axis/sound/weather/thunder_3.ogg' = 1
	)
	mid_length = 30 SECONDS
	volume = 80
	direct = TRUE

/datum/looping_sound/ta_climate_thunder/indoors
	volume = 30

/datum/looping_sound/ta_climate_ashstorm
	mid_sounds = list('modular_twilight_axis/sound/weather/ashstorm.ogg')
	mid_length = 48 SECONDS
	volume = 65
	direct = TRUE

/datum/looping_sound/ta_climate_ashstorm/indoors
	volume = 25

/datum/particle_weather
	var/ta_climate_weather = FALSE
	var/ta_climate_winding_down = FALSE

/datum/particle_weather/proc/ta_climate_get_outdoor_players()
	var/list/available = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		var/turf/T = get_turf(L)
		if(isturf(L.loc) && L.stat != DEAD && !HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE) && !HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) && (!immunity_type || !HAS_TRAIT(L, immunity_type)) && ta_climate_valid_outdoors(T) && can_weather(L) && can_weather_effect(L))
			available += L
	return available

/datum/particle_weather/heatwave
	ta_climate_weather = TRUE
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	minSeverity = 10
	maxSeverity = 70
	maxSeverityChange = 15
	name = "Heatwave"
	weather_icon_state = "heatwave"
	weather_visual_color = "#eed19c"
	weather_scroll_x = 25
	weather_scroll_y = 128
	weather_alpha_min = 55
	weather_alpha_max = 110
	desc = "Удушающая жара, от которой трудно скрыться под открытым небом."
	weather_sounds = list(/datum/looping_sound/ta_climate_hotwind)
	weather_messages = list(span_warning("Солнце беспощадно нагревает воздух."), span_warning("Жара становится невыносимой."))
	weather_duration_lower = 4 MINUTES
	weather_duration_upper = 7 MINUTES

/datum/particle_weather/sand_gentle
	ta_climate_weather = TRUE
	weather_duration_lower = 3 MINUTES
	weather_duration_upper = 6 MINUTES
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	minSeverity = 10
	maxSeverity = 70
	maxSeverityChange = 15
	immunity_type = "sandstorm_immune"
	name = "Sand Gentle"
	desc = "Тёплый ветер несёт песок и пыль."
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_icon_state = "sand_light"
	weather_visual_color = "#f0d7b4"
	weather_alpha_min = 170
	weather_alpha_max = 235
	weather_scroll_time = 72
	weather_scroll_x = 512
	weather_scroll_y = 0
	weather_sounds = list(/datum/looping_sound/ta_climate_sandstorm)
	indoor_weather_sounds = list(/datum/looping_sound/ta_climate_sandstorm/indoors)
	weather_messages = list(span_notice("Ветер приносит сухую пыль."), span_warning("Песчинки неприятно колют открытое лицо."))
	parallax_weather = TRUE
	weather_parallax_speed = 16
	weather_tile_count = 5
/datum/particle_weather/sandstorm
	ta_climate_weather = TRUE
	weather_duration_lower = 3 MINUTES
	weather_duration_upper = 6 MINUTES
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	maxSeverityChange = 15
	immunity_type = "sandstorm_immune"
	name = "Sandstorm"
	desc = "Сильный ветер гонит густые облака песка."
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_icon_state = "sand_storm"
	weather_visual_color = "#a88a52"
	weather_alpha_min = 160
	weather_alpha_max = 240
	weather_scroll_x = 512
	weather_scroll_y = 0
	weather_scroll_time = 55
	weather_sounds = list(/datum/looping_sound/ta_climate_sandstorm)
	indoor_weather_sounds = list(/datum/looping_sound/ta_climate_sandstorm/indoors)
	weather_messages = list(span_warning("Сквозь песчаную бурю едва видно дорогу."), span_danger("Порывы песка ослепляют и выматывают вас!"))
	minSeverity = 40
	maxSeverity = 100

/datum/particle_weather/dry_thunderstorm
	ta_climate_weather = TRUE
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	minSeverity = 10
	maxSeverity = 70
	maxSeverityChange = 15
	name = "Dry Thunderstorm"
	weather_icon_state = "dry_thunder"
	weather_visual_color = "#e9edcc"
	weather_alpha_min = 30
	weather_alpha_max = 70
	desc = "Гром раскатывается в безоблачной суши; дождь так и не начинается."
	weather_sounds = list(/datum/looping_sound/ta_climate_thunder)
	indoor_weather_sounds = list(/datum/looping_sound/ta_climate_thunder/indoors)
	weather_messages = list(span_notice("Вдалеке громыхает гром, но дождя нет."), span_warning("Над головой грохочут раскаты сухой грозы."))
	weather_duration_lower = 3 MINUTES
	weather_duration_upper = 5 MINUTES

/datum/particle_weather/ashstorm
	ta_climate_weather = TRUE
	weather_duration_lower = 3 MINUTES
	weather_duration_upper = 6 MINUTES
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	maxSeverityChange = 15
	name = "Ashstorm"
	desc = "Горячий вулканический пепел застилает небо."
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_icon_state = "ash"
	weather_visual_color = "#e1ddd8"
	weather_alpha_min = 215
	weather_alpha_max = 255
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 42
	weather_sounds = list(/datum/looping_sound/ta_climate_ashstorm)
	indoor_weather_sounds = list(/datum/looping_sound/ta_climate_ashstorm/indoors)
	weather_messages = list(span_warning("С неба сыплется горячий пепел."), span_danger("Пепел обжигает незащищённую кожу!"))
	minSeverity = 30
	maxSeverity = 75
	parallax_weather = TRUE
	weather_parallax_speed = 20
	weather_tile_count = 5
/datum/looping_sound/ta_climate_hotwind
	mid_sounds = list('modular_twilight_axis/sound/weather/wind.ogg')
	mid_length = 15 SECONDS
	volume = 35
	direct = TRUE

/datum/looping_sound/ta_climate_ashstorm/indoors
	mid_sounds = list('modular_twilight_axis/sound/weather/ashstorm_indoors.ogg')

/datum/looping_sound/ta_climate_hurricane
	mid_sounds = list('modular_twilight_axis/sound/weather/rain_hurricane.ogg')
	mid_length = 30 SECONDS
	volume = 75
	direct = TRUE

/datum/looping_sound/ta_climate_hurricane/indoors
	volume = 28

/mob/living/proc/ta_climate_sandstorm_eye_protected()
	if(!ishuman(src))
		return FALSE
	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/mask = H.wear_mask
	var/obj/item/head = H.head
	if(mask && !mask.obj_broken && (istype(mask, /obj/item/clothing/mask/rogue/spectacles/golden) || istype(mask, /obj/item/clothing/mask/rogue/spectacles/goggles) || istype(mask, /obj/item/clothing/mask/rogue/lordmask/naledi)))
		return TRUE
	if(head && !head.obj_broken && (istype(head, /obj/item/clothing/mask/rogue/spectacles/golden) || istype(head, /obj/item/clothing/mask/rogue/spectacles/goggles) || istype(head, /obj/item/clothing/mask/rogue/lordmask/naledi)))
		return TRUE
	return FALSE

/mob/living/proc/ta_climate_face_covered()
	if(!ishuman(src))
		return FALSE
	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/head = H.head
	var/obj/item/clothing/mask = H.wear_mask
	return (head && !head.obj_broken && (head.flags_inv & HIDEFACE)) || (mask && !mask.obj_broken && (mask.flags_inv & HIDEFACE))

/mob/living/proc/ta_climate_weather_temperature(delta)
	if(!delta)
		return
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		return H.apply_weather_temperature(delta)
	adjust_bodytemperature(delta)

/datum/particle_weather/heatwave/weather_act(mob/living/L)
	if((HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE)))
		return
	if(L.bodytemperature < BODYTEMP_HEAT_LEVEL_ONE_MAX + 25)
		L.ta_climate_weather_temperature(rand(3, 8) / 10)

/datum/particle_weather/heatwave
	var/next_ripple = 0

/datum/particle_weather/heatwave/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time < next_ripple)
		return
	next_ripple = world.time + rand(3, 6) SECONDS
	var/list/players = ta_climate_get_outdoor_players()
	if(!length(players))
		return
	var/mob/living/L = pick(players)
	var/list/places = list()
	for(var/turf/open/T in range(6, L))
		if(ta_climate_valid_outdoors(T))
			places += T
	for(var/i in 1 to min(3, max(1, round(severity / 45))))
		if(!length(places))
			break
		var/turf/open/selected = pick(places)
		places -= selected
		new /obj/effect/temp_visual/ta_climate_heat_ripple(selected)

/datum/particle_weather/sand_gentle/weather_act(mob/living/L)
	if(HAS_TRAIT(L, "sandstorm_immune") || HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE))
		return
	if(!L.ta_climate_sandstorm_eye_protected() && prob(5) && hascall(L, "adjust_blurriness"))
		call(L, "adjust_blurriness")(rand(3, 8) / 10)
	if(L.bodytemperature < BODYTEMP_NORMAL_MAX + 75)
		L.ta_climate_weather_temperature(rand(1, 3) / 10)

/datum/particle_weather/sand_gentle
	var/next_dust_devil = 0

/datum/particle_weather/sand_gentle/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time < next_dust_devil)
		return
	next_dust_devil = world.time + rand(15, 40) SECONDS
	if(prob(30))
		for(var/i in 1 to 2)
			ta_climate_spawn_wind_hazard(/obj/effect/weather/ta_climate_tornado/dust_devil, 5, 2, 7, 30, 3, src)

/datum/particle_weather/sandstorm/weather_act(mob/living/L)
	if(HAS_TRAIT(L, "sandstorm_immune") || HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE))
		return
	if(!L.ta_climate_sandstorm_eye_protected() && prob(25) && hascall(L, "adjust_blurriness"))
		call(L, "adjust_blurriness")(rand(1, 3) / 10)
	if(L.bodytemperature < BODYTEMP_HEAT_LEVEL_ONE_MAX + 15)
		L.ta_climate_weather_temperature(rand(3, 8) / 10)
	if(!L.ta_climate_has_sandstorm_hood() && prob(33))
		L.energy_add(-10)

/datum/particle_weather/sandstorm
	var/next_dust_devil = 0

/datum/particle_weather/sandstorm/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time < next_dust_devil)
		return
	next_dust_devil = world.time + rand(15, 40) SECONDS
	if(prob(50))
		for(var/i in 1 to 2)
			ta_climate_spawn_wind_hazard(/obj/effect/weather/ta_climate_tornado/dust_devil, 10, 2, 7, 30, 3, src)

/datum/particle_weather/dry_thunderstorm
	var/next_lightning = 0

/datum/particle_weather/dry_thunderstorm/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time < next_lightning)
		return
	next_lightning = world.time + rand(5, 40) SECONDS
	ta_climate_spawn_lightning(src, 10)

/datum/particle_weather/ashstorm/weather_act(mob/living/L)
	if((HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE)))
		return
	if(L.bodytemperature < BODYTEMP_HEAT_LEVEL_ONE_MAX + 15)
		L.ta_climate_weather_temperature(rand(3, 8) / 10)
	if(prob(25))
		L.adjust_fire_stacks(1)
		to_chat(L, span_danger("Горячий пепел обжигает вас!"))

/datum/stressevent/ta_climate_fireflies
	stressadd = -2
	timer = 30 SECONDS
	desc = span_notice("Мерцающие огоньки приносят спокойствие.")

/datum/particle_weather/fireflies
	ta_climate_weather = TRUE
	weather_icon = 'modular_twilight_axis/icons/effects/weather.dmi'
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	target_trait = "weather_ta_climate"
	maxSeverityChange = 15
	name = "Fireflies"
	desc = "Тёплые огни беззвучно плывут в воздухе."
	weather_icon_state = "fireflies"
	weather_visual_color = "#fff9e3"
	weather_alpha_min = 205
	weather_alpha_max = 255
	weather_scroll_x = 512
	weather_scroll_y = 0
	weather_scroll_time = 1050
	weather_messages = list(span_notice("Вдали появляются слабые огоньки."), span_notice("Рядом мерцают крошечные светлячки."))
	minSeverity = 1
	maxSeverity = 5
	weather_duration_lower = 4 MINUTES
	weather_duration_upper = 8 MINUTES
	parallax_weather = TRUE
	weather_parallax_speed = 3
	weather_tile_count = 5
/datum/particle_weather/fireflies/weather_act(mob/living/L)
	if(ishuman(L))
		L.add_stress(/datum/stressevent/ta_climate_fireflies)

/datum/particle_weather/hurricane
	ta_climate_weather = TRUE
	weather_act_interval = 5 SECONDS
	weather_fade_time = 5 SECONDS
	name = "Hurricane"
	desc = "Шторм Абиссора несёт ливень, молнии и смерчи."
	weather_icon = 'icons/effects/weather_screen.dmi'
	weather_icon_state = "rain_storm"
	weather_visual_color = "#a9d9e1"
	weather_scroll_x = -512
	weather_scroll_y = -512
	weather_scroll_time = 10
	weather_alpha_min = 135
	weather_alpha_max = 240
	weather_tile_count = 4
	weather_duration_lower = 5 MINUTES
	weather_duration_upper = 10 MINUTES
	weather_sounds = list(/datum/looping_sound/ta_climate_hurricane)
	indoor_weather_sounds = list(/datum/looping_sound/ta_climate_hurricane/indoors)
	weather_messages = list(span_danger("Громадные тучи скручиваются в гигантскую воронку."), span_danger("Ветер воет, небо вспарывают молнии!"))
	minSeverity = 100
	maxSeverity = 150
	maxSeverityChange = 50
	target_trait = PARTICLEWEATHER_RAIN
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	var/next_lightning = 0

/datum/particle_weather/hurricane/weather_act(mob/living/L)
	if((HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE)))
		return
	if(L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 20)
		L.ta_climate_weather_temperature(-rand(3, 9) / 10)
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L, CLEAN_STRONG)

/datum/particle_weather/hurricane/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time >= next_lightning)
		next_lightning = world.time + rand(5, 40) SECONDS
		ta_climate_spawn_lightning(src, 6)
	if(prob(40))
		ta_climate_spawn_wind_hazard(/obj/effect/weather/ta_climate_tornado/abyssors_rage, 2, 8, 20, 30, 5, src)

/datum/particle_weather/rain_storm
	var/ta_climate_next_lightning = 0

/datum/particle_weather/rain_storm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/rain_storm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/rain_storm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/rain_storm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/rain_storm/tick()
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	if(world.time >= ta_climate_next_lightning)
		ta_climate_next_lightning = world.time + rand(5, 40) SECONDS
		ta_climate_spawn_lightning(src, 6)
	if(prob(5))
		ta_climate_spawn_wind_hazard(/obj/effect/weather/ta_climate_tornado, 2, 8, 20, 30, 3, src)

/atom/movable/screen/fullscreen/ta_climate_sandstorm_dust
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'
	icon_state = "smok"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE
	color = "#C3b091"
	alpha = 125

/atom/movable/screen/fullscreen/ta_climate_sandstorm_dust/protected
	alpha = 90

/atom/movable/screen/fullscreen/ta_climate_sandstorm_nearsight
	icon = 'modular_twilight_axis/icons/mob/temperature/temperature_fullscreen.dmi'
	icon_state = "inqvision"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE

/mob/living/proc/ta_climate_has_sandstorm_hood()
	if(!ishuman(src))
		return FALSE
	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/head = H.head
	if(!head || head.obj_broken)
		return FALSE
	return istype(head, /obj/item/clothing/head/roguetown/roguehood) || istype(head, /obj/item/clothing/head/roguetown/menacing) || istype(head, /obj/item/clothing/head/roguetown/necromhood) || istype(head, /obj/item/clothing/head/roguetown/necrahood)

/mob/living/proc/ta_climate_set_sandstorm_exposure(exposed)
	if(exposed && stat != DEAD)
		if(!HAS_TRAIT(src, "Sandstormed"))
			ADD_TRAIT(src, "Sandstormed", "ta_climate_sandstorm")
		if(ta_climate_sandstorm_eye_protected())
			overlay_fullscreen("ta_climate_sandstorm_dust", /atom/movable/screen/fullscreen/ta_climate_sandstorm_dust/protected)
			clear_fullscreen("ta_climate_sandstorm_nearsight", FALSE)
		else
			overlay_fullscreen("ta_climate_sandstorm_dust", /atom/movable/screen/fullscreen/ta_climate_sandstorm_dust)
			overlay_fullscreen("ta_climate_sandstorm_nearsight", /atom/movable/screen/fullscreen/ta_climate_sandstorm_nearsight)
		return
	REMOVE_TRAIT(src, "Sandstormed", "ta_climate_sandstorm")
	clear_fullscreen("ta_climate_sandstorm_dust", FALSE)
	clear_fullscreen("ta_climate_sandstorm_nearsight", FALSE)

/datum/particle_weather/sandstorm
	var/list/ta_climate_exposed_mobs = list()

/datum/particle_weather/sandstorm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	. = ..()
	if(!L || QDELETED(L))
		return
	var/exposed = L.stat != DEAD && running && !ta_climate_winding_down && severity > 0 && can_weather(L) && can_weather_effect(L) && !HAS_TRAIT(L, "sandstorm_immune") && !HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE) && !HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED)
	if(exposed)
		ta_climate_exposed_mobs |= L
	else
		ta_climate_exposed_mobs -= L
	L.ta_climate_set_sandstorm_exposure(exposed)

/datum/particle_weather/sandstorm/proc/ta_climate_clear_exposed_mobs()
	for(var/mob/living/L as anything in ta_climate_exposed_mobs)
		if(L && !QDELETED(L))
			L.ta_climate_set_sandstorm_exposure(FALSE)
	ta_climate_exposed_mobs.Cut()

/datum/particle_weather/sandstorm/wind_down()
	ta_climate_clear_exposed_mobs()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/sandstorm/end()
	ta_climate_clear_exposed_mobs()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/sandstorm/Destroy()
	ta_climate_clear_exposed_mobs()
	return ..()

/datum/particle_weather/rain_gentle

/datum/particle_weather/rain_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/rain_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/rain_gentle/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/rain_gentle/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/snow_gentle

/datum/particle_weather/snow_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/snow_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/snow_gentle/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/snow_gentle/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/snow_storm

/datum/particle_weather/snow_storm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/snow_storm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/snow_storm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/snow_storm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/hail

/datum/particle_weather/hail/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/hail/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/hail/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/hail/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()


/datum/particle_weather/blood_rain_gentle

/datum/particle_weather/blood_rain_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/blood_rain_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/blood_rain_gentle/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/blood_rain_gentle/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/blood_rain_storm

/datum/particle_weather/blood_rain_storm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/blood_rain_storm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/blood_rain_storm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/blood_rain_storm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/fog

/datum/particle_weather/fog/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/fog/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/leaves_gentle

/datum/particle_weather/leaves_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/leaves_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/sakura_gentle

/datum/particle_weather/sakura_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sakura_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/dust_storm

/datum/particle_weather/dust_storm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/dust_storm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	return ..()

/datum/particle_weather/dust_storm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/dust_storm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather
	var/list/ta_climate_sound_exposure = list()

/datum/particle_weather/weather_sound_effect(mob/living/L, outside = TRUE)
	if(!L || QDELETED(L))
		return
	if(L.stat == DEAD)
		stop_weather_sound_effect(L)
		return
	var/datum/looping_sound/previous_sound = currentSounds[L]
	if(previous_sound && QDELETED(previous_sound))
		currentSounds[L] = null
		previous_sound = null
	if(previous_sound && !isnull(ta_climate_sound_exposure[L]) && ta_climate_sound_exposure[L] != outside)
		stop_weather_sound_effect(L)
	. = ..()
	if(currentSounds[L])
		ta_climate_sound_exposure[L] = outside
	else
		ta_climate_sound_exposure -= L

/datum/particle_weather/stop_weather_sound_effect(mob/living/L)
	ta_climate_sound_exposure -= L
	return ..()

/datum/particle_weather/proc/ta_climate_stop_all_weather_sounds()
	if(islist(currentSounds))
		for(var/sound_owner as anything in currentSounds)
			var/datum/looping_sound/current_sound = currentSounds[sound_owner]
			if(current_sound && !QDELETED(current_sound))
				current_sound.stop()
				qdel(current_sound)
		currentSounds.Cut()
	ta_climate_sound_exposure.Cut()

/datum/particle_weather/rain_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/rain_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/rain_storm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/rain_storm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/snow_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/snow_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/snow_storm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/snow_storm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/hail/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/hail/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/blood_rain_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/blood_rain_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/blood_rain_storm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/blood_rain_storm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/fog/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/fog/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/leaves_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/leaves_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/sakura_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sakura_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/dust_storm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/dust_storm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/rain_gentle/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/rain_storm/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/fog/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/dust_storm/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/proc/ta_climate_native_weather_exposed(mob/living/L)
	return L && !QDELETED(L) && L.stat != DEAD && isturf(L.loc) && ta_climate_valid_outdoors(get_turf(L))

/datum/particle_weather/rain_gentle/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/rain_storm/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/snow_gentle/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/snow_storm/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/hail/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/blood_rain_gentle/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/blood_rain_storm/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/fog/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/leaves_gentle/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/sakura_gentle/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()

/datum/particle_weather/dust_storm/can_weather(mob/living/L)
	if(!ta_climate_native_weather_exposed(L))
		return FALSE
	return ..()


/obj/weather_effect/fog_parallax/proc/ta_climate_start_parallax_scroll(datum/particle_weather/W)
	if(!W || !W.ta_climate_weather || !W.parallax_weather)
		return
	if(detail_layer)
		vis_contents -= detail_layer
	if(!W.weather_scroll_x && !W.weather_scroll_y)
		return
	var/matrix/end_transform = matrix()
	end_transform.Translate(W.weather_scroll_x, W.weather_scroll_y)
	animate(src, transform = end_transform, time = max(1, W.weather_scroll_time), loop = -1, tag = "ta_climate_weather_drift")
	animate(transform = null, time = 0)

/datum/particle_weather/heatwave/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/heatwave/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/heatwave/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/heatwave/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/heatwave/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/heatwave/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/heatwave/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/heatwave/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/heatwave/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/sand_gentle/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sand_gentle/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sand_gentle/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/sand_gentle/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/sand_gentle/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/sand_gentle/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/sand_gentle/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/sand_gentle/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/sand_gentle/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/sandstorm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sandstorm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/sandstorm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/sandstorm/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/sandstorm/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/sandstorm/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/dry_thunderstorm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/dry_thunderstorm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/dry_thunderstorm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/dry_thunderstorm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/dry_thunderstorm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/dry_thunderstorm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/dry_thunderstorm/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/dry_thunderstorm/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/dry_thunderstorm/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/ashstorm/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/ashstorm/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/ashstorm/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/ashstorm/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/ashstorm/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/ashstorm/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/ashstorm/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/ashstorm/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/ashstorm/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/fireflies/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/fireflies/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/fireflies/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/fireflies/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/fireflies/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/fireflies/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/fireflies/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/fireflies/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/fireflies/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

/datum/particle_weather/hurricane/start(color)
	if(SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/hurricane/ChangeSeverity()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	return ..()

/datum/particle_weather/hurricane/wind_down()
	if(!running || ta_climate_winding_down || SSParticleWeather?.runningWeather != src)
		return
	ta_climate_winding_down = TRUE
	ta_climate_clear_owned_wind_hazards()
	return ..()

/datum/particle_weather/hurricane/end()
	if(SSParticleWeather?.runningWeather != src)
		return
	ta_climate_clear_owned_wind_hazards()
	ta_climate_stop_all_weather_sounds()
	return ..()

/datum/particle_weather/hurricane/try_weather_act(mob/living/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		return
	return ..()

/datum/particle_weather/hurricane/weather_obj_act(obj/L)
	if(!running || ta_climate_winding_down || severity <= 0)
		if(L)
			L.weather = FALSE
		return
	return ..()

/datum/particle_weather/hurricane/can_weather(mob/living/L)
	if(!L || QDELETED(L) || L.stat == DEAD || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	return ..()

/datum/particle_weather/hurricane/can_weather_effect(mob/living/L)
	if(!L || !isturf(L.loc))
		return FALSE
	return ..()

/datum/particle_weather/hurricane/can_weather_act_obj(obj/O)
	if(!O || !isturf(O.loc) || !ta_climate_valid_outdoors(get_turf(O)))
		return FALSE
	return ..()

