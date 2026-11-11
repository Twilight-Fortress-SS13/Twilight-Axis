#define MANOR_INDUSTRY_DAILY_CAPACITY 3
#define MANOR_YIELD_PRECISION 1000

/datum/manor
	var/industry_origin_type
	var/list/industry_order_catalogue
	var/industry_active = FALSE
	var/datum/workstation/mining/industry_mine
	var/datum/workstation/manor_smeltery/industry_smeltery
	var/datum/workstation/manor_forge/industry_forge
	var/datum/workstation/manor_craft/processing/industry_processing
	var/datum/workstation/manor_craft/workshop/industry_workshop
	var/industry_specialization
	var/list/industry_materials
	var/list/industry_last_production
	var/industry_peasants = 0
	var/industry_artisans = 0
	var/industry_steel_unlocked = FALSE
	var/industry_mining_priority
	var/industry_smeltery_metal = "iron"
	var/industry_forge_metal = "iron"
	var/industry_revision = 0
	var/industry_last_day
	var/industry_last_ore = 0
	var/industry_last_ingots = 0
	var/industry_last_forged_ingots = 0
	var/industry_last_points = 0
	var/industry_last_sold_ore = 0
	var/industry_last_stored_ore = 0
	var/industry_last_smeltery_metal = "iron"
	var/industry_last_forge_metal = "iron"
	var/industry_points = 0
	var/industry_point_remainder = 0

/datum/workstation/manor_smeltery
	workstation_name = "Плавильня"
	workstation_theme = "smeltery"
	type_of_produce = "Processing"

/datum/workstation/manor_forge
	workstation_name = "Кузница"
	workstation_theme = "forge"
	type_of_produce = "Manufacturing"

/datum/workstation/manor_craft
	var/material

/datum/workstation/manor_craft/processing
	workstation_theme = "industry_processing"
	type_of_produce = "Processing"

/datum/workstation/manor_craft/workshop
	workstation_theme = "industry_workshop"
	type_of_produce = "Manufacturing"

/datum/workstation
	var/list/manor_resource_focus
	var/list/manor_yield_remainders = list()

// Carry fractional yield per good so small lots retain percentage bonuses.
/datum/workstation/proc/applyManorYieldModifier(good_id, units, multiplier)
	var/credit = round(units * multiplier * MANOR_YIELD_PRECISION + 0.5)
	credit += manor_yield_remainders[good_id] || 0
	var/whole_units = FLOOR(credit / MANOR_YIELD_PRECISION, 1)
	manor_yield_remainders[good_id] = credit % MANOR_YIELD_PRECISION
	return whole_units

/datum/roguestock/stockpile/manor_toper
	name = "Toper"
	trade_good_id = TRADE_GOOD_TOPER
	item_type = /obj/item/roguegem/yellow
	category = "Gems"

/datum/roguestock/stockpile/manor_gemerald
	name = "Gemerald"
	trade_good_id = TRADE_GOOD_GEMERALD
	item_type = /obj/item/roguegem/green
	category = "Gems"

/datum/roguestock/stockpile/manor_jade
	name = "Jade"
	trade_good_id = TRADE_GOOD_JADE
	item_type = /obj/item/roguegem/jade
	category = "Gems"

/datum/roguestock/stockpile/manor_saffira
	name = "Saffira"
	trade_good_id = TRADE_GOOD_SAFFIRA
	item_type = /obj/item/roguegem/violet
	category = "Gems"

/datum/roguestock/stockpile/manor_opal
	name = "Opal"
	trade_good_id = TRADE_GOOD_OPAL
	item_type = /obj/item/roguegem/opal
	category = "Gems"

/datum/roguestock/stockpile/manor_dorpel
	name = "Dorpel"
	trade_good_id = TRADE_GOOD_DORPEL
	item_type = /obj/item/roguegem/diamond
	category = "Gems"

/datum/roguestock/stockpile/manor_amber
	name = "Amber"
	trade_good_id = TRADE_GOOD_AMBER
	item_type = /obj/item/roguegem/amber
	category = "Gems"

