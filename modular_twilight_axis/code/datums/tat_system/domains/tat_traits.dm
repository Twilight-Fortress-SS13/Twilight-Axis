/mob/living/carbon/human
	var/tat_pliant_title
	var/tat_handles_preference_loadout = FALSE

/datum/tat_traits
	var/datum/tat_build/owner_build
	var/list/selected = list()
	var/base_points = 100

/datum/tat_traits/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/tat_traits/proc/reset()
	selected = list()
	return TRUE

/datum/tat_traits/proc/get_entry(trait_id)
	return GLOB.tat_available_traits[trait_id]

/datum/tat_traits/proc/get_trait_count(trait_id)
	var/value = selected[trait_id]
	if(isnum(value))
		return max(0, round(value))
	return value ? 1 : 0

/datum/tat_traits/proc/has_trait(trait_id)
	return get_trait_count(trait_id) > 0

/datum/tat_traits/proc/get_external_traits()
	var/list/result = list()
	var/list/virtues = owner_build?.get_active_virtues()
	if(!length(virtues))
		return result

	for(var/virtue_entry in virtues)
		if(!istype(virtue_entry, /datum/virtue))
			continue

		var/datum/virtue/virtue = virtue_entry
		if(!("added_traits" in virtue.vars))
			continue

		var/list/added_traits = virtue.vars["added_traits"]
		if(!islist(added_traits))
			continue

		for(var/trait_id in added_traits)
			if(!check_trait(trait_id))
				continue
			result[trait_id] = TRUE

	return result

/datum/tat_traits/proc/get_external_trait_count(trait_id)
	var/list/external_traits = get_external_traits()
	return external_traits[trait_id] ? 1 : 0

/datum/tat_traits/proc/has_external_trait(trait_id)
	return get_external_trait_count(trait_id) > 0

/datum/tat_traits/proc/get_effective_trait_count(trait_id)
	return max(get_trait_count(trait_id), get_external_trait_count(trait_id))

/datum/tat_traits/proc/has_effective_trait(trait_id)
	return get_effective_trait_count(trait_id) > 0

/datum/tat_traits/proc/get_effective_trait_counts()
	var/list/result = list()

	for(var/trait_id in selected)
		var/count = get_trait_count(trait_id)
		if(count > 0)
			result[trait_id] = count

	var/list/external_traits = get_external_traits()
	for(var/trait_id in external_traits)
		result[trait_id] = max(round(result[trait_id] || 0), 1)

	return result

/datum/tat_traits/proc/is_repeatable_trait(trait_id)
	var/list/repeatables = TAT_TRAIT_REPEATABLE_MAXIMUMS
	return !!repeatables[trait_id]

/datum/tat_traits/proc/get_trait_maximum(trait_id)
	if(!is_repeatable_trait(trait_id))
		return 1
	var/list/repeatables = TAT_TRAIT_REPEATABLE_MAXIMUMS
	return max(1, round(repeatables[trait_id] || 1))

/datum/tat_traits/proc/get_trait_display_name(trait_id)
	var/list/entry = get_entry(trait_id)
	if(!islist(entry))
		return "[trait_id]"
	return "[entry["name"]]"

/datum/tat_traits/proc/get_total_maximum()
	return base_points

/datum/tat_traits/proc/get_base_cost(trait_id)
	var/list/entry = get_entry(trait_id)
	if(!islist(entry))
		return 0
	return round((isnum(entry["cost"]) ? entry["cost"] : 0))

/datum/tat_traits/proc/is_armor_supplier_trait(trait_id)
	return trait_id in GLOB.tat_armor_supplier_traits

/datum/tat_traits/proc/is_material_supplier_trait(trait_id)
	return trait_id in GLOB.tat_material_supplier_traits

/datum/tat_traits/proc/get_first_selected_supplier_trait(list/supplier_traits)
	if(!islist(supplier_traits))
		return null

	for(var/selected_trait_id in selected)
		if(!(selected_trait_id in supplier_traits))
			continue
		if(get_trait_count(selected_trait_id) <= 0)
			continue
		return selected_trait_id

	return null

/datum/tat_traits/proc/get_supplier_cross_discount(trait_id, list/supplier_traits, discount)
	if(!(trait_id in supplier_traits))
		return 0

	var/first_selected_trait_id = get_first_selected_supplier_trait(supplier_traits)
	if(!first_selected_trait_id || first_selected_trait_id == trait_id)
		return 0

	return discount

/datum/tat_traits/proc/get_armor_supplier_cross_discount(trait_id)
	return get_supplier_cross_discount(trait_id, GLOB.tat_armor_supplier_traits, TAT_ARMOR_SUPPLIER_CROSS_DISCOUNT)

/datum/tat_traits/proc/get_material_supplier_cross_discount(trait_id)
	return get_supplier_cross_discount(trait_id, GLOB.tat_material_supplier_traits, TAT_MATERIAL_SUPPLIER_CROSS_DISCOUNT)

/datum/tat_traits/proc/get_armor_training_supplier_discount(trait_id)
	if(!is_armor_supplier_trait(trait_id))
		return 0

	var/list/rules = GLOB.tat_trait_armor_training_supplier_discount_rules
	for(var/training_trait_id in selected)
		if(rules[training_trait_id] != trait_id)
			continue
		if(get_trait_count(training_trait_id) <= 0)
			continue
		return TAT_ARMOR_TRAINING_SUPPLIER_DISCOUNT

	return 0

/datum/tat_traits/proc/get_cost_modifier(trait_id)
	var/modifier = 0
	modifier -= get_armor_supplier_cross_discount(trait_id)
	modifier -= get_material_supplier_cross_discount(trait_id)
	modifier -= get_armor_training_supplier_discount(trait_id)
	modifier -= get_outlander_natural_potential_discount(trait_id)
	return modifier

/datum/tat_traits/proc/get_display_cost(trait_id)
	var/cost = get_base_cost(trait_id) + get_cost_modifier(trait_id)
	if(is_armor_supplier_trait(trait_id) || is_material_supplier_trait(trait_id))
		return max(0, cost)
	return cost

/datum/tat_traits/proc/check_trait(trait_id)
	return islist(get_entry(trait_id))

/datum/tat_traits/proc/get_pq_lock_minimum(trait_id)
	var/list/rules = GLOB.tat_trait_pq_lock_rules
	return round(rules[trait_id] || 0)

/datum/tat_traits/proc/is_pq_locked_trait(trait_id)
	return get_pq_lock_minimum(trait_id) > 0

/datum/tat_traits/proc/can_select_trait(trait_id)
	if(!check_trait(trait_id))
		return FALSE
	if(trait_id == TAT_TRAIT_CONTRACTOR && !owner_build?.can_select_contractor_trait())
		return FALSE
	if(trait_id == TAT_TRAIT_CONTRACTOR_ENTITY && owner_build?.get_owner_ckey() != "mrix")
		return FALSE
	var/pq_minimum = get_pq_lock_minimum(trait_id)
	if(pq_minimum > 0 && (owner_build?.get_owner_playerquality() || 0) < pq_minimum)
		return FALSE
	// Virtue-granted flaws are already real character traits. Do not allow buying
	// the same negative TAT trait again just to farm trait points. Positive
	// traits stay buyable: external traits must not satisfy requirement chains.
	if(has_external_trait(trait_id) && get_base_cost(trait_id) < 0)
		return FALSE
	return TRUE

