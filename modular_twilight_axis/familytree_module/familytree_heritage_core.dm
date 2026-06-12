/datum/heritage
	var/housename
	var/datum/species/dominant_species
	var/datum/species/dominant_race
	var/list/members = list()
	var/list/member_nodes = list()
	var/list/family_icons = list()
	var/datum/family_member/founder
	var/datum/family_member/house_leader
	var/closed = FALSE

	var/list/family_curses = list()
	var/list/curse_history = list()

/datum/heritage/proc/AddFamilyCurse(datum/family_curse/curse_type, severity, mob/curser)
	var/datum/family_curse/new_curse = new curse_type()
	new_curse.curse_type = curse_type
	new_curse.severity = severity
	new_curse.cursed_by = WEAKREF(curser)
	new_curse.when_cursed = world.time

	family_curses += new_curse

	curse_history += "The [housename] family was cursed with [new_curse.name] by [curser]"

	ApplyCurseEffects(new_curse)

	return new_curse

/datum/heritage/proc/ApplyCurseEffects(datum/family_curse/curse)
	for(var/datum/family_node/node as anything in member_nodes)
		if(node.person)
			for(var/effect in curse.curse_effects)
				node.person.apply_status_effect(effect)

/datum/heritage/proc/InheritCurses(datum/family_member/child)
	for(var/datum/family_curse/curse as anything in family_curses)
		if(curse.inherited)
			for(var/effect in curse.curse_effects)
				child.person?.apply_status_effect(effect)


/datum/heritage/proc/TransferToFamily(mob/living/carbon/human/person, relationship_type)
	var/datum/family_member/member = CreateFamilyMember(person)
	if(!member)
		return FALSE

	switch(relationship_type)
		if(FAMILY_INLAW)
			member.adoption_status = FALSE
		if(FAMILY_FATHER, FAMILY_MOTHER)
			pass()

	to_chat(person, span_notice("Вы вступили в семью [housename] как [relationship_type]."))
	return member

/datum/heritage/proc/ConductWedding(datum/family_member/bride, datum/family_member/groom, mob/living/carbon/human/officiant)
	if(!bride || !groom || !officiant)
		return FALSE

	if(!MarryMembers(bride, groom))
		return FALSE

	var/announcement = "[bride.person?.real_name] и [groom.person?.real_name] сочетались браком в семье [housename]!"

	for(var/datum/family_node/node as anything in member_nodes)
		if(node.person && node.person?.client)
			to_chat(node.person, span_love(announcement))

	bride.HandleBiologicalChildren(groom)

	return TRUE

/datum/heritage/New(mob/living/carbon/human/founder_person, new_name, majority_species)
	if(founder_person)
		founder = CreateFamilyMember(founder_person)
		founder.generation = 0

		if(!new_name)
			housename = SurnameFormatting(founder_person)
		else
			housename = new_name

		dominant_species = majority_species
		dominant_race = founder_person?.dna?.species
		if(!majority_species)
			dominant_species = founder_person?.dna?.species?.type

/datum/heritage/proc/SelectReplacementHouseHead()
	var/datum/family_member/replacement = null
	for(var/datum/family_member/member as anything in members)
		if(member?.person && !member.phantom && !member.cosmetic)
			replacement = member
			break
	if(!replacement)
		for(var/datum/family_member/member as anything in members)
			if(member && !member.cosmetic)
				replacement = member
				break
	if(!founder || !(founder in members))
		founder = replacement
	if(!house_leader || !(house_leader in members))
		house_leader = replacement
	return replacement

/datum/heritage/proc/IsPreservablePlayerMember(datum/family_member/member)
	if(!member?.person || member.phantom)
		return FALSE
	if(!member.person.ckey || istype(member.person, /mob/living/carbon/human/dummy))
		return FALSE
	return TRUE

/datum/heritage/proc/FamilyTreeMembersConnectedWithoutBridge(datum/family_member/start, datum/family_member/target, datum/family_member/bridge)
	if(!start || !target)
		return FALSE
	if(start == target)
		return TRUE
	var/list/seen = list()
	var/list/queue = list(start)
	seen[start] = TRUE
	if(bridge)
		seen[bridge] = TRUE

	while(queue.len)
		var/datum/family_member/current = queue[1]
		queue.Cut(1, 2)
		if(!current)
			continue

		var/list/neighbors = list()
		neighbors += current.get_parent_members()
		neighbors += current.get_child_members()
		neighbors += current.get_spouse_members()
		neighbors += current.get_sworn_sibling_members()

		for(var/datum/family_member/neighbor as anything in neighbors)
			if(!neighbor || seen[neighbor] || !(neighbor in members))
				continue
			if(neighbor == target)
				return TRUE
			seen[neighbor] = TRUE
			queue += neighbor

	return FALSE