/proc/taManorSmithMaterials()
	var/static/list/materials = list(
		"iron" = list(
			"label" = "Iron Ingot",
			"inputs" = list(TRADE_GOOD_IRON_ORE = 1),
			"refined_good" = TRADE_GOOD_IRON_INGOT,
		),
		"steel" = list(
			"label" = "Steel Ingot",
			"inputs" = list(TRADE_GOOD_IRON_ORE = 1),
			"refined_good" = TRADE_GOOD_STEEL_INGOT,
			"points_per_unit" = 2,
			"requires_steel" = TRUE,
		),
		"copper" = list(
			"label" = "Copper Ingot",
			"inputs" = list(TRADE_GOOD_COPPER_ORE = 1),
			"refined_good" = TRADE_GOOD_COPPER_INGOT,
		),
		"tin" = list(
			"label" = "Tin Ingot",
			"inputs" = list(TRADE_GOOD_TIN_ORE = 1),
			"refined_good" = TRADE_GOOD_TIN_INGOT,
		),
		"bronze" = list(
			"label" = "Bronze Ingot",
			"inputs" = list(TRADE_GOOD_COPPER_ORE = 1, TRADE_GOOD_TIN_ORE = 1),
			"refined_good" = TRADE_GOOD_BRONZE_INGOT,
		),
		"gold" = list(
			"label" = "Gold Ingot",
			"inputs" = list(TRADE_GOOD_GOLD_ORE = 1),
			"refined_good" = TRADE_GOOD_GOLD_INGOT,
		),
		"silver" = list(
			"label" = "Silver Ingot",
			"inputs" = list(TRADE_GOOD_SILVER_ORE = 1),
			"refined_good" = TRADE_GOOD_SILVER_INGOT,
		),
	)
	return materials

/proc/getManorReachableRawGoods(manor_type, size, specialization, origin_type)
	var/list/limits = taManorIndustryLimits(size)
	var/list/goods = list()
	if(!limits)
		return goods
	for(
		var/list/station in taManorRawWorkstations(
			manor_type,
			size,
			origin_type
		)
	)
		for(var/list/resource in station["resources"])
			if(
				taManorResourceIsFree(resource, specialization) \
				|| resource["cost"] <= limits["points"]
			)
				goods |= resource["id"]
	return goods

/proc/taManorProfileMaterials(
	manor_type,
	specialization,
	list/available_raw,
	steel_unlocked
)
	var/list/lanes = getManorProductionLanes(manor_type)
	var/list/lane = lanes?[specialization]
	var/list/candidates = specialization == "smith" ? taManorSmithMaterials() \
		: lane?["materials"]
	var/list/extra_materials = getManorAdditionalMaterials(
		manor_type,
		specialization
	)
	if(length(extra_materials))
		candidates = (candidates || list()) + extra_materials
	var/list/materials = list()
	for(var/id in candidates)
		var/list/recipe = candidates[id]
		if(recipe["requires_steel"] && !steel_unlocked)
			continue
		var/list/inputs = recipe["inputs"]
		var/reachable = TRUE
		if(islist(available_raw))
			for(var/good_id in inputs)
				if(!(good_id in available_raw))
					reachable = FALSE
					break
		var/ready_good = recipe["refined_good"]
		if(!reachable && !recipe["direct"] && (ready_good in available_raw))
			var/list/ready_inputs = list()
			ready_inputs[ready_good] = 1
			recipe = recipe.Copy()
			recipe["direct"] = TRUE
			recipe["inputs"] = ready_inputs
			reachable = TRUE
		if(reachable)
			materials[id] = recipe
	return materials

/proc/taManorIsRefiningMaterial(list/materials, material)
	if(!istext(material))
		return FALSE
	var/list/recipe = materials?[material]
	return !!recipe && !recipe["direct"]

/proc/taManorFirstRefiningMaterial(list/materials)
	for(var/material in materials)
		if(taManorIsRefiningMaterial(materials, material))
			return material
	return null

/datum/manor/proc/getIndustryRawGoods()
	var/list/goods = list()
	for(var/datum/workstation/station in workstations)
		for(var/stock_path in station.produce)
			var/datum/roguestock/stockpile/stock = stock_path
			var/good_id = stock::trade_good_id
			if(good_id)
				goods |= good_id
	return goods

