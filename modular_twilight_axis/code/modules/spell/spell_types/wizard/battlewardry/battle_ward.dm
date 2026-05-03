#define BATTLE_WARD_RUNE_DURATION (1 MINUTES)
#define BATTLE_WARD_TELEGRAPH_TIME (3 SECONDS)

/datum/action/cooldown/spell/battle_ward/spawn_runes(list/turfs, rune_path, caster_name, caster_ckey)
	for(var/turf/T in turfs)
		var/obj/structure/rune_ward/rune = new rune_path(T)
		rune.owner_name = caster_name
		rune.owner_ckey = caster_ckey
		rune.owner_ref = WEAKREF(owner)
		rune.max_integrity = 50
		rune.obj_integrity = 50
		QDEL_IN(rune, BATTLE_WARD_RUNE_DURATION)

#undef BATTLE_WARD_RUNE_DURATION
#undef BATTLE_WARD_TELEGRAPH_TIME
