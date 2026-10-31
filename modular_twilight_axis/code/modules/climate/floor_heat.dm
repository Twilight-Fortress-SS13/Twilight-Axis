/turf/open/floor
	var/list/heat_sources

GLOBAL_LIST_EMPTY(hot_floors)
GLOBAL_LIST_EMPTY(heat_source_floors)
GLOBAL_VAR_INIT(heat_ticking, FALSE)
GLOBAL_VAR_INIT(heat_count, 0)

/proc/start_heat_ticking()
	if(GLOB.heat_ticking)
		return
	GLOB.heat_ticking = TRUE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(heat_tick)), 2 SECONDS)

/turf/open/floor/proc/set_heat(new_heat)
	new_heat = clamp(new_heat, 0, 5)
	if(heat == new_heat)
		return
	heat = new_heat
	GLOB.hot_floors[src] = TRUE
	for(var/D in GLOB.cardinals)
		var/turf/open/floor/T = get_step(src, D)
		if(isfloorturf(T))
			GLOB.hot_floors[T] = TRUE
	start_heat_ticking()

/turf/open/floor/proc/add_heat_source(obj/O, source_heat)
	if(!heat_sources)
		heat_sources = list()
	heat_sources[O] = source_heat
	GLOB.heat_source_floors[src] = TRUE
	var/source_max = 0
	for(var/obj/machinery/light/rogue/F as anything in heat_sources)
		if(!QDELETED(F) && F.on && F.loc == src)
			source_max = max(source_max, heat_sources[F])
	source_max = clamp(source_max, 0, 5)
	if(heat != source_max)
		set_heat(source_max)
	start_heat_ticking()

/turf/open/floor/proc/remove_heat_source(obj/O)
	if(!heat_sources)
		return
	heat_sources -= O
	if(length(heat_sources))
		var/source_max = 0
		for(var/obj/machinery/light/rogue/F as anything in heat_sources)
			if(!QDELETED(F) && F.on && F.loc == src)
				source_max = max(source_max, heat_sources[F])
		source_max = clamp(source_max, 0, 5)
		if(heat != source_max)
			set_heat(source_max)
		return
	heat_sources = null
	GLOB.heat_source_floors -= src
	GLOB.hot_floors[src] = TRUE
	start_heat_ticking()

/turf/open/floor/proc/get_source_heat()
	. = 0
	if(!heat_sources)
		return
	var/list/stale_sources = list()
	for(var/obj/machinery/light/rogue/F as anything in heat_sources)
		if(QDELETED(F) || !F.on || F.loc != src)
			stale_sources += F
			continue
		if(heat_sources[F] > .)
			. = heat_sources[F]
	for(var/obj/machinery/light/rogue/F as anything in stale_sources)
		remove_heat_source(F)
	. = clamp(., 0, 5)

/proc/heat_tick()
	set waitfor = FALSE
	GLOB.heat_count++
	if(GLOB.heat_count >= 5)
		GLOB.heat_count = 0
		for(var/turf/open/floor/T as anything in GLOB.heat_source_floors)
			if(!isfloorturf(T) || !T.heat_sources)
				GLOB.heat_source_floors -= T
				continue
			var/shigh = T.get_source_heat()
			if(shigh != T.heat)
				T.set_heat(shigh)
			CHECK_TICK
	var/list/checking = GLOB.hot_floors
	GLOB.hot_floors = list()
	var/list/changes = list()
	for(var/turf/open/floor/T as anything in checking)
		if(!isfloorturf(T) || T.heat <= 0)
			continue
		var/hottest = 0
		for(var/D in GLOB.cardinals)
			var/turf/open/floor/T2 = get_step(T, D)
			if(!isfloorturf(T2))
				continue
			if(T2.heat > hottest)
				hottest = T2.heat
			if(T2.heat <= T.heat - 2 && changes[T2] < T.heat - 1)
				changes[T2] = T.heat - 1
		if(!T.heat_sources && hottest <= T.heat)
			changes[T] = T.heat - 1
		CHECK_TICK
	for(var/turf/open/floor/T as anything in changes)
		T.set_heat(changes[T])
		CHECK_TICK
	if(!length(GLOB.hot_floors) && !length(GLOB.heat_source_floors))
		GLOB.heat_ticking = FALSE
		return
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(heat_tick)), 2 SECONDS)
