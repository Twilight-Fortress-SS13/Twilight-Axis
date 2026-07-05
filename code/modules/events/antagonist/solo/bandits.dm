/datum/round_event_control/antagonist/solo/bandits
	name = "Bandits"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = FALSE
	antag_flag = ROLE_BANDIT
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_rumour_name = "bandits"

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 0
	maximum_antags = 0

	earliest_start = 0 SECONDS

	weight = 0

	typepath = /datum/round_event/antagonist/solo/bandits
	antag_datum = /datum/antagonist/bandit

/datum/round_event/antagonist/solo/bandits
	var/leader = FALSE

/datum/round_event_control/antagonist/solo/bandits/preRunEvent()
	return EVENT_CANT_RUN

/datum/round_event/antagonist/solo/bandits/start()
	return

/datum/round_event_control/antagonist/solo/bandits/canSpawnEvent(players_amt, gamemode, fake_check)
	return FALSE
