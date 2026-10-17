/datum/round_event_control/antagonist/solo/thievesguild
	name = "Гильдия воров"
	tags = list(TAG_VILLIAN, TAG_LOOT)
	roundstart = TRUE
	antag_flag = ROLE_THIEVESGUILD
	shared_occurence_type = SHARED_MINOR_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_pill_label = "Гильдия воров"
	storyteller_rumour_name = "тайная гильдия воров"
	storyteller_slot_key = "Thieves Guild"
	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	base_antags = 1
	maximum_antags = 5
	denominator = 25
	max_occurrences = 1
	earliest_start = -1
	weight = 0
	min_players = 0
	typepath = /datum/round_event/antagonist/solo/thievesguild
	antag_datum = /datum/antagonist/thievesguild

/datum/round_event_control/antagonist/solo/thievesguild/trim_candidates(list/candidates)
	. = ..()
	for(var/mob/living/candidate in .)
		var/role = candidate.mind?.assigned_role
		if(role != "Adventurer" && role != "Towner" && !(role in GLOB.burgher_positions))
			. -= candidate
	return .

/datum/round_event_control/antagonist/solo/thievesguild/preRunEvent()
	if(is_storyteller_soft_antag_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/thievesguild

/datum/controller/subsystem/gamemode/proc/roll_thievesguild_roundstart()
	if(halted_storyteller || !can_run_roundstart || !current_storyteller)
		return
	var/datum/storyteller/preset = current_storyteller
	if(istype(preset, /datum/storyteller/gamemode/extended) || preset.block_soft)
		return
	var/spawn_chance = 5
	if(istype(preset, /datum/storyteller/gamemode/guaranteed_antag/low_wretch))
		spawn_chance = 15
	else if(istype(preset, /datum/storyteller/gamemode/guaranteed_antag))
		spawn_chance = 20
	else if(istype(preset, /datum/storyteller/gamemode/no_antag/small_wretch))
		spawn_chance = 4
	else if(istype(preset, /datum/storyteller/gamemode/no_antag/standard))
		spawn_chance = 7
	else if(istype(preset, /datum/storyteller/gamemode/no_antag))
		spawn_chance = 10
	else if(istype(preset, /datum/storyteller/gamemode/admin))
		spawn_chance = 5
	if(!prob(spawn_chance))
		return
	var/pop = get_correct_popcount()
	for(var/datum/round_event_control/antagonist/solo/thievesguild/event in event_pools[EVENT_TRACK_CHARACTER_INJECTION])
		if(event.occurrences || !event.canSpawnEvent(pop, null, TRUE))
			return
		log_storyteller("Rolling Thieves Guild as a rare bonus roundstart antag on [preset.name] ([spawn_chance]% chance).")
		TriggerEvent(event, TRUE)
		return
