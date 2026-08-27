/datum/controller/subsystem/familytree/var/list/family_nodes = list()
/datum/controller/subsystem/familytree/var/list/family_nodes_by_person = list()
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
	qdel(node)
	return TRUE

/datum/controller/subsystem/familytree/proc/is_preservable_relationship_label(relation)
	return istext(relation) && length(relation) && relation != "distant relative"

/datum/controller/subsystem/familytree/proc/preserve_player_relationship(datum/family_member/member_a, datum/family_member/member_b, relation_a_to_b, relation_b_to_a, datum/heritage/house)
	if(!member_a?.person || !member_b?.person || member_a == member_b)
		return FALSE
	if(!is_preservable_relationship_label(relation_a_to_b) && !is_preservable_relationship_label(relation_b_to_a))
		return FALSE
	var/datum/mind/mind_a = kin_mind_of(member_a.person)
	var/datum/mind/mind_b = kin_mind_of(member_b.person)
	if(!mind_a || !mind_b)
		return FALSE
	get_or_create_family_node(member_a.person, house)
	get_or_create_family_node(member_b.person, house)
	if(is_preservable_relationship_label(relation_a_to_b))
		var/datum/social_bond/kin/forward = SSbonds.add_kin_link(mind_a, mind_b, BOND_KIN_PRESERVED, FALSE, house)
		forward?.preserved_label = relation_a_to_b
	if(is_preservable_relationship_label(relation_b_to_a))
		var/datum/social_bond/kin/backward = SSbonds.add_kin_link(mind_b, mind_a, BOND_KIN_PRESERVED, FALSE, house)
		backward?.preserved_label = relation_b_to_a
	kin_mark_dirty(member_a.person, member_b.person, house)
	return TRUE

/datum/controller/subsystem/familytree/proc/get_preserved_relationship(mob/living/carbon/human/from_person, mob/living/carbon/human/to_person)
	if(!from_person?.mind || !to_person?.mind || from_person == to_person)
		return null
	var/datum/social_bond/kin/link = SSbonds.find_kin(from_person.mind, to_person.mind, BOND_KIN_PRESERVED)
	return link?.preserved_label

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
		if(person.mind)
			SSbonds.drop_kin_for_house(person.mind, house)
		house.member_nodes -= node
	if(node.primary_house == house)
		node.primary_house = null
		node.bump_revision()
		if(house)
			mark_family_dirty(node, null, house)
	return TRUE

/datum/controller/subsystem/familytree/proc/kin_mind_of(mob/living/carbon/human/person)
	if(!person)
		return null
	if(!person.mind)
		ftlog("kin hook received [person.real_name || person] without a mind; kinship link skipped", FTLOG_WARN)
		return null
	return person.mind

/datum/controller/subsystem/familytree/proc/kin_mark_dirty(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/heritage/house)
	var/datum/family_node/node_a = person_a ? get_family_node(person_a) : null
	var/datum/family_node/node_b = person_b ? get_family_node(person_b) : null
	var/datum/heritage/target_house = house || node_a?.primary_house || node_b?.primary_house
	mark_family_dirty(node_a, node_b, target_house)

/datum/controller/subsystem/familytree/proc/graph_sync_adoption_status(mob/living/carbon/human/child_person, adopted)
	var/datum/mind/child_mind = kin_mind_of(child_person)
	if(!child_mind)
		return FALSE
	var/changed = FALSE
	for(var/datum/social_bond/kin/link as anything in SSbonds.kin_links_of_kind(child_mind, BOND_KIN_PARENT))
		if(link.adopted == adopted)
			continue
		if(SSbonds.set_kin_adopted(child_mind, link.other, BOND_KIN_PARENT, adopted))
			changed = TRUE
	if(changed)
		kin_mark_dirty(child_person, null, null)
	return changed

/datum/controller/subsystem/familytree/proc/graph_on_parent_added(mob/living/carbon/human/parent_person, mob/living/carbon/human/child_person, datum/heritage/house, adopted = FALSE)
	if(!parent_person || !child_person || parent_person == child_person)
		return null
	var/datum/mind/parent_mind = kin_mind_of(parent_person)
	var/datum/mind/child_mind = kin_mind_of(child_person)
	if(!parent_mind || !child_mind)
		return null
	get_or_create_family_node(parent_person, house)
	get_or_create_family_node(child_person, house)
	var/datum/social_bond/kin/link = SSbonds.add_kin(child_mind, parent_mind, BOND_KIN_PARENT, adopted, house)
	kin_mark_dirty(parent_person, child_person, house)
	return link

/datum/controller/subsystem/familytree/proc/graph_on_parent_removed(mob/living/carbon/human/parent_person, mob/living/carbon/human/child_person)
	var/datum/mind/parent_mind = kin_mind_of(parent_person)
	var/datum/mind/child_mind = kin_mind_of(child_person)
	if(!parent_mind || !child_mind)
		return FALSE
	if(!SSbonds.remove_kin(child_mind, parent_mind, BOND_KIN_PARENT))
		return FALSE
	kin_mark_dirty(parent_person, child_person, null)
	return TRUE

/datum/controller/subsystem/familytree/proc/graph_on_spouse_added(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/heritage/house)
	if(!person_a || !person_b || person_a == person_b)
		return null
	var/datum/mind/mind_a = kin_mind_of(person_a)
	var/datum/mind/mind_b = kin_mind_of(person_b)
	if(!mind_a || !mind_b)
		return null
	get_or_create_family_node(person_a, house)
	get_or_create_family_node(person_b, house)
	var/datum/social_bond/kin/link = SSbonds.add_kin(mind_a, mind_b, BOND_KIN_SPOUSE, FALSE, house)
	person_a.bonds_refresh_spouse_cache()
	person_b.bonds_refresh_spouse_cache()
	kin_mark_dirty(person_a, person_b, house)
	return link

/datum/controller/subsystem/familytree/proc/graph_on_sworn_sibling_added(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, datum/heritage/house)
	if(!person_a || !person_b || person_a == person_b)
		return null
	var/datum/mind/mind_a = kin_mind_of(person_a)
	var/datum/mind/mind_b = kin_mind_of(person_b)
	if(!mind_a || !mind_b)
		return null
	get_or_create_family_node(person_a, house)
	get_or_create_family_node(person_b, house)
	var/datum/social_bond/kin/link = SSbonds.add_kin(mind_a, mind_b, BOND_KIN_SWORN_SIBLING, FALSE, house)
	kin_mark_dirty(person_a, person_b, house)
	return link

/datum/controller/subsystem/familytree/proc/graph_on_spouse_removed(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b, divorce = FALSE)
	var/datum/mind/mind_a = kin_mind_of(person_a)
	var/datum/mind/mind_b = kin_mind_of(person_b)
	if(!mind_a || !mind_b)
		return FALSE
	var/datum/social_bond/kin/existing = SSbonds.find_kin(mind_a, mind_b, BOND_KIN_SPOUSE)
	var/datum/heritage/kept_house = existing?.house
	var/removed = SSbonds.remove_kin(mind_a, mind_b, BOND_KIN_SPOUSE)
	if(divorce)
		SSbonds.add_kin(mind_a, mind_b, BOND_KIN_FORMER_SPOUSE, FALSE, kept_house)
	person_a.bonds_refresh_spouse_cache()
	person_b.bonds_refresh_spouse_cache()
	kin_mark_dirty(person_a, person_b, kept_house)
	return removed
