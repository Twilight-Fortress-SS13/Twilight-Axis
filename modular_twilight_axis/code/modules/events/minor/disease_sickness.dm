/datum/round_event_control/disease_sickness
	name = "Sickness"
	track = EVENT_TRACK_MUNDANE
	typepath = /datum/round_event/disease_sickness
	weight = 7
	max_occurrences = 6
	min_players = 50
	earliest_start = 8 MINUTES

	tags = list(
		TAG_MEDICAL,
		TAG_ALCHEMY,
	)

/datum/round_event/disease_sickness
	var/list/disease_pool = list(
		/datum/disease/flu,
		/datum/disease/grime_flu,
		/datum/disease/derma_tick,
	)
	var/min_targets = 1
	var/max_targets = 3

/datum/round_event/disease_sickness/start()
	. = ..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H || H.stat == DEAD || !H.client)
			continue
		valid_targets += H
	if(!length(valid_targets))
		return

	var/disease_type = pick(disease_pool)
	var/target_count = clamp(round(length(valid_targets) / 8), min_targets, max_targets)
	for(var/i = 1 to target_count)
		var/mob/living/carbon/human/target = pick_n_take(valid_targets)
		if(!target)
			break
		var/datum/disease/D = new disease_type()
		target.ForceContractDisease(D, FALSE, TRUE)
