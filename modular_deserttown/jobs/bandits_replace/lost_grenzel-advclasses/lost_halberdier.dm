/datum/advclass/lost_grenzel/lost_halberdier
	name = "Lost Halberdier"
	tutorial = "С детства вы отличались немалой силой и немалой выносливостью, быть может именно поэтому вы выжили в песках Зибантии? В Аль-Ашур вы прибываете как опытный владелец копья и алебарды. У вас почти нет снабжения - и единственное на что приходится рассчитывать, так это на грабёж местного населения."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/lost_grenzel/lost_halberdier
	category_tags = list(CTAG_LOSTGRENZEL)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/lost_grenzel/lost_halberdier/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You're an experienced soldier skilled in the use of polearms and axes. Your equals make up the bulk of the mercenary guild's forces."))
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel
	if(H.mind)
		var/weapons = list("Halberd", "Partizan")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/cloth/sash
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft 
	head = /obj/item/clothing/head/roguetown/roguehood/shalal
	cloak = /obj/item/clothing/cloak/cape/crusader
	pants = /obj/item/clothing/under/roguetown/chainlegs/grenzelhoft
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/blacksteel/modern
	mask = /obj/item/clothing/mask/rogue/ragmask
	gloves = /obj/item/clothing/gloves/roguetown/plate/blacksteel/modern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)