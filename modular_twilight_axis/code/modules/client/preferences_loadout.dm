#define LOADOUT_COLOR_DUCHY_PRIMARY "duchy_primary"
#define LOADOUT_COLOR_DUCHY_SECONDARY "duchy_secondary"

/proc/is_loadout_duchy_color_source(color)
	return color == LOADOUT_COLOR_DUCHY_PRIMARY || color == LOADOUT_COLOR_DUCHY_SECONDARY

/proc/sanitize_loadout_color_setting(color)
	if(!istext(color))
		return
	if(is_loadout_duchy_color_source(color))
		return color
	return sanitize_hexcolor(color, 6, TRUE, null)

/proc/resolve_loadout_color_setting(color)
	var/sanitized_color = sanitize_loadout_color_setting(color)
	if(!sanitized_color)
		return
	switch(sanitized_color)
		if(LOADOUT_COLOR_DUCHY_PRIMARY)
			if(GLOB.lordprimary)
				return sanitize_hexcolor(GLOB.lordprimary, 6, TRUE, null)
			return
		if(LOADOUT_COLOR_DUCHY_SECONDARY)
			if(GLOB.lordsecondary)
				return sanitize_hexcolor(GLOB.lordsecondary, 6, TRUE, null)
			return
	return sanitized_color

/proc/get_loadout_color_setting_label(color)
	var/sanitized_color = sanitize_loadout_color_setting(color)
	if(!sanitized_color)
		return
	switch(sanitized_color)
		if(LOADOUT_COLOR_DUCHY_PRIMARY)
			return "Primary Keep Color"
		if(LOADOUT_COLOR_DUCHY_SECONDARY)
			return "Secondary Keep Color"
	return sanitized_color

/proc/update_loadout_lord_colors(primary, secondary)
	for(var/datum/weakref/item_ref as anything in GLOB.loadout_lordcolor.Copy())
		var/obj/item/item = item_ref.resolve()
		if(!item)
			GLOB.loadout_lordcolor -= item_ref
			continue
		item.apply_loadout_duchy_colors(primary, secondary)

/obj/item
	var/list/loadout_duchy_color_sources

/obj/item/proc/apply_loadout_color_channel(channel, color_value)
	if(!color_value)
		return FALSE
	switch(channel)
		if("primary")
			add_atom_colour(color_value, FIXED_COLOUR_PRIORITY)
		if("detail")
			if(!detail_tag)
				return FALSE
			detail_color = color_value
		if("altdetail")
			if(!altdetail_tag)
				return FALSE
			altdetail_color = color_value
		else
			return FALSE
	return TRUE

/obj/item/proc/refresh_loadout_colors()
	update_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.regenerate_icons()

/obj/item/proc/apply_loadout_duchy_colors(primary, secondary, refresh = TRUE)
	if(!islist(loadout_duchy_color_sources))
		return FALSE
	var/changed = FALSE
	for(var/channel in loadout_duchy_color_sources)
		var/color_source = loadout_duchy_color_sources[channel]
		var/color_value
		switch(color_source)
			if(LOADOUT_COLOR_DUCHY_PRIMARY)
				color_value = primary
			if(LOADOUT_COLOR_DUCHY_SECONDARY)
				color_value = secondary
		if(color_value && apply_loadout_color_channel(channel, color_value))
			changed = TRUE
	if(changed && refresh)
		refresh_loadout_colors()
	return changed

/obj/item/proc/apply_loadout_color_metadata(list/metadata)
	if(!islist(metadata))
		return FALSE
	var/static/list/channel_meta_keys = list(
		"primary" = "color",
		"detail" = "detail_color",
		"altdetail" = "altdetail_color",
	)
	var/list/duchy_color_sources = list()
	var/changed = FALSE
	for(var/channel in channel_meta_keys)
		var/color_setting = sanitize_loadout_color_setting(metadata[channel_meta_keys[channel]])
		if(!color_setting)
			continue
		if(is_loadout_duchy_color_source(color_setting))
			duchy_color_sources[channel] = color_setting
			continue
		var/color_value = resolve_loadout_color_setting(color_setting)
		if(color_value && apply_loadout_color_channel(channel, color_value))
			changed = TRUE
	if(duchy_color_sources.len)
		loadout_duchy_color_sources = duchy_color_sources
		GLOB.loadout_lordcolor |= WEAKREF(src)
		if(apply_loadout_duchy_colors(GLOB.lordprimary, GLOB.lordsecondary, FALSE))
			changed = TRUE
	if(changed)
		refresh_loadout_colors()
	return changed

