#define TRADE_GOOD_MANOR_BANANA "BANANA"
#define TRADE_GOOD_MANOR_WATERMELON "WATERMELON"

/datum/preferences
	var/manor_treasury_retention = 0
	var/list/manor_industry_profiles
	var/datum/manor_industry_setup/manor_industry_editor

/mob/living/carbon/human
	var/manor_treasury_retention = 0
	var/manor_type_pref
	var/list/manor_industry_profiles

/datum/preferences/proc/get_manor_type_display_name(type = null)
	var/list/type_names = taManorTypeNames()
	return type_names[type || manor_type] || type_names["manor"]

/proc/taManorTypeNames()
	var/static/list/type_names = list(
		"manor" = "Manor",
		"hunter_mansion" = "Hunter Mansion",
		"village" = "Village",
		"fisher_hamlet" = "Fisher Hamlet",
		"mining_settlement" = "Mining Settlement",
	)
	return type_names

/proc/taManorIndustryLimits(size)
	var/list/limits
	switch(size)
		if("small")
			limits = list(
				"population" = 15,
				"default_artisans" = 2,
				"mine_slots" = 5,
				"finishers" = 1,
				"points" = 2,
			)
		if("medium")
			limits = list(
				"population" = 25,
				"default_artisans" = 3,
				"mine_slots" = 10,
				"finishers" = 2,
				"points" = 5,
			)
		if("big")
			limits = list(
				"population" = 50,
				"default_artisans" = 6,
				"mine_slots" = 20,
				"finishers" = 5,
				"points" = 10,
			)
	if(!limits)
		return null
	limits["artisan_cost"] = 3
	limits["mine_upgrade_cost"] = 1
	limits["steel_upgrade_cost"] = 2
	limits["forge_upgrade_cost"] = 2
	return limits

/proc/taManorPeasantCount(list/limits, artisans)
	return limits["population"] - limits["artisan_cost"] * artisans

/proc/taManorResourceAdditions(type, site)
	var/static/list/additions = list(
		"mining_settlement" = list(
			"mining" = list(
				/datum/roguestock/stockpile/gold = list(
					"cost" = 3,
					"naledi_cost" = 2,
				),
				/datum/roguestock/stockpile/silver = list("cost" = 5),
				/datum/roguestock/stockpile/cinnabar = list("cost" = 1),
				/datum/roguestock/stockpile/salt = list("cost" = 1),
				/datum/roguestock/stockpile/manor_toper = list("cost" = 3),
				/datum/roguestock/stockpile/manor_gemerald = list("cost" = 4),
				/datum/roguestock/stockpile/manor_jade = list("cost" = 4),
				/datum/roguestock/stockpile/manor_saffira = list("cost" = 5),
				/datum/roguestock/stockpile/manor_opal = list("cost" = 7),
				/datum/roguestock/stockpile/manor_dorpel = list("cost" = 9),
			),
			"trade" = list(
				/datum/roguestock/stockpile/wood = list("cost" = 1),
				/datum/roguestock/stockpile/fibers = list("cost" = 1),
				/datum/roguestock/stockpile/hide = list("cost" = 1),
				/datum/roguestock/stockpile/cured = list("cost" = 2),
				/datum/roguestock/stockpile/fur = list("cost" = 2),
			),
		),
		"village" = list(
			"field" = list(
				/datum/roguestock/stockpile/maize = list("cost" = 1),
				/datum/roguestock/stockpile/beans = list("cost" = 1),
				/datum/roguestock/stockpile/lentils = list("cost" = 1),
				/datum/roguestock/stockpile/pumpkin = list("cost" = 1),
				/datum/roguestock/stockpile/tomato = list("cost" = 1),
			),
			"farm" = list(
				/datum/roguestock/stockpile/honey = list("cost" = 1),
				/datum/roguestock/stockpile/salt = list("cost" = 1),
				/datum/roguestock/stockpile/pork_belly = list("cost" = 1),
				/datum/roguestock/stockpile/boarham = list("cost" = 2),
			),
		),
		"manor" = list(
			"field" = list(
				/datum/roguestock/stockpile/calendula = list("cost" = 2),
				/datum/roguestock/stockpile/poppy = list("cost" = 1),
				/datum/roguestock/stockpile/mushroom = list("cost" = 1),
			),
			"fruit" = list(
				/datum/roguestock/stockpile/blackberry = list("cost" = 1),
				/datum/roguestock/stockpile/tangerine = list("cost" = 1),
				/datum/roguestock/stockpile/manor_banana = list("cost" = 1),
				/datum/roguestock/stockpile/manor_watermelon = list("cost" = 1),
			),
		),
		"hunter_mansion" = list(
			"hunt" = list(
				/datum/roguestock/stockpile/manor_fox_pelt = list(
					"cost" = 2,
					"free_in" = list("trophies"),
				),
				/datum/roguestock/stockpile/deer = list("cost" = 1),
				/datum/roguestock/stockpile/volf = list("cost" = 2),
				/datum/roguestock/stockpile/bear = list("cost" = 2),
			),
			"forest" = list(
				/datum/roguestock/stockpile/mushroom = list("cost" = 1),
				/datum/roguestock/stockpile/fibers = list("cost" = 1),
				/datum/roguestock/stockpile/silk = list("cost" = 2),
			),
		),
		"fisher_hamlet" = list("fish" = list(
			/datum/roguestock/stockpile/manor_oyster = list(
				"cost" = 2,
				"free_in" = list("marine_jewelry"),
			),
			/datum/roguestock/stockpile/crabbo = list("cost" = 2),
			/datum/roguestock/stockpile/clay = list("cost" = 1),
			/datum/roguestock/stockpile/manor_amber = list("cost" = 4),
		)),
	)
	var/list/estate_options = additions[type]
	return estate_options?[site]

