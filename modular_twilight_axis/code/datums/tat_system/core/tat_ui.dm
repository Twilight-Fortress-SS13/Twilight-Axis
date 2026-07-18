/// UI-facing layer for TAT build (backend side).

/datum/tat_build/proc/get_ui_skill_domain_key(domain)
	if(domain == TAT_SKILL_DOMAIN_COMBAT)
		return "combat"
	if(domain == TAT_SKILL_DOMAIN_PEACEFUL)
		return "peaceful"
	if(domain == TAT_SKILL_DOMAIN_ADVENTURE)
		return "adventure"
	if(domain == TAT_SKILL_DOMAIN_WANDERING)
		return "adventure"
	if(domain == TAT_SKILL_DOMAIN_GATHERING)
		return "peaceful"
	if(domain == TAT_SKILL_DOMAIN_CRAFTING)
		return "peaceful"
	if(domain == TAT_SKILL_DOMAIN_MISC)
		return "adventure"
	return "adventure"

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

/datum/tat_build/proc/give_skill_domain_points(domain, amount = 1)
	if(!skills)
		return FALSE
	var/ok = skills.give_skill_domain_points(domain, text2num("[amount]") || 1)
	if(ok)
		skills.sanitize(FALSE)
		invalidate_ui_data_cache()
	return ok

/datum/tat_build/proc/take_skill_domain_points(domain, amount = 1)
	if(!skills)
		return FALSE
	var/ok = skills.take_skill_domain_points(domain, text2num("[amount]") || 1)
	if(ok)
		skills.sanitize(FALSE)
		invalidate_ui_data_cache()
	return ok

/datum/tat_build/proc/build_ui_skill_conversion_state()
	if(!skills)
		return list()
	return skills.build_skill_conversion_state()

/datum/tat_build/proc/build_ui_directions()
	if(!directions)
		return list()
	return directions.build_ui_state()

/datum/tat_build/proc/get_remaining_trait_points()
	return traits?.get_remaining_points() || 0

/datum/tat_build/proc/get_remaining_item_points()
	return items?.get_remaining_points() || 0

/datum/tat_build/proc/build_ui_skill_points_by_domain()
	var/list/result = list(
		"combat" = 0,
		"peaceful" = 0,
		"adventure" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_COMBAT)
	result["peaceful"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_PEACEFUL)
	result["adventure"] = skills.get_total_maximum(TAT_SKILL_DOMAIN_ADVENTURE)

	return result

/datum/tat_build/proc/build_ui_skill_points_remaining_by_domain()
	var/list/result = list(
		"combat" = 0,
		"peaceful" = 0,
		"adventure" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_COMBAT)
	result["peaceful"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_PEACEFUL)
	result["adventure"] = skills.get_remaining_points(TAT_SKILL_DOMAIN_ADVENTURE)

	return result

