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

	return max(0, final_cost)

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

/datum/tat_build/proc/get_combat_skill_cap()
	var/cap = TAT_SKILL_COMBAT_CAP_DEFAULT
	if(traits[TAT_TRAIT_WARRIOR_EXPERT])
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_1)
	if(traits[TAT_TRAIT_WARRIOR_MASTER])
		cap = max(cap, TAT_SKILL_COMBAT_CAP_TRAIT_2)
	return cap

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
		return get_combat_skill_cap()
	if(should_softcap_peaceful_skill(skill_type) && !has_expert_trait_for_skill(skill_type))
		return 2
	if((skill_type == /datum/skill/combat/twilight_firearms) && !(has_expert_trait_for_skill(skill_type)))
		return 2
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
	switch(cleric_tier)
		if(CLERIC_T4)
			return CLERIC_REGEN_MAJOR
		if(CLERIC_T2)
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

/datum/tat_build/proc/are_traits_mutually_exclusive(trait_a, trait_b)
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TRAIT_OUTLANDER) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TRAIT_OUTLANDER))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_WANTED) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_WANTED))
		return TRUE
	if((trait_a == TAT_TRAIT_BONUS_STAT_POOL && trait_b == TAT_TRAIT_WANTED) || (trait_b == TAT_TRAIT_BONUS_STAT_POOL && trait_a == TAT_TRAIT_WANTED))
		return TRUE
	if((trait_a == TAT_TRAIT_RESIDENT && trait_b == TAT_TRAIT_BONUS_STAT_POOL) || (trait_b == TAT_TRAIT_RESIDENT && trait_a == TAT_TRAIT_BONUS_STAT_POOL))
		return TRUE
	if((trait_a == TRAIT_DODGEEXPERT && trait_b == TRAIT_PARRYEXPERT) || (trait_b == TRAIT_DODGEEXPERT && trait_a == TRAIT_PARRYEXPERT))
		return TRUE
	if((trait_a == TRAIT_HEAVYARMOR && trait_b == TRAIT_CRITICAL_RESISTANCE) || (trait_b == TRAIT_HEAVYARMOR && trait_a == TRAIT_CRITICAL_RESISTANCE))
		return TRUE
	if((trait_a == TRAIT_MEDIUMARMOR && trait_b == TRAIT_CRITICAL_RESISTANCE) || (trait_b == TRAIT_MEDIUMARMOR && trait_a == TRAIT_CRITICAL_RESISTANCE))
		return TRUE
	if((trait_a == TAT_TRAIT_TROPHY_BOUNTY && trait_b == TAT_TRAIT_RONIN) || (trait_b == TAT_TRAIT_TROPHY_BOUNTY && trait_a == TAT_TRAIT_RONIN))
		return TRUE
	if((trait_a == TAT_TRAIT_TROPHY_BOUNTY && trait_b == TAT_TRAIT_SOUNDBREAKER) || (trait_b == TAT_TRAIT_TROPHY_BOUNTY && trait_a == TAT_TRAIT_SOUNDBREAKER))
		return TRUE
	if((trait_a == TAT_TRAIT_SOUNDBREAKER && trait_b == TAT_TRAIT_RONIN) || (trait_b == TAT_TRAIT_SOUNDBREAKER && trait_a == TAT_TRAIT_RONIN))
		return TRUE
	if((trait_a == TAT_TRAIT_SPELLBLADE && trait_b == TAT_TRAIT_RONIN) || (trait_b == TAT_TRAIT_SPELLBLADE && trait_a == TAT_TRAIT_RONIN))
		return TRUE
	if((trait_a == TAT_TRAIT_SPELLBLADE && trait_b == TAT_TRAIT_SOUNDBREAKER) || (trait_b == TAT_TRAIT_SPELLBLADE && trait_a == TAT_TRAIT_SOUNDBREAKER))
		return TRUE
	if((trait_a == TAT_TRAIT_SPELLBLADE && trait_b == TAT_TRAIT_TROPHY_BOUNTY) || (trait_b == TAT_TRAIT_SPELLBLADE && trait_a == TAT_TRAIT_TROPHY_BOUNTY))
		return TRUE
	if((trait_a == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_b == TAT_TRAIT_SOUNDBREAKER) || (trait_b == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_a == TAT_TRAIT_SOUNDBREAKER))
		return TRUE
	if((trait_a == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_b == TAT_TRAIT_SPELLBLADE) || (trait_b == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_a == TAT_TRAIT_SPELLBLADE))
		return TRUE
	if((trait_a == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_b == TAT_TRAIT_RONIN) || (trait_b == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_a == TAT_TRAIT_RONIN))
		return TRUE
	if((trait_a == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_b == TAT_TRAIT_DIVINE_BOON_3) || (trait_b == TAT_TRAIT_BARDIC_INSPIRATION_T2 && trait_a == TAT_TRAIT_DIVINE_BOON_3))
		return TRUE
	if((trait_a == TAT_TRAIT_SPELLBLADE && trait_b == TAT_TRAIT_DIVINE_BOON_3) || (trait_b == TAT_TRAIT_SPELLBLADE && trait_a == TAT_TRAIT_DIVINE_BOON_3))
		return TRUE
	if((trait_a == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_b == TAT_TRAIT_DIVINE_BOON_3) || (trait_b == TAT_TRAIT_MAGE_MAJOR_SLOT && trait_a == TAT_TRAIT_DIVINE_BOON_3))
		return TRUE
	if((trait_a == TAT_TRAIT_DRUID_INITIATE && trait_b == TAT_TRAIT_MAGE_INITIATE) || (trait_b == TAT_TRAIT_DRUID_INITIATE && trait_a == TAT_TRAIT_MAGE_INITIATE))
		return TRUE
	if((trait_a == TAT_TRAIT_DRUID_INITIATE && trait_b == TAT_TRAIT_DIVINE_INITIATE) || (trait_b == TAT_TRAIT_DRUID_INITIATE && trait_a == TAT_TRAIT_DIVINE_INITIATE))
		return TRUE
	if((trait_a == TAT_TRAIT_WARRIOR_MASTER && has_defensive_trait_lockout()) || (trait_b == TAT_TRAIT_WARRIOR_MASTER && has_defensive_trait_lockout()))
		return TRUE
	if((trait_a == TRAIT_CRITICAL_RESISTANCE && trait_b == TAT_TRAIT_MAGE_INITIATE) || (trait_b == TRAIT_CRITICAL_RESISTANCE && trait_a == TAT_TRAIT_MAGE_INITIATE))
		return TRUE
	if((trait_a == TRAIT_CRITICAL_RESISTANCE && trait_b == TAT_TRAIT_DIVINE_INITIATE) || (trait_b == TRAIT_CRITICAL_RESISTANCE && trait_a == TAT_TRAIT_DIVINE_INITIATE))
		return TRUE
	return FALSE

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
	if(traits[TAT_TRAIT_WARRIOR_MASTER] && !traits[TAT_TRAIT_WARRIOR_EXPERT])
		return TRUE
	if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T2] && !traits[TAT_TRAIT_BARDIC_INSPIRATION_T1])
		return TRUE
	if(traits[TAT_TRAIT_DIVINE_BOON_1] && !traits[TAT_TRAIT_DIVINE_INITIATE])
		return TRUE
	if(traits[TAT_TRAIT_DIVINE_BOON_2] && (!traits[TAT_TRAIT_DIVINE_INITIATE] || !traits[TAT_TRAIT_DIVINE_BOON_1]))
		return TRUE
	if(traits[TAT_TRAIT_DIVINE_BOON_3] && (!traits[TAT_TRAIT_DIVINE_INITIATE] || !traits[TAT_TRAIT_DIVINE_BOON_2]))
		return TRUE
	if(traits[TAT_TRAIT_MAGE_INITIATE] && !traits[TRAIT_ARCYNE])
		return TRUE
	if(traits[TAT_TRAIT_SPELLBLADE] && (!traits[TAT_TRAIT_MAGE_INITIATE] || !traits[TRAIT_ARCYNE]))
		return TRUE
	if((traits[TAT_TRAIT_MAGE_MAJOR_SLOT] || traits[TAT_TRAIT_MAGE_MINOR_SLOT_1] || traits[TAT_TRAIT_MAGE_UTILITY_SLOT]) && !traits[TAT_TRAIT_MAGE_INITIATE])
		return TRUE
	if(traits[TAT_TRAIT_MAGE_MINOR_SLOT_2] && !traits[TAT_TRAIT_MAGE_MINOR_SLOT_1])
		return TRUE
	if(traits[TAT_TRAIT_ARTIFACTS_SUPPLIER] && !traits[TAT_TRAIT_PARTY_LEADER])
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

