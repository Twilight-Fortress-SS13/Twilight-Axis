/datum/family_edge
	var/datum/family_node/a
	var/datum/family_node/b
	var/relation_type
	var/relation_flags = 0
	var/datum/heritage/house
	var/created_at = 0
	var/source = "system"
	var/preserved_relation_a_to_b
	var/preserved_relation_b_to_a

/datum/family_edge/New(datum/family_node/from_node, datum/family_node/to_node, rel_type, datum/heritage/edge_house, flags = 0, edge_source = "system")
	a = from_node
	b = to_node
	relation_type = rel_type
	relation_flags = flags
	house = edge_house
	source = edge_source
	created_at = world.time

/datum/family_edge/Destroy(force)
	if(a)
		a.edges -= src
	if(b && b != a)
		b.edges -= src
	a = null
	b = null
	house = null
	return ..()

/datum/family_edge/proc/connects(datum/family_node/node_a, datum/family_node/node_b, directed = FALSE)
	if(directed)
		return (a == node_a && b == node_b)
	return ((a == node_a && b == node_b) || (a == node_b && b == node_a))

/datum/family_edge/proc/other_end(datum/family_node/node)
	if(a == node)
		return b
	if(b == node)
		return a
	return null

/datum/family_node
	var/tmp/mob/living/carbon/human/person
	var/datum/heritage/primary_house
	var/list/edges = list()
	var/revision = 0

/datum/family_node/New(mob/living/carbon/human/new_person, datum/heritage/house)
	person = new_person
	primary_house = house
	revision = 0

/datum/family_node/Destroy(force)
	for(var/datum/family_edge/edge as anything in edges.Copy())
		qdel(edge)
	edges = null
	person = null
	primary_house = null
	return ..()

/datum/family_node/proc/bump_revision()
	revision++

/datum/family_node/proc/get_edges_of_type(relation_type)
	var/list/matches = list()
	for(var/datum/family_edge/edge as anything in edges)
		if(edge.relation_type == relation_type)
			matches += edge
	return matches

/datum/family_node/proc/has_edge_to(datum/family_node/other, relation_type, directed = FALSE)
	if(!other)
		return FALSE
	for(var/datum/family_edge/edge as anything in edges)
		if(relation_type && edge.relation_type != relation_type)
			continue
		if(edge.connects(src, other, directed))
			return TRUE
	return FALSE

/datum/family_node/proc/find_edge_to(datum/family_node/other, relation_type, directed = FALSE)
	if(!other)
		return null
	for(var/datum/family_edge/edge as anything in edges)
		if(relation_type && edge.relation_type != relation_type)
			continue
		if(edge.connects(src, other, directed))
			return edge
	return null

/datum/family_node/proc/neighbors_by_type(relation_type)
	var/list/out = list()
	for(var/datum/family_edge/edge as anything in edges)
		if(relation_type && edge.relation_type != relation_type)
			continue
		var/datum/family_node/other = edge.other_end(src)
		if(other && !(other in out))
			out += other
	return out

/datum/family_node/proc/get_parent_nodes()
	var/list/out = list()
	for(var/datum/family_edge/edge as anything in edges)
		if(edge.relation_type != "parent_child" && edge.relation_type != "adoptive_parent_child")
			continue
		if(edge.b != src)
			continue
		if(edge.a && !(edge.a in out))
			out += edge.a
	return out

/datum/family_node/proc/get_child_nodes()
	var/list/out = list()
	for(var/datum/family_edge/edge as anything in edges)
		if(edge.relation_type != "parent_child" && edge.relation_type != "adoptive_parent_child")
			continue
		if(edge.a != src)
			continue
		if(edge.b && !(edge.b in out))
			out += edge.b
	return out

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

	for(var/datum/family_edge/edge as anything in node.edges)
		if(!edge)
			out_issues += "[label]: null edge in node.edges"
			issues++
			continue
		if(edge.a == edge.b)
			out_issues += "[label]: self-edge [edge.relation_type]"
			issues++
			continue
		if(edge.a != node && edge.b != node)
			out_issues += "[label]: edge [edge.relation_type] does not reference this node"
			issues++
			continue
		var/datum/family_node/other = edge.other_end(node)
		if(!other)
			out_issues += "[label]: edge [edge.relation_type] has null other end"
			issues++
			continue
		if(!(edge in other.edges))
			out_issues += "[label]: edge [edge.relation_type] missing on other end [other.person?.real_name || "unowned"]"
			issues++

	issues += graph_validate_no_parent_cycle(node, out_issues)
	return issues

/datum/controller/subsystem/familytree/proc/graph_validate_no_parent_cycle(datum/family_node/node, list/out_issues)
	if(!node || !out_issues)
		return 0
	var/list/visited = list(node)
	var/list/queue = list()
	for(var/datum/family_edge/edge as anything in node.edges)
		if(edge.relation_type != "parent_child" && edge.relation_type != "adoptive_parent_child")
			continue
		if(edge.b != node)
			continue
		queue += edge.a

	while(queue.len)
		var/datum/family_node/current = queue[1]
		queue.Cut(1, 2)
		if(!current)
			continue
		if(current == node)
			out_issues += "[node.person?.real_name || "node"]: parent_child cycle detected"
			return 1
		if(current in visited)
			continue
		visited += current
		for(var/datum/family_edge/up_edge as anything in current.edges)
			if(up_edge.relation_type != "parent_child" && up_edge.relation_type != "adoptive_parent_child")
				continue
			if(up_edge.b != current)
				continue
			queue += up_edge.a
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
	return "nodes=[family_nodes.len] edges=[family_edges.len] node_lookup=[family_nodes_by_person.len] caches=[family_graph_caches.len]"

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