/datum/manor/proc/applyIndustryProfile(mob/living/carbon/human/owner)
	industry_origin_type = owner?.mind?.ta_nobility_origin_type \
		|| owner?.client?.prefs?.virtue_origin?.type || virtue_origin?.type
	industry_order_catalogue = null
	var/list/profiles = owner?.manor_industry_profiles
	var/list/type_profiles = profiles?[manor_type]
	if(manor_type == "mining_settlement" && !islist(type_profiles))
		type_profiles = profiles
	var/list/saved_profile = type_profiles?[manor_size]
	var/list/profile = taSanitizeManorIndustryProfile(
		manor_size,
		islist(saved_profile) ? saved_profile : list(),
		manor_type,
		industry_origin_type
	)
	if(!profile)
		return FALSE

	var/list/limits = taManorIndustryLimits(manor_size)
	industry_specialization = profile["specialization"]
	industry_artisans = profile["artisans"]
	industry_peasants = taManorPeasantCount(limits, industry_artisans)
	var/list/raw_workers = profile["raw_workers"]
	var/list/resource_unlocks = profile["resource_unlocks"]
	var/list/resource_pool = profile["resource_pool"]
	for(var/datum/workstation/station in workstations)
		var/site = station.workstation_theme
		station.workers_employed = raw_workers[site] || 0
		if(
			manor_type == "mining_settlement" \
			&& istype(station, /datum/workstation/mining)
		)
			industry_mine = station
			station.workstation_size += 5 * profile["expand_mine"]
		var/list/options = taManorWorkstationResources(
			manor_type,
			site,
			station.produce,
			industry_origin_type
		)
		var/list/unlocks = resource_unlocks[site]
		for(var/good_id in options)
			var/list/option = options[good_id]
			if(
				!option["base"] \
				&& (
					taManorResourceIsFree(option, industry_specialization) \
					|| (unlocks && (good_id in unlocks))
				)
			)
				station.produce = station.produce + option["stock_path"]
		station.manor_resource_focus = resource_pool[site]

	industry_steel_unlocked = profile["unlock_steel"]
	industry_materials = taManorProfileMaterials(
		manor_type,
		industry_specialization,
		getIndustryRawGoods(),
		industry_steel_unlocked
	)

	var/workshop_capacity = min(
		industry_artisans,
		limits["finishers"] + profile["expand_forge"]
	)
	if(industry_specialization == "smith")
		industry_smeltery_metal = profile["smeltery_metal"]
		industry_forge_metal = profile["forge_metal"]
		industry_smeltery = new
		industry_smeltery.workstation_size = industry_artisans
		industry_smeltery.workers_employed = profile["smelters"]
		industry_forge = new
		industry_forge.workstation_size = workshop_capacity
		industry_forge.workers_employed = profile["finishers"]
		workstations += list(industry_smeltery, industry_forge)
	else
		var/list/lanes = getManorProductionLanes(manor_type)
		var/list/lane = lanes[industry_specialization]
		industry_processing = new
		industry_processing.workstation_name = lane["processing_name"]
		industry_processing.workstation_size = industry_artisans
		industry_processing.workers_employed = profile["processing_workers"]
		var/processing_material = profile["processing_material"]
		industry_processing.material = taManorIsRefiningMaterial(
			industry_materials,
			processing_material
		) ? processing_material \
			: taManorFirstRefiningMaterial(industry_materials)
		industry_workshop = new
		industry_workshop.workstation_name = lane["workshop_name"]
		industry_workshop.workstation_size = workshop_capacity
		industry_workshop.workers_employed = profile["workshop_workers"]
		var/workshop_material = profile["workshop_material"]
		if(workshop_material && industry_materials[workshop_material])
			industry_workshop.material = workshop_material
		else if(length(industry_materials))
			industry_workshop.material = industry_materials[1]
		workstations += list(industry_processing, industry_workshop)

	industry_active = TRUE
	var/population_multiplier = owner?.taNobilityEstateMultiplier() || 1
	if(population_multiplier > 1)
		scaleEstateWorkers(population_multiplier)

	total_workers = industry_peasants + industry_artisans
	min_workers = total_workers
	workers_limit = total_workers
	return TRUE

