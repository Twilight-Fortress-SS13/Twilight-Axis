/datum/intent/simple/elementalt2_unarmed/lesser_dryad

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser
	name = "lesser dryad"
	gender = FEMALE
	health = 450
	maxHealth = 450
	melee_damage_lower = 12
	melee_damage_upper = 18
	aggressive = FALSE
	ai_controller = /datum/ai_controller/ta_dendor_lesser_dryad
	inherent_spells = list()
	base_intents = list(/datum/intent/simple/elementalt2_unarmed/lesser_dryad)
	d_intent = INTENT_PARRY
	environment_smash = ENVIRONMENT_SMASH_NONE // Does not destroy vines or structures in its path
	var/special_cd = 0
	var/conjurer_ckey = null
	var/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/summoner_spell
	var/mob/living/follow_target = null
	var/turf/guard_turf = null
	var/turf/guard_before_surge
	var/mob/living/follow_before_surge
	var/mob/living/owner_mob = null
	var/ignore_owner_defense_until = 0
	var/bark_integrity = 250
	var/bark_max_integrity = 250
	var/bark_broken = FALSE
	var/bark_regen_timer = null
	var/vine_regen_timer = null
	var/frenzy_timer = null
	var/frenzy_boost = 0
	var/frenzy_melee_credit = 0
	var/last_attack_dtype = "blunt"
	var/dendor_dryad_aggressive_mode = FALSE
	var/list/default_dryad_factions

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Initialize(mapload, mob/living/carbon/human/owner)
	. = ..()
	faction |= "neutral"
	if(owner)
		owner_mob = owner
		conjurer_ckey = owner.ckey
		var/owner_name = owner.mind?.current?.real_name || owner.real_name
		var/faction_tag = "[owner_name]_faction"
		owner.faction |= faction_tag
		faction |= faction_tag
	default_dryad_factions = faction.Copy()
	AddComponent(/datum/component/ai_aggro_system)
	ai_controller?.set_ai_status(AI_STATUS_ON)
	vine_regen_timer = addtimer(CALLBACK(src, PROC_REF(vine_heal_tick)), 100, TIMER_STOPPABLE)


/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/is_dendor_dryad_ally(mob/living/other)
	if(!other || other == src || other == owner_mob)
		return TRUE
	if(!QDELETED(owner_mob))
		if(owner_mob.faction_check_mob(other) || shares_fellowship(owner_mob, other))
			return TRUE
	return faction_check_mob(other)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/apply_dendor_dryad_aggression(enabled)
	dendor_dryad_aggressive_mode = !!enabled
	aggressive = dendor_dryad_aggressive_mode
	if(dendor_dryad_aggressive_mode)
		if(!QDELETED(owner_mob))
			var/owner_name = owner_mob.mind?.current?.real_name || owner_mob.real_name
			var/owner_tag = "[owner_name]_faction"
			faction = list(owner_tag)
		var/mob/living/current_target = ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(isliving(current_target) && is_dendor_dryad_ally(current_target))
			ai_controller.clear_aggro()
		ai_controller?.nudge_target_scan()
	else
		faction = default_dryad_factions ? default_dryad_factions.Copy() : list(FACTION_FAE)
		ai_controller?.clear_aggro()
		if(!QDELETED(owner_mob))
			follow_target = owner_mob
			guard_turf = null
		ai_controller?.set_ai_status(AI_STATUS_ON)
	ai_controller?.nudge_target_scan()

/datum/targetting_datum/basic/ta_dendor_dryad/can_attack(mob/living/living_mob, atom/target, vision_range)
	if(!..())
		return FALSE
	if(!istype(living_mob, /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser) || !isliving(target))
		return FALSE
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad = living_mob
	var/mob/living/living_target = target
	if(dryad.is_dendor_dryad_ally(living_target))
		return FALSE
	if(!dryad.dendor_dryad_aggressive_mode)
		var/list/retaliating_against = dryad.ai_controller?.blackboard[BB_BASIC_MOB_RETALIATE_LIST]
		return living_target in retaliating_against
	return TRUE

/datum/ai_controller/ta_dendor_lesser_dryad
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/ta_dendor_dryad())
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/ta_dendor_dryad_commands,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/simple_self_recovery,
	)

