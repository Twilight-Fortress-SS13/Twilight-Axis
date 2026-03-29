/obj/structure/closet/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	if(user.mmb_intent)
		return ..()

	if(!dragged || !user)
		return

	var/is_head = istype(dragged, /obj/item/bodypart/head/dullahan)

	var/valid = FALSE

	if(dragged == user)
		valid = TRUE
	else if(is_head)
		valid = TRUE
	else if(dragged == src && user.loc == src)
		valid = TRUE

	if(!valid)
		return

	var/atom/initiator = is_head ? dragged : user
	return erp_try_start(initiator, src, user)

/obj/item/storage/belt/rogue/leather/aria/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.GetComponent(/datum/component/combo_core/wanderer))
		return

	if(!L.ckey || ckey(L.ckey) != "mrix")
		return

	if(slot != SLOT_BELT)
		return

	L.AddComponent(/datum/component/combo_core/wanderer, SB_COMBO_WINDOW, SB_MAX_HISTORY, SB_MAX_VISIBLE_NOTES)
