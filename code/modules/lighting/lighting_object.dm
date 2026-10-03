/atom/movable/lighting_object
	name			= ""

	anchored		= TRUE

	//TA EDIT START
	icon				= LIGHTING_TENT_ICON
	icon_state		= "tent"
	color			= null
	blend_mode		= BLEND_ADD
	//TA EDIT END
	plane			= LIGHTING_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer			= LIGHTING_LAYER
	invisibility		= INVISIBILITY_LIGHTING

	var/needs_update = FALSE
	var/turf/myturf
	var/lamp_lit = FALSE //TA EDIT

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
	var/datum/outdoor_effect/sky = myturf.outdoor_effect //TA EDIT START
	if(sky)
		overlays = sky.applied_overlays ? sky.applied_overlays : list()
		luminosity = sky.sun_lit //TA EDIT END

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
	if(ca.cache_r + ca.cache_g + ca.cache_b > 0.002)
		icon = LIGHTING_TENT_ICON
		color = rgb(ca.cache_r * 255, ca.cache_g * 255, ca.cache_b * 255)
	else
		icon = null
		color = null
	lamp_lit = set_luminosity
	var/datum/outdoor_effect/sky = myturf.outdoor_effect
	luminosity = lamp_lit || (sky && sky.sun_lit)
	//TA EDIT END

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/lighting_object/ex_act(severity)
	return 0

/atom/movable/lighting_object/onTransitZ()
	return

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_object/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()
