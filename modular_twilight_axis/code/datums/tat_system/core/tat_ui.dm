/datum/tat_build
	var/list/ui_item_states_cache = null
	var/ui_item_states_cache_dirty = TRUE
	var/ui_item_cache_requested = FALSE
	var/ui_item_cache_pending_catalog = FALSE
	var/ui_item_cache_pending_states_full = FALSE
	var/list/ui_item_cache_pending_state_paths = null

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
	var/ok = reset()
	if(ok)
		queue_item_ui_states_full_refresh()
	return ok

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
	queue_item_ui_states_full_refresh()
	set_dirty()
	return TRUE

/datum/tat_build/proc/reset_items()
	items?.reset()
	sanitize()
	queue_item_ui_states_full_refresh()
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
	if(ok)
		queue_item_ui_states_full_refresh()
	return ok

/datum/tat_build/proc/remove_trait(trait_id)
	var/ok = traits?.remove_trait(trait_id)
	sanitize()
	if(ok)
		queue_item_ui_states_full_refresh()
	return ok

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_amount(path)
	var/ok = items.set_amount(path, current + (text2num("[amount]") || 1))
	sanitize()
	if(ok)
		queue_item_ui_state_refresh_for_related_paths(path)
	return ok

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_amount(path)
	var/ok = items.set_amount(path, current - (text2num("[amount]") || 1))
	sanitize()
	if(ok)
		queue_item_ui_state_refresh_for_related_paths(path)
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
		"can_save" = can_save_build,
		"validation_issues" = validation,
		"build_json" = last_exported_json,
		"last_json_error" = last_json_error,
		"last_json_notice" = last_json_notice,
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
		if("export_json")
			export_to_json()
			return TRUE
		if("import_json")
			return import_from_json(params["json"])

	return FALSE

/datum/tat_build/proc/build_ui_item_state(item_path)
	var/list/entry = get_item_entry(item_path)
	if(!islist(entry))
		return null

	var/maximum = items.get_maximum(item_path)
	var/amount = items.get_amount(item_path)
	return list(
		"amount" = amount,
		"unlocked" = items.can_use_item_entry(entry),
		"maximum" = maximum,
		"can_add" = amount < maximum,
	)

/datum/tat_build/proc/get_ui_item_states_cache()
	if(islist(ui_item_states_cache) && !ui_item_states_cache_dirty)
		return ui_item_states_cache
	ui_item_states_cache = list()
	for(var/item_path in list(TAT_AVAILABLE_ITEMS_LIST))
		var/list/state = build_ui_item_state(item_path)
		if(!islist(state))
			continue
		ui_item_states_cache["[item_path]"] = state
	ui_item_states_cache_dirty = FALSE
	return ui_item_states_cache

/datum/tat_build/proc/build_ui_item_states_for_paths(list/paths)
	var/list/result = list()
	if(!islist(paths))
		return result

	for(var/item_path in paths)
		if(!ispath(item_path))
			item_path = text2path("[item_path]")
		if(!item_path)
			continue
		var/list/state = build_ui_item_state(item_path)
		if(!islist(state))
			continue
		result["[item_path]"] = state
	return result

/datum/tat_build/proc/add_pending_item_state_path(item_path)
	if(!item_path)
		return FALSE
	if(!ispath(item_path))
		item_path = text2path("[item_path]")
	if(!item_path)
		return FALSE
	if(!islist(ui_item_cache_pending_state_paths))
		ui_item_cache_pending_state_paths = list()
	if(!(item_path in ui_item_cache_pending_state_paths))
		ui_item_cache_pending_state_paths += item_path
	return TRUE

/datum/tat_build/proc/queue_item_ui_state_refresh_for_related_paths(item_path)
	ui_item_states_cache_dirty = TRUE
	if(!ui_item_cache_requested)
		return
	if(ui_item_cache_pending_states_full)
		return
	for(var/related_path in tat_get_item_related_dynamic_paths(item_path))
		add_pending_item_state_path(related_path)

/datum/tat_build/proc/queue_item_ui_states_full_refresh()
	ui_item_states_cache_dirty = TRUE
	if(!ui_item_cache_requested)
		return
	ui_item_cache_pending_states_full = TRUE
	ui_item_cache_pending_state_paths = null

/datum/tat_build/proc/invalidate_item_ui_cache(send_full = FALSE)
	if(send_full)
		tat_clear_item_static_ui_cache()
		if(ui_item_cache_requested)
			ui_item_cache_pending_catalog = TRUE
	queue_item_ui_states_full_refresh()

/datum/tat_build/proc/request_item_ui_cache(force_full = FALSE)
	ui_item_cache_requested = TRUE
	if(force_full || !length(GLOB.tat_item_catalog_cache))
		ui_item_cache_pending_catalog = TRUE
		ui_item_cache_pending_states_full = TRUE
		ui_item_cache_pending_state_paths = null
	return TRUE

