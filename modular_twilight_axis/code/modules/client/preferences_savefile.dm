/datum/preferences/load_character(slot)
	. = ..()
	if(!.)
		return
	var/savefile/character_save = new(path)
	character_save.cd = "/character[loaded_slot]"
	var/saved_retention
	character_save["manor_treasury_retention"] >> saved_retention
	manor_treasury_retention = sanitize_integer(
		saved_retention,
		0,
		100,
		initial(manor_treasury_retention),
	)
	var/list/saved_profiles
	character_save["manor_industry_profiles"] >> saved_profiles
	manor_industry_profiles = taSanitizeManorIndustryProfiles(
		saved_profiles,
		virtue_origin?.type,
	)

/datum/preferences/save_character()
	. = ..()
	if(!.)
		return
	var/savefile/character_save = new(path)
	character_save.cd = "/character[default_slot]"
	WRITE_FILE( \
		character_save["manor_treasury_retention"], \
		manor_treasury_retention \
	)
	WRITE_FILE( \
		character_save["manor_industry_profiles"], \
		manor_industry_profiles \
	)

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
