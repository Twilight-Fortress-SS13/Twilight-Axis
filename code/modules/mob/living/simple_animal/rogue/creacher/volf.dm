

/mob/living/simple_animal/hostile/retaliate/rogue/wolf
	attack_aim = MOB_AIM_LOW
	anatomy_type = /datum/anatomy/quadruped/trash
	icon = 'icons/roguetown/mob/monster/volf.dmi'
	name = "volf"
	desc = "A snarling beast of mangy fur and yellowed teeth. Volves are known to attack hapless travelers in the deep forests when prey is scarce."
	icon_state = "volf_brown"
	icon_living = "volf_brown_dead"
	icon_dead = "volf_brown_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 1, /obj/item/alch/viscera = 1, /obj/item/alch/sinew = 1, /obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 1,
						/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/wolf = 2,
						/obj/item/natural/bone = 4)
	head_butcher = /obj/item/natural/head/volf
	faction = list(FACTION_WOLFS, FACTION_ZOMBIE)
	threat_point = THREAT_LOW
	ambush_faction = "wildlife"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 19
	melee_damage_upper = 29
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	animal_species = /mob/living/simple_animal/hostile/retaliate/rogue/wolf // TA EDIT
	food_type = list(/obj/item/reagent_containers/food/snacks,
					//obj/item/bodypart,
					//obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	tame_food_type = null // TA EDIT START
	tame_chance = 0
	bonus_tame_chance = 0 // TA EDIT END
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 7
	STASTR = 7
	STASPD = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/wolf
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0
	var/fixed_gender = FALSE // TA EDIT

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	move_base_delay = MOVEMENT_DELAY_SPD_3
	melee_cooldown = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/AttackingTarget() //7+1d6 vs con to knock ppl down
	. = ..()

	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS) //they can do it Once basically
			chomp_roll = STASTR + (rand(0,6))
			if(chomp_roll > C.STACON)
				C.Knockdown(20)
				C.visible_message(
					span_danger("\The [src] chomps \the [C]'s legs, knocking them down!"),
					span_danger("\The [src] tugs me to the ground! I'm winded!")
				)
				C.adjustOxyLoss(10) //less punishing than zfall bc simplemob
				C.emote("gasp")
				playsound(C, 'sound/foley/zfall.ogg', 100, FALSE)
			else
				C.visible_message(span_danger("\The [src] fails to drag \the [C] down!"))
			chomp_cd = world.time //this goes here i think? ...sure


/obj/effect/decal/remains/wolf
	name = "remains"
	desc = "Whether by starvation, disease, inter-pack conflict, or an unlucky kick from a saiga, this volf has died."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/volf.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/Initialize(mapload)
	. = ..()
	if(ai_controller) // TA EDIT START
		AddComponent(/datum/component/ai_aggro_system)
		AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.4)
	if(!fixed_gender)
		gender = prob(33) ? FEMALE : MALE
	if(gender == FEMALE && !adult_growth)
		childtype = list(
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup = 67,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/female = 33,
		)
	else
		childtype = null // TA EDIT END
	update_icon()
	if(ai_controller) // TA EDIT
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type) // TA EDIT
	var/color = pick("brown", "black", "white")
	icon_state = "volf_[color]"
	icon_living = "volf_[color]"
	icon_dead = "volf_[color]_dead"

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/male // TA EDIT START
	fixed_gender = TRUE
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/female
	fixed_gender = TRUE
	gender = FEMALE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup
	name = "volf pup"
	desc = "A young volf, not yet grown into its full strength."
	fixed_gender = TRUE
	gender = MALE
	animal_species = null
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/male
	health = WOLF_HEALTH / 2
	maxHealth = WOLF_HEALTH / 2
	melee_damage_lower = round(19 / 2)
	melee_damage_upper = round(29 / 2)
	STACON = 4
	STASTR = 3
	STASPD = 9
	mob_size = MOB_SIZE_SMALL
	aggressive = 0
	del_on_deaggro = 0
	ai_controller = null
	can_receive_livestock_commands = FALSE
	tame_food_type = list(/obj/item/reagent_containers/food/snacks/rogue/meat)
	tame_chance = 15
	bonus_tame_chance = 10

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/Retaliate()
	return 0

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/GiveTarget(new_target)
	return 0

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/Initialize(mapload)
	. = ..()
	var/matrix/pup_scale = matrix()
	pup_scale.Scale(0.7, 0.7)
	transform = pup_scale

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/female
	gender = FEMALE
	adult_growth = /mob/living/simple_animal/hostile/retaliate/rogue/wolf/female

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/wild
	fixed_gender = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/wild/Initialize(mapload)
	. = ..()
	adult_growth = gender == FEMALE ? /mob/living/simple_animal/hostile/retaliate/rogue/wolf/female : /mob/living/simple_animal/hostile/retaliate/rogue/wolf/male
	roll_initial_genetics()

/proc/get_wolf_family_types()
	return list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/female,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/wild,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/wild,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/pup/wild,
	) // TA EDIT END

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/tamed(mob/user) // TA EDIT START
	clear_enemies()
	LoseTarget()
	return ..(user) // TA EDIT END

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/death(gibbed)
	..()
	update_icon()
	if(!QDELETED(src))
		AddComponent(/datum/component/deadite_animal_reanimation)

/* Eyes that glow in the dark. They float over kybraxor pits at the moment.
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		var/mutable_appearance/eye_lights = mutable_appearance(icon, "vve")
		eye_lights.plane = 19
		eye_lights.layer = 19
		add_overlay(eye_lights)*/

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/taunted(mob/user)
	emote("aggro")
	Retaliate()
	GiveTarget(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)


/datum/intent/simple/bite/volf
	clickcd = WOLF_ATTACK_SPEED
