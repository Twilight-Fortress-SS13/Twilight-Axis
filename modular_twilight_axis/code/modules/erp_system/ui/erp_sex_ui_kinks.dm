/datum/erp_sex_ui_tab/kinks
	parent_type = /datum/erp_sex_ui_tab

/datum/erp_sex_ui_tab/kinks/build()
	var/datum/erp_controller/C = ui.controller
	if(!C)
		return list("entries" = list())

	// Слева всегда "я" (владелец UI)
	var/mob/living/self = ui.actor
	return C.get_kinks_ui(self, C.active_partner)

/datum/erp_sex_ui_tab/kinks/handle_ui_intent(action, list/params)
	var/datum/erp_controller/C = ui.controller
	if(!C)
		return FALSE

	switch(action)
		if("set_kink_pref")
			var/mob/living/self = ui.actor
			if(!C.set_kink_pref(self, params["type"], text2num(params["value"])))
				return FALSE

			ui.request_update()
			return TRUE

	return FALSE
