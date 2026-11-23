/datum/action/cooldown/spell/battle_ward/spawn_rune(turf/T, rune_path, caster_name, caster_ckey) // TA EDIT
	if(!T || T.density) // TA EDIT
		return
	var/obj/structure/rune_ward/rune = new rune_path(T) // TA EDIT
	rune.owner_name = caster_name // TA EDIT
	rune.owner_ckey = caster_ckey // TA EDIT
	rune.owner_ref = WEAKREF(owner) // TA EDIT
	rune.max_integrity = 50 // TA EDIT
	rune.obj_integrity = 50 // TA EDIT
	QDEL_IN(rune, 1 MINUTES) // TA EDIT
