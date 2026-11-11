/datum/controller/global_vars/InitGlobalroguetraits()
	..()
	roguetraits[TRAIT_SQUIRE] = span_info("I am a squire in training.")

/datum/controller/global_vars/InitGlobaltraits_by_type()
	..()
	traits_by_type[/mob] += TRAIT_SQUIRE
