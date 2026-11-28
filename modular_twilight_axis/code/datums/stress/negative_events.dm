/datum/stressevent/soulchurnerheretic
	timer = 1 MINUTES
	stressadd = 35
	desc = span_red("The horrid wails of the dead call for relief!")

/datum/stressevent/proc/taNobleDomesticMultiplier(mob/living/user)
	if(!ishuman(user) || !(type in GLOB.ta_noble_domestic_stressors))
		return 1
	if(stressadd + ((stacks - 1) * stressadd_per_extra_stack) <= 0)
		return 1
	var/mob/living/carbon/human/noble = user
	return noble.taAppliedNobilityTier() >= 2 ? 1.25 : 1

/datum/stressevent/peckish/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/hungry/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/starving/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/drym/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/thirst/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/parched/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/sleepytime/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)

/datum/stressevent/sewertouched/get_stress(mob/living/user)
	return ..() * taNobleDomesticMultiplier(user)
