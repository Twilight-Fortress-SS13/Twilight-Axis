/datum/advclass/mercenary/twilight_gunslinger
	name = "Dragoon"
	tutorial = "As gunpowder becomes more widespread accross Psydonia, so do the Gunslingers - those who earn their living through their skill with those advanced weapons. Having left the ranks of the Otavan militant orders, nowdays you count yourself as one of these fine gentlemen, travelling the land with but a gun in your hand."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_gunslinger
	maximum_possible_slots = 2
	min_pq = 25 // Все мерки в данный момент с 25 открываются
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_gunslinger.ogg'
	class_select_category = CLASS_CAT_OTAVA
	category_tags = list(CTAG_MERCENARY)
	subclass_languages = list(/datum/language/otavan)
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/outfit/job/roguetown/mercenary/twilight_gunslinger/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	if(H.mind)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/survival/paper_cartridge)
	beltl = /obj/item/quiver/twilight_bullet/paper/lead
	beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol/puffer
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	r_hand = /obj/item/rogueweapon/sword/short/falchion
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	head = /obj/item/clothing/head/roguetown/duelhat/gunslinger
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backpack_contents = list(/obj/item/roguekey/mercenary = 1, /obj/item/rogueweapon/huntingknife = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	backr = /obj/item/rogueweapon/scabbard/sword
	cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
	H.merctype = 10
