/datum/component/arousal
	var/chain_orgasm_lock = FALSE
	var/last_ejaculation_world_time = -1
	var/tmp/last_nympho_boost_time = 0
	var/tmp/accumulated_pain_for_vice = 0
	charge = CHARGE_FOR_CLIMAX
	var/charge_max = SEX_MAX_CHARGE
	var/charge_for_climax = CHARGE_FOR_CLIMAX

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
	record_round_statistic(STATS_PLEASURES)
	var/do_spread = !chain_orgasm_lock
	chain_orgasm_lock = FALSE

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
		user.sate_addiction()
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

	if(intimate)
		after_intimate_climax(user, target)

/datum/component/arousal/ejaculate()
	if(world.time <= (last_ejaculation_world_time + 2 SECONDS))
		return
	last_ejaculation_world_time = world.time

	var/mob/living/carbon/human/mob = parent
	var/list/parent_sessions = return_sessions_with_user_tgui(mob)
	var/datum/sex_action_session/highest_priority = null
	var/best_score = -1

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
		return

	if(!highest_priority)
		do_ejac_inject_from_session(mob, null)
		var/turf/turf = get_turf(mob)
		new /obj/effect/decal/cleanable/coom(turf)
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
	var/return_type = action_object.handle_climax_message(link_actor, link_partner, is_active)
	if(!return_type)
		do_ejac_inject_from_session(source, null)
		var/turf/turf2 = get_turf(mob)
		new /obj/effect/decal/cleanable/coom(turf2)
		after_ejaculation(FALSE, source, partner)
		return

	handle_climax(return_type, source, partner)

	var/intimate = (return_type == "into" || return_type == "oral")
	after_ejaculation(intimate, source, partner)

	if(session_tgui_object.do_knot_action && action_object.can_knot && source)
		var/obj/item/organ/penis/penis_item = source.getorganslot(ORGAN_SLOT_PENIS)
		var/datum/sex_organ/penis/penis_object = penis_item ? penis_item.sex_organ : null
		if(penis_object && penis_object.have_knot)
			action_object.try_knot_on_climax(source, partner)

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

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	var/do_damage = (applied_force == SEX_FORCE_HIGH || applied_force == SEX_FORCE_EXTREME)

	if(do_damage && final_pain > 0)
		damage_from_pain(final_pain, organ_id)

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
			add_value =  amount * PENIS_CHARGE_PER_UNIT
		
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
				var/min_needed = max(penis_object.stored_liquid_max * PENIS_MIN_EJAC_FRACTION, PENIS_MIN_EJAC_ABSOLUTE)
				var/vol = penis_object.total_volume()
				if(vol >= min_needed && charge < charge_for_climax)
					var/fullness = vol / max(1, penis_object.stored_liquid_max) // 0..1
					var/gain = dt * PENIS_VOLUME_CHARGE_RATE * fullness
					adjust_charge(gain)

	if(is_spent())
		if(arousal > 60)
			to_chat(parent, span_warning("I'm too spent!"))
			adjust_arousal(parent, -20)
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

	if(charge < charge_for_climax)
		return TRUE

	return FALSE

/datum/component/arousal/process(dt)
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

/datum/component/arousal/adjust_arousal(datum/source, amount)
	if(arousal_frozen)
		return arousal

	var/final_amount = amount

	if(final_amount > 0)
		final_amount *= arousal_multiplier

	return set_arousal(source, arousal + final_amount)

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
