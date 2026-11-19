/proc/setup_deserttown_economy()
	var/list/desert_regions = build_deserttown_economic_regions()
	if(!GLOB.economic_regions)
		GLOB.economic_regions = list()
	GLOB.economic_regions.Cut()
	for(var/region_id in desert_regions)
		GLOB.economic_regions[region_id] = desert_regions[region_id]
	log_world("DesertTown economy: Loaded [GLOB.economic_regions.len] Al-Ashur economic regions.")

/proc/build_deserttown_economic_regions()
	var/list/regions = list()

	var/datum/economic_region/oasis = deserttown_make_economic_region(
		TRADE_REGION_AL_ASHUR_OASIS,
		"Al-Ashur Oasis",
		"Sultan's granaries, city baths and palm-fed wards",
		"The inner oasis feeds the court, the bazaar and the bathhouses. It exports staples, poultry and civic luxuries, but it constantly hungers for worked metal, cloth, lumber, fish and temple-grade reagents.",
		THREAT_REGION_DESERT_NEAR,
		list(
			TRADE_GOOD_GRAIN = TG_SUPPLY_LOCAL_GRAIN,
			TRADE_GOOD_RICE = TG_SUPPLY_FOREIGN_GRAIN,
			TRADE_GOOD_OATS = TG_SUPPLY_FOREIGN_GRAIN,
			TRADE_GOOD_POULTRY = TG_SUPPLY_MEAT_STAPLE,
			TRADE_GOOD_RABBIT = TG_SUPPLY_MEAT_STAPLE,
			TRADE_GOOD_EGG = TG_SUPPLY_MEAT_BULK,
			TRADE_GOOD_BUTTER = TG_SUPPLY_MEAT_STAPLE,
			TRADE_GOOD_CHEESE = TG_SUPPLY_MEAT_STAPLE,
			TRADE_GOOD_ONION = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_CARROT = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_TURNIP = TG_SUPPLY_COMMON_VEG,
		),
		list(
			TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
			TRADE_GOOD_SILK = TG_DEMAND_SILK,
			TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2,
			TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
			TRADE_GOOD_SALT = TG_DEMAND_SALT,
			TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
			TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
			TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		),
		list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_great_feast_proteins,
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_arcane_commission,
		)
	)
	regions[oasis.region_id] = oasis

	var/datum/economic_region/caravan = deserttown_make_economic_region(
		TRADE_REGION_AL_ASHUR_CARAVAN_ROAD,
		"Al-Ashur Caravan Road",
		"Taxed wells, caravanserais and guarded trade roads",
		"The road between the oasis, the western sea lanes and Zybantian hinterlands lives on guarded caravans. It exports salt, hides, pack goods and rough food, but blockades here bite the whole city.",
		THREAT_REGION_DESERT_NEAR,
		list(
			TRADE_GOOD_SALT = TG_SUPPLY_SALT,
			TRADE_GOOD_HIDE = TG_SUPPLY_LEATHER,
			TRADE_GOOD_FUR = TG_SUPPLY_LEATHER,
			TRADE_GOOD_CURED_LEATHER = TG_SUPPLY_LEATHER,
			TRADE_GOOD_FIBERS = TG_SUPPLY_FIBERS,
			TRADE_GOOD_WOOD = TG_SUPPLY_CHEAP_RAW_MAT,
			TRADE_GOOD_MEAT = TG_SUPPLY_MEAT_BULK,
			TRADE_GOOD_RABBIT = TG_SUPPLY_MEAT_STAPLE,
		),
		list(
			TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
			TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
			TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
			TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
		),
		list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_armaments,
			/datum/standing_order/demand_construction_bulk,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_equipment_armaments,
			/datum/standing_order/demand_equipment_armor_light,
			/datum/standing_order/demand_frontier_gear,
			/datum/standing_order/demand_birthday_gift,
		)
	)
	regions[caravan.region_id] = caravan

	var/datum/economic_region/spice = deserttown_make_economic_region(
		TRADE_REGION_AL_ASHUR_SPICE_DUNES,
		"Spice Dunes",
		"Sheikh-held spice pans and perfumed desert estates",
		"The spice dunes are the prize that set the Sultan against the sheikhs. Their plantations, drying tents and guarded wells send herbs, silk and glass into the bazaar, but demand food, armed protection and refined tools.",
		THREAT_REGION_DESERT_NEAR,
		list(
			TRADE_GOOD_CALENDULA = TG_SUPPLY_SPECIALTY_HERB,
			TRADE_GOOD_POPPY = TG_SUPPLY_SPECIALTY_HERB,
			TRADE_GOOD_DENDOR_ESSENCE = TG_SUPPLY_SPECIALTY_HERB,
			TRADE_GOOD_VISCERA = TG_SUPPLY_SPECIALTY_HERB,
			TRADE_GOOD_SILK = TG_SUPPLY_SILK,
			TRADE_GOOD_GLASS_BATCH = TG_SUPPLY_GLASS,
			TRADE_GOOD_CLAY = TG_SUPPLY_CHEAP_RAW_MAT,
		),
		list(
			TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
			TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
			TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_STEEL_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
			TRADE_GOOD_WOOD = TG_DEMAND_CHEAP_RAW_MAT * 2,
		),
		list(
			/datum/standing_order/demand_exotic,
			/datum/standing_order/demand_alchemical,
			/datum/standing_order/demand_alchemical_warband,
			/datum/standing_order/demand_birthday_gift,
			/datum/standing_order/demand_court_finery,
			/datum/standing_order/demand_jewelry,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_arcane_commission,
		)
	)
	regions[spice.region_id] = spice

	var/datum/economic_region/giza = deserttown_make_economic_region(
		TRADE_REGION_AL_ASHUR_GIZA_ROUTE,
		"Giza Route",
		"Southern grain roads and Zybantian caravan tolls",
		"The southern road binds Al-Ashur to Giza, the Zybantian fields and the imperial coast. It keeps the city fed, but relies on Ashurian salt, leather, glass and escorts.",
		THREAT_REGION_DESERT_NEAR,
		list(
			TRADE_GOOD_GRAIN = TG_SUPPLY_LOCAL_GRAIN,
			TRADE_GOOD_RICE = TG_SUPPLY_FOREIGN_GRAIN,
			TRADE_GOOD_OATS = TG_SUPPLY_FOREIGN_GRAIN,
			TRADE_GOOD_CABBAGE = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_ONION = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_CARROT = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_TURNIP = TG_SUPPLY_COMMON_VEG,
			TRADE_GOOD_CLOTH = TG_SUPPLY_FIBERS,
			TRADE_GOOD_FIBERS = TG_SUPPLY_FIBERS,
		),
		list(
			TRADE_GOOD_SALT = TG_DEMAND_SALT,
			TRADE_GOOD_HIDE = TG_DEMAND_LEATHER,
			TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
			TRADE_GOOD_IRON_INGOT = TG_DEMAND_REFINED_INGOTS,
			TRADE_GOOD_GLASS_BATCH = TG_DEMAND_GLASS,
			TRADE_GOOD_FISH_FILET = TG_DEMAND_FISH_BULK,
			TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
		),
		list(
			/datum/standing_order/demand_rations,
			/datum/standing_order/demand_textile,
			/datum/standing_order/demand_great_feast_proteins,
			/datum/standing_order/demand_construction_bulk,
			/datum/standing_order/demand_victualling_garrison,
			/datum/standing_order/demand_fine_joinery,
			/datum/standing_order/demand_birthday_gift,
		)
	)
	regions[giza.region_id] = giza

	var/datum/economic_region/ruins = deserttown_make_economic_region(
		TRADE_REGION_AL_ASHUR_SUNKEN_RUINS,
		"Sunken Ashurian Ruins",
		"Buried quarries, dead cities and cursed dig sites",
		"Old Ashurian ruins and desert mines yield stone, ores, coal, clay and relic metals. Their camps consume food, cloth and medicine, and their roads are easiest for raiders and dead things to sever.",
		THREAT_REGION_DESERT_DEEP,
		list(
			TRADE_GOOD_IRON_ORE = TG_SUPPLY_IRON,
			TRADE_GOOD_COPPER_ORE = TG_SUPPLY_TIN_BRONZE,
			TRADE_GOOD_TIN_ORE = TG_SUPPLY_TIN_BRONZE,
			TRADE_GOOD_COAL = TG_SUPPLY_IRON,
			TRADE_GOOD_STONE = TG_SUPPLY_CHEAP_RAW_MAT,
			TRADE_GOOD_CLAY = TG_SUPPLY_CHEAP_RAW_MAT,
			TRADE_GOOD_CINNABAR = TG_SUPPLY_PRECIOUS_METAL,
			TRADE_GOOD_GOLD_ORE = TG_SUPPLY_PRECIOUS_METAL,
			TRADE_GOOD_SILVER_ORE = TG_SUPPLY_PRECIOUS_METAL,
			TRADE_GOOD_GLASS_BATCH = TG_SUPPLY_GLASS,
		),
		list(
			TRADE_GOOD_GRAIN = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_RICE = TG_DEMAND_LOCAL_GRAIN,
			TRADE_GOOD_MEAT = TG_DEMAND_MEAT_BULK,
			TRADE_GOOD_CLOTH = TG_DEMAND_CLOTH,
			TRADE_GOOD_CURED_LEATHER = TG_DEMAND_LEATHER,
			TRADE_GOOD_SALT = TG_DEMAND_SALT,
			TRADE_GOOD_CALENDULA = TG_DEMAND_SPECIALTY_HERB,
			TRADE_GOOD_POPPY = TG_DEMAND_SPECIALTY_HERB,
		),
		list(
			/datum/standing_order/demand_smithing,
			/datum/standing_order/demand_construction_bulk,
			/datum/standing_order/demand_victualling_mines,
			/datum/standing_order/demand_artificery,
			/datum/standing_order/demand_artificed_panoply,
			/datum/standing_order/demand_prosthetic_run,
			/datum/standing_order/demand_trophy_heads,
			/datum/standing_order/demand_arcane_commission,
		)
	)
	regions[ruins.region_id] = ruins

	return regions

