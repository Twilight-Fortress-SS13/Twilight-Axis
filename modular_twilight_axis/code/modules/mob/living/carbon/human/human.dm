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

/mob/living/carbon/human/proc/has_axedance()
	if(!mind)
		return FALSE

	for(var/obj/effect/proc_holder/spell/S in mind.spell_list)
		if(istype(S, /obj/effect/proc_holder/spell/self/axedance))
			return TRUE

	return FALSE