/datum/tat_build/proc/build_ui_skill_free_points_by_domain()
	var/list/result = list(
		"combat" = 0,
		"peaceful" = 0,
		"adventure" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_free_domain_points(TAT_SKILL_DOMAIN_COMBAT)
	result["peaceful"] = skills.get_free_domain_points(TAT_SKILL_DOMAIN_PEACEFUL)
	result["adventure"] = skills.get_free_domain_points(TAT_SKILL_DOMAIN_ADVENTURE)

	return result

/datum/tat_build/proc/build_ui_skill_trait_points_by_domain()
	var/list/result = list(
		"combat" = 0,
		"peaceful" = 0,
		"adventure" = 0,
	)

	if(!skills)
		return result

	result["combat"] = skills.get_trait_domain_points(TAT_SKILL_DOMAIN_COMBAT)
	result["peaceful"] = skills.get_trait_domain_points(TAT_SKILL_DOMAIN_PEACEFUL)
	result["adventure"] = skills.get_trait_domain_points(TAT_SKILL_DOMAIN_ADVENTURE)

	return result

/datum/tat_build/proc/build_ui_skill_point_breakdown_by_domain()
	var/list/result = list(
		"combat" = list("base" = 0, "trait" = 0, "expert" = 0, "master" = 0, "converted" = 0),
		"peaceful" = list("base" = 0, "trait" = 0, "converted" = 0),
		"adventure" = list("base" = 0, "trait" = 0, "converted" = 0),
	)

	if(!skills)
		return result

	var/list/default_domain_points = TAT_DEFAULT_SKILL_DOMAIN_POINTS
	for(var/domain in result)
		var/list/breakdown = result[domain]
		var/default_points = max(0, round(default_domain_points[domain] || 0))
		var/current_domain_points = max(0, round(skills.domain_points[domain] || 0))
		breakdown["base"] = max(0, round(min(current_domain_points, default_points) + get_role_skill_domain_points(domain) - skills.get_converted_role_points(domain)))
		breakdown["trait"] = skills.get_trait_domain_points(domain)
		breakdown["converted"] = skills.get_converted_domain_points(domain)

	var/list/combat_breakdown = result["combat"]
	var/expert_points = skills.get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_EXPERT, TAT_SKILL_DOMAIN_COMBAT)
	var/master_points = skills.get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_MASTER, TAT_SKILL_DOMAIN_COMBAT)
	combat_breakdown["expert"] = expert_points
	combat_breakdown["master"] = master_points
	combat_breakdown["trait"] = max(0, round(combat_breakdown["trait"] || 0) - expert_points - master_points)
	var/combat_total = skills.get_total_maximum(TAT_SKILL_DOMAIN_COMBAT)
	var/combat_spent = skills.get_spent_points(TAT_SKILL_DOMAIN_COMBAT)
	var/expert_spent = min(expert_points, skills.get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT))
	var/master_spent = min(master_points, skills.get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER))
	var/restricted_total = expert_points + master_points
	var/restricted_spent = min(restricted_total, expert_spent + master_spent)
	var/normal_total = max(0, combat_total - restricted_total)
	var/normal_spent = min(normal_total, max(0, combat_spent - restricted_spent))
	combat_breakdown["normal_total"] = normal_total
	combat_breakdown["normal_spent"] = normal_spent
	combat_breakdown["normal_remaining"] = max(0, normal_total - normal_spent)
	combat_breakdown["expert_master_total"] = restricted_total
	combat_breakdown["expert_master_spent"] = restricted_spent
	combat_breakdown["expert_master_remaining"] = max(0, restricted_total - restricted_spent)

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

/datum/tat_build/proc/reset_directions()
	directions?.reset()
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
		directions?.sanitize()
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
		directions?.sanitize()
		traits?.sanitize()
		stats?.sanitize()
		skills?.refresh_after_trait_change()
		items?.sanitize()
	return changed

/datum/tat_build/proc/set_direction_foundation(foundation)
	if(!directions)
		return FALSE
	var/ok = directions.set_foundation(foundation)
	if(ok)
		sanitize()
		set_dirty()
	return ok

/datum/tat_build/proc/set_direction_role_choice(role_choice)
	if(!directions)
		return FALSE
	var/ok = directions.set_role_choice(role_choice)
	if(ok)
		sanitize()
		set_dirty()
	return ok

/datum/tat_build/proc/add_direction_point(direction, amount = 1)
	if(!directions)
		return FALSE
	var/ok = directions.add_point(direction, amount)
	if(ok)
		sanitize()
		set_dirty()
	return ok

/datum/tat_build/proc/remove_direction_point(direction, amount = 1)
	if(!directions)
		return FALSE
	var/ok = directions.remove_point(direction, amount)
	if(ok)
		sanitize()
		set_dirty()
	return ok

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
		var/bonus_value = skills.get_bonus_value(skill_type)
		var/invested_value = round(skills.invested[skill_type] || 0)
		var/total_value = skills.get_total_value(skill_type)
		var/invested_cap = max(0, cap - bonus_value)
		var/next_target = invested_value + 1
		var/next_cost = 0
		if(next_target > 0 && next_target <= invested_cap)
			next_cost = max(1, next_target - get_skill_cost_discount(skill_type, next_target))
			var/domain = skills.get_domain(skill_type)
			var/current_cost = skills.get_total_cost_for_level(skill_type, invested_value)
			var/new_domain_spent = skills.get_spent_points(domain) - current_cost + skills.get_total_cost_for_level(skill_type, next_target)
			if(new_domain_spent > skills.get_total_maximum(domain))
				next_cost = 0
			else if(domain == TAT_SKILL_DOMAIN_COMBAT && !skills.combat_budget_is_valid(new_domain_spent, skill_type, next_target))
				next_cost = 0

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
	if(!traits)
		return result
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

/datum/tat_build/proc/build_ui_effective_traits()
	var/list/result = list()
	if(!traits)
		return result
	var/list/effective_traits = traits.get_effective_trait_counts()
	for(var/trait_id in effective_traits)
		var/count = round(effective_traits[trait_id] || 0)
		for(var/i in 1 to count)
			result += trait_id
	return result

