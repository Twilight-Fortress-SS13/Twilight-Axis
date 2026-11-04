/datum/ai_controller/ifrit
	movement_delay = WOLF_MOVEMENT_SPEED

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items()
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/targeted_mob_ability/continue_planning,

		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/simple_self_recovery/dragon,

		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit
	name = "Fire Breath"
	var/fire_range = 6
	cooldown_time = 15 SECONDS

/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit/Activate(atom/target)
	StartCooldown()
	if(owner)
		owner.visible_message(span_danger("[owner] breathes a cone of roaring fire!"))
		playsound(owner, 'sound/magic/fireball.ogg', 100, TRUE)

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire
	name = "Fire Wheel"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/Activate(atom/target)
	StartCooldown()
	if(owner)
		owner.visible_message(span_boldwarning("[owner] radiates waves of scorching flame!"))
		playsound(owner, 'sound/magic/meteorstorm.ogg', 100, TRUE)

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit
	icon = 'modular_deserttown/icons/mob/monster/ifrit.dmi'
	name = "ifrit"
	icon_state = "ifrit"
	icon_living = "ifrit"
	icon_dead = "ifrit_dead"
	ambushable = FALSE
	base_intents = list(/datum/intent/simple/bite/bear)
	faction = list("ifrit")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	melee_damage_lower = 50
	melee_damage_upper = 60
	vision_range = 6
	aggro_vision_range = 8
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	milkies = FALSE
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	health = 500
	maxHealth = 500
	food_type = list(
		/obj/item/reagent_containers/food/snacks,
		/obj/item/bodypart,
		/obj/item/organ,
		/obj/effect/decal/remains,
	)
	STACON = 12
	STASTR = 13
	STASPD = 9
	simple_detect_bonus = 40
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = FALSE
	food = 0
	remains_type = null
	attack_sound = list('sound/vo/mobs/direbear/direbear_attack1.ogg','sound/vo/mobs/direbear/direbear_attack2.ogg','sound/vo/mobs/direbear/direbear_attack3.ogg')
	dodgetime = 30
	aggressive = 1
	stat_attack = UNCONSCIOUS
	eat_forever = TRUE

	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/ifrit

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/magic/charging_fire.ogg')
		if("pain")
			return pick('sound/magic/charging_fire.ogg')
		if("death")
			return pick('sound/magic/charging_fire.ogg')

/datum/intent/simple/bite/frit
	clickcd = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit/fire = new(src)
	fire.Grant(src)
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_TARGETED_ACTION, fire)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/matriarch
	icon = 'modular_deserttown/icons/mob/monster/ifritmatriarch.dmi'
	health = 8000
	maxHealth = 8000
	name = "ifrit Matriarch"
	icon_state = "ifrit_queen"
	icon_living = "ifrit_queen"
	icon_dead = "ifrit_queen_dead"
	base_intents = list(/datum/intent/unarmed/dragonclaw)
	ranged_cooldown_time = 20 SECONDS
	var/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit/fire_breath
	var/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/firewheel
	pixel_x = -32
	STACON = 20
	STASTR = 20
	STASPD = 13

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/matriarch/Initialize(mapload)
	. = ..()
	firewheel = new(src)
	firewheel.Grant(src)
	fire_breath = new(src)
	fire_breath.Grant(src)

	if(ai_controller)
		ai_controller.set_blackboard_key(BB_TARGETED_ACTION, fire_breath)
		ai_controller.set_blackboard_key(BB_TARGETED_ACTION, firewheel)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_GUIDANCE, TRAIT_GENERIC)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/matriarch/Destroy()
	if(fire_breath)
		fire_breath.Remove(src)
		QDEL_NULL(fire_breath)
	if(firewheel)
		firewheel.Remove(src)
		QDEL_NULL(firewheel)
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/matriarch/boss
	loot = list(/obj/item/roguekey/mage/ifrit)

/obj/item/roguekey/mage/ifrit
	name = "drakian key"
	desc = "An ancient drakian key. Once embedded in an ifrit matriach's flame, now no more than a trophy."
	icon_state = "voidkey"
	lockid = "ifrit"

/obj/effect/oneway/ifrit
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 5 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/ifrit/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/mage/ifrit))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)
