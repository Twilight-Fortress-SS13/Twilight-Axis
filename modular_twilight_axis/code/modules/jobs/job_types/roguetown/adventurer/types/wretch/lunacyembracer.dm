/datum/advclass/wretch/lunacyembracer
	name = "Lunacy Embracer"
	tutorial = "You have rejected and terrorized civilization in the name of nature. \
	You run wild under the moon, a terror to the townsfolk and a champion of Dendor's wild domain. \
	Clergy of Azuria assume you are a radical dendorite and rejected you, your connection with Treefather is weaken but you will serve him whatever it takes."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	min_pq = 30
	maximum_possible_slots = 2

	outfit = /datum/outfit/job/roguetown/wretch/lunacyembracer
	category_tags = list(CTAG_WRETCH)
	extra_context = "Minimum PQ Required: 30"
	subclass_languages = list(/datum/language/beast)

	traits_applied = list(
		TRAIT_NUDIST,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAIN,
		TRAIT_DODGEEXPERT,
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_STRONGBITE,
		TRAIT_LONGSTRIDER,
		TRAIT_WOODWALKER,
		TRAIT_NASTY_EATER,
		TRAIT_OUTDOORSMAN,
		TRAIT_HERESIARCH
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = -3,
		STATKEY_PER = -2
	)

/datum/outfit/job/roguetown/wretch/lunacyembracer/pre_equip(mob/living/carbon/human/H)
	H.set_patron(/datum/patron/divine/dendor)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)
	neck = /obj/item/clothing/neck/roguetown/psicross/dendor

	H.cmode_music = 'modular_twilight_axis/sound/music/combat_berserker.ogg'
	to_chat(H, span_danger("You have abandoned your humanity to run wild under the moon. The call of nature fills your soul!"))
	wretch_select_bounty(H)
