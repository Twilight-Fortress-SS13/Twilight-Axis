/// UI-facing layer for TAT build (backend side).

/datum/tat_build
	var/list/ui_item_catalog_cache = null
	var/list/ui_item_states_cache = null
	var/ui_item_states_cache_dirty = TRUE
	var/ui_item_cache_requested = FALSE
	var/ui_item_cache_pending_full = FALSE
	var/ui_item_cache_pending_states = FALSE

/datum/tat_build/proc/get_ui_skill_domain_key(domain)
	if(domain == TAT_SKILL_DOMAIN_COMBAT)
		return "combat"
	if(domain == TAT_SKILL_DOMAIN_WANDERING)
		return "wandering"
	if(domain == TAT_SKILL_DOMAIN_GATHERING)
		return "gathering"
	if(domain == TAT_SKILL_DOMAIN_CRAFTING)
		return "crafting"
	if(domain == TAT_SKILL_DOMAIN_MISC)
		return "misc"
	return "misc"

/datum/tat_build/proc/get_all_ui_skill_types()
	var/list/result = list()
	result += TAT_SKILLS_COMBAT
	result += TAT_SKILLS_WANDERING
	result += TAT_SKILLS_GATHERING
	result += TAT_SKILLS_CRAFTING
	result += TAT_SKILLS_MISC
	return result

/datum/tat_build/proc/get_stat_entry(stat_id)
	return stats?.get_entry(stat_id)

/datum/tat_build/proc/get_skill_entry(skill_type)
	if(!ispath(skill_type, /datum/skill))
		return null

	var/datum/skill/S = new skill_type
	if(!S)
		return null

	var/domain = skills?.get_domain(skill_type)
	var/ui_domain = get_ui_skill_domain_key(domain)

	var/list/result = list(
		"name" = S.name,
		"desc" = S.desc,
		"category" = ui_domain,
		"is_combat" = !!ispath(skill_type, /datum/skill/combat),
	)

	qdel(S)
	return result

/datum/tat_build/proc/get_trait_entry(trait_id)
	return traits?.get_entry(trait_id)

/datum/tat_build/proc/get_item_entry(item_path)
	return items?.get_entry(item_path)

/datum/tat_build/proc/get_skill_cap(skill_type)
	return skills?.get_maximum(skill_type) || 0

/datum/tat_build/proc/get_skill_next_cost(skill_type)
	var/current_invested = get_invested_skill_value(skill_type)
	return skills?.get_step_cost(skill_type, current_invested + 1) || 0

/datum/tat_build/proc/get_effective_stat_points_total()
	return stats?.get_total_maximum() || 0

/datum/tat_build/proc/get_remaining_stat_points()
	return stats?.get_remaining_points() || 0

/datum/tat_build/proc/get_effective_skill_points_total()
	if(!skills)
		return 0
	var/total = 0
	for(var/domain in skills.domain_points)
		total += skills.get_total_maximum(domain)
	return total

/datum/tat_build/proc/get_remaining_skill_points()
	if(!skills)
		return 0
	var/total = 0
	for(var/domain in skills.domain_points)
		total += skills.get_remaining_points(domain)
	return total

/datum/tat_build/proc/get_remaining_trait_points()
	return traits?.get_remaining_points() || 0

/datum/tat_build/proc/get_remaining_item_points()
	return items?.get_remaining_points() || 0

/datum/tat_build/proc/build_ui_skill_points_by_domain()
	var/list/result = list(
		"combat" = 0,
		"wandering" = 0,
		"gathering" = 0,
		"crafting" = 0,
		"misc" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_COMBAT)
	result["wandering"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_WANDERING)
	result["gathering"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_GATHERING)
	result["crafting"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_CRAFTING)
	result["misc"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_MISC)

	return result

/datum/tat_build/proc/build_ui_skill_points_remaining_by_domain()
	var/list/result = list(
		"combat" = 0,
		"wandering" = 0,
		"gathering" = 0,
		"crafting" = 0,
		"misc" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_COMBAT)
	result["wandering"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_WANDERING)
	result["gathering"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_GATHERING)
	result["crafting"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_CRAFTING)
	result["misc"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_MISC)

	return result