/proc/taManorWorkstationResources(
	type,
	site,
	list/base_produce,
	origin_type = null
)
	var/list/resources = list()
	for(var/stock_path in base_produce)
		var/datum/roguestock/stockpile/stock = stock_path
		var/id = stock::trade_good_id
		if(!id || resources[id])
			continue
		var/datum/trade_good/good = GLOB.trade_goods[id]
		resources[id] = list(
			"id" = id,
			"name" = good?.name || stock::name,
			"cost" = 0,
			"base" = TRUE,
			"free_in" = list(),
			"stock_path" = stock_path,
		)
	var/list/additions = taManorResourceAdditions(type, site)
	for(var/stock_path in additions)
		var/datum/roguestock/stockpile/stock = stock_path
		var/id = stock::trade_good_id
		if(!id || resources[id])
			continue
		var/list/addition = additions[stock_path]
		var/datum/trade_good/good = GLOB.trade_goods[id]
		var/cost = addition["cost"]
		if(
			ispath(origin_type, /datum/virtue/origin/naledi) \
			&& !isnull(addition["naledi_cost"])
		)
			cost = addition["naledi_cost"]
		resources[id] = list(
			"id" = id,
			"name" = good?.name || stock::name,
			"cost" = cost,
			"base" = FALSE,
			"free_in" = addition["free_in"] || list(),
			"stock_path" = stock_path,
		)
	return resources

/proc/taManorResourceIsFree(list/resource, specialization)
	var/list/free_in = resource["free_in"]
	return resource["base"] || (specialization in free_in)

/proc/taManorRawWorkstations(type, size, origin_type = null)
	var/static/list/templates = list()
	var/list/stations = list()
	for(var/station_path in taManorWorkstationTypes(type, size))
		var/datum/workstation/station = templates[station_path]
		if(!station)
			station = new station_path()
			templates[station_path] = station
		var/site = station.workstation_theme
		var/list/resources = taManorWorkstationResources(
			type,
			site,
			station.produce,
			origin_type
		)
		var/list/resource_options = list()
		for(var/resource_id in resources)
			var/list/resource = resources[resource_id]
			resource_options += list(list(
				"id" = resource_id,
				"name" = resource["name"],
				"cost" = resource["cost"],
				"base" = resource["base"],
				"free_in" = resource["free_in"],
			))
		stations += list(list(
			"id" = site,
			"name" = station.workstation_name,
			"capacity" = station.workstation_size,
			"resources" = resource_options,
			"focus_limit" = 3,
		))
	return stations

