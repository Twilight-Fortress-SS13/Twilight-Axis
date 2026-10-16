/datum/intent/simple/elementalt2_unarmed/lesser_dryad

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser
	name = "lesser dryad"
	gender = FEMALE
	health = 450
	maxHealth = 450
	melee_damage_lower = 12
	melee_damage_upper = 18
	aggressive = FALSE
	ai_controller = null
	inherent_spells = list()
	base_intents = list(/datum/intent/simple/elementalt2_unarmed/lesser_dryad)
	d_intent = INTENT_PARRY
	move_to_delay = 7 // Reasonable companion speed
	environment_smash = ENVIRONMENT_SMASH_NONE // Does not destroy vines or structures in its path
	robust_searching = TRUE // Use threshold-based stat checking (needed for stat_attack to work)
	stat_attack = SOFT_CRIT // Stops pursuing when target becomes unconscious or paralyzed
	retreat_health = 0 // Never flee at low health
	lose_patience_timeout = 0 // Never give up chasing a target
	var/special_cd = 0
	var/conjurer_ckey = null
	var/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/summoner_spell
	var/mob/living/follow_target = null
	var/turf/guard_turf = null
	var/mob/living/owner_mob = null
	var/ignore_owner_defense_until = 0
	var/bark_integrity = 250
	var/bark_max_integrity = 250
	var/bark_broken = FALSE
	var/bark_regen_timer = null
	var/vine_regen_timer = null
	var/frenzy_timer = null
	var/frenzy_boost = 0
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
		if(isliving(target))
			var/mob/living/L = target
			if(is_dendor_dryad_ally(L))
				LoseTarget()
		toggle_ai(AI_ON)
	else
		faction = default_dryad_factions ? default_dryad_factions.Copy() : list(FACTION_FAE)
		clear_enemies()
		LoseTarget()
		if(!QDELETED(owner_mob))
			follow_target = owner_mob
			guard_turf = null
		toggle_ai(AI_IDLE)
	notify_faction_change()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/CanAttack(atom/the_target)
	if(!isliving(the_target))
		return FALSE
	var/mob/living/L = the_target
	if(is_dendor_dryad_ally(L))
		return FALSE
	if(!dendor_dryad_aggressive_mode && !(L in enemies))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/contains_vines(turf/T)
	for(var/obj/structure/vine/V in T)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Move(newloc)
	. = ..()
	var/base_delay = (isturf(newloc) && contains_vines(newloc)) ? 5 : 7
	switch(frenzy_boost)
		if(2)  // Bloomstone frenzy: 50% faster
			move_to_delay = max(2, round(base_delay * 0.5))
		if(1)  // Normal frenzy: 25% faster
			move_to_delay = max(2, round(base_delay * 0.75))
		else
			move_to_delay = base_delay

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/handle_automated_movement()
	if(target)
		return ..()
	if(!QDELETED(owner_mob) && world.time >= ignore_owner_defense_until)
		var/mob/living/attacker = owner_mob.lastattacker_weakref?.resolve()
		if(isliving(attacker) && attacker.stat != DEAD && !is_dendor_dryad_ally(attacker))
			add_enemy(attacker)
			GiveTarget(attacker)
			toggle_ai(AI_ON)
			return
	if(!QDELETED(follow_target))
		if(get_dist(src, follow_target) > 2)
			walk_towards(src, follow_target, move_to_delay)
		else
			walk(src, 0)
		return
	if(guard_turf && !QDELETED(guard_turf))
		if(get_dist(src, guard_turf) > 0)
			walk_towards(src, guard_turf, move_to_delay)
		else
			walk(src, 0)
		return
	walk(src, 0)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/Retaliate()
	toggle_ai(AI_ON)
	var/mob/living/attacker = lastattacker_weakref?.resolve()
	if(isliving(attacker) && !is_dendor_dryad_ally(attacker) && attacker.stat != DEAD)
		add_enemy(attacker)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/AttackingTarget()
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
	return ..()

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

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/MeleeAction(patience = TRUE)
	var/on_vine = isturf(loc) && contains_vines(loc)
	rapid_melee = on_vine ? 2 : 1
	if(on_vine)
		melee_damage_lower = initial(melee_damage_lower) * 1.5
		melee_damage_upper = initial(melee_damage_upper) * 1.5
	. = ..()
	if(on_vine)
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)

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
	if(bloomstone_boost)
		melee_cooldown = round(initial(melee_cooldown) * 0.5)
		frenzy_boost = 2
		visible_message(span_boldwarning("[src] blazes with the Treefather's fury — its movements become a blur!"))
	else
		melee_cooldown = round(initial(melee_cooldown) * 0.75)
		frenzy_boost = 1
		visible_message(span_warning("[src] surges with Dendor's blessing, striking faster!"))
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("dryad_frenzy_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	frenzy_timer = addtimer(CALLBACK(src, PROC_REF(end_frenzy)), 50, TIMER_STOPPABLE)  // 5 seconds

/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/proc/end_frenzy()
	frenzy_timer = null
	melee_cooldown = initial(melee_cooldown)
	frenzy_boost = 0
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
