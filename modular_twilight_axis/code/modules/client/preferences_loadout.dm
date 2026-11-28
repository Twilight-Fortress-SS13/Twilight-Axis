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
	var/loadout_subscription_tier = 0

/datum/preferences/proc/sanitize_subscription_loadout(mob/user, notify = TRUE)
	if(!user?.ckey || !GLOB.PatreonsLoaded)
		return FALSE
	if(!islist(gear_list))
		gear_list = list()
	var/current_tier = clamp(round(check_patreon_lvl(user.ckey) || 0), 0, 5)
	var/previous_tier = sanitize_integer(loadout_subscription_tier, 0, 5, 0)
	loadout_subscription_tier = current_tier
	if(previous_tier > current_tier)
		gear_list = list()
		if(notify)
			to_chat(user, span_warning("Уровень подписки снизился. Лодаут полностью сброшен."))
		return TRUE
	if(!gear_list.len)
		return FALSE
	if(gear_list.len > get_loadout_size(user))
		gear_list = list()
		if(notify)
			to_chat(user, span_warning("Лодаут превышал доступный лимит и был сброшен."))
		return TRUE
	var/list/valid_items = list()
	var/removed_item = FALSE
	for(var/item_name in gear_list)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
		if(!item?.path || item.get_loadout_lock_reason(user))
			if(item && (item.donatitem || item.donat_tier > 0))
				gear_list = list()
				if(notify)
					to_chat(user, span_warning("Недоступный предмет подписки обнаружен. Лодаут полностью сброшен."))
				return TRUE
			removed_item = TRUE
			continue
		valid_items[item_name] = gear_list[item_name]
	if(!removed_item)
		return FALSE
	gear_list = valid_items
	if(notify)
		to_chat(user, span_warning("Недоступные предметы удалены из лодаута."))
	return TRUE

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

/datum/preferences/proc/get_loadout_item_color(item_name, channel = "primary", list/selection)
	if(!islist(selection))
		selection = gear_list
	if(!(item_name in selection))
		return
	var/list/meta = selection[item_name]
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

/datum/preferences/proc/set_loadout_item_color(item_name, channel, color, list/selection)
	if(!islist(selection))
		selection = gear_list
	if(!(item_name in selection))
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
	if(!item || !item.can_color_loadout_channel(channel))
		return FALSE
	var/sanitized_color = sanitize_loadout_color_setting(color)
	if(!sanitized_color)
		return FALSE
	var/list/meta = selection[item_name]
	if(!islist(meta))
		meta = list()
	switch(channel)
		if("primary")
			meta["color"] = sanitized_color
		if("detail")
			meta["detail_color"] = sanitized_color
		if("altdetail")
			meta["altdetail_color"] = sanitized_color
	selection[item_name] = meta
	return TRUE

/datum/preferences/proc/clear_loadout_item_colors(item_name, list/selection)
	if(!islist(selection))
		selection = gear_list
	if(!(item_name in selection))
		return FALSE
	var/list/meta = selection[item_name]
	if(!islist(meta))
		return FALSE
	meta -= "color"
	meta -= "detail_color"
	meta -= "altdetail_color"
	selection[item_name] = meta
	return TRUE

/datum/preferences/proc/pick_loadout_item_color(mob/user, item_name, channel, list/selection)
	if(!islist(selection))
		selection = gear_list
	if(!(item_name in selection))
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items_by_name[item_name]
	if(!item)
		return FALSE
	var/list/channels = item.get_loadout_color_channels()
	var/channel_name = channels[channel]
	if(!channel_name)
		return FALSE
	var/current_color = resolve_loadout_color_setting(get_loadout_item_color(item_name, channel, selection))
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
	return set_loadout_item_color(item_name, channel, new_color, selection)

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
