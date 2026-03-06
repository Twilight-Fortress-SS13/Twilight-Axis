/obj/effect/landmark/mapGenerator/rogue/underdarkrat
	mapGeneratorType = /datum/mapGenerator/underdarkrat
	endTurfX = 255
	endTurfY = 450
	startTurfX = 1
	startTurfY = 1

/datum/mapGenerator/underdarkrat
	modules = list(/datum/mapGeneratorModule/underdarkratstone, /datum/mapGeneratorModule/underdarkratmud)


/datum/mapGeneratorModule/underdarkratstone
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/naturalstone)
	allowed_areas = list(/area/rogue/under/underdark)
	spawnableAtoms = list(/obj/structure/flora/tinymushrooms = 5,
							/obj/structure/roguerock = 20,
							/obj/item/natural/rock = 20,
							/obj/structure/vine = 5)

/datum/mapGeneratorModule/underdarkratmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdark)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 5,
							/obj/structure/flora/roguegrass/thorn_bush = 5,
							/obj/structure/flora/rogueshroom/happy/random = 15,
							/obj/structure/flora/rogueshroom = 5,
							/obj/structure/flora/tinymushrooms = 5,
							/obj/structure/flora/roguegrass = 15,
							/obj/structure/flora/roguegrass/herb/random = 3,
							/obj/structure/zizo_bane = 0.5)
