GLOBAL_LIST_EMPTY(sun_overlay_cache) //TA EDIT

/atom/movable/lighting_object
	name			= ""

	anchored		= TRUE

	//TA EDIT START
	icon				= LIGHTING_TENT_ICON
	icon_state		= "tent15"
	color			= null
	blend_mode		= BLEND_ADD
	//TA EDIT END
	plane			= LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer			= LIGHTING_LAYER
	invisibility		= INVISIBILITY_LIGHTING

	var/needs_update = FALSE
	var/turf/myturf
	//TA EDIT START
	var/mutable_appearance/lamp_overlay
	var/lamp_lit = FALSE
	var/list/sun_overlays
	var/sun_queued = FALSE
	//TA EDIT END

/atom/movable/lighting_object/Initialize(mapload)
	. = ..()
	verbs.Cut()
	//We avoid setting this in the base as if we do then the parent atom handling will add_atom_color it and that
	//is totally unsuitable for this object, as we are always changing it's colour manually
	color = "#ffffff" //TA EDIT

	myturf = loc
	if(myturf.lighting_object)
		qdel(myturf.lighting_object, force = TRUE)
	myturf.lighting_object = src
	myturf.luminosity = 0
	if(SSoutdoor_effects.initialized) //TA EDIT START
		refresh_sun() //TA EDIT END

	needs_update = TRUE
	SSlighting.objects_queue += src

/atom/movable/lighting_object/Destroy(force)
	if (force)
		SSlighting.objects_queue -= src
		if (loc != myturf)
			var/turf/oldturf = get_turf(myturf)
			var/turf/newturf = get_turf(loc)
			stack_trace("A lighting object was qdeleted with a different loc then it is suppose to have ([COORD(oldturf)] -> [COORD(newturf)])")
		if (isturf(myturf))
			myturf.lighting_object = null
			myturf.luminosity = 1
		myturf = null

		return ..()

	else
		return QDEL_HINT_LETMELIVE

/atom/movable/lighting_object/proc/update()
	if (loc != myturf)
		if (loc)
			var/turf/oldturf = get_turf(myturf)
			var/turf/newturf = get_turf(loc)
			warning("A lighting object realised its loc had changed in update() ([myturf]\[[myturf ? myturf.type : "null"]]([COORD(oldturf)]) -> [loc]\[[ loc ? loc.type : "null"]]([COORD(newturf)]))!")

		qdel(src, TRUE)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/list/corners = myturf.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners) //done this way for speed
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	//TA EDIT START
	var/mask = tent_mask()
	var/tent_color
	if(mask && ca.cache_r + ca.cache_g + ca.cache_b > LIGHTING_TENT_THRESHOLD)
		tent_color = rgb(ca.cache_r * 255, ca.cache_g * 255, ca.cache_b * 255)
	var/mutable_appearance/new_lamp_overlay
	if(myturf.opaque_atom_count > 0)
		var/flat_r = (cr.cache_r + cg.cache_r + cb.cache_r + ca.cache_r) / 4
		var/flat_g = (cr.cache_g + cg.cache_g + cb.cache_g + ca.cache_g) / 4
		var/flat_b = (cr.cache_b + cg.cache_b + cb.cache_b + ca.cache_b) / 4
		if(flat_r + flat_g + flat_b > LIGHTING_TENT_THRESHOLD)
			icon = LIGHTING_TENT_ICON
			icon_state = "flat"
			color = rgb(flat_r * 255, flat_g * 255, flat_b * 255)
		else
			icon = null
			color = null
		if(tent_color)
			new_lamp_overlay = mutable_appearance(LIGHTING_TENT_ICON, "tent[mask]")
			new_lamp_overlay.color = tent_color
			new_lamp_overlay.appearance_flags = RESET_COLOR
	else if(tent_color)
		icon = LIGHTING_TENT_ICON
		icon_state = "tent[mask]"
		color = tent_color
	else
		icon = null
		color = null
	if(lamp_overlay || new_lamp_overlay)
		lamp_overlay = new_lamp_overlay
		refresh_overlays()
	lamp_lit = set_luminosity
	sync_luminosity()
	//TA EDIT END

