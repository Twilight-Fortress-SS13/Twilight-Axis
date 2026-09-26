/mob/living/carbon/human/verb/feign_impairment()
	set name = "Feign Impairment"
	set category = "IC"
	set desc = "Pretend to be impaired by deliberately slurring your speech."

	feigning_impairment = !feigning_impairment
	if(feigning_impairment)
		to_chat(src, span_notice("I begin to deliberately slur my speech."))
	else
		to_chat(src, span_notice("I stop feigning impairment."))
