/obj/effect/proc_holder/spell/invoked/watertrap
	name = "Water Trap"
	desc = "Causes a whirlpool with a strong current."
	cost = 6
	range = 7
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 30
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "nondetection"
	spell_tier = 3
	invocations = list("Submergi!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	ignore_los = FALSE


/obj/effect/watertrap
	name = "Reaver"
	desc = "A swirling wavepool churns violently."
	icon_state = "blueshatter2"
	anchored = TRUE
	density = FALSE
	var/list/turf_data = list()
	var/duration = 7 SECONDS
	var/radius = 1
	var/atom/movable/spawned_maneater

/obj/effect/proc_holder/spell/invoked/watertrap/cast(list/targets, mob/user)
	. = ..()

	if(!targets.len)
		return

	var/turf/T = get_turf(targets[1])

	if(T)
		new /obj/effect/watertrap(T)
	else
		return FALSE 

/obj/effect/watertrap/Destroy()

	if(spawned_maneater && !QDELETED(spawned_maneater))
		qdel(spawned_maneater)

	for(var/turf/T in turf_data)
		if(T)
			T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()


/obj/effect/watertrap/Initialize(mapload, turf/center)
	. = ..()
	var/turf/origin = center || get_turf(src)
	if(!origin)
		return

	src.forceMove(null) 
	var/list/affected = range(radius, origin)

	for(var/turf/T in affected)
		if(istype(T, /turf/closed) || istype(T, /turf/open/transparent/openspace)) 
			continue
		
		turf_data[T] = T.type
		var/dx = T.x - origin.x
		var/dy = T.y - origin.y
		var/new_type

		if(dx == 0 && dy == 0)
			new_type = /turf/open/water/ocean/deep
			spawned_maneater = new /obj/structure/flora/roguegrass/maneater/real(T) 

		else if(dx == 0) 
			new_type = (dy > 0) ? /turf/open/water/river/flow : /turf/open/water/river/flow/north

		else if(dy == 0) 
			new_type = (dx > 0) ? /turf/open/water/river/flow/west : /turf/open/water/river/flow/east

		else 
			if(dx < 0)
				new_type = (dy < 0) ? /turf/open/water/river/flow/east : /turf/open/water/river/flow
			else
				new_type = (dy < 0) ? /turf/open/water/river/flow/north : /turf/open/water/river/flow/west

		T.ChangeTurf(new_type, flags = CHANGETURF_IGNORE_AIR)

	QDEL_IN(src, duration)

/obj/structure/flora/roguegrass/maneater/real
