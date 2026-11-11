/datum/unit_test/manor_review/Run()
	checkCatalogue()
	checkReachableMaterials()
	checkGoods()
	checkRefining()
	checkYieldRemainders()
	checkProductionSchedule()

/datum/unit_test/manor_review/proc/checkCatalogue()
	var/datum/manor/smith = allocateDatum(/datum/manor)
	smith.manor_type = "mining_settlement"
	smith.industry_specialization = "smith"
	var/list/raw_goods = list(
		TRADE_GOOD_IRON_ORE, TRADE_GOOD_GOLD_ORE,
		TRADE_GOOD_SILVER_ORE, TRADE_GOOD_WOOD, TRADE_GOOD_FIBERS,
		TRADE_GOOD_CLAY,
	)
	smith.industry_materials = taManorProfileMaterials(
		smith.manor_type, "smith", raw_goods, TRUE)
	var/list/smith_catalogue = smith.buildEstateWorkshopCatalogue(
		smith.industry_materials)
	var/datum/manor/jeweler = allocateDatum(/datum/manor)
	jeweler.manor_type = "mining_settlement"
	jeweler.industry_specialization = "jewelry"
	jeweler.industry_materials = taManorProfileMaterials(
		jeweler.manor_type, "jewelry", raw_goods, FALSE)
	var/list/jeweler_catalogue = jeweler.buildEstateWorkshopCatalogue(
		jeweler.industry_materials)
	var/list/metal_products = list(
		/datum/anvil_recipe/tools/gold/cups,
		/datum/anvil_recipe/tools/silver/cups,
		/datum/anvil_recipe/valuables/ringg,
		/datum/anvil_recipe/valuables/rings,
	)
	for(var/recipe_type in metal_products)
		var/list/forged = findRecipe(smith_catalogue, recipe_type)
		var/list/jeweled = findRecipe(jeweler_catalogue, recipe_type)
		TEST_ASSERT(forged && jeweled, "Both trades know [recipe_type]")
		TEST_ASSERT_EQUAL(forged["cost"], jeweled["cost"], recipe_type)
		var/list/manifest = getManorRecipeManifest(jeweled)
		TEST_ASSERT_EQUAL(manifest[jeweled["item_type"]], 3, \
			"The normal three-piece batch must be preserved")

	var/list/table_set = jeweler_catalogue["manor_silver_set"]
	// Two cups, bowls, forks, spoons and one platter cost 4.5 silver bars.
	TEST_ASSERT_EQUAL(table_set?["cost"], 36, \
		"The table set is priced from its normal recipe yields")
	var/list/porcelain_set = jeweler_catalogue["manor_porcelain_set"]
	TEST_ASSERT_EQUAL(porcelain_set?["value"], 9 * SELLPRICE_CLAY, \
		"The porcelain set accounts for all nine clay items")
	var/list/spoon = findRecipe(jeweler_catalogue,
		/datum/crafting_recipe/roguetown/ceramics/clayspoon)
	TEST_ASSERT_EQUAL(spoon?["item_type"], \
		/obj/item/kitchen/spoon/carved/porcelain, \
		"A ceramics order supplies finished tableware")
	var/list/arrows = findRecipe(smith_catalogue,
		/datum/anvil_recipe/weapons/iron/arrows)
	TEST_ASSERT(arrows, "Wood must supply arrow shafts inside the workshop")
	var/list/arrow_batch = getManorRecipeManifest(arrows)
	TEST_ASSERT_EQUAL(arrow_batch[arrows["item_type"]], ARROW_SMITH_BATCH, \
		"The normal arrow batch is preserved")
	TEST_ASSERT_EQUAL(arrows["cost"], \
		(ceil((SELLPRICE_IRON_INGOT + 2 * SELLPRICE_WOOD / 3) \
			/ SELLPRICE_IRON_INGOT)), \
		"The point price includes two shafts cut from wood")
	TEST_ASSERT(!taManorIsRefiningMaterial(smith.industry_materials, \
		"sticks"), "Arrow shafts must not appear in the smeltery")
	TEST_ASSERT(!taManorIsRefiningMaterial(smith.industry_materials, \
		"cloth"), "Lining must not appear in the smeltery")

	var/list/component_recipes = getManorWorkshopRecipes()
	var/list/cloth = findRecipe(component_recipes,
		/datum/crafting_recipe/roguetown/survival/cloth)
	TEST_ASSERT(cloth?["hidden"], "Cloth is a hidden workshop component")
	var/list/material_types = list("fibers" = /obj/item/natural/fibers)
	var/list/material_costs = list(
		"fibers" = list("material" = "fibers", "value" = SELLPRICE_FIBERS))
	var/list/cloth_cost = smith.resolveEstateWorkshopCost(
		cloth, material_types, material_costs, list())
	TEST_ASSERT_EQUAL(cloth_cost?["value"], 2 * SELLPRICE_FIBERS, \
		"Cloth lining accounts for both fibers")

	var/list/without_wood = smith.buildEstateWorkshopCatalogue(
		taManorProfileMaterials("mining_settlement", "smith",
			list(TRADE_GOOD_IRON_ORE), FALSE))
	TEST_ASSERT(!findRecipe(without_wood, \
		/datum/anvil_recipe/weapons/iron/arrows), \
		"Arrow shafts still require a real source of wood")

