/mob
	var/doing_generation = 0

/datum/component/timed_action
	dupe_mode = COMPONENT_DUPE_ALLOWED

	var/mob/user
	var/delay
	var/doing_generation
	var/successful = TRUE
	var/finished = FALSE
	var/signals_registered = FALSE
	var/start_time
	var/datum/callback/extra_checks
	var/datum/progressbar/progbar
	var/progress_timer_id
	var/extra_checks_timer_id
	var/obj/item/original_held_item
	var/hand_interrupt = FALSE
	var/hand_check_pending = FALSE
	var/state_check_pending = FALSE
	var/send_do_after_signal = FALSE
	var/same_direction = FALSE
	var/original_dir

/datum/component/timed_action/Destroy()
	stop_timers()
	unregister_action_signals()
	if(progbar)
		qdel(progbar)
	progbar = null
	extra_checks = null
	user = null
	original_held_item = null
	return ..()

/datum/component/timed_action/proc/setup_action(delay, progress, datum/callback/extra_checks, doing_generation, atom/progress_target = null, poll_extra_checks = TRUE)
	if(!ismob(parent))
		return FALSE

	user = parent
	src.delay = max(delay, 0)
	src.extra_checks = extra_checks
	src.doing_generation = doing_generation
	original_held_item = user.get_active_held_item()
	start_time = world.time

	if(progress)
		progbar = new(user, src.delay, progress_target ? progress_target : user)
		var/progress_interval = max(1, round(src.delay / 20))
		progress_timer_id = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/component/timed_action, update_progress)), progress_interval, TIMER_LOOP | TIMER_STOPPABLE)

	if(extra_checks && poll_extra_checks)
		extra_checks_timer_id = addtimer(CALLBACK(src, PROC_REF(run_extra_checks)), 1, TIMER_LOOP | TIMER_STOPPABLE)

	return TRUE

/datum/component/timed_action/proc/register_action_signals()
	return

/datum/component/timed_action/proc/unregister_action_signals()
	return

/datum/component/timed_action/proc/stop_timers()
	if(progress_timer_id)
		deltimer(progress_timer_id)
		progress_timer_id = null
	if(extra_checks_timer_id)
		deltimer(extra_checks_timer_id)
		extra_checks_timer_id = null

/datum/component/timed_action/proc/update_progress()
	if(finished)
		return
	var/elapsed = world.time - start_time
	if(progbar)
		progbar.update(elapsed)
	update_additional_progress(elapsed)

/datum/component/timed_action/proc/update_additional_progress(elapsed)
	return

/datum/component/timed_action/proc/run_extra_checks()
	if(finished || !extra_checks)
		return
	if(!extra_checks.Invoke())
		cancel()

/datum/component/timed_action/proc/on_deleted()
	SIGNAL_HANDLER
	cancel()

/datum/component/timed_action/proc/on_inventory_change()
	SIGNAL_HANDLER
	if(finished || hand_check_pending)
		return
	hand_check_pending = TRUE
	addtimer(CALLBACK(src, PROC_REF(check_active_hand)), 0)

/datum/component/timed_action/proc/check_active_hand()
	hand_check_pending = FALSE
	if(finished || !hand_interrupt || !user || QDELETED(user))
		return
	if(user.get_active_held_item() != original_held_item)
		cancel()

/datum/component/timed_action/proc/on_user_state_signal()
	SIGNAL_HANDLER
	if(finished || state_check_pending)
		return
	state_check_pending = TRUE
	addtimer(CALLBACK(src, PROC_REF(check_user_state)), 0)

/datum/component/timed_action/proc/check_user_state()
	state_check_pending = FALSE
	if(finished || !user || QDELETED(user))
		return
	if(!user_state_valid())
		cancel()

/datum/component/timed_action/proc/user_state_valid()
	if(user.stat)
		return FALSE
	if(isliving(user))
		var/mob/living/living_user = user
		if(living_user.IsStun() || living_user.IsParalyzed() || living_user.IsImmobilized())
			return FALSE
	return TRUE

/datum/component/timed_action/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	if(new_dir != original_dir)
		cancel()

