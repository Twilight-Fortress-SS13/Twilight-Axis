/datum/bond_actor
	var/datum/mind/mind
	var/datum/family_member/phantom_member
	var/cached_name = "someone"
	var/cached_origin_id

/datum/bond_actor/Destroy(force)
	mind = null
	phantom_member = null
	return ..()

/datum/bond_actor/proc/name_of()
	if(mind?.name)
		return mind.name
	var/mob/living/carbon/human/body = current_body()
	if(body?.real_name)
		return body.real_name
	return cached_name

/datum/bond_actor/proc/current_body()
	if(mind?.current)
		return mind.current
	return phantom_member?.person

/datum/bond_actor/proc/family_member_of()
	if(phantom_member)
		return phantom_member
	var/mob/living/carbon/human/body = current_body()
	return body?.family_member_datum

/datum/bond_actor/proc/is_phantom()
	return !isnull(phantom_member)

/datum/controller/subsystem/bonds/proc/actor_for_mind(datum/mind/subject)
	RETURN_TYPE(/datum/bond_actor)
	if(!subject)
		return null
	var/datum/bond_actor/actor = actors_by_mind[subject]
	if(actor)
		return actor
	actor = new()
	actor.mind = subject
	actor.cached_name = subject.name || "someone"
	actors_by_mind[subject] = actor
	return actor

/datum/controller/subsystem/bonds/proc/actor_for_phantom(datum/family_member/member)
	RETURN_TYPE(/datum/bond_actor)
	if(!member)
		return null
	var/datum/bond_actor/actor = actors_by_phantom[member]
	if(actor)
		return actor
	actor = new()
	actor.phantom_member = member
	actor.cached_name = member.person?.real_name || "родич"
	actors_by_phantom[member] = actor
	return actor

/datum/controller/subsystem/bonds/proc/resolve_actor(thing)
	RETURN_TYPE(/datum/bond_actor)
	if(!thing)
		return null
	if(istype(thing, /datum/bond_actor))
		return thing
	if(istype(thing, /datum/mind))
		return actor_for_mind(thing)
	if(istype(thing, /datum/family_member))
		var/datum/family_member/member = thing
		if(member.phantom || member.cosmetic || !member.person?.mind)
			return actor_for_phantom(member)
		return actor_for_mind(member.person.mind)
	if(ishuman(thing))
		var/mob/living/carbon/human/body = thing
		if(!body.mind)
			return null
		return actor_for_mind(body.mind)
	return null

/datum/controller/subsystem/bonds/proc/drop_actor(datum/bond_actor/actor)
	if(!actor)
		return FALSE
	for(var/datum/bond_actor/other as anything in nodes)
		if(other == actor)
			continue
		var/datum/bond_node/other_node = nodes[other]
		if(!other_node)
			continue
		other_node.remove_kin_to(actor, null)
		other_node.remove_bond(actor)
	if(actor.mind)
		actors_by_mind -= actor.mind
	if(actor.phantom_member)
		actors_by_phantom -= actor.phantom_member
	influence_pools -= actor
	drop_node(actor)
	qdel(actor)
	return TRUE

/datum/bond_node
	var/datum/bond_actor/owner
	var/list/bonds
	var/list/kin

/datum/bond_node/New(datum/bond_actor/new_owner)
	owner = new_owner
	bonds = list()
	kin = list()

/datum/bond_node/Destroy(force)
	QDEL_LIST_ASSOC_VAL(bonds)
	QDEL_LIST(kin)
	bonds = null
	kin = null
	owner = null
	return ..()

/datum/bond_node/proc/get_bond(datum/bond_actor/target)
	RETURN_TYPE(/datum/social_bond)
	if(!target || !bonds)
		return null
	return bonds[target]

/datum/bond_node/proc/add_bond(datum/social_bond/bond)
	if(!bond?.other)
		return null
	bonds[bond.other] = bond
	enforce_cap(bond.other)
	return bond

