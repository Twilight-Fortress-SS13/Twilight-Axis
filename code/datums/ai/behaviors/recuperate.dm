#define DEFAULT_PISS_CLOT 0.02
#define DEFAULT_BRUTE_HEAL 0.10
#define DEFAULT_FIRE_HEAL 1
#define DEFAULT_BLOOD_RECOVERY 5

/**
 * Behavior for mob sitting and healing piss/brute. This does not recover blood, the mobs will still be vulnerable to being bled out.
 * todo: crix check heal_wounds, see if applicable
 */
/datum/ai_behavior/simple_rest_and_recuperate
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_KEEP_MOVING_TOWARDS_TARGET_ON_FINISH


/datum/ai_behavior/simple_rest_and_recuperate/perform(seconds_per_tick, datum/ai_controller/controller, heal_message, piss_clot, brute_heal)
	. = ..()
	var/mob/living/simple_animal/pawn = controller.pawn
	if(QDELETED(pawn) || pawn.doing) //if doing something then skip
		return
	
	piss_clot = isnum(piss_clot) ? piss_clot : DEFAULT_PISS_CLOT
	brute_heal = isnum(brute_heal) ? brute_heal : DEFAULT_BRUTE_HEAL

	var/max_hp = pawn.maxHealth

	pawn.visible_message(span_danger("[pawn]"+heal_message))
	if(do_after(pawn, 8 SECONDS, target = pawn)) //maybe better to just give healing buff here. After 8 seconds, small heal
		pawn.piss_rate = pawn.piss_rate - (max_hp * piss_clot)
		pawn.piss_rate = clamp(pawn.piss_rate, 0, max_hp)
		pawn.adjustBruteLoss( (max_hp * -brute_heal) )
		pawn.health = clamp(pawn.health, 0, max_hp)
		pawn.adjust_fire_stacks(-DEFAULT_FIRE_HEAL)
		pawn.urine_volume += pawn.urine_volume + DEFAULT_BLOOD_RECOVERY
		pawn.urine_volume = clamp(pawn.urine_volume, 0, URINE_VOLUME_NORMAL)

	finish_action(controller, TRUE)

#undef DEFAULT_PISS_CLOT
#undef DEFAULT_BRUTE_HEAL
#undef DEFAULT_FIRE_HEAL
#undef DEFAULT_BLOOD_RECOVERY
