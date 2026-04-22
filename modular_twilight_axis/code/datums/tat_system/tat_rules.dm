/// Rules/caps/costs/validation layer for TAT build.

/datum/tat_build/proc/get_effective_stat_points_total()
	var/total = points_stats
	if(traits[TAT_TRAIT_BONUS_STAT_POOL])
		total += TAT_BUILD_STAT_BONUS_EXTRA_STATS
	if(traits[TAT_TRAIT_WANTED])
		total += TAT_BUILD_STAT_BONUS_WANTED
	return total

/datum/tat_build/proc/get_effective_skill_points_total()
	var/total = points_skills
	if(traits[TRAIT_JACKOFALLTRADES])
		total += TRAIT_JACKOFALLTRADES_POINTS
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

	var/base_cost = isnum(entry["cost"]) ? entry["cost"] : 0
	var/final_cost = base_cost + get_trait_cost_modifier(trait_id)

	return final_cost

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
	var/refund_floor = get_stat_min(stat_id)

	value = clamp(value, get_stat_hard_min(stat_id), get_stat_max(stat_id))

	if(value > base)
		return (value - base) * cost

	var/effective_value = max(value, refund_floor)
	return (effective_value - base) * cost

/datum/tat_build/proc/get_total_stat_point_delta()
	var/total = 0
	for(var/stat_id in available_stats)
		total += get_stat_point_delta_for_value(stat_id, get_stat_value(stat_id))
	return total

/datum/tat_build/proc/get_remaining_stat_points()
	return get_effective_stat_points_total() - get_total_stat_point_delta()

/datum/tat_build/proc/get_skill_next_cost(skill_type)
	var/current = get_skill_value(skill_type)
	return get_skill_step_cost(skill_type, current + 1)

/datum/tat_build/proc/get_skill_step_cost(skill_type, target_level)
	if(!ispath(skill_type) || !isnum(target_level) || target_level <= 0)
		return 0

	var/discount = get_skill_discount_modifier(skill_type, target_level)
	return max(1, target_level - discount)

/datum/tat_build/proc/get_skill_total_cost_for_level(skill_type, level)
	if(!ispath(skill_type) || !isnum(level) || level <= 0)
		return 0

	var/total = 0
	for(var/i in 1 to level)
		total += get_skill_step_cost(skill_type, i)

	return total

/datum/tat_build/proc/get_spent_skill_points()
	var/total = 0
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(!isnum(level) || level <= 0)
			continue
		total += get_skill_total_cost_for_level(skill_type, level)
	return total

/datum/tat_build/proc/get_remaining_skill_points()
	return get_effective_skill_points_total() - get_spent_skill_points()

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

/datum/tat_build/proc/get_primary_advanced_combat_skill()
	var/primary_skill = null
	var/primary_level = TAT_SKILL_COMBAT_CAP_DEFAULT

	for(var/skill_type in skills)
		if(!ispath(skill_type, /datum/skill/combat))
			continue
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue

		var/level = round(skills[skill_type])
		if(level <= TAT_SKILL_COMBAT_CAP_DEFAULT)
			continue

		if(!primary_skill || level > primary_level || (level == primary_level && "[skill_type]" < "[primary_skill]"))
			primary_skill = skill_type
			primary_level = level

	return primary_skill

/datum/tat_build/proc/get_highest_advanced_combat_skill(excluded_skills = null)
	var/best_skill = null
	var/best_level = TAT_SKILL_COMBAT_CAP_DEFAULT

	for(var/skill_type in skills)
		if(!ispath(skill_type, /datum/skill/combat))
			continue
		if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
			continue

		if(islist(excluded_skills))
			if(skill_type in excluded_skills)
				continue
		else
			if(skill_type == excluded_skills)
				continue

		var/level = skills[skill_type]
		if(!isnum(level))
			continue
		if(level < best_level)
			continue

		if(level > best_level || !best_skill || "[skill_type]" < "[best_skill]")
			best_skill = skill_type
			best_level = level

	return best_skill

