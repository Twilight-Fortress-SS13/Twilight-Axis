/datum/familytree_probe
	var/list/violations = list()
	var/list/notes = list()

	var/offers = 0
	var/buttons_shown = 0
	var/presses = 0
	var/ignored = 0
	var/overlaps = 0
	var/peak_concurrent = 0

	var/accepted = 0
	var/rejected = 0
	var/expired = 0

	var/total_hold_ds = 0
	var/max_hold_ds = 0
	var/min_window_ds = -1
	var/max_window_ds = 0

	var/pending_leaked = 0
	var/sessions_opened = 0
	var/sessions_closed = 0

	var/list/live_by_person = list()
	var/list/open_sessions = list()
	var/list/spawned_cast = list()

/datum/familytree_probe/Destroy()
	release()
	violations = null
	notes = null
	return ..()

/datum/familytree_probe/proc/fault(text)
	violations += text
	return FALSE

/datum/familytree_probe/proc/note(text)
	notes += text

/datum/familytree_probe/proc/release()
	for(var/datum/family_confirm_session/session as anything in open_sessions)
		if(!QDELETED(session))
			qdel(session)
	open_sessions = list()
	live_by_person = list()
	clear_cast()
	drop_houses()

/datum/familytree_probe/proc/open_offer(mob/living/carbon/human/first, mob/living/carbon/human/second)
	RETURN_TYPE(/datum/family_confirm_session)
	if(!first || !second || first == second)
		fault("an offer needs two distinct people")
		return null

	offers++
	if(live_by_person[first])
		overlaps++
		fault("[first.real_name] was offered a second confirmation while one was still live")
	if(live_by_person[second])
		overlaps++
		fault("[second.real_name] was offered a second confirmation while one was still live")

	var/datum/family_confirm_session/session = new(first, second, null, "probe", null, null)
	session.deadline = world.time + MUTUAL_CONFIRM_TIMEOUT
	first.familytree_confirmation_pending = TRUE
	second.familytree_confirmation_pending = TRUE
	live_by_person[first] = session
	live_by_person[second] = session
	open_sessions += session
	buttons_shown += 2
	sessions_opened++
	peak_concurrent = max(peak_concurrent, round(length(live_by_person) / 2))
	return session

/datum/familytree_probe/proc/press(datum/family_confirm_session/session, is_person_a, hold_ds, accept = TRUE)
	if(QDELETED(session) || session.resolved)
		return FALSE

	session.deadline -= hold_ds
	total_hold_ds += hold_ds
	max_hold_ds = max(max_hold_ds, hold_ds)

	if(!session.extend_for_prompt(is_person_a))
		return FALSE
	presses++

	var/window_ds = session.deadline - world.time
	if(min_window_ds < 0 || window_ds < min_window_ds)
		min_window_ds = window_ds
	max_window_ds = max(max_window_ds, window_ds)

	if(window_ds < MUTUAL_CONFIRM_ANSWER_WINDOW)
		fault("a press after [hold_ds / 10]s left only [window_ds / 10]s to answer; the deadline burns while the button waits unclicked")

	if(is_person_a)
		session.result_a = accept ? CONFIRM_ACCEPTED : CONFIRM_REJECTED
	else
		session.result_b = accept ? CONFIRM_ACCEPTED : CONFIRM_REJECTED
	if(accept)
		accepted++
	else
		rejected++
	return TRUE

/datum/familytree_probe/proc/ignore_offer()
	ignored++

/datum/familytree_probe/proc/settle(datum/family_confirm_session/session)
	if(QDELETED(session))
		return
	var/mob/living/carbon/human/first = session.person_a
	var/mob/living/carbon/human/second = session.person_b
	var/was_pending = (session.result_a == CONFIRM_PENDING || session.result_b == CONFIRM_PENDING)

	if(was_pending)
		expired++
		session.force_timeout()
	else
		session.check_resolution()
	sessions_closed++
	open_sessions -= session

	for(var/mob/living/carbon/human/person in list(first, second))
		if(!person || QDELETED(person))
			continue
		live_by_person -= person
		if(person.familytree_confirmation_pending)
			pending_leaked++
			fault("[person.real_name] is still marked pending after the offer closed, so the queue will never look at them again")
			person.familytree_confirmation_pending = FALSE

	if(!QDELETED(session))
		fault("a settled session was not disposed of, so its timer is still armed")
		qdel(session)

