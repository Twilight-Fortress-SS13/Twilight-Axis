#define ORG_PAIN_GAIN_RATE 0.05

/datum/sex_action_context
	var/datum/sex_action_session/link
	var/list/compiled_messages
	var/compile_key
	var/obj/item/active_container

/datum/sex_action_session
	var/action_type
	var/datum/sex_session_tgui/session

	var/mob/living/carbon/human/actor
	var/mob/living/carbon/human/partner

	var/instance_id
	var/actor_node_id
	var/partner_node_id

	var/speed = SEX_SPEED_MID
	var/force = SEX_FORCE_MID

	var/next_tick_time = 0

	var/datum/sex_panel_action/action_proto
	var/datum/sex_action_context/ctx

/datum/sex_action_session/New(datum/sex_session_tgui/S, datum/sex_panel_action/A, actor_node, partner_node, action_key)
	. = ..()
	session = S
	action_type = action_key
	action_proto = A

	ctx = new
	ctx.link = src
	ctx.compiled_messages = null
	ctx.compile_key = null
	ctx.active_container = null

	instance_id = "[REF(src)]"
	actor_node_id = actor_node
	partner_node_id = partner_node

	actor = S.user
	var/mob/living/carbon/human/p = S.get_current_partner()
	if(!p)
		p = S.user
	partner = p

/datum/sex_action_session/Destroy()
	var/datum/sex_organ/src_org = session?.resolve_organ_datum(actor, actor_node_id)
	if(src_org)
		src_org.unbind()

	ctx = null
	action_proto = null
	return ..()

/datum/sex_action_session/proc/start()
	var/datum/sex_organ/src_org = session.resolve_organ_datum(actor, actor_node_id)
	var/datum/sex_organ/tgt_org = session.resolve_organ_datum(partner, partner_node_id)

	if(src_org)
		src_org.bind_with(tgt_org)

	if(action_proto)
		action_proto.on_start(actor, partner, ctx)

	next_tick_time = world.time
	if(session)
		session.recalc_next_actions_time()

/datum/sex_action_session/proc/tick()
	if(next_tick_time && world.time < next_tick_time)
		return

	if(QDELETED(session))
		return

	if(QDELETED(actor) || QDELETED(partner))
		session.stop_instance(instance_id)
		return

	var/datum/sex_action_session/I = session.current_actions?[instance_id]
	if(!I || I != src)
		return

	if(isnull(partner))
		session.stop_instance(instance_id)
		return

	if(!session.can_continue_action_session(src))
		session.stop_instance(instance_id)
		return

	var/do_time = action_proto.interaction_timer / get_speed_multiplier(speed)
	if(do_time < world.tick_lag)
		do_time = world.tick_lag

	if(action_proto.stamina_cost)
		var/mob/living/carbon/human/U = actor
		if(U)
			U.sex_procs_active = TRUE
			var/success = U.stamina_add(action_proto.stamina_cost * get_stamina_cost_multiplier(force))
			U.sex_procs_active = FALSE
			if(!success)
				session.stop_instance(instance_id)
				return

	var/mob/living/carbon/human/A = actor
	var/mob/living/carbon/human/T = partner

	var/datum/sex_organ/src_org = session.resolve_organ_datum(A, actor_node_id)
	var/datum/sex_organ/tgt_org = session.resolve_organ_datum(T, partner_node_id)

	var/self_pleasure_base   = action_proto.affects_self_arousal
	var/target_pleasure_base = action_proto.affects_arousal
	var/self_pain_base       = action_proto.affects_self_pain
	var/target_pain_base     = action_proto.affects_pain

	var/list/force_mults = get_force_multipliers(force, A)
	var/pain_mult     = force_mults["pain"]
	var/pleasure_mult = force_mults["pleasure"]
			
	var/self_pleasure_delta   = self_pleasure_base * pleasure_mult
	var/target_pleasure_delta = target_pleasure_base * pleasure_mult

	var/total_pain_mult = pain_mult * ORG_PAIN_GAIN_RATE

	var/self_pain_delta   = self_pain_base   * total_pain_mult
	var/target_pain_delta = target_pain_base * total_pain_mult

	if(src_org && self_pain_delta > 0)
		src_org.adjust_pain(self_pain_delta)
	if(tgt_org && target_pain_delta > 0)
		tgt_org.adjust_pain(target_pain_delta)

	apply_arousal_delta(self_pleasure_delta, target_pleasure_delta, self_pain_delta, target_pain_delta)

	session.sync_arousal_ui()
	SStgui.update_uis(session)
	next_tick_time = world.time + do_time