/proc/taManorSanitizeResourcePlan(
	list/stations,
	specialization,
	list/source,
	points_left
)
	var/list/unlocks = list()
	var/list/focus = list()
	var/list/available_goods = list()
	var/list/requested_unlocks = source["resource_unlocks"]
	var/list/requested_focus = source["resource_pool"]
	for(var/list/station in stations)
		var/site = station["id"]
		var/list/options = list()
		var/list/available = list()
		for(var/list/resource in station["resources"])
			var/id = resource["id"]
			options[id] = resource
			if(taManorResourceIsFree(resource, specialization))
				available += id

		var/list/site_unlocks = islist(requested_unlocks) \
			? requested_unlocks[site] : null
		site_unlocks = migrateManorResourceChoices(site_unlocks, site)
		if(islist(site_unlocks))
			var/list/purchased = list()
			for(var/id in site_unlocks)
				if(!istext(id) || (id in available))
					continue
				var/list/option = options[id]
				if(!option || option["cost"] > points_left)
					continue
				points_left -= option["cost"]
				purchased += id
				available += id
			if(length(purchased))
				unlocks[site] = purchased

		var/list/site_focus = islist(requested_focus) ? requested_focus[site] \
			: null
		site_focus = migrateManorResourceChoices(site_focus, site)
		if(islist(site_focus))
			var/list/preferred = list()
			for(var/id in site_focus)
				if(istext(id) && (id in available))
					preferred |= id
				if(length(preferred) >= station["focus_limit"])
					break
			if(length(preferred))
				focus[site] = preferred
		available_goods |= available

	return list(
		"resource_unlocks" = unlocks,
		"resource_pool" = focus,
		"available_goods" = available_goods,
	)

/proc/taSanitizeManorIndustryProfile(
	size,
	list/source,
	manor_type = "mining_settlement",
	origin_type = null
)
	var/list/limits = taManorIndustryLimits(size)
	var/list/lanes = getManorProductionLanes(manor_type)
	if(!limits || !islist(source) || !length(lanes))
		return null

	var/specialization = source["specialization"]
	if(!istext(specialization) || !lanes[specialization])
		specialization = lanes[1]
	var/smithing = specialization == "smith"
	var/artisan_limit = FLOOR(limits["population"] / limits["artisan_cost"], 1)
	var/artisans = isnum(source["artisans"]) ? clamp(
		round(source["artisans"]),
		0,
		artisan_limit
	) : limits["default_artisans"]
	var/expand_mine = manor_type == "mining_settlement" \
		&& sanitize_bool(source["expand_mine"])
	var/unlock_steel = smithing && sanitize_bool(source["unlock_steel"])
	var/expand_forge = sanitize_bool(source["expand_forge"])
	var/points_left = limits["points"] - limits["mine_upgrade_cost"] * \
		expand_mine
	if(points_left < limits["steel_upgrade_cost"])
		unlock_steel = FALSE
	points_left -= limits["steel_upgrade_cost"] * unlock_steel
	if(points_left < limits["forge_upgrade_cost"])
		expand_forge = FALSE
	points_left -= limits["forge_upgrade_cost"] * expand_forge
	var/max_finishers = min(artisans, limits["finishers"] + expand_forge)
	var/legacy_smelting = sanitize_bool(source["smelting"], TRUE)
	var/legacy_finishing = sanitize_bool(source["finishing"], TRUE)
	var/default_finishers = legacy_finishing ? (
		legacy_smelting ? min(
			max_finishers,
			FLOOR(artisans / 2, 1)
		) : max_finishers
	) : 0
	var/finishers_setting = smithing ? source["finishers"] \
		: source["workshop_workers"]
	var/finishers = isnum(finishers_setting) ? clamp(
		round(finishers_setting),
		0,
		max_finishers
	) : default_finishers
	var/max_smelters = artisans - finishers
	var/smelters_setting = smithing ? source["smelters"] \
		: source["processing_workers"]
	var/smelters = isnum(smelters_setting) ? clamp(
		round(smelters_setting),
		0,
		max_smelters
	) : (legacy_smelting ? max_smelters : 0)
	var/smeltery_metal = source["smeltery_metal"] || source["metal"]
	var/forge_metal = source["forge_metal"] || source["metal"]
	var/list/stations = taManorRawWorkstations(manor_type, size, origin_type)
	var/list/resource_plan = taManorSanitizeResourcePlan(
		stations,
		specialization,
		source,
		points_left
	)
	var/list/materials = taManorProfileMaterials(
		manor_type,
		specialization,
		resource_plan["available_goods"],
		unlock_steel
	)
	var/default_material = length(materials) ? materials[1] : null
	var/default_processing_material = taManorFirstRefiningMaterial(materials)
	var/processing_material = source["processing_material"]
	var/workshop_material = source["workshop_material"]
	var/list/raw_workers = list()
	var/list/requested_raw_workers = source["raw_workers"]
	var/available_peasants = taManorPeasantCount(limits, artisans)
	for(var/list/station in stations)
		var/id = station["id"]
		var/capacity = min(
			available_peasants,
			station["capacity"] + (id == "mining" ? 5 * expand_mine : 0)
		)
		var/assigned
		if(islist(requested_raw_workers))
			assigned = requested_raw_workers[id]
		else if(smithing)
			assigned = id == "mining" ? (
				isnum(source["miners"]) ? source["miners"] : capacity
			) : 0
		else
			assigned = capacity
		assigned = isnum(assigned) ? clamp(round(assigned), 0, capacity) : 0
		raw_workers[id] = assigned
		available_peasants -= assigned
	return list(
		"specialization" = specialization,
		"artisans" = artisans,
		"miners" = raw_workers["mining"] || 0,
		"raw_workers" = raw_workers,
		"resource_unlocks" = resource_plan["resource_unlocks"],
		"resource_pool" = resource_plan["resource_pool"],
		"smelters" = smelters,
		"finishers" = finishers,
		"processing_workers" = smelters,
		"workshop_workers" = finishers,
		"processing_material" = taManorIsRefiningMaterial(
			materials,
			processing_material
		) ? processing_material : default_processing_material,
		"workshop_material" = istext(workshop_material) \
			&& materials?[workshop_material] ? workshop_material \
			: default_material,
		"expand_mine" = expand_mine,
		"unlock_steel" = unlock_steel,
		"expand_forge" = expand_forge,
		"smeltery_metal" = smithing && taManorIsRefiningMaterial(materials, \
			smeltery_metal) ? smeltery_metal : "iron",
		"forge_metal" = smithing && istext(forge_metal) \
			&& taManorCanFundWorkshop(specialization, \
			materials?[forge_metal]) ? forge_metal : "iron",
	)

