GLOBAL_LIST_EMPTY(ta_climate_tornadoes)
GLOBAL_LIST_EMPTY(ta_climate_dust_devils)
GLOBAL_LIST_EMPTY(ta_climate_abyssors_rage)

/datum/controller/subsystem/outdoor_effects/proc/ta_climate_initialize_weather_z_levels()
	if(!SSmapping?.config)
		return
	var/list/map_traits = SSmapping.config.traits
	if(!islist(map_traits) || !length(map_traits))
		return
	var/first_z = SSmapping.station_start
	if(!isnum(first_z) || first_z <= 0)
		return
	for(var/offset in 0 to (length(map_traits) - 1))
		var/zlevel = first_z + offset
		if(!SSmapping.level_trait(zlevel, ZTRAIT_STATION) || SSmapping.level_trait(zlevel, ZTRAIT_IGNORE_WEATHER_TRAIT))
			continue
		turf_weather_affectable_z_levels[zlevel] = TRUE

/proc/ta_climate_valid_outdoors(turf/T)
	if(!istype(T, /turf/open) || T.density || !T.outdoor_effect || T.outdoor_effect.weatherproof)
		return FALSE
	return !!SSoutdoor_effects?.turf_weather_affectable_z_levels[T.z]

/proc/ta_climate_lightning_exposed(mob/living/L, datum/particle_weather/weather_source)
	if(!L || QDELETED(L) || L.stat == DEAD || !isturf(L.loc) || !ta_climate_valid_outdoors(get_turf(L)))
		return FALSE
	if(HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE) || HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, TRAIT_RAINSTORM_IMMUNE))
		return FALSE
	if(weather_source)
		if(weather_source.immunity_type && HAS_TRAIT(L, weather_source.immunity_type))
			return FALSE
		if(!weather_source.can_weather(L) || !weather_source.can_weather_effect(L))
			return FALSE
	return TRUE

/proc/ta_climate_spawn_lightning(datum/particle_weather/weather_source, strike_count = 6)
	var/list/targets = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		if(ta_climate_lightning_exposed(L, weather_source))
			targets += L
	if(!length(targets))
		return
	for(var/i in 1 to min(strike_count, 10))
		var/mob/living/anchor = pick(targets)
		if(!ta_climate_lightning_exposed(anchor, weather_source))
			continue
		if(anchor.badluck(4))
			anchor.Immobilize(0.5 SECONDS)
			anchor.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
			anchor.electrocute_act(1, weather_source, 1, SHOCK_NOSTUN)
			anchor.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
			new /obj/effect/temp_visual/ta_climate_lightning(get_turf(anchor))
		var/list/safe_tiles = list()
		for(var/turf/open/T in range(7, anchor))
			if(ta_climate_valid_outdoors(T))
				safe_tiles += T
		if(length(safe_tiles))
			new /obj/effect/temp_visual/ta_climate_lightning(pick(safe_tiles))

/obj/effect/temp_visual/ta_climate_lightning
	name = "lightning"
	icon = 'modular_twilight_axis/icons/effects/lightning.dmi'
	icon_state = "strike"
	pixel_y = 24
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	light_system = MOVABLE_LIGHT
	light_color = "#D8E4ED"
	light_outer_range = 15
	light_power = 25
	duration = 12

/obj/effect/temp_visual/ta_climate_lightning/Initialize(mapload)
	. = ..()
	playsound(get_turf(src), 'modular_twilight_axis/sound/weather/thunder_1.ogg', 80, TRUE)

/obj/effect/temp_visual/ta_climate_heat_ripple
	name = "heat ripple"
	icon = 'modular_twilight_axis/icons/effects/heat_ripple.dmi'
	icon_state = "heatwave"
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	alpha = 30
	duration = 20

/obj/effect/temp_visual/ta_climate_heat_ripple/Initialize(mapload)
	. = ..()
	animate(src, alpha = 65, time = 8)
	animate(alpha = 0, time = 12)

