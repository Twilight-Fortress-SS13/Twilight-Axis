/mob/living/simple_animal/hostile/retaliate/rogue/antlion
	icon = 'modular_deserttown/icons/mob/monster/antlion.dmi'
	name = "antlion"
	desc = ""
	threat_point = THREAT_TOUGH
	pixel_x = -2
	pixel_y = 7
	faction = list("antlion")
	gender = MALE
	icon_state = "antlion"
	icon_living = "antlion"
	icon_dead = "antlion_dead"
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 3, /obj/item/natural/bone = 3)
	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	health = 660
	maxHealth = 660
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	milkies = FALSE
	melee_damage_lower = 60
	melee_damage_upper = 90
	STASPD = 10
	STACON = 15
	STASTR = 12
	tame = FALSE
	food_type = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/spider,
		/obj/item/reagent_containers/food/snacks/rogue/meat/crab,
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry,
		/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/truffles,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)
	tame_chance = 5
	bonus_tame_chance = 5
	can_saddle = TRUE
	can_buckle = TRUE
	aggressive = 1
	move_base_delay = MOVEMENT_DELAY_SPD_17
	ai_controller = /datum/ai_controller/mirespider
	remains_type = /obj/effect/decal/remains/antlion

/obj/effect/decal/remains/antlion
	name = "remains"
	gender = PLURAL
	icon_state = "bones"
	icon = 'modular_deserttown/icons/mob/monster/antlion.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/Initialize(mapload)
	. = ..()
	if(ai_controller)
		AddComponent(/datum/component/ai_aggro_system)
		AddElement(/datum/element/ai_retaliate)
		AddElement(/datum/element/ai_flee_while_injured, 0.3, 0.5)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE2, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			add_overlay(saddlet)

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/tamed()
	..()
	deaggroprob = 20
	setup_mount(list(TEXT_NORTH = list(0, 9), TEXT_SOUTH = list(0, 9), TEXT_EAST = list(-1, 9), TEXT_WEST = list(-1, 9)), south_layer = OBJ_LAYER, north_layer = MOB_LAYER+0.5)
	var/datum/component/riding/D = get_riding_datum()
	if(D)
		D.set_riding_offsets(2, list(TEXT_NORTH = list(0, 1), TEXT_SOUTH = list(0, 17), TEXT_EAST = list(-9, 9), TEXT_WEST = list(7, 9)))

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/death()
	unbuckle_all_mobs()
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/taunted(mob/user)
	emote("aggro")
	if(isliving(user))
		ai_controller?.force_aggro(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/eat_plants()
	..()
	var/obj/structure/vine/SV = locate(/obj/structure/vine) in loc
	if(SV)
		SV.eat(src)
		food = max(food + 30, 100)

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/Life()
	..()
	if(stat == CONSCIOUS)
		if(!pulledby)
			for(var/direction in shuffle(list(1,2,4,8,5,6,9,10)))
				var/step = get_step(src, direction)
				if(step)
					if(locate(/obj/structure/vine) in step || locate(/obj/structure/glowshroom) in step)
						Move(step, get_dir(src, step))
	if(stat != DEAD)
		if(has_buckled_mobs())
			icon_state = "antlion_mounted"
			icon_living = "antlion_mounted"
		else
			icon_state = "antlion"
			icon_living = "antlion"

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_CHEST)
			return "thorax"
		if(BODY_ZONE_PRECISE_GROIN)
			return "abdomen"
		if(BODY_ZONE_L_ARM)
			return "front right leg"
		if(BODY_ZONE_R_ARM)
			return "front left leg"
		if(BODY_ZONE_L_LEG)
			return "hind right leg"
		if(BODY_ZONE_R_LEG)
			return "hind left leg"
	return "thorax"

/mob/living/simple_animal/hostile/retaliate/rogue/antlion/tame/saddled/Initialize()
	. = ..()
	setup_mount(list(TEXT_NORTH = list(0, 9), TEXT_SOUTH = list(0, 9), TEXT_EAST = list(-1, 9), TEXT_WEST = list(-1, 9)), south_layer = OBJ_LAYER, north_layer = MOB_LAYER+0.5)
	var/datum/component/riding/D = get_riding_datum()
	if(D)
		D.set_riding_offsets(2, list(TEXT_NORTH = list(0, 1), TEXT_SOUTH = list(0, 17), TEXT_EAST = list(-9, 9), TEXT_WEST = list(7, 9)))
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()