/datum/unit_test/manor_review/proc/findRecipe(list/catalogue, recipe_type)
	for(var/id in catalogue)
		var/list/entry = catalogue[id]
		if(entry["recipe_type"] == recipe_type)
			return entry
	return null

/datum/unit_test/manor_review/proc/checkReachableMaterials()
	for(var/manor_type in taManorTypeNames())
		for(var/specialization in getManorProductionLanes(manor_type))
			var/list/raw_goods = getManorReachableRawGoods(
				manor_type, "big", specialization)
			var/list/materials = taManorProfileMaterials(
				manor_type, specialization, raw_goods, TRUE)
			for(var/material in materials)
				var/list/recipe = materials[material]
				for(var/good_id in recipe["inputs"])
					TEST_ASSERT(good_id in raw_goods, \
						"Every refining or direct material has a real source")
			var/datum/manor/estate = allocateDatum(/datum/manor)
			estate.manor_type = manor_type
			estate.manor_size = "big"
			estate.industry_specialization = specialization
			estate.industry_materials = materials
			var/list/catalogue = estate.getEstateWorkshopCatalogue()
			for(var/id in catalogue)
				var/list/entry = catalogue[id]
				TEST_ASSERT(!entry["locked"], \
					"All actual sources unlock the entire visible catalogue")

	var/list/jeweler_raw = getManorReachableRawGoods(
		"mining_settlement", "big", "jewelry")
	var/list/jeweler_materials = taManorProfileMaterials(
		"mining_settlement", "jewelry", jeweler_raw, TRUE)
	TEST_ASSERT(!jeweler_materials["raw_[TRADE_GOOD_GLASS_BATCH]"], \
		"Glass Batch has no source in a mining settlement")
	var/list/small_raw = getManorReachableRawGoods(
		"mining_settlement", "small", "jewelry")
	TEST_ASSERT(!(TRADE_GOOD_GOLD_ORE in small_raw), \
		"An unaffordable upgrade is not a reachable source")
	var/list/naledi_raw = getManorReachableRawGoods(
		"mining_settlement", "small", "jewelry", /datum/virtue/origin/naledi)
	TEST_ASSERT(TRADE_GOOD_GOLD_ORE in naledi_raw, \
		"The Naledi price reduction makes gold reachable")

