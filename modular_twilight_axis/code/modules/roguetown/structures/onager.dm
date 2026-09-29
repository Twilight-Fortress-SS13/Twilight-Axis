
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

	var/direct_limb_damage = 24
	var/direct_nonhuman_damage = 260
	var/direct_wound_rolls_min = 2
	var/direct_wound_rolls_max = 3
	var/direct_armor_wear = 0.30

	var/kinetic_radius = 4
	var/kinetic_limb_damage_close = 22
	var/kinetic_limb_damage_mid = 18
	var/kinetic_limb_damage_far = 14
	var/kinetic_limb_damage_edge = 10
	var/kinetic_limbs_close = 3
	var/kinetic_limbs_mid = 3
	var/kinetic_limbs_far = 2
	var/kinetic_limbs_edge = 2
	var/kinetic_armor_wear_close = 0.15
	var/kinetic_armor_wear_mid = 0.10
	var/kinetic_armor_wear_far = 0.07
	var/kinetic_armor_wear_edge = 0.04
	var/kinetic_max_armor_block = 80

	var/structure_damage_radius = 3
	var/structure_damage_direct = 1600
	var/structure_damage_close = 1000
	var/structure_damage_far = 800
	var/structure_damage_edge = 450

	var/devastation_range = 0
	var/heavy_impact_range = 2
	var/light_impact_range = 6

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
	if(!T)
		qdel(src)
		return

	playsound(T, 'modular_twilight_axis/sound/catapult/explosion_distant2.ogg', 100, TRUE)

	apply_direct_impact(T)
	apply_kinetic_splash(T)
	apply_structure_impact(T)

	explosion(T, devastation_range, heavy_impact_range, light_impact_range, smoke = TRUE)

	if(isopenturf(T) && prob(60))
		T.ChangeTurf(/turf/open/transparent/openspace)
		var/turf/below = get_step_multiz(T, DOWN)
		if(below)
			explosion(below, 0, 2, 3, smoke = TRUE)

	create_shrapnel(T)

	for(var/mob/living/L in range(6, T))
		if(!L.stat)
			shake_camera(L, 3, 1)

	qdel(src)

/obj/item/boulder/proc/apply_direct_impact(turf/T)
	for(var/mob/living/L in T)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.visible_message(span_danger("[H] is crushed by the falling boulder!"))

			for(var/obj/item/bodypart/BP in H.bodyparts)
				var/armor = H.run_armor_check(BP.body_zone, "blunt", "", "", armor_penetration = PEN_NONE, damage = direct_limb_damage, used_weapon = src)
				H.apply_damage(direct_limb_damage, BRUTE, BP.body_zone, armor)

			damage_worn_armor(H, direct_armor_wear)
			apply_direct_blunt_wounds(H)
		else
			L.adjustBruteLoss(direct_nonhuman_damage)

		L.Knockdown(5 SECONDS)
		L.Paralyze(1 SECONDS)

/obj/item/boulder/proc/apply_direct_blunt_wounds(mob/living/carbon/human/H)
	var/list/candidates = list()
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone == BODY_ZONE_HEAD || BP.body_zone == BODY_ZONE_CHEST)
			continue
		candidates += BP

	var/wound_rolls = min(length(candidates), rand(direct_wound_rolls_min, direct_wound_rolls_max))
	if(wound_rolls <= 0)
		return
	for(var/i in 1 to wound_rolls)
		if(!length(candidates))
			break
		var/obj/item/bodypart/BP = pick(candidates)
		candidates -= BP

		if(prob(65))
			BP.add_wound(/datum/wound/fracture, FALSE, TRUE)
		else
			BP.add_wound(/datum/wound/dislocation, FALSE, TRUE)

		if(prob(20))
			BP.add_wound(/datum/wound/artery, FALSE, TRUE)