/datum/sex_action_session/proc/apply_arousal_delta(self_delta, partner_delta, self_pain_delta, partner_pain_delta)
	if(self_delta <= 0 && partner_delta <= 0 && self_pain_delta <= 0 && partner_pain_delta <= 0)
		return

	var/mob/living/carbon/human/U = actor
	var/mob/living/carbon/human/T = partner

	var/user_sources   = get_arousal_source_count_for(U)
	var/target_sources = get_arousal_source_count_for(T)

	var/user_delta   = self_delta
	var/target_delta = partner_delta

	if(user_sources > 1 && user_delta)
		user_delta /= user_sources
	if(target_sources > 1 && target_delta)
		target_delta /= target_sources

	if(self_pain_delta > 0 && U)
		if(is_maso(U) || is_nympho(U))
			user_delta += self_pain_delta
		else
			user_delta -= self_pain_delta

	if(partner_pain_delta > 0 && T)
		if(is_maso(T) || is_nympho(T))
			target_delta += partner_pain_delta
		else
			target_delta -= partner_pain_delta

	var/total_user_pain   = 0
	var/total_target_pain = 0

	if(U && actor_node_id && session)
		var/datum/sex_organ/user_org = session.resolve_organ_datum(U, actor_node_id)
		if(user_org)
			total_user_pain = max(0, user_org.pain)
			user_delta *= user_org.sensitivity
			user_org.pain += self_pain_delta

	if(T && partner_node_id && session)
		var/datum/sex_organ/target_org = session.resolve_organ_datum(T, partner_node_id)
		if(target_org)
			total_target_pain = max(0, target_org.pain)
			target_delta *= target_org.sensitivity
			target_org.pain += partner_pain_delta

	if(U && (user_delta || total_user_pain))
		SEND_SIGNAL(U, COMSIG_SEX_RECEIVE_ACTION, user_delta, total_user_pain, TRUE, force, speed, actor_node_id)

	if(T && (target_delta || total_target_pain))
		SEND_SIGNAL(T, COMSIG_SEX_RECEIVE_ACTION, target_delta, total_target_pain, FALSE, force, speed, partner_node_id)

/datum/sex_action_session/proc/get_arousal_source_count_for(mob/living/carbon/human/M)
	if(!M || !session || !length(session.current_actions))
		return 1

	var/count = 0
	for(var/id in session.current_actions)
		var/datum/sex_action_session/S = session.current_actions[id]
		if(!S || QDELETED(S))
			continue
		if(!S.action_proto)
			continue

		if(S.actor == M)
			if(!S.action_proto.affects_self_arousal)
				continue
		else if(S.partner == M)
			if(!S.action_proto.affects_arousal)
				continue
		else
			continue

		count++

	if(count <= 0)
		count = 1
	return count

/datum/sex_action_session/proc/get_priority_for(mob/living/carbon/human/U)
	if(!session || !action_proto || !U)
		return -1

	var/organ_priority = 0
	if(actor_node_id)
		var/org_type = session.node_organ_type(actor_node_id)
		if(isnum(org_type))
			organ_priority = org_type

	var/role_priority = 0
	if(U == partner)
		role_priority = 100
	else if(U == actor)
		role_priority = 50

	return organ_priority + role_priority

/datum/sex_action_session/proc/get_force_multipliers(force, mob/living/carbon/human/unit)
	var/pain_mult = 0.0
	var/pleasure_mult = 1.0

	switch(force)
		if(SEX_FORCE_LOW)
			pain_mult = 0.0
			pleasure_mult = 0.5

		if(SEX_FORCE_MID)
			pain_mult = 0.0
			pleasure_mult = 1.0

		if(SEX_FORCE_HIGH)
			pain_mult = 1.0
			pleasure_mult = is_maso(unit) ? 1.5 : 1.25
			pleasure_mult += is_nympho(unit) ? 0.05 : 0

		if(SEX_FORCE_EXTREME)
			pain_mult = is_maso(unit) ? 1.25 : 1.5
			pleasure_mult = is_maso(unit) ? 2.0 : 1.5

	pleasure_mult += is_nympho(unit) ? 0.25 : 0

	return list(
		"pain"     = pain_mult,
		"pleasure" = pleasure_mult,
	)

/datum/sex_action_session/proc/send_sex_message(mob/living/carbon/human/user, mob/living/carbon/human/target, message)
	if(!message)
		return

	if(session)
		session.dispatch_sex_message(user, target, message)
	else if(user)
		user.visible_message(message)

#undef ORG_PAIN_GAIN_RATE
