/datum/threat_region/rockhill_basin
	region_name = THREAT_REGION_ROCKHILL_BASIN
	latent_ambush = 250
	min_ambush = 0
	max_ambush = 500
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 55,
		QUEST_FACTION_FOREST_GOBLIN = 25,
		QUEST_FACTION_WILD_BEAST = 20,
	)
	tp_budget_multiplier = 0.85
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_bog_north
	region_name = THREAT_REGION_ROCKHILL_BOG_NORTH
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	lowpop_tick = 900 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 900 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 40,
		QUEST_FACTION_MIRESPIDER = 25,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_FOREST_GOBLIN = 10,
		QUEST_FACTION_WILD_BEAST = 5,
	)
	tp_budget_multiplier = 1.15
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_bog_west
	region_name = THREAT_REGION_ROCKHILL_BOG_WEST
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	lowpop_tick = 900 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 900 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 35,
		QUEST_FACTION_MIRESPIDER = 25,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_HIGHWAYMAN = 10,
		QUEST_FACTION_WILD_BEAST = 10,
	)
	tp_budget_multiplier = 1.15
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_bog_south
	region_name = THREAT_REGION_ROCKHILL_BOG_SOUTH
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	lowpop_tick = 900 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 900 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 35,
		QUEST_FACTION_BOG_DEADITE = 25,
		QUEST_FACTION_MIRESPIDER = 20,
		QUEST_FACTION_FOREST_GOBLIN = 15,
		QUEST_FACTION_WILD_BEAST = 5,
	)
	tp_budget_multiplier = 1.15
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_bog_sunkmire
	region_name = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE
	latent_ambush = 1200
	min_ambush = 0
	max_ambush = 1200
	fixed_ambush = FALSE
	lowpop_tick = 1200 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1200 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 35,
		QUEST_FACTION_MIRESPIDER = 30,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_BOG_TROLL = 10,
		QUEST_FACTION_FOREST_GOBLIN = 5,
	)
	tp_budget_multiplier = 1.5
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 2
	evergreen_target = 2

/datum/threat_region/rockhill_woods_north
	region_name = THREAT_REGION_ROCKHILL_WOODS_NORTH
	latent_ambush = 250
	min_ambush = 0
	max_ambush = 500
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 45,
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_WILD_BEAST = 25,
	)
	tp_budget_multiplier = 0.9
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_woods_south
	region_name = THREAT_REGION_ROCKHILL_WOODS_SOUTH
	latent_ambush = 400
	min_ambush = 0
	max_ambush = 900
	fixed_ambush = FALSE
	lowpop_tick = 900 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 900 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_WILD_BEAST = 10,
	)
	tp_budget_multiplier = 1.1
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/rockhill_outer_grove
	region_name = THREAT_REGION_ROCKHILL_OUTER_GROVE
	latent_ambush = 250
	min_ambush = 0
	max_ambush = 500
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 35,
		QUEST_FACTION_WILD_BEAST = 25,
	)
	tp_budget_multiplier = 0.85
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2
