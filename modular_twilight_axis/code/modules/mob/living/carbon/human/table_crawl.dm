#define TABLE_CRAWL_BONK_STUN (5 SECONDS)
#define TABLE_CRAWL_BONK_COOLDOWN (1 SECONDS)
#define TABLE_CRAWL_BONK_SOUND_VOLUME 100
#define TABLE_CRAWL_UNDER_LAYER_OFFSET 0.1
#define TABLE_CRAWL_ACTION_WARNING_COOLDOWN (1 SECONDS)
#define TABLE_CRAWL_FULLSCREEN_CATEGORY "table_crawl_view"

/mob/living/carbon/human
	var/tmp/table_crawl_state_enabled = FALSE
	var/tmp/table_crawl_under_table = FALSE
	var/tmp/table_crawl_attempting = FALSE
	var/tmp/table_crawl_pending_entry = FALSE
	var/tmp/table_crawl_passtable_owned = FALSE
	var/tmp/table_crawl_validating = FALSE
	var/tmp/table_crawl_restoring = FALSE
	var/tmp/table_crawl_next_bonk = 0
	var/tmp/table_crawl_next_action_warning = 0
	var/tmp/list/table_crawl_spell_actions

/mob/living/carbon/human/proc/is_table_crawl_player()
	return !!mind && !!client

/mob/living/carbon/human/set_resting(rest, silent = TRUE)
	if(!rest && try_table_crawl_head_bonk())
		rest = TRUE

	. = ..()

	if(resting && is_table_crawl_player())
		enable_table_crawl_state()
	else if(table_crawl_state_enabled && !table_crawl_under_table && !table_crawl_pending_entry)
		disable_table_crawl_state()

	refresh_table_crawl()

/mob/living/carbon/human/toggle_rest()
	if(resting && try_table_crawl_head_bonk())
		return
	return ..()

/mob/living/carbon/human/stand_up()
	if(try_table_crawl_head_bonk())
		return FALSE
	return ..()

/mob/living/carbon/human/toggle_rogmove_intent(intent, silent = FALSE)
	. = ..()
	if(table_crawl_under_table || table_crawl_pending_entry)
		update_table_crawl_visibility()
		update_table_crawl_spell_actions()
		return
	if(table_crawl_state_enabled)
		refresh_table_crawl()

/mob/living/carbon/human/check_click_intercept(params, A)
	if(table_crawl_under_table && (client?.click_intercept || click_intercept) && should_block_table_crawl_click(A, params))
		warn_table_crawl_action(get_table_crawl_block_message(A, params))
		interrupt_table_crawl_offense()
		return TRUE
	return ..()

/mob/living/carbon/human/toggle_throw_mode()
	if(table_crawl_under_table)
		warn_table_crawl_action("I can't throw things from under [get_table_crawl_name()].")
		throw_mode_off()
		return
	return ..()

/mob/living/carbon/human/throw_mode_on()
	if(table_crawl_under_table)
		warn_table_crawl_action("I can't throw things from under [get_table_crawl_name()].")
		throw_mode_off()
		return
	return ..()

/mob/living/carbon/human/throw_item(atom/target, offhand = FALSE)
	if(table_crawl_under_table)
		warn_table_crawl_action("I can't throw things from under [get_table_crawl_name()].")
		throw_mode_off()
		return
	return ..()

/mob/living/carbon/human/RangedAttack(atom/A, mouseparams)
	if(table_crawl_under_table)
		warn_table_crawl_action(get_table_crawl_block_message(A, mouseparams))
		interrupt_table_crawl_offense()
		return
	return ..()

/mob/living/carbon/human/proc/enable_table_crawl_state()
	if(table_crawl_state_enabled)
		return
	table_crawl_state_enabled = TRUE
	AddElement(/datum/element/table_crawl)

/mob/living/carbon/human/proc/disable_table_crawl_state()
	if(!table_crawl_state_enabled)
		return
	table_crawl_state_enabled = FALSE
	RemoveElement(/datum/element/table_crawl)

/mob/living/carbon/human/proc/can_table_crawl()
	if(buckled)
		return FALSE
	if(mobility_flags & MOBILITY_STAND)
		return FALSE
	if(m_intent != MOVE_INTENT_SNEAK)
		return FALSE
	if(mob_size >= MOB_SIZE_LARGE)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/can_start_table_crawl()
	if(!can_table_crawl())
		return FALSE
	return resting

