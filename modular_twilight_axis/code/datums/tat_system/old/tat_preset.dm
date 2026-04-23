/// Read-only TAT preset definition used by UI to load authored builds into the current draft.
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

/datum/tat_preset/proc/export_to_ui_payload(datum/tat_build/build_owner)
	var/list/summary = list(
		"stats" = 0,
		"skills" = 0,
		"traits" = 0,
		"items" = 0,
	)
	if(istype(build_owner, /datum/tat_build))
		summary = build_owner.build_slot_summary_from_data(build_data)
	return list(
		"id" = id,
		"name" = name,
		"summary" = summary,
	)

/datum/tat_preset/proc/get_build_data()
	return islist(build_data) ? build_data.Copy() : list()
