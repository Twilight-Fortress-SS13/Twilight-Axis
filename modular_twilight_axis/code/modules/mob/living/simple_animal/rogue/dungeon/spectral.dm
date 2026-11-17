/mob/living/simple_animal/hostile/rogue/spectral
	threat_point = THREAT_LOW
	icon = 'modular_twilight_axis/icons/roguetown/mob/spectral/spectral.dmi'
	name = "spectral guard"
	desc = "This is the tortured soul of a royal guardsman. Flesh and armor have decayed, but loyalty is eternal."
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = null
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 0
	see_in_dark = 6
	base_intents = list(/datum/intent/simple/slash)
	faction = list(FACTION_UNDEAD)
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	health = 280
	maxHealth = 280
	melee_damage_lower = 25
	melee_damage_upper = 45
	attack_sound = 'sound/combat/wooshes/bladed/wooshmed (1).ogg'
	dodge_sound = 'sound/combat/dodge.ogg'
	parry_sound = "bladedmedium"
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	food_type = list()
	movement_type = FLYING
	pass_flags = PASSTABLE|PASSGRILLE
	pooptype = null
	STACON = 10
	STASTR = 10
	STASPD = 12
	STALUC = 10
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	simple_detect_bonus = 20
	del_on_death = TRUE
	defprob = 50
	d_intent = INTENT_PARRY
	food = 0
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"

	ai_controller = /datum/ai_controller/simple_skeleton

/mob/living/simple_animal/hostile/rogue/spectral/servant
	threat_point = THREAT_LOW
	icon = 'modular_twilight_axis/icons/roguetown/mob/spectral/spectral.dmi'
	name = "spectral servant"
	desc = "This is the tortured soul of a maid buried with her King. Despite the years after death, the dress still looks neat."
	icon_state = "servant"
	icon_living = "servant"
	icon_dead = null
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 0
	see_in_dark = 6
	base_intents = list(/datum/intent/unarmed/claw)
	faction = list(FACTION_UNDEAD)
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 17
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	ranged = TRUE
	ranged_cooldown_time = 40
	projectiletype = /obj/projectile/magic/frostbolt/spectral
	check_friendly_fire = 1
	food_type = list()
	movement_type = FLYING
	pass_flags = PASSTABLE|PASSGRILLE
	pooptype = null
	STACON = 7
	STASTR = 6
	STASPD = 12
	STALUC = 11
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	simple_detect_bonus = 20
	del_on_death = TRUE
	defprob = 40
	candodge = TRUE
	food = 0
	attack_sound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	dodgetime = 30

	ai_controller = /datum/ai_controller/skeleton_ranged

/obj/projectile/magic/frostbolt/spectral
	antibeast_factor = ANTIBEAST_GREATER
	speed = MAGE_PROJ_SLOW

/mob/living/simple_animal/hostile/rogue/spectral/Initialize()
	. = ..()
	set_light(2, 2, 4, l_color = "#62bee9")
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/rogue/spectral/death(gibbed)
	emote("death")
	..()

/mob/living/simple_animal/hostile/rogue/spectral/Life()
	. = ..()
	if(!ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		if(prob(2))
			emote(pick("laugh", "moan", "whisper"), TRUE)

/mob/living/simple_animal/hostile/rogue/spectral/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')
