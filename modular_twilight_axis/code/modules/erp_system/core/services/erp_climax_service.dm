#define ERP_CLIMAX_AMOUNT_SINGLE 5
#define ERP_CLIMAX_AMOUNT_COATING 8
#define ERP_CLIMAX_AMOUNT_INSIDE 5

/datum/erp_climax_service
	var/datum/erp_controller/controller

/datum/erp_climax_service/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Handles climax signal: message, schedule effects, stop until_climax links.
/datum/erp_climax_service/proc/on_arousal_climax(datum/source)
	var/mob/living/carbon/human/who = source
	if(!istype(who))
		return

	var/datum/component/arousal/A = who.GetComponent(/datum/component/arousal)
	if(A)
		if(A.erp_last_climax_fx_time && (world.time - A.erp_last_climax_fx_time) <= 2)
			return
		A.erp_last_climax_fx_time = world.time

	var/list/active_raw = list()
	SEND_SIGNAL(who, COMSIG_ERP_GET_LINKS, active_raw)

	var/list/active = list()
	if(active_raw && active_raw.len)
		for(var/datum/erp_sex_link/L in active_raw)
			if(L && !QDELETED(L) && L.is_valid())
				active += L

	var/datum/erp_sex_link/best = null
	if(active.len)
		best = pick_best_climax_link(who, active)

	if(best && best.action)
		var/text = null
		if(SSerp?.action_message_renderer)
			var/datum/erp_actor/as_actor = null
			if(best.actor_active?.physical == who)
				as_actor = best.actor_active
			else if(best.actor_passive?.physical == who)
				as_actor = best.actor_passive

			var/tpl = best.action.message_climax_active
			if(as_actor && as_actor == best.actor_passive)
				tpl = best.action.message_climax_passive

			if(tpl)
				text = SSerp.action_message_renderer.build_message(tpl, best, allow_knot_suffix = FALSE)

		if(text)
			controller.send_message(controller.spanify_scene_climax(text), best)

	INVOKE_ASYNC(controller, TYPE_PROC_REF(/datum/erp_controller, handle_arousal_climax_effects), who, active)
	for(var/datum/erp_sex_link/Lx in active)
		if(!Lx || QDELETED(Lx) || !Lx.is_valid())
			continue

		if(Lx.finish_mode != "until_climax")
			continue

		if(Lx.actor_active?.physical != who)
			continue

		var/datum/erp_controller/link_controller = Lx.session
		if(!istype(link_controller))
			link_controller = controller

		link_controller.stop_link_runtime(Lx)

	if(who.stat != DEAD)
		if(!controller?.hidden_mode)
			who.emote("sexmoanhvy", forced = TRUE)
		who.playsound_local(who, 'sound/misc/mat/end.ogg', 100)

	A?.spread_chain_orgasm(who)
	var/mob/living/carbon/human/partner = null
	if(best)
		var/list/ctx = get_orgasm_context(who, best)
		partner = ctx?["partner"]

	A?.award_satisfaction_on_climax(who, partner)
	A?.apply_climax_stress(who, partner)
	return