/datum/tat_build/proc/can_save()
	return is_budget_valid()

/datum/tat_build/proc/reset_build()
	return reset()

/datum/tat_build/proc/reset_stats()
	stats?.reset()
	sanitize()
	set_dirty()
	return TRUE

/datum/tat_build/proc/reset_skills()
	skills?.reset()
	sanitize()
	set_dirty()
	return TRUE

/datum/tat_build/proc/reset_traits()
	traits?.reset()
	sanitize()
	set_dirty()
	return TRUE

/datum/tat_build/proc/reset_items()
	items?.reset()
	sanitize()
	set_dirty()
	return TRUE

/datum/tat_build/proc/add_stat(id, amount = 1)
	if(!stats)
		return FALSE
	var/current = stats.get_value(id)
	var/ok = stats.set_value(id, current + (text2num("[amount]") || 1))
	sanitize()
	return ok

/datum/tat_build/proc/remove_stat(id, amount = 1)
	if(!stats)
		return FALSE
	var/current = stats.get_value(id)
	var/ok = stats.set_value(id, current - (text2num("[amount]") || 1))
	sanitize()
	return ok

/datum/tat_build/proc/add_skill(skill_type, amount = 1)
	if(!skills)
		return FALSE
	var/current = skills.get_invested_value(skill_type)
	var/ok = skills.set_invested_value(skill_type, current + (text2num("[amount]") || 1))
	sanitize()
	return ok

/datum/tat_build/proc/remove_skill(skill_type, amount = 1)
	if(!skills)
		return FALSE
	var/current = skills.get_invested_value(skill_type)
	var/ok = skills.set_invested_value(skill_type, current - (text2num("[amount]") || 1))
	sanitize()
	return ok

/datum/tat_build/proc/add_trait(trait_id)
	var/ok = traits?.add_trait(trait_id)
	sanitize()
	return ok

/datum/tat_build/proc/remove_trait(trait_id)
	var/ok = traits?.remove_trait(trait_id)
	sanitize()
	return ok

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_amount(path)
	var/ok = items.set_amount(path, current + (text2num("[amount]") || 1))
	sanitize()
	invalidate_item_ui_cache()
	return ok

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_amount(path)
	var/ok = items.set_amount(path, current - (text2num("[amount]") || 1))
	sanitize()
	invalidate_item_ui_cache()
	return ok

/datum/tat_build/proc/move_item_to_bag(path, amount = 1)
	if(!items)
		return FALSE
	var/count = max(1, text2num("[amount]") || 1)
	var/total = items.get_amount(path)
	if(total <= 0)
		return FALSE
	var/list/loadout = items.get_loadout(path)
	loadout["bag"] = min(total, round(loadout["bag"] || 0) + count)
	loadout["equip"] = max(0, total - round(loadout["bag"] || 0))
	items.normalize_loadout(path)
	set_dirty()
	return TRUE

/datum/tat_build/proc/move_item_to_equip(path, amount = 1)
	if(!items)
		return FALSE
	var/count = max(1, text2num("[amount]") || 1)
	var/total = items.get_amount(path)
	if(total <= 0)
		return FALSE
	var/list/loadout = items.get_loadout(path)
	loadout["bag"] = max(0, round(loadout["bag"] || 0) - count)
	loadout["equip"] = max(0, total - round(loadout["bag"] || 0))
	items.normalize_loadout(path)
	set_dirty()
	return TRUE

/datum/tat_build/proc/build_ui_stats()
	var/list/result = list()
	for(var/stat_id in TAT_STATS_ORDER_LIST)
		var/list/entry = get_stat_entry(stat_id)
		if(!islist(entry))
			continue
		result[stat_id] = get_stat_value(stat_id)
	return result

/datum/tat_build/proc/build_ui_stat_entries()
	var/list/result = list()
	for(var/stat_id in TAT_STATS_ORDER_LIST)
		var/list/entry = get_stat_entry(stat_id)
		if(islist(entry))
			result[stat_id] = entry
	return result

