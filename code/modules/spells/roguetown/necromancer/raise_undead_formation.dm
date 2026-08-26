/datum/ai_planning_subtree/summoned_skeleton_find_target // TA EDIT START
/datum/ai_planning_subtree/summoned_skeleton_find_target/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/pawn = controller.pawn
	if(!istype(pawn))
		return

	var/datum/targetting_datum/targetting_datum = controller.blackboard[BB_TARGETTING_DATUM]
	if(!targetting_datum)
		return

	var/aggro_range = controller.blackboard[BB_AGGRO_RANGE] || 9 // TA EDIT
	var/mob/living/current_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	var/current_target_valid = isliving(current_target) && !QDELETED(current_target) && current_target.stat != DEAD && get_dist_3d(pawn, current_target) <= aggro_range && targetting_datum.can_attack(pawn, current_target) // TA EDIT
	if(!current_target_valid && current_target) // TA EDIT
		controller.CancelActions()
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
		current_target = null

	var/mob/living/commanded_target = controller.blackboard[BB_CURRENT_PET_TARGET]
	if(isliving(commanded_target) && !QDELETED(commanded_target) && commanded_target.stat != DEAD && targetting_datum.can_attack(pawn, commanded_target))
		if(current_target != commanded_target)
			controller.CancelActions()
			controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, commanded_target)
			controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, commanded_target)
			pawn.cmode = TRUE
		return
	if(commanded_target)
		controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)

	if(pawn.pet_passive)
		return

	var/next_scan = controller.blackboard["summoned_skeleton_next_target_scan"] || 0
	if(world.time < next_scan)
		return
	controller.set_blackboard_key("summoned_skeleton_next_target_scan", world.time + 0.5 SECONDS)

	var/list/visible_targets = view(aggro_range, pawn) // TA EDIT
	if(current_target && (current_target in visible_targets)) // TA EDIT
		return
	if(current_target) // TA EDIT
		controller.CancelActions()
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)

	var/mob/living/chosen_target
	var/best_distance = aggro_range + 1
	for(var/mob/living/potential_target in visible_targets) // TA EDIT
		if(potential_target == pawn || QDELETED(potential_target) || potential_target.stat == DEAD)
			continue
		if(!targetting_datum.can_attack(pawn, potential_target))
			continue
		if(potential_target.rogue_sneaking && !pawn.npc_detect_sneak(potential_target, 0))
			continue
		var/target_distance = get_dist(pawn, potential_target)
		if(target_distance >= best_distance)
			continue
		chosen_target = potential_target
		best_distance = target_distance

	if(!chosen_target)
		return

	controller.CancelActions()
	controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, chosen_target)
	controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, chosen_target)
	pawn.cmode = TRUE // TA EDIT END

/datum/action/cooldown/spell/raise_undead_formation
	name = "Raise Undead Formation"
	desc = "Invoke forbidden magicka to summon a cohort of mindless, shambling skeletons.\nMindless skeletons can be given orders to guard, patrol, and attack by their summoner.\nThese skeletons are weaker than their more complex-jointed counterparts, but are harder to incapacitate."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton_formation"

	spell_color = GLOW_COLOR_ZIZO
	cast_range = 7
	sound = 'sound/magic/magnet.ogg'
	primary_resource_cost = 40
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 3 SECONDS //Quick for combat, useless outside of it mostly.
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 25 SECONDS
	zizo_spell = TRUE
	invocation_type = INVOCATION_SHOUT
	invocations = list("Evoca skeletos!")
	var/miracle = FALSE
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	var/spawn_lifespan

