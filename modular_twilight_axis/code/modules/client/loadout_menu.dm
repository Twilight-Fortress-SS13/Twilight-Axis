// TA EDIT START
#define TA_LOADOUT_NAME_LENGTH 64
#define TA_LOADOUT_DESC_LENGTH 1024

/datum/loadout_menu
	var/client/owner
	var/list/gear_list = list()
	var/subscription_tier = 0

/datum/loadout_menu/New(client/new_owner)
	owner = new_owner
	if(owner?.prefs)
		owner.prefs.sanitize_subscription_loadout(owner.mob)
		gear_list = deepCopyList(owner.prefs.gear_list)
		subscription_tier = owner.prefs.loadout_subscription_tier

/datum/loadout_menu/Destroy()
	owner = null
	gear_list = null
	return ..()

/datum/loadout_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_menu/ui_interact(mob/user, datum/tgui/ui)
	if(user.client != owner)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutMenu", "Лодаут")
		ui.open()

/datum/loadout_menu/ui_close(mob/user)
	qdel(src)

/datum/loadout_menu/proc/sanitize_selection(mob/user)
	owner.prefs.sanitize_subscription_loadout(user)
	var/current_tier = owner.prefs.loadout_subscription_tier
	if(GLOB.PatreonsLoaded)
		if(current_tier < subscription_tier || gear_list.len > owner.prefs.get_loadout_size(user))
			gear_list.Cut()
		subscription_tier = current_tier
	for(var/item_name in gear_list.Copy())
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		if(!item?.path || (GLOB.PatreonsLoaded && item.get_loadout_lock_reason(user)))
			gear_list -= item_name

