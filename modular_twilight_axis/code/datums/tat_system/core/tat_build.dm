
/datum/tat_build
	var/datum/preferences/owner_preferences = null

	var/datum/tat_stats/stats
	var/datum/tat_items/items
	var/datum/tat_traits/traits
	var/datum/tat_skills/skills

	var/list/magic_profile = list()

	var/last_exported_json = null
	var/last_json_error = null
	var/last_json_notice = null

	var/list/tat_slots = list()
	var/active_tat_slot = 1
	var/list/tat_presets = list()
	var/list/ui_tat_presets_cache = null

	var/dirty = FALSE

/datum/tat_build/New(datum/preferences/P)
	. = ..()
	owner_preferences = P
	stats = new(src)
	items = new(src)
	traits = new(src)
	skills = new(src)
	reset()
	init_tat_slots()

/datum/tat_build/proc/reset()
	traits.reset()
	stats.reset()
	skills.reset()
	items.reset()
	magic_profile = list()
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/attach_preferences(datum/preferences/P)
	owner_preferences = P
	return TRUE

/datum/tat_build/proc/set_dirty(flag = TRUE)
	dirty = !!flag
	return dirty

/datum/tat_build/proc/get_active_virtues()
	var/list/result = list()
	if(!owner_preferences)
		return result

	var/single_virtue = owner_preferences.vars["virtue"]
	var/single_virtuetwo = owner_preferences.vars["virtuetwo"]
	if(single_virtue)
		result += single_virtue
	if(single_virtuetwo)
		result += single_virtuetwo

	var/list/candidates = list(
		owner_preferences.vars["virtues"],
		owner_preferences.vars["selected_virtues"],
		owner_preferences.vars["active_virtues"],
		owner_preferences.vars["virtue_list"],
	)

	for(var/list/L as anything in candidates)
		if(!islist(L))
			continue
		for(var/entry in L)
			if(!(entry in result))
				result += entry

	return result

/datum/tat_build/proc/get_magic_value(key, default_value = null)
	if(!istext(key) || !length(key))
		return default_value
	if(!(key in magic_profile))
		return default_value
	return magic_profile[key]

/datum/tat_build/proc/set_magic_value(key, value)
	if(!istext(key) || !length(key))
		return FALSE
	if(isnull(value))
		magic_profile -= key
	else
		magic_profile[key] = value
	set_dirty()
	return TRUE

/datum/tat_build/proc/has_trait(trait_id)
	return traits.has_trait(trait_id)

/datum/tat_build/proc/get_trait_cost_display(trait_id)
	return traits.get_display_cost(trait_id)

/datum/tat_build/proc/get_stat_value(stat_id)
	return stats.get_value(stat_id)

/datum/tat_build/proc/get_skill_value(skill_type)
	return skills.get_total_value(skill_type)

/datum/tat_build/proc/get_invested_skill_value(skill_type)
	return skills.get_invested_value(skill_type)

/datum/tat_build/proc/get_item_amount(item_path)
	return items.get_amount(item_path)

/datum/tat_build/proc/get_bonus_stat_points()
	return traits.get_bonus_stat_points()

/datum/tat_build/proc/get_bonus_item_points()
	return traits.get_bonus_item_points()

/datum/tat_build/proc/get_bonus_skill_domain_points(domain)
	return traits.get_bonus_skill_domain_points(domain)

/datum/tat_build/proc/get_bonus_skill_value(skill_type)
	var/trait_bonus = traits.get_bonus_skill_value(skill_type)
	var/virtue_bonus = skills.get_virtue_bonus_value(skill_type)
	return max(trait_bonus, virtue_bonus)

/datum/tat_build/proc/get_skill_cap_bonus_value(skill_type)
	return traits.get_skill_cap_bonus_value(skill_type)

/datum/tat_build/proc/get_skill_cost_discount(skill_type, target_level)
	return traits.get_skill_cost_discount(skill_type, target_level)

/datum/tat_build/proc/can_keep_item(item_path)
	return items.check_item(item_path)