/datum/tat_traits/proc/add_trait(trait_id)
	if(!can_select_trait(trait_id))
		return FALSE
	if(is_repeatable_trait(trait_id))
		var/current = get_trait_count(trait_id)
		var/maximum = get_trait_maximum(trait_id)
		if(current >= maximum)
			return FALSE
		selected[trait_id] = current + 1
	else
		selected[trait_id] = TRUE
	owner_build?.set_dirty()
	return TRUE

/datum/tat_traits/proc/remove_trait(trait_id)
	if(is_repeatable_trait(trait_id))
		var/current = get_trait_count(trait_id)
		if(current > 1)
			selected[trait_id] = current - 1
		else
			selected -= trait_id
	else
		selected -= trait_id
	owner_build?.set_dirty()
	return TRUE

/datum/tat_traits/proc/get_bonus_stat_points()
	var/total = 0
	var/list/rules = GLOB.tat_trait_stat_point_rules
	for(var/trait_id in selected)
		if(trait_id in rules)
			total += round(rules[trait_id]) * get_trait_count(trait_id)
	return total

/datum/tat_traits/proc/get_bonus_item_points()
	var/total = 0
	var/list/rules = GLOB.tat_trait_item_point_rules
	for(var/trait_id in selected)
		if(trait_id in rules)
			total += round(rules[trait_id]) * get_trait_count(trait_id)
	return total

/datum/tat_traits/proc/get_bonus_skill_domain_points(domain)
	var/total = 0
	var/list/rules = GLOB.tat_trait_skill_point_rules
	for(var/trait_id in selected)
		var/list/domain_map = rules[trait_id]
		if(islist(domain_map))
			total += round(domain_map[domain] || 0) * get_trait_count(trait_id)
	return total

/datum/tat_traits/proc/get_bonus_skill_value(skill_type)
	var/total = 0
	var/list/rules = GLOB.tat_trait_skill_bonus_rules

	for(var/trait_id in selected)
		var/list/skill_map = rules[trait_id]
		if(islist(skill_map))
			total += round(skill_map[skill_type] || 0)

	if(has_trait(TRAIT_ARCYNE) && skill_type == /datum/skill/magic/arcane && !has_defensive_trait_lockout())
		total += 3
	
	if(has_trait(TAT_TRAIT_MAGE_INITIATE) && skill_type == /datum/skill/magic/arcane)
		total += 1

	if(has_trait(TAT_TRAIT_SADDLEBORN) && skill_type == /datum/skill/misc/riding)
		total += 1

	if(has_trait(TAT_TRAIT_DIVINE_INITIATE) && skill_type == /datum/skill/magic/holy)
		total += 1

	if(has_trait(TAT_TRAIT_DRUID_INITIATE) && skill_type == /datum/skill/magic/druidic)
		total += 1

	return total

/datum/tat_traits/proc/get_skill_cap_bonus_value(skill_type)
	var/highest_cap = 0
	var/has_rule = FALSE
	var/list/rules = GLOB.tat_trait_skill_cap_bonus_rules

	for(var/trait_id in rules)
		var/list/skill_map = rules[trait_id]
		if(!islist(skill_map) || !(skill_type in skill_map))
			continue

		has_rule = TRUE
		if(has_trait(trait_id))
			highest_cap = max(highest_cap, round(skill_map[skill_type] || 0))

	if(highest_cap > 0)
		return highest_cap

	return has_rule ? TAT_SKILL_NONCOMBAT_CAP_UNTRAITED : 0

/datum/tat_traits/proc/get_required_trait_for_unlock(unlock_type, unlock_key)
	var/list/rules = GLOB.tat_trait_item_unlock_rules
	var/list/type_rules = rules[unlock_type]
	if(!islist(type_rules))
		return null
	return type_rules[unlock_key]

/datum/tat_traits/proc/get_skill_cost_discount(skill_type, target_level)
	if(!ispath(skill_type, /datum/skill) || target_level <= 0)
		return 0

	if(has_trait(TAT_TRAIT_RESIDENT) && (ispath(skill_type, /datum/skill/misc) || ispath(skill_type, /datum/skill/labor) || ispath(skill_type, /datum/skill/craft)))
		return 1

	if(has_trait(TAT_TRAIT_MASTER_OF_WANDERING) && ispath(skill_type, /datum/skill/misc))
		return 1

	if(has_trait(TRAIT_SELF_SUSTENANCE) && (ispath(skill_type, /datum/skill/craft) || ispath(skill_type, /datum/skill/labor)))
		return 1

	var/list/rules = GLOB.tat_trait_skill_discount_rules
	for(var/trait_id in selected)
		var/list/discounted = rules[trait_id]
		if(!islist(discounted) || !(skill_type in discounted))
			continue
		if(ispath(skill_type, /datum/skill/combat))
			return (target_level <= 2) ? 1 : 0
		return 1
	return 0

/datum/tat_traits/proc/is_capped_negative_credit_trait(trait_id)
	return trait_id in GLOB.tat_capped_negative_traits

/datum/tat_traits/proc/get_capped_negative_credit_raw()
	var/total = 0
	for(var/trait_id in selected)
		if(!is_capped_negative_credit_trait(trait_id))
			continue
		var/cost = get_display_cost(trait_id) * get_trait_count(trait_id)
		if(cost >= 0)
			continue
		total += -cost
	return total

/datum/tat_traits/proc/get_capped_negative_credit_used()
	return min(get_capped_negative_credit_raw(), TAT_NEGATIVE_TRAIT_CREDIT_CAP)

/datum/tat_traits/proc/get_spent_points()
	var/total = 0
	var/capped_negative_credit = 0
	for(var/trait_id in selected)
		var/cost = get_display_cost(trait_id) * get_trait_count(trait_id)
		if(is_capped_negative_credit_trait(trait_id) && cost < 0)
			capped_negative_credit += -cost
			continue
		total += cost
	total -= min(capped_negative_credit, TAT_NEGATIVE_TRAIT_CREDIT_CAP)
	return total

/datum/tat_traits/proc/get_remaining_points()
	return get_total_maximum() - get_spent_points()

