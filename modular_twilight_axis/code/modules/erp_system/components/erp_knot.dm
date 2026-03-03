/datum/component/erp_knotting
	var/list/datum/erp_knot_link/active_links
	var/list/active_links_by_key
	var/list/btm_move_refcount
	var/decay_timer_id
	var/next_decay_at = 0

/datum/component/erp_knotting/Initialize(...)
	. = ..()
	active_links = list()
	active_links_by_key = list()
	btm_move_refcount = list()

/datum/component/erp_knotting/Destroy(force)
	clear_all_links()
	stop_decay()
	unregister_parent_moved()

	. = ..()

/datum/component/erp_knotting/RegisterWithParent()
	. = ..()
	register_parent_moved()

/datum/component/erp_knotting/UnregisterFromParent()
	. = ..()
	unregister_parent_moved()

/// Registers movement signal on parent when parent is a mob.
/datum/component/erp_knotting/proc/register_parent_moved()
	if(ismob(parent))
		RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/// Unregisters movement signal on parent when parent is a mob.
/datum/component/erp_knotting/proc/unregister_parent_moved()
	if(ismob(parent))
		UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/// Builds a stable key for penis organ + unit id lookups.
/datum/component/erp_knotting/proc/_key_for(datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0)
	return "[REF(penis_org)]#[penis_unit_id]"

/// Starts decay timer if not running.
/datum/component/erp_knotting/proc/start_decay()
	if(next_decay_at)
		return
	next_decay_at = world.time + ERP_KNOT_DECAY_TICK
	SSerp?.register_knotting_decay(src)

/// Stops decay timer if running.
/datum/component/erp_knotting/proc/stop_decay()
	if(!next_decay_at)
		return
	next_decay_at = 0
	SSerp?.unregister_knotting_decay(src)

/// Processes decay tick and restarts timer if links remain.
/datum/component/erp_knotting/proc/process_decay()
	if(!active_links || !active_links.len)
		stop_decay()
		return

	for(var/i = active_links.len; i >= 1; i--)
		var/datum/erp_knot_link/L = active_links[i]
		if(!istype(L) || !L.is_valid())
			_unregister_btm_moved(L?.btm)
			active_links.Cut(i, i + 1)
			_remove_from_index(L)
			continue
		L.decay_tick()

	if(!active_links.len)
		stop_decay()

/// Returns TRUE if there is an active knot link for this penis unit.
/datum/component/erp_knotting/proc/has_knot_link(datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0)
	return !!get_link_for_penis_unit(penis_org, penis_unit_id)

/// O(1) lookup for link by penis organ + unit id (falls back to scan if index is out of sync).
/datum/component/erp_knotting/proc/get_link_for_penis_unit(datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0)
	if(!penis_org)
		return null

	if(!active_links || !active_links.len)
		return null

	for(var/datum/erp_knot_link/L as anything in active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.penis_org == penis_org && L.penis_unit_id == penis_unit_id)
			return L

	return null

/// Returns receiving organ that must be used for forced inject target while knotted.
/datum/component/erp_knotting/proc/get_forced_inject_target(datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0)
	var/datum/erp_knot_link/L = get_link_for_penis_unit(penis_org, penis_unit_id)
	if(!L || !L.is_valid())
		return null
	return L.receiving_org

/// Notes activity for a given penis unit when action happens with expected receiving organ.
/datum/component/erp_knotting/proc/note_activity_between(datum/erp_sex_organ/penis/penis_org, datum/erp_sex_organ/other_org, penis_unit_id = 0)
	var/datum/erp_knot_link/L = get_link_for_penis_unit(penis_org, penis_unit_id)
	if(!L || !L.is_valid())
		return FALSE
	if(L.receiving_org != other_org)
		return FALSE
	L.note_activity()
	return TRUE

/// Returns TRUE if action may start with this penis against target organ given current knot state.
/datum/component/erp_knotting/proc/can_start_action_with_penis(datum/erp_sex_organ/penis/penis_org, datum/erp_sex_organ/target_org, penis_unit_id = 0)
	var/datum/erp_knot_link/L = get_link_for_penis_unit(penis_org, penis_unit_id)
	if(!L || !L.is_valid())
		return TRUE
	return (L.receiving_org == target_org)

