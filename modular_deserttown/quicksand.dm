/* Зыбучие пески - первый трай, пока что комментим /obj/structure/trap/quicksand
	name = "shifting sand"
	desc = "The sand here looks loose and unnaturally unstable."
	icon = 'modular_deserttown/icons/quicksand.dmi'
	icon_state = "quicksand"
	buckle_lying = FALSE
	buckle_prevents_pull = TRUE
	var/sink_depth = 0

/obj/structure/trap/quicksand/Crossed(atom/movable/AM)
	..()
	if(obj_broken)
		return
	if(!isliving(AM))
		return
	if(has_buckled_mobs())
		return

	var/mob/living/victim = AM
	if(!victim.ambushable())
		return
	
	// Sneaking or being native to the dunes bypasses the trap
	if(victim.m_intent == MOVE_INTENT_SNEAK || HAS_TRAIT(victim, TRAIT_AZURENATIVE))
		return

	buckle_mob(victim, TRUE, check_loc = FALSE)
	// You can add a specific slithering/sinking sound here if one exists
	// playsound(loc, 'sound/effects/mob/sludge_movement1.ogg', 50, TRUE, -1)
	
	visible_message(span_userdanger("[victim] begins to sink into the [src]! RESIST as many times as possible to break free!"))
	sink_depth = 0
	
	addtimer(CALLBACK(src, PROC_REF(sink_victim), victim), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/trap/quicksand/proc/sink_victim(mob/living/victim)
	if(!victim || QDELETED(victim))
		return
	if(victim.loc != loc)
		return
	if(!(has_buckled_mobs() && victim.buckled))
		return

	sink_depth++
	victim.pixel_y -= 4 // Visually sink the mob into the tile

	visible_message(span_danger("[victim] sinks deeper into the [src]!"))

	if(sink_depth >= 5) // Deep enough to start crushing the chest
		if(iscarbon(victim))
			var/mob/living/carbon/C = victim
			C.adjustOxyLoss(15)
			C.adjustBruteLoss(10)
		else
			victim.adjustBruteLoss(25)
		to_chat(victim, span_userdanger("The heavy sand crushes your chest, making it impossible to breathe!"))

	if(sink_depth >= 8) // Sunk entirely
		if(victim.stat != DEAD)
			victim.death()
		victim.forceMove(src) // Hide the corpse inside the trap
		victim.pixel_y = 0 // Reset sprite offset for when it is retrieved
		unbuckle_all_mobs()
		sink_depth = 0
		return

	// Repeat the sinking loop
	addtimer(CALLBACK(src, PROC_REF(sink_victim), victim), 3 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/structure/trap/quicksand/user_unbuckle_mob(mob/living/M, mob/user, var/break_factor = 1)
	if(obj_broken)
		..()
		return
	if(!isliving(user))
		return

	var/mob/living/L = user
	var/time2mount = CLAMP((L.STASTR * 2 * break_factor), 1, 99)
	
	user.changeNext_move(CLICK_CD_FAST, override = TRUE)
	
	if(user != M)
		user.visible_message(span_warning("[user] tries to pull [M] free from the [src]!"))
	else
		user.visible_message(span_warning("[user] tries to break free from the [src]!"))

	if(!prob(time2mount))
		if(do_after(M, 0.75 SECONDS, target = src))
			user_unbuckle_mob(M, user, break_factor * 1.5)
		return

	visible_message(span_notice("[M] breaks free from the [src]!"))
	M.pixel_y = 0
	sink_depth = 0
	unbuckle_all_mobs()

/obj/structure/trap/quicksand/Destroy()
	unbuckle_all_mobs()
	if(contents.len)
		for(var/obj/item/eaten in contents)
			var/turf/target = get_ranged_target_turf(src, pick(GLOB.alldirs), 1)
			eaten.forceMove(target)
			contents.Remove(eaten)
	..()
 */
