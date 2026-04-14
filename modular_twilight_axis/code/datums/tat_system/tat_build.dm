/datum/tat_build
	var/list/available_stats = list()
	var/list/available_skills = list()
	var/list/available_traits = list()
	var/list/available_items = list()

	var/points_stats = 4
	var/points_skills = 35
	var/points_traits = 10
	var/points_items = 15

	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/items = list()
	var/list/item_loadout = list()
	var/list/magic_config = list()

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

/datum/tat_build/proc/get_effective_stat_points_total()
	var/total = points_stats
	if(traits[TAT_TRAIT_BONUS_STAT_POOL])
		total += TAT_BUILD_STAT_BONUS_EXTRA_STATS
	if(traits[TAT_TRAIT_WANTED])
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
	if(traits[TAT_TRAIT_WARRIOR_EXPERT])
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_1)
	if(traits[TAT_TRAIT_WARRIOR_MASTER])
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
			return !!traits[TAT_TRAIT_BRONZE_SUPPLIER]
		if(TAT_SUPPLY_SILVER)
			return !!traits[TAT_TRAIT_SILVER_SUPPLIER]
		if(TAT_SUPPLY_STEEL)
			return !!traits[TAT_TRAIT_STEEL_SUPPLIER]
		if(TAT_SUPPLY_FIREARMS)
			return !!traits[TAT_TRAIT_FIREARMS_SUPPLIER]
	return FALSE

/datum/tat_build/proc/can_use_armor_family(armor_family)
	switch(armor_family)
		if(TAT_ARMOR_CLOTH)
			return TRUE
		if(TAT_ARMOR_LEATHER)
			return !!traits[TAT_TRAIT_LEATHER_SUPPLIER]
		if(TAT_ARMOR_MAIL)
			return !!traits[TAT_TRAIT_MAIL_SUPPLIER]
		if(TAT_ARMOR_PLATE)
			return !!traits[TAT_TRAIT_PLATE_SUPPLIER]
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

/datum/tat_build/proc/build_ui_selected_traits()
	var/list/result = list()
	for(var/trait_id in traits)
		result += trait_id
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
			"selected" = !!traits[trait_id],
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

/datum/tat_build/proc/is_magic_initiation_trait(trait_id)
	return (trait_id == TAT_TRAIT_DIVINE_INITIATE \
		|| trait_id == TAT_TRAIT_MAGE_INITIATE \
		|| trait_id == TAT_TRAIT_DRUID_INITIATE \
		|| trait_id == TAT_TRAIT_WITCH_INITIATE)

/datum/tat_build/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TRAIT_OUTLANDER) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TRAIT_OUTLANDER))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_WANTED) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_WANTED))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_BONUS_STAT_POOL) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_BONUS_STAT_POOL))
		return TRUE
	if((trait_a == TRAIT_DODGEEXPERT && trait_b == TRAIT_PARRYEXPERT) || (trait_b == TRAIT_DODGEEXPERT && trait_a == TRAIT_PARRYEXPERT))
		return TRUE
	if((trait_a == TRAIT_HEAVYARMOR && trait_b == TRAIT_CRITICAL_RESISTANCE) || (trait_b == TRAIT_HEAVYARMOR && trait_a == TRAIT_CRITICAL_RESISTANCE))
		return TRUE
	if((trait_a == TRAIT_MEDIUMARMOR && trait_b == TRAIT_CRITICAL_RESISTANCE) || (trait_b == TRAIT_MEDIUMARMOR && trait_a == TRAIT_CRITICAL_RESISTANCE))
		return TRUE


	if(is_magic_initiation_trait(trait_a) && is_magic_initiation_trait(trait_b))
		return TRUE

	return FALSE