/mob/living/carbon/human/proc/can_remain_table_crawl()
	if(buckled)
		return FALSE
	if(mobility_flags & MOBILITY_STAND)
		return FALSE
	if(mob_size >= MOB_SIZE_LARGE)
		return FALSE
	return resting

/mob/living/carbon/human/proc/get_table_crawl_table(atom/location = loc)
	var/turf/table_turf = get_turf(location)
	if(!table_turf)
		return

	for(var/obj/structure/table/table in table_turf)
		return table

/mob/living/carbon/human/proc/get_table_crawl_delay(obj/structure/table/target_table)
	var/adjusted_climb_time = target_table.climb_time
	if(restrained())
		adjusted_climb_time *= 2
	if(HAS_TRAIT(src, TRAIT_FREERUNNING))
		adjusted_climb_time *= 0.8
	adjusted_climb_time -= STASPD * 2
	return max(adjusted_climb_time, 0)

/mob/living/carbon/human/proc/can_virtual_table_climb(obj/structure/table/target_table, turf/target_turf)
	var/turf/source_turf = get_turf(src)
	if(!source_turf || !target_turf || source_turf == target_turf)
		return FALSE

	var/can_climb = FALSE
	var/old_density = target_table.density
	table_crawl_validating = TRUE
	target_table.density = FALSE

	can_climb = !source_turf.LinkBlockedWithAccess(target_turf, src, null)
	if(can_climb)
		can_climb = target_turf.CanPass(src, target_turf)
	if(can_climb)
		for(var/atom/movable/thing as anything in target_turf)
			if(thing == src || thing == target_table)
				continue
			if(!thing.CanPass(src, source_turf))
				can_climb = FALSE
				break

	target_table.density = old_density
	table_crawl_validating = FALSE
	return can_climb

/mob/living/carbon/human/proc/can_finish_table_crawl(obj/structure/table/target_table, turf/target_turf)
	if(QDELETED(src) || QDELETED(target_table))
		return FALSE
	if(!is_table_crawl_player())
		return FALSE
	if(!can_start_table_crawl())
		return FALSE
	if(get_table_crawl_table(loc))
		return FALSE
	if(get_turf(target_table) != target_turf)
		return FALSE
	if(!Adjacent(target_table))
		return FALSE
	if(!can_virtual_table_climb(target_table, target_turf))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/try_offer_table_crawl(obj/structure/table/target_table, turf/target_turf)
	if(table_crawl_validating)
		return
	if(table_crawl_pending_entry || table_crawl_under_table)
		return
	if(table_crawl_attempting || doing)
		return
	if(!can_finish_table_crawl(target_table, target_turf))
		return

	table_crawl_attempting = TRUE
	INVOKE_ASYNC(src, TYPE_PROC_REF(/mob/living/carbon/human, begin_table_crawl_attempt), target_table, target_turf)

/mob/living/carbon/human/proc/begin_table_crawl_attempt(obj/structure/table/target_table, turf/target_turf)
	if(QDELETED(src) || QDELETED(target_table) || QDELETED(target_turf))
		table_crawl_attempting = FALSE
		return
	if(!can_finish_table_crawl(target_table, target_turf))
		table_crawl_attempting = FALSE
		return

	var/crawl_delay = get_table_crawl_delay(target_table)
	changeNext_move(max(crawl_delay, CLICK_CD_MELEE), override = TRUE)
	visible_message(span_warning("[src] starts to crawl under [target_table]."), span_warning("You start to crawl under [target_table]..."))
	if(crawl_delay && !do_after(src, crawl_delay, target = target_table, extra_checks = CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, can_finish_table_crawl), target_table, target_turf)))
		table_crawl_attempting = FALSE
		return

	table_crawl_attempting = FALSE
	if(!can_finish_table_crawl(target_table, target_turf))
		return

	if(!(pass_flags & PASSTABLE))
		table_crawl_passtable_owned = TRUE
		pass_flags |= PASSTABLE
		queue_table_crawl_passtable_cleanup()

	enable_table_crawl_state()
	table_crawl_pending_entry = TRUE
	var/crawl_direction = get_dir(src, target_turf)
	if(!crawl_direction || !step(src, crawl_direction))
		table_crawl_pending_entry = FALSE
		clear_table_crawl_passtable()

