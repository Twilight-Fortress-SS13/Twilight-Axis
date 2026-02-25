/datum/erp_controller_links
	var/datum/erp_controller/controller

/datum/erp_controller_links/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Cleanup all links on controller destroy.
/datum/erp_controller_links/proc/cleanup()
	if(controller.links)
		for(var/datum/erp_sex_link/L in controller.links)
			if(L)
				L.finish()
				qdel(L)
		controller.links.Cut()

/// Stops link by id without permissions checks.
/datum/erp_controller_links/proc/handle_stop_link(link_id)
	var/datum/erp_sex_link/L = find_link(link_id)
	if(!L)
		return FALSE

	stop_link_runtime(L)
	return TRUE

/// Processes link validity and scene ticking.
/datum/erp_controller_links/proc/process_links()
	for(var/i = controller.links.len; i >= 1; i--)
		var/datum/erp_sex_link/L = controller.links[i]
		if(!L || QDELETED(L) || !L.is_valid())
			stop_link_runtime(L)

	controller.process_scene_tick()

/// Stops link by request (owner only).
/datum/erp_controller_links/proc/stop_link(mob/user, link_id)
	if(!controller._is_owner_requester(user))
		return FALSE

	var/datum/erp_sex_link/L = find_link(link_id)
	if(!L)
		return FALSE

	stop_link_runtime(L)
	return TRUE

/// Stops link and sends finish message when appropriate.
/datum/erp_controller_links/proc/stop_link_runtime(datum/erp_sex_link/L)
	if(!L)
		return
	if(QDELETED(L))
		return

	if(L.is_valid())
		controller._send_link_finish_message(L)

	if(L in controller.links)
		controller.links -= L

	L.finish()
	qdel(L)

/// Finds link datum by UI id.
/datum/erp_controller_links/proc/find_link(link_id)
	if(!link_id)
		return null

	var/key = "[link_id]"
	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L))
			continue
		if("\ref[L]" == key)
			return L

	return null

/// Sets link speed (owner only).
/datum/erp_controller_links/proc/set_link_speed(mob/user, link_id, value)
	if(!controller._is_owner_requester(user))
		return FALSE

	var/datum/erp_sex_link/L = find_link(link_id)
	if(!L)
		return FALSE

	L.speed = clamp(round(value), SEX_SPEED_LOW, SEX_SPEED_EXTREME)
	controller.ui?.request_update()
	return TRUE

/// Sets link force (owner only).
/datum/erp_controller_links/proc/set_link_force(mob/user, link_id, value)
	if(!controller._is_owner_requester(user))
		return FALSE

	var/datum/erp_sex_link/L = find_link(link_id)
	if(!L)
		return FALSE

	L.force = clamp(round(value), SEX_FORCE_LOW, SEX_FORCE_EXTREME)
	controller.ui?.request_update()
	return TRUE

/// Sets link finish mode (owner only).
/datum/erp_controller_links/proc/set_link_finish_mode(mob/user, link_id, mode)
	if(!controller._is_owner_requester(user))
		return FALSE

	var/datum/erp_sex_link/L = find_link(link_id)
	if(!L)
		return FALSE

	if(!(mode in list("until_stop", "until_climax")))
		return FALSE

	L.finish_mode = mode
	controller.ui?.request_update()
	return TRUE

/// Builds active links list for UI.
/datum/erp_controller_links/proc/get_active_links_ui(mob/living/carbon/human/H)
	var/list/L = list()

	for(var/datum/erp_sex_link/S in controller.links)
		if(!S || QDELETED(S))
			continue

		var/init_t = S.init_organ?.erp_organ_type
		var/tgt_t  = S.target_organ?.erp_organ_type

		L += list(list(
			"id" = "\ref[S]",
			"name" = S.action?.name,
			"actor_org" = init_t ? controller.get_organ_type_ui_name(init_t) : null,
			"target_org" = tgt_t ? controller.get_organ_type_ui_name(tgt_t) : null,
			"speed" = S.speed,
			"force" = S.force,
			"climax_target" = S.climax_target,
			"finish_mode" = S.finish_mode
		))

	return L

/// Stops all links and requests UI update.
/datum/erp_controller_links/proc/full_stop()
	if(!controller.links || !controller.links.len)
		return 0

	var/list/to_stop = controller.links.Copy()
	var/stopped = 0

	for(var/datum/erp_sex_link/L in to_stop)
		if(!L || QDELETED(L))
			continue
		stop_link_runtime(L)
		stopped++

	controller.ui?.request_update()
	return stopped