/datum/unit_test/manor_review/proc/checkGoods()
	var/list/goods = list(
		TRADE_GOOD_HONEY = /datum/roguestock/stockpile/honey,
		TRADE_GOOD_MUSHROOM = /datum/roguestock/stockpile/mushroom,
		TRADE_GOOD_ROPE = /datum/roguestock/stockpile/manor_rope,
		TRADE_GOOD_MANOR_VENISON = /datum/roguestock/stockpile/deer,
		TRADE_GOOD_MANOR_BUSHMEAT = /datum/roguestock/stockpile/volf,
		TRADE_GOOD_MANOR_BEAR_MEAT = /datum/roguestock/stockpile/bear,
		TRADE_GOOD_MANOR_CRAB_MEAT = /datum/roguestock/stockpile/crabbo,
		TRADE_GOOD_MANOR_BOAR_HAM = /datum/roguestock/stockpile/boarham,
	)
	var/datum/manor/estate = allocateDatum(/datum/manor)
	var/obj/structure/roguemachine/ship_fulfillment/market = allocate(
		/obj/structure/roguemachine/ship_fulfillment)
	estate.warehouse_raw_sale = 0
	estate.warehouse_processed_sale = 0
	for(var/good_id in goods)
		var/datum/trade_good/good = GLOB.trade_goods[good_id]
		var/datum/roguestock/stock = SSeconomy.find_stockpile_by_trade_good(
			good_id)
		TEST_ASSERT(good && stock, "[good_id] has both registry entries")
		TEST_ASSERT_EQUAL(stock.type, goods[good_id], \
			"The good resolves to its intended stockpile")
		TEST_ASSERT_EQUAL(good.item_type, stock.item_type, \
			"The physical delivery matches the stockpile")
		var/obj/item/product = allocate(good.item_type)
		TEST_ASSERT(stock.check_item(product), \
			"The stockpile accepts its physical product")
		TEST_ASSERT_EQUAL(market.identify_trade_good(product), good_id, \
			"The physical item resolves back to its own trade good")
		TEST_ASSERT_EQUAL(market.identify_trade_good_for_type(product.type), \
			good_id, "The item type resolves to the same trade good")
		var/stock_matches = 0
		for(var/datum/roguestock/candidate in SStreasury.stockpile_datums)
			if(candidate.trade_good_id == good_id)
				stock_matches++
		TEST_ASSERT_EQUAL(stock_matches, 1, "No duplicate stockpile ID")
		TEST_ASSERT(!good.importable, "No new merchant import is introduced")
		TEST_ASSERT_EQUAL(estate.storeWarehouseShare(good_id, 2), 2, \
			"A fully retained good reaches the warehouse")

	var/list/legacy = list(TRADE_GOOD_MEAT_EXOTIC)
	var/list/sites = list(
		"hunt" = TRADE_GOOD_MANOR_VENISON,
		"farm" = TRADE_GOOD_MANOR_BOAR_HAM,
		"fish" = TRADE_GOOD_MANOR_CRAB_MEAT,
	)
	for(var/site in sites)
		var/list/migrated = migrateManorResourceChoices(legacy, site)
		TEST_ASSERT_EQUAL(migrated[1], sites[site], \
			"The legacy resource keeps the same estate meaning")
	TEST_ASSERT_EQUAL(legacy[1], TRADE_GOOD_MEAT_EXOTIC, \
		"Migration must not modify the saved source list")
	var/list/old_plan = list(
		"resource_unlocks" = list("hunt" = legacy),
		"resource_pool" = list("hunt" = legacy),
	)
	var/list/new_plan = taSanitizeManorIndustryProfile(
		"small", old_plan, "hunter_mansion")
	var/list/unlocks = new_plan["resource_unlocks"]
	var/list/focus = new_plan["resource_pool"]
	TEST_ASSERT(TRADE_GOOD_MANOR_VENISON in unlocks["hunt"], \
		"The old purchased resource survives profile sanitization")
	TEST_ASSERT(TRADE_GOOD_MANOR_VENISON in focus["hunt"], \
		"The old harvesting priority survives profile sanitization")

/datum/unit_test/manor_review/proc/checkRefining()
	var/list/raw_goods = list(TRADE_GOOD_GOLD_ORE, TRADE_GOOD_SILVER_ORE)
	for(var/specialization in list("smith", "jewelry"))
		var/list/materials = taManorProfileMaterials(
			"mining_settlement", specialization, raw_goods, FALSE)
		for(var/material in materials)
			var/list/recipe = materials[material]
			var/list/inputs = recipe["inputs"]
			TEST_ASSERT_EQUAL(inputs[inputs[1]], 1, \
				"Precious ores use the ordinary one-to-one smelting ratio")

	var/datum/manor/estate = allocateDatum(/datum/manor)
	estate.industry_active = TRUE
	estate.industry_specialization = "tailoring"
	estate.industry_processing = allocateDatum(
		/datum/workstation/manor_craft/processing)
	estate.industry_workshop = allocateDatum(
		/datum/workstation/manor_craft/workshop)
	estate.industry_processing.workers_employed = 1
	estate.industry_processing.material = "rope"
	estate.industry_materials = taManorProfileMaterials(
		"hunter_mansion", "tailoring", list(TRADE_GOOD_FIBERS), FALSE)
	estate.warehouse_processed_sale = 0
	var/list/fresh = list(TRADE_GOOD_FIBERS = 3)
	var/list/settlement = estate.processManorProduction(fresh)
	TEST_ASSERT_EQUAL(fresh[TRADE_GOOD_FIBERS], 0, "Three fibers are used")
	TEST_ASSERT_EQUAL(settlement?["refined_units"], 1, \
		"One rope remains when the workshop has no workers")
	var/datum/roguestock/rope_stock = SSeconomy.find_stockpile_by_trade_good(
		settlement["refined_good"])
	estate.settleGoodsLot(rope_stock, rope_stock.type,
		settlement["refined_units"], FALSE, list(), list(), TRUE)
	TEST_ASSERT_EQUAL(estate.warehouse_stock[TRADE_GOOD_ROPE], 1, \
		"Unused rope is retained instead of disappearing")

