/proc/init_modular_hotbar_keybindings()
	var/list/shifted_digits = list(
		"!" = "1",
		"@" = "2",
		"#" = "3",
		"$" = "4",
		"%" = "5",
		"^" = "6",
		"&" = "7",
		"*" = "8",
		"(" = "9",
		")" = "0"
	)
	for(var/sym in shifted_digits)
		GLOB._kbMap[sym] = shifted_digits[sym]

	for(var/KB in subtypesof(/datum/keybinding/living/hotbar_slot) - /datum/keybinding/living/hotbar_slot/dynamic)
		var/datum/keybinding/living/hotbar_slot/slot_type = KB
		var/kb_name = initial(slot_type.name)
		if(!kb_name)
			var/bar_idx = initial(slot_type.hotbar_index) || 1
			var/slot_idx = initial(slot_type.slot_index)
			if(slot_idx)
				kb_name = "hotbar_[bar_idx]_slot_[slot_idx]"
		if(kb_name && GLOB.keybindings_by_name[kb_name])
			continue
		var/datum/keybinding/living/hotbar_slot/instance = new slot_type
		if(!instance.name)
			qdel(instance)
			continue
		if(!GLOB.keybindings_by_name[instance.name])
			add_keybinding(instance)
		else
			qdel(instance)

	register_dynamic_hotbar_keybindings()

/datum/preferences
	var/datum/hotbar_edit_menu/hotbar_edit_menu
	var/list/hotbar_key_bindings = list()
	var/list/hotbar_keybindings_initialized = list()

/datum/preferences/Destroy()
	QDEL_NULL(hotbar_edit_menu)
	return ..()

/datum/preferences/verify_keybindings_valid()
	init_modular_hotbar_keybindings()
	return ..()

/datum/preferences/proc/capture_hotbar_keybindings_snapshot()
	init_modular_hotbar_keybindings()
	var/list/snapshot = list()
	if(!islist(hotbar_keybindings_initialized))
		hotbar_keybindings_initialized = list()

	for(var/kb_name in GLOB.keybindings_by_name)
		var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
		if(!istype(HB_kb))
			continue
		if(kb_name in hotbar_keybindings_initialized)
			snapshot[kb_name] = list()

	if(islist(key_bindings))
		for(var/key in key_bindings)
			if(!islist(key_bindings[key]))
				continue
			for(var/kb_name in key_bindings[key])
				var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
				if(!istype(HB_kb))
					continue
				if(!islist(snapshot[kb_name]))
					snapshot[kb_name] = list()
				if(!(key in snapshot[kb_name]))
					snapshot[kb_name] += key
				if(!(kb_name in hotbar_keybindings_initialized))
					hotbar_keybindings_initialized += kb_name

	return snapshot

/datum/preferences/proc/apply_hotbar_keybindings_snapshot(list/snapshot)
	init_modular_hotbar_keybindings()
	if(!islist(key_bindings))
		key_bindings = list()
	if(!islist(snapshot))
		return

	for(var/key in key_bindings.Copy())
		var/list/bound_names = key_bindings[key]
		if(!islist(key_bindings[key]))
			key_bindings -= key
			continue
		for(var/kb_name in bound_names.Copy())
			if(kb_name in snapshot)
				key_bindings[key] -= kb_name
		if(!length(key_bindings[key]))
			key_bindings -= key

	for(var/kb_name in snapshot)
		var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
		if(!istype(HB_kb))
			continue
		var/list/keys_for_slot = snapshot[kb_name]
		if(!islist(keys_for_slot))
			continue
		for(var/bound_key in keys_for_slot)
			if(!istext(bound_key) || !length(bound_key))
				continue
			LAZYINITLIST(key_bindings[bound_key])
			if(!(kb_name in key_bindings[bound_key]))
				key_bindings[bound_key] += kb_name
				key_bindings[bound_key] = sortList(key_bindings[bound_key])

