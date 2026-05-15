/datum/tat_skills
	var/datum/tat_build/owner_build
	var/list/invested = list()
	var/list/bonus = list()
	var/list/domain_points = list()
	var/skill_point_conversion_pool = 0
	var/list/spent_points_cache = list()
	var/_cached_combat_expert_count = -1
	var/_cached_combat_master_count = -1

/datum/tat_skills/proc/invalidate_combat_count_cache()
	_cached_combat_expert_count = -1
	_cached_combat_master_count = -1

/datum/tat_skills/New(datum/tat_build/B)
	. = ..()
	owner_build = B
	reset()

/datum/tat_skills/proc/reset()
	invested = list()
	bonus = list()
	invalidate_combat_count_cache()
	invalidate_spent_points_cache()

	var/list/default_domain_points = TAT_DEFAULT_SKILL_DOMAIN_POINTS
	domain_points = default_domain_points.Copy()
	skill_point_conversion_pool = 0

	return TRUE

/datum/tat_skills/proc/invalidate_spent_points_cache()
	spent_points_cache = list()
	return TRUE

/datum/tat_skills/proc/get_domain(skill_type)
	return tat_get_skill_domain(skill_type)

/datum/tat_skills/proc/normalize_skill_domain(domain)
	if(domain == TAT_SKILL_DOMAIN_COMBAT)
		return TAT_SKILL_DOMAIN_COMBAT
	if(domain == TAT_SKILL_DOMAIN_WANDERING)
		return TAT_SKILL_DOMAIN_WANDERING
	if(domain == TAT_SKILL_DOMAIN_GATHERING)
		return TAT_SKILL_DOMAIN_GATHERING
	if(domain == TAT_SKILL_DOMAIN_CRAFTING)
		return TAT_SKILL_DOMAIN_CRAFTING
	if(domain == TAT_SKILL_DOMAIN_MISC)
		return TAT_SKILL_DOMAIN_MISC
	return null

/datum/tat_skills/proc/can_give_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return FALSE
	amount = max(1, round(amount || 1))
	if(round(domain_points[domain] || 0) < amount)
		return FALSE
	return get_remaining_points(domain) >= amount

/datum/tat_skills/proc/can_take_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	if(!domain || domain == TAT_SKILL_DOMAIN_COMBAT)
		return FALSE
	amount = max(1, round(amount || 1))
	return skill_point_conversion_pool >= amount

/datum/tat_skills/proc/give_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return FALSE
	amount = max(1, round(amount || 1))
	if(!can_give_skill_domain_points(domain, amount))
		return FALSE
	domain_points[domain] = round(domain_points[domain] || 0) - amount
	skill_point_conversion_pool += amount
	invalidate_spent_points_cache()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/take_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return FALSE
	amount = max(1, round(amount || 1))
	if(!can_take_skill_domain_points(domain, amount))
		return FALSE
	domain_points[domain] = round(domain_points[domain] || 0) + amount
	skill_point_conversion_pool -= amount
	invalidate_spent_points_cache()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/build_skill_conversion_state()
	var/list/result = list()
	for(var/domain in list(TAT_SKILL_DOMAIN_COMBAT, TAT_SKILL_DOMAIN_WANDERING, TAT_SKILL_DOMAIN_GATHERING, TAT_SKILL_DOMAIN_CRAFTING, TAT_SKILL_DOMAIN_MISC))
		result[domain] = list(
			"can_give" = can_give_skill_domain_points(domain),
			"can_take" = can_take_skill_domain_points(domain),
		)
	return result


/datum/tat_skills/proc/get_invested_value(skill_type)
	return round(invested[skill_type] || 0)

/datum/tat_skills/proc/get_bonus_value(skill_type)
	if(!check_skill(skill_type))
		return 0
	if(owner_build)
		return round(owner_build.get_bonus_skill_value(skill_type) || 0)
	return round(bonus[skill_type] || 0)

/datum/tat_skills/proc/virtue_matches_rule(virtue_entry, virtue_rule)
	if(!virtue_entry || !virtue_rule)
		return FALSE
	if(ispath(virtue_entry))
		return virtue_entry == virtue_rule || ispath(virtue_entry, virtue_rule)
	if(istype(virtue_entry, /datum/virtue))
		return istype(virtue_entry, virtue_rule)
	return virtue_entry == virtue_rule

