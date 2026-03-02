/datum/job/roguetown/bailiff
	title = "Bailiff"
	flag = BAILIFF
	department_flag = BURGHERS
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	job_traits = list(TRAIT_SEEPRICES)
	tutorial = "Вы - пристав, верный слуга мэра. Вы его глаза и уши, а если потребуется - крепкие руки и быстрые ноги."
	display_order = JDO_BAILIFF
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/bailiff
	advclass_cat_rolls = list(CTAG_BAILIFF = 6)

	give_bank_account = TRUE
	min_pq = 2
	max_pq = null
	round_contrib_points = 2
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'sound/music/combat_routier.ogg'
	job_subclasses = list(
		/datum/advclass/bailiff/bodyguard,
		/datum/advclass/bailiff/squealer,

	)

/datum/advclass/bailiff/bodyguard
	name = "Bailiff bodyguard"
	tutorial = "Вы ни много ни мало - но телохранитель. Защищая мэра, которому вы верны, как на улицах так и на разбирательствах... \
    Ваше прошлое, так или иначе, привело вас к этому положению: вы умеете обращаться с оружием, вы должны им обращаться, ведь власть Мэра порой обеспечивается силой, а не словом."
	outfit = /datum/outfit/job/roguetown/bailiff/bodyguard

	category_tags = list(CTAG_BAILIFF)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 2,
		STATKEY_CON = 3,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/bailiff/bodyguard
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/bailiff = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1
		)
/datum/outfit/job/roguetown/bailiff/bodyguard/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/bailiff
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/bailiff
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltl = /obj/item/rogueweapon/mace
	id = /obj/item/scomstone/bad
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/heater
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/datum/advclass/bailiff/squealer
	name = "Bailiff squealer"
	tutorial = "С детства Вы были странным ребёнком: Ваша внимательность часто приводила в замешательство окружающих Вас... \
... И теперь вы развили это в достаточной мере: многочисленные доносы и кляузы, написанные Вами, \
ясно свидетельствуют о ваших неслабых способностях видеть и слышать то, что обычный человек пропустит мимо ушей."
	outfit = /datum/outfit/job/roguetown/bailiff/squealer
	category_tags = list(CTAG_BAILIFF)
	traits_applied = list(TRAIT_KEENEARS, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/bailiff/squealer
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/bailiff = 1,
		/obj/item/lockpickring/mundane = 1
		)

/datum/outfit/job/roguetown/bailiff/squealer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/puritan
	cloak = /obj/item/clothing/cloak/eastcloak2
	armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/tights
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/scabbard/sheath
	id = /obj/item/scomstone/bad
	backl = /obj/item/storage/backpack/rogue/satchel
	SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/obj/item/clothing/head/roguetown/chaperon/greyscale/bailiff
	name = "chaperon hat"
	color = "#15266f"

/obj/item/clothing/suit/roguetown/shirt/undershirt/bailiff
	name = "Bodyguard shirt"
	color = "#15266f"
