#define TRADE_GOOD_MANOR_PREPARED_CLAY "MANOR_PREPARED_CLAY"
#define TRADE_GOOD_MANOR_FLOUR "MANOR_FLOUR"
#define TRADE_GOOD_MANOR_SALTED_PORK "MANOR_SALTED_PORK"
#define TRADE_GOOD_MANOR_WHEAT_WORT "MANOR_WHEAT_WORT"
#define TRADE_GOOD_MANOR_OAT_WORT "MANOR_OAT_WORT"
#define TRADE_GOOD_MANOR_JACK_MUST "MANOR_JACK_MUST"
#define TRADE_GOOD_MANOR_PLUM_MUST "MANOR_PLUM_MUST"
#define TRADE_GOOD_MANOR_FOX_PELT "MANOR_FOX_PELT"
#define TRADE_GOOD_MANOR_PREPARED_PELT "MANOR_PREPARED_PELT"
#define TRADE_GOOD_MANOR_OYSTER "MANOR_OYSTER"
#define TRADE_GOOD_MANOR_SHELL "MANOR_SHELL"
#define TRADE_GOOD_MANOR_PEARL "MANOR_PEARL"
#define TRADE_GOOD_MANOR_PLANK "MANOR_PLANK"
#define TRADE_GOOD_MANOR_STICK "MANOR_STICK"