/obj/item/boulder/proc/apply_kinetic_splash(turf/epicenter)
	for(var/mob/living/L in range(kinetic_radius, epicenter))
		var/distance = get_dist(epicenter, L)
		if(distance <= 0 || distance > kinetic_radius)
			continue

		var/limbs_to_hit
		var/limb_damage
		var/armor_wear
		var/nonhuman_damage

		switch(distance)
			if(1)
				limbs_to_hit = kinetic_limbs_close
				limb_damage = kinetic_limb_damage_close
				armor_wear = kinetic_armor_wear_close
				nonhuman_damage = 80
			if(2)
				limbs_to_hit = kinetic_limbs_mid
				limb_damage = kinetic_limb_damage_mid
				armor_wear = kinetic_armor_wear_mid
				nonhuman_damage = 60
			if(3)
				limbs_to_hit = kinetic_limbs_far
				limb_damage = kinetic_limb_damage_far
				armor_wear = kinetic_armor_wear_far
				nonhuman_damage = 40
			if(4)
				limbs_to_hit = kinetic_limbs_edge
				limb_damage = kinetic_limb_damage_edge
				armor_wear = kinetic_armor_wear_edge
				nonhuman_damage = 25

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/available_parts = H.bodyparts.Copy()

			limbs_to_hit = min(limbs_to_hit, length(available_parts))
			for(var/i in 1 to limbs_to_hit)
				if(!length(available_parts))
					break
				var/obj/item/bodypart/BP = pick(available_parts)
				available_parts -= BP
				var/armor = H.run_armor_check(BP.body_zone, "blunt", "", "", armor_penetration = PEN_NONE, damage = limb_damage, used_weapon = src)
				armor = min(armor, kinetic_max_armor_block)
				H.apply_damage(limb_damage, BRUTE, BP.body_zone, armor)

				if(distance == 1 && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST && prob(15))
					if(prob(60))
						BP.add_wound(/datum/wound/fracture, FALSE, TRUE)
					else
						BP.add_wound(/datum/wound/dislocation, FALSE, TRUE)

			damage_worn_armor(H, armor_wear)
		else
			L.adjustBruteLoss(nonhuman_damage)

		if(distance == 1)
			L.Knockdown(2 SECONDS)
			L.OffBalance(2 SECONDS)
		else if(distance == 2)
			L.Knockdown(1 SECONDS)
		else if(distance == 3)
			L.OffBalance(1 SECONDS)

/obj/item/boulder/proc/damage_worn_armor(mob/living/carbon/human/H, integrity_ratio)
	if(!H || integrity_ratio <= 0)
		return

	var/list/worn_items = list(
		H.head,
		H.wear_mask,
		H.wear_wrists,
		H.wear_shirt,
		H.wear_neck,
		H.wear_armor,
		H.wear_pants,
		H.gloves,
		H.shoes,
		H.belt,
		H.glasses
	)

	var/list/damaged = list()
	for(var/obj/item/clothing/C in worn_items)
		if(!C || (C in damaged) || C.max_integrity <= 0 || C.obj_integrity <= 0)
			continue
		damaged += C
		var/integrity_damage = max(1, round(C.max_integrity * integrity_ratio))
		C.take_damage(damage_amount = integrity_damage, damage_type = BRUTE, damage_flag = "blunt")

/obj/item/boulder/proc/get_structure_impact_damage(distance)
	if(distance <= 0)
		return structure_damage_direct
	if(distance == 1)
		return structure_damage_close
	if(distance == 2)
		return structure_damage_far
	return structure_damage_edge

/obj/item/boulder/proc/apply_structure_impact(turf/epicenter)
	for(var/turf/affected_turf in range(structure_damage_radius, epicenter))
		var/distance = get_dist(epicenter, affected_turf)
		if(distance > structure_damage_radius)
			continue

		var/impact_damage = get_structure_impact_damage(distance)

		for(var/obj/structure/S in affected_turf)
			if(S == src || istype(S, /obj/structure/flora/newbranch))
				continue
			S.take_damage(impact_damage, BRUTE, "blunt", 1)

		for(var/obj/machinery/M in affected_turf)
			M.take_damage(impact_damage, BRUTE, "blunt", 1)

		if(istype(affected_turf, /turf/closed/wall))
			var/turf/closed/wall/W = affected_turf
			W.take_damage(impact_damage, BRUTE, "blunt", 1)
		else if(istype(affected_turf, /turf/closed/mineral))
			var/turf/closed/mineral/M = affected_turf
			M.take_damage(impact_damage, BRUTE, "blunt", 1)

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