/mob/living/carbon/human/proc/table_crawl_head_bonk()
	var/obj/structure/table/target_table = get_table_crawl_table()
	var/atom/sound_source = target_table ? target_table : src
	var/table_name = target_table ? "[target_table]" : "the underside of the table"

	visible_message(span_warning("[src] bumps their head on [table_name]!"), span_warning("You bump your head on [table_name]!"))
	playsound(sound_source, "genblunt", TABLE_CRAWL_BONK_SOUND_VOLUME, TRUE)
	Stun(TABLE_CRAWL_BONK_STUN)

/mob/living/carbon/human/proc/try_table_crawl_head_bonk()
	if(!table_crawl_under_table || !get_table_crawl_table())
		return FALSE
	if(world.time >= table_crawl_next_bonk)
		table_crawl_next_bonk = world.time + TABLE_CRAWL_BONK_COOLDOWN
		table_crawl_head_bonk()
	refresh_table_crawl()
	return TRUE

/mob/living/carbon/human/proc/apply_table_crawl_visual()
	reset_offsets("structure_climb")
	layer = TABLE_LAYER - TABLE_CRAWL_UNDER_LAYER_OFFSET
	plane = GAME_PLANE_LOWER

/mob/living/carbon/human/proc/get_table_crawl_name()
	var/obj/structure/table/target_table = get_table_crawl_table()
	return target_table ? "[target_table]" : "the table"

/mob/living/carbon/human/proc/warn_table_crawl_action(message)
	if(world.time < table_crawl_next_action_warning)
		return
	table_crawl_next_action_warning = world.time + TABLE_CRAWL_ACTION_WARNING_COOLDOWN
	if(!message)
		message = "I can't do that from under [get_table_crawl_name()]."
	to_chat(src, span_warning(message))

/mob/living/carbon/human/proc/get_table_crawl_block_message(atom/target, params)
	if(in_throw_mode)
		return "I can't throw things from under [get_table_crawl_name()]."
	if(ranged_ability || click_intercept)
		return "I can't cast from under [get_table_crawl_name()]."
	if(used_intent?.type == INTENT_GRAB)
		return "I can't grab from under [get_table_crawl_name()]."
	if(ismob(target) || get_active_held_item() || used_intent?.type != INTENT_HELP)
		return "I can't attack from under [get_table_crawl_name()]."
	return "I can't reach that from under [get_table_crawl_name()]."

/mob/living/carbon/human/proc/is_table_crawl_inventory_target(atom/target)
	if(!target)
		return FALSE
	if(target == src)
		return TRUE

	var/atom/current = target
	while(current)
		if(current == src)
			return TRUE
		if(current.loc == src)
			return TRUE
		if(isarea(current))
			break
		current = current.loc
	return FALSE

/mob/living/carbon/human/proc/should_block_table_crawl_click(atom/target, params)
	if(!table_crawl_under_table || !target)
		return FALSE
	if(istype(target, /atom/movable/screen))
		return FALSE

	var/list/modifiers = params ? params2list(params) : null
	if(modifiers?["shift"] && !in_throw_mode && !ranged_ability && !click_intercept)
		return FALSE
	if(is_table_crawl_inventory_target(target))
		return FALSE
	if(ismob(target))
		return TRUE
	if(used_intent?.type == INTENT_GRAB)
		return TRUE
	if(in_throw_mode || ranged_ability || click_intercept)
		return TRUE
	var/obj/item/held_item = get_active_held_item()
	if(modifiers?["right"] && oactive)
		held_item = get_inactive_held_item()
	if(held_item)
		return TRUE
	if(used_intent?.type != INTENT_HELP)
		return TRUE
	return get_turf(target) != get_turf(src)

/mob/living/carbon/human/proc/should_block_table_crawl_unarmed(atom/target)
	if(!table_crawl_under_table || !target)
		return FALSE
	if(is_table_crawl_inventory_target(target))
		return FALSE
	if(ismob(target))
		return TRUE
	if(used_intent?.type == INTENT_GRAB)
		return TRUE
	if(used_intent?.type != INTENT_HELP)
		return TRUE
	return get_turf(target) != get_turf(src)

/mob/living/carbon/human/proc/interrupt_table_crawl_offense()
	if(in_throw_mode)
		throw_mode_off()
	if(ranged_ability)
		ranged_ability.deactivate(src)
	else if(click_intercept && click_intercept != src)
		if(hascall(click_intercept, "end_targeting"))
			call(click_intercept, "end_targeting")()

