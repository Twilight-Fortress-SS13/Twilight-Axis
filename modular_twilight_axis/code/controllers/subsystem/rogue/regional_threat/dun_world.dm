/datum/threat_region/azure_basin
	region_name = THREAT_REGION_AZURE_BASIN
	latent_ambush = 150
	min_ambush = 0
	max_ambush = 375
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 375 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 375 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 60,
		QUEST_FACTION_FOREST_GOBLIN = 25,
		QUEST_FACTION_WILD_BEAST = 15,
	)
	tp_budget_multiplier = 0.75
	kill_target_floor = 3
	evergreen_target = 2
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)

/datum/threat_region/azure_grove
	region_name = THREAT_REGION_AZURE_GROVE
	latent_ambush = 375
	min_ambush = 0
	max_ambush = 750
	fixed_ambush = FALSE
	ambush_budget_pct = AMBUSH_BUDGET_PCT_SAFE_REGION
	lowpop_tick = 750 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 750 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_WILD_BEAST = 10,
	)
	tp_budget_multiplier = 1.0
	kill_target_floor = 4
	evergreen_target = 2

/datum/threat_region/terrorbog
	region_name = THREAT_REGION_TERRORBOG
	latent_ambush = 1500
	min_ambush = 0
	max_ambush = 1500
	fixed_ambush = FALSE
	lowpop_tick = 1500 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1500 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 40,
		QUEST_FACTION_MIRESPIDER = 25,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_BOG_TROLL = 10,
		QUEST_FACTION_FOREST_GOBLIN = 5,
	)
	tp_budget_multiplier = 1.5
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	kill_target_floor = 3
	evergreen_target = 2

/datum/threat_region/azure_coast
	region_name = THREAT_REGION_AZUREAN_COAST
	latent_ambush = 500
	min_ambush = 225
	max_ambush = 800
	fixed_ambush = FALSE
	lowpop_tick = 800 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 800 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_ORC = 30,
		QUEST_FACTION_SEA_GOBLIN = 25,
		QUEST_FACTION_GRONNMAN = 20,
		QUEST_FACTION_BLEAKISLE_REAVER = 15,
		QUEST_FACTION_HIGHWAYMAN = 10,
	)
	tp_budget_multiplier = 1.2
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	kill_target_floor = 2

/datum/threat_region/mount_decap
	region_name = THREAT_REGION_MOUNT_DECAP
	latent_ambush = 600
	min_ambush = 300
	max_ambush = 1000
	fixed_ambush = FALSE
	lowpop_tick = 1000 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1000 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_HELL_GOBLIN = 25,
		QUEST_FACTION_TARICHEA_DEADITE = 20,
		QUEST_FACTION_MOUNT_REAVER = 20,
		QUEST_FACTION_MOUNTAIN_TROLL = 15,
		QUEST_FACTION_MINOTAUR = 10,
		QUEST_FACTION_GREAT_BEAST = 5,
		QUEST_FACTION_MADMAN = 5,
	)
	tp_budget_multiplier = 1.5
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	kill_target_floor = 2

/datum/threat_region/underdark
	region_name = THREAT_REGION_UNDERDARK
	latent_ambush = 600
	min_ambush = 400
	max_ambush = 1200
	fixed_ambush = FALSE
	lowpop_tick = 1200 * THREAT_LOWPOP_TICK_RATE
	highpop_tick = 1200 * THREAT_HIGHPOP_TICK_RATE
	faction_weights = list(
		QUEST_FACTION_DROW = 30,
		QUEST_FACTION_MIRESPIDER = 25,
		QUEST_FACTION_MOON_GOBLIN = 25,
		QUEST_FACTION_LICH_DEADITE = 10,
		QUEST_FACTION_MINOTAUR = 10,
	)
	tp_budget_multiplier = 1.5
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	kill_target_floor = 2
