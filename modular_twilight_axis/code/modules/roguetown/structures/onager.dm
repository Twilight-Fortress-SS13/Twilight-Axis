
/obj/structure/onager
	name = "Onager"
	desc = "A torsion-powered siege engine designed to throw massive projectiles."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/oneger/onager.dmi' 
	icon_state = "idle"

	anchored = TRUE
	density = TRUE
	max_integrity = 500
	layer = OBJ_LAYER
	
	armor = list("blunt" = 20, "slash" = 50, "stab" = 50, "piercing" = 50, "fire" = -20, "acid" = 0, "magic" = 0)

	var/min_target_distance = 5
	var/max_target_distance = 40
	var/target_distance = 15

	var/list/interactions = list("Fire!", "Set Direction", "Set Target Distance", "Pack Up")
	var/list/directions = list("NORTH", "SOUTH", "EAST", "WEST")
	
	var/list/launch_sounds = list('modular_twilight_axis/sound/catapult/launch.ogg','modular_twilight_axis/sound/catapult/launch2.ogg','modular_twilight_axis/sound/catapult/launch3.ogg') 
	var/list/aim_sounds = list('modular_twilight_axis/sound/catapult/aim.ogg','modular_twilight_axis/sound/catapult/aim2.ogg',)


	var/idle = TRUE
	var/ready = FALSE
	var/loaded = FALSE
	var/launched = FALSE
	var/packed = FALSE
	var/being_used = FALSE

/obj/structure/onager/Initialize()
	. = ..()
	if(islist(armor))
		armor = getArmor(arglist(armor))
	update_icon()



/obj/structure/onager/proc/reset_state()
	idle = FALSE
	ready = FALSE
	loaded = FALSE
	launched = FALSE
	packed = FALSE

/obj/structure/onager/proc/set_idle()
	reset_state()
	anchored = TRUE
	idle = TRUE
	update_icon()

/obj/structure/onager/proc/set_ready()
	reset_state()
	ready = TRUE
	update_icon()

/obj/structure/onager/proc/set_loaded()
	reset_state()
	ready = TRUE
	loaded = TRUE
	update_icon()

/obj/structure/onager/proc/set_launched()
	reset_state()
	launched = TRUE
	update_icon()

/obj/structure/onager/proc/set_packed()
	reset_state()
	anchored = FALSE
	packed = TRUE
	update_icon()


/obj/structure/onager/update_icon()
	cut_overlays() 
	
	if(packed)
		icon_state = "idle" 
		
		add_filter("packed_grey", 1, list("type" = "greyscale"))
		return
	else
		remove_filter("packed_grey")

	if(launched)
		icon_state = "launched"
		return

	icon_state = "idle"

	if(loaded)
		
		var/mutable_appearance/rock = mutable_appearance(icon, "boulder_overlay")
		rock.layer = HIGH_OBJ_LAYER
		add_overlay(rock)




/obj/structure/onager/AltClick(mob/user)
	if(!user.canUseTopic(src, be_close=TRUE))
		return
	if(packed)
		unpack(user)
		return TRUE 
	return ..()

// Распаковка через перетягивание (MouseDrop)
/obj/structure/onager/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr && Adjacent(usr) && in_range(src, usr))
		if(packed && ishuman(usr))
			unpack(usr)
			return
	return ..()

/obj/structure/onager/attack_hand(mob/living/carbon/user)
	
	if(packed)
		if(user.a_intent == INTENT_HELP) 
			to_chat(user, span_warning("The onager is packed. <b>Click again</b> or <b>Alt-click</b> to unpack."))
			
			unpack(user)
		else
			unpack(user)
		return 

	if(being_used)
		to_chat(user, span_warning("Someone else is using it."))
		return 
	
	
	ui_interact(user)

/obj/structure/onager/ui_interact(mob/user, datum/tgui/ui)
	
	if(packed)
		to_chat(user, span_warning("It is packed and secured. Unpack it first."))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Onager", "Onager Siege Engine")
		ui.open()