/proc/taSanitizeManorIndustryProfiles(list/source, origin_type = null)
	var/list/profiles = list()
	if(!islist(source))
		return profiles
	for(var/type in taManorTypeNames())
		var/list/type_profiles = source[type]
		if(!islist(type_profiles))
			if(type != "mining_settlement")
				continue
			type_profiles = source
		var/list/validated = list()
		for(var/size in list("small", "medium", "big"))
			var/list/plan = taSanitizeManorIndustryProfile(
				size,
				type_profiles[size],
				type,
				origin_type
			)
			if(plan)
				validated[size] = plan
		if(length(validated))
			profiles[type] = validated
	return profiles

/datum/preferences/proc/openManorIndustryEditor(mob/user)
	if(user?.client?.prefs != src)
		return
	if(
		manor_industry_editor \
		&& (
			manor_industry_editor.character_slot != loaded_slot \
			|| manor_industry_editor.character_save_slot != default_slot
		)
	)
		SStgui.close_uis(manor_industry_editor)
		QDEL_NULL(manor_industry_editor)
	if(!manor_industry_editor)
		manor_industry_editor = new(src)
	manor_industry_editor.ui_interact(user)

/datum/manor_industry_setup
	var/datum/preferences/preferences
	var/character_slot
	var/character_save_slot
	var/settings_revision = 0
	var/settings_error

/datum/manor_industry_setup/New(datum/preferences/owner_preferences)
	. = ..()
	preferences = owner_preferences
	character_slot = preferences.loaded_slot
	character_save_slot = preferences.default_slot

/datum/manor_industry_setup/Destroy()
	if(preferences?.manor_industry_editor == src)
		preferences.manor_industry_editor = null
	preferences = null
	return ..()

/datum/manor_industry_setup/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/manor_industry_setup/ui_status(mob/user, datum/ui_state/state)
	if(
		preferences \
		&& user?.client?.prefs == preferences \
		&& preferences.loaded_slot == character_slot \
		&& preferences.default_slot == character_save_slot \
		&& preferences.manor_industry_editor == src
	)
		return UI_INTERACTIVE
	return UI_CLOSE

/datum/manor_industry_setup/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ManorIndustrySetup", "Настройки поместья")
		ui.open()