/datum/tat_traits/proc/get_trait_conflict_map()
	if(length(GLOB.tat_trait_conflict_map))
		return GLOB.tat_trait_conflict_map
	GLOB.tat_trait_conflict_map = list(
		TAT_TRAIT_RESIDENT = list(TRAIT_OUTLANDER, TAT_TRAIT_WANTED, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MASTER_OF_WANDERING, TAT_TRAIT_HERETIC, TRAIT_STRONGBITE, TAT_TRAIT_TRADER_LICENSE, TAT_TRAIT_WARRIOR_EXPERT),
		TAT_TRAIT_TRADER_LICENSE = list(TAT_TRAIT_RESIDENT, TAT_TRAIT_WANTED, TRAIT_OUTLANDER, TAT_TRAIT_HERETIC),
		TRAIT_OUTLANDER = list(TAT_TRAIT_WANTED),
		TAT_TRAIT_WANTED = list(TRAIT_OUTLANDER, TAT_TRAIT_RESIDENT, TRAIT_TECHNOPHOBE),
		TAT_TRAIT_CONTRACTOR = list(TRAIT_OUTLANDER, TAT_TRAIT_WANTED, TAT_TRAIT_HERETIC, TAT_TRAIT_RESIDENT, TAT_TRAIT_TRADER_LICENSE, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_BONUS_STAT_POOL, TRAIT_PARRYEXPERT, TRAIT_DODGEEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TRAIT_CIVILIZEDBARBARIAN),
		TAT_TRAIT_BONUS_STAT_POOL = list(TAT_TRAIT_WANTED),
		TRAIT_DODGEEXPERT = list(TRAIT_PARRYEXPERT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TRAIT_HEAVYARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_MAGE_INITIATE),
		TRAIT_MEDIUMARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_MAGE_INITIATE),
		TAT_TRAIT_TROPHY_BOUNTY = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_SOUNDBREAKER = list(TAT_TRAIT_RONIN, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_MARTIAL_MASTER),
		TAT_TRAIT_MARTIAL_MASTER = list(TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_SPELLBLADE = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_MARTIAL_MASTER, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list(TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_RONIN, TAT_TRAIT_DIVINE_BOON_3),
		TAT_TRAIT_MAGE_MAJOR_SLOT = list(TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_DIVINE_BOON_3 = list(TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_UTILITY_SLOT),
		TAT_TRAIT_DRUID_INITIATE = list(TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_DIVINE_BOON_1),
		TRAIT_CRITICAL_RESISTANCE = list(TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_INITIATE),
		TAT_TRAIT_WARRIOR_EXPERT = list(TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_WITCH_INITIATE = list(TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_WANTED, TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR),
		TAT_TRAIT_WARRIOR_MASTER = list(TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TAT_TRAIT_RONIN),
		TAT_TRAIT_SAVAGE_RAGE = list(TAT_TRAIT_BERSERKER_RAGE),
		TRAIT_EASYDISMEMBER = list(TRAIT_HARDDISMEMBER),
		TRAIT_HARDDISMEMBER = list(TRAIT_EASYDISMEMBER),
		TRAIT_FENCERDEXTERITY = list(TAT_TRAIT_SAVAGE_SKIN),
		TRAIT_NUDE_SLEEPER = list(TRAIT_NUDIST, TAT_TRAIT_SAVAGE_SKIN, TRAIT_NOSLEEP),
		TAT_TRAIT_LOOTRAT = list(TAT_TRAIT_WANTED),
		TAT_TRAIT_LOOTRAT_2 = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_HERETIC, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_BONUS_STAT_POOL, TRAIT_PARRYEXPERT, TRAIT_DODGEEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TRAIT_CIVILIZEDBARBARIAN),
		TRAIT_NOSLEEP = list(TRAIT_RITUALIST),
		TRAIT_REVERSE_GUIDANCE = list(TRAIT_LESSER_REVERSE_GUIDANCE),
		TRAIT_NOPAINSTUN = list(TAT_TRAIT_MAGE_INITIATE),
		TRAIT_HARDDISMEMBER = list(TRAIT_EASYDISMEMBER)
	)
	return GLOB.tat_trait_conflict_map

/datum/tat_traits/proc/get_trait_requirement_map()
	if(length(GLOB.tat_trait_requirement_map))
		return GLOB.tat_trait_requirement_map
	GLOB.tat_trait_requirement_map = list(
		TAT_TRAIT_SOUNDBREAKER = list("all" = list(TAT_TRAIT_BARDIC_INSPIRATION_T1), "message" = "\"[get_trait_display_name(TAT_TRAIT_SOUNDBREAKER)]\" requires \"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T1)]\"."),
		TAT_TRAIT_WARRIOR_MASTER = list("all" = list(TAT_TRAIT_WARRIOR_EXPERT), "message" = "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_MASTER)]\" requires \"[get_trait_display_name(TAT_TRAIT_WARRIOR_EXPERT)]\"."),
		TAT_TRAIT_MARTIAL_MASTER = list("all" = list(TRAIT_CIVILIZEDBARBARIAN), "message" = "\"[get_trait_display_name(TAT_TRAIT_MARTIAL_MASTER)]\" requires \"[get_trait_display_name(TRAIT_CIVILIZEDBARBARIAN)]\"."),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list("all" = list(TAT_TRAIT_BARDIC_INSPIRATION_T1), "message" = "\"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T2)]\" requires \"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T1)]\"."),
		TAT_TRAIT_DRUID_INITIATE = list("all" = list(TAT_TRAIT_DIVINE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_DRUID_INITIATE)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_INITIATE)]\"."),
		TAT_TRAIT_DIVINE_BOON_1 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_1)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_INITIATE)]\"."),
		TAT_TRAIT_DIVINE_BOON_2 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_2)]\" requires previous divine progression."),
		TAT_TRAIT_DIVINE_BOON_3 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_2), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\" requires previous divine progression."),
		TAT_TRAIT_MAGE_INITIATE = list("all" = list(TRAIT_ARCYNE), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\" requires \"[get_trait_display_name(TRAIT_ARCYNE)]\"."),
		TAT_TRAIT_SPELLBLADE = list("all" = list(TAT_TRAIT_MAGE_INITIATE, TRAIT_ARCYNE), "message" = "\"[get_trait_display_name(TAT_TRAIT_SPELLBLADE)]\" requires mage initiation and arcyne."),
		TAT_TRAIT_MAGE_MINOR_SLOT_2 = list("all" = list(TAT_TRAIT_MAGE_MINOR_SLOT_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_2)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_1)]\"."),
		TRAIT_BITERHELM = list("all" = list(TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TRAIT_BITERHELM)]\" requires \"[get_trait_display_name(TAT_TRAIT_HERETIC)]\"."),
		TRAIT_RITUALIST = list("all" = list(TAT_TRAIT_HERETIC, TAT_TRAIT_DIVINE_BOON_2), "message" = "\"[get_trait_display_name(TRAIT_RITUALIST)]\" requires \"[get_trait_display_name(TAT_TRAIT_HERETIC)]\" and \"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_2)]\"."),
		TAT_TRAIT_ARTIFACTS_SUPPLIER = list("all" = list(TAT_TRAIT_PARTY_LEADER), "message" = "\"[get_trait_display_name(TAT_TRAIT_ARTIFACTS_SUPPLIER)]\" requires \"[get_trait_display_name(TAT_TRAIT_PARTY_LEADER)]\"."),
		TAT_TRAIT_SAVAGE_SKIN = list("all" = list(TRAIT_NOPAINSTUN), "message" = "\"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\" requires \"[get_trait_display_name(TRAIT_NOPAINSTUN)]\"."),
		TRAIT_STRONGBITE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN), "message" = "\"[get_trait_display_name(TRAIT_STRONGBITE)]\" requires \"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\"."),
		TAT_TRAIT_SAVAGE_RAGE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN), "message" = "\"[get_trait_display_name(TAT_TRAIT_SAVAGE_RAGE)]\" requires \"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\"."),
		TAT_TRAIT_BERSERKER_RAGE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TAT_TRAIT_BERSERKER_RAGE)]\" requires savage skin and heretic."),
		TAT_TRAIT_LOOTRAT_2 = list("all" = list(TAT_TRAIT_LOOTRAT, TAT_TRAIT_TRADER_LICENSE), "message" = "\"[get_trait_display_name(TAT_TRAIT_LOOTRAT_2)]\" requires merchant writ and lootrat."),
	)
	return GLOB.tat_trait_requirement_map

