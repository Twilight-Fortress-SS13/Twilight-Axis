/// UI-facing layer for TAT build (backend side).

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

	if(GLOB.tat_skill_entry_cache_ready && ("[skill_type]" in GLOB.tat_skill_entry_cache))
		return GLOB.tat_skill_entry_cache["[skill_type]"]

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
	GLOB.tat_skill_entry_cache["[skill_type]"] = result
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
	if(is_owner_tat_banned())
		return FALSE
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
	if(ok)
		stats?.sanitize()
	return ok

/datum/tat_build/proc/remove_stat(id, amount = 1)
	if(!stats)
		return FALSE
	var/current = stats.get_value(id)
	var/ok = stats.set_value(id, current - (text2num("[amount]") || 1), TRUE)
	return ok

/datum/tat_build/proc/add_skill(skill_type, amount = 1)
	if(!skills)
		return FALSE
	var/current = skills.get_invested_value(skill_type)
	var/ok = skills.set_invested_value(skill_type, current + (text2num("[amount]") || 1))
	if(ok)
		skills?.sanitize()
	return ok

/datum/tat_build/proc/remove_skill(skill_type, amount = 1)
	if(!skills)
		return FALSE
	var/current = skills.get_invested_value(skill_type)
	var/ok = skills.set_invested_value(skill_type, current - (text2num("[amount]") || 1), TRUE)
	return ok

/datum/tat_build/proc/add_trait(trait_id)
	var/ok = traits?.add_trait(trait_id)
	if(ok)
		traits?.sanitize()
		stats?.sanitize()
		skills?.refresh_after_trait_change()
		items?.sanitize()
	return ok

/datum/tat_build/proc/remove_trait(trait_id, amount = 1)
	if(!traits)
		return FALSE
	var/count = max(1, text2num("[amount]") || 1)
	var/changed = FALSE
	for(var/i in 1 to count)
		if(!traits.has_trait(trait_id))
			break
		if(traits.remove_trait(trait_id))
			changed = TRUE
		else
			break
	if(changed)
		traits?.sanitize()
		stats?.sanitize()
		skills?.refresh_after_trait_change()
		items?.sanitize()
	return changed

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_paid_amount(path)
	var/ok = items.set_amount(path, current + (text2num("[amount]") || 1))
	if(ok)
		items?.sanitize()
	return ok

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!items)
		return FALSE
	var/current = items.get_paid_amount(path)
	var/ok = items.set_amount(path, current - (text2num("[amount]") || 1), TRUE)
	return ok

/datum/tat_build/proc/move_item_to_bag(path, amount = 1)
	if(!items)
		return FALSE
	var/ok = items.move_item_from_stash_to_bag(path, text2num("[amount]") || 1)
	if(ok)
		set_dirty()
	return ok

/datum/tat_build/proc/move_item_to_stash(path, amount = 1)
	if(!items)
		return FALSE
	var/ok = items.move_item_from_bag_to_stash(path, text2num("[amount]") || 1)
	if(ok)
		set_dirty()
	return ok

/datum/tat_build/proc/paint_loadout_item(path, mob/user = null)
	if(!items)
		return FALSE
	var/ok = items.paint_loadout_item(path, user || usr)
	if(ok)
		set_dirty()
	return ok

/datum/tat_build/proc/move_item_to_equip(path, amount = 1)
	if(!items)
		return FALSE
	var/count = max(1, text2num("[amount]") || 1)
	var/total = items.get_amount(path)
	if(total <= 0)
		return FALSE
	var/changed = FALSE
	for(var/i in 1 to count)
		if(items.get_assigned_loadout_slot_count(path) >= total)
			break
		if(items.assign_item_to_first_available_loadout_slot(path))
			changed = TRUE
		else
			break
	items.normalize_loadout(path)
	if(changed)
		set_dirty()
	return changed

/datum/tat_build/proc/assign_item_to_loadout_slot(path, slot_id)
	if(!items)
		return FALSE
	var/ok = items.assign_item_to_loadout_slot(path, slot_id)
	if(ok)
		set_dirty()
	return ok

/datum/tat_build/proc/clear_loadout_slot(slot_id)
	if(!items)
		return FALSE
	var/ok = items.clear_loadout_slot(slot_id)
	if(ok)
		set_dirty()
	return ok

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
	if(GLOB.tat_skill_entry_cache_ready)
		return GLOB.tat_skill_entry_cache

	var/list/result = list()
	for(var/skill_type in get_all_ui_skill_types())
		var/list/entry = get_skill_entry(skill_type)
		if(!islist(entry))
			continue
		result["[skill_type]"] = entry

	GLOB.tat_skill_entry_cache = result
	GLOB.tat_skill_entry_cache_ready = TRUE
	return result

