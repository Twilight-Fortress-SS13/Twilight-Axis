/datum/familytree_probe
	var/list/probe_houses = list()
	var/trees_built = 0
	var/members_made = 0
	var/relations_named = 0
	var/tiers_resolved = 0
	var/callbacks_fired = 0

/datum/familytree_probe/proc/drop_houses()
	for(var/datum/heritage/house as anything in probe_houses)
		if(house)
			SSfamilytree.families -= house
	probe_houses = list()

/datum/familytree_probe/proc/found_house(mob/living/carbon/human/founder_body, label)
	RETURN_TYPE(/datum/heritage)
	var/datum/heritage/house = new()
	house.housename = label
	probe_houses += house
	var/datum/family_member/founder_member = house.CreateFamilyMember(founder_body)
	if(!founder_member)
		fault("[label]: the founder could not be made a member")
		return null
	house.founder = founder_member
	members_made++
	return house

/datum/familytree_probe/proc/check_house_invariants(datum/heritage/house, tag)
	if(!house)
		return fault("[tag]: the house vanished")

	var/list/seen_people = list()
	for(var/datum/family_member/member as anything in house.members)
		if(!member)
			fault("[tag]: the member list holds a null")
			continue
		if(member.family != house)
			fault("[tag]: [member.person?.real_name] is listed by this house but points at another")
		if(member.person)
			if(seen_people[member.person])
				fault("[tag]: [member.person.real_name] appears twice in the same house")
			seen_people[member.person] = TRUE
			if(member.person.family_datum && member.person.family_datum != house)
				fault("[tag]: [member.person.real_name] is in this house but their body points at [member.person.family_datum.housename]")

		for(var/datum/family_member/parent as anything in member.get_parent_members())
			if(parent == member)
				fault("[tag]: [member.person?.real_name] is their own parent")
				continue
			if(!(member in parent.get_child_members()))
				fault("[tag]: [member.person?.real_name] claims [parent.person?.real_name] as a parent, but the child link does not answer back")

		for(var/datum/family_member/child as anything in member.get_child_members())
			if(!(member in child.get_parent_members()))
				fault("[tag]: [member.person?.real_name] claims [child.person?.real_name] as a child, but the parent link does not answer back")

		if(walks_into_a_cycle(member))
			fault("[tag]: [member.person?.real_name] sits in a parent cycle, so any walk up the tree hangs")
	return !length(violations)

/datum/familytree_probe/proc/walks_into_a_cycle(datum/family_member/start)
	var/list/seen = list()
	var/list/frontier = list(start)
	var/guard = 0
	while(length(frontier) && guard < 200)
		guard++
		var/datum/family_member/current = frontier[1]
		frontier.Cut(1, 2)
		if(seen[current])
			return TRUE
		seen[current] = TRUE
		for(var/datum/family_member/parent as anything in current.get_parent_members())
			if(parent == start)
				return TRUE
			frontier += parent
	return FALSE

/datum/familytree_probe/proc/run_family_graph_fuzz(list/cast, trees = 3)
	if(length(cast) < 3)
		return fault("a family fuzz needs at least three people")

	for(var/tree_index in 1 to trees)
		var/list/pool = shuffle(cast.Copy())
		var/mob/living/carbon/human/founder_body = pool[1]
		pool.Cut(1, 2)
		var/datum/heritage/house = found_house(founder_body, "Probe House [tree_index]")
		if(!house)
			continue
		trees_built++

		var/list/placed = list(house.GetFamilyMember(founder_body))
		for(var/mob/living/carbon/human/body as anything in pool)
			var/datum/family_member/member = house.CreateFamilyMember(body)
			if(!member)
				continue
			members_made++
			var/datum/family_member/parent = pick(placed)
			member.AddParent(parent)
			placed += member

		check_house_invariants(house, "tree [tree_index]")

		for(var/datum/family_member/first as anything in placed)
			for(var/datum/family_member/second as anything in placed)
				if(first == second)
					continue
				var/relation = first.GetRelationshipTo(second)
				relations_named++
				if(!length(relation))
					fault("tree [tree_index]: [first.person?.real_name] has no name for their tie to [second.person?.real_name], so the panel would render a blank row")

		var/datum/family_member/self_check = placed[1]
		if(self_check.AddParent(self_check))
			fault("tree [tree_index]: a member was allowed to become their own parent")

	return !length(violations)

