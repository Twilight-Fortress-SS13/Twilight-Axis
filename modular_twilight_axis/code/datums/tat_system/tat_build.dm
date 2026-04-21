#define TAT_SLOT_COUNT 3

/datum/tat_build
	var/list/available_stats = list()
	var/list/available_skills = list()
	var/list/available_traits = list()
	var/list/available_items = list()

	var/points_stats = 4
	var/points_skills = 40
	var/points_traits = 12
	var/points_items = 20

	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/items = list()
	var/list/item_loadout = list()
	var/list/magic_config = list()

	var/dirty = FALSE
	var/list/stat_order = TAT_STATS_ORDER_LIST
	var/list/item_icon_cache = list()

	var/list/tat_slots = list()
	var/active_tat_slot = 1
	var/datum/preferences/owner_preferences = null

	var/list/ui_item_catalog_cache = null
	var/list/ui_item_states_cache = null
	var/ui_item_states_cache_dirty = TRUE

	var/ui_item_cache_requested = FALSE
	var/ui_item_cache_pending_full = FALSE
	var/ui_item_cache_pending_states = FALSE

/datum/tat_build/New()
	. = ..()
	init_available_stats()
	init_available_skills()
	init_available_traits()
	init_available_items()
	reset_build()
	init_tat_slots()

/datum/tat_build/proc/init_available_stats()
	available_stats = list(
		TAT_AVAILABLE_STATS_LIST
	)

/datum/tat_build/proc/init_available_skills()
	available_skills = list()
	for(var/path in subtypesof(/datum/skill))
		if(path == /datum/skill)
			continue
		if(is_skill_blocked(path))
			continue
		var/datum/skill/skill = new path
		if(initial(skill.abstract_type) == path)
			qdel(skill)
			continue
		available_skills[path] = list(
			"name" = initial(skill.name),
			"desc" = initial(skill.desc),
			"category" = "[initial(skill.abstract_type)]",
			"is_combat" = ispath(path, /datum/skill/combat),
		)
		qdel(skill)

/datum/tat_build/proc/init_available_traits()
	available_traits = list(
		TAT_AVAILABLE_TRAITS_LIST
	)

/datum/tat_build/proc/init_available_items()
	available_items = list(TAT_AVAILABLE_ITEMS_LIST)

/datum/tat_build/proc/get_item_loadout_entry(item_path)
	if(!(item_path in item_loadout) || !islist(item_loadout[item_path]))
		var/default_equip = 0
		if(item_path in items)
			default_equip = max(0, round(text2num("[items[item_path]]")))
		item_loadout[item_path] = list(
			"equip" = default_equip,
			"bag" = 0,
		)
	return item_loadout[item_path]

/datum/tat_build/proc/normalize_item_loadout(item_path)
	if(!(item_path in items))
		item_loadout -= item_path
		return
	var/total_amount = items[item_path]
	if(!isnum(total_amount) || total_amount <= 0)
		item_loadout -= item_path
		return
	var/list/loadout
	var/is_new_entry = FALSE
	if(!(item_path in item_loadout) || !islist(item_loadout[item_path]))
		loadout = list(
			"equip" = total_amount,
			"bag" = 0,
		)
		item_loadout[item_path] = loadout
		is_new_entry = TRUE
	else
		loadout = item_loadout[item_path]
	var/equip_amount = round(text2num("[loadout["equip"]]"))
	var/bag_amount = round(text2num("[loadout["bag"]]"))
	if(equip_amount < 0)
		equip_amount = 0
	if(bag_amount < 0)
		bag_amount = 0
	if(equip_amount > total_amount)
		equip_amount = total_amount
	var/remaining = total_amount - equip_amount
	if(bag_amount > remaining)
		bag_amount = remaining
	if(!is_new_entry && (equip_amount + bag_amount) < total_amount)
		equip_amount += total_amount - (equip_amount + bag_amount)
	loadout["equip"] = equip_amount
	loadout["bag"] = bag_amount

