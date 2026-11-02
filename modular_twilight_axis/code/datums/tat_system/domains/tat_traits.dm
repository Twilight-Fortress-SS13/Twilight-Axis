/mob/living/carbon/human
	var/tat_pliant_title
	var/tat_handles_preference_loadout = FALSE

/datum/tat_traits
	var/datum/tat_build/owner_build
	var/list/selected = list()

/datum/tat_traits/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/tat_traits/proc/reset()
	selected = list()
	return TRUE

/datum/tat_traits/proc/get_entry(trait_id)
	return GLOB.tat_available_traits[trait_id]

/datum/tat_traits/proc/is_resident_only_hunter_trait(trait_id)
	return trait_id in list(TAT_TRAIT_HUNTER_BEATER, TAT_TRAIT_HUNTER_SHOOTER)

/datum/tat_traits/proc/is_wanderer_role_choice(role_choice)
	return role_choice == TAT_ROLE_CHOICE_ADVENTURER || role_choice == TAT_ROLE_CHOICE_WRETCH

/datum/tat_traits/proc/is_contractor_skill_trait(trait_id)
	if(trait_id in list(TRAIT_ARCYNE, TRAIT_JACKOFALLTRADES, TAT_TRAIT_MASTER_OF_WANDERING))
		return TRUE
	return (trait_id in GLOB.tat_trait_skill_point_rules) || (trait_id in GLOB.tat_trait_skill_bonus_rules) || (trait_id in GLOB.tat_trait_skill_cap_bonus_rules) || (trait_id in GLOB.tat_trait_skill_discount_rules)

/datum/tat_traits/proc/is_contractor_trait_blocked(trait_id)
	if(has_trait(TAT_TRAIT_MENTOR))
		return FALSE
	if(has_trait(TAT_TRAIT_CONTRACTOR))
		return trait_id != TAT_TRAIT_CONTRACTOR && !is_contractor_skill_trait(trait_id)
	if(trait_id != TAT_TRAIT_CONTRACTOR)
		return FALSE
	for(var/selected_trait_id in selected)
		if(selected_trait_id != TAT_TRAIT_CONTRACTOR && !is_contractor_skill_trait(selected_trait_id))
			return TRUE
	return FALSE


/datum/tat_traits/proc/get_trait_count(trait_id)
	if(trait_id == TAT_TRAIT_RESIDENT || trait_id == TRAIT_OUTLANDER || trait_id == TAT_TRAIT_WANTED)
		var/role_trait = GLOB.tat_role_choice_effective_traits[owner_build?.directions?.role_choice]
		return role_trait == trait_id ? 1 : 0
	if(trait_id == TAT_TRAIT_HUNTER_BEATER || trait_id == TAT_TRAIT_HUNTER_SHOOTER)
		if(owner_build?.directions?.role_choice != TAT_ROLE_CHOICE_TOWNER)
			return 0
	if(trait_id == TAT_TRAIT_WEAPON_TRAINING)
		var/role_choice = owner_build?.directions?.role_choice
		if(!(role_choice in list(TAT_ROLE_CHOICE_TOWNER, TAT_ROLE_CHOICE_TRADER)))
			return 0
		if(owner_build?.has_built_in_weapon_training())
			return 1
	return get_selected_trait_count(trait_id)

/datum/tat_traits/proc/get_selected_trait_count(trait_id)
	var/value = selected[trait_id]
	if(isnum(value))
		return max(0, round(value))
	return value ? 1 : 0

/datum/tat_traits/proc/has_trait(trait_id)
	return get_trait_count(trait_id) > 0

/datum/tat_traits/proc/get_external_traits()
	var/list/result = list()
	var/datum/species/species = owner_build?.owner_preferences?.pref_species
	if(species && islist(species.inherent_traits))
		for(var/trait_id in species.inherent_traits)
			if(check_trait(trait_id))
				result[trait_id] = TRUE

	var/list/active_virtues = owner_build?.get_active_virtues()
	var/list/virtues = islist(active_virtues) ? active_virtues.Copy() : list()
	var/datum/virtue/origin = owner_build?.owner_preferences?.virtue_origin
	if(origin && !(origin in virtues))
		virtues += origin
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

		var/list/choice_rules = GLOB.tat_virtue_choice_trait_rules
		if(!islist(choice_rules) || !LAZYLEN(virtue.picked_choices))
			continue

		for(var/virtue_rule in choice_rules)
			if(!owner_build?.skills?.virtue_matches_rule(virtue, virtue_rule))
				continue

			var/list/choice_trait_map = choice_rules[virtue_rule]
			if(!islist(choice_trait_map))
				continue

			for(var/choice in virtue.picked_choices)
				var/list/choice_traits = choice_trait_map[choice]
				if(!islist(choice_traits))
					continue

				for(var/trait_id in choice_traits)
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
	var/role_trait = owner_build?.directions?.get_effective_role_trait()
	if(role_trait)
		result[role_trait] = 1

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
	return 0

/datum/tat_traits/proc/get_base_cost(trait_id)
	var/list/entry = get_entry(trait_id)
	if(!islist(entry))
		return 0
	return round((isnum(entry["cost"]) ? entry["cost"] : 0))

/datum/tat_traits/proc/get_oddity_direction_point_bonus(trait_id)
	if(!owner_build?.directions?.is_direction_trait(trait_id))
		return 0
	if(owner_build.directions.get_trait_direction(trait_id) != TAT_DIRECTION_ORDINARY)
		return 0
	var/list/entry = get_entry(trait_id)
	if(!islist(entry))
		return 0
	var/cost = get_base_cost(trait_id)
	if(cost >= 0)
		return 0
	return min(4, max(1, -cost))

/datum/tat_traits/proc/get_ordinary_trait_group(trait_id)
	if(get_oddity_direction_point_bonus(trait_id) > 0)
		return "negative"
	return "neutral"

/datum/tat_traits/proc/get_negative_oddity_direction_points()
	var/total = 0
	for(var/trait_id in selected)
		var/bonus = get_oddity_direction_point_bonus(trait_id)
		if(bonus > 0)
			total += bonus * get_trait_count(trait_id)
	return total

