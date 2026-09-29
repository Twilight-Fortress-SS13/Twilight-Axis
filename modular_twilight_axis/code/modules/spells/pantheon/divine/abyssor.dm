/mob/living/carbon/human/var/tmp/abyssor_mossback_aggressive_mode = FALSE

/mob/living/carbon/human/proc/toggle_abyssor_mossback_mode()
	set name = "Toggle Mossback Aggression"
	set category = "RoleUnique.Cleric"
	abyssor_mossback_aggressive_mode = !abyssor_mossback_aggressive_mode
	var/count = 0
	for(var/mob/living/minion as anything in GLOB.mob_list)
		if(!istype(minion, /mob/living/simple_animal/hostile/retaliate/rogue/mossback/summoned_abyssor))
			continue
		if(!abyssor_mossback_belongs_to_user(minion))
			continue
		apply_abyssor_mossback_mode(minion)
		count++
	var/updated_text = count ? " Updated [count] active mossback[count == 1 ? "" : "s"]." : ""
	to_chat(src, span_notice("Mossback mode: [abyssor_mossback_aggressive_mode ? "Aggressive - attack everyone except Mark of the Deep allies" : "Normal"].[updated_text]"))
	return TRUE

/mob/living/carbon/human/proc/abyssor_mossback_belongs_to_user(mob/living/mossback)
	if(!mossback || !mind?.current)
		return FALSE
	var/faction_tag = "[mind.current.real_name]_faction"
	return faction_tag in mossback.faction

/mob/living/carbon/human/proc/apply_abyssor_mossback_mode(mob/living/mossback)
	if(!mossback || !mind?.current)
		return FALSE
	var/faction_tag = "[mind.current.real_name]_faction"
	if(abyssor_mossback_aggressive_mode)
		mossback.faction = list(faction_tag)
		mossback.pet_passive = FALSE
	else
		mossback.faction = list(FACTION_NEUTRAL, faction_tag)
		mossback.pet_passive = TRUE
	mossback.notify_faction_change()
	if(mossback.ai_controller)
		if(!mossback.ai_controller.blackboard[BB_CURRENT_PET_TARGET])
			mossback.ai_controller.CancelActions()
			mossback.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			mossback.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
			mossback.ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
			mossback.ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = list()
		mossback.ai_controller.nudge_target_scan()
		mossback.ai_controller.wake_for_combat()
	return TRUE

/datum/action/cooldown/spell/gravemark/abyssor
	name = "Mark of the Deep"
	desc = "Marks a chosen target as an ally claimed by Abyssor's depths. Your summoned Mossback will not target or attack marked allies while aggressive. Casting Mark of the Deep on them again removes the mark."
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/abyssorspells.dmi'
	button_icon_state = "mark_of_the_deep"

/datum/action/cooldown/spell/minion_order/abyssor
	name = "Abyssal Command"
	desc = "Issues commands to your summoned Mossback within 12 tiles.<br>\
	<br>\
	Cast on a turf: Order your Mossback to move there.<br>\
	Cast on yourself: Recall your Mossback and set it to retaliate-only.<br>\
	Cast on an enemy: Order your Mossback to attack that target.<br>\
	Cast on your Mossback: Toggle its stance between retaliate-only and attack-all-strangers."
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/abyssorspells.dmi'
	button_icon_state = "abyssal_command"

/datum/ai_controller/mossback/summoned_abyssor
	max_target_distance = 30
	idle_requires_client = TRUE
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_AGGRO_RANGE = 9,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/summoned_skeleton_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/being_a_minion,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/eat_food,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/mossback/summoned_abyssor
	ai_controller = /datum/ai_controller/mossback/summoned_abyssor
	pet_passive = TRUE