/datum/tat_build/proc/get_item_equip_amount(item_path)
	if(!(item_path in items))
		return 0
	normalize_item_loadout(item_path)
	var/list/loadout = get_item_loadout_entry(item_path)
	return loadout["equip"] || 0

/datum/tat_build/proc/get_item_bag_amount(item_path)
	if(!(item_path in items))
		return 0
	normalize_item_loadout(item_path)
	var/list/loadout = get_item_loadout_entry(item_path)
	return loadout["bag"] || 0

/datum/tat_build/proc/get_magic_value(key, default_value = null)
	if(!islist(magic_config))
		magic_config = list()
	if(!(key in magic_config))
		return default_value
	return magic_config[key]

/datum/tat_build/proc/set_magic_value(key, value)
	if(!islist(magic_config))
		magic_config = list()
	if(isnull(value))
		magic_config -= key
	else
		magic_config[key] = value
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/reset_items()
	items = list()
	item_loadout = list()
	invalidate_item_ui_cache()
	dirty = TRUE

/datum/tat_build/proc/set_stat_value(stat_id, value)
	if(!(stat_id in available_stats))
		return FALSE
	value = round(value)
	value = clamp(value, get_stat_hard_min(stat_id), get_stat_max(stat_id))
	if(value == get_stat_base(stat_id))
		stats -= stat_id
	else
		stats[stat_id] = value
	return TRUE

/datum/tat_build/proc/remove_items_by_unlock(unlock_type, unlock_key)
	for(var/item_path in items.Copy())
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		if(entry["unlock_type"] == unlock_type && entry["unlock_key"] == unlock_key)
			items -= item_path
			item_loadout -= item_path

/datum/tat_build/proc/sanitize_stats()
	for(var/stat_id in available_stats)
		set_stat_value(stat_id, get_stat_value(stat_id))
	while(get_remaining_stat_points() < 0)
		var/changed = FALSE
		for(var/stat_id in available_stats)
			var/current = get_stat_value(stat_id)
			var/base = get_stat_base(stat_id)
			if(current > base)
				set_stat_value(stat_id, current - 1)
				changed = TRUE
				if(get_remaining_stat_points() >= 0)
					break
		if(!changed)
			break

/datum/tat_build/proc/sanitize_traits()
	var/list/cleaned = list()
	for(var/trait_id in traits)
		if(trait_id in available_traits)
			cleaned[trait_id] = TRUE
	traits = cleaned
	has_invalid_trait_dependencies()

/datum/tat_build/proc/sanitize_magic()
	if(!islist(magic_config))
		magic_config = list()
	if(!traits[TAT_TRAIT_DIVINE_INITIATE])
		magic_config -= "divine_tier"
		magic_config -= "divine_passive_gain"
		magic_config -= "divine_devotion_limit"
	if(!traits[TAT_TRAIT_MAGE_INITIATE])
		magic_config -= "mage_aspects"
		magic_config -= "mage_spellbook"
	if(!traits[TAT_TRAIT_DRUID_INITIATE])
		magic_config -= "druid_force_dendor"
		magic_config -= "druid_alert"
	if(!traits[TAT_TRAIT_WITCH_INITIATE])
		magic_config -= "witch_path"

/datum/tat_build/proc/sanitize_skills()
	for(var/skill_type in skills.Copy())
		if(is_skill_blocked(skill_type))
			skills -= skill_type
			continue
		if(!(skill_type in available_skills))
			skills -= skill_type
			continue
		var/value = round(skills[skill_type])
		value = clamp(value, 0, get_skill_cap(skill_type))
		if(value > 0)
			skills[skill_type] = value
		else
			skills -= skill_type

