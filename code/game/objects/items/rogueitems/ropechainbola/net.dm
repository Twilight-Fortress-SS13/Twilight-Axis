/obj/item/net
	name = "net"
	desc = "A weighed net used to entrap foes. Can be thrown to ensnare a target's legs and slow them down. Victims can struggle out of it and it will fall off after a short time."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_WRISTS
	force = 10
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	slipouttime = 5 SECONDS
	gender = NEUTER
	throw_speed = 2

	var/knockdown = 0


/obj/item/net/throw_at(atom/target, range, speed, mob/thrower, spin = 1, diagonals_first = 0, datum/callback/callback)
	if(!..())
		return
	playsound(src.loc, 'sound/blank.ogg', 75, TRUE)


/obj/item/net/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!iscarbon(hit_atom))
		return

	var/mob/living/carbon/target = hit_atom
	var/mob/living/user = istype(throwingdatum?.thrower, /mob/living) ? throwingdatum.thrower : null
	var/datum/intent/intenty = user?.used_intent

	if(user && intenty && target.checkdefense(intenty, user))
		return

	ensnare(target)

	addtimer(
		CALLBACK(src, PROC_REF(remove_effect)),
		30 SECONDS,
		TIMER_OVERRIDE | TIMER_UNIQUE
	)


/obj/item/net/proc/ensnare(mob/living/carbon/C)
	if(C.legcuffed || C.get_num_legs(FALSE) < 2)
		return

	visible_message(span_danger("\The [src] ensnares [C]!"))
	to_chat(C, span_danger("\The [src] entraps you!"))

	C.legcuffed = src
	forceMove(C)
	C.update_inv_legcuffed()
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	C.Knockdown(knockdown)
	C.apply_status_effect(/datum/status_effect/debuff/netted)
	playsound(src, 'sound/blank.ogg', 50, TRUE)


/obj/item/net/proc/remove_effect()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.legcuffed = null
			M.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, TRUE)
			M.update_inv_legcuffed()
			if(M.has_status_effect(/datum/status_effect/debuff/netted))
				M.remove_status_effect(/datum/status_effect/debuff/netted)

			var/turf/T = get_turf(M)
			forceMove(T ? T : M.loc)
