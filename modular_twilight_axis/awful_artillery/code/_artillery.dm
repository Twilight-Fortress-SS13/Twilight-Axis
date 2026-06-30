#define GRAVITY 9.81
#define BASE_AZIMUTH_ERROR 16
#define OVERHEAT_ERROR 50

#define ARTILLERY_DEV_RANGE 4
#define ARTILLERY_HEAVY_RANGE 10
#define ARTILLERY_LIGHT_RANGE 20

GLOBAL_LIST_INIT(artillery_sepia_matrix, list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0))

/obj/item/artillery_shell
	name = "Дружок, если ты это увидел то админы/маппер дурачки"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "cannonball"
	

/obj/item/artillery_shell/proc/shell_action()

/obj/structure/artillery 
	name = "Дружок, если ты это увидел то админы сервера долбаебы"
	desc = "Смайли не воруй"

	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "mortar"

	anchored = 0
	density = 1
	var/azimuth = 0 
	var/elevation = 0 
	var/elevation_min = 1
	var/elevation_max = 90

	var/charge_level = 0
	var/charge_min = 0
	var/charge_max = 5

	var/base_velocity = 5
	var/charge_velocity_step = 15

	var/ammo_type = /obj/item/artillery_shell

	var/obj/item/artillery_shell/ammo

	var/associated_skill = /datum/skill/combat/twilight_firearms
	var/associated_stat = STAT_INTELLIGENCE

	var/barrel_integrity = 15
	var/last_fired = 0
	var/cooldown  = 10 SECONDS
	var/expert_mode_active = FALSE

	var/no_expert_time_multiplier = 3

	var/list/ui_z_levels = list()
	var/list/ui_view_x = list()
	var/list/ui_view_y = list()
	var/list/cached_expert_maps = list()

/obj/structure/artillery/Initialize()
	. = ..()
	barrel_integrity = rand(6, 14)
	charge_velocity_step = rand(8, 20)

/obj/structure/artillery/Destroy()
	ui_z_levels = null
	ui_view_x = null
	ui_view_y = null
	for(var/u in cached_expert_maps)
		var/obj/effect/abstract/artillery_map/map_obj = cached_expert_maps[u]
		if(map_obj)
			var/mob/M = u
			if(M?.client)
				M.client.screen -= map_obj.tiles
			qdel(map_obj)
	cached_expert_maps = null
	return ..()

/obj/structure/artillery/examine(mob/user)
	. = ..()
	if((world.time - last_fired) < cooldown)
		. += span_info("Ствол ощущается горячим, возможно не стоит делать выстрел именно сейчас.")
	else 
		. += span_info("Ствол ощущается холодным, можно произвести выстрел без рисков.")

	if(ishuman(user))
		var/mob/living/carbon/human/C = user
		var/perception = C.get_stat(STAT_PERCEPTION) - 10
		if((perception > 0 || HAS_TRAIT(user, TRAIT_ARTILLERY_EXPERT)) && ((barrel_integrity - perception) < 1 || HAS_TRAIT(user, TRAIT_ARTILLERY_EXPERT)))
			. += span_danger("Моя внимательность позволяет узнать что ствол будет уничтожен через [barrel_integrity] выстрелов")
		else
			. += span_green("Орудие кажется надежным. Оно выстоит как минимум еще несколько выстрелов")

/obj/structure/artillery/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, ammo_type))
		if(ammo)
			to_chat(user, span_info("В стволе уже есть заряд"))
		else
			if(do_after(user, 20, target = src))
				used_item.forceMove(src)
				ammo = used_item
				to_chat(user, span_info("Я зарядил снаряд в [src.name]"))
				playsound(src, 'modular_twilight_axis/awful_artillery/sound/loading.ogg', 100, 0, 1, 1, null, null, FALSE, TRUE)
				log_game("[user] loaded artillery shell into [src]")

	if(istype(used_item, /obj/item/twilight_powderflask))
		if(ammo)
			to_chat(user, span_info("Внутри есть снаряд, нужно его вытащить прежде чем насыпать порох"))
		else
			playsound(src, 'modular_twilight_axis/awful_artillery/sound/powder.ogg', 100, 0, 1, 1, null, null, FALSE, TRUE)
			if(do_after(user, 20, target = src))
				to_chat(user, span_info("Я заправил [src.name] порохом"))
				charge_level = min(charge_level + 1, charge_max)
				log_game("[user] added gun powder into [src]")

	return ..()


