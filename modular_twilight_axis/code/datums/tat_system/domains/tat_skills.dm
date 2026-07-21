/datum/tat_skills
	var/datum/tat_build/owner_build
	var/list/invested = list()
	var/list/bonus = list()
	var/list/domain_points = list()
	var/list/converted_role_points = list()
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
	converted_role_points = list()
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
	if(domain == TAT_SKILL_DOMAIN_PEACEFUL)
		return TAT_SKILL_DOMAIN_PEACEFUL
	if(domain == TAT_SKILL_DOMAIN_ADVENTURE)
		return TAT_SKILL_DOMAIN_ADVENTURE
	if(domain == TAT_SKILL_DOMAIN_WANDERING)
		return TAT_SKILL_DOMAIN_ADVENTURE
	if(domain == TAT_SKILL_DOMAIN_GATHERING)
		return TAT_SKILL_DOMAIN_PEACEFUL
	if(domain == TAT_SKILL_DOMAIN_CRAFTING)
		return TAT_SKILL_DOMAIN_PEACEFUL
	if(domain == TAT_SKILL_DOMAIN_MISC)
		return TAT_SKILL_DOMAIN_ADVENTURE
	return null

/datum/tat_skills/proc/is_convertible_skill_domain(domain)
	domain = normalize_skill_domain(domain)
	return domain == TAT_SKILL_DOMAIN_PEACEFUL || domain == TAT_SKILL_DOMAIN_ADVENTURE

/datum/tat_skills/proc/can_convert_from_skill_domain(domain)
	domain = normalize_skill_domain(domain)
	return domain == TAT_SKILL_DOMAIN_COMBAT || is_convertible_skill_domain(domain)

/datum/tat_skills/proc/can_receive_converted_skill_domain(domain)
	domain = normalize_skill_domain(domain)
	return domain == TAT_SKILL_DOMAIN_COMBAT || is_convertible_skill_domain(domain)

/datum/tat_skills/proc/get_converted_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	var/list/default_domain_points = TAT_DEFAULT_SKILL_DOMAIN_POINTS
	var/default_value = max(0, round(default_domain_points[domain] || 0))
	return max(0, round(domain_points[domain] || 0) - default_value)

/datum/tat_skills/proc/get_converted_combat_points()
	return get_converted_domain_points(TAT_SKILL_DOMAIN_COMBAT)

/datum/tat_skills/proc/can_give_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	amount = max(1, round(text2num("[amount]") || 1))
	if(domain == TAT_SKILL_DOMAIN_COMBAT)
		return skill_point_conversion_pool >= amount && get_converted_combat_points() + amount <= TAT_COMBAT_CONVERTED_POINT_LIMIT
	if(!can_receive_converted_skill_domain(domain))
		return FALSE
	return skill_point_conversion_pool >= amount

/datum/tat_skills/proc/can_take_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	if(!can_convert_from_skill_domain(domain))
		return FALSE
	amount = max(1, round(text2num("[amount]") || 1))
	return get_convertible_remaining_points(domain) >= amount