/datum/component/timed_action/proc/done_wrong_action()
	SIGNAL_HANDLER
	cancel()

/datum/component/timed_action/proc/cancel()
	if(finished)
		return
	successful = FALSE
	finish_action()

/datum/component/timed_action/proc/final_validation(skip_extra_checks = FALSE)
	return FALSE

/datum/component/timed_action/proc/finish_additional_progress()
	return

/datum/component/timed_action/proc/release_action_refs()
	extra_checks = null
	original_held_item = null

/datum/component/timed_action/proc/finish_action()
	if(finished)
		return
	finished = TRUE
	stop_timers()
	unregister_action_signals()

	if(progbar)
		if(successful)
			progbar.update(delay)
		qdel(progbar)
		progbar = null
	finish_additional_progress()

	if(user && !QDELETED(user) && user.doing_generation == doing_generation)
		user.doing = FALSE
		if(send_do_after_signal)
			SEND_SIGNAL(user, COMSIG_DO_AFTER_ENDED)

	release_action_refs()

/datum/component/timed_action/proc/sync()
	if(!finished && successful && !final_validation(TRUE))
		successful = FALSE
	if(!finished && successful && delay > 0)
		sleep(delay)
	if(!finished && successful && !final_validation())
		successful = FALSE
	if(!finished)
		finish_action()
	var/result = successful
	qdel(src)
	return result

/datum/component/do_after_component
	parent_type = /datum/component/timed_action

	var/atom/target
	var/needhand
	var/allow_movement
	var/atom/original_user_loc
	var/atom/original_target_loc

/datum/component/do_after_component/Initialize(delay, needhand, atom/target, progress, datum/callback/extra_checks, same_direction, allow_movement, doing_generation)
	if(!setup_action(delay, progress, extra_checks, doing_generation))
		return COMPONENT_INCOMPATIBLE

	src.target = target
	src.needhand = needhand
	src.same_direction = same_direction
	src.allow_movement = allow_movement
	original_dir = user.dir
	original_user_loc = user.loc
	if(target && !isturf(target))
		original_target_loc = target.loc
	hand_interrupt = needhand
	send_do_after_signal = TRUE
	register_action_signals()

/datum/component/do_after_component/Destroy()
	. = ..()
	target = null
	original_user_loc = null
	original_target_loc = null
	return .

/datum/component/do_after_component/register_action_signals()
	if(signals_registered || !user)
		return
	signals_registered = TRUE

	RegisterSignal(user, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))
	RegisterSignal(user, COMSIG_MOB_STATCHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
	RegisterSignal(user, COMSIG_MOB_ATTACK_HAND, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))

	if(!allow_movement)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))
	if(same_direction)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_dir_change))
	if(needhand)
		RegisterSignal(user, COMSIG_CARBON_SWAPHANDS, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_DROPITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))

	if(isliving(user))
		RegisterSignal(user, COMSIG_LIVING_STATUS_STUN, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_PARALYZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_IMMOBILIZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))

	if(target && !isturf(target))
		if(target == user)
			if(allow_movement)
				RegisterSignal(user, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))
		else
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))
			RegisterSignal(target, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))

