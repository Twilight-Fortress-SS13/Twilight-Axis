SUBSYSTEM_DEF(ta_snowdrifts)
	name = "Snowdrifts"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/obj/structure/ta_snowdrift/snowdrifts = list()
	var/snowdrift_cursor = 1
	var/drifts_to_maintain_per_tick = 80
	var/snowfall_index_tiles_per_tick = 2500
	var/snowfall_attempts_per_tick = 1000
	var/snowstorm_attempts_per_tick = 1500
	var/snowfall_existing_drifts_per_tick = 200
	var/snowstorm_existing_drifts_per_tick = 320
	var/snowfall_exposed_cursor = 1
	var/snowfall_floor_cursor = 1
	var/precipitation_first = FALSE
	var/list/snowfall_weather_z_levels = list()
	var/list/snowfall_candidates = list()
	var/list/snowfall_exposed_candidates = list()
	var/snowfall_index_total = 0
	var/snowfall_index_progress = 0
	var/snowfall_index_position = 0
	var/snowfall_index_stride = 1
	var/snowfall_index_complete = FALSE
	var/snowfall_index_updated_at = 0
	var/snowfall_index_season
	var/snowfall_created_last_fire = 0
	var/snowfall_grown_last_fire = 0
	var/list/heat_sources_to_process = list()
	var/list/heated_snow_turfs = list()
	var/next_heat_check = 0

/datum/controller/subsystem/ta_snowdrifts/stat_entry()
	return ..("D:[length(snowdrifts)] F:[length(snowfall_candidates)] E:[length(snowfall_exposed_candidates)] I:[snowfall_index_progress]/[snowfall_index_total] N:[snowfall_created_last_fire] G:[snowfall_grown_last_fire]")

/datum/controller/subsystem/ta_snowdrifts/fire(resumed = FALSE)
	var/datum/particle_weather/current_weather = SSParticleWeather?.runningWeather
	var/snowing = current_weather?.running && current_weather.severity > 0 && (istype(current_weather, /datum/particle_weather/snow_gentle) || istype(current_weather, /datum/particle_weather/snow_storm))
	var/heavy = istype(current_weather, /datum/particle_weather/snow_storm)
	precipitation_first = !precipitation_first
	if(!snowfall_index_total || (snowfall_index_complete && (snowfall_index_season != SSseason?.current_season || (!snowing && world.time >= snowfall_index_updated_at + 10 MINUTES))))
		reset_snowfall_index()
	if(snowing && precipitation_first && !process_precipitation(heavy))
		return
	if(!snowfall_index_complete && precipitation_first && !build_snowfall_index())
		return
	if(world.time >= next_heat_check && !length(heat_sources_to_process))
		next_heat_check = world.time + 5 SECONDS
		heat_sources_to_process = GLOB.fires_list.Copy()
		heated_snow_turfs = list()
	while(length(heat_sources_to_process))
		var/obj/machinery/light/rogue/F = heat_sources_to_process[length(heat_sources_to_process)]
		heat_sources_to_process.len--
		if(is_major_snow_heat(F))
			for(var/turf/open/floor/T in range(1, F))
				heated_snow_turfs[T] = TRUE
				var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
				if(S && !QDELETED(S))
					S.maintain_snow(snowing, TRUE)
		if(MC_TICK_CHECK)
			return
	var/budget = min(drifts_to_maintain_per_tick, length(snowdrifts))
	for(var/i in 1 to budget)
		if(!length(snowdrifts))
			break
		if(snowdrift_cursor > length(snowdrifts))
			snowdrift_cursor = 1
		var/obj/structure/ta_snowdrift/S = snowdrifts[snowdrift_cursor]
		snowdrift_cursor++
		if(!S || QDELETED(S))
			snowdrifts -= S
			continue
		S.maintain_snow(snowing)
		if(MC_TICK_CHECK)
			return
	if(snowing && !precipitation_first && !process_precipitation(heavy))
		return
	if(!snowfall_index_complete && !precipitation_first)
		build_snowfall_index()

