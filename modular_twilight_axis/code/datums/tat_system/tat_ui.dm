/// UI-facing layer for TAT build.

/datum/tat_build/proc/build_ui_stats()
	var/list/result = list()
	for(var/stat_id in stat_order)
		if(!(stat_id in available_stats))
			continue
		result[stat_id] = get_stat_value(stat_id)
	return result

/datum/tat_build/proc/build_ui_stat_entries()
	var/list/result = list()
	for(var/stat_id in stat_order)
		if(!(stat_id in available_stats))
			continue
		result[stat_id] = available_stats[stat_id]
	return result

/datum/tat_build/proc/build_ui_skill_entries()
	var/list/result = list()
	for(var/skill_type in available_skills)
		var/list/entry = available_skills[skill_type]
		result["[skill_type]"] = list(
			"name" = entry["name"],
			"desc" = entry["desc"],
			"category" = entry["category"],
			"is_combat" = !!entry["is_combat"],
		)
	return result

/datum/tat_build/proc/build_ui_skills()
	var/list/result = list()
	for(var/skill_type in available_skills)
		result["[skill_type]"] = list(
			"level" = get_skill_value(skill_type),
			"cap" = get_skill_cap(skill_type),
			"next_cost" = get_skill_next_cost(skill_type),
		)
	return result

/datum/tat_build/proc/build_ui_selected_traits()
	var/list/result = list()
	for(var/trait_id in traits)
		result += trait_id
	return result

/datum/tat_build/proc/build_ui_trait_entries()
	var/list/result = list()
	for(var/trait_id in available_traits)
		var/list/entry = available_traits[trait_id]
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"category_name" = entry["category_name"],
			"desc" = entry["desc"],
		)
	return result

/datum/tat_build/proc/build_ui_items()
	var/list/result = list()
	for(var/item_path in available_items)
		var/list/entry = available_items[item_path]
		var/list/icon_payload = get_item_icon_payload(item_path)
		result["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"unlock_type" = entry["unlock_type"],
			"unlock_key" = entry["unlock_key"],
			"slot_group" = entry["slot_group"],
			"icon" = icon_payload ? icon_payload["icon"] : null,
			"icon_state" = icon_payload ? icon_payload["icon_state"] : null,
		)
	return result

/datum/tat_build/proc/build_ui_item_states()
	var/list/result = list()
	for(var/item_path in available_items)
		var/list/entry = available_items[item_path]
		result["[item_path]"] = list(
			"amount" = (items[item_path] || 0),
			"unlocked" = can_use_item_entry(entry),
		)
	return result

/datum/tat_build/proc/build_ui_loadout()
	var/list/result = list()
	for(var/item_path in items)
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		normalize_item_loadout(item_path)
		result["[item_path]"] = list(
			"amount" = amount,
			"equip" = get_item_equip_amount(item_path),
			"bag" = get_item_bag_amount(item_path),
		)
	return result

/datum/tat_build/proc/build_ui_tat_slot(slot_id)
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	var/list/summary = build_slot_summary_from_data(slot.get_build_data())
	var/name = istext(slot.name) && length(slot.name) ? slot.name : get_default_tat_slot_name(slot_id)
	var/list/result_data = list(
		"id" = slot_id,
		"name" = name,
		"active" = (active_tat_slot == slot_id),
		"summary" = list(
			"stats" = isnum(summary["stats"]) ? summary["stats"] : 0,
			"skills" = isnum(summary["skills"]) ? summary["skills"] : 0,
			"traits" = isnum(summary["traits"]) ? summary["traits"] : 0,
			"items" = isnum(summary["items"]) ? summary["items"] : 0,
		),
	)
	return result_data

/datum/tat_build/proc/build_ui_tat_slots()
	init_tat_slots()
	var/list/build_list = list(
		build_ui_tat_slot(1),
		build_ui_tat_slot(2),
		build_ui_tat_slot(3),
	)
	return build_list

/datum/tat_build/ui_state(mob/user)
	return GLOB.always_state

/datum/tat_build/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TATBuild")
		ui.open()

/datum/tat_build/ui_static_data(mob/user)
	return list(
		"available_stats" = build_ui_stat_entries(),
		"available_skills" = build_ui_skill_entries(),
		"available_traits" = build_ui_trait_entries(),
		"available_items" = build_ui_items(),
	)

/datum/tat_build/ui_data(mob/user)
	return list(
		"stats" = build_ui_stats(),
		"skills" = build_ui_skills(),
		"traits" = build_ui_selected_traits(),
		"items" = build_ui_item_states(),
		"loadout" = build_ui_loadout(),
		"magic_config" = magic_config.Copy(),
		"points_stats" = get_effective_stat_points_total(),
		"points_stats_remaining" = get_remaining_stat_points(),
		"points_skills" = get_effective_skill_points_total(),
		"points_skills_remaining" = get_remaining_skill_points(),
		"points_traits" = points_traits,
		"points_traits_remaining" = get_remaining_trait_points(),
		"points_items" = points_items,
		"points_items_remaining" = get_remaining_item_points(),
		"tat_slots" = build_ui_tat_slots(),
		"active_tat_slot" = active_tat_slot,
		"can_save" = can_save(),
		"dirty" = dirty,
	)

/datum/tat_build/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("add_stat")
			return add_stat(params["id"], text2num(params["amount"]) || 1)
		if("remove_stat")
			return remove_stat(params["id"], text2num(params["amount"]) || 1)
		if("add_skill")
			return add_skill(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_skill")
			return remove_skill(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("add_trait")
			return add_trait(params["id"])
		if("remove_trait")
			return remove_trait(params["id"])
		if("add_item")
			return add_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_item")
			return remove_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("move_item_to_equip")
			return move_item_to_equip(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("move_item_to_bag")
			return move_item_to_bag(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("set_magic_value")
			return set_magic_value(params["key"], params["value"])
		if("activate_tat_slot")
			return set_active_tat_slot(text2num(params["slot_id"]))
		if("rename_tat_slot")
			return rename_tat_slot(text2num(params["slot_id"]), params["name"])
		if("reset_all")
			reset_build()
			return TRUE
		if("reset_stats")
			reset_stats()
			return TRUE
		if("reset_skills")
			reset_skills()
			return TRUE
		if("reset_traits")
			reset_traits()
			return TRUE
		if("reset_items")
			reset_items()
			return TRUE
		if("save")
			if(!can_save())
				return FALSE
			return save_current_to_active_slot()
	return FALSE
