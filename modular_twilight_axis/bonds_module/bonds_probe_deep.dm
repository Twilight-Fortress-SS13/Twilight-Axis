/datum/bond_probe
	var/fuzz_steps = 0
	var/fuzz_bonds = 0
	var/kin_links = 0
	var/gates_checked = 0
	var/memory_peak = 0
	var/memory_committed = 0

/datum/bond_probe/proc/check_bond_invariants(datum/social_bond/bond, tag)
	if(!bond)
		return fault("[tag]: the bond vanished mid-sequence")
	if(bond.warmth < BOND_WARMTH_MIN || bond.warmth > BOND_WARMTH_MAX)
		return fault("[tag]: warmth [bond.warmth] left the axis")
	if(bond.weight < BOND_WEIGHT_MIN || bond.weight > BOND_WEIGHT_MAX)
		return fault("[tag]: weight [bond.weight] left the axis")
	if(bond.warmth_committed < BOND_WARMTH_MIN || bond.warmth_committed > BOND_WARMTH_MAX)
		return fault("[tag]: committed warmth [bond.warmth_committed] left the axis")
	if(bond.weight_committed < BOND_WEIGHT_MIN || bond.weight_committed > BOND_WEIGHT_MAX)
		return fault("[tag]: committed weight [bond.weight_committed] left the axis")
	if(LAZYLEN(bond.history) > BOND_MAX_HISTORY)
		return fault("[tag]: [LAZYLEN(bond.history)] history entries, over the cap of [BOND_MAX_HISTORY]")
	if(bond.scored && !SSbonds.resolve_stage(bond))
		return fault("[tag]: warmth [bond.warmth] weight [bond.weight] matches no stage")
	for(var/category in bond.active_events)
		var/datum/bond_event/live = bond.active_events[category]
		if(!live)
			return fault("[tag]: category [category] holds a null active event")
		if(live.category != category)
			return fault("[tag]: category [category] holds an event filed as [live.category]")
	return TRUE

/datum/bond_probe/proc/run_event_fuzz(sequences = 12, steps = 10)
	var/list/event_types = list()
	for(var/event_type in SSbonds.event_prototypes)
		event_types += event_type
	if(!length(event_types))
		return fault("no events to fuzz with")

	for(var/sequence in 1 to sequences)
		var/datum/mind/subject = scratch_mind()
		var/datum/mind/object = scratch_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(subject, object)
		fuzz_bonds++
		if(!bond)
			fault("fuzz sequence [sequence] could not open a bond")
			continue
		for(var/step in 1 to steps)
			var/picked = pick(event_types)
			bond.attach_event(picked)
			fuzz_steps++
			if(!check_bond_invariants(bond, "fuzz [sequence].[step] after [picked]"))
				break
		bond.recalculate()
		check_bond_invariants(bond, "fuzz [sequence] after settling")
	return !length(violations)

/datum/bond_probe/proc/run_direction_probe()
	var/datum/mind/subject = scratch_mind()
	var/datum/mind/object = scratch_mind()
	SSbonds.get_or_create_bond(subject, object)
	if(SSbonds.get_bond(object, subject))
		fault("opening one direction created the reverse, so every feeling would be mutual by accident")
	if(SSbonds.get_or_create_bond(subject, subject))
		fault("a bond to oneself was allowed")
	return !length(violations)

/datum/bond_probe/proc/run_cap_probe()
	var/datum/mind/owner = scratch_mind()
	var/overshoot = BOND_MAX_PER_MIND * 2
	for(var/i in 1 to overshoot)
		var/datum/mind/other = scratch_mind()
		var/datum/social_bond/bond = SSbonds.get_or_create_bond(owner, other)
		if(!bond)
			continue
		bond.attach_event(pick(SSbonds.event_prototypes))

	var/datum/bond_node/node = SSbonds.get_node(owner)
	if(!node)
		return fault("a mind that made [overshoot] bonds has no node")
	var/held = length(node.bonds)
	if(held > BOND_MAX_PER_MIND)
		fault("a node holds [held] bonds against a cap of [BOND_MAX_PER_MIND], so the graph grows without bound")
	return !length(violations)

/datum/bond_probe/proc/run_kin_probe()
	var/list/kinds = list(BOND_KIN_PARENT, BOND_KIN_SPOUSE, BOND_KIN_SWORN_SIBLING)
	for(var/kind in kinds)
		var/datum/mind/subject = scratch_mind()
		var/datum/mind/object = scratch_mind()
		SSbonds.add_kin(subject, object, kind)
		kin_links++
		var/list/forward = SSbonds.kin_of_kind(subject, kind)
		if(!length(forward))
			fault("[kind] did not register on the subject at all")
			continue
		SSbonds.add_kin(subject, object, kind)
		if(length(SSbonds.kin_of_kind(subject, kind)) != length(forward))
			fault("declaring the same [kind] twice grew the list, so kin can be duplicated")
	return !length(violations)

/datum/bond_probe/proc/run_dream_gate_probe()
	if(!length(SSbonds.archetype_index))
		return fault("the archetype index is empty, so no dream can ever match anyone")

	var/reachable = 0
	for(var/job_type in SSbonds.archetype_index)
		reachable |= SSbonds.archetype_index[job_type]

	for(var/event_type in SSbonds.dream_prototypes)
		var/datum/bond_event/dream/prototype = SSbonds.event_prototypes[event_type]
		if(!istype(prototype))
			continue
		gates_checked++
		if(prototype.dreamer_mask && !(prototype.dreamer_mask & reachable))
			fault("[event_type] gates the sleeper on an archetype no job carries, so it can never fire")
		if(prototype.other_mask && !(prototype.other_mask & reachable))
			fault("[event_type] gates the other side on an archetype no job carries, so it can never fire")
		if(prototype.storyteller_type && !ispath(prototype.storyteller_type))
			fault("[event_type] is gated on [prototype.storyteller_type], which is not a type")
		for(var/map_type in prototype.maps)
			if(!ispath(map_type))
				fault("[event_type] is gated on map [map_type], which is not a type")

	var/list/positive = SSbonds.dream_buckets?["[BOND_DREAM_POSITIVE]"]
	var/list/negative = SSbonds.dream_buckets?["[BOND_DREAM_NEGATIVE]"]
	if(length(positive) + length(negative) != length(SSbonds.dream_prototypes))
		fault("the valence buckets hold [length(positive) + length(negative)] of [length(SSbonds.dream_prototypes)] dreams, so some are unreachable")
	return !length(violations)