/// Apply the bonus after upgrades so improved capacities scale too.
/datum/manor/proc/scaleEstateWorkers(multiplier)
	var/population = ceil((industry_peasants + industry_artisans) * multiplier)
	industry_artisans = min(population, ceil(industry_artisans * multiplier))
	industry_peasants = population - industry_artisans
	var/peasants_left = industry_peasants
	var/artisans_left = industry_artisans
	for(var/datum/workstation/station in workstations)
		station.workstation_size = ceil(station.workstation_size * multiplier)
		var/employed = min(
			station.workstation_size,
			ceil(station.workers_employed * multiplier)
		)
		if(isArtisanWorkstation(station))
			station.workers_employed = min(artisans_left, employed)
			artisans_left -= station.workers_employed
		else
			station.workers_employed = min(peasants_left, employed)
			peasants_left -= station.workers_employed

/datum/manor/proc/isArtisanWorkstation(datum/workstation/workstation)
	return industry_active && (workstation == industry_smeltery \
		|| workstation == industry_forge || workstation == industry_processing \
		|| workstation == industry_workshop)

/datum/manor/proc/getAssignedArtisans()
	if(industry_processing)
		return industry_processing.workers_employed + \
			industry_workshop.workers_employed
	return (
		industry_smeltery?.workers_employed || 0
	) + (industry_forge?.workers_employed || 0)

/datum/manor/proc/industrySettledToday()
	return industry_active && !isnull(industry_last_day) \
		&& industry_last_day == GLOB.dayspassed

/datum/manor/proc/industryAllowsMetal(metal)
	if(industry_materials)
		return istext(metal) && !!industry_materials[metal]
	return metal == "iron" || (metal == "steel" && industry_steel_unlocked)

/datum/manor/proc/getIndustryMaterialLabel(material)
	var/list/recipe = industry_materials?[material]
	return recipe?["label"]

/datum/manor/proc/setIndustryMetal(
	mob/living/carbon/human/owner,
	station,
	metal
)
	if(
		!industry_smeltery \
		|| !taCanManageManor(owner, src) \
		|| !industryAllowsMetal(metal)
	)
		return FALSE
	switch(station)
		if("smeltery")
			if(!taManorIsRefiningMaterial(industry_materials, metal))
				return FALSE
			industry_smeltery_metal = metal
		if("forge")
			var/list/materials = industry_materials || taManorSmithMaterials()
			if(!taManorCanFundWorkshop("smith", materials[metal]))
				return FALSE
			industry_forge_metal = metal
		else
			return FALSE
	return TRUE

/datum/manor/proc/setProductionMaterial(
	mob/living/carbon/human/owner,
	stage,
	material
)
	if(
		!industry_processing \
		|| !taCanManageManor(owner, src) \
		|| !istext(material) \
		|| !industry_materials[material]
	)
		return FALSE
	switch(stage)
		if("processing")
			if(!taManorIsRefiningMaterial(industry_materials, material))
				return FALSE
			industry_processing.material = material
		if("workshop")
			industry_workshop.material = material
		else
			return FALSE
	return TRUE

/datum/manor/proc/getIndustryMiningGoods()
	var/list/mining_goods = list()
	for(var/stock_path in industry_mine?.produce)
		var/datum/roguestock/stockpile/stock_type = stock_path
		var/good_id = stock_type::trade_good_id
		if(good_id && GLOB.trade_goods[good_id])
			mining_goods[good_id] = stock_path
	return mining_goods

/datum/manor/proc/setIndustryMiningPriority(
	mob/living/carbon/human/owner,
	good_id
)
	if(!industry_active || !industry_mine || !taCanManageManor(owner, src))
		return FALSE
	if(!isnull(good_id))
		var/list/mining_goods = getIndustryMiningGoods()
		if(!istext(good_id) || !mining_goods[good_id])
			return FALSE
	industry_mining_priority = good_id
	return TRUE

/// Keep the iron-ore entry point for existing callers of the smithing cycle.
/datum/manor/proc/processIndustryHarvest(ore)
	var/list/fresh_goods = list(TRADE_GOOD_IRON_ORE = ore)
	var/list/result = processManorProduction(fresh_goods)
	if(!result)
		return null
	return list(
		"ore_surplus" = fresh_goods[TRADE_GOOD_IRON_ORE],
		"ingot_surplus" = result["refined_units"],
		"warehouse_consumed" = result["warehouse_consumed"],
	)

