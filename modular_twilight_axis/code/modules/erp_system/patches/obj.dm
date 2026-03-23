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