/proc/getManorProductionLanes(manor_type)
	var/static/list/chains = list(
		"mining_settlement" = list(
			"smith" = list(
				"name" = "Кузнечное дело",
				"processing_name" = "Плавильня",
				"workshop_name" = "Кузница",
				"materials" = list(),
			),
			"jewelry" = list(
				"name" = "Ювелирное дело и керамика",
				"processing_name" = "Подготовка материалов",
				"workshop_name" = "Ювелирная мастерская",
				"materials" = list(
					"goldsmith" = list(
						"label" = "Gold Ingot",
						"inputs" = list(TRADE_GOOD_GOLD_ORE = 1),
						"refined_good" = TRADE_GOOD_GOLD_INGOT,
					),
					"silversmith" = list(
						"label" = "Silver Ingot",
						"inputs" = list(TRADE_GOOD_SILVER_ORE = 1),
						"refined_good" = TRADE_GOOD_SILVER_INGOT,
					),
					"ceramics" = list(
						"label" = "Prepared Clay",
						"inputs" = list(TRADE_GOOD_CLAY = 1),
						"refined_good" = TRADE_GOOD_MANOR_PREPARED_CLAY,
					),
				),
			),
		),
		"village" = list(
			"provisions" = list(
				"name" = "Провизия",
				"processing_name" = "Подготовка припасов",
				"workshop_name" = "Пекарня и коптильня",
				"materials" = list(
					"flour" = list(
						"label" = "Flour",
						"inputs" = list(TRADE_GOOD_GRAIN = 1),
						"refined_good" = TRADE_GOOD_MANOR_FLOUR,
					),
					"preserved_pork" = list(
						"label" = "Salted Pork",
						"inputs" = list(
							TRADE_GOOD_PORK = 1,
							TRADE_GOOD_SALT = 1,
						),
						"refined_good" = TRADE_GOOD_MANOR_SALTED_PORK,
					),
				),
			),
			"simple_drinks" = list(
				"name" = "Простые напитки",
				"processing_name" = "Подготовка сусла",
				"workshop_name" = "Пивоварня",
				"materials" = list(
					"wheat_wort" = list(
						"label" = "Wheat Brewing Mash",
						"inputs" = list(TRADE_GOOD_GRAIN = 1),
						"refined_good" = TRADE_GOOD_MANOR_WHEAT_WORT,
					),
					"oat_wort" = list(
						"label" = "Oat Brewing Mash",
						"inputs" = list(TRADE_GOOD_OATS = 1),
						"refined_good" = TRADE_GOOD_MANOR_OAT_WORT,
					),
				),
			),
		),
		"manor" = list(
			"fine_food" = list(
				"name" = "Пиршественная кухня",
				"processing_name" = "Мельница",
				"workshop_name" = "Пекарня",
				"materials" = list(
					"flour" = list(
						"label" = "Flour",
						"inputs" = list(TRADE_GOOD_GRAIN = 1),
						"refined_good" = TRADE_GOOD_MANOR_FLOUR,
					),
				),
			),
			"fine_drinks" = list(
				"name" = "Виноделие",
				"processing_name" = "Винный пресс",
				"workshop_name" = "Винный погреб",
				"materials" = list(
					"jack_must" = list(
						"label" = "Jackberry Must",
						"inputs" = list(TRADE_GOOD_JACKSBERRY = 2),
						"refined_good" = TRADE_GOOD_MANOR_JACK_MUST,
					),
					"plum_must" = list(
						"label" = "Plum Must",
						"inputs" = list(TRADE_GOOD_PLUM = 2),
						"refined_good" = TRADE_GOOD_MANOR_PLUM_MUST,
					),
				),
			),
		),
		"hunter_mansion" = list(
			"tailoring" = list(
				"name" = "Пошив одежды",
				"processing_name" = "Кожевня",
				"workshop_name" = "Швейная мастерская",
				"materials" = list(
					"leatherwork" = list(
						"label" = "Cured Leather",
						"inputs" = list(TRADE_GOOD_HIDE = 1),
						"refined_good" = TRADE_GOOD_CURED_LEATHER,
						"output_amount" = 4,
					),
				),
			),
			"trophies" = list(
				"name" = "Охотничьи трофеи",
				"processing_name" = "Выделка трофеев",
				"workshop_name" = "Таксидермия",
				"materials" = list(
					"taxidermy" = list(
						"label" = "Prepared Venard Pelt",
						"inputs" = list(
							TRADE_GOOD_MANOR_FOX_PELT = 1,
							TRADE_GOOD_WOOD = 1,
						),
						"refined_good" = TRADE_GOOD_MANOR_PREPARED_PELT,
					),
				),
			),
		),
		"fisher_hamlet" = list(
			"marine_jewelry" = list(
				"name" = "Морские украшения",
				"processing_name" = "Разбор улова",
				"workshop_name" = "Ювелирная мастерская",
				"materials" = list(
					"shellwork" = list(
						"label" = "Clamshell",
						"inputs" = list(TRADE_GOOD_CLAM = 1),
						"refined_good" = TRADE_GOOD_MANOR_SHELL,
					),
					"pearls" = list(
						"label" = "Pearl",
						"inputs" = list(TRADE_GOOD_MANOR_OYSTER = 3),
						"refined_good" = TRADE_GOOD_MANOR_PEARL,
					),
				),
			),
		),
	)
	return chains[manor_type]

