/datum/tat_directions
	var/datum/tat_build/owner_build
	var/foundation = TAT_FOUNDATION_SETTLED
	var/role_choice = TAT_ROLE_CHOICE_TOWNER
	var/list/points = list()

/proc/tat_towner_battle_direction_cost_mode()
	return TAT_TOWNER_BATTLE_DIRECTION_COST_MODE

/datum/tat_directions/New(datum/tat_build/B)
	. = ..()
	owner_build = B
	reset()

/datum/tat_directions/proc/reset()
	foundation = TAT_FOUNDATION_SETTLED
	role_choice = TAT_ROLE_CHOICE_TOWNER
	points = list()
	for(var/direction in TAT_DIRECTION_ORDER)
		points[direction] = 0
	return TRUE

/datum/tat_directions/proc/normalize_foundation(value)
	if(value == TAT_FOUNDATION_WANDERER)
		return TAT_FOUNDATION_WANDERER
	return TAT_FOUNDATION_SETTLED

/datum/tat_directions/proc/get_default_role_for_foundation(value)
	value = normalize_foundation(value)
	if(value == TAT_FOUNDATION_WANDERER)
		return TAT_ROLE_CHOICE_ADVENTURER
	return TAT_ROLE_CHOICE_TOWNER

/datum/tat_directions/proc/normalize_role_choice(value, foundation_value = null)
	var/normalized_foundation = normalize_foundation(foundation_value || foundation)
	var/list/choices = GLOB.tat_foundation_role_choices[normalized_foundation]
	if(islist(choices) && (value in choices))
		return value
	return get_default_role_for_foundation(normalized_foundation)

/datum/tat_directions/proc/normalize_direction(direction)
	if(direction in TAT_DIRECTION_ORDER)
		return direction
	return null

/datum/tat_directions/proc/set_foundation(value)
	var/new_foundation = normalize_foundation(value)
	var/new_role_choice = normalize_role_choice(role_choice, new_foundation)
	if(foundation == new_foundation && role_choice == new_role_choice)
		return TRUE
	foundation = new_foundation
	role_choice = new_role_choice
	owner_build?.traits?.sanitize()
	owner_build?.skills?.refresh_after_trait_change()
	owner_build?.items?.sanitize()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_directions/proc/set_role_choice(value)
	var/new_role_choice = normalize_role_choice(value)
	if(role_choice == new_role_choice)
		return TRUE
	role_choice = new_role_choice
	owner_build?.traits?.sanitize()
	owner_build?.skills?.refresh_after_trait_change()
	owner_build?.items?.sanitize()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_directions/proc/get_role_choice()
	return normalize_role_choice(role_choice)

/datum/tat_directions/proc/get_effective_role_trait()
	var/list/traits_by_role = GLOB.tat_role_choice_effective_traits
	return traits_by_role[get_role_choice()]

/datum/tat_directions/proc/is_role_trait(trait_id)
	if(!trait_id)
		return FALSE
	var/list/traits_by_role = GLOB.tat_role_choice_effective_traits
	for(var/role_id in traits_by_role)
		if(traits_by_role[role_id] == trait_id)
			return TRUE
	return FALSE

/datum/tat_directions/proc/get_role_choice_for_trait(trait_id)
	if(!trait_id)
		return null
	var/list/traits_by_role = GLOB.tat_role_choice_effective_traits
	for(var/role_id in traits_by_role)
		if(traits_by_role[role_id] == trait_id)
			return role_id
	return null

/datum/tat_directions/proc/adopt_legacy_role_traits()
	if(!owner_build?.traits)
		return FALSE
	for(var/trait_id in owner_build.traits.selected)
		var/legacy_role = get_role_choice_for_trait(trait_id)
		if(!legacy_role)
			continue
		role_choice = legacy_role
		if(legacy_role == TAT_ROLE_CHOICE_ADVENTURER || legacy_role == TAT_ROLE_CHOICE_WRETCH)
			foundation = TAT_FOUNDATION_WANDERER
		else
			foundation = TAT_FOUNDATION_SETTLED
		return TRUE
	return FALSE