/datum/preferences/proc/ensure_hotbar_keybindings_synced()
	init_modular_hotbar_keybindings()
	if(!islist(key_bindings))
		key_bindings = list()
	if(!islist(hotbar_key_bindings))
		hotbar_key_bindings = list()
	if(!islist(hotbar_keybindings_initialized))
		hotbar_keybindings_initialized = list()

	// Загрузить значения биндов, чтоб сохранялись между перезапусками
	if(length(hotbar_key_bindings))
		var/list/valid_saved_snapshot = list()
		for(var/kb_name in hotbar_key_bindings)
			var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
			if(!istype(HB_kb))
				continue
			var/list/saved_keys = hotbar_key_bindings[kb_name]
			valid_saved_snapshot[kb_name] = islist(saved_keys) ? saved_keys.Copy() : list()
			if(!(kb_name in hotbar_keybindings_initialized))
				hotbar_keybindings_initialized += kb_name
		if(length(valid_saved_snapshot))
			apply_hotbar_keybindings_snapshot(valid_saved_snapshot)

	var/list/bound_kb_names = list()
	for(var/key in key_bindings)
		if(!islist(key_bindings[key]))
			continue
		for(var/kb_name in key_bindings[key])
			bound_kb_names[kb_name] = TRUE
			if(!(kb_name in hotbar_keybindings_initialized))
				hotbar_keybindings_initialized += kb_name

	var/seeded_new_defaults = FALSE
	for(var/kb_name in GLOB.keybindings_by_name)
		var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
		if(!istype(HB_kb))
			continue

		if(bound_kb_names[kb_name] || (kb_name in hotbar_keybindings_initialized))
			continue
		hotbar_keybindings_initialized += kb_name
		seeded_new_defaults = TRUE
		if(!LAZYLEN(HB_kb.hotkey_keys))
			continue
		for(var/default_key in HB_kb.hotkey_keys)
			LAZYINITLIST(key_bindings[default_key])
			if(!(HB_kb.name in key_bindings[default_key]))
				key_bindings[default_key] += HB_kb.name
				key_bindings[default_key] = sortList(key_bindings[default_key])

	hotbar_key_bindings = capture_hotbar_keybindings_snapshot()
	return seeded_new_defaults

/datum/preferences/load_preferences()
	init_modular_hotbar_keybindings()
	. = ..()
	if(!.)
		return .

	if(path && fexists(path))
		var/savefile/S = new /savefile(path)
		if(S)
			S.cd = "/"
			S["hotbar_key_bindings"] >> hotbar_key_bindings
			S["hotbar_keybindings_initialized"] >> hotbar_keybindings_initialized
			hotbar_key_bindings = sanitize_islist(hotbar_key_bindings, list())
			hotbar_keybindings_initialized = sanitize_islist(hotbar_keybindings_initialized, list())

	var/seeded_defaults = ensure_hotbar_keybindings_synced()
	if(seeded_defaults)
		save_preferences()
	return .

/datum/preferences/save_preferences()
	init_modular_hotbar_keybindings()
	hotbar_key_bindings = capture_hotbar_keybindings_snapshot()
	. = ..()
	if(!. || !path)
		return .

	var/savefile/S = new /savefile(path)
	if(!S)
		return .
	S.cd = "/"
	WRITE_FILE(S["hotbar_key_bindings"], hotbar_key_bindings)
	WRITE_FILE(S["hotbar_keybindings_initialized"], hotbar_keybindings_initialized)
	return .

// Вынести бинды в отдельную меню на панели, чтоб не засорять Создание Персонажа
/datum/preferences/ui_data_keybinds(mob/user)
	init_modular_hotbar_keybindings()
	var/list/data = ..()
	if(!islist(data) || !islist(data["keybindings"]))
		return data

	var/list/filtered_keybindings = list()
	for(var/list/kb_entry as anything in data["keybindings"])
		if(!islist(kb_entry))
			continue
		var/kb_name = kb_entry["name"]
		var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
		if(istype(kb, /datum/keybinding/living/hotbar_slot))
			continue
		UNTYPED_LIST_ADD(filtered_keybindings, kb_entry)

	data["keybindings"] = filtered_keybindings
	return data

