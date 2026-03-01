/datum/erp_sex_ui_tab/actions
	parent_type = /datum/erp_sex_ui_tab
	var/selected_actor_type = null
	var/selected_partner_type = null

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
		"base_speed" = SEX_SPEED_MID,
		"base_force" = SEX_FORCE_MID,
	)

	var/datum/erp_controller/C = ui.controller
	if(!C)
		return D

	var/datum/erp_sex_organ/penis/P = C.get_owner_penis_organ()
	D["climax_mode"] = P ? (P.climax_mode || "outside") : "outside"
	D["climax_modes"] = list(list("id"="outside","name"="НАРУЖУ"),list("id"="inside","name"="ВНУТРЬ"))
	D["actor_nodes"] = C.get_actor_type_filters_ui() || list()
	D["partner_nodes"] = C.get_partner_type_filters_ui() || list()
	D["actions"] = C.get_action_list_ui(selected_actor_type, selected_partner_type) || list()
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

			ui.request_update()
			return TRUE

		if("start_action")
			var/action_id = params["id"] || params["type"]
			C.start_action_by_types(ui.actor, action_id)
			return TRUE

		if("stop_link")
			C.stop_link(ui.actor, params["link_id"])
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
