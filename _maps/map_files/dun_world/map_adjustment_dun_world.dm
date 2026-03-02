/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/dunworld
	map_file_name = "dun_world.dmm"
	realm_name = "Azure Peak"
	blacklist = list(
		/datum/job/roguetown/royal_guard, 
		/datum/job/roguetown/sheriff, 
		/datum/job/roguetown/town_watch, 
		/datum/job/roguetown/vanguard, 
		/datum/job/roguetown/courtphysician, 
		/datum/job/roguetown/knight_enigma, 
		/datum/job/roguetown/royal_sergeant, 
		/datum/job/roguetown/overseer, 
		/datum/job/roguetown/dungeoneer,
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/bailiff,
	)
	slot_adjust = list(/datum/job/roguetown/villager = 42, /datum/job/roguetown/adventurer = 69)
	title_adjust = list()
	tutorial_adjust = list()
	species_adjust = list()
	sexes_adjust = list()

	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP
	)
