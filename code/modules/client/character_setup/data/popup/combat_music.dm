/datum/preferences/proc/ui_data_popup_combat_music(mob/user)
	var/can_custom_cmode = can_use_custom_combat_music(user?.ckey)
	var/custom_cmode_uploaded = can_custom_cmode && custom_cmode_file && is_valid_custom_combat_music_path(custom_cmode_file) && fexists(custom_cmode_file)
	var/list/data = list(
		"combat_music" = combat_music?.name || null,
		"can_custom_combat_music" = can_custom_cmode,
		"custom_cmode_name" = can_custom_cmode ? custom_cmode_name : null,
		"custom_cmode_uploaded" = custom_cmode_uploaded,
		"custom_cmode_enabled" = can_custom_cmode && custom_cmode_enabled,
	)

	return data
