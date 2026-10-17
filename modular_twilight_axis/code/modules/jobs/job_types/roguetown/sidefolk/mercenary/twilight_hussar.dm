/datum/advclass/mercenary/twilight_hussar
	name = "Aavnic Hussar"
	tutorial = "An eternal glory, a proud name of winged hussar, a noble cause... This is all that remains in the past. Whether after a miserable defeat, fabricated treason, or a dishonorable discharge, you have been cast out from your homeland. But you are not one to give up. You have taken up the life of a mercenary, and now you seek to reclaim your honor and your place in the world."
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_hussar
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	maximum_possible_slots = 2
	class_select_category = CLASS_CAT_AAVNR
	subclass_languages = list(/datum/language/aavnic)
	cmode_music = sound("modular_twilight_axis/sound/music/combat_hussar.ogg")

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_WIL = 4,
		STATKEY_PER = 2,
		STATKEY_CON = 1, // who are you without your wings???
		STATKEY_SPD = -2 // use your mount
	) // 8 points statblock cuz of great armor

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN // Expert since +1 FROM VIRTUE!!!!
	)

/datum/outfit/job/roguetown/mercenary/twilight_hussar/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/lepoardcloak
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	armor = /obj/item/clothing/suit/roguetown/armor/plate/hussar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	l_hand = /obj/item/rogueweapon/sword/sabre
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
	)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	if(H.mind)
		var/weapons = list("Lance", "Pike")
		var/weapon_choice = input(H, "Choose your weapon.", "LET YOUR HANDS SPEAK BEFORE YOUR MOUTH.") as anything in weapons
		switch(weapon_choice)
			if ("Lance")
				r_hand = /obj/item/rogueweapon/spear/lance
			if ("Pike")
				r_hand = /obj/item/rogueweapon/spear/boar/frei/pike