/datum/tat_build/proc/get_skill_cap(skill_type)
	if(skill_type == /datum/skill/magic/arcane)
		if(!can_train_arcane())
			return 0
		else
			return 4

	if(skill_type == /datum/skill/magic/holy)
		if(!can_train_holy())
			return 0

	if(ispath(skill_type, /datum/skill/combat) && !ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return get_combat_skill_cap(skill_type)

	if(should_softcap_peaceful_skill(skill_type) && !has_expert_trait_for_skill(skill_type))
		return 2

	if((skill_type == /datum/skill/combat/twilight_firearms) && !(has_expert_trait_for_skill(skill_type)))
		return 2

	return TAT_SKILL_NONCOMBAT_CAP

/datum/tat_build/proc/get_combat_skill_cap(skill_type)
	var/base_cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	var/expert_cap = TAT_SKILL_COMBAT_CAP_TRAIT_1
	var/master_cap = TAT_SKILL_COMBAT_CAP_TRAIT_2

	var/has_expert = !!traits[TAT_TRAIT_WARRIOR_EXPERT]
	var/has_master = !!traits[TAT_TRAIT_WARRIOR_MASTER]

	if(!has_expert && !has_master)
		return base_cap

	if(!ispath(skill_type, /datum/skill/combat))
		return base_cap

	if(ispath(skill_type, /datum/skill/combat/twilight_firearms))
		return base_cap

	var/current_level = skills[skill_type]
	if(!isnum(current_level))
		current_level = 0

	var/advanced_count = 0
	var/mastered_count = 0

	for(var/other_skill in skills)
		if(!ispath(other_skill, /datum/skill/combat))
			continue
		if(ispath(other_skill, /datum/skill/combat/twilight_firearms))
			continue

		var/other_level = skills[other_skill]
		if(!isnum(other_level))
			continue

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
		if(TAT_SUPPLY_ARTIFACTS)
			return !!traits[TAT_TRAIT_ARTIFACTS_SUPPLIER]
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

/datum/tat_build/proc/get_effective_divine_tier()
	var/tier = CLERIC_T0
	if(traits[TAT_TRAIT_DIVINE_BOON_1])
		tier++
	if(traits[TAT_TRAIT_DIVINE_BOON_2])
		tier++
	if(traits[TAT_TRAIT_DIVINE_BOON_3])
		tier++
	return clamp(tier, CLERIC_T0, CLERIC_T4)

/datum/tat_build/proc/get_divine_passive_gain_for_tier(cleric_tier)
	if(cleric_tier >= CLERIC_T1)
		return CLERIC_REGEN_MINOR
	return CLERIC_REGEN_WITCH

/datum/tat_build/proc/get_divine_devotion_limit_for_tier(cleric_tier)
	switch(cleric_tier)
		if(CLERIC_T4)
			return CLERIC_REQ_4
		if(CLERIC_T3)
			return CLERIC_REQ_3
		if(CLERIC_T2)
			return CLERIC_REQ_2
	return CLERIC_REQ_1

/datum/tat_build/proc/build_mage_aspects(scale_with_arcane = TRUE)
	var/major = 0
	var/minor = 1
	var/utilities = 3
	if(traits[TAT_TRAIT_MAGE_MAJOR_SLOT])
		major += 1
	if(traits[TAT_TRAIT_MAGE_MINOR_SLOT_1])
		minor += 1
	if(traits[TAT_TRAIT_MAGE_MINOR_SLOT_2])
		minor += 1
	if(traits[TAT_TRAIT_MAGE_UTILITY_SLOT])
		utilities += 1
	if(scale_with_arcane)
		utilities += get_skill_value(/datum/skill/magic/arcane)
	return list(
		"mastery" = FALSE,
		"major" = major,
		"minor" = minor,
		"utilities" = utilities,
		"ward" = TRUE,
	)

/datum/tat_build/proc/get_trait_conflict_map()
	var/list/conflicts = list(
		TAT_TRAIT_RESIDENT = list(
			TRAIT_OUTLANDER,
			TAT_TRAIT_WANTED,
			TAT_TRAIT_BONUS_STAT_POOL,
		),
		TAT_TRAIT_BONUS_STAT_POOL = list(
			TAT_TRAIT_WANTED,
		),
		TRAIT_DODGEEXPERT = list(
			TRAIT_PARRYEXPERT,
			TAT_TRAIT_MAGE_MINOR_SLOT_2,
			TAT_TRAIT_MAGE_MAJOR_SLOT,
		),
		TRAIT_HEAVYARMOR = list(
			TRAIT_CRITICAL_RESISTANCE,
			TAT_TRAIT_MAGE_INITIATE,
		),
		TRAIT_MEDIUMARMOR = list(
			TRAIT_CRITICAL_RESISTANCE,
			TAT_TRAIT_MAGE_INITIATE,
		),
		TAT_TRAIT_TROPHY_BOUNTY = list(
			TAT_TRAIT_RONIN,
			TAT_TRAIT_SOUNDBREAKER,
			TAT_TRAIT_SPELLBLADE,
		),
		TAT_TRAIT_SOUNDBREAKER = list(
			TAT_TRAIT_RONIN,
			TAT_TRAIT_SPELLBLADE,
		),
		TAT_TRAIT_SPELLBLADE = list(
			TAT_TRAIT_RONIN,
			TAT_TRAIT_DIVINE_BOON_3,
		),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list(
			TAT_TRAIT_SOUNDBREAKER,
			TAT_TRAIT_SPELLBLADE,
			TAT_TRAIT_RONIN,
			TAT_TRAIT_DIVINE_BOON_3,
		),
		TAT_TRAIT_MAGE_MAJOR_SLOT = list(
			TAT_TRAIT_DIVINE_BOON_3,
		),
		TAT_TRAIT_DRUID_INITIATE = list(
			TAT_TRAIT_MAGE_INITIATE,
			TAT_TRAIT_DIVINE_INITIATE,
		),
		TRAIT_CRITICAL_RESISTANCE = list(
			TAT_TRAIT_MAGE_INITIATE,
			TAT_TRAIT_DIVINE_INITIATE,
		),
		TAT_TRAIT_WARRIOR_EXPERT = list(
			TAT_TRAIT_DIVINE_BOON_2,
			TAT_TRAIT_MAGE_MINOR_SLOT_2,
			TAT_TRAIT_MAGE_MAJOR_SLOT,
		),
	)

	return conflicts

/datum/tat_build/proc/get_trait_requirement_map()
	var/list/requirements = list(
		TAT_TRAIT_WARRIOR_MASTER = list(
			"all" = list(TAT_TRAIT_WARRIOR_EXPERT),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_MASTER)]\" requires \"[get_trait_display_name(TAT_TRAIT_WARRIOR_EXPERT)]\".",
		),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list(
			"all" = list(TAT_TRAIT_BARDIC_INSPIRATION_T1),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T2)]\" requires \"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T1)]\".",
		),
		TAT_TRAIT_DIVINE_BOON_1 = list(
			"all" = list(TAT_TRAIT_DIVINE_INITIATE),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_1)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_INITIATE)]\".",
		),
		TAT_TRAIT_DIVINE_BOON_2 = list(
			"all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_2)]\" requires previous divine progression.",
		),
		TAT_TRAIT_DIVINE_BOON_3 = list(
			"all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_2),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\" requires previous divine progression.",
		),
		TAT_TRAIT_MAGE_INITIATE = list(
			"all" = list(TRAIT_ARCYNE),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\" requires \"[get_trait_display_name(TRAIT_ARCYNE)]\".",
		),
		TAT_TRAIT_SPELLBLADE = list(
			"all" = list(TAT_TRAIT_MAGE_INITIATE, TRAIT_ARCYNE),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_SPELLBLADE)]\" requires mage initiation and arcyne.",
		),
		TAT_TRAIT_MAGE_MINOR_SLOT_2 = list(
			"all" = list(TAT_TRAIT_MAGE_MINOR_SLOT_1),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_2)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_1)]\".",
		),
		TAT_TRAIT_ARTIFACTS_SUPPLIER = list(
			"all" = list(TAT_TRAIT_PARTY_LEADER),
			"message" = "\"[get_trait_display_name(TAT_TRAIT_ARTIFACTS_SUPPLIER)]\" requires \"[get_trait_display_name(TAT_TRAIT_PARTY_LEADER)]\".",
		),
	)

	return requirements