/datum/unit_test/manor_review/proc/checkYieldRemainders()
	for(var/multiplier in list(1, 1.05, 1.1))
		var/datum/workstation/mine = allocateDatum(/datum/workstation)
		var/total = 0
		for(var/cycle in 1 to 20)
			for(var/amount in list(0, 1, 2))
				total += mine.applyManorYieldModifier(
					TRADE_GOOD_IRON_ORE, amount, multiplier)
		TEST_ASSERT_EQUAL(total, round(60 * multiplier + 0.5), \
			"The actual yield preserves the percentage bonus")
	var/datum/workstation/field = allocateDatum(/datum/workstation)
	var/harvest = 0
	for(var/cycle in 1 to 20)
		for(var/amount in list(1, 2, 3))
			harvest += field.applyManorYieldModifier(
				TRADE_GOOD_GRAIN,
				amount,
				0.8
			)
	TEST_ASSERT_EQUAL(harvest, 96, "Noc's field penalty really removes 20%")
	var/datum/workstation/separate = allocateDatum(/datum/workstation)
	TEST_ASSERT_EQUAL(separate.applyManorYieldModifier( \
		TRADE_GOOD_IRON_ORE, 1, 0.5), 0, "Half an iron unit waits")
	TEST_ASSERT_EQUAL(separate.applyManorYieldModifier( \
		TRADE_GOOD_GOLD_ORE, 1, 0.5), 0, "Iron credit cannot create gold")
	TEST_ASSERT_EQUAL(separate.applyManorYieldModifier( \
		TRADE_GOOD_IRON_ORE, 1, 0.5), 1, "Two halves produce one iron unit")

/datum/unit_test/manor_review/proc/checkProductionSchedule()
	var/mob/living/carbon/human/owner = allocate(/mob/living/carbon/human)
	owner.mind_initialize()
	owner.manor_type_pref = "mining_settlement"
	for(var/specialization in list("smith", "jewelry"))
		owner.manor_industry_profiles = list(
			"mining_settlement" = list(
				"small" = list("specialization" = specialization)
			)
		)
		var/datum/manor/estate = allocateDatum(/datum/manor)
		owner.mind.set_owned_manor(estate)
		estate.on_creation(owner)
		allocated += estate.workstations
		TEST_ASSERT(estate.industry_active, \
			"The normal estate setup enables production")
		TEST_ASSERT_EQUAL(estate.industry_specialization, specialization, \
			"The saved specialization survives estate creation")
		estate.patron = /datum/patron/inhumen/zizo
		estate.treasury_retention = 100
		var/list/dawn = estate.produce_resources(owner, TRUE, FALSE)
		TEST_ASSERT(dawn && estate.industrySettledToday(), \
			"The first cycle settles daily processing")
		var/list/dusk = estate.produce_resources(owner, FALSE, TRUE)
		TEST_ASSERT(dusk, "Both specialties retain Zizo's second harvest")
		TEST_ASSERT(!estate.processManorProduction(list()), \
			"Daily processing still cannot run twice")
		TEST_ASSERT(!estate.produce_resources(owner, FALSE, TRUE), \
			"The same harvest phase cannot be replayed")

/datum/unit_test/manor_review/proc/allocateDatum(datum_type)
	var/datum/instance = new datum_type
	allocated += instance
	return instance
