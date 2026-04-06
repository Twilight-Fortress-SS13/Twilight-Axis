/datum/tat_build
	var/list/available_stats = list()
	var/list/available_skills = list()
	var/list/available_traits = list()
	var/list/available_items = list()

	var/points_stats = 4
	var/points_skills = 30
	var/points_traits = 10
	var/points_items = 15

	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/items = list()
	var/list/item_loadout = list()

	var/dirty = FALSE
	var/list/stat_order = TAT_STATS_ORDER_LIST

/datum/tat_build/New()
	. = ..()
	init_available_stats()
	init_available_skills()
	init_available_traits()
	init_available_items()
	reset_build()

/datum/tat_build/proc/init_available_stats()
	available_stats = list(
		TAT_AVAILABLE_STATS_LIST
	)

/datum/tat_build/proc/init_available_skills()
	available_skills = list()

	for(var/path in subtypesof(/datum/skill))
		if(path == /datum/skill)
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
	available_items = list(
		TAT_AVAILABLE_ITEMS_LIST
	)

/datum/tat_build/proc/get_effective_stat_points_total()
	var/total = points_stats
	if(TAT_TRAIT_BONUS_STAT_POOL in traits)
		total += TAT_BUILD_STAT_BONUS_EXTRA_STATS
	if(TAT_TRAIT_WANTED in traits)
		total += TAT_BUILD_STAT_BONUS_WANTED
	return total

/datum/tat_build/proc/get_stat_entry(stat_id)
	if(!(stat_id in available_stats))
		return null
	return available_stats[stat_id]

