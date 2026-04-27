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
	var/list/all = list(TAT_AVAILABLE_TRAITS_LIST)
	if(!(trait_id in all))
		return null
	return all[trait_id]

/datum/tat_traits/proc/has_trait(trait_id)
	return !!selected[trait_id]

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

/datum/tat_traits/proc/get_cost_modifier(trait_id)
	return 0

/datum/tat_traits/proc/get_display_cost(trait_id)
	return get_base_cost(trait_id) + get_cost_modifier(trait_id)

/datum/tat_traits/proc/check_trait(trait_id)
	return islist(get_entry(trait_id))

/datum/tat_traits/proc/add_trait(trait_id)
	if(!check_trait(trait_id))
		return FALSE
	selected[trait_id] = TRUE
	owner_build?.set_dirty()
	return TRUE

/datum/tat_traits/proc/remove_trait(trait_id)
	selected -= trait_id
	owner_build?.set_dirty()
	return TRUE

/datum/tat_traits/proc/get_bonus_stat_points()
	var/total = 0
	var/list/rules = TAT_TRAIT_STAT_POINT_RULES
	for(var/trait_id in selected)
		if(trait_id in rules)
			total += round(rules[trait_id])
	return total

/datum/tat_traits/proc/get_bonus_item_points()
	var/total = 0
	var/list/rules = TAT_TRAIT_ITEM_POINT_RULES
	for(var/trait_id in selected)
		if(trait_id in rules)
			total += round(rules[trait_id])
	return total

/datum/tat_traits/proc/get_bonus_skill_domain_points(domain)
	var/total = 0
	var/list/rules = TAT_TRAIT_SKILL_POINT_RULES
	for(var/trait_id in selected)
		var/list/domain_map = rules[trait_id]
		if(islist(domain_map))
			total += round(domain_map[domain] || 0)
	return total

/datum/tat_traits/proc/get_bonus_skill_value(skill_type)
	var/total = 0
	var/list/rules = TAT_TRAIT_SKILL_BONUS_RULES

	for(var/trait_id in selected)
		var/list/skill_map = rules[trait_id]
		if(islist(skill_map))
			total += round(skill_map[skill_type] || 0)

	if(has_trait(TAT_TRAIT_MAGE_INITIATE) && skill_type == /datum/skill/magic/arcane)
		total += 1

	if(has_trait(TAT_TRAIT_DIVINE_INITIATE) && skill_type == /datum/skill/magic/holy)
		total += 1

	if(has_trait(TAT_TRAIT_DRUID_INITIATE) && skill_type == /datum/skill/magic/druidic)
		total += 1

	return total

/datum/tat_traits/proc/get_skill_cap_bonus_value(skill_type)
	var/total = 0
	var/list/rules = TAT_TRAIT_SKILL_CAP_BONUS_RULES

	for(var/trait_id in selected)
		var/list/skill_map = rules[trait_id]
		if(!islist(skill_map))
			continue

		total += round(skill_map[skill_type] || 0)

	return total

/datum/tat_traits/proc/get_required_trait_for_unlock(unlock_type, unlock_key)
	var/list/rules = TAT_TRAIT_ITEM_UNLOCK_RULES
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

	var/list/rules = TAT_TRAIT_SKILL_DISCOUNT_RULES
	for(var/trait_id in selected)
		var/list/discounted = rules[trait_id]
		if(!islist(discounted) || !(skill_type in discounted))
			continue
		if(ispath(skill_type, /datum/skill/combat))
			return (target_level <= 2) ? 1 : 0
		return 1
	return 0

/datum/tat_traits/proc/get_spent_points()
	var/total = 0
	for(var/trait_id in selected)
		total += get_display_cost(trait_id)
	return total

/datum/tat_traits/proc/get_remaining_points()
	return get_total_maximum() - get_spent_points()

