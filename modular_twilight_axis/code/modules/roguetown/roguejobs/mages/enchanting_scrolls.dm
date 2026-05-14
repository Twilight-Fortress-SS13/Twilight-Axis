/obj/item/enchantmentscroll/attack_obj(obj/item/O, mob/living/user)
	if(O.unenchantable)
		to_chat(user, span_warning("You cannot enchant this item."))
		return FALSE
	var/datum/component/magic_item/M = O.GetComponent(/datum/component/magic_item, component)
	var/datum/component/cursed_item/C = O.GetComponent(/datum/component/cursed_item)
	if(C)
		to_chat(user, span_warning("This item is already filled with strange magic and cannot be enchanted."))
		return FALSE
	if(M)
		if(length(M.magical_effects) >= M.enchanting_capacity)
			to_chat(user, span_warning("This item is already enchanted to its full capacity."))
			return FALSE
	return TRUE
