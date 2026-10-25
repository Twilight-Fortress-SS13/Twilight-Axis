/datum/advclass/vagabond_gassenratte
	name = "Gassenratte"
	tutorial = "A nameless vagabond, cloaked in filth and tattered rags. A creature of the gutters, hardened by hunger, betrayal, and the cruelty of the streets. He wanders the shadows of the city, owing nothing to anyone but fate itself."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/vagabond/runner
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_CIVILIZEDBARBARIAN, TRAIT_NOSTINK)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_LCK = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/vagabond/runner/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
