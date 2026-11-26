/datum/round_event_control/antagonist/solo/renegade
	name = "Renegades"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_RENEGADE
	shared_occurence_type = SHARED_MINOR_THREAT // TA EDIT START
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	consumes_hard_antag_slot = FALSE
	track = EVENT_TRACK_CHARACTER_INJECTION // TA EDIT END

	maximum_antags = 0
	max_occurrences = 1

	earliest_start = 0 SECONDS

	antag_datum = /datum/antagonist/renegade

	restricted_roles = RENEGADE_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/renegade/get_antag_amount()
	var/admin_slot = SSgamemode.get_admin_slot(antag_datum, storyteller_slot_key)
	if(!isnull(admin_slot))
		return max(0, admin_slot)
	return SSgamemode.story_antag_slot_cap(antag_datum, roundstart = roundstart)

/datum/round_event_control/antagonist/solo/renegade/get_candidates() // TA EDIT START
	var/list/candidates = ..()
	for(var/mob/living/carbon/human/H in candidates)
		if(H.stat == DEAD || H.advsetup || H.client?.is_afk() || H.mind?.special_role)
			candidates -= H
	return candidates // TA EDIT END