/datum/tat_skills/proc/add_virtue_rule_value(skill_type, list/rules, list/virtues)
	var/total = 0
	if(!islist(rules) || !islist(virtues) || !length(virtues))
		return 0

	for(var/virtue_entry in virtues)
		for(var/virtue_rule in rules)
			if(!virtue_matches_rule(virtue_entry, virtue_rule))
				continue

			var/list/skill_map = rules[virtue_rule]
			if(islist(skill_map))
				total += round(skill_map[skill_type] || 0)

	return total

/datum/tat_skills/proc/add_virtue_choice_rule_value(skill_type, list/rules, list/virtues)
	var/total = 0
	if(!islist(rules) || !islist(virtues) || !length(virtues))
		return 0

	for(var/virtue_entry in virtues)
		if(!istype(virtue_entry, /datum/virtue))
			continue
		var/datum/virtue/virtue_datum = virtue_entry
		if(!LAZYLEN(virtue_datum.picked_choices))
			continue

		for(var/virtue_rule in rules)
			if(!virtue_matches_rule(virtue_datum, virtue_rule))
				continue

			var/list/choice_map = rules[virtue_rule]
			if(!islist(choice_map))
				continue

			for(var/choice in virtue_datum.picked_choices)
				var/list/skill_map = choice_map[choice]
				if(islist(skill_map))
					total += round(skill_map[skill_type] || 0)

	return total

/datum/tat_skills/proc/get_virtue_bonus_value(skill_type)
	var/list/virtues = owner_build?.get_active_virtues()
	if(!length(virtues))
		return 0
	return add_virtue_rule_value(skill_type, GLOB.tat_virtue_skill_bonus_rules, virtues) + add_virtue_choice_rule_value(skill_type, GLOB.tat_virtue_choice_skill_bonus_rules, virtues)

/datum/tat_skills/proc/get_virtue_skill_cap_bonus(skill_type)
	var/list/virtues = owner_build?.get_active_virtues()
	if(!length(virtues))
		return 0
	return add_virtue_rule_value(skill_type, GLOB.tat_virtue_skill_cap_bonus_rules, virtues) + add_virtue_choice_rule_value(skill_type, GLOB.tat_virtue_choice_skill_cap_bonus_rules, virtues)

/datum/tat_skills/proc/rebuild_bonus_values()
	bonus = list()
	invalidate_spent_points_cache()

	for(var/skill_type in TAT_SKILLS_ALL)
		var/value = owner_build ? owner_build.get_bonus_skill_value(skill_type) : 0
		if(value > 0)
			bonus[skill_type] = round(value)

	return TRUE

/datum/tat_skills/proc/check_skill(skill_type)
	return !!get_domain(skill_type)

/datum/tat_skills/proc/get_total_maximum(domain)
	return round((domain_points[domain] || 0) + (owner_build ? owner_build.get_bonus_skill_domain_points(domain) : 0))

/datum/tat_skills/proc/get_combat_expert_count(except_skill_type = null)
	if(!except_skill_type && _cached_combat_expert_count >= 0)
		return _cached_combat_expert_count

	var/count = 0
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(skill_type == except_skill_type)
			continue
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue
		if(get_raw_total_value(skill_type) >= TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT)
			count++

	if(!except_skill_type)
		_cached_combat_expert_count = count
	return count

/datum/tat_skills/proc/get_combat_master_count(except_skill_type = null)
	if(!except_skill_type && _cached_combat_master_count >= 0)
		return _cached_combat_master_count

	var/count = 0
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(skill_type == except_skill_type)
			continue
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue
		if(get_raw_total_value(skill_type) >= TAT_SKILL_COMBAT_CAP_TRAIT_MASTER)
			count++

	if(!except_skill_type)
		_cached_combat_master_count = count
	return count

/datum/tat_skills/proc/get_raw_total_value(skill_type, invested_override = null)
	var/invested_value = isnull(invested_override) ? get_invested_value(skill_type) : max(0, round(invested_override))
	return invested_value + get_bonus_value(skill_type)

/datum/tat_skills/proc/is_limited_combat_skill(skill_type)
	if(!ispath(skill_type, /datum/skill/combat))
		return FALSE
	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return FALSE
	return TRUE

/datum/tat_skills/proc/get_hypothetical_combat_threshold_count(threshold, changed_skill_type = null, changed_invested_value = null)
	var/count = 0
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(!is_limited_combat_skill(skill_type))
			continue

		var/invested_override = null
		if(skill_type == changed_skill_type)
			invested_override = changed_invested_value

		if(get_raw_total_value(skill_type, invested_override) >= threshold)
			count++

	return count