/datum/tat_build/proc/build_ui_skills()
	if(islist(ui_skills_cache))
		return ui_skills_cache

	var/list/result = list()
	if(!skills)
		for(var/skill_type in get_all_ui_skill_types())
			result["[skill_type]"] = list("level" = 0, "cap" = 0, "next_cost" = 0, "bonus" = 0, "invested" = 0)
		ui_skills_cache = result
		return result

	for(var/skill_type in get_all_ui_skill_types())
		var/cap = skills.get_maximum(skill_type)
		var/bonus_value = round(skills.bonus[skill_type] || 0)
		var/invested_value = round(skills.invested[skill_type] || 0)
		var/total_value = clamp(invested_value + bonus_value, 0, cap)
		var/invested_cap = max(0, cap - bonus_value)
		var/next_target = invested_value + 1
		var/next_cost = 0
		if(next_target > 0 && next_target <= invested_cap)
			next_cost = max(1, next_target - get_skill_cost_discount(skill_type, next_target))

		result["[skill_type]"] = list(
			"level" = total_value,
			"cap" = cap,
			"next_cost" = next_cost,
			"bonus" = bonus_value,
			"invested" = invested_value,
		)
	ui_skills_cache = result
	return result

/datum/tat_build/proc/build_ui_selected_traits()
	var/list/result = list()
	for(var/trait_id in traits.selected)
		var/count = traits.get_trait_count(trait_id)
		for(var/i in 1 to count)
			result += trait_id
	return result

/datum/tat_build/proc/build_ui_trait_counts()
	var/list/result = list()
	if(!traits)
		return result
	for(var/trait_id in traits.selected)
		var/count = traits.get_trait_count(trait_id)
		if(count > 0)
			result[trait_id] = count
	return result

/datum/tat_build/proc/build_ui_trait_entries()
	var/list/result = list()
	for(var/trait_id in GLOB.tat_available_traits)
		if(trait_id == TAT_TRAIT_CONTRACTOR_ENTITY && get_owner_ckey() != "mrix")
			continue
		var/list/entry = get_trait_entry(trait_id)
		if(!islist(entry))
			continue
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = get_trait_cost_display(trait_id),
			"category" = entry["category"],
			"category_name" = entry["category_name"],
			"desc" = entry["desc"],
			"repeatable" = traits?.is_repeatable_trait(trait_id),
			"maximum" = traits?.get_trait_maximum(trait_id),
		)
	return result

/datum/tat_build/proc/build_ui_items_static()
	items?.sync_external_grants()
	if(!GLOB.tat_item_icon_cache_ready)
		warm_tat_item_catalog()
	return GLOB.tat_item_catalog_cache

/datum/tat_build/proc/build_ui_items_state()
	if(islist(ui_items_state_cache))
		return ui_items_state_cache

	var/list/result = list()
	if(!items)
		ui_items_state_cache = result
		return result

	items.sync_external_grants()
	var/list/bucket_totals = list()
	for(var/item_path in items.get_all_item_paths())
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue
		if(entry["category"] != TAT_ITEM_CATEGORY_CLOTHING)
			continue
		var/slot_group = entry["slot_group"]
		if(!slot_group || slot_group == "misc")
			continue
		var/amount = items.get_amount(item_path)
		if(amount <= 0)
			continue
		var/bucket_key = "[entry["category"]]|[slot_group]"
		bucket_totals[bucket_key] = (bucket_totals[bucket_key] || 0) + amount

	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue

		var/unlocked = items.can_use_item_entry(entry)
		var/amount = items.get_amount(item_path)
		var/maximum = 0

		if(unlocked)
			var/cost = entry["cost"]
			if(!isnum(cost))
				cost = 0
			var/category = entry["category"]
			var/slot_group = entry["slot_group"]
			if(cost <= 0 && (category == "misc" || category == "weapon"))
				maximum = 1
			else if(category != TAT_ITEM_CATEGORY_CLOTHING || !slot_group || slot_group == "misc")
				maximum = 99
			else
				var/bucket_key = "[category]|[slot_group]"
				var/already_taken = bucket_totals[bucket_key] || 0
				var/own = amount
				maximum = max(0, 1 - (already_taken - own))

		result["[item_path]"] = list(
			"amount" = amount,
			"unlocked" = unlocked,
			"maximum" = maximum,
			"can_add" = amount < maximum,
		)
	ui_items_state_cache = result
	return result

