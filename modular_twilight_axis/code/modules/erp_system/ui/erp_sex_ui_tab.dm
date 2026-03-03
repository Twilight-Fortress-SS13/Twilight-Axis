/datum/erp_sex_ui_tab
	var/datum/erp_sex_ui/ui
	var/tab_id

/datum/erp_sex_ui_tab/New(datum/erp_sex_ui/U, id)
	. = ..()
	ui = U
	tab_id = id

/datum/erp_sex_ui_tab/proc/build()
	return list()

/datum/erp_sex_ui_tab/proc/handle_ui_intent(action, list/params)
	return FALSE