/datum/tat_traits/proc/get_trait_conflict_map()
	return list(
		TAT_TRAIT_RESIDENT = list(TRAIT_OUTLANDER, TAT_TRAIT_WANTED, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MASTER_OF_WANDERING, TAT_TRAIT_HERETIC),
		TAT_TRAIT_BONUS_STAT_POOL = list(TAT_TRAIT_WANTED),
		TRAIT_DODGEEXPERT = list(TRAIT_PARRYEXPERT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TRAIT_HEAVYARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_MAGE_INITIATE),
		TRAIT_MEDIUMARMOR = list(TRAIT_CRITICAL_RESISTANCE, TAT_TRAIT_MAGE_INITIATE),
		TAT_TRAIT_TROPHY_BOUNTY = list(TAT_TRAIT_RONIN, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_SOUNDBREAKER = list(TAT_TRAIT_RONIN, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_SPELLBLADE = list(TAT_TRAIT_RONIN, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list(TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_RONIN, TAT_TRAIT_DIVINE_BOON_3),
		TAT_TRAIT_MAGE_MAJOR_SLOT = list(TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_SPELLBLADE),
		TAT_TRAIT_DIVINE_BOON_3 = list(TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_MAGE_UTILITY_SLOT),
		TAT_TRAIT_DRUID_INITIATE = list(TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_INITIATE),
		TRAIT_CRITICAL_RESISTANCE = list(TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DIVINE_INITIATE),
		TAT_TRAIT_WARRIOR_EXPERT = list(TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT),
		TAT_TRAIT_WITCH_INITIATE = list(TAT_TRAIT_MAGE_MINOR_SLOT_2, TAT_TRAIT_DIVINE_BOON_3, TAT_TRAIT_WANTED),
	)

/datum/tat_traits/proc/get_trait_requirement_map()
	return list(
		TAT_TRAIT_WARRIOR_MASTER = list("all" = list(TAT_TRAIT_WARRIOR_EXPERT), "message" = "\"[get_trait_display_name(TAT_TRAIT_WARRIOR_MASTER)]\" requires \"[get_trait_display_name(TAT_TRAIT_WARRIOR_EXPERT)]\"."),
		TAT_TRAIT_BARDIC_INSPIRATION_T2 = list("all" = list(TAT_TRAIT_BARDIC_INSPIRATION_T1), "message" = "\"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T2)]\" requires \"[get_trait_display_name(TAT_TRAIT_BARDIC_INSPIRATION_T1)]\"."),
		TAT_TRAIT_DIVINE_BOON_1 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_1)]\" requires \"[get_trait_display_name(TAT_TRAIT_DIVINE_INITIATE)]\"."),
		TAT_TRAIT_DIVINE_BOON_2 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_2)]\" requires previous divine progression."),
		TAT_TRAIT_DIVINE_BOON_3 = list("all" = list(TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_2), "message" = "\"[get_trait_display_name(TAT_TRAIT_DIVINE_BOON_3)]\" requires previous divine progression."),
		TAT_TRAIT_MAGE_INITIATE = list("all" = list(TRAIT_ARCYNE), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_INITIATE)]\" requires \"[get_trait_display_name(TRAIT_ARCYNE)]\"."),
		TAT_TRAIT_SPELLBLADE = list("all" = list(TAT_TRAIT_MAGE_INITIATE, TRAIT_ARCYNE), "message" = "\"[get_trait_display_name(TAT_TRAIT_SPELLBLADE)]\" requires mage initiation and arcyne."),
		TAT_TRAIT_MAGE_MINOR_SLOT_2 = list("all" = list(TAT_TRAIT_MAGE_MINOR_SLOT_1), "message" = "\"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_2)]\" requires \"[get_trait_display_name(TAT_TRAIT_MAGE_MINOR_SLOT_1)]\"."),
		TRAIT_BITERHELM = list("all" = list(TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TRAIT_BITERHELM)]\" requires \"[get_trait_display_name(TAT_TRAIT_HERETIC)]\"."),
		TRAIT_RITUALIST = list("all" = list(TAT_TRAIT_HERETIC), "message" = "\"[get_trait_display_name(TRAIT_RITUALIST)]\" requires \"[get_trait_display_name(TAT_TRAIT_HERETIC)]\"."),
		TAT_TRAIT_ARTIFACTS_SUPPLIER = list("all" = list(TAT_TRAIT_PARTY_LEADER), "message" = "\"[get_trait_display_name(TAT_TRAIT_ARTIFACTS_SUPPLIER)]\" requires \"[get_trait_display_name(TAT_TRAIT_PARTY_LEADER)]\"."),
	)

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
	if(has_trait(TRAIT_DODGEEXPERT))
		return TRUE
	if(has_trait(TRAIT_PARRYEXPERT))
		return TRUE
	if(has_trait(TRAIT_CRITICAL_RESISTANCE))
		return TRUE
	if(has_trait(TRAIT_MEDIUMARMOR))
		return TRUE
	if(has_trait(TRAIT_HEAVYARMOR))
		return TRUE
	return FALSE

/datum/tat_traits/proc/are_traits_mutually_exclusive(trait_a, trait_b)
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
	if((trait_a == TAT_TRAIT_WITCH_INITIATE || trait_b == TAT_TRAIT_WITCH_INITIATE) && has_defensive_trait_lockout())
		return "\"[get_trait_display_name(TAT_TRAIT_WITCH_INITIATE)]\" conflicts with current defensive trait setup."
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
	for(var/trait_a in selected)
		for(var/trait_b in selected)
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
		if(!check_trait(trait_id))
			selected -= trait_id
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
	H.mind?.special_items["Resident Manuscript"] = /obj/item/book/granter/residentcardvirtue
	var/bonus_reading = owner_build?.get_resident_skill_value(/datum/skill/misc/reading) || 0
	if(bonus_reading > 0)
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, bonus_reading, TRUE)
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
		owner_build?.grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/gravemark)

/datum/tat_traits/proc/apply_mage_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_MAGE_INITIATE) || !H.mind)
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	var/list/aspects = build_mage_aspects(TRUE)
	H.mind.setup_mage_aspects(aspects)
	owner_build?.set_magic_value("mage_aspects", aspects.Copy())
	if(owner_build?.get_magic_value("mage_spellbook", TRUE))
		H.equip_to_slot_or_del(new /obj/item/book/spellbook(H), SLOT_IN_BACKPACK)

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