/datum/tat_skills/proc/give_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	amount = max(1, round(text2num("[amount]") || 1))
	if(!can_give_skill_domain_points(domain, amount))
		return FALSE
	var/role_return = min(amount, get_converted_role_points(domain))
	if(role_return > 0)
		converted_role_points[domain] = get_converted_role_points(domain) - role_return
	var/base_return = amount - role_return
	if(base_return > 0)
		domain_points[domain] = max(0, round(domain_points[domain] || 0)) + base_return
	skill_point_conversion_pool -= amount
	invalidate_spent_points_cache()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/take_skill_domain_points(domain, amount = 1)
	domain = normalize_skill_domain(domain)
	amount = max(1, round(text2num("[amount]") || 1))
	if(!can_take_skill_domain_points(domain, amount))
		return FALSE
	var/remaining_amount = amount
	var/converted_amount = min(remaining_amount, get_free_converted_domain_points(domain))
	if(converted_amount > 0)
		domain_points[domain] = max(0, round(domain_points[domain] || 0) - converted_amount)
		remaining_amount -= converted_amount
	var/base_amount = min(remaining_amount, max(0, get_base_remaining_points(domain)))
	var/role_amount = remaining_amount - base_amount
	if(base_amount > 0)
		domain_points[domain] = max(0, round(domain_points[domain] || 0) - base_amount)
	if(role_amount > 0)
		converted_role_points[domain] = get_converted_role_points(domain) + role_amount
	skill_point_conversion_pool += amount
	invalidate_spent_points_cache()
	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/build_skill_conversion_state()
	var/list/result = list()
	for(var/domain in list(TAT_SKILL_DOMAIN_COMBAT, TAT_SKILL_DOMAIN_PEACEFUL, TAT_SKILL_DOMAIN_ADVENTURE))
		var/can_convert = can_convert_from_skill_domain(domain)
		var/can_receive = can_receive_converted_skill_domain(domain)
		var/give_text = can_receive ? "Move one converted skill point into this pool." : "This skill pool cannot receive converted points."
		var/take_text = can_convert ? "Move one free base or role skill point into conversion." : "This skill pool cannot be converted out."
		if(domain == TAT_SKILL_DOMAIN_COMBAT)
			give_text = "Move one converted skill point into Combat. Combat can receive up to [TAT_COMBAT_CONVERTED_POINT_LIMIT] converted points."
			take_text = "Move one free Combat point into conversion for other skill pools."
		result[domain] = list(
			"can_give" = can_give_skill_domain_points(domain),
			"can_take" = can_take_skill_domain_points(domain),
			"give_text" = give_text,
			"take_text" = take_text,
		)
	return result

/datum/tat_skills/proc/sanitize_skill_domain_points()
	if(!islist(domain_points))
		domain_points = list()
	if(!islist(converted_role_points))
		converted_role_points = list()

	var/list/domains = list(
		TAT_SKILL_DOMAIN_COMBAT,
		TAT_SKILL_DOMAIN_PEACEFUL,
		TAT_SKILL_DOMAIN_ADVENTURE
	)
	var/list/default_domain_points = TAT_DEFAULT_SKILL_DOMAIN_POINTS

	for(var/domain in domain_points.Copy())
		var/normalized = normalize_skill_domain(domain)
		if(!normalized)
			domain_points -= domain
			continue
		if(normalized != domain)
			domain_points[normalized] = round(domain_points[normalized] || 0) + round(domain_points[domain] || 0)
			domain_points -= domain

	for(var/domain in converted_role_points.Copy())
		var/normalized = normalize_skill_domain(domain)
		if(!can_convert_from_skill_domain(normalized))
			converted_role_points -= domain
			continue
		if(normalized != domain)
			converted_role_points[normalized] = round(converted_role_points[normalized] || 0) + round(converted_role_points[domain] || 0)
			converted_role_points -= domain

	for(var/domain in domains)
		converted_role_points[domain] = clamp(round(text2num("[converted_role_points[domain]]") || 0), 0, get_convertible_role_domain_points(domain))

	var/legal_total = 0
	var/base_legal_total = 0
	for(var/domain in domains)
		var/default_value = max(0, round(default_domain_points[domain] || 0))
		legal_total += default_value
		base_legal_total += default_value

		var/current_value = text2num("[domain_points[domain]]")
		domain_points[domain] = max(0, round(current_value || 0))
	for(var/domain in domains)
		legal_total += get_converted_role_points(domain)

	var/combat_default = max(0, round(default_domain_points[TAT_SKILL_DOMAIN_COMBAT] || 0))
	var/combat_maximum = combat_default + TAT_COMBAT_CONVERTED_POINT_LIMIT
	if(round(domain_points[TAT_SKILL_DOMAIN_COMBAT] || 0) > combat_maximum)
		domain_points[TAT_SKILL_DOMAIN_COMBAT] = combat_maximum

	skill_point_conversion_pool = max(0, round(text2num("[skill_point_conversion_pool]") || 0))

	var/current_total = skill_point_conversion_pool
	for(var/domain in domains)
		current_total += round(domain_points[domain] || 0)

	if(current_total > legal_total)
		var/excess = current_total - legal_total

		var/pool_cut = min(skill_point_conversion_pool, excess)
		if(pool_cut > 0)
			skill_point_conversion_pool -= pool_cut
			excess -= pool_cut

		if(excess > 0)
			for(var/domain in domains)
				if(domain == TAT_SKILL_DOMAIN_COMBAT)
					continue

				var/default_value = max(0, round(default_domain_points[domain] || 0))
				var/current_value = round(domain_points[domain] || 0)
				var/surplus = max(0, current_value - default_value)
				var/cut = min(surplus, excess)
				if(cut <= 0)
					continue

				domain_points[domain] = current_value - cut
				excess -= cut
				if(excess <= 0)
					break

		if(excess > 0)
			for(var/domain in domains)
				var/current_value = round(domain_points[domain] || 0)
				var/cut = min(current_value, excess)
				if(cut <= 0)
					continue

				domain_points[domain] = current_value - cut
				excess -= cut
				if(excess <= 0)
					break

	else if(current_total < base_legal_total)
		for(var/domain in domains)
			var/default_value = max(0, round(default_domain_points[domain] || 0))
			var/current_value = round(domain_points[domain] || 0)
			var/missing = default_value - current_value
			if(missing <= 0)
				continue
			var/add = min(missing, base_legal_total - current_total)
			domain_points[domain] = current_value + add
			current_total += add
			if(current_total >= base_legal_total)
				break

	invalidate_spent_points_cache()
	return TRUE


