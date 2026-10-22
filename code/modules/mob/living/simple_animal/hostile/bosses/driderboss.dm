/mob/living/simple_animal/hostile/boss/driderboss
	name = "Greater Drider"
	desc = "A monstrous fusion of a drow woman and a spider. The finest webbing covers her skin on the chest like lingerie."
	mob_biotypes = MOB_HUMANOID
	boss_abilities = list(/datum/action/boss/drider_summon_minions)
	faction = list(FACTION_DROW)
	icon = 'modular_twilight_axis/icons/roguetown/mob/drow/driderboss.dmi'
	icon_state = "driderboss"
	icon_living = "driderboss"
	icon_dead = "driderboss_dead"
	wander = 0
	vision_range = 8
	aggro_vision_range = 24
	ranged = 1
	rapid = 3
	rapid_fire_delay = 8
	ranged_message = "casts a spell"
	ranged_cooldown_time = 70
	ranged_ignores_vision = TRUE
	environment_smash = 0
	minimum_distance = 6
	retreat_distance = 4
	move_to_delay = 5
	obj_damage = 100
	base_intents = list(/datum/intent/simple/driderboss)
	melee_damage_lower = 60
	melee_damage_upper = 80
	health = 4000
	maxHealth = 4000
	STASTR = 16
	STAPER = 20
	STAINT = 14
	STACON = 20
	STAWIL = 20
	STASPD = 18
	STALUC = 13
	//loot = list(/obj/effect/temp_visual/driderboss_dying)
	projectiletype = /obj/projectile/magic
	var/allowed_projectile_types = /obj/projectile/magic/acidsplash
	patron = /datum/patron/inhumen/zizo
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	stat_attack = UNCONSCIOUS

	ai_controller = /datum/ai_controller/spectral_maid

	var/next_cast = 0
	var/list/taunt = list("Она смотрит на нас!!! Умрите красиво!", "Ах, вкусная плоть...", "Страдайте!")
	var/minions_to_spawn = 6
	var/next_summon = 0
	var/mob_type
	var/mob/new_mob
	var/spawned_mobs = 0
	var/list/minions = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/angry/driderboss = 60,
	)

/mob/living/simple_animal/hostile/boss/driderboss/Initialize(mapload)
	projectiletype = /obj/projectile/bullet/reusable/deepone
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/boss/driderboss/Shoot()
	projectiletype = pick(allowed_projectile_types)
	..()

//First Summon Ability. Spawns two big spiders.
/datum/action/boss/drider_summon_minions
	name = "Summon Spiders"
	button_icon_state = "art_summon"
	usage_probability = 100
	boss_cost = 70
	boss_type = /mob/living/simple_animal/hostile/boss/driderboss
	needs_target = TRUE
	say_when_triggered = "На помощь, стражи!"
	var/static/summoned_minions = 0

/datum/action/boss/drider_summon_minions/Trigger()
	if(summoned_minions <= 8 && ..())
		var/list/minions = list(
		/mob/living/simple_animal/hostile/rogue/drowmage/spider = 30)
		var/list/directions = GLOB.cardinals.Copy()
		for(var/i in 1 to 2)
			var/minions_chosen = pickweight(minions)
			new minions_chosen (get_step(boss,pick_n_take(directions)), 1)
		summoned_minions += 1;

/mob/living/simple_animal/hostile/boss/driderboss/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time && next_summon < world.time) //Second summon ability. Spawns a mob of small spiders
		spawn_minions(minions_to_spawn)
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, say), "Придите, дети мои! Пируйте их плотью!", null, list("colossus", "yell"))
		next_cast = world.time + 10
		next_summon = world.time + 600
		return .
	if(target && next_cast < world.time)
		blast()
		next_cast = world.time + 100
		return .

/mob/living/simple_animal/hostile/boss/driderboss/proc/shoot_projectile(turf/marker, set_angle)
	if(!isnum(set_angle) && (!marker || marker == loc))
		return
	var/turf/startloc = get_turf(src)
	var/obj/projectile/P = new projectiletype(startloc)
	P.preparePixelProjectile(marker, startloc)
	P.firer = src
	if(target)
		P.original = target
	P.fire(set_angle)

/obj/projectile/magic/sickness/driderboss
	speed = 20
	damage = 20

/mob/living/simple_animal/hostile/boss/driderboss/proc/spawn_minions()
	var/spawn_chance = 100
	if (prob(spawn_chance))
		var/turf/spawn_turf
		var/i = 0
		while (i < minions_to_spawn)
			spawn_turf = get_random_valid_turf()
			if (spawn_turf)
				mob_type = pickweight(minions)
				new_mob = new mob_type(spawn_turf)
				if (new_mob)
					spawned_mobs++
			i++

/mob/living/simple_animal/hostile/boss/driderboss/proc/get_random_valid_turf()
	var/list/valid_turfs = list()
	for (var/turf/T in range(6, src))
		if (is_valid_spawn_turf(T))
			valid_turfs += T
	if (valid_turfs.len == 0)
		return null
	return pick(valid_turfs)

/mob/living/simple_animal/hostile/boss/driderboss/proc/is_valid_spawn_turf(turf/T)
	if (!(istype(T, /turf/open/floor/rogue)))
		return FALSE
	if (istype(T, /turf/closed))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/boss/driderboss/proc/blast(set_angle)
	var/turf/target_turf = get_turf(target)
	var/angle_to_target = Get_Angle(src, target_turf)
	if(isnum(set_angle))
		angle_to_target = set_angle
	var/static/list/colossus_shotgun_shot_angles = list(30, 20, 10, 0, -10, -20, -30)
	for(var/i in colossus_shotgun_shot_angles)
		shoot_projectile(target_turf, angle_to_target + i)

/mob/living/simple_animal/hostile/boss/driderboss/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/mob/M in range(7,src))
		shake_camera(M, 7, 1)
	var/turf/T = get_turf(src)
	new /obj/item/roguekey/mage/driderboss(T)

/mob/living/simple_animal/hostile/boss/driderboss/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/datum/intent/simple/driderboss
	name = "driderboss"
	icon_state = "instrike"
	attack_verb = list("strikes", "cuts", "cleaves", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = 'sound/combat/hits/bladed/genchop (1).ogg'
	chargetime = 10
	penfactor = PEN_HEAVY
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_d_type = "stab"

/obj/effect/oneway
	name = "one way effect"
	desc = ""
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "field_dir"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/oneway/CanPass(atom/movable/mover, turf/target)
	if(!(ismob(mover))) //Fixes cart exploit that broke one way boss arena doors. Only mobs can pass through now.
		return ..() && 0
	var/turf/T = get_turf(src)
	var/turf/MT = get_turf(mover)
	return ..() && (T == MT || get_dir(MT,T) == dir)

/obj/effect/oneway/driderboss //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Overcome the guard who holds the key to the passage!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/driderboss/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/mage/driderboss))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)

//Loot
/obj/item/roguekey/mage/driderboss
	name = "Drider's key"
	desc = "A strange key the Drider dropped."
	icon_state = "eyekey"
	lockid = "driderboss"

/mob/living/simple_animal/hostile/retaliate/rogue/mirespider/angry/driderboss
	faction = list(FACTION_DROW)
