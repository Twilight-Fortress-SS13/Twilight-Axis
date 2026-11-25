GLOBAL_DATUM(ducal_court, /datum/ducal_court)

/proc/get_ducal_court()
	if(!GLOB.ducal_court)
		GLOB.ducal_court = new /datum/ducal_court
	return GLOB.ducal_court

/obj/structure/roguethrone/attack_right(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(!(user in buckled_mobs))
		to_chat(user, span_warning("Чтобы управлять двором, нужно восседать на троне."))
		return
	var/datum/ducal_court/court = get_ducal_court()
	if(!court.get_throat())
		to_chat(user, span_warning("Древняя магия молчит."))
		return
	court.ui_interact(user)
	return TRUE