/obj/structure/onager/ui_data(mob/user)
	var/list/data = list()
	
	data["ready"] = ready
	data["loaded"] = loaded
	data["launched"] = launched
	data["firing"] = (launched && !ready && !loaded)
	
	data["direction"] = dir2text(dir)
	data["target_distance"] = target_distance
	data["min_distance"] = min_target_distance
	data["max_distance"] = max_target_distance
	
	data["integrity"] = obj_integrity
	data["max_integrity"] = max_integrity

	return data

/obj/structure/onager/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("fire")
			try_fire(ui.user)
			return TRUE
		
		if("crank")
			if(!ready && !being_used)
				ready(ui.user)
			return TRUE
		
		if("set_dir")
			var/new_dir_text = params["dir"]
			var/new_dir = text2dir(new_dir_text)
			if(new_dir && new_dir != dir)
				if(!being_used)
					being_used = TRUE
					playsound(src, pick(aim_sounds), 50, TRUE)
					if(do_after(ui.user, 10, target = src))
						dir = new_dir
					being_used = FALSE
			return TRUE
		
		if("set_distance")
			var/new_dist = params["dist"]
			if(isnum(new_dist))
				target_distance = clamp(round(new_dist), min_target_distance, max_target_distance)
			return TRUE
			
		if("pack")
			pack(ui.user)
			ui.close()
			return TRUE

/obj/structure/onager/attackby(obj/item/I, mob/living/carbon/user)
	if(istype(I, /obj/item/rogueweapon/hammer))
		if(obj_integrity < max_integrity)
			I.play_tool_sound(src)
			user.visible_message(span_notice("[user] repairs [src]."), span_notice("You repair [src]."))
			obj_integrity = min(obj_integrity + 50, max_integrity)
			if(obj_integrity >= max_integrity)
				obj_broken = FALSE 
			return
	
	if(packed)
		to_chat(user, span_warning("Unpack it first!"))
		return

	if(istype(I, /obj/item/boulder))
		if(!ready)
			to_chat(user, span_warning("The mechanism is slack! You need to crank it first."))
			ui_interact(user) 
			return
		
		if(loaded)
			to_chat(user, span_warning("It's already loaded."))
			return

		try_load(I, user)
		return

	return ..()



/obj/structure/onager/proc/ready(mob/user)
	user.visible_message(span_notice("[user] cranks the arm back."))
	playsound(src, pick(aim_sounds), 50, TRUE)
	if(do_after(user, 30, target = src))
		set_ready()
		user.visible_message(span_notice("The onager is ready."))

/obj/structure/onager/proc/try_fire(mob/user)
	if(is_obstructed())
		to_chat(user, span_warning("Obstructed from above!"))
		return 
	if(!loaded)
		to_chat(user, span_warning("Not loaded."))
		return
	if(target_distance <= 0)
		to_chat(user, span_warning("Aim it first."))
		return
	fire(user)

/obj/structure/onager/proc/fire(mob/user)
	var/turf/target = get_ranged_target_turf(src, dir, target_distance)
	if(!target) return

	
	var/flight_height = get_free_z_height(src)

	playsound(src, pick(launch_sounds), 60, TRUE)
	set_launched() 
	
	var/obj/item/boulder/P = new /obj/item/boulder(get_turf(src))
	

	P.launch_artillery(target, target_distance, flight_height)

/obj/structure/onager/proc/is_obstructed()
	var/turf/T = get_turf(src)
	var/turf/above = get_step_multiz(T, UP)
	if(above && above.density) return TRUE 
	return FALSE

/obj/structure/onager/proc/try_load(obj/item/I, mob/living/carbon/user)
	if(istype(I, /obj/item/boulder))
		if(!user.dropItemToGround(I)) return
		qdel(I) 
		user.visible_message(span_notice("[user] loads [I]."))
		playsound(src, 'modular_twilight_axis/sound/catapult/adjusting.ogg', 70, TRUE) 
		set_loaded()
	else
		to_chat(user, span_warning("You need a boulder."))


/obj/structure/onager/proc/pack(mob/user)
	being_used = TRUE
	user.visible_message(span_notice("[user] starts packing the onager..."))
	playsound(src, 'modular_twilight_axis/sound/catapult/adjusting.ogg', 70, TRUE) 
	if(do_after(user, 50, target = src))
		set_packed()
		user.visible_message(span_notice("[user] packs the onager."))
	being_used = FALSE

