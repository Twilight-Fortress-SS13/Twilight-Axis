/datum/erp_injection_service
	var/datum/erp_controller/controller

/datum/erp_injection_service/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Finds nearby reagent container around center (hands, tile, adjacent).
/datum/erp_injection_service/proc/find_nearby_container(mob/living/carbon/human/H, turf/center)
	if(!istype(H) || !center)
		return null

	var/obj/item/I = H.get_active_held_item()
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C1 = I
		if(C1.reagents)
			return C1

	I = H.get_inactive_held_item()
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C2 = I
		if(C2.reagents)
			return C2

	for(var/obj/item/reagent_containers/C3 in center)
		if(C3.reagents)
			return C3

	for(var/turf/T in orange(1, center))
		if(T == center)
			continue
		for(var/obj/item/reagent_containers/C4 in T)
			if(C4.reagents)
				return C4

	return null

/// Routes extracted reagents based on target mode.
/datum/erp_injection_service/proc/handle_inject(datum/erp_sex_link/link, datum/erp_sex_organ/source, target_mode, mob/living/carbon/human/who = null)
	if(!link || !source || QDELETED(source))
		return

	var/amount = 5
	var/datum/reagents/R = source.extract_reagents(amount)
	if(!R)
		return

	var/inject_mode = target_mode
	if(who && who == link.actor_active?.physical)
		if(link.climax_target == "outside" && source.erp_organ_type == SEX_ORGAN_PENIS)
			inject_mode = INJECT_GROUND

	var/target = null

	switch(inject_mode)
		if(INJECT_ORGAN)
			if(source == link.init_organ)
				target = link.target_organ
			else if(source == link.target_organ)
				target = link.init_organ
			else
				target = link.target_organ

		if(INJECT_CONTAINER)
			var/mob/living/carbon/human/H = null
			if(istype(who))
				H = who

			if(!H)
				H = source.get_owner()

			if(!H)
				H = link.actor_active?.physical

			var/turf/center = get_turf(H) || get_turf(link.actor_passive?.physical) || get_turf(link.actor_active?.physical)
			var/obj/item/reagent_containers/C = find_nearby_container(H, center)
			if(!(C && C.reagents))
				var/mob/living/carbon/human/H2 = (H == link.actor_active?.physical) ? link.actor_passive?.physical : link.actor_active?.physical
				var/turf/center2 = get_turf(H2) || center
				C = find_nearby_container(H2, center2)

			if(C && C.reagents)
				target = C
			else
				inject_mode = INJECT_GROUND

		if(INJECT_GROUND)
			target = get_turf(link.actor_passive?.physical) || get_turf(link.actor_active?.physical)

	if(!target)
		inject_mode = INJECT_GROUND
		target = get_turf(link.actor_passive?.physical) || get_turf(link.actor_active?.physical)

	source.on_inject(link, inject_mode, target, R, who)
	source.route_reagents(R, inject_mode, target)

/// Checks if there is a nearby container for container-inject actions.
/datum/erp_injection_service/proc/has_nearby_container_for_action()
	var/mob/living/carbon/human/H1 = controller.owner?.get_effect_mob()
	var/mob/living/carbon/human/H2 = controller.active_partner?.get_effect_mob()

	if(!istype(H1) && !istype(H2))
		return FALSE

	var/turf/c1 = H1 ? get_turf(H1) : null
	var/turf/c2 = H2 ? get_turf(H2) : null

	if(istype(H1))
		var/obj/item/reagent_containers/C = find_nearby_container(H1, c1 || c2)
		if(C && C.reagents)
			return TRUE

	if(istype(H2))
		var/obj/item/reagent_containers/C2 = find_nearby_container(H2, c2 || c1)
		if(C2 && C2.reagents)
			return TRUE

	return FALSE

/// Returns relationship multiplier for pair.
/datum/erp_injection_service/proc/rel_mult_for(mob/living/who, mob/living/partner)
	if(!who || !partner)
		return 1

	var/datum/component/relationships/R = who.GetComponent(/datum/component/relationships)
	if(!R)
		return 1

	var/m = R.get_sex_multiplier(partner)
	if(!isnum(m))
		return 1

	return clamp(m, 0.05, 5)
