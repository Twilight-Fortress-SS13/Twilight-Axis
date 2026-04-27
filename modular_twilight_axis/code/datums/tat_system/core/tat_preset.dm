/datum/tat_preset
	var/id = "base"
	var/name = "Preset"
	var/list/build_data = list()

/datum/tat_preset/New()
	. = ..()
	if(!istext(id) || !length(id))
		id = "[type]"
	if(!istext(name) || !length(name))
		name = "Preset"
	if(!islist(build_data))
		build_data = list()

/datum/tat_preset/proc/get_build_data()
	return islist(build_data) ? build_data.Copy() : list()

/datum/tat_preset/proc/export_to_list()
	return list(
		"id" = id,
		"name" = name,
		"build_data" = get_build_data(),
	)


/datum/tat_preset/sample
