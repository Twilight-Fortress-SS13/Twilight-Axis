/datum/combo_pending_action
	var/execute_at
	var/callback
	var/list/args

/datum/combo_input_entry
	var/skill_id
	var/time
	var/mob/living/target
	var/zone

/datum/combo_rule
	var/rule_id
	/// list of skill_id (suffix match)
	var/list/pattern
	/// higher -> earlier
	var/priority = 0
	/// Optional callback on component instance:
	/// call(src, callback)(rule_id, target, zone)
	var/callback

/// global proc for intercept ability on attack
/proc/try_consume_attack_effects(mob/living/user, atom/target_atom, zone)
	if(!isliving(user))
		return FALSE
	var/result = SEND_SIGNAL(user, COMSIG_ATTACK_TRY_CONSUME, target_atom, zone)
	return (result & COMPONENT_ATTACK_CONSUMED)

/// sort by priority desc
/proc/_combo_rule_cmp(datum/combo_rule/A, datum/combo_rule/B)
	if(A.priority > B.priority)
		return -1
	if(A.priority < B.priority)
		return 1
	return 0

/datum/component/combo_core
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/mob/living/owner
	var/combo_window = 8 SECONDS
	var/max_history = 5

	var/list/history
	var/list/rules
	var/last_input_time = 0
	var/list/pending_actions = list()

/datum/component/combo_core/Initialize(_combo_window, _max_history)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	history = list()
	rules = list()
	pending_actions = list()

	if(_combo_window)
		combo_window = _combo_window
	if(_max_history)
		max_history = _max_history

	DefineRules()
	SortRules()

	RegisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT, PROC_REF(_sig_register_input))
	RegisterSignal(owner, COMSIG_COMBO_CORE_CLEAR, PROC_REF(_sig_clear))

/datum/component/combo_core/Destroy(force)
	SScombo_expire.Untrack(src)
	pending_actions = null

	if(owner)
		UnregisterSignal(owner, COMSIG_COMBO_CORE_REGISTER_INPUT)
		UnregisterSignal(owner, COMSIG_COMBO_CORE_CLEAR)

	owner = null
	history = null
	rules = null
	return ..()

// ------------------------------------------------------------
// Virtuals
// ------------------------------------------------------------

/// Child defines rules: call RegisterRule(rule_id, pattern, priority, callback)
/datum/component/combo_core/proc/DefineRules()
	return

/// Called after history changed (added/cleaned). Child may update visuals.
/datum/component/combo_core/proc/OnHistoryChanged()
	return

/// Called when history is cleared (explicitly or expired).
/datum/component/combo_core/proc/OnHistoryCleared(reason)
	return

/// Called right before ConsumeOnCombo() after a rule successfully fired.
/datum/component/combo_core/proc/OnComboMatched(rule_id, mob/living/target, zone)
	return

/// Called when child wants to expose "prepared/armed" state in a generic lifecycle sense.
/datum/component/combo_core/proc/OnComboPrepared(state_id, payload = null)
	return

/// Called when combo-produced state was consumed.
/datum/component/combo_core/proc/OnComboConsumed(state_id, payload = null)
	return

/// Called specifically when combo/history expired.
/datum/component/combo_core/proc/OnComboExpired()
	return

/// How to consume history on combo fire.
/datum/component/combo_core/proc/ConsumeOnCombo(rule_id)
	ClearHistory("combo")
	return

// ------------------------------------------------------------
// Registration helpers
// ------------------------------------------------------------

/datum/component/combo_core/proc/RegisterRule(rule_id, list/pattern, priority = 0, callback = null)
	if(!rule_id || !length(pattern))
		return

	var/datum/combo_rule/R = new
	R.rule_id = rule_id
	R.pattern = pattern.Copy()
	R.priority = priority
	R.callback = callback
	rules += R

/datum/component/combo_core/proc/SortRules()
	if(length(rules) <= 1)
		return
	rules = sortTim(rules, GLOBAL_PROC_REF(_combo_rule_cmp))

// ------------------------------------------------------------
// Signals
// ------------------------------------------------------------

/datum/component/combo_core/proc/_sig_register_input(datum/source, skill_id, mob/living/target, zone)
	SIGNAL_HANDLER

	if(!owner)
		return 0

	var/fired = RegisterInput(skill_id, target, zone)
	return COMPONENT_COMBO_ACCEPTED | (fired ? COMPONENT_COMBO_FIRED : 0)

/datum/component/combo_core/proc/_sig_clear(datum/source)
	SIGNAL_HANDLER
	ClearHistory("signal")
	return COMPONENT_COMBO_ACCEPTED

// ------------------------------------------------------------
// Core API
// ------------------------------------------------------------

/datum/component/combo_core/proc/LazyExpireIfNeeded()
	if(!owner)
		return
	if(!length(history))
		return

	if(world.time - last_input_time >= combo_window)
		ClearHistory("expired")

