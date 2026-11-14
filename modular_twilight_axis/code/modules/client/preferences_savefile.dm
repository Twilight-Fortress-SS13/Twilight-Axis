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

/datum/preferences/_load_quirk(savefile/S)
	var/lesser_type
	var/greater_type
	S["quirklesser"] >> lesser_type
	S["quirkgreater"] >> greater_type
	. = ..()
	if(greater_type != /datum/quirk/noble)
		return
	if(lesser_type && lesser_type != /datum/quirk/none)
		return
	QDEL_NULL(quirklesser)
	quirklesser = quirkgreater
	quirkgreater = new /datum/quirk/none
