/obj/machinery/light/rogue
	var/heat_level = 0

/obj/machinery/light/rogue/proc/update_turf_heat()
	if(!heat_level)
		return
	var/turf/open/floor/T = loc
	if(!isfloorturf(T))
		return
	if(on)
		T.add_heat_source(src, heat_level)
	else
		T.remove_heat_source(src)

/obj/machinery/light/rogue/proc/ta_climate_clear_turf_heat()
	if(!heat_level || !isfloorturf(loc))
		return
	var/turf/open/floor/T = loc
	T.remove_heat_source(src)

/obj/machinery/light/rogue/Moved(atom/OldLoc, Dir)
	. = ..()
	if(!heat_level)
		return
	if(isfloorturf(OldLoc))
		var/turf/open/floor/T = OldLoc
		T.remove_heat_source(src)
	update_turf_heat()

/obj/machinery/light/rogue/firebowl
	heat_level = 4

/obj/machinery/light/rogue/firebowl/standing
	heat_level = 3

/obj/machinery/light/rogue/campfire/fireplace
	heat_level = 6

/obj/machinery/light/rogue/hearth
	heat_level = 3

/obj/machinery/light/rogue/campfire
	heat_level = 5

/obj/machinery/light/rogue/campfire/densefire
	heat_level = 5

/obj/machinery/light/rogue/campfire/pyre
	heat_level = 5