/datum/tat_traits/proc/get_bonus_direction_points()
	var/negative_bonus = 0
	var/rule_total = 0
	var/list/rules = GLOB.tat_trait_direction_point_rules
	for(var/trait_id in selected)
		var/bonus = get_oddity_direction_point_bonus(trait_id)
		if(bonus > 0)
			negative_bonus += bonus * get_trait_count(trait_id)
		var/rule_bonus = round(rules[trait_id] || 0)
		if(rule_bonus > 0)
			rule_total += rule_bonus * get_trait_count(trait_id)
	return min(negative_bonus, TAT_NEGATIVE_DIRECTION_POINT_CAP) + rule_total

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
	if(has_trait(TAT_TRAIT_MENTOR) && (trait_id in list(TRAIT_NOPAINSTUN, TRAIT_CIVILIZEDBARBARIAN)))
		modifier -= max(0, get_base_cost(trait_id))
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
	if(trait_id == TAT_TRAIT_MENTOR && owner_build?.get_owner_ckey() != "mrix")
		return FALSE
	if(is_resident_only_hunter_trait(trait_id) && owner_build?.directions?.get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
		return FALSE
	if(trait_id == TAT_TRAIT_WEAPON_TRAINING && !((owner_build?.directions?.get_role_choice()) in list(TAT_ROLE_CHOICE_TOWNER, TAT_ROLE_CHOICE_TRADER)))
		return FALSE
	if(trait_id == TAT_TRAIT_WEAPON_TRAINING && owner_build?.has_built_in_weapon_training_foundation())
		return FALSE
	if(owner_build?.directions?.is_role_trait(trait_id))
		return FALSE
	if(trait_id == TAT_TRAIT_CONTRACTOR && !owner_build?.can_select_contractor_trait())
		return FALSE
	if(is_contractor_trait_blocked(trait_id))
		return FALSE
	if(trait_id == TAT_TRAIT_BONUS_STAT_POOL && (owner_build?.directions?.foundation != TAT_FOUNDATION_SETTLED || is_wanderer_role_choice(owner_build?.directions?.get_role_choice())))
		return FALSE
	if(trait_id == TAT_TRAIT_TRADER_LICENSE && owner_build?.directions?.get_role_choice() != TAT_ROLE_CHOICE_TRADER)
		return FALSE
	if(owner_build?.directions && !owner_build.directions.can_select_trait(trait_id))
		return FALSE
	var/list/requirements = get_trait_requirement_map()
	var/list/requirement_rule = requirements[trait_id]
	if(islist(requirement_rule) && !trait_requirement_is_met(requirement_rule))
		return FALSE
	var/pq_minimum = get_pq_lock_minimum(trait_id)
	if(pq_minimum > 0 && (owner_build?.get_owner_playerquality() || 0) < pq_minimum)
		return FALSE
	// Virtue-granted flaws are already real character traits. Do not allow buying
	// the same negative TAT trait again just to farm trait points. Positive
	// traits stay buyable: external traits must not satisfy requirement chains.
	if(has_external_trait(trait_id) && get_base_cost(trait_id) < 0)
		return FALSE
	var/list/external_traits = get_external_traits()
	for(var/external_trait_id in external_traits)
		if(are_traits_mutually_exclusive(trait_id, external_trait_id))
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

	if(skill_type == /datum/skill/magic/arcane && has_trait(TAT_TRAIT_SPELLBLADE))
		total += 3
	else if(has_trait(TRAIT_ARCYNE) && skill_type == /datum/skill/magic/arcane)
		total += 3
	if(skill_type == /datum/skill/combat/arcyne && has_trait(TAT_TRAIT_SPELLBLADE))
		total += 2

	if(has_trait(TRAIT_CIVILIZEDBARBARIAN) && (skill_type == /datum/skill/combat/unarmed || skill_type == /datum/skill/combat/wrestling))
		total += 1

	if(has_trait(TAT_TRAIT_MAGE_INITIATE) && !has_trait(TAT_TRAIT_SPELLBLADE) && skill_type == /datum/skill/magic/arcane)
		total += 1

	if(has_trait(TAT_TRAIT_MAGE_INITIATE) && skill_type == /datum/skill/misc/reading)
		total += min(4, max(0, owner_build?.directions?.get_points(TAT_DIRECTION_MAGIC) || 0))

	if(has_trait(TAT_TRAIT_SADDLEBORN) && skill_type == /datum/skill/misc/riding)
		total += 1

	if(has_trait(TAT_TRAIT_DIVINE_INITIATE) && skill_type == /datum/skill/magic/holy)
		total += 1

	var/ranged_points = owner_build?.directions?.get_points(TAT_DIRECTION_RANGED) || 0
	if(ranged_points > 0)
		if(has_trait(TAT_TRAIT_RANGED_SYNERGY_BOWS) && skill_type == /datum/skill/combat/bows)
			total += ranged_points
		if(has_trait(TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS) && skill_type == /datum/skill/combat/crossbows)
			total += ranged_points
		if(has_trait(TAT_TRAIT_RANGED_SYNERGY_SLINGS) && skill_type == /datum/skill/combat/slings)
			total += ranged_points
		if(has_trait(TAT_TRAIT_RANGED_SYNERGY_FIREARMS) && skill_type == /datum/skill/combat/twilight_firearms)
			total += ranged_points

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
		if(has_effective_trait(trait_id))
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
		var/role_choice = owner_build?.directions?.get_role_choice()
		if(role_choice == TAT_ROLE_CHOICE_ADVENTURER || role_choice == TAT_ROLE_CHOICE_WRETCH)
			return 2
		return 1

	if(has_trait(TRAIT_SELF_SUSTENANCE) && (ispath(skill_type, /datum/skill/craft) || ispath(skill_type, /datum/skill/labor)))
		return 1

	if(has_trait(TRAIT_ARCYNE) && skill_type == /datum/skill/magic/arcane)
		return 1

	var/list/rules = GLOB.tat_trait_skill_discount_rules
	for(var/trait_id in selected)
		var/list/discounted = rules[trait_id]
		if(!islist(discounted) || !(skill_type in discounted))
			continue
		if(ispath(skill_type, /datum/skill/combat))
			return 0
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
		if(owner_build?.directions?.is_direction_trait(trait_id))
			continue
		var/cost = get_display_cost(trait_id) * get_trait_count(trait_id)
		if(is_capped_negative_credit_trait(trait_id) && cost < 0)
			capped_negative_credit += -cost
			continue
		total += cost
	total -= min(capped_negative_credit, TAT_NEGATIVE_TRAIT_CREDIT_CAP)
	return total

/datum/tat_traits/proc/get_remaining_points()
	return 0

/datum/tat_traits/proc/get_trait_conflict_map()
	if(length(GLOB.tat_trait_conflict_map))
		return GLOB.tat_trait_conflict_map
	GLOB.tat_trait_conflict_map = list(
		TAT_TRAIT_RESIDENT = list(TRAIT_NOPAINSTUN, TRAIT_OUTLANDER, TAT_TRAIT_WANTED, TAT_TRAIT_MASTER_OF_WANDERING, TRAIT_STRONGBITE, TAT_TRAIT_TRADER_LICENSE, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST, TRAIT_HEAVYARMOR, TRAIT_MEDIUMARMOR, TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_SAVAGE_RAGE, TAT_TRAIT_BERSERKER_RAGE, TRAIT_RITUALIST, TRAIT_CIVILIZEDBARBARIAN, TRAIT_CRITICAL_RESISTANCE),
		TAT_TRAIT_TRADER_LICENSE = list(TAT_TRAIT_RESIDENT),
		TRAIT_OUTLANDER = list(TAT_TRAIT_WANTED, TRAIT_RITUALIST),
		TAT_TRAIT_WANTED = list(TRAIT_OUTLANDER, TAT_TRAIT_RESIDENT, TRAIT_TECHNOPHOBE),
		TAT_TRAIT_CONTRACTOR = list(TRAIT_OUTLANDER, TAT_TRAIT_WANTED, TAT_TRAIT_HERETIC, TAT_TRAIT_RESIDENT, TAT_TRAIT_TRADER_LICENSE, TAT_TRAIT_WARRIOR_EXPERT, TRAIT_PARRYEXPERT, TRAIT_DODGEEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TRAIT_CIVILIZEDBARBARIAN),
		TRAIT_DODGEEXPERT = list(TRAIT_PARRYEXPERT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TRAIT_HEAVYARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_DIVINE_BOON_1, , TAT_TRAIT_DIVINE_BOON_2,TAT_TRAIT_MAGE_INITIATE, TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER),
		TRAIT_MEDIUMARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MAJOR_SLOT, TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TAT_TRAIT_SOUNDBREAKER),
		TAT_TRAIT_TROPHY_BOUNTY = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST),
		TAT_TRAIT_SOUNDBREAKER = list(TAT_TRAIT_RONIN, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_1, TRAIT_CRITICAL_RESISTANCE),
		TAT_TRAIT_RONIN = list(TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_1, TRAIT_CRITICAL_RESISTANCE),
		TAT_TRAIT_SPELLBLADE = list(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLFIST, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_SPELLFIST = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TRAIT_CIVILIZEDBARBARIAN = list(TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_EXPERT_ARMAMENT = list(TAT_TRAIT_WARRIOR_EXPERT),
		TAT_TRAIT_HANDICRAFT_APPRENTICE = list(TAT_TRAIT_MASTER_OF_CRAFTING),
		TAT_TRAIT_STRAYING_SOUL_APPRENTICE = list(TAT_TRAIT_STRAYING_SOUL),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list(TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST, TAT_TRAIT_RONIN, TAT_TRAIT_DIVINE_BOON_3),
		TAT_TRAIT_MAGE_MAJOR_SLOT = list(TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST),
		TAT_TRAIT_DIVINE_BOON_3 = list(TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_UTILITY_SLOT),
		TRAIT_CRITICAL_RESISTANCE = list(TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_INITIATE, TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT),
		TAT_TRAIT_WARRIOR_EXPERT = list(TAT_TRAIT_SPELLBLADE, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT, TRAIT_HEAVYARMOR),
		TAT_TRAIT_WITCH_INITIATE = list(TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_WANTED, TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR),
		TAT_TRAIT_WARRIOR_MASTER = list(TRAIT_DODGEEXPERT, TRAIT_PARRYEXPERT, TRAIT_CRITICAL_RESISTANCE, TRAIT_MEDIUMARMOR, TRAIT_HEAVYARMOR, TAT_TRAIT_RONIN,TRAIT_FENCERDEXTERITY, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_INITIATE),
		TAT_TRAIT_RANGED_SYNERGY_BOWS = list(TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS, TAT_TRAIT_RANGED_SYNERGY_SLINGS, TAT_TRAIT_RANGED_SYNERGY_FIREARMS),
		TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS = list(TAT_TRAIT_RANGED_SYNERGY_BOWS, TAT_TRAIT_RANGED_SYNERGY_SLINGS, TAT_TRAIT_RANGED_SYNERGY_FIREARMS),
		TAT_TRAIT_RANGED_SYNERGY_SLINGS = list(TAT_TRAIT_RANGED_SYNERGY_BOWS, TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS, TAT_TRAIT_RANGED_SYNERGY_FIREARMS),
		TAT_TRAIT_RANGED_SYNERGY_FIREARMS = list(TAT_TRAIT_RANGED_SYNERGY_BOWS, TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS, TAT_TRAIT_RANGED_SYNERGY_SLINGS),
		TAT_TRAIT_HUNTER_BEATER = list(TAT_TRAIT_HUNTER_SHOOTER, TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER),
		TAT_TRAIT_HUNTER_SHOOTER = list(TAT_TRAIT_HUNTER_BEATER, TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER),
		TAT_TRAIT_BODYBUILDER_SKIN = list(TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_SAVAGE_RAGE, TAT_TRAIT_BERSERKER_RAGE),
		TAT_TRAIT_SAVAGE_RAGE = list(TAT_TRAIT_BERSERKER_RAGE, TAT_TRAIT_BODYBUILDER_SKIN),
		TRAIT_EASYDISMEMBER = list(TRAIT_HARDDISMEMBER),
		TRAIT_FENCERDEXTERITY = list(TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_BODYBUILDER_SKIN, TAT_TRAIT_WARRIOR_MASTER),
		TRAIT_NUDIST = list(TRAIT_SHIRTLESS),
		TRAIT_SHIRTLESS = list(TRAIT_NUDIST),
		TRAIT_NUDE_SLEEPER = list(TRAIT_NUDIST, TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_BODYBUILDER_SKIN, TRAIT_NOSLEEP),
		TRAIT_NOSLEEP = list(TRAIT_RITUALIST),
		TRAIT_NOPAINSTUN = list(TAT_TRAIT_MAGE_INITIATE),
		TRAIT_BOMBER_EXPERT = list(TAT_TRAIT_WARRIOR_EXPERT,)
	)
	return GLOB.tat_trait_conflict_map

/datum/tat_traits/proc/get_trait_requirement_map()
	if(length(GLOB.tat_trait_requirement_map))
		return GLOB.tat_trait_requirement_map
	GLOB.tat_trait_requirement_map = list(
		TAT_TRAIT_WEAPON_TRAINING = list("role_choices" = list(TAT_ROLE_CHOICE_TOWNER, TAT_ROLE_CHOICE_TRADER), "message" = "\"[get_trait_display_name(TAT_TRAIT_WEAPON_TRAINING)]\" requires Resident or Trader role."),
		TAT_TRAIT_WARRIOR_EXPERT = list("all_by_role_choice" = list(TAT_ROLE_CHOICE_TOWNER = list(TAT_TRAIT_WEAPON_TRAINING), TAT_ROLE_CHOICE_TRADER = list(TAT_TRAIT_WEAPON_TRAINING)), "message" = "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_EXPERT)]\" requires \"[get_trait_display_name(TAT_TRAIT_WEAPON_TRAINING)]\" for Resident and Trader roles."),
		TAT_TRAIT_WARRIOR_MASTER = list("all" = list(TAT_TRAIT_WARRIOR_EXPERT), "message" = "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_MASTER)]\" requires \"[get_trait_display_name(TAT_TRAIT_WARRIOR_EXPERT)]\"."),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list("all" = list(TAT_TRAIT_BARDIC_INSPIRATION_T1), "message" = "\"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T2)]\" requires \"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T1)]\"."),
		TAT_TRAIT_SPELLBLADE = list("all" = list(TAT_TRAIT_MAGE_INITIATE, TRAIT_ARCYNE), "message" = "\"[get_trait_display_name(TAT_TRAIT_SPELLBLADE)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\" and \"[get_trait_display_name(TRAIT_ARCYNE)]\"."),
		TAT_TRAIT_SPELLFIST = list("all" = list(TRAIT_CIVILIZEDBARBARIAN, TAT_TRAIT_MAGE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_SPELLFIST)]\" requires \"[get_trait_display_name(TRAIT_CIVILIZEDBARBARIAN)]\" and \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."),
		TAT_TRAIT_EXPERT_ARMAMENT = list("any" = list(TRAIT_ARCYNE, TAT_TRAIT_MAGE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_EXPERT_ARMAMENT)]\" requires \"[get_trait_display_name(TRAIT_ARCYNE)]\" or \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."),
		TAT_TRAIT_HANDICRAFT_APPRENTICE = list("role_choices" = list(TAT_ROLE_CHOICE_ADVENTURER, TAT_ROLE_CHOICE_WRETCH), "message" = "\"[get_trait_display_name(TAT_TRAIT_HANDICRAFT_APPRENTICE)]\" requires Adventurer or Wretch role."),
		TAT_TRAIT_STRAYING_SOUL_APPRENTICE = list("role_choices" = list(TAT_ROLE_CHOICE_ADVENTURER, TAT_ROLE_CHOICE_WRETCH), "message" = "\"[get_trait_display_name(TAT_TRAIT_STRAYING_SOUL_APPRENTICE)]\" requires Adventurer or Wretch role."),
		TAT_TRAIT_MAGE_MINOR_SLOT_1 = list("all" = list(TAT_TRAIT_MAGE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_1)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."),
		TAT_TRAIT_MAGE_MINOR_SLOT_2 = list("all" = list(TAT_TRAIT_MAGE_MINOR_SLOT_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_2)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_1)]\"."),
		TAT_TRAIT_MAGE_MAJOR_SLOT = list("all" = list(TAT_TRAIT_MAGE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MAJOR_SLOT)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."),
		TAT_TRAIT_MAGE_UTILITY_SLOT = list("all" = list(TAT_TRAIT_MAGE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_UTILITY_SLOT)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\"."),
		TAT_TRAIT_DIVINE_BOON_1 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_1)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_INITIATE)]\"."),
		TAT_TRAIT_DIVINE_BOON_2 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_2)]\" requires previous divine progression."),
		TAT_TRAIT_DIVINE_BOON_3 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_2), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\" requires previous divine progression."),
		TAT_TRAIT_DIVINE_BLAST = list("all" = list(TAT_TRAIT_DIVINE_BOON_3), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BLAST)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\"."),
		TRAIT_RITUALIST = list("all" = list(TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TRAIT_RITUALIST)]\" requires \"[get_trait_display_name(TAT_TRAIT_HERETIC)]\"."),
		TAT_TRAIT_ARTIFACTS_SUPPLIER = list("all" = list(TAT_TRAIT_PARTY_LEADER), "message" = "\"[get_trait_display_name(TAT_TRAIT_ARTIFACTS_SUPPLIER)]\" requires \"[get_trait_display_name(TAT_TRAIT_PARTY_LEADER)]\"."),
		TAT_TRAIT_SILVER_SUPPLIER = list("all" = list(TRAIT_PURITAN_ADVENTURER), "message" = "\"[get_trait_display_name(TAT_TRAIT_SILVER_SUPPLIER)]\" requires \"[get_trait_display_name(TRAIT_PURITAN_ADVENTURER)]\"."),
		TAT_TRAIT_SAVAGE_SKIN = list("all" = list(TRAIT_NOPAINSTUN), "message" = "\"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\" requires \"[get_trait_display_name(TRAIT_NOPAINSTUN)]\"."),
		TAT_TRAIT_BODYBUILDER_SKIN = list("role_choice" = TAT_ROLE_CHOICE_TOWNER, "message" = "\"[get_trait_display_name(TAT_TRAIT_BODYBUILDER_SKIN)]\" requires Resident."),
		TRAIT_STRONGBITE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN), "message" = "\"[get_trait_display_name(TRAIT_STRONGBITE)]\" requires \"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\"."),
		TAT_TRAIT_SAVAGE_RAGE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN), "message" = "\"[get_trait_display_name(TAT_TRAIT_SAVAGE_RAGE)]\" requires \"[get_trait_display_name(TAT_TRAIT_SAVAGE_SKIN)]\"."),
		TAT_TRAIT_BERSERKER_RAGE = list("all" = list(TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TAT_TRAIT_BERSERKER_RAGE)]\" requires savage skin and heretic."),
		TAT_TRAIT_HUNTER_BEATER = list("all" = list(TRAIT_OUTDOORSMAN), "role_choice" = TAT_ROLE_CHOICE_TOWNER, "message" = "\"[get_trait_display_name(TAT_TRAIT_HUNTER_BEATER)]\" requires Resident and \"[get_trait_display_name(TRAIT_OUTDOORSMAN)]\"."),
		TAT_TRAIT_HUNTER_SHOOTER = list("all" = list(TRAIT_OUTDOORSMAN), "role_choice" = TAT_ROLE_CHOICE_TOWNER, "message" = "\"[get_trait_display_name(TAT_TRAIT_HUNTER_SHOOTER)]\" requires Resident and \"[get_trait_display_name(TRAIT_OUTDOORSMAN)]\"."),
		TAT_TRAIT_LOOTRAT_2 = list("all" = list(TAT_TRAIT_TRADER_LICENSE, TAT_TRAIT_LOOTRAT), "foundation" = TAT_FOUNDATION_SETTLED, "role_choice" = TAT_ROLE_CHOICE_TRADER, "message" = "\"[get_trait_display_name(TAT_TRAIT_LOOTRAT_2)]\" requires \"[get_trait_display_name(TAT_TRAIT_TRADER_LICENSE)]\", \"[get_trait_display_name(TAT_TRAIT_LOOTRAT)]\", and Trader role."),
		TRAIT_BOMBER_EXPERT = list("all" = list(TRAIT_EXPLOSIVE_SUPPLY), "message" = "\"[get_trait_display_name(TRAIT_BOMBER_EXPERT)]\" requires \"[get_trait_display_name(TRAIT_EXPLOSIVE_SUPPLY)]\"."),
	)
	return GLOB.tat_trait_requirement_map

