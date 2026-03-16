/datum/job/roguetown/adventurer/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/cleric/vigilant,
		/datum/advclass/rogue/soundbreaker,
		/datum/advclass/foreigner/ronin,
		/datum/advclass/ranger/twilight_hunter,
		/datum/advclass/foreigner/gronnadv
	)
	. = ..()