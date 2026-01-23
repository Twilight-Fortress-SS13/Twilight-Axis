#define SEX_PAIN_CHANCE_BOOST 20
#define SEX_PAIN_CHANCE_MAX 25
#define PAIN_BASE_SCALE 0.75
#define FORCE_HIGH_PAIN_CRIT_CHANCE 20
#define FORCE_EXTREME_PAIN_CRIT_CHANCE 40
#define FORCE_PAIN_CRIT_MULT 2.0

#define PENIS_CHARGE_PER_UNIT 3
#define BREASTS_CHARGE_PER_UNIT 1.5
#define SEX_AROUSAL_BASIC_CHARGE 4

#define NYMPHO_AROUSAL_SOFT_CAP 20
#define NYMPHO_ORGASM_MULT_GAIN 0.5
#define BAOTHA_SEX_CHARGE_MAX 400
#define NIMPHO_SEX_CHARGE_FOR_CLIMAX 75
#define NYMPHO_ORGASM_MULT_MAX 1.2
#define NYMPHO_BOOST_DURATION (10 MINUTES)

#define SP_MAX 5
#define SP_SATED_THRESHOLD 3
#define SP_DECAY_INTERVAL (10 MINUTES)
#define SELF_LOCK_DURATION (2 MINUTES)

/datum/component/arousal
	var/chain_orgasm_lock = FALSE
	var/last_ejaculation_world_time = -1
	var/tmp/last_nympho_boost_time = 0
	var/tmp/accumulated_pain_for_vice = 0
	charge = CHARGE_FOR_CLIMAX
	var/charge_max = SEX_MAX_CHARGE
	var/charge_for_climax = CHARGE_FOR_CLIMAX

	var/satisfaction_points = 0
	var/last_sp_decay_time = 0
	var/self_gratification_lock = FALSE
	var/self_gratification_lock_until = 0

/datum/component/arousal/set_charge(amount)
	var/empty = (charge < charge_for_climax)
	charge = clamp(amount, 0, charge_max)
	var/after_empty = (charge < charge_for_climax)
	if(empty && !after_empty)
		to_chat(parent, span_notice("I feel like I'm not so spent anymore"))
	if(!empty && after_empty)
		to_chat(parent, span_notice("I'm spent!"))

/datum/component/arousal/proc/spread_climax_to_partners(mob/living/carbon/human/source)
	if(!source)
		return

	var/list/sessions = return_sessions_with_user_tgui(source)
	if(!length(sessions))
		return

	var/list/affected = list()

	for(var/datum/sex_session_tgui/session_object in sessions)
		if(QDELETED(session_object))
			continue
		if(!length(session_object.current_actions))
			continue

		for(var/id in session_object.current_actions)
			var/datum/sex_action_session/action_object = session_object.current_actions[id]
			if(!action_object || QDELETED(action_object) || !action_object.action_proto)
				continue

			var/mob/living/carbon/human/actor_object = action_object.actor
			var/mob/living/carbon/human/partner_object = action_object.partner

			if(actor_object == source && partner_object && partner_object != source)
				affected |= partner_object
			else if(partner_object == source && actor_object && actor_object != source)
				affected |= actor_object

	for(var/mob/living/carbon/human/mob_object in affected)
		if(QDELETED(mob_object) || mob_object.stat == DEAD)
			continue

		var/is_nympho = mob_object.has_flaw(/datum/charflaw/addiction/lovefiend)
		var/is_fabled = HAS_TRAIT(source, TRAIT_GOODLOVER)
		var/bonus = is_nympho ? 20 : 10
		bonus *= is_fabled ? 2 : 1

		var/datum/component/arousal/arousal_object = mob_object.GetComponent(/datum/component/arousal)
		if(!arousal_object)
			continue

		arousal_object.chain_orgasm_lock = TRUE
		SEND_SIGNAL(mob_object, COMSIG_SEX_ADJUST_AROUSAL, bonus)

