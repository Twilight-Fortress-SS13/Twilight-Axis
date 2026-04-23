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

/datum/tat_skills/proc/get_skill_rule(skill_type)
	var/list/skill_rules = list(
		/datum/skill/craft/cooking = list("softcap" = TRUE, "expert_trait" = TRAIT_HOMESTEAD_EXPERT),
		/datum/skill/craft/alchemy = list("softcap" = TRUE, "expert_trait" = TRAIT_ALCHEMY_EXPERT),
		/datum/skill/misc/medicine = list("softcap" = TRUE, "expert_trait" = TRAIT_MEDICINE_EXPERT),
		/datum/skill/craft/sewing = list("softcap" = TRUE, "expert_trait" = TRAIT_SEWING_EXPERT),
		/datum/skill/labor/farming = list("softcap" = TRUE, "expert_trait" = TRAIT_SEEDKNOW),
		/datum/skill/craft/blacksmithing = list("softcap" = TRUE, "expert_trait" = TRAIT_SMITHING_EXPERT),
		/datum/skill/craft/smelting = list("softcap" = TRUE, "expert_trait" = TRAIT_SMITHING_EXPERT),
		/datum/skill/craft/carpentry = list("softcap" = TRUE, "expert_trait" = TRAIT_HOMESTEAD_EXPERT),
		/datum/skill/craft/masonry = list("softcap" = TRUE, "expert_trait" = TRAIT_HOMESTEAD_EXPERT),
		/datum/skill/craft/crafting = list("softcap" = TRUE, "expert_trait" = TRAIT_HOMESTEAD_EXPERT),
		/datum/skill/labor/butchering = list("softcap" = TRUE, "expert_trait" = TRAIT_SURVIVAL_EXPERT),
		/datum/skill/craft/traps = list("softcap" = TRUE, "expert_trait" = TRAIT_SURVIVAL_EXPERT),
		/datum/skill/labor/fishing = list("softcap" = TRUE, "expert_trait" = TRAIT_CAUTIOUS_FISHER),
		/datum/skill/craft/armorsmithing = list("softcap" = TRUE, "expert_trait" = TRAIT_SQUIRE_REPAIR),
		/datum/skill/craft/weaponsmithing = list("softcap" = TRUE, "expert_trait" = TRAIT_SQUIRE_REPAIR),
		/datum/skill/combat/twilight_firearms = list("softcap" = TRUE, "expert_trait" = TRAIT_FIREARMS_MARKSMAN),
	)
	return skill_rules[skill_type]

/datum/tat_skills/proc/has_expert_trait_for_skill(skill_type)
	var/list/rule = get_skill_rule(skill_type)
	if(!islist(rule))
		return TRUE
	var/expert_trait = rule["expert_trait"]
	if(!expert_trait)
		return TRUE
	return !!owner_build?.has_trait(expert_trait)

/datum/tat_skills/proc/should_softcap_peaceful_skill(skill_type)
	var/list/rule = get_skill_rule(skill_type)
	if(!islist(rule))
		return FALSE
	return !!rule["softcap"]

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

/datum/tat_skills/proc/rebuild_bonus_values()
	bonus = list()
	for(var/skill_type in TAT_SKILLS_ALL)
		var/value = owner_build ? owner_build.get_bonus_skill_value(skill_type) : 0
		if(value > 0)
			bonus[skill_type] = round(value)
	return TRUE

/datum/tat_skills/proc/get_total_value(skill_type)
	return get_invested_value(skill_type) + get_bonus_value(skill_type)

/datum/tat_skills/proc/check_skill(skill_type)
	return !!get_domain(skill_type)

/datum/tat_skills/proc/get_total_maximum(domain)
	return round((domain_points[domain] || 0) + (owner_build ? owner_build.get_bonus_skill_domain_points(domain) : 0))

/datum/tat_skills/proc/get_primary_advanced_combat_skill()
	var/primary_skill = null
	var/primary_level = TAT_SKILL_COMBAT_CAP_DEFAULT
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue
		var/level = round(get_total_value(skill_type))
		if(level <= TAT_SKILL_COMBAT_CAP_DEFAULT)
			continue
		if(!primary_skill || level > primary_level || (level == primary_level && "[skill_type]" < "[primary_skill]"))
			primary_skill = skill_type
			primary_level = level
	return primary_skill

/datum/tat_skills/proc/get_highest_advanced_combat_skill(excluded_skills = null)
	var/best_skill = null
	var/best_level = TAT_SKILL_COMBAT_CAP_DEFAULT
	for(var/skill_type in TAT_SKILLS_COMBAT)
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue
		if(islist(excluded_skills))
			if(skill_type in excluded_skills)
				continue
		else if(skill_type == excluded_skills)
			continue
		var/level = get_total_value(skill_type)
		if(level < best_level)
			continue
		if(level > best_level || !best_skill || "[skill_type]" < "[best_skill]")
			best_skill = skill_type
			best_level = level
	return best_skill

/datum/tat_skills/proc/get_combat_skill_cap(skill_type)
	var/base_cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	var/expert_cap = TAT_SKILL_COMBAT_CAP_TRAIT_EXPERT
	var/master_cap = TAT_SKILL_COMBAT_CAP_TRAIT_MASTER

	var/has_expert = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_EXPERT)
	var/has_master = !!owner_build?.has_trait(TAT_TRAIT_WARRIOR_MASTER)

	if(!has_expert && !has_master)
		return base_cap
	if(!ispath(skill_type, /datum/skill/combat))
		return base_cap
	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return 2

	var/current_level = get_total_value(skill_type)
	var/advanced_count = 0
	var/mastered_count = 0

	for(var/other_skill in TAT_SKILLS_COMBAT)
		if(ispath(other_skill, /datum/skill/combat/twilight_firearms))
			continue

		var/other_level = get_total_value(other_skill)
		if(other_level > base_cap)
			advanced_count++
		if(other_level > expert_cap)
			mastered_count++

	var/can_be_expert = FALSE
	if(current_level > base_cap)
		can_be_expert = TRUE
	else if(advanced_count < 2)
		can_be_expert = TRUE

	if(!can_be_expert)
		return base_cap
	if(!has_master)
		return expert_cap
	if(current_level > expert_cap)
		return master_cap
	if(current_level >= expert_cap && mastered_count <= 0)
		return master_cap

	return expert_cap

/datum/tat_skills/proc/get_invested_maximum(skill_type)
	var/domain = get_domain(skill_type)
	if(!domain)
		return 0

	if(skill_type == /datum/skill/magic/arcane)
		if(!owner_build?.can_train_arcane())
			return 0
		return TAT_SKILL_NONCOMBAT_CAP_SPECTRAIT

	if(skill_type == /datum/skill/magic/holy)
		if(!owner_build?.can_train_holy())
			return 0

	if(skill_type == /datum/skill/combat/twilight_firearms)
		if(has_expert_trait_for_skill(skill_type))
			return 4
		return 2

	if(ispath(skill_type, /datum/skill/combat))
		return get_combat_skill_cap(skill_type)

	if(should_softcap_peaceful_skill(skill_type) && !has_expert_trait_for_skill(skill_type))
		return TAT_SKILL_NONCOMBAT_CAP_UNTRAITED

	return TAT_SKILL_NONCOMBAT_CAP_BASIC_SYSTEM

/datum/tat_skills/proc/get_maximum(skill_type)
	return get_invested_maximum(skill_type) + get_bonus_value(skill_type)

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

	if(islist(data["invested"]))
		for(var/skill_type in data["invested"])
			set_invested_value(skill_type, data["invested"][skill_type])

	rebuild_bonus_values()
	return TRUE
