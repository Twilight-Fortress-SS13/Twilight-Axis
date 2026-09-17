#define BB_TA_LIVESTOCK_COMMAND "BB_ta_livestock_command"
#define BB_TA_LIVESTOCK_AGGRESSIVE "BB_ta_livestock_aggressive"
#define BB_TA_LIVESTOCK_HIDING_TARGET "BB_ta_livestock_hiding_target"

#define TA_LIVESTOCK_STAY "stay"
#define TA_LIVESTOCK_FREE "free"
#define TA_LIVESTOCK_FOLLOW "follow"
#define TA_LIVESTOCK_MOVE "move"
#define TA_LIVESTOCK_ATTACK "attack"

/datum/targetting_datum/basic/not_friends/ta_livestock
	attack_until_past_stat = CONSCIOUS

/datum/ai_behavior/ta_livestock_follow
	required_distance = 1
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/ta_livestock_follow/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/ta_livestock_follow/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	return AI_BEHAVIOR_DELAY

/datum/ai_planning_subtree/ta_livestock_commands

/datum/ai_planning_subtree/ta_livestock_commands/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/simple_animal/pawn = controller.pawn
	if(!istype(pawn) || IS_DEAD_OR_INCAP(pawn))
		return

	var/command = controller.blackboard[BB_TA_LIVESTOCK_COMMAND]
	if(command == TA_LIVESTOCK_STAY)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(command == TA_LIVESTOCK_FOLLOW)
		var/atom/follow_target = controller.blackboard[BB_CURRENT_PET_TARGET]
		if(QDELETED(follow_target))
			controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
			controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			return
		controller.queue_behavior(/datum/ai_behavior/ta_livestock_follow, BB_CURRENT_PET_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(command == TA_LIVESTOCK_MOVE)
		var/atom/move_target = controller.blackboard[BB_CURRENT_PET_TARGET]
		if(QDELETED(move_target))
			controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
			return
		controller.queue_behavior(/datum/ai_behavior/travel_towards/stop_on_arrival, BB_CURRENT_PET_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(command == TA_LIVESTOCK_ATTACK)
		var/atom/attack_target = controller.blackboard[BB_CURRENT_PET_TARGET]
		var/datum/targetting_datum/targetter = controller.blackboard[BB_PET_TARGETING_DATUM]
		if(QDELETED(attack_target) || !targetter?.can_attack(pawn, attack_target))
			controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
			controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			controller.clear_blackboard_key(BB_TA_LIVESTOCK_HIDING_TARGET)
			return
		controller.queue_behavior(/datum/ai_behavior/basic_melee_attack, BB_CURRENT_PET_TARGET, BB_PET_TARGETING_DATUM, BB_TA_LIVESTOCK_HIDING_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(!controller.blackboard[BB_TA_LIVESTOCK_AGGRESSIVE])
		return

	var/datum/targetting_datum/targetter = controller.blackboard[BB_PET_TARGETING_DATUM]
	if(!targetter)
		return
	var/mob/living/current_target = controller.blackboard[BB_CURRENT_PET_TARGET]
	if(QDELETED(current_target) || get_dist(pawn, current_target) > 7 || !targetter.can_attack(pawn, current_target))
		current_target = null
		for(var/mob/living/candidate in oview(7, pawn))
			if(targetter.can_attack(pawn, candidate))
				current_target = candidate
				break
		if(current_target)
			controller.set_blackboard_key(BB_CURRENT_PET_TARGET, current_target)
		else
			controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
	if(!current_target)
		return
	controller.queue_behavior(/datum/ai_behavior/basic_melee_attack, BB_CURRENT_PET_TARGET, BB_PET_TARGETING_DATUM, BB_TA_LIVESTOCK_HIDING_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/component/ta_livestock_commands
	var/datum/weakref/owner_ref
	var/pending_target_command
	var/uses_ai_controller = FALSE
	var/old_ai_command
	var/datum/weakref/old_ai_target_ref
	var/old_ai_aggressive = FALSE

/datum/component/ta_livestock_commands/Initialize(mob/living/new_owner)
	if(!istype(parent, /mob/living/simple_animal))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/simple_animal/animal = parent
	uses_ai_controller = !!animal.ai_controller
	if(uses_ai_controller)
		animal.ai_controller.add_subtree_at(/datum/ai_planning_subtree/ta_livestock_commands, 1)
		if(!animal.ai_controller.blackboard[BB_PET_TARGETING_DATUM])
			animal.ai_controller.set_blackboard_key(BB_PET_TARGETING_DATUM, new /datum/targetting_datum/basic/not_friends/ta_livestock())
	else if(!istype(animal, /mob/living/simple_animal/hostile))
		return COMPONENT_INCOMPATIBLE
	set_owner(new_owner)

/datum/component/ta_livestock_commands/RegisterWithParent()
	RegisterSignal(parent, COMSIG_CLICK_ALT, PROC_REF(on_alt_click))
	if(!uses_ai_controller)
		RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(on_old_ai_life))

/datum/component/ta_livestock_commands/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_CLICK_ALT, COMSIG_LIVING_LIFE))
	clear_owner_signals()

/datum/component/ta_livestock_commands/Destroy()
	clear_owner_signals()
	owner_ref = null
	return ..()

/datum/component/ta_livestock_commands/proc/clear_owner_signals()
	var/mob/living/old_owner = owner_ref?.resolve()
	if(old_owner)
		UnregisterSignal(old_owner, list(COMSIG_MOB_SAY, COMSIG_MOB_CLICKON))
		if(pending_target_command)
			old_owner.update_mouse_pointer()
	pending_target_command = null

/datum/component/ta_livestock_commands/proc/set_owner(mob/living/new_owner)
	var/mob/living/simple_animal/animal = parent
	if(!animal)
		return
	var/mob/living/old_owner = owner_ref?.resolve()
	animal.owner = new_owner
	if(old_owner == new_owner)
		sync_friends()
		return
	clear_owner_signals()
	owner_ref = new_owner ? WEAKREF(new_owner) : null
	if(new_owner)
		RegisterSignal(new_owner, COMSIG_MOB_SAY, PROC_REF(on_owner_say))
		RegisterSignal(new_owner, COMSIG_MOB_CLICKON, PROC_REF(on_owner_click))
	sync_friends(old_owner)

/datum/component/ta_livestock_commands/proc/sync_friends(mob/living/remove_owner)
	var/mob/living/simple_animal/animal = parent
	if(!animal)
		return
	var/mob/living/owner = owner_ref?.resolve()
	if(animal.ai_controller)
		var/list/friend_list = animal.ai_controller.blackboard[BB_FRIENDS_LIST]
		friend_list = islist(friend_list) ? friend_list.Copy() : list()
		if(remove_owner)
			friend_list -= remove_owner
		friend_list |= animal
		if(owner)
			friend_list |= owner
		if(istype(animal, /mob/living/simple_animal/hostile/retaliate/rogue))
			var/mob/living/simple_animal/hostile/retaliate/rogue/rogue_animal = animal
			for(var/mob/living/friend in rogue_animal.friends)
				friend_list |= friend
		animal.ai_controller.set_blackboard_key(BB_FRIENDS_LIST, friend_list)
		return
	if(istype(animal, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_animal = animal
		if(remove_owner)
			hostile_animal.friends -= remove_owner
		if(owner)
			hostile_animal.friends |= owner

/datum/component/ta_livestock_commands/proc/on_alt_click(datum/source, mob/living/clicker)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/animal = parent
	if(!animal || !clicker)
		return
	var/mob/living/owner = owner_ref?.resolve()
	if(!owner && animal.owner)
		set_owner(animal.owner)
		owner = owner_ref?.resolve()
	if(owner)
		if(clicker != owner)
			return
		INVOKE_ASYNC(src, PROC_REF(show_command_menu), clicker)
		return
	if(!can_claim(clicker))
		return
	INVOKE_ASYNC(src, PROC_REF(offer_claim), clicker)

/datum/component/ta_livestock_commands/proc/on_owner_click(mob/living/source, atom/target, params)
	SIGNAL_HANDLER
	if(source != owner_ref?.resolve())
		return
	if(pending_target_command)
		var/command_name = pending_target_command
		cancel_targeting()
		INVOKE_ASYNC(src, PROC_REF(apply_targeted_command), source, command_name, target)
		return COMSIG_MOB_CANCEL_CLICKON
	if(target != parent)
		return
	var/list/modifiers = islist(params) ? params : params2list(params)
	if(!modifiers["alt"] || !modifiers["left"] || modifiers["right"] || modifiers["middle"])
		return
	INVOKE_ASYNC(src, PROC_REF(show_command_menu), source)
	return COMSIG_MOB_CANCEL_CLICKON

/datum/component/ta_livestock_commands/proc/can_claim(mob/living/user)
	var/mob/living/simple_animal/animal = parent
	if(!animal || !user || !ishuman(user))
		return FALSE
	if(animal.owner || !animal.tame || animal.adult_growth)
		return FALSE
	if(user.incapacitated() || IS_DEAD_OR_INCAP(animal))
		return FALSE
	if(get_dist(user, animal) > 1 || !can_see(user, animal))
		return FALSE
	return TRUE

/datum/component/ta_livestock_commands/proc/offer_claim(mob/living/user)
	if(!can_claim(user))
		return
	var/mob/living/simple_animal/animal = parent
	var/answer = alert(user, "Become [animal]'s handler? This will let you issue commands to [animal.p_them()].", "Bond with [animal]", "Yes", "No")
	if(answer != "Yes" || !can_claim(user))
		return
	animal.assign_livestock_owner(user)
	to_chat(user, span_notice("[animal] now recognizes you as [animal.p_their()] handler."))
	show_command_menu(user)

/datum/component/ta_livestock_commands/proc/check_menu(mob/living/user)
	var/mob/living/simple_animal/animal = parent
	if(!user || !animal || user.incapacitated() || IS_DEAD_OR_INCAP(animal))
		return FALSE
	if(owner_ref?.resolve() != user)
		return FALSE
	if(get_dist(user, animal) > 7 || !can_see(user, animal))
		return FALSE
	return TRUE

/datum/component/ta_livestock_commands/proc/show_command_menu(mob/living/user)
	if(!check_menu(user))
		return
	var/mob/living/simple_animal/animal = parent
	var/list/commands = list(
		"Stay" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "halt"),
		"Free" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "free"),
		"Follow" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "follow"),
		"Move" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "move"),
		"Attack" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "attack"),
		"Aggressive" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "aggro"),
		"Calm" = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "calm"),
	)
	if(animal.generate_genetics && !animal.adult_growth && animal.childtype && animal.animal_species && animal.breedchildren > 0)
		commands["Breed"] = image(icon = 'modular_twilight_axis/icons/hud/animal_commands.dmi', icon_state = "breed")
	var/choice = show_radial_menu(user, animal, commands, custom_check = CALLBACK(src, PROC_REF(check_menu), user), tooltips = TRUE)
	if(!choice || !check_menu(user))
		return
	handle_command(user, choice)