/// Stops pair links (optionally keep allow_sex_on_move).
/datum/erp_controller_links/proc/stop_pair_links(mob/living/A, mob/living/B, break_only_no_move = TRUE)
	if(!A || !B)
		return

	var/list/to_stop = null

	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L))
			continue

		var/mob/living/la = L.actor_active?.physical
		var/mob/living/lb = L.actor_passive?.physical
		if(!la || !lb)
			continue

		if(!((la == A && lb == B) || (la == B && lb == A)))
			continue

		if(break_only_no_move)
			var/datum/erp_action/ACT = L.action
			if(ACT && ACT.allow_sex_on_move)
				continue

		LAZYADD(to_stop, L)

	if(!to_stop)
		return

	for(var/datum/erp_sex_link/L2 in to_stop)
		stop_link_runtime(L2)

/// Starts action by choosing first free organs (type-aware).
/datum/erp_controller_links/proc/start_action_by_types(mob/living/carbon/human/H, action_id)
	if(!H || H.client != controller.owner.client)
		return FALSE
	if(!controller.active_partner)
		return FALSE

	var/datum/erp_action/A = controller.get_action_by_id_or_path(action_id)
	if(!A)
		return FALSE

	var/mob/living/carbon/human/actor_object = controller.owner?.physical
	var/mob/living/carbon/human/partner_object = controller.active_partner?.physical
	if(!actor_object || !partner_object)
		return FALSE

	if(get_dist(actor_object, partner_object) > 1)
		return FALSE

	var/list/p1 = controller.actions_d.pick_first_by_type(controller.owner, TRUE)
	var/list/p2 = controller.actions_d.pick_first_by_type(controller.active_partner, FALSE)

	var/list/init_by = p1["by"]
	var/list/tgt_by  = p2["by"]

	var/datum/erp_sex_organ/any_init = p1["any"]
	var/datum/erp_sex_organ/any_tgt  = p2["any"]

	var/datum/erp_sex_organ/init = null
	if(A.required_init_organ)
		init = init_by[controller.actions_d.normalize_organ_type(A.required_init_organ)]
	else
		init = any_init

	var/datum/erp_sex_organ/target = null
	if(A.required_target_organ)
		target = tgt_by[controller.actions_d.normalize_organ_type(A.required_target_organ)]
	else
		target = any_tgt

	if(!init || !target)
		return FALSE

	var/reason = controller.get_action_block_reason(A, init, target)
	if(!isnull(reason))
		return FALSE

	if(istype(init,/datum/erp_sex_organ/penis))
		var/datum/erp_sex_organ/penis/P = init
		if(P.have_knot)
			var/mob/living/carbon/human/top = P.get_owner()
			var/datum/component/erp_knotting/K = controller._get_knotting_component(top)
			if(K && !K.can_start_action_with_penis(P, target, 0))
				return FALSE

	var/list/organs = list("init" = init, "target" = target)
	var/datum/erp_sex_link/L = new(controller.owner, controller.active_partner, A, organs, controller)
	controller.links += L

	controller._send_link_start_message(L)
	controller.ui?.request_update()
	return TRUE

/// Stops links on pair moved based on distance and allow_sex_on_move.
/datum/erp_controller_links/proc/on_pair_moved(atom/movable/source, atom/oldloc, dir, forced)
	if(!controller.links || !controller.links.len)
		return

	var/mob/living/mover = source
	if(!istype(mover))
		return

	var/list/to_stop = null

	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L))
			continue

		var/mob/living/A = L.actor_active?.physical
		var/mob/living/B = L.actor_passive?.physical
		if(!A || !B)
			LAZYADD(to_stop, L)
			continue

		if(mover != A && mover != B)
			continue

		var/dist = get_dist(A, B)
		if(dist > 1)
			if(dist < 3 && controller._is_knot_pair_link(L))
				continue
			LAZYADD(to_stop, L)
			continue

		var/datum/erp_action/ACT = L.action
		if(!ACT || !ACT.allow_sex_on_move)
			LAZYADD(to_stop, L)

	if(!to_stop)
		return

	for(var/datum/erp_sex_link/L2 in to_stop)
		stop_link_runtime(L2)

	controller.ui?.request_update()

/// Adds links relevant to a mob into out_links list.
/datum/erp_controller_links/proc/on_get_links(datum/source, list/out_links)
	if(!islist(out_links) || !controller.links || !controller.links.len)
		return

	var/mob/living/M = source
	if(!istype(M))
		return

	for(var/datum/erp_sex_link/L in controller.links)
		if(!L || QDELETED(L))
			continue

		var/mob/living/ma = L.actor_active?.get_effect_mob()
		var/mob/living/mp = L.actor_passive?.get_effect_mob()
		if(ma == M || mp == M)
			out_links += L