/datum/tat_skills/proc/get_invested_value(skill_type)
	return round(invested[skill_type] || 0)

/datum/tat_skills/proc/get_raw_bonus_value(skill_type)
	if(!check_skill(skill_type))
		return 0
	if(owner_build)
		return round(owner_build.get_bonus_skill_value(skill_type) || 0)
	return round(bonus[skill_type] || 0)

/datum/tat_skills/proc/get_bonus_value(skill_type)
	var/raw_bonus = get_raw_bonus_value(skill_type)
	if(raw_bonus <= 0)
		return 0
	return min(raw_bonus, max(0, get_maximum(skill_type) - get_invested_value(skill_type)))

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

/datum/tat_skills/proc/get_virtue_skill_floor(skill_type)
	return max(get_virtue_bonus_value(skill_type), get_virtue_skill_cap_bonus(skill_type))

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
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return round((domain_points[domain] || 0) + (owner_build ? owner_build.get_bonus_skill_domain_points(domain) : 0) - get_converted_role_points(domain))

/datum/tat_skills/proc/get_trait_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain || !owner_build?.traits)
		return 0
	var/total = owner_build.traits.get_bonus_skill_domain_points(domain)
	if(domain == TAT_SKILL_DOMAIN_COMBAT && owner_build.traits.has_trait(TAT_TRAIT_WEAPON_TRAINING))
		total += 3
	return max(0, round(total || 0))

/datum/tat_skills/proc/get_free_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return max(0, get_total_maximum(domain) - get_trait_domain_points(domain))

/datum/tat_skills/proc/get_base_remaining_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	var/base_points = max(0, round(domain_points[domain] || 0))
	var/convertible_spent = get_convertible_spent_points(domain)
	return max(0, base_points - min(base_points, convertible_spent))

/datum/tat_skills/proc/get_role_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain || !owner_build)
		return 0
	return max(0, round(owner_build.get_role_skill_domain_points(domain) || 0))