/datum/component/ta_livestock_commands/proc/handle_command(mob/living/commander, command_name)
	var/mob/living/simple_animal/animal = parent
	if(!animal || owner_ref?.resolve() != commander)
		return
	cancel_targeting()
	sync_friends()

	if(animal.ai_controller)
		animal.ai_controller.set_ai_status(AI_STATUS_ON)
		animal.ai_controller.CancelActions()
		animal.ai_controller.halt_movement()
	else if(istype(animal, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_animal = animal
		hostile_animal.toggle_ai(AI_ON)

	switch(command_name)
		if("Stay")
			if(animal.ai_controller)
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_COMMAND, TA_LIVESTOCK_STAY)
				animal.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			else
				set_old_ai_command(TA_LIVESTOCK_STAY)
			animal.visible_message(span_notice("[animal] stops and waits for [commander]."))
		if("Free")
			if(animal.ai_controller)
				animal.ai_controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
				animal.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			else
				set_old_ai_command(null)
				old_ai_aggressive = FALSE
				reset_old_ai_hostility()
			animal.visible_message(span_notice("[animal] relaxes and resumes its normal behavior."))
		if("Follow")
			if(animal.ai_controller)
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_COMMAND, TA_LIVESTOCK_FOLLOW)
				animal.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, commander)
			else
				set_old_ai_command(TA_LIVESTOCK_FOLLOW, commander)
			animal.visible_message(span_notice("[animal] moves to follow [commander]."))
		if("Move", "Attack", "Breed")
			begin_targeting(commander, command_name)
		if("Aggressive")
			if(animal.ai_controller)
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_AGGRESSIVE, TRUE)
				animal.ai_controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
				animal.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			else
				set_old_ai_command(null)
				old_ai_aggressive = TRUE
				reset_old_ai_hostility(FALSE)
			animal.visible_message(span_warning("[animal] becomes alert and aggressive at [commander]'s order."))
		if("Calm")
			if(animal.ai_controller)
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_AGGRESSIVE, FALSE)
				animal.ai_controller.clear_blackboard_key(BB_TA_LIVESTOCK_COMMAND)
				animal.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			else
				set_old_ai_command(null)
				old_ai_aggressive = FALSE
				reset_old_ai_hostility()
			animal.visible_message(span_notice("[animal] calms down at [commander]'s order."))