/proc/deserttown_make_economic_region(region_id, name, subtitle, description, threat_region_id, list/produces, list/demands, list/standing_order_templates)
	var/datum/economic_region/region = new /datum/economic_region()
	region.region_id = region_id
	region.name = name
	region.subtitle = subtitle
	region.description = description
	region.threat_region_id = threat_region_id
	region.associated_marker_id = "[region_id]_blockade"
	region.produces = produces
	region.demands = demands
	region.produces_today = produces.Copy()
	region.demands_today = demands.Copy()
	region.possible_standing_order_types = deserttown_weight_standing_orders(standing_order_templates)
	return region

/proc/deserttown_weight_standing_orders(list/templates)
	var/list/weighted = list()
	for(var/datum/standing_order/template as anything in templates)
		var/datum/standing_order/probe = new template()
		weighted[template] = probe.roll_weight
		qdel(probe)
	return weighted

/datum/threat_region/al_ashur_oasis
	region_name = THREAT_REGION_AL_ASHUR_OASIS
	latent_ambush = 175
	min_ambush = 0
	max_ambush = 350
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 350 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 350 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 35,
		QUEST_FACTION_WILD_BEAST = 25,
		QUEST_FACTION_MADMAN = 40,
	)
	tp_budget_multiplier = 0.75
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 2
	evergreen_target = 2

