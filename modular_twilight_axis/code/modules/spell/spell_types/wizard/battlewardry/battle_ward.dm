/datum/action/cooldown/spell/battle_ward/spawn_rune(turf/T, rune_path, caster_name, caster_ckey)
	if(!T || T.density)
		return
	var/obj/structure/rune_ward/rune = new rune_path(T)
	rune.owner_name = caster_name
	rune.owner_ckey = caster_ckey
	rune.owner_ref = WEAKREF(owner)
	rune.max_integrity = 50
	rune.obj_integrity = 50
	QDEL_IN(rune, 1 MINUTES)