/datum/component/ta_livestock_commands/proc/begin_targeting(mob/living/commander, command_name)
	pending_target_command = command_name
	commander.client?.mouse_pointer_icon = 'modular_twilight_axis/icons/hud/animal_command_cursor.dmi'
	commander.update_mouse_pointer()
	to_chat(commander, span_notice("Click a target for the [command_name] command."))

/datum/component/ta_livestock_commands/proc/cancel_targeting()
	var/mob/living/owner = owner_ref?.resolve()
	if(owner && pending_target_command)
		owner.update_mouse_pointer()
	pending_target_command = null

/datum/component/ta_livestock_commands/proc/apply_targeted_command(mob/living/commander, command_name, atom/target)
	var/mob/living/simple_animal/animal = parent
	if(!animal || !target || get_dist(animal, target) > 9 || !can_see(animal, target))
		to_chat(commander, span_warning("[animal] cannot act on that target."))
		return

	switch(command_name)
		if("Move")
			var/turf/destination = get_turf(target)
			if(!destination)
				return
			if(animal.ai_controller)
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_COMMAND, TA_LIVESTOCK_MOVE)
				animal.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, destination)
			else
				set_old_ai_command(TA_LIVESTOCK_MOVE, destination)
			animal.visible_message(span_notice("[animal] moves where [commander] directs."))
		if("Attack")
			if(animal.ai_controller)
				var/datum/targetting_datum/targetter = animal.ai_controller.blackboard[BB_PET_TARGETING_DATUM]
				if(!targetter?.can_attack(animal, target))
					to_chat(commander, span_warning("[animal] refuses to attack [target]."))
					return
				animal.ai_controller.set_blackboard_key(BB_TA_LIVESTOCK_COMMAND, TA_LIVESTOCK_ATTACK)
				animal.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, target)
			else
				var/mob/living/simple_animal/hostile/hostile_animal = animal
				if(!old_ai_can_attack(hostile_animal, target))
					to_chat(commander, span_warning("[animal] refuses to attack [target]."))
					return
				set_old_ai_command(TA_LIVESTOCK_ATTACK, target)
				if(isliving(target) && istype(hostile_animal, /mob/living/simple_animal/hostile/retaliate))
					var/mob/living/living_target = target
					var/mob/living/simple_animal/hostile/retaliate/retaliating_animal = hostile_animal
					retaliating_animal.add_enemy(living_target)
				hostile_animal.GiveTarget(target)
			animal.visible_message(span_warning("[animal] turns aggressively toward [target] at [commander]'s command!"))
		if("Breed")
			if(!isliving(target) || !istype(target, /mob/living/simple_animal))
				to_chat(commander, span_warning("That is not an animal that can be used as a breeding partner."))
				return
			var/mob/living/simple_animal/other = target
			var/mob/living/simple_animal/mother
			var/mob/living/simple_animal/father
			if(animal.gender == FEMALE)
				mother = animal
				father = other
			else if(other.gender == FEMALE)
				mother = other
				father = animal
			else
				to_chat(commander, span_warning("Breeding requires one female and one male."))
				return
			var/failure_reason = mother.get_breeding_failure_reason(father)
			if(failure_reason)
				to_chat(commander, span_warning(failure_reason))
				return
			var/spawned = mother.make_babies_with(father)
			if(!spawned)
				to_chat(commander, span_warning("Breeding failed before offspring could be produced. Try again."))
			else
				animal.visible_message(span_notice("[animal] obeys [commander]'s breeding command."))

