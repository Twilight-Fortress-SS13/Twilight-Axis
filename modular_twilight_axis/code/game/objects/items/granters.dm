/obj/item/book/granter/residentcard
	name = "Resident Manuscript"
	icon_state = "contractunsigned"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "This scroll grants the signer citizenship in the town of Rockhill and the right to choose an unoccupied house in the town."
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'

/obj/item/book/granter/residentcard/attack_self(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_RESIDENT))
		to_chat(user, span_danger("I already have citizenship!"))
		return FALSE
	if(icon_state == "contractsigned")
		to_chat(user, span_danger("This scroll already signed."))
		return FALSE
	else
		var/obj/item/writefeather
		for(var/obj/item/I in user.held_items)
			if(istype(I, /obj/item/natural/feather))
				writefeather = I
				break
		if(!writefeather)
			to_chat(user, span_warning("I need to hold a feather!"))
			return FALSE
		
		var/turf/T = get_step(user, user.dir)
		if(!(locate(/obj/structure/table) in T))
			to_chat(user, span_warning("I need to make this on a table."))
			return FALSE
		
		if(!do_after(user, 4 SECONDS, TRUE))
			to_chat(user, span_warning("My concentration breaks! I could not sign properly."))
			return FALSE

		to_chat(user, span_notice("I sign the scroll, receiving citizenship and the opportunity to live in a house in the city!"))
		playsound(user, 'sound/items/write.ogg', 50, TRUE, -2)
		ADD_TRAIT(user, TRAIT_RESIDENT, TRAIT_GENERIC)
		onlearned(user)

/obj/item/book/granter/residentcard/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "[user.real_name] - resident manuscript"
		desc = "A scroll confirming citizenship with the owner's signature."
		icon_state = "contractsigned"
	
/obj/item/book/granter/residentcardvirtue
	name = "Resident manuscript"
	icon_state = "scrollwrite"
	icon = 'icons/roguetown/items/misc.dmi'
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'

/obj/item/book/granter/residentcardvirtue/attack_self(mob/living/user)
		to_chat(user, span_info("A scroll confirming citizenship with the owner's signature."))

/obj/item/book/granter/residentcardvirtue/equipped(mob/living/user, slot)
	. = ..()
	if(icon_state == "contractsigned")
		return FALSE
	else
		name = "[user.real_name] - resident manuscript"
		desc = "A scroll confirming citizenship with the owner's signature."
		icon_state = "contractsigned"
		onlearned(user)
		return FALSE