/datum/component/do_after_component/unregister_action_signals()
	if(!signals_registered)
		return
	signals_registered = FALSE

	if(user)
		UnregisterSignal(user, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE, COMSIG_MOB_ATTACK_HAND))
		if(!allow_movement || target == user)
			UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		if(same_direction)
			UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		if(needhand)
			UnregisterSignal(user, list(COMSIG_CARBON_SWAPHANDS, COMSIG_MOB_DROPITEM, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
		if(isliving(user))
			UnregisterSignal(user, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_IMMOBILIZE))

	if(target && !isturf(target) && target != user)
		UnregisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

/datum/component/do_after_component/release_action_refs()
	. = ..()
	target = null
	original_user_loc = null
	original_target_loc = null

/datum/component/do_after_component/final_validation(skip_extra_checks = FALSE)
	if(!user || QDELETED(user))
		return FALSE
	if(user.doing_generation != doing_generation)
		return FALSE
	if(!user_state_valid())
		return FALSE
	if(!allow_movement && user.loc != original_user_loc)
		return FALSE
	if(same_direction && user.dir != original_dir)
		return FALSE
	if(needhand && user.get_active_held_item() != original_held_item)
		return FALSE
	if(target && !isturf(target))
		if(QDELETED(target) || target.loc != original_target_loc)
			return FALSE
	if(!skip_extra_checks && extra_checks && !extra_checks.Invoke())
		return FALSE
	return TRUE

/datum/component/do_mob_component
	parent_type = /datum/component/timed_action

	var/mob/target
	var/uninterruptible
	var/can_move
	var/adjacency_check_pending = FALSE
	var/datum/progressbar/progbartarget

/datum/component/do_mob_component/Initialize(mob/target, delay, uninterruptible, progress, datum/callback/extra_checks, double_progress, can_move, doing_generation)
	if(!target)
		return COMPONENT_INCOMPATIBLE
	if(!setup_action(delay, progress, extra_checks, doing_generation, target, !uninterruptible))
		return COMPONENT_INCOMPATIBLE

	src.target = target
	src.uninterruptible = uninterruptible
	src.can_move = can_move
	hand_interrupt = !uninterruptible
	if(double_progress)
		progbartarget = new(target, src.delay, user)
		if(!progress)
			var/progress_interval = max(1, round(src.delay / 20))
			progress_timer_id = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/component/timed_action, update_progress)), progress_interval, TIMER_LOOP | TIMER_STOPPABLE)
	register_action_signals()

/datum/component/do_mob_component/Destroy()
	if(progbartarget)
		qdel(progbartarget)
	progbartarget = null
	. = ..()
	target = null
	return .

/datum/component/do_mob_component/register_action_signals()
	if(signals_registered || !user)
		return
	signals_registered = TRUE

	RegisterSignal(user, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))
	if(target != user)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))

	if(uninterruptible)
		return

	RegisterSignal(user, COMSIG_MOB_STATCHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
	RegisterSignal(user, COMSIG_CARBON_SWAPHANDS, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_DROPITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))

	if(isliving(user))
		RegisterSignal(user, COMSIG_LIVING_STATUS_STUN, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_PARALYZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_UNCONSCIOUS, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_IMMOBILIZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))

	if(!can_move)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_position_change))
		if(target != user)
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_position_change))

