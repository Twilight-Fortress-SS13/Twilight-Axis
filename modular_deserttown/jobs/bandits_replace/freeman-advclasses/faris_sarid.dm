/datum/advclass/faris_sarid
	name = "Fāris-šārid"// Что означает "Фарис-изгой"
	tutorial = "«... Так возникли Фа́рисы - каста стальных защитников, чей долг - быть оплотом чести и силы, когда вера других слабеет ...»"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/freeman/faris_sarid
	category_tags = list(CTAG_FREEMAN)
	maximum_possible_slots = 2
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE)
	subclass_stats = list(
		STATKEY_CON = 3, 
		STATKEY_STR = 2,
		STATKEY_WIL = 3,
		STATKEY_LCK = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,		
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding)

/datum/outfit/job/roguetown/freeman/faris_sarid/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/cataphract
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/dunestalker
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	armor = /obj/item/clothing/suit/roguetown/armor/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/mattcoin
	backpack_contents = list(
					/obj/item/rogueweapon/huntingknife/idagger = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)

	H.adjust_blindness(-3)
	var/weapons = list("Flameberge", "Polemace", "Poleaxe", "Polehammer")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Flameberge")
			r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Polemace")
			beltr = /obj/item/rogueweapon/mace/goden/steel
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
		if("Poleaxe")
			beltr = /obj/item/rogueweapon/greataxe/steel/knight
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
		if("Polehammer")
			r_hand = /obj/item/rogueweapon/eaglebeak
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)			
		if("Lance + Scimitar")
			r_hand = /obj/item/rogueweapon/spear/lance
			backl = /obj/item/rogueweapon/scabbard/gwstrap				
			l_hand = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
			beltl = /obj/item/rogueweapon/scabbard/sword
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)