/// Attempts to create a new knot link and apply start effects.
/datum/component/erp_knotting/proc/try_knot_link(mob/living/target, datum/erp_sex_organ/penis/penis_org, datum/erp_sex_organ/receiving_org, penis_unit_id = 0, force_level = 0)
	var/mob/living/user = parent
	if(!istype(user) || !istype(target))
		return FALSE
	if(!penis_org || !receiving_org)
		return FALSE
	
	var/list/used_units = list()

	for(var/datum/erp_knot_link/X as anything in active_links)
		if(!istype(X) || !X.is_valid())
			continue
		if(X.penis_org == penis_org)
			used_units += X.penis_unit_id

	var/max = max(1, penis_org.count_to_action)
	if(used_units.len >= max)
		return FALSE

	var/unit = null
	for(var/i = 0; i < max; i++)
		if(!(i in used_units))
			unit = i
			break

	if(isnull(unit))
		return FALSE

	var/datum/erp_knot_link/L = new(user, target, penis_org, receiving_org, unit)

	if(!islupian(user))
		record_round_statistic(STATS_KNOTTED_NOT_LUPIANS)
	record_round_statistic(STATS_KNOTTED)
	active_links += L
	_add_to_index(L)
	_register_btm_moved(L.btm)

	var/datum/erp_knot_effects/E2 = SSerp.knot_effects
	if(E2)
		E2.on_knot_started(src, L, force_level)

	start_decay()
	return TRUE

/// Removes all knot links for a given penis organ (all unit ids).
/datum/component/erp_knotting/proc/remove_all_for_penis(datum/erp_sex_organ/penis/penis_org, who_pulled = null, forceful = FALSE)
	if(!active_links || !active_links.len || !penis_org)
		return FALSE

	var/removed = FALSE
	for(var/i = active_links.len; i >= 1; i--)
		var/datum/erp_knot_link/L = active_links[i]
		if(!istype(L) || !L.is_valid())
			_unregister_btm_moved(L?.btm)
			active_links.Cut(i, i + 1)
			_remove_from_index(L)
			continue
		if(L.penis_org != penis_org)
			continue

		remove_single_link(L, forceful, who_pulled)
		removed = TRUE

	return removed

/// Removes a single knot link for specific bottom + penis unit.
/datum/component/erp_knotting/proc/remove_link_for_pair(mob/living/btm, datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0, who_pulled = null, forceful = FALSE)
	var/datum/erp_knot_link/L = get_link_for_penis_unit(penis_org, penis_unit_id)
	if(!L || !L.is_valid())
		return FALSE
	if(L.btm != btm)
		return FALSE

	remove_single_link(L, forceful, who_pulled)
	return TRUE

/// Attempts to pull out for given actor (top or bottom).
/datum/component/erp_knotting/proc/try_pull_out(mob/living/actor, datum/erp_sex_organ/penis/penis_org, penis_unit_id = 0)
	var/datum/erp_knot_link/L = get_link_for_penis_unit(penis_org, penis_unit_id)
	if(!L || !L.is_valid())
		return FALSE
	if(!istype(actor))
		return FALSE

	var/datum/erp_knot_rules/R = SSerp.knot_rules
	var/chance = R ? R.get_pull_out_chance(L, actor) : 0
	chance = clamp(chance, 5, 95)

	if(!prob(chance))
		L.try_increase_strength_from_movement()

		var/datum/erp_knot_effects/E = SSerp.knot_effects
		if(E)
			E.notify_pull_failed(L, actor)

		return FALSE

	if(actor == L.top)
		return remove_all_for_penis(penis_org, who_pulled = actor, forceful = FALSE)

	return remove_link_for_pair(L.btm, penis_org, penis_unit_id, who_pulled = actor, forceful = FALSE)

/// Removes a single link with all bookkeeping and effects.
/datum/component/erp_knotting/proc/remove_single_link(datum/erp_knot_link/L, forceful = FALSE, who_pulled = null)
	if(!L)
		return FALSE

	if(active_links && (L in active_links))
		active_links -= L

	_remove_from_index(L)
	_unregister_btm_moved(L.btm)

	if(!L.is_valid())
		qdel(L)
		_finalize_if_empty()
		return TRUE

	var/mob/living/top = L.top
	var/mob/living/btm = L.btm

	var/remove_btm_status = !has_any_links_for_btm(btm)
	var/remove_top_status = !has_any_links_for_top(top)

	var/datum/erp_knot_effects/E = SSerp.knot_effects
	if(E)
		E.on_knot_removed(src, L, forceful, who_pulled, remove_top_status, remove_btm_status)

	qdel(L)
	_finalize_if_empty()
	return TRUE

