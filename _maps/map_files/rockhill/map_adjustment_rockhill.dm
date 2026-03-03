/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

/datum/map_adjustment/template/rockhill
	map_file_name = "rockhill.dmm"
	realm_name = "Enigma"
	realm_type = "Kingdom"
	realm_type_short = "Kingdom"
	blacklist = list(/datum/job/roguetown/manorguard, /datum/job/roguetown/warden, /datum/job/roguetown/knight, /datum/job/roguetown/sergeant, /datum/job/roguetown/physician)
	slot_adjust = list(
	/datum/job/roguetown/squire = 2,
	/datum/job/roguetown/wapprentice = 3,
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "King", f_title = "Queen")
	)
	
	threat_regions = list(
		THREAT_REGION_ROCKHILL_BASIN,
		THREAT_REGION_ROCKHILL_BOG_NORTH,
		THREAT_REGION_ROCKHILL_BOG_WEST,
		THREAT_REGION_ROCKHILL_BOG_SOUTH,
		THREAT_REGION_ROCKHILL_BOG_SUNKMIRE,
		THREAT_REGION_ROCKHILL_WOODS_NORTH,
		THREAT_REGION_ROCKHILL_WOODS_SOUTH
	)