/datum/tat_build/proc/get_stat_base(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 10
	return isnum(entry["base"]) ? entry["base"] : 10

/datum/tat_build/proc/get_stat_min(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 1
	return isnum(entry["min"]) ? entry["min"] : 1

/datum/tat_build/proc/get_stat_max(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 20
	return isnum(entry["max"]) ? entry["max"] : 20

/datum/tat_build/proc/get_stat_cost(stat_id)
	var/list/entry = get_stat_entry(stat_id)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_stat_value(stat_id)
	if(stat_id in stats)
		return stats[stat_id]
	return get_stat_base(stat_id)

/datum/tat_build/proc/get_skill_entry(skill_type)
	if(!ispath(skill_type) || !(skill_type in available_skills))
		return null
	return available_skills[skill_type]

/datum/tat_build/proc/get_skill_value(skill_type)
	if(skill_type in skills)
		return skills[skill_type]
	return 0

/datum/tat_build/proc/get_trait_entry(trait_id)
	if(!(trait_id in available_traits))
		return null
	return available_traits[trait_id]

/datum/tat_build/proc/get_trait_cost(trait_id)
	var/list/entry = get_trait_entry(trait_id)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_item_entry(item_path)
	if(!ispath(item_path) || !(item_path in available_items))
		return null
	return available_items[item_path]

/datum/tat_build/proc/get_item_cost(item_path)
	var/list/entry = get_item_entry(item_path)
	if(!islist(entry))
		return 0
	return isnum(entry["cost"]) ? entry["cost"] : 0

/datum/tat_build/proc/get_stat_point_delta_for_value(stat_id, value)
	var/base = get_stat_base(stat_id)
	var/cost = get_stat_cost(stat_id)
	return (value - base) * cost

/datum/tat_build/proc/get_total_stat_point_delta()
	var/total = 0
	for(var/stat_id in available_stats)
		total += get_stat_point_delta_for_value(stat_id, get_stat_value(stat_id))
	return total

/datum/tat_build/proc/get_remaining_stat_points()
	return get_effective_stat_points_total() - get_total_stat_point_delta()

/datum/tat_build/proc/get_skill_next_cost(skill_type)
	var/current = get_skill_value(skill_type)
	return current + 1

/datum/tat_build/proc/get_skill_total_cost_for_level(level)
	if(!isnum(level) || level <= 0)
		return 0
	var/total = 0
	for(var/i in 1 to level)
		total += i
	return total

/datum/tat_build/proc/get_spent_skill_points()
	var/total = 0
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(!isnum(level) || level <= 0)
			continue
		total += get_skill_total_cost_for_level(level)
	return total

/datum/tat_build/proc/get_remaining_skill_points()
	return points_skills - get_spent_skill_points()

/datum/tat_build/proc/get_spent_trait_points()
	var/total = 0
	for(var/trait_id in traits)
		total += get_trait_cost(trait_id)
	return total

/datum/tat_build/proc/get_remaining_trait_points()
	return points_traits - get_spent_trait_points()

/datum/tat_build/proc/get_spent_item_points()
	var/total = 0
	for(var/item_path in items)
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		total += get_item_cost(item_path) * amount
	return total

/datum/tat_build/proc/get_remaining_item_points()
	return points_items - get_spent_item_points()

/datum/tat_build/proc/get_combat_skill_cap()
	var/cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	if(TAT_TRAIT_WARRIOR_EXPERT in traits)
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_1)
	if(TAT_TRAIT_WARRIOR_MASTER in traits)
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_2)
	return cap

/datum/tat_build/proc/get_skill_cap(skill_type)
	if(ispath(skill_type, /datum/skill/combat))
		return get_combat_skill_cap()
	return TAT_SKILL_NONCOMBAT_CAP

/datum/tat_build/proc/can_use_weapon_supply_type(supply_type)
	switch(supply_type)
		if(TAT_SUPPLY_IRON)
			return TRUE
		if(TAT_SUPPLY_BRONZE)
			return (TAT_TRAIT_BRONZE_SUPPLIER in traits)
		if(TAT_SUPPLY_SILVER)
			return (TAT_TRAIT_SILVER_SUPPLIER in traits)
		if(TAT_SUPPLY_STEEL)
			return (TAT_TRAIT_STEEL_SUPPLIER in traits)
	return FALSE

/datum/tat_build/proc/can_use_armor_family(armor_family)
	switch(armor_family)
		if(TAT_ARMOR_CLOTH)
			return TRUE
		if(TAT_ARMOR_LEATHER)
			return (TAT_TRAIT_LEATHER_SUPPLIER in traits)
		if(TAT_ARMOR_MAIL)
			return (TAT_TRAIT_MAIL_SUPPLIER in traits)
		if(TAT_ARMOR_PLATE)
			return (TAT_TRAIT_PLATE_SUPPLIER in traits)
	return FALSE

/datum/tat_build/proc/can_use_item_entry(list/entry)
	if(!islist(entry))
		return FALSE

	var/unlock_type = entry["unlock_type"]
	var/unlock_key = entry["unlock_key"]

	switch(unlock_type)
		if(TAT_UNLOCK_TYPE_WEAPON_SUPPLY)
			return can_use_weapon_supply_type(unlock_key)
		if(TAT_UNLOCK_TYPE_ARMOR_FAMILY)
			return can_use_armor_family(unlock_key)
	return FALSE

/datum/tat_build/proc/get_item_loadout_entry(item_path)
	if(!(item_path in item_loadout) || !islist(item_loadout[item_path]))
		item_loadout[item_path] = list(
			"equip" = 0,
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

	var/list/loadout = get_item_loadout_entry(item_path)
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

	if((equip_amount + bag_amount) < total_amount)
		bag_amount += total_amount - (equip_amount + bag_amount)

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
		var/list/entry = available_stats[stat_id]
		result[stat_id] = entry
	return result

/datum/tat_build/proc/build_ui_skills()
	var/list/result = list()
	for(var/skill_type in available_skills)
		var/list/entry = available_skills[skill_type]
		result["[skill_type]"] = list(
			"name" = entry["name"],
			"desc" = entry["desc"],
			"level" = get_skill_value(skill_type),
			"cap" = get_skill_cap(skill_type),
			"next_cost" = get_skill_next_cost(skill_type),
			"is_combat" = !!entry["is_combat"],
			"category" = entry["category"],
		)
	return result

/datum/tat_build/proc/build_ui_traits()
	var/list/result = list()
	for(var/trait_id in available_traits)
		var/list/entry = available_traits[trait_id]
		result[trait_id] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"category_name" = entry["category_name"],
			"desc" = entry["desc"],
			"selected" = (trait_id in traits),
		)
	return result

/datum/tat_build/proc/build_ui_items()
	var/list/result = list()
	for(var/item_path in available_items)
		var/list/entry = available_items[item_path]
		if(!can_use_item_entry(entry))
			continue
		result["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"unlock_type" = entry["unlock_type"],
			"unlock_key" = entry["unlock_key"],
			"slot_group" = entry["slot_group"],
			"amount" = (items[item_path] || 0),
			"unlocked" = TRUE,
		)
	return result

/datum/tat_build/proc/build_ui_loadout()
	var/list/result = list()
	for(var/item_path in items)
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue

		normalize_item_loadout(item_path)

		result["[item_path]"] = list(
			"name" = entry["name"],
			"cost" = entry["cost"],
			"category" = entry["category"],
			"slot_group" = entry["slot_group"],
			"amount" = amount,
			"equip" = get_item_equip_amount(item_path),
			"bag" = get_item_bag_amount(item_path),
		)
	return result

/datum/tat_build/proc/set_stat_value(stat_id, value)
	if(!(stat_id in available_stats))
		return FALSE
	value = round(value)
	value = clamp(value, get_stat_min(stat_id), get_stat_max(stat_id))
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

/datum/tat_build/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TRAIT_OUTLANDER) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TRAIT_OUTLANDER))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_WANTED) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_WANTED))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_BONUS_STAT_POOL) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_BONUS_STAT_POOL))
		return TRUE
	return FALSE

