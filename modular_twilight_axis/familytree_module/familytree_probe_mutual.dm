GLOBAL_LIST_INIT(familytree_probe_confirm_types, list(
	"family",
	"house",
	"sibling_house",
	"spouse",
	"targeted_spouse",
	"dynasty",
	"relative",
))

/datum/familytree_probe
	var/guards_checked = 0
	var/types_rendered = 0
	var/blocks_checked = 0

/datum/familytree_probe/proc/session_count()
	var/found = 0
	for(var/datum/family_confirm_session/session in world)
		if(!QDELETED(session))
			found++
	return found

/datum/familytree_probe/proc/run_mutual_guard_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	if(!first || !second)
		return fault("the guard probe needs two people")

	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE

	first.familytree_opted_out = TRUE
	SSfamilytree.request_mutual_confirmation(first, second, null, "family")
	guards_checked++
	if(first.familytree_confirmation_pending || second.familytree_confirmation_pending)
		fault("an offer to someone who opted out left a pending flag behind")
	first.familytree_opted_out = FALSE
	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE

	first.familytree_confirmation_pending = TRUE
	SSfamilytree.request_mutual_confirmation(first, second, null, "family")
	guards_checked++
	if(second.familytree_confirmation_pending)
		fault("an offer was opened against someone already holding a confirmation")
	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE

	SSfamilytree.request_mutual_confirmation(first, second, null, "family")
	guards_checked++
	if(first.familytree_confirmation_pending || second.familytree_confirmation_pending)
		fault("an offer to people without clients left them marked pending, so the queue would skip them forever")

	SSfamilytree.request_mutual_confirmation(first, null, null, "family")
	SSfamilytree.request_mutual_confirmation(null, second, null, "family")
	SSfamilytree.request_mutual_confirmation(first, first, null, "family")
	guards_checked += 3

	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE
	return !length(violations)

/datum/familytree_probe/proc/run_timeout_block_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	if(!first?.ckey || !second?.ckey)
		return fault("the block probe needs two people with ckeys")

	first.familytree_timeout_blocks = null
	second.familytree_timeout_blocks = null

	if(SSfamilytree.familytree_pair_blocked(first, second))
		return fault("a fresh pair is already blocked")

	SSfamilytree.familytree_record_timeout_block(first, second)
	blocks_checked++
	if(!SSfamilytree.familytree_pair_blocked(first, second))
		fault("an unanswered offer must hold the pair back, or the queue re-offers it at once")
	if(!SSfamilytree.familytree_pair_blocked(second, first))
		fault("the hold-back must read the same from either side")

	for(var/i in 1 to FAMILYTREE_TIMEOUT_BLOCK_ITERATIONS)
		if(!SSfamilytree.familytree_pair_blocked(first, second))
			fault("the hold-back expired after [i - 1] of [FAMILYTREE_TIMEOUT_BLOCK_ITERATIONS] iterations")
			break
		SSfamilytree.familytree_tick_timeout_blocks(first)
		SSfamilytree.familytree_tick_timeout_blocks(second)
		blocks_checked++

	if(SSfamilytree.familytree_pair_blocked(first, second))
		fault("the hold-back outlived its [FAMILYTREE_TIMEOUT_BLOCK_ITERATIONS] iterations, so the pair never meets again")

	first.familytree_timeout_blocks = null
	second.familytree_timeout_blocks = null
	return !length(violations)

/datum/familytree_probe/proc/run_confirm_text_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	if(!first || !second)
		return fault("the text probe needs two people")

	var/list/types = GLOB.familytree_probe_confirm_types.Copy()
	types += "a_type_no_one_has_written_yet"

	for(var/confirm_type in types)
		for(var/mutual in list(TRUE, FALSE))
			var/text = SSfamilytree.familytree_confirmation_found_text(confirm_type, first, second, mutual, null)
			types_rendered++
			if(!length(text))
				fault("confirmation type \"[confirm_type]\" renders no text[mutual ? " on the mutual path" : ""], so the prompt would open blank")
		var/body = SSfamilytree.familytree_confirmation_prompt_body("проба", first, second)
		if(!length(body))
			fault("confirmation type \"[confirm_type]\" renders an empty prompt body")
	return !length(violations)


/datum/familytree_probe
	var/gate_outcomes = 0
	var/sessions_probed = 0

/datum/familytree_probe/proc/expect_gate(mob/living/carbon/human/first, mob/living/carbon/human/second, deferred, client_a, client_b, busy_a, busy_b, expected, story)
	gate_outcomes++
	var/got = SSfamilytree.mutual_gate(first, second, deferred, client_a, client_b, busy_a, busy_b)
	if(got != expected)
		fault("[story]: the gate answered [got], expected [expected]")

