/obj/machinery/light/rogue/proc/ta_burn_mobs_on_tile()
	if(!on || !crossfire || !isturf(loc))
		return
	for(var/mob/living/L in loc)
		if(L.is_jumping || (L.movement_type & (FLYING|FLOATING)))
			continue
		L.fire_act(1, 5)

/obj/machinery/light/rogue/process()
	. = ..()
	if(!crossfire)
		return
	. = null
	ta_burn_mobs_on_tile()