/datum/tat_traits/proc/trait_requirement_is_met(list/rule)
	if(!islist(rule))
		return TRUE
	var/list/all_requirements = rule["all"]
	if(islist(all_requirements))
		for(var/required_trait in all_requirements)
			if(!has_trait(required_trait))
				return FALSE
	return TRUE

/datum/tat_traits/proc/has_defensive_trait_lockout()
	if(has_effective_trait(TRAIT_DODGEEXPERT))
		return TRUE
	if(has_effective_trait(TRAIT_PARRYEXPERT))
		return TRUE
	if(has_effective_trait(TRAIT_CRITICAL_RESISTANCE))
		return TRUE
	if(has_effective_trait(TRAIT_MEDIUMARMOR))
		return TRUE
	if(has_effective_trait(TRAIT_HEAVYARMOR))
		return TRUE
	return FALSE

/datum/tat_traits/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if(!trait_a || !trait_b || trait_a == trait_b)
		return null

	if(has_trait(TAT_TRAIT_WANTED))
		if((trait_a == TRAIT_NOPAINSTUN && (trait_b == TAT_TRAIT_MAGE_INITIATE || trait_b == TAT_TRAIT_DIVINE_BOON_2)) || (trait_b == TRAIT_NOPAINSTUN && (trait_a == TAT_TRAIT_MAGE_INITIATE || trait_a == TAT_TRAIT_DIVINE_BOON_2)))
			return null

	var/list/conflicts = get_trait_conflict_map()
	var/list/a_conflicts = conflicts[trait_a]
	if(islist(a_conflicts) && (trait_b in a_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."
	var/list/b_conflicts = conflicts[trait_b]
	if(islist(b_conflicts) && (trait_a in b_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."
	if(((trait_a == TAT_TRAIT_DIVINE_BOON_3 || trait_b == TAT_TRAIT_DIVINE_BOON_3) && has_defensive_trait_lockout()) && !(has_trait(TAT_TRAIT_HERETIC) || has_trait(TAT_TRAIT_WANTED)))
		return "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\" conflicts with current defensive trait setup or lack wanted/heretic traits."
	return null

/datum/tat_traits/proc/has_invalid_trait_dependencies()
	var/list/issues = list()
	var/list/requirements = get_trait_requirement_map()
	for(var/trait_id in requirements)
		if(!has_trait(trait_id))
			continue
		var/list/rule = requirements[trait_id]
		if(trait_requirement_is_met(rule))
			continue
		issues += (rule["message"] || "Trait has unmet requirements.")
	if((has_trait(TAT_TRAIT_MAGE_MAJOR_SLOT) || has_trait(TAT_TRAIT_MAGE_MINOR_SLOT_1) || has_trait(TAT_TRAIT_MAGE_UTILITY_SLOT)) && !has_trait(TAT_TRAIT_MAGE_INITIATE))
		issues += "Mage spell slots require \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."
	var/list/effective_traits = get_effective_trait_counts()
	for(var/trait_a in effective_traits)
		for(var/trait_b in effective_traits)
			if(trait_a == trait_b)
				continue
			if("[trait_a]" >= "[trait_b]")
				continue
			var/reason = are_traits_mutually_exclusive(trait_a, trait_b)
			if(reason)
				issues += reason
	return issues

/datum/tat_traits/proc/get_effective_divine_tier()
	var/tier = CLERIC_T0
	if(has_trait(TAT_TRAIT_DIVINE_BOON_1))
		tier++
	if(has_trait(TAT_TRAIT_DIVINE_BOON_2))
		tier++
	if(has_trait(TAT_TRAIT_DIVINE_BOON_3))
		tier++
	return clamp(tier, CLERIC_T0, CLERIC_T4)

/datum/tat_traits/proc/get_divine_passive_gain_for_tier(cleric_tier)
	if(cleric_tier >= CLERIC_T1)
		return CLERIC_REGEN_MINOR
	return CLERIC_REGEN_WITCH

/datum/tat_traits/proc/get_divine_devotion_limit_for_tier(cleric_tier)
	switch(cleric_tier)
		if(CLERIC_T4)
			return CLERIC_REQ_4
		if(CLERIC_T3)
			return CLERIC_REQ_3
		if(CLERIC_T2)
			return CLERIC_REQ_2
	return CLERIC_REQ_1

/datum/tat_traits/proc/build_mage_aspects(scale_with_arcane = TRUE)
	var/major = 0
	var/minor = 1
	var/utilities = 3
	if(has_trait(TAT_TRAIT_MAGE_MAJOR_SLOT))
		major += 1
	if(has_trait(TAT_TRAIT_MAGE_MINOR_SLOT_1))
		minor += 1
	if(has_trait(TAT_TRAIT_MAGE_MINOR_SLOT_2))
		minor += 1
	if(has_trait(TAT_TRAIT_MAGE_UTILITY_SLOT))
		utilities += 1
	if(scale_with_arcane)
		utilities += owner_build?.get_skill_value(/datum/skill/magic/arcane) || 0
	return list("mastery" = FALSE, "major" = major, "minor" = minor, "utilities" = utilities, "ward" = TRUE)

/datum/tat_traits/proc/can_train_arcane()
	return TRUE

/datum/tat_traits/proc/can_train_holy()
	return TRUE

/datum/tat_traits/proc/can_train_druidic()
	return TRUE

/datum/tat_traits/proc/sanitize()
	for(var/trait_id in selected.Copy())
		if(!can_select_trait(trait_id))
			selected -= trait_id
			continue
		var/count = get_trait_count(trait_id)
		var/maximum = get_trait_maximum(trait_id)
		if(count <= 0)
			selected -= trait_id
		else if(is_repeatable_trait(trait_id) && count > maximum)
			selected[trait_id] = maximum
	while(get_remaining_points() < 0)
		var/changed = FALSE
		for(var/trait_id in selected.Copy())
			selected -= trait_id
			changed = TRUE
			if(get_remaining_points() >= 0)
				break
		if(!changed)
			break
	return TRUE

/datum/tat_traits/proc/try_apply_party_leader(mob/living/carbon/human/H)
	if(has_trait(TAT_TRAIT_PARTY_LEADER))
		H.LoadComponent(/datum/component/tat_party_leader)

/datum/tat_traits/proc/apply_resident_package(mob/living/carbon/human/H)
	if(!H)
		return
	ADD_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)
	if(H in SStreasury.bank_accounts)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
	else
		SStreasury.create_bank_account(H, ECONOMIC_LOWER_MIDDLE_CLASS)
	var/bonus_reading = owner_build?.get_resident_skill_value(/datum/skill/misc/reading) || 0
	if(bonus_reading > 0)
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, bonus_reading, TRUE)

	apply_resident_skill_spells(H)

/datum/tat_traits/proc/apply_resident_pugilist_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TRAIT_CIVILIZEDBARBARIAN))
		return
	var/spell_type = owner_build?.get_resident_pugilist_spell_type(owner_build?.get_resident_pugilist_spell_choice(H))
	if(spell_type)
		owner_build?.grant_mind_spell_if_missing(H, spell_type)

