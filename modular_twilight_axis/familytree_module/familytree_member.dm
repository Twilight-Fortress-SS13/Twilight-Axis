/datum/family_member
	var/tmp/mob/living/carbon/human/person
	var/datum/heritage/family
	var/list/phantom_parent_members = list()
	var/list/phantom_child_members = list()
	var/adoption_status = FALSE
	var/generation = 0
	var/phantom = FALSE
	var/cosmetic = FALSE
	var/tmp/recalculating_generation = FALSE
	var/mutable_appearance/cloned_look

/datum/family_member/New(mob/living/carbon/human/new_person, datum/heritage/new_family)
	person = new_person
	family = new_family
	person?.family_member_datum = src
	var/old_dir = person?.dir
	var/old_invisibility = person?.invisibility
	person?.invisibility = 0
	person?.dir = SOUTH
	cloned_look = new_person?.appearance
	person?.dir = old_dir
	person?.invisibility = old_invisibility

/datum/family_member/proc/get_parent_members() as /list
	var/list/out = list()
	for(var/datum/family_member/p as anything in phantom_parent_members)
		if(p)
			out += p
	if(!person)
		return out
	var/datum/family_node/node = SSfamilytree.get_family_node(person)
	if(!node)
		return out
	for(var/datum/family_node/parent_node as anything in node.get_parent_nodes())
		var/datum/family_member/pm = parent_node.person?.family_member_datum
		if(pm && !(pm in out))
			out += pm
	return out

/datum/family_member/proc/get_child_members() as /list
	var/list/out = list()
	for(var/datum/family_member/c as anything in phantom_child_members)
		if(c)
			out += c
	if(!person)
		return out
	var/datum/family_node/node = SSfamilytree.get_family_node(person)
	if(!node)
		return out
	for(var/datum/family_node/child_node as anything in node.get_child_nodes())
		var/datum/family_member/cm = child_node.person?.family_member_datum
		if(cm && !(cm in out))
			out += cm
	return out

/datum/family_member/proc/get_spouse_members() as /list
	var/list/out = list()
	if(!person)
		return out
	var/datum/family_node/node = SSfamilytree.get_family_node(person)
	if(!node)
		return out
	for(var/datum/family_edge/edge as anything in node.get_edges_of_type("spouse"))
		var/datum/family_node/other = edge.other_end(node)
		var/datum/family_member/sm = other?.person?.family_member_datum
		if(sm && !(sm in out))
			out += sm
	return out

/datum/family_member/proc/get_sworn_sibling_members() as /list
	var/list/out = list()
	if(!person)
		return out
	var/datum/family_node/node = SSfamilytree.get_family_node(person)
	if(!node)
		return out
	for(var/datum/family_edge/edge as anything in node.get_edges_of_type("sworn_sibling"))
		var/datum/family_node/other = edge.other_end(node)
		var/datum/family_member/sm = other?.person?.family_member_datum
		if(sm && !(sm in out))
			out += sm
	return out

/datum/family_member/proc/get_former_spouse_members() as /list
	var/list/out = list()
	if(!person)
		return out
	var/datum/family_node/node = SSfamilytree.get_family_node(person)
	if(!node)
		return out
	for(var/datum/family_edge/edge as anything in node.get_edges_of_type("former_spouse"))
		var/datum/family_node/other = edge.other_end(node)
		var/datum/family_member/sm = other?.person?.family_member_datum
		if(sm && !(sm in out))
			out += sm
	return out

/datum/family_member/proc/AddParent(datum/family_member/parent, skip_reciprocal = FALSE)
	if(!parent || parent == src)
		return FALSE
	var/list/current_parents = get_parent_members()
	if(parent in current_parents)
		return FALSE
	if(current_parents.len >= 2)
		return FALSE
	if(IsAncestorOf(parent))
		return FALSE
	if(person && parent.person && !adoption_status && !parent.cosmetic && !cosmetic && !SSfamilytree.familytree_biological_parent_allowed(parent.person, person, family))
		return FALSE
	if(person && parent.person && !adoption_status && !parent.cosmetic && !cosmetic)
		for(var/datum/family_member/existing_parent as anything in current_parents)
			if(existing_parent?.person && !existing_parent.cosmetic && !SSfamilytree.familytree_biological_parent_pair_allowed(parent.person, existing_parent.person, person, family))
				return FALSE

	if(parent.phantom || parent.cosmetic || cosmetic || !parent.person)
		phantom_parent_members += parent
		if(!(src in parent.phantom_child_members))
			parent.phantom_child_members += src
	else if(person)
		SSfamilytree.graph_on_parent_added(parent.person, person, family, adoption_status)
	else
		return FALSE

	RecalculateGeneration()
	return TRUE