/proc/getManorAdditionalMaterials(manor_type, specialization)
	var/list/materials = list()
	var/list/direct_goods
	switch(specialization)
		if("smith")
			direct_goods = list(
				TRADE_GOOD_FUR,
				TRADE_GOOD_FIBERS,
				TRADE_GOOD_SILK,
				TRADE_GOOD_WOOD,
				TRADE_GOOD_COAL,
				TRADE_GOOD_STONE,
				TRADE_GOOD_CURED_LEATHER,
				TRADE_GOOD_CLOTH,
			)
		if("jewelry")
			direct_goods = list(
				TRADE_GOOD_CLAY,
				TRADE_GOOD_GLASS_BATCH,
				TRADE_GOOD_STONE,
				TRADE_GOOD_WOOD,
				TRADE_GOOD_TOPER,
				TRADE_GOOD_GEMERALD,
				TRADE_GOOD_SAFFIRA,
				TRADE_GOOD_DORPEL,
				TRADE_GOOD_JADE,
				TRADE_GOOD_OPAL,
				TRADE_GOOD_AMBER,
			)
		if("tailoring")
			direct_goods = list(
				TRADE_GOOD_FIBERS,
				TRADE_GOOD_SILK,
				TRADE_GOOD_FUR,
				TRADE_GOOD_HIDE,
				TRADE_GOOD_SINEW,
				TRADE_GOOD_TALLOW,
				TRADE_GOOD_FAT,
				TRADE_GOOD_WOOD,
			)
			materials["cloth"] = list(
				"label" = "Cloth",
				"inputs" = list(TRADE_GOOD_FIBERS = 2),
				"refined_good" = TRADE_GOOD_CLOTH,
			)
			materials["rope"] = list(
				"label" = "Rope",
				"inputs" = list(TRADE_GOOD_FIBERS = 3),
				"refined_good" = TRADE_GOOD_ROPE,
			)
		if("trophies")
			direct_goods = list(
				TRADE_GOOD_FUR,
				TRADE_GOOD_HIDE,
				TRADE_GOOD_WOOD,
				TRADE_GOOD_BONES,
				TRADE_GOOD_SINEW,
				TRADE_GOOD_MANOR_FOX_PELT,
				TRADE_GOOD_TROPHY_DIREBEAR,
			)
		if("marine_jewelry")
			direct_goods = list(
				TRADE_GOOD_CLAMSHELL,
				TRADE_GOOD_AMBER,
				TRADE_GOOD_FIBERS,
			)
		if("provisions", "fine_food")
			direct_goods = list(
				TRADE_GOOD_GRAIN,
				TRADE_GOOD_OATS,
				TRADE_GOOD_RICE,
				TRADE_GOOD_MAIZE,
				TRADE_GOOD_BEANS,
				TRADE_GOOD_LENTILS,
				TRADE_GOOD_MUSHROOM,
				TRADE_GOOD_MEAT,
				TRADE_GOOD_PORK,
				TRADE_GOOD_PORK_BELLY,
				TRADE_GOOD_HAM,
				TRADE_GOOD_MANOR_VENISON,
				TRADE_GOOD_MANOR_BUSHMEAT,
				TRADE_GOOD_MANOR_BEAR_MEAT,
				TRADE_GOOD_MANOR_CRAB_MEAT,
				TRADE_GOOD_MANOR_BOAR_HAM,
				TRADE_GOOD_POULTRY,
				TRADE_GOOD_RABBIT,
				TRADE_GOOD_FAT,
				TRADE_GOOD_TALLOW,
				TRADE_GOOD_EGG,
				TRADE_GOOD_BUTTER,
				TRADE_GOOD_CHEESE,
				TRADE_GOOD_HONEY,
				TRADE_GOOD_APPLE,
				TRADE_GOOD_PEAR,
				TRADE_GOOD_PLUM,
				TRADE_GOOD_JACKSBERRY,
				TRADE_GOOD_STRAWBERRY,
				TRADE_GOOD_RASPBERRY,
				TRADE_GOOD_BLACKBERRY,
				TRADE_GOOD_LIME,
				TRADE_GOOD_LEMON,
				TRADE_GOOD_TANGERINE,
				TRADE_GOOD_MANOR_BANANA,
				TRADE_GOOD_MANOR_WATERMELON,
				TRADE_GOOD_CABBAGE,
				TRADE_GOOD_POTATO,
				TRADE_GOOD_ONION,
				TRADE_GOOD_CARROT,
				TRADE_GOOD_TURNIP,
				TRADE_GOOD_GARLICK,
				TRADE_GOOD_TOMATO,
				TRADE_GOOD_CUCUMBER,
				TRADE_GOOD_EGGPLANT,
				TRADE_GOOD_PUMPKIN,
				TRADE_GOOD_SALT,
				TRADE_GOOD_SUGAR,
				TRADE_GOOD_ROCKNUT,
				TRADE_GOOD_FISH_FILET,
				TRADE_GOOD_FISH_MINCE,
			)
		if("simple_drinks", "fine_drinks")
			direct_goods = list(
				TRADE_GOOD_GRAIN,
				TRADE_GOOD_OATS,
				TRADE_GOOD_RICE,
				TRADE_GOOD_HONEY,
				TRADE_GOOD_JACKSBERRY,
				TRADE_GOOD_PLUM,
				TRADE_GOOD_APPLE,
				TRADE_GOOD_PEAR,
				TRADE_GOOD_LEMON,
				TRADE_GOOD_LIME,
				TRADE_GOOD_TEA,
				TRADE_GOOD_COFFEE,
				TRADE_GOOD_SUGAR,
				TRADE_GOOD_CALENDULA,
				TRADE_GOOD_POPPY,
			)
	if(specialization in list("trophies", "jewelry"))
		materials["planks"] = list(
			"label" = "Plank",
			"inputs" = list(TRADE_GOOD_WOOD = 1),
			"refined_good" = TRADE_GOOD_MANOR_PLANK,
		)
		materials["sticks"] = list(
			"label" = "Stick",
			"inputs" = list(TRADE_GOOD_WOOD = 1),
			"refined_good" = TRADE_GOOD_MANOR_STICK,
		)
	for(var/good_id in direct_goods)
		var/datum/trade_good/good = GLOB.trade_goods[good_id]
		if(!good?.item_type)
			continue
		var/list/inputs = list()
		inputs[good_id] = 1
		materials["raw_[good_id]"] = list(
			"label" = good.name,
			"inputs" = inputs,
			"refined_good" = good_id,
			"direct" = TRUE,
		)
	return materials

