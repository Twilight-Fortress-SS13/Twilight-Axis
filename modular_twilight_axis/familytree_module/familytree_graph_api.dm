/datum/controller/subsystem/familytree/var/list/family_nodes = list()
/datum/controller/subsystem/familytree/var/list/family_nodes_by_person = list()
/datum/controller/subsystem/familytree/var/list/family_edges = list()
/datum/controller/subsystem/familytree/var/list/family_graph_caches = list()

/datum/controller/subsystem/familytree/proc/get_family_node(mob/living/carbon/human/person)
	if(!person)
		return null
	return family_nodes_by_person[person]

/datum/controller/subsystem/familytree/proc/get_or_create_family_node(mob/living/carbon/human/person, datum/heritage/house)
	if(!person)
		return null
	var/datum/family_node/node = family_nodes_by_person[person]
	if(node)
		if(house && !node.primary_house)
			node.primary_house = house
		return node
	node = new /datum/family_node(person, house)
	family_nodes += node
	family_nodes_by_person[person] = node
	if(house)
		mark_family_dirty(node, null, house)
	return node

/datum/controller/subsystem/familytree/proc/remove_family_node(datum/family_node/node)
	if(!node)
		return FALSE
	if(node.primary_house)
		node.primary_house.member_nodes -= node
	if(node.person)
		family_nodes_by_person -= node.person
	family_nodes -= node
	for(var/datum/family_edge/edge as anything in node.edges.Copy())
		remove_family_edge(edge, "node_removed")
	qdel(node)
	return TRUE

/datum/controller/subsystem/familytree/proc/add_family_edge(datum/family_node/node_a, datum/family_node/node_b, relation_type, datum/heritage/house, flags = 0, source = "system", directed = FALSE)
	if(!node_a || !node_b || node_a == node_b || !relation_type)
		return null
	if(node_a.has_edge_to(node_b, relation_type, directed))
		return node_a.find_edge_to(node_b, relation_type, directed)
	var/datum/family_edge/edge = new /datum/family_edge(node_a, node_b, relation_type, house, flags, source)
	node_a.edges += edge
	if(node_b != node_a)
		node_b.edges += edge
	family_edges += edge
	node_a.bump_revision()
	node_b.bump_revision()
	mark_family_dirty(node_a, node_b, house)
#ifdef FAMILYTREE_DEBUG_LOGGING
	ftlog("GRAPH +edge [relation_type] [node_a.person?.real_name || "phantom"] -> [node_b.person?.real_name || "phantom"] house='[house?.housename || "none"]' source=[source] directed=[directed]", FTLOG_DEBUG)
	graph_validate_after_mutation(node_a, node_b)
#endif
	return edge

/datum/controller/subsystem/familytree/proc/remove_family_edge(datum/family_edge/edge, source = "system")
	if(!edge)
		return FALSE
	var/datum/family_node/node_a = edge.a
	var/datum/family_node/node_b = edge.b
	var/datum/heritage/edge_house = edge.house
	family_edges -= edge
	if(node_a)
		node_a.edges -= edge
		node_a.bump_revision()
	if(node_b && node_b != node_a)
		node_b.edges -= edge
		node_b.bump_revision()
	mark_family_dirty(node_a, node_b, edge_house)
#ifdef FAMILYTREE_DEBUG_LOGGING
	ftlog("GRAPH -edge [edge.relation_type] [node_a?.person?.real_name || "phantom"] -> [node_b?.person?.real_name || "phantom"] source=[source]", FTLOG_DEBUG)
	graph_validate_after_mutation(node_a, node_b)
#endif
	qdel(edge)
	return TRUE

/datum/controller/subsystem/familytree/proc/find_family_edge(datum/family_node/node_a, datum/family_node/node_b, relation_type, directed = FALSE)
	if(!node_a)
		return null
	return node_a.find_edge_to(node_b, relation_type, directed)

