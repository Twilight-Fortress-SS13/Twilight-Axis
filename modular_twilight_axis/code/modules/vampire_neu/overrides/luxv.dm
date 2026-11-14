/datum/reagent/vitae
	metabolization_rate = 1

/datum/reagent/vitae/on_mob_life(mob/living/carbon/M)
	..()
	if(HAS_TRAIT(M, TRAIT_VAMPBITE))
		M.adjust_bloodpool(150)

/datum/reagent/impure_vitae
	metabolization_rate = 1

/datum/reagent/impure_vitae/on_mob_life(mob/living/carbon/M)
	..()
	if(HAS_TRAIT(M, TRAIT_VAMPBITE))
		M.adjust_bloodpool(75)