/datum/controller/subsystem/ta_snowdrifts/proc/reset_snowfall_index()
	snowfall_weather_z_levels = list()
	for(var/z in 1 to world.maxz)
		if(SSoutdoor_effects?.turf_weather_affectable_z_levels[z])
			snowfall_weather_z_levels += z
	snowfall_candidates = list()
	snowfall_exposed_candidates = list()
	snowfall_exposed_cursor = 1
	snowfall_floor_cursor = 1
	snowfall_index_total = world.maxx * world.maxy * length(snowfall_weather_z_levels)
	snowfall_index_progress = 0
	snowfall_index_complete = FALSE
	snowfall_index_updated_at = world.time
	snowfall_index_season = SSseason?.current_season
	if(snowfall_index_total <= 1)
		snowfall_index_position = 0
		snowfall_index_stride = 1
		return
	snowfall_index_position = rand(0, snowfall_index_total - 1)
	snowfall_index_stride = rand(1, snowfall_index_total - 1)
	while(TRUE)
		var/a = snowfall_index_stride
		var/b = snowfall_index_total
		while(b)
			var/remainder = a % b
			a = b
			b = remainder
		if(a == 1)
			break
		snowfall_index_stride++
		if(snowfall_index_stride >= snowfall_index_total)
			snowfall_index_stride = 1

/datum/controller/subsystem/ta_snowdrifts/proc/snowfall_index_to_turf(index)
	var/tiles_per_z = world.maxx * world.maxy
	if(!tiles_per_z)
		return null
	var/z_index = floor(index / tiles_per_z) + 1
	if(z_index < 1 || z_index > length(snowfall_weather_z_levels))
		return null
	var/tile_index = index % tiles_per_z
	var/x = (tile_index % world.maxx) + 1
	var/y = floor(tile_index / world.maxx) + 1
	return locate(x, y, snowfall_weather_z_levels[z_index])

/datum/controller/subsystem/ta_snowdrifts/proc/build_snowfall_index()
	if(!snowfall_index_total)
		return TRUE
	var/checked = 0
	while(snowfall_index_progress < snowfall_index_total && checked < snowfall_index_tiles_per_tick)
		var/turf/open/floor/T = snowfall_index_to_turf(snowfall_index_position)
		if(istype(T, /turf/open/floor) && !T.density)
			snowfall_candidates += (snowfall_index_position + 1)
			if(ta_climate_valid_outdoors(T))
				snowfall_exposed_candidates += (snowfall_index_position + 1)
		snowfall_index_position += snowfall_index_stride
		if(snowfall_index_position >= snowfall_index_total)
			snowfall_index_position -= snowfall_index_total
		snowfall_index_progress++
		checked++
		if(MC_TICK_CHECK)
			return FALSE
	if(snowfall_index_progress >= snowfall_index_total)
		snowfall_index_complete = TRUE
		snowfall_index_updated_at = world.time
	return TRUE

/datum/controller/subsystem/ta_snowdrifts/proc/process_precipitation(heavy)
	snowfall_created_last_fire = 0
	snowfall_grown_last_fire = 0
	if(!snowfall_index_total)
		return TRUE
	var/candidate_count = length(snowfall_candidates)
	var/exposed_count = length(snowfall_exposed_candidates)
	var/total_attempts = heavy ? snowstorm_attempts_per_tick : snowfall_attempts_per_tick
	var/exposed_attempts = min(exposed_count, round(total_attempts * 0.9))
	var/floor_attempts = min(candidate_count, total_attempts - exposed_attempts)
	for(var/pass in 1 to 2)
		var/list/current_candidates = pass == 1 ? snowfall_exposed_candidates : snowfall_candidates
		var/attempts = pass == 1 ? exposed_attempts : floor_attempts
		if(!attempts)
			continue
		var/count = length(current_candidates)
		var/cursor = pass == 1 ? snowfall_exposed_cursor : snowfall_floor_cursor
		if(cursor > count)
			cursor = 1
		for(var/i in 1 to attempts)
			var/turf/open/floor/T = snowfall_index_to_turf(current_candidates[cursor] - 1)
			cursor++
			if(cursor > count)
				cursor = 1
			if(pass == 1)
				snowfall_exposed_cursor = cursor
			else
				snowfall_floor_cursor = cursor
			if(istype(T, /turf/open/floor) && prob(heavy ? 30 : 20) && valid_snow_turf(T) && !heated_snow_turfs[T])
				var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
				if(S && !QDELETED(S))
					S.add_snow(heavy ? 2 : 1)
					snowfall_grown_last_fire++
				else
					new /obj/structure/ta_snowdrift(T)
					snowfall_created_last_fire++
			if(MC_TICK_CHECK)
				return FALSE
	var/growth_attempts = min(heavy ? snowstorm_existing_drifts_per_tick : snowfall_existing_drifts_per_tick, length(snowdrifts))
	for(var/i in 1 to growth_attempts)
		var/obj/structure/ta_snowdrift/S = snowdrifts[rand(1, length(snowdrifts))]
		if(S && !QDELETED(S) && prob(heavy ? 30 : 20))
			var/turf/open/floor/T = get_turf(S)
			if(istype(T, /turf/open/floor) && valid_snow_turf(T) && !heated_snow_turfs[T])
				S.add_snow(heavy ? 2 : 1)
				snowfall_grown_last_fire++
		if(MC_TICK_CHECK)
			return FALSE
	return TRUE

