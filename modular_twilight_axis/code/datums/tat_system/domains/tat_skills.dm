/datum/tat_skills
	var/datum/tat_build/owner_build
	var/list/invested = list()
	var/list/bonus = list()
	var/list/domain_points = list()

/datum/tat_skills/New(datum/tat_build/B)
	. = ..()
	owner_build = B
	reset()

/datum/tat_skills/proc/reset()
	invested = list()
	bonus = list()

	var/list/default_domain_points = TAT_DEFAULT_SKILL_DOMAIN_POINTS
	domain_points = default_domain_points.Copy()

	return TRUE

/datum/tat_skills/proc/get_domain(skill_type)
	return tat_get_skill_domain(skill_type)

/datum/tat_skills/proc/get_invested_value(skill_type)
	return round(invested[skill_type] || 0)

/datum/tat_skills/proc/get_bonus_value(skill_type)
	return round(bonus[skill_type] || 0)

/datum/tat_skills/proc/get_virtue_bonus_value(skill_type)
	var/total = 0
	var/list/virtues = owner_build?.get_active_virtues()
	var/list/rules = TAT_VIRTUE_SKILL_BONUS_RULES

	if(!islist(virtues) || !length(virtues))
		return 0

	for(var/virtue_entry in virtues)
		for(var/virtue_rule in rules)
			if(!(ispath(virtue_entry, virtue_rule) || istype(virtue_entry, virtue_rule) || virtue_entry == virtue_rule))
				continue

			var/list/skill_map = rules[virtue_rule]
			if(islist(skill_map))
				total += round(skill_map[skill_type] || 0)

	return total

/datum/tat_skills/proc/get_virtue_skill_cap_bonus(skill_type)
	return get_virtue_bonus_value(skill_type)

/datum/tat_skills/proc/rebuild_bonus_values()
	bonus = list()

	for(var/skill_type in TAT_SKILLS_ALL)
		var/value = owner_build ? owner_build.get_bonus_skill_value(skill_type) : 0
		if(value > 0)
			bonus[skill_type] = round(value)

	return TRUE

/datum/tat_skills/proc/check_skill(skill_type)
	return !!get_domain(skill_type)

/datum/tat_skills/proc/get_total_maximum(domain)
	return round((domain_points[domain] || 0) + (owner_build ? owner_build.get_bonus_skill_domain_points(domain) : 0))

/datum/tat_skills/proc/get_combat_expert_count()
	var/count = 0

	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue

		if(get_invested_value(skill_type) > TAT_SKILL_COMBAT_CAP_DEFAULT)
			count++

	return count

/datum/tat_skills/proc/get_combat_master_count()
	var/count = 0

	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue

		if(get_invested_value(skill_type) > TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT)
			count++

	return count

/datum/tat_skills/proc/get_trait_cap_bonus(skill_type)
	return owner_build ? owner_build.get_skill_cap_bonus_value(skill_type) : 0

