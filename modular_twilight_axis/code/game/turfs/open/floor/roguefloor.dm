/turf/open/floor/rogue/dirt/nospawn

/turf/open/floor/rogue/grass/nospawn

/turf/open/floor/rogue/grasspurple
	name = "fungal 'grass'"
	desc = "Thin fungal strands rising from the ground. Spongey to walk on."
	icon_state = "grass_purple"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_purpleedge"

/turf/open/floor/rogue/grasspurple/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grasspurple/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grassgrey
	name = "dead grass"
	desc = "Pale, like a bloated corpse."
	icon_state = "grass_grey"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_greyedge"

/turf/open/floor/rogue/grassgrey/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassgrey/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/tile/bath
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