/datum/tat_build/proc/build_ui_loadout()
	if(islist(ui_loadout_cache))
		return ui_loadout_cache

	var/list/result = list()
	if(!items)
		ui_loadout_cache = result
		return result
	items.sync_external_grants()
	for(var/item_path in items.get_all_item_paths())
		var/amount = items.get_amount(item_path)
		if(amount <= 0)
			continue
		items.normalize_loadout(item_path)
		var/list/loadout = items.get_loadout(item_path)
		var/list/exported_slots = list()
		var/list/slots = loadout["slots"]
		if(islist(slots))
			for(var/slot_id in slots)
				exported_slots[slot_id] = TRUE
		var/list/icon_payload = items.build_loadout_item_icon_payload(item_path)
		result["[item_path]"] = list(
			"amount" = amount,
			"equip" = round(loadout["equip"] || 0),
			"bag" = round(loadout["bag"] || 0),
			"stash" = round(loadout["stash"] || 0),
			"slots" = exported_slots,
			"valid_slots" = items.get_valid_loadout_ui_slots_for_item(item_path),
			"sources" = items.get_source_counts_for_ui(item_path),
			"paint" = items.get_paint_data_for_ui(item_path),
			"icon" = icon_payload?["icon"],
			"icon_state" = icon_payload?["icon_state"],
		)
	ui_loadout_cache = result
	return result

/datum/tat_build/proc/build_ui_tat_slot(slot_id)
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	var/list/summary = slot.get_summary(src)
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
	if(islist(ui_tat_slots_cache))
		return ui_tat_slots_cache

	init_tat_slots()
	var/list/result = list()
	for(var/i in 1 to TAT_SLOT_COUNT)
		result += list(build_ui_tat_slot(i))
	ui_tat_slots_cache = result
	return result

/datum/tat_build/ui_state(mob/user)
	return GLOB.always_state

/datum/tat_build/ui_interact(mob/user, datum/tgui/ui)
	attach_preferences_from_mob(user)
	if(is_owner_tat_banned(user))
		tat_tell_banned(user)
		return
	// Opening the window must sync external loadout grants immediately.
	// Otherwise donor/preference loadout changes can stay hidden behind a valid cached UI payload
	// until Save or another action forces sanitize/cache invalidation.
	items?.sync_external_grants()
	invalidate_ui_data_cache()
	if(!islist(_cached_active_virtues))
		skills?.rebuild_bonus_values()
		invalidate_ui_data_cache()
	if(ui)
		ui.set_autoupdate(FALSE)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TATBuild")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tat_build/ui_static_data(mob/user)
	attach_preferences_from_mob(user)
	if(is_owner_tat_banned(user))
		return list()
	items?.sync_external_grants()
	return list(
		"available_stats" = build_ui_stat_entries(),
		"available_skills" = build_ui_skill_entries(),
		"available_traits" = build_ui_trait_entries(),
		"available_items" = build_ui_items_static(),
	)

