/turf/open/transparent
	baseturfs = /turf/open/transparent/openspace
	intact = FALSE //this means wires go on top


/turf/open/transparent/Initialize() // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	plane = OPENSPACE_PLANE
	layer = OPENSPACE_LAYER

	return INITIALIZE_HINT_LATELOAD

/turf/open/transparent/LateInitialize()
	update_multiz(TRUE, TRUE)

/turf/open/transparent/Destroy()
	vis_contents.len = 0
	return ..()

/turf/open/transparent/update_multiz(prune_on_fail = FALSE, init = FALSE)
	. = ..()

	var/turf/T = GET_TURF_BELOW(src)
	if(!T)
		T = get_step_multiz(src, DOWN)
	if(!T && z > 1)
		T = locate(x, y, z - 1)

	if(!T)
		vis_contents.len = 0
		if(!show_bottom_level() && prune_on_fail)
			ChangeTurf(/turf/open/floor/rogue/naturalstone, flags = CHANGETURF_INHERIT_AIR)
		return FALSE

	if(init)
		vis_contents += T
	return TRUE

/turf/open/transparent/multiz_turf_del(turf/T, dir)
	if(dir != DOWN)
		return
	update_multiz()

/turf/open/transparent/multiz_turf_new(turf/T, dir)
	if(dir != DOWN)
		return
	update_multiz()

///Called when there is no real turf below this turf
/turf/open/transparent/proc/show_bottom_level()
	var/turf/path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/floor/rogue/naturalstone
	if(!ispath(path))
		path = text2path(path)
		if(!ispath(path))
			warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
			path = /turf/open/floor/rogue/naturalstone
	var/mutable_appearance/underlay_appearance = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER, plane = PLANE_SPACE)
	underlays += underlay_appearance
	return TRUE


/client/proc/debug_below_turf()
	set name = "Debug Below Turf"
	set category = "Debug"

	var/turf/T = get_turf(usr)
	if(!T)
		to_chat(usr, "no turf")
		return

	var/turf/B = GET_TURF_BELOW(T)
	to_chat(usr, "HERE: [T] type=[T.type] ([T.x],[T.y],[T.z])")
	to_chat(usr, "BELOW: [B] type=[B?.type] ([B?.x],[B?.y],[B?.z])")
	var/turf/L = locate(T.x, T.y, T.z - 1)
	to_chat(src, "LOCATE BELOW: [L] type=[L?.type] z=[T.z-1] maxz=[world.maxz] maxx=[world.maxx] maxy=[world.maxy]")

	var/turf/stepB = get_step_multiz(T, DOWN)
	to_chat(src, "get_step_multiz(DOWN): [stepB] type=[stepB?.type]")

	to_chat(usr, "multiz_levels.len=[length(SSmapping.multiz_levels)]")
	to_chat(usr, "get_step(DOWN)=[get_step(T, DOWN)] type=[get_step(T, DOWN)?.type]")

	if(istype(T, /turf/open/transparent) || istype(T, /turf/closed/transparent))
		T.update_multiz(TRUE, TRUE)
		to_chat(usr, "after update_multiz: vis=[length(T.vis_contents)] underlays=[length(T.underlays)]")
