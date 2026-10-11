/datum/tat_stats
	var/datum/tat_build/owner_build
	var/list/values = list()
	var/base_points = TAT_BASIC_STAT_POINTS

/datum/tat_stats/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/tat_stats/proc/reset()
	values = list()
	return TRUE

/datum/tat_stats/proc/get_entry(stat_id)
	var/list/all = list(TAT_AVAILABLE_STATS_LIST)
	if(!(stat_id in all))
		return null
	return all[stat_id]

/datum/tat_stats/proc/get_base(stat_id)
	var/list/entry = get_entry(stat_id)
	if(!islist(entry))
		return 10
	return isnum(entry["base"]) ? entry["base"] : 10

/datum/tat_stats/proc/get_minimum(stat_id)
	var/list/entry = get_entry(stat_id)
	if(!islist(entry))
		return 1
	return isnum(entry["min"]) ? entry["min"] : 1

/datum/tat_stats/proc/get_hard_minimum(stat_id)
	return 1

/datum/tat_stats/proc/get_maximum(stat_id)
	var/list/entry = get_entry(stat_id)
	if(!islist(entry))
		return 20
	return isnum(entry["max"]) ? entry["max"] : 20

/datum/tat_stats/proc/get_cost(stat_id)
	var/list/entry = get_entry(stat_id)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_stats/proc/get_total_maximum()
	return base_points + (owner_build ? owner_build.get_bonus_stat_points() : 0)

/datum/tat_stats/proc/get_value(stat_id)
	if(stat_id in values)
		return values[stat_id]
	return get_base(stat_id)

/datum/tat_stats/proc/set_value(stat_id, value, ignore_budget = FALSE)
	if(!islist(get_entry(stat_id)))
		return FALSE
	value = round(value)
	value = clamp(value, get_hard_minimum(stat_id), get_maximum(stat_id))

	var/old_value = get_value(stat_id)
	if(value == old_value)
		return TRUE

	if(!ignore_budget)
		var/old_cost = get_point_delta_for_value(stat_id, old_value)
		var/new_cost = get_point_delta_for_value(stat_id, value)
		var/new_spent = get_spent_points() - old_cost + new_cost
		if(new_spent > get_total_maximum())
			return FALSE

	if(value == get_base(stat_id))
		values -= stat_id
	else
		values[stat_id] = value
	owner_build?.set_dirty()
	return TRUE

/datum/tat_stats/proc/get_point_delta_for_value(stat_id, value)
	var/base = get_base(stat_id)
	var/cost = get_cost(stat_id)
	var/refund_floor = get_minimum(stat_id)

	value = clamp(value, get_hard_minimum(stat_id), get_maximum(stat_id))
	if(value > base)
		return (value - base) * cost
	var/effective_value = max(value, refund_floor)
	return (effective_value - base) * cost

/datum/tat_stats/proc/get_spent_points()
	var/total = 0
	var/list/order = TAT_STATS_ORDER_LIST
	for(var/stat_id in order)
		total += get_point_delta_for_value(stat_id, get_value(stat_id))
	return total

/datum/tat_stats/proc/get_remaining_points()
	return get_total_maximum() - get_spent_points()

/datum/tat_stats/proc/sanitize()
	var/list/order = TAT_STATS_ORDER_LIST
	for(var/stat_id in values.Copy())
		if(!islist(get_entry(stat_id)))
			values -= stat_id
	for(var/stat_id in order)
		set_value(stat_id, get_value(stat_id), TRUE)
	while(get_remaining_points() < 0)
		var/changed = FALSE
		for(var/stat_id in order)
			var/current = get_value(stat_id)
			var/base = get_base(stat_id)
			if(current > base)
				set_value(stat_id, current - 1, TRUE)
				changed = TRUE
				if(get_remaining_points() >= 0)
					break
		if(!changed)
			break
	return TRUE

/datum/tat_stats/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/stat_id in TAT_STATS_ORDER_LIST)
		var/diff = get_value(stat_id) - get_base(stat_id)
		if(diff)
			H.change_stat(stat_id, diff)
	return TRUE

/datum/tat_stats/proc/disable_from_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/stat_id in TAT_STATS_ORDER_LIST)
		var/diff = get_value(stat_id) - get_base(stat_id)
		if(diff)
			H.change_stat(stat_id, -diff)
	return TRUE

/datum/tat_stats/proc/export_to_list()
	return values.Copy()

/datum/tat_stats/proc/import_from_list(list/data)
	values = list()
	if(!islist(data))
		return FALSE
	for(var/stat_id in data)
		set_value(stat_id, data[stat_id], TRUE)
	return TRUE

/datum/tat_stats/proc/export_to_json_list()
	return export_to_list()

/datum/tat_stats/proc/import_from_json_list(list/data)
	return import_from_list(data)