/datum/controller/subsystem/ta_snowdrifts/proc/is_major_snow_heat(obj/machinery/light/rogue/F)
	if(!F || QDELETED(F) || !F.on || !isturf(F.loc))
		return FALSE
	if(istype(F, /obj/machinery/light/rogue/campfire) || istype(F, /obj/machinery/light/rogue/hearth))
		return TRUE
	return istype(F, /obj/machinery/light/rogue/firebowl) && !istype(F, /obj/machinery/light/rogue/firebowl/standing)

/datum/controller/subsystem/ta_snowdrifts/proc/try_shovel_snow(turf/T, mob/living/user, obj/item/tool)
	if(!user || !T || !istype(tool, /obj/item/rogueweapon/shovel))
		return FALSE
	var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
	if(!S || user.used_intent?.type != /datum/intent/shovelscoop)
		return FALSE
	if(get_dist(user, S) <= 1)
		S.shovel_snow(user)
	return TRUE

/datum/controller/subsystem/ta_snowdrifts/proc/valid_snow_turf(turf/open/floor/T, ignore_heat = FALSE)
	if(!istype(T, /turf/open/floor) || T.density || T.platform_atom_count)
		return FALSE
	if(!ta_climate_valid_outdoors(T))
		return FALSE
	if(SSmapping?.config?.map_name == "Desert Town")
		return FALSE
	if(!ignore_heat && T.heat > 0)
		return FALSE
	if(locate(/obj/structure/hotspring) in T)
		return FALSE
	if(locate(/obj/structure/stairs) in T)
		return FALSE
	if(locate(/obj/structure/mineral_door) in T)
		return FALSE
	return TRUE

/datum/controller/subsystem/ta_snowdrifts/proc/try_snowfall(turf/open/floor/T, heavy = FALSE)
	if(!valid_snow_turf(T) || heated_snow_turfs[T])
		return
	var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
	if(S)
		S.add_snow(heavy ? 2 : 1)
		return
	new /obj/structure/ta_snowdrift(T)

/obj/structure/ta_snowdrift
	name = "snowdrift"
	desc = "Слежавшийся снег затрудняет передвижение. Частые шаги постепенно утаптывают тропу."
	icon = 'modular_twilight_axis/icons/effects/snowdrifts.dmi'
	icon_state = "blank"
	anchored = TRUE
	density = FALSE
	plane = GAME_PLANE
	layer = BELOW_OBJ_LAYER
	var/depth = 1
	var/progression = 0
	var/foot_traffic = 0
	var/last_melt = 0
	var/melt_progress = 0
	var/list/tracks = list("2" = FALSE, "1" = FALSE, "8" = FALSE, "4" = FALSE)
	var/snow_appearance_signature

/obj/structure/ta_snowdrift/Initialize(mapload)
	. = ..()
	if(!isturf(loc))
		return INITIALIZE_HINT_QDEL
	SSta_snowdrifts.snowdrifts += src
	update_snow_slowdown()
	update_snow_appearance()
	update_snow_submersion()
	update_neighbours(null, 0, depth)

/obj/structure/ta_snowdrift/Destroy()
	update_snow_submersion(FALSE)
	SSta_snowdrifts.snowdrifts -= src
	update_neighbours(src, depth, 0)
	return ..()

/obj/structure/ta_snowdrift/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use a shovel with SCOOP intent to clear the snow, one layer at a time.")

