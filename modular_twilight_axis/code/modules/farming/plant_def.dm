#define SLOW_GROWING 6 MINUTES
#define FAST_GROWING 5 MINUTES
#define VERY_FAST_GROWING 4 MINUTES
#define HUNGRINESS_EXTREME 60 // For Tree
#define HUNGRINESS_DEMANDING 35
#define HUNGRINESS_NORMAL 25
#define HUNGRINESS_TINY 15

/datum/plant_def/melon
	name = "melon vines"
	icon = 'modular_twilight_axis/icons/roguetown/misc/crops.dmi'
	icon_state = "melon"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/melon
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers = 3)
	maturation_nutrition = HUNGRINESS_DEMANDING
	maturation_time = SLOW_GROWING
	produce_time = 3 MINUTES

/datum/plant_def/watermelon
	name = "watermelon vines"
	icon = 'modular_twilight_axis/icons/roguetown/misc/crops.dmi'
	icon_state = "watermelon"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/watermelon
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers = 3)
	maturation_nutrition = HUNGRINESS_DEMANDING
	maturation_time = SLOW_GROWING
	produce_time = 3 MINUTES

/datum/plant_def/tree/banana
	name = "banana tree"
	icon = 'modular_twilight_axis/icons/roguetown/misc/crops.dmi'
	icon_state = "banana"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/banana

#undef SLOW_GROWING
#undef FAST_GROWING
#undef VERY_FAST_GROWING
#undef HUNGRINESS_EXTREME
#undef HUNGRINESS_DEMANDING
#undef HUNGRINESS_NORMAL
#undef HUNGRINESS_TINY
