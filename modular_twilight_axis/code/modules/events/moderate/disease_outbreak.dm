/datum/round_event_control/disease_outbreak
	name = "Disease Outbreak"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/disease_outbreak
	weight = 4
	max_occurrences = 4
	min_players = 50
	earliest_start = 12 MINUTES

	tags = list(
		TAG_MEDICAL,
		TAG_ALCHEMY,
	)

/datum/round_event/disease_outbreak
	var/list/disease_pool = list(
		/datum/disease/ash_blight,
		/datum/disease/vision_rot,
		/datum/disease/flash_frenzy,
	)
	var/min_targets = 1
	var/max_targets = 2

/datum/round_event/disease_outbreak/start()
	. = ..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H || H.stat == DEAD || !H.client)
			continue
		valid_targets += H
	if(!length(valid_targets))
		return

	var/disease_type = pick(disease_pool)
	var/target_count = clamp(round(length(valid_targets) / 12), min_targets, max_targets)
	for(var/i = 1 to target_count)
		var/mob/living/carbon/human/target = pick_n_take(valid_targets)
		if(!target)
			break
		var/datum/disease/D = new disease_type()
		target.ForceContractDisease(D, FALSE, TRUE)