/datum/bond_probe/proc/run_stance_layering_probe()
	var/list/template = SSbonds.current_realm_template()
	if(!template)
		return fault("the running map has no realm template, so layering cannot be checked")

	var/list/overrides = template["overrides"]
	for(var/key in overrides)
		var/list/declared = overrides[key]
		var/list/sides = splittext(key, "|")
		if(length(sides) != 2)
			continue
		if(SSbonds.stance_warmth(sides[1], sides[2]) != declared[1])
			fault("[key] is declared as an override but the live matrix reads [SSbonds.stance_warmth(sides[1], sides[2])], so overrides do not win")

	var/list/blocs = template["blocs"]
	var/list/inner = template["inner"]
	for(var/bloc_id in inner)
		var/list/members = blocs[bloc_id]
		var/list/triangle = inner[bloc_id]
		var/list/warmth_rows = triangle[1]
		for(var/i in 1 to length(members))
			var/list/row = warmth_rows[i]
			for(var/j in (i + 1) to length(members))
				var/expected = row[j - i]
				if(isnull(expected))
					continue
				if(overrides[bonds_stance_key(members[i], members[j])])
					continue
				if(SSbonds.stance_warmth(members[i], members[j]) != expected)
					fault("[members[i]]|[members[j]] sits inside bloc [bloc_id] at [expected] but reads [SSbonds.stance_warmth(members[i], members[j])], so the bloc matrix lost to something else")
	return !length(violations)

/datum/bond_probe/proc/run_seeding_idempotence_probe()
	var/list/before = list()
	for(var/key in SSbonds.faction_stances)
		var/datum/faction_stance/stance = SSbonds.faction_stances[key]
		before[key] = "[stance.warmth]/[stance.weight]"

	SSbonds.build_faction_stances()

	var/list/after = list()
	for(var/key in SSbonds.faction_stances)
		var/datum/faction_stance/stance = SSbonds.faction_stances[key]
		after[key] = "[stance.warmth]/[stance.weight]"

	if(length(before) != length(after))
		fault("re-seeding changed the matrix size from [length(before)] to [length(after)]")
	var/list/drifted = list()
	for(var/key in before)
		if(before[key] != after[key])
			drifted += "[key] [before[key]] -> [after[key]]"
	if(length(drifted))
		fault("re-seeding moved [length(drifted)] pairs, so seeding depends on prior state: [drifted.Join("; ")]")
	return !length(violations)


/datum/bond_probe/proc/run_memory_probe(events = 40)
	var/list/event_types = list()
	for(var/event_type in SSbonds.event_prototypes)
		event_types += event_type
	if(!length(event_types))
		return fault("no events to accumulate")

	var/datum/mind/subject = scratch_mind()
	var/datum/mind/object = scratch_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(subject, object)
	if(!bond || !bond.scored)
		return fault("could not open a scored bond to accumulate against")

	var/peak_history = 0
	for(var/i in 1 to events)
		bond.attach_event(pick(event_types))
		peak_history = max(peak_history, LAZYLEN(bond.history))
		if(LAZYLEN(bond.history) > BOND_MAX_HISTORY)
			fault("history reached [LAZYLEN(bond.history)] entries after [i] events, over the cap of [BOND_MAX_HISTORY]")
			break
	memory_peak = peak_history

	var/committed_before = bond.warmth_committed
	for(var/category in bond.active_events)
		var/datum/bond_event/live = bond.active_events[category]
		live.bond = null
		qdel(live)
	bond.active_events = null
	bond.recalculate()

	if(bond.warmth_committed != committed_before)
		fault("letting every transient expire moved the committed sum from [committed_before] to [bond.warmth_committed]; the accumulated past must survive forgetting")
	if(bond.warmth != bond.warmth_committed)
		fault("with no transients left the live warmth [bond.warmth] must equal the committed sum [bond.warmth_committed]")
	memory_committed = bond.warmth_committed
	return !length(violations)

/datum/bond_probe/proc/run_deep_sweep(sequences = 12, steps = 10)
	run_direction_probe()
	run_kin_probe()
	run_dream_gate_probe()
	run_stance_layering_probe()
	run_seeding_idempotence_probe()
	run_event_fuzz(sequences, steps)
	run_cap_probe()
	run_memory_probe()
	return !length(violations)

/datum/bond_probe/proc/deep_report()
	var/list/out = list()
	out += "fuzz:    [fuzz_steps] events across [fuzz_bonds] bonds"
	out += "kin:     [kin_links] links declared"
	out += "gates:   [gates_checked] dream gates checked against the archetype index"
	if(length(violations))
		out += "FAULTS ([length(violations)]):"
		for(var/line in violations)
			out += "  - [line]"
	else
		out += "no faults"
	return out.Join("\n")

/datum/bond_probe/proc/summary()
	return "events=[events_applied] dreams=[dreams_rendered] fuzz=[fuzz_steps]/[fuzz_bonds] kin=[kin_links] gates=[gates_checked] pairs=[stances_checked] faults=[length(violations)]"