/atom/movable/lighting_object/proc/tent_mask() //TA EDIT START
	. = 0
	if(myturf.opaque_atom_count <= 0)
		. |= TENT_COVERS_SELF
	var/turf/neighbor = get_step(myturf, EAST)
	if(neighbor && neighbor.opaque_atom_count <= 0)
		. |= TENT_COVERS_EAST
	neighbor = get_step(myturf, NORTH)
	if(neighbor && neighbor.opaque_atom_count <= 0)
		. |= TENT_COVERS_NORTH
	neighbor = get_step(myturf, NORTHEAST)
	if(neighbor && neighbor.opaque_atom_count <= 0)
		. |= TENT_COVERS_NORTHEAST

/atom/movable/lighting_object/proc/sync_luminosity()
	luminosity = (lamp_lit || myturf.outdoor_effect?.sun_lit) ? 1 : 0

/atom/movable/lighting_object/proc/refresh_overlays()
	var/list/new_overlays = list()
	if(sun_overlays)
		new_overlays += sun_overlays
	if(lamp_overlay)
		new_overlays += lamp_overlay
	overlays = new_overlays

/atom/movable/lighting_object/proc/queue_sun()
	if(sun_queued)
		return
	sun_queued = TRUE
	GLOB.SUNLIGHT_QUEUE_CARRIER += src

/atom/movable/lighting_object/proc/refresh_sun()
	sun_queued = FALSE
	sync_luminosity()
	var/list/new_sun_overlays
	var/mutable_appearance/flat = sun_flat_overlay()
	if(flat)
		LAZYADD(new_sun_overlays, flat)
	var/mutable_appearance/tent = sun_tent_overlay()
	if(tent)
		LAZYADD(new_sun_overlays, tent)
	if(new_sun_overlays ~= sun_overlays)
		return
	sun_overlays = new_sun_overlays
	refresh_overlays()

/atom/movable/lighting_object/proc/sun_flat_overlay()
	var/datum/outdoor_effect/sky = myturf.outdoor_effect
	if(!sky || myturf.opaque_atom_count <= 0)
		return
	var/sun = 1
	if(sky.state == SKY_BLOCKED)
		sun = 0
		for(var/datum/lighting_corner/corner in myturf.corners)
			sun += corner.sunFalloff / 4
	return sun_overlay("flat", sun, sky.weatherproof ? 0 : 1)

/atom/movable/lighting_object/proc/sun_tent_overlay()
	var/mask = tent_mask()
	if(!mask)
		return
	var/outdoor_tiles = 0
	var/rainy_tiles = 0
	var/open_sky = FALSE
	for(var/turf/quarter in list(myturf, get_step(myturf, EAST), get_step(myturf, NORTH), get_step(myturf, NORTHEAST)))
		var/datum/outdoor_effect/sky = quarter.outdoor_effect
		if(!sky)
			continue
		outdoor_tiles++
		if(sky.state != SKY_BLOCKED)
			open_sky = TRUE
		if(!sky.weatherproof)
			rainy_tiles++
	if(!outdoor_tiles)
		return
	var/sun = 1
	if(!open_sky)
		var/datum/lighting_corner/northeast_corner = myturf.corners?[1]
		sun = northeast_corner ? northeast_corner.sunFalloff : 0
	return sun_overlay("tent[mask]", sun, rainy_tiles / 4)

/atom/movable/lighting_object/proc/sun_overlay(state, sun, rain)
	var/sun_level = round(sun * 255)
	var/rain_level = round(rain * 255)
	if(!sun_level && !rain_level)
		return
	var/key = "[state] [sun_level] [rain_level]"
	var/mutable_appearance/overlay = GLOB.sun_overlay_cache[key]
	if(overlay)
		return overlay
	overlay = new /mutable_appearance()
	overlay.icon = LIGHTING_TENT_ICON
	overlay.icon_state = state
	overlay.color = rgb(sun_level, rain_level, 0)
	overlay.blend_mode = BLEND_ADD
	overlay.plane = SUNLIGHTING_PLANE
	overlay.invisibility = INVISIBILITY_LIGHTING
	overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	GLOB.sun_overlay_cache[key] = overlay
	return overlay //TA EDIT END

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/lighting_object/ex_act(severity)
	return 0

/atom/movable/lighting_object/onTransitZ()
	return

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_object/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()