/datum/tat_skills/proc/get_convertible_role_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain || !owner_build)
		return 0
	if(domain != TAT_SKILL_DOMAIN_COMBAT)
		return get_role_domain_points(domain)

	var/total = 0
	if(owner_build.directions?.foundation == TAT_FOUNDATION_WANDERER)
		total += 6
	if(owner_build.directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
		total += 6
	return max(0, total)

/datum/tat_skills/proc/get_converted_role_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return max(0, round(converted_role_points[domain] || 0))

/datum/tat_skills/proc/get_convertible_domain_pool(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return max(0, round(domain_points[domain] || 0) + get_convertible_role_domain_points(domain) - get_converted_role_points(domain))

/datum/tat_skills/proc/get_nonconvertible_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return max(0, get_total_maximum(domain) - get_convertible_domain_pool(domain))

/datum/tat_skills/proc/get_nonconvertible_spent_coverage(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	var/spent = get_spent_points(domain)
	if(domain != TAT_SKILL_DOMAIN_COMBAT)
		return min(spent, get_nonconvertible_domain_points(domain))

	var/weapon_training_points = owner_build?.traits?.has_trait(TAT_TRAIT_WEAPON_TRAINING) ? 3 : 0
	var/expert_bonus = get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_EXPERT, TAT_SKILL_DOMAIN_COMBAT)
	var/master_bonus = get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_MASTER, TAT_SKILL_DOMAIN_COMBAT)
	var/expert_spend = get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT)
	var/master_spend = get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER)
	var/restricted_coverage = min(expert_bonus, expert_spend) + min(master_bonus, master_spend)
	return min(spent, weapon_training_points + restricted_coverage)

/datum/tat_skills/proc/get_convertible_spent_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return max(0, get_spent_points(domain) - get_nonconvertible_spent_coverage(domain))

/datum/tat_skills/proc/get_convertible_role_remaining_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	var/role_pool = max(0, get_convertible_role_domain_points(domain) - get_converted_role_points(domain))
	var/convertible_spent = get_convertible_spent_points(domain)
	var/base_points = max(0, round(domain_points[domain] || 0))
	return max(0, role_pool - max(0, convertible_spent - base_points))

/datum/tat_skills/proc/get_free_converted_domain_points(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return 0
	return min(get_converted_domain_points(domain), get_base_remaining_points(domain))

/datum/tat_skills/proc/get_convertible_remaining_points(domain)
	domain = normalize_skill_domain(domain)
	if(!can_convert_from_skill_domain(domain))
		return 0
	return get_base_remaining_points(domain) + get_convertible_role_remaining_points(domain)

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
	return invested_value + get_raw_bonus_value(skill_type)

/datum/tat_skills/proc/is_ranged_combat_skill(skill_type)
	if(ispath(skill_type, /datum/skill/combat/bows))
		return TRUE
	if(ispath(skill_type, /datum/skill/combat/crossbows))
		return TRUE
	if(ispath(skill_type, /datum/skill/combat/slings))
		return TRUE
	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return TRUE
	return FALSE

/datum/tat_skills/proc/get_ranged_synergy_cap(skill_type)
	if(!owner_build?.directions)
		return 0
	var/ranged_points = owner_build.directions.get_points(TAT_DIRECTION_RANGED) || 0
	if(ranged_points <= 0)
		return 0
	if(owner_build.has_trait(TAT_TRAIT_RANGED_SYNERGY_BOWS) && skill_type == /datum/skill/combat/bows)
		return ranged_points
	if(owner_build.has_trait(TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS) && skill_type == /datum/skill/combat/crossbows)
		return ranged_points
	if(owner_build.has_trait(TAT_TRAIT_RANGED_SYNERGY_SLINGS) && skill_type == /datum/skill/combat/slings)
		return ranged_points
	if(owner_build.has_trait(TAT_TRAIT_RANGED_SYNERGY_FIREARMS) && skill_type == /datum/skill/combat/twilight_firearms)
		return ranged_points
	return 0

/datum/tat_skills/proc/is_limited_combat_skill(skill_type)
	if(!ispath(skill_type, /datum/skill/combat))
		return FALSE
	if(is_ranged_combat_skill(skill_type))
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
		score += get_raw_bonus_value(skill_type) * 100
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
	return owner_build?.traits ? owner_build.traits.get_skill_cap_bonus_value(skill_type) : 0

/datum/tat_skills/proc/skill_has_trait_cap_rule(skill_type)
	var/list/rules = GLOB.tat_trait_skill_cap_bonus_rules

	for(var/trait_id in rules)
		var/list/skill_map = rules[trait_id]
		if(!islist(skill_map))
			continue

		if(skill_type in skill_map)
			return TRUE

	return FALSE

/datum/tat_skills/proc/get_base_noncombat_skill_cap(skill_type)
	if(!ispath(skill_type, /datum/skill))
		return 0

	var/static/list/base_caps = list()
	if(skill_type in base_caps)
		return base_caps[skill_type]

	var/cap = TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM
	var/datum/skill/S = new skill_type
	if(S)
		cap = round(S.max_untraited_level || 0)
		qdel(S)

	cap = clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)
	base_caps[skill_type] = cap
	return cap