/obj/structure/artillery/proc/calculate_coordinates(mob/living/carbon/user)
	if(charge_level == 0)
		return

	var/velocity = base_velocity + charge_level * charge_velocity_step
	var/range = (velocity * velocity / GRAVITY) * sin(2 * elevation)

	var/target_azimuth = azimuth

	if(!HAS_TRAIT(user, TRAIT_ARTILLERY_EXPERT))
		var/user_stat = user.get_stat(associated_stat)
		var/user_skill = user.get_skill_level(associated_skill)
		var/overall_artillery_skill = user_skill + (user_stat - 10) / 2
		
		if(overall_artillery_skill < 5)
			target_azimuth += rand(-BASE_AZIMUTH_ERROR, BASE_AZIMUTH_ERROR)
		else if(overall_artillery_skill < 7)
			target_azimuth += rand(-BASE_AZIMUTH_ERROR/2, BASE_AZIMUTH_ERROR/2)
		else if(overall_artillery_skill < 10)
			target_azimuth += rand(-BASE_AZIMUTH_ERROR/4, BASE_AZIMUTH_ERROR/4)

	if((world.time - last_fired) < cooldown)
		range += rand(-OVERHEAT_ERROR, OVERHEAT_ERROR)
		target_azimuth += rand(-OVERHEAT_ERROR, OVERHEAT_ERROR)

	var/dx = range * sin(target_azimuth)
	var/dy = range * cos(target_azimuth)

	return vector(round(loc.x + dx, 1), round(loc.y + dy, 1))

/obj/structure/artillery/proc/fire_artillery(mob/living/carbon/human/user)
	var/mob/living/carbon/human/H = user
	if(charge_level == 0)
		to_chat(user, span_warning("В стволе нету заряда"))
		return

	if(!ammo)
		to_chat(user, span_warning("В стволе нету снаряда"))
		return

	if(!HAS_TRAIT(user, TRAIT_ARTILLERY_EXPERT))
		var/user_stat = H.get_stat(associated_stat)
		var/user_skill = H.get_skill_level(associated_skill)
		var/overall_artillery_skill = user_skill + (user_stat - 10) / 2
		var/rand_roll = rand(1, 20)

		if((rand_roll + overall_artillery_skill) < 12)
			user.visible_message(span_danger("[user] совершил критическую ошибку при выстреле! [src] уничтожен"))
			explosion(src, 1, 2, 4, flame_range = 2)
			H.adjustBruteLoss(150)
			return

	var/vector/hit_coordinates = calculate_coordinates(user)
	if(!hit_coordinates)
		to_chat(user, span_warning("Что-то не дает мне выстрелить туда"))
		return
	var/turf/target = locate(hit_coordinates.x, hit_coordinates.y, src.z)
	if(!target)
		to_chat(user, span_warning("Что-то не дает мне выстрелить туда"))
		return

	for(var/turf/AT in get_adjacent_turfs(src.loc))
		new/obj/effect/particle_effect/smoke/arquebus(AT)
		if(rand(1,10) > 7)
			for(var/turf/BT in get_adjacent_turfs(AT))
				new/obj/effect/particle_effect/smoke/arquebus(BT)

	var/x_mid = src.x + ((target.x - src.x) * 0.5)
	var/y_mid = src.y + ((target.y - src.y) * 0.5)
	var/z_mid = src.z + ((target.z - src.z) * 0.5)
	var/turf/turf_mid = locate(floor(x_mid), floor(y_mid), floor(z_mid))

	playsound(turf_mid, 'modular_twilight_axis/awful_artillery/sound/flyby.ogg', 100, 0, 50, 1, null, null, FALSE, TRUE)

	playsound(src, 'modular_twilight_axis/awful_artillery/sound/launch.ogg', 100, 0, 20, 1, null, null, FALSE, TRUE)

	ammo.forceMove(target)

	ammo.shell_action()
	
	ammo = null

	charge_level = 0


	if((world.time - last_fired) < cooldown)
		barrel_integrity -= 2
	else 
		barrel_integrity--
	last_fired = world.time
	
	user.visible_message(span_danger("[user] производит выстрел из [src]!"))
	log_game("[user] fired artillery([src]) at [target.loc.name]([target.x] [target.y] [target.z])")
	message_admins("Artillery fired at [ADMIN_VERBOSEJMP(src.loc)] by [user] to [ADMIN_VERBOSEJMP(target)]")

	var/turf/src_turf = get_turf(src)
	for(var/mob/living/M in GLOB.player_list)
		var/message = "Слышно звук выстрела артиллерии"
		var/dist = get_dist(src_turf, M)
		if(dist > 15)
			message += " на расстоянии около [floor(dist/15)*15] метров"
		if(M.z < src.z)
			message += " откуда то сверху"
		if(M.z > src.z)
			message += " откуда то снизу"

		var/dir = get_dir(M, src)
		switch(dir)
			if(NORTH)
				message += " с севера"
			if(SOUTH)
				message += " с юга"
			if(EAST)
				message += " с востока"
			if(WEST)
				message += " с запада"
			if(NORTHEAST)
				message += " с северо-востока"
			if(NORTHWEST)
				message += " с северо-запада"
			if(SOUTHEAST)
				message += " с юго-востока"
			if(SOUTHWEST)
				message += " с юго-запада"

		message += "."
		to_chat(M, message)

	if(barrel_integrity <= 0)
		src.visible_message(span_danger("[src] взрывается из-за износа ствола!"))
		explosion(src, 1, 2, 10, flame_range = 3)

