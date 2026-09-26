/datum/erp_sex_ui_tab/status
	parent_type = /datum/erp_sex_ui_tab

/datum/erp_sex_ui_tab/status/proc/_get_owner_mob(datum/erp_controller/C)
	if(!C?.owner)
		return null
	var/mob/living/M = C.owner.physical
	return istype(M) ? M : null

/datum/erp_sex_ui_tab/status/proc/_build_link_row(datum/erp_sex_link/L, datum/erp_sex_organ/O, is_passive)
	if(!L || !O)
		return null

	var/datum/erp_sex_organ/other = is_passive ? L.init_organ : L.target_organ
	return list(
		"id" = "[L]",
		"mode" = is_passive ? "passive" : "active",
		"action_name" = L.action?.name,
		"speed" = L.speed,
		"force" = L.force,
		"other_organ" = other ? "[other.erp_organ_type]" : null
	)

/datum/erp_sex_ui_tab/status/build()
	var/list/D = list(
		"entries" = list(),
		"arousal" = 0
	)

	var/datum/erp_controller/C = ui.controller
	if(!C)
		return D

	D["entries"] = C.get_organs_status_ui(ui.actor)
	D["arousal"] = C.get_actor_arousal_ui(ui.actor) || 0

	var/mob/living/carbon/human/H = _get_owner_mob(C)
	if(istype(H))
		D["arousal_data"] = _get_arousal_payload(H)

	return D

/datum/erp_sex_ui_tab/status/handle_ui_intent(action, list/params)
	var/datum/erp_controller/C = ui.controller
	if(!C)
		return FALSE

	switch(action)
		if("set_organ_sensitivity")
			if(!C.set_organ_sensitivity(
				_get_owner_mob(C),
				params["organ_id"],
				text2num(params["value"])
			))
				return FALSE
			ui.request_update()
			return TRUE

		if("toggle_organ_overflow")
			if(!C.toggle_organ_overflow(
				_get_owner_mob(C),
				params["organ_id"]
			))
				return FALSE
			ui.request_update()
			return TRUE

		if("set_organ_erect")
			if(!C.set_organ_erect_mode(
				_get_owner_mob(C),
				params["organ_id"],
				params["mode"]
			))
				return FALSE
			ui.request_update()
			return TRUE

	return FALSE

/datum/erp_sex_ui_tab/status/proc/_get_arousal_payload(mob/living/carbon/human/H)
	if(!istype(H))
		return null
	var/list/arousal_data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, arousal_data)
	return arousal_data
