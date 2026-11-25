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
	blacklist = list(
		/datum/job/roguetown/absolver, // TA EDIT
		/datum/job/roguetown/manorguard,
		/datum/job/roguetown/warden,
		/datum/job/roguetown/knight,
		/datum/job/roguetown/sergeant,
		/datum/job/roguetown/physician,
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
	slot_adjust = list(
	/datum/job/roguetown/squire = 2,
	/datum/job/roguetown/ordinator = 1, // TA EDIT
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

/datum/map_adjustment/template/rockhill/job_change() // TA EDIT START
	. = ..()
	var/datum/job/inquisitor = SSjob.GetJobType(/datum/job/roguetown/inquisitor)
	inquisitor.job_subclasses -= /datum/advclass/inquisitor/ordinator
	inquisitor.advclass_cat_rolls -= CTAG_ORDINATOR // TA EDIT END