/datum/tat_traits/proc/trait_requirement_is_met(list/rule)
	if(!islist(rule))
		return TRUE
	var/required_foundation = rule["foundation"]
	if(required_foundation && owner_build?.directions?.foundation != required_foundation)
		return FALSE
	var/required_role_choice = rule["role_choice"]
	if(required_role_choice && owner_build?.directions?.get_role_choice() != required_role_choice)
		return FALSE
	var/list/required_role_choices = rule["role_choices"]
	if(islist(required_role_choices) && !((owner_build?.directions?.get_role_choice()) in required_role_choices))
		return FALSE
	var/list/all_requirements = rule["all"]
	if(islist(all_requirements))
		for(var/required_trait in all_requirements)
			if(!has_trait(required_trait))
				return FALSE
	var/list/any_requirements = rule["any"]
	if(islist(any_requirements) && length(any_requirements))
		var/has_any_requirement = FALSE
		for(var/required_trait in any_requirements)
			if(has_trait(required_trait))
				has_any_requirement = TRUE
				break
		if(!has_any_requirement)
			return FALSE
	var/list/all_by_role_choice = rule["all_by_role_choice"]
	if(islist(all_by_role_choice))
		var/list/role_requirements = all_by_role_choice[owner_build?.directions?.get_role_choice()]
		if(islist(role_requirements))
			for(var/required_trait in role_requirements)
				if(!has_trait(required_trait))
					return FALSE
	return TRUE

/datum/tat_traits/proc/get_trait_requirement_block_reason(trait_id)
	var/list/requirements = get_trait_requirement_map()
	var/list/rule = requirements[trait_id]
	if(!islist(rule) || trait_requirement_is_met(rule))
		return null
	return rule["message"] || "Trait has unmet requirements."

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

/datum/tat_traits/proc/has_full_heretic_unlock()
	return has_trait(TAT_TRAIT_HERETIC) && !has_trait(TAT_TRAIT_RESIDENT)