/datum/tat_directions/proc/get_points(direction)
	direction = normalize_direction(direction)
	if(!direction)
		return 0
	return get_allocated_points(direction) + get_role_direction_points(direction)

/datum/tat_directions/proc/get_allocated_points(direction)
	direction = normalize_direction(direction)
	if(!direction)
		return 0
	return max(0, round(points[direction] || 0))

/datum/tat_directions/proc/get_role_direction_points(direction)
	direction = normalize_direction(direction)
	if(!direction)
		return 0
	switch(get_role_choice())
		if(TAT_ROLE_CHOICE_TOWNER)
			if(direction == TAT_DIRECTION_SKILLS)
				return 2
		if(TAT_ROLE_CHOICE_TRADER)
			if(direction == TAT_DIRECTION_SKILLS)
				return 1
	return 0

/datum/tat_directions/proc/is_towner_battle_direction(direction)
	direction = normalize_direction(direction)
	if(!direction || get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
		return FALSE
	return direction in TAT_TOWNER_BATTLE_DIRECTIONS

/datum/tat_directions/proc/get_triangular_cost(value)
	value = max(0, round(text2num("[value]") || 0))
	return round((value * (value + 1)) / 2)

/datum/tat_directions/proc/get_discounted_towner_battle_cost(value)
	value = max(0, round(text2num("[value]") || 0))
	var/total = 0
	for(var/i = 1, i <= value, i++)
		total += max(1, i - 1)
	return total

/datum/tat_directions/proc/has_towner_hunter_direction_discount(direction)
	if(get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
		return FALSE
	direction = normalize_direction(direction)
	if(direction == TAT_DIRECTION_COMBAT && owner_build?.traits?.has_trait(TAT_TRAIT_HUNTER_BEATER))
		return TRUE
	if(direction == TAT_DIRECTION_RANGED && owner_build?.traits?.has_trait(TAT_TRAIT_HUNTER_SHOOTER))
		return TRUE
	return FALSE

/datum/tat_directions/proc/get_towner_battle_allocated_points(direction_override = null, override_value = null)
	var/total = 0
	for(var/direction in TAT_DIRECTION_ORDER)
		if(!(direction in TAT_TOWNER_BATTLE_DIRECTIONS))
			continue
		if(has_towner_hunter_direction_discount(direction))
			continue
		if(direction_override && direction == direction_override)
			total += max(0, round(text2num("[override_value]") || 0))
		else
			total += get_allocated_points(direction)
	return total

/datum/tat_directions/proc/get_towner_battle_spent_points(direction_override = null, override_value = null)
	if(get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
		return 0
	var/discounted_total = 0
	for(var/discounted_direction in TAT_TOWNER_BATTLE_DIRECTIONS)
		if(!has_towner_hunter_direction_discount(discounted_direction))
			continue
		if(direction_override && discounted_direction == direction_override)
			discounted_total += get_discounted_towner_battle_cost(override_value)
		else
			discounted_total += get_discounted_towner_battle_cost(get_allocated_points(discounted_direction))
	switch(tat_towner_battle_direction_cost_mode())
		if(TAT_TOWNER_BATTLE_DIRECTION_COST_MODE_BRANCH)
			var/total = 0
			for(var/direction in TAT_TOWNER_BATTLE_DIRECTIONS)
				if(has_towner_hunter_direction_discount(direction))
					continue
				var/value = (direction_override && direction == direction_override) ? max(0, round(text2num("[override_value]") || 0)) : get_allocated_points(direction)
				total += get_triangular_cost(value)
			return total + discounted_total
		if(TAT_TOWNER_BATTLE_DIRECTION_COST_MODE_GLOBAL)
			return get_triangular_cost(get_towner_battle_allocated_points(direction_override, override_value)) + discounted_total
	return 0

/datum/tat_directions/proc/get_spent_points(direction_override = null, override_value = null)
	var/total = 0
	var/use_towner_battle_cost = get_role_choice() == TAT_ROLE_CHOICE_TOWNER
	for(var/direction in TAT_DIRECTION_ORDER)
		if(use_towner_battle_cost && (direction in TAT_TOWNER_BATTLE_DIRECTIONS))
			continue
		if(direction_override && direction == direction_override)
			total += max(0, round(text2num("[override_value]") || 0))
		else
			total += get_allocated_points(direction)
	if(use_towner_battle_cost)
		total += get_towner_battle_spent_points(direction_override, override_value)
	total += get_ordinary_trait_spent_points()
	return total

/datum/tat_directions/proc/get_ordinary_trait_spent_points()
	if(!owner_build?.traits)
		return 0
	var/total = 0
	for(var/trait_id in owner_build.traits.selected)
		if(get_trait_direction(trait_id) != TAT_DIRECTION_ORDINARY)
			continue
		total += get_trait_cost(trait_id) * owner_build.traits.get_trait_count(trait_id)
	return total

/datum/tat_directions/proc/get_next_point_cost(direction)
	direction = normalize_direction(direction)
	if(!direction)
		return 0
	var/current = get_allocated_points(direction)
	return max(0, get_spent_points(direction, current + 1) - get_spent_points())

/datum/tat_directions/proc/get_total_points()
	return TAT_DIRECTION_POINTS + get_role_bonus_points() + (owner_build?.traits?.get_bonus_direction_points() || 0)

/datum/tat_directions/proc/get_role_bonus_points()
	switch(get_role_choice())
		if(TAT_ROLE_CHOICE_ADVENTURER)
			return 2
		if(TAT_ROLE_CHOICE_WRETCH)
			return 2
	return 0

/datum/tat_directions/proc/get_remaining_points()
	return get_total_points() - get_spent_points()

/datum/tat_directions/proc/set_points(direction, value)
	direction = normalize_direction(direction)
	if(!direction)
		return FALSE
	value = max(0, round(text2num("[value]") || 0))
	value = max(0, value - get_role_direction_points(direction))
	var/current = get_allocated_points(direction)
	if(value == current)
		return TRUE
	if(value > current && get_spent_points(direction, value) > get_total_points())
		return FALSE
	points[direction] = value
	owner_build?.traits?.sanitize()
	owner_build?.skills?.refresh_after_trait_change()
	owner_build?.items?.sanitize()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_directions/proc/add_point(direction, amount = 1)
	direction = normalize_direction(direction)
	if(!direction)
		return FALSE
	amount = max(1, round(text2num("[amount]") || 1))
	return set_points(direction, get_points(direction) + amount)

/datum/tat_directions/proc/remove_point(direction, amount = 1)
	direction = normalize_direction(direction)
	if(!direction)
		return FALSE
	amount = max(1, round(text2num("[amount]") || 1))
	return set_points(direction, get_points(direction) - amount)

/datum/tat_directions/proc/get_trait_rule(trait_id)
	var/list/rule = GLOB.tat_direction_trait_rules[trait_id]
	return islist(rule) ? rule : null

/datum/tat_directions/proc/is_direction_trait(trait_id)
	return islist(get_trait_rule(trait_id))

/datum/tat_directions/proc/get_trait_direction(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	return rule ? rule["direction"] : null

/datum/tat_directions/proc/is_handicraft_cluster_trait(trait_id)
	return trait_id == TAT_TRAIT_MASTER_OF_CRAFTING || trait_id == TAT_TRAIT_STRAYING_SOUL

/datum/tat_directions/proc/get_first_selected_handicraft_cluster_trait()
	if(!owner_build?.traits?.selected)
		return null
	for(var/trait_id in owner_build.traits.selected)
		if(is_handicraft_cluster_trait(trait_id) && owner_build.traits.get_trait_count(trait_id) > 0)
			return trait_id
	return null

/datum/tat_directions/proc/get_handicraft_cluster_trait_cost(trait_id)
	if(!is_handicraft_cluster_trait(trait_id))
		return -1
	switch(get_role_choice())
		if(TAT_ROLE_CHOICE_TRADER)
			return 1
		if(TAT_ROLE_CHOICE_TOWNER)
			var/first_trait = get_first_selected_handicraft_cluster_trait()
			if(!first_trait || first_trait == trait_id)
				return 0
	return 2

/datum/tat_directions/proc/get_trait_cost(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	if(!rule)
		return 0
	var/handicraft_cost = get_handicraft_cluster_trait_cost(trait_id)
	if(handicraft_cost >= 0)
		return handicraft_cost
	if(trait_id == TRAIT_OUTDOORSMAN && get_role_choice() == TAT_ROLE_CHOICE_TOWNER)
		return 1
	return max(0, owner_build?.traits?.get_base_cost(trait_id) || 0)

/datum/tat_directions/proc/get_trait_tier(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	return rule ? max(0, round(rule["tier"] || 0)) : 0

/datum/tat_directions/proc/get_trait_requirements(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	if(!rule)
		return null
	var/list/requirements = rule["requirements"]
	return islist(requirements) ? requirements.Copy() : null

/datum/tat_directions/proc/trait_requirements_met(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	if(!rule)
		return TRUE
	var/list/requirements = rule["requirements"]
	if(!islist(requirements))
		return TRUE
	for(var/direction in requirements)
		if(direction == TAT_DIRECTION_ORDINARY)
			if(get_trait_tier(trait_id) < round(requirements[direction] || 0))
				return FALSE
			continue
		if(get_points(direction) < round(requirements[direction] || 0))
			return FALSE
	return TRUE

/datum/tat_directions/proc/get_trait_requirement_text(trait_id)
	var/list/rule = get_trait_rule(trait_id)
	if(!rule)
		return null
	if(rule["direction"] == TAT_DIRECTION_ORDINARY)
		return null
	var/list/requirements = rule["requirements"]
	if(!islist(requirements) || !length(requirements))
		return null
	var/list/parts = list()
	for(var/direction in requirements)
		var/name = GLOB.tat_direction_names[direction] || direction
		parts += "[name] [requirements[direction]]"
	return parts.Join(", ")

/datum/tat_directions/proc/get_spent_trait_points(direction)
	direction = normalize_direction(direction)
	if(!direction || !owner_build?.traits)
		return 0
	var/total = 0
	for(var/trait_id in owner_build.traits.selected)
		if(get_trait_direction(trait_id) != direction)
			continue
		total += get_trait_cost(trait_id) * owner_build.traits.get_trait_count(trait_id)
	return total

/datum/tat_directions/proc/get_remaining_trait_points(direction)
	direction = normalize_direction(direction)
	if(!direction)
		return 0
	return get_points(direction) - get_spent_trait_points(direction)

/datum/tat_directions/proc/can_select_trait(trait_id)
	if(!is_direction_trait(trait_id))
		return TRUE
	if(!trait_requirements_met(trait_id))
		return FALSE
	var/direction = get_trait_direction(trait_id)
	if(direction == TAT_DIRECTION_ORDINARY)
		if(owner_build?.traits?.has_trait(trait_id))
			return get_remaining_points() >= 0
		return get_remaining_points() >= get_trait_cost(trait_id)
	if(owner_build?.traits?.has_trait(trait_id))
		return TRUE
	return get_remaining_trait_points(direction) >= get_trait_cost(trait_id)

/datum/tat_directions/proc/get_trait_block_reason(trait_id)
	if(!is_direction_trait(trait_id))
		return null
	var/requirement_text = get_trait_requirement_text(trait_id)
	if(requirement_text && !trait_requirements_met(trait_id))
		return "Requires [requirement_text]."
	var/direction = get_trait_direction(trait_id)
	if(direction == TAT_DIRECTION_ORDINARY)
		if(get_remaining_points() < get_trait_cost(trait_id))
			return "Not enough unspent direction points."
		return null
	if(get_remaining_trait_points(direction) < get_trait_cost(trait_id))
		return "Not enough unspent [GLOB.tat_direction_names[direction] || direction] direction points."
	return null

/datum/tat_directions/proc/sanitize()
	if(!islist(points))
		points = list()
	adopt_legacy_role_traits()
	foundation = normalize_foundation(foundation)
	role_choice = normalize_role_choice(role_choice)
	if(round(text2num("[points[TAT_DIRECTION_DEFENSE]]") || 0) > 0)
		points[TAT_DIRECTION_COMBAT] = max(0, round(points[TAT_DIRECTION_COMBAT] || 0)) + max(0, round(text2num("[points[TAT_DIRECTION_DEFENSE]]") || 0))
		points -= TAT_DIRECTION_DEFENSE
	for(var/key in points.Copy())
		if(!(key in TAT_DIRECTION_ORDER))
			points -= key
	for(var/direction in TAT_DIRECTION_ORDER)
		points[direction] = max(0, round(text2num("[points[direction]]") || 0))
	while(get_spent_points() > get_total_points())
		var/changed = FALSE
		var/list/order = TAT_DIRECTION_ORDER
		var/i = length(order)
		while(i >= 1)
			var/direction = order[i]
			if(get_allocated_points(direction) <= 0)
				i--
				continue
			points[direction] = get_allocated_points(direction) - 1
			changed = TRUE
			break
		if(!changed)
			break
	return TRUE

/datum/tat_directions/proc/export_to_list()
	sanitize()
	var/list/exported_points = list()
	for(var/direction in TAT_DIRECTION_ORDER)
		exported_points[direction] = get_allocated_points(direction)
	return list(
		"foundation" = foundation,
		"role_choice" = get_role_choice(),
		"points" = exported_points,
	)

/datum/tat_directions/proc/import_from_list(list/data, run_sanitize = TRUE)
	reset()
	if(!islist(data))
		return FALSE
	foundation = normalize_foundation(data["foundation"])
	role_choice = normalize_role_choice(data["role_choice"])
	var/list/imported_points = data["points"]
	if(islist(imported_points))
		for(var/direction in imported_points)
			var/normalized = direction == TAT_DIRECTION_DEFENSE ? TAT_DIRECTION_COMBAT : normalize_direction(direction)
			if(normalized)
				points[normalized] = max(0, round(points[normalized] || 0)) + max(0, round(text2num("[imported_points[direction]]") || 0))
	if(run_sanitize)
		sanitize()
	return TRUE

/datum/tat_directions/proc/export_to_json_list()
	return export_to_list()

/datum/tat_directions/proc/import_from_json_list(list/data, run_sanitize = TRUE)
	return import_from_list(data, run_sanitize)

/datum/tat_directions/proc/build_ui_state()
	var/list/result = list()
	for(var/direction in TAT_DIRECTION_ORDER)
		result[direction] = list(
			"points" = get_points(direction),
			"spent" = get_spent_trait_points(direction),
			"remaining" = get_remaining_trait_points(direction),
			"next_cost" = get_next_point_cost(direction),
			"name" = GLOB.tat_direction_names[direction] || direction,
		)
	return list(
		"foundation" = foundation,
		"role_choice" = get_role_choice(),
		"points_total" = get_total_points(),
		"points_spent" = get_spent_points(),
		"points_remaining" = get_remaining_points(),
		"directions" = result,
		"foundation_names" = GLOB.tat_foundation_names,
		"foundation_role_choices" = GLOB.tat_foundation_role_choices,
		"role_choice_names" = GLOB.tat_role_choice_names,
		"direction_order" = TAT_DIRECTION_ORDER,
	)