/datum/tat_build/proc/get_pending_item_ui_cache_packet()
	if(!ui_item_cache_requested)
		return null

	if(!ui_item_cache_pending_catalog && !ui_item_cache_pending_states_full && !length(ui_item_cache_pending_state_paths))
		return null

	var/list/packet = list()
	packet["full"] = ui_item_cache_pending_catalog || ui_item_cache_pending_states_full

	if(ui_item_cache_pending_catalog)
		packet["catalog"] = tat_get_item_catalog_cache()
	else
		packet["catalog"] = null

	if(ui_item_cache_pending_states_full)
		packet["states"] = get_ui_item_states_cache()
	else
		packet["states"] = build_ui_item_states_for_paths(ui_item_cache_pending_state_paths)

	ui_item_cache_pending_catalog = FALSE
	ui_item_cache_pending_states_full = FALSE
	ui_item_cache_pending_state_paths = null

	return packet

/proc/tat_item_entry_is_slot_limited(list/entry)
	if(!islist(entry))
		return FALSE

	var/category = lowertext("[entry["category"]]")
	if(category == TAT_ITEM_CATEGORY_WEAPON)
		return FALSE

	var/slot_group = lowertext("[entry["slot_group"]]")
	if(!length(slot_group))
		return FALSE
	if(slot_group == "misc")
		return FALSE

	return TRUE

/proc/tat_get_item_bucket_key(list/entry)
	if(!islist(entry))
		return null

	var/category = lowertext("[entry["category"]]")
	var/slot_group = lowertext("[entry["slot_group"]]")

	if(!length(category) || !length(slot_group))
		return null

	return "[category]|[slot_group]"

/proc/tat_get_item_icon_payload(item_path)
	if(!ispath(item_path, /obj/item))
		return null

	var/cache_key = "[item_path]"
	if(cache_key in GLOB.tat_item_icon_cache)
		return GLOB.tat_item_icon_cache[cache_key]

	var/obj/item/item_type = item_path

	var/icon_file = initial(item_type.icon)
	var/icon_state = initial(item_type.icon_state)

	var/icon_b64 = null
	if(icon_file)
		var/icon/render_icon = icon(icon_file, icon_state, SOUTH, 1)
		icon_b64 = render_icon ? icon2base64(render_icon) : null

	var/list/payload = list(
		"icon" = icon_b64,
		"icon_state" = "[icon_state]",
	)

	GLOB.tat_item_icon_cache[cache_key] = payload
	return payload

/proc/tat_get_item_catalog_cache()
	if(length(GLOB.tat_item_catalog_cache))
		return GLOB.tat_item_catalog_cache

	var/list/all_items = list(TAT_AVAILABLE_ITEMS_LIST)

	for(var/item_path in all_items)
		var/list/entry = all_items[item_path]
		if(!islist(entry))
			continue

		var/list/icon_payload = tat_get_item_icon_payload(item_path)

		GLOB.tat_item_catalog_cache["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"unlock_type" = entry["unlock_type"],
			"unlock_key" = entry["unlock_key"],
			"slot_group" = entry["slot_group"],
			"icon" = icon_payload ? icon_payload["icon"] : null,
			"icon_state" = icon_payload ? icon_payload["icon_state"] : null,
		)

	return GLOB.tat_item_catalog_cache

/proc/tat_ensure_item_related_paths_cache()
	if(length(GLOB.tat_item_related_paths_cache))
		return TRUE

	var/list/all_items = list(TAT_AVAILABLE_ITEMS_LIST)
	var/list/buckets = list()

	for(var/item_path in all_items)
		var/list/entry = all_items[item_path]
		if(!tat_item_entry_is_slot_limited(entry))
			continue

		var/bucket_key = tat_get_item_bucket_key(entry)
		if(!bucket_key)
			continue

		if(!islist(buckets[bucket_key]))
			buckets[bucket_key] = list()

		buckets[bucket_key] += item_path

	for(var/item_path in all_items)
		var/list/result = list(item_path)

		var/list/entry = all_items[item_path]
		if(tat_item_entry_is_slot_limited(entry))
			var/bucket_key = tat_get_item_bucket_key(entry)
			var/list/bucket = buckets[bucket_key]

			if(islist(bucket))
				for(var/related_path in bucket)
					if(related_path == item_path)
						continue
					result += related_path

		GLOB.tat_item_related_paths_cache[item_path] = result

	return TRUE

/proc/tat_get_item_related_dynamic_paths(item_path)
	var/list/result = list()

	if(!item_path)
		return result

	if(!ispath(item_path))
		item_path = text2path("[item_path]")

	if(!item_path)
		return result

	tat_ensure_item_related_paths_cache()

	var/list/cached = GLOB.tat_item_related_paths_cache[item_path]
	if(islist(cached))
		return cached

	result += item_path
	return result

/proc/tat_clear_item_static_ui_cache()
	if(islist(GLOB.tat_item_icon_cache))
		GLOB.tat_item_icon_cache.Cut()

	if(islist(GLOB.tat_item_catalog_cache))
		GLOB.tat_item_catalog_cache.Cut()

	if(islist(GLOB.tat_item_related_paths_cache))
		GLOB.tat_item_related_paths_cache.Cut()

	return TRUE