/datum/tat_traits/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if(!trait_a || !trait_b || trait_a == trait_b)
		return null

	if(has_trait(TAT_TRAIT_WANTED))
		if((trait_a == TRAIT_NOPAINSTUN && (trait_b == TAT_TRAIT_MAGE_INITIATE || trait_b == TAT_TRAIT_DIVINE_BOON_2)) || (trait_b == TRAIT_NOPAINSTUN && (trait_a == TAT_TRAIT_MAGE_INITIATE || trait_a == TAT_TRAIT_DIVINE_BOON_2)))
			return null
	if((trait_a == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_b == TAT_TRAIT_DIVINE_BOON_1) || (trait_b == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_a == TAT_TRAIT_DIVINE_BOON_1))
		if(owner_build?.directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
			return null
		if(owner_build?.directions?.get_role_choice() == TAT_ROLE_CHOICE_TOWNER && has_trait(TAT_TRAIT_WITCH_INITIATE))
			return null
	if(owner_build?.directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
		if((trait_a == TAT_TRAIT_SPELLBLADE && trait_b == TAT_TRAIT_DIVINE_BOON_1) || (trait_b == TAT_TRAIT_SPELLBLADE && trait_a == TAT_TRAIT_DIVINE_BOON_1))
			return null
		if((trait_a == TAT_TRAIT_WARRIOR_EXPERT && trait_b == TAT_TRAIT_MAGE_MINOR_SLOT_1) || (trait_b == TAT_TRAIT_WARRIOR_EXPERT && trait_a == TAT_TRAIT_MAGE_MINOR_SLOT_1))
			return null
		if((trait_a == TAT_TRAIT_WARRIOR_EXPERT && trait_b == TRAIT_HEAVYARMOR) || (trait_b == TAT_TRAIT_WARRIOR_EXPERT && trait_a == TRAIT_HEAVYARMOR))
			return null
		if((trait_a == TRAIT_MEDIUMARMOR && trait_b == TAT_TRAIT_DIVINE_BOON_2) || (trait_b == TRAIT_MEDIUMARMOR && trait_a == TAT_TRAIT_DIVINE_BOON_2))
			return null
		if((trait_a == TRAIT_HEAVYARMOR && trait_b == TAT_TRAIT_DIVINE_BOON_1) || (trait_b == TRAIT_HEAVYARMOR && trait_a == TAT_TRAIT_DIVINE_BOON_1))
			return null
		if((trait_a == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_b == TAT_TRAIT_DIVINE_BOON_2) || (trait_b == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_a == TAT_TRAIT_DIVINE_BOON_2))
			return null
		if((trait_a == TAT_TRAIT_WARRIOR_EXPERT && trait_b == TAT_TRAIT_SPELLBLADE) || (trait_b == TAT_TRAIT_WARRIOR_EXPERT && trait_a == TAT_TRAIT_SPELLBLADE))
			return null
		if((trait_a == TAT_TRAIT_DIVINE_BOON_1 && trait_b == TRAIT_HEAVYARMOR) || (trait_b == TAT_TRAIT_DIVINE_BOON_1 && trait_a == TRAIT_HEAVYARMOR))
			return null

	var/list/conflicts = get_trait_conflict_map()
	var/list/a_conflicts = conflicts[trait_a]
	if(islist(a_conflicts) && (trait_b in a_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."
	var/list/b_conflicts = conflicts[trait_b]
	if(islist(b_conflicts) && (trait_a in b_conflicts))
		return "\"[get_trait_display_name(trait_a)]\" conflicts with \"[get_trait_display_name(trait_b)]\"."
	if(((trait_a == TAT_TRAIT_DIVINE_BOON_3 || trait_b == TAT_TRAIT_DIVINE_BOON_3) && has_defensive_trait_lockout()) && !(has_full_heretic_unlock() || has_trait(TAT_TRAIT_WANTED)))
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
	return clamp(tier, CLERIC_T0, CLERIC_T3)

/datum/tat_traits/proc/get_divine_passive_gain_for_tier(cleric_tier)
	if(cleric_tier >= CLERIC_T1)
		return CLERIC_REGEN_MINOR
	return CLERIC_REGEN_WITCH

/datum/tat_traits/proc/get_divine_devotion_limit_for_tier(cleric_tier)
	var/cap_offset = has_trait(TAT_TRAIT_RESIDENT) ? 10 : 20
	switch(cleric_tier)
		if(CLERIC_T4)
			return max(CLERIC_REQ_3, CLERIC_REQ_4 - cap_offset)
		if(CLERIC_T3)
			return max(CLERIC_REQ_2, CLERIC_REQ_3 - cap_offset)
		if(CLERIC_T2)
			return max(CLERIC_REQ_1, CLERIC_REQ_2 - cap_offset)
	return max(CLERIC_REQ_0, CLERIC_REQ_1 - cap_offset)

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
	return (owner_build?.directions?.get_points(TAT_DIRECTION_MAGIC) || 0) > 0

/datum/tat_traits/proc/can_train_holy()
	if(!has_trait(TAT_TRAIT_DIVINE_INITIATE) && !has_trait(TAT_TRAIT_DIVINE_BOON_1) && !has_trait(TAT_TRAIT_DIVINE_BOON_2) && !has_trait(TAT_TRAIT_DIVINE_BOON_3))
		return FALSE
	return (owner_build?.directions?.get_points(TAT_DIRECTION_MIRACLES) || 0) > 0

/datum/tat_traits/proc/can_train_druidic()
	return TRUE

/datum/tat_traits/proc/sanitize()
	for(var/trait_id in selected.Copy())
		if(owner_build?.directions?.is_direction_trait(trait_id))
			var/direction = owner_build.directions.get_trait_direction(trait_id)
			if(!owner_build.directions.trait_requirements_met(trait_id) || owner_build.directions.get_remaining_trait_points(direction) < 0)
				selected -= trait_id
				continue
		if(!can_select_trait(trait_id))
			selected -= trait_id
			continue
		var/count = get_trait_count(trait_id)
		var/maximum = get_trait_maximum(trait_id)
		if(count <= 0)
			selected -= trait_id
		else if(is_repeatable_trait(trait_id) && count > maximum)
			selected[trait_id] = maximum
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

/*
/datum/tat_traits/proc/apply_resident_pugilist_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TRAIT_CIVILIZEDBARBARIAN))
		return
	var/spell_type = owner_build?.get_resident_pugilist_spell_type(owner_build?.get_resident_pugilist_spell_choice(H))
	if(spell_type)
		owner_build?.grant_mind_spell_if_missing(H, spell_type)
*/

/datum/tat_traits/proc/apply_divine_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_DIVINE_INITIATE))
		return
	var/cleric_tier = get_effective_divine_tier()
	var/passive_gain = get_divine_passive_gain_for_tier(cleric_tier)
	var/devotion_limit = get_divine_devotion_limit_for_tier(cleric_tier)
	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = cleric_tier, passive_gain = passive_gain, devotion_limit = devotion_limit)
	H.adjust_skillrank_up_to(/datum/skill/magic/holy, max(1, owner_build?.get_skill_value(/datum/skill/magic/holy) || 1), TRUE)
	switch(H.patron?.type)
		if(/datum/patron/divine/abyssor)
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/xylix)
			H.grant_language(/datum/language/tricksterscant)
		if(/datum/patron/inhumen/zizo)
			if(cleric_tier >= CLERIC_T2)
				H.grant_language(/datum/language/undead)
			else
				// Patron.on_gain grants this at conversion; TAT keeps it gated behind T2 miracles.
				H.remove_language(/datum/language/undead)
	if(H.patron?.type == /datum/patron/inhumen/zizo && cleric_tier >= CLERIC_T2)
		owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/minion_order)
		owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/gravemark)
	if(has_trait(TAT_TRAIT_DIVINE_BLAST))
		if(istype(H.patron, /datum/patron/divine))
			owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/projectile/divine_blast)
		else if(istype(H.patron, /datum/patron/inhumen))
			owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/projectile/unholy_blast)

/datum/tat_traits/proc/apply_mage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_MAGE_INITIATE) || !H.mind)
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	var/list/aspects = build_mage_aspects(TRUE)
	H.mind.setup_mage_aspects(aspects)
	owner_build?.set_magic_value("mage_aspects", aspects.Copy())
	// Spellbook/chalk are synchronized into the TAT loadout stash by /datum/tat_items.

/datum/tat_traits/proc/apply_accursed_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_ACCURSED))
		return
	H.mind.AddComponent(/datum/component/night_form)

/datum/tat_traits/proc/apply_witch_base_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_WITCH_INITIATE))
		return
	ADD_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)
	ADD_TRAIT(H, TRAIT_DEATHSIGHT, TAT_TRAIT_SOURCE)

/datum/tat_traits/proc/get_available_witch_paths()
	var/list/paths = list()
	if(!has_trait(TAT_TRAIT_WITCH_INITIATE))
		return paths
	if(owner_build?.directions?.get_role_choice() != TAT_ROLE_CHOICE_TOWNER)
		return paths
	var/magic_points = owner_build?.directions?.get_points(TAT_DIRECTION_MAGIC) || 0
	var/miracle_points = owner_build?.directions?.get_points(TAT_DIRECTION_MIRACLES) || 0
	if(magic_points >= 2)
		paths += TAT_WITCH_PATH_OLD_MAGICK
	if(miracle_points >= 2)
		paths += TAT_WITCH_PATH_GODSBLOOD
	if(magic_points >= 1 && miracle_points >= 1)
		paths += TAT_WITCH_PATH_MYSTAGOGUE
	return paths

/datum/tat_traits/proc/get_witch_path_choice(mob/living/carbon/human/H)
	var/list/paths = get_available_witch_paths()
	if(!length(paths))
		return null
	var/stored_path = owner_build?.get_magic_value("witch_path")
	if(stored_path in paths)
		return stored_path
	if(length(paths) == 1)
		return paths[1]
	if(H?.client)
		var/path_choice = tgui_input_list(H, "How do your powers manifest?", "THE OLD WAYS", paths)
		if(path_choice in paths)
			return path_choice
	return paths[1]