/datum/loadout_item/proc/can_color_loadout_item()
	var/static/list/allowed_types = list(
		/obj/item/clothing,
		/obj/item/storage,
		/obj/item/bedroll,
		/obj/item/flowercrown,
		/obj/item/legwears,
		/obj/item/undies,
		/obj/item/reagent_containers/glass/bottle/clayvase,
		/obj/item/reagent_containers/glass/bottle/clayfancyvase,
		/obj/item/reagent_containers/glass/cup/claycup,
		/obj/item/reagent_containers/glass/bottle/claybottle,
		/obj/item/roguestatue/clay,
		/obj/item/roguestatue/glass,
		"/obj/item/reagent_containers/glass/bottle/blown",
		"/obj/item/reagent_containers/glass/bottle/alchemical/blown",
	)
	for(var/allowed_type in allowed_types)
		var/allowed_path = allowed_type
		if(istext(allowed_path))
			allowed_path = text2path(allowed_path)
		if(allowed_path && ispath(path, allowed_path))
			return TRUE
	return FALSE

/datum/loadout_item/proc/get_loadout_color_channels()
	var/list/channels = list()
	if(!can_color_loadout_item())
		return channels
	channels["primary"] = "Основной цвет"
	var/obj/item/item_type = path
	if(item_type::detail_tag)
		channels["detail"] = "Дополнительный цвет"
	if(item_type::altdetail_tag)
		channels["altdetail"] = "Третий цвет"
	return channels

/datum/loadout_item/proc/can_color_loadout_channel(channel)
	var/list/channels = get_loadout_color_channels()
	return !!channels[channel]

/datum/preferences
	var/current_loadout_category = "Всё"

// Обрабатывает вещи в списке лодаута игрока и удаляет те, название которых было изменено или они были удалены.
// Иначе лодаут будет ломаться. Мб это как то адекватнее можно починить, но я хз.
/datum/preferences/proc/clean_loadout(mob/user)
	var/list/valid_items = list()
	var/has_invalid_items = FALSE

	for(var/item_name in gear_list)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		if(!item)
			has_invalid_items = TRUE
			continue

		if(item.get_loadout_lock_reason(user))
			has_invalid_items = TRUE
			continue

		valid_items[item_name] = gear_list[item_name]

	if(has_invalid_items)
		gear_list = valid_items
		to_chat(user, "Твой лодаут был очищен из-за изменений в предметах.")

/// Обрабатывает размер лодаута и сбрасывает его, если превышает лимит
/datum/preferences/proc/handle_loadout_size(mob/user)
	if(gear_list.len <= get_loadout_size(user))
		return
	gear_list = list()
	to_chat(user, "Размер твоего лодаута был изменён и его пришлось сбросить!")

/// Возвращает размер лодаута для указанного ника игрока
/datum/preferences/proc/get_loadout_size(mob/user)
	var/loadout_size = 3
	var/modifiers = 0

	var/plevel = check_patreon_lvl(user.ckey)

	if(plevel == 1)
		modifiers = 4
	if(plevel == 2)
		modifiers = 8
	if(plevel == 3)
		modifiers = 14
	if(plevel == 4)
		modifiers = 18
	if(plevel == 5)
		modifiers = 23

	return modifiers ? max(loadout_size + modifiers, 1) : loadout_size

/// Добавляет предмет лодаута
/datum/preferences/proc/add_loadout_item(item_name)
	if(!(item_name in gear_list))
		gear_list[item_name] = list()

/// Убирает предмет лодаута
/datum/preferences/proc/remove_loadout_item(item_name)
	gear_list -= item_name

/datum/preferences/proc/get_loadout_item_color(item_name, channel = "primary")
	if(!(item_name in gear_list))
		return
	var/list/meta = gear_list[item_name]
	if(!islist(meta))
		return
	var/meta_key
	switch(channel)
		if("primary")
			meta_key = "color"
		if("detail")
			meta_key = "detail_color"
		if("altdetail")
			meta_key = "altdetail_color"
		else
			return
	return sanitize_loadout_color_setting(meta[meta_key])

