/datum/family_node
	var/tmp/mob/living/carbon/human/person
	var/datum/heritage/primary_house
	var/revision = 0

/datum/family_node/New(mob/living/carbon/human/new_person, datum/heritage/house)
	person = new_person
	primary_house = house
	revision = 0

/datum/family_node/Destroy(force)
	person = null
	primary_house = null
	return ..()

/datum/family_node/proc/bump_revision()
	revision++

/datum/family_graph_cache
	var/datum/heritage/owner_house
	var/dirty_relations = TRUE
	var/dirty_generations = TRUE
	var/dirty_display = TRUE
	var/revision = 0
	var/list/relation_matrix = list()
	var/list/generation_buckets = list()
	var/list/display_tree_by_checker = list()
	var/list/display_sections = list()

/datum/family_graph_cache/New(datum/heritage/house)
	owner_house = house

/datum/family_graph_cache/Destroy(force)
	owner_house = null
	relation_matrix = null
	generation_buckets = null
	display_tree_by_checker = null
	display_sections = null
	return ..()

/datum/family_graph_cache/proc/mark_dirty(relations = TRUE, generations = TRUE, display = TRUE)
	if(relations)
		dirty_relations = TRUE
	if(generations)
		dirty_generations = TRUE
	if(display)
		dirty_display = TRUE
		display_tree_by_checker = list()
	revision++

/datum/family_graph_cache/proc/mark_all_dirty()
	dirty_relations = TRUE
	dirty_generations = TRUE
	dirty_display = TRUE
	display_tree_by_checker = list()
	revision++

/datum/controller/subsystem/familytree/proc/graph_validate_node(datum/family_node/node, list/out_issues)
	if(!node || !out_issues)
		return 0
	var/issues = 0
	var/label = node.person?.real_name || "unowned_node"

	var/datum/bond_actor/subject = SSbonds.resolve_actor(node.person)
	if(!subject)
		return 0

	for(var/datum/social_bond/kin/link as anything in SSbonds.kin_links_of_kind(subject, null))
		if(!link.other)
			out_issues += "[label]: kin link [link.kind] has no other end"
			issues++
			continue
		if(link.other == subject)
			out_issues += "[label]: self kin link [link.kind]"
			issues++
			continue
		var/datum/social_bond/kin/mirror = SSbonds.find_kin(link.other, subject, bonds_kin_reciprocal(link.kind))
		if(!mirror)
			out_issues += "[label]: kin link [link.kind] to [link.other.name_of()] has no reciprocal"
			issues++
			continue
		if(mirror.adopted != link.adopted)
			out_issues += "[label]: kin link [link.kind] to [link.other.name_of()] disagrees on adoption"
			issues++

	issues += graph_validate_no_parent_cycle(node, out_issues)
	return issues

/datum/controller/subsystem/familytree/proc/graph_validate_no_parent_cycle(datum/family_node/node, list/out_issues)
	if(!node || !out_issues)
		return 0
	var/datum/bond_actor/subject = SSbonds.resolve_actor(node.person)
	if(!subject)
		return 0
	for(var/datum/bond_actor/parent as anything in SSbonds.kin_of_kind(subject, BOND_KIN_PARENT))
		if(SSbonds.kin_would_cycle(subject, parent))
			out_issues += "[node.person?.real_name || "node"]: parent cycle through [parent.name_of()]"
			return 1
	return 0

/datum/controller/subsystem/familytree/proc/graph_validate_after_mutation(datum/family_node/node_a, datum/family_node/node_b)
#ifdef FAMILYTREE_DEBUG_LOGGING
	var/list/issues = list()
	if(node_a)
		graph_validate_node(node_a, issues)
	if(node_b && node_b != node_a)
		graph_validate_node(node_b, issues)
	if(issues.len)
		for(var/issue in issues)
			ftlog("GRAPH VALIDATION: [issue]", FTLOG_ERROR)
#endif
	return

/datum/controller/subsystem/familytree/proc/graph_validate_house(datum/heritage/house, list/out_issues)
	if(!house || !out_issues)
		return 0
	var/issues = 0
	var/list/house_nodes = list()
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person)
			continue
		var/datum/family_node/node = get_family_node(member.person)
		if(!node)
			out_issues += "[house.housename || "Unnamed"]: member [member.person.real_name] has no graph node"
			issues++
			continue
		if(node in house_nodes)
			out_issues += "[house.housename || "Unnamed"]: duplicate node for [member.person.real_name]"
			issues++
			continue
		house_nodes += node
		if(node.primary_house && node.primary_house != house)
			out_issues += "[house.housename || "Unnamed"]: [member.person.real_name] primary_house is [node.primary_house.housename || "Unnamed"]"
			issues++
		issues += graph_validate_node(node, out_issues)
	return issues

/datum/controller/subsystem/familytree/proc/graph_compare_house(datum/heritage/house, list/out_mismatches)
	if(!house || !out_mismatches)
		return 0
	return graph_validate_house(house, out_mismatches)

/datum/controller/subsystem/familytree/proc/graph_compare_all(list/out_mismatches)
	if(!out_mismatches)
		return 0
	var/total = 0
	if(ruling_family)
		total += graph_compare_house(ruling_family, out_mismatches)
	for(var/datum/heritage/house as anything in families)
		total += graph_compare_house(house, out_mismatches)
	return total

/datum/controller/subsystem/familytree/proc/graph_state_summary()
	return "nodes=[family_nodes.len] node_lookup=[family_nodes_by_person.len] caches=[family_graph_caches.len]"

/client/proc/familytree_graph_compare()
	set name = "FamilyTree Graph Compare"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/list/mismatches = list()
	var/count = SSfamilytree.graph_compare_all(mismatches)
	var/summary = SSfamilytree.graph_state_summary()
	to_chat(src, span_notice("FamilyTree graph: [summary]"))
	to_chat(src, span_notice("Legacy vs graph mismatches: [count]"))
	if(count && mismatches.len)
		var/limit = min(mismatches.len, 40)
		for(var/i in 1 to limit)
			to_chat(src, span_warning(mismatches[i]))
		if(mismatches.len > limit)
			to_chat(src, span_warning("... [mismatches.len - limit] more omitted"))