/datum/tat_build/proc/sanitize_items()
	for(var/item_path in items.Copy())
		if(!(item_path in available_items))
			items -= item_path
			item_loadout -= item_path
			continue
		var/value = round(items[item_path])
		if(value <= 0)
			items -= item_path
			item_loadout -= item_path
			continue
		var/list/entry = available_items[item_path]
		if(!can_use_item_entry(entry))
			items -= item_path
			item_loadout -= item_path
			continue
		var/max_allowed = get_max_amount_for_item(item_path)
		if(max_allowed <= 0)
			items -= item_path
			item_loadout -= item_path
			continue
		if(max_allowed != INFINITY)
			value = min(value, max_allowed)
		if(value <= 0)
			items -= item_path
			item_loadout -= item_path
			continue
		items[item_path] = value
		normalize_item_loadout(item_path)

/datum/tat_build/proc/sanitize_build()
	sanitize_traits()
	sanitize_magic()
	sanitize_skills()
	sanitize_items()
	sanitize_stats()

/datum/tat_build/proc/reset_build()
	reset_stats()
	reset_skills()
	reset_traits()
	reset_items()
	reset_magic()
	invalidate_item_ui_cache()
	dirty = TRUE

/datum/tat_build/proc/reset_stats()
	stats = list()
	dirty = TRUE

/datum/tat_build/proc/reset_skills()
	skills = list()
	invalidate_item_ui_cache()
	dirty = TRUE

/datum/tat_build/proc/reset_traits()
	traits = list()
	invalidate_item_ui_cache()
	dirty = TRUE

/datum/tat_build/proc/reset_magic()
	magic_config = list()
	dirty = TRUE

/datum/tat_build/proc/add_stat(id, amount = 1)
	if(!id || !isnum(amount) || !(id in available_stats))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/current = get_stat_value(id)
	var/new_value = current + amount
	if(new_value > get_stat_max(id))
		return FALSE
	var/old_delta = get_stat_point_delta_for_value(id, current)
	var/new_delta = get_stat_point_delta_for_value(id, new_value)
	if(get_remaining_stat_points() < (new_delta - old_delta))
		return FALSE
	set_stat_value(id, new_value)
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_stat(id, amount = 1)
	if(!id || !isnum(amount) || !(id in available_stats))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/current = get_stat_value(id)
	var/new_value = current - amount
	if(new_value < get_stat_hard_min(id))
		return FALSE
	set_stat_value(id, new_value)
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount) || !(skill_type in available_skills))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/current = get_skill_value(skill_type)
	var/new_value = current + amount
	if(new_value > get_skill_cap(skill_type))
		return FALSE
	var/cost = 0
	for(var/i in 1 to amount)
		cost += current + i
	if(get_remaining_skill_points() < cost)
		return FALSE
	skills[skill_type] = new_value
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/remove_skill(skill_type, amount = 1)
	if(!ispath(skill_type) || !isnum(amount) || !(skill_type in available_skills))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/current = get_skill_value(skill_type)
	if(current <= 0)
		return FALSE
	var/new_value = max(0, current - amount)
	if(new_value > 0)
		skills[skill_type] = new_value
	else
		skills -= skill_type
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/add_trait(trait_id)
	if(!trait_id || !(trait_id in available_traits) || traits[trait_id])
		return FALSE
	if(get_remaining_trait_points() < get_trait_cost(trait_id))
		return FALSE
	traits[trait_id] = TRUE
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id || !traits[trait_id])
		return FALSE
	traits -= trait_id
	sanitize_magic()
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/add_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in available_items))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/list/entry = available_items[path]
	if(!can_use_item_entry(entry))
		return FALSE
	var/max_add = get_max_amount_for_item(path)
	if(max_add <= 0)
		return FALSE
	amount = min(amount, max_add)
	if(amount <= 0)
		return FALSE
	var/cost = get_item_cost(path) * amount
	if(get_remaining_item_points() < cost)
		return FALSE
	items[path] = (items[path] || 0) + amount
	normalize_item_loadout(path)
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/remove_item(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in items))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	var/current = items[path] - amount
	if(current > 0)
		items[path] = current
		normalize_item_loadout(path)
	else
		items -= path
		item_loadout -= path
	dirty = TRUE
	invalidate_item_ui_cache()
	return TRUE

