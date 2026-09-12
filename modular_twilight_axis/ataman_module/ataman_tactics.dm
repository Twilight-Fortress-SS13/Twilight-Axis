/datum/ai_behavior/npc_kick_attack/ataman_low

/datum/ai_behavior/npc_kick_attack/ataman_low/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/living/pawn = controller.pawn
	if(istype(pawn))
		pawn.zone_selected = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	return ..()

/datum/ai_planning_subtree/ataman_intercept/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/npc/ataman_bandit/pawn = controller.pawn
	if(!istype(pawn) || pawn.ataman_role != ATAMAN_ROLE_ENFORCER)
		return
	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	if(!squad)
		return
	var/mob/living/carbon/target = controller.blackboard[BB_ATAMAN_TARGET]
	if(!istype(target) || target.stat == DEAD || ataman_target_is_secured(target) || length(target.grabbedby))
		squad.release_interceptor(pawn)
		return
	if(pawn.Adjacent(target))
		squad.release_interceptor(pawn)
		return
	var/turf/intercept_point = squad.get_intercept_point()
	if(!intercept_point)
		squad.release_interceptor(pawn)
		return
	if(!squad.claim_interceptor(pawn))
		squad.release_interceptor(pawn)
		return
	ataman_ai_log(pawn, "INTERCEPT: cutting off [target] toward [intercept_point]")
	controller.set_blackboard_key(BB_ATAMAN_INTERCEPT_TURF, intercept_point)
	controller.queue_behavior(/datum/ai_behavior/travel_towards/stop_on_arrival, BB_ATAMAN_INTERCEPT_TURF)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/ataman_leash/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/npc/ataman_bandit/pawn = controller.pawn
	if(!istype(pawn) || pawn.ataman_disbanding)
		return
	var/mob/living/hunted = controller.blackboard[BB_ATAMAN_TARGET]
	if(!istype(hunted) || hunted.stat == DEAD || pawn.ataman_gave_up)
		if(!pawn.ataman_idle_until)
			pawn.ataman_idle_until = world.time + rand(ATAMAN_IDLE_DESPAWN_MIN, ATAMAN_IDLE_DESPAWN_MAX)
		else if(world.time >= pawn.ataman_idle_until)
			ataman_ai_log(pawn, "IDLE: nothing left to hunt, breaking off for good")
			ataman_disband(controller, pawn)
			return SUBTREE_RETURN_FINISH_PLANNING
		return

	pawn.ataman_idle_until = 0
	var/turf/spawn_turf = controller.blackboard[BB_ATAMAN_SPAWN_TURF]
	var/target_gap = get_dist(pawn, hunted)
	var/spawn_gap = spawn_turf ? get_dist(pawn, spawn_turf) : 0
	if(target_gap <= ATAMAN_GIVEUP_RANGE && spawn_gap <= ATAMAN_LEASH_RANGE)
		return

	ataman_ai_log(pawn, "LEASH: [hunted] broke away - [target_gap] tiles between us, [spawn_gap] from spawn, melting into the treeline")
	if(pawn.pulling == hunted)
		pawn.stop_pulling()
	pawn.cmode = FALSE
	pawn.ataman_gave_up = TRUE
	controller.clear_blackboard_key(BB_ATAMAN_TARGET)
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	ataman_disband(controller, pawn)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/ataman_disarm_restrain/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/npc/ataman_bandit/pawn = controller.pawn
	ataman_recover_target(controller, pawn)
	var/mob/living/carbon/target = controller.blackboard[BB_ATAMAN_TARGET]
	if(!istype(pawn) || !istype(target) || target.stat == DEAD)
		if(istype(pawn))
			ataman_ai_log(pawn, "CAPTURE: target [target] gone/dead, clearing")
			ataman_disband(controller, pawn)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(ataman_target_is_secured(target))
		var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
		var/mob/living/owner_mob = controller.blackboard[BB_ATAMAN_OWNER]
		if(squad && !squad.owner_took_custody && owner_mob && target.pulledby == owner_mob)
			squad.owner_took_custody = TRUE
			ataman_ai_log(pawn, "CUSTODY: [owner_mob] took [target], the gang loses interest")
		if(squad && !squad.owner_took_custody && squad.claim_holder(pawn))
			controller.queue_behavior(/datum/ai_behavior/ataman_hold_secured, BB_ATAMAN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		ataman_disband(controller, pawn)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, target)
	var/role = controller.blackboard[BB_ATAMAN_ROLE]
	var/target_is_armed = target.get_active_held_item() || target.get_inactive_held_item()

	switch(role)
		if(ATAMAN_ROLE_GRABBER)
			if(!(target.mobility_flags & MOBILITY_STAND))
				ataman_ai_log(pawn, "CAPTURE: grabber -> hold (target down)")
				controller.queue_behavior(/datum/ai_behavior/ataman_hold, BB_ATAMAN_TARGET)
			else if(target_is_armed)
				ataman_ai_log(pawn, "CAPTURE: grabber -> disarm (target armed)")
				controller.queue_behavior(/datum/ai_behavior/ataman_disarm, BB_ATAMAN_TARGET)
			else
				ataman_ai_log(pawn, "CAPTURE: grabber -> hold (target unarmed)")
				controller.queue_behavior(/datum/ai_behavior/ataman_hold, BB_ATAMAN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		if(ATAMAN_ROLE_BINDER)
			var/standing = target.mobility_flags & MOBILITY_STAND
			var/pinned = length(target.grabbedby) && (target.IsOffBalanced() || ataman_target_under_debuff(target))
			if(target.stat == CONSCIOUS && standing && (target_is_armed || !pinned))
				ataman_ai_log(pawn, "CAPTURE: binder not ready (armed=[target_is_armed ? "yes" : "no"] standing=yes pinned=[pinned ? "yes" : "no"]) - falling back to attacking")
				return
			ataman_ai_log(pawn, "CAPTURE: binder -> restrain")
			controller.queue_behavior(/datum/ai_behavior/ataman_restrain, BB_ATAMAN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		if(ATAMAN_ROLE_ENFORCER)
			if(!target_is_armed || target.pulledby || !(target.mobility_flags & MOBILITY_STAND))
				return

	return

/datum/ai_behavior/ataman_disarm
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/ataman_disarm/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/ataman_disarm/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/carbon/target = controller.blackboard[target_key]
	if(!istype(pawn) || !istype(target) || QDELETED(target) || ataman_target_is_secured(target))
		finish_action(controller, FALSE, target_key)
		return
	if(!pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key)
		return

	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	if(squad?.is_target_caster(target) && !ataman_target_mouth_secured(target))
		if(!get_location_accessible(target, BODY_ZONE_PRECISE_MOUTH))
			if(target.mobility_flags & MOBILITY_STAND)
				ataman_ai_log(pawn, "DISARM: [target] is a masked caster, headhunting instead of grabbing")
				controller.set_blackboard_key(BB_HUMAN_NPC_WEAKPOINT, list(BODY_ZONE_HEAD, world.time + 2 SECONDS, target))
				finish_action(controller, FALSE, target_key)
				return
		else if(pawn.pulling == target)
			finish_action(controller, TRUE, target_key)
			return
		else if(ataman_try_mouth_grab(controller, pawn, target, squad))
			finish_action(controller, TRUE, target_key)
			return

	var/obj/item/armed_hand = target.get_active_held_item() || target.get_inactive_held_item()
	if(!armed_hand)
		ataman_ai_log(pawn, "DISARM: [target] already unarmed, nothing to do")
		finish_action(controller, TRUE, target_key)
		return

	var/grab_limb = target.get_active_held_item() ? BODY_ZONE_PRECISE_R_HAND : BODY_ZONE_PRECISE_L_HAND
	var/obj/item/grabbing/grab_item = ataman_get_grab_on(pawn, target, grab_limb)
	if(!grab_item)
		if(!ataman_free_hands_for_grabbing(controller))
			ataman_ai_log(pawn, "DISARM: couldn't free a hand to grab [target]")
			finish_action(controller, FALSE, target_key)
			return
		pawn.zone_selected = grab_limb
		if(!pawn.start_pulling(target, GRAB_PASSIVE, item_override = grab_limb))
			ataman_ai_log(pawn, "DISARM: grab on [grab_limb] failed to start")
			finish_action(controller, FALSE, target_key)
			return
		grab_item = ataman_get_grab_on(pawn, target, grab_limb)

	if(!grab_item || !ataman_make_grab_active(pawn, grab_item))
		ataman_ai_log(pawn, "DISARM: grab on [target] was lost before it could be used")
		finish_action(controller, FALSE, target_key)
		return

	pawn.update_grab_intents()
	pawn.update_a_intents()

	var/datum/intent/grab/disarm/disarm_intent
	for(var/datum/intent/candidate as anything in pawn.possible_a_intents)
		if(istype(candidate, /datum/intent/grab/disarm))
			disarm_intent = candidate
			break

	if(!disarm_intent)
		ataman_ai_log(pawn, "DISARM: no disarm intent even with grab active (active=[pawn.get_active_held_item()])")
		finish_action(controller, FALSE, target_key)
		return

	ataman_ai_log(pawn, "DISARM: attempting disarm on [target] ([armed_hand])")
	pawn.a_intent = disarm_intent
	pawn.used_intent = disarm_intent
	controller.ai_interact(target, TRUE, TRUE)
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/ataman_hold
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/ataman_hold/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/ataman_hold/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/carbon/target = controller.blackboard[target_key]
	if(!istype(pawn) || !istype(target) || QDELETED(target) || ataman_target_is_secured(target) || !pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key)
		return

	var/obj/item/grabbing/torso_grab = ataman_get_grab_on(pawn, target, BODY_ZONE_CHEST)
	if(!torso_grab)
		if(!ataman_free_hands_for_grabbing(controller))
			ataman_ai_log(pawn, "HOLD: couldn't free a hand to reinforce the grip on [target]")
			finish_action(controller, FALSE, target_key)
			return
		pawn.zone_selected = BODY_ZONE_CHEST
		if(!pawn.start_pulling(target, GRAB_PASSIVE, item_override = BODY_ZONE_CHEST))
			ataman_ai_log(pawn, "HOLD: torso grip on [target] failed to start")
			finish_action(controller, FALSE, target_key)
			return
		ataman_ai_log(pawn, "HOLD: reinforced the grip with a hold on [target]'s torso")
		torso_grab = ataman_get_grab_on(pawn, target, BODY_ZONE_CHEST)

	if(!torso_grab || !ataman_make_grab_active(pawn, torso_grab))
		finish_action(controller, FALSE, target_key)
		return

	if(target.mobility_flags & MOBILITY_STAND)
		pawn.update_grab_intents()
		pawn.update_a_intents()
		var/datum/intent/grab/shove/shove_intent
		for(var/datum/intent/candidate as anything in pawn.possible_a_intents)
			if(istype(candidate, /datum/intent/grab/shove))
				shove_intent = candidate
				break
		if(shove_intent)
			ataman_ai_log(pawn, "HOLD: shoving [target]")
			pawn.a_intent = shove_intent
			pawn.used_intent = shove_intent
			controller.ai_interact(target, TRUE, TRUE)
		else
			ataman_ai_log(pawn, "HOLD: no shove intent even with torso grip active")
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/ataman_hold_secured
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/ataman_hold_secured/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/ataman_hold_secured/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/carbon/human/target = controller.blackboard[target_key]
	if(!istype(pawn) || !istype(target) || QDELETED(target) || target.stat == DEAD || !ataman_target_is_secured(target))
		finish_action(controller, FALSE, target_key)
		return
	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	var/mob/living/owner_mob = controller.blackboard[BB_ATAMAN_OWNER]
	if(squad && !squad.owner_took_custody && owner_mob && target.pulledby == owner_mob)
		squad.owner_took_custody = TRUE
		ataman_ai_log(pawn, "CUSTODY: [owner_mob] took [target], releasing")
	if(squad?.owner_took_custody)
		if(pawn.pulling == target)
			pawn.stop_pulling()
		pawn.cmode = FALSE
		finish_action(controller, TRUE, target_key)
		return
	if(!pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key)
		return

	if(squad?.is_target_caster(target) && !target.mouth && get_location_accessible(target, BODY_ZONE_PRECISE_MOUTH))
		var/obj/item/natural/cloth/rag = new(get_turf(target))
		if(target.equip_to_slot_if_possible(rag, SLOT_MOUTH, TRUE, TRUE))
			ataman_ai_log(pawn, "CUSTODY: gagged [target] with a rag")
			target.visible_message(span_warning("[pawn] stuffs a rag into [target]'s mouth!"))
		else
			qdel(rag)

	if(!target.legcuffed && !(target.cmode && (target.mobility_flags & MOBILITY_STAND)))
		var/binding_type = ataman_binding_type(squad)
		var/obj/item/rope/binding = new binding_type(pawn)
		if(pawn.put_in_hands(binding))
			ataman_ai_log(pawn, "CUSTODY: tying [target]'s legs as well")
			binding.try_cuff_legs(target, pawn)
			if(QDELETED(pawn) || QDELETED(target) || QDELETED(controller) || controller.pawn != pawn)
				return
			if(!QDELETED(binding) && binding.loc == pawn)
				qdel(binding)
		else
			qdel(binding)

	ataman_patch_wounds(pawn, target)

	if(pawn.pulling != target)
		if(!ataman_free_hands_for_grabbing(controller))
			finish_action(controller, FALSE, target_key)
			return
		pawn.zone_selected = BODY_ZONE_CHEST
		if(pawn.start_pulling(target, GRAB_PASSIVE, item_override = BODY_ZONE_CHEST))
			ataman_ai_log(pawn, "CUSTODY: holding [target] until the ataman collects them")
	else if(target.mobility_flags & MOBILITY_STAND)
		var/obj/item/grabbing/torso_grab = ataman_get_grab_on(pawn, target, BODY_ZONE_CHEST)
		if(torso_grab && ataman_make_grab_active(pawn, torso_grab))
			pawn.update_grab_intents()
			pawn.update_a_intents()
			for(var/datum/intent/candidate as anything in pawn.possible_a_intents)
				if(istype(candidate, /datum/intent/grab/shove))
					pawn.a_intent = candidate
					pawn.used_intent = candidate
					controller.ai_interact(target, TRUE, TRUE)
					break
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/ataman_restrain
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/ataman_restrain/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/ataman_restrain/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/carbon/target = controller.blackboard[target_key]
	if(!istype(pawn) || !istype(target) || QDELETED(target) || ataman_target_is_secured(target))
		finish_action(controller, FALSE, target_key)
		return
	if(!pawn.Adjacent(target) || (target.stat == CONSCIOUS && (target.mobility_flags & MOBILITY_STAND)))
		finish_action(controller, FALSE, target_key)
		return
	if(!ataman_free_hands_for_grabbing(controller))
		finish_action(controller, FALSE, target_key)
		return

	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	var/binding_type = ataman_binding_type(squad)
	ataman_ai_log(pawn, "RESTRAIN: attempting to bind [target]'s [target.handcuffed ? "legs" : "arms"] with [binding_type == /obj/item/rope/chain ? "chain" : "rope"]")
	var/obj/item/rope/binding = new binding_type(pawn)
	if(!pawn.put_in_hands(binding))
		qdel(binding)
		finish_action(controller, FALSE, target_key)
		return
	if(!target.handcuffed)
		binding.try_cuff_arms(target, pawn)
	else if(!target.legcuffed)
		binding.try_cuff_legs(target, pawn)
	if(QDELETED(pawn) || QDELETED(target) || QDELETED(controller) || controller.pawn != pawn)
		return
	if(!QDELETED(binding) && binding.loc == pawn)
		qdel(binding)
	ataman_ai_log(pawn, "RESTRAIN: result on [target] - handcuffed=[target.handcuffed ? "yes" : "no"] legcuffed=[target.legcuffed ? "yes" : "no"]")
	finish_action(controller, target.handcuffed, target_key)

/datum/ai_planning_subtree/ataman_squad_tactics/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/npc/ataman_bandit/pawn = controller.pawn
	if(!istype(pawn))
		return
	var/datum/ataman_squad/squad = controller.blackboard[BB_ATAMAN_SQUAD]
	if(!squad)
		return
	ataman_recover_target(controller, pawn)
	var/mob/living/carbon/target = controller.blackboard[BB_ATAMAN_TARGET]
	if(!istype(target) || target.stat == DEAD || ataman_target_is_secured(target))
		return
	squad.refresh_aim_intel(target)
	if(!pawn.Adjacent(target))
		return

	var/role = controller.blackboard[BB_ATAMAN_ROLE]
	if(role != ATAMAN_ROLE_GRABBER && ishuman(target) && target.stat == CONSCIOUS)
		var/capture_zone = ataman_pick_capture_zone(pawn, target)
		if(capture_zone)
			controller.set_blackboard_key(BB_HUMAN_NPC_WEAKPOINT, list(capture_zone, world.time + 3 SECONDS, target))

	if(world.time < (controller.blackboard[BB_ATAMAN_TACTICS_COOLDOWN] || 0))
		return

	if(squad.target_channeling_escape_spell())
		if(ataman_try_feint(controller, pawn, target, squad, TRUE))
			controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(role == ATAMAN_ROLE_ENFORCER && pawn.pulling != target && (pawn.mobility_flags & MOBILITY_STAND) && !pawn.IsOffBalanced() && pawn.get_num_legs() >= 2 && (target.mobility_flags & MOBILITY_STAND))
		var/held = length(target.grabbedby) >= 1
		var/walled_kick = held && ataman_target_is_walled(pawn, target)
		if(walled_kick || target.IsOffBalanced() || (held && ataman_target_under_debuff(target)))
			ataman_ai_log(pawn, "TACTICS: kicking [target] ([walled_kick ? "held and walled" : target.IsOffBalanced() ? "off balance" : "held and debuffed"])")
			controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
			controller.queue_behavior(/datum/ai_behavior/npc_kick_attack/ataman_low, BB_ATAMAN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING

	if(role == ATAMAN_ROLE_BINDER && squad.is_target_caster(target) && ataman_try_mouth_grab(controller, pawn, target, squad))
		controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(squad.target_channeling_spell())
		if(!pawn.has_status_effect(/datum/status_effect/buff/clash) && squad.claim_guard())
			ataman_ai_log(pawn, "TACTICS: [target] is casting - guarding")
			controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
			pawn.try_guard()
		return SUBTREE_RETURN_FINISH_PLANNING

	if(ataman_target_under_debuff(target))
		return

	if(ataman_try_bait(controller, pawn, target, squad))
		controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(ataman_try_feint(controller, pawn, target, squad))
		controller.set_blackboard_key(BB_ATAMAN_TACTICS_COOLDOWN, world.time + 1 SECONDS)
		return SUBTREE_RETURN_FINISH_PLANNING

	return
