/datum/component/armour_filtering/trait_boon_equip(mob/living/carbon/human/user, id)
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(positive)
			user.remove_status_effect(/datum/status_effect/debuff/lost_drow_inq_mask)
			user.remove_stress(/datum/stressevent/lost_drow_inq_mask)
	. = ..()

/datum/component/armour_filtering/trait_boon_drop(mob/living/carbon/human/user, id)
	if(HAS_TRAIT(user, TRAIT_INQUISITION) && isdarkelf(user))
		if(positive)
			if(user.has_status_effect(/datum/status_effect/debuff/lost_drow_inq_mask))
				return
			if(user.has_stress_event(/datum/stressevent/lost_drow_inq_mask))
				return
			user.apply_status_effect(/datum/status_effect/debuff/lost_drow_inq_mask)
			user.add_stress(/datum/stressevent/lost_drow_inq_mask)

	. = ..()
