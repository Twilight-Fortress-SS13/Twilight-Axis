/datum/advclass/mercenary/seonjang
	name = "Ruma Seonjang"
	tutorial = "A Captain from a band of Kazengite foreigners. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed to avoid repercussion. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL)
	outfit = /datum/outfit/job/roguetown/mercenary/seonjang
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_HARDDISMEMBER, TRAIT_NOPAINSTUN, TRAIT_HONORBOUND)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	maximum_possible_slots = 1
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/seonjang/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
	beltl = /obj/item/rogueweapon/scabbard/sword/kazengun/gold
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		)
	H.adjust_blindness(-3)

	if(should_wear_masc_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/easttats
		head = /obj/item/clothing/head/roguetown/eaststrawhat
		cloak = /obj/item/clothing/cloak/eastcloak1
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
		gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
		armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
		H.change_stat(STATKEY_WIL, 1)
		H.change_stat(STATKEY_CON, 1) //to compensate for the permanent lack of armor
		H.dna.species.soundpack_m = new /datum/voicepack/male/evil()
	else if(should_wear_femme_clothes(H))
		head = /obj/item/clothing/head/roguetown/eaststrawhat
		armor = /obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe
		shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/easttats
		gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
		cloak = /obj/item/clothing/cloak/eastcloak1
	H.merctype = 9