/datum/heritage/proc/PreservePlayerRelationshipsThroughDepartingMember(datum/family_member/departing)
	if(!IsPreservablePlayerMember(departing))
		return FALSE

	var/list/player_members = list()
	for(var/datum/family_member/member as anything in members)
		if(member == departing || !IsPreservablePlayerMember(member))
			continue
		player_members += member

	var/preserved = 0
	var/player_count = player_members.len
	for(var/i = 1, i < player_count, i++)
		var/datum/family_member/member_a = player_members[i]
		for(var/j = i + 1, j <= player_count, j++)
			var/datum/family_member/member_b = player_members[j]
			if(FamilyTreeMembersConnectedWithoutBridge(member_a, member_b, departing))
				continue
			var/relation_a_to_b = member_a.GetRelationshipTo(member_b)
			var/relation_b_to_a = member_b.GetRelationshipTo(member_a)
			if(SSfamilytree.preserve_player_relationship(member_a, member_b, relation_a_to_b, relation_b_to_a, src))
				preserved++

	return preserved

/datum/heritage/proc/RemoveFamilyMember(datum/family_member/member, clear_person_refs = TRUE)
	if(!member || !(member in members))
		return FALSE

	var/mob/living/carbon/human/person = member.person
	PreservePlayerRelationshipsThroughDepartingMember(member)

	var/list/member_parents = member.get_parent_members()
	for(var/datum/family_member/parent as anything in member_parents)
		member.RemoveParent(parent)

	var/list/member_children = member.get_child_members()
	for(var/datum/family_member/child as anything in member_children)
		member.RemoveChild(child)

	var/list/member_spouses = member.get_spouse_members()
	for(var/datum/family_member/spouse as anything in member_spouses)
		var/mob/living/carbon/human/spouse_person = spouse?.person
		member.RemoveSpouse(spouse)
		if(person && person.spouse_mob == spouse_person)
			person.spouse_mob = null
		if(spouse_person && spouse_person.spouse_mob == person)
			var/mob/living/carbon/human/replacement_spouse = null
			for(var/datum/family_member/other_spouse as anything in spouse.get_spouse_members())
				if(other_spouse?.person)
					replacement_spouse = other_spouse.person
					break
			spouse_person.spouse_mob = replacement_spouse

	if(person)
		var/image/member_icon = family_icons[person]
		if(member_icon)
			for(var/datum/family_node/viewer_node as anything in member_nodes)
				if(viewer_node.person?.client)
					viewer_node.person.client.images.Remove(member_icon)
			family_icons.Remove(person)

	members -= member

	if(founder == member)
		founder = null
	if(house_leader == member)
		house_leader = null
	SelectReplacementHouseHead()

	if(clear_person_refs && person)
		if(person.family_datum == src)
			person.family_datum = null
		if(person.family_member_datum == member)
			person.family_member_datum = null
		person.spouse_mob = null

	member.phantom_parent_members.Cut()
	member.phantom_child_members.Cut()
	if(person)
		SSfamilytree.graph_on_member_removed(person, src)
	member.person = null
	member.family = null
	return TRUE

/datum/heritage/proc/RemovePersonFromFamily(mob/living/carbon/human/person, clear_person_refs = TRUE)
	if(!person)
		return FALSE
	var/datum/family_member/member = GetFamilyMember(person)
	if(!member && person.family_member_datum?.family == src)
		member = person.family_member_datum
	if(!member)
		return FALSE
	return RemoveFamilyMember(member, clear_person_refs)

