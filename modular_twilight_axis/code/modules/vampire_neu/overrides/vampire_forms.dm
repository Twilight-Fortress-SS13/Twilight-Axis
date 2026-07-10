/*
 * Keeps vampire shapeshifts separate from their ordinary and witch variants.
 */

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bat
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/bat/vampire_shifted

/mob/living/simple_animal/hostile/retaliate/bat/vampire_shifted
	speed = 0
	move_to_delay = 2
	AIStatus = AI_OFF
	can_have_ai = FALSE
	wander = FALSE