/datum/tat_skills/proc/skill_has_trait_cap_rule(skill_type)
	var/list/rules = TAT_TRAIT_SKILL_CAP_BONUS_RULES

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
	else
		cap += get_trait_cap_bonus(skill_type)

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
	var/expert_count = get_combat_expert_count()
	var/master_count = get_combat_master_count()

	var/cap = base_cap

	if(has_expert)
		var/can_take_expert = FALSE

		if(current_invested > base_cap)
			can_take_expert = TRUE
		else if(expert_count < TAT_COMBAT_EXPERT_SKILL_LIMIT)
			can_take_expert = TRUE

		if(can_take_expert)
			cap = expert_cap

	if(has_master && cap >= expert_cap)
		var/can_take_master = FALSE

		if(current_invested > expert_cap)
			can_take_master = TRUE
		else if(master_count < TAT_COMBAT_MASTER_SKILL_LIMIT)
			can_take_master = TRUE

		if(can_take_master)
			cap = master_cap

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_magic_skill_cap(skill_type)
	var/cap = 0

	if(skill_type == /datum/skill/magic/arcane)
		if(owner_build?.has_trait(TAT_TRAIT_MAGE_MINOR_SLOT_2))
			cap = 6
		else if(owner_build?.has_trait(TAT_TRAIT_MAGE_MAJOR_SLOT))
			cap = 5
		else if(owner_build?.has_trait(TAT_TRAIT_MAGE_INITIATE))
			cap = 3

	else if(skill_type == /datum/skill/magic/holy)
		if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_3))
			cap = 6
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_2))
			cap = 5
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_BOON_1))
			cap = 3
		else if(owner_build?.has_trait(TAT_TRAIT_DIVINE_INITIATE))
			cap = 1

	else if(skill_type == /datum/skill/magic/druidic)
		if(owner_build?.has_trait(TAT_TRAIT_DRUID_INITIATE))
			cap = 3

	return clamp(cap, 0, TAT_SKILL_NONCOMBAT_CAP_ABSOLUTE)

/datum/tat_skills/proc/get_noncombat_skill_cap(skill_type)
	var/base_cap = TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM

	if(skill_has_trait_cap_rule(skill_type))
		base_cap = TAT_SKILL_NONCOMBAT_CAP_UNTRAITED

	var/trait_cap_bonus = get_trait_cap_bonus(skill_type)
	var/virtue_cap_bonus = get_virtue_skill_cap_bonus(skill_type)

	var/cap = base_cap + max(trait_cap_bonus, virtue_cap_bonus)
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
	return min(get_maximum(skill_type), get_invested_value(skill_type) + get_bonus_value(skill_type))

/datum/tat_skills/proc/get_step_cost(skill_type, target_level)
	if(target_level <= 0)
		return 0

	var/discount = owner_build ? owner_build.get_skill_cost_discount(skill_type, target_level) : 0
	return max(1, target_level - discount)

/datum/tat_skills/proc/get_total_cost_for_level(skill_type, level)
	var/total = 0

	for(var/i in 1 to level)
		total += get_step_cost(skill_type, i)

	return total

/datum/tat_skills/proc/get_spent_points(domain)
	var/total = 0

	for(var/skill_type in invested)
		if(get_domain(skill_type) != domain)
			continue

		total += get_total_cost_for_level(skill_type, get_invested_value(skill_type))

	return total

/datum/tat_skills/proc/get_remaining_points(domain)
	return get_total_maximum(domain) - get_spent_points(domain)

/datum/tat_skills/proc/get_any_negative_remaining()
	for(var/domain in domain_points)
		if(get_remaining_points(domain) < 0)
			return TRUE

	return FALSE

/datum/tat_skills/proc/set_invested_value(skill_type, value)
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

	var/old_cost = get_total_cost_for_level(skill_type, old_value)
	var/new_cost = get_total_cost_for_level(skill_type, value)

	var/current_domain_spent = get_spent_points(domain)
	var/new_domain_spent = current_domain_spent - old_cost + new_cost
	var/domain_max = get_total_maximum(domain)

	if(new_domain_spent > domain_max)
		return FALSE

	if(value <= 0)
		invested -= skill_type
	else
		invested[skill_type] = value

	owner_build?.set_dirty()
	return TRUE

/datum/tat_skills/proc/sanitize()
	rebuild_bonus_values()

	for(var/skill_type in invested.Copy())
		if(!check_skill(skill_type))
			invested -= skill_type
			continue

		var/current = get_invested_value(skill_type)
		set_invested_value(skill_type, current)

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
	)

/datum/tat_skills/proc/import_from_list(list/data)
	reset()

	if(!islist(data))
		return FALSE

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
	return list("invested" = exported_invested)

/datum/tat_skills/proc/import_from_json_list(list/data)
	reset()
	if(!islist(data))
		return FALSE

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
