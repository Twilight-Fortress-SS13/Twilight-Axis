#define NYMPHO_AROUSAL_SOFT_CAP ERP_NYMPHO_SOFT_CAP
#define MOAN_THRESHOLD 4.0

/datum/component/arousal
	var/tmp/last_ejaculation_world_time = -1
	var/tmp/accumulated_pain_for_vice = 0
	var/satisfaction_points = 0.0
	var/last_sp_decay_time = 0
	var/overload_points = 0
	var/last_overload_gain_time = 0
	var/tmp/chain_lock_until = 0
	var/last_overload_sleep_decay_time = 0
	var/tmp/nympho_sp_floor_until = 0

/datum/component/arousal/RegisterWithParent()
	. = ..()
	check_processing()
	seed_satisfaction_if_needed()

/datum/component/arousal/proc/seed_satisfaction_if_needed()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(last_sp_decay_time)
		return
	if(H.has_flaw(/datum/charflaw/addiction/lovefiend))
		satisfaction_points = 2.0
	else
		satisfaction_points = 3.0
	last_sp_decay_time = world.time

/datum/component/arousal/proc/get_erp_links()
	var/list/L = list()
	SEND_SIGNAL(parent, COMSIG_ERP_GET_LINKS, L)
	return L

/datum/component/arousal/proc/is_in_erp_scene()
	var/list/L = get_erp_links()
	for(var/datum/erp_sex_link/link in L)
		if(link && !QDELETED(link) && link.is_valid() && link.state == LINK_STATE_ACTIVE)
			return TRUE
	return FALSE

/datum/component/arousal/proc/pick_best_erp_link(list/L)
	var/mob/living/carbon/human/H = parent
	if(!istype(H) || !length(L))
		return null

	var/datum/erp_controller/C = SSerp.get_controller_for(H)
	var/datum/erp_actor/me = C ? C.get_actor_by_mob(H) : null
	if(!me)
		return null

	var/datum/erp_sex_link/best = null
	var/best_score = -1
	for(var/datum/erp_sex_link/link in L)
		if(!link || QDELETED(link) || !link.is_valid() || link.state != LINK_STATE_ACTIVE)
			continue
		var/sc = link.get_climax_score(me)
		if(sc > best_score)
			best_score = sc
			best = link

	return best

/datum/component/arousal/proc/get_character_age()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return ERP_AGE_BASELINE

	if(!isnull(H.vars["age"]))
		return max(0, text2num("[H.vars["age"]]"))
	if(!isnull(H.vars["real_age"]))
		return max(0, text2num("[H.vars["real_age"]]"))

	return ERP_AGE_BASELINE

/datum/component/arousal/proc/get_age_charge_regen_mult()
	switch(get_age_category())
		if(AGE_MIDDLEAGED)
			return 0.85
		if(AGE_OLD)
			return 0.70
		else
			return 1.00

/datum/component/arousal/proc/get_age_arousal_decay_mult()
	switch(get_age_category())
		if(AGE_MIDDLEAGED)
			return 1.15
		if(AGE_OLD)
			return 1.35
		else
			return 1.00

/datum/component/arousal/proc/is_lovefiend()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return FALSE
	return !!H.get_flaw(/datum/charflaw/addiction/lovefiend)

/datum/component/arousal/proc/is_baotha_follower()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return FALSE
	if(istype(H.patron, /datum/patron/inhumen/baotha))
		return TRUE
	return FALSE

/datum/component/arousal/proc/is_crackhead()
	var/mob/living/carbon/human/H = parent
	return istype(H) && HAS_TRAIT(H, TRAIT_CRACKHEAD)

/datum/component/arousal/proc/is_psydonist()
	var/mob/living/carbon/human/H = parent
	return istype(H) && (H.patron?.type == /datum/patron/old_god)

/datum/component/arousal/proc/is_nympho_sated()
	return (satisfaction_points >= ERP_NYMPHO_SATED_SP)

/datum/component/arousal/proc/get_nympho_hunger_level()
	if(!is_lovefiend())
		return 0
	if(is_nympho_sated())
		return 0
	if(satisfaction_points < ERP_NYMPHO_HARD_HUNGER_SP)
		return 2
	return 1