/// Runs delayed climax effects and updates UI.
/datum/erp_climax_service/proc/handle_arousal_climax_effects(mob/living/carbon/human/who, list/active_links)
	if(!istype(who) || who.stat == DEAD)
		return

	var/datum/erp_actor/A = controller.get_actor_by_mob(who)
	if(!A)
		return

	var/list/relevant_links = list()
	if(islist(active_links) && active_links.len)
		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue
			if(L.actor_active?.physical != who && L.actor_passive?.physical != who)
				continue
			relevant_links += L

	var/list/pens = A.get_organs_ref(SEX_ORGAN_PENIS)
	if(islist(pens) && pens.len)
		for(var/datum/erp_sex_organ/penis/P in pens)
			if(!P || QDELETED(P))
				continue
			if(!P.producing || !P.producing.producing_reagent)
				continue

			var/datum/erp_sex_link/best_link = null
			var/best_score = -1
			var/list/receiving_targets = list()
			var/list/receiving_force = list()

			for(var/datum/erp_sex_link/Lp in relevant_links)
				if(Lp.init_organ != P && Lp.target_organ != P)
					continue

				var/sc = Lp.get_climax_score(who)
				if(sc > best_score)
					best_score = sc
					best_link = Lp

				var/datum/erp_sex_organ/other = (Lp.init_organ == P) ? Lp.target_organ : Lp.init_organ
				if(!other || QDELETED(other))
					continue
				if(!(other.erp_organ_type in list(SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS, SEX_ORGAN_MOUTH)))
					continue

				receiving_targets += other
				receiving_force[other] = max(receiving_force[other] || 0, Lp.force)

			var/mob/living/carbon/human/top = P.get_owner()
			var/datum/component/erp_knotting/K = null
			if(istype(top))
				K = top.GetComponent(/datum/component/erp_knotting)
				if(!K && P.have_knot)
					K = top.AddComponent(/datum/component/erp_knotting)

			if(controller.do_knot_action && P.have_knot && K && receiving_targets.len)
				var/max_units = max(1, P.count_to_action)
				var/list/free_units = list()

				for(var/i = 0; i < max_units; i++)
					var/datum/erp_knot_link/occupied = K.get_link_for_penis_unit(P, i)
					if(!occupied || !occupied.is_valid())
						free_units += i

				for(var/datum/erp_sex_organ/T as anything in receiving_targets)
					if(!free_units.len)
						break

					var/mob/living/btm = T.get_owner()
					if(!istype(btm))
						continue

					var/slot = free_units[1]
					free_units.Cut(1, 2)
					K.try_knot_link(btm, P, T, penis_unit_id = slot, force_level = receiving_force[T])

			if(best_link?.action && best_link.action.inject_timing == INJECT_ON_FINISH)
				best_link.action.handle_inject(best_link, who)

			var/list/knot_links = list()
			if(K && islist(K.active_links) && K.active_links.len)
				for(var/datum/erp_knot_link/KL in K.active_links)
					if(!KL || QDELETED(KL) || !KL.is_valid())
						continue
					if(KL.penis_org != P)
						continue
					knot_links += KL

			if(knot_links.len)
				for(var/datum/erp_knot_link/AKL in knot_links)
					if(!AKL || QDELETED(AKL) || !AKL.is_valid())
						continue

					var/datum/erp_sex_organ/forced_target = AKL.receiving_org
					if(!forced_target || QDELETED(forced_target))
						continue

					var/datum/reagents/Rin = P.extract_reagents(ERP_CLIMAX_AMOUNT_INSIDE)
					if(!Rin)
						continue

					P.route_reagents(Rin, INJECT_ORGAN, forced_target)
					qdel(Rin)

					if(istype(forced_target, /datum/erp_sex_organ/vagina))
						var/datum/erp_sex_organ/vagina/Vforced = forced_target
						Vforced.on_climax(top, 0, 0)
			else if(best_link)
				do_climax_effects(who, best_link)
			else
				var/datum/reagents/Rp = P.extract_reagents(ERP_CLIMAX_AMOUNT_SINGLE)
				if(Rp)
					P.on_inject(null, INJECT_GROUND, get_turf(who), Rp, who)
					P.route_reagents(Rp, INJECT_GROUND, get_turf(who))
					qdel(Rp)

	var/list/vags = A.get_organs_ref(SEX_ORGAN_VAGINA)
	if(islist(vags) && vags.len)
		for(var/datum/erp_sex_organ/vagina/V in vags)
			if(!V || QDELETED(V))
				continue

			var/datum/erp_sex_link/best_link_v = null
			var/best_score_v = -1

			for(var/datum/erp_sex_link/Lv in relevant_links)
				if(Lv.init_organ != V && Lv.target_organ != V)
					continue

				var/scv = Lv.get_climax_score(who)
				if(scv > best_score_v)
					best_score_v = scv
					best_link_v = Lv

			if(best_link_v)
				controller.handle_inject(best_link_v, V, INJECT_ORGAN, who)
				do_climax_effects(who, best_link_v)
			else
				var/datum/reagents/Rv = V.extract_reagents(ERP_CLIMAX_AMOUNT_SINGLE)
				if(Rv)
					V.on_inject(null, INJECT_GROUND, get_turf(who), Rv, who)
					V.route_reagents(Rv, INJECT_GROUND, get_turf(who))
					qdel(Rv)

	var/list/br = A.get_organs_ref(SEX_ORGAN_BREASTS)
	if(islist(br) && br.len)
		for(var/datum/erp_sex_organ/B in br)
			if(!B || QDELETED(B))
				continue
			if(!B.producing || !B.producing.producing_reagent)
				continue

			var/datum/erp_sex_link/best_link_b = null
			var/best_score_b = -1

			for(var/datum/erp_sex_link/Lb in relevant_links)
				if(Lb.init_organ != B && Lb.target_organ != B)
					continue

				var/scb = Lb.get_climax_score(who)
				if(scb > best_score_b)
					best_score_b = scb
					best_link_b = Lb

			if(!best_link_b)
				continue

			controller.handle_inject(best_link_b, B, INJECT_ORGAN, who)
			do_climax_effects(who, best_link_b)

	controller.ui?.request_update()
	return

