/**
 * Get ranged target turf, but with direct targets as opposed to directions
 *
 * Starts at atom starting_atom and gets the exact angle between starting_atom and target
 * Moves from starting_atom with that angle, Range amount of times, until it stops, bound to map size
 * Arguments:
 * * starting_atom - Initial Firer / Position
 * * target - Target to aim towards
 * * range - Distance of returned target turf from starting_atom
 * * offset - Angle offset, 180 input would make the returned target turf be in the opposite direction
 */
/proc/get_ranged_target_turf_direct(atom/starting_atom, atom/target, range, offset)
	var/angle = ATAN2(target.x - starting_atom.x, target.y - starting_atom.y)
	if(offset)
		angle += offset
	var/turf/starting_turf = get_turf(starting_atom)
	for(var/i in 1 to range)
		var/turf/check = locate(starting_atom.x + cos(angle) * i, starting_atom.y + sin(angle) * i, starting_atom.z)
		if(!check)
			break
		starting_turf = check

	return starting_turf

/proc/is_type_on_turf(turf/location, type_to_find)
	if(!location)
		return
	var/found_type = locate(type_to_find) in location
	return found_type

///Returns the src and all recursive contents as a list.
/atom/proc/get_all_contents(ignore_flag_1)
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(checked_atom.flags_1 & ignore_flag_1)
			continue
		. += checked_atom.contents

///identical to get_all_contents but returns a list of atoms of the type passed in the argument.
/atom/proc/get_all_contents_type(type)
	var/list/processing_list = list(src)
	. = list()
	while(length(processing_list))
		var/atom/checked_atom = processing_list[1]
		processing_list.Cut(1, 2)
		processing_list += checked_atom.contents
		if(istype(checked_atom, type))
			. += checked_atom

///Like get_all_contents_type, but uses a typecache list as argument
/atom/proc/get_all_contents_ignoring(list/ignore_typecache)
	if(!length(ignore_typecache))
		return get_all_contents()
	var/list/processing = list(src)
	. = list()
	var/i = 0
	while(i < length(processing))
		var/atom/checked_atom = processing[++i]
		if(ignore_typecache[checked_atom.type])
			continue
		processing += checked_atom.contents
		. += checked_atom

///Returns the src and all recursive contents, but skipping going any deeper if an atom has a specific trait.
/atom/proc/get_all_contents_skipping_traits(skipped_trait)
	. = list(src)
	if(!skipped_trait)
		CRASH("get_all_contents_skipping_traits called without a skipped_trait")
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		if(HAS_TRAIT(checked_atom, skipped_trait))
			continue
		. += checked_atom.contents
