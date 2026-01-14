/datum/component/knotting
	var/movement_timer_id
	var/movement_signals_registered = FALSE
/datum/component/knotting/should_remove_knot_on_movement(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	var/list/arousal_data = list()
	SEND_SIGNAL(top, COMSIG_SEX_GET_AROUSAL, arousal_data)

	var/dist = get_dist(top, btm)

	if(dist <= 1)
		var/grabstate = top.get_highest_grab_state_on(btm)
		if(grabstate && grabstate >= GRAB_AGGRESSIVE)
			return FALSE

	if(dist > 1 && dist < 6)
		return FALSE

	if(arousal_data["arousal"] < AROUSAL_HARD_ON_THRESHOLD)
		knot_remove()
		return TRUE

	if(dist > 1)
		knot_remove(forceful_removal = TRUE)
		return TRUE

	var/lupine_op = top.STASTR > (btm.STACON + 3)
	if(!lupine_op && top.m_intent == MOVE_INTENT_RUN && (top.mobility_flags & MOBILITY_STAND))
		knot_remove(forceful_removal = TRUE)
		return TRUE

	return FALSE

/datum/component/knotting/handle_special_movement_cases(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	if(top.m_intent == MOVE_INTENT_WALK && (btm in top.buckled_mobs))
		var/obj/item/organ/penis/penis_item = top.getorganslot(ORGAN_SLOT_PENIS)
		var/strength = (penis_item && penis_item.penis_size > DEFAULT_PENIS_SIZE) ? 6.0 : 3.0

		SEND_SIGNAL(btm, COMSIG_SEX_RECEIVE_ACTION, strength, 0, FALSE, SEX_FORCE_MID, SEX_SPEED_HIGH, SEX_ORGAN_FILTER_VAGINA)

		var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
		btm_arousal?.try_ejaculate()

		if(prob(50))
			to_chat(top, span_love("I feel [btm] tightening over my knot."))
			to_chat(btm, span_love("I feel [top] rubbing inside."))

		if(get_dist(top, btm) > 1)
			tugging_knot = TRUE
			for(var/i in 1 to 2)
				if(get_dist(top, btm) <= 1) break
				step_towards(btm, top)
			tugging_knot = FALSE
		btm.face_atom(top)
		top.set_pull_offsets(btm, GRAB_AGGRESSIVE)

		return TRUE

	if(top.pulling == btm)
		if(get_dist(top, btm) > 1)
			tugging_knot = TRUE
			step_towards(btm, top)
			tugging_knot = FALSE
		btm.face_atom(top)
		top.set_pull_offsets(btm, GRAB_AGGRESSIVE)
		return TRUE

	if(btm.pulling == top)
		knot_remove(forceful_removal = TRUE)
		return TRUE

	return FALSE

/datum/component/knotting/can_knot(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user || !target || !ishuman(target))
		return FALSE

	if(get_dist(user, target) > 1)
		return FALSE

	if(!check_knot_penis_type())
		return FALSE

	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/arous = arousal_data["arousal"] || 0

	if(arous < AROUSAL_HARD_ON_THRESHOLD)
		if(!knotted_status)
			to_chat(user, span_notice("My knot was too soft to tie."))
		if(knotted_recipient != target)
			to_chat(target, span_notice("I feel their deflated knot slip out."))
		return FALSE

	return TRUE

/datum/component/knotting/handle_bottom_movement(mob/living/carbon/human/top, mob/living/carbon/human/btm)
	if(top.stat >= SOFT_CRIT)
		knot_remove()
		return

	var/dist = get_dist(top, btm)
	if(dist > 1)
		for(var/i in 1 to min(2, dist))
			if(get_dist(top, btm) <= 1)
				break
			step_towards(btm, top)

		if(get_dist(top, btm) > 1)
			knot_remove(forceful_removal = TRUE)
			return

	top.set_pull_offsets(btm, GRAB_AGGRESSIVE)

	if(btm.mobility_flags & MOBILITY_STAND && btm.m_intent == MOVE_INTENT_RUN)
		btm.Knockdown(10)
		btm.Stun(30)
		btm.emote("groan", forced = TRUE)
		return

	if(!btm.IsStun())
		if(prob(10))
			btm.emote("groan")
			var/datum/component/arousal/btm_arousal = btm.GetComponent(/datum/component/arousal)
			btm_arousal?.try_do_pain_effect(PAIN_MED_EFFECT, FALSE)
			btm.Stun(15)
		else if(prob(4))
			btm.emote("painmoan")

	if(movement_timer_id)
		deltimer(movement_timer_id)
		movement_timer_id = null

	movement_timer_id = addtimer(CALLBACK(src, PROC_REF(knot_movement_btm_after)), 0.1 SECONDS, TIMER_STOPPABLE)

/datum/component/knotting/knot_remove(forceful_removal = FALSE, notify = TRUE, keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(movement_timer_id)
		deltimer(movement_timer_id)
		movement_timer_id = null

	if(ishuman(btm) && !QDELETED(btm) && ishuman(top) && !QDELETED(top))
		handle_knot_removal_effects(top, btm, forceful_removal, notify, keep_btm_status)

	knot_exit(keep_top_status, keep_btm_status)

/datum/component/knotting/Destroy(force)
	if(movement_timer_id)
		deltimer(movement_timer_id)
		movement_timer_id = null
		
	if(knotted_status)
		knot_exit()
	. = ..()

/datum/component/knotting/proc/get_pregnancy_bonus(mob/living/carbon/human/target)
	if(knotted_status != KNOTTED_AS_TOP || knotted_recipient != target)
		return 0

	var/bonus = 15
	if(knot_count > 1)
		bonus += 5 * (knot_count - 1)

	return bonus

/datum/component/knotting/apply_knot(mob/living/carbon/human/user, mob/living/carbon/human/target, force_level, knot_count_param = 1)
	knotted_owner = user
	knotted_recipient = target
	knotted_status = KNOTTED_AS_TOP
	tugging_knot_blocked = FALSE
	knot_count = knot_count_param

	for(var/obj/item/organ/O in target.internal_organs)
		if(O.sex_organ && (O.sex_organ.organ_type in list(SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS, SEX_ORGAN_MOUTH)))
			O.sex_organ.block_drain = TRUE

	handle_knot_force_effects(user, target, force_level)
	var/knot_plural = knot_count > 1 ? "s" : ""
	user.visible_message(span_notice("[user] ties their knot[knot_plural] inside of [target]!"),
		span_notice("I tie my knot inside of [target]."))

	if(!knot_count)
		return

	if(target.stat != DEAD)
		var/knot_count = count_active_knots(target)
		switch(knot_count)
			if(1)
				to_chat(target, span_userdanger("You have been knotted!"))
			if(2)
				to_chat(target, span_userdanger("You have been double-knotted!"))
			if(3)
				to_chat(target, span_userdanger("You have been triple-knotted!"))
			if(4)
				to_chat(target, span_userdanger("You have been quad-knotted!"))
			if(5)
				to_chat(target, span_userdanger("You have been penta-knotted!"))
			else
				to_chat(target, span_userdanger("You have been ultra-knotted!"))

	apply_knot_status_effects(user, target)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(knot_movement))
	log_combat(user, target, "Started knot tugging")

	if(!islupian(user))
		record_round_statistic(STATS_KNOTTED_NOT_LUPIANS)
	record_round_statistic(STATS_KNOTTED)

/datum/component/knotting/knot_exit(keep_top_status = FALSE, keep_btm_status = FALSE)
	var/mob/living/carbon/human/top = knotted_owner
	var/mob/living/carbon/human/btm = knotted_recipient

	if(istype(top))
		if(!keep_top_status)
			top.remove_status_effect(/datum/status_effect/knotted)
		log_combat(top, top, "Stopped knot tugging")

	if(istype(btm))
		if(!keep_btm_status)
			btm.remove_status_effect(/datum/status_effect/knot_tied)
		UnregisterSignal(btm, COMSIG_MOVABLE_MOVED)
		log_combat(btm, btm, "Stopped knot tugging")

	knotted_owner = null
	knotted_recipient = null
	knotted_status = KNOTTED_NULL
	knot_count = 0

/datum/component/knotting/handle_existing_knots(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(knotted_status)
		if(knotted_status == KNOTTED_AS_TOP && knotted_recipient == target)
			return

		var/user_was_top = (knotted_status == KNOTTED_AS_TOP)
		var/user_was_bottom = (knotted_status == KNOTTED_AS_BTM)
		knot_remove(keep_btm_status = user_was_bottom, keep_top_status = user_was_top)
		if(user_was_top && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid))
			target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
			to_chat(target, span_userdanger("You can't think straight!"))

	var/mob/living/carbon/human/other_knotter = find_knotter_for_target(target)
	if(other_knotter && other_knotter != user)
		var/datum/component/knotting/other_knot = other_knotter.GetComponent(/datum/component/knotting)
		if(other_knot?.knotted_recipient == target)
			other_knot.knot_remove(forceful_removal = TRUE)
			if(other_knot.knotted_status == KNOTTED_AS_BTM && !target.has_status_effect(/datum/status_effect/knot_fucked_stupid))
				target.apply_status_effect(/datum/status_effect/knot_fucked_stupid)
