#define GRAVITY 9.81
#define BASE_AZIMUTH_ERROR 16
#define OVERHEAT_ERROR 50

#define ARTILLERY_DEV_RANGE 4
#define ARTILLERY_HEAVY_RANGE 10
#define ARTILLERY_LIGHT_RANGE 20

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
	
	var/user_stat = user.get_stat(associated_stat)
	var/user_skill = user.get_skill_level(associated_skill)

	var/velocity = base_velocity + charge_level * charge_velocity_step
	var/range = (velocity * velocity / GRAVITY) * sin(2 * elevation)

	var/overall_artillery_skill = user_skill + (user_stat - 10) / 2

	var/target_azimuth = azimuth
	
	if(!HAS_TRAIT(user, TRAIT_ARTILLERY_EXPERT))
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

	var/target_x = round(loc.x + dx, 1)
	var/target_y = round(loc.y + dy, 1)

	var/vector/target = vector(target_x, target_y)

	return target

/obj/structure/artillery/proc/fire_artillery(mob/user)
	if(!ishuman(user))
		return
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

/obj/structure/artillery/proc/generate_map_grid(view_x, view_y, view_z, radius)
	var/list/map_data = list()
	for(var/dy in radius to -radius step -1)
		var/list/row = list()
		for(var/dx in -radius to radius)
			var/turf/tile = locate(view_x + dx, view_y + dy, view_z)
			var/list/tile_icons = list()
			if(tile)
				var/turf/highest = get_highest_turf(tile)
				if(highest)
					var/b64_turf = get_artillery_bicon(highest)
					if(b64_turf)
						tile_icons += b64_turf
					for(var/obj/structure/S in highest)
						var/b64_s = get_artillery_bicon(S)
						if(b64_s)
							tile_icons += b64_s
			row += list(tile_icons)
		map_data += list(row)
	return map_data

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
	if(experts.len >= 2)
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

		var/list/cache = cached_expert_maps[user]
		if(!cache || cache["x"] != view_x || cache["y"] != view_y || cache["z"] != view_z)
			cache = list("data" = generate_map_grid(view_x, view_y, view_z, 15), "x" = view_x, "y" = view_y, "z" = view_z)
			cached_expert_maps[user] = cache
		data["expert_map_data"] = cache["data"]
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
			data["map_data"] = generate_map_grid(target_turf.x, target_turf.y, src.z, 6)


	return data

/obj/structure/artillery/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("setZLevel")
			var/new_z = text2num(params["mapZLevel"])
			if(!new_z)
				return
			ui_z_levels[ui.user] = new_z
			cached_expert_maps[ui.user] = null
			return TRUE
		if("pan_map")
			var/dx = text2num(params["dx"])
			var/dy = text2num(params["dy"])
			if(dx) ui_view_x[ui.user] = clamp((ui_view_x[ui.user] || src.x) + dx, 1, world.maxx)
			if(dy) ui_view_y[ui.user] = clamp((ui_view_y[ui.user] || src.y) + dy, 1, world.maxy)
			cached_expert_maps[ui.user] = null
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
		if("set_azimuth")
			var/new_azimuth_val = text2num(params["value"])
			if(isnull(new_azimuth_val))
				return
			azimuth = clamp(new_azimuth_val, 0, 359)
			playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
			ui.user.visible_message(span_info("[ui.user] правит азимут."))
		if("set_target_tile")
			var/num_dx = text2num(params["dx"])
			var/num_dy = text2num(params["dy"])
			if(isnull(num_dx) || isnull(num_dy))
				return
				
			var/vector/current_target = calculate_coordinates(ui.user)
			if(!current_target)
				return
			
			var/list/solution = calculate_firing_solution(ui.user, current_target.x + num_dx, current_target.y + num_dy)
			if(!solution)
				return
				
			to_chat(ui.user, span_notice("Начинаю перенастраивать орудие..."))
			if(do_after(ui.user, 10 SECONDS, target = src))
				azimuth = solution["azimuth"]
				elevation = solution["elevation"]
				playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, 1, 1, 1, null, null, FALSE, FALSE)
				if(ui.user) ui.user.visible_message(span_info("[ui.user] перенастроил орудие на новые координаты."))
		if("set_expert_target_tile")
			var/num_dx = text2num(params["dx"])
			var/num_dy = text2num(params["dy"])
			if(isnull(num_dx) || isnull(num_dy))
				return
				
			var/target_z = ui_z_levels[ui.user] || src.z
			var/view_x = ui_view_x[ui.user] || src.x
			var/view_y = ui_view_y[ui.user] || src.y
			var/target_x = view_x + num_dx
			var/target_y = view_y + num_dy
			
			if(target_z != src.z)
				to_chat(ui.user, span_warning("Вы не можете навести мортиру на другой Z-уровень! Сначала переключитесь на уровень мортиры."))
				return
				
			var/list/experts = get_artillery_experts()
			if(experts.len < 2)
				to_chat(ui.user, span_warning("Недостаточно экспертов рядом для такого сложного расчета!"))
				return
				
			var/list/solution = calculate_firing_solution(ui.user, target_x, target_y)
			if(!solution)
				return
				
			to_chat(ui.user, span_notice("Начинаем сложный расчет и перенастройку..."))
			INVOKE_ASYNC(src, PROC_REF(expert_aim_process), ui.user, experts, solution["azimuth"], solution["elevation"])
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

GLOBAL_LIST_EMPTY(artillery_bicon_cache)

/proc/get_artillery_bicon(atom/A)
	if(!A || !A.icon || !A.icon_state)
		return ""
	var/key = "[istype(A.icon, /icon) ? "[REF(A.icon)]" : A.icon]:[A.icon_state]"
	if(!GLOB.artillery_bicon_cache[key])
		var/icon/target_icon = icon(A.icon, A.icon_state, SOUTH, 1)
		if(target_icon)
			GLOB.artillery_bicon_cache[key] = icon2base64(target_icon)
	return GLOB.artillery_bicon_cache[key]

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