/obj/structure/artillery/proc/get_parts()
	return list()
	
/obj/structure/artillery/ui_interact(mob/user, datum/tgui/ui)
	if(!istype(user, /mob/living/carbon/human))
		return 

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Artillery", "Artillery")
		ui.open()

/obj/structure/artillery/proc/fix_map_glitch(mob/user)
	if(QDELETED(src) || QDELETED(user) || !user.client)
		return
	var/obj/effect/abstract/artillery_map/M = cached_expert_maps[user]
	if(M && !M.redraw_done)
		var/v_x = M.view_x
		var/v_y = M.view_y
		var/v_z = M.view_z
		var/rad = M.radius
		cached_expert_maps[user] = null
		user.client.screen -= M.tiles
		qdel(M)
		generate_map_screen(v_x, v_y, v_z, rad, user, TRUE)

/obj/effect/abstract/artillery_dummy
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = ""
	plane = ABOVE_LIGHTING_PLANE

/obj/effect/abstract/artillery_map
	name = "artillery map"
	var/list/tiles = list()
	var/radius
	var/view_x
	var/view_y
	var/view_z
	var/redraw_done = FALSE

/obj/effect/abstract/artillery_map/Destroy()
	for(var/t in tiles)
		qdel(t)
	tiles.Cut()
	return ..()

/obj/effect/abstract/artillery_map/Initialize(mapload, rad = 6)
	. = ..()
	radius = rad
	var/obj/structure/artillery/A = loc
	for(var/dy in radius to -radius step -1)
		for(var/dx in -radius to radius)
			var/atom/movable/screen/artillery_map_tile/tile = new(src)
			tile.linked_artillery = A
			tile.map_dx = dx
			tile.map_dy = dy
			tile.screen_loc = "artmap:[dx + rad + 1],[dy + rad + 1]"
			tiles += tile

/atom/movable/screen/artillery_map_tile
	name = "artillery map tile"
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	var/map_dx = 0
	var/map_dy = 0
	var/obj/structure/artillery/linked_artillery

/atom/movable/screen/artillery_map_tile/Click(location, control, params)
	var/mob/user = usr
	if(!linked_artillery)
		return

	var/list/P = params2list(params)
	if(P["left"])
		var/obj/effect/abstract/artillery_map/M = loc
		if(istype(M))
			if(M.radius == 15)
				linked_artillery.expert_target_tile(user, map_dx, map_dy)
			else
				linked_artillery.target_tile(user, map_dx, map_dy)