/datum/tat_traits/proc/apply_divine_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_DIVINE_INITIATE))
		return
	var/cleric_tier = get_effective_divine_tier()
	var/passive_gain = get_divine_passive_gain_for_tier(cleric_tier)
	var/devotion_limit = get_divine_devotion_limit_for_tier(cleric_tier)
	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = cleric_tier, passive_gain = passive_gain, devotion_limit = devotion_limit)
	H.adjust_skillrank_up_to(/datum/skill/magic/holy, max(1, owner_build?.get_skill_value(/datum/skill/magic/holy) || 1), TRUE)
	if(H.patron?.type == /datum/patron/inhumen/zizo && cleric_tier >= CLERIC_T2)
		owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/minion_order)

/datum/tat_traits/proc/apply_mage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_MAGE_INITIATE) || !H.mind)
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	var/list/aspects = build_mage_aspects(TRUE)
	H.mind.setup_mage_aspects(aspects)
	owner_build?.set_magic_value("mage_aspects", aspects.Copy())
	// Spellbook/chalk are synchronized into the TAT loadout stash by /datum/tat_items.

/datum/tat_traits/proc/apply_druid_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_DRUID_INITIATE))
		return
	if(owner_build?.get_magic_value("druid_force_dendor", TRUE))
		H.set_patron(/datum/patron/divine/dendor)
	if(owner_build?.get_magic_value("druid_alert", TRUE))
		H.AddComponent(/datum/component/wise_tree_alert)
	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/create_seed)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_claws)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_rage)
	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)

/datum/tat_traits/proc/apply_witch_base_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_WITCH_INITIATE))
		return
	ADD_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)
	ADD_TRAIT(H, TRAIT_DEATHSIGHT, TAT_TRAIT_SOURCE)

/datum/tat_traits/proc/apply_witch_shapeshift_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_WITCH_INITIATE))
		return
	var/list/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
	var/shapeshiftchoice = null
	if(H.client)
		shapeshiftchoice = tgui_input_list(H, "What form does your second skin take?", "THE OLD WAYS", shapeshifts)
	if(!shapeshiftchoice || !(shapeshiftchoice in shapeshifts))
		shapeshiftchoice = owner_build?.get_magic_value("witch_shapeshift")
	if(!shapeshiftchoice || !(shapeshiftchoice in shapeshifts))
		shapeshiftchoice = "Zad"
	owner_build?.set_magic_value("witch_shapeshift", shapeshiftchoice)
	if(H.mind)
		switch(shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)

/datum/tat_traits/proc/apply_spellblade_base_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SPELLBLADE))
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)

/datum/tat_traits/proc/apply_spellblade_specialization_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SPELLBLADE))
		return
	if(!H.mind)
		return
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))
	var/list/subclass_list = list("Blade", "Phalangite", "Macebearer")
	var/subclass_selected = H.client ? tgui_input_list(H, "Who are you?", "The spellblade specialization", subclass_list) : null
	if(!subclass_selected)
		subclass_selected = "Blade"
	switch(subclass_selected)
		if("Blade")
			H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
			H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
			H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
		if("Phalangite")
			H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
			H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
			H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
		if("Macebearer")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
			H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
			H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
			H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
	H.mind.setup_mage_aspects(build_mage_aspects(FALSE))
	H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

/datum/tat_traits/proc/get_pliant_rename_prefix()
	if(!has_trait(TRAIT_OUTLANDER) && !has_trait(TAT_TRAIT_RESIDENT))
		return "Straying Pliant"
	if(has_trait(TRAIT_OUTLANDER))
		return "Wandering Pliant"
	if(has_trait(TAT_TRAIT_RESIDENT))
		return "Local Pliant"
	return "Pliant"

/datum/tat_traits/proc/get_pliant_default_class_name()
	return "Towner"

/datum/tat_traits/proc/get_pliant_current_class_name(mob/living/carbon/human/H)
	// Automatic, silent base title generation.
	// Used by Pliant Rename as the "current/selected class" option.
	// Do not open choice dialogs here.
	var/class_name = get_pliant_best_role_title()
	if(!length(class_name))
		class_name = trim("[H?.advjob]")
	if(!length(class_name))
		class_name = get_pliant_default_class_name()
	return get_pliant_safe_class_name(class_name)

/datum/tat_traits/proc/get_pliant_slot_class_name(fallback = null)
	var/slot_name = trim("[owner_build?.get_active_tat_slot_name()]")
	if(!length(slot_name))
		if(length("[fallback]"))
			return get_pliant_safe_class_name(fallback)
		return get_pliant_default_class_name()
	return get_pliant_safe_class_name(slot_name)

/datum/tat_traits/proc/get_pliant_safe_class_name(class_name, fallback = null)
	class_name = trim("[class_name]")
	if(!length(class_name))
		if(length("[fallback]"))
			class_name = fallback
		else
			class_name = get_pliant_default_class_name()
	return copytext(class_name, 1, 50)

/datum/tat_traits/proc/get_pliant_skill_role_rules()
	return list(
		list("title" = "Sellsword", "minimum" = 3, "skills" = list(/datum/skill/combat/swords, /datum/skill/combat/knives, /datum/skill/combat/maces, /datum/skill/combat/axes, /datum/skill/combat/polearms, /datum/skill/combat/whipsflails, /datum/skill/combat/staves, /datum/skill/combat/shields)),
		list("title" = "Archer", "minimum" = 3, "skills" = list(/datum/skill/combat/bows, /datum/skill/combat/crossbows, /datum/skill/combat/slings)),
		list("title" = "Pugilist", "minimum" = 3, "skills" = list(/datum/skill/combat/unarmed, /datum/skill/combat/wrestling)),
		list("title" = "Gunslinger", "minimum" = 3, "skills" = list(/datum/skill/combat/twilight_firearms)),
		list("title" = "Hunter", "minimum" = 3, "skills" = list(/datum/skill/misc/hunting, /datum/skill/misc/tracking, /datum/skill/labor/butchering, /datum/skill/combat/bows, /datum/skill/combat/crossbows)),
		list("title" = "Forester", "minimum" = 3, "skills" = list(/datum/skill/labor/lumberjacking, /datum/skill/misc/tracking, /datum/skill/misc/climbing, /datum/skill/misc/athletics)),
		list("title" = "Miner", "minimum" = 3, "skills" = list(/datum/skill/labor/mining, /datum/skill/craft/smelting, /datum/skill/craft/masonry)),
		list("title" = "Farmer", "minimum" = 3, "skills" = list(/datum/skill/labor/farming, /datum/skill/craft/cooking)),
		list("title" = "Fisher", "minimum" = 3, "skills" = list(/datum/skill/labor/fishing, /datum/skill/craft/cooking)),
		list("title" = "Cook", "minimum" = 3, "skills" = list(/datum/skill/craft/cooking, /datum/skill/labor/fishing, /datum/skill/labor/butchering)),
		list("title" = "Blacksmith", "minimum" = 3, "skills" = list(/datum/skill/craft/blacksmithing, /datum/skill/craft/weaponsmithing, /datum/skill/craft/armorsmithing, /datum/skill/craft/smelting)),
		list("title" = "Tailor", "minimum" = 3, "skills" = list(/datum/skill/craft/sewing, /datum/skill/craft/tanning)),
		list("title" = "Carpenter", "minimum" = 3, "skills" = list(/datum/skill/craft/carpentry, /datum/skill/craft/masonry, /datum/skill/craft/crafting)),
		list("title" = "Engineer", "minimum" = 3, "skills" = list(/datum/skill/craft/engineering, /datum/skill/craft/traps, /datum/skill/craft/carpentry)),
		list("title" = "Alchemist", "minimum" = 3, "skills" = list(/datum/skill/craft/alchemy, /datum/skill/misc/medicine, /datum/skill/misc/reading)),
		list("title" = "Physician", "minimum" = 3, "skills" = list(/datum/skill/misc/medicine, /datum/skill/craft/alchemy, /datum/skill/misc/reading)),
		list("title" = "Scholar", "minimum" = 3, "skills" = list(/datum/skill/misc/reading, /datum/skill/magic/arcane, /datum/skill/magic/holy, /datum/skill/magic/druidic)),
		list("title" = "Bard", "minimum" = 3, "skills" = list(/datum/skill/misc/music, /datum/skill/misc/reading)),
		list("title" = "Rogue", "minimum" = 3, "skills" = list(/datum/skill/misc/stealing, /datum/skill/misc/sneaking, /datum/skill/misc/lockpicking)),
		list("title" = "Scout", "minimum" = 3, "skills" = list(/datum/skill/misc/athletics, /datum/skill/misc/climbing, /datum/skill/misc/swimming, /datum/skill/misc/riding, /datum/skill/misc/tracking)),
		list("title" = "Acolyte", "minimum" = 1, "skills" = list(/datum/skill/magic/holy)),
		list("title" = "Mage", "minimum" = 1, "skills" = list(/datum/skill/magic/arcane)),
		list("title" = "Druid", "minimum" = 1, "skills" = list(/datum/skill/magic/druidic))
	)