/datum/tat_traits/proc/apply_witch_path_package(mob/living/carbon/human/H)
	if(!H || !H.mind || !has_trait(TAT_TRAIT_WITCH_INITIATE))
		return
	var/path_choice = get_witch_path_choice(H)
	if(!path_choice)
		owner_build?.set_magic_value("witch_path", null)
		return
	owner_build?.set_magic_value("witch_path", path_choice)
	var/datum/devotion/D
	var/list/aspects
	switch(path_choice)
		if(TAT_WITCH_PATH_OLD_MAGICK)
			ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, max(1, owner_build?.get_skill_value(/datum/skill/magic/arcane) || 1), TRUE)
			aspects = list("mastery" = FALSE, "major" = 1, "minor" = 1, "utilities" = 5, "ward" = TRUE)
			H.mind.setup_mage_aspects(aspects)
			owner_build?.set_magic_value("mage_aspects", aspects.Copy())
		if(TAT_WITCH_PATH_GODSBLOOD)
			if(H.devotion)
				qdel(H.devotion)
			D = new /datum/devotion(H, H.patron)
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, max(1, owner_build?.get_skill_value(/datum/skill/magic/holy) || 1), TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_2)
			D.max_devotion *= 0.5
		if(TAT_WITCH_PATH_MYSTAGOGUE)
			if(H.devotion)
				qdel(H.devotion)
			D = new /datum/devotion(H, H.patron)
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, max(1, owner_build?.get_skill_value(/datum/skill/magic/holy) || 1), TRUE)
			D.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
			D.max_devotion *= 0.5
			ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, max(1, owner_build?.get_skill_value(/datum/skill/magic/arcane) || 1), TRUE)
			aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3)
			H.mind.setup_mage_aspects(aspects)
			owner_build?.set_magic_value("mage_aspects", aspects.Copy())
			grant_poke_spell(H)

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

/datum/tat_traits/proc/apply_spellfist_base_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SPELLFIST))
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TAT_TRAIT_SOURCE)

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
	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = lowertext(subclass_selected)
	switch(subclass_selected)
		if("Blade")
			H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
			H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
			H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
			H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
		if("Phalangite")
			H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
			H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
			H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
		if("Macebearer")
			H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
			H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
			H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
			H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
	H.mind.setup_mage_aspects(build_mage_aspects(FALSE))
	H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
	H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

/datum/tat_traits/proc/apply_spellfist_specialization_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SPELLFIST))
		return
	if(!H.mind)
		return

	to_chat(H, span_warning("You channel arcyne momentum through your fists. Build momentum with unarmed strikes, then release it through Spellfist techniques."))
	H.mind.setup_mage_aspects(build_mage_aspects(FALSE))
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/fist_of_psydon)
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/grasp_of_psydon)
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/blink/shadowstep)
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/storm_of_psydon)
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/empower_weapon)
	owner_build?.grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/mending)

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

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
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		roles["Spellblade"] = 800000
	if(has_trait(TAT_TRAIT_SPELLFIST))
		roles["Spellfist"] = 800000
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
	else if(has_trait(TAT_TRAIT_RESIDENT))
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

	if(!has_trait(TAT_TRAIT_WANTED))
		var/skin_path_1 = /obj/item/clothing/suit/roguetown/armor/manual/resting/chest/barbarian
		var/skin_path_2 = /obj/item/clothing/suit/roguetown/armor/manual/pushups/barbarian
		owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path_1, SLOT_ARMOR)
		owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path_2, SLOT_SHIRT)
	else
		var/skin_path_1 = /obj/item/clothing/suit/roguetown/armor/manual/resting/chest/berzerker
		var/skin_path_2 = /obj/item/clothing/suit/roguetown/armor/manual/resting/body/berzerker
		owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path_1, SLOT_ARMOR)
		owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path_2, SLOT_SHIRT)
	return TRUE

/datum/tat_traits/proc/apply_bodybuilder_skin_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_BODYBUILDER_SKIN))
		return FALSE

	var/skin_path = /obj/item/clothing/suit/roguetown/armor/manual/tool/needle/body/disciple
	owner_build.items.spawn_item_to_exact_slot_or_bag(H, skin_path, SLOT_ARMOR)
	return TRUE

/datum/tat_traits/proc/apply_savage_rage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SAVAGE_RAGE) || !H.mind)
		return FALSE
	if(owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/self/rage))
		return TRUE
	if(!owner_build)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		return TRUE
	return FALSE

/datum/tat_traits/proc/apply_berserker_rage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_BERSERKER_RAGE) || !H.mind)
		return FALSE
	if(owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/self/rage))
		ADD_TRAIT(H, TRAIT_RAGE, TAT_TRAIT_SOURCE)
		return TRUE
	if(!owner_build)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
		ADD_TRAIT(H, TRAIT_RAGE, TAT_TRAIT_SOURCE)
		return TRUE
	return FALSE

/datum/tat_traits/proc/get_polyglot_language_choices(mob/living/carbon/human/H)
	var/static/list/selectable_languages = list(
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/raneshi,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/lingyuese,
		/datum/language/gyedzenese,
		/datum/language/valorian,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/otavan,
		/datum/language/aavnic,
		/datum/language/undercommon,
	)
	var/list/choices = list()
	for(var/language_type in selectable_languages)
		if(H?.has_language(language_type))
			continue
		var/datum/language/language = new language_type()
		if(language?.name)
			choices[language.name] = language_type
		qdel(language)
	return choices

/datum/tat_traits/proc/apply_polyglot_package(mob/living/carbon/human/H)
	if(!H?.client || !has_trait(TAT_TRAIT_POLYGLOT))
		return FALSE

	var/list/choices = get_polyglot_language_choices(H)
	if(!length(choices))
		to_chat(H, span_notice("I already know every language my Polyglot training could teach me."))
		return FALSE

	var/chosen_language = tgui_input_list(H, "Choose one additional language to learn.", "Polyglot", choices)
	var/language_type = choices[chosen_language]
	if(!language_type)
		return FALSE

	H.grant_language(language_type)
	to_chat(H, span_notice("My Polyglot training lets me speak [chosen_language]."))
	return TRUE

/datum/tat_traits/proc/apply_instant_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/trait_id in selected)
		if(is_repeatable_trait(trait_id))
			continue
		switch(trait_id)
			if(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER, TAT_TRAIT_WEAPON_TRAINING, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_RESIDENT, TAT_TRAIT_STEEL_SUPPLIER, TAT_TRAIT_SILVER_SUPPLIER, TAT_TRAIT_BRONZE_SUPPLIER, TAT_TRAIT_LEATHER_SUPPLIER, TAT_TRAIT_MAIL_SUPPLIER, TAT_TRAIT_PLATE_SUPPLIER, TAT_TRAIT_RANGED_SUPPLIER, TAT_TRAIT_RANGED_SYNERGY_BOWS, TAT_TRAIT_RANGED_SYNERGY_CROSSBOWS, TAT_TRAIT_RANGED_SYNERGY_SLINGS, TAT_TRAIT_RANGED_SYNERGY_FIREARMS, TAT_TRAIT_HUNTER_BEATER, TAT_TRAIT_HUNTER_SHOOTER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_SPELLFIST, TAT_TRAIT_EXPERT_ARMAMENT, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2, TAT_TRAIT_PARTY_LEADER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WANTED, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BLAST, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_WITCH_INITIATE, TAT_TRAIT_CONTRACTOR, TAT_TRAIT_MENTOR, TAT_TRAIT_ARTIFACTS_SUPPLIER, TAT_TRAIT_FIREARMS_SUPPLIER, TAT_TRAIT_TROPHY_BOUNTY, TAT_TRAIT_MASTER_OF_WANDERING, TAT_TRAIT_MASTER_OF_CRAFTING, TAT_TRAIT_STRAYING_SOUL, TAT_TRAIT_HANDICRAFT_APPRENTICE, TAT_TRAIT_STRAYING_SOUL_APPRENTICE, TAT_TRAIT_PLIANT_RENAME, TAT_TRAIT_SAVAGE_SKIN, TAT_TRAIT_BODYBUILDER_SKIN, TAT_TRAIT_SAVAGE_RAGE, TAT_TRAIT_HERETIC, TAT_TRAIT_BERSERKER_RAGE, TAT_TRAIT_LOOTRAT, TRAIT_SHIRTLESS, TAT_TRAIT_LOOTRAT_2, TAT_TRAIT_ACCURSED, TAT_TRAIT_POLYGLOT)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_RONIN))
		H.LoadComponent(/datum/component/combo_core/ronin, RONIN_GATE_DURATION, RONIN_MAX_HISTORY)
	if(has_trait(TAT_TRAIT_SOUNDBREAKER))
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
	if(has_trait(TAT_TRAIT_RESIDENT))
		apply_resident_package(H)
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		apply_spellblade_base_package(H)
	if(has_trait(TAT_TRAIT_SPELLFIST))
		apply_spellfist_base_package(H)
	if(has_trait(TAT_TRAIT_TROPHY_BOUNTY))
		H.LoadComponent(/datum/component/trophy_hunter)
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
	apply_bodybuilder_skin_package(H)
	apply_savage_rage_package(H)
	apply_berserker_rage_package(H)
	if(has_trait(TAT_TRAIT_WARRIOR_MASTER))
		ADD_TRAIT(H, TRAIT_BADTRAINER, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_WANTED))
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_ZURCH, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_HERETIC))
		GLOB.excommunicated_players += H.real_name
	// Abyssor's T1+ path prompt needs the client attached to the new character.
	if(H.patron?.type != /datum/patron/divine/abyssor || get_effective_divine_tier() < CLERIC_T1)
		apply_divine_package(H)
	apply_mage_package(H)
	apply_accursed_package(H)
	if(has_trait(TAT_TRAIT_CONTRACTOR))
		var/contractor_type = text2path("/datum/component/contractor")
		if(contractor_type)
			H.LoadComponent(contractor_type, 0)
	apply_witch_base_package(H)
	if(has_trait(TAT_TRAIT_MENTOR))
		H.LoadComponent(/datum/component/tat_mentor)
	return TRUE

