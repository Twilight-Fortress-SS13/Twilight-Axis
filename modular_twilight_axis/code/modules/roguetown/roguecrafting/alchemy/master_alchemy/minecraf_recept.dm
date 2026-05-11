/datum/alch_grid_recipe
	var/name = "Unknown"
	var/result_type = null
	var/result_icon = null
	var/result_icon_state = null
	var/list/grid = list(
		null, null, null,
		null, null, null,
		null, null, null
	)



/datum/alch_grid_recipe/silver
	name = "Трансмутация серебра"
	result_type = /obj/item/rogueore/silver
	result_icon = 'icons/roguetown/items/ore.dmi'
	result_icon_state = "oresilv1"
	grid = list(
		/obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron,
		/obj/item/rogueore/iron, /obj/item/rogueore/gold, /obj/item/rogueore/iron,
		/obj/item/rogueore/iron, /obj/item/rogueore/iron, /obj/item/rogueore/iron 
	)

/datum/alch_grid_recipe/philosophorum
	name = "Философский камень"
	result_type = /obj/item/philosophers_stone
	result_icon = 'modular_twilight_axis/code/modules/roguetown/roguecrafting/alchemy/master_alchemy/alch.dmi'
	result_icon_state = "soulstone"
	grid = list(
		/obj/item/alch/waterdust, /obj/item/reagent_containers/lux_impure, /obj/item/alch/earthdust,
		/obj/item/alch/magicdust, /obj/item/riddleofsteel, /obj/item/alch/magicdust,
		/obj/item/alch/airdust, /obj/item/reagent_containers/lux, /obj/item/alch/firedust

	)

/datum/alch_grid_recipe/infernaldust
	name = "Инфернальная пыль"
	result_type = /obj/item/alch/infernaldust
	result_icon = 'icons/roguetown/misc/alchemy.dmi'
	result_icon_state = "infernaldust"
	grid = list(
		null, null, /obj/item/alch/firedust,
		null, /obj/item/alch/firedust, null,
		/obj/item/alch/firedust, null, null

	)

/datum/alch_grid_recipe/bone
	name = "Копчик"
	result_type = /obj/item/alch/bone
	result_icon = 'icons/roguetown/misc/alchemy.dmi'
	result_icon_state = "bone"
	grid = list(
		/obj/item/alch/sinew, null, null,
		null, /obj/item/alch/sinew, null,
		null, null, /obj/item/alch/sinew

	)

/datum/alch_grid_recipe/sunflower
	name = "Семя подсолнуха"
	result_type = /obj/item/seeds/sunflower
	result_icon = 'icons/obj/hydroponics/seeds.dmi'
	result_icon_state = "seed"
	grid = list(
		null, /obj/item/alch/firedust, null,
		null, /obj/item/alch/rosa, null,
		null, /obj/item/alch/firedust, null
	)
/datum/alch_grid_recipe/homunculus_clay
	name = "Mirror Clay"
	result_type = /obj/item/alch/mirror_clay
	result_icon = 'icons/roguetown/items/natural.dmi'
	result_icon_state = "clay"
	grid = list(
		/obj/item/natural/clay, /obj/item/natural/clay, /obj/item/natural/clay,
		/obj/item/natural/clay, /obj/item/reagent_containers/lux, /obj/item/natural/clay,
		/obj/item/natural/clay, /obj/item/natural/clay, /obj/item/natural/clay
	)
