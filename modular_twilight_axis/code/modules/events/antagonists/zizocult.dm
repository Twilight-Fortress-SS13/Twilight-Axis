// Формула рассчета сколько нужно игроков для возвышения, плюс фиксация этого числа раундстартом.
/datum/antag_retainer/proc/set_cult_ascension_required_cultists(player_count)
	cult_ascension_required_cultists = max(1, round(player_count / 6))

/datum/antag_retainer/proc/get_cult_ascension_required_cultists()
	if(cult_ascension_required_cultists <= 0)
		var/player_count = 1
		if(SSgamemode)
			player_count = max(1, SSgamemode.ready_players)
		set_cult_ascension_required_cultists(player_count)

	return cult_ascension_required_cultists

#define ZIZO_CULT_BLACKLISTED_ROLES list(\
		"Grand Duke",\
		"Marshal",\
		"Merchant",\
		"Bishop",\
		"Martyr",\
		"Hand",\
		"Steward",\
		"Knight Captain",\
		"Knight",\
		"Templar",\
		"Sergeant",\
		"Inquisitor",\
		"Absolver",\
		"Veteran",\
		"Bathmaster",\
		"Bandit",\
		"Guildmaster",\
		"Court Magician",\
		"Keeper",\
		"Orthodoxist",\
		"Druid",\
		"Acolyte",\
		"Man at Arms",\
		"Squire",\
		"Prince",\
		"Wretch",\
	)

/datum/round_event_control/antagonist/solo/zizo_cult
	name = "Zizo cult"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_CULT
	antag_datum = /datum/antagonist/zizocultist
	shared_occurence_type = SHARED_HIGH_THREAT

	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_guarantee_flags = STORYTELLER_FAVOR_LICH // При Зизо выпадает или культ или лич
	allowed_storytellers = list(/datum/storyteller/zizo)

	base_antags = 1
	maximum_antags = 5
	denominator = 40
	weight = 2
	max_occurrences = 1
	earliest_start = 0 SECONDS
	typepath = /datum/round_event/antagonist/solo/zizo_cult
	restricted_roles = ZIZO_CULT_BLACKLISTED_ROLES


/datum/round_event/antagonist/solo/zizo_cult
	var/leader = FALSE

/datum/round_event_control/antagonist/solo/zizo_cult/preRunEvent()
	if(SSmapping?.retainer && SSmapping.retainer.cult_ascension_required_cultists <= 0)
		var/roundstart_ready = 0

		if(SSgamemode)
			roundstart_ready = SSgamemode.ready_players
			if(roundstart_ready <= 0)
				SSgamemode.calculate_ready_players()
				roundstart_ready = SSgamemode.ready_players

		if(roundstart_ready <= 0)
			roundstart_ready = length(GLOB.joined_player_list)

		SSmapping.retainer.set_cult_ascension_required_cultists(roundstart_ready)

	return ..()

/datum/round_event/antagonist/solo/zizo_cult/add_datum_to_mind(datum/mind/antag_mind)
	if(!leader)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.current_positions = max(J?.current_positions-1, 0)
		var/datum/antagonist/zizocultist/leader/lorde = new /datum/antagonist/zizocultist/leader()
		antag_mind.add_antag_datum(lorde)
		leader = TRUE
		return
	else
		if(!antag_mind.has_antag_datum(antag_datum))
			var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
			J?.current_positions = max(J?.current_positions-3, 0)
			var/datum/antagonist/zizocultist/servante = new /datum/antagonist/zizocultist
			antag_mind.add_antag_datum(servante)
			return

#undef ZIZO_CULT_BLACKLISTED_ROLES
