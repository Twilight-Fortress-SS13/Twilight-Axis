/mob/living/carbon/human
	var/trophy_rage_duration_bonus = 0
	var/trophy_rage_cooldown_mult = 1

/mob/living/carbon/human/proc/get_trophy_rage_duration_bonus()
	return trophy_rage_duration_bonus

/mob/living/carbon/human/proc/get_trophy_rage_cooldown_mult()
	return trophy_rage_cooldown_mult

/mob/living/carbon/human/proc/get_trophy_armor_bonus_for_zone(def_zone, d_type)
	var/datum/component/trophy_hunter/trophy_hunter = GetComponent(/datum/component/trophy_hunter)
	if(!trophy_hunter)
		return 0

	return trophy_hunter.get_armor_bonus_for_zone(def_zone, d_type)