/datum/tat_skills/proc/get_firearms_skill_cap(skill_type)
	var/cap = TAT_SKILL_NONCOMBAT_CAP_UNTRAITED

	if(owner_build?.has_trait(TRAIT_FIREARMS_MARKSMAN))
		cap = TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT

	cap = max(cap, get_ranged_synergy_cap(skill_type))
	cap = max(cap, get_virtue_skill_floor(skill_type))

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_arcyne_armament_skill_cap(skill_type)
	var/cap = 0
	var/has_arcyne_training = !!owner_build?.has_trait(TRAIT_ARCYNE) || !!owner_build?.has_trait(TAT_TRAIT_MAGE_INITIATE)
	if(!has_arcyne_training)
		return clamp(get_virtue_skill_floor(skill_type), 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

	var/base_cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	var/trained_cap = TAT_SKILL_COMBAT_CAP_WEAPON_TRAINED
	var/expert_cap = TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT
	var/master_cap = TAT_SKILL_COMBAT_CAP_TRAIT_MASTER
	var/has_training_unlock = !!owner_build?.has_trait(TAT_TRAIT_WEAPON_TRAINING) || !!owner_build?.has_role_combat_training_unlock()
	var/has_expert = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_EXPERT) || !!owner_build?.has_trait(TAT_TRAIT_EXPERT_ARMAMENT)
	var/has_master = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_MASTER)
	var/current_invested = get_invested_value(skill_type)
	var/bonus_value = get_raw_bonus_value(skill_type)

	cap = base_cap
	if(has_training_unlock)
		cap = trained_cap

	if(has_expert)
		var/expert_invested_target = max(current_invested, expert_cap - bonus_value)
		if(expert_invested_target >= 0 && get_raw_total_value(skill_type, expert_invested_target) >= expert_cap && !would_violate_combat_hardcaps(skill_type, expert_invested_target))
			cap = expert_cap

	if(has_master && cap >= expert_cap)
		var/master_invested_target = max(current_invested, master_cap - bonus_value)
		if(master_invested_target >= 0 && get_raw_total_value(skill_type, master_invested_target) >= master_cap && !would_violate_combat_hardcaps(skill_type, master_invested_target))
			cap = master_cap

	cap = max(cap, get_virtue_skill_floor(skill_type))

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_combat_skill_cap(skill_type)
	if(!ispath(skill_type, /datum/skill/combat))
		return TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM

	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return get_firearms_skill_cap(skill_type)

	if(skill_type == /datum/skill/combat/arcyne)
		return get_arcyne_armament_skill_cap(skill_type)

	var/base_cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	var/trained_cap = TAT_SKILL_COMBAT_CAP_WEAPON_TRAINED
	var/expert_cap = TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT
	var/master_cap = TAT_SKILL_COMBAT_CAP_TRAIT_MASTER

	var/has_weapon_training = !!owner_build?.has_trait(TAT_TRAIT_WEAPON_TRAINING)
	var/has_training_unlock = has_weapon_training || !!owner_build?.has_role_combat_training_unlock()
	var/has_hunter_cap_unlock = !!owner_build?.has_trait(TAT_TRAIT_HUNTER_SHOOTER)
	var/has_expert = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_EXPERT)
	var/has_master = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_MASTER)
	var/has_pugilist = !!owner_build?.has_trait(TRAIT_CIVILIZEDBARBARIAN)
	var/is_ranged_skill = is_ranged_combat_skill(skill_type)

	var/current_invested = get_invested_value(skill_type)
	var/bonus_value = get_raw_bonus_value(skill_type)

	var/cap = base_cap

	if(has_training_unlock && !is_ranged_skill)
		cap = trained_cap

	if(is_ranged_skill)
		cap = max(cap, get_ranged_synergy_cap(skill_type))

	var/is_pugilist_unarmed_skill = skill_type == /datum/skill/combat/unarmed
	var/is_pugilist_skill = is_pugilist_unarmed_skill || skill_type == /datum/skill/combat/wrestling
	if(has_pugilist && is_pugilist_skill)
		if(has_training_unlock)
			cap = max(cap, expert_cap)
		else
			cap = max(cap, trained_cap)

	if(has_expert && !is_ranged_skill)
		var/expert_invested_target = max(current_invested, expert_cap - bonus_value)
		if(expert_invested_target >= 0 && get_raw_total_value(skill_type, expert_invested_target) >= expert_cap && !would_violate_combat_hardcaps(skill_type, expert_invested_target))
			cap = expert_cap

	if(has_master && !is_ranged_skill && cap >= expert_cap)
		var/master_invested_target = max(current_invested, master_cap - bonus_value)
		if(master_invested_target >= 0 && get_raw_total_value(skill_type, master_invested_target) >= master_cap && !would_violate_combat_hardcaps(skill_type, master_invested_target))
			cap = master_cap

	if(has_pugilist && has_expert && is_pugilist_unarmed_skill && owner_build?.directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
		cap = max(cap, master_cap)

	var/cap_bonus = get_trait_cap_bonus(skill_type) + get_virtue_skill_cap_bonus(skill_type)
	if(cap_bonus > 0)
		var/bonus_cap = cap_bonus
		if(bonus_cap > base_cap && !has_training_unlock && !(has_hunter_cap_unlock && is_ranged_skill) && !(has_pugilist && is_pugilist_skill))
			bonus_cap = base_cap
		cap = max(cap, bonus_cap)

	cap = max(cap, get_virtue_skill_floor(skill_type))

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_magic_skill_cap(skill_type)
	var/cap = 0
	var/can_apply_cap_bonus = TRUE

	if(skill_type == /datum/skill/magic/arcane)
		if(owner_build?.has_trait(TAT_TRAIT_SPELLBLADE))
			cap = 3
			if(owner_build?.directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
				cap = SKILL_LEVEL_MASTER
		else
			var/magic_points = owner_build?.directions?.get_points(TAT_DIRECTION_MAGIC) || 0
			cap = magic_points
			if(owner_build?.has_trait(TRAIT_ARCYNE))
				cap = max(cap, 3)
			cap = min(cap, SKILL_LEVEL_EXPERT)
		can_apply_cap_bonus = FALSE

	else if(skill_type == /datum/skill/magic/holy)
		if(owner_build?.has_trait(TAT_TRAIT_DIVINE_INITIATE) || owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_1) || owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_2) || owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_3))
			cap = min(owner_build?.directions?.get_points(TAT_DIRECTION_MIRACLES) || 0, SKILL_LEVEL_EXPERT)
		can_apply_cap_bonus = FALSE

	else if(skill_type == /datum/skill/magic/druidic)
		if(owner_build?.has_trait(TAT_TRAIT_DRUID_INITIATE))
			cap = 2

	var/cap_bonus = get_trait_cap_bonus(skill_type) + get_virtue_skill_cap_bonus(skill_type)
	if(cap_bonus > 0 && can_apply_cap_bonus)
		if(cap > 0)
			cap += cap_bonus
		else
			cap = cap_bonus

	cap = max(cap, get_virtue_skill_floor(skill_type))

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_noncombat_skill_cap(skill_type)
	var/base_cap = get_base_noncombat_skill_cap(skill_type)
	var/cap = base_cap
	var/unlock_cap = max(get_trait_cap_bonus(skill_type), get_virtue_skill_cap_bonus(skill_type))
	if(unlock_cap > 0)
		cap = max(cap, unlock_cap)
	cap = max(cap, get_virtue_skill_floor(skill_type))

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

