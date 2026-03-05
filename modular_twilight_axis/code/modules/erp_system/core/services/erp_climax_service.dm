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

	var/list/active = list()
	if(controller.links && controller.links.len)
		for(var/datum/erp_sex_link/L in controller.links)
			if(L && !QDELETED(L) && L.is_valid())
				active += L

	if(!active.len)
		return

	var/datum/erp_sex_link/best = pick_best_climax_link(who, active)
	if(best && best.action)
		var/datum/erp_actor/as_actor = null
		if(best.actor_active?.physical == who)
			as_actor = best.actor_active
		else if(best.actor_passive?.physical == who)
			as_actor = best.actor_passive

		var/text = null
		if(SSerp?.action_message_renderer)
			var/tpl = best.action.message_climax_active
			if(as_actor && as_actor == best.actor_passive)
				tpl = best.action.message_climax_passive
			if(tpl)
				text = SSerp.action_message_renderer.build_message(tpl, best)

		if(text)
			controller.send_message(controller.spanify_scene_climax(text), best)

	INVOKE_ASYNC(controller, TYPE_PROC_REF(/datum/erp_controller, handle_arousal_climax_effects), who, active)

	if(controller.links && controller.links.len)
		for(var/i = controller.links.len; i >= 1; i--)
			var/datum/erp_sex_link/Lx = controller.links[i]
			if(!Lx || QDELETED(Lx) || !Lx.is_valid())
				continue
			if(Lx.finish_mode != "until_climax")
				continue
			if(Lx.actor_active?.physical != who)
				continue
			controller.stop_link_runtime(Lx)

