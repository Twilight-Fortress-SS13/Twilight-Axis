/datum/quirk/noble
	greater = FALSE
	mechdesc = "Grants noble status and a title without an active estate."
	restricted_virtues = list(/datum/virtue/utility/noble)

/datum/quirk/noble/handle_traits(mob/living/carbon/human/recipient)
	..()
	// An innate court title takes precedence over the landless background.
	if(!isnull(recipient.taRoleNobilityTier()))
		REMOVE_TRAIT(recipient, TRAIT_NOBLE_UNLANDED, TRAIT_QUIRK)