/obj/structure/artillery/proc/generate_map_screen(view_x, view_y, view_z, radius, mob/user, no_redraw = FALSE)
	var/obj/effect/abstract/artillery_map/M = cached_expert_maps[user]
	var/map_id = radius == 15 ? "expert_artmap" : "normal_artmap"
	
	if(M && M.radius == radius && M.view_x == view_x && M.view_y == view_y && M.view_z == view_z)
		if(user.client)
			user.client.screen |= M.tiles
			winset(user, map_id, "icon-size=[radius == 15 ? 16 : 32]")
		return M

	if(M)
		if(user.client)
			user.client.screen -= M.tiles
		qdel(M)

	M = new /obj/effect/abstract/artillery_map(src, radius)
	M.view_x = view_x
	M.view_y = view_y
	M.view_z = view_z
	cached_expert_maps[user] = M

	if(no_redraw)
		M.redraw_done = TRUE
	else
		addtimer(CALLBACK(src, PROC_REF(fix_map_glitch), user), 10)

	var/tile_index = 1
	var/list/t_list = M.tiles
	for(var/dy in radius to -radius step -1)
		var/ty = view_y + dy
		for(var/dx in -radius to radius)
			var/tx = view_x + dx
			var/atom/movable/screen/artillery_map_tile/tile = t_list[tile_index++]
			tile.overlays.Cut()

			var/turf/T = locate(tx, ty, view_z)
			if(!T) continue

			var/turf/highest = get_highest_turf(T)
			if(!highest) continue

			tile.appearance = highest.appearance
			tile.screen_loc = "[map_id]:[dx + radius + 1],[dy + radius + 1]"
			tile.plane = ABOVE_LIGHTING_PLANE
			tile.layer = 100
			tile.mouse_opacity = MOUSE_OPACITY_OPAQUE
			tile.color = GLOB.artillery_sepia_matrix

			if(dx == 0 && dy == 0)
				var/image/crosshair = image('icons/mob/screen_gen.dmi', "")
				crosshair.maptext = "<span style='color:#FF0000; font-size:22pt; font-weight:bold; text-align:center; -dm-text-outline: 2px black;'>+</span>"
				crosshair.maptext_width = 32
				crosshair.maptext_height = 32
				crosshair.maptext_y = -5
				crosshair.plane = ABOVE_LIGHTING_PLANE
				crosshair.layer = 105
				tile.overlays += crosshair

			for(var/atom/movable/AM in highest)
				if(AM.invisibility > 100 || ismob(AM) || istype(AM, /obj/effect) || istype(AM, /atom/movable/lighting_object))
					continue
				var/mutable_appearance/MA = new(AM.appearance)
				MA.plane = ABOVE_LIGHTING_PLANE
				MA.layer = 101
				tile.overlays += MA

	if(user.client)
		user.client.screen |= M.tiles
		winset(user, map_id, "icon-size=[radius == 15 ? 16 : 32]")

	return M

/obj/structure/artillery/proc/calculate_firing_solution(mob/user, target_x, target_y)
	var/dist_x = target_x - src.x
	var/dist_y = target_y - src.y
	
	var/new_azimuth = ATAN2(dist_y, dist_x)
	if(new_azimuth < 0)
		new_azimuth += 360
		
	var/new_range = sqrt(dist_x * dist_x + dist_y * dist_y)
	var/velocity = base_velocity + charge_level * charge_velocity_step
	if(velocity == 0) return null
	
	var/range_factor = (new_range * GRAVITY) / (velocity * velocity)
	if(range_factor > 1 || range_factor < -1)
		to_chat(user, span_warning("Эта точка вне зоны досягаемости при текущем заряде!"))
		return null
		
	var/theta1 = 0.5 * arcsin(range_factor)
	var/theta2 = 90 - theta1
	var/new_elevation = (abs(elevation - theta1) < abs(elevation - theta2)) ? theta1 : theta2
	
	if(new_elevation < elevation_min || new_elevation > elevation_max)
		to_chat(user, span_warning("Невозможно навести орудие под таким углом!"))
		return null
		
	return list("azimuth" = new_azimuth, "elevation" = new_elevation)

