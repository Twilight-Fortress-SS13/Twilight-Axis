// Generic combo engine component.
// - stores recent inputs (skill IDs) with time/target payload
// - enforces window + max_history
// - matches suffix patterns against registered rules
// - calls virtual hooks (child decides what to do)
// - uses signals ONLY as an external entry point if someone wants to push input
//
// Child responsibilities:
// - override DefineRules() and OnComboMatched()
// - optionally override OnHistoryChanged()/OnHistoryCleared()
// - optionally push inputs directly via RegisterInput() (no signals inside component)


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
	/// Unique ID for child-side switch
	var/rule_id
	/// list of skill_id (suffix match)
	var/list/pattern
	/// higher -> earlier
	var/priority = 0
	/// Optional: callback on component instance (call(src, callback)(rule_id, target, zone))
	var/callback
	
/// global proc for intercept ability on attack
/proc/try_consume_attack_effects(mob/living/user, atom/target_atom, zone)
	if(!isliving(user))
		return FALSE
	var/result = SEND_SIGNAL(user, COMSIG_ATTACK_TRY_CONSUME, target_atom, zone)
	return (result & COMPONENT_ATTACK_CONSUMED)

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

// ----------------- Virtuals -----------------

/// Child defines rules: call RegisterRule(rule_id, pattern, priority)
/datum/component/combo_core/proc/DefineRules()
	return

/// Called after history changed (added/cleaned). Child may update visuals.
/datum/component/combo_core/proc/OnHistoryChanged()
	return

/// Called when history is cleared (explicitly or expired).
/datum/component/combo_core/proc/OnHistoryCleared(reason)
	return

/// How to consume history on combo fire.
/datum/component/combo_core/proc/ConsumeOnCombo(rule_id)
	ClearHistory("combo")
	return

// ----------------- Registration helpers -----------------
/datum/component/combo_core/proc/RegisterRule(rule_id, list/pattern, priority = 0, callback = null)
	if(!rule_id || !islist(pattern) || !pattern.len)
		return
	var/datum/combo_rule/R = new
	R.rule_id = rule_id
	R.pattern = pattern.Copy()
	R.priority = priority
	R.callback = callback
	rules += R

/datum/component/combo_core/proc/SortRules()
	if(!rules || rules.len <= 1)
		return
	rules = sortTim(rules, /proc/_combo_rule_cmp)

/proc/_combo_rule_cmp(datum/combo_rule/A, datum/combo_rule/B)
	if(A.priority > B.priority) return -1
	if(A.priority < B.priority) return 1
	return 0

// ----------------- Signals -----------------
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

// ----------------- Core API -----------------
/datum/component/combo_core/proc/LazyExpireIfNeeded()
	if(!owner)
		return
	if(!history || !history.len)
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
	if(!history || !history.len)
		return

	var/current_time = world.time
	var/list/new_history = list()

	for(var/datum/combo_input_entry/E as anything in history)
		if(!E)
			continue
		if(current_time - E.time <= combo_window)
			new_history += E

	while(new_history.len > max_history)
		new_history.Cut(1, 2)

	history = new_history

/datum/component/combo_core/proc/CheckCombos()
	if(!history || !history.len || !rules || !rules.len)
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
				ConsumeOnCombo(R.rule_id)
				return TRUE

	return FALSE

/datum/component/combo_core/proc/MatchSuffix(list/seq, list/pattern)
	if(!seq || !pattern)
		return FALSE
	if(pattern.len > seq.len)
		return FALSE

	var/base = seq.len - pattern.len
	for(var/i in 1 to pattern.len)
		if(seq[base + i] != pattern[i])
			return FALSE
	return TRUE

/datum/component/combo_core/proc/ClearHistory(reason = "manual")
	if(history)
		history.Cut()
	OnHistoryCleared(reason)
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
	if(history?.len)
		next = last_input_time + combo_window

	if(pending_actions?.len)
		var/soonest = 0
		for(var/datum/combo_pending_action/A as anything in pending_actions)
			if(!A) continue
			if(!soonest || A.execute_at < soonest)
				soonest = A.execute_at

		if(soonest && (!next || soonest < next))
			next = soonest

	return next

/datum/component/combo_core/proc/ProcessTimers(now)
	if(history?.len && (now >= last_input_time + combo_window))
		ClearHistory("expired")

	if(pending_actions?.len)
		for(var/datum/combo_pending_action/A as anything in pending_actions.Copy())
			if(!A || A.execute_at > now)
				continue
			pending_actions -= A
			call(src, A.callback)(arglist(A.args))

	Reschedule()