/datum/preferences/KeybindingSet(mob/user, kb_name, clear_key, old_key, new_key, alt_mod, ctrl_mod, shift_mod, numpad)
	init_modular_hotbar_keybindings()
	var/datum/keybinding/kb = kb_name ? GLOB.keybindings_by_name[kb_name] : null
	if(!istype(kb, /datum/keybinding/living/hotbar_slot))
		return ..()

	user << browse(null, "window=capturekeypress")
	if(!kb_name)
		return

	if(!islist(key_bindings))
		key_bindings = list()
	if(!islist(hotbar_keybindings_initialized))
		hotbar_keybindings_initialized = list()
	if(!(kb_name in hotbar_keybindings_initialized))
		hotbar_keybindings_initialized += kb_name

	if(clear_key)
		if(old_key && key_bindings[old_key])
			key_bindings[old_key] -= kb_name
			if(!length(key_bindings[old_key]))
				key_bindings -= old_key
	else
		new_key = uppertext(new_key)
		var/AltMod = alt_mod ? "Alt" : ""
		var/CtrlMod = ctrl_mod ? "Ctrl" : ""
		var/ShiftMod = shift_mod ? "Shift" : ""
		var/NPad = numpad ? "Numpad" : ""

		if(GLOB._kbMap[new_key])
			new_key = GLOB._kbMap[new_key]

		var/full_key
		switch(new_key)
			if("Alt")
				full_key = "[new_key][CtrlMod][ShiftMod]"
			if("Ctrl")
				full_key = "[AltMod][new_key][ShiftMod]"
			if("Shift")
				full_key = "[AltMod][CtrlMod][new_key]"
			else
				full_key = "[AltMod][CtrlMod][ShiftMod][NPad][new_key]"

		if(old_key && old_key != "Unbound" && key_bindings[old_key])
			key_bindings[old_key] -= kb_name
			if(!length(key_bindings[old_key]))
				key_bindings -= old_key

		LAZYINITLIST(key_bindings[full_key])
		if(!(kb_name in key_bindings[full_key]))
			key_bindings[full_key] += kb_name
			key_bindings[full_key] = sortList(key_bindings[full_key])

	hotbar_key_bindings = capture_hotbar_keybindings_snapshot()
	parent?.set_macros()
	parent?.update_movement_keys()
	save_preferences()

	if(isliving(user))
		var/mob/living/L = user
		L.sync_dynamic_hotbars()

	if(hotbar_edit_menu)
		SStgui.update_uis(hotbar_edit_menu)
	SStgui.try_update_ui(user, src)

/datum/preferences/proc/open_hotbar_edit(mob/user)
	if(!user)
		user = parent?.mob
	if(!user)
		return
	ensure_hotbar_keybindings_synced()
	if(!hotbar_edit_menu)
		hotbar_edit_menu = new(src)
	hotbar_edit_menu.ui_interact(user)

/datum/preferences/proc/reset_hotbar_keybindings(mob/user)
	init_modular_hotbar_keybindings()
	if(!islist(key_bindings))
		key_bindings = list()
	if(!islist(hotbar_keybindings_initialized))
		hotbar_keybindings_initialized = list()

	for(var/key in key_bindings.Copy())
		var/list/bound_names = key_bindings[key]
		if(!islist(key_bindings[key]))
			key_bindings -= key
			continue
		for(var/kb_name in bound_names.Copy())
			var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
			if(istype(kb, /datum/keybinding/living/hotbar_slot))
				key_bindings[key] -= kb_name
		if(!length(key_bindings[key]))
			key_bindings -= key

	for(var/kb_name in GLOB.keybindings_by_name)
		var/datum/keybinding/living/hotbar_slot/HB_kb = GLOB.keybindings_by_name[kb_name]
		if(!istype(HB_kb))
			continue
		if(!(kb_name in hotbar_keybindings_initialized))
			hotbar_keybindings_initialized += kb_name
		if(!LAZYLEN(HB_kb.hotkey_keys))
			continue
		for(var/default_key in HB_kb.hotkey_keys)
			LAZYINITLIST(key_bindings[default_key])
			if(!(HB_kb.name in key_bindings[default_key]))
				key_bindings[default_key] += HB_kb.name
				key_bindings[default_key] = sortList(key_bindings[default_key])

	hotbar_key_bindings = capture_hotbar_keybindings_snapshot()
	parent?.set_macros()
	parent?.update_movement_keys()
	save_preferences()

	if(isliving(user))
		var/mob/living/L = user
		L.sync_dynamic_hotbars()

/datum/preferences/ui_act_game_settings(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action == "open_hotbar_edit")
		open_hotbar_edit(ui.user)
		return TRUE
	return ..()

/datum/preferences/ui_act_keybinds(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action == "open_hotbar_edit")
		open_hotbar_edit(ui.user)
		return TRUE
	if(action == "keybindings_reset")
		var/list/preserved_hotbar_binds = capture_hotbar_keybindings_snapshot()
		. = ..()
		apply_hotbar_keybindings_snapshot(preserved_hotbar_binds)
		hotbar_key_bindings = capture_hotbar_keybindings_snapshot()
		save_preferences()
		return .
	return ..()

/client/verb/hotbar_edit()
	set name = "Hotbar Edit"
	set category = "Preferences.Options"
	set desc = "Configure keybindings for hotbar slots."
	if(prefs)
		prefs.open_hotbar_edit(usr)

/datum/hotbar_edit_menu
	var/datum/preferences/preferences

/datum/hotbar_edit_menu/New(datum/preferences/new_preferences)
	. = ..()
	preferences = new_preferences