/proc/getManorAdditionalCatalogue()
	var/static/list/catalogue = list(
		"manor_silver_set" = list(
			"category" = "Посуда",
			"material" = "silversmith",
			"price_from_contents" = TRUE,
			"name" = "silver table set for two",
			"item_type" = /obj/item/reagent_containers/glass/cup/silver,
			"manifest" = list(
				/obj/item/reagent_containers/glass/cup/silver = 2,
				/obj/item/reagent_containers/glass/bowl/silver = 2,
				/obj/item/kitchen/spoon/silver = 2,
				/obj/item/kitchen/fork/silver = 2,
				/obj/item/cooking/platter/silver = 1,
			)
		),
		"manor_porcelain_set" = list(
			"category" = "Посуда",
			"material" = "ceramics",
			"price_from_contents" = TRUE,
			"name" = "porcelain table set for two",
			"item_type" = \
				/obj/item/reagent_containers/glass/cup/carved/porcelain,
			"manifest" = list(
				/obj/item/reagent_containers/glass/cup/carved/porcelain = 2,
				/obj/item/reagent_containers/glass/bowl/carved/porcelain = 2,
				/obj/item/kitchen/spoon/carved/porcelain = 2,
				/obj/item/kitchen/fork/carved/porcelain = 2,
				/obj/item/cooking/platter/carved/porcelain = 1,
			)
		),
		"manor_bread" = list(
			"category" = "Провизия",
			"material" = "flour",
			"cost" = 4,
			"item_type" = /obj/item/reagent_containers/food/snacks/rogue/bread,
			"batch_size" = 4,
		),
		"manor_buns" = list(
			"category" = "Провизия",
			"material" = "flour",
			"cost" = 2,
			"item_type" = /obj/item/reagent_containers/food/snacks/rogue/bun,
			"batch_size" = 4,
		),
		"manor_salami" = list(
			"category" = "Провизия",
			"material" = "preserved_pork",
			"cost" = 8,
			"item_type" = \
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami,
			"batch_size" = 4,
		),
		"manor_smoked_ham" = list(
			"category" = "Провизия",
			"material" = "preserved_pork",
			"cost" = 6,
			"item_type" = \
				/obj/item/reagent_containers/food/snacks/rogue/meat/ham/smoked,
			"batch_size" = 2,
		),
		"manor_wheat_beer" = list(
			"category" = "Напитки",
			"material" = "wheat_wort",
			"cost" = 6,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_wheat_beer,
			"batch_size" = 6,
		),
		"manor_oat_ale" = list(
			"category" = "Напитки",
			"material" = "oat_wort",
			"cost" = 6,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_oat_ale,
			"batch_size" = 6,
		),
		"manor_jack_wine_regular" = list(
			"category" = "Напитки",
			"material" = "jack_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine/regular,
			"batch_size" = 3,
		),
		"manor_jack_wine" = list(
			"category" = "Напитки",
			"material" = "jack_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine,
			"batch_size" = 2,
		),
		"manor_jack_wine_delectable" = list(
			"category" = "Напитки",
			"material" = "jack_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine/delectable,
		),
		"manor_plum_wine_regular" = list(
			"category" = "Напитки",
			"material" = "plum_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine/regular,
			"batch_size" = 3,
		),
		"manor_plum_wine" = list(
			"category" = "Напитки",
			"material" = "plum_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine,
			"batch_size" = 2,
		),
		"manor_plum_wine_delectable" = list(
			"category" = "Напитки",
			"material" = "plum_must",
			"cost" = 4,
			"item_type" = \
				/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine/delectable,
		),
		"manor_leather_vest" = list(
			"category" = "Одежда",
			"material" = "leatherwork",
			"cost" = 2,
			"item_type" = /obj/item/clothing/suit/roguetown/armor/leather/vest,
		),
		"manor_leather_boots" = list(
			"category" = "Одежда",
			"material" = "leatherwork",
			"cost" = 2,
			"item_type" = /obj/item/clothing/shoes/roguetown/boots/leather,
		),
		"manor_leather_belt" = list(
			"category" = "Одежда",
			"material" = "leatherwork",
			"cost" = 1,
			"item_type" = /obj/item/storage/belt/rogue/leather,
		),
		"manor_venard_trophy" = list(
			"category" = "Трофеи",
			"material" = "taxidermy",
			"cost" = 2,
			"item_type" = /obj/item/manor_venard_trophy,
		),
		"manor_shell_ring" = list(
			"category" = "Украшения",
			"material" = "shellwork",
			"cost" = 1,
			"item_type" = /obj/item/clothing/ring/shell,
		),
		"manor_shell_cameo" = list(
			"category" = "Украшения",
			"material" = "shellwork",
			"cost" = 1,
			"item_type" = /obj/item/carvedgem/shell/cameo,
		),
		"manor_pearl_necklace" = list(
			"category" = "Украшения",
			"material" = "pearls",
			"cost" = 3,
			"item_type" = /obj/item/clothing/neck/roguetown/psicross/pearl,
		),
	)
	return catalogue

