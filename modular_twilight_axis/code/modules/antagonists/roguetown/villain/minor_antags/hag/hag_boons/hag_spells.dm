// Spells
/datum/hag_boon/spell/rat_form
	name = "Boon of rat form"
	desc = "Allows bearer to transform into a small, smart rat..."
	spell_type = /obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	points = 30

/obj/effect/proc_holder/spell/self/wildshape/hag_rat_form
	name = "Rat Form"
	desc = "Turns yourself into a small rat!"
	invocation_type = "none"
	recharge_time = 10 SECONDS
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE
	ignore_cockblock = TRUE

	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/rat
	)
	disallowed_equipment_type = list(/obj/item/rogueweapon)

/mob/living/carbon/human/species/wildshape/rat
	name = "Rat"
	race = /datum/species/shaperat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = null
	wildshape_icon = 'icons/roguetown/mob/monster/rat.dmi'
	wildshape_icon_state = "srat"
	give_miracles = FALSE

/mob/living/carbon/human/species/wildshape/rat/gain_inherent_skills()
	. = ..()
	if(mind)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)

		STASTR = 1
		STACON = 1 // YOU GONNA DIE FROM ONE HIT, HA-HA-HA!!!
		STAWIL = 15
		STAPER = 14
		STASPD = 15
		STAINT = 12

		real_name = "rat"
		faction += "rats"

/datum/species/shaperat
	name = "rat"
	id = "shaperat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_STEELHEARTED,
		TRAIT_INFINITE_ENERGY,
		TRAIT_ORGAN_EATER,
		TRAIT_WILD_EATER,
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_DODGEEXPERT,
		TRAIT_CRITICAL_WEAKNESS
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shaperat/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg','sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg'), 80, TRUE, -1)

/datum/species/shaperat/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/roguetown/mob/monster/rat.dmi'
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.icon_state = "srat"
	human.update_damage_overlays()
	return TRUE

/datum/hag_boon/spell/roots_movement
	name = "Boon of roots moving"
	desc = "Allows bearer to move throught the roots to someone they know."
	spell_type = /obj/effect/proc_holder/spell/self/roots_movement
	points = 50

/obj/effect/proc_holder/spell/self/roots_movement
	name = "Movement of roots"
	desc = "Move through the roots to someone you know..."
	recharge_time = 10 MINUTES
	miracle = FALSE
	devotion_cost = 0
	clothes_req = FALSE
	human_req = FALSE

/obj/effect/proc_holder/spell/self/roots_movement/cast(list/targets, mob/user)
	var/mob/living/carbon/human/C = user
	var/list/possible = C.mind.known_people.Copy()
	if(!possible.len)
		to_chat(C, span_warning("I have no known livings."))
		revert_cast()
		return FALSE

	var/prompt = "Choose living being to move to..."
	var/target_name = tgui_input_list(C, prompt, "Roots Moving", sort_list(possible))

	var/mob/living/carbon/human/found_mob
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == target_name)
			found_mob = HL
			break

	if(!found_mob)
		revert_cast()
		return FALSE

	C.visible_message(span_yellow("[C]'s legs begin to cover in strange roots..."), \
							span_yellow("I starts to move to [found_mob.name]..."))
	if(!do_after(C, 10 SECONDS, TRUE, src))
		revert_cast()
		return FALSE

	C.adjust_blindness(2)
	C.forceMove(found_mob.loc)
	C.visible_message(span_yellow("[C]'s appears from the ground, covered in roots!"), \
							span_yellow("I moved throught the roots to [found_mob.name]."))

/datum/hag_boon/spell/blesscrop
	name = "Boon of bless crop"
	desc = "Allows bearer to bless crops as druid does."
	spell_type = /obj/effect/proc_holder/spell/targeted/blesscrop
	points = 50

/datum/hag_boon/spell/berserker_rage
	name = "Boon of berserker rage"
	desc = "Grants bearer a berkerker's rage, allowing it to become stronger."
	spell_type = /obj/effect/proc_holder/spell/self/rage
	points = 75
