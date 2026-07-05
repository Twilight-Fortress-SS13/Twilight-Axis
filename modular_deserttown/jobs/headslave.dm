/datum/job/roguetown/headslave
	title = "Head Slave"
	tutorial = "Вернейший раб, вернейший слуга, хранитель тайн и надёжный негласный советник - вы стоите безумно дорого, вы являетесь украшением своего Султана, вы являетесь украшением его дворца. В ваших руках находится ответственность за всех остальных рабов дворца, не посмейте подвести Султана."
	flag = HEADSLAVE
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	outfit = /datum/outfit/job/roguetown/headslave
	advclass_cat_rolls = list(CTAG_HEADSLAVE = 20)
	job_traits = list(TRAIT_SLAVE)
	forbidden_races = list(RACES_DESPISED)
	display_order = JDO_SENESCHAL
	give_bank_account = 30
	min_pq = 3
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_desert2.ogg'
	job_subclasses = list(
		/datum/advclass/headslave,
		/datum/advclass/headslave/headmaid,
		/datum/advclass/headslave/chiefbutler
	)
	spells = list(/obj/effect/proc_holder/spell/invoked/takeapprentice)

/datum/advclass/headslave
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND) // They have Expert Sewing
	category_tags = list(CTAG_HEADSLAVE)
	name = "Head Slave"
	tutorial = "Ваша преданность, послушание и незаурядный ум возвысили вас над остальными. Как главный раб, вы — доверенное лицо и невидимая опора дворца. Ваша задача — управлять прислугой и обеспечивать безупречный комфорт Господина, оставаясь при этом в тени."
	outfit = /datum/outfit/job/roguetown/headslave/headslave
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/headslave
	has_loadout = TRUE

//This applies to all headslave subclasses
/datum/outfit/job/roguetown/headslave/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.age == AGE_MIDDLEAGED)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)

/datum/outfit/job/roguetown/headslave/headslave/pre_equip(mob/living/carbon/human/H)
	..()
	backpack_contents = list(
		/obj/item/rogueweapon/whip = 1,
	)
	if(should_wear_femme_clothes(H))
		mask = /obj/item/clothing/mask/rogue/silkmask
		neck = /obj/item/clothing/neck/roguetown/collar/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/silkbra
		shoes = /obj/item/clothing/shoes/roguetown/anklets
		belt = /obj/item/storage/belt/rogue/leather/silkbelt
		armor = /obj/item/clothing/suit/roguetown/armor/silkcoat
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/dress/thawb/beige
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/open
		neck = /obj/item/clothing/neck/roguetown/collar
		pants = /obj/item/clothing/under/roguetown/trou/leathertights
		belt = /obj/item/storage/belt/rogue/leather/black
		shoes = /obj/item/clothing/shoes/roguetown/sandals

	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/keyring/seneschal
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad

/datum/advclass/headslave/headmaid
	name = "Head Maid"
	tutorial = "Ваша преданность, послушание и незаурядный ум возвысили вас над остальными. Как главный раб, вы — доверенное лицо и невидимая опора дворца. Ваша задача — управлять прислугой и обеспечивать безупречный комфорт Господина, оставаясь при этом в тени."
	outfit = /datum/outfit/job/roguetown/headslave/headmaid
	category_tags = list(CTAG_HEADSLAVE)
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/headslave/headmaid/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/black
	shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
	cloak = /obj/item/clothing/cloak/apron/waist
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/seneschal
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/scomstone/bad

/datum/advclass/headslave/chiefbutler
	name = "Chief Butler"
	tutorial = "Со временем вы всё больше и больше посвящали себе чему-то более возвышенному чем простое обслуживание Господина. Искусство быть дворецким, котором вы в совершенстве овладели, было встречено весьма отзывчиво со стороны вашего Господина."
	outfit = /datum/outfit/job/roguetown/headslave/chiefbutler
	category_tags = list(CTAG_HEADSLAVE)
	traits_applied = list(TRAIT_CICERONE, TRAIT_HOMESTEAD_EXPERT, TRAIT_SEWING_EXPERT, TRAIT_ROYALSERVANT, TRAIT_FOOD_STIPEND)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1, // Usual leadership carrot.
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/headslave/chiefbutler/pre_equip(mob/living/carbon/human/H)
	..() // They need a monocle.
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/seneschal
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
	id = /obj/item/scomstone/bad
