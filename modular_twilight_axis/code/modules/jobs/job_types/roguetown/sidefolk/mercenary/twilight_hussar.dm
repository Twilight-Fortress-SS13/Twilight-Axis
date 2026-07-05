/datum/advclass/mercenary/twilight_hussar
	name = "Aavnic Hussar"
	tutorial = "An eternal glory, a proud name of winged hussar, a noble cause... This is all that remains in the past. Whether after a miserable defeat, fabricated treason, or a dishonorable discharge, you have been cast out from your homeland. But you are not one to give up. You have taken up the life of a mercenary, and now you seek to reclaim your honor and your place in the world."
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_hussar
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_MERCENARY)
	maximum_possible_slots = 2
	class_select_category = CLASS_CAT_AAVNR
	subclass_languages = list(/datum/language/aavnic)
	cmode_music = 'modular_twilight_axis/sound/music/combat_hussar.ogg'

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
		var/weapon_choice = input("Choose your weapon.", "LET YOUR HANDS SPEAK BEFORE YOUR MOUTH.") as anything in weapons
		switch(weapon_choice)
			if ("Lance")
				r_hand = /obj/item/rogueweapon/spear/lance
			if ("Pike")
				r_hand = /obj/item/rogueweapon/spear/boar/frei/pike


/obj/item/clothing/suit/roguetown/armor/plate/hussar
	name = "hussar's plate harness"
	desc = "An ornate suit of plate armour made with Aavnr's finest Vyšvou steel, meant to be used by the Potentate's elite cavalry. A frame is attached to the back of the cuirass, and raptor feathers create the illusion of an angel's wings."
	icon_state = "hussar"
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/armor.dmi'
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	equip_delay_other = 2 SECONDS
	strip_delay = 4 SECONDS
	smelt_bar_num = 2
	boobed = FALSE
	worn_x_dimension = 32
	worn_y_dimension = 36
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	name = "hussar's steel szyszak"
	desc = "A brand new kind of helmet based on Ranesheni çiçeks, fitted with a sliding nasal protector, cheekpieces, and a neck guard. This ornate szyszak was made from high-quality Vyšvou steel, clearly intended for the Potentate's own cavalrymen."
	body_parts_covered = HEAD|EARS|HAIR|NECK|NOSE //Notice how it doesn't protect eyes!!!
	max_integrity = ARMOR_INT_HELMET_STEEL
	icon_state = "hussarhelm"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'

/obj/item/clothing/cloak/lepoardcloak
	name = "leopard pelt cloak"
	desc = "This regal cloak is made from the pelt of an Etruscan Leopard. It's worn by soldiers of great prestige and renown."
	icon_state = "lepoardcape"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	salvage_result = /obj/item/natural/fur
	allowed_race = NON_DWARVEN_RACE_TYPES
	salvage_amount = 3
	cold_protection = 20