/datum/action/cooldown/spell/raise_undead_formation/cast(atom/cast_on)
	. = ..()

	if(!owner)
		return FALSE

	if(istype(get_area(owner), /area/rogue/indoors/ravoxarena))
		to_chat(owner, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		reset_spell_cooldown()
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T))
		to_chat(owner, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	for(var/i = 1 to to_spawn)
		var/turf/spawn_turf = T

		if(i > 1)
			if(owner.dir == NORTH || owner.dir == SOUTH)
				spawn_turf = get_step(T, prob(50) ? EAST : WEST)
			else
				spawn_turf = get_step(T, prob(50) ? NORTH : SOUTH)

		if(!isopenturf(spawn_turf) || spawn_turf.is_blocked_turf())
			continue

		new /obj/effect/temp_visual/bluespace_fissure(spawn_turf)

		var/skeleton_roll = rand(1,100)
		var/skeleton_type

		switch(skeleton_roll)
			if(1 to 20)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(21 to 30)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/spear
			if(31 to 60)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard
			if(61 to 70)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/axe
			if(71 to 100)
				skeleton_type = /mob/living/simple_animal/hostile/rogue/skeleton/guard

		var/mob/living/simple_animal/hostile/rogue/skeleton/S = new skeleton_type(spawn_turf, owner, cabal_affine)

		if(!S)
			continue

		var/mob/living/faction_owner = owner // TA EDIT START
		if(owner.mind?.current)
			faction_owner = owner.mind.current
		var/summoner_faction = "[faction_owner.real_name]_faction"
		S.faction = list(summoner_faction)
		if(cabal_affine)
			S.faction += FACTION_CABAL
		if(faction_owner.mind?.has_antag_datum(/datum/antagonist/lich))
			S.faction += FACTION_UNDEAD // TA EDIT END

		if(miracle)
			var/holyLV = owner.get_skill_level(/datum/skill/magic/holy)
			var/bonus = max(0, holyLV - 1) * 2

			S.STASTR += bonus
			S.STASPD += round(bonus / 2)
			S.maxHealth += bonus * 50
			S.health = S.maxHealth

		var/aggro_range = 8
		var/mob/living/initial_target // TA EDIT
		var/datum/targetting_datum/targetting_datum = S.ai_controller?.blackboard[BB_TARGETTING_DATUM] // TA EDIT

		if(S.ai_controller) // TA EDIT START
			S.ai_controller.idle_requires_client = TRUE // TA EDIT
			S.ai_controller.CancelActions()
			if(istype(S, /mob/living/simple_animal/hostile/rogue/skeleton/spear))
				S.ai_controller.replace_planning_subtrees(list(
					/datum/ai_planning_subtree/summoned_skeleton_find_target,
					/datum/ai_planning_subtree/attack_obstacle_in_path,
					/datum/ai_planning_subtree/spacing/melee,
					/datum/ai_planning_subtree/basic_melee_attack_subtree/spear,
					/datum/ai_planning_subtree/being_a_minion,
				))
			else
				S.ai_controller.replace_planning_subtrees(list(
					/datum/ai_planning_subtree/summoned_skeleton_find_target,
					/datum/ai_planning_subtree/attack_obstacle_in_path,
					/datum/ai_planning_subtree/basic_melee_attack_subtree,
					/datum/ai_planning_subtree/being_a_minion,
				))
			S.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET) // TA EDIT
			S.pet_passive = FALSE // TA EDIT END

		for(var/mob/living/M in view(aggro_range, S))
			if(M == S)
				continue
			if(M.stat == DEAD)
				continue

			if(!initial_target && targetting_datum && targetting_datum.can_attack(S, M)) // TA EDIT
				initial_target = M // TA EDIT

			if(M.mind)
				continue
			if(!M.ai_controller)
				continue
			if(M.faction_check_mob(S))
				continue
			if(M.faction_check_mob(owner))
				continue

			M.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, S)
			M.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, S)

			var/datum/component/ai_aggro_system/aggro = M.GetComponent(/datum/component/ai_aggro_system)

			if(aggro)
				aggro.add_threat_to_mob(S, 1000)
				aggro.add_threat_to_mob(owner, -1000)

		if(S.ai_controller) // TA EDIT START
			if(initial_target)
				S.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, initial_target)
				S.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, initial_target)
			S.ai_controller.nudge_target_scan()
			S.ai_controller.reset_ai_status() // TA EDIT END

		apply_mob_lifespan(S, owner, spawn_lifespan)

	return TRUE

/datum/action/cooldown/spell/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	cooldown_time = 40 SECONDS
	to_spawn = 3
