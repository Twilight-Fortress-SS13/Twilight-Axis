/datum/job/roguetown/thief_guild_master
	title = "Nachtfuchs"
	flag = THIEFGUILDMASTER
	department_flag = THIEFGUILD
	faction = "Station" // what
	total_positions = 1
	spawn_positions = 1
	min_pq = 10
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	allowed_sexes = list(MALE, FEMALE)
	display_order = JDO_THIEFGUILDMASTER
	selection_color = JCOLOR_ANTAGONIST
	outfit = /datum/outfit/job/roguetown/thief_guild_master
	give_bank_account = FALSE
	same_job_respawn_delay = 30 MINUTES
	job_traits = list(TRAIT_DODGEEXPERT, TRAIT_SEEPRICES, TRAIT_LIGHT_STEP)

/datum/advclass/thief_guild_master
	name = "Nachtfuchs"
	tutorial = "Guildmaster of Thieves. \
		The master of the criminal underworld, whose power stems from the Lower City. \
		His hideout lies hidden among the slums, where mercenaries, beggars, and smugglers know his name better than the city guards. \
		He earned his seat on the Council neither by right nor by favor. \
		Blackmail, bribery, vanished witnesses, and deals best left unspoken paved his way to the top. \
		Now his influence reaches far beyond the slums, and the secrets he possesses make even the most noble think twice in his presence. \
		Though he is the head of the guild, his position can be claimed by anyone within his circle. \
		Even among his own, he can never afford to let his guard down."

	category_tags = list(CTAG_STEWARD)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 3,
		STATKEY_WIL = 3,
		STATKEY_LCK = 4
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER
	)

/datum/outfit/job/roguetown/thief_guild_master/pre_equip(mob/living/carbon/human/H, visualsOnly)
	suit = /obj/item/clothing/suit/roguetown/armor/leather/studded
	mask = /obj/item/clothing/mask/rogue/facemask/padded
	undershirt = /obj/item/clothing/under/roguetown/heavy_leather_pants
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	l_hand = /obj/item/grapplinghook
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded,
		/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison,
		/obj/item/storage/keyring,

	)

/obj/item/storage/keyring/acolyte
	keys = list(/obj/item/roguekey/mercenary, /obj/item/roguekey/bathworker, /obj/item/roguekey/bathmaster)
