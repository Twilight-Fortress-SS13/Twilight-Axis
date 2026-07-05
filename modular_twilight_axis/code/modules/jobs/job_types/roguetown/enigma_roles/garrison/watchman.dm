/datum/job/roguetown/town_watch
	title = "Town Watch"
	flag = TOWNWATCH
	department_flag = CITYWATCH
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	forbidden_races = list(RACES_DESPISED)
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
	round_contrib_points = 2
	same_job_respawn_delay = 30 MINUTES
	cmode_music = 'modular_twilight_axis/sound/music/combat/combat_watchman.ogg'
	job_subclasses = list(
		/datum/advclass/town_watch,
		/datum/advclass/town_watch/dungeoneer,
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
		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
	H.verbs |= /mob/proc/haltyell

/obj/item/storage/backpack/rogue/satchel/citywatch
	name = "city watch satchel"
	color = "#586ed3e1"

/obj/item/storage/belt/rogue/leather/citywatch
	name = "city watch belt"
	color = "#60a0dbbb"

/datum/advclass/town_watch/dungeoneer
	name = "Dungeoneer"
	tutorial = "Покаяние, мерзкая склонность к садизму или извращённое понимание правосудия — что-то из этого привело вас к тому, чтобы надеть презренный капюшон палача.\
	\ Прихоти шерифа и знати — ваш закон; вы ведь не привыкли терзаться вопросами морали."
	outfit = /datum/outfit/job/roguetown/town_watch/dungeoneer
	maximum_possible_slots = 1
	category_tags = list(CTAG_TOWN_WATCH)
	traits_applied = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_JAILOR, TRAIT_CIVILIZEDBARBARIAN, TRAIT_CRITICAL_RESISTANCE, TRAIT_IGNOREDAMAGESLOWDOWN)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Branding Letters" = /obj/item/branding_letters,
		"Branding Iron" = /obj/item/branding_iron,
	)

/datum/outfit/job/roguetown/town_watch/dungeoneer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/menacing/executioner
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = /obj/item/clothing/head/roguetown/roguehood/black
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/bailiff
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	beltr = /obj/item/rogueweapon/whip/antique
	beltl = /obj/item/storage/keyring/dungeoneer
	backl = /obj/item/rogueweapon/sword/long/exe/cloth
	H.adjust_blindness(-3)
	if(H.mind)
		H.set_blindness(0)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