/datum/bond_node/proc/remove_bond(datum/bond_actor/target)
	var/datum/social_bond/bond = bonds?[target]
	if(!bond)
		return FALSE
	bonds -= target
	qdel(bond)
	return TRUE

/datum/bond_node/proc/add_kin(datum/social_bond/kin/link)
	RETURN_TYPE(/datum/social_bond/kin)
	if(!link?.other)
		return null
	kin += link
	return link

/datum/bond_node/proc/remove_kin_to(datum/bond_actor/target, kind)
	if(!target || !kin)
		return FALSE
	var/removed = FALSE
	for(var/datum/social_bond/kin/link as anything in kin.Copy())
		if(link.other != target)
			continue
		if(kind && link.kind != kind)
			continue
		kin -= link
		qdel(link)
		removed = TRUE
	return removed

/datum/bond_node/proc/enforce_cap(datum/bond_actor/newcomer)
	while(length(bonds) > BOND_MAX_PER_MIND)
		if(evict_weakest(newcomer, TRUE))
			continue
		if(evict_weakest(newcomer, FALSE))
			continue
		BONDS_TALLY("cap.blocked_all_protected")
		return

/datum/bond_node/proc/evict_weakest(datum/bond_actor/newcomer, untagged_only)
	var/datum/bond_actor/weakest
	var/weakest_weight = BOND_WEIGHT_MAX + 1
	for(var/datum/bond_actor/target as anything in bonds)
		if(target == newcomer)
			continue
		var/datum/social_bond/bond = bonds[target]
		if(!bond.evictable)
			continue
		if(untagged_only ? (bond.tags != BOND_TAG_NONE) : (bond.tags & BOND_TAG_PROTECTED))
			continue
		if(bond.weight >= weakest_weight)
			continue
		weakest_weight = bond.weight
		weakest = target
	if(!weakest)
		return FALSE
	BONDS_TALLY("cap.evicted")
	remove_bond(weakest)
	return TRUE

/datum/bond_node/proc/sorted_bonds()
	var/list/out = list()
	for(var/datum/bond_actor/target as anything in bonds)
		out += bonds[target]
	return out

/datum/social_bond
	var/evictable = TRUE
	var/scored = TRUE
	var/datum/bond_actor/holder
	var/datum/bond_actor/other
	var/warmth = 0
	var/weight = 0
	var/warmth_committed = 0
	var/weight_committed = 0
	var/tags = BOND_TAG_NONE
	var/list/active_events
	var/list/commit_times
	var/list/commit_counts
	var/list/history
	var/list/snapshot
	var/datum/bond_stage/stage
	var/swing_used = 0
	var/swing_reset = 0
	var/created_at = 0
	var/updated_at = 0

/datum/social_bond/New(datum/bond_actor/new_holder, datum/bond_actor/new_other)
	holder = new_holder
	other = new_other
	created_at = world.time
	updated_at = world.time
	refresh_snapshot()
	recalculate()

/datum/social_bond/Destroy(force)
	if(active_events)
		for(var/category as anything in active_events)
			var/datum/bond_event/event = active_events[category]
			event.bond = null
		QDEL_LIST_ASSOC_VAL(active_events)
	if(history)
		QDEL_LIST(history)
	active_events = null
	commit_times = null
	commit_counts = null
	history = null
	snapshot = null
	holder = null
	other = null
	return ..()

/datum/social_bond/proc/refresh_snapshot()
	var/list/built = bonds_build_snapshot(other?.current_body())
	if(built)
		snapshot = built

/datum/social_bond/proc/display_name()
	return snapshot?["name"] || other?.name_of() || "someone"

/datum/social_bond/proc/recalculate()
	if(!scored)
		updated_at = world.time
		return
	var/new_warmth = warmth_committed
	var/new_weight = weight_committed
	for(var/category as anything in active_events)
		var/datum/bond_event/event = active_events[category]
		new_warmth += event.warmth_transient * event.applied_scale
		new_weight += event.weight_transient * event.applied_scale
	warmth = clamp(new_warmth, BOND_WARMTH_MIN, BOND_WARMTH_MAX)
	weight = clamp(new_weight, BOND_WEIGHT_MIN, BOND_WEIGHT_MAX)
	stage = SSbonds.resolve_stage(src)
	updated_at = world.time

