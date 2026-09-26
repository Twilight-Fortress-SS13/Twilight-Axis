/datum/erp_sex_organ/hand
	erp_organ_type = SEX_ORGAN_HANDS
	count_to_action = 2
	active_arousal = 0.7
	passive_arousal = 1.0
	active_pain = 0.01
	passive_pain = 0.05

/datum/erp_sex_organ/legs
	erp_organ_type = SEX_ORGAN_LEGS
	count_to_action = 2
	active_arousal = 0.7
	passive_arousal = 1.0
	active_pain = 0.01
	passive_pain = 0.1

/datum/erp_sex_organ/tail
	erp_organ_type = SEX_ORGAN_TAIL
	active_arousal = 0.7
	passive_arousal = 1.0
	active_pain = 0.01
	passive_pain = 0.01

/datum/erp_sex_organ/body
	erp_organ_type = SEX_ORGAN_BODY
	active_arousal = 0.8
	passive_arousal = 1.0
	active_pain = 0.01
	passive_pain = 0.02

/obj/item/organ/tail/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/tail(src)