/datum/tat_build/proc/build_ui_skill_entries()
	var/list/result = list()
	for(var/skill_type in get_all_ui_skill_types())
		var/list/entry = get_skill_entry(skill_type)
		if(!islist(entry))
			continue
		result["[skill_type]"] = entry
	return result

/datum/tat_build/proc/build_ui_skills()
	var/list/result = list()
	for(var/skill_type in get_all_ui_skill_types())
		var/bonus_value = 0
		var/invested_value = 0

		if(skills)
			bonus_value = skills.get_bonus_value(skill_type)
			invested_value = skills.get_invested_value(skill_type)

		result["[skill_type]"] = list(
			"level" = get_skill_value(skill_type),
			"cap" = get_skill_cap(skill_type),
			"next_cost" = get_skill_next_cost(skill_type),
			"bonus" = bonus_value,
			"invested" = invested_value,
		)
	return result

/datum/tat_build/proc/build_ui_selected_traits()
	var/list/result = list()
	for(var/trait_id in traits.selected)
		result += trait_id
	return result

/datum/tat_build/proc/build_ui_trait_entries()
	var/list/result = list()
	for(var/trait_id in list(TAT_AVAILABLE_TRAITS_LIST))
		var/list/entry = get_trait_entry(trait_id)
		if(!islist(entry))
			continue
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = get_trait_cost_display(trait_id),
			"category" = entry["category"],
			"category_name" = entry["category_name"],
			"desc" = entry["desc"],
		)
	return result

/datum/tat_build/proc/get_item_icon_payload(item_path)
	if(!ispath(item_path, /obj/item))
		return null
	var/obj/item/I = new item_path
	if(!I)
		return null
	var/icon/render_icon = icon(initial(I.icon), initial(I.icon_state), SOUTH, 1)
	var/icon_b64 = render_icon ? icon2base64(render_icon) : null
	var/list/payload = list(
		"icon" = icon_b64,
		"icon_state" = "[initial(I.icon_state)]",
	)
	qdel(I)
	return payload

/datum/tat_build/proc/build_ui_loadout()
	var/list/result = list()
	for(var/item_path in items.selected)
		var/amount = items.get_amount(item_path)
		if(amount <= 0)
			continue
		items.normalize_loadout(item_path)
		var/list/loadout = items.get_loadout(item_path)
		result["[item_path]"] = list(
			"amount" = amount,
			"equip" = round(loadout["equip"] || 0),
			"bag" = round(loadout["bag"] || 0),
		)
	return result

/datum/tat_build/proc/build_ui_tat_slot(slot_id)
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	var/list/summary = build_slot_summary_from_data(slot.get_build_data())
	var/name = istext(slot.name) && length(slot.name) ? slot.name : get_default_tat_slot_name(slot_id)
	return list(
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

/datum/tat_build/proc/build_ui_tat_slots()
	init_tat_slots()
	var/list/result = list()
	for(var/i in 1 to TAT_SLOT_COUNT)
		result += list(build_ui_tat_slot(i))
	return result

/datum/tat_build/proc/build_ui_tat_presets()
	if(islist(ui_tat_presets_cache))
		return ui_tat_presets_cache

	init_tat_presets()

	var/list/result = list()
	for(var/preset_id in tat_presets)
		var/datum/tat_preset/sample/preset = tat_presets[preset_id]
		if(!istype(preset, /datum/tat_preset/sample))
			continue
		result += list(list(
			"id" = preset.id,
			"name" = preset.name,
			"summary" = build_slot_summary_from_data(preset.get_build_data()),
		))

	ui_tat_presets_cache = result
	return ui_tat_presets_cache

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
		"available_items" = null,
	)

