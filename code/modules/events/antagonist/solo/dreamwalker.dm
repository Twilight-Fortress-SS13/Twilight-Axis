/datum/round_event_control/antagonist/solo/dreamwalker
	name = "Dreamwalker"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	//Can roll at any time.
	roundstart = FALSE
	antag_flag = ROLE_DREAMWALKER
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	consumes_hard_antag_slot = FALSE // TA EDIT
	min_players = HARD_ANTAG_MIN_POP

	denominator = 80

	base_antags = 1
	maximum_antags = 2

	weight = 10
	max_occurrences = 2

	earliest_start = 15 MINUTES

	typepath = /datum/round_event/antagonist/solo/dreamwalker
	antag_datum = /datum/antagonist/dreamwalker

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	prompted_picking = TRUE

/datum/round_event_control/antagonist/solo/dreamwalker/canSpawnEvent(players_amt, gamemode, fake_check)
	var/datum/storyteller/preset = active_preset()
	if(!preset?.allow_dreamwalker)
		return FALSE
	return ..()

/datum/round_event/antagonist/solo/dreamwalker

/datum/round_event_control/antagonist/solo/dreamwalker/roundstart // TA EDIT START
	name = "Dreamwalker"
	roundstart = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_SOFT
	min_players = HARD_ANTAG_MIN_POP
	base_antags = 1
	maximum_antags = 1
	max_occurrences = 1
	earliest_start = 0 SECONDS
	prompted_picking = FALSE // TA EDIT END
