/datum/preferences/proc/ui_act_popup_patron_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("set_patron")
			// Typepath index
			var/datum/patron/picked = GLOB.preference_patrons[text2path(params["patron"])]
			if(!picked?.name)
				return CHARACTER_ACT_DATA_UPDATE
			if(picked.type == /datum/patron/old_god && has_flaw(/datum/charflaw/inquisition_suspect)) // TA EDIT START
				to_chat(user, span_warning("Remove Under Suspicion before choosing Psydon."))
				return CHARACTER_ACT_DATA_UPDATE // TA EDIT END

			verbose_pref_log_change(user, "notice", "Patron", selected_patron.name, picked)
			selected_patron = picked
			return CHARACTER_ACT_DATA_UPDATE