/obj/structure/onager/proc/unpack(mob/user)
	if(being_used) return
	being_used = TRUE
	user.visible_message(span_notice("[user] starts unpacking..."))
	playsound(src, 'modular_twilight_axis/sound/catapult/adjusting.ogg', 70, TRUE) 
	if(do_after(user, 50, target = src))
		set_idle()
		user.visible_message(span_notice("[user] unpacks the onager."))
	being_used = FALSE




/obj/item/boulder
	name = "boulder"
	desc = "A massive rock."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/oneger/boulder_item.dmi'
	icon_state = "boulder_item" 
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 50
	var/stored_flight_height = 0

/obj/item/boulder/proc/launch_artillery(turf/target, distance, flight_height)
	src.stored_flight_height = flight_height 
	
	var/obj/effect/temp_visual/onager_fly/fly = new(get_turf(src))
	fly.do_launch_anim()

	anchored = TRUE
	moveToNullspace() 

	var/flight_time = 20 + (distance * 2)
	addtimer(CALLBACK(src, PROC_REF(begin_impact), target), flight_time)

/obj/item/boulder/proc/begin_impact(turf/target_turf)
	if(!target_turf)
		qdel(src)
		return

	
	var/turf/start_impact_turf = target_turf
	for(var/i in 1 to stored_flight_height)
		var/turf/above = get_step_multiz(start_impact_turf, UP)
		if(above)
			start_impact_turf = above
		else
			break

	
	var/turf/final_T = start_impact_turf
	var/turf/below = get_step_multiz(final_T, DOWN)
	while(below && istransparentturf(final_T)) 
		final_T = below
		below = get_step_multiz(final_T, DOWN)

	forceMove(final_T)
	invisibility = 0
	
	playsound(final_T, 'modular_twilight_axis/sound/catapult/incoming3.ogg', 100, FALSE)
	
	pixel_z = 600
	animate(src, pixel_z = 0, time = 8, easing = EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(impact)), 8)


/obj/item/boulder/proc/impact()
	var/turf/T = get_turf(src)
	
	playsound(T, 'modular_twilight_axis/sound/catapult/explosion_distant2.ogg', 100, TRUE) 

	if(istype(T, /turf/closed)) 
		explosion(T, 1, 2, 4) 
	else 
		explosion(T, 0, 2, 4, smoke = TRUE)
		
		if(isopenturf(T) && prob(50))
			T.ChangeTurf(/turf/open/transparent/openspace)
			var/turf/below = get_step_multiz(T, DOWN)
			if(below)
				explosion(below, 0, 1, 2)

	create_shrapnel(T)
	
	for(var/mob/living/L in range(6, T))
		if(!L.stat)
			shake_camera(L, 3, 1)
			L.Knockdown(20)
	
	qdel(src)


/obj/item/boulder/proc/create_shrapnel(turf/T)
	for(var/i in 1 to 6) 
		var/obj/projectile/rock_shard/S = new(T)
		var/turf/target = locate(T.x + rand(-3,3), T.y + rand(-3,3), T.z)
		if(target)
			S.preparePixelProjectile(target, T)
			S.fire()


/obj/effect/temp_visual/onager_fly
	name = "boulder"
	
	icon = 'modular_twilight_axis/icons/obj/structures/siege/oneger/onager.dmi' 
	
	icon_state = "boulder" 
	
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	duration = 15

/obj/effect/temp_visual/onager_fly/proc/do_launch_anim()
	
	
	pixel_z = 0
	
	
	animate(src, pixel_z = 600, alpha = 0, time = 10, easing = EASE_IN)

/obj/projectile/rock_shard
    name = "rock shard"
    icon_state = "bullet" 
    damage = 15
    range = 5
    flag = "piercing" 
    damage_type = BRUTE
    speed = 2

/proc/get_free_z_height(atom/origin)
	var/height = 0
	var/turf/current_turf = get_turf(origin)
	
	
	while(current_turf)
		var/turf/above = get_step_multiz(current_turf, UP)
		if(!above || above.density)
			break
		current_turf = above
		height++
	
	return height
