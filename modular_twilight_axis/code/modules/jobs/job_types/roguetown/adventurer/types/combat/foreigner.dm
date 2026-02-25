/datum/advclass/foreigner/gronnadv
	name = "Norsian Griddar"
	tutorial = "You leaved your community, by your hand or by other's decision, but it not matter now. You are trying to find new home or die like a true warrior of your land."
	outfit = /datum/outfit/job/roguetown/adventurer/gronnadv
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_STEELHEARTED)
	subclass_languages = list(/datum/language/gronnic)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)

	subclass_skills = list(

		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,		
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE		//all nomads have it

	)

/datum/outfit/job/roguetown/adventurer/gronnadv
	allowed_patrons = ALL_GRONNIC_PATRONS 

/datum/outfit/job/roguetown/adventurer/gronnadv/pre_equip(mob/living/carbon/human/H)
	..()

	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	neck = /obj/item/clothing/neck/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/sheath
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/handaxe/copper
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/stoneknife = 1,
		/obj/item/recipe_book/survival = 1
		)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special 

	H.dna.species.soundpack_m = new /datum/voicepack/male/evil()

