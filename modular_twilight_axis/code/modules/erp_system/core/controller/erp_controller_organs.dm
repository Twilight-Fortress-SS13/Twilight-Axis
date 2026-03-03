/datum/erp_controller_organs
	var/datum/erp_controller/controller

/datum/erp_controller_organs/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Gets owner's penis organ datum.
/datum/erp_controller_organs/proc/get_owner_penis_organ()
	for(var/datum/erp_sex_organ/O in controller.owner.get_organs_ref())
		if(istype(O,/datum/erp_sex_organ/penis))
			return O
	return null

/// Sets penis climax mode.
/datum/erp_controller_organs/proc/set_penis_climax_mode(mob/living/carbon/human/H, mode)
	if(!H || H.client != controller.owner.client)
		return FALSE
	if(!(mode in list("outside", "inside")))
		return FALSE

	var/datum/erp_sex_organ/penis/P = get_owner_penis_organ()
	if(!P)
		return FALSE

	P.climax_mode = mode
	controller.ui?.request_update()
	return TRUE

/// Builds organs status list for UI.
/datum/erp_controller_organs/proc/get_organs_status_ui(mob/living/carbon/human/H)
	var/list/out = list()
	for(var/datum/erp_sex_organ/O in controller.owner.get_organs_ref())
		out += list(build_organ_status_entry(O))
	return out

/// Builds single organ status entry.
/datum/erp_controller_organs/proc/build_organ_status_entry(datum/erp_sex_organ/O)
	var/list/toggles = list()
	if(O.has_liquid_system())
		var/current = O.allow_overflow_spill
		toggles["has_overflow"] = TRUE
		toggles["overflow"] = current

	if(istype(O,/datum/erp_sex_organ/penis))
		toggles["has_erect"] = TRUE
		toggles["erect_mode"] = get_penis_erect_mode(O)

	var/list/links = list()
	for(var/datum/erp_sex_link/L in O.get_passive_links())
		links += list(list(
			"id" = "\ref[L]",
			"mode" = "passive",
			"action_name" = L.action?.name,
			"other_organ" = "[L.init_organ?.erp_organ_type]"
		))

	for(var/datum/erp_sex_link/L2 in O.get_active_links())
		links += list(list(
			"id" = "\ref[L2]",
			"mode" = "active",
			"action_name" = L2.action?.name,
			"other_organ" = "[L2.target_organ?.erp_organ_type]"
		))

	return list(
		"id" = "\ref[O]",
		"type" = "[O.erp_organ_type]",
		"name" = get_organ_ui_name(O),
		"sensitivity" = O.sensitivity,
		"pain" = O.pain,
		"busy" = O.is_busy(),
		"storage" = build_liquid_block(O.storage),
		"producing" = build_liquid_block(O.producing),
		"links" = links,
		"toggles" = toggles
	)

/// Returns localized organ name by type.
/datum/erp_controller_organs/proc/get_organ_ui_name(datum/erp_sex_organ/O)
	switch(O.erp_organ_type)
		if(SEX_ORGAN_PENIS) return "Член"
		if(SEX_ORGAN_HANDS) return "Руки"
		if(SEX_ORGAN_LEGS) return "Ноги"
		if(SEX_ORGAN_TAIL) return "Хвост"
		if(SEX_ORGAN_BODY) return "Тело"
		if(SEX_ORGAN_MOUTH) return "Рот"
		if(SEX_ORGAN_ANUS) return "Анус"
		if(SEX_ORGAN_BREASTS) return "Грудь"
		if(SEX_ORGAN_VAGINA) return "Вагина"
	return "[O.erp_organ_type]"

/// Returns penis erect mode string.
/datum/erp_controller_organs/proc/get_penis_erect_mode(datum/erp_sex_organ/penis/P)
	if(!istype(P))
		return "auto"
	return P.erect_mode

/// Builds liquid status block.
/datum/erp_controller_organs/proc/build_liquid_block(datum/erp_liquid_storage/L)
	if(!L || L.capacity <= 0)
		return list("has" = FALSE, "pct" = 0)

	var/cap = max(1, L.capacity)
	var/vol = clamp(L.total_volume(), 0, cap)
	var/pct = (vol / cap) * 100
	pct = clamp(round(pct, 0.1), 0, 100)

	return list("has" = TRUE, "pct" = pct, "volume" = pct)

/// Sets organ sensitivity and saves preferences.
/datum/erp_controller_organs/proc/set_organ_sensitivity(mob/living/carbon/human/H, organ_id, value)
	if(!istype(H))
		return FALSE

	var/datum/erp_sex_organ/O = controller.owner.get_organ_by_id(organ_id)
	if(!O)
		return FALSE

	value = clamp(value, 0, O.sensitivity_max)
	O.sensitivity = value

	var/datum/preferences/P = H.client?.prefs
	if(P)
		var/key = "[O.erp_organ_type]"
		var/list/prefs = P.erp_organ_prefs[key]
		if(!islist(prefs))
			prefs = P.erp_organ_prefs[key] = list()

		prefs["sensitivity"] = O.sensitivity
		P.save_preferences()

	controller.ui?.request_update()
	return TRUE

