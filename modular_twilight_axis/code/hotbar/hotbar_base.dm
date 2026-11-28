/datum/hotbar
	var/hotbar_number = 1

	var/max_slots = HOTBAR_SLOTS_PER_ROW

	var/list/slot_keybind_names = list()

/datum/hotbar/New(bar_num = 1)
	..()
	hotbar_number = bar_num
	slot_keybind_names = list()
	for(var/slot_i in 1 to max_slots)
		slot_keybind_names += get_hotbar_slot_keybind_name(hotbar_number, slot_i)

/proc/get_hotbar_slot_keybind_name(bar_num, slot_num)
	if(bar_num == 1 && slot_num >= 1 && slot_num <= 9)
		return "action_[slot_num]"
	return "hotbar_[bar_num]_slot_[slot_num]"

/datum/hotbar/proc/get_slot_action_index(slot_num)
	if(slot_num < 1 || slot_num > max_slots)
		return 0
	return ((hotbar_number - 1) * max_slots) + slot_num

/datum/hotbar/proc/get_action_in_slot(mob/living/owner, slot_num)
	if(!isliving(owner) || !LAZYLEN(owner.actions))
		return null
	var/target_idx = get_slot_action_index(slot_num)
	if(target_idx < 1 || target_idx > length(owner.actions))
		return null
	return owner.actions[target_idx]

/datum/hotbar/proc/trigger_slot(mob/living/owner, slot_num)
	if(!isliving(owner))
		return FALSE
	var/datum/hud/H = owner.hud_used
	if(H?.rearrange_mode)
		H.rearrange_hint(owner)
		return TRUE
	var/datum/action/A = get_action_in_slot(owner, slot_num)
	if(!A)
		return FALSE
	A.Trigger()
	return TRUE

/datum/hotbar/proc/get_filled_slot_count(mob/living/owner)
	if(!isliving(owner) || !LAZYLEN(owner.actions))
		return 0
	var/first_idx = get_slot_action_index(1)
	var/total_actions = length(owner.actions)
	if(total_actions < first_idx)
		return 0
	return min(max_slots, (total_actions - first_idx) + 1)

/datum/keybinding/living/hotbar_slot/hotbar
	hotkey_keys = null
	classic_keys = null
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB
	var/slots_in_row = HOTBAR_SLOTS_PER_ROW

/datum/keybinding/living/hotbar_slot/hotbar/bar_1
	hotkey_keys = null
	hotbar_index = 1

/datum/keybinding/living/hotbar_slot/hotbar/bar_1/slot_10
	hotkey_keys = list()
	name = "hotbar_1_slot_10"
	full_name = "Hotbar 1 - Action 10"
	description = "Select spell or action #10 on Hotbar 1."
	slot_index = 10

/datum/keybinding/living/hotbar_slot/hotbar/bar_1/slot_11
	hotkey_keys = list()
	name = "hotbar_1_slot_11"
	full_name = "Hotbar 1 - Action 11"
	description = "Select spell or action #11 on Hotbar 1."
	slot_index = 11

/datum/keybinding/living/hotbar_slot/hotbar/bar_1/slot_12
	hotkey_keys = list()
	name = "hotbar_1_slot_12"
	full_name = "Hotbar 1 - Action 12"
	description = "Select spell or action #12 on Hotbar 1."
	slot_index = 12

