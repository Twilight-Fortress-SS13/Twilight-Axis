/datum/supply_pack/rogue/zybantu
	group = "Cultural Stock"
	crate_name = "Zybantu crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/zybantu/stargazer_vestments
	name = "Zybantian Stargazer Vestments"
	no_name_quantity = TRUE
	cost = 320
	contains = list(
		/obj/item/clothing/suit/roguetown/shirt/robe/noc/stargazer,
		/obj/item/clothing/head/roguetown/roguehood/stargazer,
		/obj/item/clothing/mask/rogue/owlmask,
		/obj/item/clothing/shoes/roguetown/sandals,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/zybantu/imperial_gold_finery
	name = "Imperial Zybantian Gold Finery"
	cost = 190
	contains = list(
		/obj/item/clothing/ring/gold,
		/obj/item/clothing/ring/gold,
		/obj/item/clothing/wrists/roguetown/bracers/gold,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantu/glass_decanters
	name = "Zybantian Glass Decanter Set"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/zybantu/desert_rider_gear
	name = "Zybantian Desert Rider Gear"
	cost = 145
	contains = list(
		/obj/item/clothing/head/roguetown/roguehood/shalal/hijab,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/storage/belt/rogue/leather/shalal,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/zybantu/merchant_survey
	name = "Survey of the Sultan's Markets"
	cost = 70
	contains = list(
		/obj/item/book/rogue/naledi1,
		/obj/item/book/rogue/naledi2,
	)
	ship_qty_min = 1
	ship_qty_max = 2