/datum/tat_build/proc/get_effective_divine_tier()
	return traits.get_effective_divine_tier()

/datum/tat_build/proc/get_divine_passive_gain_for_tier(cleric_tier)
	return traits.get_divine_passive_gain_for_tier(cleric_tier)

/datum/tat_build/proc/get_divine_devotion_limit_for_tier(cleric_tier)
	return traits.get_divine_devotion_limit_for_tier(cleric_tier)

/datum/tat_build/proc/build_mage_aspects(scale_with_arcane = TRUE)
	return traits.build_mage_aspects(scale_with_arcane)

/datum/tat_build/proc/can_train_arcane()
	return traits.can_train_arcane()

/datum/tat_build/proc/can_train_holy()
	return traits.can_train_holy()

/datum/tat_build/proc/can_train_druidic()
	return traits.can_train_druidic()

/datum/tat_build/proc/has_invalid_trait_dependencies()
	return traits.has_invalid_trait_dependencies()

/datum/tat_build/proc/has_invalid_supply_items()
	return items.has_invalid_supply_items()

/datum/tat_build/proc/get_validation_issues()
	var/list/issues = list()

	if(stats.get_remaining_points() < 0)
		issues += "Spent too many stat points."
	if(skills.get_any_negative_remaining())
		issues += "Spent too many skill points."
	if(traits.get_remaining_points() < 0)
		issues += "Spent too many trait points."
	if(items.get_remaining_points() < 0)
		issues += "Spent too many item points."

	var/list/trait_issues = traits.has_invalid_trait_dependencies()
	if(length(trait_issues))
		issues += trait_issues

	var/list/item_issues = items.has_invalid_supply_items()
	if(length(item_issues))
		issues += item_issues

	return issues

/datum/tat_build/proc/is_budget_valid()
	return !length(get_validation_issues())

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
	var/datum/new_spell = new spell_type
	if(!new_spell)
		return FALSE
	H.mind.AddSpell(new_spell)
	return TRUE

/datum/tat_build/proc/get_resident_skill_value(skill_type)
	if(skill_type == /datum/skill/misc/reading)
		return 3
	return 0

/datum/tat_build/proc/get_resident_pugilist_spell_choice(mob/living/carbon/human/H)
	var/list/options = list(
		"Headbutt - Vulnerable Debuff",
		"Chokeslam - Stamina Damage",
		"Stunner - Dazed Debuff",
		"Dropkick - Pushback + Extra Damage"
	)
	if(!H?.client)
		return TAT_RESIDENT_PUGILIST_DEFAULT
	return tgui_input_list(H, "Choose your resident pugilist style.", "Resident Pugilist", options) || TAT_RESIDENT_PUGILIST_DEFAULT

/datum/tat_build/proc/get_resident_pugilist_spell_type(choice)
	switch(choice)
		if("Dropkick - Pushback + Extra Damage")
			return /obj/effect/proc_holder/spell/invoked/dropkick
		if("Chokeslam - Stamina Damage")
			return /obj/effect/proc_holder/spell/invoked/chokeslam
		if("Stunner - Dazed Debuff")
			return /obj/effect/proc_holder/spell/invoked/stunner
	return /obj/effect/proc_holder/spell/invoked/headbutt

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

/datum/tat_build/proc/sanitize()
	traits.sanitize()
	stats.sanitize()
	skills.sanitize()
	items.sanitize()
	dirty = FALSE
	return TRUE