/datum/tat_build/ui_data(mob/user)
	var/list/validation = get_validation_issues()
	var/can_save_build = !length(validation)

	return list(
		"stats" = build_ui_stats(),
		"skills" = build_ui_skills(),
		"traits" = build_ui_selected_traits(),
		"items" = null,
		"item_cache" = get_pending_item_ui_cache_packet(),
		"loadout" = build_ui_loadout(),

		"points_stats" = get_effective_stat_points_total(),
		"points_stats_remaining" = get_remaining_stat_points(),

		"points_skills" = get_effective_skill_points_total(),
		"points_skills_remaining" = get_remaining_skill_points(),
		"skill_points_by_domain" = build_ui_skill_points_by_domain(),
		"skill_points_remaining_by_domain" = build_ui_skill_points_remaining_by_domain(),

		"points_traits" = traits.get_total_maximum(),
		"points_traits_remaining" = get_remaining_trait_points(),

		"points_items" = items.get_total_maximum(),
		"points_items_remaining" = get_remaining_item_points(),

		"tat_slots" = build_ui_tat_slots(),
		"active_tat_slot" = active_tat_slot,
		"tat_presets" = build_ui_tat_presets(),
		"can_save" = can_save_build,
		"validation_issues" = validation,
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
		if("activate_tat_slot")
			return set_active_tat_slot(text2num(params["slot_id"]))
		if("rename_tat_slot")
			return rename_tat_slot(text2num(params["slot_id"]), params["name"])
		if("reset_all")
			return reset_build()
		if("reset_stats")
			return reset_stats()
		if("reset_skills")
			return reset_skills()
		if("reset_traits")
			return reset_traits()
		if("reset_items")
			return reset_items()
		if("save")
			if(!can_save())
				return FALSE
			return save_current_to_active_slot()
		if("request_item_cache")
			return request_item_ui_cache(text2num(params["full"]) ? TRUE : FALSE)
		if("load_tat_preset")
			return load_preset_into_current(params["preset_id"])
	return FALSE

/datum/tat_build/proc/get_ui_item_catalog_cache()
	if(islist(ui_item_catalog_cache))
		return ui_item_catalog_cache
	ui_item_catalog_cache = list()
	for(var/item_path in list(TAT_AVAILABLE_ITEMS_LIST))
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		var/list/icon_payload = get_item_icon_payload(item_path)
		ui_item_catalog_cache["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"unlock_type" = entry["unlock_type"],
			"unlock_key" = entry["unlock_key"],
			"slot_group" = entry["slot_group"],
			"icon" = icon_payload ? icon_payload["icon"] : null,
			"icon_state" = icon_payload ? icon_payload["icon_state"] : null,
		)
	return ui_item_catalog_cache

/datum/tat_build/proc/get_ui_item_states_cache()
	if(islist(ui_item_states_cache) && !ui_item_states_cache_dirty)
		return ui_item_states_cache
	ui_item_states_cache = list()
	for(var/item_path in list(TAT_AVAILABLE_ITEMS_LIST))
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		ui_item_states_cache["[item_path]"] = list(
			"amount" = items.get_amount(item_path),
			"unlocked" = items.can_use_item_entry(entry),
		)
	ui_item_states_cache_dirty = FALSE
	return ui_item_states_cache

/datum/tat_build/proc/invalidate_item_ui_cache(send_full = FALSE)
	ui_item_states_cache_dirty = TRUE
	if(!ui_item_cache_requested)
		return
	if(send_full || !islist(ui_item_catalog_cache))
		ui_item_cache_pending_full = TRUE
	else
		ui_item_cache_pending_states = TRUE

/datum/tat_build/proc/request_item_ui_cache(force_full = FALSE)
	ui_item_cache_requested = TRUE
	if(force_full || !islist(ui_item_catalog_cache))
		ui_item_cache_pending_full = TRUE
	else
		ui_item_cache_pending_states = TRUE
	return TRUE

/datum/tat_build/proc/get_pending_item_ui_cache_packet()
	if(!ui_item_cache_requested)
		return null
	if(!ui_item_cache_pending_full && !ui_item_cache_pending_states)
		return null
	var/list/packet = list()
	if(ui_item_cache_pending_full)
		packet["full"] = TRUE
		packet["catalog"] = get_ui_item_catalog_cache()
	else
		packet["full"] = FALSE
		packet["catalog"] = null
	packet["states"] = get_ui_item_states_cache()
	ui_item_cache_pending_full = FALSE
	ui_item_cache_pending_states = FALSE
	return packet
