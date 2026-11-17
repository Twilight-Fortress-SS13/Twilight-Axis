/datum/ai_controller/ifrit
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
		/datum/ai_planning_subtree/targeted_mob_ability/any/continue_planning,

		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/simple_self_recovery/dragon,

		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

// =========================================================================
// FIRE BREATH ABILITIES
// =========================================================================

/datum/action/cooldown/mob_cooldown/fire_breath
	name = "Fire Breath"
	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "fireball"
	desc = "Breathe a line of flames towards the target."
	cooldown_time = 20 SECONDS
	shared_cooldown = "mob_special"
	lockout_time = 3 SECONDS
	panel = null

	// AI settings
	use_chance = 70
	npc_min_range = 0
	npc_max_range = 6
	npc_requires_los = TRUE

	/// Range of the fire
	var/fire_range = 6
	/// Sound played on fire cast
	var/fire_sound = 'sound/magic/fireball.ogg'
	/// Delay between turfs
	var/fire_delay = 0.25 SECONDS
	/// Cast windup
	var/cast_time = 1.5 SECONDS
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/datum/action/cooldown/mob_cooldown/fire_breath/Activate(atom/target_atom)
	if(!target_atom || target_atom == owner)
		target_atom = get_step(owner, owner.dir)
	StartCooldown()
	owner.visible_message(span_alert("[owner] inhales deeply, warmth emanating from their form."))
	addtimer(CALLBACK(src, PROC_REF(attack_sequence), target_atom), cast_time)
	return TRUE

/datum/action/cooldown/mob_cooldown/fire_breath/proc/attack_sequence(atom/target)
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	playsound(owner.loc, fire_sound, 100, TRUE)
	fire_line(target)

/datum/action/cooldown/mob_cooldown/fire_breath/proc/fire_line(atom/target, offset = 0)
	if(isnull(target) || QDELETED(owner))
		return
	var/turf/target_turf = get_ranged_target_turf_direct(owner, target, fire_range, offset)
	var/list/turfs = getline(owner, target_turf) - get_turf(owner)
	INVOKE_ASYNC(src, PROC_REF(progressive_fire_line), turfs)

/datum/action/cooldown/mob_cooldown/fire_breath/proc/progressive_fire_line(list/burn_turfs)
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	var/list/hit_list = list(owner)
	for(var/turf/target_turf in burn_turfs)
		if(target_turf.is_blocked_turf(exclude_mobs = TRUE))
			explosion(target_turf, -1, 0, 4, 0, 0, flame_range = 1, soundin = explode_sound)
			return
		burn_turf(target_turf, hit_list, owner)
		sleep(fire_delay)

/datum/action/cooldown/mob_cooldown/fire_breath/proc/burn_turf(turf/fire_turf, list/hit_list, mob/living/source)
	var/obj/effect/hotspot/fire_hotspot = new /obj/effect/hotspot(fire_turf)

	for(var/mob/living/barbecued in fire_turf.contents)
		if(barbecued in hit_list)
			continue
		hit_list |= barbecued
		on_burn_mob(barbecued, source)

	return fire_hotspot

/datum/action/cooldown/mob_cooldown/fire_breath/proc/on_burn_mob(mob/living/barbecued, mob/living/source)
	to_chat(barbecued, span_userdanger("You are burned by [source]'s fire breath!"))
	barbecued.fire_act(4, 8)
	barbecued.apply_damage(10, BURN)

/datum/action/cooldown/mob_cooldown/fire_breath/cone
	name = "Fire Cone"
	desc = "Breathe several lines of fire directed at a target."
	cooldown_time = 25 SECONDS
	var/list/angles = list(-20, 0, 20)

/datum/action/cooldown/mob_cooldown/fire_breath/cone/attack_sequence(atom/target)
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	playsound(owner.loc, fire_sound, 100, TRUE)
	for(var/offset in angles)
		fire_line(target, offset)

/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit
	fire_range = 3
	cooldown_time = 25 SECONDS

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire
	name = "Fire Wheel"
	button_icon = 'icons/effects/fire.dmi'
	button_icon_state = "light"
	desc = "Breathe flames in all directions."
	cooldown_time = 65 SECONDS
	fire_range = 8
	npc_min_range = 0
	npc_max_range = 8
	self_targetable = TRUE
	use_chance = 50

	var/sectors = 8
	var/breath_delay = 1.5 SECONDS
	var/total_spins = 2

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/Activate(atom/target_atom)
	target_atom = get_step(owner, owner.dir)
	return ..()

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/attack_sequence(atom/target)
	var/queued_spins = 0
	for(var/i in 1 to total_spins)
		var/delay = queued_spins * breath_delay
		queued_spins++
		addtimer(CALLBACK(src, PROC_REF(fire_spin), target, queued_spins), delay)

/datum/action/cooldown/mob_cooldown/fire_breath/mass_fire/proc/fire_spin(target, spin_count)
	if(QDELETED(owner) || owner.stat == DEAD)
		return
	playsound(owner.loc, 'sound/magic/meteorstorm.ogg', 100, TRUE)
	var/angle_increment = 360 / sectors
	var/additional_offset = spin_count * angle_increment / 2
	for(var/i in 1 to sectors)
		fire_line(target, (angle_increment * i) + additional_offset)

// =========================================================================
// MOBS
// =========================================================================

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit
	threat_point = THREAT_DANGEROUS
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
	see_in_dark = 6
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
	food = 0
	remains_type = null
	attack_sound = list('sound/vo/mobs/direbear/direbear_attack1.ogg','sound/vo/mobs/direbear/direbear_attack2.ogg','sound/vo/mobs/direbear/direbear_attack3.ogg')
	dodgetime = 30
	aggressive = 1
	eat_forever = TRUE

	ai_controller = /datum/ai_controller/ifrit
	move_base_delay = MOVEMENT_DELAY_SPD_3

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
	AddComponent(/datum/component/ai_aggro_system)
	var/datum/action/cooldown/mob_cooldown/fire_breath/cone/ifrit/fire = new(src)
	fire.Grant(src)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/ifrit/matriarch
	icon = 'modular_deserttown/icons/mob/monster/ifritmatriarch.dmi'
	health = 6000
	maxHealth = 6000
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
	fire_breath = new(src)
	fire_breath.Grant(src)

	firewheel = new(src)
	firewheel.Grant(src)

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

// =========================================================================
// BARRIER & KEY
// =========================================================================

/obj/item/roguekey/mage/ifrit
	name = "drakian key"
	desc = "An ancient drakian key. Once embedded in an ifrit matriarch's flame, now no more than a trophy."
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
		playsound(src, 'sound/magic/teleport_diss.ogg', 100, TRUE)
		qdel(src)
