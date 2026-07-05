/obj/effect/landmark/mapGenerator/rogue/desert
	mapGeneratorType = /datum/mapGenerator/desert
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/desert
	modules = list(/datum/mapGeneratorModule/desertsand, /datum/mapGeneratorModule/desertsand_flora, /datum/mapGeneratorModule/desertgrass, /datum/mapGeneratorModule/deserttrees, /datum/mapGeneratorModule/desertroad, /datum/mapGeneratorModule/desertwater)


/datum/mapGeneratorModule/desertsand_flora
	clusterCheckFlags = CLUSTER_CHECK_NONE
	allowed_turfs = list(/turf/open/floor/rogue/dunes)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)
	spawnableAtoms = list(/obj/structure/flora/roguegrass/desertgrass = 3)


/datum/mapGeneratorModule/desertsand_flora/checkPlaceAtom(turf/T)
	. = ..()
	if(!.)
		return 0
	for(var/obj/O in T) // Do not spawn on top of existing objects
		if(istype(O, /obj/structure) || istype(O, /obj/item))
			return 0


/datum/mapGeneratorModule/desertsand
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dunes)
//	excluded_areas = list(/area/rogue/indoors/shelter/town, /area/rogue/outdoors/town/roofs, /area/rogue/indoors/town, /area/rogue/under/town/basement)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 0.5,
							/obj/structure/flora/roguegrass/bush/desertshrub = 0.5,
							/obj/structure/flora/roguetree/stump/log = 0.3,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.1,
							/obj/structure/leyline/normal/coast = 0.04,
							/obj/structure/leyline/normal/decap = 0.02,
							/obj/structure/leyline/normal/grove = 0.03,
							/obj/structure/voidstoneobelisk = 0.05,
							/obj/item/magic/manacrystal = 0.07,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/desert_spice = 0.2,
							/obj/structure/flora/junglebush/desertbush = 0.6,
							/obj/effect/landmark/desert_track_spawner = 1.4) // Added for modular hunting
	//spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)


/datum/mapGeneratorModule/desertgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	//  = list(/area/rogue/indoors/shelter/town, /area/rogue/outdoors/town/roofs, /area/rogue/indoors/town, /area/rogue/under/town/basement)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 7,
							/obj/structure/flora/roguegrass/bush/desertshrub = 6,
							/obj/structure/flora/roguegrass/bush = 4,
							/obj/structure/flora/junglebush = 4,
							/obj/structure/flora/newtree = 7,
							/obj/structure/flora/roguetree = 6,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/grass/jungle = 25,
							/obj/structure/flora/roguetree/stump/log = 0.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.5,
							/obj/structure/flora/ausbushes/ywflowers = 0.5,
							/obj/structure/flora/roguegrass/maneater = 0.5,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 0.5,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline/normal/coast = 0.1,
							/obj/structure/leyline/normal/decap = 0.1,
							/obj/structure/leyline/normal/grove = 0.3,
							/obj/structure/voidstoneobelisk = 0.1,
							/obj/structure/flora/roguegrass/herb/manabloom = 1,
							/obj/item/magic/manacrystal = 0.1,
							/obj/structure/closet/dirthole/closed/loot = 0.5,
							/obj/structure/flora/roguegrass/swampweed = 0.5,
							/obj/structure/flora/roguegrass/herb/random = 7,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/zizo_bane = 0.5,
							/obj/effect/landmark/desert_track_spawner = 2.2) // Added for modular hunting
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/deserttrees
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt/desert)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
//	excluded_areas = list(/area/rogue/indoors/shelter/town, /area/rogue/outdoors/town/roofs, /area/rogue/indoors/town, /area/rogue/under/town/basement)
	spawnableAtoms = list(/obj/structure/flora/newtree = 20,
							/obj/structure/flora/roguetree/palm = 7,
							/obj/structure/flora/roguegrass/bush/desertshrub = 6,
							/obj/structure/flora/roguegrass/bush = 4,
							/obj/structure/flora/junglebush = 4,
							/obj/structure/flora/roguetree = 6,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/grass/jungle = 25,
							/obj/structure/flora/roguetree/stump/log = 0.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.5,
							/obj/structure/flora/ausbushes/ywflowers = 0.5,
							/obj/structure/flora/roguegrass/maneater = 0.5,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 0.5,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline/normal/coast = 0.05,
							/obj/structure/leyline/normal/decap = 0.03,
							/obj/structure/leyline/normal/grove = 0.02,
							/obj/structure/voidstoneobelisk = 0.1,
							/obj/structure/flora/roguegrass/herb/manabloom = 1,
							/obj/item/magic/manacrystal = 0.1,
							/obj/structure/closet/dirthole/closed/loot = 0.5,
							/obj/structure/flora/roguegrass/swampweed = 0.5,
							/obj/structure/flora/roguegrass/herb/random = 7,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/zizo_bane = 0.5,
							/obj/effect/landmark/desert_track_spawner = 2.2) // Added for modular hunting
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 2,/obj/item/grown/log/tree/stick = 1)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertwater
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/water/cleanshallow)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)
	spawnableAtoms = list(	/obj/structure/flora/roguetree/stump/log = 1,
							/obj/structure/flora/ausbushes/reedbush = 1,
							/obj/structure/flora/roguegrass/water/reeds = 1,)

// Smart proxy spawner for modular hunting tracks in desert
/obj/effect/landmark/desert_track_spawner
	name = "desert track spawner proxy"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE

/obj/effect/landmark/desert_track_spawner/Initialize(mapload)
	. = ..()
	var/area/current_area = get_area(src)

	var/spawn_chance = 0
	if(istype(current_area, /area/rogue/outdoors/desertdeep))
		spawn_chance = 75 // Medium amount of tracks in deep desert
	else if(istype(current_area, /area/rogue/outdoors/desert))
		spawn_chance = 20 // Low amount of tracks in regular desert

	if(prob(spawn_chance))
		new /obj/effect/hunting_track(src.loc)

	// In all cases, we delete the proxy spawner after checking
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/mapGenerator/rogue/desertdark
	mapGeneratorType = /datum/mapGenerator/desertdark
	endTurfX = 380
	endTurfY = 310
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/desertdark
	modules = list(/datum/mapGeneratorModule/desertdarkstone, /datum/mapGeneratorModule/desertdarkmud)

/datum/mapGeneratorModule/desertdarkstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/desertdark)
	spawnableAtoms = list(/obj/structure/flora/rogueshroom/happy/random = 17,
							/obj/structure/flora/mushroomcluster = 13,
							/obj/structure/flora/tinymushrooms = 13,
							/obj/structure/roguerock = 25,
							/obj/item/natural/rock = 20,
							/obj/structure/vine = 5,
							/obj/effect/hunting_track = 5,
							/obj/structure/zizo_bane = 3)

/datum/mapGeneratorModule/desertdarkmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/desertdark)
	allowed_turfs = list(/turf/open/floor/rogue/dirt)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 18,
							/obj/structure/flora/roguegrass/thorn_bush = 8,
							/obj/structure/flora/rogueshroom/happy/random = 22,
							/obj/structure/flora/rogueshroom = 18,
							/obj/structure/flora/tinymushrooms = 18,
							/obj/structure/flora/roguegrass = 24,
							/obj/structure/flora/roguegrass/herb/random = 5,
							/obj/effect/hunting_track = 5,
							/obj/structure/zizo_bane = 3)