/datum/manor_industry_setup/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/manor_industry_setup/ui_data(mob/user)
	if(ui_status(user, null) != UI_INTERACTIVE)
		return list()

	var/list/type_names = taManorTypeNames()
	var/list/manor_types = list()
	for(var/type_id in type_names)
		manor_types += list(list("id" = type_id, "name" = type_names[type_id]))

	var/list/plans_by_type = list()
	var/list/production_lanes = list()
	var/origin_type = preferences.virtue_origin?.type
	var/list/saved_profiles = taSanitizeManorIndustryProfiles(
		preferences.manor_industry_profiles,
		origin_type
	)
	for(var/type_id in type_names)
		var/list/plans = list()
		var/list/type_profiles = saved_profiles[type_id]
		for(var/size in list("small", "medium", "big"))
			var/list/default_profile = taSanitizeManorIndustryProfile(
				size,
				list(),
				type_id,
				origin_type
			)
			var/list/saved = type_profiles?[size]
			plans += list(list(
				"size" = size,
				"limits" = taManorIndustryLimits(size),
				"profile" = saved || default_profile,
				"default_profile" = default_profile,
				"raw_workstations" = taManorRawWorkstations(
					type_id,
					size,
					origin_type
				),
				"saved" = !!saved,
			))
		plans_by_type[type_id] = plans
		var/list/lane_options = list()
		var/list/lanes = getManorProductionLanes(type_id)
		for(var/lane_id in lanes)
			var/list/lane = lanes[lane_id]
			var/list/possible_goods = getManorReachableRawGoods(
				type_id, "big", lane_id, origin_type)
			var/list/materials = taManorProfileMaterials(
				type_id, lane_id, possible_goods, TRUE)
			var/list/material_options = list()
			for(var/material_id in materials)
				var/list/material = materials[material_id]
				var/list/inputs = material["inputs"]
				var/list/ingredients = list()
				var/list/input_ids = list()
				for(var/good_id in inputs)
					var/datum/trade_good/good = GLOB.trade_goods[good_id]
					var/good_name = good?.name || good_id
					ingredients += "[inputs[good_id]] × [good_name]"
					input_ids += good_id
				var/description = material["description"] \
					|| ingredients.Join(", ")
				var/output_amount = material["output_amount"] || 1
				if(output_amount > 1)
					description += " → [output_amount] × [material["label"]]"
				material_options += list(list(
					"id" = material_id,
					"name" = material["label"],
					"description" = description,
					"input_ids" = input_ids,
					"ready_good_id" = material["refined_good"],
					"requires_steel" = !!material["requires_steel"],
					"direct" = !!material["direct"],
					"can_fund" = taManorCanFundWorkshop(lane_id, material),
				))
			lane_options += list(list(
				"id" = lane_id,
				"name" = lane["name"],
				"processing_name" = lane["processing_name"],
				"workshop_name" = lane["workshop_name"],
				"materials" = material_options,
			))
		production_lanes[type_id] = lane_options
	return list(
		"settings" = list(
			"enabled" = !!preferences.have_manor,
			"name" = preferences.manor_name || "",
			"type" = type_names[preferences.manor_type] \
				? preferences.manor_type : "manor",
			"treasury_retention" = preferences.manor_treasury_retention,
		),
		"manor_types" = manor_types,
		"plans" = plans_by_type["mining_settlement"],
		"plans_by_type" = plans_by_type,
		"production_lanes" = production_lanes,
		"max_name_length" = MAX_NAME_LEN,
		"settings_revision" = settings_revision,
		"settings_error" = settings_error,
	)

/datum/manor_industry_setup/ui_act(
	action,
	list/params,
	datum/tgui/ui,
	datum/ui_state/state
)
	. = ..()
	if(.)
		return
	if(
		action != "save_settings" \
		|| ui_status(ui?.user, state) != UI_INTERACTIVE
	)
		return FALSE
	settings_revision++
	settings_error = saveSettings(
		ui.user,
		params?["settings"],
		params?["profiles"]
	)
	return TRUE