/datum/family_member/proc/RemoveParent(datum/family_member/parent, skip_reciprocal = FALSE)
	if(!parent)
		return FALSE
	var/removed = FALSE
	if(parent in phantom_parent_members)
		phantom_parent_members -= parent
		parent.phantom_child_members -= src
		removed = TRUE
	if(person && parent.person)
		SSfamilytree.graph_on_parent_removed(parent.person, person)
		removed = TRUE
	if(!removed)
		return FALSE
	RecalculateGeneration()
	return TRUE

/datum/family_member/proc/AddChild(datum/family_member/child, skip_reciprocal = FALSE)
	if(!child)
		return FALSE
	return child.AddParent(src, skip_reciprocal)

/datum/family_member/proc/RemoveChild(datum/family_member/child, skip_reciprocal = FALSE)
	if(!child)
		return FALSE
	return child.RemoveParent(src, skip_reciprocal)

/datum/family_member/proc/AddSpouse(datum/family_member/spouse, skip_reciprocal = FALSE)
	if(!spouse || spouse == src || !person || !spouse.person)
		return FALSE
	if(spouse in get_spouse_members())
		return FALSE

	person.spouse_mob = spouse.person
	if(!spouse.person.spouse_mob)
		spouse.person.spouse_mob = person

	SSfamilytree.graph_on_spouse_added(person, spouse.person, family)
	HandleBiologicalChildren(spouse)
	return TRUE

/datum/family_member/proc/AddSwornSibling(datum/family_member/sibling)
	if(!sibling || sibling == src || !person || !sibling.person)
		return FALSE
	if(sibling in get_sworn_sibling_members())
		return TRUE

	SSfamilytree.graph_on_sworn_sibling_added(person, sibling.person, family)
	return TRUE

/datum/family_member/proc/RemoveSpouse(datum/family_member/spouse, divorce = FALSE, skip_reciprocal = FALSE)
	if(!spouse || !person || !spouse.person)
		return FALSE
	if(!(spouse in get_spouse_members()))
		return FALSE

	SSfamilytree.graph_on_spouse_removed(person, spouse.person, divorce)

	if(person.spouse_mob == spouse.person)
		person.spouse_mob = null
	if(spouse.person.spouse_mob == person)
		spouse.person.spouse_mob = null
	return TRUE

/datum/family_member/proc/IsAncestorOf(datum/family_member/other)
	if(!other || other == src)
		return FALSE

	var/list/checked = list(src)
	var/list/to_check = get_child_members()

	while(to_check.len)
		var/datum/family_member/current = to_check[1]
		to_check -= current

		if(current == other)
			return TRUE

		if(!(current in checked))
			checked += current
			to_check += current.get_child_members()

	return FALSE

/datum/family_member/proc/IsDescendantOf(datum/family_member/other)
	if(!other || other == src)
		return FALSE

	var/list/checked = list(src)
	var/list/to_check = get_parent_members()

	while(to_check.len)
		var/datum/family_member/current = to_check[1]
		to_check -= current

		if(current == other)
			return TRUE

		if(!(current in checked))
			checked += current
			to_check += current.get_parent_members()

	return FALSE

/datum/family_member/proc/HandleBiologicalChildren(datum/family_member/spouse)
	if(!spouse || !person || !spouse.person)
		return
	if(SSfamilytree.is_sterile_species(person) || SSfamilytree.is_sterile_species(spouse.person))
		return
	var/list/spouse_children = spouse.get_child_members()
	for(var/datum/family_member/child as anything in get_child_members())
		if(child in spouse_children)
			if(SSfamilytree.familytree_biological_parent_pair_allowed(person, spouse.person, child.person, family))
				child.adoption_status = FALSE
				SSfamilytree.graph_sync_adoption_status(child.person, FALSE)