/datum/tat_build/proc/has_invalid_trait_dependencies()
	if((TAT_TRAIT_WARRIOR_MASTER in traits) && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		return TRUE
	if((TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits) && !(TAT_TRAIT_BARDIC_INSPIRATION_T1 in traits))
		return TRUE

	for(var/trait_a in traits)
		for(var/trait_b in traits)
			if(trait_a == trait_b)
				continue
			if(are_traits_mutually_exclusive(trait_a, trait_b))
				return TRUE

	return FALSE

/datum/tat_build/proc/has_invalid_supply_items()
	for(var/item_path in items)
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry) || !can_use_item_entry(entry))
			return TRUE
	return FALSE

/datum/tat_build/proc/is_budget_valid()
	if(get_remaining_stat_points() < 0)
		return FALSE
	if(get_remaining_skill_points() < 0)
		return FALSE
	if(get_remaining_trait_points() < 0)
		return FALSE
	if(get_remaining_item_points() < 0)
		return FALSE
	return TRUE

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
			cleaned += trait_id
	traits = cleaned

	if((TAT_TRAIT_WARRIOR_MASTER in traits) && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		traits -= TAT_TRAIT_WARRIOR_MASTER

	if((TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits) && !(TAT_TRAIT_BARDIC_INSPIRATION_T1 in traits))
		traits -= TAT_TRAIT_BARDIC_INSPIRATION_T2

	if((TAT_TRAIT_RESIDENT in traits) && (TRAIT_OUTLANDER in traits))
		traits -= TRAIT_OUTLANDER
	if((TAT_TRAIT_RESIDENT in traits) && (TAT_TRAIT_WANTED in traits))
		traits -= TAT_TRAIT_WANTED
	if((TAT_TRAIT_RESIDENT in traits) && (TAT_TRAIT_BONUS_STAT_POOL in traits))
		traits -= TAT_TRAIT_BONUS_STAT_POOL

	while(get_remaining_trait_points() < 0)
		var/changed = FALSE
		for(var/trait_id in traits.Copy())
			if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && (TAT_TRAIT_WARRIOR_MASTER in traits))
				continue
			if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T1 && (TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits))
				continue
			traits -= trait_id
			changed = TRUE
			if(get_remaining_trait_points() >= 0)
				break
		if(!changed)
			break

	if(!(TAT_TRAIT_BRONZE_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_BRONZE)
	if(!(TAT_TRAIT_SILVER_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_SILVER)
	if(!(TAT_TRAIT_STEEL_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_STEEL)
	if(!(TAT_TRAIT_LEATHER_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_LEATHER)
	if(!(TAT_TRAIT_MAIL_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_MAIL)
	if(!(TAT_TRAIT_PLATE_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_PLATE)

/datum/tat_build/proc/sanitize_skills()
	for(var/skill_type in skills.Copy())
		if(!(skill_type in available_skills))
			skills -= skill_type
			continue
		var/value = round(skills[skill_type])
		value = clamp(value, 0, get_skill_cap(skill_type))
		if(value > 0)
			skills[skill_type] = value
		else
			skills -= skill_type

	while(get_remaining_skill_points() < 0)
		var/changed = FALSE
		for(var/skill_type in skills.Copy())
			var/current = get_skill_value(skill_type)
			if(current <= 0)
				continue
			if(current > 1)
				skills[skill_type] = current - 1
			else
				skills -= skill_type
			changed = TRUE
			if(get_remaining_skill_points() >= 0)
				break
		if(!changed)
			break

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

		items[item_path] = value
		normalize_item_loadout(item_path)

	for(var/item_path in item_loadout.Copy())
		if(!(item_path in items))
			item_loadout -= item_path

	while(get_remaining_item_points() < 0)
		var/changed = FALSE
		for(var/item_path in items.Copy())
			var/current = items[item_path]
			if(current > 1)
				items[item_path] = current - 1
			else
				items -= item_path
				item_loadout -= item_path
			if(item_path in items)
				normalize_item_loadout(item_path)
			changed = TRUE
			if(get_remaining_item_points() >= 0)
				break
		if(!changed)
			break

/datum/tat_build/proc/sanitize_build()
	sanitize_traits()
	sanitize_skills()
	sanitize_items()
	sanitize_stats()
	sanitize_traits()
	sanitize_skills()
	sanitize_items()
	sanitize_stats()

/datum/tat_build/proc/reset_build()
	reset_stats()
	reset_skills()
	reset_traits()
	reset_items()
	dirty = TRUE

/datum/tat_build/proc/reset_stats()
	stats = list()
	dirty = TRUE

/datum/tat_build/proc/reset_skills()
	skills = list()
	dirty = TRUE

/datum/tat_build/proc/reset_traits()
	traits = list()
	dirty = TRUE

/datum/tat_build/proc/reset_items()
	items = list()
	item_loadout = list()
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
	if(new_value < get_stat_min(id))
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
	return TRUE

/datum/tat_build/proc/add_trait(trait_id)
	if(!trait_id || !(trait_id in available_traits) || (trait_id in traits))
		return FALSE

	if(trait_id == TAT_TRAIT_WARRIOR_MASTER && !(TAT_TRAIT_WARRIOR_EXPERT in traits))
		return FALSE
	if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T2 && !(TAT_TRAIT_BARDIC_INSPIRATION_T1 in traits))
		return FALSE

	for(var/existing_trait in traits)
		if(are_traits_mutually_exclusive(trait_id, existing_trait))
			return FALSE

	if(get_remaining_trait_points() < get_trait_cost(trait_id))
		return FALSE

	traits += trait_id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id || !(trait_id in traits))
		return FALSE
	if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && (TAT_TRAIT_WARRIOR_MASTER in traits))
		return FALSE
	if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T1 && (TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits))
		return FALSE

	traits -= trait_id

	if(!(TAT_TRAIT_BRONZE_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_BRONZE)
	if(!(TAT_TRAIT_SILVER_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_SILVER)
	if(!(TAT_TRAIT_STEEL_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_STEEL)
	if(!(TAT_TRAIT_LEATHER_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_LEATHER)
	if(!(TAT_TRAIT_MAIL_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_MAIL)
	if(!(TAT_TRAIT_PLATE_SUPPLIER in traits))
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_PLATE)

	for(var/skill_type in skills.Copy())
		var/cap = get_skill_cap(skill_type)
		if(get_skill_value(skill_type) > cap)
			if(cap > 0)
				skills[skill_type] = cap
			else
				skills -= skill_type

	dirty = TRUE
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

	var/cost = get_item_cost(path) * amount
	if(get_remaining_item_points() < cost)
		return FALSE

	items[path] = (items[path] || 0) + amount
	normalize_item_loadout(path)
	dirty = TRUE
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
	return list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
		"item_loadout" = item_loadout.Copy(),
	)

/datum/tat_build/proc/load_from_list(list/L)
	reset_build()
	if(!islist(L))
		dirty = FALSE
		return

	var/list/_stats = L["stats"]
	var/list/_skills = L["skills"]
	var/list/_traits = L["traits"]
	var/list/_items = L["items"]
	var/list/_item_loadout = L["item_loadout"]

	if(islist(_stats))
		for(var/stat_id in available_stats)
			if(isnum(_stats[stat_id]))
				set_stat_value(stat_id, _stats[stat_id])

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(trait_id in available_traits && !(trait_id in traits))
				traits += trait_id

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

	sanitize_build()
	dirty = FALSE

/datum/tat_build/proc/apply_stats(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/stat_id in available_stats)
		var/base = get_stat_base(stat_id)
		var/value = get_stat_value(stat_id)
		var/diff = value - base
		if(diff)
			H.change_stat(stat_id, diff)

/datum/tat_build/proc/apply_skills(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(level > 0)
			H.adjust_skillrank(skill_type, level, TRUE)

/datum/tat_build/proc/grant_skill_bonus_if_exists(mob/living/carbon/human/H, path_text, amount = 3)
	if(!H || !path_text || !istext(path_text))
		return
	var/path = text2path(path_text)
	if(!ispath(path, /datum/skill))
		return
	H.adjust_skillrank(path, amount, TRUE)

/datum/tat_build/proc/apply_trait_skill_bonuses(mob/living/carbon/human/H)
	if(!H)
		return

	if(TRAIT_TRAINED_SMITH in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smelting", 3)

	if(TRAIT_SMITHING_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smithing", 3)

	if(TRAIT_ALCHEMY_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/alchemy", 3)

	if(TRAIT_MEDICINE_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/medicine", 3)

	if(TRAIT_HOMESTEAD_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/carpentry", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/masonry", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/crafting", 3)

	if(TRAIT_SURVIVAL_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/butchering", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/traps", 3)

	if(TRAIT_SEWING_EXPERT in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/sewing", 3)

	if(TRAIT_SEEDKNOW in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/farming", 3)

	if(TRAIT_CAUTIOUS_FISHER in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/fishing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/fishing", 3)

	if(TRAIT_SQUIRE_REPAIR in traits)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/armorsmithing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/weaponsmithing", 3)

	if((TRAIT_ARCYNE in traits) || (TAT_TRAIT_SPELLBLADE in traits))
		grant_skill_bonus_if_exists(H, "/datum/skill/magic/arcane", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/magic/arcana", 3)

/datum/tat_build/proc/apply_traits(mob/living/carbon/human/H)
	if(!H)
		return

	for(var/trait_id in traits)
		switch(trait_id)
			if(
				TAT_TRAIT_WARRIOR_EXPERT,
				TAT_TRAIT_WARRIOR_MASTER,
				TAT_TRAIT_SOUNDBREAKER,
				TAT_TRAIT_RONIN,
				TAT_TRAIT_RESIDENT,
				TAT_TRAIT_STEEL_SUPPLIER,
				TAT_TRAIT_SILVER_SUPPLIER,
				TAT_TRAIT_BRONZE_SUPPLIER,
				TAT_TRAIT_LEATHER_SUPPLIER,
				TAT_TRAIT_MAIL_SUPPLIER,
				TAT_TRAIT_PLATE_SUPPLIER,
				TAT_TRAIT_SPELLBLADE,
				TAT_TRAIT_BARDIC_INSPIRATION_T1,
				TAT_TRAIT_BARDIC_INSPIRATION_T2,
				TAT_TRAIT_PARTY_LEADER,
				TAT_TRAIT_BONUS_STAT_POOL,
				TAT_TRAIT_WANTED
			)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)

	if(TAT_TRAIT_RESIDENT in traits)
		ADD_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)

	if(TAT_TRAIT_SPELLBLADE in traits)
		ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	if(TAT_TRAIT_SOUNDBREAKER in traits)
		H.LoadComponent(/datum/component/combo_core/soundbreaker)

	if(TAT_TRAIT_RONIN in traits)
		H.LoadComponent(/datum/component/combo_core/ronin)

	if((TAT_TRAIT_BARDIC_INSPIRATION_T1 in traits) || (TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits))
		var/bard_tier = BARD_T1
		if(TAT_TRAIT_BARDIC_INSPIRATION_T2 in traits)
			bard_tier = BARD_T2

		if(!H.inspiration)
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier)
		else
			H.inspiration.grant_inspiration(H, bard_tier)

	if(TAT_TRAIT_PARTY_LEADER in traits)
		H.LoadComponent(/datum/component/tat_party_leader)

	if(TAT_TRAIT_WANTED in traits)
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
		wretch_select_bounty(H)

/datum/tat_build/proc/find_backpack_or_storage(mob/living/carbon/human/H)
	if(!H)
		return null

	for(var/obj/item/I in H.contents)
		if(istype(I, /obj/item/storage/backpack))
			return I

	for(var/obj/item/I in H.contents)
		if(istype(I, /obj/item/storage))
			return I

	return null

/datum/tat_build/proc/try_insert_into_storage(obj/item/I, atom/storage_owner, mob/living/carbon/human/H)
	if(!I || !storage_owner)
		return FALSE

	I.forceMove(storage_owner)
	return TRUE

/datum/tat_build/proc/spawn_item_into_bag_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return

	var/obj/item/I = new path(get_turf(H))
	var/atom/storage_owner = find_backpack_or_storage(H)

	if(storage_owner && try_insert_into_storage(I, storage_owner, H))
		return

	if(H.put_in_hands(I))
		return

	I.forceMove(get_turf(H))

/datum/tat_build/proc/spawn_item_equipped_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return

	var/obj/item/I = new path(get_turf(H))

	if(hascall(H, "equip_to_appropriate_slot"))
		if(call(H, "equip_to_appropriate_slot")(I, FALSE))
			return

	if(H.put_in_hands(I))
		return

	I.forceMove(get_turf(H))

/datum/tat_build/proc/apply_items(mob/living/carbon/human/H)
	if(!H)
		return

	for(var/path in items)
		var/amount = items[path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/equip_amount = get_item_equip_amount(path)
		var/bag_amount = get_item_bag_amount(path)

		for(var/i in 1 to equip_amount)
			spawn_item_equipped_or_fallback(H, path)

		for(var/i in 1 to bag_amount)
			spawn_item_into_bag_or_fallback(H, path)

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return
	sanitize_build()
	apply_stats(H)
	apply_skills(H)
	apply_trait_skill_bonuses(H)
	apply_traits(H)
	apply_items(H)

/datum/tat_build/ui_state(mob/user)
	return GLOB.always_state

/datum/tat_build/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TATBuild")
		ui.open()

/datum/tat_build/ui_static_data(mob/user)
	return list()

/datum/tat_build/ui_data(mob/user)
	return list(
		"stats" = build_ui_stats(),
		"skills" = build_ui_skills(),
		"traits" = traits.Copy(),
		"trait_entries" = build_ui_traits(),
		"items" = build_ui_items(),
		"loadout" = build_ui_loadout(),
		"available_stats" = build_ui_stat_entries(),
		"available_skills" = build_ui_skills(),
		"available_traits" = build_ui_traits(),
		"available_items" = build_ui_items(),
		"points_stats" = get_effective_stat_points_total(),
		"points_stats_remaining" = get_remaining_stat_points(),
		"points_skills" = points_skills,
		"points_skills_remaining" = get_remaining_skill_points(),
		"points_traits" = points_traits,
		"points_traits_remaining" = get_remaining_trait_points(),
		"points_items" = points_items,
		"points_items_remaining" = get_remaining_item_points(),
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
			dirty = FALSE
			return TRUE

	return FALSE

#undef TAT_TRAIT_SOURCE

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()

	if(!islist(tat_data))
		tat_build.reset_build()
		tat_build.dirty = FALSE
		return

	tat_build.load_from_list(tat_data)
	tat_build.dirty = FALSE
