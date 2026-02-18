/obj/effect/proc_holder/spell/invoked/watertrap
	name = "Water Trap"
	desc = "Causes a whirlpool with a strong current."
	cost = 3
	range = 7
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
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
	var/delay = 1 SECONDS
	var/area_of_effect = 1


/obj/effect/watertrap
	name = "Reaver"
	desc = "A swirling wavepool churns violently."
	icon_state = "blueshatter2"
	anchored = TRUE
	density = FALSE
	var/list/turf_data = list()
	var/duration = 10 SECONDS
	var/radius = 1
	var/atom/movable/spawned_maneater
	var/is_cleaning_up = FALSE 

/obj/effect/proc_holder/spell/invoked/watertrap/cast(list/targets, mob/user)
	. = ..()

	if(!targets.len)
		return
	var/turf/source_turf = get_turf(user)
	var/turf/T = get_turf(targets[1])

	if(!T)
		return FALSE

	if(get_dist(T, source_turf) > range)
		to_chat(user, "<span class='warning'>Too far!</span>")
		return FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/trap(affected_turf)
		playsound(T, 'sound/magic/blade_burst.ogg', 80, TRUE, soundping = TRUE)

	sleep(delay)
	new /obj/effect/watertrap(T)

/obj/effect/watertrap/Destroy()
	if(is_cleaning_up)
		return ..()
	is_cleaning_up = TRUE

	if(spawned_maneater && !QDELETED(spawned_maneater))
		qdel(spawned_maneater)

	for(var/turf/T in turf_data)
		if(T && istype(T, /turf/open/water))
			T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	
	turf_data.Cut()
	return ..()


/obj/effect/watertrap/Initialize(mapload, turf/center)
	. = ..()
	var/turf/origin = center || get_turf(src)
	if(!origin)
		return INITIALIZE_HINT_QDEL

	
	for(var/obj/effect/watertrap/existing in origin)
		if(existing != src)
			return INITIALIZE_HINT_QDEL

	
	src.invisibility = INVISIBILITY_ABSTRACT 
	
	var/list/affected = range(radius, origin)

	for(var/turf/T in affected)
		
		if(istype(T, /turf/closed) || istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open/water))
			continue

		
		turf_data[T] = T.type
		
		var/dx = T.x - origin.x
		var/dy = T.y - origin.y
		var/new_type

		if(!dx && !dy)
			new_type = /turf/open/water/ocean/deep
			spawned_maneater = new /obj/structure/flora/roguegrass/maneater/real(T)
			T.ChangeTurf(new_type, flags = CHANGETURF_IGNORE_AIR)
			continue

		switch("[SIGN(dx)]:[SIGN(dy)]")
			if("0:1")  new_type = /turf/open/water/river/flow
			if("0:-1") new_type = /turf/open/water/river/flow/north
			if("1:0")  new_type = /turf/open/water/river/flow/west
			if("-1:0") new_type = /turf/open/water/river/flow/east
			if("1:1")  new_type = /turf/open/water/river/flow/west
			if("-1:1") new_type = /turf/open/water/river/flow
			if("1:-1") new_type = /turf/open/water/river/flow/north
			if("-1:-1") new_type = /turf/open/water/river/flow/east

		if(new_type)
			T.ChangeTurf(new_type, flags = CHANGETURF_IGNORE_AIR)

	
	QDEL_IN(src, duration)