/datum/component/combo_core/proc/RegisterInput(skill_id, mob/living/target, zone)
	if(!owner || !skill_id)
		return FALSE

	LazyExpireIfNeeded()
	last_input_time = world.time

	var/datum/combo_input_entry/E = new
	E.skill_id = skill_id
	E.time = world.time
	E.target = target
	E.zone = zone
	history += E

	CleanupHistory()
	OnHistoryChanged()
	Reschedule()

	return CheckCombos()

/datum/component/combo_core/proc/CleanupHistory()
	if(!length(history))
		return

	var/current_time = world.time
	var/list/new_history = list()

	for(var/datum/combo_input_entry/E as anything in history)
		if(!E)
			continue
		if(current_time - E.time <= combo_window)
			new_history += E

	while(length(new_history) > max_history)
		new_history.Cut(1, 2)

	history = new_history

/datum/component/combo_core/proc/CheckCombos()
	if(!length(history) || !length(rules))
		return FALSE

	var/list/skills_seq = list()
	var/mob/living/last_target = null
	var/last_zone = null

	for(var/datum/combo_input_entry/E as anything in history)
		skills_seq += E.skill_id
		if(E.target)
			last_target = E.target
		if(E.zone)
			last_zone = E.zone

	for(var/datum/combo_rule/R as anything in rules)
		if(MatchSuffix(skills_seq, R.pattern))
			var/ok = FALSE

			if(R.callback)
				ok = call(src, R.callback)(R.rule_id, last_target, last_zone)

			if(ok)
				OnComboMatched(R.rule_id, last_target, last_zone)
				ConsumeOnCombo(R.rule_id)
				return TRUE

	return FALSE

/datum/component/combo_core/proc/MatchSuffix(list/seq, list/pattern)
	if(!seq || !pattern)
		return FALSE
	if(length(pattern) > length(seq))
		return FALSE

	var/base = length(seq) - length(pattern)
	for(var/i in 1 to length(pattern))
		if(seq[base + i] != pattern[i])
			return FALSE
	return TRUE

/datum/component/combo_core/proc/ClearHistory(reason = "manual")
	if(history)
		history.Cut()

	OnHistoryCleared(reason)

	if(reason == "expired")
		OnComboExpired()

	Reschedule()

/datum/component/combo_core/proc/QueueAction(delay, callback, ...)
	if(!callback)
		return

	var/datum/combo_pending_action/A = new
	A.execute_at = world.time + delay
	A.callback = callback
	A.args = args.Copy(3)
	pending_actions += A

	Reschedule()

/datum/component/combo_core/proc/Reschedule()
	var/next = GetNextWakeTime()
	if(next > 0)
		SScombo_expire.Track(src, next)
	else
		SScombo_expire.Untrack(src)

/datum/component/combo_core/proc/GetNextWakeTime()
	var/next = 0

	if(length(history))
		next = last_input_time + combo_window

	if(length(pending_actions))
		var/soonest = 0
		for(var/datum/combo_pending_action/A as anything in pending_actions)
			if(!A)
				continue
			if(!soonest || A.execute_at < soonest)
				soonest = A.execute_at

		if(soonest && (!next || soonest < next))
			next = soonest

	return next

/datum/component/combo_core/proc/ProcessTimers(now)
	if(length(history) && (now >= last_input_time + combo_window))
		ClearHistory("expired")

	if(length(pending_actions))
		for(var/datum/combo_pending_action/A as anything in pending_actions.Copy())
			if(!A || A.execute_at > now)
				continue
			pending_actions -= A
			call(src, A.callback)(arglist(A.args))

	Reschedule()

/datum/component/combo_core/proc/IsValidPrefix()
	if(!history || !rules)
		return FALSE

	var/list/skills_seq = list()
	for(var/datum/combo_input_entry/E as anything in history)
		skills_seq += E.skill_id

	for(var/datum/combo_rule/R as anything in rules)
		if(IsPrefix(skills_seq, R.pattern))
			return TRUE

	return FALSE

/datum/component/combo_core/proc/IsPrefix(list/seq, list/pattern)
	if(length(seq) > length(pattern))
		return FALSE

	for(var/i in 1 to length(seq))
		if(seq[i] != pattern[i])
			return FALSE

	return TRUE

// ============================================================
// Intermediate reusable base for combat combo styles.
// Keeps generic combat helpers OUT of plain combo_core,
// but still shared by ronin / soundbreaker / future classes.
// No class-specific visuals/messages here.
// ============================================================

/datum/component/combo_core/combat_style
	parent_type = /datum/component/combo_core

/datum/component/combo_core/combat_style/proc/TryGetZone(zone)
	if(zone)
		return zone
	if(owner?.zone_selected)
		return owner.zone_selected
	return BODY_ZONE_CHEST

