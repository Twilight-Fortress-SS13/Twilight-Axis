/datum/preferences/proc/load_emote_favourites(savefile/preferences_file)
	var/list/saved
	preferences_file["emote_favourites"] >> saved
	emote_favourites = list()
	if(!islist(saved))
		return
	for(var/name in saved)
		if(istext(name) && length_char(name) && length_char(name) <= MAX_NAME_LEN)
			emote_favourites |= name
			if(length(emote_favourites) >= 200)
				break

/datum/preferences/proc/save_emote_favourites(savefile/preferences_file)
	WRITE_FILE(preferences_file["emote_favourites"], emote_favourites)