/datum/trade_good/manor_prepared_clay
	id = TRADE_GOOD_MANOR_PREPARED_CLAY
	name = "Prepared Clay"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 4
	importable = FALSE
	item_type = /obj/item/natural/clay/manor_prepared

/datum/roguestock/stockpile/manor_prepared_clay
	name = "Prepared Clay"
	item_type = /obj/item/natural/clay/manor_prepared
	trade_good_id = TRADE_GOOD_MANOR_PREPARED_CLAY
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_flour
	id = TRADE_GOOD_MANOR_FLOUR
	name = "Flour"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 3
	importable = FALSE
	item_type = /obj/item/reagent_containers/powder/flour

/datum/roguestock/stockpile/manor_flour
	name = "Flour"
	item_type = /obj/item/reagent_containers/powder/flour
	trade_good_id = TRADE_GOOD_MANOR_FLOUR
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_salted_pork
	id = TRADE_GOOD_MANOR_SALTED_PORK
	name = "Salted Pork"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 7
	importable = FALSE
	item_type = \
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/manor_salted

/datum/roguestock/stockpile/manor_salted_pork
	name = "Salted Pork"
	item_type = \
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/manor_salted
	trade_good_id = TRADE_GOOD_MANOR_SALTED_PORK
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_wheat_wort
	id = TRADE_GOOD_MANOR_WHEAT_WORT
	name = "Wheat Brewing Mash"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 3
	importable = FALSE
	item_type = \
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_wheat

