/// Recipe costs use the value of their ordinary ingredients.
/// Production points represent materials already consumed by artisans.
/proc/getManorWorkshopRecipes()
	var/static/list/catalogue
	if(catalogue)
		return catalogue
	catalogue = list()
	var/list/cultural_recipes = getManorCulturalRecipeOrigins()
	for(var/datum/anvil_recipe/recipe as anything in GLOB.anvil_recipes)
		if(
			recipe.hides_from_books \
			|| recipe.required_tech_node \
			|| !ispath(recipe.req_bar, /obj/item/ingot) \
			|| !ispath(recipe.created_item, /obj/item)
		)
			continue
		var/list/requirements = list()
		requirements[recipe.req_bar] = 1
		for(var/ingredient in recipe.additional_items)
			requirements[ingredient] = (requirements[ingredient] || 0) + 1
		var/list/manifest = list()
		manifest[recipe.created_item] = max(1, recipe.createditem_num)
		var/category = "Инструменты"
		var/list/lanes = list("smith")
		if(istype(recipe, /datum/anvil_recipe/weapons))
			category = "Оружие"
		else if(istype(recipe, /datum/anvil_recipe/armor))
			category = "Броня"
		if(
			recipe.req_bar == /obj/item/ingot/gold \
			|| recipe.req_bar == /obj/item/ingot/silver
		)
			category = getManorHandcraftCategory(recipe.created_item, category)
			if((category in list(
				"Украшения",
				"Посуда",
			)) || istype(recipe, /datum/anvil_recipe/valuables))
				lanes += "jewelry"
		addManorWorkshopRecipe(
			catalogue,
			recipe.type,
			lanes,
			category,
			requirements,
			manifest,
			cultural_recipes
		)

	var/list/kitchen_lanes = list("provisions", "fine_food")
	var/list/dry_brew_recipes = list(
		/datum/crafting_recipe/roguetown/cooking/drytea,
		/datum/crafting_recipe/roguetown/cooking/dryrosa,
		/datum/crafting_recipe/roguetown/cooking/mix_taraxamint,
		/datum/crafting_recipe/roguetown/cooking/mix_utricasalvia,
		/datum/crafting_recipe/roguetown/cooking/mix_sbiten,
	)
	for(var/datum/crafting_recipe/recipe as anything in GLOB.crafting_recipes)
		if(
			recipe.hides_from_books \
			|| recipe.required_tech_node \
			|| recipe.required_trait \
			|| recipe.wallcraft \
			|| recipe.doorcraft \
			|| recipe.windowcraft \
			|| length(recipe.parts) \
			|| length(recipe.chem_catalysts)
		)
			continue
		var/list/results = islist(recipe.result) ? recipe.result \
			: list(recipe.result)
		var/output = length(results) ? results[1] : null
		if(!ispath(output, /obj/item))
			continue
		var/category = getManorHandcraftCategory(
			output,
			recipe.category,
			recipe.display_category
		)
		var/list/lanes
		var/component_only = FALSE
		if(recipe.type == /datum/crafting_recipe/roguetown/survival/cloth)
			lanes = list("smith", "tailoring")
			component_only = TRUE
		else if(
			istype(recipe, /datum/crafting_recipe/roguetown/sewing) \
			|| istype(recipe, /datum/crafting_recipe/roguetown/leather) \
			|| istype(recipe, /datum/crafting_recipe/roguetown/weaving)
		)
			lanes = list("tailoring")
		else if(istype(recipe, /datum/crafting_recipe/roguetown/ceramics))
			lanes = list("jewelry")
		else if(istype(recipe, /datum/crafting_recipe/roguetown/gemcarving))
			lanes = list("jewelry", "marine_jewelry")
		else if(istype(recipe, /datum/crafting_recipe/roguetown/woodcarving))
			lanes = list("trophies", "jewelry")
		else if(istype(recipe, /datum/crafting_recipe/roguetown/cooking))
			if(recipe.type in dry_brew_recipes)
				lanes = list(
					"provisions",
					"fine_food",
					"simple_drinks",
					"fine_drinks",
				)
			else if(ispath(output, /obj/item/reagent_containers/food/snacks))
				lanes = kitchen_lanes
		else if(istype(recipe, /datum/crafting_recipe/roguetown/engineering))
			lanes = list("smith")
		else if(cultural_recipes[recipe.type])
			lanes = list("smith", "tailoring")
		else if(istype(recipe, /datum/crafting_recipe/roguetown/survival))
			if((category in list(
				"Оружие",
				"Броня",
				"Инструменты",
			)) || ispath(output, /obj/item/craft_kit))
				lanes = list("smith")
			else if(category == "Посуда")
				lanes = list("smith", "jewelry", "trophies")
		if(cultural_recipes[recipe.type] && ("tailoring" in lanes))
			lanes |= "smith"
		if(
			!lanes \
			|| (!recipe.always_availible && !cultural_recipes[recipe.type])
		)
			continue
		var/list/manifest = list()
		for(var/result in results)
			if(!ispath(result, /obj/item))
				manifest.Cut()
				break
			if(
				istype(recipe, /datum/crafting_recipe/roguetown/ceramics) \
				&& ispath(result, /obj/item/natural/clay)
			)
				var/obj/item/natural/clay/clay_type = result
				if(ispath(clay_type::cooked_type, /obj/item))
					result = clay_type::cooked_type
					category = getManorHandcraftCategory(result, "Керамика")
			manifest[result] = (manifest[result] || 0) + 1
		addManorWorkshopRecipe(catalogue, recipe.type, lanes, category,
			recipe.reqs, manifest, cultural_recipes, recipe.subtype_reqs,
			recipe.blacklist, hidden = component_only)

	// Splitting logs is an item action, not a registered crafting recipe.
	// Lists are initialized on instances; a type path returns no debris list.
	var/obj/item/grown/log/tree/small/log_sample = new(null)
	var/list/log_debris = log_sample.static_debris
	log_debris = log_debris.Copy()
	qdel(log_sample)
	addManorWorkshopRecipe(catalogue, null, list("smith"), "Материалы",
		list(/obj/item/grown/log/tree/small = 1), log_debris,
		cultural_recipes, hidden = TRUE)

	for(
		var/datum/food_recipe/recipe as anything in \
			init_subtypes(/datum/food_recipe)
	)
		var/base = recipe.base_item
		if(
			istype(recipe, /datum/food_recipe/dough/dot_tart) \
			|| recipe.restricted_message \
			|| (!ispath(base, /obj/item) && !islist(base))
		)
			continue
		var/obj/item/reagent_containers/food/snacks/result_type = \
			recipe.result_type
		if(!ispath(result_type, /obj/item/reagent_containers/food/snacks))
			continue
		var/method = recipe.cook_method
		switch(method)
			if(COOK_FRY)
				result_type = result_type::fried_type
			if(COOK_DEEPFRY)
				result_type = result_type::deep_fried_type
			if(COOK_BOIL)
				continue
			if(COOK_SMOKE)
				result_type = result_type::smoked_type
			if(COOK_BAKE)
				result_type = result_type::cooked_type || result_type
			else
				if(recipe.needs_cooking)
					result_type = result_type::cooked_type
		if(!ispath(result_type, /obj/item))
			continue
		var/list/requirements = list()
		var/list/alternatives = list()
		if(islist(base))
			alternatives += list(base)
		else
			requirements[base] = 1
		var/list/ingredients = recipe.ingredients
		var/supported = TRUE
		for(var/ingredient in ingredients)
			if(
				ingredient == COOKSTEP_SHARP \
				|| ingredient == /datum/reagent/water \
				|| (
					ispath(ingredient) \
					&& ingredients[ingredient] == COOKSTEP_TOOL
				)
			)
				continue
			if(
				recipe.type == /datum/food_recipe/baked/buttered_dough \
				&& ingredient == \
					/obj/item/reagent_containers/food/snacks/butterslice
			)
				continue
			if(islist(ingredient))
				alternatives += list(ingredient)
				continue
			if(!ispath(ingredient, /obj/item))
				supported = FALSE
				break
			requirements[ingredient] = (requirements[ingredient] || 0) + 1
		if(!supported)
			continue
		if(method == COOK_DEEPFRY)
			var/tallow = /obj/item/reagent_containers/food/snacks/tallow
			requirements[tallow] = (requirements[tallow] || 0) + 1
		var/list/manifest = list()
		manifest[result_type] = max(1, recipe.result_amount)
		var/hidden = recipe.hidden || (recipe.book_category in list(
			FOOD_CAT_BASICS,
			FOOD_CAT_DOUGHS,
		))
		addManorWorkshopRecipe(
			catalogue,
			recipe.type,
			kitchen_lanes,
			"Еда",
			requirements,
			manifest,
			cultural_recipes,
			TRUE,
			null,
			alternatives,
			hidden
		)

	for(
		var/datum/container_craft/recipe as anything in \
			init_subtypes(/datum/container_craft)
	)
		if(
			recipe.hides_from_books \
			|| !ispath(recipe.output, /obj/item/reagent_containers/food/snacks)
		)
			continue
		if(
			!istype(recipe, /datum/container_craft/cooking) \
			&& !istype(recipe, /datum/container_craft/pan) \
			&& !istype(recipe, /datum/container_craft/oven)
		)
			continue
		var/subtypes = !!length(recipe.wildcard_requirements)
		if(subtypes && length(recipe.requirements))
			continue
		var/list/recipe_requirements = subtypes ? recipe.wildcard_requirements \
			: recipe.requirements
		var/list/requirements = recipe_requirements?.Copy() || list()
		var/supported = TRUE
		for(var/reagent in recipe.reagent_requirements)
			if(reagent == /datum/reagent/water)
				continue
			if(
				reagent == /datum/reagent/consumable/oil/tallow \
				|| (
					reagent == /datum/reagent/consumable/oil \
					&& recipe.subtype_reagents_allowed
				)
			)
				var/tallow = /obj/item/reagent_containers/food/snacks/tallow
				requirements[tallow] = (
					requirements[tallow] || 0
				) + ceil(recipe.reagent_requirements[reagent] / 5)
			else
				supported = FALSE
				break
		if(!supported)
			continue
		var/list/manifest = list()
		manifest[recipe.output] = max(1, recipe.output_amount)
		addManorWorkshopRecipe(
			catalogue,
			recipe.type,
			kitchen_lanes,
			"Еда",
			requirements,
			manifest,
			cultural_recipes,
			subtypes
		)

	for(var/item_path in subtypesof(/obj/item/reagent_containers/food/snacks))
		for(
			var/list/transform as anything in \
				SScooking.get_auto_transforms(item_path)
		)
			var/list/requirements = list()
			requirements[item_path] = 1
			var/list/manifest = list()
			manifest[transform["result"]] = transform["amount"] || 1
			addManorWorkshopRecipe(
				catalogue,
				null,
				kitchen_lanes,
				"Еда",
				requirements,
				manifest,
				cultural_recipes,
				FALSE,
				null,
				null,
				!transform["method"] && !transform["generic"]
			)
	return catalogue