/datum/controller/subsystem/familytree/proc/get_edges_for_person(mob/living/carbon/human/person, relation_type)
	var/datum/family_node/node = get_family_node(person)
	if(!node)
		return list()
	if(!relation_type)
		return node.edges.Copy()
	return node.get_edges_of_type(relation_type)

/datum/controller/subsystem/familytree/proc/is_preservable_relationship_label(relation)
	return istext(relation) && length(relation) && relation != "distant relative"

/datum/controller/subsystem/familytree/proc/preserve_player_relationship(datum/family_member/member_a, datum/family_member/member_b, relation_a_to_b, relation_b_to_a, datum/heritage/house)
	if(!member_a?.person || !member_b?.person || member_a == member_b)
		return FALSE
	if(!is_preservable_relationship_label(relation_a_to_b) && !is_preservable_relationship_label(relation_b_to_a))
		return FALSE
	var/datum/family_node/node_a = get_or_create_family_node(member_a.person, house)
	var/datum/family_node/node_b = get_or_create_family_node(member_b.person, house)
	if(!node_a || !node_b)
		return FALSE
	var/datum/family_edge/edge = find_family_edge(node_a, node_b, "preserved_relation", FALSE)
	if(!edge)
		edge = add_family_edge(node_a, node_b, "preserved_relation", house, 0, "player_bridge_removed", FALSE)
	if(!edge)
		return FALSE
	if(edge.a == node_a)
		if(is_preservable_relationship_label(relation_a_to_b))
			edge.preserved_relation_a_to_b = relation_a_to_b
		if(is_preservable_relationship_label(relation_b_to_a))
			edge.preserved_relation_b_to_a = relation_b_to_a
	else
		if(is_preservable_relationship_label(relation_a_to_b))
			edge.preserved_relation_b_to_a = relation_a_to_b
		if(is_preservable_relationship_label(relation_b_to_a))
			edge.preserved_relation_a_to_b = relation_b_to_a
	mark_family_dirty(node_a, node_b, house)
	return TRUE

/datum/controller/subsystem/familytree/proc/get_preserved_relationship(mob/living/carbon/human/from_person, mob/living/carbon/human/to_person)
	if(!from_person || !to_person || from_person == to_person)
		return null
	var/datum/family_node/from_node = get_family_node(from_person)
	var/datum/family_node/to_node = get_family_node(to_person)
	if(!from_node || !to_node)
		return null
	for(var/datum/family_edge/edge as anything in from_node.get_edges_of_type("preserved_relation"))
		if(edge.other_end(from_node) != to_node)
			continue
		if(edge.a == from_node)
			return edge.preserved_relation_a_to_b
		return edge.preserved_relation_b_to_a
	return null

/datum/controller/subsystem/familytree/proc/get_family_graph_cache(datum/heritage/house, create_if_missing = TRUE)
	if(!house)
		return null
	var/datum/family_graph_cache/cache = family_graph_caches[house]
	if(cache)
		return cache
	if(!create_if_missing)
		return null
	cache = new /datum/family_graph_cache(house)
	family_graph_caches[house] = cache
	return cache

/datum/controller/subsystem/familytree/proc/mark_family_dirty(datum/family_node/node_a, datum/family_node/node_b, datum/heritage/house)
	if(house)
		var/datum/family_graph_cache/cache = get_family_graph_cache(house, TRUE)
		if(cache)
			cache.mark_all_dirty()
	if(node_a?.primary_house && node_a.primary_house != house)
		var/datum/family_graph_cache/cache_a = get_family_graph_cache(node_a.primary_house, TRUE)
		if(cache_a)
			cache_a.mark_all_dirty()
	if(node_b?.primary_house && node_b.primary_house != house && node_b.primary_house != node_a?.primary_house)
		var/datum/family_graph_cache/cache_b = get_family_graph_cache(node_b.primary_house, TRUE)
		if(cache_b)
			cache_b.mark_all_dirty()

