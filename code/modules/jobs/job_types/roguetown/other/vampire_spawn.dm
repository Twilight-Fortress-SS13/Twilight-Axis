/datum/job/roguetown/vampire_spawn
	title = "Vampire Spawn"
	flag = VAMPIRE_SERVANT
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = ""

	outfit = /datum/outfit/job/roguetown/vampire_spawn
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE

	obsfuscated_job = TRUE //future coders if you ever ADD an antag-job that's not supposed to be immedately obvious like lich skele, please add these. Otherwise the job title will show on examine + actors menu.
	wanderer_examine = TRUE
	advjob_examine = TRUE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/job/roguetown/vampire_spawn/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	SSmapping.retainer.death_knights |= L.mind
	return ..()

/datum/advclass/vampire_spawn
	name = "Vampire Spawn"
	outfit = /datum/outfit/job/roguetown/vampire_spawn

	category_tags = list(CTAG_VAMPSPAWN)

	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vampire_spawn/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	var/list/possible_classes = list()
	for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_VAMPSPAWN])
		possible_classes += CHECKS

	var/datum/advclass/C = input(H.client, "What is my class?", "HOW DO YOU HERALD YOUR MASTER'S WILL?") as null|anything in possible_classes
	C.equipme(H)

	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 5, TRUE)

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	H.grant_language(/datum/language/common)