/// Picks best link for climax scoring.
/datum/erp_climax_service/proc/pick_best_climax_link(mob/living/carbon/human/who, list/active_links)
	if(!who || !active_links || !active_links.len)
		return null

	var/datum/erp_sex_link/best = null
	var/best_score = -1

	for(var/datum/erp_sex_link/L in active_links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue
		var/sc = L.get_climax_score(who)
		if(sc > best_score)
			best_score = sc
			best = L

	return best

/// Computes orgasm context (organ selection fallback).
/datum/erp_climax_service/proc/get_orgasm_context(mob/living/carbon/human/who, datum/erp_sex_link/best)
	if(!istype(who) || !best)
		return null

	var/datum/erp_sex_organ/init_org = best.init_organ
	var/datum/erp_sex_organ/target_org = best.target_organ

	var/mob/living/carbon/human/init_owner = init_org?.get_owner()
	var/mob/living/carbon/human/target_owner = target_org?.get_owner()

	var/datum/erp_sex_organ/orgasm_organ = null
	var/datum/erp_sex_organ/other_organ = null
	var/mob/living/carbon/human/partner = null

	if(init_owner == who)
		orgasm_organ = init_org
		other_organ = target_org
		partner = target_owner
	else if(target_owner == who)
		orgasm_organ = target_org
		other_organ = init_org
		partner = init_owner
	else
		if(best.actor_active?.physical == who)
			orgasm_organ = init_org
			other_organ = target_org
			partner = best.actor_passive?.physical
		else if(best.actor_passive?.physical == who)
			orgasm_organ = target_org
			other_organ = init_org
			partner = best.actor_active?.physical

	var/organ_type = orgasm_organ?.erp_organ_type
	if(!(organ_type in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS)))
		if(other_organ && other_organ.get_owner() == who)
			var/t2 = other_organ.erp_organ_type
			if(t2 in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS))
				orgasm_organ = other_organ
				other_organ = (other_organ == init_org) ? target_org : init_org
				partner = other_organ?.get_owner()

	return list(
		"organ" = orgasm_organ,
		"other_organ" = other_organ,
		"partner" = partner
	)

/// Applies coating status effect.
/datum/erp_climax_service/proc/apply_coating(mob/living/carbon/human/target, zone, datum/reagents/R, capacity = 30)
	if(!istype(target) || !R || R.total_volume <= 0)
		return FALSE

	var/datum/status_effect/erp_coating/E = null

	switch(zone)
		if("groin")
			E = target.has_status_effect(/datum/status_effect/erp_coating/groin)
			if(!E)
				E = target.apply_status_effect(/datum/status_effect/erp_coating/groin, capacity)
		if("chest")
			E = target.has_status_effect(/datum/status_effect/erp_coating/chest)
			if(!E)
				E = target.apply_status_effect(/datum/status_effect/erp_coating/chest, capacity)
		else
			E = target.has_status_effect(/datum/status_effect/erp_coating/face)
			if(!E)
				E = target.apply_status_effect(/datum/status_effect/erp_coating/face, capacity)

	if(!E)
		return FALSE

	E.add_from(R, R.total_volume)
	return TRUE

/// Applies coating and puddle, respecting clothing accessibility.
/datum/erp_climax_service/proc/apply_coating_and_puddle(datum/erp_sex_organ/source_organ, mob/living/carbon/human/coat_mob, zone, mob/living/carbon/human/feet_mob, amount, capacity = 30)
	if(!source_organ || QDELETED(source_organ))
		return FALSE
	if(!istype(coat_mob) || !istype(feet_mob))
		return FALSE
	if(!amount || amount <= 0)
		return FALSE

	var/bodyzone = controller._zone_key_to_bodyzone(zone)
	if(bodyzone && !get_location_accessible(coat_mob, bodyzone))
		var/datum/reagents/Rwaste = source_organ.extract_reagents(amount * 2)
		if(Rwaste)
			Rwaste.clear_reagents()
			qdel(Rwaste)
		return TRUE

	var/datum/reagents/Rcoat = source_organ.extract_reagents(amount)
	if(Rcoat)
		apply_coating(coat_mob, zone, Rcoat, capacity)
		qdel(Rcoat)

	var/datum/reagents/Rpuddle = source_organ.extract_reagents(amount)
	if(!Rpuddle)
		return TRUE

	var/turf/T = get_turf(feet_mob)
	if(!T)
		Rpuddle.clear_reagents()
		qdel(Rpuddle)
		return TRUE

	var/obj/effect/decal/cleanable/coom/C = null
	for(var/obj/effect/decal/cleanable/coom/existing in T)
		C = existing
		break

	if(!C)
		C = new /obj/effect/decal/cleanable/coom(T)

	if(!C.reagents)
		C.reagents = new /datum/reagents(C.reagents_capacity)
		C.reagents.my_atom = C

	Rpuddle.trans_to(C, Rpuddle.total_volume, 1, TRUE, TRUE)
	Rpuddle.clear_reagents()
	qdel(Rpuddle)

	return TRUE

