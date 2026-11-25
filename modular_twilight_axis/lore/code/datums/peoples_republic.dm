/**
 * Rite of Liberation
*/

/datum/usurpation_rite/peoples_republic
	name = "Rite of Liberation"
	desc = "Shatter every chain that still binds this realm, and break the crown of the tyrant who oppressed it."
	explanation = {"<p>Those who follow Matthios, Father of Freedom, may invoke this rite to establish a Republic of equals, breaking the Crown and ensuring no tyrannical monarchy can ever claim this land again.</p>\
<p><b>Who may invoke:</b> Followers of Matthios.</p>\
<p><b>How it works:</b> The people of the realm must gather near the throne and speak the words 'I assent' to support your claim. Anyone may assent.</p>\
<p><b>Completion condition:</b> <b>10</b> weighted voices must speak their assent. Matthiosites count as <b>two</b> voices each — they risked everything to assert their right. All others count as one. Once the threshold is reached, the realm is alerted and a contestation period begins — survive it and stay conscious while remaining near the throne, and it is yours.</p>\
<p><b>Restrictions:</b> The undead may not invoke or assent.</p>\
<p><b>Realm type if successful:</b> Freemen Republic, governed by a First Citizen.</p>"}
	new_ruler_title = "First Citizen"
	new_ruler_title_f = "First Citizen"
	new_realm_type = "Freemen Republic"
	new_realm_type_short = "Freemen Republic"
	roundend_epilogue = "The people have spoken, and the old order has crumbled. " + \
		"The realm is ruled by the people, for the people! " + \
		"With blessing of Matthios, First among Equals! " + \
		"The Church may dismiss this as the ruin of rabble, " + \
		"but the people know the truth -- " + \
		"that power belongs to those who have the courage to seize it, " + \
		"and the people to support it!"

/// Matthiosites, no undead.
/datum/usurpation_rite/peoples_republic/can_invoke(mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(HAS_TRAIT(user, TRAIT_ROTMAN) || (user.mob_biotypes & MOB_UNDEAD))
		return FALSE
	// Matthiosites can invoke
	if(istype(user.patron, /datum/patron/inhumen/matthios))
		return TRUE
	return FALSE

/datum/usurpation_rite/peoples_republic/on_gathering_started()
	to_chat(invoker, span_notice("The rite has begun. The people must now speak 'I assent' near the throne. You require [ACCLAIM_REQUIRED_ASSENTS] weighted voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes. Matthiosites count as two voices each. Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/peoples_republic/on_gathering_timeout()
	fail("The people of the realm did not grant sufficient assent.")

/// Override: anyone living can assent. Wide pool, weighted by outlaw status.
/datum/usurpation_rite/peoples_republic/try_assent(mob/living/carbon/human/person)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(person))
		return FALSE
	if(person.stat != CONSCIOUS)
		return FALSE
	if(person == invoker)
		to_chat(person, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(HAS_TRAIT(person, TRAIT_ROTMAN) || (person.mob_biotypes & MOB_UNDEAD))
		to_chat(person, span_warning("The dead have no voice among the living."))
		return FALSE
	if(assenters[person])
		to_chat(person, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(person, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[person] = TRUE
	on_assent_accepted(person)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/peoples_republic/on_assent_accepted(mob/living/carbon/human/person)
	var/weight = get_vote_weight(person)
	var/voice_desc = weight >= ACCLAIM_VOTE_OUTLAW ? "two voices" : "one voice"
	person.visible_message( \
		span_notice("[person.real_name] speaks their assent to the Rite of Liberation."), \
		span_notice("You speak your assent. Your voice is heard."))
	to_chat(invoker, span_notice("[person.real_name] has assented as [voice_desc]. ([get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS])"))

/datum/usurpation_rite/peoples_republic/check_assent_threshold()
	if(get_assent_total() >= ACCLAIM_REQUIRED_ASSENTS)
		start_contesting()

/datum/usurpation_rite/peoples_republic/on_contesting_started()
	priority_announce( \
		"[invoker.real_name] has invoked the Rite of Liberation!\n\n" + \
		"The people of [SSticker.realm_name] have spoken — [invoker.real_name] shall step forth as the First Citizen of [SSticker.realm_name]. A rule by the people, for the people, by blessing of Matthios, First among Equals!\n\n" + \
		"The will of the people shall be settled in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless the claim is struck down.\n\n", \
		"Rite of Liberation", \
		sound_contesting)
	to_chat(invoker, span_notice("The people have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the succession is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/peoples_republic/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.real_name || "Their predecessor"
	..()
	if(invoker?.mind)
		var/datum/antagonist/prebel/rebel_datum = invoker.mind.has_antag_datum(/datum/antagonist/prebel)
		if(rebel_datum && rebel_datum.rev_team)
			rebel_datum.rev_team.rite_won = TRUE
	priority_announce( \
		"A ruler must rule for the benefits of their subjects. And no one is more fit than one elected by their subjects.\n\n" + \
		"The people of [SSticker.realm_name] declare [invoker.real_name] the rightful [SSticker.rulertype], chosen to LIBERATE this land in the name of Matthios.\n\n" + \
		"[old_ruler_name], unable to contest this claim, has lost the confidence of the people, " + \
		"and their authority is hereby revoked.\n\n" + \
		"Long live [invoker.real_name], [SSticker.rulertype] of [SSticker.realm_name], raised up by the will of the freefolk, blessed by Lord of No Realm!", \
		"A New [SSticker.rulertype] Ascends", \
		sound_victory)
	to_chat(invoker, span_notice("The people stand behind you. The throne is yours."))

/datum/usurpation_rite/peoples_republic/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce( \
			"The Rite of Liberation has failed. [reason] The old order holds — for now.", \
			"Rite Failed", \
			sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The Rite of Liberation has failed. [reason]"))


/datum/usurpation_rite/peoples_republic/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "A Rite of Liberation is underway. [get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "The people have affirmed [invoker?.real_name]'s claim. The will of the people approaches."
	return null

/datum/usurpation_rite/peoples_republic/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.real_name] claims the throne by popular will. Speak your assent -- or stop them. ([get_assent_total()]/[ACCLAIM_REQUIRED_ASSENTS] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = ""
			if(contest_time_remaining > 0)
				var/elapsed = world.time - contest_started_at
				var/left = max(contest_time_remaining - elapsed, 0)
				remaining = "[round(left / (1 SECONDS))] seconds"
			else
				remaining = "moments"
			return "The people have spoken. [invoker?.real_name] will ascend in [remaining]. Defend or destroy this claim!"
	return null

/// Returns the vote weight: matthiosites count double, everyone else single.
/datum/usurpation_rite/peoples_republic/proc/get_vote_weight(mob/living/carbon/human/person)
	if(istype(person.patron, /datum/patron/inhumen/matthios))
		return ACCLAIM_VOTE_OUTLAW
	return ACCLAIM_VOTE_CITIZEN

/// Returns the total assent vote weight accumulated so far.
/datum/usurpation_rite/peoples_republic/proc/get_assent_total()
	var/total = 0
	for(var/mob/living/carbon/human/person in assenters)
		total += get_vote_weight(person)
	return total