/datum/preferences/proc/set_loadout_item_color(item_name, channel, color)
	if(!(item_name in gear_list))
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
	if(!item || !item.can_color_loadout_channel(channel))
		return FALSE
	var/sanitized_color = sanitize_loadout_color_setting(color)
	if(!sanitized_color)
		return FALSE
	var/list/meta = gear_list[item_name]
	if(!islist(meta))
		meta = list()
	switch(channel)
		if("primary")
			meta["color"] = sanitized_color
		if("detail")
			meta["detail_color"] = sanitized_color
		if("altdetail")
			meta["altdetail_color"] = sanitized_color
	gear_list[item_name] = meta
	return TRUE

/datum/preferences/proc/clear_loadout_item_colors(item_name)
	if(!(item_name in gear_list))
		return FALSE
	var/list/meta = gear_list[item_name]
	if(!islist(meta))
		return FALSE
	meta -= "color"
	meta -= "detail_color"
	meta -= "altdetail_color"
	gear_list[item_name] = meta
	return TRUE

/datum/preferences/proc/pick_loadout_item_color(mob/user, item_name, channel)
	if(!(item_name in gear_list))
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
	if(!item)
		return FALSE
	var/list/channels = item.get_loadout_color_channels()
	var/channel_name = channels[channel]
	if(!channel_name)
		return FALSE
	var/current_color = resolve_loadout_color_setting(get_loadout_item_color(item_name, channel))
	var/pick_method = alert(user, "Выберите способ выбора цвета.", channel_name, "Палитра", "Готовые цвета", "Отмена")
	var/new_color
	switch(pick_method)
		if("Палитра")
			new_color = color_pick_sanitized(user, "Выберите [lowertext(channel_name)].", "Цвет предмета", current_color ? current_color : "#FFFFFF")
		if("Готовые цвета")
			var/list/colors_to_pick = list(
				"Primary Keep Color" = LOADOUT_COLOR_DUCHY_PRIMARY,
				"Secondary Keep Color" = LOADOUT_COLOR_DUCHY_SECONDARY,
			)
			colors_to_pick += COLOR_MAP
			colors_to_pick += GLOB.pridelist
			var/picked_color = input(user, "Выберите цвет.", channel_name, null) as null|anything in colors_to_pick
			if(!picked_color)
				return FALSE
			new_color = colors_to_pick[picked_color]
		else
			return FALSE
	if(isnull(new_color))
		return FALSE
	return set_loadout_item_color(item_name, channel, new_color)

/client/verb/boosty()
	set name = "boosty"
	set desc = ""
	set category = "OOC"
	var/boostyurl = CONFIG_GET(string/boostyurl)
	if(boostyurl)
		if(alert("This will open the boosty in your browser. Are you sure?",, "Yes", "No") != "Yes")
			return
		src << link(boostyurl)
	else
		to_chat(src, span_danger("The forum URL is not set in the server configuration."))
	return

/datum/config_entry/string/boostyurl
	config_entry_value = ""

/datum/loadout_panel
	/// Mob that the examine panel belongs to.
	var/mob/living/carbon/human/holder

/datum/loadout_panel/New(mob/holder_mob)
	if(holder_mob)
		holder = holder_mob

/datum/loadout_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LoadoutPanel")
		ui.open()

