/datum/virtue/origin/handle_traits(mob/living/carbon/human/recipient)
	if(recipient.mind)
		recipient.mind.ta_nobility_origin_type = type
	return ..()