/datum/tat_build/proc/can_train_arcane()
	return !!traits[TRAIT_ARCYNE]

/datum/tat_build/proc/can_train_holy()
	return !!traits[TAT_TRAIT_DIVINE_INITIATE]

/datum/tat_build/proc/has_expert_trait_for_skill(skill_type)
	switch(skill_type)
		if(/datum/skill/craft/cooking)
			return !!traits[TRAIT_HOMESTEAD_EXPERT]
		if(/datum/skill/craft/alchemy)
			return !!traits[TRAIT_ALCHEMY_EXPERT]
		if(/datum/skill/misc/medicine)
			return !!traits[TRAIT_MEDICINE_EXPERT]
		if(/datum/skill/craft/sewing)
			return !!traits[TRAIT_SEWING_EXPERT]
		if(/datum/skill/labor/farming)
			return !!traits[TRAIT_SEEDKNOW]
		if(/datum/skill/craft/blacksmithing)
			return !!traits[TRAIT_SMITHING_EXPERT]
		if(/datum/skill/craft/smelting)
			return !!traits[TRAIT_SMITHING_EXPERT]
		if(/datum/skill/craft/carpentry)
			return !!traits[TRAIT_HOMESTEAD_EXPERT]
		if(/datum/skill/craft/masonry)
			return !!traits[TRAIT_HOMESTEAD_EXPERT]
		if(/datum/skill/craft/crafting)
			return !!traits[TRAIT_HOMESTEAD_EXPERT]
		if(/datum/skill/labor/butchering)
			return !!traits[TRAIT_SURVIVAL_EXPERT]
		if(/datum/skill/craft/traps)
			return !!traits[TRAIT_SURVIVAL_EXPERT]
		if(/datum/skill/labor/fishing)
			return !!traits[TRAIT_CAUTIOUS_FISHER]
		if(/datum/skill/craft/armorsmithing)
			return !!traits[TRAIT_SQUIRE_REPAIR]
		if(/datum/skill/craft/weaponsmithing)
			return !!traits[TRAIT_SQUIRE_REPAIR]
		if(/datum/skill/combat/twilight_firearms)
			return !!traits[TRAIT_FIREARMS_MARKSMAN]
	return TRUE

/datum/tat_build/proc/should_softcap_peaceful_skill(skill_type)
	switch(skill_type)
		if(
			/datum/skill/craft/cooking,
			/datum/skill/craft/alchemy,
			/datum/skill/misc/medicine,
			/datum/skill/craft/sewing,
			/datum/skill/labor/farming,
			/datum/skill/craft/blacksmithing,
			/datum/skill/craft/smelting,
			/datum/skill/craft/carpentry,
			/datum/skill/craft/masonry,
			/datum/skill/craft/crafting,
			/datum/skill/labor/butchering,
			/datum/skill/craft/traps,
			/datum/skill/labor/fishing,
			/datum/skill/craft/armorsmithing,
			/datum/skill/craft/weaponsmithing
		)
			return TRUE
	return FALSE

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
	var/list/entry = get_item_entry(path)
	if(!islist(entry))
		return 0
	if(!is_item_slot_limited(entry))
		return INFINITY
	var/slot_group = entry["slot_group"]
	var/category = entry["category"]
	if(!slot_group)
		return INFINITY
	var/already_taken = get_slot_group_item_count(slot_group, category, path)
	return max(0, 1 - already_taken)

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