/datum/tat_traits/proc/get_pliant_trait_role_scores()
	var/list/roles = list()
	if(has_trait(TAT_TRAIT_WITCH_INITIATE))
		roles["Witch"] = 1000000
	if(has_trait(TAT_TRAIT_BARDIC_INSPIRATION_T1) || has_trait(TAT_TRAIT_BARDIC_INSPIRATION_T2))
		roles["Minstrel"] = 600000
	return roles

/datum/tat_traits/proc/get_pliant_skill_role_score(list/rule)
	if(!owner_build || !islist(rule))
		return 0

	var/list/skills = rule["skills"]
	if(!islist(skills) || !length(skills))
		return 0

	var/highest_skill = 0
	var/total_skill = 0
	for(var/skill_type in skills)
		var/skill_value = owner_build.get_skill_value(skill_type)
		if(skill_value <= 0)
			continue
		highest_skill = max(highest_skill, skill_value)
		total_skill += skill_value

	var/minimum = round(rule["minimum"] || 3)
	if(highest_skill < minimum)
		return 0

	return total_skill

/datum/tat_traits/proc/get_pliant_skill_role_title_score(title)
	if(!istext(title) || !length(title))
		return 0
	for(var/rule_entry in get_pliant_skill_role_rules())
		var/list/rule = rule_entry
		if(!islist(rule))
			continue
		var/rule_title = get_pliant_safe_class_name(rule["title"])
		if(lowertext(rule_title) != lowertext(title))
			continue
		return get_pliant_skill_role_score(rule)
	return 0

/datum/tat_traits/proc/get_pliant_role_title_score(title)
	if(!istext(title) || !length(title))
		return 0
	var/list/trait_roles = get_pliant_trait_role_scores()
	if(title in trait_roles)
		return round(trait_roles[title] || 0)
	return get_pliant_skill_role_title_score(title)

/datum/tat_traits/proc/get_pliant_best_role_title()
	var/best_title = null
	var/best_score = 0

	var/list/trait_roles = get_pliant_trait_role_scores()
	for(var/title in trait_roles)
		var/score = round(trait_roles[title] || 0)
		if(score <= best_score)
			continue
		best_score = score
		best_title = title

	for(var/rule_entry in get_pliant_skill_role_rules())
		var/list/rule = rule_entry
		if(!islist(rule))
			continue
		var/title = get_pliant_safe_class_name(rule["title"])
		var/score = get_pliant_skill_role_score(rule)
		if(score <= best_score)
			continue
		best_score = score
		best_title = title

	return best_title

/datum/tat_traits/proc/add_pliant_role_choice(list/display_to_title, title, score, source_label = null, excluded_title = null)
	if(!islist(display_to_title) || !istext(title) || !length(title))
		return FALSE
	if(istext(excluded_title) && length(excluded_title) && lowertext(title) == lowertext(excluded_title))
		return FALSE

	var/display = source_label ? "[title] ([source_label])" : "[title] ([score])"
	if(display in display_to_title)
		return FALSE
	display_to_title[display] = title
	return TRUE

/datum/tat_traits/proc/build_pliant_role_title_choices(excluded_title = null)
	var/list/display_to_title = list()

	var/list/trait_roles = get_pliant_trait_role_scores()
	for(var/title in trait_roles)
		add_pliant_role_choice(display_to_title, title, trait_roles[title], "trait", excluded_title)

	for(var/rule_entry in get_pliant_skill_role_rules())
		var/list/rule = rule_entry
		if(!islist(rule))
			continue
		var/title = get_pliant_safe_class_name(rule["title"])
		var/score = get_pliant_skill_role_score(rule)
		if(score <= 0 || !length(title))
			continue
		add_pliant_role_choice(display_to_title, title, score, null, excluded_title)

	return display_to_title

/datum/tat_traits/proc/build_pliant_skill_role_choices(current_class_name)
	return build_pliant_role_title_choices(current_class_name)

/datum/tat_traits/proc/get_single_pliant_role_choice(list/display_to_title)
	if(!islist(display_to_title) || length(display_to_title) != 1)
		return null
	for(var/display in display_to_title)
		return display_to_title[display]
	return null

/datum/tat_traits/proc/get_pliant_base_class_title(mob/living/carbon/human/H)
	// Pliant Rename uses this silently. The actual dialog for rename must only ask
	// between current/slot/custom, not open a separate role picker first.
	return get_pliant_current_class_name(H)

/datum/tat_traits/proc/get_pliant_plain_class_title(mob/living/carbon/human/H)
	var/fallback = get_pliant_current_class_name(H)
	var/list/display_to_title = build_pliant_role_title_choices()
	if(!length(display_to_title))
		return fallback

	var/single_title = get_single_pliant_role_choice(display_to_title)
	if(single_title)
		return get_pliant_safe_class_name(single_title, fallback)

	var/list/options = list()
	for(var/display in display_to_title)
		options += display

	var/choice = H.client ? tgui_input_list(H, "Choose which class title should be used for your Pliant identity.", "CHOOSE YOUR CLASS", options) : null
	if(choice && display_to_title[choice])
		return get_pliant_safe_class_name(display_to_title[choice], fallback)
	return fallback