/datum/familytree_probe/proc/run_confirm_storm(list/people, rounds = 4, max_hold_seconds = 115)
	if(length(people) < 2)
		return fault("a confirmation storm needs at least two people")

	for(var/round_index in 1 to rounds)
		var/list/pool = shuffle(people.Copy())
		while(length(pool) >= 2)
			var/mob/living/carbon/human/first = pool[1]
			var/mob/living/carbon/human/second = pool[2]
			pool.Cut(1, 3)
			var/datum/family_confirm_session/session = open_offer(first, second)
			if(!session)
				continue

			var/hold_a = rand(0, max_hold_seconds) * 10
			var/hold_b = rand(0, max_hold_seconds) * 10

			switch(rand(1, 10))
				if(1 to 5)
					press(session, TRUE, hold_a, TRUE)
					press(session, FALSE, hold_b, TRUE)
				if(6 to 7)
					press(session, TRUE, hold_a, TRUE)
					press(session, FALSE, hold_b, FALSE)
				if(8)
					press(session, TRUE, hold_a, FALSE)
					ignore_offer()
				if(9)
					ignore_offer()
					press(session, FALSE, hold_b, TRUE)
				else
					ignore_offer()
					ignore_offer()

			settle(session)

	if(length(live_by_person))
		fault("[round(length(live_by_person) / 2)] offers never closed")
	if(sessions_opened != sessions_closed)
		fault("opened [sessions_opened] offers but closed [sessions_closed]")
	for(var/mob/living/carbon/human/person as anything in people)
		if(person && !QDELETED(person) && person.familytree_confirmation_pending)
			fault("[person.real_name] ends the storm still pending")
	return !length(violations)

/datum/familytree_probe/proc/run_late_press_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	var/datum/family_confirm_session/session = open_offer(first, second)
	if(!session)
		return FALSE

	var/burn = MUTUAL_CONFIRM_TIMEOUT - 10
	session.deadline -= burn
	session.extend_for_prompt(TRUE)
	var/window_ds = session.deadline - world.time
	if(window_ds < MUTUAL_CONFIRM_ANSWER_WINDOW)
		fault("pressing at the very end of the offer left [window_ds / 10]s, not a full answering window")
	session.result_a = CONFIRM_ACCEPTED
	session.result_b = CONFIRM_ACCEPTED
	settle(session)
	return !length(violations)


/datum/familytree_probe/proc/spawn_cast(count, turf/spot)
	RETURN_TYPE(/list)
	if(!spot)
		fault("a storm needs a turf to stand its cast on")
		return list()
	for(var/i in 1 to count)
		var/mob/living/carbon/human/body = new(spot)
		body.real_name = "Probe [i]"
		body.name = body.real_name
		spawned_cast += body
	return spawned_cast

/datum/familytree_probe/proc/clear_cast()
	for(var/mob/living/carbon/human/body as anything in spawned_cast)
		if(body && !QDELETED(body))
			qdel(body)
	spawned_cast = list()

/datum/familytree_probe/proc/report()
	var/list/out = list()
	out += "offers:   [offers] made, [buttons_shown] buttons shown, [presses] pressed, [ignored] left alone"
	out += "overlap:  [overlaps] collisions, peak [peak_concurrent] offers live at once"
	out += "answers:  [accepted] accepted, [rejected] refused, [expired] expired unanswered"
	out += "holding:  average [presses ? round(total_hold_ds / presses / 10, 0.1) : 0]s before pressing, longest [max_hold_ds / 10]s"
	out += "window:   shortest [min_window_ds < 0 ? "n/a" : min_window_ds / 10]s left after pressing, longest [max_window_ds / 10]s"
	out += "queue:    [pending_leaked] people left stuck pending, [sessions_opened] opened / [sessions_closed] closed"
	if(length(notes))
		out += "notes:"
		for(var/line in notes)
			out += "  . [line]"
	if(length(violations))
		out += "FAULTS ([length(violations)]):"
		for(var/line in violations)
			out += "  - [line]"
	else
		out += "no faults"
	return out.Join("\n")
