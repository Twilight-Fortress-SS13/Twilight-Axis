//Potions
/datum/reagent/medicine/viscera
	name = "Liquid Viscera"
	description = "Gradually regenerates all types of damage."
	reagent_state = LIQUID
	color = "#d05555"
	taste_description = "meat"
	scent_description = "meat"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	var/brut_mod = -0.70
	var/burn_mod = -0.70
	var/woundmod = 1
	var/bloodmod = 5
	var/toxinmod = -0.70

/datum/reagent/medicine/viscera/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/viscera, 2) //No overhealing.
	if(M.reagents.has_reagent(/datum/reagent/medicine/boil/calendula))
		brut_mod = -2.5
	if(M.reagents.has_reagent(/datum/reagent/medicine/boil/taraxacum))
		burn_mod = -2.5
	if(M.reagents.has_reagent(/datum/reagent/medicine/boil/leech))
		woundmod = 6
	if(M.reagents.has_reagent(/datum/reagent/medicine/boil/bonedust))
		bloodmod = 20
	if(M.reagents.has_reagent(/datum/reagent/medicine/boil/leaf))
		toxinmod = -2.5
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+bloodmod, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(woundmod)
	if(volume > 0.99)
		M.adjustBruteLoss(brut_mod  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(burn_mod  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustToxLoss(toxinmod  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-1.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.70  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -1 * REAGENTS_EFFECT_MULTIPLIER)
	..()

/datum/reagent/medicine/boil
	name = "Extract"
	description = ""
	reagent_state = LIQUID
	color = "#83817f"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM/2
	alpha = 173
	var/brut_mod = 0
	var/burn_mod = 0
	var/woundmod = 0
	var/bloodmod = 0
	var/toxinmod = 0

/datum/reagent/medicine/boil/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(src, 2) //No overhealing.

	if(M.reagents.has_reagent(/datum/reagent/medicine/viscera))
		brut_mod = 0
		burn_mod = 0
		woundmod = 0
		bloodmod = 0
		toxinmod = 0

	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+bloodmod, BLOOD_VOLUME_NORMAL)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(woundmod)
	if(volume > 0.99)
		M.adjustBruteLoss(brut_mod  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(burn_mod  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustToxLoss(toxinmod  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/medicine/boil/calendula
	name = "Сalendula Extract"
	color = "#e47a24"
	taste_description = "violence"
	scent_description = "violence"
	brut_mod = -2

/datum/reagent/medicine/boil/taraxacum
	name = "Taraxacum Extract"
	color = "#e3e342"
	taste_description = "cremation"
	scent_description = "cremation"
	burn_mod = -2

/datum/reagent/medicine/boil/leech
	name = "Leech Extract"
	color = "#5c4a86"
	taste_description = "fresh wound"
	scent_description = "fresh wound"
	woundmod = 5

/datum/reagent/medicine/boil/bonedust
	name = "Bone Extract"
	color = "#a18888"
	taste_description = "remains"
	scent_description = "remains"
	bloodmod = 20

/datum/reagent/medicine/boil/leaf
	name = "Leaf Extract"
	color = "#3f6239"
	taste_description = "poison"
	scent_description = "poison"
	toxinmod = -2