/obj/structure/ta_snowdrift/attackby(obj/item/W, mob/living/user, params)
	if(SSta_snowdrifts.try_shovel_snow(get_turf(src), user, W))
		return TRUE
	return ..()

/obj/structure/ta_snowdrift/proc/shovel_snow(mob/living/user)
	if(!user || get_dist(user, src) > 1)
		return
	if(!do_after(user, 2 SECONDS, target = src))
		return
	if(QDELETED(src) || get_dist(user, src) > 1)
		return
	playsound(src, 'sound/items/dig_shovel.ogg', 70, TRUE)
	to_chat(user, span_notice("Вы разгребаете снег лопатой."))
	set_depth(depth - 1)

/obj/structure/ta_snowdrift/proc/update_snow_slowdown()
	object_slowdown = foot_traffic >= 2 ? 0 : 1.5 * depth

/obj/structure/ta_snowdrift/proc/add_snow(amount)
	progression += amount
	if(progression < depth * 8)
		return
	progression = 0
	foot_traffic = 0
	for(var/direction in tracks)
		tracks[direction] = FALSE
	update_snow_slowdown()
	if(depth < 3)
		set_depth(depth + 1)
	else
		update_snow_appearance()
		if(prob(12))
			var/turf/open/floor/adjacent = get_step(loc, pick(NORTH, SOUTH, EAST, WEST))
			SSta_snowdrifts.try_snowfall(adjacent, FALSE)

/obj/structure/ta_snowdrift/proc/set_depth(new_depth)
	if(new_depth <= 0)
		qdel(src)
		return
	var/previous_depth = depth
	depth = min(new_depth, 3)
	if(depth == previous_depth)
		return
	update_snow_slowdown()
	update_snow_appearance()
	update_snow_submersion()
	update_neighbours(null, previous_depth, depth)

/datum/element/mob_overlay_effect/ta_snow/on_add(datum/source, datum/target)
	if(istype(target, /obj/structure/fluff/statue) || istype(target, /obj/structure/underworld/carriage_normal) || istype(target, /obj/structure/eoran_pomegranate_tree) || istype(target, /obj/machinery/light/rogue/lanternpost) || istype(target, /obj/structure/fluff/railing/fence) || istype(target, /obj/structure/fluff/psycross))
		return
	return ..()

/obj/structure/ta_snowdrift/proc/should_sink_in_snow(atom/movable/target)
	if(!target || target == src || QDELETED(target))
		return FALSE
	if(isliving(target) || isitem(target))
		return TRUE
	if(!isobj(target))
		return FALSE
	var/obj/O = target
	if(istype(O, /obj/structure/fluff/statue) || istype(O, /obj/structure/underworld/carriage_normal) || istype(O, /obj/structure/eoran_pomegranate_tree) || istype(O, /obj/machinery/light/rogue/lanternpost) || istype(O, /obj/structure/fluff/railing/fence) || istype(O, /obj/structure/fluff/psycross))
		return FALSE
	if(O.obj_flags & IGNORE_SINK)
		return FALSE
	if(istype(O, /obj/structure/flora/tree))
		return FALSE
	if(isstructure(O) && O.density)
		return FALSE
	return isstructure(O) || istype(O, /obj/machinery)

/obj/structure/ta_snowdrift/proc/update_snow_submersion(replace = TRUE)
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/list/affected = list()
	for(var/atom/movable/AM in T)
		if(!should_sink_in_snow(AM))
			continue
		affected += AM
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_REMOVE, AM)
	RemoveElement(/datum/element/mob_overlay_effect/ta_snow)
	if(!replace)
		return
	AddElement(/datum/element/mob_overlay_effect/ta_snow, depth * 2.4, -6 + (depth * 3.5), 100)
	for(var/atom/movable/AM as anything in affected)
		if(!QDELETED(AM) && get_turf(AM) == T)
			SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_FORCE_UPDATE, AM)

