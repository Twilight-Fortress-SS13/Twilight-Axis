/datum/job/roguetown/slavemaster
	title = "Slave Master"
	flag = SLAVEMASTER
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_GUARDSMAN, TRAIT_MEDIUMARMOR, TRAIT_XENOPHOBIC, TRAIT_NOBLE)
	advclass_cat_rolls = list(CTAG_SLAVEMASTER = 2)

	tutorial = "Твоя рука карает кнутом, дабы держать чернь в узде, и лишь твоя воля заставляет ленивых рабов трудиться на благо Султана. \
        В цитадели тебе отведены богатые покои, но твой истинный дом — это невольничий рынок и зиндан. \
        Ты ловишь беглых абдов, принуждаешь к труду нерадивых и следишь, чтобы ни один прикованный не помышлял о свободе. \
        Проверяй зинданы: там всегда найдутся те, кого стоит заставить отрабатывать свой долг."

	announce_latejoin = FALSE
	outfit = /datum/outfit/job/roguetown/slavemaster
	give_bank_account = 25
	min_pq = 10
	max_pq = null
	round_contrib_points = 2
	cmode_music = 'sound/music/combat_zybantine.ogg'
	spells = list(/obj/effect/proc_holder/spell/self/convertrole/slave)
	job_subclasses = list(
		/datum/advclass/slavemaster
	)
	same_job_respawn_delay = 30 MINUTES

/datum/job/roguetown/slavemaster/New()
	. = ..()
	peopleknowme = list()
	for(var/X in GLOB.garrison_positions)
		peopleknowme += X
	for(var/X in GLOB.noble_positions)
		peopleknowme += X
	for(var/X in GLOB.courtier_positions)
		peopleknowme += X

/datum/job/roguetown/slavemaster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.advsetup = 1
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		var/index = findtext(H.real_name, " ")
		if(index)
			index = copytext(H.real_name, 1,index)
		if(!index)
			index = H.real_name
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Nazir"
		if(H.gender == FEMALE)
			honorary = "Nazirah"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

/datum/outfit/job/roguetown/slavemaster
	job_bitflag = BITFLAG_GARRISON

/datum/advclass/slavemaster
	name = "Slavemaster"
	tutorial = "Твоя рука карает кнутом, дабы держать чернь в узде, и лишь твоя воля заставляет ленивых рабов трудиться на благо Султана. \
        В цитадели тебе отведены богатые покои, но твой истинный дом — это невольничий рынок и зиндан. \
        Ты ловишь беглых абдов, принуждаешь к труду нерадивых и следишь, чтобы ни один прикованный не помышлял о свободе. \
        Проверяй зинданы: там всегда найдутся те, кого стоит заставить отрабатывать свой долг."
	outfit = /datum/outfit/job/roguetown/slavemaster/base

	category_tags = list(CTAG_SLAVEMASTER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,//slave chasin'
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,//slave whippin
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //slave wranglin
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT, //slave beatin
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//Enough for majority of surgeries without grinding.
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN, //slave chasin'
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN, //slave detection
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/slavemaster/base/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt =  /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backl = /obj/item/storage/backpack/rogue/backpack
	beltr = /obj/item/rogueweapon/whip/antique
	beltl = /obj/item/storage/keyring/slavemaster
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(/obj/item/flashlight/flare/torch/lantern, /obj/item/reagent_containers/glass/bottle/rogue/healthpot = 2, /obj/item/rope/chain = 1, /obj/item/flint = 1, /obj/item/clothing/neck/roguetown/collar/leather = 2, /obj/item/clothing/neck/roguetown/psicross/silver = 1)