/datum/tat_skills/proc/would_violate_combat_hardcaps(skill_type, invested_value)
	if(!is_limited_combat_skill(skill_type))
		return FALSE

	var/expert_count = get_hypothetical_combat_threshold_count(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT, skill_type, invested_value)
	if(expert_count > TAT_COMBAT_EXPERT_SKILL_LIMIT)
		return TRUE

	var/master_count = get_hypothetical_combat_threshold_count(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER, skill_type, invested_value)
	if(master_count > TAT_COMBAT_MASTER_SKILL_LIMIT)
		return TRUE

	return FALSE

/datum/tat_skills/proc/get_combat_threshold_overflow_skill(threshold)
	var/limit = (threshold >= TAT_SKILL_COMBAT_CAP_TRAIT_MASTER) ? TAT_COMBAT_MASTER_SKILL_LIMIT : TAT_COMBAT_EXPERT_SKILL_LIMIT
	if(get_hypothetical_combat_threshold_count(threshold) <= limit)
		return null

	var/best_skill = null
	var/best_score = -999999999
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(!is_limited_combat_skill(skill_type))
			continue

		var/invested_value = get_invested_value(skill_type)
		if(invested_value <= 0)
			continue

		var/total_value = get_raw_total_value(skill_type)
		if(total_value < threshold)
			continue

		// Prefer removing the point that actually drops the skill below the overflowing threshold.
		// Bonus-only skills still count against the quota, but they cannot be fixed by stripping TAT points.
		var/drops_below_threshold = (get_raw_total_value(skill_type, invested_value - 1) < threshold)
		var/score = 0
		if(drops_below_threshold)
			score += 10000
		score += get_bonus_value(skill_type) * 100
		score += invested_value

		if(score > best_score)
			best_score = score
			best_skill = skill_type

	return best_skill

/datum/tat_skills/proc/enforce_combat_hardcaps()
	var/changed = FALSE

	while(get_hypothetical_combat_threshold_count(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER) > TAT_COMBAT_MASTER_SKILL_LIMIT)
		var/skill_type = get_combat_threshold_overflow_skill(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER)
		if(!skill_type)
			break
		var/current = get_invested_value(skill_type)
		if(current <= 0)
			break
		invested[skill_type] = current - 1
		if(invested[skill_type] <= 0)
			invested -= skill_type
		changed = TRUE
		invalidate_combat_count_cache()
		invalidate_spent_points_cache()

	while(get_hypothetical_combat_threshold_count(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT) > TAT_COMBAT_EXPERT_SKILL_LIMIT)
		var/skill_type = get_combat_threshold_overflow_skill(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT)
		if(!skill_type)
			break
		var/current = get_invested_value(skill_type)
		if(current <= 0)
			break
		invested[skill_type] = current - 1
		if(invested[skill_type] <= 0)
			invested -= skill_type
		changed = TRUE
		invalidate_combat_count_cache()
		invalidate_spent_points_cache()

	if(changed)
		owner_build?.set_dirty()

	return changed

/datum/tat_skills/proc/get_trait_cap_bonus(skill_type)
	return owner_build ? owner_build.get_skill_cap_bonus_value(skill_type) : 0

/datum/tat_skills/proc/skill_has_trait_cap_rule(skill_type)
	var/list/rules = GLOB.tat_trait_skill_cap_bonus_rules

	for(var/trait_id in rules)
		var/list/skill_map = rules[trait_id]
		if(!islist(skill_map))
			continue

		if(skill_type in skill_map)
			return TRUE

	return FALSE