/datum/tat_build/proc/move_item_to_equip(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in items))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	normalize_item_loadout(path)
	var/list/loadout = get_item_loadout_entry(path)
	var/bag_amount = loadout["bag"] || 0
	if(bag_amount < amount)
		return FALSE
	loadout["bag"] = bag_amount - amount
	loadout["equip"] = (loadout["equip"] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/move_item_to_bag(path, amount = 1)
	if(!ispath(path) || !isnum(amount) || !(path in items))
		return FALSE
	amount = round(amount)
	if(amount <= 0)
		return FALSE
	normalize_item_loadout(path)
	var/list/loadout = get_item_loadout_entry(path)
	var/equip_amount = loadout["equip"] || 0
	if(equip_amount < amount)
		return FALSE
	loadout["equip"] = equip_amount - amount
	loadout["bag"] = (loadout["bag"] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/validate_for_save()
	sanitize_build()
	return !has_invalid_trait_dependencies() && !has_invalid_supply_items() && is_budget_valid()

/datum/tat_build/proc/can_save()
	return validate_for_save()

/datum/tat_build/proc/export_to_list()
	init_tat_slots()
	var/list/final_data =list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
		"item_loadout" = item_loadout.Copy(),
		"magic_config" = magic_config.Copy(),
		"tat_slots" = export_tat_slots_to_list(),
		"active_tat_slot" = active_tat_slot,
	)
	return final_data

/datum/tat_build/proc/load_from_list(list/L)
	reset_build()
	init_tat_slots()

	if(!islist(L))
		load_tat_slots_from_list(null, 1)
		dirty = FALSE
		return

	var/list/_stats = L["stats"]
	var/list/_skills = L["skills"]
	var/list/_traits = L["traits"]
	var/list/_items = L["items"]
	var/list/_item_loadout = L["item_loadout"]
	var/list/_magic_config = L["magic_config"]
	var/list/_tat_slots = L["tat_slots"]
	var/_active_tat_slot = L["active_tat_slot"]

	if(islist(_tat_slots) || !isnull(_active_tat_slot))
		load_tat_slots_from_list(_tat_slots, _active_tat_slot)
	else
		load_tat_slots_from_list(null, 1)

	if(islist(_stats))
		for(var/stat_id in available_stats)
			if(isnum(_stats[stat_id]))
				set_stat_value(stat_id, _stats[stat_id])

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(trait_id in available_traits)
				traits[trait_id] = TRUE

	if(islist(_skills))
		for(var/skill_type in _skills)
			if(ispath(skill_type) && isnum(_skills[skill_type]) && (skill_type in available_skills))
				var/value = round(_skills[skill_type])
				if(value > 0)
					skills[skill_type] = value

	if(islist(_items))
		for(var/item_path in _items)
			if(ispath(item_path) && isnum(_items[item_path]) && (item_path in available_items))
				var/value = round(_items[item_path])
				if(value > 0)
					items[item_path] = value

	if(islist(_item_loadout))
		for(var/item_path in _item_loadout)
			if(!(item_path in items))
				continue
			if(!islist(_item_loadout[item_path]))
				continue
			var/list/saved_loadout = _item_loadout[item_path]
			item_loadout[item_path] = list(
				"equip" = round(text2num("[saved_loadout["equip"]]")),
				"bag" = round(text2num("[saved_loadout["bag"]]")),
			)

	if(islist(_magic_config))
		magic_config = _magic_config.Copy()

	sanitize_build()
	dirty = FALSE

/datum/tat_build/proc/is_skill_blocked(skill_type)
	if(!ispath(skill_type, /datum/skill))
		return TRUE
	return (skill_type in TAT_BLOCKED_SKILLS_LIST)

/datum/tat_build/proc/get_default_tat_slot_name(slot_id)
	return "Slot [slot_id]"

/datum/tat_build/proc/normalize_tat_slot_index(slot_id)
	var/index = round(text2num("[slot_id]"))
	if(index < 1)
		index = 1
	if(index > TAT_SLOT_COUNT)
		index = TAT_SLOT_COUNT 
	return index

/datum/tat_build/proc/attach_preferences(datum/preferences/P)
	owner_preferences = P
	return TRUE

/datum/tat_build/proc/init_tat_slots()
	if(!islist(tat_slots))
		tat_slots = list()

	while(tat_slots.len < 3)
		tat_slots += null

	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = tat_slots[i]

		if(!istype(slot, /datum/tat_slot))
			slot = new /datum/tat_slot(get_default_tat_slot_name(i))
			tat_slots[i] = slot

		if(!istext(slot.name) || !length(slot.name))
			slot.name = get_default_tat_slot_name(i)

		if(!islist(slot.build_data))
			slot.set_build_data(list())

	active_tat_slot = normalize_tat_slot_index(active_tat_slot)
	return TRUE

/datum/tat_build/proc/get_tat_slot(slot_id) as /datum/tat_slot
	init_tat_slots()

	var/index = normalize_tat_slot_index(slot_id)
	var/datum/tat_slot/slot = tat_slots[index]

	if(!istype(slot, /datum/tat_slot))
		slot = new /datum/tat_slot(get_default_tat_slot_name(index))
		tat_slots[index] = slot

	if(!istext(slot.name) || !length(slot.name))
		slot.name = get_default_tat_slot_name(index)

	if(!islist(slot.build_data))
		slot.set_build_data(list())

	return slot

/datum/tat_build/proc/build_slot_summary_from_data(list/build_data)
	var/list/summary = list(
		"stats" = 0,
		"skills" = 0,
		"traits" = 0,
		"items" = 0,
	)
	if(!islist(build_data) || !length(build_data))
		return summary

	var/datum/tat_build/temp = new /datum/tat_build()
	temp.load_slot_build_from_list(build_data)
	summary["stats"] = temp.get_total_stat_point_delta()
	summary["skills"] = temp.get_spent_skill_points()
	summary["traits"] = temp.get_spent_trait_points()
	summary["items"] = temp.get_spent_item_points()
	qdel(temp)
	return summary

/datum/tat_build/proc/save_current_to_slot(slot_id)
	init_tat_slots()

	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot)
		return FALSE

	slot.set_build_data(export_slot_build_to_list())
	return TRUE

