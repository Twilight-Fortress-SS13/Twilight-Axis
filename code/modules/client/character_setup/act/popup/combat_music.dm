/datum/preferences/proc/ui_act_popup_combat_music(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("set_combat_music")
			var/path = text2path(params["combat_music"])
			// This is just here to check that they're not passing us a bad path
			if(!(path in GLOB.cmode_tracks_by_type))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/combat_music/cm = GLOB.cmode_tracks_by_type[path]
			verbose_pref_log_change(user, "notice", "Combat Music Override", combat_music.name, cm.name)
			combat_music = cm
			custom_cmode_enabled = FALSE
			return CHARACTER_ACT_DATA_UPDATE
		if("preview_combat_music")
			var/path = text2path(params["combat_music"])
			// This is just here to check that they're not passing us a bad path
			if(!(path in GLOB.cmode_tracks_by_type))
				return CHARACTER_ACT_DATA_UPDATE
			var/datum/combat_music/cm = GLOB.cmode_tracks_by_type[path]

			if(!LAZYLEN(cm.musicpath))
				to_chat(user, span_notice("\"[cm.name]\" has no tracks."))
				return

			var/sound_path = cm.musicpath[1]
			var/sound_len = rustg_sound_length(sound_path)

			user.client.tgui_panel?.play_music("byond://[REF(sound_path)]", list("title" = cm.name, "artist" = cm.credits, "duration" = "[round(sound_len / 10)] seconds"))

			return CHARACTER_ACT_DATA_UPDATE
		if("upload_custom_combat_music")
			if(!can_use_custom_combat_music(user.ckey))
				return CHARACTER_ACT_DATA_UPDATE
			upload_custom_combat_music(user)
			return CHARACTER_ACT_DATA_UPDATE
		if("select_custom_combat_music")
			if(!can_use_custom_combat_music(user.ckey))
				return CHARACTER_ACT_DATA_UPDATE
			if(build_custom_combat_music(user.ckey))
				to_chat(user, span_notice("Selected custom combat music: <b>[combat_music.name]</b>."))
			else
				to_chat(user, span_warning("Custom combat music file is missing."))
			return CHARACTER_ACT_DATA_UPDATE
		if("clear_custom_combat_music")
			if(!can_use_custom_combat_music(user.ckey))
				return CHARACTER_ACT_DATA_UPDATE
			clear_custom_combat_music(user)
			return CHARACTER_ACT_DATA_UPDATE
