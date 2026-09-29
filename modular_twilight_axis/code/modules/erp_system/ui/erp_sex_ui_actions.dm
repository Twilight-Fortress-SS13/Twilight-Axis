/datum/erp_sex_ui_tab/actions
	parent_type = /datum/erp_sex_ui_tab
	var/selected_actor_type = null
	var/selected_partner_type = null
	var/list/cached_action_payload
	var/cached_action_signature

/datum/erp_sex_ui_tab/actions/proc/mark_dirty()
	cached_action_payload = null
	cached_action_signature = null

/datum/erp_sex_ui_tab/actions/proc/ref_signature(datum/D)
	return D ? "\ref[D]" : "null"

/datum/erp_sex_ui_tab/actions/proc/item_context_signature(obj/item/I)
	if(!I)
		return "null"

	var/list/parts = list(
		ref_signature(I),
		"name=[I.name]",
		"cover=[I.body_parts_covered_dynamic]",
		"surgery=[I.surgery_cover]"
	)

	if(islist(I.erp_item_tags))
		parts += "tags=[I.erp_item_tags.Join(",")]"

	return parts.Join(":")

/datum/erp_sex_ui_tab/actions/proc/mob_context_signature(mob/living/M)
	if(!M)
		return "null"

	var/turf/T = get_turf(M)
	var/list/parts = list(
		ref_signature(M),
		ref_signature(M.loc),
		ref_signature(T),
		"pos=[M.x],[M.y],[M.z]",
		"pull=[ref_signature(M.pulling)]",
		"pulledby=[ref_signature(M.pulledby)]",
		"grab=[M.grab_state]",
		"act=[item_context_signature(M.get_active_held_item())]",
		"inact=[item_context_signature(M.get_inactive_held_item())]"
	)

	if(iscarbon(M))
		var/mob/living/carbon/C = M
		parts += "grabbedby=[islist(C.grabbedby) ? C.grabbedby.len : 0]"
		if(islist(C.grabbedby))
			for(var/obj/item/grabbing/G as anything in C.grabbedby)
				parts += ref_signature(G)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		parts += "under=[ref_signature(H.underwear)]"
		parts += "legwear=[ref_signature(H.legwear_socks)]"
		parts += "piercings=[ref_signature(H.piercings_item)]"
		parts += "testicles=[ref_signature(H.getorganslot(ORGAN_SLOT_TESTICLES))]"

		var/list/equipped = H.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE)
		parts += "equipped=[islist(equipped) ? equipped.len : 0]"
		if(islist(equipped))
			for(var/obj/item/I as anything in equipped)
				parts += item_context_signature(I)

	return parts.Join("|")

/datum/erp_sex_ui_tab/actions/proc/actor_organs_signature(datum/erp_actor/A)
	if(!A)
		return "null"

	var/list/parts = list(ref_signature(A))
	for(var/datum/erp_sex_organ/O in A.get_organs_ref())
		if(!O)
			continue
		parts += "[ref_signature(O)]:[O.erp_organ_type]:[O.get_free_slots()]"

	return parts.Join("|")

/datum/erp_sex_ui_tab/actions/proc/links_signature(datum/erp_controller/C)
	if(!C || !islist(C.links))
		return "links=0"

	var/list/parts = list("links=[C.links.len]")
	for(var/datum/erp_sex_link/L in C.links)
		if(!L)
			continue
		parts += "[ref_signature(L)]:[L.state]:[ref_signature(L.init_organ)]:[ref_signature(L.target_organ)]:[ref_signature(L.action)]"

	return parts.Join("|")

/datum/erp_sex_ui_tab/actions/proc/action_context_signature(datum/erp_controller/C)
	if(!C)
		return null

	var/list/parts = list(
		"actor_filter=[selected_actor_type]",
		"partner_filter=[selected_partner_type]",
		"owner=[ref_signature(C.owner)]",
		"partner=[ref_signature(C.active_partner)]",
		"container=[C._has_nearby_container_for_action()]",
		"custom=[islist(C.owner?.custom_actions) ? C.owner.custom_actions.len : 0]",
		mob_context_signature(C.owner?.get_mob()),
		mob_context_signature(C.active_partner?.get_mob()),
		actor_organs_signature(C.owner),
		actor_organs_signature(C.active_partner),
		links_signature(C)
	)

	if(islist(C.owner?.custom_actions))
		for(var/datum/erp_action/A in C.owner.custom_actions)
			if(!A)
				continue
			parts += "[ref_signature(A)]:[A.id]:[A.name]"

	return parts.Join(";")