/datum/tat_build/proc/save_current_to_active_slot()
	if(!save_current_to_slot(active_tat_slot))
		return FALSE

	dirty = FALSE
	return TRUE

/datum/tat_build/proc/load_slot_into_current(slot_id)
	init_tat_slots()

	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot)
		return FALSE

	var/list/build_data = slot.get_build_data()
	if(!islist(build_data) || !length(build_data))
		reset_build()
		dirty = FALSE
		return TRUE

	load_slot_build_from_list(build_data)
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/set_active_tat_slot(slot_id)
	init_tat_slots()

	active_tat_slot = normalize_tat_slot_index(slot_id)

	if(!load_slot_into_current(active_tat_slot))
		return FALSE

	dirty = FALSE
	return TRUE

/datum/tat_build/proc/rename_tat_slot(slot_id, new_name)
	init_tat_slots()

	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot)
		return FALSE

	if(!istext(new_name))
		return FALSE

	new_name = trim(new_name)
	if(!length(new_name))
		return FALSE

	new_name = copytext(new_name, 1, 33)
	slot.name = new_name
	return TRUE

/datum/tat_build/proc/export_tat_slots_to_list()
	init_tat_slots()

	var/list/result = list()
	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = get_tat_slot(i)
		result += list(slot.export_to_list())

	return result

