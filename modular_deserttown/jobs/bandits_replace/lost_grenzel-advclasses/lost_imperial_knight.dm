/datum/advclass/lost_grenzel/lost_imperial_knight
	name = "Lost Imperial Knight"
	tutorial = "В прежней армии вы были офицером, возглавшявшим небольшое подразделение. Но вас разбили... Ваша сила и ваши навыки позволили сплотить вокруг себя небольшую банду."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/lost_grenzel/lost_imperial_knight
	subclass_languages = list(/datum/language/grenzelhoftian)
	category_tags = list(CTAG_LOSTGRENZEL)
	maximum_possible_slots = 1
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_BADTRAINER)
	subclass_stats = list(
		STATKEY_CON = 4,
		STATKEY_STR = 3,
		STATKEY_WIL = 4,
		STATKEY_LCK = 3,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
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

/datum/outfit/job/roguetown/lost_grenzel/lost_imperial_knight/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/grenzelhoft
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	cloak = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft
	armor = /obj/item/clothing/suit/roguetown/armor/plate/blacksteel/modern
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backr = /obj/item/storage/backpack/rogue/satchel/black
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
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)
		if("Polemace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_MASTER, TRUE)
		if("Poleaxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/knight
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_MASTER, TRUE)
		if("Polehammer")
			r_hand = /obj/item/rogueweapon/eaglebeak
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_MASTER, TRUE)