/datum/tat_traits/proc/apply_deferred_to_human(mob/living/carbon/human/H)
	if(!H?.client)
		return FALSE
	if(H.patron?.type == /datum/patron/divine/abyssor && get_effective_divine_tier() >= CLERIC_T1)
		apply_divine_package(H)
//	if(has_trait(TAT_TRAIT_RESIDENT))
		//apply_resident_pugilist_package(H)
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		apply_spellblade_specialization_package(H)
	if(has_trait(TAT_TRAIT_SPELLFIST))
		apply_spellfist_specialization_package(H)
	if(has_trait(TAT_TRAIT_WANTED))
		wretch_select_bounty(H)
	if(has_trait(TAT_TRAIT_SADDLEBORN))
		if(!H.HasSpell(/obj/effect/proc_holder/spell/self/choose_riding_virtue_mount))
			H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
		ADD_TRAIT(H, TRAIT_EQUESTRIAN, TAT_TRAIT_SOURCE)
	apply_witch_path_package(H)
	apply_witch_shapeshift_package(H)
	apply_pliant_title(H)
	apply_polyglot_package(H)
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

/datum/tat_traits/proc/import_trait_count(trait_id, count = 1)
	if(!check_trait(trait_id))
		return FALSE
	count = max(0, round(text2num("[count]") || 0))
	if(count <= 0)
		return FALSE
	if(is_repeatable_trait(trait_id))
		count = min(count, get_trait_maximum(trait_id))
		selected[trait_id] = count
	else
		selected[trait_id] = TRUE
	return TRUE

/datum/tat_traits/proc/import_from_list(list/data)
	reset()
	if(!islist(data))
		return FALSE
	for(var/trait_id in data)
		if(!check_trait(trait_id))
			continue
		import_trait_count(trait_id, data[trait_id])
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
		var/import_count = 1
		if(check_trait(key))
			import_count = isnull(data[key]) ? (get_selected_trait_count(key) + 1) : data[key]
			import_trait_count(key, import_count)
			continue
		if(data[key] && check_trait("[key]"))
			import_count = data[key]
			import_trait_count("[key]", import_count)
			continue
		var/value = data[key]
		if(istext(value) && check_trait(value))
			import_trait_count(value, get_selected_trait_count(value) + 1)
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

/datum/tat_traits/proc/get_tat_resident_advclass_datum(advclass_type)
	RETURN_TYPE(/datum/advclass)
	if(!ispath(advclass_type, /datum/advclass))
		return null

	var/list/all_classes = SSrole_class_handler?.sorted_class_categories?[CTAG_ALLCLASS]
	if(!length(all_classes))
		return null

	for(var/datum/advclass/advclass as anything in all_classes)
		if(advclass.type == advclass_type)
			return advclass

	return null

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
		var/datum/advclass/advclass = get_tat_resident_advclass_datum(resident_advjob_type)
		if(advclass)
			applied_name = get_pliant_safe_class_name(advclass.name, title)
			if(H.mind)
				H.mind.picked_advclass = advclass
		else
			advclass = new resident_advjob_type
			if(advclass)
				applied_name = get_pliant_safe_class_name(advclass.name, title)
				qdel(advclass)

	if(!length(applied_name))
		return

	H.advjob = applied_name

/datum/component/tat_mentor
	var/mob/living/carbon/human/owner
	var/training_enabled = FALSE
	var/list/granted_spells = list()

/datum/component/tat_mentor/Initialize()
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	if(owner.mind)
		for(var/spell_type in list(/datum/action/cooldown/spell/tat_mentor/training_toggle, /datum/action/cooldown/spell/tat_mentor/body_change))
			var/datum/action/cooldown/spell/new_spell = new spell_type
			owner.mind.AddSpell(new_spell)
			granted_spells += new_spell

/datum/component/tat_mentor/Destroy(force)
	for(var/datum/action/cooldown/spell/spell as anything in granted_spells)
		if(QDELETED(spell))
			continue
		owner?.mind?.RemoveSpell(spell)
		if(!QDELETED(spell))
			qdel(spell)
	granted_spells = null
	owner = null
	return ..()

/datum/component/tat_mentor/proc/can_share_training()
	return training_enabled

/datum/action/cooldown/spell/tat_mentor
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "spell_default"
	background_icon = 'icons/mob/actions/roguespells.dmi'
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	panel = "Mentor"
	charge_required = FALSE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/tat_mentor/proc/get_core()
	return owner?.GetComponent(/datum/component/tat_mentor)

/datum/action/cooldown/spell/tat_mentor/can_cast_spell(feedback = TRUE)
	return ..() && !!get_core()

/datum/action/cooldown/spell/tat_mentor/training_toggle
	name = "Training"
	desc = "Toggle sharing skills through intimate actions."
	cooldown_time = 5 SECONDS

/datum/action/cooldown/spell/tat_mentor/training_toggle/cast(atom/cast_on)
	. = ..()
	var/datum/component/tat_mentor/core = get_core()
	if(!core)
		return FALSE
	core.training_enabled = !core.training_enabled
	if(core.training_enabled)
		to_chat(owner, span_notice("You start sharing training through intimate actions."))
	else
		to_chat(owner, span_notice("You stop sharing training."))
	return TRUE

/datum/action/cooldown/spell/tat_mentor/body_change
	name = "Shape Body"
	desc = "Change your own or another nearby body."
	cooldown_time = 5 SECONDS
	click_to_activate = TRUE
	self_cast_possible = TRUE
	cast_range = 1
	aim_assist = TRUE

/datum/action/cooldown/spell/tat_mentor/body_change/is_valid_target(atom/cast_on)
	return ..() && ishuman(cast_on)

/datum/action/cooldown/spell/tat_mentor/body_change/cast(atom/cast_on)
	. = ..()
	if(!get_core() || !ishuman(cast_on))
		return FALSE
	return perform_tat_mentor_mirror_transform(owner, cast_on)

