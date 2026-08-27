GLOBAL_DATUM_INIT(throne_seated_state, /datum/ui_state/throne_seated, new)

/datum/ui_state/throne_seated/can_use_topic(src_object, mob/user)
	if(user.stat != CONSCIOUS)
		return UI_CLOSE
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	if(!throne || !(user in throne.buckled_mobs))
		return UI_CLOSE
	return UI_INTERACTIVE