/datum/tat_traits/proc/apply_witch_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_WITCH_INITIATE))
		return
	ADD_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)
	ADD_TRAIT(H, TRAIT_DEATHSIGHT, TAT_TRAIT_SOURCE)
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

/datum/tat_traits/proc/apply_spellblade_package(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_SPELLBLADE))
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	if(!H.mind)
		return
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))
	var/list/subclass_list = list("Blade", "Phalangite", "Macebearer")
	var/subclass_selected = owner_build?.get_magic_value("spellblade_subclass")
	if(!subclass_selected || !(subclass_selected in subclass_list))
		subclass_selected = H.client ? tgui_input_list(H, "Who are you?", "The spellblade specialization", subclass_list) : null
		if(!subclass_selected)
			subclass_selected = "Blade"
		owner_build?.set_magic_value("spellblade_subclass", subclass_selected)
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

/datum/tat_traits/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/trait_id in selected)
		switch(trait_id)
			if(TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER, TAT_TRAIT_SOUNDBREAKER, TAT_TRAIT_RONIN, TAT_TRAIT_RESIDENT, TAT_TRAIT_STEEL_SUPPLIER, TAT_TRAIT_SILVER_SUPPLIER, TAT_TRAIT_BRONZE_SUPPLIER, TAT_TRAIT_LEATHER_SUPPLIER, TAT_TRAIT_MAIL_SUPPLIER, TAT_TRAIT_PLATE_SUPPLIER, TAT_TRAIT_SPELLBLADE, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2, TAT_TRAIT_PARTY_LEADER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WANTED, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_DRUID_INITIATE, TAT_TRAIT_WITCH_INITIATE, TAT_TRAIT_ARTIFACTS_SUPPLIER, TAT_TRAIT_FIREARMS_SUPPLIER, TAT_TRAIT_TROPHY_BOUNTY, TAT_TRAIT_MASTER_OF_WANDERING, TAT_TRAIT_STRAYING_SOUL, TAT_TRAIT_HERETIC)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_RESIDENT))
		apply_resident_package(H)
		apply_resident_advjob(H)
	if(has_trait(TAT_TRAIT_SPELLBLADE))
		apply_spellblade_package(H)
	if(has_trait(TAT_TRAIT_SOUNDBREAKER))
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/soundbreaker_codex(H), SLOT_IN_BACKPACK)
	if(has_trait(TAT_TRAIT_TROPHY_BOUNTY))
		H.LoadComponent(/datum/component/trophy_hunter)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/trophy_rules(H), SLOT_IN_BACKPACK)
	if(has_trait(TAT_TRAIT_RONIN))
		H.LoadComponent(/datum/component/combo_core/ronin)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/ronin_codex(H), SLOT_IN_BACKPACK)
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
	if(has_trait(TAT_TRAIT_WARRIOR_MASTER))
		ADD_TRAIT(H, TRAIT_BADTRAINER, TAT_TRAIT_SOURCE)
	if(has_trait(TAT_TRAIT_WANTED))
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
		wretch_select_bounty(H)
	if(has_trait(TAT_TRAIT_HERETIC))
		GLOB.excommunicated_players += H.real_name
	apply_divine_package(H)
	apply_mage_package(H)
	apply_druid_package(H)
	apply_witch_package(H)
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
		if(data[trait_id])
			add_trait(trait_id)
	return TRUE

/datum/tat_traits/proc/export_to_json_list()
	var/list/result = list()
	for(var/trait_id in selected)
		if(selected[trait_id])
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
			add_trait("[key]")
	return TRUE

/datum/tat_traits/proc/get_tat_resident_advjob()
	if(!has_trait(TAT_TRAIT_RESIDENT))
		return null

	var/stored_advjob = owner_build?.get_magic_value("resident_advjob")
	if(stored_advjob)
		return stored_advjob

	if(has_trait(TAT_TRAIT_WITCH_INITIATE))
		return /datum/advclass/witch

	if((owner_build?.get_skill_value(/datum/skill/craft/blacksmithing) || 0) > 0)
		return /datum/advclass/blacksmith

	if((owner_build?.get_skill_value(/datum/skill/labor/mining) || 0) > 0)
		return /datum/advclass/miner

	if((owner_build?.get_skill_value(/datum/skill/craft/carpentry) || 0) > 0)
		return /datum/advclass/woodworker

	if((owner_build?.get_skill_value(/datum/skill/labor/fishing) || 0) > 0)
		return /datum/advclass/fisher

	if((owner_build?.get_skill_value(/datum/skill/craft/sewing) || 0) > 0)
		return /datum/advclass/seamstress

	return null

/datum/tat_traits/proc/apply_resident_advjob(mob/living/carbon/human/H)
	if(!H || !has_trait(TAT_TRAIT_RESIDENT))
		return

	var/datum/advclass/resident_advjob = get_tat_resident_advjob()
	if(!resident_advjob)
		return

	var/datum/advclass/advclass = SSrole_class_handler.get_advclass_by_name(resident_advjob.name)
	if(!advclass)
		return

	H.advjob = resident_advjob.name
