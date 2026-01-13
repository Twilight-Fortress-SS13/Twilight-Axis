/datum/sex_panel_action/other/penis/hemi
	abstract_type = TRUE
	stamina_cost = 0.4
	name = "Корневое действие гемипенисом"

/datum/sex_panel_action/other/penis/hemi/proc/has_hemi_penis(mob/living/carbon/human/human_object)
	if(!human_object)
		return FALSE

	var/obj/item/organ/penis/penis_organ = human_object.getorganslot(ORGAN_SLOT_PENIS)
	if(!penis_organ)
		return FALSE

	var/datum/sex_organ/penis/penis_object = penis_organ.sex_organ
	if(!penis_object)
		return FALSE
		
	return (penis_organ.penis_type == PENIS_TYPE_TAPERED_DOUBLE || penis_organ.penis_type == PENIS_TYPE_TAPERED_DOUBLE_KNOTTED)

/datum/sex_panel_action/other/penis/hemi/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE

	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/human_object = user
	if(!has_hemi_penis(human_object))
		return FALSE

	return TRUE
