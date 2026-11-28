#ifndef HOTBAR_SLOTS_PER_ROW
#define HOTBAR_SLOTS_PER_ROW 12
#endif

#ifndef MAX_DYNAMIC_HOTBARS
#define MAX_DYNAMIC_HOTBARS 5 // Пока будет на 5, если что - поднять до 6
#endif

/datum/keybinding/living/hotbar_slot
	hotkey_keys = null
	classic_keys = null
	name = null
	full_name = null
	description = "Select the spell scroll or action in this hotbar slot."
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

	var/hotbar_index = 1

	var/slot_index = 1

	var/action_taken = 1

/datum/keybinding/living/hotbar_slot/New()
	action_taken = get_action_index()
	return ..()

/datum/keybinding/living/hotbar_slot/proc/get_action_index()
	if(hotbar_index > 0 && slot_index > 0)
		return ((hotbar_index - 1) * HOTBAR_SLOTS_PER_ROW) + slot_index
	return action_taken

/datum/keybinding/living/hotbar_slot/down(client/user)
	if(!user || !isliving(user.mob))
		return FALSE
	var/mob/living/C = user.mob
	var/datum/hud/H = C.hud_used
	if(H?.rearrange_mode)
		H.rearrange_hint(C)
		return TRUE


	C.sync_dynamic_hotbars()
	if(!C.can_use_hotbar_slot(hotbar_index, slot_index))
		return FALSE

	var/target_action_index = get_action_index()
	var/count = 0
	for(var/datum/action/A as anything in C.actions)
		count++
		if(count == target_action_index)
			A.Trigger()
			return TRUE
	return FALSE