/datum/family_member/proc/RecalculateGeneration()
	if(recalculating_generation)
		return
	recalculating_generation = TRUE

	var/list/my_parents = get_parent_members()
	if(!my_parents.len)
		generation = 0
	else
		var/max_parent_gen = -1
		for(var/datum/family_member/parent as anything in my_parents)
			if(parent.generation > max_parent_gen)
				max_parent_gen = parent.generation
		generation = max_parent_gen + 1

	recalculating_generation = FALSE

	for(var/datum/family_member/child as anything in get_child_members())
		if(!child.recalculating_generation)
			child.RecalculateGeneration()

/datum/family_member/proc/GetRelationshipStyle()
	if(person)
		return person.familytree_get_parental_style()
	return "neutral"

/datum/family_member/proc/GetParentTerm()
	var/parent_style = person?.familytree_get_parental_style()
	switch(parent_style)
		if("masculine")
			return "father"
		if("feminine")
			return "mother"
	return "parent"

/datum/family_member/proc/GetChildTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "son"
		if("feminine")
			return "daughter"
	return "child"

/datum/family_member/proc/GetSpouseTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "husband"
		if("feminine")
			return "wife"
	return "spouse"

/datum/family_member/proc/GetSiblingTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "brother"
		if("feminine")
			return "sister"
	return "sibling"

/datum/family_member/proc/GetSwornSiblingTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "sworn brother"
		if("feminine")
			return "sworn sister"
	return "sworn sibling"

/datum/family_member/proc/GetParentInLawTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "father-in-law"
		if("feminine")
			return "mother-in-law"
	return "parent-in-law"

/datum/family_member/proc/GetChildInLawTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "son-in-law"
		if("feminine")
			return "daughter-in-law"
	return "child-in-law"

/datum/family_member/proc/GetSiblingInLawTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "brother-in-law"
		if("feminine")
			return "sister-in-law"
	return "sibling-in-law"

/datum/family_member/proc/GetGrandparentTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "grandfather"
		if("feminine")
			return "grandmother"
	return "grandparent"

/datum/family_member/proc/GetGrandparentInLawTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "grandfather-in-law"
		if("feminine")
			return "grandmother-in-law"
	return "grandparent-in-law"

/datum/family_member/proc/GetParentInLawTermForSpouse(datum/family_member/spouse)
	switch(spouse?.GetRelationshipStyle())
		if("masculine")
			switch(GetRelationshipStyle())
				if("masculine")
					return "father-in-law"
				if("feminine")
					return "mother-in-law"
		if("feminine")
			switch(GetRelationshipStyle())
				if("masculine")
					return "father-in-law"
				if("feminine")
					return "mother-in-law"
	return GetParentInLawTerm()

/datum/family_member/proc/GetSpouseSiblingInLawTerm(datum/family_member/spouse)
	switch(spouse?.GetRelationshipStyle())
		if("masculine")
			switch(GetRelationshipStyle())
				if("masculine")
					return "brother-in-law"
				if("feminine")
					return "sister-in-law"
		if("feminine")
			switch(GetRelationshipStyle())
				if("masculine")
					return "brother-in-law"
				if("feminine")
					return "sister-in-law"
	return GetSiblingInLawTerm()

/datum/family_member/proc/GetSpouseOfSpousesSiblingInLawTerm(datum/family_member/spouse, datum/family_member/spouse_sibling)
	if(spouse?.GetRelationshipStyle() == "masculine" && spouse_sibling?.GetRelationshipStyle() == "masculine" && GetRelationshipStyle() == "feminine")
		return "sister-in-law"
	if(spouse?.GetRelationshipStyle() == "feminine" && spouse_sibling?.GetRelationshipStyle() == "feminine" && GetRelationshipStyle() == "masculine")
		return "brother-in-law"
	return GetSpouseOfSiblingTerm()

/datum/family_member/proc/GetSpouseOfSiblingTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "brother-in-law"
		if("feminine")
			return "sister-in-law"
	return GetSiblingInLawTerm()

/datum/family_member/proc/GetSpouseOfChildTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "son-in-law"
		if("feminine")
			return "daughter-in-law"
	return GetChildInLawTerm()

