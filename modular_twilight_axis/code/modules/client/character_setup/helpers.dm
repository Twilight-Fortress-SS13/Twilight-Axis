/datum/preferences/close_subwindows(mob/user)
	. = ..()
	if(!user?.client)
		return
	SStgui.close_uis(manor_industry_editor)
	QDEL_NULL(manor_industry_editor)