/datum/social_bond/proc/stage_label()
	return stage?.label || "Незнакомец"

/datum/social_bond/proc/stage_group()
	return stage?.category || BOND_GROUP_KNOWN

/datum/social_bond/proc/next_stage()
	RETURN_TYPE(/datum/bond_stage)
	var/current_priority = stage ? stage.priority : 0
	var/datum/bond_stage/best
	for(var/datum/bond_stage/candidate as anything in SSbonds.stage_prototypes)
		if(candidate.priority <= current_priority)
			continue
		if(warmth >= 0 && candidate.warmth_max < 0)
			continue
		if(warmth < 0 && candidate.warmth_min > 0)
			continue
		if(!best || candidate.priority < best.priority)
			best = candidate
	return best

/datum/social_bond/proc/progress_to_next()
	var/datum/bond_stage/upcoming = next_stage()
	if(!upcoming)
		return 1
	var/warmth_progress = 1
	if(warmth >= 0 && upcoming.warmth_min > 0)
		warmth_progress = clamp(warmth / upcoming.warmth_min, 0, 1)
	else if(warmth < 0 && upcoming.warmth_max < 0)
		warmth_progress = clamp(warmth / upcoming.warmth_max, 0, 1)
	var/weight_progress = 1
	if(upcoming.weight_min > 0)
		weight_progress = clamp(weight / upcoming.weight_min, 0, 1)
	return min(warmth_progress, weight_progress)

/datum/social_bond/proc/can_commit(category)
	if(!commit_times)
		return TRUE
	var/last = commit_times[category]
	if(isnull(last))
		return TRUE
	return (world.time - last) >= BOND_COMMIT_COOLDOWN

/datum/social_bond/proc/commit_scale(category)
	if(!commit_counts)
		return 1
	var/count = commit_counts[category]
	if(!count)
		return 1
	return 1 / (1 + (count * BOND_COMMIT_FALLOFF))

/datum/social_bond/proc/swing_allowance()
	if(world.time >= swing_reset)
		swing_used = 0
		swing_reset = world.time + BOND_SWING_WINDOW
		commit_counts = null
	return max(0, BOND_MAX_SWING - swing_used)

/datum/social_bond/proc/commit(datum/bond_event/prototype, applied_scale = 1)
	var/allowance = swing_allowance()
	if(!allowance)
		BONDS_TALLY("commit.blocked_swing_exhausted")
		return 0
	var/scale = commit_scale(prototype.category) * applied_scale
	var/requested = abs(prototype.warmth_commit * scale)
	if(requested > allowance)
		BONDS_TALLY("commit.clipped_by_swing")
		scale *= allowance / requested
	swing_used += abs(prototype.warmth_commit * scale)
	warmth_committed = clamp(warmth_committed + (prototype.warmth_commit * scale), BOND_WARMTH_MIN, BOND_WARMTH_MAX)
	weight_committed = clamp(weight_committed + (prototype.weight_commit * scale), BOND_WEIGHT_MIN, BOND_WEIGHT_MAX)
	LAZYINITLIST(commit_times)
	LAZYINITLIST(commit_counts)
	commit_times[prototype.category] = world.time
	commit_counts[prototype.category] = (commit_counts[prototype.category] || 0) + 1
	return scale

/datum/social_bond/proc/add_history(datum/bond_event/prototype, scale = 0)
	RETURN_TYPE(/datum/bond_history)
	var/datum/bond_history/entry = new()
	entry.label = prototype.history_label
	entry.story = prototype.build_story(src)
	entry.created_at = world.time
	entry.warmth_delta = round(prototype.warmth_commit * scale, 0.1)
	entry.weight_delta = round(prototype.weight_commit * scale, 0.1)
	entry.pinned = (prototype.tag_applied != BOND_TAG_NONE)
	entry.dream = istype(prototype, /datum/bond_event/dream)
	LAZYADD(history, entry)
	trim_history()
	return entry