/datum/family_member/proc/GetSpouseOfNieceNephewTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "nephew-in-law"
		if("feminine")
			return "niece-in-law"
	return "niece/nephew-in-law"

/datum/family_member/proc/GetStepChildTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "stepson"
		if("feminine")
			return "stepdaughter"
	return "stepchild"

/datum/family_member/proc/GetCoParentInLawTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "co-father-in-law"
		if("feminine")
			return "co-mother-in-law"
	return "co-parent-in-law"

/datum/family_member/proc/GetGrandchildTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "grandson"
		if("feminine")
			return "granddaughter"
	return "grandchild"

/datum/family_member/proc/GetAuntUncleTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "uncle"
		if("feminine")
			return "aunt"
	return "aunt/uncle"

/datum/family_member/proc/GetNieceNephewTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "nephew"
		if("feminine")
			return "niece"
	return "niece/nephew"

/datum/family_member/proc/GetGreatGrandparentTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "great-grandfather"
		if("feminine")
			return "great-grandmother"
	return "great-grandparent"

/datum/family_member/proc/GetGreatGrandchildTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "great-grandson"
		if("feminine")
			return "great-granddaughter"
	return "great-grandchild"

/datum/family_member/proc/HasAdoptiveParent(datum/family_member/parent)
	if(!parent)
		return FALSE
	if(!person || !parent.person)
		return adoption_status && (parent in get_parent_members())
	var/datum/family_node/parent_node = SSfamilytree.get_family_node(parent.person)
	var/datum/family_node/child_node = SSfamilytree.get_family_node(person)
	if(!parent_node || !child_node)
		return adoption_status && (parent in get_parent_members())
	return parent_node.find_edge_to(child_node, "adoptive_parent_child", TRUE) ? TRUE : FALSE

/datum/family_member/proc/get_blood_parent_members() as /list
	var/list/out = list()
	for(var/datum/family_member/parent as anything in get_parent_members())
		if(!HasAdoptiveParent(parent))
			out += parent
	return out

/datum/family_member/proc/get_blood_child_members() as /list
	var/list/out = list()
	for(var/datum/family_member/child as anything in get_child_members())
		if(!child.HasAdoptiveParent(src))
			out += child
	return out

/datum/family_member/proc/GetSwornSiblingRelation(datum/family_member/other)
	if(!other || other == src)
		return null
	if(other in get_sworn_sibling_members())
		return other.GetSwornSiblingTerm()
	var/list/my_parents = get_parent_members()
	var/list/other_parents = other.get_parent_members()
	for(var/datum/family_member/parent as anything in my_parents)
		if(!(parent in other_parents))
			continue
		if(HasAdoptiveParent(parent) || other.HasAdoptiveParent(parent))
			return other.GetSwornSiblingTerm()
	return null

/datum/family_member/proc/GetRelationshipTo(datum/family_member/other)
	if(!other || other == src)
		return null

	var/list/my_parents = get_parent_members()
	if(other in my_parents)
		if(HasAdoptiveParent(other))
			return "adoptive [other.GetParentTerm()]"
		return other.GetParentTerm()

	var/list/my_children = get_child_members()
	if(other in my_children)
		if(other.HasAdoptiveParent(src))
			return "adopted [other.GetChildTerm()]"
		return other.GetChildTerm()

	if(other in get_spouse_members())
		return other.GetSpouseTerm()

	var/sworn_sibling_rel = GetSwornSiblingRelation(other)
	if(sworn_sibling_rel)
		return sworn_sibling_rel

	var/inlaw_rel = GetInLawRelation(other)
	if(inlaw_rel)
		return inlaw_rel

	if(AreSiblings(other))
		if(AreFullSiblings(other))
			return other.GetSiblingTerm()
		return GetHalfSiblingTerm(other)

	var/grandparent_rel = GetGrandparentRelation(other)
	if(grandparent_rel)
		return grandparent_rel

	var/grandchild_rel = GetGrandchildRelation(other)
	if(grandchild_rel)
		return grandchild_rel

	var/great_grandparent_rel = GetGreatGrandparentRelation(other)
	if(great_grandparent_rel)
		return great_grandparent_rel

	var/great_grandchild_rel = GetGreatRelation(other)
	if(great_grandchild_rel)
		return great_grandchild_rel

	var/great_niece_nephew_rel = GetGreatNieceNephewRelation(other)
	if(great_niece_nephew_rel)
		return great_niece_nephew_rel

	var/great_aunt_uncle_rel = GetGreatAuntUncleRelation(other)
	if(great_aunt_uncle_rel)
		return great_aunt_uncle_rel

	var/aunt_uncle_rel = GetAuntUncleRelation(other)
	if(aunt_uncle_rel)
		return aunt_uncle_rel

	var/niece_nephew_rel = GetNieceNephewRelation(other)
	if(niece_nephew_rel)
		return niece_nephew_rel

	var/cousin_rel = GetCousinRelation(other)
	if(cousin_rel)
		return cousin_rel

	var/cousin_once_removed_rel = GetCousinOnceRemovedRelation(other)
	if(cousin_once_removed_rel)
		return cousin_once_removed_rel

	var/second_cousin_rel = GetSecondCousinRelation(other)
	if(second_cousin_rel)
		return second_cousin_rel

	var/preserved_rel = GetPreservedRelationshipTo(other)
	if(preserved_rel)
		return preserved_rel

	return "distant relative"

