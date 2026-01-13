/datum/sex_organ/mouth
	organ_type = SEX_ORGAN_MOUTH
	stored_liquid_max = MOUTH_MAX_UNITS

/datum/sex_organ/mouth/proc/has_liquid()
	return stored_liquid && stored_liquid.total_volume > 0

/datum/sex_organ/mouth/process_org()
	..()

	var/mob/living/carbon/human/H = get_owner()
	if(!H) return

	if(has_liquid())
		if(!H.has_status_effect(/datum/status_effect/mouth_full))
			H.apply_status_effect(/datum/status_effect/mouth_full)
	else
		H.remove_status_effect(/datum/status_effect/mouth_full)