/datum/component/ta_livestock_commands/proc/set_old_ai_command(command, atom/target)
	old_ai_command = command
	old_ai_target_ref = target ? WEAKREF(target) : null
	var/mob/living/simple_animal/hostile/animal = parent
	if(!istype(animal))
		return
	if(command == TA_LIVESTOCK_STAY || command == TA_LIVESTOCK_FOLLOW || command == TA_LIVESTOCK_MOVE)
		animal.toggle_ai(AI_OFF)
		animal.stop_automated_movement = TRUE
		walk(animal, 0)
	else
		animal.toggle_ai(AI_ON)
		animal.stop_automated_movement = FALSE
	animal.LoseTarget()

/datum/component/ta_livestock_commands/proc/reset_old_ai_hostility(clear_enemies = TRUE)
	var/mob/living/simple_animal/hostile/animal = parent
	if(!istype(animal))
		return
	animal.toggle_ai(AI_ON)
	animal.LoseTarget()
	animal.stop_automated_movement = FALSE
	if(istype(animal, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/retaliating_animal = animal
		retaliating_animal.aggressive = FALSE
		if(clear_enemies)
			retaliating_animal.clear_enemies()

/datum/component/ta_livestock_commands/proc/old_ai_can_attack(mob/living/simple_animal/hostile/animal, atom/target)
	if(!animal || !target || target == animal)
		return FALSE
	var/mob/living/owner = owner_ref?.resolve()
	if(target == owner)
		return FALSE
	if(ismob(target) && (target in animal.friends))
		return FALSE
	return animal.CanAttack(target)

/datum/component/ta_livestock_commands/proc/on_old_ai_life(mob/living/simple_animal/hostile/animal, seconds_per_tick, times_fired)
	SIGNAL_HANDLER
	if(!animal || IS_DEAD_OR_INCAP(animal))
		return

	if(old_ai_command == TA_LIVESTOCK_STAY)
		animal.stop_automated_movement = TRUE
		walk(animal, 0)
		return

	if(old_ai_command == TA_LIVESTOCK_FOLLOW)
		var/atom/follow_target = old_ai_target_ref?.resolve()
		if(QDELETED(follow_target))
			set_old_ai_command(null)
			return
		animal.stop_automated_movement = TRUE
		if(get_dist(animal, follow_target) > 1)
			animal.Goto(follow_target, 1)
		else
			walk(animal, 0)
		return

	if(old_ai_command == TA_LIVESTOCK_MOVE)
		var/atom/move_target = old_ai_target_ref?.resolve()
		if(QDELETED(move_target))
			set_old_ai_command(null)
			return
		animal.stop_automated_movement = TRUE
		if(get_dist(animal, move_target) > 0)
			animal.Goto(move_target, 0)
		else
			walk(animal, 0)
			set_old_ai_command(null)
		return

	if(old_ai_command == TA_LIVESTOCK_ATTACK)
		var/atom/attack_target = old_ai_target_ref?.resolve()
		if(QDELETED(attack_target) || !old_ai_can_attack(animal, attack_target))
			set_old_ai_command(null)
			return
		if(animal.target != attack_target)
			INVOKE_ASYNC(src, PROC_REF(assign_old_ai_target), attack_target)
		return

	if(!old_ai_aggressive)
		return
	if(animal.target && !old_ai_can_attack(animal, animal.target))
		animal.LoseTarget()
	if(animal.target)
		return
	for(var/mob/living/candidate in oview(7, animal))
		if(!old_ai_can_attack(animal, candidate))
			continue
		INVOKE_ASYNC(src, PROC_REF(assign_old_ai_target), candidate)
		break

/datum/component/ta_livestock_commands/proc/assign_old_ai_target(atom/target)
	var/mob/living/simple_animal/hostile/animal = parent
	if(!istype(animal) || QDELETED(target) || !old_ai_can_attack(animal, target))
		return

	var/atom/command_target = old_ai_target_ref?.resolve()
	if(old_ai_command == TA_LIVESTOCK_ATTACK)
		if(target != command_target)
			return
	else if(!old_ai_aggressive)
		return

	if(isliving(target) && istype(animal, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/living_target = target
		var/mob/living/simple_animal/hostile/retaliate/retaliating_animal = animal
		retaliating_animal.add_enemy(living_target)
	animal.GiveTarget(target)

/datum/component/ta_livestock_commands/proc/on_owner_say(mob/living/speaker, speech_args)
	SIGNAL_HANDLER
	if(speaker != owner_ref?.resolve())
		return
	var/mob/living/simple_animal/animal = parent
	if(!animal || !can_see(animal, speaker, 7))
		return
	var/message = speech_args?[SPEECH_MESSAGE]
	if(!istext(message) || !length(message))
		return
	message = lowertext(message)
	if(findtext(message, "stay") || findtext(message, "stop"))
		handle_command(speaker, "Stay")
	else if(findtext(message, "free") || findtext(message, "loose"))
		handle_command(speaker, "Free")
	else if(findtext(message, "follow") || findtext(message, "come") || findtext(message, "heel"))
		handle_command(speaker, "Follow")
	else if(findtext(message, "attack") || findtext(message, "sic"))
		handle_command(speaker, "Attack")
	else if(findtext(message, "breed"))
		handle_command(speaker, "Breed")
	else if(findtext(message, "move"))
		handle_command(speaker, "Move")
	else if(findtext(message, "aggressive") || findtext(message, "guard"))
		handle_command(speaker, "Aggressive")
	else if(findtext(message, "calm") || findtext(message, "peace"))
		handle_command(speaker, "Calm")

/mob/living/simple_animal/proc/assign_livestock_owner(mob/living/new_owner)
	if(!new_owner || QDELETED(new_owner))
		return FALSE
	owner = new_owner
	if(istype(src, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_animal = src
		hostile_animal.friends |= new_owner
	setup_livestock_commands()
	var/datum/component/ta_livestock_commands/commands = GetComponent(/datum/component/ta_livestock_commands)
	commands?.set_owner(new_owner)
	return TRUE

/mob/living/simple_animal/proc/setup_livestock_commands()
	if(!can_receive_livestock_commands || adult_growth)
		return
	var/datum/component/ta_livestock_commands/existing = GetComponent(/datum/component/ta_livestock_commands)
	if(existing)
		existing.set_owner(owner)
		return
	AddComponent(/datum/component/ta_livestock_commands, owner)