/datum/loadout_menu/ui_static_data(mob/user)
	if(user.client != owner)
		return list()
	var/list/items = list()
	var/list/categories = list("Всё")
	for(var/category in GLOB.loadout_items_by_category)
		categories |= category
	for(var/item_name in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		if(!ispath(item.path, /obj/item))
			continue
		if(item.ckeywhitelist && !item.donator_ckey_check(user.ckey))
			continue
		var/list/item_categories = list()
		item_categories += item.category
		items += list(list(
			"name" = item_name,
			"label" = item.name,
			"desc" = item.desc,
			"categories" = item_categories,
			"triumph_cost" = item.triumph_cost,
			"donator_item" = item.donatitem,
			"donator_tier" = item.donat_tier,
			"color_channels" = item.get_loadout_color_channels(),
			"preview_layers" = item.get_loadout_preview_layers(),
			"requirements" = item.get_loadout_requirements(),
		))
	return list("items" = items, "categories" = categories)

/datum/loadout_menu/ui_data(mob/user)
	if(user.client != owner)
		return list()
	sanitize_selection(user)
	var/list/selected = list()
	var/list/locks = list()
	var/total_triumph_cost = 0
	for(var/item_name in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		if(item.ckeywhitelist && !item.donator_ckey_check(user.ckey))
			continue
		var/reason = item.get_loadout_lock_reason(user)
		if(reason)
			locks[item_name] = reason
	for(var/item_name in gear_list)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		var/list/meta = gear_list[item_name]
		if(!islist(meta))
			meta = list()
		var/list/colors = list()
		var/list/color_labels = list()
		for(var/channel in item.get_loadout_color_channels())
			var/color_setting = owner.prefs.get_loadout_item_color(item_name, channel, gear_list)
			colors[channel] = resolve_loadout_color_setting(color_setting)
			color_labels[channel] = get_loadout_color_setting_label(color_setting)
		selected += list(list(
			"name" = item_name,
			"colors" = colors,
			"color_labels" = color_labels,
			"custom_name" = meta["custom_name"],
			"custom_desc" = meta["custom_desc"],
		))
		total_triumph_cost += item.triumph_cost
	var/discount = get_donator_triumph_discount(user.ckey)
	return list(
		"selected" = selected,
		"subscription_loaded" = GLOB.PatreonsLoaded,
		"locks" = locks,
		"max_slots" = owner.prefs.get_loadout_size(user),
		"donator_tier" = check_patreon_lvl(user.ckey),
		"triumph_discount" = discount,
		"total_triumph_cost" = total_triumph_cost,
		"effective_triumph_cost" = max(0, total_triumph_cost - discount),
		"player_triumphs" = user.get_triumphs() || 0,
	)

/datum/loadout_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user
	if(!owner?.prefs || user.client != owner)
		return FALSE
	if(!GLOB.PatreonsLoaded && action != "cancel" && action != "boosty")
		return TRUE
	sanitize_selection(user)
	var/item_name = params["name"]
	if(!istext(item_name))
		item_name = null
	var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
	switch(action)
		if("toggle_item")
			if(item_name in gear_list)
				gear_list -= item_name
				return TRUE
			if(!item?.path)
				return TRUE
			var/lock_reason = item.get_loadout_lock_reason(user)
			if(lock_reason)
				to_chat(user, span_warning(lock_reason))
				return TRUE
			if(gear_list.len >= owner.prefs.get_loadout_size(user))
				to_chat(user, span_warning("Лимит предметов исчерпан."))
				return TRUE
			gear_list[item_name] = list()
			return TRUE
		if("set_color")
			if(!item || !istext(params["channel"]) || item.get_loadout_lock_reason(user))
				return TRUE
			owner.prefs.pick_loadout_item_color(user, item_name, params["channel"], gear_list)
			return TRUE
		if("clear_colors")
			owner.prefs.clear_loadout_item_colors(item_name, gear_list)
			return TRUE
		if("set_custom_name", "set_custom_desc")
			if(!item || !(item_name in gear_list) || item.get_loadout_lock_reason(user))
				return TRUE
			var/list/meta = gear_list[item_name]
			if(!islist(meta))
				meta = list()
			var/meta_key = action == "set_custom_name" ? "custom_name" : "custom_desc"
			var/value = params["value"]
			if(!istext(value))
				return TRUE
			if(meta_key == "custom_name")
				value = replacetext(value, "\n", "")
				value = replacetext(value, "\r", "")
				value = copytext_char(value, 1, TA_LOADOUT_NAME_LENGTH + 1)
			else
				value = copytext_char(value, 1, TA_LOADOUT_DESC_LENGTH + 1)
			if(value)
				meta[meta_key] = value
				meta["[meta_key]_parsed"] = parsemarkdown_basic(html_encode(value), limited = meta_key == "custom_name")
				if(meta_key == "custom_name" && findtext(meta["custom_name_parsed"], "\\improper") == 1)
					meta["custom_name_parsed"] = "\improper" + copytext(meta["custom_name_parsed"], 10)
				if(meta_key == "custom_desc")
					meta["custom_desc_parsed"] = replacetext(meta["custom_desc_parsed"], "\n", "<br/>")
			else
				meta -= meta_key
				meta -= "[meta_key]_parsed"
			gear_list[item_name] = meta
			return TRUE
		if("clear_all")
			gear_list.Cut()
			return TRUE
		if("confirm")
			owner.prefs.gear_list = deepCopyList(gear_list)
			owner.prefs.save_character()
			owner.prefs.update_pref_data_for_all_viewers()
			ui.close()
			return TRUE
		if("cancel")
			ui.close()
			return TRUE
		if("boosty")
			var/boosty_url = CONFIG_GET(string/boostyurl)
			if(boosty_url)
				user << link(boosty_url)
			return TRUE

/datum/loadout_item/proc/get_loadout_preview_type()
	if(!ispath(path, /obj/item))
		return
	if(ispath(path, /obj/item/enchantingkit))
		var/obj/item/enchantingkit/kit = path
		var/result = initial(kit.icon_loadout) || initial(kit.result_item)
		if(ispath(result, /obj/item))
			return result
	return path

/datum/loadout_item/proc/get_loadout_preview_layers()
	var/obj/item/preview_type = get_loadout_preview_type()
	if(!preview_type)
		return
	var/icon_file = initial(preview_type.icon)
	var/icon_state = initial(preview_type.icon_state)
	if(!icon_file || !icon_exists(icon_file, icon_state))
		return
	var/list/layers = list(list("icon" = "[icon_file]", "icon_state" = icon_state, "color" = initial(preview_type.color), "channel" = "primary"))
	var/detail = initial(preview_type.detail_tag)
	if(detail && icon_exists(icon_file, "[icon_state][detail]"))
		layers += list(list("icon" = "[icon_file]", "icon_state" = "[icon_state][detail]", "color" = initial(preview_type.detail_color), "channel" = "detail"))
	var/altdetail = initial(preview_type.altdetail_tag)
	if(altdetail && icon_exists(icon_file, "[icon_state][altdetail]"))
		layers += list(list("icon" = "[icon_file]", "icon_state" = "[icon_state][altdetail]", "color" = initial(preview_type.altdetail_color), "channel" = "altdetail"))
	return layers

/datum/loadout_item/proc/get_loadout_requirements()
	if(!ispath(path, /obj/item/enchantingkit))
		return
	var/obj/item/enchantingkit/kit = path
	var/list/target_items = initial(kit.target_items)
	var/list/names = list()
	for(var/target_type in target_items)
		if(!ispath(target_type, /obj/item))
			continue
		var/obj/item/target_item = target_type
		names |= initial(target_item.name)
	return english_list(names)

#undef TA_LOADOUT_NAME_LENGTH
#undef TA_LOADOUT_DESC_LENGTH
// TA EDIT END