/datum/family_member/proc/GetPreservedRelationshipTo(datum/family_member/other)
	if(!person || !other?.person)
		return null
	return SSfamilytree.get_preserved_relationship(person, other)

/datum/family_member/proc/AreFullSiblings(datum/family_member/other)
	if(!other || other == src)
		return FALSE
	var/list/my_parents = get_blood_parent_members()
	var/list/other_parents = other.get_blood_parent_members()
	if(my_parents.len < 2 || other_parents.len < 2)
		return FALSE
	var/shared = 0
	for(var/datum/family_member/p as anything in my_parents)
		if(p in other_parents)
			shared++
	return shared >= 2

/datum/family_member/proc/GetHalfSiblingTerm(datum/family_member/other)
	var/shared_style = null
	var/list/my_parents = get_blood_parent_members()
	var/list/other_parents = other.get_blood_parent_members()
	for(var/datum/family_member/p as anything in my_parents)
		if(p in other_parents)
			shared_style = p.GetRelationshipStyle()
			break
	var/base
	switch(other.GetRelationshipStyle())
		if("masculine")
			base = "half-brother"
		if("feminine")
			base = "half-sister"
		else
			base = "half-sibling"
	if(shared_style == "masculine")
		return "paternal [base]"
	if(shared_style == "feminine")
		return "maternal [base]"
	return base

/datum/family_member/proc/GetGreatAuntUncleTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "great-uncle"
		if("feminine")
			return "great-aunt"
	return "great-aunt/uncle"

/datum/family_member/proc/GetGreatNieceNephewTerm()
	switch(GetRelationshipStyle())
		if("masculine")
			return "great-nephew"
		if("feminine")
			return "great-niece"
	return "great-niece/nephew"

/datum/family_member/proc/GetGreatAuntUncleRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		for(var/datum/family_member/grandparent as anything in parent.get_blood_parent_members())
			if(other.AreSiblings(grandparent) && other != grandparent)
				return other.GetGreatAuntUncleTerm()
	return null

/datum/family_member/proc/GetGreatNieceNephewRelation(datum/family_member/other)
	for(var/datum/family_member/sibling as anything in family.members)
		if(!AreSiblings(sibling) || sibling == src)
			continue
		for(var/datum/family_member/niblingchild as anything in sibling.get_blood_child_members())
			if(other in niblingchild.get_blood_child_members())
				return other.GetGreatNieceNephewTerm()
	return null

/datum/family_member/proc/GetCousinOnceRemovedRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		if(parent.GetCousinRelation(other))
			return "first cousin once removed"
	for(var/datum/family_member/their_parent as anything in other.get_blood_parent_members())
		if(GetCousinRelation(their_parent))
			return "first cousin once removed"
	return null

/datum/family_member/proc/GetSecondCousinRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		for(var/datum/family_member/grandparent as anything in parent.get_blood_parent_members())
			for(var/datum/family_member/their_parent as anything in other.get_blood_parent_members())
				for(var/datum/family_member/their_grandparent as anything in their_parent.get_blood_parent_members())
					if(grandparent.AreSiblings(their_grandparent))
						return "second cousin"
	return null

