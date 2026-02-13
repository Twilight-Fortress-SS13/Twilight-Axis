// FLU CURE REAGENT

/datum/reagent/medicine/flu_cure
	name = "Flu Cure"
	description = "A herbal tonic that helps the body purge the illness."
	reagent_state = LIQUID
	color = "#7cbf6f"
	taste_description = "bitter herbs"
	scent_description = "crushed leaves"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/medicine/flu_cure/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		for(var/thing in M.diseases)
			var/datum/disease/D = thing
			if(istype(D, /datum/disease/flu) && prob(10))
				D.cure()
				to_chat(M, span_notice("I feel my fever begin to break."))
				break
	..()
	. = 1
