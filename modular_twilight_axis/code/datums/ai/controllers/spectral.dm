/datum/ai_controller/spectral_maid
	movement_delay = SKELETON_MOVEMENT_SPEED * 1.5

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/archer_base,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/flee_target,
	)
