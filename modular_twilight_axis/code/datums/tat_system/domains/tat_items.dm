/datum/tat_items
	var/datum/tat_build/owner_build
	var/list/selected = list()
	var/list/item_loadout = list()
	var/list/item_grants = list()
	var/list/item_paint = list()
	var/base_points = 20
	var/list/equip_slots_cache = list()

/datum/tat_items/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/mind
	var/list/tat_unmintable_special_items = list()

/datum/mind/proc/tat_mark_special_item_unmintable(key)
	if(!key)
		return FALSE
	if(!islist(tat_unmintable_special_items))
		tat_unmintable_special_items = list()
	tat_unmintable_special_items[key] = TRUE
	return TRUE

/datum/mind/proc/tat_apply_special_item_sale_lock(key, obj/item/I)
	if(!key || !I || !islist(tat_unmintable_special_items) || !tat_unmintable_special_items[key])
		return FALSE
	tat_unmintable_special_items -= key
	I.unmintable = TRUE
	return TRUE

/datum/tat_items/proc/should_sale_lock_item_path(path)
	if(!ispath(path, /obj/item))
		return FALSE
	if(ispath(path, /obj/item/roguecoin))
		return FALSE
	if(is_coin_pouch_path(path))
		return FALSE
	return TRUE

/datum/tat_items/proc/apply_sale_lock_to_spawned_item(path, obj/item/I)
	if(!I || !should_sale_lock_item_path(path))
		return FALSE
	I.unmintable = TRUE
	return TRUE

/datum/tat_items/proc/reset()
	selected = list()
	item_loadout = list()
	item_grants = list()
	item_paint = list()
	return TRUE

/datum/tat_items/proc/get_entry(item_path)
	return GLOB.tat_available_items[item_path]

/datum/tat_items/proc/get_paid_amount(item_path)
	return round(selected[item_path] || 0)

/datum/tat_items/proc/get_granted_amount(item_path, source = null)
	var/list/sources = item_grants[item_path]
	if(!islist(sources))
		return 0
	if(!isnull(source))
		return round(sources[source] || 0)
	var/total = 0
	for(var/source_key in sources)
		total += round(sources[source_key] || 0)
	return total

/datum/tat_items/proc/get_amount(item_path)
	return get_paid_amount(item_path) + get_granted_amount(item_path)

/datum/tat_items/proc/get_non_donor_amount(item_path)
	return get_paid_amount(item_path) + get_granted_amount(item_path, TAT_ITEM_SOURCE_TRAIT)

/datum/tat_items/proc/get_external_granted_amount(item_path)
	return get_granted_amount(item_path, TAT_ITEM_SOURCE_TRAIT) + get_granted_amount(item_path, TAT_ITEM_SOURCE_DONOR_LOADOUT)

/datum/tat_items/proc/get_purchase_limit_amount(item_path)
	// Donor/preference loadout grants are external freebies. They must be visible in
	// the loadout stash, but must never count as TAT-purchased items and must not
	// consume the category/slot caps used by the Items purchase tab. Trait grants
	// still count here because they are part of the TAT build itself.
	return get_non_donor_amount(item_path)

/datum/tat_items/proc/is_loadout_only_entry(list/entry)
	return islist(entry) && !!entry["loadout_only"]

/datum/tat_items/proc/get_all_item_paths()
	var/list/result = list()
	for(var/item_path in selected)
		if(!(item_path in result))
			result += item_path
	for(var/item_path in item_grants)
		if(get_granted_amount(item_path) <= 0)
			continue
		if(!(item_path in result))
			result += item_path
	return result

/datum/tat_items/proc/get_source_counts_for_ui(item_path)
	var/list/result = list()
	var/paid = get_paid_amount(item_path)
	if(paid > 0)
		result[TAT_ITEM_SOURCE_PAID] = paid
	var/list/sources = item_grants[item_path]
	if(islist(sources))
		for(var/source_key in sources)
			var/count = round(sources[source_key] || 0)
			if(count > 0)
				result[source_key] = count
	return result

