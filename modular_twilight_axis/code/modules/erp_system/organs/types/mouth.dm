#define MOUTH_MAX_UNITS 10

/datum/erp_sex_organ/mouth
	erp_organ_type = SEX_ORGAN_MOUTH
	active_arousal = 0.9
	passive_arousal = 1.0
	active_pain = 0.05
	passive_pain = 0.15

/datum/erp_sex_organ/mouth/New(atom/host_atom)
	. = ..()
	host = host_atom
	storage = new(MOUTH_MAX_UNITS, src)

/datum/erp_sex_organ/mouth/proc/has_liquid()
	return storage && storage.total_volume() > 0

/datum/erp_sex_organ/mouth/receive_reagents(datum/reagents/R, amount)
	var/added = ..()
	if(!added)
		return 0

	var/mob/living/carbon/human/H = get_owner()
	if(!istype(H))
		return added

	var/milk_amt = storage.reagents.get_reagent_amount(/datum/reagent/consumable/milk/erp)
	if(milk_amt > 0)
		storage.reagents.remove_reagent(/datum/reagent/consumable/milk/erp, milk_amt)
		H.reagents.add_reagent(/datum/reagent/consumable/milk/erp, milk_amt)

	if(has_liquid())
		if(!H.has_status_effect(/datum/status_effect/mouth_full))
			H.apply_status_effect(/datum/status_effect/mouth_full)
	else
		H.remove_status_effect(/datum/status_effect/mouth_full)

	return added

/datum/erp_sex_organ/mouth/proc/swallow(amount = 5)
	if(!storage || storage.total_volume() <= 0)
		return FALSE

	var/to_take = min(amount, storage.total_volume())
	var/datum/reagents/R = storage.inject(to_take)
	if(!R || R.total_volume <= 0)
		return FALSE

	var/mob/living/carbon/human/H = get_owner()
	if(istype(H))
		R.trans_to(H.reagents, R.total_volume)

	if(istype(H) && !has_liquid())
		H.remove_status_effect(/datum/status_effect/mouth_full)

	H.visible_message(span_notice("[H] сглатывает."), span_notice("Я проглатываю семя во рту."))
	return TRUE

/datum/erp_sex_organ/mouth/proc/spit(amount = 5)
	if(!storage || storage.total_volume() <= 0)
		return FALSE

	var/to_take = min(amount, storage.total_volume())
	var/datum/reagents/R = storage.inject(to_take)
	if(!R || R.total_volume <= 0)
		if(R) qdel(R)
		return FALSE

	drop_to_ground(R)
	qdel(R)

	var/mob/living/carbon/human/H = get_owner()
	if(istype(H) && !has_liquid())
		H.remove_status_effect(/datum/status_effect/mouth_full)

	H.visible_message(span_notice("[H] сплевывает."), span_notice("Я сплевываю семя из рта."))
	return TRUE

/obj/item/bodypart/head/Initialize()
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/erp_sex_organ/mouth(src)

#undef MOUTH_MAX_UNITS