/datum/component/do_mob_component/unregister_action_signals()
	if(!signals_registered)
		return
	signals_registered = FALSE

	if(user)
		UnregisterSignal(user, COMSIG_PARENT_QDELETING)
	if(target && target != user)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)

	if(uninterruptible)
		return

	if(user)
		UnregisterSignal(user, list(COMSIG_MOB_STATCHANGE, COMSIG_CARBON_SWAPHANDS, COMSIG_MOB_DROPITEM, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
		if(isliving(user))
			UnregisterSignal(user, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_UNCONSCIOUS, COMSIG_LIVING_STATUS_IMMOBILIZE))
		if(!can_move)
			UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
	if(!can_move && target && target != user)
		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/component/do_mob_component/release_action_refs()
	. = ..()
	target = null

/datum/component/do_mob_component/user_state_valid()
	if(!..())
		return FALSE
	return !user.incapacitated()

/datum/component/do_mob_component/proc/on_position_change()
	SIGNAL_HANDLER
	if(adjacency_check_pending || finished || uninterruptible || can_move)
		return
	adjacency_check_pending = TRUE
	addtimer(CALLBACK(src, PROC_REF(check_adjacency)), 0)

/datum/component/do_mob_component/proc/check_adjacency()
	adjacency_check_pending = FALSE
	if(finished || uninterruptible || can_move || !user || !target || QDELETED(user) || QDELETED(target))
		return
	if(!user.Adjacent(target))
		cancel()

/datum/component/do_mob_component/update_additional_progress(elapsed)
	if(progbartarget)
		progbartarget.update(elapsed)

/datum/component/do_mob_component/finish_additional_progress()
	if(!progbartarget)
		return
	if(successful)
		progbartarget.update(delay)
	qdel(progbartarget)
	progbartarget = null

/datum/component/do_mob_component/final_validation(skip_extra_checks = FALSE)
	if(!user || !target || QDELETED(user) || QDELETED(target))
		return FALSE
	if(user.doing_generation != doing_generation)
		return FALSE
	if(uninterruptible)
		return TRUE
	if(!can_move && !user.Adjacent(target))
		return FALSE
	if(user.get_active_held_item() != original_held_item)
		return FALSE
	if(!user_state_valid())
		return FALSE
	if(!skip_extra_checks && extra_checks && !extra_checks.Invoke())
		return FALSE
	return TRUE

/datum/component/move_after_component
	parent_type = /datum/component/timed_action

	var/atom/target
	var/needhand
	var/adjacency_check_pending = FALSE

/datum/component/move_after_component/Initialize(delay, needhand, atom/target, progress, datum/callback/extra_checks, same_direction, doing_generation)
	if(!setup_action(delay, progress, extra_checks, doing_generation))
		return COMPONENT_INCOMPATIBLE

	src.target = target
	src.needhand = needhand
	src.same_direction = same_direction
	original_dir = user.dir
	hand_interrupt = needhand
	send_do_after_signal = TRUE
	register_action_signals()

/datum/component/move_after_component/Destroy()
	. = ..()
	target = null
	return .

/datum/component/move_after_component/register_action_signals()
	if(signals_registered || !user)
		return
	signals_registered = TRUE

	RegisterSignal(user, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))
	RegisterSignal(user, COMSIG_MOB_STATCHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_position_change))

	if(same_direction)
		RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_dir_change))
	if(needhand)
		RegisterSignal(user, COMSIG_CARBON_SWAPHANDS, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_DROPITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
		RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))

	if(isliving(user))
		RegisterSignal(user, COMSIG_LIVING_STATUS_STUN, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_PARALYZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_IMMOBILIZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))

	if(target && target != user)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))
		if(istype(target, /atom/movable))
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_position_change))

/datum/component/move_after_component/unregister_action_signals()
	if(!signals_registered)
		return
	signals_registered = FALSE

	if(user)
		UnregisterSignal(user, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_MOVED))
		if(same_direction)
			UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE)
		if(needhand)
			UnregisterSignal(user, list(COMSIG_CARBON_SWAPHANDS, COMSIG_MOB_DROPITEM, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
		if(isliving(user))
			UnregisterSignal(user, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_IMMOBILIZE))
	if(target && target != user)
		UnregisterSignal(target, COMSIG_PARENT_QDELETING)
		if(istype(target, /atom/movable))
			UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/component/move_after_component/release_action_refs()
	. = ..()
	target = null

/datum/component/move_after_component/proc/on_position_change()
	SIGNAL_HANDLER
	if(adjacency_check_pending || finished)
		return
	adjacency_check_pending = TRUE
	addtimer(CALLBACK(src, PROC_REF(check_adjacency)), 0)

/datum/component/move_after_component/proc/check_adjacency()
	adjacency_check_pending = FALSE
	if(finished || !user || QDELETED(user))
		return
	var/atom/Tloc = target?.loc
	var/atom/Uloc = user.loc
	if(!Tloc?.Adjacent(Uloc))
		cancel()

/datum/component/move_after_component/final_validation(skip_extra_checks = FALSE)
	if(!user || QDELETED(user))
		return FALSE
	if(user.doing_generation != doing_generation)
		return FALSE
	if(!user_state_valid())
		return FALSE
	var/atom/Tloc = target?.loc
	var/atom/Uloc = user.loc
	if(!Tloc?.Adjacent(Uloc))
		return FALSE
	if(same_direction && user.dir != original_dir)
		return FALSE
	if(needhand && user.get_active_held_item() != original_held_item)
		return FALSE
	if(!skip_extra_checks && extra_checks && !extra_checks.Invoke())
		return FALSE
	return TRUE

/datum/component/do_after_mob_component
	parent_type = /datum/component/timed_action

	var/list/targets
	var/list/original_target_locs
	var/atom/original_user_loc
	var/uninterruptible
	var/required_mobility_flags

/datum/component/do_after_mob_component/Initialize(list/targets, delay, uninterruptible, progress, datum/callback/extra_checks, required_mobility_flags, doing_generation)
	if(!targets || !length(targets))
		return COMPONENT_INCOMPATIBLE

	src.targets = list()
	for(var/atom/target in targets)
		if(!(target in src.targets))
			src.targets += target
	if(!length(src.targets))
		return COMPONENT_INCOMPATIBLE
	if(!setup_action(delay, progress, extra_checks, doing_generation, src.targets[1], !uninterruptible))
		return COMPONENT_INCOMPATIBLE

	src.uninterruptible = uninterruptible
	src.required_mobility_flags = required_mobility_flags
	original_user_loc = user.loc
	original_target_locs = list()
	for(var/atom/target in src.targets)
		original_target_locs[target] = target.loc
	hand_interrupt = !uninterruptible
	register_action_signals()

/datum/component/do_after_mob_component/Destroy()
	. = ..()
	targets = null
	original_target_locs = null
	original_user_loc = null
	return .

/datum/component/do_after_mob_component/register_action_signals()
	if(signals_registered || !user)
		return
	signals_registered = TRUE

	RegisterSignal(user, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, on_deleted))

	if(uninterruptible)
		return

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))
	RegisterSignal(user, COMSIG_MOB_STATCHANGE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
	RegisterSignal(user, COMSIG_CARBON_SWAPHANDS, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_DROPITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))
	RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, TYPE_PROC_REF(/datum/component/timed_action, on_inventory_change))

	if(isliving(user))
		RegisterSignal(user, COMSIG_LIVING_STATUS_STUN, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_PARALYZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_UNCONSCIOUS, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_KNOCKDOWN, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_IMMOBILIZE, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))
		RegisterSignal(user, COMSIG_LIVING_STATUS_SLEEP, TYPE_PROC_REF(/datum/component/timed_action, on_user_state_signal))

	for(var/atom/target in targets)
		if(!target || target == user)
			continue
		RegisterSignal(target, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))
		if(istype(target, /atom/movable))
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/datum/component/timed_action, done_wrong_action))