/mob/living/carbon/human/proc/update_table_crawl_visibility()
	if(table_crawl_under_table)
		overlay_fullscreen(TABLE_CRAWL_FULLSCREEN_CATEGORY, /atom/movable/screen/fullscreen/impaired, 1)
		return

	clear_fullscreen(TABLE_CRAWL_FULLSCREEN_CATEGORY, 0)

/mob/living/carbon/human/proc/clear_table_crawl_spell_actions()
	if(!length(table_crawl_spell_actions))
		return
	for(var/datum/action/spell_action/action as anything in table_crawl_spell_actions)
		UnregisterSignal(action, COMSIG_ACTION_TRIGGER, PROC_REF(handle_table_crawl_spell_trigger))
	table_crawl_spell_actions.Cut()

/mob/living/carbon/human/proc/update_table_crawl_spell_actions()
	if(!table_crawl_under_table)
		clear_table_crawl_spell_actions()
		return
	if(!table_crawl_spell_actions)
		table_crawl_spell_actions = list()

	var/list/current_spell_actions = list()
	for(var/datum/action/spell_action/action as anything in actions)
		current_spell_actions += action
		if(action in table_crawl_spell_actions)
			continue
		RegisterSignal(action, COMSIG_ACTION_TRIGGER, PROC_REF(handle_table_crawl_spell_trigger))
		table_crawl_spell_actions += action

	for(var/datum/action/spell_action/action as anything in table_crawl_spell_actions.Copy())
		if(QDELETED(action) || !(action in current_spell_actions))
			UnregisterSignal(action, COMSIG_ACTION_TRIGGER, PROC_REF(handle_table_crawl_spell_trigger))
			table_crawl_spell_actions -= action

/mob/living/carbon/human/proc/handle_table_crawl_spell_trigger(datum/action/spell_action/source, datum/action/action)
	SIGNAL_HANDLER
	if(!table_crawl_under_table)
		return NONE
	warn_table_crawl_action("I can't cast from under [get_table_crawl_name()].")
	return COMPONENT_ACTION_BLOCK_TRIGGER

/mob/living/carbon/human/proc/clear_table_crawl_passtable()
	if(!table_crawl_passtable_owned)
		return
	table_crawl_passtable_owned = FALSE
	pass_flags &= ~PASSTABLE

/mob/living/carbon/human/proc/queue_table_crawl_passtable_cleanup()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, clear_table_crawl_passtable)), world.tick_lag, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/carbon/human/proc/queue_table_crawl_restore()
	if(table_crawl_restoring)
		return
	table_crawl_restoring = TRUE
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/carbon/human, restore_table_crawl_pose)), world.tick_lag, TIMER_UNIQUE | TIMER_OVERRIDE)

/mob/living/carbon/human/proc/restore_table_crawl_pose()
	table_crawl_restoring = FALSE
	if(QDELETED(src) || !table_crawl_under_table)
		return
	if(resting && !(mobility_flags & MOBILITY_STAND))
		return
	set_resting(TRUE, TRUE)

/mob/living/carbon/human/proc/clear_table_crawl_visual()
	var/obj/structure/table/table = get_table_crawl_table()
	if(table?.climb_offset)
		set_mob_offsets("structure_climb", _x = 0, _y = table.climb_offset)
	else
		reset_offsets("structure_climb")

	if(!(mobility_flags & MOBILITY_STAND))
		layer = LYING_MOB_LAYER
	else
		layer = initial(layer)
	plane = initial(plane)

/mob/living/carbon/human/proc/refresh_table_crawl()
	if(table_crawl_pending_entry && !get_table_crawl_table())
		table_crawl_pending_entry = FALSE
		clear_table_crawl_passtable()
	if(!table_crawl_under_table)
		clear_table_crawl_visual()
		update_table_crawl_visibility()
		clear_table_crawl_spell_actions()
		return
	if(!can_remain_table_crawl() || !get_table_crawl_table())
		table_crawl_under_table = FALSE
		clear_table_crawl_visual()
		clear_table_crawl_passtable()
		update_table_crawl_visibility()
		clear_table_crawl_spell_actions()
		return
	interrupt_table_crawl_offense()
	apply_table_crawl_visual()
	update_table_crawl_visibility()
	update_table_crawl_spell_actions()

