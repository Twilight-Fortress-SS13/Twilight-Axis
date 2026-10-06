/datum/ai_controller/human_npc/melee/summoned_skeleton // TA EDIT START
	max_target_distance = 12
	idle_requires_client = TRUE // TA EDIT
	planning_subtrees = list(
		/datum/ai_planning_subtree/summoned_skeleton_find_target,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/being_a_minion,
	) // TA EDIT END

/mob/living/carbon/human/species/skeleton/npc/summon //Unique skilled NPC summons exclusive to necromancers, these guys are a menace to fight.
	npc_archetype = /datum/npc_archetype/skeleton/summon
	ai_controller = /datum/ai_controller/human_npc/melee/summoned_skeleton // TA EDIT
	pet_passive = FALSE // TA EDIT
	var/datum/weakref/summoner_ai_ref // TA EDIT

/mob/living/carbon/human/species/skeleton/npc/summon/proc/set_summoner(mob/living/master) // TA EDIT START
	if(QDELETED(master))
		return
	summoner_ai_ref = WEAKREF(master)
	setup_summoner(master) // TA EDIT END

/mob/living/carbon/human/species/skeleton/npc/summon/after_creation()
	. = ..()
	var/mob/living/master = summoner_ai_ref?.resolve() // TA EDIT START
	if(master)
		setup_summoner(master) // TA EDIT END
	energy = max_energy //Always combat-ready
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/skeleton/npc/summon/proc/setup_summoner(mob/living/master) // TA EDIT START
	if(QDELETED(master) || !ai_controller)
		return
	if(master.mind?.current)
		master = master.mind.current
	summoner = master.real_name
	faction = list(FACTION_CABAL, "[master.real_name]_faction")
	var/datum/antagonist/lich/lich_antag = master.mind?.has_antag_datum(/datum/antagonist/lich)
	if(lich_antag && master.real_name)
		faction += FACTION_UNDEAD
	ADD_TRAIT(src, TRAIT_CONJURED_SUMMON, TRAIT_GENERIC)
	pet_passive = FALSE
	ai_controller.CancelActions()
	ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
	ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
	ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
	ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = list()
	ai_controller.nudge_target_scan()
	ai_controller.reset_ai_status() // TA EDIT END