/datum/tat_traits/proc/get_pliant_rename_title(mob/living/carbon/human/H)
	var/base_class_name = get_pliant_base_class_title(H)
	var/slot_name = get_pliant_slot_class_name(base_class_name)

	var/current_choice = "Use selected class ([base_class_name])"
	var/slot_choice = "Use active TAT slot ([slot_name])"
	var/input_choice = "Input class name"
	var/list/display_to_title = list()
	display_to_title[current_choice] = base_class_name
	var/list/options = list(current_choice)

	if(lowertext(slot_name) != lowertext(base_class_name))
		options += slot_choice
		display_to_title[slot_choice] = slot_name

	options += input_choice

	var/choice = H.client ? tgui_input_list(H, "Choose how your displayed class name should be written.", "CHOOSE YOUR DESTINY", options) : null
	var/class_name = base_class_name

	if(choice == input_choice)
		class_name = H.client ? tgui_input_text(H, "What is name of your destiny?", "YOUR CLASS NAME", encode = FALSE) : base_class_name
		if(!length(trim("[class_name]")))
			class_name = base_class_name
	else if(choice && display_to_title[choice])
		class_name = display_to_title[choice]

	class_name = get_pliant_safe_class_name(class_name, base_class_name)
	return "[get_pliant_rename_prefix()] [class_name]"

/datum/tat_traits/proc/get_pliant_default_title(mob/living/carbon/human/H)
	var/class_name = get_pliant_plain_class_title(H)
	class_name = get_pliant_safe_class_name(class_name)
	return "[get_pliant_rename_prefix()] [class_name]"

/datum/tat_traits/proc/apply_pliant_title(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	var/class_name = null
	var/new_title = null
	if(has_trait(TAT_TRAIT_PLIANT_RENAME))
		new_title = get_pliant_rename_title(H)
		class_name = copytext(new_title, length(get_pliant_rename_prefix()) + 2)
	else
		class_name = get_pliant_plain_class_title(H)
		new_title = "[get_pliant_rename_prefix()] [get_pliant_safe_class_name(class_name)]"

	if(!length(new_title))
		return FALSE

	H.tat_pliant_title = new_title
	if(length(class_name))
		owner_build?.set_magic_value("pliant_selected_role_title", get_pliant_safe_class_name(class_name))
	return TRUE

/datum/tat_traits/proc/apply_pliant_rename(mob/living/carbon/human/H)
	return apply_pliant_title(H)

/datum/tat_traits/proc/apply_savage_skin_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SAVAGE_SKIN))
		return FALSE

	var/skin_path = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
	return owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path, SLOT_ARMOR)

/datum/tat_traits/proc/apply_savage_rage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SAVAGE_RAGE) || !H.mind)
		return FALSE
	if(owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/self/ragebad))
		return TRUE
	if(!owner_build)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/ragebad)
		ADD_TRAIT(H, TRAIT_RAGE, TAT_TRAIT_SOURCE)
		return TRUE
	return FALSE

/datum/tat_traits/proc/apply_berserker_rage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_BERSERKER_RAGE) || !H.mind)
		return FALSE
	if(owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/self/rage))
		return TRUE
	if(!owner_build)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		ADD_TRAIT(H, TRAIT_RAGE, TAT_TRAIT_SOURCE)
		return TRUE
	return FALSE

/datum/tat_traits/proc/apply_instant_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/trait_id in selected)
		if(is_repeatable_trait(trait_id))
			continue
		switch(trait_id)
			if(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER, TAT_TRAIT_MARTIAL_MASTER, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_RESIDENT, TAT_TRAIT_STEEL_SUPPLIER, TAT_TRAIT_SILVER_SUPPLIER, TAT_TRAIT_BRONZE_SUPPLIER, TAT_TRAIT_LEATHER_SUPPLIER, TAT_TRAIT_MAIL_SUPPLIER, TAT_TRAIT_PLATE_SUPPLIER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2, TAT_TRAIT_PARTY_LEADER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WANTED, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DRUID_INITIATE, TAT_TRAIT_WITCH_INITIATE, TAT_TRAIT_CONTRACTOR, TAT_TRAIT_ARTIFACTS_SUPPLIER, TAT_TRAIT_FIREARMS_SUPPLIER, TAT_TRAIT_TROPHY_BOUNTY, TAT_TRAIT_MASTER_OF_WANDERING, TAT_TRAIT_STRAYING_SOUL, TAT_TRAIT_PLIANT_RENAME, TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_SAVAGE_RAGE, TAT_TRAIT_HERETIC, TAT_TRAIT_BERSERKER_RAGE, TAT_TRAIT_LOOTRAT, TRAIT_SHIRTLESS, TAT_TRAIT_LOOTRAT_2)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_RESIDENT))
		apply_resident_package(H)
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		apply_spellblade_base_package(H)
	if(has_trait(TAT_TRAIT_SOUNDBREAKER))
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
	if(has_trait(TAT_TRAIT_MARTIAL_MASTER))
		H.LoadComponent(/datum/component/combo_core/martial_master)
	if(has_trait(TAT_TRAIT_TROPHY_BOUNTY))
		H.LoadComponent(/datum/component/trophy_hunter)
	if(has_trait(TAT_TRAIT_RONIN))
		H.LoadComponent(/datum/component/combo_core/ronin)
	// Ritual chalk, spellbook and chalk are synchronized into the TAT loadout stash by /datum/tat_items.
	if(has_trait(TAT_TRAIT_BARDIC_INSPIRATION_T1) || has_trait(TAT_TRAIT_BARDIC_INSPIRATION_T2))
		var/bard_tier = BARD_T1
		if(has_trait(TAT_TRAIT_BARDIC_INSPIRATION_T2))
			bard_tier = BARD_T2
		if(!H.inspiration)
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier)
		else
			H.inspiration.grant_inspiration(H, bard_tier)
	try_apply_party_leader(H)
	apply_savage_skin_package(H)
	apply_savage_rage_package(H)
	apply_berserker_rage_package(H)
	if(has_trait(TAT_TRAIT_WARRIOR_MASTER))
		ADD_TRAIT(H, TRAIT_BADTRAINER, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_WANTED))
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_HERETIC))
		GLOB.excommunicated_players += H.real_name
	apply_divine_package(H)
	apply_mage_package(H)
	apply_druid_package(H)
	apply_witch_base_package(H)
	if(has_trait(TAT_TRAIT_CONTRACTOR))
		H.LoadComponent(/datum/component/contractor, 0)
	if(has_trait(TAT_TRAIT_CONTRACTOR_ENTITY))
		H.LoadComponent(/datum/component/contractor/entity, 4)
	return TRUE

/datum/tat_traits/proc/apply_deferred_to_human(mob/living/carbon/human/H)
	if(!H?.client)
		return FALSE
	if(has_trait(TAT_TRAIT_RESIDENT))
		apply_resident_pugilist_package(H)
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		apply_spellblade_specialization_package(H)
	if(has_trait(TAT_TRAIT_WANTED))
		wretch_select_bounty(H)
	if(has_trait(TAT_TRAIT_SADDLEBORN))
		if(!H.HasSpell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
			H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
		ADD_TRAIT(H, TRAIT_EQUESTRIAN, TAT_TRAIT_SOURCE)
	apply_witch_shapeshift_package(H)
	apply_pliant_title(H)
	if(has_trait(TAT_TRAIT_RESIDENT))
		apply_resident_advjob(H)
	return TRUE

/datum/tat_traits/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	apply_instant_to_human(H)
	apply_deferred_to_human(H)
	return TRUE

/datum/tat_traits/proc/disable_from_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/trait_id in selected)
		REMOVE_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_BADTRAINER, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)
	REMOVE_TRAIT(H, TRAIT_DEATHSIGHT, TAT_TRAIT_SOURCE)
	return TRUE