/datum/particle_weather/proc/ta_climate_clear_owned_wind_hazards()
	for(var/obj/effect/weather/ta_climate_tornado/T as anything in GLOB.ta_climate_tornadoes.Copy())
		if(T && !QDELETED(T) && T.ta_climate_source_weather == src)
			qdel(T)

/proc/ta_climate_spawn_wind_hazard(path, max_active = 2, min_distance = 8, max_distance = 20, min_spacing = 30, max_attempts = 3, datum/particle_weather/source_weather = null)
	if(source_weather && (QDELETED(source_weather) || SSParticleWeather?.runningWeather != source_weather || !source_weather.running || source_weather.severity <= 0 || source_weather.vars["ta_climate_winding_down"]))
		return FALSE
	if(!ispath(path, /obj/effect/weather/ta_climate_tornado))
		return FALSE
	var/is_dust_devil = ispath(path, /obj/effect/weather/ta_climate_tornado/dust_devil)
	var/is_abyssor = ispath(path, /obj/effect/weather/ta_climate_tornado/abyssors_rage)
	var/weather_immunity_trait = is_dust_devil ? "sandstorm_immune" : TRAIT_RAINSTORM_IMMUNE
	var/current_count = 0
	if(is_dust_devil)
		current_count = length(GLOB.ta_climate_dust_devils)
	else if(is_abyssor)
		current_count = length(GLOB.ta_climate_abyssors_rage)
	else
		for(var/obj/effect/weather/ta_climate_tornado/T as anything in GLOB.ta_climate_tornadoes)
			if(T.type == /obj/effect/weather/ta_climate_tornado)
				current_count++
	if(current_count >= max_active)
		return FALSE
	var/list/players = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		if(L.stat == DEAD || !isturf(L.loc) || HAS_TRAIT(L, TRAIT_WEATHER_IMMUNE) || HAS_TRAIT(L, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(L, weather_immunity_trait))
			continue
		if(source_weather && ((source_weather.immunity_type && HAS_TRAIT(L, source_weather.immunity_type)) || !source_weather.can_weather(L) || !source_weather.can_weather_effect(L)))
			continue
		if(ta_climate_valid_outdoors(get_turf(L)))
			players += L
	if(!length(players))
		return FALSE
	var/mob/living/anchor = pick(players)
	var/turf/center = get_turf(anchor)
	if(is_dust_devil)
		var/nearby = 0
		for(var/obj/effect/weather/ta_climate_tornado/dust_devil/D in range(7, center))
			nearby++
		if(nearby >= 2)
			return FALSE
		var/list/possible = list()
		for(var/turf/open/T in range(7, center))
			if(!ta_climate_valid_outdoors(T) || istype(get_area(T), /area/rogue/outdoors/town) || istype(get_area(T), /area/rogue/indoors/town))
				continue
			possible += T
		if(!length(possible))
			return FALSE
		var/obj/effect/weather/ta_climate_tornado/created = new path(pick(possible))
		created.ta_climate_source_weather = source_weather
		return TRUE
	for(var/i in 1 to max_attempts)
		var/dist = rand(min_distance, max_distance)
		var/angle = rand(0, 359)
		var/turf/open/T = locate(center.x + round(dist * cos(angle)), center.y + round(dist * sin(angle)), center.z)
		if(!ta_climate_valid_outdoors(T))
			continue
		var/too_close = FALSE
		for(var/obj/effect/weather/ta_climate_tornado/other as anything in GLOB.ta_climate_tornadoes)
			if(other.z != T.z || get_dist(other, T) >= min_spacing)
				continue
			if(is_abyssor ? istype(other, /obj/effect/weather/ta_climate_tornado/abyssors_rage) : (other.type == /obj/effect/weather/ta_climate_tornado))
				too_close = TRUE
				break
		if(too_close)
			continue
		var/obj/effect/weather/ta_climate_tornado/created = new path(T)
		created.ta_climate_source_weather = source_weather
		return TRUE
	return FALSE

/obj/effect/weather/ta_climate_tornado
	name = "tornado"
	desc = "Воронка стремительно вращающегося воздуха."
	icon = 'modular_twilight_axis/icons/effects/tornado.dmi'
	icon_state = "Tornado"
	pixel_x = -96
	pixel_y = -32
	plane = GAME_PLANE
	layer = ABOVE_MOB_LAYER
	alpha = 150
	anchored = FALSE
	density = FALSE
	movement_type = FLYING
	var/radius = 5
	var/spin_strength = 15
	var/z_throw_chance = 0
	var/drift_delay = 10
	var/next_drift_time = 0
	var/current_drift_dir = SOUTH
	var/next_dir_change = 0
	var/next_pull = 0
	var/lifetime = 180 SECONDS
	var/next_sound = 0
	var/sound_range = 20
	var/sound_volume = 75
	var/wind_immunity_trait = TRAIT_RAINSTORM_IMMUNE
	var/datum/particle_weather/ta_climate_source_weather

/obj/effect/weather/ta_climate_tornado/proc/ta_climate_has_active_source_weather()
	if(!ta_climate_source_weather)
		return TRUE
	return !QDELETED(ta_climate_source_weather) && SSParticleWeather?.runningWeather == ta_climate_source_weather && ta_climate_source_weather.running && !ta_climate_source_weather.vars["ta_climate_winding_down"] && ta_climate_source_weather.severity > 0

/obj/effect/weather/ta_climate_tornado/Initialize(mapload)
	. = ..()
	GLOB.ta_climate_tornadoes += src
	QDEL_IN(src, lifetime)
	START_PROCESSING(SSobj, src)
	visible_message(span_warning("[src] возникает из бушующих ветров!"))

/obj/effect/weather/ta_climate_tornado/Destroy()
	GLOB.ta_climate_tornadoes -= src
	ta_climate_source_weather = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/weather/ta_climate_tornado/process()
	if(!ta_climate_has_active_source_weather())
		qdel(src)
		return
	if(world.time >= next_sound)
		next_sound = world.time + 45 SECONDS
		for(var/mob/M in hearers(sound_range, src))
			M.playsound_local(src, 'modular_twilight_axis/sound/weather/tornado.ogg', sound_volume, FALSE)
	if(world.time >= next_pull)
		next_pull = world.time + 1 SECONDS
		do_spin_pull()
	if(world.time >= next_drift_time)
		next_drift_time = world.time + drift_delay
		if(world.time >= next_dir_change)
			current_drift_dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
			next_dir_change = world.time + rand(3, 8) SECONDS
		var/turf/destination = get_step(src, current_drift_dir)
		if(ta_climate_valid_outdoors(destination))
			step(src, current_drift_dir)

/obj/effect/weather/ta_climate_tornado/proc/do_spin_pull()
	var/turf/center = get_turf(src)
	if(!ta_climate_valid_outdoors(center))
		return
	for(var/atom/movable/A in range(radius, src))
		if(A == src || A.anchored || !isturf(A.loc) || istype(A, /obj/effect/weather/ta_climate_tornado))
			continue
		if(A.move_resist > MOVE_FORCE_EXTREMELY_STRONG)
			continue
		if(isliving(A) && (HAS_TRAIT(A, TRAIT_WEATHER_IMMUNE) || HAS_TRAIT(A, TRAIT_WEATHER_PROTECTED) || HAS_TRAIT(A, wind_immunity_trait)))
			continue
		if(isliving(A) && ta_climate_source_weather)
			var/mob/living/L = A
			if((ta_climate_source_weather.immunity_type && HAS_TRAIT(L, ta_climate_source_weather.immunity_type)) || !ta_climate_source_weather.can_weather(L) || !ta_climate_source_weather.can_weather_effect(L))
				continue
		var/turf/target = get_turf(A)
		if(!target || target.z != z || !SSoutdoor_effects?.turf_weather_affectable_z_levels[target.z])
			continue
		if(!ta_climate_valid_outdoors(target))
			continue
		var/dx = (A.x > x) - (A.x < x)
		var/dy = (A.y > y) - (A.y < y)
		if(!dx && !dy)
			continue
		var/turf/destination = ta_climate_pick_throw_destination(A, -dy, dx)
		if(!destination)
			continue
		A.throw_at(destination, get_dist(A, destination), 10)
		try_z_throw(A)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			H.set_resting(TRUE, TRUE)
			H.Immobilize(2 SECONDS)
			to_chat(H, span_danger("Вас подхватывает [src]!"))

/obj/effect/weather/ta_climate_tornado/proc/ta_climate_pick_throw_destination(atom/movable/A, spin_dx, spin_dy)
	var/turf/origin = get_turf(A)
	if(!origin)
		return null
	var/distance = spin_strength
	while(distance > 0)
		var/turf/landing = locate(origin.x + spin_dx * distance, origin.y + spin_dy * distance, origin.z)
		if(ta_climate_valid_outdoors(landing))
			return landing
		distance--
	return null

/obj/effect/weather/ta_climate_tornado/proc/try_z_throw(atom/movable/A)
	if(!z_throw_chance || !prob(z_throw_chance))
		return
	var/turf/above = GET_TURF_ABOVE(get_turf(A))
	if(ta_climate_valid_outdoors(above))
		A.forceMove(above)

/obj/effect/weather/ta_climate_tornado/dust_devil
	name = "dust devil"
	wind_immunity_trait = "sandstorm_immune"
	desc = "Небольшая быстро движущаяся воронка песка."
	color = "#5F4B37"
	radius = 2
	spin_strength = 3
	z_throw_chance = 60
	drift_delay = 3
	lifetime = 360 SECONDS
	sound_volume = 10

/obj/effect/weather/ta_climate_tornado/dust_devil/Initialize(mapload)
	. = ..()
	GLOB.ta_climate_dust_devils += src
	transform = transform.Scale(0.55, 0.55)

/obj/effect/weather/ta_climate_tornado/dust_devil/Destroy()
	GLOB.ta_climate_dust_devils -= src
	return ..()

/obj/effect/weather/ta_climate_tornado/abyssors_rage
	name = "abyssor's wrath"
	desc = "Разрушительный смерч, оставляющий после себя руины."
	color = "#00d8d8"
	radius = 5
	spin_strength = 15
	lifetime = 240 SECONDS
	var/destruction_radius = 4
	var/destruction_cooldown = 5
	var/next_destruction = 0

/obj/effect/weather/ta_climate_tornado/abyssors_rage/Initialize(mapload)
	. = ..()
	GLOB.ta_climate_abyssors_rage += src
	transform = transform.Scale(1.2, 1.2)

/obj/effect/weather/ta_climate_tornado/abyssors_rage/Destroy()
	GLOB.ta_climate_abyssors_rage -= src
	return ..()

/obj/effect/weather/ta_climate_tornado/abyssors_rage/process()
	if(!ta_climate_has_active_source_weather())
		qdel(src)
		return
	..()
	if(QDELETED(src))
		return
	if(world.time < next_destruction)
		return
	next_destruction = world.time + destruction_cooldown
	if(!ta_climate_valid_outdoors(get_turf(src)))
		return
	for(var/turf/closed/wall/W in range(destruction_radius, src))
		if(W.z != z)
			continue
		if(W.sheet_type && W.sheet_amount)
			var/turf/drop_turf = get_step(src, turn(dir, 180))
			if(!drop_turf)
				drop_turf = get_turf(W)
			new W.sheet_type(drop_turf, W.sheet_amount)
		if(hascall(W, "turf_destruction"))
			call(W, "turf_destruction")()
	for(var/obj/structure/S in range(destruction_radius, src))
		if(S.z != z || (S.anchored && prob(40)))
			continue
		if(hascall(S, "deconstruct"))
			call(S, "deconstruct")(FALSE)
		else
			qdel(S)