/proc/getManorHandcraftCategory(item_type, fallback, display_category)
	if(
		ispath(item_type, /obj/item/reagent_containers/glass) \
		|| ispath(item_type, /obj/item/kitchen) \
		|| ispath(item_type, /obj/item/cooking/platter)
	)
		return "Посуда"
	if(
		ispath(item_type, /obj/item/clothing/ring) \
		|| ispath(item_type, /obj/item/carvedgem) \
		|| ispath(item_type, /obj/item/clothing/neck/roguetown/psicross)
	)
		return "Украшения"
	if(
		ispath(item_type, /obj/item/clothing/suit/roguetown/armor) \
		|| findtext(display_category || "", "Armor (") == 1
	)
		return "Броня"
	if(
		ispath(item_type, /obj/item/rogueweapon) \
		|| ispath(item_type, /obj/item/gun) \
		|| findtext(display_category || "", "Weapons (") == 1 \
		|| display_category == ITEM_CAT_ENG_COMBAT
	)
		return "Оружие"
	if(ispath(item_type, /obj/item/clothing))
		return "Одежда"
	if(ispath(item_type, /obj/item/reagent_containers/food/snacks))
		return "Еда"
	if(
		findtext(display_category || "", "Tools (") == 1 \
		|| findtext(display_category || "", "Engineering (") == 1
	)
		return "Инструменты"
	return fallback || "Прочее"