/datum/tat_traits/proc/export_to_list()
	return selected.Copy()

/datum/tat_traits/proc/import_from_list(list/data)
	reset()
	if(!islist(data))
		return FALSE
	for(var/trait_id in data)
		if(!check_trait(trait_id))
			continue
		var/count = isnum(data[trait_id]) ? round(data[trait_id]) : (data[trait_id] ? 1 : 0)
		for(var/i in 1 to count)
			add_trait(trait_id)
	return TRUE

/datum/tat_traits/proc/export_to_json_list()
	var/list/result = list()
	for(var/trait_id in selected)
		var/count = get_trait_count(trait_id)
		for(var/i in 1 to count)
			result += trait_id
	return result

/datum/tat_traits/proc/import_from_json_list(list/data)
	reset()
	if(!islist(data))
		return FALSE
	for(var/key in data)
		if(check_trait(key))
			add_trait(key)
			continue
		if(data[key] && check_trait("[key]"))
			var/count = isnum(data[key]) ? round(data[key]) : 1
			for(var/i in 1 to count)
				add_trait("[key]")
	return TRUE

/datum/tat_traits/proc/get_resident_skill_spell_rules()
	return list(
		/datum/skill/misc/medicine = list(
			/obj/effect/proc_holder/spell/invoked/diagnose/secular,
		),
		/datum/skill/misc/hunting = list(
			/obj/effect/proc_holder/spell/invoked/huntersyell,
		),
		/datum/skill/craft/ceramics = list(
			/obj/effect/proc_holder/spell/invoked/digclay,
		),
		/datum/skill/craft/sewing = list(
			/obj/effect/proc_holder/spell/invoked/fittedclothing,
		),
		/datum/skill/labor/mining = list(
			/datum/component/ore_sight,
		),
	)

/datum/tat_traits/proc/apply_resident_skill_spells(mob/living/carbon/human/H)
	if(!H || !H.mind || !has_trait(TAT_TRAIT_RESIDENT))
		return FALSE

	var/list/rules = get_resident_skill_spell_rules()
	for(var/skill_type in rules)
		if((owner_build?.get_skill_value(skill_type) || 0) <= 3)
			continue

		var/list/rewards = rules[skill_type]
		if(!islist(rewards))
			continue

		for(var/reward_type in rewards)
			if(ispath(reward_type, /datum/component))
				H.AddComponent(reward_type)
				continue

			owner_build.grant_mind_spell_if_missing(H, reward_type)

	return TRUE

/datum/tat_traits/proc/get_tat_resident_advjob_title_to_path_map()
	return list(
		"Blacksmith" = "/datum/advclass/blacksmith",
		"Miner" = "/datum/advclass/miner",
		"Hunter" = "/datum/advclass/hunter",
		"Farmer" = "/datum/advclass/farmer",
		"Fisher" = "/datum/advclass/fisher",
		"Cook" = "/datum/advclass/cook",
		"Tailor" = "/datum/advclass/seamstress",
		"Carpenter" = "/datum/advclass/woodworker",
		"Engineer" = "/datum/advclass/engineer",
		"Alchemist" = "/datum/advclass/alchemist",
		"Physician" = "/datum/advclass/physician",
		"Scholar" = "/datum/advclass/scholar",
		"Bard" = "/datum/advclass/bard",
		"Rogue" = "/datum/advclass/rogue",
		"Witch" = "/datum/advclass/witch",
	)

/datum/tat_traits/proc/get_tat_resident_special_role_titles()
	return list(
		"Sellsword",
		"Archer",
		"Pugilist",
		"Gunslinger",
		"Forester",
		"Scout",
		"Acolyte",
		"Mage",
		"Druid",
	)

/datum/tat_traits/proc/is_tat_resident_special_role_title(title)
	if(!istext(title) || !length(title))
		return FALSE
	return title in get_tat_resident_special_role_titles()

/datum/tat_traits/proc/get_tat_resident_advjob_path_for_title(title)
	if(!istext(title) || !length(title))
		return null
	var/list/title_to_path = get_tat_resident_advjob_title_to_path_map()
	var/path_text = title_to_path[title]
	if(!istext(path_text) || !length(path_text))
		return null
	return text2path(path_text)

/datum/tat_traits/proc/get_tat_resident_role_choice_for_title(title)
	if(!has_trait(TAT_TRAIT_RESIDENT) || !istext(title) || !length(title))
		return null

	title = get_pliant_safe_class_name(title)
	if(title == "Witch")
		if(!has_trait(TAT_TRAIT_WITCH_INITIATE))
			return null
		return list(
			"title" = "Witch",
			"path" = get_tat_resident_advjob_path_for_title("Witch"),
			"score" = 1000000,
		)

	if(is_tat_resident_special_role_title(title))
		return null

	var/score = get_pliant_skill_role_title_score(title)
	if(score <= 0)
		return null

	return list(
		"title" = title,
		"path" = get_tat_resident_advjob_path_for_title(title),
		"score" = score,
	)

/datum/tat_traits/proc/get_tat_resident_role_choice()
	if(!has_trait(TAT_TRAIT_RESIDENT))
		return null

	var/selected_title = owner_build?.get_magic_value("pliant_selected_role_title")
	var/list/selected_choice = get_tat_resident_role_choice_for_title(selected_title)
	if(islist(selected_choice))
		return selected_choice

	if(has_trait(TAT_TRAIT_WITCH_INITIATE))
		return get_tat_resident_role_choice_for_title("Witch")

	var/list/rules = get_pliant_skill_role_rules()
	var/list/best_choice = null
	var/best_score = 0

	for(var/rule_entry in rules)
		var/list/rule = rule_entry
		if(!islist(rule))
			continue

		var/title = get_pliant_safe_class_name(rule["title"])
		if(!length(title) || is_tat_resident_special_role_title(title))
			continue

		var/score = get_pliant_skill_role_score(rule)
		if(score <= best_score)
			continue

		best_score = score
		best_choice = list(
			"title" = title,
			"path" = get_tat_resident_advjob_path_for_title(title),
			"score" = score,
		)

	return best_choice

/datum/tat_traits/proc/get_tat_resident_advjob()
	var/list/choice = get_tat_resident_role_choice()
	if(!islist(choice))
		return null
	return choice["path"]

/datum/tat_traits/proc/apply_resident_advjob(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_RESIDENT))
		return

	var/list/choice = get_tat_resident_role_choice()
	if(!islist(choice))
		return

	var/title = get_pliant_safe_class_name(choice["title"])
	var/resident_advjob_type = choice["path"]
	var/applied_name = title

	if(resident_advjob_type)
		var/datum/advclass/advclass = new resident_advjob_type
		if(advclass)
			applied_name = get_pliant_safe_class_name(advclass.name, title)
			qdel(advclass)

	if(!length(applied_name))
		return

	H.advjob = applied_name

/datum/tat_traits/proc/get_outlander_natural_potential_discount(trait_id)
	if(trait_id != TAT_TRAIT_BONUS_STAT_POOL)
		return 0
	if(!has_trait(TRAIT_OUTLANDER))
		return 0
	return 10
