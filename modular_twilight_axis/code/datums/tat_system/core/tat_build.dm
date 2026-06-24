/datum/tat_build
	var/datum/preferences/owner_preferences = null

	var/datum/tat_stats/stats
	var/datum/tat_items/items
	var/datum/tat_traits/traits
	var/datum/tat_skills/skills
	var/datum/tat_directions/directions

	var/list/magic_profile = list()
	var/list/_cached_active_virtues = null
	var/_cached_active_virtues_key = null
	var/_cached_preference_loadout_key = null
	var/_cached_owner_patron_type = null
	var/list/_cached_ui_data = null
	var/_ui_data_cache_dirty = TRUE

	var/last_exported_json = null
	var/last_json_error = null
	var/last_json_notice = null

	var/list/tat_slots = list()
	var/active_tat_slot = 1
	var/list/tat_presets = list()
	var/list/ui_tat_presets_cache = null

	var/list/ui_items_state_cache = null
	var/list/ui_loadout_cache = null
	var/list/ui_skills_cache = null
	var/list/ui_tat_slots_cache = null

	var/dirty = FALSE

/datum/tat_build/New(datum/preferences/P)
	. = ..()
	owner_preferences = P
	stats = new(src)
	items = new(src)
	traits = new(src)
	skills = new(src)
	directions = new(src)
	reset()
	init_tat_slots()

/datum/tat_build/proc/reset()
	traits.reset()
	directions.reset()
	stats.reset()
	skills.reset()
	items.reset()
	magic_profile = list()
	_cached_preference_loadout_key = null
	_cached_owner_patron_type = null
	dirty = FALSE
	invalidate_ui_data_cache()
	return TRUE

/datum/tat_build/proc/attach_preferences(datum/preferences/P)
	owner_preferences = P
	return TRUE

/datum/tat_build/proc/get_owner_ckey()
	if(owner_preferences)
		var/client/parent_client = owner_preferences.parent
		if(parent_client?.ckey)
			return parent_client.ckey
	if(usr?.ckey)
		return usr.ckey
	return null

/datum/tat_build/proc/get_owner_client()
	if(owner_preferences)
		var/client/parent_client = owner_preferences.parent
		if(parent_client)
			return parent_client
	if(usr?.client)
		return usr.client
	return null

/datum/tat_build/proc/is_owner_admin()
	var/client/owner_client = get_owner_client()
	if(owner_client?.holder)
		return TRUE

	var/owner_ckey = get_owner_ckey()
	if(owner_ckey && usr?.client?.holder && usr.ckey == owner_ckey)
		return TRUE

	return FALSE

/datum/tat_build/proc/can_select_contractor_trait()
	return is_owner_admin() //TRUE для фулланлока

/datum/tat_build/proc/has_dendor_patron()
	return owner_preferences?.selected_patron?.type == /datum/patron/divine/dendor

/datum/tat_build/proc/can_select_druid_initiate_trait()
	return has_dendor_patron()

/datum/tat_build/proc/is_owner_tat_banned(mob/user = null)
	if(user?.ckey)
		return tat_is_ckey_banned(user.ckey)
	var/key = get_owner_ckey()
	if(!key)
		return FALSE
	return tat_is_ckey_banned(key)

/datum/tat_build/proc/is_owner_tat_role_locked(mob/user = null)
	var/key = user?.ckey || get_owner_ckey()
	if(!key)
		return FALSE
	return tat_is_role_bucket_locked(key, get_role_bucket())

/datum/tat_build/proc/get_owner_tat_role_lock_message(mob/user = null)
	var/key = user?.ckey || get_owner_ckey()
	var/bucket = get_role_bucket()
	var/bucket_name = tat_role_bucket_display_name(bucket)
	var/reason = key ? tat_get_role_lock_reason(key, bucket) : null
	if(!reason)
		reason = TAT_ROLE_LOCK_DEFAULT_REASON
	return "You are locked out of the TAT [bucket_name] role bucket. Reason: [reason]"

/datum/tat_build/proc/get_owner_playerquality()
	var/key = get_owner_ckey()
	if(!key)
		return 0
	return round(get_playerquality(key))

