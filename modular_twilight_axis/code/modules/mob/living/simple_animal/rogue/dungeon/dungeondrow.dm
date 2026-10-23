/mob/living/simple_animal/hostile/rogue/drowmage/mage
	threat_point = THREAT_LOW
	icon = 'modular_twilight_axis/icons/roguetown/mob/drow/drowmage.dmi'
	name = "drow mage"
	desc = "A Drow sorceress who has devoted her life to the study of destruction magic."
	icon_state = "drowmage"
	icon_living = "drowmage"
	icon_dead = null
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 0
	turns_per_move = 4
	see_in_dark = 6
	move_to_delay = 4
	base_intents = list(/datum/intent/unarmed/punch)
	faction = list(FACTION_DROW)
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	health = 200
	maxHealth = 200
	melee_damage_lower = 10
	melee_damage_upper = 20
	vision_range = 9
	aggro_vision_range = 9
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	ranged = TRUE
	ranged_cooldown_time = 130
	projectiletype =/obj/projectile/magic/aoe/fireball/drowmage
	retreat_distance = 4
	minimum_distance = 3
	check_friendly_fire = 1
	food_type = list()
	pooptype = null
	STACON = 8
	STASTR = 8
	STAINT = 16
	STASPD = 10
	STALUC = 11
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	simple_detect_bonus = 20
	del_on_death = FALSE
	defprob = 40
	candodge = TRUE
	retreat_health = 0
	food = 0
	attack_sound = 'sound/combat/hits/blunt/genblunt (1).ogg'
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	dodgetime = 30

	ai_controller = /datum/ai_controller/spectral_maid

/obj/projectile/magic/aoe/fireball/drowmage
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE

/obj/projectile/magic/aoe/fireball/drowmage/on_hit(target)
	. = ..()

	if(out_of_effective_range())
		return

	var/turf/T = get_turf(target)

	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] vanishes into smoke on contact with [target]!"))
			return BULLET_ACT_BLOCK

	explosion(T, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	for(var/mob/living/L in range(4, T))
		L.adjustFireLoss(80)

/mob/living/simple_animal/hostile/rogue/drowmage/mage/death(gibbed, nocutscene = FALSE)
	. = ..()
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/gib_animation(get_turf(src), "gibbed-h")
	playsound(src, 'sound/combat/fracture/fracturewet (2).ogg', 100, TRUE)
	qdel(src)
	new /obj/effect/decal/cleanable/blood/gibs/limb(T)
	new /mob/living/simple_animal/hostile/rogue/drowmage/spider(T)

/mob/living/simple_animal/hostile/rogue/drowmage/spider
	anatomy_type = /datum/anatomy/spider/spitter
	attack_aim = MOB_AIM_HIGH // BIG spidah with tall sprite
	icon = 'icons/mob/mirespider_new.dmi'
	desc = "An unusually large and dangerous mire crawler, these lumbering creatures tend to find smaller specimens gravitating to them for safety - or perhaps simply to hunt more efficiently."
	name = "mire lurker"
	icon_state = "lurker"
	icon_living = "lurker"
	icon_dead = "lurker_dead"
	response_help_continuous = "pets"
	response_help_simple = "pet"

	faction = list(FACTION_DROW)
	threat_point = THREAT_ELITE
	ambush_faction = "underdark"
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 3,
						/obj/item/natural/silk = 3,
						/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1,
						/obj/item/alch/viscera = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 4,
						/obj/item/natural/hide = 4,
						/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 2,
						/obj/item/natural/silk = 5, // You killed the mire lurker. You get all the figgy pudding . . .
						/obj/item/alch/viscera = 4)
	head_butcher = /obj/item/natural/head/mirelurker

	health = 250
	maxHealth = 250
	melee_damage_lower = 50
	melee_damage_upper = 70

	STACON = 12
	STASTR = 12
	STASPD = 14
	// These things will crit. Slow attacks, devestating consequences.
	STAPER = 15
	pixel_x = -4

	ai_controller = /datum/ai_controller/simple_skeleton
	move_base_delay = MOVEMENT_DELAY_SPD_17