/datum/tat_build/proc/get_skill_rule(skill_type)
	var/list/skill_rules = list(
		/datum/skill/craft/cooking = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_HOMESTEAD_EXPERT,
		),
		/datum/skill/craft/alchemy = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_ALCHEMY_EXPERT,
		),
		/datum/skill/misc/medicine = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_MEDICINE_EXPERT,
		),
		/datum/skill/craft/sewing = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SEWING_EXPERT,
		),
		/datum/skill/labor/farming = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SEEDKNOW,
		),
		/datum/skill/craft/blacksmithing = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SMITHING_EXPERT,
		),
		/datum/skill/craft/smelting = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SMITHING_EXPERT,
		),
		/datum/skill/craft/carpentry = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_HOMESTEAD_EXPERT,
		),
		/datum/skill/craft/masonry = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_HOMESTEAD_EXPERT,
		),
		/datum/skill/craft/crafting = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_HOMESTEAD_EXPERT,
		),
		/datum/skill/labor/butchering = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SURVIVAL_EXPERT,
		),
		/datum/skill/craft/traps = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SURVIVAL_EXPERT,
		),
		/datum/skill/labor/fishing = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_CAUTIOUS_FISHER,
		),
		/datum/skill/craft/armorsmithing = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SQUIRE_REPAIR,
		),
		/datum/skill/craft/weaponsmithing = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_SQUIRE_REPAIR,
		),
		/datum/skill/combat/twilight_firearms = list(
			"softcap" = TRUE,
			"expert_trait" = TRAIT_FIREARMS_MARKSMAN,
		),
	)

	return skill_rules[skill_type]

