/datum/job/roguetown/wretch/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/wretch/twilight_corsair,
		/datum/advclass/wretch/lunacyembracer,
		/datum/advclass/wretch/gudsklor,
		/datum/advclass/wretch/thehero,
	)
	. = ..()