/// Reserve freshly harvested units before drawing from warehouse stock.
/datum/manor/proc/reserveIndustryGood(list/fresh_goods, good_id, units)
	var/from_harvest = min(units, fresh_goods[good_id] || 0)
	if(from_harvest)
		fresh_goods[good_id] -= from_harvest
	var/from_warehouse = units - from_harvest
	if(!from_warehouse)
		return FALSE
	warehouse_stock[good_id] -= from_warehouse
	if(!warehouse_stock[good_id])
		warehouse_stock -= good_id
	return TRUE

/datum/manor/proc/processManorProduction(list/fresh_goods)
	if((!industry_smeltery && !industry_processing) || industrySettledToday())
		return null
	var/smithing = !!industry_smeltery
	var/list/materials = industry_materials || taManorSmithMaterials()
	var/processing_material = smithing ? industry_smeltery_metal \
		: industry_processing.material
	var/workshop_material = smithing ? industry_forge_metal \
		: industry_workshop.material
	var/processing_workers = smithing ? industry_smeltery.workers_employed \
		: industry_processing.workers_employed
	var/workshop_workers = smithing ? industry_forge.workers_employed \
		: industry_workshop.workers_employed
	var/harvested_iron = fresh_goods[TRADE_GOOD_IRON_ORE] || 0
	var/list/processing_recipe = materials?[processing_material]
	var/list/ingredients = processing_recipe?["inputs"]
	var/processed_good = processing_recipe?["refined_good"]
	var/processed_units = 0
	var/warehouse_consumed = FALSE
	var/daily_capacity = getIndustryDailyCapacity()
	if(processed_good && length(ingredients) && !processing_recipe["direct"])
		var/batches = processing_workers * daily_capacity
		for(var/good_id in ingredients)
			var/available = (
				fresh_goods[good_id] || 0
			) + (warehouse_stock[good_id] || 0)
			batches = min(batches, FLOOR(available / ingredients[good_id], 1))
		for(var/good_id in ingredients)
			if(
				reserveIndustryGood(
					fresh_goods,
					good_id,
					ingredients[good_id] * batches
				)
			)
				warehouse_consumed = TRUE
		processed_units = batches * (processing_recipe["output_amount"] || 1)

	var/list/refined_goods = list()
	if(processed_good)
		refined_goods[processed_good] = processed_units
	var/list/workshop_recipe = materials?[workshop_material]
	var/workshop_good = workshop_recipe?["refined_good"]
	var/consumed = 0
	var/points_earned = 0
	if(
		workshop_good \
		&& taManorCanFundWorkshop(
			smithing ? "smith" : industry_specialization,
			workshop_recipe
		)
	)
		var/ready_units = fresh_goods[workshop_good] || 0
		var/available = ready_units + (
			refined_goods[workshop_good] || 0
		) + (warehouse_stock[workshop_good] || 0)
		consumed = min(available, workshop_workers * daily_capacity)
		var/from_ready = min(ready_units, consumed)
		if(from_ready)
			fresh_goods[workshop_good] -= from_ready
		if(
			reserveIndustryGood(
				refined_goods,
				workshop_good,
				consumed - from_ready
			)
		)
			warehouse_consumed = TRUE
		var/credit = industry_point_remainder + consumed * \
			taManorMaterialValue(workshop_recipe)
		points_earned = FLOOR(credit / SELLPRICE_IRON_INGOT, 1)
		industry_point_remainder = credit - points_earned * SELLPRICE_IRON_INGOT
		industry_points += points_earned

	var/datum/trade_good/processed_trade_good = processed_good \
		? GLOB.trade_goods[processed_good] : null
	industry_last_production = list(
		"processed" = processed_units,
		"processed_good" = processed_trade_good?.name,
		"consumed" = consumed,
		"points" = points_earned,
		"material" = workshop_material,
		"material_name" = workshop_recipe?["label"],
	)
	if(smithing)
		industry_last_ore = harvested_iron
		industry_last_ingots = processed_units
		industry_last_forged_ingots = consumed
		industry_last_points = points_earned
		industry_last_smeltery_metal = processing_material
		industry_last_forge_metal = workshop_material
	industry_last_day = GLOB.dayspassed
	industry_revision++
	return list(
		"refined_good" = processed_good,
		"refined_units" = processed_good ? (
			refined_goods[processed_good] || 0
		) : 0,
		"warehouse_consumed" = warehouse_consumed,
	)