/datum/tat_build/proc/build_ui_effective_trait_counts()
	var/list/result = list()
	if(!traits)
		return result
	var/list/effective_traits = traits.get_effective_trait_counts()
	for(var/trait_id in effective_traits)
		var/count = round(effective_traits[trait_id] || 0)
		if(count > 0)
			result[trait_id] = count
	return result

/datum/tat_build/proc/build_ui_external_trait_counts()
	var/list/result = list()
	if(!traits)
		return result
	var/list/external_traits = traits.get_external_traits()
	for(var/trait_id in external_traits)
		result[trait_id] = 1
	return result

/datum/tat_build/proc/build_ui_trait_entries()
	var/list/result = list()
	for(var/trait_id in GLOB.tat_available_traits)
		if(trait_id == TAT_TRAIT_CONTRACTOR_ENTITY && get_owner_ckey() != "mrix")
			continue
		if(trait_id == TAT_TRAIT_WEAPON_TRAINING && !((directions?.get_role_choice()) in list(TAT_ROLE_CHOICE_TOWNER, TAT_ROLE_CHOICE_TRADER)))
			continue
		if(traits?.is_resident_only_hunter_trait(trait_id) && directions?.get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
			continue
		if(trait_id == TAT_TRAIT_BONUS_STAT_POOL && traits?.is_wanderer_role_choice(directions?.get_role_choice()))
			continue
		if(directions?.is_role_trait(trait_id))
			continue
		var/list/entry = get_trait_entry(trait_id)
		if(!islist(entry))
			continue
		if(!directions?.is_direction_trait(trait_id))
			continue
		var/can_add = traits?.can_select_trait(trait_id)
		var/lock_reason = traits?.get_trait_requirement_block_reason(trait_id) || directions?.get_trait_block_reason(trait_id)
		if(!lock_reason && !can_add)
			if(trait_id == TAT_TRAIT_CONTRACTOR && !can_select_contractor_trait())
				lock_reason = "Contractor is not available for this character."
			else if(trait_id == TAT_TRAIT_DRUID_INITIATE && !can_select_druid_initiate_trait())
				lock_reason = "Requires Dendor as patron."
			else if(trait_id == TAT_TRAIT_BONUS_STAT_POOL && directions?.foundation != TAT_FOUNDATION_SETTLED)
				lock_reason = "Requires Shenanigans foundation."
			else if(trait_id == TAT_TRAIT_TRADER_LICENSE && directions?.get_role_choice() != TAT_ROLE_CHOICE_TRADER)
				lock_reason = "Requires Trader role."
			else if(traits?.is_pq_locked_trait(trait_id))
				lock_reason = "Requires [traits.get_pq_lock_minimum(trait_id)] player quality."
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = get_trait_cost_display(trait_id),
			"desc" = entry["desc"],
			"repeatable" = traits?.is_repeatable_trait(trait_id),
			"maximum" = traits?.get_trait_maximum(trait_id),
			"external" = traits?.has_external_trait(trait_id),
			"can_add" = can_add,
			"direction" = directions?.get_trait_direction(trait_id),
			"direction_cost" = directions?.get_trait_cost(trait_id),
			"direction_tier" = directions?.get_trait_tier(trait_id),
			"direction_requirement_map" = directions?.get_trait_requirements(trait_id),
			"direction_requirements" = directions?.get_trait_requirement_text(trait_id),
			"direction_locked_reason" = lock_reason,
			"direction_point_bonus" = traits?.get_oddity_direction_point_bonus(trait_id),
			"ordinary_group" = traits?.get_ordinary_trait_group(trait_id),
		)
	return result

/datum/tat_build/proc/build_ui_items_static()
	items?.sync_external_grants()
	if(!GLOB.tat_item_icon_cache_ready)
		warm_tat_item_catalog()
	var/list/result = list()
	for(var/item_path in GLOB.tat_item_catalog_cache)
		var/list/entry = GLOB.tat_item_catalog_cache[item_path]
		if(!islist(entry))
			continue
		var/list/copy = entry.Copy()
		copy["base_cost"] = copy["cost"]
		copy["cost"] = items?.get_cost(text2path("[item_path]")) || copy["cost"]
		result[item_path] = copy
	return result

