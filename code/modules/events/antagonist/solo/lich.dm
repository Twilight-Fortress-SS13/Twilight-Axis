/datum/round_event_control/antagonist/solo/lich
	name = "Lich"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_LICH
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_rumour_name = "liches"

	denominator = 80

	base_antags = 1
	maximum_antags = 1

	weight = 11	//i hate you
	max_occurrences = 1 // mashallah

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/lich
	antag_datum = /datum/antagonist/lich

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/lich/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/lich
/datum/round_event/antagonist/solo/lich/setup() // TA EDIT START
	..()
	if(!setup || SSticker.HasRoundStarted() || SSgamemode?.roundstart_live)
		return
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/mob/dead/new_player/player = antag_mind.current
		if(!istype(player) || !antag_mind.assigned_role)
			continue
		SSrole_class_handler.clear_roundstart_subclass_state(player.ckey)
		SSgamemode.roundstart_build_replacement_minds |= antag_mind // TA EDIT END
