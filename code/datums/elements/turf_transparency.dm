/datum/element/turf_z_transparency
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY

/datum/element/turf_z_transparency/Attach(datum/target, is_openspace = FALSE)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE

	var/turf/our_turf = target

	our_turf.layer = OPENSPACE_LAYER
	if(is_openspace)
		our_turf.plane = OPENSPACE_PLANE
	else
		our_turf.plane = TRANSPARENT_FLOOR_PLANE

	RegisterSignal(target, COMSIG_TURF_MULTIZ_DEL, PROC_REF(on_multiz_turf_del))
	RegisterSignal(target, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_turf_new))

	ADD_TRAIT(our_turf, TURF_Z_TRANSPARENT_TRAIT, type)
	update_multi_z(our_turf)

/datum/element/turf_z_transparency/Detach(datum/source)
	. = ..()
	var/turf/our_turf = source
	clear_visible_turfs(our_turf)
	UnregisterSignal(our_turf, list(COMSIG_TURF_MULTIZ_NEW, COMSIG_TURF_MULTIZ_DEL))
	REMOVE_TRAIT(our_turf, TURF_Z_TRANSPARENT_TRAIT, type)

/datum/element/turf_z_transparency/proc/get_below_turf(turf/our_turf)
	var/turf/below_turf = GET_TURF_BELOW(our_turf)
	if(!below_turf)
		below_turf = get_step_multiz(our_turf, DOWN)
	if(!below_turf && our_turf.z > 1)
		below_turf = locate(our_turf.x, our_turf.y, our_turf.z - 1)
	return below_turf

/datum/element/turf_z_transparency/proc/clear_visible_turfs(turf/our_turf)
	for(var/atom/visible_atom in our_turf.vis_contents)
		if(isturf(visible_atom))
			our_turf.vis_contents -= visible_atom
	our_turf.underlays -= get_baseturf_underlay(our_turf)

/datum/element/turf_z_transparency/proc/update_multi_z(turf/our_turf)
	clear_visible_turfs(our_turf)

	var/turf/below_turf = get_below_turf(our_turf)
	if(below_turf)
		our_turf.vis_contents += below_turf
	else
		our_turf.underlays += get_baseturf_underlay(our_turf)

	return TRUE

/datum/element/turf_z_transparency/proc/on_multiz_turf_del(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER

	if(dir != DOWN)
		return

	update_multi_z(our_turf)

/datum/element/turf_z_transparency/proc/on_multiz_turf_new(turf/our_turf, turf/below_turf, dir)
	SIGNAL_HANDLER

	if(dir != DOWN)
		return

	update_multi_z(our_turf)

/datum/element/turf_z_transparency/proc/get_baseturf_underlay(turf/our_turf)
	var/turf/path = SSmapping.level_trait(our_turf.z, ZTRAIT_BASETURF) || /turf/open/floor/rogue/naturalstone
	if(!ispath(path))
		path = text2path(path)
		if(!ispath(path))
			warning("Z-level [our_turf.z] has invalid baseturf '[SSmapping.level_trait(our_turf.z, ZTRAIT_BASETURF)]'")
			path = /turf/open/floor/rogue/naturalstone
	var/mutable_appearance/underlay_appearance = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER - 0.02, plane = PLANE_SPACE)
	underlay_appearance.appearance_flags = RESET_ALPHA | RESET_COLOR
	return underlay_appearance
