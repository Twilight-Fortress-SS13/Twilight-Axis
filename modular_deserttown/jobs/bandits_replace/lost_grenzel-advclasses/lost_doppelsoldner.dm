/datum/advclass/lost_grenzel/lost_doppelsoldner
	name = "Lost Doppelsoldner"
	tutorial = "В пустынях Зибантии вы приобрели бессмертные навыки выживания. Ваша тактика сражения с двуручным мечом не раз спасла вашу и товарищей жизни."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/lost_grenzel/lost_doppelsoldner
	category_tags = list(CTAG_LOSTGRENZEL)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 4,
		STATKEY_WIL = 4,
		STATKEY_STR = 3,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/lost_grenzel/lost_doppelsoldner/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a Doppelsoldner - \"Double-pay Mercenary\" - an experienced frontline swordsman trained by the Zenitstadt fencing guild."))
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	if(H.mind)
		var/weapons = list("Zweihander", "Kriegmesser & Buckler")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Zweihander")
				r_hand = /obj/item/rogueweapon/greatsword/grenz
			if("Kriegmesser & Buckler")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				l_hand = /obj/item/rogueweapon/shield/buckler
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	mask = /obj/item/clothing/mask/rogue/ragmask
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft
	cloak = /obj/item/clothing/cloak/tabard/stabard/crusader/bsteel
	head = /obj/item/clothing/head/roguetown/turban
	pants = /obj/item/clothing/under/roguetown/chainlegs/grenzelhoft
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)