/datum/threat_region/al_ashur_caravan_road
	region_name = THREAT_REGION_AL_ASHUR_CARAVAN_ROAD
	latent_ambush = 300
	min_ambush = 0
	max_ambush = 650
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 600 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 600 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 60,
		QUEST_FACTION_WILD_BEAST = 25,
		QUEST_FACTION_MADMAN = 15,
	)
	tp_budget_multiplier = 0.95
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/desert_near
	parent_type = /datum/threat_region/al_ashur_caravan_road
	region_name = THREAT_REGION_DESERT_NEAR

/datum/threat_region/al_ashur_spice_dunes
	region_name = THREAT_REGION_AL_ASHUR_SPICE_DUNES
	latent_ambush = 375
	min_ambush = 0
	max_ambush = 800
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 750 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 750 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 55,
		QUEST_FACTION_WILD_BEAST = 20,
		QUEST_FACTION_TARICHEA_DEADITE = 15,
		QUEST_FACTION_MADMAN = 10,
	)
	tp_budget_multiplier = 1.05
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/al_ashur_deep_dunes
	region_name = THREAT_REGION_AL_ASHUR_DEEP_DUNES
	latent_ambush = 450
	min_ambush = 0
	max_ambush = 1000
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 950 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 950 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_WILD_BEAST = 25,
		QUEST_FACTION_TARICHEA_DEADITE = 25,
		QUEST_FACTION_GREAT_BEAST = 20,
	)
	tp_budget_multiplier = 1.20
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/desert_deep
	parent_type = /datum/threat_region/al_ashur_deep_dunes
	region_name = THREAT_REGION_DESERT_DEEP

/datum/threat_region/al_ashur_sunken_ruins
	region_name = THREAT_REGION_AL_ASHUR_SUNKEN_RUINS
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 850 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 850 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_TARICHEA_DEADITE = 45,
		QUEST_FACTION_HIGHWAYMAN = 20,
		QUEST_FACTION_GREAT_BEAST = 20,
		QUEST_FACTION_MADMAN = 15,
	)
	tp_budget_multiplier = 1.15
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/desertdark
	region_name = THREAT_REGION_DESERTDARK
	latent_ambush = 600
	min_ambush = 400
	max_ambush = 1200
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 1200 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1200 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_MIRESPIDER = 30,
		QUEST_FACTION_TARICHEA_DEADITE = 25,
		QUEST_FACTION_GREAT_BEAST = 25,
		QUEST_FACTION_DROW = 20,
	)
	tp_budget_multiplier = 1.5
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	kill_target_floor = 2

/datum/threat_region/desertdark_deep
	region_name = THREAT_REGION_DESERTDARK_DEEP
	latent_ambush = 800
	min_ambush = 600
	max_ambush = 1500
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_REGULAR
	lowpop_tick = 1500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_MIRESPIDER = 20,
		QUEST_FACTION_TARICHEA_DEADITE = 30,
		QUEST_FACTION_GREAT_BEAST = 20,
		QUEST_FACTION_DROW = 30,
	)
	tp_budget_multiplier = 1.75
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	kill_target_floor = 3