/proc/addManorWorkshopRecipe(
	list/catalogue,
	recipe_type,
	list/lanes,
	category,
	list/requirements,
	list/manifest,
	list/cultural_recipes,
	subtype_reqs = FALSE,
	list/blacklist,
	list/alternatives,
	hidden = FALSE
)
	if((!length(requirements) && !length(alternatives)) || !length(manifest))
		return
	for(var/ingredient in requirements)
		if(
			!ispath(ingredient, /obj/item) \
			|| !isnum(requirements[ingredient]) \
			|| requirements[ingredient] < 1
		)
			return
	var/units = 0
	for(var/output in manifest)
		if(
			!ispath(output, /obj/item) \
			|| !isnum(manifest[output]) \
			|| manifest[output] < 1 \
			|| round(manifest[output]) != manifest[output]
		)
			return
		if(
			ispath(
				output,
				/obj/item/reagent_containers/food/snacks/rogue/dot_tart
			)
		)
			return
		if(
			ispath(
				output,
				/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
			)
		)
			hidden = TRUE
		units += manifest[output]
	if(units > MANOR_SHIPMENT_MAX_UNITS)
		return
	var/static/list/stable_ids = list(
		/datum/anvil_recipe/weapons/iron/sword = "iron_sword",
		/datum/anvil_recipe/weapons/iron/greatsword = "iron_greatsword",
		/datum/anvil_recipe/weapons/steel/sword = "steel_sword",
		/datum/anvil_recipe/weapons/steel/greatsword = "steel_greatsword",
		/datum/anvil_recipe/armor/iron/sallet = "iron_sallet",
		/datum/anvil_recipe/armor/steel/helmetsall = "steel_sallet",
	)
	var/id = recipe_type ? stable_ids[recipe_type] : null
	if(!id)
		id = "manor-recipe-[length(catalogue) + 1]"
	catalogue[id] = list(
		"category" = category,
		"lanes" = lanes,
		"requirements" = requirements,
		"subtype_reqs" = subtype_reqs,
		"blacklist" = blacklist,
		"alternatives" = alternatives,
		"hidden" = hidden,
		"origins" = recipe_type ? cultural_recipes[recipe_type] : null,
		"recipe_type" = recipe_type,
		"item_type" = manifest[1],
		"manifest" = manifest,
	)