/// Runs delayed climax effects and updates UI.
/datum/erp_climax_service/proc/handle_arousal_climax_effects(mob/living/carbon/human/who, list/active_links)
	if(!istype(who) || !islist(active_links) || !active_links.len)
		return

	for(var/datum/erp_sex_link/L in active_links)
		if(!L || QDELETED(L) || !L.is_valid())
			continue
		if(L.actor_active?.physical != who && L.actor_passive?.physical != who)
			continue
		do_climax_effects(who, L)

	controller.ui?.request_update()

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
	if(!who || !best)
		return null

	var/is_active = (best.actor_active?.physical == who)
	var/datum/erp_sex_organ/base_org = is_active ? best.init_organ : best.target_organ
	var/datum/erp_sex_organ/other_org = is_active ? best.target_organ : best.init_organ
	var/mob/living/carbon/human/partner = is_active ? best.actor_passive?.physical : best.actor_active?.physical

	var/datum/erp_sex_organ/org = base_org
	if(org)
		var/t = org.erp_organ_type
		if(!(t in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS)))
			var/can_use_other = FALSE
			if(other_org)
				if(other_org.host == who)
					var/t2 = other_org.erp_organ_type
					if(t2 in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS))
						can_use_other = TRUE
			if(can_use_other)
				org = other_org

	return list(
		"is_active" = is_active,
		"organ" = org,
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
	if(!best.is_valid())
		return FALSE

	var/list/ctx = get_orgasm_context(who, best)
	if(!islist(ctx))
		return FALSE

	var/is_active = ctx["is_active"] ? TRUE : FALSE
	var/datum/erp_sex_organ/orgasm_organ = ctx["organ"]
	if(!orgasm_organ)
		return FALSE

	var/mob/living/carbon/human/active_mob  = best.actor_active?.physical
	var/mob/living/carbon/human/passive_mob = best.actor_passive?.physical
	var/two_actors = (istype(active_mob) && istype(passive_mob) && active_mob != passive_mob)

	var/organ_type = orgasm_organ.erp_organ_type
	if(!(organ_type in list(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_BREASTS)))
		return FALSE

	if(!two_actors)
		if(organ_type == SEX_ORGAN_VAGINA)
			return apply_coating_and_puddle(orgasm_organ, who, "groin", who, ERP_CLIMAX_AMOUNT_COATING, 30)

		if(organ_type == SEX_ORGAN_BREASTS)
			if(!orgasm_organ.producing || !orgasm_organ.producing.producing_reagent)
				return FALSE
			return apply_coating_and_puddle(orgasm_organ, who, "chest", who, ERP_CLIMAX_AMOUNT_COATING, 30)

		if(organ_type == SEX_ORGAN_PENIS)
			if(!orgasm_organ.producing || !orgasm_organ.producing.producing_reagent)
				return FALSE
			return apply_coating_and_puddle(orgasm_organ, who, "groin", who, ERP_CLIMAX_AMOUNT_COATING, 30)

		return FALSE

	if(organ_type == SEX_ORGAN_VAGINA)
		return apply_coating_and_puddle(orgasm_organ, who, "groin", who, ERP_CLIMAX_AMOUNT_COATING, 30)

	if(organ_type == SEX_ORGAN_BREASTS)
		if(!orgasm_organ.producing || !orgasm_organ.producing.producing_reagent)
			return FALSE
		return apply_coating_and_puddle(orgasm_organ, who, "chest", who, ERP_CLIMAX_AMOUNT_COATING, 30)

	if(organ_type == SEX_ORGAN_PENIS)
		if(!orgasm_organ.producing || !orgasm_organ.producing.producing_reagent)
			return FALSE

		var/datum/erp_sex_organ/penis/Pk = orgasm_organ
		var/mob/living/carbon/human/topk = Pk.get_owner()
		if(!istype(topk))
			return FALSE

		var/datum/component/erp_knotting/Kk = controller._get_knotting_component(topk)
		if(!Kk && Pk.have_knot)
			Kk = topk.AddComponent(/datum/component/erp_knotting)

		if(controller.do_knot_action && Pk.have_knot && Kk)
			var/max_units = max(1, Pk.count_to_action)
			for(var/datum/erp_sex_link/L in controller.links)
				if(!L || QDELETED(L) || !L.is_valid())
					continue

				if(L.init_organ != Pk && L.target_organ != Pk)
					continue

				var/datum/erp_sex_organ/receiving = (L.init_organ == Pk) ? L.target_organ : L.init_organ
				if(!receiving)
					continue

				if(!(receiving.erp_organ_type in list(SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS, SEX_ORGAN_MOUTH)))
					continue

				var/mob/living/carbon/human/btm = L.actor_passive?.physical
				if(!istype(btm))
					continue

				for(var/i = 0; i < max_units; i++)
					if(!Kk.get_link_for_penis_unit(Pk, i))
						if(Kk.can_start_action_with_penis(Pk, receiving, i))
							Kk.try_knot_link(btm, Pk, receiving, i, L.force)
							break

		var/datum/erp_sex_organ/forced_knot_target = null
		if(Kk && Pk.have_knot)
			var/max_units = max(1, Pk.count_to_action)
			for(var/i = 0; i < max_units; i++)
				if(Kk.get_forced_inject_target(Pk, i))
					forced_knot_target = Kk.get_forced_inject_target(Pk, i)
					break

		if(forced_knot_target)
			var/datum/reagents/Rk = orgasm_organ.extract_reagents(ERP_CLIMAX_AMOUNT_INSIDE)
			if(!Rk)
				return TRUE

			orgasm_organ.route_reagents(Rk, INJECT_ORGAN, forced_knot_target)
			qdel(Rk)

			if(istype(forced_knot_target,/datum/erp_sex_organ/vagina))
				var/datum/erp_sex_organ/vagina/Vk = forced_knot_target
				Vk.on_climax(who, 0, 0)

			return TRUE

		var/list/tags = best.action?.action_tags
		var/force_inside = FALSE
		var/force_outside = FALSE
		var/blocks_inside = FALSE

		if(islist(tags))
			if("inject_inside_only" in tags)  force_inside = TRUE
			if("inject_outside_only" in tags) force_outside = TRUE
			if("no_internal_climax" in tags)  blocks_inside = TRUE

		var/mode = Pk.climax_mode
		if(force_inside)
			mode = "inside"
		else if(force_outside)
			mode = "outside"

		if(mode == "inside" && blocks_inside)
			mode = "outside"

		var/datum/erp_sex_organ/inside_target_organ = null
		if(mode == "inside")
			inside_target_organ = is_active ? best.target_organ : best.init_organ

		if(mode == "inside")
			if(!inside_target_organ)
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

			if(istype(inside_target_organ,/datum/erp_sex_organ/vagina))
				var/datum/erp_sex_organ/vagina/V = inside_target_organ
				V.on_climax(who, 0, 0)

			return TRUE

		if(mode == "outside")
			var/datum/reagents/Rout = orgasm_organ.extract_reagents(ERP_CLIMAX_AMOUNT_COATING)
			if(Rout)
				orgasm_organ.route_reagents(Rout, INJECT_GROUND, null)
				qdel(Rout)
			return TRUE

		if(mode == "self")
			var/datum/reagents/Rout = orgasm_organ.extract_reagents(ERP_CLIMAX_AMOUNT_SINGLE)
			if(Rout)
				orgasm_organ.route_reagents(Rout, INJECT_GROUND, null)
				qdel(Rout)
			return TRUE

		var/mob/living/carbon/human/coating_target = null
		if(is_active)
			coating_target = passive_mob
		else
			coating_target = active_mob

		if(!istype(coating_target))
			return apply_coating_and_puddle(orgasm_organ, who, "groin", who, ERP_CLIMAX_AMOUNT_COATING, 30)

		return apply_coating_and_puddle(orgasm_organ, coating_target, "groin", coating_target, ERP_CLIMAX_AMOUNT_COATING, 30)

	return FALSE

#undef ERP_CLIMAX_AMOUNT_SINGLE
#undef ERP_CLIMAX_AMOUNT_COATING
#undef ERP_CLIMAX_AMOUNT_INSIDE