/// Returns TRUE if any remaining knot links exist for the given bottom.
/datum/component/erp_knotting/proc/has_any_links_for_btm(mob/living/btm)
	if(!active_links || !active_links.len)
		return FALSE
	for(var/datum/erp_knot_link/L as anything in active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.btm == btm)
			return TRUE
	return FALSE

/// Returns TRUE if any remaining knot links exist for the given top.
/datum/component/erp_knotting/proc/has_any_links_for_top(mob/living/top)
	if(!active_links || !active_links.len)
		return FALSE
	for(var/datum/erp_knot_link/L as anything in active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.top == top)
			return TRUE
	return FALSE

/// Clears all links and unregisters signals/timers.
/datum/component/erp_knotting/proc/clear_all_links()
	if(!active_links || !active_links.len)
		return

	for(var/i = active_links.len; i >= 1; i--)
		var/datum/erp_knot_link/L = active_links[i]
		if(istype(L))
			_remove_from_index(L)
			_unregister_btm_moved(L.btm)
			qdel(L)

	active_links.Cut()

/// Adds link into O(1) index.
/datum/component/erp_knotting/proc/_add_to_index(datum/erp_knot_link/L)
	if(!L || !L.penis_org)
		return
	active_links_by_key[_key_for(L.penis_org, L.penis_unit_id)] = L

/// Removes link from O(1) index if present.
/datum/component/erp_knotting/proc/_remove_from_index(datum/erp_knot_link/L)
	if(!L || !L.penis_org)
		return
	active_links_by_key -= _key_for(L.penis_org, L.penis_unit_id)

/// Tracks btm movement signal with refcount.
/datum/component/erp_knotting/proc/_register_btm_moved(mob/living/btm)
	if(!istype(btm))
		return

	var/n = (btm_move_refcount[btm] || 0) + 1
	btm_move_refcount[btm] = n

	if(n == 1)
		RegisterSignal(btm, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/// Untracks btm movement signal with refcount.
/datum/component/erp_knotting/proc/_unregister_btm_moved(mob/living/btm)
	if(!istype(btm))
		return
	if(!(btm in btm_move_refcount))
		return

	var/n = (btm_move_refcount[btm] || 0) - 1
	if(n <= 0)
		btm_move_refcount -= btm
		UnregisterSignal(btm, COMSIG_MOVABLE_MOVED)
		return

	btm_move_refcount[btm] = n

/// Stops decay when no links remain.
/datum/component/erp_knotting/proc/_finalize_if_empty()
	if(active_links && active_links.len)
		return
	stop_decay()

/datum/component/erp_knotting/proc/on_moved(atom/movable/mover, atom/oldloc, dir, forced)
	SIGNAL_HANDLER

	if(!active_links || !active_links.len)
		return

	var/mob/living/M = mover
	if(QDELETED(mover) || !istype(M))
		return

	for(var/datum/erp_knot_link/L as anything in active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(mover != L.top && mover != L.btm)
			continue

		addtimer(CALLBACK(src, PROC_REF(handle_link_movement), L, M), 1)

/// Handles movement consequences for a specific link via movement policy.
/datum/component/erp_knotting/proc/handle_link_movement(datum/erp_knot_link/L, mob/living/mover)
	if(!L || !L.is_valid())
		return

	var/datum/erp_knot_rules/R = SSerp.knot_rules
	if(R && R.should_break_for_missing_clients(L))
		remove_single_link(L, forceful = FALSE, who_pulled = null)
		return

	var/datum/erp_knot_movement_policy/MP = SSerp.knot_movement_policy
	if(!MP)
		return

	var/result = MP.handle_link_movement(L, mover)
	switch(result)
		if(ERP_KNOT_MOVE_BREAK_SOFT)
			remove_single_link(L, forceful = FALSE, who_pulled = mover)
		if(ERP_KNOT_MOVE_BREAK_FORCE)
			remove_single_link(L, forceful = TRUE, who_pulled = mover)

/datum/component/erp_knotting/proc/count_knots_on_target(mob/living/target)
	var/count = 0
	for(var/datum/erp_knot_link/L as anything in active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.btm == target)
			count++
	return count
