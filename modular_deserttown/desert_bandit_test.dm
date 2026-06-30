// Test NPC preset for a desert bandit with lamia legs, matching bog deserter stats.

// --- BASE SWORDSMAN OUTFIT ---
/datum/outfit/job/roguetown/desert_bandit_test
	name = "Desert Bandit"

/datum/outfit/job/roguetown/desert_bandit_test/pre_equip(mob/living/carbon/human/H)
	..()
	H.eye_color = "000000"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle = "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"

	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	
	change_origin(H, /datum/virtue/origin/raneshen, "Desert native")

	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open/random
	head = /obj/item/clothing/head/roguetown/turban
	r_hand = /obj/item/rogueweapon/sword/iron
	l_hand = /obj/item/rogueweapon/shield/heater


// --- ARCHER OUTFIT ---
/datum/outfit/job/roguetown/desert_bandit_test/archer
	name = "Desert Bandit Archer"

/datum/outfit/job/roguetown/desert_bandit_test/archer/pre_equip(mob/living/carbon/human/H)
	..() // Inherit stats, origin, and standard clothes
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	l_hand = null
	beltl = /obj/item/quiver/arrows


// --- SPEARWOMAN OUTFIT ---
/datum/outfit/job/roguetown/desert_bandit_test/spear
	name = "Desert Bandit Spearwoman"

/datum/outfit/job/roguetown/desert_bandit_test/spear/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/spear
	l_hand = null


// --- DAGGER OUTFIT ---
/datum/outfit/job/roguetown/desert_bandit_test/dagger
	name = "Desert Bandit Rogue"

/datum/outfit/job/roguetown/desert_bandit_test/dagger/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel


// --- MOB DEFINITIONS ---

/mob/living/carbon/human/species/human/northern/desert_bandit_test
	gender = FEMALE
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_BANDITS)
	ambushable = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)
	var/outfit_type = /datum/outfit/job/roguetown/desert_bandit_test

// /mob/living/carbon/human/species/human/northern/desert_bandit_test/Initialize()
//	. = ..()
//	set_species(/datum/species/human/northern/southern_lamia)
//	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/desert_bandit_test/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Desert Bandit Test"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	
	// Add Lamia legs with a sandy color BEFORE equipping to avoid dropping weapons
	Taurize(/obj/item/bodypart/taur/lamia, "#e3c16f")
	
	equipOutfit(new outfit_type)
	
	update_hair()
	update_body()

	var/obj/item/bodypart/head/mob_head = get_bodypart(BODY_ZONE_HEAD)
	if(mob_head)
		mob_head.sellprice = HEAD_BOUNTY_DESERTER
	
	AddComponent(/datum/component/npc_death_line, null, 25)


// --- SUBTYPES ---

/mob/living/carbon/human/species/human/northern/desert_bandit_test/archer
	gender = FEMALE
	ai_controller = /datum/ai_controller/human_npc/archer
	outfit_type = /datum/outfit/job/roguetown/desert_bandit_test/archer

/mob/living/carbon/human/species/human/northern/desert_bandit_test/spear
	gender = FEMALE
	outfit_type = /datum/outfit/job/roguetown/desert_bandit_test/spear

/mob/living/carbon/human/species/human/northern/desert_bandit_test/dagger
	gender = FEMALE
	outfit_type = /datum/outfit/job/roguetown/desert_bandit_test/dagger