/datum/component/combo_core/combat_style/proc/GetTargetTurf(atom/target_atom)
	if(!target_atom)
		return null
	if(isturf(target_atom))
		return target_atom
	return get_turf(target_atom)

/datum/component/combo_core/combat_style/proc/GetAimDir(atom/target_atom)
	if(!owner)
		return SOUTH
	if(!target_atom)
		return owner.dir

	var/turf/ot = get_turf(owner)
	var/turf/tt = get_turf(target_atom)
	if(!ot || !tt)
		return owner.dir

	var/d = get_dir(ot, tt)
	return d ? d : owner.dir

/datum/component/combo_core/combat_style/proc/FaceTurf(turf/T)
	if(!owner || !T)
		return

	var/d = GetAimDir(T)
	if(d)
		owner.setDir(d)

/datum/component/combo_core/combat_style/proc/GetPrimaryFromClick(atom/target_atom, turf/target_turf)
	if(isliving(target_atom))
		return target_atom
	return _first_living_on_turf(target_turf)

/datum/component/combo_core/combat_style/proc/GetFrontTurf(distance = 1, dir_override = null)
	if(!owner)
		return null

	var/turf/T = get_turf(owner)
	if(!T)
		return null

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	for(var/i in 1 to distance)
		var/turf/next = get_step(T, d)
		if(!next)
			break
		T = next

	return T

/datum/component/combo_core/combat_style/proc/GetArcTurfs(distance = 1, dir_override = null)
	var/list/res = list()
	if(!owner)
		return res

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	var/turf/center = GetFrontTurf(distance, d)
	if(!center)
		return res

	res += center

	var/turf/L = GetFrontTurf(distance, turn(d, 45))
	if(L)
		res += L

	var/turf/R = GetFrontTurf(distance, turn(d, -45))
	if(R)
		res += R

	return res

/datum/component/combo_core/combat_style/proc/GetWaveLineTurfs(distance = 1, dir_override = null)
	var/list/res = list()
	if(!owner)
		return res

	var/d = dir_override || owner.dir
	if(!d)
		d = owner.dir

	var/turf/center = GetFrontTurf(distance, d)
	if(!center)
		return res

	res += center

	var/dir_left = turn(d, 90)
	var/dir_right = turn(d, -90)

	var/turf/L = get_step(center, dir_left)
	if(L)
		res += L

	var/turf/R = get_step(center, dir_right)
	if(R)
		res += R

	return res

/datum/component/combo_core/combat_style/proc/_turf_is_dash_blocked(turf/T)
	if(!T)
		return TRUE
	if(T.density)
		return TRUE

	for(var/atom/movable/A in T)
		if(ismob(A))
			continue
		if(A.density)
			return TRUE

	return FALSE

/datum/component/combo_core/combat_style/proc/_first_living_on_turf(turf/T)
	if(!T)
		return null

	var/mob/living/first_dead = null
	for(var/mob/living/L in T)
		if(L == owner)
			continue
		if(L.stat == DEAD)
			if(!first_dead)
				first_dead = L
			continue
		return L

	return first_dead

/datum/component/combo_core/combat_style/proc/Knockback(mob/living/target, tiles, dir_override = null, throw_force = MOVE_FORCE_STRONG)
	if(!owner || !target || tiles <= 0)
		return

	var/d = dir_override || get_dir(owner, target)
	if(!d)
		d = owner.dir

	var/turf/start = get_turf(target)
	if(!start)
		return

	var/turf/dest = get_ranged_target_turf(start, d, tiles)
	if(dest)
		target.safe_throw_at(dest, tiles, 1, owner, force = throw_force)

/datum/component/combo_core/combat_style/proc/_get_stamina_pct(mob/living/L)
	if(!L)
		return 1
	if(!isnum(L.max_stamina) || L.max_stamina <= 0)
		return 1
	if(!isnum(L.stamina))
		return 1
	return clamp(L.stamina / L.max_stamina, 0, 1)

/datum/component/combo_core/combat_style/proc/IsOffbalanced(mob/living/L)
	if(!L)
		return FALSE
	return L.IsOffBalanced()

/datum/component/combo_core/combat_style/proc/SafeOffbalance(mob/living/L, duration)
	if(!L)
		return
	L.OffBalance(duration)

/datum/component/combo_core/combat_style/proc/SafeSlow(mob/living/L, amount)
	if(!L)
		return
	L.Slowdown(amount)

/datum/component/combo_core/combat_style/proc/GetEffectiveHitZone(mob/living/target, desired_zone, datum/skill_path = /datum/skill/combat/unarmed, datum/intent/used_intent = null, obj/item/I = null)
	if(!desired_zone || !owner || !target)
		return BODY_ZONE_CHEST

	if(!used_intent)
		used_intent = owner.used_intent
	if(!I)
		I = owner.get_active_held_item()

	var/eff = melee_accuracy_check(desired_zone, owner, target, skill_path, used_intent, I)
	return eff || BODY_ZONE_CHEST