/datum/familytree_probe/proc/run_gate_matrix_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	if(!first || !second)
		return fault("the gate matrix needs two people")

	first.familytree_opted_out = FALSE
	second.familytree_opted_out = FALSE
	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE

	expect_gate(null, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_INVALID, "a missing first participant")
	expect_gate(first, null, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_INVALID, "a missing second participant")
	expect_gate(first, first, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_INVALID, "someone offered to themselves")

	expect_gate(first, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_OK, "two willing people with clients")
	expect_gate(first, second, FALSE, FALSE, TRUE, null, null, MUTUAL_GATE_NO_CLIENT, "the first side without a client")
	expect_gate(first, second, FALSE, TRUE, FALSE, null, null, MUTUAL_GATE_NO_CLIENT, "the second side without a client")

	expect_gate(first, second, FALSE, TRUE, TRUE, "занят", null, MUTUAL_GATE_BUSY, "the first side busy")
	expect_gate(first, second, FALSE, TRUE, TRUE, null, "занят", MUTUAL_GATE_BUSY, "the second side busy")
	expect_gate(first, second, TRUE, TRUE, TRUE, "занят", null, MUTUAL_GATE_BUSY, "a deferred retry that is still busy")

	first.familytree_confirmation_pending = TRUE
	expect_gate(first, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_PENDING, "one side already holding an offer")
	expect_gate(first, second, TRUE, TRUE, TRUE, null, null, MUTUAL_GATE_OK, "a deferred retry may reuse its own pending flag")
	expect_gate(first, second, FALSE, TRUE, TRUE, "занят", null, MUTUAL_GATE_PENDING, "pending outranks busy")
	first.familytree_confirmation_pending = FALSE

	SSfamilytree.round_disabled = TRUE
	expect_gate(first, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_DISABLED, "the whole system switched off for the round")
	SSfamilytree.round_disabled = FALSE

	for(var/i in 1 to FAMILYTREE_PAIR_OFFER_LIMIT)
		SSfamilytree.familytree_record_pair_offer(first, second)
	expect_gate(first, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_OFFER_LIMIT, "a pair already offered to each other its full allowance")
	SSfamilytree.familytree_round_ledger.Cut()

	first.familytree_opted_out = TRUE
	expect_gate(first, second, FALSE, TRUE, TRUE, null, null, MUTUAL_GATE_OPTED_OUT, "someone who opted out")
	expect_gate(first, second, FALSE, FALSE, FALSE, "занят", "занят", MUTUAL_GATE_OPTED_OUT, "opting out outranks busy and missing clients")
	first.familytree_opted_out = FALSE

	return !length(violations)

/datum/familytree_probe/proc/run_open_session_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	if(!first || !second)
		return fault("opening a session needs two people")

	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE
	callbacks_fired = 0

	var/datum/family_confirm_session/session = SSfamilytree.open_mutual_session(first, second, CALLBACK(src, PROC_REF(mark_callback)), "family", null, null, FALSE)
	sessions_probed++
	if(!session)
		return fault("the happy path opened no session at all")

	if(!first.familytree_confirmation_pending || !second.familytree_confirmation_pending)
		fault("an open session must mark both sides pending, or a second offer could land on them")
	if(!session.timerid)
		fault("an open session must arm its expiry timer, or a silent pair hangs forever")
	if(session.deadline - world.time != MUTUAL_CONFIRM_TIMEOUT)
		fault("a fresh session must start with the full offer window, got [(session.deadline - world.time) / 10]s")
	if(session.result_a != CONFIRM_PENDING || session.result_b != CONFIRM_PENDING)
		fault("a fresh session must start with both answers pending")

	session.extend_for_prompt(TRUE)
	session.result_a = CONFIRM_ACCEPTED
	session.extend_for_prompt(FALSE)
	session.result_b = CONFIRM_ACCEPTED
	session.check_resolution()

	if(callbacks_fired != 1)
		fault("both sides accepted through the real session but the callback fired [callbacks_fired] times")
	if(first.familytree_confirmation_pending || second.familytree_confirmation_pending)
		fault("a resolved session left someone pending")

	first.familytree_confirmation_pending = FALSE
	second.familytree_confirmation_pending = FALSE
	return !length(violations)

/datum/familytree_probe/proc/run_mutual_sweep(mob/living/carbon/human/first, mob/living/carbon/human/second)
	run_mutual_guard_probe(first, second)
	run_timeout_block_probe(first, second)
	run_confirm_text_probe(first, second)
	run_gate_matrix_probe(first, second)
	run_open_session_probe(first, second)
	return !length(violations)

/datum/familytree_probe/proc/mutual_report()
	var/list/out = list()
	out += "guards:  [guards_checked] refusal paths walked"
	out += "blocks:  [blocks_checked] hold-back steps"
	out += "texts:   [types_rendered] confirmation strings rendered"
	if(length(violations))
		out += "FAULTS ([length(violations)]):"
		for(var/line in violations)
			out += "  - [line]"
	else
		out += "no faults"
	return out.Join("\n")