/datum/manor/proc/serializeIndustryStage(
	datum/workstation/manor_craft/station,
	stage
)
	var/list/options = list()
	for(var/material_id in industry_materials)
		var/list/recipe = industry_materials[material_id]
		if(
			stage == "processing" ? recipe["direct"] : !taManorCanFundWorkshop(
				industry_specialization,
				recipe
			)
		)
			continue
		var/datum/trade_good/output = GLOB.trade_goods[recipe["refined_good"]]
		var/list/inputs = list()
		var/list/produce = list()
		if(stage == "processing")
			var/list/ingredients = recipe["inputs"]
			for(var/good_id in ingredients)
				var/datum/trade_good/ingredient = GLOB.trade_goods[good_id]
				if(ingredient)
					inputs += "[ingredients[good_id]] × [ingredient.name]"
			if(output)
				var/output_amount = recipe["output_amount"] || 1
				produce += output_amount > 1 \
					? "[output_amount] × [output.name]" : output.name
		else if(output)
			inputs += output.name
		options += list(list(
			"id" = material_id,
			"name" = recipe["label"],
			"inputs" = inputs,
			"produce" = produce,
			"points_per_unit" = taManorMaterialValue(recipe) / \
				SELLPRICE_IRON_INGOT,
		))
	return list(
		"id" = stage,
		"station_id" = workstations.Find(station),
		"name" = station.workstation_name,
		"kind" = stage,
		"selected" = station.material,
		"options" = options,
	)

/datum/manor/proc/getIndustryDailyCapacity()
	switch(industry_specialization)
		if("provisions", "fine_food")
			return 6
		if("simple_drinks", "fine_drinks")
			return 5
	return MANOR_INDUSTRY_DAILY_CAPACITY

/proc/taManorCanFundWorkshop(specialization, list/material)
	if(!material)
		return FALSE
	if(specialization != "smith")
		return TRUE
	var/datum/trade_good/good = GLOB.trade_goods[material["refined_good"]]
	return ispath(good?.item_type, /obj/item/ingot)

/// One iron ingot is one point. Work in economy value units to keep partial
/// credit exact, and use the same material value for output and recipe costs.
/proc/taManorMaterialValue(list/material)
	var/point_override = material["points_per_unit"]
	if(point_override)
		return point_override * SELLPRICE_IRON_INGOT
	var/datum/trade_good/good = GLOB.trade_goods[material["refined_good"]]
	return max(1, good?.base_price || 0)

/proc/getManorRecipeManifest(list/entry)
	if(islist(entry["manifest"]))
		return entry["manifest"]
	var/list/manifest = list()
	manifest[entry["item_type"]] = entry["batch_size"] || 1
	return manifest

