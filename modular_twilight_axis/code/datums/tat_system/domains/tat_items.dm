/datum/tat_items
	var/datum/tat_build/owner_build
	var/list/selected = list()
	var/list/item_loadout = list()
	var/base_points = 20
	var/list/equip_slots_cache = list()

/datum/tat_items/New(datum/tat_build/B)
	. = ..()
	owner_build = B

/datum/tat_items/proc/reset()
	selected = list()
	item_loadout = list()
	return TRUE

/datum/tat_items/proc/get_entry(item_path)
	return GLOB.tat_available_items[item_path]

/datum/tat_items/proc/get_amount(item_path)
	return round(selected[item_path] || 0)

/datum/tat_items/proc/get_cost(item_path)
	var/list/entry = get_entry(item_path)
	if(!islist(entry))
		return 0

	var/cost = entry["cost"]
	if(!isnum(cost))
		return 0

	return cost

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
	for(var/item_path in selected)
		if(!isnull(exclude_item_path) && item_path == exclude_item_path)
			continue
		var/list/entry = GLOB.tat_available_items[item_path]
		if(!islist(entry))
			continue
		if(entry["slot_group"] != slot_group)
			continue
		if(entry["category"] != category)
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
	var/cost = entry["cost"]
	if(!isnum(cost))
		cost = 0
	var/category = entry["category"]
	if(cost <= 0 && (category == "misc" || category == "weapon"))
		return 1
	if(!tat_item_entry_is_slot_limited(entry))
		return 99
	var/slot_group = entry["slot_group"]
	if(!slot_group)
		return 99
	var/already_taken_elsewhere = get_slot_group_item_count(slot_group, category, item_path)
	return max(0, 1 - already_taken_elsewhere)

/datum/tat_items/proc/set_amount(item_path, amount, ignore_limits = FALSE)
	if(!islist(get_entry(item_path)))
		return FALSE
	amount = round(amount)
	if(ignore_limits)
		amount = max(0, amount)
	else
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
		item_loadout[item_path] = list("equip" = 0, "bag" = get_amount(item_path), "slots" = list())
	return item_loadout[item_path]

/datum/tat_items/proc/normalize_loadout(item_path)
	var/amount = get_amount(item_path)
	if(amount <= 0)
		item_loadout -= item_path
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

	loadout["equip"] = length(slots)
	loadout["bag"] = max(0, amount - length(slots))

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

	clear_loadout_slot(slot_id)

	var/list/loadout = get_loadout(item_path)
	var/list/slots = loadout["slots"]
	if(!islist(slots))
		slots = list()
		loadout["slots"] = slots
	if(!(slot_id in slots))
		while(length(slots) >= get_amount(item_path))
			var/drop_slot = slots[length(slots)]
			slots -= drop_slot
		slots[slot_id] = TRUE
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
		if(QDELETED(I))
			return FALSE
		if(H.get_item_by_slot(slot_id))
			continue
		if(H.equip_to_slot_if_possible(I, slot_id, FALSE, TRUE, TRUE, TRUE))
			return TRUE
	try_put_into_any_storage_or_drop(I, H)
	return FALSE

/datum/tat_items/proc/get_item_slot_group_lower(path)
	var/list/entry = get_entry(path)
	if(!islist(entry))
		return null
	return lowertext("[entry["slot_group"]]")

/datum/tat_items/proc/try_put_into_loadout_hand(mob/living/carbon/human/H, obj/item/I, slot_id)
	if(!H || !I || QDELETED(I))
		return FALSE

	var/free_hand = 0
	if(slot_id == "hand_l")
		H.put_in_l_hand(I, TRUE)
	else if(slot_id == "hand_r")
		H.put_in_r_hand(I, TRUE)
	if(!free_hand)
		return TRUE

	return FALSE

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
	if(H.get_item_by_slot(equip_slot))
		try_put_into_any_storage_or_drop(I, H)
		return FALSE
	if(H.equip_to_slot_if_possible(I, equip_slot, FALSE, TRUE, TRUE, TRUE))
		if(H.get_item_by_slot(equip_slot) == I)
			return TRUE
		if(!QDELETED(I))
			try_put_into_any_storage_or_drop(I, H)
		return FALSE
	try_put_into_any_storage_or_drop(I, H)
	return FALSE

/datum/tat_items/proc/spawn_item_to_loadout_hand(mob/living/carbon/human/H, path, slot_id, allow_fallback = TRUE)
	if(!H || !ispath(path) || !is_hand_loadout_slot(slot_id))
		return FALSE
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return FALSE
	if(try_put_into_loadout_hand(H, I, slot_id))
		return TRUE
	if(allow_fallback)
		if(try_equip_existing_item_to_hand_fallback_slot(H, I, path, slot_id))
			return TRUE
		try_put_into_any_storage_or_drop(I, H)
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
		for(var/item_path in selected)
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
	for(var/item_path in selected)
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

/datum/tat_items/proc/is_roundstart_bag_path(path)
	if(!ispath(path))
		return FALSE
	return ispath(path, /obj/item/storage/backpack/rogue)

/datum/tat_items/proc/has_selected_roundstart_backpack()
	for(var/item_path in selected)
		if(get_amount(item_path) <= 0)
			continue
		if(is_roundstart_bag_path(item_path))
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
	if(equip_slot && !H.get_item_by_slot(equip_slot) && H.equip_to_slot_if_possible(I, equip_slot, FALSE, TRUE, TRUE, TRUE))
		return TRUE
	if(!QDELETED(I))
		I.forceMove(get_turf(H))
	return TRUE

/datum/tat_items/proc/get_reserved_loadout_equip_slots()
	var/list/reserved = list()
	for(var/item_path in selected)
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

/datum/tat_items/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	if(!length(selected))
		return TRUE

	for(var/item_path in selected)
		normalize_loadout(item_path)

	spawn_assigned_loadout_items(H, FALSE)
	grant_default_roundstart_bag(H)
	spawn_bag_items(H)
	spawn_hand_loadout_items(H)

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
		var/list/exported_slots = list()
		var/list/slots = loadout["slots"]
		if(islist(slots))
			for(var/slot_id in slots)
				exported_slots[slot_id] = TRUE
		exported_loadout["[item_path]"] = list(
			"equip" = round(loadout["equip"] || 0),
			"bag" = round(loadout["bag"] || 0),
			"slots" = exported_slots,
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
			var/list/imported_slots = list()
			if(islist(source_loadout["slots"]))
				var/list/source_slots = source_loadout["slots"]
				for(var/slot_id in source_slots)
					if(source_slots[slot_id])
						imported_slots[slot_id] = TRUE
			item_loadout[item_path] = list(
				"equip" = round(text2num("[raw_equip]") || 0),
				"bag" = round(text2num("[raw_bag]") || 0),
				"slots" = imported_slots,
			)

	for(var/item_path in selected)
		normalize_loadout(item_path)

	return TRUE
