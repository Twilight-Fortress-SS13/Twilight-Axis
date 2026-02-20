/mob/living/simple_animal/hostile/retaliate/blood
	name = "FLESH HOMUNCULUS"
	desc = "WHAT THE-... KILL IT WITH FIRE!!!!"
	hud_type = /datum/hud/human
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizoid.dmi'
	icon_state = "FLESH"
	icon_living = "FLESH"

	mob_biotypes = MOB_EPIC
	footstep_type = FOOTSTEP_MOB_HEAVY
	vision_range = 6
	aggro_vision_range = 6
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	retreat_distance = 0
	minimum_distance = 0

	health = 1200
	maxHealth = 1200
	food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/unarmed/claw)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	melee_damage_lower = 80
	melee_damage_upper = 100
	STASTR = 14
	STAPER = 8
	STAINT = 1
	STACON = 15
	STAWIL = 16
	STASPD = 4
	STALUC = 15
	defprob = 20
	del_on_deaggro = 99 SECONDS
	retreat_health = 0
	food = 0

	dodgetime = 20
	aggressive = TRUE
//	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/troll // Placeholder until Troll remains are sprited.

	ai_controller = /datum/ai_controller/minotaur
	faction = list("undead")


/mob/living/simple_animal/hostile/retaliate/blood/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/blood/ascended
	name = "???"
	desc = "AH, ITS OUR END!!! PRAISE THE QUEEN!!!"
	hud_type = /datum/hud/human
	icon_state = "ascend"
	icon_living = "ascend"
	icon = 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sprites/zizoid.dmi'
	move_to_delay = 0
	base_intents = list(/datum/intent/unarmed/ascendedclaw)
	melee_damage_lower = 250
	melee_damage_upper = 550
	health = 666666
	maxHealth = 666666
	STASTR = 66
	STAPER = 66
	STAINT = 66
	STACON = 66
	STAWIL = 66
	STASPD = 20
	STALUC = 66

/mob/living/simple_animal/hostile/retaliate/blood/ascended/examine(mob/user)
	. = ..()
	. += "<span class='narsiesmall'>It is impossible to comprehend such a thing.</span>"

/mob/living/simple_animal/hostile/retaliate/blood/ascended/Initialize()
	. = ..()
	set_light(5,5,5, l_color =  LIGHT_COLOR_RED)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/blood/ascended/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg')
		if("pain")
			return pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg')
		if("death")
			return pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg')
		if("idle")
			return pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg')
		if("cidle")
			return pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg')

/mob/living/simple_animal/hostile/retaliate/blood/death(gibbed)
	. = ..()
	gib()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/blood/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/troll/aggro1.ogg','sound/vo/mobs/troll/aggro2.ogg')
		if("pain")
			return pick('sound/vo/mobs/troll/pain1.ogg','sound/vo/mobs/troll/pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/troll/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/troll/idle1.ogg','sound/vo/mobs/troll/idle2.ogg')
		if("cidle")
			return pick('sound/vo/mobs/troll/cidle1.ogg','sound/vo/mobs/troll/aggro2.ogg')

/mob/living/simple_animal/hostile/retaliate/blood/taunted(mob/user)
	emote("aggro")
	return


/mob/living/simple_animal/hostile/retaliate/blood/simple_limb_hit(zone)
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

/// Very temporary sprite
/mob/living/simple_animal/hostile/retaliate/blood/weird
	icon = 'icons/roguetown/underworld/carriageman.dmi'
	icon_state = "weird"

/datum/intent/unarmed/ascendedclaw
	name = "claw"
	icon_state = "inclaw"
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "claw"
	blade_class = BCLASS_CHOP
	hitsound = "genslash"
	penfactor = 131
	damfactor = 40
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