/// Validate everything before mutating preferences.
/datum/manor_industry_setup/proc/saveSettings(
	mob/user,
	list/settings,
	list/profile_changes
)
	if(
		!islist(settings) \
		|| (!isnull(profile_changes) && !islist(profile_changes))
	)
		return "Не удалось прочитать настройки поместья."
	var/new_enabled = settings["enabled"]
	if(!isnum(new_enabled) || (new_enabled != TRUE && new_enabled != FALSE))
		return "Укажи, включено ли поместье."
	var/new_type = settings["type"]
	var/list/type_names = taManorTypeNames()
	if(!istext(new_type) || !type_names[new_type])
		return "Выбери тип поместья из списка."
	var/new_retention = settings["treasury_retention"]
	if(!isnum(new_retention))
		return "Укажи, какой процент дохода оставить в казне."
	new_retention = round(new_retention)
	if(!(new_retention >= 0 && new_retention <= 100))
		return "Доля казны должна быть от 0 до 100%."

	var/current_name = preferences.manor_name || ""
	var/new_name = settings["name"]
	if(!istext(new_name))
		return "Укажи название поместья."
	if(new_name != current_name)
		new_name = reject_bad_name(new_name)
		if(!new_name)
			return "В названии нужны хотя бы две латинские буквы и не больше \
			[MAX_NAME_LEN] символов. Допустимы пробелы, дефис, апостроф, \
			точка и запятая."

	var/origin_type = preferences.virtue_origin?.type
	var/list/new_profiles = taSanitizeManorIndustryProfiles(
		preferences.manor_industry_profiles,
		origin_type
	)
	for(var/type_id in profile_changes)
		var/list/type_changes = profile_changes[type_id]
		if(!type_names[type_id] || !islist(type_changes))
			return "Не удалось определить тип поместья для плана производства."
		var/list/type_profiles = new_profiles[type_id] || list()
		for(var/size in type_changes)
			if(!taManorIndustryLimits(size))
				return "Не удалось определить размер поместья для плана \
				производства."
			var/profile = type_changes[size]
			if(isnull(profile))
				type_profiles -= size
				continue
			var/list/plan = taSanitizeManorIndustryProfile(
				size,
				profile,
				type_id,
				origin_type
			)
			if(!plan)
				return "Не удалось прочитать план производства."
			type_profiles[size] = plan
		if(length(type_profiles))
			new_profiles[type_id] = type_profiles
		else
			new_profiles -= type_id

	if(new_enabled != !!preferences.have_manor)
		preferences.verbose_pref_log_change(
			user,
			"notice",
			"Estate",
			preferences.have_manor ? "Enabled" : "Disabled",
			new_enabled ? "Enabled" : "Disabled"
		)
		preferences.have_manor = new_enabled
		if(new_enabled)
			to_chat(
				user,
				span_notice( \
					"При наличии дворянства, вы сможете управлять имением, \
					которое будет приносить вам доход и предоставлять \
					различные бонусы. Для того, чтобы связаться с имением, \
					используйте ГЕРМЕС." \
				)
			)
		else
			to_chat(
				user,
				span_notice( \
					"При наличии дворянства ваш персонаж будет считаться \
					безземельным дворянином, не получая доступ к имению." \
				)
			)
	if(new_name != current_name)
		preferences.verbose_pref_log_change(
			user,
			"notice",
			"Estate Name",
			preferences.manor_name,
			new_name
		)
		preferences.manor_name = new_name
	if(new_type != preferences.manor_type)
		preferences.verbose_pref_log_change(
			user,
			"notice",
			"Estate Type",
			preferences.manor_type,
			new_type
		)
		preferences.manor_type = new_type
	if(new_retention != preferences.manor_treasury_retention)
		preferences.verbose_pref_log_change(
			user,
			"notice",
			"Treasury Share",
			"[preferences.manor_treasury_retention]%",
			"[new_retention]%"
		)
		preferences.manor_treasury_retention = new_retention
	if(length(profile_changes))
		preferences.manor_industry_profiles = new_profiles
	SStgui.update_uis(preferences)
	return null

/datum/trade_good/fruit/manor_banana
	id = TRADE_GOOD_MANOR_BANANA
	name = "Banana"
	base_price = SELLPRICE_TANGERINE
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/banana

/datum/roguestock/stockpile/manor_banana
	name = "Banana"
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/banana
	trade_good_id = TRADE_GOOD_MANOR_BANANA
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 25
	category = "Fruit"

/datum/trade_good/fruit/manor_watermelon
	id = TRADE_GOOD_MANOR_WATERMELON
	name = "Watermelon"
	base_price = SELLPRICE_TANGERINE
	importable = FALSE
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/watermelon

/datum/roguestock/stockpile/manor_watermelon
	name = "Watermelon"
	item_type = /obj/item/reagent_containers/food/snacks/grown/fruit/watermelon
	trade_good_id = TRADE_GOOD_MANOR_WATERMELON
	importexport_amt = 5
	stockpile_amount = 0
	stockpile_limit = 25
	category = "Fruit"
