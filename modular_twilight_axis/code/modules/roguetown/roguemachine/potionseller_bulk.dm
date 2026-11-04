// TA: bulk-load (RMB) now collects containers from the machine's own tile
// and all 8 surrounding tiles, instead of only its tile + north + south.
/obj/structure/roguemachine/potionseller/attack_right(mob/user, list/modifiers)
	if(locked)
		to_chat(user, span_warning("The vendor is locked!"))
		return
	if(!ishuman(user))
		return
	if(!user.Adjacent(src))
		return
	var/count = 0
	for(var/turf/T in range(1, src))
		for(var/obj/item/I in T)
			if(bulk_insert(I, user))
				count++
	if(count > 0)
		say("Bulk loading complete. [count] container\s processed.")
		playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		attack_hand(user)