/datum/social_bond/proc/trim_history()
	if(LAZYLEN(history) <= BOND_MAX_HISTORY)
		return
	for(var/datum/bond_history/entry as anything in history.Copy())
		if(entry.pinned)
			continue
		history -= entry
		qdel(entry)
		if(LAZYLEN(history) <= BOND_MAX_HISTORY)
			return
	while(LAZYLEN(history) > BOND_MAX_HISTORY)
		var/datum/bond_history/oldest = history[1]
		history -= oldest
		qdel(oldest)

/datum/social_bond/proc/attach_event(event_type, applied_scale = 1)
	RETURN_TYPE(/datum/bond_event)
	if(!scored || !applied_scale)
		return null
	var/datum/bond_event/prototype = SSbonds.get_event_prototype(event_type)
	if(!prototype)
		return null
	LAZYINITLIST(active_events)
	var/category = prototype.category
	var/datum/bond_event/existing = active_events[category]
	var/scale = 0
	if(existing && existing.type == event_type)
		existing.refresh()
	else
		if(existing)
			existing.bond = null
			qdel(existing)
		var/datum/bond_event/event = new event_type()
		event.applied_scale = applied_scale
		event.bond = src
		active_events[category] = event
		event.start()
	if(can_commit(category))
		scale = commit(prototype, applied_scale)
	if(prototype.tag_applied != BOND_TAG_NONE)
		tags |= prototype.tag_applied
	add_history(prototype, scale)
	recalculate()
	return active_events[category]

/datum/social_bond/proc/detach_event(datum/bond_event/event)
	if(!active_events || !event)
		return FALSE
	if(active_events[event.category] != event)
		return FALSE
	active_events -= event.category
	recalculate()
	return TRUE

/datum/social_bond/kin
	evictable = FALSE
	scored = FALSE
	var/kind = BOND_KIN_PARENT
	var/adopted = FALSE
	var/datum/heritage/house
	var/preserved_label

/datum/social_bond/kin/Destroy(force)
	house = null
	return ..()

/datum/social_bond/kin/display_name()
	return snapshot?["name"] || other?.name_of() || "родич"

/proc/bonds_kin_reciprocal(kind)
	switch(kind)
		if(BOND_KIN_PARENT)
			return BOND_KIN_CHILD
		if(BOND_KIN_CHILD)
			return BOND_KIN_PARENT
	return kind

/proc/bonds_kin_is_parental(kind)
	return (kind == BOND_KIN_PARENT) || (kind == BOND_KIN_CHILD)

/datum/controller/subsystem/bonds/proc/find_kin(subject, object, kind)
	RETURN_TYPE(/datum/social_bond/kin)
	var/datum/bond_node/node = get_node(subject)
	var/datum/bond_actor/target = resolve_actor(object)
	if(!node || !target)
		return null
	for(var/datum/social_bond/kin/link as anything in node.kin)
		if(link.other != target)
			continue
		if(kind && link.kind != kind)
			continue
		return link
	return null

/datum/controller/subsystem/bonds/proc/kin_of_kind(subject, kind)
	RETURN_TYPE(/list)
	var/list/out = list()
	var/datum/bond_node/node = get_node(subject)
	if(!node)
		return out
	for(var/datum/social_bond/kin/link as anything in node.kin)
		if(kind && link.kind != kind)
			continue
		if(link.other && !(link.other in out))
			out += link.other
	return out

/datum/controller/subsystem/bonds/proc/kin_links_of_kind(subject, kind)
	RETURN_TYPE(/list)
	var/list/out = list()
	var/datum/bond_node/node = get_node(subject)
	if(!node)
		return out
	for(var/datum/social_bond/kin/link as anything in node.kin)
		if(kind && link.kind != kind)
			continue
		out += link
	return out

