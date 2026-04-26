/datum/tat_items
	var/datum/tat_build/owner_build
	var/list/selected = list()
	var/list/item_loadout = list()
	var/list/applied_mob_refs = list()
	var/base_points = 20

/datum/tat_items/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/tat_items/proc/reset()
	selected = list()
	item_loadout = list()
	return TRUE

/datum/tat_items/proc/get_entry(item_path)
	var/list/all = list(TAT_AVAILABLE_ITEMS_LIST)
	if(!(item_path in all))
		return null
	return all[item_path]

/datum/tat_items/proc/get_amount(item_path)
	return round(selected[item_path] || 0)

/datum/tat_items/proc/get_cost(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return 0
	return round(entry["cost"] || 0)

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
			return !!owner_build?.has_trait(TAT_TRAIT_MAIL_SUPPLIER)
		if(TAT_ARMOR_PLATE)
			return !!owner_build?.has_trait(TAT_TRAIT_PLATE_SUPPLIER)
	return FALSE

/datum/tat_items/proc/can_use_item_entry(list/entry)
	if(!islist(entry))
		return FALSE
	var/unlock_type = entry["unlock_type"]
	var/unlock_key = entry["unlock_key"]
	switch(unlock_type)
		if(TAT_UNLOCK_TYPE_WEAPON_SUPPLY)
			return can_use_weapon_supply_type(unlock_key)
		if(TAT_UNLOCK_TYPE_ARMOR_FAMILY)
			return can_use_armor_family(unlock_key)
	return TRUE

/datum/tat_items/proc/check_item(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return FALSE
	if(!can_use_item_entry(entry))
		return FALSE
	return TRUE

/datum/tat_items/proc/is_item_slot_limited(list/entry)
	if(!islist(entry))
		return FALSE
	var/category = lowertext("[entry["category"]]")
	if(category == "weapon")
		return FALSE
	var/slot_group = lowertext("[entry["slot_group"]]")
	if(slot_group == "misc")
		return FALSE
	return TRUE

/datum/tat_items/proc/get_slot_group_item_count(slot_group, category, exclude_item_path = null)
	if(!slot_group)
		return 0
	var/target_slot_group = lowertext("[slot_group]")
	var/target_category = lowertext("[category]")
	var/total = 0
	for(var/item_path in selected)
		if(!ispath(item_path))
			continue
		if(!isnull(exclude_item_path) && item_path == exclude_item_path)
			continue
		var/list/entry = get_entry(item_path)
		if(!islist(entry))
			continue
		var/entry_slot_group = lowertext("[entry["slot_group"]]")
		var/entry_category = lowertext("[entry["category"]]")
		if(entry_slot_group != target_slot_group)
			continue
		if(entry_category != target_category)
			continue
		var/amount = selected[item_path]
		if(!isnum(amount) || amount <= 0)
			continue
		total += amount
	return total

/datum/tat_items/proc/get_item_total_allowed_amount(path)
	var/list/entry = get_entry(path)
	if(!islist(entry))
		return 0
	var/category = lowertext("[entry["category"]]")
	var/cost = get_cost(path)
	if(cost <= 0 && (category == "misc" || category == "weapon"))
		return 1
	if(!is_item_slot_limited(entry))
		return INFINITY
	var/slot_group = entry["slot_group"]
	if(!slot_group)
		return INFINITY
	return 1

/datum/tat_items/proc/get_maximum(item_path)
	if(!check_item(item_path))
		return 0
	var/total_allowed = get_item_total_allowed_amount(item_path)
	if(total_allowed <= 0)
		return 0
	if(total_allowed == INFINITY)
		return 99
	var/list/entry = get_entry(item_path)
	var/category = lowertext("[entry["category"]]")
	if(get_cost(item_path) <= 0 && (category == "misc" || category == "weapon"))
		return total_allowed
	var/already_taken_elsewhere = get_slot_group_item_count(entry["slot_group"], entry["category"], item_path)
	return max(0, total_allowed - already_taken_elsewhere)

/datum/tat_items/proc/set_amount(item_path, amount)
	if(!islist(get_entry(item_path)))
		return FALSE
	amount = round(amount)
	amount = clamp(amount, 0, get_maximum(item_path))
	if(amount <= 0)
		selected -= item_path
		item_loadout -= item_path
	else
		selected[item_path] = amount
		normalize_loadout(item_path)
	owner_build?.set_dirty()
	return TRUE

/datum/tat_items/proc/get_loadout(item_path)
	if(!(item_path in item_loadout) || !islist(item_loadout[item_path]))
		item_loadout[item_path] = list("equip" = get_amount(item_path), "bag" = 0)
	return item_loadout[item_path]

/datum/tat_items/proc/normalize_loadout(item_path)
	var/amount = get_amount(item_path)
	if(amount <= 0)
		item_loadout -= item_path
		return
	var/list/loadout = get_loadout(item_path)
	var/equip = max(0, round(loadout["equip"] || 0))
	var/bag = max(0, round(loadout["bag"] || 0))
	if(equip > amount)
		equip = amount
	if(bag > (amount - equip))
		bag = amount - equip
	if(equip + bag < amount)
		equip += amount - (equip + bag)
	loadout["equip"] = equip
	loadout["bag"] = bag

/datum/tat_items/proc/get_spent_points()
	var/total = 0
	for(var/item_path in selected)
		total += get_cost(item_path) * get_amount(item_path)
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
	for(var/item_path in selected.Copy())
		if(!check_item(item_path))
			selected -= item_path
			item_loadout -= item_path
			continue
		set_amount(item_path, get_amount(item_path))
	while(get_remaining_points() < 0)
		var/changed = FALSE
		for(var/item_path in selected.Copy())
			var/amount = get_amount(item_path)
			if(amount > 0)
				set_amount(item_path, amount - 1)
				changed = TRUE
				if(get_remaining_points() >= 0)
					break
		if(!changed)
			break
	for(var/item_path in selected)
		normalize_loadout(item_path)
	return TRUE

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

	var/flags = I.slot_flags
	if(flags & ITEM_SLOT_HEAD)
		append_unique_equip_slot(slots, SLOT_HEAD)
	if(flags & ITEM_SLOT_MASK)
		append_unique_equip_slot(slots, SLOT_WEAR_MASK)
	if(flags & ITEM_SLOT_NECK)
		append_unique_equip_slot(slots, SLOT_NECK)
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
	return slots

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

/datum/tat_items/proc/try_put_into_any_storage_or_drop(obj/item/I, mob/living/carbon/human/H)
	if(!I || !H)
		return FALSE
	for(var/storage_owner in get_storage_targets(H))
		if(try_insert_into_storage(I, storage_owner, H))
			return TRUE
	I.forceMove(get_turf(H))
	return TRUE

/datum/tat_items/proc/spawn_item_into_bag_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return
	try_put_into_any_storage_or_drop(I, H)

/datum/tat_items/proc/spawn_item_equipped_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	var/list/slots = get_equip_slots_for_item(I, path)
	for(var/slot_id in slots)
		if(H.equip_to_slot_if_possible(I, slot_id, FALSE, TRUE, TRUE, TRUE))
			return TRUE
	try_put_into_any_storage_or_drop(I, H)
	return FALSE

/datum/tat_items/proc/get_item_slot_group_lower(path)
	var/list/entry = get_entry(path)
	if(!islist(entry))
		return null
	return lowertext("[entry["slot_group"]]")

/datum/tat_items/proc/spawn_equipped_items_for_slot_group(mob/living/carbon/human/H, target_slot_group)
	for(var/item_path in selected)
		if(get_item_slot_group_lower(item_path) != lowertext("[target_slot_group]"))
			continue
		var/list/loadout = get_loadout(item_path)
		for(var/i in 1 to round(loadout["equip"] || 0))
			spawn_item_equipped_or_fallback(H, item_path)

/datum/tat_items/proc/spawn_equipped_items_except_slot_groups(mob/living/carbon/human/H, list/excluded_groups)
	for(var/item_path in selected)
		var/slot_group = get_item_slot_group_lower(item_path)
		if(islist(excluded_groups) && (slot_group in excluded_groups))
			continue
		var/list/loadout = get_loadout(item_path)
		for(var/i in 1 to round(loadout["equip"] || 0))
			spawn_item_equipped_or_fallback(H, item_path)

/datum/tat_items/proc/spawn_bag_items(mob/living/carbon/human/H)
	for(var/item_path in selected)
		var/list/loadout = get_loadout(item_path)
		for(var/i in 1 to round(loadout["bag"] || 0))
			spawn_item_into_bag_or_fallback(H, item_path)

/datum/tat_items/proc/has_selected_roundstart_backpack()
	return get_amount(/obj/item/storage/backpack/rogue/backpack) > 0

/datum/tat_items/proc/grant_default_roundstart_bag(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(has_selected_roundstart_backpack())
		return FALSE
	spawn_item_equipped_or_fallback(H, /obj/item/storage/backpack/rogue/satchel)
	return TRUE

/datum/tat_items/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/mob_ref = "\ref[H]"
	if(mob_ref in applied_mob_refs)
		return FALSE
	applied_mob_refs += mob_ref
	grant_default_roundstart_bag(H)
	spawn_equipped_items_for_slot_group(H, "shirt")
	spawn_equipped_items_for_slot_group(H, "pants")
	spawn_equipped_items_except_slot_groups(H, list("shirt", "pants"))
	spawn_bag_items(H)
	return TRUE

/datum/tat_items/proc/disable_from_human(mob/living/carbon/human/H)
	return TRUE

/datum/tat_items/proc/export_to_list()
	return list("selected" = selected.Copy(), "item_loadout" = item_loadout.Copy())

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
		if(item_path == "selected")
			continue
		if(item_path == "item_loadout")
			continue
		set_amount(item_path, imported_selected[item_path])

	if(islist(data["item_loadout"]))
		var/list/temp = data["item_loadout"]
		item_loadout = temp.Copy()

	for(var/item_path in selected)
		normalize_loadout(item_path)

	return TRUE

/datum/tat_items/proc/export_to_json_list()
	var/list/exported_selected = list()
	for(var/item_path in selected)
		var/amount = get_amount(item_path)
		if(amount > 0)
			exported_selected["[item_path]"] = amount

	var/list/exported_loadout = list()
	for(var/item_path in item_loadout)
		if(!(item_path in selected))
			continue
		var/list/loadout = item_loadout[item_path]
		if(!islist(loadout))
			continue
		exported_loadout["[item_path]"] = list(
			"equip" = round(loadout["equip"] || 0),
			"bag" = round(loadout["bag"] || 0),
		)

	return list(
		"selected" = exported_selected,
		"item_loadout" = exported_loadout,
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
		if(raw_path == "selected" || raw_path == "item_loadout")
			continue
		var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
		if(!item_path)
			continue
		set_amount(item_path, text2num("[imported_selected[raw_path]]"))

	if(islist(data["item_loadout"]))
		for(var/raw_path in data["item_loadout"])
			var/item_path = ispath(raw_path) ? raw_path : text2path("[raw_path]")
			if(!item_path || !(item_path in selected))
				continue
			var/list/source_loadout = data["item_loadout"][raw_path]
			if(!islist(source_loadout))
				continue
			var/raw_equip = source_loadout["equip"]
			var/raw_bag = source_loadout["bag"]
			item_loadout[item_path] = list(
				"equip" = round(text2num("[raw_equip]") || 0),
				"bag" = round(text2num("[raw_bag]") || 0),
			)

	for(var/item_path in selected)
		normalize_loadout(item_path)

	return TRUE
