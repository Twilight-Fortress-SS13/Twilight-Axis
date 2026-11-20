/mob/living
	var/list/active_hotbars

/mob/living/Destroy()
	QDEL_LIST(active_hotbars)
	return ..()

/mob/living/proc/is_spell_scroll_action(datum/action/A)
	if(!istype(A))
		return FALSE
	if(istype(A, /datum/action/cooldown/spell) || istype(A, /datum/action/spell_action))
		return TRUE
	return TRUE

/mob/living/proc/get_spell_scroll_count()
	if(!LAZYLEN(actions))
		return 0
	var/count = 0
	for(var/datum/action/A as anything in actions)
		if(is_spell_scroll_action(A))
			count++
	return count

/mob/living/proc/get_required_hotbar_count()
	var/total_scrolls = length(actions)
	var/spell_scrolls = get_spell_scroll_count()
	if(spell_scrolls > total_scrolls)
		total_scrolls = spell_scrolls
	if(total_scrolls <= 0)
		return 1
	var/needed = round((total_scrolls + HOTBAR_SLOTS_PER_ROW - 1) / HOTBAR_SLOTS_PER_ROW)
	return clamp(needed, 1, MAX_DYNAMIC_HOTBARS)

/mob/living/proc/sync_dynamic_hotbars()
	if(!islist(active_hotbars))
		active_hotbars = list()

	var/required = get_required_hotbar_count()
	var/current_len = length(active_hotbars)

	if(current_len < required)
		for(var/bar_i in (current_len + 1) to required)
			active_hotbars += new /datum/hotbar(bar_i)
	else if(current_len > required)
		for(var/bar_i in current_len to (required + 1) step -1)
			var/datum/hotbar/removed_bar = active_hotbars[bar_i]
			active_hotbars.Cut(bar_i, bar_i + 1)
			if(removed_bar)
				qdel(removed_bar)

	return length(active_hotbars)

/mob/living/proc/get_active_hotbar_count()
	if(!LAZYLEN(active_hotbars))
		return sync_dynamic_hotbars()
	return length(active_hotbars)

/mob/living/proc/get_hotbar(bar_num)
	sync_dynamic_hotbars()
	if(bar_num < 1 || bar_num > length(active_hotbars))
		return null
	return active_hotbars[bar_num]

/mob/living/proc/can_use_hotbar_slot(bar_num, slot_num)
	if(slot_num < 1 || slot_num > HOTBAR_SLOTS_PER_ROW)
		return FALSE
	var/datum/hotbar/HB = get_hotbar(bar_num)
	if(!HB)
		return FALSE
	var/action_idx = HB.get_slot_action_index(slot_num)
	return (action_idx >= 1 && action_idx <= length(actions))

/mob/living/update_action_buttons(reload_screen)
	sync_dynamic_hotbars()
	return ..()
