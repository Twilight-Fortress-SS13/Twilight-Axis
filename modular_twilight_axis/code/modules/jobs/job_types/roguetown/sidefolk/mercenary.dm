/datum/job/roguetown/mercenary/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/mercenary/twilight_gunslinger,
		/datum/advclass/mercenary/twilight_heishi,
		/datum/advclass/mercenary/twilight_yohei,
		/datum/advclass/mercenary/twilight_miragefen_rogue,
		/datum/advclass/mercenary/twilight_conquistador
	)
	. = ..()