/datum/manor/proc/getEstateWorkshopCatalogue()
	if(industry_order_catalogue)
		return industry_order_catalogue
	var/list/possible_goods = getManorReachableRawGoods(
		manor_type, manor_size, industry_specialization, industry_origin_type)
	var/list/all_materials = taManorProfileMaterials(
		manor_type, industry_specialization, possible_goods, TRUE)
	industry_order_catalogue = buildEstateWorkshopCatalogue(all_materials)
	var/list/unlocked = buildEstateWorkshopCatalogue(industry_materials)
	var/list/locked_by_output = list()
	for(var/id in industry_order_catalogue)
		if(unlocked[id])
			continue
		var/list/entry = industry_order_catalogue[id]
		entry["locked"] = TRUE
		var/list/manifest = entry["manifest"]
		if(length(manifest) <= 1)
			locked_by_output[entry["item_type"]] = id
	for(var/id in unlocked)
		var/list/entry = unlocked[id]
		var/list/manifest = entry["manifest"]
		var/locked_id = locked_by_output[entry["item_type"]]
		if(locked_id && length(manifest) <= 1)
			industry_order_catalogue -= locked_id
		industry_order_catalogue[id] = entry
	return industry_order_catalogue

/datum/manor/proc/buildEstateWorkshopCatalogue(list/materials)
	var/list/available_recipes = list()
	var/list/known_outputs = list()
	var/list/material_types = list()
	var/list/material_costs = list()
	for(var/material in materials)
		var/list/recipe = materials[material]
		var/datum/trade_good/good = GLOB.trade_goods[recipe["refined_good"]]
		if(good?.item_type)
			material_types[material] = good.item_type
			material_costs[material] = list(
				"material" = material,
				"value" = taManorMaterialValue(recipe),
			)

	var/list/curated = getManorAdditionalCatalogue()
	for(var/id in curated)
		var/list/entry = curated[id]
		var/material = entry["material"]
		var/list/recipe = materials?[material]
		if(!recipe || entry["price_from_contents"])
			continue
		var/list/registered = entry.Copy()
		var/value = entry["cost"] * taManorMaterialValue(recipe)
		registered["value"] = value
		registered["cost"] = ceil(value / SELLPRICE_IRON_INGOT)
		registered["material_label"] = recipe["label"]
		available_recipes[id] = registered
		if(!entry["manifest"])
			known_outputs[entry["item_type"]] = TRUE

	var/list/catalogue = getManorWorkshopRecipes()
	var/list/pending = list()
	var/list/reachable_components = list()
	var/is_kitchen = industry_specialization == "provisions" \
		|| industry_specialization == "fine_food"
	var/static/list/output_origins
	if(!output_origins)
		output_origins = list()
		for(var/id in catalogue)
			var/list/entry = catalogue[id]
			var/list/origins = entry["origins"]
			if(length(origins))
				var/list/allowed = output_origins[entry["item_type"]] || list()
				output_origins[entry["item_type"]] = allowed | origins
	for(var/id in catalogue)
		var/list/entry = catalogue[id]
		var/list/lanes = entry["lanes"]
		var/list/origins = output_origins[entry["item_type"]]
		if(
			(industry_specialization in lanes) \
			&& (!length(origins) || (industry_origin_type in origins))
		)
			pending[id] = entry

	// Resolve only recipes with reachable inputs. Each pass removes resolved
	// recipes, so a cycle without a source cannot unlock itself.
	while(length(pending))
		var/list/resolved = list()
		for(var/id in pending)
			var/list/entry = pending[id]
			var/list/cost = resolveEstateWorkshopCost(
				entry,
				material_types,
				material_costs,
				reachable_components
			)
			if(!cost)
				continue
			resolved += id
			var/list/manifest = entry["manifest"]
			var/item_type = entry["item_type"]
			if(length(manifest) == 1 && !reachable_components[item_type])
				reachable_components[item_type] = list(
					"material" = cost["material"],
					"value" = cost["value"] / manifest[item_type],
				)
			if(entry["hidden"] || known_outputs[item_type])
				continue
			var/list/registered = entry.Copy()
			var/material = cost["material"]
			var/list/material_recipe = materials[material]
			registered["material"] = material
			registered["material_label"] = material_recipe["label"]
			var/batch_multiplier = 1
			if(
				is_kitchen \
				&& length(manifest) == 1 \
				&& ispath(item_type, /obj/item/reagent_containers/food/snacks)
			)
				var/obj/item/reagent_containers/food/snacks/food_type = \
					item_type
				var/batch_target = 4
				if(food_type::faretype == FARE_LAVISH)
					batch_target = 1
				else if(food_type::faretype == FARE_FINE)
					batch_target = 2
				// Scale batches without changing per-item material costs.
				batch_multiplier = max(
					1,
					FLOOR(batch_target / manifest[item_type], 1)
				)
				if(batch_multiplier > 1)
					var/list/batch = list()
					batch[item_type] = manifest[item_type] * batch_multiplier
					registered["manifest"] = batch
			registered["cost"] = ceil(
				cost["value"] * batch_multiplier / SELLPRICE_IRON_INGOT
			)
			registered["value"] = cost["value"] * batch_multiplier
			available_recipes[id] = registered
			if(length(manifest) == 1)
				known_outputs[item_type] = TRUE
		if(!length(resolved))
			break
		pending -= resolved
	addEstateWorkshopBundles(available_recipes, materials)
	return available_recipes