/datum/tat_skills/proc/get_firearms_skill_cap(skill_type)
	var/cap = TAT_SKILL_NONCOMBAT_CAP_UNTRAITED

	if(owner_build?.has_trait(TRAIT_FIREARMS_MARKSMAN))
		cap = TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_combat_skill_cap(skill_type)
	if(!ispath(skill_type, /datum/skill/combat))
		return TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM

	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return get_firearms_skill_cap(skill_type)

	var/base_cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	var/expert_cap = TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT
	var/master_cap = TAT_SKILL_COMBAT_CAP_TRAIT_MASTER

	var/has_expert = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_EXPERT)
	var/has_master = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_MASTER)

	var/current_invested = get_invested_value(skill_type)
	var/bonus_value = get_bonus_value(skill_type)

	var/cap = base_cap

	if(has_expert)
		var/expert_invested_target = max(current_invested, expert_cap - bonus_value)
		if(expert_invested_target >= 0 && get_raw_total_value(skill_type, expert_invested_target) >= expert_cap && !would_violate_combat_hardcaps(skill_type, expert_invested_target))
			cap = expert_cap

	if(has_master && cap >= expert_cap)
		var/master_invested_target = max(current_invested, master_cap - bonus_value)
		if(master_invested_target >= 0 && get_raw_total_value(skill_type, master_invested_target) >= master_cap && !would_violate_combat_hardcaps(skill_type, master_invested_target))
			cap = master_cap

	var/cap_bonus = get_trait_cap_bonus(skill_type)
	if(cap_bonus > 0)
		cap = max(cap, base_cap + cap_bonus)

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_magic_skill_cap(skill_type)
	var/cap = 0

	if(skill_type == /datum/skill/magic/arcane)
		if(owner_build?.has_trait(TRAIT_ARCYNE))
			cap = 6

	else if(skill_type == /datum/skill/magic/holy)
		if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_3))
			cap = 6
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_2))
			cap = 5
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_1))
			cap = 3
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_INITIATE))
			cap = 1
		else if(owner_build?.has_trait(TAT_TRAIT_DRUID_INITIATE))
			cap = 3

	else if(skill_type == /datum/skill/magic/druidic)
		if(owner_build?.has_trait(TAT_TRAIT_DRUID_INITIATE))
			cap = 3

	var/cap_bonus = get_trait_cap_bonus(skill_type) + get_virtue_skill_cap_bonus(skill_type)
	if(cap_bonus > 0)
		if(cap > 0)
			cap += cap_bonus
		else
			cap = cap_bonus

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_noncombat_skill_cap(skill_type)
	var/base_cap = TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM

	if(skill_has_trait_cap_rule(skill_type))
		base_cap = TAT_SKILL_NONCOMBAT_CAP_UNTRAITED

	var/cap = base_cap + get_trait_cap_bonus(skill_type)
	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_maximum(skill_type)
	if(!check_skill(skill_type))
		return 0

	if(ispath(skill_type, /datum/skill/magic))
		return get_magic_skill_cap(skill_type)

	if(ispath(skill_type, /datum/skill/combat))
		return get_combat_skill_cap(skill_type)

	return get_noncombat_skill_cap(skill_type)

/datum/tat_skills/proc/get_invested_maximum(skill_type)
	var/domain = get_domain(skill_type)
	if(!domain)
		return 0

	return max(0, get_maximum(skill_type) - get_bonus_value(skill_type))

/datum/tat_skills/proc/get_total_value(skill_type)
	return clamp(get_invested_value(skill_type) + get_bonus_value(skill_type), 0, get_maximum(skill_type))

/datum/tat_skills/proc/get_step_cost(skill_type, target_level)
	if(target_level <= 0)
		return 0
	if(target_level > get_invested_maximum(skill_type))
		return 0

	var/discount = owner_build ? owner_build.get_skill_cost_discount(skill_type, target_level) : 0
	return max(1, target_level - discount)

/datum/tat_skills/proc/get_total_cost_for_level(skill_type, level)
	var/total = 0

	for(var/i in 1 to level)
		total += get_step_cost(skill_type, i)

	return total

/datum/tat_skills/proc/get_spent_points(domain)
	if(domain in spent_points_cache)
		return spent_points_cache[domain]

	var/total = 0
	for(var/skill_type in invested)
		if(get_domain(skill_type) != domain)
			continue
		total += get_total_cost_for_level(skill_type, get_invested_value(skill_type))

	spent_points_cache[domain] = total
	return total

/datum/tat_skills/proc/get_remaining_points(domain)
	return get_total_maximum(domain) - get_spent_points(domain)

/datum/tat_skills/proc/get_any_negative_remaining()
	for(var/domain in domain_points)
		if(get_remaining_points(domain) < 0)
			return TRUE

	return FALSE

/datum/tat_skills/proc/set_invested_value(skill_type, value, ignore_budget = FALSE)
	var/domain = get_domain(skill_type)
	if(!domain)
		return FALSE

	value = round(value)
	value = max(0, value)

	var/invested_cap = get_invested_maximum(skill_type)

	if(value > invested_cap)
		value = invested_cap

	var/old_value = get_invested_value(skill_type)
	if(value == old_value)
		return TRUE

	if(value > old_value && would_violate_combat_hardcaps(skill_type, value))
		return FALSE

	var/old_cost = get_total_cost_for_level(skill_type, old_value)
	var/new_cost = get_total_cost_for_level(skill_type, value)

	var/current_domain_spent = get_spent_points(domain)
	var/new_domain_spent = current_domain_spent - old_cost + new_cost
	var/domain_max = get_total_maximum(domain)

	if(!ignore_budget && new_domain_spent > domain_max)
		return FALSE

	if(value <= 0)
		invested -= skill_type
	else
		invested[skill_type] = value

	invalidate_combat_count_cache()
	invalidate_spent_points_cache()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/refresh_after_trait_change()
	return sanitize(FALSE)