/datum/tat_build/proc/invalidate_ui_caches()
	return invalidate_ui_data_cache()

/datum/tat_build/proc/get_active_tat_slot_name()
	init_tat_slots()
	var/datum/tat_slot/slot = get_tat_slot(active_tat_slot)
	if(!slot || !istext(slot.name) || !length(trim(slot.name)))
		return get_default_tat_slot_name(active_tat_slot)
	return trim(slot.name)

/datum/tat_build/proc/set_dirty(flag = TRUE)
	dirty = !!flag
	invalidate_ui_data_cache()
	return dirty

/datum/tat_build/proc/invalidate_ui_data_cache()
	_cached_ui_data = null
	_ui_data_cache_dirty = TRUE
	ui_items_state_cache = null
	ui_loadout_cache = null
	ui_skills_cache = null
	ui_tat_slots_cache = null
	return TRUE

/datum/tat_build/proc/get_active_virtues_cache_key(datum/preferences/P)
	if(!P)
		return null

	var/list/parts = list()
	var/list/virtues = list(P.virtue, P.virtuetwo)
	for(var/virtue_entry in virtues)
		var/datum/virtue/virtue = virtue_entry
		if(!virtue || istype(virtue, /datum/virtue/none))
			parts += "none"
			continue

		var/part = "[virtue.type]:[REF(virtue)]"
		if(islist(virtue.picked_choices))
			for(var/choice in virtue.picked_choices)
				part += ":[choice]"
		parts += part
	return parts.Join("|")

/datum/tat_build/proc/get_preference_loadout_cache_key(datum/preferences/P)
	if(!P || !islist(P.selected_loadout_items))
		return ""
	var/list/parts = list()
	for(var/key in P.selected_loadout_items)
		parts += "[key]"
	return parts.Join("|")

/datum/tat_build/proc/attach_preferences_from_mob(mob/user)
	if(!user?.client?.prefs)
		return FALSE
	var/datum/preferences/P = user.client.prefs
	if(P.tat_build != src)
		return FALSE

	var/new_virtues_key = get_active_virtues_cache_key(P)
	var/new_loadout_key = get_preference_loadout_cache_key(P)
	var/new_patron_type = P.selected_patron?.type
	var/preferences_changed = owner_preferences != P
	var/virtues_changed = _cached_active_virtues_key != new_virtues_key
	var/loadout_changed = _cached_preference_loadout_key != new_loadout_key
	var/patron_changed = _cached_owner_patron_type != new_patron_type

	owner_preferences = P

	if(preferences_changed || virtues_changed || patron_changed)
		_cached_active_virtues = null
		_cached_active_virtues_key = null
		_cached_owner_patron_type = new_patron_type
		skills?.sanitize(FALSE)
		traits?.sanitize()
		invalidate_ui_data_cache()

	if(loadout_changed)
		_cached_preference_loadout_key = new_loadout_key
		items?.sync_external_grants()
		invalidate_ui_data_cache()

	if(!preferences_changed && !virtues_changed && !loadout_changed && !patron_changed)
		attach_preferences(P)

	return TRUE

/datum/tat_build/proc/get_active_virtues()
	var/cache_key = get_active_virtues_cache_key(owner_preferences)
	if(islist(_cached_active_virtues) && _cached_active_virtues_key == cache_key)
		return _cached_active_virtues
	var/list/result = list()
	if(!owner_preferences)
		_cached_active_virtues = result
		_cached_active_virtues_key = cache_key
		return result

	if(owner_preferences.virtue && !istype(owner_preferences.virtue, /datum/virtue/none))
		result += owner_preferences.virtue

	if(owner_preferences.virtuetwo && !istype(owner_preferences.virtuetwo, /datum/virtue/none))
		if(!(owner_preferences.virtuetwo in result))
			result += owner_preferences.virtuetwo

	_cached_active_virtues = result
	_cached_active_virtues_key = cache_key
	return result

/datum/tat_build/proc/invalidate_active_virtues_cache()
	_cached_active_virtues = null
	_cached_active_virtues_key = null

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

/datum/tat_build/proc/has_built_in_weapon_training()
	return directions?.foundation == TAT_FOUNDATION_WANDERER