/datum/hotbar_edit_menu/Destroy()
	if(preferences && preferences.hotbar_edit_menu == src)
		preferences.hotbar_edit_menu = null
	preferences = null
	return ..()

/datum/hotbar_edit_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/hotbar_edit_menu/ui_status(mob/user, datum/ui_state/state)
	if(!preferences || user?.client != preferences.parent)
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/hotbar_edit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HotbarEdit", "Hotbar edit")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/hotbar_edit_menu/ui_data(mob/user)
	init_modular_hotbar_keybindings()

	var/list/data = list(
		"max_keys_per_keybind" = MAX_KEYS_PER_KEYBIND,
		"hotbars" = list(),
		"keybindings" = list(),
	)

	if(!preferences)
		return data

	var/list/user_binds = list()
	if(islist(preferences.key_bindings))
		for(var/key in preferences.key_bindings)
			for(var/kb_name in preferences.key_bindings[key])
				user_binds[kb_name] += list(key)

	var/list/by_hotbar = list()
	for(var/kb_name in GLOB.keybindings_by_name)
		var/datum/keybinding/living/hotbar_slot/kb = GLOB.keybindings_by_name[kb_name]
		if(!istype(kb))
			continue
		var/bar_key = "[kb.hotbar_index]"
		if(!by_hotbar[bar_key])
			by_hotbar[bar_key] = list()
		by_hotbar[bar_key]["[kb.slot_index]"] = kb

	var/list/hotbars = list()
	var/list/flat_keybindings = list()

	for(var/bar_idx in 1 to MAX_DYNAMIC_HOTBARS)
		var/list/bar_slots = by_hotbar["[bar_idx]"]
		if(!islist(bar_slots) || !length(bar_slots))
			continue

		var/list/group_keybindings = list()
		for(var/slot_idx in 1 to HOTBAR_SLOTS_PER_ROW)
			var/datum/keybinding/living/hotbar_slot/kb = bar_slots["[slot_idx]"]
			if(!istype(kb))
				continue

			var/list/kb_payload = list(
				"full_name" = kb.full_name,
				"name" = kb.name,
				"description" = kb.description,
				"hotbar_index" = kb.hotbar_index,
				"slot_index" = kb.slot_index,
				"default_keys" = kb.hotkey_keys,
				"user_binds" = user_binds[kb.name],
			)
			UNTYPED_LIST_ADD(group_keybindings, kb_payload)
			UNTYPED_LIST_ADD(flat_keybindings, kb_payload)

		if(length(group_keybindings))
			UNTYPED_LIST_ADD(hotbars, list(
				"hotbar_index" = bar_idx,
				"title" = "Hotbar [bar_idx]",
				"keybindings" = group_keybindings,
			))

	data["hotbars"] = hotbars
	data["keybindings"] = flat_keybindings
	return data

/datum/hotbar_edit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!preferences)
		return FALSE

	var/mob/user = ui.user
	switch(action)
		if("keybindings_capture")
			var/datum/keybinding/living/hotbar_slot/kb = GLOB.keybindings_by_name[params["keybinding"]]
			if(!istype(kb))
				return TRUE
			var/old_key = params["old_key"]
			preferences.CaptureKeybinding(user, kb, old_key)
			return TRUE

		if("keybindings_set")
			preferences.KeybindingSet(
				user,
				params["keybinding"],
				text2num(params["clear_key"]),
				params["old_key"],
				params["key"],
				text2num(params["alt"]),
				text2num(params["ctrl"]),
				text2num(params["shift"]),
				text2num(params["numpad"])
			)
			return TRUE

		if("keybindings_reset")
			var/choice = tgalert(user, "Do you really want to reset your hotbar keybindings to default?", "Setup hotbar keybindings", "Do It", "Cancel")
			if(choice == "Cancel")
				return TRUE
			preferences.reset_hotbar_keybindings(user)
			SStgui.update_uis(src)
			return TRUE

/mob/living/proc/get_bound_keys_for_hotbar_slot(bar_num, slot_num)
	init_modular_hotbar_keybindings()
	var/kb_name = get_hotbar_slot_keybind_name(bar_num, slot_num)
	var/list/results = list()
	var/list/user_bindings = client?.prefs?.key_bindings
	if(islist(user_bindings))
		for(var/key in user_bindings)
			if(kb_name in user_bindings[key])
				results += key
		return results
	var/datum/keybinding/kb = GLOB.keybindings_by_name[kb_name]
	if(kb && LAZYLEN(kb.hotkey_keys))
		results += kb.hotkey_keys
	return results
