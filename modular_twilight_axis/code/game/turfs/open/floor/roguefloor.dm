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

/turf/open/floor/rogue/tile/bath/bathtile_pool
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "bathtile_pool"

/turf/open/floor/rogue/tile/cobblestone1
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobblestone1"

/turf/open/floor/rogue/tile/cobblestone1/cobblestone2
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobblestone2"

/turf/open/floor/rogue/tile/cobblestone1/cobblestone3
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobblestone3"

/turf/open/floor/rogue/tile/masonic/full_white
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "masonicfull_white"

/turf/open/floor/rogue/tile/masonic/full_black
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "masonicfull_black"

/turf/open/floor/rogue/tile/masonic/masonicarrow
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "masonicarrow"

/turf/open/floor/rogue/tile/masonic/masonicarrow_invert
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "masonicarrow_invert"

/turf/open/floor/rogue/tile/moontile_dark
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "moontile_dark"

/turf/open/floor/rogue/tile/moontile_bw
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "moontile_bw"

/turf/open/floor/rogue/tile/suntile
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "suntile"

/turf/open/floor/rogue/tile/carvedstone
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "carvedstone"

/turf/open/floor/rogue/tile/carvedstone/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/effect/decal/cobbleedge_n
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobbleedge-n"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/cobbleedge_n/cobbleedge_sread
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobbleedge-sread"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/cobbleedge_n/cobbleedge_w
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobbleedge-w"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/cobbleedge_n/cobbleedge_e
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobbleedge-e"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/cobbleedge_n/cobblestone_edges
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "cobblestone_edges"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/woodenborder
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "woodenborder"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/woodenborder/incorner
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "woodenborderinv"
	dir = 1
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/woodenborder2
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "woodenborder2"
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/woodenborder2/incorner
	icon = 'modular_twilight_axis/icons/turf/roguefloor.dmi'
	icon_state = "woodenborder2inv"
	dir = 1
	mouse_opacity = 0
	bake_to_loc = TRUE

/obj/effect/decal/carpet/fibermat
	name = "Fibermat"
	desc = "Fibers interwoven to make a cheap mat."
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "fibermat_round"
	bake_to_loc = TRUE
	pixel_w = 0
	pixel_z = 0

/obj/effect/decal/carpet/sunrug
	name = "Sun rug"
	desc = "A round rug with the sun of Astrata embroidered in the center."
	icon = 'modular_twilight_axis/icons/roguetown/misc/64x64.dmi'
	icon_state = "sunrug"
	bake_to_loc = TRUE
	pixel_w = 0
	pixel_z = 0

/obj/effect/decal/carpet/moonrug
	name = "Nok rug"
	desc = "A round rug with the Nok embroidered in the center."
	icon = 'modular_twilight_axis/icons/roguetown/misc/64x64.dmi'
	icon_state = "moonrug"
	bake_to_loc = TRUE
	pixel_w = 0
	pixel_z = 0

/obj/effect/decal/carpet/magiccircle
	name = "magiccircle"
	icon = 'modular_twilight_axis/icons/effects/96x96.dmi'
	icon_state = "circle"
	bake_to_loc = TRUE

/obj/effect/decal/carpet/zizocircle
	name = "zizocircle"
	icon = 'modular_twilight_axis/icons/effects/96x96.dmi'
	icon_state = "zizocircle"
	bake_to_loc = TRUE

/obj/effect/decal/carpet/nocastrata
	name = "nocastrata"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "c1"
	bake_to_loc = TRUE

/obj/effect/decal/carpet/nocastrata/c2
	name = "nocastrata"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "c2"
	bake_to_loc = TRUE


/obj/effect/decal/carpet/nocastrata/c3
	name = "nocastrata"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "c3"
	bake_to_loc = TRUE

/obj/effect/decal/carpet/nocastrata/c4
	name = "nocastrata"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "c4"
	bake_to_loc = TRUE
