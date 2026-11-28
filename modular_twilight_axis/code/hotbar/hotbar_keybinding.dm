/datum/keybinding/living/hotbar_slot/dynamic
	hotbar_index = null
	slot_index = null
	name = null
	hotkey_keys = null
	classic_keys = null

/datum/keybinding/living/hotbar_slot/dynamic/New(_hotbar_index, _slot_index)
	if(!_hotbar_index || !_slot_index)
		return

	hotbar_index = _hotbar_index
	slot_index = _slot_index
	hotkey_keys = get_default_hotbar_keys()
	classic_keys = LAZYLEN(hotkey_keys) ? hotkey_keys.Copy() : list()
	..()

	hotkey_keys = get_default_hotbar_keys()
	classic_keys = LAZYLEN(hotkey_keys) ? hotkey_keys.Copy() : list()
	name = "hotbar_[hotbar_index]_slot_[slot_index]"
	full_name = "Hotbar [hotbar_index] - Slot [slot_index] (Action [action_taken])"
	description = "Select spell or action #[action_taken] (Hotbar [hotbar_index], Slot [slot_index])"

/datum/keybinding/living/hotbar_slot/dynamic/proc/get_default_hotbar_keys()
	if(slot_index < 1 || slot_index > 9)
		return list()

	switch(hotbar_index)
		if(2)
			return list("Ctrl[slot_index]")
		if(3)
			return list("AltCtrl[slot_index]")
		if(4)
			return list("AltCtrlShift[slot_index]")

	return list()

/proc/register_dynamic_hotbar_keybindings()
	for(var/bar_idx in 2 to MAX_DYNAMIC_HOTBARS)
		for(var/slot_idx in 1 to HOTBAR_SLOTS_PER_ROW)
			var/kb_name = "hotbar_[bar_idx]_slot_[slot_idx]"
			if(!GLOB.keybindings_by_name[kb_name])
				add_keybinding(new /datum/keybinding/living/hotbar_slot/dynamic(bar_idx, slot_idx))
