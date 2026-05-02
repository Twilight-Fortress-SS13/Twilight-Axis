#define BATTLE_WARD_RUNE_DURATION (1 MINUTES)
#define BATTLE_WARD_TELEGRAPH_TIME (3 SECONDS)

/datum/action/cooldown/spell/battle_ward/cast(atom/cast_on)

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/rune_path = get_rune_path()
	if(!rune_path)
		return FALSE

	// X pattern: center + 4 corners
	var/list/target_turfs = list()
	target_turfs += center
	target_turfs += get_step(center, NORTHWEST)
	target_turfs += get_step(center, NORTHEAST)
	target_turfs += get_step(center, SOUTHWEST)
	target_turfs += get_step(center, SOUTHEAST)

	// Show telegraph visuals before runes appear
	for(var/turf/T in target_turfs)
		new /obj/effect/temp_visual/trap_wall/battle_ward(T)

	playsound(center, 'sound/magic/whiteflame.ogg', 60, TRUE)
	H.visible_message(span_warning("[H] completes a complex inscription - runes begin to materialize!"), span_notice("I finish inscribing the [ward_mode] ward pattern."))

	addtimer(CALLBACK(src, PROC_REF(spawn_runes), target_turfs, rune_path, H.real_name, H.ckey || "no ckey", WEAKREF(H)), BATTLE_WARD_TELEGRAPH_TIME)
	return TRUE

/datum/action/cooldown/spell/battle_ward/spawn_runes(list/turfs, rune_path, caster_name, caster_ckey, caster_ref)
	for(var/turf/T in turfs)
		var/obj/structure/rune_ward/rune = new rune_path(T)
		rune.owner_name = caster_name
		rune.owner_ckey = caster_ckey
		rune.owner_ref = caster_ref
		rune.max_integrity = 50
		rune.obj_integrity = 50
		QDEL_IN(rune, BATTLE_WARD_RUNE_DURATION)

#undef BATTLE_WARD_RUNE_DURATION
#undef BATTLE_WARD_TELEGRAPH_TIME