/datum/erp_sex_ui_tab/actions/build()
	var/list/D = list(
		"actor_nodes" = list(),
		"partner_nodes" = list(),
		"selected_actor_node" = selected_actor_type,
		"selected_partner_node" = selected_partner_type,
		"actions" = list(),
		"active_links" = list(),

		"show_penis_panel" = FALSE,

		// NEW knot ui
		"show_knot_toggle" = FALSE,
		"do_knot_action" = FALSE,
		"has_knotted_penis" = FALSE,
		"can_knot_now" = FALSE,
		"show_climax_controls" = FALSE,
		"base_speed" = SEX_SPEED_MID,
		"base_force" = SEX_FORCE_MID,
	)

	var/datum/erp_controller/C = ui.controller
	if(!C)
		return D

	var/current_action_signature = action_context_signature(C)
	if(cached_action_signature != current_action_signature)
		cached_action_payload = null
		cached_action_signature = current_action_signature

	if(!islist(cached_action_payload))
		cached_action_payload = list(
			"actor_nodes" = C.get_actor_type_filters_ui() || list(),
			"partner_nodes" = C.get_partner_type_filters_ui() || list(),
			"selected_actor_node" = selected_actor_type,
			"selected_partner_node" = selected_partner_type,
			"actions" = C.get_action_list_ui(selected_actor_type, selected_partner_type) || list()
		)

	var/datum/erp_sex_organ/penis/P = C.get_owner_penis_organ()
	D["climax_mode"] = P ? (P.climax_mode || "outside") : "outside"
	D["climax_modes"] = list(list("id"="outside","name"="НАРУЖУ"),list("id"="inside","name"="ВНУТРЬ"))
	D["show_climax_controls"] = P ? TRUE : FALSE
	D["actor_nodes"] = cached_action_payload["actor_nodes"] || list()
	D["partner_nodes"] = cached_action_payload["partner_nodes"] || list()
	D["selected_actor_node"] = cached_action_payload["selected_actor_node"]
	D["selected_partner_node"] = cached_action_payload["selected_partner_node"]
	D["actions"] = cached_action_payload["actions"] || list()
	D["active_links"] = C.get_active_links_ui(ui.actor) || list()
	D["base_speed"] = C.default_link_speed
	D["base_force"] = C.default_link_force
	D["show_penis_panel"] = C.should_show_penis_panel(ui.actor, selected_actor_type) ? TRUE : FALSE
	if(P && P.have_knot)
		D["show_knot_toggle"] = TRUE
		D["do_knot_action"] = C.do_knot_action ? TRUE : FALSE
		var/list/kui = C.get_penis_knot_ui_state(ui.actor)
		if(islist(kui))
			D["has_knotted_penis"] = kui["has_knotted_penis"] ? TRUE : FALSE
			D["can_knot_now"] = kui["can_knot_now"] ? TRUE : FALSE
	else
		var/list/rkui = C.get_receiving_knot_ui_state(ui.actor)
		if(islist(rkui) && (rkui["can_knot_now"] || rkui["has_knotted_penis"]))
			D["show_penis_panel"] = TRUE
			D["show_knot_toggle"] = TRUE
			D["do_knot_action"] = C.do_knot_action ? TRUE : FALSE
			D["has_knotted_penis"] = rkui["has_knotted_penis"] ? TRUE : FALSE
			D["can_knot_now"] = rkui["can_knot_now"] ? TRUE : FALSE
		else
			D["show_knot_toggle"] = FALSE
			D["do_knot_action"] = FALSE
			D["has_knotted_penis"] = FALSE
			D["can_knot_now"] = FALSE

	return D

/datum/erp_sex_ui_tab/actions/handle_ui_intent(action, list/params)
	var/datum/erp_controller/C = ui.controller
	if(!C)
		return FALSE

	switch(action)
		if("select_node")
			var/side = params["side"]
			var/id = params["id"] || params["type"]

			if(side == "actor")
				selected_actor_type = (selected_actor_type == id) ? null : id
			else if(side == "partner")
				selected_partner_type = (selected_partner_type == id) ? null : id

			mark_dirty()
			ui.request_update()
			return TRUE

		if("start_action")
			var/action_id = params["id"] || params["type"]
			C.start_action_by_types(ui.actor, action_id)
			mark_dirty()
			return TRUE

		if("stop_link")
			C.stop_link(ui.actor, params["link_id"])
			mark_dirty()
			ui.request_update()
			return TRUE

		if("set_link_speed")
			C.set_link_speed(ui.actor, params["link_id"], text2num(params["value"]))
			return TRUE

		if("set_link_force")
			C.set_link_force(ui.actor, params["link_id"], text2num(params["value"]))
			return TRUE

		if("set_link_finish_mode")
			C.set_link_finish_mode(ui.actor, params["link_id"], params["mode"])
			return TRUE

		if("set_climax_mode")
			return C.set_penis_climax_mode(ui.actor, params["mode"])

		if("toggle_knot")
			return C.set_do_knot_action(ui.actor, params["value"])

		if("set_base_speed")
			return C.set_default_link_speed(ui.actor, params["value"])

		if("set_base_force")
			return C.set_default_link_force(ui.actor, params["value"])

	return FALSE