/datum/familytree_probe/proc/run_confirmation_callback_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	var/datum/family_confirm_session/session = open_offer(first, second)
	if(!session)
		return FALSE

	session.on_both_accept = CALLBACK(src, PROC_REF(mark_callback))
	press(session, TRUE, 10, TRUE)
	press(session, FALSE, 10, TRUE)
	settle(session)

	if(callbacks_fired != 1)
		fault("two people accepted but the acceptance callback fired [callbacks_fired] times")

	callbacks_fired = 0
	var/datum/family_confirm_session/refused = open_offer(first, second)
	if(!refused)
		return FALSE
	refused.on_both_accept = CALLBACK(src, PROC_REF(mark_callback))
	press(refused, TRUE, 10, TRUE)
	press(refused, FALSE, 10, FALSE)
	settle(refused)

	if(callbacks_fired != 0)
		fault("one side refused but the acceptance callback fired anyway")
	return !length(violations)

/datum/familytree_probe/proc/mark_callback()
	callbacks_fired++

/datum/familytree_probe/proc/run_timeout_bookkeeping_probe(mob/living/carbon/human/first, mob/living/carbon/human/second)
	var/datum/family_confirm_session/session = open_offer(first, second)
	if(!session)
		return FALSE
	session.on_both_accept = CALLBACK(src, PROC_REF(mark_callback))
	callbacks_fired = 0
	settle(session)
	if(callbacks_fired != 0)
		fault("nobody answered but the acceptance callback fired")
	if(first.familytree_confirmation_pending || second.familytree_confirmation_pending)
		fault("an expired offer left someone marked pending, so the queue will skip them forever")
	return !length(violations)

/datum/familytree_probe/proc/run_role_tier_probe()
	if(!SSjob || !length(SSjob.occupations))
		return fault("no occupations are loaded, so role tiers cannot be checked")

	var/list/live_titles = list()
	for(var/datum/job/job_type as anything in subtypesof(/datum/job))
		var/title = initial(job_type.title)
		var/display = initial(job_type.display_title)
		var/feminine = initial(job_type.f_title)
		if(length(title))
			live_titles[title] = TRUE
		if(length(display))
			live_titles[display] = TRUE
		if(length(feminine))
			live_titles[feminine] = TRUE

	var/list/type_lists = list(
		"high_tier_nobility_types" = SSfamilytree.high_tier_nobility_types,
		"high_tier_church_types" = SSfamilytree.high_tier_church_types,
		"high_tier_military_types" = SSfamilytree.high_tier_military_types,
		"high_tier_town_types" = SSfamilytree.high_tier_town_types,
		"low_tier_job_types" = SSfamilytree.low_tier_job_types,
	)
	for(var/list_name in type_lists)
		for(var/job_type in type_lists[list_name])
			tiers_resolved++
			if(!ispath(job_type, /datum/job))
				fault("[list_name] names [job_type], which is not a job type, so that tier rule can never match")

	for(var/title in SSfamilytree.low_tier_job_titles)
		tiers_resolved++
		if(!live_titles[title])
			fault("low_tier_job_titles names \"[title]\", which no job carries, so that rule is dead weight")
	return !length(violations)

/datum/familytree_probe/proc/run_deep_sweep(list/cast, trees = 3)
	run_role_tier_probe()
	if(length(cast) >= 2)
		run_confirmation_callback_probe(cast[1], cast[2])
		run_timeout_bookkeeping_probe(cast[1], cast[2])
	run_family_graph_fuzz(cast, trees)
	return !length(violations)

/datum/familytree_probe/proc/deep_report()
	var/list/out = list()
	out += "trees:     [trees_built] built, [members_made] members placed"
	out += "relations: [relations_named] ties named across every ordered pair"
	out += "tiers:     [tiers_resolved] job titles resolved to a role tier"
	if(length(violations))
		out += "FAULTS ([length(violations)]):"
		for(var/line in violations)
			out += "  - [line]"
	else
		out += "no faults"
	return out.Join("\n")

/datum/familytree_probe/proc/summary()
	var/avg_hold = presses ? round(total_hold_ds / presses / 10, 0.1) : 0
	var/window = min_window_ds < 0 ? "n/a" : "[min_window_ds / 10]s"
	return "offers=[offers] pressed=[presses] ignored=[ignored] overlaps=[overlaps] peak=[peak_concurrent] hold_avg=[avg_hold]s hold_max=[max_hold_ds / 10]s window_min=[window] stuck=[pending_leaked] trees=[trees_built] relations=[relations_named] tiers=[tiers_resolved] faults=[length(violations)]"
