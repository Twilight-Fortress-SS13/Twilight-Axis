//bog for rockhill - milder spawns than in dunworld

/area/rogue/outdoors/bograt
	name = "Rockhill Bog"
	icon_state = "bog"
	warden_area = TRUE
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 10,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,)
	first_time_text = "THE TERRORBOG"
	converted_type = /area/rogue/indoors/shelter/bograt
	deathsight_message = "a wretched, fetid bog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH
	warden_area = TRUE

/area/rogue/indoors/shelter/bograt
	name = "Rockhill Bog"
	icon_state = "bog"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = FALSE
	loot_budget = LOOT_BUDGET_RH_BOG_SHELTER
	loot_pool_key = "rh_bog_shelter"

/area/rogue/outdoors/bograt/north
	name = "Northern Terrorbog"
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 10,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,)
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH
	deathsight_message = "a waterlogged mire bridging civilization and the wretched, fetid bog"
	warden_area = TRUE
	loot_budget = LOOT_BUDGET_RH_BOG_NORTH
	loot_pool_key = "rh_bog_north"

/area/rogue/outdoors/bograt/south
	name = "Southern Terrorbog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_SOUTH
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 40,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,
		/datum/npc_warband/bog_guard_deserters = 15,
		/datum/npc_warband/bog_guard_deserters/hard = 2,
		/datum/npc_warband/mirespiders_ambush = 30,
		/datum/npc_warband/mirespiders_crawlers = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,)
	deathsight_message = "the depths of the wretched bog, home to old magycks and zizite prayers alike"
	warden_area = FALSE
	loot_budget = LOOT_BUDGET_RH_BOG_SOUTH
	loot_pool_key = "rh_bog_south"

/area/rogue/outdoors/bograt/west
	name = "Western Terrorbog"
	first_time_text = "The Terrormarsh"
	threat_region = THREAT_REGION_ROCKHILL_BOG_WEST
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 5,
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 30,
		/datum/npc_warband/triple_deepone = 30,
		/datum/npc_warband/deepone_party = 20,)
	deathsight_message = "the terrible marsh towards setting sun"
	warden_area = FALSE
	loot_budget = LOOT_BUDGET_RH_BOG_WEST
	loot_pool_key = "rh_bog_west"

/area/rogue/outdoors/bograt/sunken
	name = "Cursed Mire"
	first_time_text = "THE CURSED MIRE"
	threat_region = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 40,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 15,
		/datum/npc_warband/mirespiders_ambush = 110,
		/datum/npc_warband/mirespiders_crawlers = 25,
		/datum/npc_warband/mirespiders_aragn = 10,
		/datum/npc_warband/mirespiders_unfair = 5)
	deathsight_message = "the deepest depths of the mire, as dangerous as it is sunken"
	warden_area = FALSE
	loot_budget = LOOT_BUDGET_RH_BOG_MIRE
	loot_pool_key = "rh_bog_mire"

/area/rogue/outdoors/bograt/safe
	name = "Terrorbog Pass"
	ambush_mobs = null
	deathsight_message = "a foreign, distant pass, leading to the fetid bog"
	warden_area = FALSE

/area/rogue/outdoors/bograt/above
	name = "Terrorbog Above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_mobs = null
	warden_area = FALSE

/area/rogue/under/cave
	warden_area = FALSE

/area/rogue/under/cavewet/deeplair
	name = "Deep Lair"
	first_time_text = "DEEP LAIR"
	loot_budget = LOOT_BUDGET_RH_DEEP_LAIR
	loot_pool_key = "rh_deep_lair"

/area/rogue/under/cave/inhumen/rockhill
	name = "Zizo Church"
	first_time_text = "CHURCH OF ZIZO"
	loot_budget = LOOT_BUDGET_RH_ZIZO_CHURCH
	loot_pool_key = "rh_zizo_church"

/area/rogue/under/cave/licharena/grim/rockhill
	loot_budget = LOOT_BUDGET_RH_LICH_LAIR
	loot_pool_key = "rh_lich_lair"

/area/rogue/under/cavewet/rh_underbog
	name = "Under bog"
	first_time_text = "UNDER BOG"
	loot_budget = LOOT_BUDGET_RH_UNDER_BOG
	loot_pool_key = "rh_under_bog"

/area/rogue/under/cavewet/rh_sea_raiders
	name = "Hidden Grotto"
	first_time_text = "HIDDEN GROTTO"
	loot_budget = LOOT_BUDGET_RH_SEA_RAIDERS
	loot_pool_key = "rh_sea_raiders"

/area/rogue/under/cavelava/rh_lava_east
	name = "East lava caves"
	first_time_text = "EAST LAVA CAVES"
	loot_budget = LOOT_BUDGET_RH_EAST_LAVA
	loot_pool_key = "rh_east_lava"
	droning_sound = 'sound/music/area/caves.ogg'

/area/rogue/under/cavelava/rh_lava_west
	name = "West lava caves"
	first_time_text = "WEST LAVA CAVES"
	loot_budget = LOOT_BUDGET_RH_WEST_LAVA
	loot_pool_key = "rh_west_lava"
	droning_sound = 'sound/music/area/caves.ogg'

/area/rogue/under/town/basement/rh_bog_basement
	name = "Dusty basement"
	loot_budget = LOOT_BUDGET_RH_BOG_SHELTER
	loot_pool_key = "rh_bog_shelter"

/area/rogue/under/cave/skeletoncrypt/rh_skeleton_fort
	name = "Forgotten Fortress"
	first_time_text = "FORGOTTEN FORTRESS"
	loot_budget = LOOT_BUDGET_RH_ROCK_CASTLE
	loot_pool_key = "rh_rock_castle"

/area/rogue/under/cave/rh_cursed_peak
	name = "Caves of the cursed Peak"
	first_time_text = "CAVES OF THE CURSED PEAK"
	loot_budget = LOOT_BUDGET_RH_MOUNTAIN_CAVES
	loot_pool_key = "rh_mountain_caves"

/area/rogue/under/cavewet/rh_bog_caves
	name = "Bog Caves"
	first_time_text = "BOG CAVES"
	loot_budget = LOOT_BUDGET_RH_BOG_CAVES
	loot_pool_key = "rh_bog_caves"

/area/rogue/under/underdark/south/drowdungeon
	name = "Drow Hiedout"
	first_time_text = "DROW HIDEOUT"
	loot_budget = LOOT_BUDGET_RH_DROW_VILLAGE
	loot_pool_key = "rh_drow_village"

/area/rogue/under/cave/mazedungeon/rh_maze_dungeon
	loot_budget = LOOT_BUDGET_RH_MAZE_DUNGEON
	loot_pool_key = "rh_maze_dungeon"

/area/rogue/under/cave/fishmandungeon/rh_fishmandungeon
	loot_budget = LOOT_BUDGET_RH_BOG_FISHMAN
	loot_pool_key = "rh_bog_fishman"

/area/rogue/under/cave/orcdungeon/rh_orcdungeon
	loot_budget = LOOT_BUDGET_RH_ORC_DUNGEON
	loot_pool_key = "rh_orc_dungeon"

/area/rogue/under/kingtomb/rh_kingtomb
	loot_budget = LOOT_BUDGET_RH_KING_DUNGEON
	loot_pool_key = "rh_king_dungeon"

/area/rogue/under/kingtomb/rh_kingtomb/bossarena

/area/rogue/under/kingtomb/rh_kingtomb/approaching