/datum/controller/subsystem/bonds/proc/add_kin_link(subject, object, kind, adopted = FALSE, datum/heritage/house)
	RETURN_TYPE(/datum/social_bond/kin)
	var/datum/bond_actor/subject_actor = resolve_actor(subject)
	var/datum/bond_actor/object_actor = resolve_actor(object)
	if(!subject_actor || !object_actor || subject_actor == object_actor)
		return null
	var/datum/social_bond/kin/existing = find_kin(subject_actor, object_actor, kind)
	if(existing)
		existing.adopted = adopted
		if(house)
			existing.house = house
		return existing
	var/datum/bond_node/node = get_or_create_node(subject_actor)
	if(!node)
		return null
	var/datum/social_bond/kin/link = new(subject_actor, object_actor)
	link.kind = kind
	link.adopted = adopted
	link.house = house
	node.add_kin(link)
	return link

/datum/controller/subsystem/bonds/proc/add_kin(subject, object, kind, adopted = FALSE, datum/heritage/house)
	RETURN_TYPE(/datum/social_bond/kin)
	if(!resolve_actor(subject) || !resolve_actor(object) || resolve_actor(subject) == resolve_actor(object))
		return null
	var/datum/social_bond/kin/forward = add_kin_link(subject, object, kind, adopted, house)
	add_kin_link(object, subject, bonds_kin_reciprocal(kind), adopted, house)
	return forward

/datum/controller/subsystem/bonds/proc/remove_kin(subject, object, kind)
	var/removed = FALSE
	var/datum/bond_node/subject_node = get_node(subject)
	if(subject_node && subject_node.remove_kin_to(resolve_actor(object), kind))
		removed = TRUE
	var/datum/bond_node/object_node = get_node(object)
	if(object_node && object_node.remove_kin_to(resolve_actor(subject), kind ? bonds_kin_reciprocal(kind) : null))
		removed = TRUE
	return removed

/datum/controller/subsystem/bonds/proc/set_kin_adopted(subject, object, kind, adopted)
	var/datum/social_bond/kin/forward = find_kin(subject, object, kind)
	var/datum/social_bond/kin/backward = find_kin(object, subject, bonds_kin_reciprocal(kind))
	if(!forward && !backward)
		return FALSE
	if(forward)
		forward.adopted = adopted
	if(backward)
		backward.adopted = adopted
	return TRUE

/datum/controller/subsystem/bonds/proc/retype_kin(subject, object, from_kind, to_kind, adopted)
	var/datum/social_bond/kin/link = find_kin(subject, object, from_kind)
	if(!link)
		return FALSE
	var/datum/heritage/kept_house = link.house
	remove_kin(subject, object, from_kind)
	add_kin(subject, object, to_kind, adopted, kept_house)
	return TRUE

/datum/controller/subsystem/bonds/proc/drop_kin_for_house(subject, datum/heritage/house)
	var/datum/bond_node/node = get_node(subject)
	if(!node || !house)
		return FALSE
	var/dropped = FALSE
	for(var/datum/social_bond/kin/link as anything in node.kin.Copy())
		if(link.house != house)
			continue
		remove_kin(subject, link.other, link.kind)
		dropped = TRUE
	return dropped

/mob/living/carbon/human/proc/bonds_refresh_spouse_cache()
	if(!mind)
		return null
	var/list/spouses = SSbonds.kin_of_kind(mind, BOND_KIN_SPOUSE)
	if(!length(spouses))
		spouse_mob = null
		return null
	var/datum/bond_actor/first = spouses[1]
	spouse_mob = first.current_body()
	return spouse_mob

/datum/controller/subsystem/bonds/proc/kin_reaches(start, target, kind)
	var/datum/bond_actor/start_actor = resolve_actor(start)
	var/datum/bond_actor/target_actor = resolve_actor(target)
	if(!start_actor || !target_actor || start_actor == target_actor)
		return FALSE
	var/list/frontier = kin_of_kind(start_actor, kind)
	var/list/seen = list()
	seen[start_actor] = TRUE
	while(length(frontier))
		var/datum/bond_actor/current = frontier[1]
		frontier.Cut(1, 2)
		if(!current || seen[current])
			continue
		seen[current] = TRUE
		if(current == target_actor)
			return TRUE
		for(var/datum/bond_actor/next as anything in kin_of_kind(current, kind))
			if(!seen[next])
				frontier += next
	return FALSE