/datum/tat_build/proc/build_slot_summary_from_data(list/build_data)
	if(!islist(build_data))
		return list("stats" = 0, "skills" = 0, "traits" = 0, "items" = 0)

	var/stats_spent = 0
	var/list/stat_data = build_data["stats"]
	if(islist(stat_data))
		var/list/all_stats = list(TAT_AVAILABLE_STATS_LIST)
		for(var/stat_id in TAT_STATS_ORDER_LIST)
			var/list/entry = all_stats[stat_id]
			if(!islist(entry))
				continue

			var/base = isnum(entry["base"]) ? entry["base"] : 10
			var/minimum = isnum(entry["min"]) ? entry["min"] : 1
			var/cost = isnum(entry["cost"]) ? entry["cost"] : 0
			var/value = isnum(stat_data[stat_id]) ? stat_data[stat_id] : base

			if(value > base)
				stats_spent += (value - base) * cost
			else
				stats_spent += (max(value, minimum) - base) * cost

	var/skills_spent = 0
	var/list/skill_data = build_data["skills"]
	var/list/invested_skills = null

	if(islist(skill_data))
		if(islist(skill_data["invested"]))
			invested_skills = skill_data["invested"]
		else
			invested_skills = skill_data

	if(islist(invested_skills))
		for(var/skill_type in invested_skills)
			if(skill_type == "bonus" || skill_type == "invested")
				continue

			var/level = round(invested_skills[skill_type] || 0)
			for(var/i in 1 to level)
				skills_spent += i

	var/traits_spent = 0
	var/list/trait_data = build_data["traits"]

	if(islist(trait_data))
		var/list/all_traits = GLOB.tat_available_traits
		var/has_outlander = !!trait_data[TRAIT_OUTLANDER]

		for(var/trait_id in trait_data)
			if(!trait_data[trait_id])
				continue

			var/list/entry = all_traits[trait_id]
			if(!islist(entry))
				continue

			var/cost = isnum(entry["cost"]) ? entry["cost"] : 0

			if(trait_id == TAT_TRAIT_BONUS_STAT_POOL && has_outlander)
				cost -= TAT_TRAIT_DISCOUNT

			traits_spent += cost

	var/items_spent = 0
	var/list/item_data = build_data["items"]
	var/list/selected_items = null

	if(islist(item_data))
		if(islist(item_data["selected"]))
			selected_items = item_data["selected"]
		else
			selected_items = item_data

	if(islist(selected_items))
		var/list/all_items = GLOB.tat_available_items
		for(var/item_path in selected_items)
			if(item_path == "selected" || item_path == "item_loadout")
				continue

			var/list/entry = all_items[item_path]
			if(!islist(entry))
				continue

			var/cost = isnum(entry["cost"]) ? entry["cost"] : 0
			var/amount = round(selected_items[item_path] || 0)

			items_spent += cost * amount

	return list(
		"stats" = stats_spent,
		"skills" = skills_spent,
		"traits" = traits_spent,
		"items" = items_spent,
	)

/datum/tat_build/proc/export_slot_build_to_list()
	return list(
		"stats" = stats.export_to_list(),
		"items" = items.export_to_list(),
		"traits" = traits.export_to_list(),
		"skills" = skills.export_to_list(),
		"magic_profile" = magic_profile.Copy(),
		"magic_config" = magic_profile.Copy(),
	)

/datum/tat_build/proc/export_to_list()
	init_tat_slots()
	return list(
		"stats" = stats.export_to_list(),
		"items" = items.export_to_list(),
		"traits" = traits.export_to_list(),
		"skills" = skills.export_to_list(),
		"magic_profile" = magic_profile.Copy(),
		"magic_config" = magic_profile.Copy(),
		"tat_slots" = export_tat_slots_to_list(),
		"active_tat_slot" = active_tat_slot,
	)

/datum/tat_build/proc/load_slot_build_from_list(list/data)
	reset()
	if(!islist(data))
		return FALSE
	traits.import_from_list(data["traits"])
	stats.import_from_list(data["stats"])
	skills.import_from_list(data["skills"])
	items.import_from_list(data["items"])
	if(islist(data["magic_profile"]))
		var/list/temp = data["magic_profile"]
		magic_profile = temp.Copy()
	else if(islist(data["magic_config"]))
		var/list/temp = data["magic_config"]
		magic_profile = temp.Copy()
	sanitize()
	return TRUE