/datum/tat_skills/proc/sanitize(enforce_budget = TRUE)
	invalidate_combat_count_cache()
	invalidate_spent_points_cache()
	rebuild_bonus_values()

	for(var/skill_type in invested.Copy())
		if(!check_skill(skill_type))
			invested -= skill_type
			continue

		var/current = get_invested_value(skill_type)
		set_invested_value(skill_type, current)

	enforce_combat_hardcaps()

	if(!enforce_budget)
		return TRUE

	for(var/domain in domain_points)
		while(get_remaining_points(domain) < 0)
			var/changed = FALSE

			for(var/skill_type in invested.Copy())
				if(get_domain(skill_type) != domain)
					continue

				var/current = get_invested_value(skill_type)
				if(current <= 0)
					continue

				if(set_invested_value(skill_type, current - 1))
					changed = TRUE
					if(get_remaining_points(domain) >= 0)
						break

			if(!changed)
				break

	return TRUE

/datum/tat_skills/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	for(var/skill_type in TAT_SKILLS_ALL)
		var/level = get_total_value(skill_type)
		if(level > 0)
			H.adjust_skillrank_up_to(skill_type, level, TRUE)

	return TRUE

/datum/tat_skills/proc/disable_from_human(mob/living/carbon/human/H)
	return TRUE

/datum/tat_skills/proc/export_to_list()
	return list(
		"invested" = invested.Copy(),
		"bonus" = bonus.Copy(),
		"domain_points" = domain_points.Copy(),
		"skill_point_conversion_pool" = skill_point_conversion_pool,
	)

/datum/tat_skills/proc/import_from_list(list/data)
	reset()

	if(!islist(data))
		return FALSE

	if(islist(data["domain_points"]))
		var/list/imported_domains = data["domain_points"]
		for(var/domain in imported_domains)
			var/normalized_domain = normalize_skill_domain(domain)
			if(normalized_domain)
				domain_points[normalized_domain] = max(0, round(text2num("[imported_domains[domain]]") || 0))
	var/raw_conversion_pool = data["skill_point_conversion_pool"]
	skill_point_conversion_pool = max(0, round(text2num("[raw_conversion_pool]") || 0))

	var/list/imported_invested = null
	if(islist(data["invested"]))
		imported_invested = data["invested"]
	else
		imported_invested = data

	for(var/skill_type in imported_invested)
		if(skill_type == "bonus")
			continue
		if(skill_type == "invested")
			continue
		set_invested_value(skill_type, imported_invested[skill_type])

	rebuild_bonus_values()
	sanitize()
	return TRUE

/datum/tat_skills/proc/export_to_json_list()
	var/list/exported_invested = list()
	for(var/skill_type in invested)
		var/value = get_invested_value(skill_type)
		if(value > 0)
			exported_invested["[skill_type]"] = value
	return list(
		"invested" = exported_invested,
		"domain_points" = domain_points.Copy(),
		"skill_point_conversion_pool" = skill_point_conversion_pool,
	)

/datum/tat_skills/proc/import_from_json_list(list/data)
	reset()
	if(!islist(data))
		return FALSE

	if(islist(data["domain_points"]))
		var/list/imported_domains = data["domain_points"]
		for(var/domain in imported_domains)
			var/normalized_domain = normalize_skill_domain(domain)
			if(normalized_domain)
				domain_points[normalized_domain] = max(0, round(text2num("[imported_domains[domain]]") || 0))
	var/raw_conversion_pool = data["skill_point_conversion_pool"]
	skill_point_conversion_pool = max(0, round(text2num("[raw_conversion_pool]") || 0))

	var/list/imported_invested = null
	if(islist(data["invested"]))
		imported_invested = data["invested"]
	else
		imported_invested = data

	for(var/raw_path in imported_invested)
		if(raw_path == "bonus" || raw_path == "invested")
			continue
		var/skill_type = ispath(raw_path) ? raw_path : text2path("[raw_path]")
		if(!skill_type)
			continue
		set_invested_value(skill_type, text2num("[imported_invested[raw_path]]"))

	rebuild_bonus_values()
	sanitize()
	return TRUE