/datum/controller/subsystem/bonds/proc/kin_would_cycle(child, candidate_parent)
	var/datum/bond_actor/child_actor = resolve_actor(child)
	var/datum/bond_actor/parent_actor = resolve_actor(candidate_parent)
	if(!child_actor || !parent_actor)
		return FALSE
	if(child_actor == parent_actor)
		return TRUE
	return kin_reaches(parent_actor, child_actor, BOND_KIN_PARENT)

/datum/controller/subsystem/bonds/proc/get_node(participant)
	RETURN_TYPE(/datum/bond_node)
	var/datum/bond_actor/actor = resolve_actor(participant)
	if(!actor)
		return null
	return nodes[actor]

/datum/controller/subsystem/bonds/proc/get_or_create_node(participant)
	RETURN_TYPE(/datum/bond_node)
	var/datum/bond_actor/actor = resolve_actor(participant)
	if(!actor)
		return null
	var/datum/bond_node/node = nodes[actor]
	if(node)
		return node
	node = new(actor)
	nodes[actor] = node
	return node

/datum/controller/subsystem/bonds/proc/drop_node(participant)
	var/datum/bond_actor/actor = resolve_actor(participant)
	var/datum/bond_node/node = actor ? nodes[actor] : null
	if(!node)
		return FALSE
	nodes -= actor
	qdel(node)
	return TRUE

/datum/controller/subsystem/bonds/proc/get_bond(subject, object)
	RETURN_TYPE(/datum/social_bond)
	var/datum/bond_node/node = get_node(subject)
	if(!node)
		return null
	return node.get_bond(resolve_actor(object))

/datum/controller/subsystem/bonds/proc/get_or_create_bond(subject, object)
	RETURN_TYPE(/datum/social_bond)
	var/datum/bond_actor/subject_actor = resolve_actor(subject)
	var/datum/bond_actor/object_actor = resolve_actor(object)
	if(!subject_actor || !object_actor || subject_actor == object_actor)
		return null
	var/datum/bond_node/node = get_or_create_node(subject_actor)
	if(!node)
		return null
	var/datum/social_bond/bond = node.get_bond(object_actor)
	if(bond)
		return bond
	bond = new(subject_actor, object_actor)
	return node.add_bond(bond)

/datum/controller/subsystem/bonds/proc/record(subject, object, event_type, mob/living/carbon/human/object_mob, force = FALSE, applied_scale = 1)
	RETURN_TYPE(/datum/bond_event)
	var/datum/bond_actor/subject_actor = resolve_actor(subject)
	var/datum/bond_actor/object_actor = resolve_actor(object)
	if(!subject_actor || !object_actor || subject_actor == object_actor)
		BONDS_TALLY("record.no_actor")
		return null
	if(!force && !bonds_identity_visible(object_mob) && !get_bond(subject_actor, object_actor))
		BONDS_TALLY("record.blocked_identity")
		return null
	var/datum/bond_event/prototype = get_event_prototype(event_type)
	if(!prototype)
		bondlog("record() unknown event type [event_type]", BONDLOG_ERROR)
		return null
	if(!prototype.can_apply(subject_actor, object_actor))
		BONDS_TALLY("record.blocked_can_apply")
		return null
	var/datum/social_bond/bond = get_or_create_bond(subject_actor, object_actor)
	if(!bond)
		return null
	BONDS_TALLY("record.applied")
	if(verbose_logging)
		bondlog("record [subject_actor.name_of()] -> [object_actor.name_of()] [event_type]")
	return bond.attach_event(event_type, applied_scale)

/datum/controller/subsystem/bonds/proc/get_bonds_for(participant)
	var/datum/bond_node/node = get_node(participant)
	if(!node)
		return list()
	return node.sorted_bonds()
