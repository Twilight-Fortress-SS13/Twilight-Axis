/datum/erp_knot_service
	var/datum/erp_controller/controller

/datum/erp_knot_service/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Gets knotting component.
/datum/erp_knot_service/proc/get_knotting_component(mob/living/carbon/human/H)
	if(!istype(H))
		return null
	return H.GetComponent(/datum/component/erp_knotting)

/// Returns penis unit id for link (stub for multi-knot).
/datum/erp_knot_service/proc/get_penis_unit_id_for_link(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.is_valid())
		return 0

	var/datum/erp_knot_link/KL = find_knot_for_link(L)
	if(!KL)
		return 0

	return KL.penis_unit_id

/datum/erp_knot_service/proc/find_knot_for_link(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.is_valid())
		return null

	var/datum/erp_sex_organ/penis/P = null
	var/datum/erp_sex_organ/other = null

	if(istype(L.init_organ, /datum/erp_sex_organ/penis))
		P = L.init_organ
		other = L.target_organ
	else if(istype(L.target_organ, /datum/erp_sex_organ/penis))
		P = L.target_organ
		other = L.init_organ
	else
		return null

	if(!P || !other)
		return null

	var/mob/living/carbon/human/top = P.get_owner()
	if(!istype(top))
		return null

	var/datum/component/erp_knotting/K = get_knotting_component(top)
	if(!K)
		return null

	for(var/datum/erp_knot_link/KL in K.active_links)
		if(KL && KL.penis_org == P && KL.receiving_org == other)
			return KL

	return null

/// Checks if link is a knot pair link.
/datum/erp_knot_service/proc/is_knot_pair_link(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.is_valid())
		return FALSE

	var/datum/erp_sex_organ/init = L.init_organ
	var/datum/erp_sex_organ/tgt  = L.target_organ

	var/datum/erp_sex_organ/penis/P = null
	var/datum/erp_sex_organ/other = null

	if(istype(init,/datum/erp_sex_organ/penis))
		P = init
		other = tgt
	else if(istype(tgt,/datum/erp_sex_organ/penis))
		P = tgt
		other = init
	else
		return FALSE

	if(!P || !other)
		return FALSE

	var/mob/living/carbon/human/top = P.get_owner()
	var/datum/component/erp_knotting/K = get_knotting_component(top)
	if(!K)
		return FALSE

	var/unit = get_penis_unit_id_for_link(L)
	var/datum/erp_sex_organ/forced = K.get_forced_inject_target(P, unit)
	if(!forced)
		return FALSE

	return (forced == other)

/// Notes knot activity for penis/other pair.
/datum/erp_knot_service/proc/note_knot_activity_from_link(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.is_valid())
		return

	var/datum/erp_sex_organ/init = L.init_organ
	var/datum/erp_sex_organ/tgt  = L.target_organ

	var/datum/erp_sex_organ/penis/P = null
	var/datum/erp_sex_organ/other = null

	if(istype(init,/datum/erp_sex_organ/penis))
		P = init
		other = tgt
	else if(istype(tgt,/datum/erp_sex_organ/penis))
		P = tgt
		other = init
	else
		return

	if(!P || !other)
		return

	var/mob/living/carbon/human/top = P.get_owner()
	var/datum/component/erp_knotting/K = get_knotting_component(top)
	if(!K)
		return

	var/unit = get_penis_unit_id_for_link(L)
	K.note_activity_between(P, other, unit)

/// Toggles do_knot_action state (owner only).
/datum/erp_knot_service/proc/set_do_knot_action(mob/living/carbon/human/H, value)
	if(!H || H.client != controller.owner.client)
		return FALSE

	var/datum/erp_sex_organ/penis/P = controller.get_owner_penis_organ()
	if(!P || !P.have_knot)
		controller.do_knot_action = FALSE
		controller.ui?.request_update()
		return FALSE

	var/new_state
	if(isnull(value))
		new_state = !controller.do_knot_action
	else
		new_state = value ? TRUE : FALSE

	controller.do_knot_action = new_state
	controller.ui?.request_update()
	return TRUE

/// Returns penis knot UI state.
/datum/erp_knot_service/proc/get_penis_knot_ui_state(mob/living/carbon/human/H)
	var/list/out = list(
		"has_knotted_penis" = FALSE,
		"can_knot_now" = FALSE
	)

	if(!H || H.client != controller.owner.client)
		return out

	var/datum/erp_sex_organ/penis/P = controller.get_owner_penis_organ()
	if(!P || !P.have_knot)
		controller.do_knot_action = FALSE
		return out

	var/mob/living/carbon/human/top = P.get_owner()
	if(!istype(top))
		return out

	var/datum/component/erp_knotting/K = get_knotting_component(top)
	if(!K)
		return out

	var/max_units = max(1, P.count_to_action)
	var/has_any_link = FALSE
	for(var/i = 0; i < max_units; i++)
		if(K.get_link_for_penis_unit(P, i))
			has_any_link = TRUE
			break

	out["has_knotted_penis"] = has_any_link
	var/used_units = 0
	for(var/i = 0; i < max_units; i++)
		if(K.get_link_for_penis_unit(P, i))
			used_units++

	if(used_units >= max_units)
		out["can_knot_now"] = FALSE
		return out

	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue

		if(L.actor_active != controller.owner)
			continue

		var/datum/erp_sex_organ/other = null

		if(L.init_organ == P)
			other = L.target_organ
		else if(L.target_organ == P)
			other = L.init_organ
		else
			continue

		if(!other)
			continue

		for(var/i = 0; i < max_units; i++)
			if(!K.get_link_for_penis_unit(P, i))
				if(K.can_start_action_with_penis(P, other, i))
					out["can_knot_now"] = TRUE
					return out

	out["can_knot_now"] = FALSE
	return out

/// Checks if penis panel should be shown.
/datum/erp_knot_service/proc/should_show_penis_panel(mob/living/carbon/human/H, actor_type_filter)
	var/datum/erp_sex_organ/penis/P = controller.get_owner_penis_organ()
	if(!P)
		return FALSE

	if(controller.actions_d.normalize_organ_type(actor_type_filter) == SEX_ORGAN_PENIS)
		return TRUE

	if(!controller.links || !controller.links.len)
		return FALSE

	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue
		if(L.actor_active != controller.owner)
			continue
		if(L.init_organ == P || L.target_organ == P)
			return TRUE

	return FALSE
