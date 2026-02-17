// THE PLAGUE CURE REAGENT

/datum/reagent/medicine/plague_cure
	name = "Plague Cure"
	description = "A potent alchemical elixir that must be consumed before cauterization surgery to cure the Plague."
	reagent_state = LIQUID
	color = "#d4af37"
	taste_description = "bitter gold and iron"
	scent_description = "sour herbs and metal"
	metabolization_rate = 0.05 * REAGENTS_METABOLISM

/datum/reagent/medicine/plague_cure/on_mob_life(mob/living/carbon/M)
	// This reagent stays in the body, waiting to be consumed during surgery
	// It provides slight regeneration while present
	if(volume > 0.5)
		M.adjustBruteLoss(-0.5)
		M.adjustToxLoss(-0.5)
	..()
	. = 1
