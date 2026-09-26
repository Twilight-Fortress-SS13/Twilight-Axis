/datum/reagent/organpoison
	name = "Organ Poison"
	description = ""
	reagent_state = LIQUID
	color = "#2c1818"
	taste_description = "sour meat"
	scent_description = "rancid meat"
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	harmful = TRUE

/datum/reagent/organpoison/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.reagents.add_reagent(/datum/reagent/medicine/manapot, 1)
		if(M.patron.type == /datum/patron/inhumen/graggar)
			var/mob/living/carbon/human/H = M
			H.reagents.add_reagent(/datum/reagent/medicine/stampot, 1)
			H.devotion?.update_devotion(5)
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(9)
		M.adjustToxLoss(2)
	return ..()