/// Toggles organ overflow and saves preferences.
/datum/erp_controller_organs/proc/toggle_organ_overflow(mob/living/carbon/human/H, organ_id)
	if(!istype(H))
		return FALSE

	var/datum/erp_sex_organ/O = controller.owner.get_organ_by_id(organ_id)
	if(!O || !O.has_liquid_system())
		return FALSE

	var/current = O.allow_overflow_spill
	O.allow_overflow_spill = !current

	var/datum/preferences/P = H.client?.prefs
	if(P)
		var/key = "[O.erp_organ_type]"
		var/list/prefs = P.erp_organ_prefs[key]
		if(!islist(prefs))
			prefs = P.erp_organ_prefs[key] = list()

		prefs["overflow"] = O.allow_overflow_spill
		P.save_preferences()

	controller.ui?.request_update()
	return TRUE

/// Sets penis erect mode and syncs source organ.
/datum/erp_controller_organs/proc/set_organ_erect_mode(mob/living/carbon/human/H, organ_id, mode)
	if(!istype(H))
		return FALSE

	var/datum/erp_sex_organ/O = controller.owner.get_organ_by_id(organ_id)
	if(!istype(O,/datum/erp_sex_organ/penis))
		return FALSE

	var/datum/erp_sex_organ/penis/P = O
	var/obj/item/organ/penis/OP = P.source_organ
	if(!OP)
		return FALSE

	P.erect_mode = mode
	switch(mode)
		if("auto")
			OP.disable_manual_erect()
		if("none")
			OP.set_manual_erect_state(ERECT_STATE_NONE)
		if("partial")
			OP.set_manual_erect_state(ERECT_STATE_PARTIAL)
		if("hard")
			OP.set_manual_erect_state(ERECT_STATE_HARD)
		else
			return FALSE

	if(OP.owner)
		OP.owner.update_body_parts(TRUE)

	controller.ui?.request_update()
	return TRUE

/// Localized organ type name for filters.
/datum/erp_controller_organs/proc/get_organ_type_ui_name(type)
	switch(type)
		if(SEX_ORGAN_PENIS) return "Член"
		if(SEX_ORGAN_HANDS) return "Руки"
		if(SEX_ORGAN_LEGS) return "Ноги"
		if(SEX_ORGAN_TAIL) return "Хвост"
		if(SEX_ORGAN_BODY) return "Тело"
		if(SEX_ORGAN_MOUTH) return "Рот"
		if(SEX_ORGAN_ANUS) return "Анус"
		if(SEX_ORGAN_BREASTS) return "Грудь"
		if(SEX_ORGAN_VAGINA) return "Вагина"
	return "[type]"

/// Returns actor type filters list with localized names.
/datum/erp_controller_organs/proc/get_actor_type_filters_ui()
	var/list/L = controller.owner?.get_organ_type_filters_ui() || list()
	for(var/list/E in L)
		E["name"] = get_organ_type_ui_name(E["type"])
	return L

/// Returns partner type filters list with localized names.
/datum/erp_controller_organs/proc/get_partner_type_filters_ui()
	if(!controller.active_partner)
		return list()

	var/list/L = controller.active_partner.get_organ_type_filters_ui() || list()
	for(var/list/E in L)
		E["name"] = get_organ_type_ui_name(E["type"])
	return L

/// Returns actor nodes list for filter.
/datum/erp_controller_organs/proc/get_actor_nodes_by_filter_ui(type_filter)
	var/list/out = list()
	if(!type_filter)
		return out

	for(var/datum/erp_sex_organ/O in controller.owner.get_organs_ref(type_filter))
		out += list(list(
			"id" = "\ref[O]",
			"name" = get_organ_ui_name(O),
			"busy" = O.is_busy(),
			"free" = O.get_free_slots(),
			"total" = O.get_total_slots()
		))

	return out

/// Returns partner nodes list for filter.
/datum/erp_controller_organs/proc/get_partner_nodes_by_filter_ui(type_filter)
	var/list/out = list()
	if(!controller.active_partner || !type_filter)
		return out

	for(var/datum/erp_sex_organ/O in controller.active_partner.get_organs_ref(type_filter))
		out += list(list(
			"id" = "\ref[O]",
			"name" = get_organ_ui_name(O),
			"busy" = O.is_busy(),
			"free" = O.get_free_slots(),
			"total" = O.get_total_slots()
		))

	return out
