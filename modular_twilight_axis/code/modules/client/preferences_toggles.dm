/client/verb/toggle_runechat_animation()
	set category = "Preferences.Options"
	set name = "Toggle Runechat Animation"
	if(prefs)
		prefs.no_runechat_animation = !prefs.no_runechat_animation
		prefs.save_preferences()
	to_chat(src, "You will [prefs.no_runechat_animation ? "not see" : "see"] animated runechat.")
