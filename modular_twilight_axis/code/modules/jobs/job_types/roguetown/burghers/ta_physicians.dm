/datum/job/roguetown/physician/New()
	job_traits += list(TRAIT_STEELHEARTED)
	. = ..()

/datum/job/roguetown/apothecary/New()
	job_traits += list(TRAIT_STEELHEARTED)
	. = ..()

/datum/advclass/barbersurgeon/New()
	traits_applied += list(TRAIT_STEELHEARTED)
	. = ..()