/datum/manor/proc/addEstateWorkshopBundles(list/recipes, list/materials)
	var/list/unit_values = list()
	for(var/id in recipes)
		var/list/entry = recipes[id]
		var/list/manifest = getManorRecipeManifest(entry)
		if(length(manifest) != 1)
			continue
		var/item_type = manifest[1]
		var/unit_value = entry["value"] / manifest[item_type]
		if(
			isnull(unit_values[item_type]) \
			|| unit_value < unit_values[item_type]
		)
			unit_values[item_type] = unit_value

	var/list/bundles = getManorAdditionalCatalogue()
	for(var/id in bundles)
		var/list/entry = bundles[id]
		var/list/material = materials?[entry["material"]]
		if(!entry["price_from_contents"] || !material)
			continue
		var/list/manifest = entry["manifest"]
		var/value = 0
		var/available = TRUE
		for(var/item_type in manifest)
			if(isnull(unit_values[item_type]))
				available = FALSE
				break
			value += unit_values[item_type] * manifest[item_type]
		if(!available)
			continue
		var/list/registered = entry.Copy()
		registered["value"] = value
		registered["cost"] = ceil(value / SELLPRICE_IRON_INGOT)
		registered["material_label"] = material["label"]
		recipes[id] = registered

/datum/manor/proc/resolveEstateWorkshopCost(
	list/entry,
	list/material_types,
	list/material_costs,
	list/reachable_components
)
	var/primary_material
	var/value = 0
	var/list/requirements = entry["requirements"]
	for(var/ingredient in requirements)
		var/list/cost = getEstateWorkshopIngredientCost(
			ingredient,
			material_types,
			material_costs,
			reachable_components,
			entry["subtype_reqs"],
			entry["blacklist"]
		)
		if(!cost)
			return null
		primary_material = primary_material || cost["material"]
		value += requirements[ingredient] * cost["value"]
	for(var/list/options as anything in entry["alternatives"])
		var/list/cost
		for(var/ingredient in options)
			cost = getEstateWorkshopIngredientCost(
				ingredient,
				material_types,
				material_costs,
				reachable_components,
				TRUE
			)
			if(cost)
				break
		if(!cost)
			return null
		primary_material = primary_material || cost["material"]
		value += cost["value"]
	if(!primary_material)
		return null
	return list("material" = primary_material, "value" = value)

/datum/manor/proc/getEstateWorkshopIngredientCost(
	ingredient,
	list/material_types,
	list/material_costs,
	list/reachable_components,
	subtype_reqs,
	list/blacklist
)
	if(!ispath(ingredient, /obj/item))
		return null
	var/substitute
	for(var/material in material_types)
		var/available = material_types[material]
		if(blacklist && (available in blacklist))
			continue
		if(available == ingredient)
			return material_costs[material]
		if(!substitute && subtype_reqs && ispath(available, ingredient))
			substitute = material
	if(substitute)
		return material_costs[substitute]
	if(
		reachable_components[ingredient] \
		&& !(blacklist && (ingredient in blacklist))
	)
		return reachable_components[ingredient]
	if(subtype_reqs)
		for(var/component in reachable_components)
			if(
				ispath(component, ingredient) \
				&& !(blacklist && (component in blacklist))
			)
				return reachable_components[component]
	return null
