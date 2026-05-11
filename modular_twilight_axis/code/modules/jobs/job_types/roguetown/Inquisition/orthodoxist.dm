/datum/job/roguetown/orthodoxist/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/blackpowder_legionnaire,
		/datum/advclass/naledimage
		)
	. = ..()