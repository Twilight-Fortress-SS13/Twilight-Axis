// PLAGUE MASKS - Physician and Pestran helmets grant disease immunity

/obj/item/clothing/head/roguetown/helmet/heavy/pestran/equipped(mob/user, slot)
	..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
		to_chat(user, span_notice("The pestran helmet protects me from plague contact transmission."))

/obj/item/clothing/head/roguetown/helmet/heavy/pestran/dropped(mob/user, slot)
	..()
	if(slot == SLOT_HEAD)
		REMOVE_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
		to_chat(user, span_notice("I remove the pestran helmet's protection."))

/obj/item/clothing/mask/rogue/physician/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
		to_chat(user, span_notice("The physician's mask protects me from plague contact transmission."))

/obj/item/clothing/mask/rogue/physician/dropped(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
	to_chat(user, span_notice("I remove the physician's mask protection."))

/obj/item/clothing/mask/rogue/courtphysician/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
		to_chat(user, span_notice("The head physician's mask protects me from plague contact transmission."))

/obj/item/clothing/mask/rogue/courtphysician/dropped(mob/user)
	..()
	REMOVE_TRAIT(user, TRAIT_PLAGUE_MASK_WORN, "[type]")
	to_chat(user, span_notice("I remove the head physician's mask protection."))
