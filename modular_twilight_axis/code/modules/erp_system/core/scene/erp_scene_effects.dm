#define ERP_SCENE_AROUSAL_MULT 3.00
#define ERP_SCENE_PAIN_MULT 0.75

/datum/erp_scene_effects
	var/datum/erp_controller/controller

/datum/erp_scene_effects/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Applies tick effects (arousal/pain/inject) for active links.
/datum/erp_scene_effects/proc/apply_scene_effects(list/active_links, datum/erp_sex_link/best, dt)
	if(!islist(active_links) || !active_links.len)
		return

	var/n = 0
	var/sum_force = 0
	var/sum_speed = 0

	var/a_arousal_sum = 0
	var/p_arousal_sum = 0
	var/a_pain_sum = 0
	var/p_pain_sum = 0

	var/list/asphyxia_by_actor = list()
	for(var/datum/erp_sex_link/L in active_links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue

		n++
		controller._note_knot_activity_from_link(L)

		var/f = clamp(round(L.force || SEX_FORCE_MID), SEX_FORCE_LOW, SEX_FORCE_EXTREME)
		var/s = clamp(round(L.speed || SEX_SPEED_MID), SEX_SPEED_LOW, SEX_SPEED_EXTREME)

		sum_force += f
		sum_speed += s

		var/list/r = L.action?.calc_effect(L)
		if(r)
			var/arA = r[ERP_ACTION_ACTIVE_AROUSAL]
			var/arP = r[ERP_ACTION_PASSIVE_AROUSAL]
			var/paA = r[ERP_ACTION_ACTIVE_PAIN]
			var/paP = r[ERP_ACTION_PASSIVE_PAIN]

			if(!isnum(arA))
				arA = r[ERP_ACTION_LEGACY_AROUSAL] || 0
			if(!isnum(arP))
				arP = r[ERP_ACTION_LEGACY_AROUSAL] || 0
			if(!isnum(paA))
				paA = r[ERP_ACTION_LEGACY_PAIN] || 0
			if(!isnum(paP))
				paP = r[ERP_ACTION_LEGACY_PAIN] || 0

			a_arousal_sum += arA
			p_arousal_sum += arP

			if(f > SEX_FORCE_MID)
				if(isnum(paA) && paA != 0)
					var/datum/erp_sex_organ/Oa = L.init_organ
					if(Oa && !QDELETED(Oa))
						Oa.add_pain(paA)
						paA *= Oa.pain

				if(isnum(paP) && paP != 0)
					var/datum/erp_sex_organ/Op = L.target_organ
					if(Op && !QDELETED(Op))
						Op.add_pain(paP)
						paP *= Op.pain

				a_pain_sum += paA
				p_pain_sum += paP

		if(L.action && L.action.inject_timing == INJECT_CONTINUOUS)
			L.action.handle_inject(L, null)

		if(_is_sucking_link(L))
			var/datum/erp_actor/mouth_actor = _get_mouth_actor_for_link(L)
			if(mouth_actor)
				var/add = 0
				if(f >= SEX_FORCE_EXTREME)
					add = 3
				else if(f >= SEX_FORCE_HIGH)
					add = 2

				if(add > 0)
					asphyxia_by_actor[mouth_actor] = (asphyxia_by_actor[mouth_actor] || 0) + add

	if(n <= 0)
		return

	var/avg_force = clamp(round(sum_force / n), SEX_FORCE_LOW, SEX_FORCE_EXTREME)
	var/avg_speed = clamp(round(sum_speed / n), SEX_SPEED_LOW, SEX_SPEED_EXTREME)

	var/a_arousal = (a_arousal_sum / n) * ERP_SCENE_AROUSAL_MULT
	var/p_arousal = (p_arousal_sum / n) * ERP_SCENE_AROUSAL_MULT

	var/a_pain = (a_pain_sum / n) * ERP_SCENE_PAIN_MULT
	var/p_pain = (p_pain_sum / n) * ERP_SCENE_PAIN_MULT

	var/mob/living/ma = best?.actor_active?.get_effect_mob()
	var/mob/living/mp = best?.actor_passive?.get_effect_mob()

	if(best?.actor_active == best?.actor_passive)
		a_arousal += p_arousal
		a_pain += p_pain

	if(best?.actor_active)
		var/multA = controller.inject_d.rel_mult_for(ma, mp)
		best.actor_active.apply_erp_effect(a_arousal * multA, a_pain, TRUE, avg_force, avg_speed, null)

	if(best?.actor_passive && best?.actor_active != best?.actor_passive)
		var/multP = controller.inject_d.rel_mult_for(mp, ma)
		best.actor_passive.apply_erp_effect(p_arousal * multP, p_pain, FALSE, avg_force, avg_speed, null)

/// Returns average force/speed for active links.
/datum/erp_scene_effects/proc/get_scene_force_speed_avg(list/active_links)
	var/n = 0
	var/sum_force = 0
	var/sum_speed = 0

	for(var/datum/erp_sex_link/L in active_links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue
		n++
		sum_force += (L.force || 0)
		sum_speed += (L.speed || 0)

	if(!n)
		return list("force" = SEX_FORCE_MID, "speed" = SEX_SPEED_MID)

	return list(
		"force" = clamp(round(sum_force / n), SEX_FORCE_LOW, SEX_FORCE_EXTREME),
		"speed" = clamp(round(sum_speed / n), SEX_SPEED_LOW, SEX_SPEED_EXTREME),
	)

/datum/erp_scene_effects/proc/_is_sucking_link(datum/erp_sex_link/L)
	var/init_t = L.init_organ?.erp_organ_type
	var/tgt_t  = L.target_organ?.erp_organ_type
	if(!(init_t == SEX_ORGAN_MOUTH || tgt_t == SEX_ORGAN_MOUTH))
		return FALSE
	return !(init_t == SEX_ORGAN_MOUTH && tgt_t == SEX_ORGAN_MOUTH)

/datum/erp_scene_effects/proc/_get_mouth_actor_for_link(datum/erp_sex_link/L)
	if(L.init_organ?.erp_organ_type == SEX_ORGAN_MOUTH)
		return L.actor_active
	if(L.target_organ?.erp_organ_type == SEX_ORGAN_MOUTH)
		return L.actor_passive
	return null