/datum/tat_items/proc/get_base_cost(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return 0

	var/cost = entry["cost"]
	if(!isnum(cost))
		return 0

	return cost

/datum/tat_items/proc/has_armor_cost_discount(list/entry)
	if(!islist(entry) || entry["unlock_type"] != TAT_UNLOCK_TYPE_ARMOR_FAMILY)
		return FALSE

	var/armor_family = entry["unlock_key"]
	switch(armor_family)
		if(TAT_ARMOR_LEATHER)
			return !!owner_build?.has_trait(TAT_TRAIT_LEATHER_SUPPLIER) && (owner_build?.directions?.get_points(TAT_DIRECTION_SURVIVAL) || 0) >= 3
		if(TAT_ARMOR_MAIL)
			return !!owner_build?.has_trait(TAT_TRAIT_MAIL_SUPPLIER) && !!owner_build?.has_trait(TRAIT_MEDIUMARMOR)
		if(TAT_ARMOR_PLATE)
			return !!owner_build?.has_trait(TAT_TRAIT_PLATE_SUPPLIER) && !!owner_build?.has_trait(TRAIT_HEAVYARMOR)
	return FALSE

/datum/tat_items/proc/get_cost(item_path)
	var/list/entry = get_entry(item_path)
	var/cost = get_base_cost(item_path)
	if(cost <= 0)
		return cost
	if(has_armor_cost_discount(entry))
		return cost * 0.5
	return cost

/datum/tat_items/proc/is_supply_soft_locked(list/entry)
	if(!islist(entry))
		return FALSE
	var/unlock_type = entry["unlock_type"]
	var/unlock_key = entry["unlock_key"]
	switch(unlock_type)
		if(TAT_UNLOCK_TYPE_WEAPON_SUPPLY)
			return !can_use_weapon_supply_type(unlock_key)
		if(TAT_UNLOCK_TYPE_ARMOR_FAMILY)
			return !can_use_armor_family(unlock_key)
	return FALSE

/datum/tat_items/proc/get_total_maximum()
	return base_points + (owner_build ? owner_build.get_bonus_item_points() : 0)

/datum/tat_items/proc/can_use_weapon_supply_type(supply_type)
	switch(supply_type)
		if(TAT_SUPPLY_IRON)
			return TRUE
		if(TAT_SUPPLY_BRONZE)
			return !!owner_build?.has_trait(TAT_TRAIT_BRONZE_SUPPLIER)
		if(TAT_SUPPLY_SILVER)
			return !!owner_build?.has_trait(TAT_TRAIT_SILVER_SUPPLIER)
		if(TAT_SUPPLY_STEEL)
			return !!owner_build?.has_trait(TAT_TRAIT_STEEL_SUPPLIER)
		if(TAT_SUPPLY_FIREARMS)
			return !!owner_build?.has_trait(TAT_TRAIT_FIREARMS_SUPPLIER)
		if(TAT_SUPPLY_ARTIFACTS)
			return !!owner_build?.has_trait(TAT_TRAIT_ARTIFACTS_SUPPLIER)
	return FALSE

/datum/tat_items/proc/can_use_armor_family(armor_family)
	switch(armor_family)
		if(TAT_ARMOR_CLOTH)
			return TRUE
		if(TAT_ARMOR_LEATHER)
			return !!owner_build?.has_trait(TAT_TRAIT_LEATHER_SUPPLIER)
		if(TAT_ARMOR_MAIL)
			return !!owner_build?.has_trait(TAT_TRAIT_MAIL_SUPPLIER) || !!owner_build?.has_trait(TRAIT_MEDIUMARMOR) || !!owner_build?.has_trait(TRAIT_HEAVYARMOR)
		if(TAT_ARMOR_PLATE)
			return !!owner_build?.has_trait(TAT_TRAIT_PLATE_SUPPLIER) || !!owner_build?.has_trait(TRAIT_HEAVYARMOR)
	return FALSE

/proc/tat_ckey_in_ckey_list(key, list/ckey_list)
	key = ckey(key)
	if(!key || !islist(ckey_list))
		return FALSE
	if(key in ckey_list)
		return TRUE
	for(var/list_key in ckey_list)
		if(ckey(list_key) == key)
			return TRUE
	return FALSE

/proc/tat_can_ckey_use_donation_item(key, required_tier, list/entry = null)
	required_tier = round(required_tier || 0)
	if(required_tier <= 0)
		return TRUE

	key = ckey(key)
	if(!key)
		return FALSE
	if(tat_ckey_in_ckey_list(key, GLOB.tat_donation_access_all_ckeys))
		return TRUE
	if(islist(entry) && tat_ckey_in_ckey_list(key, entry["donat_ignore"]))
		return TRUE

	return round(check_patreon_lvl(key) || 0) >= required_tier

/datum/tat_items/proc/can_use_item_entry(list/entry)
	if(!islist(entry))
		return FALSE
	if(is_loadout_only_entry(entry))
		return FALSE
	var/donat_tier = round(entry["donat_tier"] || 0)
	if(donat_tier > 0 && !tat_can_ckey_use_donation_item(owner_build?.get_owner_ckey(), donat_tier, entry))
		return FALSE

	var/required_trait = entry["required_trait"]
	if(required_trait && !owner_build?.has_trait(required_trait))
		return FALSE

	var/unlock_type = entry["unlock_type"]
	var/unlock_key = entry["unlock_key"]
	switch(unlock_type)
		if(TAT_UNLOCK_TYPE_WEAPON_SUPPLY)
			return can_use_weapon_supply_type(unlock_key)
		if(TAT_UNLOCK_TYPE_ARMOR_FAMILY)
			return can_use_armor_family(unlock_key)
		if(TAT_UNLOCK_TYPE_TRAIT)
			return !!owner_build?.has_trait(unlock_key)
	return TRUE

/datum/tat_items/proc/check_item(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return FALSE
	if(!can_use_item_entry(entry))
		return FALSE
	return TRUE

/datum/tat_items/proc/is_item_slot_limited(list/entry)
	return tat_item_entry_is_slot_limited(entry)

/datum/tat_items/proc/get_slot_group_item_count(slot_group, category, exclude_item_path = null)
	if(!slot_group)
		return 0
	var/total = 0
	for(var/item_path in get_all_item_paths())
		if(!isnull(exclude_item_path) && item_path == exclude_item_path)
			continue
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue
		if(entry["slot_group"] != slot_group)
			continue
		if(entry["category"] != category)
			continue
		var/amount = get_purchase_limit_amount(item_path)
		if(amount <= 0)
			continue
		total += amount
	return total

/datum/tat_items/proc/is_limited_firearm_item(item_path)
	if(!ispath(item_path))
		item_path = text2path("[item_path]")
	if(!item_path)
		return FALSE
	return ispath(item_path, /obj/item/gun/ballistic/twilight_firearm)

/datum/tat_items/proc/get_limited_firearm_item_count(exclude_item_path = null)
	var/total = 0
	for(var/item_path in get_all_item_paths())
		if(!isnull(exclude_item_path) && item_path == exclude_item_path)
			continue
		if(!is_limited_firearm_item(item_path))
			continue

		var/amount = get_purchase_limit_amount(item_path)
		if(amount <= 0)
			continue

		total += amount

	return total

/datum/tat_items/proc/get_item_total_allowed_amount(path)
	var/list/entry = get_entry(path)
	if(!islist(entry) || is_loadout_only_entry(entry))
		return 0
	if(ispath(path, /obj/item/folding_peddler_stored))
		return 1
	if(ispath(path, /obj/item/storage/belt/rogue/pouch/coins/mid))
		return 2
	if(is_limited_firearm_item(path))
		return 1
	var/cost = entry["cost"]
	if(!isnum(cost))
		cost = 0
	var/category = entry["category"]
	if(cost <= 0 && (category == "misc" || category == "weapon"))
		return 1
	if(!tat_item_entry_is_slot_limited(entry))
		return INFINITY
	if(!entry["slot_group"])
		return INFINITY
	return 1

/datum/tat_items/proc/get_maximum(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return 0
	if(!can_use_item_entry(entry))
		return 0
	var/trait_granted = get_granted_amount(item_path, TAT_ITEM_SOURCE_TRAIT)
	if(ispath(item_path, /obj/item/folding_peddler_stored))
		return max(0, 1 - trait_granted)
	if(ispath(item_path, /obj/item/storage/belt/rogue/pouch/coins/mid))
		return max(0, 2 - trait_granted)
	if(is_limited_firearm_item(item_path))
		return max(0, 1 - get_limited_firearm_item_count(item_path) - trait_granted)
	var/cost = entry["cost"]
	if(!isnum(cost))
		cost = 0
	var/category = entry["category"]
	if(cost <= 0 && (category == "misc" || category == "weapon"))
		return max(0, 1 - trait_granted)
	if(!tat_item_entry_is_slot_limited(entry))
		return max(0, 99 - trait_granted)
	var/slot_group = entry["slot_group"]
	if(!slot_group)
		return max(0, 99 - trait_granted)
	var/already_taken_elsewhere = get_slot_group_item_count(slot_group, category, item_path)
	return max(0, 1 - already_taken_elsewhere - trait_granted)

/datum/tat_items/proc/set_amount(item_path, amount, ignore_limits = FALSE)
	if(!islist(get_entry(item_path)))
		return FALSE
	var/old_total = get_amount(item_path)
	amount = round(amount)
	if(ignore_limits)
		amount = max(0, amount)
	else
		amount = clamp(amount, 0, get_maximum(item_path))
	if(amount <= 0)
		selected -= item_path
	else
		selected[item_path] = amount
	var/new_total = get_amount(item_path)
	if(new_total <= 0)
		item_loadout -= item_path
		item_paint -= item_path
	else
		var/list/loadout = get_loadout(item_path)
		if(new_total > old_total)
			// Newly acquired TAT item copies start in stash. The player explicitly moves
			// them to backpack before equipping or spawning them into the round.
			loadout["stash"] = round(loadout["stash"] || 0) + (new_total - old_total)
		normalize_loadout(item_path)
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/get_loadout(item_path)
	if(!(item_path in item_loadout) || !islist(item_loadout[item_path]))
		// Unknown/fresh loadout state must not silently dump items into backpack.
		// Stash is the safe default; backpack is opt-in via move_item_from_stash_to_bag().
		item_loadout[item_path] = list("equip" = 0, "bag" = 0, "stash" = get_amount(item_path), "slots" = list())
	if(isnull(item_loadout[item_path]["bag"]))
		item_loadout[item_path]["bag"] = 0
	if(isnull(item_loadout[item_path]["stash"]))
		item_loadout[item_path]["stash"] = 0
	return item_loadout[item_path]

/datum/tat_items/proc/normalize_loadout(item_path)
	var/amount = get_amount(item_path)
	if(amount <= 0)
		item_loadout -= item_path
		item_paint -= item_path
		return
	var/list/loadout = get_loadout(item_path)
	var/list/slots = loadout["slots"]
	if(!islist(slots))
		slots = list()
		loadout["slots"] = slots

	var/list/valid_slots = get_valid_loadout_ui_slots_for_item(item_path)
	for(var/slot_id in slots.Copy())
		if(!(slot_id in valid_slots))
			slots -= slot_id

	while(length(slots) > amount)
		var/drop_slot = slots[length(slots)]
		slots -= drop_slot

	var/equip = length(slots)
	var/non_slot_amount = max(0, amount - equip)
	var/bag = max(0, round(loadout["bag"] || 0))
	var/stash = max(0, round(loadout["stash"] || 0))

	while((bag + stash) > non_slot_amount)
		if(stash > 0)
			stash--
		else if(bag > 0)
			bag--
		else
			break

	if((bag + stash) < non_slot_amount)
		// Any missing loose copies are restored into stash, never backpack.
		stash += non_slot_amount - (bag + stash)

	loadout["equip"] = equip
	loadout["bag"] = bag
	loadout["stash"] = stash

/datum/tat_items/proc/set_item_grant_amount(item_path, source, amount, default_to_stash = TRUE, preserve_loadout_on_zero = FALSE)
	if(!ispath(item_path) || !istext(source) || !length(source))
		return FALSE
	ensure_runtime_item_entry(item_path, null, TRUE)
	amount = max(0, round(amount || 0))
	var/list/sources = item_grants[item_path]
	if(!islist(sources))
		sources = list()
		item_grants[item_path] = sources
	var/old_source_amount = round(sources[source] || 0)
	if(amount <= 0)
		sources -= source
	else
		sources[source] = amount
	if(!length(sources))
		item_grants -= item_path
	var/new_total = get_amount(item_path)
	if(new_total <= 0)
		if(!preserve_loadout_on_zero)
			item_loadout -= item_path
			item_paint -= item_path
	else
		var/list/loadout = get_loadout(item_path)
		var/source_delta = amount - old_source_amount
		if(source_delta > 0)
			// Trait and donor-loadout grants are born in stash. They never appear in
			// backpack unless the player explicitly moves them there from the loadout UI.
			if(default_to_stash)
				loadout["stash"] = round(loadout["stash"] || 0) + source_delta
			else
				loadout["bag"] = round(loadout["bag"] || 0) + source_delta
		normalize_loadout(item_path)
	return TRUE

/datum/tat_items/proc/add_grant_amount(list/result, item_path, amount = 1)
	if(!ispath(item_path) || amount <= 0)
		return
	result[item_path] = round(result[item_path] || 0) + round(amount)

/datum/tat_items/proc/build_trait_granted_item_amounts()
	var/list/result = list()
	if(!owner_build?.traits)
		return result
	if(owner_build.has_trait(TAT_TRAIT_TROPHY_BOUNTY))
		add_grant_amount(result, /obj/item/book/rogue/trophy_rules)
	if(owner_build.has_trait(TRAIT_RITUALIST))
		add_grant_amount(result, /obj/item/ritechalk)
	if(owner_build.has_trait(TAT_TRAIT_MAGE_INITIATE))
		add_grant_amount(result, /obj/item/book/spellbook)
		add_grant_amount(result, /obj/item/chalk)
	return result

/datum/tat_items/proc/sync_trait_granted_items()
	var/list/wanted = build_trait_granted_item_amounts()
	var/list/current_trait_grants = list()
	for(var/item_path in item_grants)
		if(get_granted_amount(item_path, TAT_ITEM_SOURCE_TRAIT) > 0)
			current_trait_grants += item_path
	for(var/item_path in wanted)
		set_item_grant_amount(item_path, TAT_ITEM_SOURCE_TRAIT, wanted[item_path], TRUE)
	for(var/item_path in current_trait_grants)
		if(!(item_path in wanted))
			set_item_grant_amount(item_path, TAT_ITEM_SOURCE_TRAIT, 0, TRUE)
	return TRUE

/datum/tat_items/proc/infer_runtime_item_category(item_path)
	if(ispath(item_path, /obj/item/clothing) || ispath(item_path, /obj/item/storage/belt))
		return TAT_ITEM_CATEGORY_CLOTHING
	if(ispath(item_path, /obj/item/rogueweapon) || ispath(item_path, /obj/item/gun) || ispath(item_path, /obj/item/ammo_casing) || ispath(item_path, /obj/item/quiver))
		return TAT_ITEM_CATEGORY_WEAPON
	return "misc"

/datum/tat_items/proc/infer_runtime_item_slot_group(item_path)
	if(!ispath(item_path, /obj/item))
		return "misc"

	var/obj/item/I = item_path
	var/flags = initial(I.slot_flags)

	if(flags & ITEM_SLOT_BELT)
		return "belt"
	if(flags & ITEM_SLOT_NECK)
		return "neck"
	if(flags & ITEM_SLOT_MASK)
		return "mask"
	if(flags & ITEM_SLOT_HEAD)
		return "head"
	if(flags & ITEM_SLOT_CLOAK)
		return "cloak"
	if(flags & ITEM_SLOT_ARMOR || flags & ITEM_SLOT_OCLOTHING)
		return "armor"
	if(flags & ITEM_SLOT_SHIRT || flags & ITEM_SLOT_ICLOTHING)
		return "shirt"
	if(flags & ITEM_SLOT_PANTS)
		return "pants"
	if(flags & ITEM_SLOT_WRISTS)
		return "wrists"
	if(flags & ITEM_SLOT_GLOVES)
		return "gloves"
	if(flags & ITEM_SLOT_SHOES)
		return "shoes"
	if(flags & ITEM_SLOT_RING)
		return "ring"

	if(ispath(item_path, /obj/item/storage/belt))
		return "belt"

	return "misc"

/datum/tat_items/proc/get_runtime_item_name(item_path)
	if(!ispath(item_path, /obj/item))
		return "Unknown item"
	var/obj/item/I = item_path
	return initial(I.name) || "Unknown item"

/datum/tat_items/proc/ensure_runtime_item_entry(item_path, override_name = null, loadout_only = FALSE)
	if(!ispath(item_path, /obj/item))
		return FALSE

	var/inferred_category = infer_runtime_item_category(item_path)
	var/inferred_slot_group = infer_runtime_item_slot_group(item_path)
	var/list/existing_entry = GLOB.tat_available_items[item_path]
	if(islist(existing_entry))
		if(is_loadout_only_entry(existing_entry))
			var/changed = FALSE
			if((!existing_entry["slot_group"] || existing_entry["slot_group"] == "misc") && inferred_slot_group != "misc")
				existing_entry["slot_group"] = inferred_slot_group
				changed = TRUE
			if((!existing_entry["category"] || existing_entry["category"] == "misc") && inferred_category != "misc")
				existing_entry["category"] = inferred_category
				changed = TRUE
			if(istext(override_name) && length(override_name) && existing_entry["name"] != override_name)
				existing_entry["name"] = override_name
				changed = TRUE
			if(changed)
				GLOB.tat_item_loadout_slots_cache -= item_path
				equip_slots_cache -= item_path
				GLOB.tat_item_icon_cache_ready = FALSE
		return TRUE

	GLOB.tat_available_items[item_path] = list(
		"name" = istext(override_name) && length(override_name) ? override_name : get_runtime_item_name(item_path),
		"cost" = 0,
		"category" = inferred_category,
		"unlock_type" = null,
		"unlock_key" = null,
		"slot_group" = inferred_slot_group,
		"loadout_only" = !!loadout_only,
	)
	GLOB.tat_item_icon_cache_ready = FALSE
	return TRUE

/datum/tat_items/proc/sync_donor_loadout_from_preferences()
	var/list/wanted = list()
	var/datum/preferences/P = owner_build?.owner_preferences
	if(P && islist(P.selected_loadout_items))
		for(var/key in P.selected_loadout_items)
			var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
			if(!item?.path)
				continue
			ensure_runtime_item_entry(item.path, item.name, TRUE)
			add_grant_amount(wanted, item.path)

	var/list/current_donor_grants = list()
	for(var/item_path in item_grants)
		if(get_granted_amount(item_path, TAT_ITEM_SOURCE_DONOR_LOADOUT) > 0)
			current_donor_grants += item_path
	for(var/item_path in wanted)
		set_item_grant_amount(item_path, TAT_ITEM_SOURCE_DONOR_LOADOUT, wanted[item_path], TRUE, TRUE)
	for(var/item_path in current_donor_grants)
		if(!(item_path in wanted))
			set_item_grant_amount(item_path, TAT_ITEM_SOURCE_DONOR_LOADOUT, 0, TRUE, TRUE)
	return TRUE

/datum/tat_items/proc/ensure_external_grants_start_in_stash()
	for(var/item_path in get_all_item_paths())
		var/external_amount = get_external_granted_amount(item_path)
		if(external_amount <= 0)
			continue
		var/list/loadout = get_loadout(item_path)
		var/already_initialized = round(loadout["external_stash_initialized"] || 0)
		if(already_initialized >= external_amount)
			continue

		var/missing_external = external_amount - already_initialized
		var/bag = max(0, round(loadout["bag"] || 0))
		var/stash = max(0, round(loadout["stash"] || 0))
		var/move_from_bag = min(missing_external, bag)
		if(move_from_bag > 0)
			loadout["bag"] = bag - move_from_bag
			loadout["stash"] = stash + move_from_bag

		// Mark only after the first automatic stash placement. From this point on,
		// player-made bag/stash choices are preserved across normal UI syncs.
		loadout["external_stash_initialized"] = external_amount
		normalize_loadout(item_path)
	return TRUE

/datum/tat_items/proc/sync_external_grants()
	sync_trait_granted_items()
	sync_donor_loadout_from_preferences()
	ensure_external_grants_start_in_stash()
	for(var/item_path in get_all_item_paths())
		normalize_loadout(item_path)
	return TRUE

/datum/tat_items/proc/get_spent_points()
	var/total = 0
	for(var/item_path in selected)
		total += get_cost(item_path) * get_paid_amount(item_path)
	return total

/datum/tat_items/proc/get_remaining_points()
	return get_total_maximum() - get_spent_points()

/datum/tat_items/proc/has_invalid_supply_items()
	var/list/issues = list()
	for(var/item_path in selected)
		var/amount = selected[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		var/list/entry = get_entry(item_path)
		if(!islist(entry))
			issues += "\"[item_path]\" is missing from item definitions."
			continue
		if(!can_use_item_entry(entry))
			issues += "\"[entry["name"]]\" is no longer unlocked by current traits."
	return issues

/datum/tat_items/proc/sanitize()
	sync_external_grants()
	for(var/item_path in selected.Copy())
		if(!check_item(item_path))
			selected -= item_path
			if(get_amount(item_path) <= 0)
				item_loadout -= item_path
			continue
		set_amount(item_path, get_paid_amount(item_path))
	while(get_remaining_points() < 0)
		var/changed = FALSE
		for(var/item_path in selected.Copy())
			var/amount = get_paid_amount(item_path)
			if(amount > 0)
				set_amount(item_path, amount - 1)
				changed = TRUE
				if(get_remaining_points() >= 0)
					break
		if(!changed)
			break
	for(var/item_path in get_all_item_paths())
		normalize_loadout(item_path)
	return TRUE

/datum/tat_items/proc/append_unique_text(list/values, value)
	if(!istext(value) || !length(value))
		return
	if(!(value in values))
		values += value

/datum/tat_items/proc/append_music_loadout_ui_slots(list/slots)
	append_unique_text(slots, "shoulder_l")
	append_unique_text(slots, "shoulder_r")
	append_unique_text(slots, "belt")
	append_unique_text(slots, "belt_l")
	append_unique_text(slots, "belt_r")
	append_unique_text(slots, "hand_l")
	append_unique_text(slots, "hand_r")

/datum/tat_items/proc/append_music_equip_slots(list/slots)
	append_unique_equip_slot(slots, SLOT_BACK_L)
	append_unique_equip_slot(slots, SLOT_BACK_R)
	append_unique_equip_slot(slots, SLOT_BACK)
	append_unique_equip_slot(slots, SLOT_BELT)
	append_unique_equip_slot(slots, SLOT_BELT_L)
	append_unique_equip_slot(slots, SLOT_BELT_R)
	append_unique_equip_slot(slots, SLOT_HANDS)

/datum/tat_items/proc/is_weapon_loadout_group(slot_group)
	var/group = lowertext("[slot_group]")
	return group in list("blackpowder", "ranged", "munition", "knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip", "sheath", "artifact", "unarmed")

/datum/tat_items/proc/is_light_loadout_group(slot_group)
	var/group = lowertext("[slot_group]")
	return group in list("adventur' supply", "adventur supply", "adventure supply", "light", "lamp", "lantern", "torch")

/datum/tat_items/proc/is_light_loadout_item(item_path, list/entry = null)
	if(ispath(item_path, /obj/item/flashlight/flare/torch))
		return TRUE
	if(ispath(item_path, /obj/item/flashlight))
		return TRUE
	if(islist(entry) && is_light_loadout_group(entry["slot_group"]))
		return TRUE
	return FALSE

/datum/tat_items/proc/append_light_loadout_ui_slots(list/slots)
	append_unique_text(slots, "belt")
	append_unique_text(slots, "belt_l")
	append_unique_text(slots, "belt_r")
	append_unique_text(slots, "hand_l")
	append_unique_text(slots, "hand_r")

/datum/tat_items/proc/append_light_equip_slots(list/slots)
	append_unique_equip_slot(slots, SLOT_BELT)
	append_unique_equip_slot(slots, SLOT_BELT_L)
	append_unique_equip_slot(slots, SLOT_BELT_R)
	append_unique_equip_slot(slots, SLOT_HANDS)

/datum/tat_items/proc/is_amulet_loadout_group(slot_group)
	var/group = lowertext("[slot_group]")
	return group in list("cross", "amulet", "amulets", "talisman", "talismans", "charm", "charms", "necklace", "necklaces")

/datum/tat_items/proc/is_amulet_loadout_item(item_path, list/entry = null)
	if(islist(entry) && is_amulet_loadout_group(entry["slot_group"]))
		return TRUE
	var/path_text = lowertext("[item_path]")
	if(findtext(path_text, "amulet") || findtext(path_text, "talisman") || findtext(path_text, "charm") || findtext(path_text, "necklace") || findtext(path_text, "psicross") || findtext(path_text, "cross"))
		return TRUE
	if(islist(entry))
		var/name_text = lowertext("[entry["name"]]")
		if(findtext(name_text, "amulet") || findtext(name_text, "talisman") || findtext(name_text, "charm") || findtext(name_text, "necklace") || findtext(name_text, "cross"))
			return TRUE
	return FALSE

/datum/tat_items/proc/append_amulet_loadout_ui_slots(list/slots)
	append_unique_text(slots, "neck")
	append_unique_text(slots, "ring")

/datum/tat_items/proc/append_amulet_equip_slots(list/slots)
	append_unique_equip_slot(slots, SLOT_NECK)
	append_unique_equip_slot(slots, SLOT_RING)

/datum/tat_items/proc/append_weapon_loadout_ui_slots(list/slots, slot_group = null)
	var/group = lowertext("[slot_group]")
	if(group in list("greatsword", "polearm"))
		append_unique_text(slots, "shoulder_l")
		append_unique_text(slots, "shoulder_r")
		append_unique_text(slots, "hand_l")
		append_unique_text(slots, "hand_r")
		return
	if(group == "sheath")
		append_unique_text(slots, "belt")
		append_unique_text(slots, "belt_l")
		append_unique_text(slots, "belt_r")
		append_unique_text(slots, "shoulder_l")
		append_unique_text(slots, "shoulder_r")
		return
	append_unique_text(slots, "belt")
	append_unique_text(slots, "belt_l")
	append_unique_text(slots, "belt_r")
	append_unique_text(slots, "shoulder_l")
	append_unique_text(slots, "shoulder_r")
	append_unique_text(slots, "hand_l")
	append_unique_text(slots, "hand_r")

/datum/tat_items/proc/append_weapon_equip_slots(list/slots, slot_group = null)
	var/group = lowertext("[slot_group]")
	if(group in list("greatsword", "polearm"))
		append_unique_equip_slot(slots, SLOT_BACK_L)
		append_unique_equip_slot(slots, SLOT_BACK_R)
		append_unique_equip_slot(slots, SLOT_BACK)
		append_unique_equip_slot(slots, SLOT_HANDS)
		return
	if(group == "sheath")
		append_unique_equip_slot(slots, SLOT_BELT)
		append_unique_equip_slot(slots, SLOT_BELT_L)
		append_unique_equip_slot(slots, SLOT_BELT_R)
		append_unique_equip_slot(slots, SLOT_BACK_L)
		append_unique_equip_slot(slots, SLOT_BACK_R)
		append_unique_equip_slot(slots, SLOT_BACK)
		return
	append_unique_equip_slot(slots, SLOT_BELT)
	append_unique_equip_slot(slots, SLOT_BELT_L)
	append_unique_equip_slot(slots, SLOT_BELT_R)
	append_unique_equip_slot(slots, SLOT_BACK_L)
	append_unique_equip_slot(slots, SLOT_BACK_R)
	append_unique_equip_slot(slots, SLOT_BACK)
	append_unique_equip_slot(slots, SLOT_HANDS)

/datum/tat_items/proc/get_loadout_ui_slot_ids()
	return list(
		"neck",
		"mask",
		"head",
		"mouth",
		"cloak",
		"armor",
		"suit",
		"belt",
		"legs",
		"boots",
		"wrists",
		"gloves",
		"ring",
		"shoulder_l",
		"shoulder_r",
		"belt_l",
		"belt_r",
		"hand_l",
		"hand_r",
	)

/datum/tat_items/proc/get_loadout_slot_equip_slot(slot_id)
	switch(slot_id)
		if("neck")
			return SLOT_NECK
		if("mask")
			return SLOT_WEAR_MASK
		if("head")
			return SLOT_HEAD
		if("mouth")
			return SLOT_MOUTH
		if("cloak")
			return SLOT_CLOAK
		if("armor")
			return SLOT_ARMOR
		if("suit")
			return SLOT_SHIRT
		if("belt")
			return SLOT_BELT
		if("legs")
			return SLOT_PANTS
		if("boots")
			return SLOT_SHOES
		if("wrists")
			return SLOT_WRISTS
		if("gloves")
			return SLOT_GLOVES
		if("ring")
			return SLOT_RING
		if("shoulder_l")
			return SLOT_BACK_L
		if("shoulder_r")
			return SLOT_BACK_R
		if("belt_l")
			return SLOT_BELT_L
		if("belt_r")
			return SLOT_BELT_R
		if("hand_l", "hand_r")
			return SLOT_HANDS
	return null

/datum/tat_items/proc/append_loadout_ui_slots_for_slot_group(list/slots, slot_group)
	var/group = lowertext("[slot_group]")
	switch(group)
		if("neck")
			append_unique_text(slots, "neck")
		if("mask")
			append_unique_text(slots, "mask")
		if("head")
			append_unique_text(slots, "head")
		if("mouth")
			append_unique_text(slots, "mouth")
		if("cloak")
			append_unique_text(slots, "cloak")
		if("armor")
			append_unique_text(slots, "armor")
		if("suit", "shirt", "under")
			append_unique_text(slots, "suit")
		if("belt")
			append_unique_text(slots, "belt")
			append_unique_text(slots, "belt_l")
			append_unique_text(slots, "belt_r")
		if("pants")
			append_unique_text(slots, "legs")
		if("shoes")
			append_unique_text(slots, "boots")
		if("wrists")
			append_unique_text(slots, "wrists")
		if("gloves")
			append_unique_text(slots, "gloves")
		if("ring")
			append_unique_text(slots, "ring")
		if("cross", "amulet", "amulets", "talisman", "talismans", "charm", "charms", "necklace", "necklaces")
			append_amulet_loadout_ui_slots(slots)
		if("back")
			append_unique_text(slots, "shoulder_l")
			append_unique_text(slots, "shoulder_r")
		if("back_l")
			append_unique_text(slots, "shoulder_l")
		if("back_r")
			append_unique_text(slots, "shoulder_r")
		if("belt_l")
			append_unique_text(slots, "belt_l")
		if("belt_r")
			append_unique_text(slots, "belt_r")
		if("music")
			append_music_loadout_ui_slots(slots)
		if("adventur' supply", "adventur supply", "adventure supply", "light", "lamp", "lantern", "torch")
			append_light_loadout_ui_slots(slots)
		if("blackpowder", "ranged", "munition", "knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip", "sheath", "artifact", "unarmed")
			append_weapon_loadout_ui_slots(slots, group)

/datum/tat_items/proc/append_loadout_ui_slots_for_equip_slot(list/slots, slot_id)
	switch(slot_id)
		if(SLOT_NECK)
			append_unique_text(slots, "neck")
		if(SLOT_WEAR_MASK)
			append_unique_text(slots, "mask")
		if(SLOT_HEAD)
			append_unique_text(slots, "head")
		if(SLOT_MOUTH)
			append_unique_text(slots, "mouth")
		if(SLOT_CLOAK)
			append_unique_text(slots, "cloak")
		if(SLOT_ARMOR)
			append_unique_text(slots, "armor")
		if(SLOT_SHIRT)
			append_unique_text(slots, "suit")
		if(SLOT_BELT)
			append_unique_text(slots, "belt")
		if(SLOT_PANTS)
			append_unique_text(slots, "legs")
		if(SLOT_SHOES)
			append_unique_text(slots, "boots")
		if(SLOT_WRISTS)
			append_unique_text(slots, "wrists")
		if(SLOT_GLOVES)
			append_unique_text(slots, "gloves")
		if(SLOT_RING)
			append_unique_text(slots, "ring")
		if(SLOT_BACK_L)
			append_unique_text(slots, "shoulder_l")
		if(SLOT_BACK_R)
			append_unique_text(slots, "shoulder_r")
		if(SLOT_BACK)
			append_unique_text(slots, "shoulder_l")
			append_unique_text(slots, "shoulder_r")
		if(SLOT_BELT_L)
			append_unique_text(slots, "belt_l")
		if(SLOT_BELT_R)
			append_unique_text(slots, "belt_r")
		if(SLOT_HANDS)
			append_unique_text(slots, "hand_l")
			append_unique_text(slots, "hand_r")

/datum/tat_items/proc/append_hand_slots_if_reasonable(list/slots, item_path, list/entry)
	var/category = lowertext("[entry["category"]]")
	var/slot_group = lowertext("[entry["slot_group"]]")
	if(slot_group == "music" || ispath(item_path, /obj/item/rogue/instrument))
		append_music_loadout_ui_slots(slots)
		return
	if(is_light_loadout_item(item_path, entry))
		append_light_loadout_ui_slots(slots)
		return
	if(is_amulet_loadout_item(item_path, entry))
		append_amulet_loadout_ui_slots(slots)
		return
	if(category == TAT_ITEM_CATEGORY_WEAPON || is_weapon_loadout_group(slot_group))
		append_weapon_loadout_ui_slots(slots, slot_group)

/datum/tat_items/proc/get_cached_equip_slots_for_item(item_path)
	if(item_path in equip_slots_cache)
		return equip_slots_cache[item_path]

	var/list/result = list()
	if(ispath(item_path, /obj/item))
		var/obj/item/I = new item_path(null)
		if(I)
			result = get_equip_slots_for_item(I, item_path)
			qdel(I)
	equip_slots_cache[item_path] = result
	return result

/datum/tat_items/proc/get_valid_loadout_ui_slots_for_item(item_path)
	if(!ispath(item_path))
		item_path = text2path("[item_path]")
	if(!item_path)
		return list()

	var/list/cached = GLOB.tat_item_loadout_slots_cache[item_path]
	if(islist(cached))
		return cached

	var/list/result = list()
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return result

	append_loadout_ui_slots_for_slot_group(result, entry["slot_group"])

	for(var/slot_id in get_cached_equip_slots_for_item(item_path))
		append_loadout_ui_slots_for_equip_slot(result, slot_id)

	append_hand_slots_if_reasonable(result, item_path, entry)
	GLOB.tat_item_loadout_slots_cache[item_path] = result
	return result

/datum/tat_items/proc/get_assigned_loadout_slot_count(item_path)
	var/list/loadout = get_loadout(item_path)
	var/list/slots = loadout["slots"]
	if(!islist(slots))
		return 0
	return length(slots)

/datum/tat_items/proc/clear_loadout_slot(slot_id)
	if(!istext(slot_id) || !length(slot_id))
		return FALSE
	var/changed = FALSE
	for(var/item_path in item_loadout)
		var/list/loadout = item_loadout[item_path]
		if(!islist(loadout))
			continue
		var/list/slots = loadout["slots"]
		if(!islist(slots) || !(slot_id in slots))
			continue
		slots -= slot_id
		// Clearing an equipped slot is the one explicit path that returns that copy
		// to backpack; all other newly loose copies default to stash.
		loadout["bag"] = round(loadout["bag"] || 0) + 1
		normalize_loadout(item_path)
		changed = TRUE
	if(changed)
		owner_build?.set_dirty()
	return changed

/datum/tat_items/proc/assign_item_to_loadout_slot(item_path, slot_id)
	if(!istext(slot_id) || !length(slot_id))
		return FALSE
	if(!(slot_id in get_loadout_ui_slot_ids()))
		return FALSE
	if(get_amount(item_path) <= 0)
		return FALSE
	var/list/valid_slots = get_valid_loadout_ui_slots_for_item(item_path)
	if(!(slot_id in valid_slots))
		return FALSE

	var/list/loadout = get_loadout(item_path)
	if(round(loadout["bag"] || 0) <= 0)
		return FALSE

	clear_loadout_slot(slot_id)

	loadout = get_loadout(item_path)
	var/list/slots = loadout["slots"]
	if(!islist(slots))
		slots = list()
		loadout["slots"] = slots
	if(!(slot_id in slots))
		while(length(slots) >= get_amount(item_path))
			var/drop_slot = slots[length(slots)]
			slots -= drop_slot
		loadout["bag"] = max(0, round(loadout["bag"] || 0) - 1)
		slots[slot_id] = TRUE
	normalize_loadout(item_path)
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/move_item_from_bag_to_stash(item_path, amount = 1)
	if(get_amount(item_path) <= 0)
		return FALSE
	var/list/loadout = get_loadout(item_path)
	var/count = min(max(1, round(amount || 1)), round(loadout["bag"] || 0))
	if(count <= 0)
		return FALSE
	loadout["bag"] = round(loadout["bag"] || 0) - count
	loadout["stash"] = round(loadout["stash"] || 0) + count
	normalize_loadout(item_path)
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/move_item_from_stash_to_bag(item_path, amount = 1)
	if(get_amount(item_path) <= 0)
		return FALSE
	var/list/loadout = get_loadout(item_path)
	var/count = min(max(1, round(amount || 1)), round(loadout["stash"] || 0))
	if(count <= 0)
		return FALSE
	loadout["stash"] = round(loadout["stash"] || 0) - count
	loadout["bag"] = round(loadout["bag"] || 0) + count
	normalize_loadout(item_path)
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/assign_item_to_first_available_loadout_slot(item_path)
	var/list/valid_slots = get_valid_loadout_ui_slots_for_item(item_path)
	for(var/slot_id in valid_slots)
		var/taken = FALSE
		for(var/other_path in item_loadout)
			var/list/other_loadout = item_loadout[other_path]
			var/list/other_slots = islist(other_loadout) ? other_loadout["slots"] : null
			if(islist(other_slots) && (slot_id in other_slots))
				taken = TRUE
				break
		if(taken)
			continue
		return assign_item_to_loadout_slot(item_path, slot_id)
	return FALSE

/datum/tat_items/proc/append_unique_equip_slot(list/slots, slot_id)
	if(!(slot_id in slots))
		slots += slot_id

/datum/tat_items/proc/get_equip_slots_for_item(obj/item/I, item_path = null)
	var/list/slots = list()
	if(!I)
		return slots

	var/list/entry = item_path ? get_entry(item_path) : null
	var/slot_group = islist(entry) ? lowertext("[entry["slot_group"]]") : null

	// Prefer explicit TAT slot groups. Backpacks and satchels in RogueTown/Twilight Axis
	// are shoulder/back items first, and slot_flags alone is not reliable enough here.
	switch(slot_group)
		if("back")
			append_unique_equip_slot(slots, SLOT_BACK_L)
			append_unique_equip_slot(slots, SLOT_BACK_R)
			append_unique_equip_slot(slots, SLOT_BACK)
		if("belt")
			append_unique_equip_slot(slots, SLOT_BELT)
			append_unique_equip_slot(slots, SLOT_BELT_L)
			append_unique_equip_slot(slots, SLOT_BELT_R)
		if("cloak")
			append_unique_equip_slot(slots, SLOT_CLOAK)
		if("neck")
			append_unique_equip_slot(slots, SLOT_NECK)
		if("head")
			append_unique_equip_slot(slots, SLOT_HEAD)
		if("mask")
			append_unique_equip_slot(slots, SLOT_WEAR_MASK)
		if("armor", "suit")
			append_unique_equip_slot(slots, SLOT_ARMOR)
		if("shirt", "under")
			append_unique_equip_slot(slots, SLOT_SHIRT)
		if("pants")
			append_unique_equip_slot(slots, SLOT_PANTS)
		if("wrists")
			append_unique_equip_slot(slots, SLOT_WRISTS)
		if("gloves")
			append_unique_equip_slot(slots, SLOT_GLOVES)
		if("shoes")
			append_unique_equip_slot(slots, SLOT_SHOES)
		if("ring")
			append_unique_equip_slot(slots, SLOT_RING)
		if("cross", "amulet", "amulets", "talisman", "talismans", "charm", "charms", "necklace", "necklaces")
			append_amulet_equip_slots(slots)
		if("music")
			append_music_equip_slots(slots)
		if("adventur' supply", "adventur supply", "adventure supply", "light", "lamp", "lantern", "torch")
			append_light_equip_slots(slots)
		if("blackpowder", "ranged", "munition", "knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip", "sheath", "artifact", "unarmed")
			append_weapon_equip_slots(slots, slot_group)

	if(ispath(item_path, /obj/item/rogue/instrument))
		append_music_equip_slots(slots)
	if(is_light_loadout_item(item_path, entry))
		append_light_equip_slots(slots)
	if(is_amulet_loadout_item(item_path, entry))
		append_amulet_equip_slots(slots)
	if(islist(entry) && lowertext("[entry["category"]]") == TAT_ITEM_CATEGORY_WEAPON)
		append_weapon_equip_slots(slots, slot_group)

	var/flags = I.slot_flags
	if(flags & ITEM_SLOT_HEAD)
		append_unique_equip_slot(slots, SLOT_HEAD)
	if(flags & ITEM_SLOT_MASK)
		append_unique_equip_slot(slots, SLOT_WEAR_MASK)
	if(flags & ITEM_SLOT_NECK)
		append_unique_equip_slot(slots, SLOT_NECK)
		if(is_amulet_loadout_item(item_path, entry))
			append_unique_equip_slot(slots, SLOT_RING)
	if(flags & ITEM_SLOT_CLOAK)
		append_unique_equip_slot(slots, SLOT_CLOAK)
	if(flags & ITEM_SLOT_ARMOR || flags & ITEM_SLOT_OCLOTHING)
		append_unique_equip_slot(slots, SLOT_ARMOR)
	if(flags & ITEM_SLOT_SHIRT)
		append_unique_equip_slot(slots, SLOT_SHIRT)
	if(flags & ITEM_SLOT_PANTS)
		append_unique_equip_slot(slots, SLOT_PANTS)
	if(flags & ITEM_SLOT_ICLOTHING)
		append_unique_equip_slot(slots, SLOT_SHIRT)
		append_unique_equip_slot(slots, SLOT_PANTS)
	if(flags & ITEM_SLOT_WRISTS)
		append_unique_equip_slot(slots, SLOT_WRISTS)
	if(flags & ITEM_SLOT_GLOVES)
		append_unique_equip_slot(slots, SLOT_GLOVES)
	if(flags & ITEM_SLOT_SHOES)
		append_unique_equip_slot(slots, SLOT_SHOES)
	if(flags & ITEM_SLOT_RING)
		append_unique_equip_slot(slots, SLOT_RING)
	if(flags & ITEM_SLOT_BELT)
		append_unique_equip_slot(slots, SLOT_BELT)
	return slots


/datum/tat_items/proc/get_paint_data(item_path)
	var/list/paint = item_paint[item_path]
	if(!islist(paint))
		paint = list()
		item_paint[item_path] = paint
	return paint

/datum/tat_items/proc/get_paint_data_for_ui(item_path)
	var/list/paint = item_paint[item_path]
	if(!islist(paint) || !length(paint))
		return null
	return paint.Copy()

/datum/tat_items/proc/build_loadout_item_icon_payload(item_path)
	if(!ispath(item_path, /obj/item))
		return null
	var/obj/item/preview_item = new item_path(null)
	if(!preview_item)
		return null

	var/list/paint = item_paint[item_path]
	if(islist(paint) && length(paint))
		apply_paint_to_item(item_path, preview_item)

	var/icon/preview_icon = new /icon()
	preview_icon.Insert(new /icon(preview_item.icon, preview_item.icon_state), "", SOUTH, 0)

	if(islist(paint) && istext(paint["primary"]))
		preview_icon.Blend(paint["primary"], ICON_MULTIPLY)

	if(islist(paint) && istext(paint["detail"]) && preview_item.detail_tag && preview_item.detail_color)
		var/icon/detail_overlay = new /icon()
		detail_overlay.Insert(new /icon(preview_item.icon, "[preview_item.icon_state][preview_item.detail_tag]"), "", SOUTH, 0)
		detail_overlay.Blend(paint["detail"], ICON_MULTIPLY)
		preview_icon.Blend(detail_overlay, ICON_OVERLAY)

	if(islist(paint) && istext(paint["altdetail"]) && preview_item.altdetail_tag && preview_item.altdetail_color)
		var/icon/altdetail_overlay = new /icon()
		altdetail_overlay.Insert(new /icon(preview_item.icon, "[preview_item.icon_state][preview_item.altdetail_tag]"), "", SOUTH, 0)
		altdetail_overlay.Blend(paint["altdetail"], ICON_MULTIPLY)
		preview_icon.Blend(altdetail_overlay, ICON_OVERLAY)

	var/list/result = list(
		"icon" = icon2base64(preview_icon),
		"icon_state" = "[preview_item.icon_state]",
	)
	qdel(preview_item)
	return result

/datum/tat_items/proc/can_paint_item_path(item_path)
	if(!ispath(item_path, /obj/item))
		return FALSE
	var/obj/item/I = new item_path(null)
	if(!I)
		return FALSE
	var/can_paint = is_type_in_list(I, list(
		/obj/item/clothing,
		/obj/item/storage,
		/obj/item/bedroll,
		/obj/item/flowercrown,
		/obj/item/legwears,
		/obj/item/undies,
		/obj/item/natural/cloth,
		/obj/item/caparison,
		/obj/item/reagent_containers/glass/bottle/clayvase,
		/obj/item/reagent_containers/glass/bottle/clayfancyvase,
		/obj/item/reagent_containers/glass/cup/claycup,
		/obj/item/reagent_containers/glass/bottle/claybottle,
		/obj/item/roguestatue/clay,
		/obj/item/roguestatue/glass,
	))
	qdel(I)
	return can_paint

/datum/tat_items/proc/pick_tat_dye(mob/user, current_color = "#FFFFFF", prompt_title = "Loadout Dye")
	if(!user)
		return null
	if(alert(user, "Input Choice", prompt_title, "Color Wheel", "Color Preset") == "Color Wheel")
		var/c = sanitize_hexcolor(color_pick_sanitized(user, "Choose your dye:", "Dyes", current_color), 6, TRUE)
		return (c == "#000000") ? "#FFFFFF" : c

	var/list/colors_to_pick = list()
	if(GLOB.lordprimary)
		colors_to_pick["Primary Keep Color"] = GLOB.lordprimary
	if(GLOB.lordsecondary)
		colors_to_pick["Secondary Keep Color"] = GLOB.lordsecondary
	colors_to_pick += COLOR_MAP
	colors_to_pick += pridelist
	var/picked = input(user, "Choose your dye:", "Dyes", null) as null|anything in colors_to_pick
	if(!picked)
		return null
	return colors_to_pick[picked]

/datum/tat_items/proc/paint_loadout_item(item_path, mob/user)
	if(get_amount(item_path) <= 0)
		return FALSE
	if(!can_paint_item_path(item_path))
		to_chat(user, span_warning("This loadout item cannot be dyed."))
		return FALSE

	var/obj/item/preview = new item_path(null)
	var/list/options = list("Primary color", "Clear primary", "Clear all")
	if(preview?.detail_color)
		options += "Detail color"
		options += "Clear detail"
	if(preview?.altdetail_color)
		options += "Alt detail color"
		options += "Clear alt detail"
	qdel(preview)

	var/choice = tgui_input_list(user, "Choose which loadout dye to edit.", "Loadout Dye", options)
	if(!choice)
		return FALSE

	var/list/paint = get_paint_data(item_path)
	switch(choice)
		if("Primary color")
			var/color = pick_tat_dye(user, paint["primary"] || "#FFFFFF", "Primary Dye")
			if(!color)
				return FALSE
			paint["primary"] = color
		if("Detail color")
			var/color = pick_tat_dye(user, paint["detail"] || "#FFFFFF", "Secondary Dye")
			if(!color)
				return FALSE
			paint["detail"] = color
		if("Alt detail color")
			var/color = pick_tat_dye(user, paint["altdetail"] || "#FFFFFF", "Tertiary Dye")
			if(!color)
				return FALSE
			paint["altdetail"] = color
		if("Clear primary")
			paint -= "primary"
		if("Clear detail")
			paint -= "detail"
		if("Clear alt detail")
			paint -= "altdetail"
		if("Clear all")
			item_paint -= item_path
			owner_build?.set_dirty()
			return TRUE

	if(islist(paint) && !length(paint))
		item_paint -= item_path
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/apply_paint_to_item(item_path, obj/item/I)
	if(!I || QDELETED(I))
		return FALSE
	var/list/paint = item_paint[item_path]
	if(!islist(paint) || !length(paint))
		return FALSE
	if(istext(paint["primary"]))
		I.add_atom_colour(paint["primary"], FIXED_COLOUR_PRIORITY)
	if(istext(paint["detail"]) && I.detail_color)
		I.detail_color = paint["detail"]
	if(istext(paint["altdetail"]) && I.altdetail_color)
		I.altdetail_color = paint["altdetail"]
	I.update_icon()
	return TRUE


/datum/tat_items/proc/get_mind_stash_item_name(item_path)
	var/list/entry = get_entry(item_path)
	if(islist(entry) && istext(entry["name"]) && length(entry["name"]))
		return entry["name"]
	if(ispath(item_path, /obj/item))
		var/obj/item/I = item_path
		return initial(I.name) || "[item_path]"
	return "[item_path]"

/datum/tat_items/proc/get_unique_mind_stash_key(mob/living/carbon/human/H, item_path)
	if(!H?.mind)
		return null
	var/base_name = get_mind_stash_item_name(item_path)
	if(!istext(base_name) || !length(base_name))
		base_name = "[item_path]"
	if(!islist(H.mind.special_items))
		H.mind.special_items = list()
	if(!(base_name in H.mind.special_items))
		return base_name
	for(var/index in 2 to 999)
		var/candidate = "[base_name] ([index])"
		if(!(candidate in H.mind.special_items))
			return candidate
	return "[base_name] ([world.time])"

/datum/tat_items/proc/add_item_path_to_mind_stash(mob/living/carbon/human/H, item_path, amount = 1)
	if(!H?.mind || !ispath(item_path, /obj/item))
		return FALSE
	if(!islist(H.mind.special_items))
		H.mind.special_items = list()
	var/count = max(0, round(amount || 0))
	if(count <= 0)
		return FALSE
	var/added = FALSE
	for(var/i in 1 to count)
		var/key = get_unique_mind_stash_key(H, item_path)
		if(!key)
			continue
		H.mind.special_items[key] = item_path
		if(should_sale_lock_item_path(item_path))
			H.mind.tat_mark_special_item_unmintable(key)
		added = TRUE
	return added

/datum/tat_items/proc/remove_item_path_from_mind_stash(mob/living/carbon/human/H, item_path, amount = 1)
	if(!H?.mind || !ispath(item_path, /obj/item) || !islist(H.mind.special_items))
		return FALSE
	var/count = max(0, round(amount || 0))
	if(count <= 0)
		return FALSE
	var/removed = 0
	for(var/key in H.mind.special_items.Copy())
		if(removed >= count)
			break
		if(H.mind.special_items[key] != item_path)
			continue
		H.mind.tat_unmintable_special_items -= key
		H.mind.special_items -= key
		removed++
	return removed > 0

/datum/tat_items/proc/get_loadout_assigned_slot_count(item_path)
	var/list/loadout = get_loadout(item_path)
	var/list/slots = loadout["slots"]
	if(!islist(slots))
		return 0
	return length(slots)

/datum/tat_items/proc/get_consumed_donor_loadout_amount(item_path)
	var/donor_amount = get_granted_amount(item_path, TAT_ITEM_SOURCE_DONOR_LOADOUT)
	if(donor_amount <= 0)
		return 0
	var/list/loadout = get_loadout(item_path)
	var/assigned = get_loadout_assigned_slot_count(item_path)
	var/bag = max(0, round(loadout["bag"] || 0))
	return min(donor_amount, assigned + bag)

/datum/tat_items/proc/remove_consumed_preference_loadout_from_mind_stash(mob/living/carbon/human/H)
	if(!H?.mind || !islist(H.mind.special_items))
		return FALSE
	var/changed = FALSE
	for(var/item_path in get_all_item_paths())
		var/consumed = get_consumed_donor_loadout_amount(item_path)
		if(consumed <= 0)
			continue
		if(remove_item_path_from_mind_stash(H, item_path, consumed))
			changed = TRUE
	return changed

/datum/tat_items/proc/get_effective_stash_spawn_amount(item_path)
	if(get_amount(item_path) <= 0)
		return 0
	normalize_loadout(item_path)
	var/list/loadout = get_loadout(item_path)
	var/amount = get_amount(item_path)
	var/assigned = get_loadout_assigned_slot_count(item_path)
	var/bag = max(0, round(loadout["bag"] || 0))
	var/stash = max(0, round(loadout["stash"] || 0))
	var/max_stash = max(0, amount - assigned - bag)
	return min(stash, max_stash)

/datum/tat_items/proc/stash_existing_item_for_later(obj/item/I, mob/living/carbon/human/H, item_path = null)
	if(!I || QDELETED(I))
		return FALSE
	if(!ispath(item_path, /obj/item))
		item_path = I.type
	if(add_item_path_to_mind_stash(H, item_path, 1))
		qdel(I)
		return TRUE
	return FALSE

/datum/tat_items/proc/get_storage_targets(mob/living/carbon/human/H)
	var/list/targets = list()
	if(!H)
		return targets
	for(var/slot_id in list(SLOT_BACK_L, SLOT_BACK_R, SLOT_BELT_L, SLOT_BELT_R, SLOT_BACK, SLOT_BELT, SLOT_CLOAK))
		var/obj/item/I = H.get_item_by_slot(slot_id)
		if(I && !(I in targets))
			targets += I
	return targets

/datum/tat_items/proc/try_insert_into_storage(obj/item/I, atom/storage_owner, mob/living/carbon/human/H)
	if(!I || !storage_owner)
		return FALSE
	return !!SEND_SIGNAL(storage_owner, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE)

/datum/tat_items/proc/try_put_into_any_storage_or_drop(obj/item/I, mob/living/carbon/human/H, item_path = null)
	if(!I || !H || QDELETED(I))
		return FALSE
	for(var/storage_owner in get_storage_targets(H))
		if(QDELETED(I))
			return FALSE
		if(try_insert_into_storage(I, storage_owner, H))
			return TRUE
	if(QDELETED(I))
		return FALSE
	if(stash_existing_item_for_later(I, H, item_path))
		return TRUE
	I.forceMove(get_turf(H))
	return FALSE

/datum/tat_items/proc/try_put_into_any_storage_or_drop_no_stash(obj/item/I, mob/living/carbon/human/H)
	if(!I || !H || QDELETED(I))
		return FALSE
	for(var/storage_owner in get_storage_targets(H))
		if(QDELETED(I))
			return FALSE
		if(try_insert_into_storage(I, storage_owner, H))
			return TRUE
	if(QDELETED(I))
		return FALSE
	I.forceMove(get_turf(H))
	return FALSE


/datum/tat_items/proc/is_coin_pouch_path(path)
	if(!ispath(path))
		return FALSE
	return ispath(path, /obj/item/storage/belt/rogue/pouch/coins)

/datum/tat_items/proc/merge_coin_stacks_in_container(atom/container)
	if(!container)
		return FALSE

	var/list/coins_by_type = list()
	for(var/obj/item/roguecoin/coin in container.contents)
		if(QDELETED(coin))
			continue
		if(!coin.base_type)
			continue

		var/coin_type = coin.type
		if(!coins_by_type[coin_type])
			coins_by_type[coin_type] = list()
		coins_by_type[coin_type] += coin

	for(var/coin_type in coins_by_type)
		var/list/coins = coins_by_type[coin_type]
		var/list/active_stacks = list()

		for(var/obj/item/roguecoin/coin as anything in coins)
			if(QDELETED(coin) || coin.quantity <= 0)
				continue

			var/was_merged = FALSE
			for(var/obj/item/roguecoin/target as anything in active_stacks)
				if(QDELETED(target) || target.quantity >= 20)
					continue

				target.merge(coin, null)
				was_merged = TRUE

				if(QDELETED(coin) || coin.quantity <= 0)
					break

			if(!was_merged && !QDELETED(coin) && coin.quantity > 0)
				active_stacks += coin

	return TRUE

/datum/tat_items/proc/get_coin_stack_path_for_value(value)
	value = round(value || 0)
	if(value <= 0)
		return null

	if(SSmapping.config.map_name == "Rockhill")
		if(value >= 14)
			return /obj/item/roguecoin/goldkrona
		return /obj/item/roguecoin/copper

	if(value >= 10)
		return /obj/item/roguecoin/gold
	if(value >= 5)
		return /obj/item/roguecoin/silver
	return /obj/item/roguecoin/copper

/datum/tat_items/proc/insert_coin_stack_into_pouch(obj/item/storage/belt/rogue/pouch/pouch, coin_path, amount)
	if(!pouch || !ispath(coin_path, /obj/item/roguecoin))
		return FALSE

	amount = round(amount || 0)
	if(amount <= 0)
		return FALSE

	var/success = FALSE
	while(amount > 0)
		var/stack_amount = min(amount, 20)
		var/obj/item/roguecoin/coin = new coin_path(get_turf(pouch))
		if(!coin)
			return success

		coin.set_quantity(stack_amount)
		if(!SEND_SIGNAL(pouch, COMSIG_TRY_STORAGE_INSERT, coin, null, TRUE, TRUE))
			qdel(coin)
			return success

		success = TRUE
		amount -= stack_amount

	return success

/datum/tat_items/proc/collect_coin_pouch_value(obj/item/storage/belt/rogue/pouch/pouch)
	if(!pouch)
		return 0

	var/total_value = 0
	for(var/obj/item/roguecoin/coin in pouch.contents)
		if(QDELETED(coin))
			continue
		total_value += round(coin.get_real_price() || 0)
		qdel(coin)

	return total_value

/datum/tat_items/proc/fill_coin_pouch_from_value(obj/item/storage/belt/rogue/pouch/pouch, total_value)
	if(!pouch)
		return FALSE

	total_value = round(total_value || 0)
	if(total_value <= 0)
		return FALSE

	var/list/coin_values = list()
	if(SSmapping.config.map_name == "Rockhill")
		coin_values += 14
		coin_values += 1
	else
		coin_values += 10
		coin_values += 5
		coin_values += 1

	for(var/value in coin_values)
		if(total_value <= 0)
			break

		value = round(value || 0)
		if(value <= 0)
			continue

		var/coin_amount = floor(total_value / value)
		if(coin_amount <= 0)
			continue

		var/coin_path = get_coin_stack_path_for_value(value)
		if(insert_coin_stack_into_pouch(pouch, coin_path, coin_amount))
			total_value -= coin_amount * value

	return TRUE

/datum/tat_items/proc/normalize_coin_pouch_value(obj/item/storage/belt/rogue/pouch/pouch)
	if(!pouch)
		return FALSE

	return fill_coin_pouch_from_value(pouch, collect_coin_pouch_value(pouch))

/datum/tat_items/proc/spawn_combined_coin_pouches_into_bag_or_fallback(mob/living/carbon/human/H, list/pouch_amounts)
	if(!H || !islist(pouch_amounts) || !length(pouch_amounts))
		return FALSE

	var/turf/drop_turf = get_turf(H)
	if(!drop_turf)
		return FALSE

	var/primary_path = null
	for(var/path in pouch_amounts)
		if(is_coin_pouch_path(path) && round(pouch_amounts[path] || 0) > 0)
			primary_path = path
			break
	if(!primary_path)
		return FALSE

	var/obj/item/storage/belt/rogue/pouch/coins/pouch = new primary_path(drop_turf)
	if(!pouch || QDELETED(pouch))
		return FALSE

	var/total_value = collect_coin_pouch_value(pouch)
	var/primary_consumed = FALSE

	for(var/path in pouch_amounts)
		if(!is_coin_pouch_path(path))
			continue

		var/amount = max(0, round(pouch_amounts[path] || 0))
		if(amount <= 0)
			continue

		var/start_index = 1
		if(path == primary_path && !primary_consumed)
			start_index = 2
			primary_consumed = TRUE
		if(start_index > amount)
			continue

		for(var/i in start_index to amount)
			var/obj/item/storage/belt/rogue/pouch/coins/temp_pouch = new path(drop_turf)
			if(!temp_pouch || QDELETED(temp_pouch))
				continue

			total_value += collect_coin_pouch_value(temp_pouch)
			qdel(temp_pouch)

	if(total_value <= 0)
		qdel(pouch)
		return FALSE

	fill_coin_pouch_from_value(pouch, total_value)
	merge_coin_stacks_in_container(pouch)
	apply_paint_to_item(primary_path, pouch)
	try_put_into_any_storage_or_drop_no_stash(pouch, H)
	return TRUE

/datum/tat_items/proc/spawn_stacked_coin_pouch_into_bag_or_fallback(mob/living/carbon/human/H, path, amount = 1)
	if(!H || !is_coin_pouch_path(path))
		return FALSE

	var/list/pouch_amounts = list()
	pouch_amounts[path] = max(1, round(amount || 1))
	return spawn_combined_coin_pouches_into_bag_or_fallback(H, pouch_amounts)

/datum/tat_items/proc/spawn_item_into_bag_or_fallback(mob/living/carbon/human/H, path, amount = 1)
	if(!H || !ispath(path))
		return FALSE

	amount = max(1, round(amount || 1))
	if(is_coin_pouch_path(path))
		return spawn_stacked_coin_pouch_into_bag_or_fallback(H, path, amount)

	var/success = FALSE
	for(var/i in 1 to amount)
		var/obj/item/I = new path(get_turf(H))
		if(!I)
			continue
		apply_sale_lock_to_spawned_item(path, I)
		apply_paint_to_item(path, I)
		try_put_into_any_storage_or_drop(I, H, path)
		success = TRUE
	return success

/datum/tat_items/proc/spawn_item_equipped_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	apply_sale_lock_to_spawned_item(path, I)
	apply_paint_to_item(path, I)
	var/list/slots = get_equip_slots_for_item(I, path)
	for(var/slot_id in slots)
		if(QDELETED(I))
			return FALSE
		if(H.get_item_by_slot(slot_id))
			continue
		if(H.equip_to_slot_if_possible(I, slot_id, FALSE, TRUE, TRUE, TRUE))
			return TRUE
	try_put_into_any_storage_or_drop(I, H, path)
	return FALSE

/datum/tat_items/proc/get_item_slot_group_lower(path)
	var/list/entry = get_entry(path)
	if(!islist(entry))
		return null
	return lowertext("[entry["slot_group"]]")

/datum/tat_items/proc/try_put_into_loadout_hand(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(!H || !I || QDELETED(I))
		return FALSE

	if(slot_id == "hand_l")
		H.put_in_l_hand(I, TRUE)
	else if(slot_id == "hand_r")
		H.put_in_r_hand(I, TRUE)
	else
		return FALSE

	if(QDELETED(I))
		return TRUE
	return I.loc == H

/datum/tat_items/proc/try_equip_existing_item_to_exact_slot(mob/living/carbon/human/H, obj/item/I, equip_slot)
	if(!H || !I || QDELETED(I) || !equip_slot)
		return FALSE
	if(H.get_item_by_slot(equip_slot))
		return FALSE
	if(H.equip_to_slot_if_possible(I, equip_slot, FALSE, TRUE, TRUE, TRUE))
		return H.get_item_by_slot(equip_slot) == I || I.loc == H
	return FALSE

/datum/tat_items/proc/get_hand_loadout_wearable_fallback_slots(item_path, preferred_hand_slot_id = null)
	var/list/result = list()
	var/list/valid_ui_slots = get_valid_loadout_ui_slots_for_item(item_path)
	var/list/preferred_ui_slots = list("shoulder_l", "shoulder_r", "belt", "belt_l", "belt_r")
	for(var/ui_slot in preferred_ui_slots)
		if(!(ui_slot in valid_ui_slots))
			continue
		var/equip_slot = get_loadout_slot_equip_slot(ui_slot)
		if(equip_slot)
			append_unique_equip_slot(result, equip_slot)
	for(var/equip_slot in get_cached_equip_slots_for_item(item_path))
		if(equip_slot == SLOT_HANDS)
			continue
		append_unique_equip_slot(result, equip_slot)
	return result

/datum/tat_items/proc/try_equip_existing_item_to_hand_fallback_slot(mob/living/carbon/human/H, obj/item/I, item_path, preferred_hand_slot_id = null)
	if(!H || !I || QDELETED(I) || !ispath(item_path))
		return FALSE
	for(var/equip_slot in get_hand_loadout_wearable_fallback_slots(item_path, preferred_hand_slot_id))
		if(QDELETED(I))
			return FALSE
		if(try_equip_existing_item_to_exact_slot(H, I, equip_slot))
			return TRUE
	return FALSE

/datum/tat_items/proc/spawn_item_to_exact_slot_or_bag(mob/living/carbon/human/H, path, equip_slot)
	if(!H || !ispath(path) || !equip_slot)
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	apply_sale_lock_to_spawned_item(path, I)
	apply_paint_to_item(path, I)
	if(H.get_item_by_slot(equip_slot))
		try_put_into_any_storage_or_drop(I, H, path)
		return FALSE
	if(H.equip_to_slot_if_possible(I, equip_slot, FALSE, TRUE, TRUE, TRUE))
		if(H.get_item_by_slot(equip_slot) == I)
			return TRUE
		if(!QDELETED(I))
			try_put_into_any_storage_or_drop(I, H, path)
		return FALSE
	try_put_into_any_storage_or_drop(I, H, path)
	return FALSE

/datum/tat_items/proc/spawn_item_to_loadout_hand(mob/living/carbon/human/H, path, slot_id, allow_fallback = TRUE)
	if(!H || !ispath(path) || !is_hand_loadout_slot(slot_id))
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	apply_sale_lock_to_spawned_item(path, I)
	apply_paint_to_item(path, I)
	if(try_put_into_loadout_hand(H, I, slot_id))
		return TRUE
	if(allow_fallback)
		if(try_equip_existing_item_to_hand_fallback_slot(H, I, path, slot_id))
			return TRUE
		try_put_into_any_storage_or_drop(I, H, path)
	else
		qdel(I)
	return FALSE

/datum/tat_items/proc/spawn_item_to_loadout_slot_or_bag(mob/living/carbon/human/H, path, slot_id)
	if(!H || !ispath(path))
		return FALSE
	if(is_hand_loadout_slot(slot_id))
		return spawn_item_to_loadout_hand(H, path, slot_id, TRUE)
	var/equip_slot = get_loadout_slot_equip_slot(slot_id)
	if(!equip_slot)
		return FALSE
	return spawn_item_to_exact_slot_or_bag(H, path, equip_slot)

/datum/tat_items/proc/is_hand_loadout_slot(slot_id)
	return slot_id == "hand_l" || slot_id == "hand_r"

/datum/tat_items/proc/spawn_assigned_loadout_items(mob/living/carbon/human/H, hands_only = FALSE, allow_hand_fallback = TRUE)
	for(var/slot_id in get_loadout_ui_slot_ids())
		if(is_hand_loadout_slot(slot_id) != hands_only)
			continue
		for(var/item_path in get_all_item_paths())
			var/list/loadout = get_loadout(item_path)
			var/list/slots = loadout["slots"]
			if(!islist(slots) || !(slot_id in slots))
				continue
			if(is_hand_loadout_slot(slot_id))
				spawn_item_to_loadout_hand(H, item_path, slot_id, allow_hand_fallback)
			else
				spawn_item_to_loadout_slot_or_bag(H, item_path, slot_id)
			break

/datum/tat_items/proc/get_assigned_item_for_loadout_slot(slot_id)
	if(!is_hand_loadout_slot(slot_id))
		return null
	for(var/item_path in get_all_item_paths())
		var/list/loadout = get_loadout(item_path)
		var/list/slots = loadout["slots"]
		if(islist(slots) && (slot_id in slots))
			return item_path
	return null

/datum/tat_items/proc/spawn_hand_loadout_items(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return FALSE

	var/any_success = FALSE

	for(var/slot_id in list("hand_l", "hand_r"))
		var/item_path = get_assigned_item_for_loadout_slot(slot_id)
		if(!item_path)
			continue

		if(spawn_item_to_loadout_hand(H, item_path, slot_id, TRUE))
			any_success = TRUE

	return any_success

/datum/tat_items/proc/spawn_equipped_items_for_slot_group(mob/living/carbon/human/H, target_slot_group)
	for(var/item_path in get_all_item_paths())
		if(get_item_slot_group_lower(item_path) != lowertext("[target_slot_group]"))
			continue
		var/list/loadout = get_loadout(item_path)
		for(var/i in 1 to round(loadout["equip"] || 0))
			spawn_item_equipped_or_fallback(H, item_path)

/datum/tat_items/proc/spawn_equipped_items_except_slot_groups(mob/living/carbon/human/H, list/excluded_groups)
	for(var/item_path in get_all_item_paths())
		var/slot_group = get_item_slot_group_lower(item_path)
		if(islist(excluded_groups) && (slot_group in excluded_groups))
			continue
		var/list/loadout = get_loadout(item_path)
		for(var/i in 1 to round(loadout["equip"] || 0))
			spawn_item_equipped_or_fallback(H, item_path)

/datum/tat_items/proc/spawn_bag_items(mob/living/carbon/human/H)
	for(var/item_path in get_all_item_paths())
		var/list/loadout = get_loadout(item_path)
		var/bag_amount = round(loadout["bag"] || 0)
		if(bag_amount <= 0)
			continue
		spawn_item_into_bag_or_fallback(H, item_path, bag_amount)

/datum/tat_items/proc/is_roundstart_bag_path(path)
	if(!ispath(path))
		return FALSE
	return ispath(path, /obj/item/storage/backpack/rogue)

/datum/tat_items/proc/is_roundstart_bag_replacer_path(path)
	if(!ispath(path))
		return FALSE
	if(ispath(path, /obj/item/storage/backpack/rogue/backpack))
		return TRUE
	if(path == /obj/item/storage/backpack/rogue/backpack_trader)
		return TRUE
	return FALSE

/datum/tat_items/proc/has_selected_roundstart_backpack()
	for(var/item_path in get_all_item_paths())
		if(get_amount(item_path) <= 0)
			continue
		if(is_roundstart_bag_replacer_path(item_path))
			return TRUE
	return FALSE

/datum/tat_items/proc/has_existing_roundstart_bag(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	for(var/equip_slot in list(SLOT_BACK_L, SLOT_BACK_R, SLOT_BACK))
		var/obj/item/I = H.get_item_by_slot(equip_slot)
		if(I && is_roundstart_bag_path(I.type))
			return TRUE
	return FALSE

/datum/tat_items/proc/spawn_roundstart_bag_to_slot_or_drop(mob/living/carbon/human/H, path, equip_slot)
	if(!H || !ispath(path))
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	apply_sale_lock_to_spawned_item(path, I)
	apply_paint_to_item(path, I)
	if(equip_slot && !H.get_item_by_slot(equip_slot) && H.equip_to_slot_if_possible(I, equip_slot, FALSE, TRUE, TRUE, TRUE))
		return TRUE
	if(!QDELETED(I))
		I.forceMove(get_turf(H))
	return TRUE

/datum/tat_items/proc/get_reserved_loadout_equip_slots()
	var/list/reserved = list()
	for(var/item_path in get_all_item_paths())
		var/list/loadout = get_loadout(item_path)
		var/list/slots = loadout["slots"]
		if(!islist(slots))
			continue
		for(var/slot_id in slots)
			var/equip_slot = get_loadout_slot_equip_slot(slot_id)
			if(equip_slot)
				append_unique_equip_slot(reserved, equip_slot)
	return reserved

/datum/tat_items/proc/grant_default_roundstart_bag(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(has_selected_roundstart_backpack() || has_existing_roundstart_bag(H))
		return FALSE
	var/list/reserved_slots = get_reserved_loadout_equip_slots()
	for(var/equip_slot in list(SLOT_BACK_L, SLOT_BACK_R, SLOT_BACK))
		if(equip_slot in reserved_slots)
			continue
		if(H.get_item_by_slot(equip_slot))
			continue
		return spawn_roundstart_bag_to_slot_or_drop(H, /obj/item/storage/backpack/rogue/satchel, equip_slot)
	return spawn_roundstart_bag_to_slot_or_drop(H, /obj/item/storage/backpack/rogue/satchel, null)


/datum/tat_items/proc/spawn_stash_items(mob/living/carbon/human/H)
	if(!H?.mind)
		return FALSE
	var/added = FALSE
	var/list/coin_pouch_amounts = list()
	for(var/item_path in get_all_item_paths())
		var/stash_amount = get_effective_stash_spawn_amount(item_path)
		if(stash_amount <= 0)
			continue
		if(is_coin_pouch_path(item_path))
			coin_pouch_amounts[item_path] = round(coin_pouch_amounts[item_path] || 0) + stash_amount
			continue
		if(add_item_path_to_mind_stash(H, item_path, stash_amount))
			added = TRUE
	if(length(coin_pouch_amounts))
		if(spawn_combined_coin_pouches_into_bag_or_fallback(H, coin_pouch_amounts))
			added = TRUE
	return added

/datum/tat_items/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	sync_external_grants()
	if(!length(get_all_item_paths()))
		return TRUE

	for(var/item_path in get_all_item_paths())
		normalize_loadout(item_path)

	// If the legacy preference-loadout block already placed donor items into
	// mind.special_items, remove copies that the TAT loadout will spawn in bag or
	// equipped slots. This keeps old integration order from duplicating Pliant gear.
	remove_consumed_preference_loadout_from_mind_stash(H)
	spawn_assigned_loadout_items(H, FALSE)
	grant_default_roundstart_bag(H)
	spawn_stash_items(H)
	spawn_bag_items(H)
	spawn_hand_loadout_items(H)

	return TRUE

/datum/tat_items/proc/disable_from_human(mob/living/carbon/human/H)
	return TRUE

/datum/tat_items/proc/export_to_list()
	return list(
		"selected" = selected.Copy(),
		"item_loadout" = deep_copy_list_alt(item_loadout),
		"item_grants" = deep_copy_list_alt(item_grants),
		"item_paint" = deep_copy_list_alt(item_paint),
	)

/datum/tat_items/proc/import_from_list(list/data)
	reset()
	if(!islist(data))
		return FALSE

	var/list/imported_selected = null
	if(islist(data["selected"]))
		imported_selected = data["selected"]
	else
		imported_selected = data

	for(var/item_path in imported_selected)
		if(item_path == "selected" || item_path == "item_loadout" || item_path == "item_grants" || item_path == "item_paint")
			continue
		set_amount(item_path, imported_selected[item_path])

	if(islist(data["item_grants"]))
		var/list/temp_grants = data["item_grants"]
		item_grants = deep_copy_list_alt(temp_grants)
	if(islist(data["item_loadout"]))
		var/list/temp_loadout = data["item_loadout"]
		item_loadout = deep_copy_list_alt(temp_loadout)
	if(islist(data["item_paint"]))
		var/list/temp_paint = data["item_paint"]
		item_paint = deep_copy_list_alt(temp_paint)

	sync_external_grants()
	for(var/item_path in get_all_item_paths())
		normalize_loadout(item_path)

	return TRUE

/datum/tat_items/proc/export_to_json_list()
	var/list/exported_selected = list()
	for(var/item_path in selected)
		var/amount = get_paid_amount(item_path)
		if(amount > 0)
			exported_selected["[item_path]"] = amount

	var/list/exported_grants = list()
	for(var/item_path in item_grants)
		var/list/sources = item_grants[item_path]
		if(!islist(sources))
			continue
		var/list/exported_sources = list()
		for(var/source_key in sources)
			var/count = round(sources[source_key] || 0)
			if(count > 0)
				exported_sources[source_key] = count
		if(length(exported_sources))
			exported_grants["[item_path]"] = exported_sources

	var/list/exported_loadout = list()
	for(var/item_path in item_loadout)
		if(get_amount(item_path) <= 0)
			continue
		var/list/loadout = item_loadout[item_path]
		if(!islist(loadout))
			continue
		var/list/exported_slots = list()
		var/list/slots = loadout["slots"]
		if(islist(slots))
			for(var/slot_id in slots)
				exported_slots[slot_id] = TRUE
		exported_loadout["[item_path]"] = list(
			"equip" = round(loadout["equip"] || 0),
			"bag" = round(loadout["bag"] || 0),
			"stash" = round(loadout["stash"] || 0),
			"external_stash_initialized" = round(loadout["external_stash_initialized"] || 0),
			"slots" = exported_slots,
		)

	var/list/exported_paint = list()
	for(var/item_path in item_paint)
		var/list/paint = item_paint[item_path]
		if(islist(paint) && length(paint))
			exported_paint["[item_path]"] = paint.Copy()

	return list(
		"selected" = exported_selected,
		"item_grants" = exported_grants,
		"item_loadout" = exported_loadout,
		"item_paint" = exported_paint,
	)

/datum/tat_items/proc/import_from_json_list(list/data)
	reset()
	if(!islist(data))
		return FALSE

	var/list/imported_selected = null
	if(islist(data["selected"]))
		imported_selected = data["selected"]
	else
		imported_selected = data

	for(var/raw_path in imported_selected)
		if(raw_path == "selected" || raw_path == "item_loadout" || raw_path == "item_grants" || raw_path == "item_paint")
			continue
		var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
		if(!item_path)
			continue
		set_amount(item_path, text2num("[imported_selected[raw_path]]"))

	if(islist(data["item_grants"]))
		for(var/raw_path in data["item_grants"])
			var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
			if(!item_path)
				continue
			var/list/source_data = data["item_grants"][raw_path]
			if(!islist(source_data))
				continue
			for(var/source_key in source_data)
				set_item_grant_amount(item_path, source_key, text2num("[source_data[source_key]]"), TRUE)

	if(islist(data["item_loadout"]))
		for(var/raw_path in data["item_loadout"])
			var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
			if(!item_path)
				continue
			var/list/source_loadout = data["item_loadout"][raw_path]
			if(!islist(source_loadout))
				continue
			var/raw_equip = source_loadout["equip"]
			var/raw_bag = source_loadout["bag"]
			var/raw_stash = source_loadout["stash"]
			var/raw_external_stash_initialized = source_loadout["external_stash_initialized"]
			var/list/imported_slots = list()
			if(islist(source_loadout["slots"]))
				var/list/source_slots = source_loadout["slots"]
				for(var/slot_id in source_slots)
					if(source_slots[slot_id])
						imported_slots[slot_id] = TRUE
			item_loadout[item_path] = list(
				"equip" = round(text2num("[raw_equip]") || 0),
				"bag" = round(text2num("[raw_bag]") || 0),
				"stash" = round(text2num("[raw_stash]") || 0),
				"external_stash_initialized" = round(text2num("[raw_external_stash_initialized]") || 0),
				"slots" = imported_slots,
			)

	if(islist(data["item_paint"]))
		for(var/raw_path in data["item_paint"])
			var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
			if(!item_path)
				continue
			var/list/source_paint = data["item_paint"][raw_path]
			if(islist(source_paint))
				item_paint[item_path] = source_paint.Copy()

	sync_external_grants()
	for(var/item_path in get_all_item_paths())
		normalize_loadout(item_path)

	return TRUE

/proc/tat_role_text_matches_pliant(value)
	if(isnull(value))
		return FALSE
	var/text = lowertext("[value]")
	if(findtext(text, "pliant"))
		return TRUE
	// TAT roundstart roles may be stored as SQL buckets or job titles rather than
	// literally containing "Pliant". Treat those as TAT-managed loadout roles too.
	if(text == lowertext(TAT_SQL_ROLE_TOWNER))
		return TRUE
	if(text == lowertext(TAT_SQL_ROLE_TRADER))
		return TRUE
	if(text == lowertext(TAT_SQL_ROLE_ADVENTURER))
		return TRUE
	if(text == lowertext(TAT_SQL_ROLE_WRETCH))
		return TRUE
	if(findtext(text, "tat "))
		return TRUE
	if(findtext(text, "tat_"))
		return TRUE
	return FALSE

/proc/tat_is_pliant_roundstart_character(mob/living/carbon/human/character)
	if(!character)
		return FALSE

	if(character.tat_handles_preference_loadout)
		return TRUE

	if(tat_role_text_matches_pliant(character.tat_pliant_title))
		return TRUE

	if(tat_role_text_matches_pliant(character.advjob))
		return TRUE

	var/assigned_role = character.mind?.assigned_role
	if(tat_role_text_matches_pliant(assigned_role))
		return TRUE

	var/datum/job/assigned_job = SSjob.GetJob(assigned_role)
	if(assigned_job)
		if(tat_role_text_matches_pliant("[assigned_job.type]"))
			return TRUE
		if(tat_role_text_matches_pliant(assigned_job.title))
			return TRUE

	return FALSE

/proc/tat_build_handles_preference_loadout(mob/living/carbon/human/character, client/player)
	if(!character)
		return FALSE
	if(!player)
		player = character.client
	if(!player?.prefs?.tat_build)
		return FALSE

	// Preferred path: the actual TAT build application has marked the character.
	// Fallback path: detect TAT/Pliant roundstart roles before the build flag exists.
	if(!character.tat_handles_preference_loadout && !tat_is_pliant_roundstart_character(character))
		return FALSE

	var/datum/tat_build/build = player.prefs.tat_build
	build.attach_preferences(player.prefs)
	if(build.is_owner_tat_banned(character))
		return FALSE

	character.tat_handles_preference_loadout = TRUE
	build.items?.sync_donor_loadout_from_preferences()
	return TRUE

/proc/tat_apply_legacy_preference_loadout(mob/living/carbon/human/character, client/player)
	if(!character)
		return FALSE
	if(!player)
		player = character.client
	if(!player?.prefs)
		return FALSE
	if(tat_build_handles_preference_loadout(character, player))
		return TRUE

	var/triumph_discount_remaining = get_donator_triumph_discount(player.ckey) // TA EDIT - donor triumph discount scales by Patreon tier
	if(player.prefs.selected_loadout_items)
		for(var/key in player.prefs.selected_loadout_items)
			var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
			if(!item)
				continue

			if(item.triumph_cost)
				var/discounted_cost = max(0, item.triumph_cost - triumph_discount_remaining)
				if(discounted_cost > 0 && character.get_triumphs() < discounted_cost)
					to_chat(character, span_warning("Недостаточно триумфов для [item.name]."))
					continue

				triumph_discount_remaining = max(0, triumph_discount_remaining - item.triumph_cost)
				if(discounted_cost > 0)
					character.adjust_triumphs(-discounted_cost)

			character.mind.special_items[item.name] = item.path
	return TRUE
