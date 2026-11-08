/client/proc/handle_emote_panel_message(type, payload)
	switch(type)
		if("Update-Verbs")
			send_emote_panel_data()
		if("Emote-Favourite")
			if(!prefs || !islist(payload))
				return
			var/name = payload["name"]
			if(!istext(name) || !length_char(name) || length_char(name) > MAX_NAME_LEN)
				return
			if(name in prefs.emote_favourites)
				prefs.emote_favourites -= name
			else
				if(length(prefs.emote_favourites) >= 200 || !is_available_emote_verb(name))
					send_emote_panel_data()
					return
				prefs.emote_favourites += name
			// TA EDIT - Частые нажатия объединяются в одну запись настроек.
			addtimer(CALLBACK(prefs, TYPE_PROC_REF(/datum/preferences, save_preferences)), 3 SECONDS, TIMER_UNIQUE)
			send_emote_panel_data()

/client/proc/is_available_emote_verb(name)
	if(!mob)
		return FALSE
	for(var/procpath/verb_path as anything in (verbs | mob.verbs))
		if(verb_path.hidden || verb_path.name != name)
			continue
		var/category = verb_path.category
		if(category == "Emotes" || findtext(category, "Emotes.") == 1)
			return TRUE
	return FALSE

/client/proc/send_emote_panel_data()
	if(prefs && stat_panel)
		stat_panel.send_message("emote_panel_data", list("favourites" = prefs.emote_favourites))