/datum/tat_build/proc/load_from_list(list/data)
	reset()
	if(!islist(data))
		load_tat_slots_from_list(null, 1)
		return FALSE
	traits.import_from_list(data["traits"])
	stats.import_from_list(data["stats"])
	skills.import_from_list(data["skills"])
	items.import_from_list(data["items"])
	if(islist(data["magic_profile"]))
		var/list/temp = data["magic_profile"]
		magic_profile = temp.Copy()
	else if(islist(data["magic_config"]))
		var/list/temp = data["magic_config"]
		magic_profile = temp.Copy()

	var/list/_tat_slots = data["tat_slots"]
	var/_active_tat_slot = data["active_tat_slot"]
	if(islist(_tat_slots) || !isnull(_active_tat_slot))
		load_tat_slots_from_list(_tat_slots, _active_tat_slot)
	else
		load_tat_slots_from_list(null, 1)

	sanitize()
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/apply_pre_client_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	sanitize()
	traits.apply_instant_to_human(H)
	items.apply_to_human(H)
	stats.apply_to_human(H)
	skills.apply_to_human(H)
	return TRUE

/datum/tat_build/proc/apply_post_client_to_human(mob/living/carbon/human/H)
	if(!H || !H.client)
		return FALSE
	sanitize()
	traits.apply_deferred_to_human(H)
	return TRUE

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!apply_pre_client_to_human(H))
		return FALSE
	if(!H.client)
		return TRUE
	return apply_post_client_to_human(H)

/datum/tat_build/proc/disable_from_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	items.disable_from_human(H)
	skills.disable_from_human(H)
	traits.disable_from_human(H)
	stats.disable_from_human(H)
	return TRUE

/datum/tat_build/proc/get_default_tat_slot_name(slot_id)
	return "Slot [slot_id]"

/datum/tat_build/proc/normalize_tat_slot_index(slot_id)
	var/index = round(text2num("[slot_id]"))
	if(index < 1)
		index = 1
	if(index > TAT_SLOT_COUNT)
		index = TAT_SLOT_COUNT
	return index

/datum/tat_build/proc/init_tat_slots()
	if(!islist(tat_slots))
		tat_slots = list()

	while(tat_slots.len < TAT_SLOT_COUNT)
		tat_slots += null

	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = tat_slots[i]
		if(!istype(slot, /datum/tat_slot))
			slot = new /datum/tat_slot(get_default_tat_slot_name(i))
			tat_slots[i] = slot
		if(!istext(slot.name) || !length(slot.name))
			slot.name = get_default_tat_slot_name(i)
		if(!islist(slot.build_data))
			slot.set_build_data(list())

	active_tat_slot = normalize_tat_slot_index(active_tat_slot)
	return TRUE

/datum/tat_build/proc/get_tat_slot(slot_id) as /datum/tat_slot
	init_tat_slots()
	var/index = normalize_tat_slot_index(slot_id)
	var/datum/tat_slot/slot = tat_slots[index]
	if(!istype(slot, /datum/tat_slot))
		slot = new /datum/tat_slot(get_default_tat_slot_name(index))
		tat_slots[index] = slot
	if(!istext(slot.name) || !length(slot.name))
		slot.name = get_default_tat_slot_name(index)
	if(!islist(slot.build_data))
		slot.set_build_data(list())
	return slot

/datum/tat_build/proc/save_current_to_slot(slot_id)
	init_tat_slots()
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot)
		return FALSE
	slot.set_build_data(export_slot_build_to_list())
	return TRUE

/datum/tat_build/proc/save_current_to_active_slot()
	if(!save_current_to_slot(active_tat_slot))
		return FALSE
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/load_slot_into_current(slot_id)
	init_tat_slots()
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot)
		return FALSE
	var/list/build_data = slot.get_build_data()
	if(!islist(build_data) || !length(build_data))
		reset()
		dirty = FALSE
		return TRUE
	load_slot_build_from_list(build_data)
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/set_active_tat_slot(slot_id)
	init_tat_slots()
	active_tat_slot = normalize_tat_slot_index(slot_id)
	if(!load_slot_into_current(active_tat_slot))
		return FALSE
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/rename_tat_slot(slot_id, new_name)
	init_tat_slots()
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot || !istext(new_name))
		return FALSE
	new_name = trim(new_name)
	if(!length(new_name))
		return FALSE
	new_name = copytext(new_name, 1, 33)
	slot.name = new_name
	return TRUE