/obj/structure/ta_snowdrift/proc/maintain_snow(snowing, heated = FALSE)
	var/turf/open/floor/T = get_turf(src)
	if(!istype(T, /turf/open/floor) || !SSta_snowdrifts.valid_snow_turf(T, TRUE))
		qdel(src)
		return
	var/thawing = (!snowing && SSseason?.current_season != SEASON_WINTER) || heated || SSta_snowdrifts.heated_snow_turfs[T]
	if(!thawing)
		last_melt = 0
		melt_progress = 0
		return
	if(!last_melt)
		last_melt = world.time
		return
	melt_progress += max(0, world.time - last_melt)
	last_melt = world.time
	if(melt_progress < 60 SECONDS)
		return
	var/layers_to_melt = min(depth, floor(melt_progress / (60 SECONDS)))
	melt_progress -= layers_to_melt * 60 SECONDS
	set_depth(depth - layers_to_melt)

/obj/structure/ta_snowdrift/Crossed(atom/movable/arrived)
	. = ..()
	if(isliving(arrived))
		var/mob/living/L = arrived
		if(!L.is_floor_hazard_immune())
			register_step(turn(L.dir, 180))

/obj/structure/ta_snowdrift/Uncrossed(atom/movable/gone)
	. = ..()
	if(isliving(gone))
		var/mob/living/L = gone
		if(!L.is_floor_hazard_immune())
			register_step(L.dir)

/obj/structure/ta_snowdrift/proc/register_step(direction)
	if(!(direction in list(NORTH, SOUTH, EAST, WEST)))
		return
	var/had_track = tracks["[direction]"]
	var/was_unpacked = foot_traffic < 2
	tracks["[direction]"] = TRUE
	foot_traffic = min(foot_traffic + 1, 8)
	if(was_unpacked && foot_traffic >= 2)
		update_snow_slowdown()
	if(!had_track)
		update_snow_appearance()

/obj/structure/ta_snowdrift/proc/update_neighbours(obj/structure/ta_snowdrift/ignored, old_depth = 0, new_depth = 0)
	var/changed_layer = min(old_depth, new_depth) + 1
	for(var/turf/T in orange(1, src))
		var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
		if(S && S != src && !QDELETED(S) && S.depth >= changed_layer)
			S.update_snow_appearance(ignored)

/obj/structure/ta_snowdrift/proc/update_snow_appearance(obj/structure/ta_snowdrift/ignored)
	var/static/list/image_cache = list()
	var/list/diagonals = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)
	var/list/connection_dirs = list()
	for(var/turf/T in orange(1, src))
		var/obj/structure/ta_snowdrift/S = locate(/obj/structure/ta_snowdrift) in T
		if(S && S != ignored && S.depth >= 1)
			connection_dirs["[get_dir(src, S)]"] = S.depth
	var/list/states = list()
	var/list/directions = list()
	var/list/signature_parts = list()
	for(var/level in 1 to depth)
		for(var/index in 1 to 4)
			var/diagonal = diagonals[index]
			var/corners = 0
			if(connection_dirs["[turn(diagonal, 45)]"] >= level)
				corners |= 1
			if(connection_dirs["[diagonal]"] >= level)
				corners |= 2
			if(connection_dirs["[turn(diagonal, -45)]"] >= level)
				corners |= 4
			var/state = "snow_[level]_[corners]"
			var/draw_direction = 1 << (index - 1)
			states += state
			directions += draw_direction
			signature_parts += "[state]:[draw_direction]"
	var/track_state = ""
	for(var/direction in tracks)
		if(tracks[direction])
			track_state += direction
	if(length(track_state))
		signature_parts += "track:[track_state]"
	var/next_signature = jointext(signature_parts, "|")
	if(snow_appearance_signature == next_signature)
		return
	snow_appearance_signature = next_signature
	overlays.Cut()
	for(var/index in 1 to length(states))
		var/state = states[index]
		var/draw_direction = directions[index]
		var/cache_key = "[icon]:[state]:[draw_direction]"
		var/image/cached_image = image_cache[cache_key]
		if(!cached_image)
			cached_image = image(icon, state, dir = draw_direction)
			image_cache[cache_key] = cached_image
		overlays += cached_image
	if(length(track_state))
		var/track_key = "[icon]:track:[track_state]"
		var/image/track_image = image_cache[track_key]
		if(!track_image)
			track_image = image(icon, track_state)
			image_cache[track_key] = track_image
		overlays += track_image

/obj/structure/ta_snowdrift/ex_act(severity)
	set_depth(depth - 1)

/obj/structure/underworld/carriage_normal
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER

/obj/structure/eoran_pomegranate_tree
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER
