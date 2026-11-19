/datum/job/roguetown/orthodoxist/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/inq/blackpowder_legionnaire,
		/datum/advclass/psydonianwarscholar
		)
	. = ..()
