/turf/open/floor/rogue/dunes
	name = "sand"
	desc = "Its course and rough, and it gets everywhere."
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	icon_state = "dune1"
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/desert_grass,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/dirt/desert,
						/turf/open/floor/rogue/dirt/road/desert,
						/turf/open/floor/rogue/citybrick,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/cobble/mossy,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	// slowdown = 1
	// neighborlay = "duneedge"
	track_prob = 10

/turf/open/floor/rogue/dunes/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dunes/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "dune[rand(1,16)]"

/obj/effect/decal/duneedge
	name = ""
	desc = ""
	icon = 'modular_deserttown/icons/duneedge.dmi'
	icon_state = "duneedge"
	mouse_opacity = 0

/turf/open/floor/rogue/sandbrick
	icon_state = "sand-brick1"
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue, /turf/closed/mineral, /turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wood, /turf/closed/wall/mineral/rogue/wooddark, /turf/closed/wall/mineral/rogue/stone, /turf/closed/wall/mineral/rogue/stone/moss, /turf/open/floor/rogue/cobble, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass)
	track_prob = 5

/turf/open/floor/rogue/sandbrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/sandbrick/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	icon_state = "sand-brick[rand(1,4)]"

/turf/open/floor/rogue/citybrick
	icon_state = "city-brick1"
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue, /turf/closed/mineral, /turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wood, /turf/closed/wall/mineral/rogue/wooddark, /turf/closed/wall/mineral/rogue/stone, /turf/closed/wall/mineral/rogue/stone/moss, /turf/open/floor/rogue/cobble, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass)
	abstract_type = /turf/open/floor/rogue/citybrick
	track_prob = 3

/turf/open/floor/rogue/citybrick/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/citybrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/citybrick/citybrick1
	icon_state = "city-brick1-1"

/turf/open/floor/rogue/citybrick/citybrick1/Initialize(mapload)
	. = ..()
	icon_state = "city-brick1-[rand(1,4)]"


/turf/open/floor/rogue/citybrick/citybrick2
	icon_state = "city-brick2-1"

/turf/open/floor/rogue/citybrick/citybrick2/Initialize(mapload)
	. = ..()
	icon_state = "city-brick2-[rand(1,5)]"


/turf/open/floor/rogue/citybrick/citybrick3
	icon_state = "city-brick3-1" //this only has one variant


/turf/open/floor/rogue/citybrick/citybrick4
	icon_state = "city-brick4-1"

/turf/open/floor/rogue/citybrick/citybrick4/Initialize(mapload)
	. = ..()
	icon_state = "city-brick4-[rand(1,2)]"

/turf/open/floor/rogue/citybrick/citybrick5
	icon_state = "city-brick5-1"

/turf/open/floor/rogue/citybrick/citybrick5/Initialize(mapload)
	. = ..()
	icon_state = "city-brick5-[rand(1,2)]"


/turf/open/floor/rogue/citybrick/citybrick6
	icon_state = "city-brick6-1"

/turf/open/floor/rogue/citybrick/citybrick6/Initialize(mapload)
	. = ..()
	icon_state = "city-brick6-[rand(1,2)]"

/turf/open/floor/rogue/lightpath
	icon_state = "light-path1"
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	canSmoothWith = list(/turf/open/floor/rogue, /turf/closed/mineral, /turf/closed/wall/mineral)
	// slowdown = 0 //Could be due tweaking but turning it off for now for practical reasons
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_TRUE
	track_prob = 10

/turf/open/floor/rogue/lightpath/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/lightpath/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	icon_state = "light-path[rand(1,8)]"


/turf/open/floor/rogue/darkpath
	icon_state = "dark-path1"
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	canSmoothWith = list(/turf/open/floor/rogue, /turf/closed/mineral, /turf/closed/wall/mineral)
	slowdown = 0
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_TRUE
	track_prob = 10

/turf/open/floor/rogue/darkpath/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/darkpath/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	icon_state = "dark-path[rand(1,8)]"

/obj/effect/decal/desertgrassedge
	name = ""
	desc = ""
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	icon_state = "desertgrassedge"
	mouse_opacity = 0

/turf/open/floor/rogue/desert_grass
	name = "desert grass"
	desc = "Grass, barely."
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	icon_state = "desertgrass1"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/dunes,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/dirt/road,
						/turf/open/floor/rogue/dirt/desert,
						/turf/open/floor/rogue/dirt/road/desert,
						/turf/open/floor/rogue/citybrick,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/grassgrey,
						/turf/open/floor/rogue/grasspurple,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/cobblerock,
						/turf/open/floor/rogue/cobble/mossy,)
	neighborlay = "desertgrassedge"
	spread_chance = 15
	burn_power = 6
	track_prob = 15

/turf/open/floor/rogue/desert_grass/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	icon_state = "desertgrass[rand(1,16)]"

/turf/open/floor/rogue/desert_grass/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/desert_grass/turf_destruction(damage_flag)
	. = ..()
	src.ChangeTurf(/turf/open/floor/rogue/dirt/desert, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/desert_grass/nospawn

/turf/open/floor/rogue/dirt/desert
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	track_prob = 15
	
/turf/open/floor/rogue/dirt/desert/nospawn

/turf/open/floor/rogue/dirt/road/desert
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	track_prob = 15

/turf/open/floor/rogue/grass/desert
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	track_prob = 15

///.

/turf/open/floor/rogue/deserttile
	icon_state = "tiledrab"
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue, /turf/closed/mineral, /turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wood, /turf/closed/wall/mineral/rogue/wooddark, /turf/closed/wall/mineral/rogue/stone, /turf/closed/wall/mineral/rogue/stone/moss, /turf/open/floor/rogue/cobble, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass)
	abstract_type = /turf/open/floor/rogue/deserttile
	track_prob = 3

// FIX: Added explicit 'cardinal_smooth' override so SMOOTH_MORE logic does not break the icon
/turf/open/floor/rogue/deserttile/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/naturalstone/sandstone
	name = "rough sandstone ground"
	desc = "Rough sandstone that's been exposed to the air either through erosion or the swing of a pickaxe. Dust wisps through the cracks."
	icon = 'modular_deserttown/icons/desertfloor.dmi'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral)
	track_prob = 5
