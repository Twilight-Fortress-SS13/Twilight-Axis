/datum/coven/bestial
	name = "Bestial Guise"
	desc = "Pour your blood into lesser flesh and wear it as a mask. The thinner the blood, the meaner the beast it can hold."
	icon_state = "potence"
	clan_restricted = FALSE
	power_type = /datum/coven_power/bestial
	max_level = 5

/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bestial
	name = "Bestial Guise"
	desc = "Shed your shape for a beast's."
	pick_again = TRUE
	shapeshift_type = null
	die_with_shapeshifted_form = FALSE
	do_gib = FALSE
	possible_shapes = list()

/datum/coven_power/bestial
	name = "Bestial power name"
	desc = "Bestial power description"
	var/list/ta_shapes = list()
	var/obj/effect/proc_holder/spell/targeted/shapeshift/vampire/bestial/ta_shift_spell

/datum/coven_power/bestial/Destroy()
	QDEL_NULL(ta_shift_spell)
	return ..()

/proc/ta_is_shapeshifted(mob/living/carbon/human/vampire)
	return istype(vampire?.loc, /obj/shapeshift_holder)

/datum/coven_power/bestial/proc/ta_refund_failed_use()
	if(owner && cost_system == COVEN_COST_VITAE)
		owner.adjust_bloodpool(vitae_cost)
	return FALSE

/datum/coven_power/bestial/pre_activation_checks(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(!owner || !length(ta_shapes))
		return ta_refund_failed_use()

	if(!ta_shift_spell)
		ta_shift_spell = new()
		ta_shift_spell.possible_shapes = ta_shapes.Copy()

	var/was_shifted = ta_is_shapeshifted(owner)
	ta_shift_spell.shapeshift_type = null
	ta_shift_spell.cast(list(owner), owner)

	if(ta_is_shapeshifted(owner) == was_shifted)
		return ta_refund_failed_use()
	return TRUE

/datum/coven_power/bestial/crawling
	name = "Crawling Guise"
	desc = "Take the shape of the small and the overlooked: a rat, a cat, a cabbit."

	level = 1
	research_cost = 0
	cooldown_length = 20 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	ta_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/smallrat,
		/mob/living/simple_animal/hostile/retaliate/rogue/cat,
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit,
	)

/datum/coven_power/bestial/winged
	name = "Winged Guise"
	desc = "Scatter into wings and leave the ground behind as a bat or a zad."

	level = 2
	research_cost = 1
	cooldown_length = 30 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	ta_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/bat,
		/mob/living/simple_animal/hostile/retaliate/bat/crow,
	)

/datum/coven_power/bestial/predator
	name = "Predator's Guise"
	desc = "Become something with teeth: volf, lynx, bauson, rous or beespider."

	level = 3
	research_cost = 2
	cooldown_length = 45 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	ta_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat,
		/mob/living/simple_animal/hostile/retaliate/rogue/badger,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider,
	)

/datum/coven_power/bestial/monstrous
	name = "Monstrous Guise"
	desc = "Wear a shape that was never meant to hold a mind: direbear, bramblesnout, mossback, skallax spider, mire lurker or lamia."

	level = 4
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE
	cooldown_length = 90 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	ta_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear,
		/mob/living/simple_animal/hostile/retaliate/rogue/boar,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated,
		/mob/living/simple_animal/hostile/rogue/mirespider_lurker,
		/mob/living/simple_animal/hostile/retaliate/rogue/lamia,
	)

/datum/coven_power/bestial/dread_wings
	name = "Dread Wings"
	desc = "Unfold into the storm bat, a horror of wings and hunger."

	level = 5
	research_cost = 5
	minimal_generation = GENERATION_ANCILLAE
	cooldown_length = 2 MINUTES
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	ta_shapes = list(
		/mob/living/simple_animal/hostile/retaliate/bat/ta_storm_bat,
	)

/mob/living/simple_animal/hostile/retaliate/bat/ta_storm_bat
	name = "storm bat"
	desc = "A bat the size of a man, all sinew and wet leather. Its eyes hold something far older than hunger."
	maxHealth = 180
	health = 180
	melee_damage_lower = 40
	melee_damage_upper = 50
	move_to_delay = 2
	AIStatus = AI_OFF
	can_have_ai = FALSE
	wander = FALSE

/mob/living/simple_animal/hostile/retaliate/bat/ta_storm_bat/Initialize()
	. = ..()
	transform = transform.Scale(3, 3)