/datum/roguestock/stockpile/manor_wheat_wort
	name = "Wheat Brewing Mash"
	item_type = \
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_wheat
	trade_good_id = TRADE_GOOD_MANOR_WHEAT_WORT
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_oat_wort
	id = TRADE_GOOD_MANOR_OAT_WORT
	name = "Oat Brewing Mash"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 3
	importable = FALSE
	item_type = \
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_oat

/datum/roguestock/stockpile/manor_oat_wort
	name = "Oat Brewing Mash"
	item_type = \
		/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_oat
	trade_good_id = TRADE_GOOD_MANOR_OAT_WORT
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_jack_must
	id = TRADE_GOOD_MANOR_JACK_MUST
	name = "Jackberry Must"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 5
	importable = FALSE
	item_type = \
		/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_must

/datum/roguestock/stockpile/manor_jack_must
	name = "Jackberry Must"
	item_type = \
		/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_must
	trade_good_id = TRADE_GOOD_MANOR_JACK_MUST
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_plum_must
	id = TRADE_GOOD_MANOR_PLUM_MUST
	name = "Plum Must"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 5
	importable = FALSE
	item_type = \
		/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_must

/datum/roguestock/stockpile/manor_plum_must
	name = "Plum Must"
	item_type = \
		/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_must
	trade_good_id = TRADE_GOOD_MANOR_PLUM_MUST
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_fox_pelt
	id = TRADE_GOOD_MANOR_FOX_PELT
	name = "Venard Pelt"
	category = TRADE_CATEGORY_ARTISAN
	behavior = TRADE_BEHAVIOR_RAW
	base_price = 6
	importable = FALSE
	item_type = /obj/item/natural/fur/fox

/datum/roguestock/stockpile/manor_fox_pelt
	name = "Venard Pelt"
	item_type = /obj/item/natural/fur/fox
	trade_good_id = TRADE_GOOD_MANOR_FOX_PELT
	stockpile_limit = 20
	importexport_amt = 5
	category = "Resources"

/datum/trade_good/manor_prepared_pelt
	id = TRADE_GOOD_MANOR_PREPARED_PELT
	name = "Prepared Venard Pelt"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 9
	importable = FALSE
	item_type = /obj/item/natural/fur/fox/manor_prepared

/datum/roguestock/stockpile/manor_prepared_pelt
	name = "Prepared Venard Pelt"
	item_type = /obj/item/natural/fur/fox/manor_prepared
	trade_good_id = TRADE_GOOD_MANOR_PREPARED_PELT
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_oyster
	id = TRADE_GOOD_MANOR_OYSTER
	name = "Oyster"
	category = TRADE_CATEGORY_GEM_COMMON
	behavior = TRADE_BEHAVIOR_RAW
	base_price = 4
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/fish/oyster

/datum/roguestock/stockpile/manor_oyster
	name = "Oyster"
	item_type = /obj/item/reagent_containers/food/snacks/fish/oyster
	trade_good_id = TRADE_GOOD_MANOR_OYSTER
	stockpile_limit = 20
	importexport_amt = 5
	category = "Resources"

/datum/trade_good/manor_shell
	id = TRADE_GOOD_MANOR_SHELL
	name = "Clamshell"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 4
	importable = FALSE
	item_type = /obj/item/carvedgem/shell/rawshell

/datum/roguestock/stockpile/manor_shell
	name = "Clamshell"
	item_type = /obj/item/carvedgem/shell/rawshell
	trade_good_id = TRADE_GOOD_MANOR_SHELL
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_pearl
	id = TRADE_GOOD_MANOR_PEARL
	name = "Pearl"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 9
	importable = FALSE
	item_type = /obj/item/pearl

