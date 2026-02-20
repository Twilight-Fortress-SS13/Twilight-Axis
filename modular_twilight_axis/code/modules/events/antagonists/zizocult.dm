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
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 3

	denominator = 40

	weight = 5
	max_occurrences = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/zizo_cult
	antag_datum = /datum/antagonist/zizocultist

	restricted_roles = ZIZO_CULT_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/zizo_cult
	var/leader = FALSE

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
			J?.current_positions = max(J?.current_positions-1, 0)
			var/datum/antagonist/zizocultist/servante = new /datum/antagonist/zizocultist
			antag_mind.add_antag_datum(servante)
			return

#undef ZIZO_CULT_BLACKLISTED_ROLES