/datum/controller/subsystem/familytree/proc/get_display_tree_for(datum/heritage/house, mob/living/carbon/human/checker)
	if(!house)
		return list()
	var/datum/family_graph_cache/cache = get_family_graph_cache(house, TRUE)
	if(!cache)
		return house.BuildFamilyTreeRoots(checker)
	var/checker_key = checker ? checker : "none"
	if(cache.display_tree_by_checker[checker_key])
		return cache.display_tree_by_checker[checker_key]
	var/list/built = house.BuildFamilyTreeRoots(checker)
	cache.display_tree_by_checker[checker_key] = built
	cache.dirty_display = FALSE
	return built

/datum/controller/subsystem/familytree/proc/get_cached_relation(datum/heritage/house, datum/family_member/looker_member, datum/family_member/lookee_member)
	if(!house || !looker_member || !lookee_member || looker_member == lookee_member)
		return null
	var/datum/family_graph_cache/cache = get_family_graph_cache(house, TRUE)
	if(!cache)
		return looker_member.GetRelationshipTo(lookee_member)
	if(cache.dirty_relations)
		cache.relation_matrix = list()
		cache.dirty_relations = FALSE
	var/list/inner = cache.relation_matrix[looker_member]
	if(!inner)
		inner = list()
		cache.relation_matrix[looker_member] = inner
	if(!isnull(inner[lookee_member]))
		var/cached = inner[lookee_member]
		return cached == "" ? null : cached
	var/computed = looker_member.GetRelationshipTo(lookee_member)
	inner[lookee_member] = computed ? computed : ""
	return computed

/datum/controller/subsystem/familytree/proc/drop_family_graph_cache(datum/heritage/house)
	if(!house)
		return FALSE
	var/datum/family_graph_cache/cache = family_graph_caches[house]
	if(!cache)
		return FALSE
	family_graph_caches -= house
	qdel(cache)
	return TRUE

/datum/controller/subsystem/familytree/proc/graph_on_member_created(mob/living/carbon/human/person, datum/heritage/house)
	if(!person)
		return null
	var/newly_tracked = !family_nodes_by_person[person]
	var/datum/family_node/node = get_or_create_family_node(person, house)
	if(house && node.primary_house != house)
		if(node.primary_house)
			node.primary_house.member_nodes -= node
			mark_family_dirty(node, null, node.primary_house)
		node.primary_house = house
		if(!(node in house.member_nodes))
			house.member_nodes += node
		mark_family_dirty(node, null, house)
	else if(house && !(node in house.member_nodes))
		house.member_nodes += node
	if(newly_tracked)
		RegisterSignal(person, COMSIG_PARENT_QDELETING, PROC_REF(graph_on_person_qdeleting), override = TRUE)
	return node

