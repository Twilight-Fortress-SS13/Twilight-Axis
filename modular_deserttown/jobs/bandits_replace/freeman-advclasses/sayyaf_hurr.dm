/datum/advclass/sayyaf_hurr
	name = "Sayyaf-Hurr"
	tutorial = "«... Сайяф-Хурр, так назвали его пустынники, мечник опьянённый свободой и волей ...»"
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/freeman/sayyaf_hurr
	category_tags = list(CTAG_FREEMAN)
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding)

/datum/outfit/job/roguetown/freeman/sayyaf_hurr/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	armor = /obj/item/clothing/suit/roguetown/armor/plate/raneshen_scale
	cloak = /obj/item/clothing/cloak/dunestalker
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/mattcoin
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					)
	id = /obj/item/mattcoin
	H.adjust_blindness(-3)
	var/weapons = list("Heavy Scimitar & Shield","Greatsword")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Heavy Scimitar & Shield")
				backl= /obj/item/rogueweapon/shield/iron/zybantine
				beltr = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine
			if("Greatsword")
				r_hand = /obj/item/rogueweapon/greatsword
				backl = /obj/item/rogueweapon/scabbard/gwstrap