/datum/tat_build/proc/has_invalid_trait_dependencies()
	if(traits[TAT_TRAIT_WARRIOR_MASTER] && !traits[TAT_TRAIT_WARRIOR_EXPERT])
		return TRUE
	if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T2] && !traits[TAT_TRAIT_BARDIC_INSPIRATION_T1])
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
			cleaned[trait_id] = TRUE
	traits = cleaned

	if(traits[TAT_TRAIT_WARRIOR_MASTER] && !traits[TAT_TRAIT_WARRIOR_EXPERT])
		traits -= TAT_TRAIT_WARRIOR_MASTER

	if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T2] && !traits[TAT_TRAIT_BARDIC_INSPIRATION_T1])
		traits -= TAT_TRAIT_BARDIC_INSPIRATION_T2

	if(traits[TAT_TRAIT_RESIDENT] && traits[TRAIT_OUTLANDER])
		traits -= TRAIT_OUTLANDER
	if(traits[TAT_TRAIT_RESIDENT] && traits[TAT_TRAIT_WANTED])
		traits -= TAT_TRAIT_WANTED
	if(traits[TAT_TRAIT_RESIDENT] && traits[TAT_TRAIT_BONUS_STAT_POOL])
		traits -= TAT_TRAIT_BONUS_STAT_POOL

	while(get_remaining_trait_points() < 0)
		var/changed = FALSE
		for(var/trait_id in traits.Copy())
			if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && traits[TAT_TRAIT_WARRIOR_MASTER])
				continue
			if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T1 && traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
				continue
			traits -= trait_id
			changed = TRUE
			if(get_remaining_trait_points() >= 0)
				break
		if(!changed)
			break

	if(!traits[TAT_TRAIT_BRONZE_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_BRONZE)
	if(!traits[TAT_TRAIT_SILVER_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_SILVER)
	if(!traits[TAT_TRAIT_STEEL_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_STEEL)
	if(!traits[TAT_TRAIT_LEATHER_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_LEATHER)
	if(!traits[TAT_TRAIT_MAIL_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_MAIL)
	if(!traits[TAT_TRAIT_PLATE_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_PLATE)

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

	if(traits[TAT_TRAIT_DIVINE_INITIATE])
		if(isnull(get_magic_value("divine_tier", null)))
			magic_config["divine_tier"] = CLERIC_T1
		if(isnull(get_magic_value("divine_passive_gain", null)))
			magic_config["divine_passive_gain"] = CLERIC_REGEN_MINOR
		if(isnull(get_magic_value("divine_devotion_limit", null)))
			magic_config["divine_devotion_limit"] = CLERIC_REQ_1

	if(traits[TAT_TRAIT_MAGE_INITIATE])
		if(!islist(get_magic_value("mage_aspects", null)))
			magic_config["mage_aspects"] = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3, "ward" = TRUE)
		if(isnull(get_magic_value("mage_spellbook", null)))
			magic_config["mage_spellbook"] = TRUE

	if(traits[TAT_TRAIT_DRUID_INITIATE])
		if(isnull(get_magic_value("druid_force_dendor", null)))
			magic_config["druid_force_dendor"] = TRUE
		if(isnull(get_magic_value("druid_alert", null)))
			magic_config["druid_alert"] = TRUE

	if(traits[TAT_TRAIT_WITCH_INITIATE])
		if(isnull(get_magic_value("witch_path", null)))
			magic_config["witch_path"] = "old_magick"

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
	if(!trait_id || !(trait_id in available_traits) || traits[trait_id])
		return FALSE

	if(trait_id == TAT_TRAIT_WARRIOR_MASTER && !traits[TAT_TRAIT_WARRIOR_EXPERT])
		return FALSE
	if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T2 && !traits[TAT_TRAIT_BARDIC_INSPIRATION_T1])
		return FALSE

	for(var/existing_trait in traits)
		if(are_traits_mutually_exclusive(trait_id, existing_trait))
			return FALSE

	if(get_remaining_trait_points() < get_trait_cost(trait_id))
		return FALSE

	traits[trait_id] = TRUE
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id || !traits[trait_id])
		return FALSE
	if(trait_id == TAT_TRAIT_WARRIOR_EXPERT && traits[TAT_TRAIT_WARRIOR_MASTER])
		return FALSE
	if(trait_id == TAT_TRAIT_BARDIC_INSPIRATION_T1 && traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
		return FALSE

	traits -= trait_id

	if(!traits[TAT_TRAIT_BRONZE_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_BRONZE)
	if(!traits[TAT_TRAIT_SILVER_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_SILVER)
	if(!traits[TAT_TRAIT_STEEL_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_WEAPON_SUPPLY, TAT_SUPPLY_STEEL)
	if(!traits[TAT_TRAIT_LEATHER_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_LEATHER)
	if(!traits[TAT_TRAIT_MAIL_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_MAIL)
	if(!traits[TAT_TRAIT_PLATE_SUPPLIER])
		remove_items_by_unlock(TAT_UNLOCK_TYPE_ARMOR_FAMILY, TAT_ARMOR_PLATE)

	sanitize_magic()

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
		"magic_config" = magic_config.Copy(),
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
			H.adjust_skillrank_up_to(skill_type, level, TRUE)

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

	if(traits[TRAIT_TRAINED_SMITH])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smelting", 3)

	if(traits[TRAIT_SMITHING_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smithing", 3)

	if(traits[TRAIT_ALCHEMY_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/alchemy", 3)

	if(traits[TRAIT_MEDICINE_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/medicine", 3)

	if(traits[TRAIT_HOMESTEAD_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/carpentry", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/masonry", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/crafting", 3)

	if(traits[TRAIT_SURVIVAL_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/butchering", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/traps", 3)

	if(traits[TRAIT_SEWING_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/sewing", 3)

	if(traits[TRAIT_SEEDKNOW])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/farming", 3)

	if(traits[TRAIT_CAUTIOUS_FISHER])
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/fishing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/fishing", 3)

	if(traits[TRAIT_SQUIRE_REPAIR])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/armorsmithing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/weaponsmithing", 3)

	if(traits[TRAIT_ARCYNE] || traits[TAT_TRAIT_SPELLBLADE] || traits[TAT_TRAIT_MAGE_INITIATE])
		grant_skill_bonus_if_exists(H, "/datum/skill/magic/arcane", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/magic/arcana", 3)

/datum/tat_build/proc/apply_divine_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_DIVINE_INITIATE])
		return

	var/cleric_tier = get_magic_value("divine_tier", CLERIC_T1)
	var/passive_gain = get_magic_value("divine_passive_gain", CLERIC_REGEN_MINOR)
	var/devotion_limit = get_magic_value("divine_devotion_limit", CLERIC_REQ_1)

	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = cleric_tier, passive_gain = passive_gain, devotion_limit = devotion_limit)

/datum/tat_build/proc/apply_mage_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_MAGE_INITIATE] || !H.mind)
		return

	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)

	var/list/aspects = get_magic_value("mage_aspects", null)
	if(islist(aspects))
		H.mind.setup_mage_aspects(aspects)

	if(get_magic_value("mage_spellbook", TRUE))
		H.equip_to_slot_or_del(new /obj/item/book/spellbook(H), SLOT_IN_BACKPACK)

/datum/tat_build/proc/apply_druid_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_DRUID_INITIATE])
		return

	if(get_magic_value("druid_force_dendor", TRUE))
		H.set_patron(/datum/patron/divine/dendor)

	if(get_magic_value("druid_alert", TRUE))
		H.AddComponent(/datum/component/wise_tree_alert)

	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/create_seed)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_claws)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_rage)

	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)

/datum/tat_build/proc/apply_witch_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_WITCH_INITIATE])
		return

	ADD_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)

	switch(tgui_input_list(H, "Choose your witch path.", "Witch Initiate", list("Old Magick", "Godsblood", "Mystagogue")))
		if("Old Magick")
			ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list(
					"mastery" = FALSE,
					"major" = 1,
					"minor" = 1,
					"utilities" = 5,
					"ward" = TRUE,
				))
			H.equip_to_slot_or_del(new /obj/item/book/spellbook(H), SLOT_IN_BACKPACK)

		if("Godsblood")
			var/datum/devotion/D = new /datum/devotion(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_APPRENTICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5

		if("Mystagogue")
			var/datum/devotion/D = new /datum/devotion(H, H.patron)
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			D.max_devotion *= 0.5

			ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
			H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
			if(H.mind)
				H.mind.setup_mage_aspects(list(
					"mastery" = FALSE,
					"major" = 0,
					"minor" = 1,
					"utilities" = 3,
					"ward" = TRUE,
				))
			H.equip_to_slot_or_del(new /obj/item/book/spellbook(H), SLOT_IN_BACKPACK)

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
				TAT_TRAIT_WANTED,
				TAT_TRAIT_DIVINE_INITIATE,
				TAT_TRAIT_MAGE_INITIATE,
				TAT_TRAIT_DRUID_INITIATE,
				TAT_TRAIT_WITCH_INITIATE
			)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)

	if(traits[TAT_TRAIT_RESIDENT])
		ADD_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)

	if(traits[TAT_TRAIT_SPELLBLADE])
		ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
		if(H.mind)
			H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	if(traits[TAT_TRAIT_SOUNDBREAKER])
		H.LoadComponent(/datum/component/combo_core/soundbreaker)

	if(traits[TAT_TRAIT_RONIN])
		H.LoadComponent(/datum/component/combo_core/ronin)

	if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T1] || traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
		var/bard_tier = BARD_T1
		if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
			bard_tier = BARD_T2

		if(!H.inspiration)
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier)
		else
			H.inspiration.grant_inspiration(H, bard_tier)

	if(traits[TAT_TRAIT_PARTY_LEADER])
		H.LoadComponent(/datum/component/tat_party_leader)

	if(traits[TAT_TRAIT_WANTED])
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
		wretch_select_bounty(H)

	apply_divine_package(H)
	apply_mage_package(H)
	apply_druid_package(H)
	apply_witch_package(H)

/datum/tat_build/proc/get_equip_slots_for_item(obj/item/I)
	var/list/slots = list()
	if(!I)
		return slots

	var/flags = I.slot_flags

	if(flags & ITEM_SLOT_WRISTS)
		slots += SLOT_WRISTS
	if(flags & ITEM_SLOT_GLOVES)
		slots += SLOT_GLOVES
	if(flags & ITEM_SLOT_SHOES)
		slots += SLOT_SHOES
	if(flags & ITEM_SLOT_RING)
		slots += SLOT_RING
	if(flags & ITEM_SLOT_HEAD)
		slots += SLOT_HEAD
	if(flags & ITEM_SLOT_MOUTH)
		slots += SLOT_MOUTH
	if(flags & ITEM_SLOT_MASK)
		slots += SLOT_WEAR_MASK
	if(flags & ITEM_SLOT_NECK)
		slots += SLOT_NECK
	if(flags & ITEM_SLOT_CLOAK)
		slots += SLOT_CLOAK

	if(flags & ITEM_SLOT_ARMOR)
		slots += SLOT_ARMOR
	if(flags & ITEM_SLOT_SHIRT)
		slots += SLOT_SHIRT
	if(flags & ITEM_SLOT_PANTS)
		slots += SLOT_PANTS

	if(flags & ITEM_SLOT_OCLOTHING)
		if(!(SLOT_ARMOR in slots))
			slots += SLOT_ARMOR
	if(flags & ITEM_SLOT_ICLOTHING)
		if(!(SLOT_SHIRT in slots))
			slots += SLOT_SHIRT
		if(!(SLOT_PANTS in slots))
			slots += SLOT_PANTS

	if(flags & ITEM_SLOT_BELT)
		slots += SLOT_BELT_L
		slots += SLOT_BELT_R
		slots += SLOT_BELT

	if(flags & ITEM_SLOT_HIP)
		if(!(SLOT_BELT_L in slots))
			slots += SLOT_BELT_L
		if(!(SLOT_BELT_R in slots))
			slots += SLOT_BELT_R
		if(!(SLOT_BELT in slots))
			slots += SLOT_BELT

	if(flags & ITEM_SLOT_BACK_L)
		slots += SLOT_BACK_L
	if(flags & ITEM_SLOT_BACK_R)
		slots += SLOT_BACK_R
	if(flags & ITEM_SLOT_BACK)
		if(!(SLOT_BACK_L in slots))
			slots += SLOT_BACK_L
		if(!(SLOT_BACK_R in slots))
			slots += SLOT_BACK_R
		if(!(SLOT_BACK in slots))
			slots += SLOT_BACK

	return slots

/datum/tat_build/proc/get_storage_targets(mob/living/carbon/human/H)
	var/list/targets = list()
	if(!H)
		return targets

	var/obj/item/I = H.get_item_by_slot(SLOT_BACK_L)
	if(I)
		targets += I

	I = H.get_item_by_slot(SLOT_BACK_R)
	if(I && !(I in targets))
		targets += I

	I = H.get_item_by_slot(SLOT_BELT_L)
	if(I && !(I in targets))
		targets += I

	I = H.get_item_by_slot(SLOT_BELT_R)
	if(I && !(I in targets))
		targets += I

	I = H.get_item_by_slot(SLOT_BACK)
	if(I && !(I in targets))
		targets += I

	I = H.get_item_by_slot(SLOT_BELT)
	if(I && !(I in targets))
		targets += I

	I = H.get_item_by_slot(SLOT_CLOAK)
	if(I && !(I in targets))
		targets += I

	return targets

/datum/tat_build/proc/try_insert_into_storage(obj/item/I, atom/storage_owner, mob/living/carbon/human/H)
	if(!I || !storage_owner)
		return FALSE

	return !!SEND_SIGNAL(storage_owner, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE)

/datum/tat_build/proc/try_put_into_any_storage_or_drop(obj/item/I, mob/living/carbon/human/H)
	if(!I || !H)
		return FALSE

	for(var/storage_owner in get_storage_targets(H))
		if(try_insert_into_storage(I, storage_owner, H))
			return TRUE

	I.forceMove(get_turf(H))
	return TRUE

/datum/tat_build/proc/spawn_item_into_bag_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return

	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return

	try_put_into_any_storage_or_drop(I, H)

/datum/tat_build/proc/spawn_item_equipped_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return

	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return

	var/list/slots = get_equip_slots_for_item(I)

	for(var/slot_id in slots)
		if(H.equip_to_slot_if_possible(I, slot_id, FALSE, TRUE, TRUE, TRUE))
			return

	try_put_into_any_storage_or_drop(I, H)

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
	
	var/obj/item/storage/backpack/rogue/satchel/B = new /obj/item/storage/backpack/rogue/satchel(H)
	H.equip_to_slot_if_possible(B, SLOT_BACK_R, TRUE, TRUE, TRUE, TRUE)
	apply_items(H)

	apply_stats(H)
	apply_skills(H)
	apply_trait_skill_bonuses(H)
	apply_traits(H)

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
		"traits" = build_ui_selected_traits(),
		"trait_entries" = build_ui_traits(),
		"items" = build_ui_items(),
		"loadout" = build_ui_loadout(),
		"magic_config" = magic_config.Copy(),
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
		if("set_magic_value")
			return set_magic_value(params["key"], params["value"])
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

/datum/tat_build/proc/is_skill_blocked(skill_type)
	if(!ispath(skill_type, /datum/skill))
		return TRUE
	return (skill_type in TAT_BLOCKED_SKILLS_LIST)

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()

	if(!islist(tat_data))
		tat_build.reset_build()
		tat_build.dirty = FALSE
		return

	tat_build.load_from_list(tat_data)
	tat_build.dirty = FALSE