/datum/controller/subsystem/familytree/proc/graph_on_person_qdeleting(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/person = source
	var/datum/family_node/node = family_nodes_by_person[person]
	if(!node)
		return
	var/datum/heritage/house = person.family_datum || person.family_member_datum?.family || node.primary_house
	if(house)
		ftlog("graph_on_person_qdeleting: removing [person.real_name] from house '[house.housename || "no name"]'")
		house.RemovePersonFromFamily(person, TRUE)
	node = family_nodes_by_person[person] || node
	remove_family_node(node)
	stop_tracking_human(person, "human deleted or far traveled")

/datum/controller/subsystem/familytree/proc/graph_on_member_removed(mob/living/carbon/human/person, datum/heritage/house)
	if(!person)
		return FALSE
	var/datum/family_node/node = get_family_node(person)
	if(!node)
		return FALSE
	if(house)
		for(var/datum/family_edge/edge as anything in node.edges.Copy())
			if(edge.house == house)
				remove_family_edge(edge, "member_removed")
		house.member_nodes -= node
	if(node.primary_house == house)
		node.primary_house = null
		node.bump_revision()
		if(house)
			mark_family_dirty(node, null, house)
	return TRUE

/datum/controller/subsystem/familytree/proc/graph_sync_adoption_status(mob/living/carbon/human/child_person, adopted)
	if(!child_person)
		return FALSE
	var/datum/family_node/child_node = get_family_node(child_person)
	if(!child_node)
		return FALSE
	var/changed = FALSE
	var/from_type = adopted ? "parent_child" : "adoptive_parent_child"
	var/to_type = adopted ? "adoptive_parent_child" : "parent_child"
	for(var/datum/family_edge/edge as anything in child_node.edges.Copy())
		if(edge.relation_type != from_type)
			continue
		if(edge.b != child_node)
			continue
		var/datum/family_node/parent_node = edge.a
		var/datum/heritage/edge_house = edge.house
		var/edge_source = edge.source
		var/edge_flags = edge.relation_flags
		remove_family_edge(edge, "adoption_retype")
		add_family_edge(parent_node, child_node, to_type, edge_house, edge_flags, edge_source, TRUE)
		changed = TRUE
	return changed

/datum/controller/subsystem/familytree/proc/graph_on_parent_added(mob/living/carbon/human/parent_person, mob/living/carbon/human/child_person, datum/heritage/house, adopted = FALSE)
	if(!parent_person || !child_person || parent_person == child_person)
		return null
	var/datum/family_node/parent_node = get_or_create_family_node(parent_person, house)
	var/datum/family_node/child_node = get_or_create_family_node(child_person, house)
	var/edge_type = adopted ? "adoptive_parent_child" : "parent_child"
	return add_family_edge(parent_node, child_node, edge_type, house, 0, "legacy_hook", TRUE)

/datum/controller/subsystem/familytree/proc/graph_on_parent_removed(mob/living/carbon/human/parent_person, mob/living/carbon/human/child_person)
	if(!parent_person || !child_person)
		return FALSE
	var/datum/family_node/parent_node = get_family_node(parent_person)
	var/datum/family_node/child_node = get_family_node(child_person)
	if(!parent_node || !child_node)
		return FALSE
	var/datum/family_edge/edge = find_family_edge(parent_node, child_node, "parent_child", TRUE)
	if(!edge)
		edge = find_family_edge(parent_node, child_node, "adoptive_parent_child", TRUE)
	if(!edge)
		return FALSE
	return remove_family_edge(edge, "legacy_hook")

/datum/controller/subsystem/familytree/proc/graph_on_spouse_added(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/heritage/house)
	if(!person_a || !person_b || person_a == person_b)
		return null
	var/datum/family_node/node_a = get_or_create_family_node(person_a, house)
	var/datum/family_node/node_b = get_or_create_family_node(person_b, house)
	return add_family_edge(node_a, node_b, "spouse", house, 0, "legacy_hook", FALSE)

/datum/controller/subsystem/familytree/proc/graph_on_sworn_sibling_added(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/heritage/house)
	if(!person_a || !person_b || person_a == person_b)
		return null
	var/datum/family_node/node_a = get_or_create_family_node(person_a, house)
	var/datum/family_node/node_b = get_or_create_family_node(person_b, house)
	return add_family_edge(node_a, node_b, "sworn_sibling", house, 0, "legacy_hook", FALSE)

/datum/controller/subsystem/familytree/proc/graph_on_spouse_removed(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, divorce = FALSE)
	if(!person_a || !person_b)
		return FALSE
	var/datum/family_node/node_a = get_family_node(person_a)
	var/datum/family_node/node_b = get_family_node(person_b)
	if(!node_a || !node_b)
		return FALSE
	var/datum/family_edge/edge = find_family_edge(node_a, node_b, "spouse", FALSE)
	if(edge)
		var/datum/heritage/edge_house = edge.house
		remove_family_edge(edge, "legacy_hook")
		if(divorce)
			add_family_edge(node_a, node_b, "former_spouse", edge_house, 0, "legacy_hook", FALSE)
		return TRUE
	if(divorce)
		add_family_edge(node_a, node_b, "former_spouse", null, 0, "legacy_hook", FALSE)
	return FALSE