/datum/component/arousal/proc/sync_lovefiend_sated_from_sp()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
		
	if(!is_lovefiend())
		return

	var/datum/charflaw/addiction/A = H.get_flaw(/datum/charflaw/addiction/lovefiend)
	if(!istype(A, /datum/charflaw/addiction/lovefiend))
		return

	var/was_sated = A.sated
	var/now_sated = is_nympho_sated()
	if(was_sated == now_sated)
		return

	A.sated = now_sated
	A.unsate_time = world.time
	if(now_sated)
		nympho_sp_floor_until = world.time + 48 MINUTES
		if(A.sated_text)
			to_chat(H, span_blue(A.sated_text))

		H.remove_stress(/datum/stressevent/vice)
		if(A.debuff)
			H.remove_status_effect(A.debuff)
	else
		var/h = get_nympho_hunger_level()
		if(h >= 2)
			to_chat(H, span_boldred("I didn't indulge my vice."))
		else
			to_chat(H, span_boldwarning("I'm feeling randy."))

		H.add_stress(/datum/stressevent/vice)
		if(A.debuff)
			H.apply_status_effect(A.debuff)

/datum/component/arousal/proc/get_satisfaction_buff_tier()
	var/start_sp = 1.0
	if(is_lovefiend())
		start_sp = ERP_NYMPHO_SATED_SP

	if(satisfaction_points < start_sp)
		return 0

	var/t = floor(satisfaction_points - start_sp + 1.0)
	return clamp(t, 0, ERP_SATISFY_MAX_TIER)

/datum/component/arousal/proc/update_satisfaction_buff()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	var/tier = get_satisfaction_buff_tier()
	if(tier <= 0)
		H.remove_status_effect(/datum/status_effect/buff/erp_satisfaction)
		return

	var/datum/status_effect/buff/erp_satisfaction/E = H.has_status_effect(/datum/status_effect/buff/erp_satisfaction)
	if(!E)
		E = H.apply_status_effect(/datum/status_effect/buff/erp_satisfaction)
	if(E)
		E.set_tier(tier)

/datum/component/arousal/proc/try_gain_overload_point()
	if(overload_points >= ERP_OVERLOAD_MAX_OP)
		return
	if(satisfaction_points < ERP_OVERLOAD_SP_TRIGGER)
		return
	if(is_crackhead())
		return
	if(is_psydonist())
		return

	overload_points = min(ERP_OVERLOAD_MAX_OP, overload_points + 1)
	last_overload_gain_time = world.time
	update_overload_debuff()

/datum/component/arousal/proc/update_overload_debuff()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return

	if(overload_points <= 0)
		H.remove_status_effect(/datum/status_effect/debuff/erp_overload)
		return

	var/datum/status_effect/debuff/erp_overload/E = H.apply_status_effect(/datum/status_effect/debuff/erp_overload)
	if(E)
		E.set_stacks(overload_points)

/datum/component/arousal/proc/clear_overload_points(reason = null)
	overload_points = 0
	last_overload_gain_time = 0
	update_overload_debuff()

/datum/component/arousal/proc/handle_overload_decay()
	if(overload_points <= 0)
		last_overload_gain_time = 0
		return

	if(!last_overload_gain_time)
		last_overload_gain_time = world.time
		return

	if(world.time < last_overload_gain_time + ERP_OVERLOAD_DECAY_INTERVAL)
		return

	var/steps = FLOOR((world.time - last_overload_gain_time) / ERP_OVERLOAD_DECAY_INTERVAL, 1)
	if(steps <= 0)
		return

	last_overload_gain_time += steps * ERP_OVERLOAD_DECAY_INTERVAL
	overload_points = max(0, overload_points - steps)
	update_overload_debuff()

/datum/component/arousal/proc/adjust_satisfaction(delta)
	satisfaction_points = clamp(satisfaction_points + delta, 0.0, ERP_SP_MAX)
	if(is_nympho_sp_floor_active())
		satisfaction_points = max(satisfaction_points, 2.0)

	last_sp_decay_time = world.time
	sync_lovefiend_sated_from_sp()