/obj/structure/artillery/proc/expert_aim_process(mob/user, list/experts, new_azimuth, new_elevation)
	var/list/prog_bars = list()
	for(var/mob/M in experts)
		if(QDELETED(M)) continue
		M.doing = TRUE
		prog_bars += new /datum/progressbar(M, 20 SECONDS, src)

	var/endtime = world.time + 20 SECONDS
	var/starttime = world.time
	var/success = TRUE

	while(world.time < endtime)
		stoplag(1)
		if(QDELETED(src))
			success = FALSE
			break
			
		var/list/current_experts = get_artillery_experts()
		for(var/mob/M in experts)
			if(QDELETED(M) || !(M in current_experts) || !M.doing)
				success = FALSE
				break
				
		if(!success)
			break
			
		for(var/datum/progressbar/pb in prog_bars)
			if(!QDELETED(pb)) pb.update(world.time - starttime)

	for(var/mob/M in experts)
		if(!QDELETED(M)) M.doing = FALSE
	for(var/datum/progressbar/pb in prog_bars)
		if(!QDELETED(pb)) qdel(pb)

	if(!success || QDELETED(src))
		if(user && !QDELETED(user))
			user.visible_message(span_warning("Наведение мортиры было прервано!"))
		return

	azimuth = new_azimuth
	elevation = new_elevation
	playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
	if(user && !QDELETED(user))
		user.visible_message(span_info("Команда экспертов перенастроила орудие на новые координаты."))

/obj/structure/artillery/ui_data(mob/user)
	var/list/data = list()
	data["elevation"] = elevation
	data["elevation_min"] = elevation_min
	data["elevation_max"] = elevation_max
	data["azimuth"] = azimuth
	data["charge_level"] = charge_level
	data["charge_max"] = charge_max

	var/list/experts = get_artillery_experts()
	data["can_expert_mode"] = (experts.len >= 2)
	
	if(experts.len < 2)
		expert_mode_active = FALSE

	if(expert_mode_active && experts.len >= 2)
		data["expert_mode"] = TRUE
		data["maxx"] = world.maxx
		data["maxy"] = world.maxy
		if(!ui_z_levels[user]) ui_z_levels[user] = src.z
		if(!ui_view_x[user]) ui_view_x[user] = src.x
		if(!ui_view_y[user]) ui_view_y[user] = src.y
		
		var/view_z = ui_z_levels[user]
		var/view_x = ui_view_x[user]
		var/view_y = ui_view_y[user]
		
		data["mapZLevel"] = view_z
		data["view_x"] = view_x
		data["view_y"] = view_y
		
		var/list/levels = list()
		for(var/i in 1 to world.maxz)
			levels += i
		data["map_levels"] = levels

		generate_map_screen(view_x, view_y, view_z, 15, user)
		data["map_ref"] = "expert_artmap"
	else
		data["expert_mode"] = FALSE

	data["range"] = "НЕИЗВЕСТНО"
	data["area_name"] = "НЕИЗВЕСТНО"

	var/vector/target = calculate_coordinates(user)
	if(target)
		var/turf/target_turf = locate(target.x, target.y, src.z)
		if(target_turf)
			var/velocity = base_velocity + charge_level * charge_velocity_step
			data["range"] = floor((velocity * velocity / GRAVITY) * sin(2 * elevation))
			data["area_name"] = target_turf.loc.name
			if(!data["expert_mode"])
				generate_map_screen(target_turf.x, target_turf.y, src.z, 6, user)
				data["map_ref"] = "normal_artmap"


	return data

