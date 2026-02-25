/datum/map_template/automap_template
	name = "Automap Template"
	keep_cached_map = FALSE
	/// The map for which we load on
	var/required_map
	/// Touches builtin map. Clears the area manually instead of blacklisting
	var/affects_builtin_map
	/// Our load turf
	var/turf/load_turf

/datum/map_template/automap_template/New(path, rename, incoming_required_map, incoming_load_turf)
	. = ..(path, rename, cache = TRUE)

	if(!incoming_required_map || !incoming_load_turf)
		return

	required_map = incoming_required_map
	load_turf = incoming_load_turf
	affects_builtin_map = incoming_required_map == AUTOMAPPER_MAP_BUILTIN

/datum/map_template
	var/depth = 1

/datum/map_template/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width  = (bounds[MAP_MAXX] - bounds[MAP_MINX] + 1)
		height = (bounds[MAP_MAXY] - bounds[MAP_MINY] + 1)
		depth  = (bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1)

		if(cache)
			cached_map = parsed
	return bounds

/datum/map_template/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner

	var/x2 = placement.x + width  - 1
	var/y2 = placement.y + height - 1
	var/z2 = placement.z + depth  - 1

	return block(placement, locate(x2, y2, z2))

/datum/map_template/proc/nuke_placement_area(turf/T, centered = FALSE, turf/empty_type = /turf/open/transparent/openspace)
	var/list/turfs = get_affected_turfs(T, centered)
	for(var/turf/iter as anything in turfs)
		for(var/atom/movable/A as anything in iter.contents)
			qdel(A, force = TRUE)

		if(iter.type == empty_type)
			continue

		var/bt = initial(empty_type.baseturfs)
		if(islist(bt))
			bt = bt[1]

		iter.ChangeTurf(empty_type, bt, CHANGETURF_FORCEOP)

/datum/map_template/proc/get_footprint_turfs(turf/load_turf, centered = FALSE)
	// Требует cache = TRUE при new(...) чтобы cached_map был
	if(!cached_map)
		return list()

	var/turf/placement = load_turf
	if(centered)
		var/turf/corner = locate(placement.x - round(width/2), placement.y - round(height/2), placement.z)
		if(corner)
			placement = corner

	var/list/out = list()

	// base в world-координатах
	var/base_x = placement.x
	var/base_y = placement.y
	var/base_z = placement.z

	// x/y внутри шаблона: 0..width-1, 0..height-1
	for(var/x = 0 to width - 1)
		for(var/y = 0 to height - 1)
			// пропускаем noop-клетки (не трогаем то, что под ними)
			if(SSautomapper.has_turf_noop(src, x, y)) // если proc у SS
				continue

			var/turf/T = locate(base_x + x, base_y + y, base_z)
			if(T)
				out += T

	return out
