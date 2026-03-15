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
	spawnableAtoms = list(/obj/structure/flora/tinymushrooms = 3,
							/obj/structure/roguerock = 10,
							/obj/item/natural/rock = 10,
							/obj/structure/vine = 4,
							/obj/structure/leyline/normal/coast = 1)

/datum/mapGeneratorModule/underdarkratmud
	clusterCheckFlags = CLUSTER_CHECK_SAME_ATOMS
	allowed_areas = list(/area/rogue/under/underdark)
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grasscold, /turf/open/floor/rogue/grasspurple)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/mushroomcluster = 3,
							/obj/structure/flora/roguegrass/thorn_bush = 3,
							/obj/structure/flora/rogueshroom/happy/random = 10,
							/obj/structure/flora/rogueshroom = 3,
							/obj/structure/flora/tinymushrooms = 3,
							/obj/structure/flora/roguegrass = 10,
							/obj/structure/flora/roguegrass/herb/random = 2,
							/obj/structure/zizo_bane = 0.5,
							/obj/structure/leyline/normal/coast = 1)