/proc/perform_tat_mentor_mirror_transform(mob/living/carbon/human/editor, mob/living/carbon/human/H)
	if(!editor || !H)
		return FALSE
	if(QDELETED(editor) || QDELETED(H))
		return FALSE

	var/should_update = FALSE
	var/list/choices = list("Accessory", "Breast Quantity", "Breast Size", "Ears", "Ear Color One", "Ear Color Two", "Eye Color", "Facial Hairstyle", "Facial Hair Color", "Face Detail", "Hairstyle", "Hair Primary Color", "Hair Secondary Gradient", "Hair Secondary Natural Color", "Hair Third Gradient", "Hair Third Dye Color", "Horns", "Horn Color", "Penis", "Penis Size", "Tail", "Tail Color One", "Tail Color Two", "Testicles", "Testicle Size", "Vagina", "Wings", "Wing Color")
	if(HAS_TRAIT(editor, TRAIT_EDIT_DESCRIPTORS) || HAS_TRAIT(H, TRAIT_EDIT_DESCRIPTORS))
		choices += "Descriptors"

	var/chosen = input(editor, "Change what on [H]?", "Shape Flesh") as null|anything in choices
	if(!chosen)
		return FALSE

	switch(chosen)
		if("Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type
				qdel(hair)

			var/new_style = input(editor, "Choose [H]'s hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							hair_entry.dye_gradient = current_hair.hair_dye_gradient
							hair_entry.dye_color = current_hair.hair_dye_color
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.update_hair()
						should_update = TRUE

		if("Hair Primary Color")
			var/new_hair_color = color_pick_sanitized(editor, "Choose [H]'s hair color", "Primary Hair Color", H.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/datum/customizer_entry/hair/hair_entry = new()
					hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						H.hair_color = hair_entry.hair_color
						H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.dna.species.handle_body(H)
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						should_update = TRUE

		if("Facial Hair Color")
			var/new_facial_hair_color = color_pick_sanitized(editor, "Choose [H]'s facial hair color", "Facial Hair Color", H.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/datum/customizer_entry/hair/facial/facial_entry = new()
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break
					if(current_facial)
						facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
						facial_entry.accessory_type = current_facial.accessory_type
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)
						H.facial_hair_color = facial_entry.hair_color
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE

		if("Eye Color")
			var/new_eye_color = color_pick_sanitized(editor, "Choose [H]'s eye color", "Eye Color", H.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(H)
					eyes.eye_color = new_eye_color
					eyes.Insert(H, TRUE, FALSE)
				H.eye_color = new_eye_color
				H.dna.features["eye_color"] = new_eye_color
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				H.update_body_parts()
				should_update = TRUE

		if("Hair Secondary Gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type
			var/new_style = input(editor, "Choose [H]'s natural gradient", "Secondary Natural Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = valid_gradients[new_style]
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Secondary Natural Color")
			var/new_gradient_color = color_pick_sanitized(editor, "Choose [H]'s natural gradient color", "Secondary Natural Hair Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/datum/customizer_entry/hair/hair_entry = new()
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Third Gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type
			var/new_style = input(editor, "Choose [H]'s dye gradient", "Hair Third Dye Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = valid_gradients[new_style]
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Third Dye Color")
			var/new_gradient_color = color_pick_sanitized(editor, "Choose [H]'s third gradient hair color", "Third Hair Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/datum/customizer_entry/hair/hair_entry = new()
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break
					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.accessory_type = current_hair.accessory_type
						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Facial Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type
				qdel(facial)
			var/new_style = input(editor, "Choose [H]'s facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break
					if(current_facial)
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						H.update_hair()
						should_update = TRUE

		if("Accessory")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("none")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type
				qdel(acc)
			var/new_style = input(editor, "Choose [H]'s accessory", "Accessory Styling") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break
					if(new_style != "none")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], H.hair_color, H)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("Face Detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type
				qdel(detail)
			var/new_detail = input(editor, "Choose [H]'s face detail", "Face Detail") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break
					if(new_detail != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.hair_color, H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("Penis")
			var/list/valid_penis_organs = list("none")
			for(var/penis_type in subtypesof(/obj/item/organ/penis))
				var/obj/item/organ/penis/temp_penis = new penis_type
				valid_penis_organs[temp_penis.name] = penis_type
				qdel(temp_penis)
			var/new_style = input(editor, "Choose [H]'s penis type", "Penis Customization") as null|anything in valid_penis_organs
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(H)
						qdel(penis)
						H.update_body()
						should_update = TRUE
				else
					var/selected_type = valid_penis_organs[new_style]
					var/obj/item/organ/penis/old_penis = H.getorganslot(ORGAN_SLOT_PENIS)
					var/old_size = DEFAULT_PENIS_SIZE
					var/old_colors = null
					var/old_functional = TRUE
					var/old_manual_override = FALSE
					var/old_erect_state = ERECT_STATE_NONE
					if(old_penis)
						old_size = old_penis.penis_size
						old_colors = old_penis.accessory_colors
						old_functional = old_penis.functional
						old_manual_override = old_penis.manual_erection_override
						old_erect_state = old_penis.erect_state
						old_penis.Remove(H)
						qdel(old_penis)
					var/obj/item/organ/penis/new_penis = new selected_type
					new_penis.penis_size = old_size
					new_penis.functional = old_functional
					new_penis.Insert(H, TRUE, FALSE)
					var/datum/sprite_accessory/penis/penis_accessory = SPRITE_ACCESSORY(new_penis.accessory_type)
					new_penis.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, penis_accessory, old_colors)
					if(old_manual_override)
						new_penis.set_manual_erect_state(old_erect_state)
					else
						new_penis.on_arousal_changed()
					if(new_penis.sex_organ)
						var/datum/erp_sex_organ/penis/SP = new_penis.sex_organ
						SP.refresh_from_organ(new_penis)
					else
						new_penis.refresh_sex_organ()
					H.update_body()
					should_update = TRUE

		if("Testicles")
			var/list/valid_testicle_types = list("none")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles = new testicle_path()
				valid_testicle_types[testicles.name] = testicle_path
				qdel(testicles)
			var/new_style = input(editor, "Choose [H]'s testicles type", "Testicles Customization") as null|anything in valid_testicle_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(H)
						qdel(testicles)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(H, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					var/datum/sprite_accessory/testicles/testicles_type = SPRITE_ACCESSORY(testicles.accessory_type)
					testicles.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, testicles_type, testicles.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Breast Quantity")
			var/list/valid_breast_types = list("none")
			for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
				var/datum/sprite_accessory/breasts/breasts = new breast_path()
				valid_breast_types[breasts.name] = breast_path
				qdel(breasts)
			var/new_style = input(editor, "Choose [H]'s breast type", "Breast Customization") as null|anything in valid_breast_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(H)
						qdel(breasts)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(H, TRUE, FALSE)
					breasts.accessory_type = valid_breast_types[new_style]
					var/datum/sprite_accessory/breasts/breasts_type = SPRITE_ACCESSORY(breasts.accessory_type)
					breasts.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, breasts_type, breasts.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Vagina")
			var/list/valid_vagina_types = list("none", "human", "hairy", "spade", "furred", "gaping", "cloaca")
			var/new_style = input(editor, "Choose [H]'s vagina type", "Vagina Customization") as null|anything in valid_vagina_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(H)
						qdel(vagina)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(H, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]
					var/new_color = color_pick_sanitized(editor, "Choose [H]'s vagina color", "Vagina Color", vagina.color || H.dna.features["mcolor"])
					if(new_color)
						vagina.color = sanitize_hexcolor(new_color, 6, TRUE)
					else
						var/datum/sprite_accessory/vagina/vag_type = SPRITE_ACCESSORY(vagina.accessory_type)
						vagina.color = tat_mentor_mirror_pick_accessory_colors(editor, H, vag_type, vagina.color)
					H.update_body()
					should_update = TRUE

		if("Breast Size")
			var/list/breast_sizes = list("Flat", "Slight", "Small", "Moderate", "Large", "Generous", "Heavy", "Massive", "Heaping", "Obscene")
			var/new_size = input(editor, "Choose [H]'s breast size", "Breast Size") as null|anything in breast_sizes
			if(new_size)
				var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
				if(breasts)
					var/size_num
					switch(new_size)
						if("Flat")
							size_num = 0
						if("Slight")
							size_num = 1
						if("Small")
							size_num = 2
						if("Moderate")
							size_num = 3
						if("Large")
							size_num = 4
						if("Generous")
							size_num = 5
						if("Heavy")
							size_num = 6
						if("Massive")
							size_num = 7
						if("Heaping")
							size_num = 8
						if("Obscene")
							size_num = 9
					breasts.breast_size = size_num
					H.update_body()
					should_update = TRUE

		if("Penis Size")
			var/list/penis_sizes = list("small", "average", "large")
			var/new_size = input(editor, "Choose [H]'s penis size", "Penis Size") as null|anything in penis_sizes
			if(new_size)
				var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
				if(penis)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3
					penis.penis_size = size_num
					H.update_body()
					should_update = TRUE

		if("Testicle Size")
			var/list/testicle_sizes = list("small", "average", "large")
			var/new_size = input(editor, "Choose [H]'s testicle size", "Testicle Size") as null|anything in testicle_sizes
			if(new_size)
				var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testicles)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3
					testicles.ball_size = size_num
					H.update_body()
					should_update = TRUE

		if("Tail")
			var/list/valid_tails = list("none")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail = new tail_path()
				valid_tails[tail.name] = tail_path
				qdel(tail)
			var/new_style = input(editor, "Choose [H]'s tail", "Tail Customization") as null|anything in valid_tails
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(H)
						qdel(tail)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(H, TRUE, FALSE)
					tail.accessory_type = valid_tails[new_style]
					var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail.accessory_type)
					tail.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, tail_type, tail.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Tail Color One")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s primary tail color", "Tail Color One", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have a tail."))

		if("Tail Color Two")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s secondary tail color", "Tail Color Two", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have a tail."))

		if("Ears")
			var/list/valid_ears = list("none")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ears = new ears_path()
				valid_ears[ears.name] = ears_path
				qdel(ears)
			var/new_style = input(editor, "Choose [H]'s ears", "Ears Customization") as null|anything in valid_ears
			if(new_style)
				var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
				if(!ears)
					ears = new /obj/item/organ/ears()
					ears.Insert(H, TRUE, FALSE)
				if(new_style == "none")
					ears.Remove(H)
					ears.accessory_type = initial(ears.accessory_type)
					ears.accessory_colors = initial(ears.accessory_colors)
					ears.Insert(H, TRUE, FALSE)
					H.update_body()
					should_update = TRUE
				else
					ears.accessory_type = valid_ears[new_style]
					var/datum/sprite_accessory/ears/ears_type = SPRITE_ACCESSORY(ears.accessory_type)
					ears.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, ears_type, ears.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Ear Color One")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s primary ear color", "Ear Color One", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have ears."))

		if("Ear Color Two")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s secondary ear color", "Ear Color Two", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color2"] = colors[2]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have ears."))

		if("Horns")
			var/list/valid_horns = list("none")
			for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
				var/datum/sprite_accessory/horns/horns = new horns_path()
				valid_horns[horns.name] = horns_path
				qdel(horns)
			var/new_style = input(editor, "Choose [H]'s horns", "Horns Customization") as null|anything in valid_horns
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(H)
						qdel(horns)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(H, TRUE, FALSE)
					horns.accessory_type = valid_horns[new_style]
					var/datum/sprite_accessory/horns/horns_type = SPRITE_ACCESSORY(horns.accessory_type)
					horns.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, horns_type, horns.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Horn Color")
			var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s primary horn color", "Horn Color", "#FFFFFF")
				if(new_color)
					horns.Remove(H)
					var/list/colors = list()
					if(horns.accessory_colors)
						colors = color_string_to_list(horns.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(colors)
					horns.Insert(H, TRUE, FALSE)
					H.dna.features["horns_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have horns."))

		if("Wings")
			var/list/valid_wings = list("none")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wings = new wings_path()
				valid_wings[wings.name] = wings_path
				qdel(wings)
			var/new_style = input(editor, "Choose [H]'s wings", "Wings Customization") as null|anything in valid_wings
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(H)
						qdel(wings)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(H, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					var/datum/sprite_accessory/wings/wings_type = SPRITE_ACCESSORY(wings.accessory_type)
					wings.accessory_colors = tat_mentor_mirror_pick_accessory_colors(editor, H, wings_type, wings.accessory_colors)
					H.update_body()
					should_update = TRUE

		if("Wing Color")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/new_color = color_pick_sanitized(editor, "Choose [H]'s primary wing color", "Wing Color One", "#FFFFFF")
				if(new_color)
					wings.Remove(H)
					var/list/colors = list()
					if(wings.accessory_colors)
						colors = color_string_to_list(wings.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF")
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(colors)
					wings.Insert(H, TRUE, FALSE)
					H.dna.features["wings_color"] = colors[1]
					H.update_body()
					should_update = TRUE
			else
				to_chat(editor, span_warning("[H] doesn't have wings."))

		if("Descriptors")
			var/list/species_choices = H.dna.species.descriptor_choices
			if(!length(species_choices))
				to_chat(editor, span_warning("[H]'s species has no standard descriptors to modify."))
				return FALSE
			var/list/choice_map = list()
			for(var/path in species_choices)
				var/datum/descriptor_choice/C = DESCRIPTOR_CHOICE(path)
				choice_map[C.name] = path
			var/choice_name = input(editor, "Which feature do you want to describe on [H]?", "Standard Descriptors") as null|anything in choice_map
			if(!choice_name)
				return FALSE
			var/choice_type = choice_map[choice_name]
			var/datum/descriptor_choice/chosen_datum = DESCRIPTOR_CHOICE(choice_type)
			var/list/picklist = list()
			for(var/desc_type in chosen_datum.descriptors)
				var/datum/mob_descriptor/descriptor = MOB_DESCRIPTOR(desc_type)
				if(descriptor)
					picklist[descriptor.name] = desc_type
			var/picked_name = input(editor, "Choose a new description for [choice_name]:", "Describe Target") as null|anything in picklist
			if(picked_name)
				for(var/old_name in picklist)
					H.remove_mob_descriptor(picklist[old_name])
				H.add_mob_descriptor(picklist[picked_name])
				should_update = TRUE

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
		erp_mark_actor_organs_dirty(H)
		to_chat(editor, span_notice("You reshape [H]'s body."))
		if(editor != H)
			to_chat(H, span_notice("Your body reshapes."))

	return should_update

/proc/tat_mentor_mirror_pick_accessory_colors(mob/living/carbon/human/editor, mob/living/carbon/human/H, datum/sprite_accessory/A, current_colors)
	if(!editor || !H || !A)
		return current_colors

	var/list/src_color = color_key_source_list_from_carbon(H)
	for(var/k in src_color)
		if(istext(src_color[k]))
			src_color[k] = sanitize_hexcolor(src_color[k], 6, TRUE)

	var/list/colors = color_string_to_list(A.validate_color_keys_for_owner(H, current_colors))
	if(!colors)
		colors = list()
	while(length(colors) < A.color_keys)
		colors += "#FFFFFF"

	for(var/i in 1 to A.color_keys)
		var/label = "Color #[i]"
		if(A.color_key_names && length(A.color_key_names) >= i)
			label = "[A.color_key_names[i]]"

		var/list/modes = list("Skin", "Mutant 1", "Mutant 2", "Mutant 3", "Custom")
		var/mode = input(editor, "Set [H]'s [label] (current: [colors[i]])", "Colors") as null|anything in modes
		if(!mode)
			continue

		switch(mode)
			if("Skin")
				colors[i] = src_color[KEY_SKIN_COLOR]
			if("Mutant 1")
				colors[i] = src_color[KEY_MUT_COLOR_ONE]
			if("Mutant 2")
				colors[i] = src_color[KEY_MUT_COLOR_TWO]
			if("Mutant 3")
				colors[i] = src_color[KEY_MUT_COLOR_THREE]
			if("Custom")
				var/c = color_pick_sanitized(editor, "Pick custom color for [H]'s [label]", "Colors", colors[i])
				if(c)
					colors[i] = sanitize_hexcolor(c, 6, TRUE)

	return color_list_to_string(colors)

GLOBAL_LIST_INIT(tat_mentor_erp_training_map, list(
	/datum/skill/labor/farming = list("action" = /datum/erp_action/other/hands/milking_breasts, "passive" = "mentor"),
	/datum/skill/labor/mining = list("action" = /datum/erp_action/other/mouth/rimming, "passive" = "mentor"),
	/datum/skill/labor/fishing = list("action" = /datum/erp_action/other/hands/finger_oral, "passive" = "mentor"),
	/datum/skill/labor/butchering = list("action" = /datum/erp_action/other/body/grinding, "passive" = "mentor"),
	/datum/skill/labor/lumberjacking = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "mentor"),

	/datum/skill/magic/holy = list("action" = /datum/erp_action/other/mouth/cunnilingus, "passive" = "mentor"),
	/datum/skill/magic/arcane = list("action" = /datum/erp_action/other/mouth/breast_feed, "passive" = "mentor"),

	/datum/skill/misc/climbing = list("action" = /datum/erp_action/other/body/rubbing, "passive" = "actor"),
	/datum/skill/misc/reading = list("action" = /datum/erp_action/other/vagina/force_face, "passive" = "actor"),
	/datum/skill/misc/stealing = list("action" = /datum/erp_action/other/vagina/face, "passive" = "actor"),
	/datum/skill/misc/sneaking = list("action" = /datum/erp_action/other/hands/force_crotch, "passive" = "actor"),
	/datum/skill/misc/lockpicking = list("action" = /datum/erp_action/other/hands/tease_vagina, "passive" = "mentor"),
	/datum/skill/misc/riding = list("action" = /datum/erp_action/other/anus/force_face, "passive" = "mentor"),
	/datum/skill/misc/medicine = list("action" = /datum/erp_action/other/mouth/finger_lick, "passive" = "actor"),
	/datum/skill/misc/tracking = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "mentor"),

	/datum/skill/craft/crafting = list("action" = /datum/erp_action/other/breasts/breast_feed, "passive" = "actor"),
	/datum/skill/craft/weaponsmithing = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "actor"),
	/datum/skill/craft/armorsmithing = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "actor"),
	/datum/skill/craft/blacksmithing = list("action" = /datum/erp_action/other/anus/butt, "passive" = "mentor"),
	/datum/skill/craft/smelting = list("action" = /datum/erp_action/other/penis/rubbing, "passive" = "actor"),
	/datum/skill/craft/carpentry = list("action" = /datum/erp_action/other/vagina/rubbing, "passive" = "actor"),
	/datum/skill/craft/masonry = list("action" = /datum/erp_action/other/anus/rubbing, "passive" = "actor"),
	/datum/skill/craft/traps = list("action" = /datum/erp_action/other/anus/face, "passive" = "actor"),
	/datum/skill/craft/engineering = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "mentor"),
	/datum/skill/craft/cooking = list("action" = /datum/erp_action/other/mouth/kiss, "passive" = "mentor"),
	/datum/skill/craft/sewing = list("action" = /datum/erp_action/other/hands/rubbing, "passive" = "mentor"),
	/datum/skill/craft/tanning = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "actor"),
	/datum/skill/craft/ceramics = list("action" = /datum/erp_action/other/hands/breasts_play, "passive" = "mentor"),
	/datum/skill/craft/alchemy = list("action" = /datum/erp_action/other/hands/milking_penis, "passive" = "mentor"),

	/datum/skill/combat/knives = list("action" = /datum/erp_action/other/penis/masturbation, "passive" = "actor"),
	/datum/skill/combat/swords = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "mentor"),
	/datum/skill/combat/polearms = list("action" = /datum/erp_action/other/hands/toy_vaginal, "passive" = "mentor"),
	/datum/skill/combat/maces = list("action" = /datum/erp_action/other/legs/footjob, "passive" = "mentor"),
	/datum/skill/combat/axes = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "mentor"),
	/datum/skill/combat/whipsflails = list("action" = /datum/erp_action/other/hands/tease_testicles, "passive" = "mentor"),
	/datum/skill/combat/wrestling = list("action" = /datum/erp_action/other/hands/finger_anal, "passive" = "mentor"),
	/datum/skill/combat/unarmed = list("action" = /datum/erp_action/other/hands/finger_vaginal, "passive" = "mentor"),
	/datum/skill/combat/shields = list("action" = /datum/erp_action/other/breasts/teasing, "passive" = "actor"),
	/datum/skill/combat/staves = list("action" = /datum/erp_action/other/legs/teasing, "passive" = "actor")
))

