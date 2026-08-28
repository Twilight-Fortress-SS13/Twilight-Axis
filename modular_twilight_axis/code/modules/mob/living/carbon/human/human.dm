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

/mob/living/carbon/human/proc/update_keep_together()
	var/needs_keep_together = length(filter_data) || length(filters) || length(vis_contents) || alpha != initial(alpha)
	if(needs_keep_together)
		appearance_flags |= KEEP_TOGETHER
	else
		appearance_flags &= ~KEEP_TOGETHER

/mob/living/carbon/human/update_filters()
	if(length(filter_data))
		appearance_flags |= KEEP_TOGETHER
	. = ..()
	update_keep_together()

/mob/living/carbon/human/clear_filters()
	. = ..()
	update_keep_together()