/datum/tat_build/ui_data(mob/user)
	attach_preferences_from_mob(user)
	if(is_owner_tat_banned(user))
		return list(
			"disabled" = TRUE,
			"disabled_reason" = tat_get_ban_reason(user?.ckey) || TAT_BAN_DEFAULT_REASON,
			"can_save" = FALSE,
		)
	if(islist(_cached_ui_data) && !_ui_data_cache_dirty)
		return _cached_ui_data
	var/list/_skp_total = build_ui_skill_points_by_domain()
	var/list/_skp_rem = build_ui_skill_points_remaining_by_domain()
	var/_p_skills_total = 0
	var/_p_skills_rem = 0
	var/_skills_any_negative = FALSE
	for(var/_d in _skp_total)
		_p_skills_total += _skp_total[_d]
	for(var/_d in _skp_rem)
		_p_skills_rem += _skp_rem[_d]
		if(_skp_rem[_d] < 0)
			_skills_any_negative = TRUE
	var/_p_stats_total = get_effective_stat_points_total()
	var/_p_stats_rem = get_remaining_stat_points()
	var/_p_traits_total = traits.get_total_maximum()
	var/_p_traits_rem = get_remaining_trait_points()
	var/_p_traits_capped_negative_raw = traits.get_capped_negative_credit_raw()
	var/_p_traits_capped_negative_used = traits.get_capped_negative_credit_used()
	items?.sync_external_grants()
	var/_p_items_total = items.get_total_maximum()
	var/_p_items_rem = get_remaining_item_points()

	var/list/validation = list()
	if(_p_stats_rem < 0)
		validation += "Spent too many stat points."
	if(_skills_any_negative)
		validation += "Spent too many skill points."
	if(_p_traits_rem < 0)
		validation += "Spent too many trait points."
	if(_p_items_rem < 0)
		validation += "Spent too many item points."
	var/list/trait_issues = traits.has_invalid_trait_dependencies()
	if(length(trait_issues))
		validation += trait_issues
	var/list/item_issues = items.has_invalid_supply_items()
	if(length(item_issues))
		validation += item_issues

	if(is_owner_tat_role_locked(user))
		validation += get_owner_tat_role_lock_message(user)

	var/can_save_build = !length(validation)
	var/list/_stats = build_ui_stats()
	var/list/_skills = build_ui_skills()
	var/list/_sel_traits = build_ui_selected_traits()
	var/list/_trait_counts = build_ui_trait_counts()
	var/list/_items_state = build_ui_items_state()
	var/list/_loadout = build_ui_loadout()
	var/list/_tat_slots = build_ui_tat_slots()

	_cached_ui_data = list(
		"stats" = _stats,
		"skills" = _skills,
		"traits" = _sel_traits,
		"trait_counts" = _trait_counts,
		"available_traits" = build_ui_trait_entries(),
		"items_state" = _items_state,
		"loadout" = _loadout,

		"points_stats" = _p_stats_total,
		"points_stats_remaining" = _p_stats_rem,

		"points_skills" = _p_skills_total,
		"points_skills_remaining" = _p_skills_rem,
		"skill_points_by_domain" = _skp_total,
		"skill_points_remaining_by_domain" = _skp_rem,

		"points_traits" = _p_traits_total,
		"points_traits_remaining" = _p_traits_rem,
		"negative_trait_credit_raw" = _p_traits_capped_negative_raw,
		"negative_trait_credit_used" = _p_traits_capped_negative_used,
		"negative_trait_credit_cap" = TAT_NEGATIVE_TRAIT_CREDIT_CAP,

		"points_items" = _p_items_total,
		"points_items_remaining" = _p_items_rem,

		"tat_slots" = _tat_slots,
		"active_tat_slot" = active_tat_slot,
		"can_save" = can_save_build,
		"validation_issues" = validation,
		"build_json" = last_exported_json,
		"last_json_error" = last_json_error,
		"last_json_notice" = last_json_notice,
		"dirty" = dirty,
	)
	_ui_data_cache_dirty = FALSE
	return _cached_ui_data

/datum/tat_build/ui_act(action, list/params)
	if(usr)
		attach_preferences_from_mob(usr)
		if(is_owner_tat_banned(usr))
			tat_tell_banned(usr)
			return FALSE
	else if(is_owner_tat_banned())
		return FALSE
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
			return remove_trait(params["id"], text2num(params["amount"]) || 1)
		if("add_item")
			return add_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("remove_item")
			return remove_item(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("move_item_to_equip")
			return move_item_to_equip(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("move_item_to_bag")
			return move_item_to_bag(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("move_item_to_stash")
			return move_item_to_stash(text2path(params["path"]), text2num(params["amount"]) || 1)
		if("paint_loadout_item")
			return paint_loadout_item(text2path(params["path"]), usr)
		if("assign_item_to_loadout_slot")
			return assign_item_to_loadout_slot(text2path(params["path"]), params["slot_id"])
		if("clear_loadout_slot")
			return clear_loadout_slot(params["slot_id"])
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
			if(is_owner_tat_role_locked(usr))
				to_chat(usr, span_warning(get_owner_tat_role_lock_message(usr)))
				return FALSE
			if(!can_save())
				return FALSE
			return save_current_to_active_slot()
		if("export_json")
			export_to_json()
			return TRUE
		if("import_json")
			return import_from_json(params["json"])

	return FALSE

/proc/tat_item_entry_is_slot_limited(list/entry)
	if(!islist(entry))
		return FALSE

	if(entry["category"] != TAT_ITEM_CATEGORY_CLOTHING)
		return FALSE

	var/slot_group = entry["slot_group"]
	if(!slot_group)
		return FALSE
	if(slot_group == "misc")
		return FALSE

	return TRUE