/// Performs climax effects for who on best link.
/datum/erp_climax_service/proc/do_climax_effects(mob/living/carbon/human/who, datum/erp_sex_link/best)
	if(!istype(who) || !best)
		return FALSE

	var/list/ctx = get_orgasm_context(who, best)
	if(!ctx)
		return FALSE

	var/datum/erp_sex_organ/orgasm_organ = ctx["organ"]
	var/datum/erp_sex_organ/other_organ = ctx["other_organ"]
	var/mob/living/carbon/human/partner = ctx["partner"]
	if(!orgasm_organ || QDELETED(orgasm_organ))
		return FALSE

	var/mob/living/carbon/human/active_mob = best.actor_active?.physical
	var/mob/living/carbon/human/passive_mob = best.actor_passive?.physical
	var/two_actors = (istype(active_mob) && istype(passive_mob) && active_mob != passive_mob)
	var/organ_type = orgasm_organ.erp_organ_type
	if(!(organ_type in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS)))
		return FALSE

	var/mob/living/carbon/human/receiver = who
	if(two_actors && istype(partner) && partner != who)
		receiver = partner

	var/zone = "groin"
	if(other_organ && !QDELETED(other_organ))
		switch(other_organ.erp_organ_type)
			if(SEX_ORGAN_MOUTH)
				zone = "face"
			if(SEX_ORGAN_BREASTS)
				zone = "chest"
			else
				zone = "groin"

	var/mob/living/carbon/human/feet_mob = receiver
	if(!istype(feet_mob))
		feet_mob = who

	if(organ_type == SEX_ORGAN_PENIS || organ_type == SEX_ORGAN_BREASTS)
		if(!orgasm_organ.producing || !orgasm_organ.producing.producing_reagent)
			return FALSE

	if(organ_type == SEX_ORGAN_PENIS)
		var/datum/erp_sex_organ/penis/Pk = orgasm_organ

		var/list/tags = best.action?.action_tags
		var/force_inside = FALSE
		var/force_outside = FALSE
		var/blocks_inside = FALSE
		if(islist(tags))
			if("inject_inside_only" in tags)
				force_inside = TRUE
			if("inject_outside_only" in tags)
				force_outside = TRUE
			if("no_internal_climax" in tags)
				blocks_inside = TRUE

		var/mode = Pk.climax_mode
		if(force_inside)
			mode = "inside"
		else if(force_outside)
			mode = "outside"

		if(mode == "inside" && blocks_inside)
			mode = "outside"

		var/datum/erp_sex_organ/inside_target_organ = null
		if(mode == "inside")
			inside_target_organ = other_organ

		if(mode == "inside")
			if(!inside_target_organ || QDELETED(inside_target_organ))
				mode = "outside"
			else
				var/it = inside_target_organ.erp_organ_type
				if(!(it in list(SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS, SEX_ORGAN_MOUTH)))
					mode = "outside"

		if(mode == "inside" && inside_target_organ)
			var/datum/reagents/Rin = orgasm_organ.extract_reagents(ERP_CLIMAX_AMOUNT_INSIDE)
			if(!Rin)
				return TRUE

			orgasm_organ.route_reagents(Rin, INJECT_ORGAN, inside_target_organ)
			qdel(Rin)

			if(istype(inside_target_organ, /datum/erp_sex_organ/vagina))
				var/datum/erp_sex_organ/vagina/Vin = inside_target_organ
				var/mob/living/carbon/human/top = orgasm_organ.get_owner()
				Vin.on_climax(top, 0, 0)

			return TRUE

		return apply_coating_and_puddle(orgasm_organ, receiver, zone, feet_mob, ERP_CLIMAX_AMOUNT_COATING, 30)

	if(organ_type == SEX_ORGAN_VAGINA)
		return apply_coating_and_puddle(orgasm_organ, who, "groin", who, ERP_CLIMAX_AMOUNT_COATING, 30)

	if(organ_type == SEX_ORGAN_BREASTS)
		return apply_coating_and_puddle(orgasm_organ, who, "chest", who, ERP_CLIMAX_AMOUNT_COATING, 30)

	return FALSE

#undef ERP_CLIMAX_AMOUNT_SINGLE
#undef ERP_CLIMAX_AMOUNT_COATING
#undef ERP_CLIMAX_AMOUNT_INSIDE