/obj/structure/table/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use <b>\[Sneak\] + \[Lay down\]</b> and move into it to crawl under it.")
	. += span_info("Large creatures cannot fit under tables.")

/datum/element/table_crawl
	element_flags = ELEMENT_DETACH

/datum/element/table_crawl/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_pre_move))
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(target, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))
	RegisterSignal(target, COMSIG_MOB_CLICKON, PROC_REF(on_click))
	RegisterSignal(target, COMSIG_HUMAN_EARLY_UNARMED_ATTACK, PROC_REF(on_early_unarmed_attack))
	RegisterSignal(target, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_item_attack))

/datum/element/table_crawl/Detach(mob/living/carbon/human/source, ...)
	UnregisterSignal(source, list(
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_BUMP,
		COMSIG_MOB_CLICKON,
		COMSIG_HUMAN_EARLY_UNARMED_ATTACK,
		COMSIG_MOB_ITEM_ATTACK,
	))
	source.table_crawl_attempting = FALSE
	source.table_crawl_pending_entry = FALSE
	source.table_crawl_under_table = FALSE
	source.table_crawl_restoring = FALSE
	source.table_crawl_next_bonk = 0
	source.table_crawl_next_action_warning = 0
	source.clear_table_crawl_passtable()
	source.clear_table_crawl_spell_actions()
	source.update_table_crawl_visibility()
	source.clear_table_crawl_visual()
	return ..()

/datum/element/table_crawl/proc/on_pre_move(mob/living/carbon/human/source, atom/new_loc, dir)
	SIGNAL_HANDLER
	if(source.table_crawl_pending_entry)
		return NONE
	if(!source.table_crawl_under_table)
		return NONE
	if(source.can_remain_table_crawl())
		return NONE
	if(!source.get_table_crawl_table(new_loc))
		return NONE
	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/element/table_crawl/proc/on_bump(mob/living/carbon/human/source, atom/obstacle)
	SIGNAL_HANDLER
	if(source.table_crawl_pending_entry || source.table_crawl_under_table || source.table_crawl_attempting)
		return NONE
	if(!source.can_start_table_crawl())
		return NONE
	if(!istype(obstacle, /obj/structure/table))
		return NONE

	var/obj/structure/table/target_table = obstacle
	source.try_offer_table_crawl(target_table, get_turf(target_table))

/datum/element/table_crawl/proc/on_click(mob/living/carbon/human/source, atom/target, params)
	SIGNAL_HANDLER
	if(!source.should_block_table_crawl_click(target, params))
		return NONE
	source.warn_table_crawl_action(source.get_table_crawl_block_message(target, params))
	source.interrupt_table_crawl_offense()
	return COMSIG_MOB_CANCEL_CLICKON

/datum/element/table_crawl/proc/on_early_unarmed_attack(mob/living/carbon/human/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!source.should_block_table_crawl_unarmed(target))
		return NONE
	source.warn_table_crawl_action(source.get_table_crawl_block_message(target, null))
	return COMPONENT_NO_ATTACK_HAND

/datum/element/table_crawl/proc/on_item_attack(mob/living/carbon/human/source, mob/target, mob/user, obj/item/used_item)
	SIGNAL_HANDLER
	if(!source.table_crawl_under_table)
		return NONE
	source.warn_table_crawl_action("I can't attack from under [source.get_table_crawl_name()].")
	return COMPONENT_ITEM_NO_ATTACK

/datum/element/table_crawl/proc/on_moved(mob/living/carbon/human/source, atom/old_loc, direction, forced)
	SIGNAL_HANDLER
	if(source.table_crawl_pending_entry)
		source.table_crawl_pending_entry = FALSE
		if(source.get_table_crawl_table())
			source.table_crawl_under_table = TRUE
			source.apply_table_crawl_visual()
	source.clear_table_crawl_passtable()
	source.refresh_table_crawl()

#undef TABLE_CRAWL_BONK_STUN
#undef TABLE_CRAWL_BONK_COOLDOWN
#undef TABLE_CRAWL_BONK_SOUND_VOLUME
#undef TABLE_CRAWL_UNDER_LAYER_OFFSET
#undef TABLE_CRAWL_ACTION_WARNING_COOLDOWN
#undef TABLE_CRAWL_FULLSCREEN_CATEGORY
