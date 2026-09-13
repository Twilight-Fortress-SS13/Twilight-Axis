/datum/tat_slot
	var/name = "Slot"
	var/list/build_data = list()
	var/list/summary_cache = null
	var/summary_dirty = TRUE

/datum/tat_slot/New(slot_name = "Slot")
	. = ..()
	if(istext(slot_name) && length(slot_name))
		name = slot_name
	if(!islist(build_data))
		build_data = list()
	summary_dirty = TRUE

/datum/tat_slot/proc/export_to_list()
	return list(
		"name" = name,
		"build_data" = islist(build_data) ? deep_copy_list_alt(build_data) : list(),
	)

/datum/tat_slot/proc/load_from_list(list/L, datum/tat_build/owner_build = null)
	if(!islist(L))
		name = "Slot"
		build_data = list()
		summary_cache = null
		summary_dirty = TRUE
		return FALSE

	name = istext(L["name"]) ? L["name"] : "Slot"
	var/list/data = L["build_data"]
	build_data = islist(data) ? deep_copy_list_alt(data) : list()
	refresh_summary(owner_build)
	return TRUE

/datum/tat_slot/proc/set_build_data(list/L, datum/tat_build/owner_build = null)
	build_data = islist(L) ? deep_copy_list_alt(L) : list()
	refresh_summary(owner_build)
	return TRUE

/datum/tat_slot/proc/get_build_data()
	return islist(build_data) ? deep_copy_list_alt(build_data) : list()

/datum/tat_slot/proc/refresh_summary(datum/tat_build/owner_build = null)
	if(owner_build)
		summary_cache = owner_build.build_slot_summary_from_data(build_data)
		summary_dirty = FALSE
	else
		summary_cache = null
		summary_dirty = TRUE
	return summary_cache

/datum/tat_slot/proc/get_summary(datum/tat_build/owner_build)
	if(!summary_dirty && islist(summary_cache))
		return summary_cache
	return refresh_summary(owner_build)