/datum/tat_build/proc/load_tat_slots_from_list(list/slots_data, active_slot = 1)
	tat_slots = list()

	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = new /datum/tat_slot(get_default_tat_slot_name(i))
		var/list/raw_slot = null

		if(islist(slots_data))
			if(islist(slots_data[i]))
				raw_slot = slots_data[i]
			else if(islist(slots_data["[i]"]))
				raw_slot = slots_data["[i]"]

		if(islist(raw_slot))
			slot.load_from_list(raw_slot)

		if(!istext(slot.name) || !length(slot.name))
			slot.name = get_default_tat_slot_name(i)

		if(!islist(slot.build_data))
			slot.set_build_data(list())

		tat_slots += slot

	active_tat_slot = normalize_tat_slot_index(active_slot)
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/load_from_preferences(datum/preferences/P)
	if(!P)
		return FALSE

	attach_preferences(P)

	if(istype(P.tat_build, /datum/tat_build))
		var/datum/tat_build/source_build = P.tat_build
		if(source_build == src)
			return TRUE
		load_from_list(source_build.export_to_list())
		dirty = FALSE
		return TRUE

	var/list/tat_data = P.tat_build
	if(islist(tat_data))
		load_from_list(tat_data)
	else
		load_tat_slots_from_list(null, 1)
		reset_build()
		dirty = FALSE

	return TRUE

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()

	tat_build.attach_preferences(src)

	if(islist(tat_data))
		tat_build.load_from_list(tat_data)
	else
		tat_build.load_tat_slots_from_list(null, 1)
		tat_build.reset_build()

	tat_build.dirty = FALSE

/datum/tat_build/proc/get_item_icon_payload(item_path)
	if(!ispath(item_path, /obj/item))
		return null
	if(!islist(item_icon_cache))
		item_icon_cache = list()
	if(item_path in item_icon_cache)
		return item_icon_cache[item_path]
	var/obj/item/I = new item_path
	if(!I)
		return null
	var/icon/render_icon = icon(initial(I.icon), initial(I.icon_state), SOUTH, 1)
	var/icon_b64 = null
	if(render_icon)
		icon_b64 = icon2base64(render_icon)
	var/list/payload = list(
		"icon" = icon_b64,
		"icon_state" = "[initial(I.icon_state)]",
	)
	item_icon_cache[item_path] = payload
	qdel(I)
	return payload

/datum/tat_build/proc/export_slot_build_to_list()
	return list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
		"item_loadout" = item_loadout.Copy(),
		"magic_config" = magic_config.Copy(),
	)

/datum/tat_build/proc/load_slot_build_from_list(list/L)
	reset_build()

	if(!islist(L))
		dirty = FALSE
		return

	var/list/_stats = L["stats"]
	var/list/_skills = L["skills"]
	var/list/_traits = L["traits"]
	var/list/_items = L["items"]
	var/list/_item_loadout = L["item_loadout"]
	var/list/_magic_config = L["magic_config"]

	if(islist(_stats))
		for(var/stat_id in available_stats)
			if(isnum(_stats[stat_id]))
				set_stat_value(stat_id, _stats[stat_id])

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(trait_id in available_traits)
				traits[trait_id] = TRUE

	if(islist(_skills))
		for(var/skill_type in _skills)
			if(ispath(skill_type) && isnum(_skills[skill_type]) && (skill_type in available_skills))
				var/value = round(_skills[skill_type])
				if(value > 0)
					skills[skill_type] = value

	if(islist(_items))
		for(var/item_path in _items)
			if(ispath(item_path) && isnum(_items[item_path]) && (item_path in available_items))
				var/value = round(_items[item_path])
				if(value > 0)
					items[item_path] = value

	if(islist(_item_loadout))
		for(var/item_path in _item_loadout)
			if(!(item_path in items))
				continue
			if(!islist(_item_loadout[item_path]))
				continue
			var/list/saved_loadout = _item_loadout[item_path]
			item_loadout[item_path] = list(
				"equip" = round(text2num("[saved_loadout["equip"]]")),
				"bag" = round(text2num("[saved_loadout["bag"]]")),
			)

	if(islist(_magic_config))
		magic_config = _magic_config.Copy()

	sanitize_build()
	dirty = FALSE