/datum/tat_build/proc/build_ui_items_state()
	if(islist(ui_items_state_cache))
		return ui_items_state_cache

	var/list/result = list()
	if(!items)
		ui_items_state_cache = result
		return result

	items.sync_external_grants()
	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue

		// The Items tab is the TAT purchase shop, not the full roundstart loadout.
		// Donor/preference loadout copies are stored and shown in the Loadout stash,
		// but they do not count as bought items and do not consume slot/category caps.
		var/unlocked = items.can_use_item_entry(entry)
		var/amount = items.get_paid_amount(item_path)
		var/maximum = unlocked ? items.get_maximum(item_path) : 0

		result["[item_path]"] = list(
			"amount" = amount,
			"unlocked" = unlocked,
			"soft_locked" = items.is_supply_soft_locked(entry),
			"maximum" = maximum,
			"can_add" = amount < maximum,
			"cost" = items.get_cost(item_path),
			"base_cost" = items.get_base_cost(item_path),
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
	var/list/build_data = slot.get_build_data()
	var/list/summary = build_slot_summary_from_data(build_data)
	var/list/role_status = build_ui_role_status_for_data(build_data)
	var/name = istext(slot.name) && length(slot.name) ? slot.name : get_default_tat_slot_name(slot_id)
	return list(
		"id" = slot_id,
		"name" = name,
		"active" = (active_tat_slot == slot_id),
		"role_bucket" = role_status["role_bucket"],
		"role_name" = role_status["role_name"],
		"role_text" = role_status["role_text"],
		"min_pq" = role_status["min_pq"],
		"player_pq" = role_status["player_pq"],
		"pq_missing" = role_status["pq_missing"],
		"pq_locked" = role_status["pq_locked"],
		"pq_lock_text" = role_status["pq_lock_text"],
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
		skills?.sanitize(FALSE)
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
	var/list/_skp_free = build_ui_skill_free_points_by_domain()
	var/list/_skp_trait = build_ui_skill_trait_points_by_domain()
	var/list/_skp_breakdown = build_ui_skill_point_breakdown_by_domain()
	var/list/_skp_conversion_state = build_ui_skill_conversion_state()
	var/_skp_conversion_pool = skills?.skill_point_conversion_pool || 0
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
	items?.sync_external_grants()
	var/_p_items_total = items.get_total_maximum()
	var/_p_items_rem = get_remaining_item_points()

	var/list/validation = list()
	if(_p_stats_rem < 0)
		validation += "Spent too many stat points."
	if(_skills_any_negative)
		validation += "Spent too many skill points."
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
	var/list/_effective_traits = build_ui_effective_traits()
	var/list/_effective_trait_counts = build_ui_effective_trait_counts()
	var/list/_external_trait_counts = build_ui_external_trait_counts()
	var/list/_items_state = build_ui_items_state()
	var/list/_loadout = build_ui_loadout()
	var/list/_tat_slots = build_ui_tat_slots()
	var/list/_directions = build_ui_directions()

	_cached_ui_data = list(
		"stats" = _stats,
		"skills" = _skills,
		"traits" = _sel_traits,
		"trait_counts" = _trait_counts,
		"effective_traits" = _effective_traits,
		"effective_trait_counts" = _effective_trait_counts,
		"external_trait_counts" = _external_trait_counts,
		"available_traits" = build_ui_trait_entries(),
		"directions" = _directions,
		"items_state" = _items_state,
		"loadout" = _loadout,

		"points_stats" = _p_stats_total,
		"points_stats_remaining" = _p_stats_rem,

		"points_skills" = _p_skills_total,
		"points_skills_remaining" = _p_skills_rem,
		"skill_points_by_domain" = _skp_total,
		"skill_points_remaining_by_domain" = _skp_rem,
		"skill_free_points_by_domain" = _skp_free,
		"skill_trait_points_by_domain" = _skp_trait,
		"skill_point_breakdown_by_domain" = _skp_breakdown,
		"skill_conversion_pool" = _skp_conversion_pool,
		"skill_conversion_state" = _skp_conversion_state,

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
		if("give_skill_domain_points")
			return give_skill_domain_points(params["domain"], text2num(params["amount"]) || 1)
		if("take_skill_domain_points")
			return take_skill_domain_points(params["domain"], text2num(params["amount"]) || 1)
		if("add_trait")
			return add_trait(params["id"])
		if("remove_trait")
			return remove_trait(params["id"], text2num(params["amount"]) || 1)
		if("set_direction_foundation")
			return set_direction_foundation(params["foundation"])
		if("set_direction_role_choice")
			return set_direction_role_choice(params["role_choice"])
		if("add_direction_point")
			return add_direction_point(params["direction"], text2num(params["amount"]) || 1)
		if("remove_direction_point")
			return remove_direction_point(params["direction"], text2num(params["amount"]) || 1)
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
		if("reset_directions")
			return reset_directions()
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
