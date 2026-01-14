/datum/sex_organ/penis
	organ_type = SEX_ORGAN_PENIS
	producing_reagent_id = /datum/reagent/erpjuice/cum
	producing_reagent_rate = 0
	injection_amount = 0
	stored_liquid_max = 0
	var/have_knot = FALSE

/datum/sex_organ/penis/New(obj/item/organ/penis/organ)
	. = ..()
	refresh_from_organ(organ)

/datum/sex_organ/penis/proc/refresh_from_organ(obj/item/organ/penis/organ)
	var/mob/living/carbon/human/owner = organ.owner
	if(!owner)
		return

	switch(organ.penis_type)
		if(PENIS_TYPE_KNOTTED, PENIS_TYPE_TAPERED, PENIS_TYPE_TAPERED_DOUBLE_KNOTTED, PENIS_TYPE_BARBED_KNOTTED)
			have_knot = TRUE
		else
			have_knot = FALSE

	if(have_knot && !owner.GetComponent(/datum/component/knotting))
		owner.AddComponent(/datum/component/knotting)

	var/datum/reagent/reagent_object = GLOB.chemical_reagents_list[producing_reagent_id]
	if(!reagent_object)
		return 

	var/obj/item/organ/testicles/testicles = owner.getorganslot(ORGAN_SLOT_TESTICLES)
	if(!testicles)
		return

	producing_reagent_rate = testicles.ball_size * 0.25
	stored_liquid_max = 12 + (3 * testicles.ball_size)

	if(stored_liquid)
		stored_liquid.maximum_volume = stored_liquid_max
	else
		stored_liquid = new(stored_liquid_max)

	injection_amount = organ.penis_size

	if(producing_reagent_id && producing_reagent_rate > 0 && stored_liquid)
		start_production_timer()
		stored_liquid.add_reagent(reagent_object.type, (stored_liquid_max/5))

/datum/sex_organ/penis/inject_liquid(obj/item/container = null, mob/living/carbon/human/preferred_holder = null, list/blocked_containers = list())
	if(!has_storage() || total_volume() <= 0)
		return ..(container, preferred_holder)

	var/mob/living/carbon/human/human_object = get_owner()

	var/ratio = PENIS_MIN_EJAC_FRACTION
	if(istype(human_object))
		if(human_object.has_flaw(/datum/charflaw/addiction/lovefiend))
			ratio -= 0.05
		if(istype(human_object.patron, /datum/patron/inhumen/baotha))
			ratio += 0.10

	ratio = clamp(ratio, 0.05, 0.75)

	var/current = total_volume()
	var/amount = round(current * ratio)
	if(amount <= 0)
		amount = 1

	var/old_injection = injection_amount
	injection_amount = amount

	var/moved = ..(container, preferred_holder, blocked_containers)

	injection_amount = old_injection
	return moved
