/obj/item/manor_delivery
	name = "package"
	desc = "A package from a faraway land. Stamped with the Trade Company's seal, which implies it was properly processed and taxed upon arrival."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "deliverypackage3"
	item_state = "deliverypackage"
	var/manor_income
	var/obj/item/paper/manor_note

/obj/item/manor_delivery/attack_self(mob/user)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	if(manor_income)
		budget2change(manor_income, user, null, TRUE, FALSE)
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	user.visible_message(span_warning("[user] opens [src]."))
	if(manor_note)
		manor_note.forceMove(user.loc)
	qdel(src)