/datum/component/do_after_mob_component/unregister_action_signals()
	if(!signals_registered)
		return
	signals_registered = FALSE

	if(user)
		UnregisterSignal(user, COMSIG_PARENT_QDELETING)

	if(uninterruptible)
		return

	if(user)
		UnregisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_STATCHANGE, COMSIG_CARBON_SWAPHANDS, COMSIG_MOB_DROPITEM, COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_UNEQUIPPED_ITEM))
		if(isliving(user))
			UnregisterSignal(user, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_PARALYZE, COMSIG_LIVING_STATUS_UNCONSCIOUS, COMSIG_LIVING_STATUS_KNOCKDOWN, COMSIG_LIVING_STATUS_IMMOBILIZE, COMSIG_LIVING_STATUS_SLEEP))
	if(targets)
		for(var/atom/target in targets)
			if(!target || target == user)
				continue
			UnregisterSignal(target, COMSIG_PARENT_QDELETING)
			if(istype(target, /atom/movable))
				UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/component/do_after_mob_component/release_action_refs()
	. = ..()
	targets = null
	original_target_locs = null
	original_user_loc = null

/datum/component/do_after_mob_component/user_state_valid()
	if(!..())
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(isliving(user) && required_mobility_flags)
		var/mob/living/living_user = user
		if(!CHECK_MULTIPLE_BITFIELDS(living_user.mobility_flags, required_mobility_flags))
			return FALSE
	return TRUE

/datum/component/do_after_mob_component/final_validation(skip_extra_checks = FALSE)
	if(!user || QDELETED(user))
		return FALSE
	if(user.doing_generation != doing_generation)
		return FALSE
	if(uninterruptible)
		return TRUE
	if(user.loc != original_user_loc)
		return FALSE
	if(user.get_active_held_item() != original_held_item)
		return FALSE
	if(!user_state_valid())
		return FALSE
	for(var/atom/target in targets)
		if(QDELETED(target) || original_target_locs[target] != target.loc)
			return FALSE
	if(!skip_extra_checks && extra_checks && !extra_checks.Invoke())
		return FALSE
	return TRUE