/datum/tat_build/proc/has_built_in_weapon_training_foundation()
	return directions?.foundation == TAT_FOUNDATION_WANDERER

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
	var/total = traits.get_bonus_stat_points()
	if(directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
		total += TAT_BUILD_STAT_BONUS_WANTED
	return total

/datum/tat_build/proc/get_bonus_item_points()
	var/total = traits.get_bonus_item_points()
	if(directions?.get_role_choice() == TAT_ROLE_CHOICE_WRETCH)
		total += TAT_BUILD_ITEM_BONUS_WANTED
	return total

/datum/tat_build/proc/get_bonus_skill_domain_points(domain)
	var/total = traits.get_bonus_skill_domain_points(domain)
	if(domain == TAT_SKILL_DOMAIN_COMBAT)
		if(has_trait(TAT_TRAIT_WEAPON_TRAINING))
			total += 6
		if(directions?.foundation == TAT_FOUNDATION_WANDERER)
			total += 3
		if(directions?.get_points(TAT_DIRECTION_COMBAT) >= 1)
			total += 3
			if(directions?.foundation == TAT_FOUNDATION_WANDERER)
				total += 6
	switch(directions?.get_role_choice())
		if(TAT_ROLE_CHOICE_ADVENTURER)
			if(domain == TAT_SKILL_DOMAIN_ADVENTURE)
				total += 6
		if(TAT_ROLE_CHOICE_WRETCH)
			if(domain == TAT_SKILL_DOMAIN_ADVENTURE)
				total += 6
			else if(domain == TAT_SKILL_DOMAIN_COMBAT && has_trait(TAT_TRAIT_WEAPON_TRAINING))
				total += 6
		if(TAT_ROLE_CHOICE_TOWNER)
			if(domain == TAT_SKILL_DOMAIN_PEACEFUL)
				total += 6
		if(TAT_ROLE_CHOICE_TRADER)
			if(domain == TAT_SKILL_DOMAIN_ADVENTURE)
				total += 3
			else if(domain == TAT_SKILL_DOMAIN_PEACEFUL)
				total += 3
	return total

/datum/tat_build/proc/get_bonus_skill_value(skill_type)
	var/trait_bonus = traits.get_bonus_skill_value(skill_type)
	var/virtue_bonus = skills.get_virtue_bonus_value(skill_type)
	return round(trait_bonus + virtue_bonus)

/datum/tat_build/proc/get_skill_cap_bonus_value(skill_type)
	var/trait_cap = traits.get_skill_cap_bonus_value(skill_type)
	var/virtue_cap = skills.get_virtue_skill_cap_bonus(skill_type)
	return round(max(trait_cap, virtue_cap))

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

/datum/tat_build/proc/sanitize()
	directions.sanitize()
	traits.sanitize()
	stats.sanitize()
	skills.sanitize()
	items.sanitize()
	dirty = FALSE
	invalidate_ui_data_cache()
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
	var/capped_negative_trait_credit = 0
	var/list/trait_data = build_data["traits"]

	if(islist(trait_data))
		var/list/all_traits = GLOB.tat_available_traits

		for(var/key in trait_data)
			var/trait_id = key
			var/count = 1
			if(!islist(all_traits[trait_id]))
				trait_id = trait_data[key]
				count = 1
			else if(isnum(trait_data[key]))
				count = max(0, round(trait_data[key]))
			else if(!trait_data[key])
				count = 0

			var/list/entry = all_traits[trait_id]
			if(!islist(entry) || count <= 0)
				continue

			var/cost = isnum(entry["cost"]) ? entry["cost"] : 0

			var/total_cost = cost * count
			if((trait_id in GLOB.tat_capped_negative_traits) && total_cost < 0)
				capped_negative_trait_credit += -total_cost
			else
				traits_spent += total_cost

	traits_spent -= min(capped_negative_trait_credit, TAT_NEGATIVE_TRAIT_CREDIT_CAP)

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
		"directions" = directions.export_to_list(),
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
		"directions" = directions.export_to_list(),
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
	directions.import_from_list(data["directions"])
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
	directions.import_from_list(data["directions"])
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
		var/datum/tat_slot/active_slot = get_tat_slot(active_tat_slot)
		var/list/active_data = active_slot?.get_build_data()

		if(islist(active_data) && length(active_data))
			load_slot_build_from_list(active_data)
	else
		load_tat_slots_from_list(null, 1)

	sanitize()
	dirty = FALSE
	invalidate_ui_data_cache()

	return TRUE

/datum/tat_build/proc/apply_pre_client_to_human(mob/living/carbon/human/H)
	attach_preferences_from_mob(H)

	if(!H)
		return FALSE

	if(is_owner_tat_banned(H))
		tat_tell_banned(H)
		return FALSE

	H.tat_handles_preference_loadout = TRUE
	items?.sync_external_grants()

	sanitize()

	traits.apply_instant_to_human(H)
	items.apply_to_human(H)

	return TRUE

/datum/tat_build/proc/apply_post_client_to_human(mob/living/carbon/human/H)
	attach_preferences_from_mob(H)

	if(!H || !H.client)
		return FALSE

	if(is_owner_tat_banned(H))
		tat_tell_banned(H)
		return FALSE

	sanitize()

	traits.apply_deferred_to_human(H)
	stats.apply_to_human(H)
	skills.apply_to_human(H)

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
	slot.set_build_data(export_slot_build_to_list(), src)
	invalidate_ui_data_cache()
	return TRUE

/datum/tat_build/proc/save_current_to_active_slot()
	if(!save_current_to_slot(active_tat_slot))
		return FALSE
	dirty = FALSE
	invalidate_ui_data_cache()
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
		invalidate_ui_data_cache()
		return TRUE
	load_slot_build_from_list(build_data)
	dirty = FALSE
	invalidate_ui_data_cache()
	return TRUE

/datum/tat_build/proc/set_active_tat_slot(slot_id)
	init_tat_slots()
	active_tat_slot = normalize_tat_slot_index(slot_id)
	if(!load_slot_into_current(active_tat_slot))
		return FALSE
	dirty = FALSE
	invalidate_ui_data_cache()
	return TRUE

/datum/tat_build/proc/rename_tat_slot(slot_id, new_name)
	init_tat_slots()
	var/datum/tat_slot/slot = get_tat_slot(slot_id)
	if(!slot || !istext(new_name))
		return FALSE
	new_name = trim(new_name)
	if(!length(new_name))
		return FALSE
	new_name = copytext(new_name, 1, 50)
	slot.name = new_name
	invalidate_ui_data_cache()
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
			slot.load_from_list(raw_slot, src)
		if(!istext(slot.name) || !length(slot.name))
			slot.name = get_default_tat_slot_name(i)
		if(!islist(slot.build_data))
			slot.set_build_data(list())
		tat_slots += slot
	active_tat_slot = normalize_tat_slot_index(active_slot)
	dirty = FALSE
	invalidate_ui_data_cache()
	return TRUE

/datum/tat_build/proc/export_to_json()
	invalidate_ui_data_cache()
	last_json_error = null
	last_json_notice = null

	var/list/data = list()
	data["version"] = 1
	data["stats"] = stats?.export_to_json_list()
	data["skills"] = skills?.export_to_json_list()
	data["traits"] = traits?.export_to_json_list()
	data["directions"] = directions?.export_to_json_list()
	data["items"] = items?.export_to_json_list()

	last_exported_json = json_encode(data)
	last_json_notice = "Build exported."
	return last_exported_json

/datum/tat_build/proc/import_from_json(raw)
	invalidate_ui_data_cache()
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
	directions.import_from_json_list(data["directions"])
	stats.import_from_json_list(data["stats"])
	skills.import_from_json_list(data["skills"])
	items.import_from_json_list(data["items"])
	
	sanitize()
	set_dirty(TRUE)

	last_exported_json = raw
	last_json_notice = "Build imported."
	return TRUE

/datum/tat_build/proc/get_role_bucket()
	if(directions)
		return directions.get_role_choice()

	if(traits?.has_trait(TAT_TRAIT_RESIDENT))
		return TAT_ROLE_BUCKET_TOWNER

	if(traits?.has_trait(TRAIT_OUTLANDER))
		return TAT_ROLE_BUCKET_ADVENTURER

	if(traits?.has_trait(TAT_TRAIT_WANTED))
		return TAT_ROLE_BUCKET_WRETCH

	return TAT_ROLE_BUCKET_TRADER

/datum/tat_build/proc/trait_data_has_trait(list/trait_data, trait_id)
	if(!islist(trait_data) || isnull(trait_id))
		return FALSE

	var/value = trait_data[trait_id]
	if(isnum(value))
		return round(value) > 0

	if(!isnull(value))
		return !!value

	return (trait_id in trait_data)

/datum/tat_build/proc/get_role_bucket_from_data(list/build_data)
	var/list/trait_data = islist(build_data) ? build_data["traits"] : null
	var/list/direction_data = islist(build_data) ? build_data["directions"] : null
	var/foundation = islist(direction_data) ? direction_data["foundation"] : null
	var/role_choice = islist(direction_data) ? direction_data["role_choice"] : null

	if(role_choice in list(TAT_ROLE_BUCKET_TOWNER, TAT_ROLE_BUCKET_TRADER, TAT_ROLE_BUCKET_ADVENTURER, TAT_ROLE_BUCKET_WRETCH))
		return role_choice

	if(trait_data_has_trait(trait_data, TAT_TRAIT_RESIDENT))
		return TAT_ROLE_BUCKET_TOWNER

	if(trait_data_has_trait(trait_data, TAT_TRAIT_TRADER_LICENSE))
		return TAT_ROLE_BUCKET_TRADER

	if(trait_data_has_trait(trait_data, TRAIT_OUTLANDER))
		return TAT_ROLE_BUCKET_ADVENTURER

	if(trait_data_has_trait(trait_data, TAT_TRAIT_WANTED))
		return TAT_ROLE_BUCKET_WRETCH

	if(foundation == TAT_FOUNDATION_WANDERER)
		return TAT_ROLE_BUCKET_ADVENTURER

	return TAT_ROLE_BUCKET_TRADER

/datum/tat_build/proc/get_tat_role_class_path(bucket)
	switch(bucket)
		if(TAT_ROLE_BUCKET_TOWNER)
			return /datum/advclass/tat_class/towner
		if(TAT_ROLE_BUCKET_TRADER)
			return /datum/advclass/tat_class/trader
		if(TAT_ROLE_BUCKET_ADVENTURER)
			return /datum/advclass/tat_class/adventurer
		if(TAT_ROLE_BUCKET_WRETCH)
			return /datum/advclass/tat_class/wretch

	return null

/datum/tat_build/proc/get_tat_role_class_name(bucket)
	var/class_path = get_tat_role_class_path(bucket)
	if(!class_path)
		return tat_role_bucket_display_name(bucket)

	var/datum/advclass/class_datum = new class_path
	var/class_name = class_datum?.name || tat_role_bucket_display_name(bucket)
	qdel(class_datum)
	return class_name

/datum/tat_build/proc/get_tat_role_min_pq(bucket)
	var/class_path = get_tat_role_class_path(bucket)
	if(!class_path)
		return 0

	var/datum/advclass/class_datum = new class_path
	var/minimum = round(class_datum?.min_pq || 0)
	qdel(class_datum)
	return minimum

/datum/tat_build/proc/build_ui_role_status_for_data(list/build_data)
	var/bucket = get_role_bucket_from_data(build_data)
	var/role_name = get_tat_role_class_name(bucket)
	var/minimum_pq = get_tat_role_min_pq(bucket)
	var/current_pq = get_owner_playerquality()
	var/missing_pq = max(0, minimum_pq - current_pq)
	var/pq_locked = missing_pq > 0
	var/role_text = role_name
	var/pq_lock_text = null

	if(pq_locked)
		pq_lock_text = "[role_name] — not enough PQ ([current_pq]/[minimum_pq])"
		role_text = pq_lock_text

	return list(
		"role_bucket" = bucket,
		"role_name" = role_name,
		"role_text" = role_text,
		"min_pq" = minimum_pq,
		"player_pq" = current_pq,
		"pq_missing" = missing_pq,
		"pq_locked" = pq_locked,
		"pq_lock_text" = pq_lock_text,
	)
