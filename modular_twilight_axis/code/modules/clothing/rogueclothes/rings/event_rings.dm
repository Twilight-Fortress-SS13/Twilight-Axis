/// Modular event ring: admins can edit `stat_mods` and `traits` via VV.
// Creator: @mykokonf. Hope you enjoy the new item, and feel free to customize it for your events!
// - `stat_mods` is a list of lists: each entry should be a two-item list
//   where [1] = STATKEY_* constant, [2] = integer amount to apply while worn.
//   Example: stat_mods = list(list(STATKEY_STR, 2), list(STATKEY_SPD, 1))
// - `traits` is a simple list of trait constants to add while worn.
// - 'equip_message' - Customizable message shown when ring is equipped;
// These are safe to edit through VV for event customization.

/obj/item/clothing/ring/event_ring
	name = "event ring"
	desc = "A customizable ring for events; editable via VV (stat_mods, traits)."
	icon_state = "g_newring_emerald"
	sellprice = 0
	// Example defaults: applies +1 to all primary stats; change the second value to adjust
	var/list/stat_mods = list(
		list(STATKEY_STR, 1),
		list(STATKEY_WIL, 1),
		list(STATKEY_CON, 1),
		list(STATKEY_PER, 1),
		list(STATKEY_INT, 1),
		list(STATKEY_LCK, 1),
		list(STATKEY_SPD, 1)
	)
	// Example default traits: admins can edit/remove these via VV
	var/list/traits = list(TRAIT_NOBLE)
	// Customizable message shown when ring is equipped; editable via VV
	var/equip_message = "You feel the ring's power settle upon you."
	var/active_item = FALSE

// Procs are defined as top-level paths so they run in the correct scope

/obj/item/clothing/ring/event_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		if(stat_mods && stat_mods.len)
			for(var/mod in stat_mods)
				if(islist(mod) && length(mod) >= 2)
					user.change_stat(mod[1], mod[2])
		if(traits && traits.len)
			for(var/t in traits)
				ADD_TRAIT(user, t, TRAIT_GENERIC)
		if(equip_message)
			to_chat(user, span_green(equip_message))
	return


/obj/item/clothing/ring/event_ring/dropped(mob/living/user)
	..()
	if(active_item)
		if(stat_mods && stat_mods.len)
			for(var/mod in stat_mods)
				if(islist(mod) && length(mod) >= 2)
					user.change_stat(mod[1], -mod[2])
		if(traits && traits.len)
			for(var/t in traits)
				REMOVE_TRAIT(user, t, TRAIT_GENERIC)
		active_item = FALSE
	return


/obj/item/clothing/ring/event_ring/proc/clear_stat_mods()
	stat_mods = list()


/obj/item/clothing/ring/event_ring/proc/clear_traits()
	traits = list()

///