/datum/tat_build/proc/trait_requirement_is_met(list/rule)
	if(!islist(rule))
		return TRUE

	var/list/all_requirements = rule["all"]
	if(islist(all_requirements))
		for(var/required_trait in all_requirements)
			if(!traits[required_trait])
				return FALSE

	return TRUE

/datum/tat_build/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if(!trait_a || !trait_b || trait_a == trait_b)
		return null

	var/list/conflicts = get_trait_conflict_map()

	var/list/a_conflicts = conflicts[trait_a]
	if(islist(a_conflicts) && (trait_b in a_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."

	var/list/b_conflicts = conflicts[trait_b]
	if(islist(b_conflicts) && (trait_a in b_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."

	if((trait_a == TAT_TRAIT_WARRIOR_MASTER || trait_b == TAT_TRAIT_WARRIOR_MASTER) && has_defensive_trait_lockout())
		return "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_MASTER)]\" conflicts with current defensive trait setup."

	return null

/datum/tat_build/proc/has_defensive_trait_lockout()
	if(traits[TRAIT_DODGEEXPERT])
		return TRUE
	if(traits[TRAIT_PARRYEXPERT])
		return TRUE
	if(traits[TRAIT_CRITICAL_RESISTANCE])
		return TRUE
	if(traits[TRAIT_MEDIUMARMOR])
		return TRUE
	if(traits[TRAIT_HEAVYARMOR])
		return TRUE
	return FALSE

/datum/tat_build/proc/has_invalid_trait_dependencies()
	var/list/issues = list()
	var/list/requirements = get_trait_requirement_map()

	for(var/trait_id in requirements)
		if(!traits[trait_id])
			continue

		var/list/rule = requirements[trait_id]
		if(trait_requirement_is_met(rule))
			continue

		var/message = rule["message"]
		if(message)
			issues += message
		else
			issues += "\"[get_trait_display_name(trait_id)]\" has unmet requirements."

	if((traits[TAT_TRAIT_MAGE_MAJOR_SLOT] || traits[TAT_TRAIT_MAGE_MINOR_SLOT_1] || traits[TAT_TRAIT_MAGE_UTILITY_SLOT]) && !traits[TAT_TRAIT_MAGE_INITIATE])
		issues += "Mage spell slots require \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."

	for(var/trait_a in traits)
		for(var/trait_b in traits)
			if(trait_a == trait_b)
				continue
			if("[trait_a]" >= "[trait_b]")
				continue

			var/reason = are_traits_mutually_exclusive(trait_a, trait_b)
			if(reason)
				issues += reason

	return issues

/datum/tat_build/proc/has_invalid_supply_items()
	var/list/issues = list()

	for(var/item_path in items)
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			issues += "\"[item_path]\" is missing from item definitions."
			continue

		if(!can_use_item_entry(entry))
			issues += "\"[entry["name"]]\" is no longer unlocked by current traits."

	return issues

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

/datum/tat_build/proc/can_train_arcane()
	return !!traits[TRAIT_ARCYNE]

/datum/tat_build/proc/can_train_holy()
	return !!traits[TAT_TRAIT_DIVINE_INITIATE]

/datum/tat_build/proc/has_expert_trait_for_skill(skill_type)
	var/list/rule = get_skill_rule(skill_type)
	if(!islist(rule))
		return TRUE

	var/expert_trait = rule["expert_trait"]
	if(!expert_trait)
		return TRUE

	return !!traits[expert_trait]

/datum/tat_build/proc/should_softcap_peaceful_skill(skill_type)
	var/list/rule = get_skill_rule(skill_type)
	if(!islist(rule))
		return FALSE

	return !!rule["softcap"]

/datum/tat_build/proc/is_item_slot_limited(list/entry)
	if(!islist(entry))
		return FALSE
	var/category = lowertext("[entry["category"]]")
	if(category == "weapon")
		return FALSE
	var/slot_group = lowertext("[entry["slot_group"]]")
	if(slot_group == "misc")
		return FALSE
	return TRUE

/datum/tat_build/proc/get_slot_group_item_count(slot_group, category, exclude_item_path = null)
	if(!slot_group)
		return 0
	var/target_slot_group = lowertext("[slot_group]")
	var/target_category = lowertext("[category]")
	var/total = 0
	for(var/item_path in items)
		if(!ispath(item_path))
			continue
		if(!isnull(exclude_item_path) && item_path == exclude_item_path)
			continue
		var/list/entry = get_item_entry(item_path)
		if(!islist(entry))
			continue
		var/entry_slot_group = lowertext("[entry["slot_group"]]")
		var/entry_category = lowertext("[entry["category"]]")
		if(entry_slot_group != target_slot_group)
			continue
		if(entry_category != target_category)
			continue
		var/amount = items[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		total += amount
	return total

/datum/tat_build/proc/get_max_amount_for_item(path)
	var/total_allowed = get_item_total_allowed_amount(path)
	if(total_allowed <= 0)
		return 0

	var/already_taken = items[path]
	if(!isnum(already_taken))
		already_taken = 0

	return max(0, total_allowed - already_taken)

/datum/tat_build/proc/get_stat_hard_min(stat_id)
	return 1

/datum/tat_build/proc/has_mind_spell(mob/living/carbon/human/H, spell_type)
	if(!H || !H.mind || !ispath(spell_type))
		return FALSE

	if(islist(H.mind.spell_list))
		for(var/datum/existing_spell as anything in H.mind.spell_list)
			if(istype(existing_spell, spell_type))
				return TRUE

	if(islist(H.actions))
		for(var/datum/action/existing_action as anything in H.actions)
			if(istype(existing_action, spell_type))
				return TRUE

	return FALSE

/datum/tat_build/proc/grant_mind_spell_if_missing(mob/living/carbon/human/H, spell_type)
	if(!H || !H.mind || !ispath(spell_type))
		return FALSE
	if(has_mind_spell(H, spell_type))
		return FALSE

	H.mind.AddSpell(new spell_type)
	return TRUE

/datum/tat_build/proc/get_resident_skill_value(skill_type)
	if(!ispath(skill_type))
		return 0
	return get_skill_value(skill_type)

/datum/tat_build/proc/get_resident_pugilist_spell_choice(mob/living/carbon/human/H)
	var/list/choices = list(
		"Dropkick - Pushback + Extra Damage",
		"Chokeslam - Stamina Damage",
		"Stunner - Dazed Debuff",
		"Headbutt - Vulnerable Debuff",
	)

	if(H?.client)
		var/choice = tgui_input_list(H, "Choose your resident pugilist technique.", "Resident Technique", choices)
		if(choice in choices)
			return choice

	return TAT_RESIDENT_PUGILIST_DEFAULT

/datum/tat_build/proc/get_resident_pugilist_spell_type(choice)
	switch(choice)
		if("Dropkick - Pushback + Extra Damage")
			return /obj/effect/proc_holder/spell/invoked/dropkick
		if("Chokeslam - Stamina Damage")
			return /obj/effect/proc_holder/spell/invoked/chokeslam
		if("Stunner - Dazed Debuff")
			return /obj/effect/proc_holder/spell/invoked/stunner
		if("Headbutt - Vulnerable Debuff")
			return /obj/effect/proc_holder/spell/invoked/headbutt
	return /obj/effect/proc_holder/spell/invoked/dropkick

/datum/tat_build/proc/get_trait_cost_modifier(trait_id)
	switch(trait_id)
		if(TAT_TRAIT_MAIL_SUPPLIER)
			if(traits[TRAIT_MEDIUMARMOR])
				return -TAT_TRAIT_DISCOUNT

		if(TAT_TRAIT_PLATE_SUPPLIER)
			if(traits[TRAIT_HEAVYARMOR] || traits[TRAIT_MEDIUMARMOR])
				return -TAT_TRAIT_DISCOUNT

	return 0

/datum/tat_build/proc/get_validation_issues()
	var/list/issues = list()

	if(get_remaining_stat_points() < 0)
		issues += "Spent too many stat points."
	if(get_remaining_skill_points() < 0)
		issues += "Spent too many skill points."
	if(get_remaining_trait_points() < 0)
		issues += "Spent too many trait points."
	if(get_remaining_item_points() < 0)
		issues += "Spent too many item points."

	var/list/trait_issues = has_invalid_trait_dependencies()
	if(length(trait_issues))
		issues += trait_issues

	var/list/item_issues = has_invalid_supply_items()
	if(length(item_issues))
		issues += item_issues

	return issues

/datum/tat_build/proc/is_allowed_post_tat_virtue(virtue_type)
	if(!virtue_type)
		return FALSE

	var/list/allowed_post_tat_virtues = list(
		/datum/virtue/combat/bowman,
		/datum/virtue/combat/crossbowman,
	)

	for(var/allowed_type in allowed_post_tat_virtues)
		if(ispath(virtue_type, allowed_type) || istype(virtue_type, allowed_type))
			return TRUE

	return FALSE

/datum/tat_build/proc/get_skill_discount_modifier(skill_type, target_level)
	if(!ispath(skill_type, /datum/skill))
		return 0

	if(!isnum(target_level) || target_level <= 0)
		return 0

	if(traits[TAT_TRAIT_RESIDENT] && (ispath(skill_type, /datum/skill/misc) || ispath(skill_type, /datum/skill/labor) || ispath(skill_type, /datum/skill/craft)))
		return 1

	var/list/trait_skill_discounts = list(
		TAT_TRAIT_TRAINEE_SMITH = list(
			/datum/skill/craft/blacksmithing,
			/datum/skill/craft/smelting,
			/datum/skill/combat/maces,
		),
		TAT_TRAIT_TRAINEE_ARMORER = list(
			/datum/skill/craft/armorsmithing,
			/datum/skill/craft/masonry,
			/datum/skill/combat/shields,
		),
		TAT_TRAIT_TRAINEE_WEAPONSMITH = list(
			/datum/skill/craft/weaponsmithing,
			/datum/skill/craft/engineering,
			/datum/skill/combat/swords,
		),
		TAT_TRAIT_TRAINEE_WOODSMAN = list(
			/datum/skill/labor/lumberjacking,
			/datum/skill/craft/carpentry,
			/datum/skill/combat/axes,
		),
		TAT_TRAIT_TRAINEE_SURVIVALIST = list(
			/datum/skill/labor/butchering,
			/datum/skill/craft/traps,
			/datum/skill/combat/bows,
		),
		TAT_TRAIT_TRAINEE_POACHER = list(
			/datum/skill/misc/tracking,
			/datum/skill/craft/traps,
			/datum/skill/combat/crossbows,
		),
		TAT_TRAIT_TRAINEE_SKULKER = list(
			/datum/skill/misc/sneaking,
			/datum/skill/misc/lockpicking,
			/datum/skill/combat/knives,
		),
		TAT_TRAIT_TRAINEE_VAGABOND = list(
			/datum/skill/misc/stealing,
			/datum/skill/misc/climbing,
			/datum/skill/combat/slings,
		),
		TAT_TRAIT_TRAINEE_RIDER = list(
			/datum/skill/misc/riding,
			/datum/skill/misc/athletics,
			/datum/skill/combat/polearms,
		),
		TAT_TRAIT_TRAINEE_MARINER = list(
			/datum/skill/misc/swimming,
			/datum/skill/labor/fishing,
			/datum/skill/combat/staves,
		),
		TAT_TRAIT_TRAINEE_CLOTHIER = list(
			/datum/skill/craft/sewing,
			/datum/skill/craft/tanning,
			/datum/skill/combat/whipsflails,
		),
		TAT_TRAIT_TRAINEE_HOMESTEADER = list(
			/datum/skill/labor/farming,
			/datum/skill/craft/cooking,
			/datum/skill/combat/wrestling,
		),
		TAT_TRAIT_TRAINEE_ARTISAN = list(
			/datum/skill/craft/crafting,
			/datum/skill/craft/ceramics,
			/datum/skill/combat/unarmed,
		),
		TAT_TRAIT_TRAINEE_CHIRURGEON = list(
			/datum/skill/misc/medicine,
			/datum/skill/misc/reading,
			/datum/skill/combat/staves,
		),
		TAT_TRAIT_TRAINEE_TROUBADOUR = list(
			/datum/skill/misc/music,
			/datum/skill/misc/reading,
			/datum/skill/combat/knives,
		),
	)

	for(var/trait_id in trait_skill_discounts)
		if(!traits[trait_id])
			continue

		var/list/discounted_skills = trait_skill_discounts[trait_id]
		if(!(skill_type in discounted_skills))
			continue

		if(ispath(skill_type, /datum/skill/combat))
			return (target_level <= 2) ? 1 : 0

		return 1

	return 0

/datum/tat_build/proc/get_item_total_allowed_amount(path)
	var/list/entry = get_item_entry(path)
	if(!islist(entry))
		return 0

	var/category = lowertext("[entry["category"]]")
	var/cost = get_item_cost(path)

	if(cost <= 0 && (category == "misc" || category == "weapon"))
		return 1

	if(!is_item_slot_limited(entry))
		return INFINITY

	var/slot_group = entry["slot_group"]
	if(!slot_group)
		return INFINITY

	return 1
