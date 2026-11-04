/obj/effect/proc_holder/spell/invoked/ShroudTrap
	name = "Shroud Trap" 
	desc = "Causes an area to be covered in rogue shroud slowing down movement."
	cost = 3
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
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "ShroudTrap"
	spell_tier = 2
	invocations = list("Obumbrare!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	ignore_los = FALSE


/obj/effect/ShroudTrap
	name = "Rogue Shroud" 
	desc = "The ground is covered in a strange, shifting shroud." 
	anchored = TRUE
	density = FALSE
	var/list/turf_data = list()
	var/duration = 15 SECONDS
	var/radius = 2


/obj/effect/proc_holder/spell/invoked/ShroudTrap/cast(list/targets, mob/user)
	. = ..()

	if(!targets.len)
		return

	var/turf/T = get_turf(targets[1])

	if(T)
		new /obj/effect/ShroudTrap(T)
	else
		return FALSE

/obj/effect/ShroudTrap/Destroy()

	for(var/turf/T in turf_data)
		if(T)
			T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()


/obj/effect/ShroudTrap/Initialize(mapload, turf/center)
	. = ..()
	var/turf/origin = center || get_turf(src)
	if(!origin)
		return

	src.forceMove(null)
	var/list/affected = range(radius, origin)

	for(var/turf/T in affected)
		if(istype(T, /turf/closed) || istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open/floor/rogue/shroud))
			continue

		turf_data[T] = T.type

		var/new_type = /turf/open/floor/rogue/shroud

		T.ChangeTurf(new_type, flags = CHANGETURF_IGNORE_AIR)

	QDEL_IN(src, duration)