/datum/tat_skills/proc/get_selected_trait_domain_bonus(trait_id, domain)
	if(!owner_build?.traits?.has_trait(trait_id))
		return 0
	var/list/rules = GLOB.tat_trait_skill_point_rules
	var/list/domain_map = rules[trait_id]
	if(!islist(domain_map))
		return 0
	return round(domain_map[domain] || 0) * owner_build.traits.get_trait_count(trait_id)

/datum/tat_skills/proc/get_combat_step_spent_at_level(target_level, changed_skill_type = null, changed_invested_value = null)
	var/total = 0
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(!is_limited_combat_skill(skill_type))
			continue

		var/invested_value = get_invested_value(skill_type)
		if(skill_type == changed_skill_type)
			invested_value = max(0, round(changed_invested_value || 0))
		if(invested_value <= 0)
			continue

		for(var/step in 1 to invested_value)
			if(get_raw_total_value(skill_type, step - 1) >= target_level)
				continue
			if(get_raw_total_value(skill_type, step) < target_level)
				continue

			total += get_step_cost(skill_type, step)
			break

	return total

/datum/tat_skills/proc/combat_budget_is_valid(new_combat_spent = null, changed_skill_type = null, changed_invested_value = null)
	var/combat_spent = isnull(new_combat_spent) ? get_spent_points(TAT_SKILL_DOMAIN_COMBAT) : round(new_combat_spent)
	if(combat_spent > get_total_maximum(TAT_SKILL_DOMAIN_COMBAT))
		return FALSE

	var/expert_bonus = get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_EXPERT, TAT_SKILL_DOMAIN_COMBAT)
	var/master_bonus = get_selected_trait_domain_bonus(TAT_TRAIT_WARRIOR_MASTER, TAT_SKILL_DOMAIN_COMBAT)
	var/expert_spend = get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT, changed_skill_type, changed_invested_value)
	var/master_spend = get_combat_step_spent_at_level(TAT_SKILL_COMBAT_CAP_TRAIT_MASTER, changed_skill_type, changed_invested_value)
	var/restricted_covered = min(expert_bonus, expert_spend) + min(master_bonus, master_spend)
	var/unrestricted_pool = get_total_maximum(TAT_SKILL_DOMAIN_COMBAT) - expert_bonus - master_bonus
	var/unrestricted_spend = combat_spent - restricted_covered
	return unrestricted_spend <= unrestricted_pool

