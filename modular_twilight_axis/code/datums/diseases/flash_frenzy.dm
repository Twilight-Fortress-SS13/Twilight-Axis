// THE FLASH-FRENZY DISEASE - Periodic rage episodes

/datum/disease/flash_frenzy
	name = "The Flash-Frenzy"
	desc = "A violent malaise that triggers sudden bouts of rage."
	max_stages = 1
	stage_prob = 0
	spread_flags = DISEASE_SPREAD_CONTACT_FLUIDS | DISEASE_SPREAD_CONTACT_SKIN
	disease_flags = CAN_CARRY | CAN_RESIST
	severity = DISEASE_SEVERITY_HARMFUL
	viable_mobtypes = list(/mob/living)
	var/infected_time = 0
	var/sleep_start_time = 0
	var/frenzy_timer = null
	var/frenzy_exit_timer = null
	var/restore_cmode = FALSE
	var/last_frenzy_attack = 0

/datum/disease/flash_frenzy/after_add()
	. = ..()
	infected_time = world.time
	schedule_frenzy()

/datum/disease/flash_frenzy/stage_act(delta_time, times_fired)
	if(!affected_mob || QDELETED(src))
		return ..()
	var/mob/living/L = affected_mob
	if(L.IsSleeping() && L.reagents?.has_reagent(/datum/reagent/medicine/flash_frenzy_sedative))
		if(!sleep_start_time)
			sleep_start_time = world.time
		else if(world.time - sleep_start_time >= 40 SECONDS)
			cure()
			return ..()
	else
		sleep_start_time = 0
	return ..()

/datum/disease/flash_frenzy/proc/schedule_frenzy()
	if(frenzy_timer)
		return
	frenzy_timer = addtimer(CALLBACK(src, PROC_REF(frenzy_tick)), rand(30, 70) SECONDS, TIMER_STOPPABLE)

/datum/disease/flash_frenzy/proc/frenzy_tick()
	frenzy_timer = null
	if(QDELETED(src) || !affected_mob)
		return
	if(!iscarbon(affected_mob))
		schedule_frenzy()
		return
	var/mob/living/carbon/C = affected_mob
	if(C.IsSleeping() || !C.can_frenzy_move())
		schedule_frenzy()
		return
	C.enter_frenzymod()
	ADD_TRAIT(C, TRAIT_FLASH_FRENZY_CONTROL_LOSS, "flash_frenzy_disease")
	// Stop any ongoing attack and reset intents to prevent errors
	if(C.client)
		C.stop_attack(FALSE)
		C.client.charging = 0
		C.client.chargedprog = 0
	playsound(get_turf(C), pick('sound/vo/male/gen/agony (11).ogg', 'sound/vo/male/gen/agony (13).ogg', 'sound/vo/male/gen/agony (4).ogg'), 80, FALSE)
	restore_cmode = FALSE
	if(!C.cmode)
		C.toggle_cmode()
		restore_cmode = TRUE
	frenzy_loop()
	if(frenzy_exit_timer)
		deltimer(frenzy_exit_timer)
	frenzy_exit_timer = addtimer(CALLBACK(src, PROC_REF(end_frenzy)), 10 SECONDS, TIMER_STOPPABLE)

/datum/disease/flash_frenzy/proc/frenzy_loop()
	if(QDELETED(src) || !affected_mob)
		return
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/C = affected_mob
	if(!isturf(C.loc) || !C.can_frenzy_move() || !HAS_TRAIT(C, TRAIT_IN_FRENZY))
		return
	if(C.m_intent == MOVE_INTENT_WALK)
		C.toggle_move_intent(C)
	C.set_glide_size(DELAY_TO_GLIDE_SIZE(C.total_multiplicative_slowdown()))
	var/mob/living/frenzy_target = C.get_frenzy_targets()
	if(frenzy_target)
		if(get_dist(frenzy_target, C) <= 1)
			if(frenzy_target.stat != DEAD)
				if(world.time >= last_frenzy_attack + 5)
					var/dam_zone = ran_zone(BODY_ZONE_CHEST, 0)
					var/obj/item/bodypart/affecting = frenzy_target.get_bodypart(check_zone(dam_zone))
					var/armor_block = frenzy_target.run_armor_check(affecting, "blunt")
					
					C.face_atom(frenzy_target)
					C.do_attack_animation(frenzy_target, ATTACK_EFFECT_PUNCH)
					
					var/damage = rand(5, 10)
					if(frenzy_target.apply_damage(damage, BRUTE, affecting, armor_block))
						frenzy_target.visible_message(span_danger("[C] savagely strikes [frenzy_target]!"), \
											span_danger("[C] savagely strikes me!"), span_hear("I hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, C)
						to_chat(C, span_danger("I strike [frenzy_target]!"))
						playsound(frenzy_target, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE, -1)
						log_combat(C, frenzy_target, "flash-frenzy attacked")
					last_frenzy_attack = world.time
		else
			C.frenzy_pathfind_to_target()
			C.face_atom(frenzy_target)
	else
		if(C.can_frenzy_move())
			if(isturf(C.loc))
				var/turf/T = get_step(C.loc, pick(NORTH, SOUTH, WEST, EAST))
				C.face_atom(T)
				C.Move(T)
	addtimer(CALLBACK(src, PROC_REF(frenzy_loop)), C.total_multiplicative_slowdown())

/datum/disease/flash_frenzy/proc/end_frenzy()
	frenzy_exit_timer = null
	if(QDELETED(src) || !affected_mob)
		return
	if(iscarbon(affected_mob))
		var/mob/living/carbon/C = affected_mob
		REMOVE_TRAIT(C, TRAIT_FLASH_FRENZY_CONTROL_LOSS, "flash_frenzy_disease")
		C.exit_frenzymod()
		if(restore_cmode && C.cmode)
			C.toggle_cmode()
		restore_cmode = FALSE
	schedule_frenzy()

/datum/disease/flash_frenzy/remove_disease()
	if(frenzy_timer)
		deltimer(frenzy_timer)
		frenzy_timer = null
	if(frenzy_exit_timer)
		deltimer(frenzy_exit_timer)
		frenzy_exit_timer = null
	if(iscarbon(affected_mob))
		var/mob/living/carbon/C = affected_mob
		REMOVE_TRAIT(C, TRAIT_FLASH_FRENZY_CONTROL_LOSS, "flash_frenzy_disease")
		if(HAS_TRAIT(C, TRAIT_IN_FRENZY))
			C.exit_frenzymod()
		if(restore_cmode && C.cmode)
			C.toggle_cmode()
		restore_cmode = FALSE
	return ..()