/datum/family_member/proc/GetInLawRelation(datum/family_member/other)
	for(var/datum/family_member/spouse as anything in get_spouse_members())
		var/list/spouse_parents = spouse.get_parent_members()
		if(other in spouse_parents)
			return other.GetParentInLawTermForSpouse(spouse)
		var/list/spouse_children = spouse.get_child_members()
		if(other in spouse_children)
			return other.GetStepChildTerm()
		if(spouse.AreSiblings(other))
			return other.GetSpouseSiblingInLawTerm(spouse)

		for(var/datum/family_member/spouse_sibling as anything in family.members)
			if(!spouse.AreSiblings(spouse_sibling) || spouse_sibling == spouse)
				continue
			if(other in spouse_sibling.get_spouse_members())
				return other.GetSpouseOfSpousesSiblingInLawTerm(spouse, spouse_sibling)
			if(other in spouse_sibling.get_blood_child_members())
				return other.GetNieceNephewTerm()

	for(var/datum/family_member/member as anything in family.members)
		if(AreSiblings(member) && (other in member.get_spouse_members()))
			return other.GetSpouseOfSiblingTerm()

	for(var/datum/family_member/sibling as anything in family.members)
		if(!AreSiblings(sibling) || sibling == src)
			continue
		for(var/datum/family_member/nibling as anything in sibling.get_blood_child_members())
			if(other in nibling.get_spouse_members())
				return other.GetSpouseOfNieceNephewTerm()

	for(var/datum/family_member/child as anything in get_child_members())
		if(other in child.get_spouse_members())
			return other.GetSpouseOfChildTerm()
		for(var/datum/family_member/child_spouse as anything in child.get_spouse_members())
			if(other in child_spouse.get_parent_members())
				return other.GetCoParentInLawTerm()

	return null

/datum/family_member/proc/AreSiblings(datum/family_member/other)
	if(!other || other == src)
		return FALSE
	var/list/my_parents = get_blood_parent_members()
	if(!my_parents.len)
		return FALSE
	var/list/other_parents = other.get_blood_parent_members()
	if(!other_parents.len)
		return FALSE

	for(var/datum/family_member/my_parent as anything in my_parents)
		if(my_parent in other_parents)
			return TRUE
	return FALSE

/datum/family_member/proc/GetAuntUncleRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		if(other.AreSiblings(parent) && other != parent)
			return other.GetAuntUncleTerm()
	return null

/datum/family_member/proc/GetNieceNephewRelation(datum/family_member/other)
	for(var/datum/family_member/sibling as anything in family.members)
		if(AreSiblings(sibling) && (sibling != src) && (other in sibling.get_blood_child_members()))
			return other.GetNieceNephewTerm()
	return null

/datum/family_member/proc/GetGrandparentRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		if(other in parent.get_blood_parent_members())
			return other.GetGrandparentTerm()
	return null

/datum/family_member/proc/GetGrandchildRelation(datum/family_member/other)
	for(var/datum/family_member/child as anything in get_blood_child_members())
		if(other in child.get_blood_child_members())
			return other.GetGrandchildTerm()
	return null

/datum/family_member/proc/GetGreatGrandparentRelation(datum/family_member/other)
	for(var/datum/family_member/parent as anything in get_blood_parent_members())
		for(var/datum/family_member/grandparent as anything in parent.get_blood_parent_members())
			if(other in grandparent.get_blood_parent_members())
				return other.GetGreatGrandparentTerm()
	return null

/datum/family_member/proc/GetCousinRelation(datum/family_member/other)
	var/list/other_parents = other.get_blood_parent_members()
	for(var/datum/family_member/my_parent as anything in get_blood_parent_members())
		for(var/datum/family_member/their_parent as anything in other_parents)
			if(my_parent.AreSiblings(their_parent))
				return "cousin"
	return null

/datum/family_member/proc/GetGreatRelation(datum/family_member/other)
	for(var/datum/family_member/child as anything in get_blood_child_members())
		for(var/datum/family_member/grandchild as anything in child.get_blood_child_members())
			if(other in grandchild.get_blood_child_members())
				return other.GetGreatGrandchildTerm()

	return null