/datum/component/arousal/after_ejaculation(intimate = FALSE, mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_spread = !chain_orgasm_lock
	chain_orgasm_lock = FALSE

	if(user.has_flaw(/datum/charflaw/addiction/thrillseeker))
		var/datum/charflaw/addiction/thrill = user.get_flaw(/datum/charflaw/addiction/thrillseeker)
		user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
		last_ejaculation_time = world.time
		if(!thrill.sated)
			user.add_stress(/datum/stressevent/thrillsex)
		if(prob(10))
			user.emote("groan", forced = TRUE)
		return

	if(do_spread)
		spread_climax_to_partners(user)

	var/after_climax_value = 20
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		after_climax_value = 30
	SEND_SIGNAL(user, COMSIG_SEX_SET_AROUSAL, after_climax_value)
	SEND_SIGNAL(user, COMSIG_SEX_CLIMAX)

	adjust_charge(-charge_for_climax)

	user.add_stress(/datum/stressevent/cumok)
	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		if(parent == user)
			arousal_multiplier = clamp(arousal_multiplier + NYMPHO_ORGASM_MULT_GAIN, 1, NYMPHO_ORGASM_MULT_MAX)
			last_nympho_boost_time = world.time

		if(user == target)
			var/datum/charflaw/addiction/lovefiend/link_flaw = user.get_flaw()
			if(link_flaw)
				link_flaw.time = rand(24 MINUTES, 48 MINUTES)	

	if(last_moan + MOAN_COOLDOWN < world.time)
		user.emote("moan", forced = TRUE)
		last_moan = world.time

	user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
	last_ejaculation_time = world.time

/datum/component/arousal/ejaculate()
	if(world.time <= (last_ejaculation_world_time + 2 SECONDS))
		return
	last_ejaculation_world_time = world.time

	var/mob/living/carbon/human/mob = parent
	var/list/parent_sessions = return_sessions_with_user_tgui(mob)
	var/datum/sex_action_session/highest_priority = null
	var/best_score = -1

	if(mob.has_flaw(/datum/charflaw/addiction/thrillseeker))
		after_ejaculation(FALSE, mob, mob)
		return
		
	for(var/datum/sex_session_tgui/session_element in parent_sessions)
		if(QDELETED(session_element))
			continue

		var/datum/sex_action_session/action_object = session_element.get_best_action_session_for(mob)
		if(!action_object)
			continue

		var/score = action_object.get_priority_for(mob)
		if(score > best_score)
			best_score = score
			highest_priority = action_object

	playsound(mob, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)

	if(!mob.getorganslot(ORGAN_SLOT_TESTICLES) && mob.getorganslot(ORGAN_SLOT_PENIS))
		mob.visible_message(span_love("[mob] climaxes, yet nothing is released!"))
		after_ejaculation(FALSE, mob, null)
		var/sp_gain = handle_satisfaction_from_climax(mob, null, "self")
		if(sp_gain > 0)
			apply_climax_stress(mob, "self", sp_gain)
		return

	if(!highest_priority)
		do_ejac_inject_from_session(mob, null)
		var/turf/turf = get_turf(mob)
		new /obj/effect/decal/cleanable/coom(turf)
		var/sp_gain = handle_satisfaction_from_climax(mob, null, "self")
		if(sp_gain > 0)
			apply_climax_stress(mob, "self", sp_gain)
		after_ejaculation(FALSE, mob, null)
		return

	var/datum/sex_action_session/session_object = highest_priority
	var/datum/sex_session_tgui/session_tgui_object = session_object.session

	var/mob/living/carbon/human/source = mob
	var/mob/living/carbon/human/partner = null
	var/is_active = TRUE

	if(session_object.actor == source)
		is_active = TRUE
		partner = session_object.partner
	else
		is_active = FALSE
		partner = session_object.actor

	if(partner == source)
		partner = null

	do_ejac_inject_from_session(source, session_object)
	var/datum/sex_panel_action/action_object = session_object.action_proto
	var/mob/living/carbon/human/link_actor = session_object.actor
	var/mob/living/carbon/human/link_partner = session_object.partner
	var/datum/sex_action_context/ctx = session_object.ctx
	var/return_type = action_object.handle_climax_message(link_actor, link_partner, is_active, ctx)
	if(!return_type)
		do_ejac_inject_from_session(source, null)
		var/turf/turf2 = get_turf(mob)
		new /obj/effect/decal/cleanable/coom(turf2)
		var/sp_gain = handle_satisfaction_from_climax(source, partner, "self")
		if(sp_gain > 0)
			apply_climax_stress(source, return_type, sp_gain)
		after_ejaculation(FALSE, source, partner)
		return

	handle_climax(return_type, source, partner)
	var/sp_gain = handle_satisfaction_from_climax(source, partner, return_type)
	if(sp_gain > 0)
		apply_climax_stress(source, return_type, sp_gain)

	var/intimate = (return_type == "into" || return_type == "onto")
	after_ejaculation(intimate, source, partner)

	if(session_tgui_object.do_knot_action && action_object.can_knot && source)
		var/mob/living/carbon/human/knot_target = partner

		var/obj/item/organ/penis/penis_item = source.getorganslot(ORGAN_SLOT_PENIS)
		var/datum/sex_organ/penis/penis_object = penis_item ? penis_item.sex_organ : null

		if(penis_object && penis_object.have_knot)
			var/datum/sex_organ/target_org = penis_object.active_target
			if(target_org)
				var/mob/living/carbon/human/real_owner = target_org.get_owner()
				if(istype(real_owner))
					knot_target = real_owner

			if(knot_target && knot_target != source)
				action_object.try_knot_on_climax(source, knot_target)

	if(return_type == "into")
		var/producing_organ_type = session_tgui_object.node_organ_type(session_object.actor_node_id)
		var/receiving_organ_type = session_tgui_object.node_organ_type(session_object.partner_node_id)
		if(receiving_organ_type != SEX_ORGAN_VAGINA || producing_organ_type != SEX_ORGAN_PENIS)
			return

		var/mob/living/carbon/human/mother = partner
		var/mob/living/carbon/human/father = source

		if(!istype(mother) || !istype(father))
			return

		var/obj/item/organ/vagina/vag = mother.getorganslot(ORGAN_SLOT_VAGINA)
		if(!vag || !vag.sex_organ)
			return

		var/list/arousal_data = list()
		SEND_SIGNAL(mother, COMSIG_SEX_GET_AROUSAL, arousal_data)

		var/mother_arousal = arousal_data["arousal"] || 0
		var/knot_bonus = 0

		var/datum/component/knotting/knot_comp = father.GetComponent(/datum/component/knotting)
		if(knot_comp)
			knot_bonus = knot_comp.get_pregnancy_bonus(mother)

		var/datum/sex_organ/vagina/vag_datum = vag.sex_organ
		vag_datum.on_intimate_climax(father, mother_arousal, knot_bonus)

/datum/component/arousal/receive_sex_action(datum/source, arousal_amt, pain_amt, giving, applied_force, applied_speed, organ_id)
	var/mob/user = parent

	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)
	pain_amt *= PAIN_BASE_SCALE

	var/list/effect = list(
		"arousal" = arousal_amt,
		"pain" = pain_amt,
		"giving" = giving,
		"force" = applied_force,
		"speed" = applied_speed,
		"organ_id" = organ_id,
	)

	SEND_SIGNAL(user, COMSIG_SEX_MODIFY_EFFECT, effect)

	arousal_amt = effect["arousal"]
	pain_amt    = effect["pain"]

	var/final_pain = pain_amt

	switch(applied_force)
		if(SEX_FORCE_HIGH)
			if(prob(FORCE_HIGH_PAIN_CRIT_CHANCE))
				final_pain *= FORCE_PAIN_CRIT_MULT
		if(SEX_FORCE_EXTREME)
			if(prob(FORCE_EXTREME_PAIN_CRIT_CHANCE))
				final_pain *= FORCE_PAIN_CRIT_MULT

	if(user.stat == DEAD)
		arousal_amt = 0
		final_pain = 0

	if(giving && user.has_flaw(/datum/charflaw/addiction/lovefiend))
		if(!arousal_amt)
			arousal_amt = 0.02

	if(arousal_amt > 0 && istype(user, /mob/living/carbon/human) && istype(source, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/mob/living/carbon/human/P = source
		var/datum/component/kinks/K = H.ensure_kinks_component()
		if(K)
			arousal_amt *= K.get_arousal_multiplier(H, P, giving, applied_force, applied_speed, organ_id)

	var/datum/component/relationships/R = user.GetComponent(/datum/component/relationships)
	if(R)
		arousal_amt *= R.get_sex_multiplier(source)

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	var/do_damage = (applied_force == SEX_FORCE_HIGH || applied_force == SEX_FORCE_EXTREME)

	if(do_damage && final_pain > 0)
		damage_from_pain(final_pain, organ_id, do_damage)

	if(final_pain > 0)
		accumulated_pain_for_vice += final_pain

	var/list/sessions = return_sessions_with_user_tgui(source)
	var/can_moan = TRUE
	for(var/datum/sex_session_tgui/session_object in sessions)
		if(session_object.user != user)
			continue
		else
			can_moan = session_object.allow_user_moan
			break

	try_do_pain_effect(final_pain, giving)
	try_do_moan(arousal_amt, final_pain, applied_force, giving, can_moan)
	try_do_maso_vice_moan()

/datum/component/arousal/damage_from_pain(pain_amt, organ_id, applied_force)
	var/mob/living/carbon/human/user = parent
	if(!user || pain_amt <= 0)
		return

	var/zone = erp_filter_to_body_zone(organ_id)
	var/obj/item/bodypart/part = user.get_bodypart(zone)
	if(!part)
		return

	var/effective_pain = max(0, pain_amt)
	if(effective_pain <= 0)
		return

	var/effective_chance = effective_pain
	effective_chance *= (applied_force == SEX_FORCE_EXTREME) ? (SEX_PAIN_CHANCE_BOOST * 2) : SEX_PAIN_CHANCE_BOOST
	var/pain_chance_maximum = (applied_force == SEX_FORCE_EXTREME) ? (SEX_PAIN_CHANCE_MAX * 2) : SEX_PAIN_CHANCE_MAX
	var/chance = min(pain_chance_maximum, effective_chance)
	if(!prob(chance))
		return

	var/damage = ((applied_force == SEX_FORCE_EXTREME) ? max(1, effective_pain * 4) : effective_pain)
	user.apply_damage(damage, BRUTE, zone)

/datum/component/arousal/get_arousal(datum/source, list/arousal_data)
	arousal_data += list(
		"arousal" = arousal,
		"frozen" = arousal_frozen,
		"last_increase" = last_arousal_increase_time,
		"arousal_multiplier" = arousal_multiplier,
		"is_spent" = is_spent(),
		"charge" = charge,
		"charge_max" = charge_max,
		"charge_for_climax" = charge_for_climax
	)

/datum/component/arousal/handle_climax(climax_type, mob/living/carbon/human/user, mob/living/carbon/human/target)
	switch(climax_type)
		if("onto")
			log_combat(user, target, "Came onto the target")
			playsound(target, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			var/turf/turf = get_turf(target)
			new /obj/effect/decal/cleanable/coom(turf)
			var/obj/item/organ/penis/P = user.getorganslot(ORGAN_SLOT_PENIS)
			if(target && P)
				var/datum/status_effect/facial/facial = target.has_status_effect(/datum/status_effect/facial)
				if(!facial)
					target.apply_status_effect(/datum/status_effect/facial)
				else
					facial.refresh_cum()
		if("into")
			log_combat(user, target, "Came inside the target")
			playsound(target, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
			var/obj/item/organ/penis/P = user.getorganslot(ORGAN_SLOT_PENIS)
			if(target && P)
				var/status_type = /datum/status_effect/facial/internal
				var/datum/status_effect/facial/internal_effect = target.has_status_effect(status_type)
				if(!internal_effect)
					target.apply_status_effect(status_type)
				else
					internal_effect.refresh_cum()
		if("self")
			log_combat(user, user, "Ejaculated")
			var/turf/turf = get_turf(user)
			new /obj/effect/decal/cleanable/coom(turf)
			playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)

/datum/component/arousal/proc/on_sex_organ_produced(datum/sex_organ/org, amount)
	if(amount <= 0)
		return

	var/mob/living/carbon/human/human_object = parent
	if(!istype(human_object))
		return

	var/add_value = SEX_AROUSAL_BASIC_CHARGE
	switch(org.organ_type)
		if(SEX_ORGAN_PENIS)
			add_value = amount * PENIS_CHARGE_PER_UNIT
		if(SEX_ORGAN_BREASTS)
			add_value = amount * BREASTS_CHARGE_PER_UNIT

	adjust_charge(add_value)

#define PENIS_VOLUME_CHARGE_RATE 0.5

/datum/component/arousal/handle_charge(dt)
	var/mob/living/carbon/human/human_object = parent
	var/has_testicles = FALSE

	if(istype(human_object))
		var/obj/item/organ/testicles/testicles_object = human_object.getorganslot(ORGAN_SLOT_TESTICLES)
		if(testicles_object)
			has_testicles = TRUE

	if(!has_testicles)
		adjust_charge(dt * CHARGE_RECHARGE_RATE)

	if(istype(human_object))
		var/obj/item/organ/penis/penis_item = human_object.getorganslot(ORGAN_SLOT_PENIS)
		if(penis_item && penis_item.sex_organ)
			var/datum/sex_organ/penis/penis_object = penis_item.sex_organ
			if(penis_object.has_storage())
				var/min_needed = min(penis_object.stored_liquid_max * PENIS_MIN_EJAC_FRACTION, PENIS_MIN_EJAC_ABSOLUTE)
				var/vol = penis_object.total_volume()
				if(vol >= min_needed && charge < charge_for_climax)
					var/fullness = vol / max(1, penis_object.stored_liquid_max)
					var/gain = dt * PENIS_VOLUME_CHARGE_RATE * fullness
					adjust_charge(gain)

	if(is_spent())
		if(arousal > 60)
			to_chat(parent, span_warning("I'm too spent!"))
			adjust_arousal(parent, -arousal)
			return
		adjust_arousal(parent, -dt * SPENT_AROUSAL_RATE)

#undef PENIS_VOLUME_CHARGE_RATE

/datum/component/arousal/is_spent()
	var/mob/living/carbon/human/human_object = parent

	if(istype(human_object))
		var/obj/item/organ/penis/penis_item = human_object.getorganslot(ORGAN_SLOT_PENIS)
		var/obj/item/organ/testicles/testicles_item = human_object.getorganslot(ORGAN_SLOT_TESTICLES)

		if(penis_item && testicles_item && penis_item.sex_organ)
			var/datum/sex_organ/penis/penis_object = penis_item.sex_organ
			if(penis_object.has_storage())
				var/min_needed = max(penis_object.stored_liquid_max * PENIS_MIN_EJAC_FRACTION, PENIS_MIN_EJAC_ABSOLUTE)
				var/current = penis_object.total_volume()
				if(current >= min_needed)
					return FALSE			

	if(charge < charge_for_climax)
		return TRUE

	return FALSE

/datum/component/arousal/process(dt)
	handle_satisfaction_decay()
	handle_self_gratification_lock()
	handle_charge(dt * 1)

	var/mob/living/carbon/human/human_object = parent
	if(istype(human_object))
		human_object.process_sex_organs()
		if(human_object.has_flaw(/datum/charflaw/addiction/lovefiend))
			if(charge >= charge_max && !(is_in_sex_scene()))
				if(arousal < NYMPHO_AROUSAL_SOFT_CAP)
					var/need_to_boost = NYMPHO_AROUSAL_SOFT_CAP - arousal
					if(need_to_boost > 0)
						adjust_arousal(parent, need_to_boost)
					return
				if(dt > 0)
					var/max_loss = max(0, arousal - NYMPHO_AROUSAL_SOFT_CAP)
					var/actual_loss = min(dt, max_loss)
					if(actual_loss > 0)
						adjust_arousal(parent, -actual_loss)
					return

	var/datum/component/relationships/R = parent.GetComponent(/datum/component/relationships)
	if(R)
		var/min_obs = R.get_observe_min()
		if(min_obs > 0 && arousal < min_obs && !(is_in_sex_scene()))
			new /obj/effect/temp_visual/heart/sex_effects(get_turf(parent))
			set_arousal(parent, min_obs, TRUE)

	if(!can_lose_arousal())
		return

	adjust_arousal(parent, dt * -1)
	if(!(is_in_sex_scene()))
		accumulated_pain_for_vice -= dt / 10
		accumulated_pain_for_vice = max(accumulated_pain_for_vice, 0)

/datum/component/arousal/update_arousal_effects()
	update_pink_screen()
	update_blueballs()
	update_erect_state()
	if(last_nympho_boost_time && world.time > last_nympho_boost_time + NYMPHO_BOOST_DURATION)
		arousal_multiplier = 1
		last_nympho_boost_time = 0

/datum/component/arousal/proc/do_ejac_inject_from_session(mob/living/carbon/human/source, datum/sex_action_session/session_object)
	if(!source)
		return

	var/list/blocked = get_blocked_containers_for_mob(source)
	if(!session_object || !session_object.session)
		var/obj/item/organ/penis/penis_item = source.getorganslot(ORGAN_SLOT_PENIS)
		if(!penis_item || !penis_item.sex_organ)
			return

		var/datum/sex_organ/penis/penis_organ = penis_item.sex_organ
		penis_organ.inject_liquid(null, source, blocked)
		return

	var/datum/sex_session_tgui/session_element = session_object.session
	var/actor_type = session_element.node_organ_type(session_object.actor_node_id)
	var/partner_type = session_element.node_organ_type(session_object.partner_node_id)
	var/mob/living/carbon/human/owner = source
	var/organ_node_id = null

	if(actor_type == SEX_ORGAN_PENIS)
		organ_node_id = session_object.actor_node_id
	else if(partner_type == SEX_ORGAN_PENIS)
		organ_node_id = session_object.partner_node_id

	if(!organ_node_id)
		var/obj/item/organ/penis/penis_item = source.getorganslot(ORGAN_SLOT_PENIS)
		if(!penis_item || !penis_item.sex_organ)
			return

		var/datum/sex_organ/penis/penis_organ = penis_item.sex_organ
		penis_organ.inject_liquid(null, source, blocked)
		return

	var/datum/sex_organ/src_org = session_element.resolve_organ_datum(owner, organ_node_id)
	if(!src_org)
		return

	src_org.inject_liquid(null, source, blocked)

/datum/component/arousal/proc/get_blocked_containers_for_mob(mob/living/carbon/human/human_object)
	if(!human_object)
		return list()

	var/list/blocked = list()
	var/list/sessions = return_sessions_with_user_tgui(human_object)
	if(!length(sessions))
		return blocked

	for(var/datum/sex_session_tgui/session_object in sessions)
		if(QDELETED(session_object))
			continue
		if(!length(session_object.current_actions))
			continue

		for(var/id in session_object.current_actions)
			var/datum/sex_action_session/action_session = session_object.current_actions[id]
			if(!action_session || QDELETED(action_session) || !action_session.action_proto)
				continue

			if(action_session.actor != human_object && action_session.partner != human_object)
				continue

			var/datum/sex_panel_action/action_element = action_session.action_proto
			if(!action_element)
				continue

			var/obj/item/container = action_element.active_container
			if(container && !(container in blocked))
				blocked += container

	return blocked

/datum/component/arousal/adjust_arousal(datum/source, amount, forced = FALSE)
	if(arousal_frozen)
		return arousal

	var/final_amount = amount

	if(final_amount > 0)
		final_amount *= arousal_multiplier

	return set_arousal(source, arousal + final_amount, forced)

/datum/component/arousal/proc/is_in_sex_scene()
	var/mob/living/carbon/human/human_object = parent
	if(!istype(human_object))
		return FALSE

	for(var/datum/sex_session_tgui/session_object in GLOB.sex_sessions)
		if(!session_object || QDELETED(session_object))
			continue
		if(!length(session_object.current_actions))
			continue

		for(var/id in session_object.current_actions)
			var/datum/sex_action_session/session_element = session_object.current_actions[id]
			if(!session_element || QDELETED(session_element))
				continue

			if(session_element.actor == human_object || session_element.partner == human_object)
				return TRUE

	return FALSE

/datum/component/arousal/proc/update_info()
	var/mob/living/carbon/human/source = parent
	if(istype(source.patron, /datum/patron/inhumen/baotha))
		charge_max = BAOTHA_SEX_CHARGE_MAX
	if(source.has_flaw(/datum/charflaw/addiction/lovefiend))
		charge_for_climax = NIMPHO_SEX_CHARGE_FOR_CLIMAX

/datum/component/arousal/try_do_moan(arousal_amt, pain_amt, applied_force, giving, can_moan = TRUE)
	var/mob/user = parent
	if(!user)
		return
	if(!can_moan)
		return
	if(arousal < 20)
		return

	if(user.stat != CONSCIOUS)
		return

	if(last_moan + MOAN_COOLDOWN >= world.time)
		return

	var/pain_level = clamp(pain_amt, 0, 2)
	var/base_chance = 10

	if(arousal >= 20)
		base_chance += arousal - 20

	base_chance += round(pain_level * 5)

	base_chance = clamp(base_chance, 10, 80)

	if(!prob(base_chance))
		return

	var/chosen_emote
	if(arousal < 99)
		chosen_emote = "sexmoanlight"
	else
		chosen_emote = "sexmoanhvy"

	if(pain_level >= 0.5 && pain_level < 1)
		if(giving)
			if(prob(20))
				chosen_emote = "groan"
		else
			if(prob(30))
				chosen_emote = "painmoan"

	else if(pain_level >= 1 && pain_level < 1.5)
		if(giving)
			if(prob(40))
				chosen_emote = "groan"
		else
			if(prob(50))
				chosen_emote = "painmoan"

	else if(pain_level >= 1.5)
		if(giving)
			if(prob(60))
				chosen_emote = "groan"
		else
			if(prob(70))
				chosen_emote = "painmoan"

	if(!chosen_emote)
		return

	last_moan = world.time
	user.emote(chosen_emote)

/datum/component/arousal/proc/try_do_maso_vice_moan()
	var/mob/living/carbon/human/user = parent
	if(!user)
		return
	if(user.stat != CONSCIOUS)
		return
	if(!user.has_flaw(/datum/charflaw/addiction/masochist))
		return
	if(accumulated_pain_for_vice < 1)
		return

	var/chance = clamp(round(accumulated_pain_for_vice * 5), 0, 100)
	if(!prob(chance))
		return

	accumulated_pain_for_vice = 0
	user.emote("painmoan", forced = TRUE)
	last_moan = world.time

	satisfy_maso_sado_vices(user)

/datum/component/arousal/proc/satisfy_maso_sado_vices(mob/living/carbon/human/source)
	if(!source)
		return

	for(var/mob/living/carbon/human/H in view(2, source))
		if(H.stat == DEAD)
			continue

		if(H.get_flaw(/datum/charflaw/addiction/sadist))
			H.sate_addiction()

/datum/component/arousal/proc/adjust_satisfaction(delta)
	satisfaction_points = clamp(satisfaction_points + delta, 0, SP_MAX)

/datum/component/arousal/proc/handle_satisfaction_decay()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(!H.has_flaw(/datum/charflaw/addiction/lovefiend))
		return
	if(world.time < last_sp_decay_time + SP_DECAY_INTERVAL)
		return
	last_sp_decay_time = world.time
	adjust_satisfaction(-1)

/datum/component/arousal/proc/handle_self_gratification_lock()
	if(self_gratification_lock && world.time >= self_gratification_lock_until)
		self_gratification_lock = FALSE

/datum/component/arousal/proc/apply_self_gratification_lock()
	self_gratification_lock = TRUE
	self_gratification_lock_until = world.time + SELF_LOCK_DURATION

/datum/component/arousal/proc/handle_satisfaction_from_climax(mob/living/carbon/human/user, mob/living/carbon/human/target, climax_type)
	if(!user || !climax_type)
		return 0

	var/sp_gain = 0
	switch(climax_type)
		if("self")
			sp_gain = 1
		if("onto")
			sp_gain = 2
		if("into")
			sp_gain = 3
		else
			return 0

	var/is_solo = (!target || target == user)

	if(is_solo)
		if(self_gratification_lock)
			return 0
		apply_self_gratification_lock()

	adjust_satisfaction(sp_gain)

	if(!is_solo && target)
		if(HAS_TRAIT(target, TRAIT_GOODLOVER))
			if(!user.mob_timers["cumtri"])
				user.mob_timers["cumtri"] = world.time
				user.adjust_triumphs(1)
				to_chat(user, span_love("Наша любовь — истинный ТРИУМФ!"))
				user.apply_status_effect(/datum/status_effect/buff/goodloving)

		if(HAS_TRAIT(user, TRAIT_GOODLOVER))
			if(!target.mob_timers["cumtri"])
				target.mob_timers["cumtri"] = world.time
				target.adjust_triumphs(1)
				to_chat(user, span_love("Наша любовь — истинный ТРИУМФ!"))
				target.apply_status_effect(/datum/status_effect/buff/goodloving)

	if(target && target != user)
		var/datum/component/arousal/partner_arousal = target.GetComponent(/datum/component/arousal)
		if(partner_arousal)
			partner_arousal.adjust_satisfaction(sp_gain)

	return sp_gain


/datum/component/arousal/proc/apply_climax_stress(mob/living/carbon/human/user, climax_type, sp_gain)
	if(!user)
		return

	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		if(satisfaction_points > SP_SATED_THRESHOLD )
			user.sate_addiction()
		user.add_stress(/datum/stressevent/cumlove)
		return

	if(climax_type == "self")
		user.add_stress(/datum/stressevent/cumself)
		return

	switch(satisfaction_points)
		if(1)
			user.add_stress(/datum/stressevent/cumok)
		if(2)
			user.add_stress(/datum/stressevent/cummid)
		if(3)
			user.add_stress(/datum/stressevent/cumgood)
		if(4)
			user.add_stress(/datum/stressevent/cummax)
		if(5)
			user.add_stress(/datum/stressevent/cumlove)
		else
			user.add_stress(/datum/stressevent/cumok)

#undef SEX_PAIN_CHANCE_BOOST
#undef SEX_PAIN_CHANCE_MAX
#undef PAIN_BASE_SCALE
#undef FORCE_HIGH_PAIN_CRIT_CHANCE
#undef FORCE_EXTREME_PAIN_CRIT_CHANCE
#undef FORCE_PAIN_CRIT_MULT

#undef PENIS_CHARGE_PER_UNIT
#undef SEX_AROUSAL_BASIC_CHARGE

#undef NYMPHO_AROUSAL_SOFT_CAP
#undef NYMPHO_ORGASM_MULT_GAIN
#undef BAOTHA_SEX_CHARGE_MAX
#undef NIMPHO_SEX_CHARGE_FOR_CLIMAX
#undef NYMPHO_ORGASM_MULT_MAX
#undef NYMPHO_BOOST_DURATION

#undef SP_MAX
#undef SP_SATED_THRESHOLD
#undef SP_DECAY_INTERVAL
#undef SELF_LOCK_DURATION