/datum/heritage/proc/CreateCosmeticFamilyMember(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null
	var/datum/family_member/new_member = new(person, src)
	new_member.cosmetic = TRUE
	members += new_member
	person?.family_datum = src
	return new_member

/datum/heritage/proc/CreateFamilyMember(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null

	var/datum/family_member/existing_fast = person.family_member_datum
	if(existing_fast && existing_fast.family == src)
		return existing_fast

	if(person.family_datum && person.family_datum != src)
		person.family_datum.RemovePersonFromFamily(person)
	else if(person.family_member_datum?.family && person.family_member_datum.family != src)
		person.family_member_datum.family.RemoveFamilyMember(person.family_member_datum)

	var/datum/family_member/new_member = new(person, src)
	members += new_member
	person?.family_datum = src

	SSfamilytree.graph_on_member_created(person, src)

	IntroduceFamilyMember(person)
	AddFamilyIcon(person)
	LateJoinAddToUI(person)
	SSfamilytree.schedule_house_member_resync(src)

	return new_member

/datum/heritage/proc/IntroduceFamilyMember(mob/living/carbon/human/new_person)
	if(!new_person)
		return
	for(var/datum/family_node/node as anything in member_nodes)
		if(!node.person || node.person == new_person)
			continue
		SSfamilytree.introduce_pair(new_person, node.person)

/datum/heritage/proc/AddToFamily(mob/living/carbon/human/person, datum/family_member/parent1, datum/family_member/parent2, adopt = FALSE)
	var/datum/family_member/new_member = CreateFamilyMember(person)
	if(!new_member)
		return FALSE

	var/biological_parentage_allowed = TRUE
	if(!adopt)
		if(parent1 && parent2)
			biological_parentage_allowed = SSfamilytree.familytree_biological_parent_pair_allowed(parent1.person, parent2.person, person, src)
		else
			var/datum/family_member/known_parent = parent1 ? parent1 : parent2
			if(known_parent)
				biological_parentage_allowed = SSfamilytree.familytree_biological_parent_allowed(known_parent.person, person, src)

	new_member.adoption_status = adopt || !biological_parentage_allowed

	if(parent1)
		new_member.AddParent(parent1)
	if(parent2)
		new_member.AddParent(parent2)

	AddFamilyIcon(person)
	to_chat(person, span_notice("Вы были добавлены в семью [housename]."))
	InheritCurses(new_member)
	return new_member

/datum/heritage/proc/MarryMembers(datum/family_member/person1, datum/family_member/person2)
	if(!person1 || !person2)
		return FALSE

	if(person2 in person1.get_spouse_members())
		return FALSE

	person1.AddSpouse(person2)

	if(person1.person && person2.person)
		pass()

	to_chat(person1.person, span_love("Вы теперь в браке с [person2.person?.real_name]!"))
	to_chat(person2.person, span_love("Вы теперь в браке с [person1.person?.real_name]!"))

	return TRUE

/datum/heritage/proc/GetFamilyMember(mob/living/carbon/human/person)
	if(!person)
		return null
	var/datum/family_member/fast = person.family_member_datum
	if(fast && fast.family == src)
		return fast
	for(var/datum/family_member/member as anything in members)
		if(member.person == person)
			return member
	return null

/datum/heritage/proc/ReturnRelation(mob/living/carbon/human/lookee, mob/living/carbon/human/looker)
	if(lookee == looker)
		return null

	var/datum/family_member/looker_member = GetFamilyMember(looker)
	var/datum/family_member/lookee_member = GetFamilyMember(lookee)

	if(!looker_member || !lookee_member)
		return null

	var/relationship = SSfamilytree.get_cached_relation(src, looker_member, lookee_member)
	if(!relationship)
		return null

	var/p_They = lookee.p_they(TRUE)
	var/p_are = lookee.p_are()
	var/relationship_text = "[p_They] [p_are] my [relationship]"

	return span_love(span_bold("[relationship_text]."))

/datum/heritage/proc/GetDisplayHouseTitle()
	var/household = trim("[housename]")
	if(!household)
		return "Nameless House"
	return "THE [uppertext(household)] HOUSE"

/datum/heritage/proc/GetRelationColor(relation_text)
	switch(relation_text)
		if("father", "mother", "parent")
			return "#4169E1"
		if("son", "daughter", "child")
			return "#32CD32"
		if("brother", "sister", "sibling")
			return "#FFD700"
		if("husband", "wife", "spouse")
			return "#FF69B4"
	return "#9370DB"

/datum/heritage/proc/FamilyTreeMemberDisplayName(datum/family_member/member)
	if(!member)
		return null
	if(member.person?.real_name)
		return member.person.real_name
	if(member.phantom)
		return "Unknown"
	return null

/datum/heritage/proc/BuildFamilyTreeParentNames(datum/family_member/member)
	var/list/parent_names = list()
	if(!member || member.phantom)
		return parent_names
	var/has_real_parent = FamilyTreeHasRealParent(member)
	for(var/datum/family_member/parent as anything in member.get_parent_members())
		if(has_real_parent && !parent?.person)
			continue
		var/parent_name = FamilyTreeMemberDisplayName(parent)
		if(parent_name && !(parent_name in parent_names))
			parent_names += parent_name
	return parent_names

/datum/heritage/proc/BuildInLawParentNode(datum/family_member/member, datum/family_member/checker_member)
	if(!member || (!member.person && !member.phantom) || (!member.cosmetic && !member.phantom))
		return null

	var/relation_text = checker_member ? checker_member.GetRelationshipTo(member) : null
	var/list/details = list()
	if(member.phantom)
		details += "Unrecorded ancestor"
	if(member.person?.dna?.species?.name)
		details += member.person.dna.species.name
	var/list/parent_names = BuildFamilyTreeParentNames(member)

	return list(
		"name" = FamilyTreeMemberDisplayName(member) || "Unknown",
		"label" = relation_text ? uppertext(relation_text) : null,
		"details" = details,
		"accentColor" = GetRelationColor(relation_text),
		"isSelf" = FALSE,
		"phantom" = member.phantom,
		"cosmetic" = member.cosmetic,
		"generation" = member.generation,
		"parents" = parent_names,
		"spouses" = list(),
		"children" = list(),
		"personRef" = null,
		"descriptor" = SSfamilytree.familytree_build_member_descriptor(member),
	)

/datum/heritage/proc/FamilyTreeHasRealParent(datum/family_member/member, datum/family_member/ignore_parent = null)
	if(!member)
		return FALSE
	for(var/datum/family_member/parent as anything in member.get_parent_members())
		if(parent == ignore_parent)
			continue
		if(parent?.person)
			return TRUE
	return FALSE

/datum/heritage/proc/FamilyTreeShouldDisplayChild(datum/family_member/parent, datum/family_member/child, list/visited)
	if(!parent || !child || visited?[child])
		return FALSE
	if(parent.phantom && FamilyTreeHasRealParent(child, parent))
		return FALSE
	return TRUE

/datum/heritage/proc/BuildFamilyDisplayEntry(datum/family_member/checker_member, datum/family_member/member)
	if(!member?.person)
		return null

	var/relation_text = ""
	if(checker_member)
		relation_text = checker_member.GetRelationshipTo(member)

	var/list/details = list()
	if(member.adoption_status && !member.cosmetic)
		details += "Adopted"
	if(member.cosmetic)
		details += "NPC"
	var/list/parent_names = BuildFamilyTreeParentNames(member)
	if(parent_names.len)
		details += "Parents: [jointext(parent_names, ", ")]"
	var/list/member_spouses_list = member.get_spouse_members()
	if(member_spouses_list.len)
		var/list/spouse_names = list()
		for(var/datum/family_member/spouse as anything in member_spouses_list)
			if(spouse.person?.real_name)
				spouse_names += spouse.person.real_name
		if(spouse_names.len)
			details += "Married to: [jointext(spouse_names, ", ")]"

	var/entry_ref = (!member.cosmetic && !member.phantom) ? REF(member.person) : null
	var/entry_descriptor = SSfamilytree.familytree_build_member_descriptor(member)

	return list(
		"name" = member.person.real_name,
		"label" = relation_text ? uppertext(relation_text) : null,
		"details" = details,
		"accentColor" = GetRelationColor(relation_text),
		"personRef" = entry_ref,
		"descriptor" = entry_descriptor,
	)

/datum/heritage/proc/OpenCursePanel(mob/living/carbon/human/user)
	if(!user || !family_curses.len)
		return FALSE

	var/datum/familytree_display_panel/panel = new(
		user,
		"Family Modifier Details",
		GetDisplayHouseTitle(),
		"No family modifiers are active.",
	)

	var/list/entries = list()
	for(var/datum/family_curse/curse as anything in family_curses)
		var/list/details = list()
		if(curse.description)
			details += curse.description
		if(curse.cursed_by)
			var/mob/curser = curse.cursed_by.resolve()
			if(curser?.real_name)
				details += "[curse.blessing ? "Blessed" : "Cursed"] by: [curser.real_name]"
		details += "Severity: [curse.severity]/3"
		details += "Time cursed: [DisplayTimeText(world.time - curse.when_cursed)] ago"

		entries += list(list(
			"name" = curse.name,
			"label" = curse.blessing ? "BLESSING" : "CURSE",
			"details" = details,
			"accentColor" = curse.blessing ? "#4CAF50" : "#C62828",
		))

	panel.add_section("Current Modifiers", entries)
	panel.ui_interact(user)
	return TRUE

/datum/heritage/proc/GetMemberForPerson(mob/living/carbon/human/P)
	if(!P)
		return null
	var/datum/family_member/fast = P.family_member_datum
	if(fast && fast.family == src)
		return fast
	for(var/datum/family_member/member as anything in members)
		if(member.person == P)
			return member
	return null

/datum/heritage/proc/GetGenerationName(generation)
	switch(generation)
		if(0)
			return "Founders"
		if(1)
			return "First Generation"
		if(2)
			return "Second Generation"
		if(3)
			return "Third Generation"
		if(4)
			return "Fourth Generation"
		else
			return "Generation [generation]"

/datum/heritage/proc/BuildFamilyTree(datum/family_member/root_member, datum/family_member/checker_member, list/visited = null, depth = 0, include_spouses = TRUE, include_children = TRUE, list/spouse_seen = null)
	if(!root_member)
		return null
	if(!visited)
		visited = list()
	if(!spouse_seen)
		spouse_seen = list()
	if(visited[root_member])
		return null
	visited[root_member] = TRUE

	var/relation_text = checker_member ? checker_member.GetRelationshipTo(root_member) : null
	var/list/details = list()
	if(root_member == checker_member)
		details += "You"
	if(root_member.adoption_status && !root_member.cosmetic)
		details += "Adopted"
	if(root_member.phantom)
		details += "Unrecorded ancestor"
	if(root_member.person?.dna?.species?.name)
		details += root_member.person.dna.species.name
	var/list/parent_names = BuildFamilyTreeParentNames(root_member)
	var/node_ref = (root_member.person && !root_member.cosmetic && !root_member.phantom) ? REF(root_member.person) : null
	var/node_descriptor = (root_member.person && !root_member.phantom) ? SSfamilytree.familytree_build_member_descriptor(root_member) : null

	var/list/node = list(
		"name" = root_member.person ? root_member.person.real_name : "Unknown",
		"label" = relation_text ? uppertext(relation_text) : null,
		"details" = details,
		"accentColor" = GetRelationColor(relation_text),
		"isSelf" = (root_member == checker_member),
		"phantom" = root_member.phantom,
		"cosmetic" = root_member.cosmetic,
		"generation" = root_member.generation,
		"parents" = parent_names,
		"spouses" = list(),
		"children" = list(),
		"personRef" = node_ref,
		"descriptor" = node_descriptor,
	)

	if(depth >= 24)
		var/list/node_details = node["details"]
		node_details += "Tree depth limit"
		return node

	if(include_spouses)
		for(var/datum/family_member/spouse as anything in root_member.get_spouse_members())
			if(!spouse || visited[spouse])
				continue
			var/list/spouse_node = BuildFamilyTree(spouse, checker_member, visited, depth + 1, FALSE, FALSE, spouse_seen)
			if(spouse_node)
				spouse_seen[spouse] = TRUE
				var/list/spouse_parent_nodes = list()
				for(var/datum/family_member/sp_parent as anything in spouse.get_parent_members())
					if(!sp_parent?.cosmetic && !sp_parent?.phantom)
						continue
					if(visited[sp_parent])
						continue
					var/list/sp_parent_node = BuildInLawParentNode(sp_parent, checker_member)
					if(!sp_parent_node)
						continue
					visited[sp_parent] = TRUE
					spouse_parent_nodes += list(sp_parent_node)
				if(spouse_parent_nodes.len)
					spouse_node["parentNodes"] = spouse_parent_nodes
				node["spouses"] += list(spouse_node)

	if(include_children)
		for(var/datum/family_member/child as anything in root_member.get_child_members())
			if(!FamilyTreeShouldDisplayChild(root_member, child, visited))
				continue
			var/list/child_node = BuildFamilyTree(child, checker_member, visited, depth + 1, TRUE, TRUE, spouse_seen)
			if(child_node)
				node["children"] += list(child_node)

	var/list/node_spouses = node["spouses"]
	var/list/node_children = node["children"]
	if(root_member.phantom && !root_member.cosmetic && !node_spouses.len && !node_children.len)
		return null

	return node

/datum/heritage/proc/FamilyTreeHasUnvisitedDisplayContent(datum/family_member/member, list/visited, list/spouse_seen, include_self = TRUE, list/checking = null, depth = 0)
	if(!member || depth > 24)
		return FALSE
	if(!visited)
		visited = list()
	if(!spouse_seen)
		spouse_seen = list()
	if(!checking)
		checking = list()
	if(checking[member])
		return FALSE
	checking[member] = TRUE

	if(include_self && !visited[member] && !spouse_seen[member])
		return TRUE

	for(var/datum/family_member/child as anything in member.get_child_members())
		if(!child)
			continue
		if(!visited[child] && !spouse_seen[child])
			return TRUE
		if(FamilyTreeHasUnvisitedDisplayContent(child, visited, spouse_seen, FALSE, checking, depth + 1))
			return TRUE

	for(var/datum/family_member/spouse as anything in member.get_spouse_members())
		if(!spouse)
			continue
		if(!visited[spouse] && !spouse_seen[spouse])
			return TRUE
		if(FamilyTreeHasUnvisitedDisplayContent(spouse, visited, spouse_seen, FALSE, checking, depth + 1))
			return TRUE

	return FALSE

/datum/heritage/proc/SortFamilyTreeRoots(list/candidates)
	if(!length(candidates))
		return list()

	var/list/with_desc_depth = list()
	for(var/datum/family_member/member as anything in candidates)
		if(!member)
			continue
		with_desc_depth[member] = CountDescendantDepth(member)

	var/list/sorted = candidates.Copy()
	var/n = length(sorted)
	for(var/i = 1, i <= n - 1, i++)
		for(var/j = 1, j <= n - i, j++)
			var/datum/family_member/a = sorted[j]
			var/datum/family_member/b = sorted[j + 1]
			if(FamilyRootSortLess(b, a, with_desc_depth))
				sorted[j] = b
				sorted[j + 1] = a
	return sorted

/datum/heritage/proc/PrioritizeFamilyTreeRootsForChecker(list/candidates, datum/family_member/checker_member)
	if(!length(candidates) || !checker_member)
		return candidates

	var/list/checker_roots = list()
	var/list/other_roots = list()
	for(var/datum/family_member/root as anything in candidates)
		if(root == checker_member || checker_member.IsDescendantOf(root))
			checker_roots += root
		else
			other_roots += root

	if(!checker_roots.len)
		return candidates

	checker_roots += other_roots
	return checker_roots

/datum/heritage/proc/FamilyRootSortLess(datum/family_member/a, datum/family_member/b, list/depth_cache)
	var/a_gen = a?.generation
	var/b_gen = b?.generation
	if(isnull(a_gen))
		a_gen = 0
	if(isnull(b_gen))
		b_gen = 0
	if(a_gen != b_gen)
		return a_gen < b_gen

	var/a_depth = depth_cache?[a] || 0
	var/b_depth = depth_cache?[b] || 0
	if(a_depth != b_depth)
		return a_depth > b_depth

	var/a_idx = members.Find(a)
	var/b_idx = members.Find(b)
	return a_idx < b_idx

/datum/heritage/proc/CountDescendantDepth(datum/family_member/member, list/seen = null, depth = 0)
	if(!member || depth > 24)
		return depth
	if(!seen)
		seen = list()
	if(seen[member])
		return depth
	seen[member] = TRUE
	var/max_depth = depth
	for(var/datum/family_member/child as anything in member.get_child_members())
		if(!child || seen[child])
			continue
		var/child_depth = CountDescendantDepth(child, seen, depth + 1)
		if(child_depth > max_depth)
			max_depth = child_depth
	return max_depth

/datum/heritage/proc/BuildFamilyTreeRoots(mob/living/carbon/human/checker)
	var/list/tree_roots = list()
	if(!members.len)
		return tree_roots

	var/datum/family_member/checker_member = GetMemberForPerson(checker)
	var/list/visited = list()
	var/list/spouse_seen = list()
	var/list/root_candidates = list()

	for(var/datum/family_member/member as anything in members)
		if(!member)
			continue
		if(member.get_parent_members().len)
			continue
		if(!member.person && !member.get_child_members().len)
			continue
		root_candidates += member

	if(!root_candidates.len)
		if(founder)
			root_candidates += founder
		else if(house_leader)
			root_candidates += house_leader
		else if(members.len)
			root_candidates += members[1]

	root_candidates = SortFamilyTreeRoots(root_candidates)
	root_candidates = PrioritizeFamilyTreeRootsForChecker(root_candidates, checker_member)

	for(var/datum/family_member/root as anything in root_candidates)
		if(spouse_seen[root] && !FamilyTreeHasUnvisitedDisplayContent(root, visited, spouse_seen, FALSE))
			continue
		var/list/root_node = BuildFamilyTree(root, checker_member, visited, 0, TRUE, TRUE, spouse_seen)
		if(root_node)
			tree_roots += list(root_node)

	for(var/datum/family_member/member as anything in members)
		if(!member?.person || visited[member])
			continue
		if(spouse_seen[member] && !FamilyTreeHasUnvisitedDisplayContent(member, visited, spouse_seen, FALSE))
			continue
		var/list/orphan_node = BuildFamilyTree(member, checker_member, visited, 0, TRUE, TRUE, spouse_seen)
		if(orphan_node)
			tree_roots += list(orphan_node)

	return tree_roots

/datum/heritage/proc/AddFamilyDisplaySections(datum/familytree_display_panel/panel, mob/living/carbon/human/checker)
	if(!panel || !members.len)
		return FALSE

	var/datum/family_member/checker_member = GetMemberForPerson(checker)
	var/list/by_generation = list()
	var/list/generation_order = list()

	for(var/datum/family_member/member as anything in members)
		var/gen_key = "[member.generation]"
		if(!by_generation[gen_key])
			by_generation[gen_key] = list()
			generation_order += member.generation
		by_generation[gen_key] += member

	generation_order = sortList(generation_order, GLOBAL_PROC_REF(cmp_numeric_asc))

	var/added_sections = FALSE
	for(var/generation as anything in generation_order)
		var/list/entries = list()
		for(var/datum/family_member/member as anything in by_generation["[generation]"])
			if(member.phantom)
				continue
			var/list/entry = BuildFamilyDisplayEntry(checker_member, member)
			if(entry)
				entries += list(entry)
		if(!entries.len)
			continue
		panel.add_section(GetGenerationName(generation), entries)
		added_sections = TRUE

	return added_sections

/datum/heritage/proc/ListFamily(mob/living/carbon/human/checker)
	if(!checker)
		return FALSE
	if(!member_nodes.len)
		return FALSE

	var/datum/familytree_display_panel/panel = new(
		checker,
		GetDisplayHouseTitle(),
		"",
		"No family members found.",
	)

	panel.set_tree_data(SSfamilytree.get_display_tree_for(src, checker))
	panel.ui_interact(checker)
	return TRUE

/datum/heritage/proc/SpeciesCalculation(mob/living/carbon/human/child, mob/living/carbon/human/parent1, mob/living/carbon/human/parent2)
	var/child_species_type = child.dna?.species?.type
	var/parent1_species_type = parent1.dna?.species?.type
	var/parent2_species_type = parent2.dna?.species?.type

	if(!child_species_type || !parent1_species_type || !parent2_species_type)
		return FALSE

	if(child_species_type == parent1_species_type && child_species_type == parent2_species_type)
		return TRUE

	if((parent1_species_type == /datum/species/tieberian) || (parent2_species_type == /datum/species/tieberian))
		return child_species_type == /datum/species/tieberian

	var/parent1_is_human = (parent1_species_type == /datum/species/human/northern)
	var/parent2_is_human = (parent2_species_type == /datum/species/human/northern)
	var/parent1_is_elf = ispath(parent1_species_type, /datum/species/elf)
	var/parent2_is_elf = ispath(parent2_species_type, /datum/species/elf)
	var/parent1_is_halfelf = (parent1_species_type == /datum/species/human/halfelf)
	var/parent2_is_halfelf = (parent2_species_type == /datum/species/human/halfelf)
	var/parent1_is_orcish = ispath(parent1_species_type, /datum/species/orc) || (parent1_species_type == /datum/species/halforc)
	var/parent2_is_orcish = ispath(parent2_species_type, /datum/species/orc) || (parent2_species_type == /datum/species/halforc)

	if(child_species_type == /datum/species/human/halfelf)
		return (parent1_is_human && parent2_is_elf) || (parent2_is_human && parent1_is_elf) \
			|| (parent1_is_halfelf || parent2_is_halfelf) \
			|| (parent1_is_human && parent2_is_halfelf) || (parent2_is_human && parent1_is_halfelf) \
			|| (parent1_is_elf && parent2_is_halfelf) || (parent2_is_elf && parent1_is_halfelf)

	if(child_species_type == /datum/species/halforc)
		return (parent1_is_human && parent2_is_orcish) || (parent2_is_human && parent1_is_orcish)

	if(child_species_type == /datum/species/human/northern)
		return (parent1_is_human || parent1_is_halfelf || parent1_species_type == /datum/species/halforc) \
			&& (parent2_is_human || parent2_is_halfelf || parent2_species_type == /datum/species/halforc)

	if(ispath(child_species_type, /datum/species/elf))
		return (parent1_is_elf || parent1_is_halfelf) && (parent2_is_elf || parent2_is_halfelf)

	if(ispath(child_species_type, /datum/species/orc))
		return parent1_is_orcish && parent2_is_orcish

	return FALSE

/datum/heritage/proc/SingleParentSpeciesCalculation(mob/living/carbon/human/child, mob/living/carbon/human/parent)
	var/child_species_type = child.dna?.species?.type
	var/parent_species_type = parent.dna?.species?.type

	if(!child_species_type || !parent_species_type)
		return FALSE

	if(child_species_type == parent_species_type)
		return TRUE

	var/child_is_human = (child_species_type == /datum/species/human/northern)
	var/child_is_elf = ispath(child_species_type, /datum/species/elf)
	var/child_is_halfelf = (child_species_type == /datum/species/human/halfelf)
	var/child_is_halforc = (child_species_type == /datum/species/halforc)
	var/child_is_tiefling = (child_species_type == /datum/species/tieberian)

	var/parent_is_human = (parent_species_type == /datum/species/human/northern)
	var/parent_is_elf = ispath(parent_species_type, /datum/species/elf)
	var/parent_is_halfelf = (parent_species_type == /datum/species/human/halfelf)
	var/parent_is_orcish = ispath(parent_species_type, /datum/species/orc) || (parent_species_type == /datum/species/halforc)
	var/parent_is_halforc = (parent_species_type == /datum/species/halforc)
	var/parent_is_tiefling = (parent_species_type == /datum/species/tieberian)

	if(child_is_tiefling)
		return parent_is_tiefling

	if(child_is_halfelf)
		return parent_is_human || parent_is_elf || parent_is_halfelf

	if(child_is_halforc)
		return parent_is_human || parent_is_orcish

	if(child_is_human)
		return parent_is_human || parent_is_halfelf || parent_is_halforc

	if(child_is_elf)
		return parent_is_elf || parent_is_halfelf

	if(ispath(child_species_type, /datum/species/orc))
		return parent_is_orcish

	return FALSE

/datum/heritage/proc/SurnameFormatting(mob/living/carbon/human/person)
	var/surname2use
	var/index = findtext(person?.real_name, " ")
	person?.original_name = person?.real_name
	if(!index)
		surname2use = person?.dna?.species?.random_surname()
	else
		if(findtext(person?.real_name, " of ") || findtext(person?.real_name, " the "))
			surname2use = person?.dna?.species?.random_surname()
		else
			surname2use = copytext(person?.real_name, index + 1)
	return surname2use

/datum/heritage/proc/ApplyUI(mob/living/carbon/human/iconer, toggle_true = FALSE)
	if(!iconer.client)
		return FALSE
	for(var/mob/living/carbon/human/H as anything in family_icons)
		if(toggle_true)
			iconer.client.images.Remove(family_icons[H])
			continue
		if(!H || H == iconer)
			continue
		iconer.client.images.Add(family_icons[H])

/datum/heritage/proc/LateJoinAddToUI(mob/living/carbon/human/new_fam)
	for(var/datum/family_node/node as anything in member_nodes)
		var/mob/living/carbon/human/H = node.person
		if(H && H.family_UI && H.client && H != new_fam)
			if(new_fam in family_icons)
				H.client.images.Add(family_icons[new_fam])
		if(new_fam?.family_UI && new_fam.client && H && H != new_fam)
			if(H in family_icons)
				new_fam.client.images.Add(family_icons[H])

/datum/heritage/proc/AddFamilyIcon(mob/living/carbon/human/famicon)
	var/datum/family_member/member = GetFamilyMember(famicon)
	if(!member)
		return FALSE

	var/icon_state = member.adoption_status ? "adopted" : "related"
	var/image/I = new('modular_twilight_axis/familytree_module/relations.dmi', loc = famicon, icon_state = icon_state)

	if(famicon in family_icons)
		var/image/old_icon = family_icons[famicon]
		if(old_icon)
			for(var/datum/family_node/viewer_node as anything in member_nodes)
				if(viewer_node.person?.client)
					viewer_node.person.client.images.Remove(old_icon)
		family_icons.Remove(famicon)
	family_icons[famicon] = I

	return TRUE