/datum/tat_build/proc/export_tat_slots_to_list()
	init_tat_slots()
	var/list/result = list()
	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = get_tat_slot(i)
		result += list(slot.export_to_list())
	return result

/datum/tat_build/proc/load_tat_slots_from_list(list/slots_data, active_slot = 1)
	tat_slots = list()
	for(var/i in 1 to TAT_SLOT_COUNT)
		var/datum/tat_slot/slot = new /datum/tat_slot(get_default_tat_slot_name(i))
		var/list/raw_slot = null
		if(islist(slots_data))
			if(i <= length(slots_data) && islist(slots_data[i]))
				raw_slot = slots_data[i]
			else
				var/text_index = "[i]"
				if(!isnull(slots_data[text_index]) && islist(slots_data[text_index]))
					raw_slot = slots_data[text_index]
		if(islist(raw_slot))
			slot.load_from_list(raw_slot)
		if(!istext(slot.name) || !length(slot.name))
			slot.name = get_default_tat_slot_name(i)
		if(!islist(slot.build_data))
			slot.set_build_data(list())
		tat_slots += slot
	active_tat_slot = normalize_tat_slot_index(active_slot)
	dirty = FALSE
	return TRUE

/datum/tat_build/proc/load_from_preferences(datum/preferences/P)
	if(!P)
		return FALSE
	attach_preferences(P)
	if(istype(P.tat_build, /datum/tat_build))
		var/datum/tat_build/source_build = P.tat_build
		if(source_build == src)
			return TRUE
		load_from_list(source_build.export_to_list())
		dirty = FALSE
		return TRUE
	var/list/tat_data = P.tat_build
	if(islist(tat_data))
		load_from_list(tat_data)
	else
		load_tat_slots_from_list(null, 1)
		reset()
		dirty = FALSE
	return TRUE

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()
	tat_build.attach_preferences(src)
	if(islist(tat_data))
		tat_build.load_from_list(tat_data)
	else
		tat_build.load_tat_slots_from_list(null, 1)
		tat_build.reset()
	tat_build.dirty = FALSE

/datum/tat_build/proc/export_to_json()
	last_json_error = null
	last_json_notice = null

	var/list/data = list()
	data["version"] = 1
	data["stats"] = stats?.export_to_json_list()
	data["skills"] = skills?.export_to_json_list()
	data["traits"] = traits?.export_to_json_list()
	data["items"] = items?.export_to_json_list()

	last_exported_json = json_encode(data)
	last_json_notice = "Build exported."
	return last_exported_json

/datum/tat_build/proc/import_from_json(raw)
	last_json_error = null
	last_json_notice = null

	if(!istext(raw) || !length(raw))
		last_json_error = "Empty JSON."
		return FALSE

	var/list/data
	try
		data = json_decode(raw)
	catch()
		last_json_error = "Invalid JSON."
		return FALSE

	if(!islist(data))
		last_json_error = "JSON root must be an object."
		return FALSE

	var/raw_version = data["version"]
	var/version = round(text2num("[raw_version]") || 1)
	if(version != 1)
		last_json_error = "Unsupported TAT build JSON version: [version]."
		return FALSE

	reset()
	traits.import_from_json_list(data["traits"])
	stats.import_from_json_list(data["stats"])
	skills.import_from_json_list(data["skills"])
	items.import_from_json_list(data["items"])
	
	sanitize()
	set_dirty(TRUE)

	last_exported_json = raw
	last_json_notice = "Build imported."
	return TRUE

/datum/tat_build/proc/get_role_bucket()
	if(traits?.has_trait(TAT_TRAIT_RESIDENT))
		return TAT_ROLE_BUCKET_TOWNER

	if(traits?.has_trait(TAT_TRAIT_WANTED) || traits?.has_trait(TRAIT_OUTLANDER))
		return TAT_ROLE_BUCKET_ADVENTURER

	return TAT_ROLE_BUCKET_TRADER
