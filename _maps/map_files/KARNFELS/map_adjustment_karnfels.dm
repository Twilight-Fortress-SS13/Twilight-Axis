/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/karnfels
	map_file_name = "via_world2.dmm"
	realm_name = "Twilight Axis"
	blacklist = list(
		/datum/job/roguetown/royal_guard,
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/courtphysician,
		/datum/job/roguetown/knight_enigma,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/bailiff,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		/datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/slave,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Burggraf", f_title = "Burggraf"),
		/datum/job/roguetown/priest = list(display_title = "Erzpriester", f_title = "Erzpriester")
	)
	trait_adjust = list(
		/datum/job/roguetown/priest = list(TRAIT_CHOSEN, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT, TRAIT_MEDICINE_EXPERT, TRAIT_CLERGY, TRAIT_MARRIAGE_CAPABLE, TRAIT_NOPAINSTUN)
	)
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