/datum/manor/proc/getIndustryPanelData()
	if(!industry_active)
		return null

	var/list/catalogue = getEstateWorkshopCatalogue()
	var/list/recipes = list()
	for(var/id in catalogue)
		var/list/entry = catalogue[id]
		var/material = entry["material"]
		var/obj/item/item_type = entry["item_type"]
		var/list/manifest = getManorRecipeManifest(entry)
		var/units = 0
		for(var/item_path in manifest)
			units += manifest[item_path]
		var/cost = entry["cost"]
		var/locked = !!entry["locked"]
		recipes += list(list(
			"id" = id,
			"name" = entry["name"] || item_type::name,
			"category" = entry["category"],
			"material" = material,
			"material_label" = entry["material_label"],
			"cost" = cost,
			"units" = units,
			"locked" = locked,
			"available" = !locked && industry_points >= cost,
		))
	var/artisans_assigned = getAssignedArtisans()
	var/list/mining_options = list()
	for(var/good_id in getIndustryMiningGoods())
		var/datum/trade_good/good = GLOB.trade_goods[good_id]
		mining_options += list(list("id" = good_id, "name" = good.name))
	var/list/stages = list()
	if(industry_processing)
		stages += list(
			serializeIndustryStage(industry_processing, "processing")
		)
		stages += list(serializeIndustryStage(industry_workshop, "workshop"))
	var/list/smeltery_options = list()
	var/list/forge_options = list()
	var/list/metal_names = list()
	var/list/points_per_ingot = list()
	if(industry_smeltery)
		for(var/material in industry_materials)
			var/list/material_recipe = industry_materials[material]
			if(!material_recipe["direct"])
				smeltery_options += material
			if(taManorCanFundWorkshop(industry_specialization, material_recipe))
				forge_options += material
				points_per_ingot[material] = \
					taManorMaterialValue(material_recipe) / SELLPRICE_IRON_INGOT
			metal_names[material] = material_recipe["label"]
	return list(
		"active" = TRUE,
		"specialization" = industry_specialization,
		"stages" = stages,
		"last_production" = industry_last_production,
		"mining_options" = mining_options,
		"mining_priority" = industry_mining_priority,
		"smeltery_metal" = industry_smeltery_metal,
		"forge_metal" = industry_forge_metal,
		"metal_options" = forge_options,
		"smeltery_options" = smeltery_options,
		"forge_options" = forge_options,
		"metal_names" = metal_names,
		"peasants" = industry_peasants,
		"peasants_assigned" = get_assigned_workers() - artisans_assigned,
		"artisans" = industry_artisans,
		"artisans_assigned" = artisans_assigned,
		"miners" = industry_mine?.workers_employed || 0,
		"mine_slots" = industry_mine?.workstation_size || 0,
		"last_ore" = industry_last_ore,
		"last_ingots" = industry_last_ingots,
		"last_forged_ingots" = industry_last_forged_ingots,
		"last_points" = industry_last_points,
		"last_smeltery_metal" = industry_last_smeltery_metal,
		"last_forge_metal" = industry_last_forge_metal,
		"last_sold_ore" = industry_last_sold_ore,
		"last_stored_ore" = industry_last_stored_ore,
		"has_report" = !isnull(industry_last_day),
		"points" = industry_points,
		"points_per_ingot" = points_per_ingot,
		"recipes" = recipes,
		"revision" = industry_revision,
	)

/datum/manor/proc/requestIndustryOrder(
	mob/living/carbon/human/owner,
	list/requested,
	expected_revision
)
	if(!industry_active || !taCanManageManor(owner, src))
		return FALSE
	if(
		!islist(requested) \
		|| !length(requested) \
		|| length(requested) > MANOR_SHIPMENT_MAX_UNITS \
		|| !isnum(expected_revision) \
		|| expected_revision != industry_revision
	)
		return FALSE
	var/list/catalogue = getEstateWorkshopCatalogue()
	var/list/manifest = list()
	var/total_cost = 0
	var/total_units = 0
	for(var/recipe_id in requested)
		if(!istext(recipe_id))
			return FALSE
		var/list/entry = catalogue[recipe_id]
		if(!entry || entry["locked"])
			return FALSE
		var/quantity = requested[recipe_id]
		if(
			!isnum(quantity) \
			|| quantity < 1 \
			|| quantity > MANOR_SHIPMENT_MAX_UNITS - total_units \
			|| round(quantity) != quantity
		)
			return FALSE
		total_cost += entry["cost"] * quantity
		if(total_cost > industry_points)
			return FALSE
		var/list/bundle = getManorRecipeManifest(entry)
		for(var/item_type in bundle)
			var/units = bundle[item_type] * quantity
			if(
				!ispath(item_type, /obj/item) \
				|| units < 1 \
				|| units > MANOR_SHIPMENT_MAX_UNITS - total_units
			)
				return FALSE
			total_units += units
			manifest[item_type] = (manifest[item_type] || 0) + units

	var/obj/item/parcel/manor_shipment/shipment = new
	if(QDELETED(shipment))
		return FALSE
	industry_points -= total_cost
	var/order_value = total_cost * SELLPRICE_IRON_INGOT
	industry_revision++

	var/delay = round(
		rand(
			20 SECONDS,
			5 MINUTES
		) * warehouseTravelMultiplier(total_units, order_value)
	)
	addtimer( \
		CALLBACK( \
			shipment, \
			TYPE_PROC_REF(/obj/item/parcel/manor_shipment, sendToOwner), \
			owner.mind, \
			manifest, \
			manor_name \
		), \
		delay \
	)
	return TRUE

#undef MANOR_INDUSTRY_DAILY_CAPACITY
#undef MANOR_YIELD_PRECISION
