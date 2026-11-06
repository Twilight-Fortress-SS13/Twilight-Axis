#define TA_DRUID_MAX_PLANT_WEEDS 100

/obj/structure/soil/proc/has_custom_growth()
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	return locate(/obj/structure/tree_sapling) in T || locate(/obj/structure/bush_sapling) in T || locate(/obj/structure/flower_sprout) in T || locate(/obj/structure/mushroom_sprout) in T || locate(/obj/structure/mushroom_circle) in T

/obj/structure/soil/proc/get_environmental_growth_multiplier()
	var/gm = 1.0
	if(tilled_time > 0)
		gm *= 1.6
	if(fertilized_time > 0)
		gm *= 2.0
	if(pollination_time > 0)
		gm *= 1.75
	if(has_world_trait(/datum/world_trait/dendor_fertility))
		gm *= 2.0
	if(has_world_trait(/datum/world_trait/fertility))
		gm *= 1.5
	if(has_world_trait(/datum/world_trait/dendor_drought))
		gm *= 0.4
	if(blessed_time > 0)
		gm *= 1.15
	if(weeds >= TA_DRUID_MAX_PLANT_WEEDS * 0.6)
		gm *= 0.75
	else if(weeds >= TA_DRUID_MAX_PLANT_WEEDS * 0.3)
		gm *= 0.75
	return gm

#undef TA_DRUID_MAX_PLANT_WEEDS