/datum/ai_planning_subtree/ta_dendor_dryad_commands/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad = controller.pawn
	if(QDELETED(dryad) || dryad.stat != CONSCIOUS)
		return
	if(!QDELETED(dryad.owner_mob) && world.time >= dryad.ignore_owner_defense_until)
		var/mob/living/attacker = dryad.owner_mob.lastattacker_weakref?.resolve()
		if(isliving(attacker) && attacker.stat != DEAD && !dryad.is_dendor_dryad_ally(attacker))
			controller.force_aggro(attacker)
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	if(dryad.guard_turf && !QDELETED(dryad.guard_turf))
		if(get_dist(dryad, dryad.guard_turf) > 0)
			controller.set_blackboard_key(BB_TRAVEL_DESTINATION, dryad.guard_turf)
			controller.queue_behavior(/datum/ai_behavior/travel_towards/stop_on_arrival, BB_TRAVEL_DESTINATION)
		else
			controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
		return SUBTREE_RETURN_FINISH_PLANNING
	if(!QDELETED(dryad.follow_target))
		if(get_dist(dryad, dryad.follow_target) > 2)
			controller.set_blackboard_key(BB_FOLLOW_TARGET, dryad.follow_target)
			controller.queue_behavior(/datum/ai_behavior/follow_friend, BB_FOLLOW_TARGET)
		else
			controller.clear_blackboard_key(BB_FOLLOW_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/contains_vines(turf/T)
	for(var/obj/structure/vine/V in T)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Move(newloc)
	. = ..()
	var/base_delay = (isturf(newloc) && contains_vines(newloc)) ? 5 : 7
	switch(frenzy_boost)
		if(2)  // Bloomstone frenzy: 50% faster
			move_base_delay = max(2, round(base_delay * 0.5))
		if(1)  // Normal frenzy: 25% faster
			move_base_delay = max(2, round(base_delay * 0.75))
		else
			move_base_delay = base_delay

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/AttackingTarget()
	target = ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(isliving(target))
		var/mob/living/L = target
		var/skull_broken = FALSE
		for(var/datum/wound/fracture/head/W in L.get_wounds())
			skull_broken = TRUE
			break
		if(!skull_broken)
			zone_selected = BODY_ZONE_HEAD
		else
			var/legs_broken = FALSE
			if(iscarbon(target))
				var/mob/living/carbon/C = target
				for(var/legzone in list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					var/obj/item/bodypart/BP = C.get_bodypart(legzone)
					if(BP)
						for(var/datum/wound/fracture/bone in BP.wounds)
							legs_broken = TRUE
							break
					if(legs_broken)
						break
			zone_selected = legs_broken ? pick(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM) : pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/on_vine = isturf(loc) && contains_vines(loc)
	var/strike_count = on_vine ? 2 : 1
	if(frenzy_boost == 2)
		strike_count *= 2
	else if(frenzy_boost == 1)
		frenzy_melee_credit += strike_count
		var/bonus_attacks = round(frenzy_melee_credit / 3)
		strike_count += bonus_attacks
		frenzy_melee_credit -= bonus_attacks * 3
	var/original_damage_lower = melee_damage_lower
	var/original_damage_upper = melee_damage_upper
	if(on_vine)
		melee_damage_lower *= 1.5
		melee_damage_upper *= 1.5
	for(var/i in 1 to strike_count)
		if(QDELETED(src) || QDELETED(target) || !Adjacent(target))
			break
		. = ..()
	melee_damage_lower = original_damage_lower
	melee_damage_upper = original_damage_upper

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/dryad_surge(turf/surge_turf)
	if(world.time < special_cd + 40 SECONDS)
		return FALSE
	special_cd = world.time
	visible_message(span_boldwarning("[src] raises its arms — thorns and vines heed the call!"))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 60, TRUE)
	var/turf/T = surge_turf || get_turf(src)
	if(!T)
		return FALSE
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	for(var/turf/V in RANGE_TURFS(2, T))
		if(!isclosedturf(V) && !locate(/obj/structure/vine) in V)
			new /obj/structure/vine(V)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/death(gibbed)
	visible_message(span_boldwarning("[src] dissolves into greenish light..."))
	playsound(get_turf(src), 'sound/items/dig_shovel.ogg', 70, TRUE)
	if(summoner_spell)
		summoner_spell.on_dryad_deleted(src)
	if(bark_regen_timer)
		deltimer(bark_regen_timer)
		bark_regen_timer = null
	if(vine_regen_timer)
		deltimer(vine_regen_timer)
		vine_regen_timer = null
	if(frenzy_timer)
		deltimer(frenzy_timer)
		frenzy_timer = null
	spill_embedded_objects()
	qdel(src)


/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/examine(mob/user)
	. = ..()
	. += span_info("A spirit of a sanctified tree, bound to serve by the rites of Dendor. Its bark-skin is etched with glowing sigils, and vines curl idly about its limbs. Though lesser than the great dryads of old, the fury of the forest still rides within.")

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/attacked_by(obj/item/I, mob/living/user)
	if(user?.used_intent)
		last_attack_dtype = user.used_intent.item_d_type || "blunt"
	. = ..()
	last_attack_dtype = "blunt"
	if(!QDELETED(src))
		bark_delay_regen()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	if(!bark_broken && bark_integrity > 0 && amount > 0 && !forced)
		var/reduction
		switch(last_attack_dtype)
			if("slash")
				reduction = 0.15   // Very weak vs cut — bark splinters against blades
			if("stab")
				reduction = 0.40   // Strong vs stab — bark resists puncture
			else
				reduction = 0.30   // Decent vs blunt — absorbs some impact
		var/absorbed = amount * reduction
		bark_integrity = max(0, bark_integrity - amount)  // Raw incoming damage erodes bark
		amount = max(0, amount - absorbed)
		if(bark_integrity <= 0 && !bark_broken)
			bark_broken = TRUE
			visible_message(span_boldwarning("[src]'s protective bark splinters and breaks!"))
	return ..(amount, updating_health, forced)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/bark_delay_regen()
	if(bark_regen_timer)
		deltimer(bark_regen_timer)
		bark_regen_timer = null
	bark_regen_timer = addtimer(CALLBACK(src, PROC_REF(bark_regen_tick)), 100, TIMER_STOPPABLE)  // 10 second combat gap

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/bark_regen_tick()
	bark_regen_timer = null
	if(QDELETED(src) || stat == DEAD)
		return
	var/regen_pct = (isturf(loc) && contains_vines(loc)) ? 0.50 : 0.25
	bark_integrity = min(bark_max_integrity, bark_integrity + round(bark_max_integrity * regen_pct))
	if(bark_integrity >= bark_max_integrity)
		bark_broken = FALSE
		return
	bark_regen_timer = addtimer(CALLBACK(src, PROC_REF(bark_regen_tick)), 100, TIMER_STOPPABLE)  // Continue every 10s

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/vine_heal_tick()
	vine_regen_timer = null
	if(QDELETED(src) || stat == DEAD)
		return
	if(isturf(loc) && contains_vines(loc) && health < maxHealth)
		if(!has_status_effect(/datum/status_effect/buff/healing))
			apply_status_effect(/datum/status_effect/buff/healing, 1.5)
		visible_message(span_notice("[src] mends itself in the vines."))
	vine_regen_timer = addtimer(CALLBACK(src, PROC_REF(vine_heal_tick)), 100, TIMER_STOPPABLE)  // Repeat every 10 s

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/apply_blessed_frenzy(bloomstone_boost = FALSE)
	if(frenzy_timer)
		deltimer(frenzy_timer)
		frenzy_timer = null
	frenzy_melee_credit = 0
	if(bloomstone_boost)
		frenzy_boost = 2
		visible_message(span_boldwarning("[src] blazes with the Treefather's fury — its movements become a blur!"))
	else
		frenzy_boost = 1
		visible_message(span_warning("[src] surges with Dendor's blessing, striking faster!"))
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("dryad_frenzy_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	frenzy_timer = addtimer(CALLBACK(src, PROC_REF(end_frenzy)), 50, TIMER_STOPPABLE)  // 5 seconds

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/end_frenzy()
	frenzy_timer = null
	frenzy_boost = 0
	frenzy_melee_credit = 0
	set_light(0)
	remove_filter("dryad_frenzy_outline")

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/attempt_parry(datum/intent/intenty, mob/living/user)
	if(!can_see_cone(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, last_parry))
		return FALSE
	if(intenty && !intenty.canparry)
		return FALSE
	COOLDOWN_START(src, last_parry, setparrytime)
	var/prob2defend = get_skill_level(/datum/skill/combat/unarmed) * 12
	var/attacker_skill = intenty?.masteritem ? user.get_skill_level(intenty.masteritem.associated_skill) \
											: user.get_skill_level(/datum/skill/combat/unarmed)
	prob2defend -= (attacker_skill * 7)
	prob2defend = clamp(prob2defend, 5, 75)
	if(!prob(prob2defend))
		return FALSE
	return do_unarmed_parry(0, user)
