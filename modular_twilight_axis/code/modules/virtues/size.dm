/datum/virtue/size/small
	name = "Small"
	desc = "I've always been smaller and weaker than the average person, folk have always called me a five-footer."
	ui_fa_icon = "compress"
	added_stats = list(STATKEY_STR = -1, STATKEY_CON = -1)
	custom_text = "Decreases your sprite size. -1 STR, -1 CON. Has no effect if you are already big (Giant virtue or the Big Guy trait from your class)."

/datum/virtue/size/small/apply_to_human(mob/living/carbon/human/recipient)
	if(HAS_TRAIT(recipient, TRAIT_BIGGUY))
		to_chat(recipient, span_notice("I'm too big to be small. The Small virtue has no effect."))
		return
	recipient.transform = recipient.transform.Scale(0.85, 0.85)
	recipient.transform = recipient.transform.Translate(0, -(0.15 * 16))
	recipient.update_transform()

/datum/virtue/size/small/handle_stats(mob/living/carbon/human/recipient)
	if(HAS_TRAIT(recipient, TRAIT_BIGGUY))
		return
	return ..()