/obj/structure/artillery/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("pan_map")
			var/dx = text2num(params["dx"])
			var/dy = text2num(params["dy"])
			if(dx) ui_view_x[ui.user] = clamp((ui_view_x[ui.user] || src.x) + dx, 1, world.maxx)
			if(dy) ui_view_y[ui.user] = clamp((ui_view_y[ui.user] || src.y) + dy, 1, world.maxy)
			return TRUE
		if("fire")
			if(charge_level == 0)
				to_chat(ui.user, span_warning("В стволе нету заряда."))
				return
			if(!ammo)
				to_chat(ui.user, span_warning("В стволе нету снаряда."))
				return
			if(HAS_TRAIT(ui.user, TRAIT_ARTILLERY_EXPERT))
				if(do_after(ui.user, 15, target = src))
					fire_artillery(ui.user)
			else
				if(tgui_alert(ui.user, "Вы не умеете пользоваться этой установкой. В данный момент вы полагаетесь исключительно на свои догадки и интеллект, при неправильном использовании вас могут ждать очень плохие последствия.", "Мортира", list("Я не буду стрелять", "ОГОНЬ!")) == "ОГОНЬ!")
					if(do_after(ui.user, 15, target = src))
						fire_artillery(ui.user)
		if("decrease_charge")
			if(do_after(ui.user, 10, target = src))
				charge_level = max(charge_level - 1, charge_min)
				playsound(src, 'modular_twilight_axis/awful_artillery/sound/removepowder.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
				ui.user.visible_message(span_info("[ui.user] извлекает лишний порох из [src]."))
		if("set_elevation")
			var/new_elevation_val = text2num(params["value"])
			if(isnull(new_elevation_val))
				return
			elevation = clamp(new_elevation_val, elevation_min, elevation_max)
			playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
			ui.user.visible_message(span_info("[ui.user] правит возвышение."))
		if("toggle_expert_mode")
			expert_mode_active = !expert_mode_active
			return TRUE
		if("target_center")
			if(expert_mode_active)
				expert_target_tile(ui.user, 0, 0)
			else
				target_tile(ui.user, 0, 0)
			return TRUE
		if("set_azimuth")
			var/new_azimuth_val = text2num(params["value"])
			if(isnull(new_azimuth_val))
				return
			azimuth = clamp(new_azimuth_val, 0, 359)
			playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
			ui.user.visible_message(span_info("[ui.user] правит азимут."))

		if("eject_ammo")
			if(!ammo)
				to_chat(ui.user, span_warning("В стволе нет снаряда."))
				return
			if(do_after(ui.user, 20, target = src))
				if(!ammo)
					return
				playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
				ammo.forceMove(loc)
				ammo = null
				ui.user.visible_message(span_info("[ui.user] извлекает боеприпас из [src]."))
		if("disasseble")
			if(do_after(ui.user, 20, target = src))
				playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
				var/list/parts = get_parts()
				for(var/path in parts)
					new path(loc)
				ui.user.visible_message(span_info("[ui.user] разобрал [src]."))
				ui.close()
				qdel(src)
				return

	SStgui.try_update_ui(ui.user, src)

/obj/item/artillery_assembly
	name = "Лафет"
	w_class = WEIGHT_CLASS_HUGE


#undef GRAVITY
#undef BASE_AZIMUTH_ERROR
#undef OVERHEAT_ERROR



/obj/structure/artillery/proc/get_highest_turf(turf/T)
	if(!T)
		return null
	var/turf/current = T
	var/turf/above = GET_TURF_ABOVE(current)
	while(above)
		current = above
		above = GET_TURF_ABOVE(current)

	var/turf/below = GET_TURF_BELOW(current)
	while(below && istype(current, /turf/open/transparent))
		current = below
		below = GET_TURF_BELOW(current)

	return current

/obj/structure/artillery/proc/get_artillery_experts()
	var/list/experts = list()
	for(var/mob/living/carbon/human/H in range(1, src))
		if(HAS_TRAIT(H, TRAIT_ARTILLERY_EXPERT))
			experts += H
	return experts

/obj/structure/artillery/proc/target_tile(mob/user, num_dx, num_dy)
	var/vector/current_target = calculate_coordinates(user)
	if(!current_target)
		return

	var/list/solution = calculate_firing_solution(user, current_target.x + num_dx, current_target.y + num_dy)
	if(!solution)
		return

	to_chat(user, span_notice("Начинаю перенастраивать орудие..."))
	if(do_after(user, 10 SECONDS, target = src))
		azimuth = solution["azimuth"]
		elevation = solution["elevation"]
		playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
		if(user) user.visible_message(span_info("[user] перенастроил орудие на новые координаты."))

/obj/structure/artillery/proc/expert_target_tile(mob/user, num_dx, num_dy)
	var/view_x = ui_view_x[user] || src.x
	var/view_y = ui_view_y[user] || src.y
	var/target_x = view_x + num_dx
	var/target_y = view_y + num_dy

	var/list/experts = get_artillery_experts()
	if(experts.len < 2)
		to_chat(user, span_warning("Недостаточно экспертов рядом для такого сложного расчета!"))
		return

	var/list/solution = calculate_firing_solution(user, target_x, target_y)
	if(!solution)
		return

	to_chat(user, span_notice("Начинаем сложный расчет и перенастройку..."))
	INVOKE_ASYNC(src, PROC_REF(expert_aim_process), user, experts, solution["azimuth"], solution["elevation"])
