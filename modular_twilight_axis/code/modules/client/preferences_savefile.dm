/datum/preferences/proc/load_emote_favourites(savefile/preferences_file)
	var/list/saved
	preferences_file["emote_favourites"] >> saved
	emote_favourites = list()
	if(!islist(saved))
		return
	// Keep favourites selected when their displayed names change.
	var/static/list/renamed_emotes = list(
		"Покачать головой" = TA_EMOTE_NAME_EMOTE_SHAKE,
		"Сморщиться" = TA_EMOTE_NAME_EMOTE_GRIMACE,
		"Ярость" = TA_EMOTE_NAME_EMOTE_RAGE,
		"Щелкнуть 1" = TA_EMOTE_NAME_EMOTE_SNAP,
		"Щелкнуть 2" = TA_EMOTE_NAME_EMOTE_SNAP2,
		"Щелкнуть 3" = TA_EMOTE_NAME_EMOTE_SNAP3,
		"Карканье" = TA_EMOTE_NAME_EMOTE_CAW,
	)
	for(var/name in saved)
		if(istext(name) && length_char(name) && length_char(name) <= MAX_NAME_LEN)
			emote_favourites |= renamed_emotes[name] || name
			if(length(emote_favourites) >= 200)
				break

/datum/preferences/proc/save_emote_favourites(savefile/preferences_file)
	WRITE_FILE(preferences_file["emote_favourites"], emote_favourites)
