/obj/item/clothing/neck/roguetown/psicross/hag/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/alch/hag_moss))
		if(!tonic_spent)
			return FALSE
		if(!do_after(user, 2 SECONDS, target = I))
			return FALSE
		playsound(src, 'sound/gore/flesh_eat_01.ogg', 70, TRUE)
		to_chat(user, span_warning("As you touch [src.name] with [I.name], it's absorbs the moss and fills with something..."))
		tonic_spent = FALSE
		qdel(I)
		return TRUE
	..()