/datum/loadout_panel/ui_static_data(mob/user)
	var/list/data = list()
	var/list/categories = list()
	var/datum/preferences/user_prefs = user.client.prefs

	var/donat_level = check_patreon_lvl(user.ckey)
	var/triumph_discount = get_donator_triumph_discount(user.ckey)
	var/is_donator_status = (triumph_discount > 0) || is_donator(user.ckey)

	for(var/cat_name in GLOB.loadout_items_by_category)
		var/list/items_in_cat = GLOB.loadout_items_by_category[cat_name]
		if(!categories[cat_name])
			categories[cat_name] = list()

		for(var/datum/loadout_item/item in items_in_cat)
			if(!item?.path)
				continue

			if(item.ckeywhitelist && !item.donator_ckey_check(user.ckey))
				continue

			var/atom/movable/icon_source_path = item.path
			var/lock_reason = item.get_loadout_lock_reason(user)

			var/icon = icon_source_path::icon
			var/icon_state = icon_source_path::icon_state

			var/id = sanitize_css_class_name("[icon_source_path]")

			var/icon_class_name = "loadout_icons128x128 [id]"

			categories[cat_name][item.name] += list(
				name = item.name,
				path = item.path,
				icon = icon,
				icon_state = icon_state,
				icon_class_name = icon_class_name,
				isDonatorItem = item.donatitem,
				unavailable = !isnull(lock_reason),
				unavailableReason = lock_reason,
				requiredTier = item.donat_tier,
				triumphCost = item.triumph_cost,
			)

	data["categories"] = categories
	data["isDonator"] = is_donator_status
	data["donatTier"] = donat_level
	data["triumphDiscount"] = triumph_discount
	data["maxLoadoutSlots"] = user_prefs.get_loadout_size(user)

	return data

/datum/loadout_panel/ui_data(mob/user)
	var/list/data = list()
	var/datum/preferences/user_prefs = user.client.prefs
	var/list/selected_loadout_items = list()
	var/list/selected_loadout_details = list()
	var/total_triumph_cost = 0
	for(var/item_name in user_prefs.gear_list)
		selected_loadout_items += item_name
		var/datum/loadout_item/selected_item = GLOB.loadout_items_by_name[item_name]
		var/list/color_channels = list()
		var/list/item_colors = list()
		var/list/item_color_labels = list()
		if(selected_item)
			color_channels = selected_item.get_loadout_color_channels()
			if(selected_item.triumph_cost)
				total_triumph_cost += selected_item.triumph_cost
			for(var/channel in color_channels)
				var/color_setting = user_prefs.get_loadout_item_color(item_name, channel)
				if(!color_setting)
					continue
				var/color_value = resolve_loadout_color_setting(color_setting)
				if(color_value)
					item_colors[channel] = color_value
				var/color_label = get_loadout_color_setting_label(color_setting)
				if(color_label)
					item_color_labels[channel] = color_label
		selected_loadout_details += list(list(
			"name" = item_name,
			"colorChannels" = color_channels,
			"colors" = item_colors,
			"colorLabels" = item_color_labels,
		))
	var/triumph_discount = get_donator_triumph_discount(user.ckey)
	var/triumph_discount_used = min(triumph_discount, total_triumph_cost)
	data["selectedLoadoutItems"] = selected_loadout_items
	data["selectedLoadoutDetails"] = selected_loadout_details
	data["triumphDiscountUsed"] = triumph_discount_used
	data["curLoadoutSlots"] = selected_loadout_items.len
	return data

/datum/loadout_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	var/mob/user = ui.user
	var/datum/preferences/user_prefs = user.client.prefs

	switch(action)
		if("add")
			var/item_name = params["item"]
			var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]

			if(!item)
				return TRUE

			if(user_prefs.gear_list.len >= user_prefs.get_loadout_size(user))
				to_chat(user, "Лимит исчерпан!")
				return TRUE

			var/lock_reason = item.get_loadout_lock_reason(user)
			if(lock_reason)
				to_chat(user, lock_reason)
				return TRUE

			user_prefs.add_loadout_item(item_name)
			return TRUE

		if("remove")
			user_prefs.remove_loadout_item(params["item"])
			return TRUE

		if("clear")
			user_prefs.gear_list = list()
			to_chat(user, "Лодаут очищен!")
			return TRUE

		if("pick_color")
			user_prefs.pick_loadout_item_color(user, params["item"], params["channel"])
			return TRUE

		if("clear_colors")
			user_prefs.clear_loadout_item_colors(params["item"])
			return TRUE

		if("boosty")
			user << link(CONFIG_GET(string/boostyurl))
			return TRUE

/datum/loadout_panel/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/loadout_icons)
	)

/datum/preferences/proc/get_max_save_slots(plevel)
	var/base_slots = 20
	var/modifiers = 0

	switch(plevel)
		if(1)
			modifiers = 2
		if(2)
			modifiers = 3
		if(3)
			modifiers = 4
		if(4)
			modifiers = 5
		if(5)
			modifiers = 6

	return modifiers ? max(base_slots * modifiers, base_slots) : base_slots
