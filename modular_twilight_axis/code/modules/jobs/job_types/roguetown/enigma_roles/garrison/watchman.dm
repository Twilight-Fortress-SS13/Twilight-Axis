/datum/job/roguetown/town_watch
	title = "Town Watch"
	flag = TOWNWATCH
	department_flag = CITYWATCH
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_races = RACES_TOLERATED_UP
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	display_order = JDO_TOWNWATCH
	tutorial = "Отвечая за безопасность города и соблюдение закона, вы ходите среди угнетенных, неся справедливость и боль. \
	Возможно, вы даже застали ПРОПАЖУ Барона и поспешное прибытие Короля с его свитой, что пришли на готовое и сразу же прибрали власть в городе. \
	Или же, вы слышали от ваших старых сослуживцев не самые лестные слова про Короля, ведь власть и авторитет Дозора заметно\
	уменьшились с Его прибытием.\
	Так или иначе, ваша верность принадлежит пропавшему Барону, ИСТИННОМУ владыке этого города, горожанам \
	а уже после Королю и его свите, что все еще не хочет выбираться со своей временной ставки. \
	Да и как защитит эта хваленная Королевская Гвардия жителей Рокхилла, сидя в замке, если не вы?"
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/town_watch
	advclass_cat_rolls = list(CTAG_TOWN_WATCH = 2)
	give_bank_account = TRUE
	min_pq = 6
	max_pq = null

	cmode_music = 'modular_twilight_axis/sound/music/combat/combat_watchman.ogg'
	job_subclasses = list(
		/datum/advclass/town_watch,
	)

/datum/job/roguetown/town_watch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.wear_armor, /obj/item/clothing/suit/roguetown/armor/plate/scale/townguard/sheriff))
			var/obj/item/clothing/S = H.wear_armor
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "watchman ([index]) armor"

/datum/advclass/town_watch
	name = "Town Watch"
	tutorial = "Отвечая за безопасность города и соблюдение закона, вы ходите среди угнетенных, неся справедливость и боль. \
	Возможно, вы даже застали ПРОПАЖУ Барона и поспешное прибытие Короля с его свитой, что пришли на готовое и сразу же прибрали власть в городе. \
	Или же, вы слышали от ваших старых сослуживцев не самые лестные слова про Короля, ведь власть и авторитет Дозора заметно\
	уменьшились с Его прибытием.\
	Так или иначе, ваша верность принадлежит пропавшему Барону, ИСТИННОМУ владыке этого города, горожанам \
	а уже после Королю и его свите, что все еще не хочет выбираться со своей временной ставки. \
	Да и как защитит эта хваленная Королевская Гвардия жителей Рокхилла, сидя в замке, если не вы?"

	category_tags = list(CTAG_TOWN_WATCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_GUARDSMAN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/town_watch
	job_bitflag = BITFLAG_CITYWATCH
	head = /obj/item/clothing/head/roguetown/helmet/heavy/citywatch
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/townguard
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/citywatch
	beltr = /obj/item/rogueweapon/mace/stunmace
	beltl = /obj/item/storage/keyring/watchman
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backr = /obj/item/storage/backpack/rogue/satchel/citywatch

/datum/outfit/job/roguetown/town_watch/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		backpack_contents = list(/obj/item/rogueweapon/huntingknife/idagger/steel = 1, /obj/item/rope/chain = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
	H.verbs |= /mob/proc/haltyell

/obj/item/storage/backpack/rogue/satchel/citywatch
	name = "city watch satchel"
	color = "#586ed3e1"

/obj/item/storage/belt/rogue/leather/citywatch
	name = "city watch belt"
	color = "#60a0dbbb"
