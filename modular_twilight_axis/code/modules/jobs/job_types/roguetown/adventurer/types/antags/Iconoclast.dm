/mob/living/carbon/human
	var/tmp/ta_is_golden_serpent = FALSE

/datum/advclass/iconoclast
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
		TRAIT_RITUALIST,
	)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 3,
		STATKEY_LCK = 2,
	)

	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/advclass/iconoclast/post_equip(mob/living/carbon/human/human)
	. = ..()

	// The outfit records the path before class skills are applied.
	if(human.ta_is_golden_serpent)
		ADD_TRAIT(
			human,
			TRAIT_CYCLOPS_RIGHT,
			ADVENTURER_TRAIT,
		)
		ADD_TRAIT(
			human,
			TRAIT_IGNOREDAMAGESLOWDOWN,
			ADVENTURER_TRAIT,
		)
		ADD_TRAIT(
			human,
			TRAIT_NOPAINSTUN,
			ADVENTURER_TRAIT,
		)

		human.adjust_skillrank_up_to(
			/datum/skill/combat/unarmed,
			SKILL_LEVEL_LEGENDARY,
			TRUE,
		)
		human.adjust_skillrank_up_to(
			/datum/skill/combat/wrestling,
			SKILL_LEVEL_LEGENDARY,
			TRUE,
		)

		human.change_stat(STATKEY_CON, 2)
		human.change_stat(STATKEY_LCK, -2)
		return

	ADD_TRAIT(
		human,
		TRAIT_HEAVYARMOR,
		ADVENTURER_TRAIT,
	)

	human.adjust_skillrank_up_to(
		/datum/skill/combat/whipsflails,
		SKILL_LEVEL_MASTER,
		TRUE,
	)
	human.adjust_skillrank_up_to(
		/datum/skill/combat/shields,
		SKILL_LEVEL_JOURNEYMAN,
		TRUE,
	)
	human.adjust_skillrank_up_to(
		/datum/skill/combat/staves,
		SKILL_LEVEL_EXPERT,
		TRUE,
	)
	human.adjust_skillrank_up_to(
		/datum/skill/combat/unarmed,
		SKILL_LEVEL_MASTER,
		TRUE,
	)
	human.adjust_skillrank_up_to(
		/datum/skill/combat/wrestling,
		SKILL_LEVEL_EXPERT,
		TRUE,
	)

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(
	mob/living/carbon/human/human,
)
	..()

	if(!istype(human.patron, /datum/patron/inhumen/matthios))
		var/matthios_message = "Matthios embraces me.."
		matthios_message += " I must uphold his creed."
		matthios_message += " I am his light in the