/datum/component/arousal/proc/handle_satisfaction_decay()
	if(!last_sp_decay_time)
		last_sp_decay_time = world.time
		return

	if(world.time < last_sp_decay_time + ERP_SP_DECAY_INTERVAL)
		return

	var/steps = floor((world.time - last_sp_decay_time) / ERP_SP_DECAY_INTERVAL)
	if(steps <= 0)
		return

	last_sp_decay_time += steps * ERP_SP_DECAY_INTERVAL
	adjust_satisfaction(-ERP_SP_DECAY_AMOUNT * steps)

/datum/component/arousal/proc/award_satisfaction_on_climax(mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	if(!climaxer || climaxer != parent)
		return
	var/is_masturbation = (!istype(partner) || partner == climaxer)
	if(is_masturbation)
		adjust_satisfaction(ERP_SP_GAIN_MASTURBATE)
	else
		adjust_satisfaction(ERP_SP_GAIN_PARTNER)

/datum/component/arousal/proc/get_climax_stress_event(mob/living/carbon/human/partner, is_masturbation)
	var/is_nympho = is_lovefiend()

	if(is_masturbation)
		return /datum/stressevent/cumself

	var/sp = satisfaction_points
	if(is_nympho)
		if(sp < 2)
			return /datum/stressevent/cumok
		if(sp < 3)
			return /datum/stressevent/cummid
		if(sp < 4)
			return /datum/stressevent/cumgood
		if(sp < 5)
			return /datum/stressevent/cummax
		return /datum/stressevent/cumlove

	if(sp < 2)
		return /datum/stressevent/cumok
	if(sp < 3)
		return /datum/stressevent/cummid
	if(sp < 4)
		return /datum/stressevent/cumgood
	if(sp < 5)
		return /datum/stressevent/cummax
	return /datum/stressevent/cumlove

/datum/component/arousal/proc/clear_climax_stress_events(mob/living/carbon/human/H)
	if(!istype(H))
		return

	H.remove_stress(/datum/stressevent/cumself)
	H.remove_stress(/datum/stressevent/cumok)
	H.remove_stress(/datum/stressevent/cummid)
	H.remove_stress(/datum/stressevent/cumgood)
	H.remove_stress(/datum/stressevent/cummax)
	H.remove_stress(/datum/stressevent/cumlove)

/datum/component/arousal/proc/apply_climax_stress(mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	if(!istype(climaxer) || climaxer.stat == DEAD)
		return

	if(climaxer.has_flaw(/datum/charflaw/addiction/thrillseeker))
		climaxer.add_stress(/datum/stressevent/thrillsex)
		return

	var/is_masturbation = (!istype(partner) || partner == climaxer)
	var/event_type = get_climax_stress_event(partner, is_masturbation)
	if(event_type)
		clear_climax_stress_events(climaxer)
		climaxer.add_stress(event_type)

/datum/component/arousal/proc/handle_lovefiend_idle(dt)
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(!is_lovefiend())
		return

	if(is_nympho_sated())
		return

	if(is_in_erp_scene())
		return

	if(is_spent())
		return

	var/hunger = get_nympho_hunger_level()
	var/cap = (hunger >= 2) ? ERP_NYMPHO_HARD_CAP : ERP_NYMPHO_SOFT_CAP

	if(arousal < cap)
		set_arousal(parent, cap, TRUE)
		return

	if(arousal > cap)
		adjust_arousal(parent, -min(dt, arousal - cap))

/datum/component/arousal/process(dt)
	seed_satisfaction_if_needed()
	handle_satisfaction_decay()
	handle_overload_sleep_clear()
	handle_overload_decay()
	handle_charge(dt * 1)
	handle_lovefiend_idle(dt)
	apply_post_climax_multiplier_gain()

	if(can_lose_arousal())
		var/dec = dt * ERP_BASE_AROUSAL_DECAY_RATE * get_age_arousal_decay_mult()
		adjust_arousal(parent, -dec)

	if(!is_in_erp_scene())
		accumulated_pain_for_vice = max(0, accumulated_pain_for_vice - (dt / 10))

/datum/component/arousal/receive_sex_action(datum/source, arousal_amt, pain_amt, giving, applied_force, applied_speed, organ_id = null)
	var/mob/user = parent

	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0

	if(is_lovefiend() && !is_nympho_sated())
		if(arousal_amt > 0)
			arousal_amt *= ERP_NYMPHO_PRE_SATED_AROUSAL_GAIN_MULT

	var/list/effect = list(
		"arousal" = arousal_amt,
		"pain" = pain_amt,
		"giving" = giving,
		"force" = applied_force,
		"speed" = applied_speed,
		"organ_id" = organ_id,
		"source" = source
	)

	SEND_SIGNAL(user, COMSIG_SEX_MODIFY_EFFECT, effect)
	arousal_amt = isnum(effect["arousal"]) ? effect["arousal"] : arousal_amt
	pain_amt = isnum(effect["pain"]) ? effect["pain"] : pain_amt

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	damage_from_pain(pain_amt)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving)

	if(pain_amt > 0)
		accumulated_pain_for_vice += pain_amt
	try_do_maso_vice_moan()

/datum/component/arousal/damage_from_pain(pain_amt)
	if(!pain_amt)
		return
	var/mob/living/carbon/user = parent
	if(!user)
		return
	var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	if(!part)
		return
	user.apply_damage(pain_amt, BRUTE, part)

/datum/component/arousal/try_ejaculate()
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(is_spent())
		return
	ejaculate()
	record_round_statistic(STATS_PLEASURES)

/datum/component/arousal/proc/_link_get_partner(datum/erp_sex_link/link, mob/living/carbon/human/me)
	if(!link || !me)
		return null

	var/mob/living/carbon/human/A = link.actor_active?.physical
	var/mob/living/carbon/human/B = link.actor_passive?.physical
	if(istype(A) && istype(B))
		if(me == A)
			return B
		if(me == B)
			return A

	A = null
	B = null
	if(!isnull(link.vars["actor"]))
		A = link.vars["actor"]
	if(!isnull(link.vars["partner"]))
		B = link.vars["partner"]

	if(istype(A) && istype(B))
		if(me == A)
			return B
		if(me == B)
			return A

	return null

/datum/component/arousal/proc/spread_chain_orgasm(mob/living/carbon/human/source)
	if(!source || source != parent)
		return
	if(world.time < chain_lock_until)
		return

	chain_lock_until = world.time + ERP_CHAIN_LOCK_TIME

	var/list/L = get_erp_links()
	if(!length(L))
		return

	var/list/affected = list()

	for(var/datum/erp_sex_link/link in L)
		if(!link || QDELETED(link) || !link.is_valid() || link.state != LINK_STATE_ACTIVE)
			continue
		var/mob/living/carbon/human/p = _link_get_partner(link, source)
		if(!istype(p) || p == source || QDELETED(p) || p.stat == DEAD)
			continue
		affected[p] = TRUE

	for(var/mob/living/carbon/human/p2 as anything in affected)
		if(!istype(p2) || QDELETED(p2) || p2.stat == DEAD)
			continue
		var/bonus = p2.has_flaw(/datum/charflaw/addiction/lovefiend) ? ERP_CHAIN_BONUS_NYMPHO : ERP_CHAIN_BONUS
		SEND_SIGNAL(p2, COMSIG_SEX_ADJUST_AROUSAL, bonus)

/datum/component/arousal/ejaculate()
	if(world.time <= (last_ejaculation_world_time + 2 SECONDS))
		return
	last_ejaculation_world_time = world.time

	var/list/L = get_erp_links()
	var/datum/erp_sex_link/best = pick_best_erp_link(L)

	if(best)
		var/mob/living/carbon/human/H = parent
		if(!istype(H))
			return

		if(best.action && best.action.inject_timing == INJECT_ON_FINISH)
			best.action.handle_inject(best, H)

		var/datum/erp_controller/C = SSerp.get_controller_for(H)
		var/datum/erp_actor/me = C ? C.get_actor_by_mob(H) : null
		var/list/info = me ? best.handle_climax(me) : null
		var/climax_type = info?["type"] || "self"
		var/mob/living/carbon/human/partner = info?["partner"]

		spread_chain_orgasm(H)
		handle_climax(climax_type, H, partner, null)
		award_satisfaction_on_climax(H, partner)
		after_ejaculation(null, H, partner)
		return

/datum/component/arousal/handle_climax(climax_type, mob/living/carbon/human/climaxer, mob/living/carbon/human/partner, action)
	switch(climax_type)
		if("outside")
			log_combat(climaxer, partner, "Came onto [partner]")
			playsound(climaxer, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			playsound(partner, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			if(partner)
				var/datum/status_effect/facial/facial = partner.has_status_effect(/datum/status_effect/facial)
				if(!facial)
					partner.apply_status_effect(/datum/status_effect/facial)
				else
					facial.refresh_cum()
		if("inside")
			log_combat(climaxer, partner, "Came inside [partner]")
			playsound(climaxer, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
			playsound(partner, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
		if("self")
			log_combat(climaxer, climaxer, "Ejaculated")
			climaxer.visible_message(span_love("[climaxer] makes a mess!"))
			playsound(climaxer, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)

/datum/component/arousal/handle_charge(dt)
	var/regen_mult = get_age_charge_regen_mult()
	if(is_baotha_follower())
		regen_mult *= ERP_BAOTHA_CHARGE_REGEN_MULT

	adjust_charge(dt * CHARGE_RECHARGE_RATE * regen_mult)

	if(is_spent())
		if(arousal > 60)
			to_chat(parent, span_warning("I'm too spent!"))
			adjust_arousal(parent, -20)
			return
		adjust_arousal(parent, -dt * SPENT_AROUSAL_RATE)

/datum/component/arousal/proc/get_charge_cost_for_climax()
	var/cost = CHARGE_FOR_CLIMAX
	if(is_lovefiend())
		cost = round(cost * 0.75)
	return max(1, cost)

/datum/component/arousal/after_ejaculation(datum/sex_action/action, mob/living/carbon/human/climaxer, mob/living/carbon/human/partner)
	SEND_SIGNAL(climaxer, COMSIG_SEX_SET_AROUSAL, 20)
	SEND_SIGNAL(climaxer, COMSIG_SEX_CLIMAX)

	apply_climax_stress(climaxer, partner)
	var/cost = get_charge_cost_for_climax()
	charge = max(0, charge - cost)

	if(satisfaction_points >= ERP_OVERLOAD_SP_TRIGGER)
		try_gain_overload_point()

	apply_post_climax_multiplier_gain()
	climaxer.emote("moan", forced = TRUE)
	climaxer.playsound_local(climaxer, 'sound/misc/mat/end.ogg', 100)

	if(HAS_TRAIT(partner, TRAIT_GOODLOVER))
		if(!climaxer.mob_timers["cumtri"])
			climaxer.mob_timers["cumtri"] = world.time
			climaxer.adjust_triumphs(1)
			to_chat(climaxer, span_love("Our loving is a true TRIUMPH!"))
		if(!partner.mob_timers["cumtri"])
			partner.mob_timers["cumtri"] = world.time
			partner.adjust_triumphs(1)
			to_chat(partner, span_love("Our loving is a true TRIUMPH!"))

	return

/datum/component/arousal/proc/get_satisfaction_text()
	var/sp = satisfaction_points

	if(is_lovefiend() && sp <= 1)
		return "слабо"

	if(is_lovefiend())
		sp -= 1

	var/t = clamp(round(sp), 0, ERP_SP_MAX)

	switch(t)
		if(0) 	return "пустота"   
		if(1) 	return "нормально"
		if(2)   return "хорошо"
		if(3)   return "очень хорошо"
		if(4)   return "прекрасно"
		if(5)   return "блаженство"
		if(6)   return "перегруз"

	return "нормально"

/datum/component/arousal/get_arousal(datum/source, list/arousal_data)
	var/cost = get_charge_cost_for_climax()
	var/overload_active = (overload_points > 0) ? TRUE : FALSE

	arousal_data += list(
		"arousal" = arousal,
		"frozen" = arousal_frozen,
		"last_increase" = last_arousal_increase_time,
		"arousal_multiplier" = arousal_multiplier,
		"is_spent" = is_spent(),
		"charge" = charge,
		"charge_max" = SEX_MAX_CHARGE,
		"charge_for_climax" = cost,
		"charge_pct" = (SEX_MAX_CHARGE > 0) ? round((charge / SEX_MAX_CHARGE) * 100) : 0,
		"charge_need_pct" = (SEX_MAX_CHARGE > 0) ? round((cost / SEX_MAX_CHARGE) * 100) : 0,
		"sp_tier_text" = get_satisfaction_text(),
		"overload_active" = overload_active,
		"nympho_hunger" = get_nympho_hunger_level()
	)

/datum/component/arousal/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	var/mob/user = parent
	var/datum/erp_controller/controller_object = SSerp.get_controller_for(parent)
	if(!controller_object?.allow_user_moan)
		return
	if(user.stat != CONSCIOUS)
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	var/chosen_emote
	switch(arousal_amt)
		if(0 to MOAN_THRESHOLD)
			chosen_emote = "sexmoanlight"
		if(MOAN_THRESHOLD to INFINITY)
			chosen_emote = "sexmoanhvy"

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(giving)
			if(prob(30))
				chosen_emote = "groan"
		else
			if(prob(40))
				chosen_emote = "painmoan"

	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(prob(50))
				chosen_emote = "groan"
		else
			if(prob(60))
				chosen_emote = "painmoan"

	last_moan = world.time
	user.emote(chosen_emote)

/datum/component/arousal/proc/try_do_maso_vice_moan()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return
	if(H.stat != CONSCIOUS)
		return
	if(!H.has_flaw(/datum/charflaw/addiction/masochist))
		return
	if(accumulated_pain_for_vice < 1)
		return

	var/chance = clamp(round(accumulated_pain_for_vice * 5), 0, 100)
	if(!prob(chance))
		return

	H.add_stress(/datum/stressevent/cumpaingood)
	accumulated_pain_for_vice = 0
	H.emote("painmoan", forced = TRUE)
	last_moan = world.time

	satisfy_maso_sado_vices(H)

/datum/component/arousal/proc/satisfy_maso_sado_vices(mob/living/carbon/human/source)
	if(!source)
		return

	for(var/mob/living/carbon/human/H in view(2, source))
		if(H.stat == DEAD)
			continue

		if(H.get_flaw(/datum/charflaw/addiction/sadist))
			H.sate_addiction()

/datum/component/arousal/proc/get_age_category()
	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		return AGE_ADULT

	if(!isnull(H.vars["age"]))
		var/a = "[H.vars["age"]]"
		if(a in ALL_AGES_LIST)
			return a

	return AGE_ADULT

#define ERP_OVERLOAD_SLEEP_DECAY_INTERVAL (30 SECONDS)

/datum/component/arousal/proc/handle_overload_sleep_clear()
	if(overload_points <= 0)
		last_overload_sleep_decay_time = 0
		return

	var/mob/living/carbon/human/H = parent
	if(!istype(H))
		last_overload_sleep_decay_time = 0
		return

	if(!H.IsSleeping())
		last_overload_sleep_decay_time = 0
		return

	clear_overload_points("sleep")
	last_overload_sleep_decay_time = 0

/datum/component/arousal/adjust_arousal(datum/source, amount, forced = FALSE)
	if(arousal_frozen)
		return arousal
	var/effective = amount * arousal_multiplier
	return set_arousal(source, arousal + effective, forced)

/datum/component/arousal/proc/apply_post_climax_multiplier_gain()
	var/delta = 0.0
	if(is_lovefiend())
		delta = 0.05 * (satisfaction_points + overload_points)
	else
		delta = 0.1 * overload_points

	arousal_multiplier = 1.0 + max(0.0, delta)

/datum/component/arousal/proc/resolve_partner_mob(p)
	if(istype(p, /mob/living/carbon/human))
		return p
	if(istype(p, /datum/erp_actor))
		var/datum/erp_actor/A = p
		var/mob/M = A.get_mob()
		return istype(M, /mob/living/carbon/human) ? M : null
	return null

/datum/component/arousal/proc/is_nympho_sp_floor_active()
	return is_lovefiend() && (world.time < nympho_sp_floor_until)

#undef ERP_OVERLOAD_SLEEP_DECAY_INTERVAL
#undef NYMPHO_AROUSAL_SOFT_CAP