/datum/roguestock/stockpile/manor_pearl
	name = "Pearl"
	item_type = /obj/item/pearl
	trade_good_id = TRADE_GOOD_MANOR_PEARL
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/obj/item/natural/clay/manor_prepared
	name = "prepared clay"

/obj/item/natural/fur/fox/manor_prepared
	name = "prepared venard pelt"

/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/manor_salted
	name = "salted pork"

/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_wheat
	name = "wheat brewing mash"

/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass/manor_oat
	name = "oat brewing mash"

/obj/item/manor_venard_trophy
	name = "mounted venard trophy"
	desc = "A prepared venard pelt arranged on a display board."
	icon = 'icons/roguetown/items/bounty_heads.dmi'
	icon_state = "foxhead"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_must
	name = "bottle of jackberry must"
	list_reagents = list(/datum/reagent/consumable/juice/jackberry = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_must
	name = "bottle of plum must"
	list_reagents = list(/datum/reagent/consumable/juice/plum = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_wheat_beer
	name = "brewer's bottle of wheat beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_oat_ale
	name = "brewer's bottle of oat ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/ale = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine
	name = "brewer's bottle of aged jackberry wine"
	list_reagents = list(
		/datum/reagent/consumable/ethanol/jackberrywine/aged = 33
	)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine/regular
	name = "brewer's bottle of jackberry wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/jackberrywine = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_jack_wine/delectable
	name = "brewer's bottle of delectably aged jackberry wine"
	list_reagents = list(
		/datum/reagent/consumable/ethanol/jackberrywine/delectable = 33
	)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine
	name = "brewer's bottle of aged umeshu wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/plum_wine/aged = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine/regular
	name = "brewer's bottle of umeshu wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/plum_wine = 33)

/obj/item/reagent_containers/glass/bottle/brewing_bottle/manor_plum_wine/delectable
	name = "brewer's bottle of delectably aged umeshu wine"
	list_reagents = list(
		/datum/reagent/consumable/ethanol/plum_wine/delectable = 33
	)

/datum/trade_good/manor_plank
	id = TRADE_GOOD_MANOR_PLANK
	name = "Plank"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 2
	importable = FALSE
	item_type = /obj/item/natural/wood/plank

/datum/roguestock/stockpile/manor_plank
	name = "Plank"
	item_type = /obj/item/natural/wood/plank
	trade_good_id = TRADE_GOOD_MANOR_PLANK
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

/datum/trade_good/manor_stick
	id = TRADE_GOOD_MANOR_STICK
	name = "Stick"
	category = TRADE_CATEGORY_INTERMEDIARY
	behavior = TRADE_BEHAVIOR_INTERMEDIARY
	base_price = 1
	importable = FALSE
	item_type = /obj/item/grown/log/tree/stick

/datum/roguestock/stockpile/manor_stick
	name = "Stick"
	item_type = /obj/item/grown/log/tree/stick
	trade_good_id = TRADE_GOOD_MANOR_STICK
	stockpile_limit = 20
	importexport_amt = 5
	category = "Refined"

#undef TRADE_GOOD_MANOR_PREPARED_CLAY
#undef TRADE_GOOD_MANOR_FLOUR
#undef TRADE_GOOD_MANOR_SALTED_PORK
#undef TRADE_GOOD_MANOR_WHEAT_WORT
#undef TRADE_GOOD_MANOR_OAT_WORT
#undef TRADE_GOOD_MANOR_JACK_MUST
#undef TRADE_GOOD_MANOR_PLUM_MUST
#undef TRADE_GOOD_MANOR_FOX_PELT
#undef TRADE_GOOD_MANOR_PREPARED_PELT
#undef TRADE_GOOD_MANOR_OYSTER
#undef TRADE_GOOD_MANOR_SHELL
#undef TRADE_GOOD_MANOR_PEARL
#undef TRADE_GOOD_MANOR_PLANK
#undef TRADE_GOOD_MANOR_STICK
#undef TRADE_GOOD_MANOR_BANANA
#undef TRADE_GOOD_MANOR_WATERMELON
