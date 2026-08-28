/turf
	var/dynamic_lighting = TRUE
	luminosity			= 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/atom/movable/lighting_object/lighting_object // Our lighting object.
	var/tmp/datum/lighting_corner/lighting_corner_NE
	var/tmp/datum/lighting_corner/lighting_corner_SE
	var/tmp/datum/lighting_corner/lighting_corner_SW
	var/tmp/datum/lighting_corner/lighting_corner_NW
	var/tmp/opaque_atom_count = 0 // Not to be confused with opacity, this is the number of opaque atoms on the tile.

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for(var/datum/lighting_corner/corner as anything in get_corners())
		corner.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		qdel(lighting_object, TRUE)

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(lighting_object)
		qdel(lighting_object,force=TRUE) //Shitty fix for lighting objects persisting after death

	new/atom/movable/lighting_object(null, src)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = get_static_lumcount(minlum, maxlum)
	totallums += get_dynamic_lumcount()

	return CLAMP01(totallums)

///Returns lumcount from the static (complex) lighting corners of this turf, ignoring overlay lights.
/turf/proc/get_static_lumcount(minlum = 0, maxlum = 1)
	var/totallums = 0
	var/datum/lighting_corner/L
	var/totalSunFalloff
	L = lighting_corner_NE
	if(L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SE
	if(L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SW
	if(L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_NW
	if(L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff

	if(outdoor_effect && outdoor_effect.state)
		totalSunFalloff = 4

	totallums += totalSunFalloff / 4

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)

	return totallums

///Fetches dynamic lumcount from overlay light sources potentially in view of this turf, via our spatial grid instead of a per-move view() scan.
/turf/proc/get_dynamic_lumcount()
	. = 0
	for (var/datum/component/overlay_lighting/light as anything in collect_dynamic_lightsources())
		. += light.lum_power

// You've heard of oranges_ear, prepare for oranges_eye
/// Uses the same optimization via hearers() that get_hearers_in_view does by allocating oranges ears to overlay lights
/// And collecting viewers rather than checking view() for each one of them
/turf/proc/collect_dynamic_lightsources()
	. = list()

	var/datum/spatial_grid_cell/grid_cell = SSspatial_grid.get_cell_of(src)
	if(!grid_cell)
		return

	var/list/light_sources = list()
	var/furthest_range = 0
	for (var/datum/component/overlay_lighting/light as anything in grid_cell.dynamic_light_sources)
		furthest_range = max(furthest_range, light.lumcount_range)
		if (isnull(light_sources[light.current_holder]))
			light_sources[light.current_holder] = light
		else if (islist(light_sources[light.current_holder]))
			light_sources[light.current_holder] |= light
		else
			light_sources[light.current_holder] = list(light_sources[light.current_holder], light)

	if(!length(light_sources))
		return

	var/list/assigned_oranges_ears = SSspatial_grid.assign_oranges_ears(light_sources)
	for(var/mob/oranges_ear/ear in hearers(furthest_range, src))
		for (var/atom/glowie as anything in ear.references)
			. += light_sources[glowie]

	for(var/mob/oranges_ear/remaining_ear as anything in assigned_oranges_ears)
		remaining_ear.unassign()

// Returns a boolean whether the turf is on soft lighting.
// Soft lighting being the threshold at which point the overlay considers
// itself as too dark to allow sight and see_in_dark becomes useful.
// So basically if this returns true the tile is unlit black.
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !lighting_object.luminosity

// Can't think of a good name, this proc will recalculate the opaque_atom_count variable.
/turf/proc/recalc_atom_opacity()
	opaque_atom_count = opacity // we count ourselves
	for (var/atom/A in src.contents) // Loop through every movable atom on our tile
		if (A.opacity)
			opaque_atom_count++

/turf/proc/change_area(area/old_area, area/new_area)
	GLOB.SUNLIGHT_QUEUE_WORK += src
	if(outdoor_effect)
		GLOB.SUNLIGHT_QUEUE_UPDATE += outdoor_effect
	if(SSlighting.initialized)
		if (new_area.dynamic_lighting != old_area.dynamic_lighting)
			if (new_area.dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/get_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return null
	if (!lighting_corners_initialised)
		generate_missing_corners()
	if (opacity || (opaque_atom_count > 0))
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return list(lighting_corner_NE, lighting_corner_SE, lighting_corner_SW, lighting_corner_NW)

///Returns a list of the (up to 4) already-existing corners of this turf, without generating missing ones or gating on opacity. Used by roguetown's sunlight system.
/turf/proc/get_corners_raw()
	. = list()
	if(lighting_corner_NE)
		. += lighting_corner_NE
	if(lighting_corner_SE)
		. += lighting_corner_SE
	if(lighting_corner_SW)
		. += lighting_corner_SW
	if(lighting_corner_NW)
		. += lighting_corner_NW

/turf/proc/generate_missing_corners()
	if (!IS_DYNAMIC_LIGHTING(src) && !light_sources)
		return
	if (!lighting_corner_NE)
		lighting_corner_NE = new /datum/lighting_corner(x, y, z)
	if (!lighting_corner_SE)
		lighting_corner_SE = new /datum/lighting_corner(x, y - 1, z)
	if (!lighting_corner_SW)
		lighting_corner_SW = new /datum/lighting_corner(x - 1, y - 1, z)
	if (!lighting_corner_NW)
		lighting_corner_NW = new /datum/lighting_corner(x - 1, y, z)
	lighting_corners_initialised = TRUE