/datum/tat_skills/proc/domain_budget_is_valid(domain)
	domain = normalize_skill_domain(domain)
	if(!domain)
		return TRUE
	if(get_remaining_points(domain) < 0)
		return FALSE
	if(domain == TAT_SKILL_DOMAIN_COMBAT && !combat_budget_is_valid())
		return FALSE
	return TRUE

/datum/tat_skills/proc/get_any_negative_remaining()
	for(var/domain in domain_points)
		if(!domain_budget_is_valid(domain))
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
	if(!ignore_budget && domain == TAT_SKILL_DOMAIN_COMBAT && !combat_budget_is_valid(new_domain_spent, skill_type, value))
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
	sanitize_skill_domain_points()

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
		while(!domain_budget_is_valid(domain))
			var/changed = FALSE

			for(var/skill_type in invested.Copy())
				if(get_domain(skill_type) != domain)
					continue

				var/current = get_invested_value(skill_type)
				if(current <= 0)
					continue

				if(set_invested_value(skill_type, current - 1))
					changed = TRUE
					if(domain_budget_is_valid(domain))
						break

			if(!changed)
				break

	sanitize_skill_domain_points()
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
		"converted_role_points" = converted_role_points.Copy(),
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
	if(islist(data["converted_role_points"]))
		var/list/imported_role_conversions = data["converted_role_points"]
		for(var/domain in imported_role_conversions)
			var/normalized_domain = normalize_skill_domain(domain)
			if(can_convert_from_skill_domain(normalized_domain))
				converted_role_points[normalized_domain] = max(0, round(text2num("[imported_role_conversions[domain]]") || 0))
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
		"converted_role_points" = converted_role_points.Copy(),
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
	if(islist(data["converted_role_points"]))
		var/list/imported_role_conversions = data["converted_role_points"]
		for(var/domain in imported_role_conversions)
			var/normalized_domain = normalize_skill_domain(domain)
			if(can_convert_from_skill_domain(normalized_domain))
				converted_role_points[normalized_domain] = max(0, round(text2num("[imported_role_conversions[domain]]") || 0))
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
