/datum/special_intent/range_special
	abstract_type = /datum/special_intent/range_special
	use_clickloc = TRUE
	respect_adjacency = FALSE
	custom_skill = /datum/skill/combat/bows
	tile_coordinates = list()
	delay = 0
	var/atom/actual_target 
	var/stored_params
	
	var/tmp/target_z
	var/tmp/turf/target_level_turf
	var/tmp/atom/final_target
	var/tmp/is_arc_mode = FALSE


/datum/special_intent/range_special/check_range(atom/source, atom/target)
	var/turf/T1 = get_turf(source)
	var/turf/T2 = get_turf(target)
	if(!T1 || !T2) return FALSE
	if(get_dist(T1, T2) > range)
		to_chat(source, span_warning("Слишком далеко!"))
		return FALSE
	return TRUE

/datum/special_intent/range_special/deploy(mob/living/user, atom/parent, atom/target, params)
	actual_target = target
	stored_params = params
	return ..()

/datum/special_intent/range_special/proc/prepare_shot_data()
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent
	var/mob/living/L = howner
	if(!istype(B) || !L) return FALSE

	target_z = L.z
	if(L.client && L.client.eye)
		var/turf/eye_turf = get_turf(L.client.eye)
		if(eye_turf) target_z = eye_turf.z

	var/turf/click_turf = get_turf(actual_target ? actual_target : click_loc)
	target_level_turf = locate(click_turf.x, click_turf.y, target_z)
	if(!target_level_turf) return FALSE

	final_target = actual_target
	var/turf/final_targ_turf = get_turf(final_target)
	if(!final_target || (final_targ_turf && final_targ_turf.z != target_z))
		final_target = target_level_turf

	is_arc_mode = FALSE
	var/list/intents_list = B.possible_item_intents
	var/idx = B.saved_intent_index
	if(intents_list && idx > 0 && idx <= length(intents_list))
		if(ispath(intents_list[idx], /datum/intent/arc))
			is_arc_mode = TRUE
	return TRUE

/datum/special_intent/range_special/proc/setup_projectile(obj/projectile/proj, proj_range)
	if(!istype(proj))
		return
	
	var/final_range = proj_range ? proj_range : src.range
	
	proj.range = final_range
	proj.max_range = final_range
	proj.decayedRange = final_range
	proj.original = final_target

	if(is_arc_mode && target_level_turf)
		proj.xo = target_level_turf.x - howner.x
		proj.yo = target_level_turf.y - howner.y
	else
		proj.xo = 0
		proj.yo = 0

/datum/special_intent/range_special/proc/perform_archery_shot()
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent
	var/mob/living/L = howner
	
	var/old_charge = L.client ? L.client.chargedprog : 0
	if(L.client) L.client.chargedprog = 100 
	
	var/old_npc_arc = B.npc_force_arc
	B.npc_force_arc = is_arc_mode

	if(is_arc_mode)
		B.process_fire(final_target, L, TRUE, null)
	else
		B.process_fire(final_target, L, TRUE, stored_params)

	if(L.client) L.client.chargedprog = old_charge
	B.npc_force_arc = old_npc_arc




/datum/special_intent/range_special/bow_doubleshot
	name = "Двойной выстрел"
	desc = "Моментально выпускает вторую стрелу из колчана вслед за первой."
	range = 14
	use_doafter = 1 SECONDS
	stamcost = 25
	cooldown = 15 SECONDS

/datum/special_intent/range_special/bow_doubleshot/on_create()
	if(!prepare_shot_data()) return
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent

	setup_projectile(B.chambered?.BB) 
	
	perform_archery_shot()
	addtimer(CALLBACK(src, PROC_REF(fire_second_arrow)), 2)
	apply_cooldown(cooldown)

/datum/special_intent/range_special/bow_doubleshot/proc/fire_second_arrow()
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent
	if(!howner || howner.stat || !B || B.loc != howner) return

	var/obj/item/ammo_casing/caseless/rogue/found_arrow
	for(var/obj/item/quiver/Q in howner.contents)
		if(length(Q.arrows))
			found_arrow = Q.pick_ammo(/obj/item/ammo_casing/caseless/rogue/arrow)
			if(found_arrow)
				Q.arrows -= found_arrow
				Q.update_icon()
				break
	if(!found_arrow) return

	B.chambered = found_arrow
	found_arrow.forceMove(B)

	setup_projectile(B.chambered.BB)
	perform_archery_shot()

/datum/special_intent/range_special/bow_longshot
	name = "Дальнобойный выстрел"
	desc = "Тщательное прицеливание. Чем дальше цель, тем больше урон."
	range = 25 
	use_doafter = 1.5 SECONDS
	stamcost = 30
	cooldown = 20 SECONDS

/datum/special_intent/range_special/bow_longshot/on_create()
	if(!prepare_shot_data()) return
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent

	setup_projectile(B.chambered?.BB)

	var/dist_val = get_dist(howner, final_target)
	B.damfactor *= (1.0 + (min(dist_val, 25) * 0.12))
	perform_archery_shot()
	B.damfactor = initial(B.damfactor)
	apply_cooldown(cooldown)

/datum/special_intent/range_special/bow_backstep
	name = "Выстрел с отскоком"
	desc = "Выстрел с одновременным прыжком назад и кратковременным бонусом к скорости."
	range = 14
	use_doafter = 0.5 SECONDS 
	stamcost = 20
	cooldown = 10 SECONDS

/datum/special_intent/range_special/bow_backstep/on_create()
	if(!prepare_shot_data()) return
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = iparent
	
	setup_projectile(B.chambered?.BB)
	
	perform_archery_shot()

	var/turf/back_turf = get_ranged_target_turf(howner, turn(howner.dir, 180), 2)
	if(back_turf)
		howner.jump_action(back_turf)

	howner.apply_status_effect(/datum/status_effect/buff/archer_haste)
	apply_cooldown(cooldown)

/datum/status_effect/buff/archer_haste
	id = "archer_haste"
	duration = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/archer_haste
	effectedstats = list(STATKEY_SPD = 10)

/atom/movable/screen/alert/status_effect/archer_haste
	name = "Легкость ветра"
	desc = "Мои движения стали быстрее после ловкого отскока."
	icon_state = "buff"
