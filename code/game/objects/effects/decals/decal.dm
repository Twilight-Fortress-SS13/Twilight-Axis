/obj/effect/decal
	name = "decal"
	plane = FLOOR_PLANE
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/turf_loc_check = TRUE
	/// If set, SSseason swaps this decal's icon_state to this value in Winter and back the rest
	/// of the year. Decals are purely decorative with no per-instance state to lose, so - unlike
	/// dirt's ChangeTurf() subtypes - a direct icon_state swap is all that's needed here.
	var/winter_icon_state
	/// Cached the first time this decal registers: its actual pre-Winter icon_state.
	var/summer_icon_state
	/// Bake into the turf's overlays (/datum/element/decal) on Initialize and delete the object.
	/// Only for decals that gameplay never creates or removes.
	var/bake_to_loc = FALSE
	/// Set only when the bake actually happened - bake_to_loc alone doesn't mean it succeeded.
	var/baked_into_loc = FALSE

/obj/effect/decal/Initialize(mapload)
	. = ..()
	if(turf_loc_check && (!isturf(loc) || NeverShouldHaveComeHere(loc)))
		return INITIALIZE_HINT_QDEL
	if(bake_to_loc && bake_into_loc())
		return INITIALIZE_HINT_QDEL
	if(winter_icon_state)
		summer_icon_state = icon_state
		GLOB.seasonal_decal_objs += src

/// On success the caller must follow up with INITIALIZE_HINT_QDEL - the object is dead weight.
/obj/effect/decal/proc/bake_into_loc()
	var/turf/T = loc
	if(!isturf(T))
		return FALSE
	// Bake the state the season would show now and leave a swap record - overlays are
	// invisible to GLOB.seasonal_decal_objs.
	var/baked_state = icon_state
	if(winter_icon_state)
		summer_icon_state = icon_state
		if(SSseason.should_show_snow_icons() && T.is_seasonally_exposed())
			baked_state = winter_icon_state
	T.AddElement(/datum/element/decal, icon, baked_state, dir, FLOAT_PLANE, layer, alpha, color, pixel_x, pixel_y, pixel_w, pixel_z)
	if(winter_icon_state)
		GLOB.seasonal_baked_decals += list(list(
			"turf" = T,
			"icon" = icon,
			"summer" = summer_icon_state,
			"winter" = winter_icon_state,
			"state" = baked_state,
			"dir" = dir,
			"plane" = FLOAT_PLANE,
			"layer" = layer,
			"alpha" = alpha,
			"color" = color,
			"px" = pixel_x,
			"py" = pixel_y,
			"pw" = pixel_w,
			"pz" = pixel_z,
		))
	baked_into_loc = TRUE
	return TRUE

/obj/effect/decal/Destroy()
	if(baked_into_loc)
		// tgstation turf_decal pattern: skip the atom teardown (doMove/signal chains).
		loc = null
		return QDEL_HINT_QUEUE
	GLOB.seasonal_decal_objs -= src
	return ..()

/obj/effect/decal/proc/NeverShouldHaveComeHere(turf/T)
	return isclosedturf(T) || isgroundlessturf(T)

/obj/effect/decal/ex_act(severity, target)
	qdel(src)

/obj/effect/decal/fire_act(added, maxstacks)
	if(!(resistance_flags & FIRE_PROOF)) //non fire proof decal or being burned by lava
		qdel(src)

/obj/effect/decal/HandleTurfChange(turf/T)
	..()
	if(T == loc && NeverShouldHaveComeHere(T))
		qdel(src)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/turf_decal
	icon = 'icons/turf/decals.dmi'
	icon_state = "warningline"
	layer = TURF_DECAL_LAYER

/obj/effect/turf_decal/Initialize(mapload)
	..()
	return INITIALIZE_HINT_QDEL

/obj/effect/turf_decal/ComponentInitialize()
	. = ..()
	var/turf/T = loc
	if(!istype(T)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	T.AddComponent(/datum/component/decal, icon, icon_state, dir, CLEAN_GOD, color, null, null, alpha)
