/datum/round_event_control/antagonist/solo/vampires
	name = "Vampires"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_pill_label = "Vampire Lord"
	storyteller_rumour_name = "lycker lords"

	weight = 9
	max_occurrences = 1

	denominator = 80

	base_antags = 1
	maximum_antags = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/vampire
	antag_datum = /datum/antagonist/vampire

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/vampires/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/vampire
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampire/setup() // TA EDIT START
	..()
	if(!setup || SSticker.HasRoundStarted() || SSgamemode?.roundstart_live)
		return
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/mob/dead/new_player/player = antag_mind.current
		if(!istype(player) || !antag_mind.assigned_role)
			continue
		var/datum/job/old_job = SSjob.GetJob(antag_mind.assigned_role)
		if(old_job)
			old_job.current_positions = max(old_job.current_positions - 1, 0)
		SSrole_class_handler.clear_roundstart_subclass_state(player.ckey)
		SSgamemode.roundstart_build_replacement_minds |= antag_mind // TA EDIT END

/datum/round_event/antagonist/solo/vampire/add_datum_to_mind(datum/mind/antag_mind)
	if(!leader)
		var/datum/antagonist/vampire/lord/lorde = new /datum/antagonist/vampire/lord()
		antag_mind.add_antag_datum(lorde)
		leader = TRUE
		return
	else
		if(!antag_mind.has_antag_datum(antag_datum))
			var/datum/antagonist/vampire/servante = new /datum/antagonist/vampire(forced_clan = null, generation = GENERATION_ANCILLAE)
			antag_mind.add_antag_datum(servante)
			return