GLOBAL_LIST_INIT(tat_mentor_erp_combat_skills, list(
	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/staves
))

/proc/tat_mentor_erp_get_training_entry(datum/erp_action/A, expected_passive)
	if(!A || !expected_passive)
		return null

	var/action_type = A.type

	for(var/skill_type as anything in GLOB.tat_mentor_erp_training_map)
		var/list/entry = GLOB.tat_mentor_erp_training_map[skill_type]
		if(!islist(entry))
			continue

		if(entry["action"] != action_type)
			continue

		if(entry["passive"] != expected_passive)
			continue

		return list("skill" = skill_type, "passive" = entry["passive"])

	return null

/datum/erp_scene_effects/proc/apply_tat_mentor_training(list/active_links)
	if(!controller)
		return

	var/list/mentors = list()

	var/datum/component/tat_mentor/SC = controller.owner?.physical?.GetComponent(/datum/component/tat_mentor)
	if(SC && SC.can_share_training() && SC.owner)
		mentors += SC.owner

	SC = controller.active_partner?.physical?.GetComponent(/datum/component/tat_mentor)
	if(SC && SC.can_share_training() && SC.owner)
		if(!(SC.owner in mentors))
			mentors += SC.owner

	if(!length(mentors))
		return

	for(var/mob/living/mentor_mob as anything in mentors)
		if(!mentor_mob)
			continue

		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue

			var/datum/erp_actor/active = L.actor_active
			var/datum/erp_actor/passive = L.actor_passive
			if(!active || !passive)
				continue

			var/mob/living/m_active = active.get_effect_mob()
			var/mob/living/m_passive = passive.get_effect_mob()
			if(!m_active || !m_passive)
				continue

			var/expected_passive = null
			var/mob/living/receiver = null

			if(m_active == mentor_mob)
				expected_passive = "actor"
				receiver = m_passive
			else if(m_passive == mentor_mob)
				expected_passive = "mentor"
				receiver = m_active
			else
				continue

			if(!receiver?.mind)
				continue

			var/list/entry = tat_mentor_erp_get_training_entry(L.action, expected_passive)
			if(!entry)
				continue

			var/skill_type = entry["skill"]
			if(!skill_type)
				continue

			receiver.mind.add_sleep_experience(skill_type, 2, FALSE)
