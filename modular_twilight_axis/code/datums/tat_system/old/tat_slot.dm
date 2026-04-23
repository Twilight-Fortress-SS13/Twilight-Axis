/// TAT slot container. Intentionally isolated from UI and character application.
/datum/tat_slot
	var/name = "Slot"
	var/list/build_data = list()

/datum/tat_slot/New(slot_name = "Slot")
	. = ..()
	if(istext(slot_name) && length(slot_name))
		name = slot_name

/datum/tat_slot/proc/export_to_list()
	var/list/info = list(
		"name" = name,
		"build_data" = islist(build_data) ? build_data.Copy() : list(),
	)
	return info

/datum/tat_slot/proc/load_from_list(list/L)
	if(!islist(L))
		name = "Slot"
		build_data = list()
		return
	name = istext(L["name"]) ? L["name"] : "Slot"
	var/list/data = L["build_data"]
	build_data = islist(data) ? data.Copy() : list()

/datum/tat_slot/proc/set_build_data(list/L)
	build_data = islist(L) ? L.Copy() : list()

/datum/tat_slot/proc/get_build_data()
	return islist(build_data) ? build_data.Copy() : list()
