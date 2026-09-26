/datum/erp_sex_ui_tab/editor
	parent_type = /datum/erp_sex_ui_tab
	var/dirty_data = TRUE
	var/list/cached_payload
	var/selected_mode = null
	var/selected_key  = null
	var/list/selected_payload = null

/datum/erp_sex_ui_tab/editor/build()
	if(islist(cached_payload))
		var/list/D = cached_payload.Copy()
		D["selected"] = selected_payload
		return D

	var/list/D = list(
		"templates" = list(),
		"custom_actions" = list(),
		"selected" = selected_payload
	)

	var/datum/erp_controller/C = ui.controller
	if(C)
		for(var/path in SSerp.actions)
			var/datum/erp_action/A = SSerp.actions[path]
			if(!A || A.abstract) continue
			D["templates"] += list(list("type" = "[path]", "name" = A.name))

		for(var/datum/erp_action/A2 in C.owner.custom_actions)
			if(!A2 || A2.abstract) continue
			D["custom_actions"] += list(list("id" = A2.id, "name" = A2.name))

	cached_payload = D.Copy()
	return D

/datum/erp_sex_ui_tab/editor/handle_ui_intent(action, list/params)
	var/datum/erp_controller/C = ui.controller
	if(!C)
		return FALSE

	switch(action)
		if("create_action")
			C.create_custom_action(ui.actor, params)
			mark_dirty()
			ui.request_update()
			return TRUE

		if("update_action")
			C.update_custom_action(ui.actor, params)
			mark_dirty()
			_select_action(C, params)
			ui.request_update()
			return TRUE

		if("delete_action")
			C.delete_custom_action(ui.actor, params["id"])
			mark_dirty()
			ui.request_update()
			return TRUE

		if("editor_select_action")
			return _select_action(C, params)

	return FALSE

/datum/erp_sex_ui_tab/editor/proc/mark_dirty()
	cached_payload = null

/datum/erp_sex_ui_tab/editor/proc/_select_action(datum/erp_controller/C, list/params)
	var/mode = params["mode"]
	var/key  = params["key"]
	if(!mode || !key)
		return FALSE

	var/datum/erp_action/A = null

	if(mode == "template")
		var/path = text2path(key)
		if(!ispath(path, /datum/erp_action))
			return FALSE
		A = SSerp.actions[path]
	else if(mode == "custom")
		for(var/datum/erp_action/X in C.owner.custom_actions)
			if(X && X.id == key)
				A = X
				break
	else
		return FALSE

	if(!A || A.abstract)
		return FALSE

	selected_mode = mode
	selected_key  = key
	selected_payload = list(
		"mode" = mode,
		"key" = key,
		"id" = A.id,
		"name" = A.name,
		"fields" = SSerp.action_editor_schema.export_editor_fields(A)
	)

	dirty_data = TRUE
	ui.request_update()
	return TRUE
