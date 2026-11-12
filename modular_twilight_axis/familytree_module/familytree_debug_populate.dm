#ifdef FAMILYTREE_DEBUG_LOGGING

#define FTDBG_POP_SESSION_TAG "POPULATE"

/datum/controller/subsystem/familytree/proc/ftpop_log(msg, level = FTLOG_INFO)
	ftlog("[FTDBG_POP_SESSION_TAG] [msg]", level)

/datum/controller/subsystem/familytree/proc/ftpop_spawn_relative(turf/loc, datum/species/species_type = null, desired_gender = null, desired_age = null, tag = "relative")
	if(!loc)
		return null
	var/mob/living/carbon/human/H = new(loc)
	var/debug_name = ftdebug_gen_name()
	H.real_name = debug_name
	H.name = debug_name
	H.ckey = "FTPOP_[debug_session_id]_[debug_entities.len + 1]"
	ftdebug_ensure_mind(H, H.ckey)
	debug_entities += H
	if(!species_type)
		species_type = pick(GLOB.ftdebug_species_pool)
	var/datum/species/new_species = new species_type()
	H.set_species(new_species, TRUE)
	H.age = desired_age || pick(GLOB.ftdebug_age_pool)
	H.gender = isnull(desired_gender) ? pick(MALE, FEMALE) : desired_gender
	H.pronouns = H.gender == MALE ? HE_HIM : SHE_HER
	H.familytree_pref = FAMILY_PARTIAL
	H.gender_choice_pref = ANY_GENDER
	H.desired_relative_role = RELATIVE_ANY
	H.allow_low_status_marriage = TRUE
	H.allow_relatives_in_family = TRUE
	H.setspouse = ""
	H.polygamy_mode = POLYGAMY_DISABLED
	ftpop_log("SPAWN [tag] [H.real_name] species=[new_species.type] gender=[H.gender] age=[H.age] loc=[loc.x],[loc.y],[loc.z]", FTLOG_DEBUG)
	return H

/datum/controller/subsystem/familytree/proc/ftpop_ensure_user_house(mob/living/carbon/human/user)
	if(!user)
		ftpop_log("ERR ensure_user_house: user is null", FTLOG_ERROR)
		return null
	if(user.family_datum)
		ftpop_log("user [user.real_name] already has house '[user.family_datum.housename]'", FTLOG_DEBUG)
		return user.family_datum
	ftpop_log("user [user.real_name] has no house, creating direct debug house", FTLOG_INFO)
	user.familytree_pref = FAMILY_PARTIAL
	user.allow_low_status_marriage = TRUE
	user.allow_relatives_in_family = TRUE
	ftdebug_create_house_for(user)
	if(user.family_datum)
		ftpop_log("user direct-created house '[user.family_datum.housename]' ok", FTLOG_INFO)
	else
		ftpop_log("ERR: direct debug house creation failed for user", FTLOG_ERROR)
	return user.family_datum

/datum/controller/subsystem/familytree/proc/ftpop_member_for(mob/living/carbon/human/person, datum/heritage/house)
	if(!person || !house)
		return null
	if(person.family_member_datum && person.family_member_datum.family == house)
		return person.family_member_datum
	return house.CreateFamilyMember(person)

/datum/controller/subsystem/familytree/proc/ftpop_house_label(datum/heritage/house)
	if(!house)
		return null
	var/list/names = list()
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(node.person)
			names += node.person.real_name
		if(names.len >= 3)
			break
	var/member_preview = names.len ? names.Join(", ") : "no visible members"
	return "[house.housename || "Nameless"] ([house.member_nodes.len] nodes, [house.members.len] members) - [member_preview]"

/datum/controller/subsystem/familytree/proc/ftpop_house_choices(mob/living/carbon/human/user)
	var/list/choices = list()
	for(var/datum/heritage/house as anything in families)
		if(!house || house == user?.family_datum)
			continue
		if(!house.member_nodes.len && !house.members.len)
			continue
		var/label = ftpop_house_label(house)
		if(!label)
			continue
		var/base_label = label
		var/dupe = 2
		while(choices[label])
			label = "[base_label] #[dupe]"
			dupe++
		choices[label] = house
	return choices

/datum/controller/subsystem/familytree/proc/ftpop_join_house_direct(mob/living/carbon/human/user, datum/heritage/house, forced_role = null)
	if(!user)
		return "no_user"
	if(!house)
		return "no_house"
	if(user.family_datum == house)
		return "OK: already in house '[house.housename || "Nameless"]'"
	ftdebug_ensure_mind(user, user.ckey || user.key)
	user.familytree_pref = FAMILY_PARTIAL
	user.allow_low_status_marriage = TRUE
	user.allow_relatives_in_family = TRUE

	var/used_fallback = FALSE
	var/role_attempted = forced_role && forced_role != "direct"
	var/datum/family_member/member = null
	if(forced_role == "spouse")
		var/datum/family_member/spouse_target = null
		for(var/datum/family_member/candidate as anything in house.members)
			if(candidate?.person && candidate.person != user)
				spouse_target = candidate
				break
		if(spouse_target)
			member = house.CreateFamilyMember(user)
			if(!member || !member.AddSpouse(spouse_target))
				used_fallback = TRUE
		else
			used_fallback = TRUE
	else if(role_attempted)
		var/assigned = AddPersonToHouse(house, user, FALSE, forced_role)
		if(!assigned)
			used_fallback = TRUE

	if(!member && user.family_datum == house)
		member = user.family_member_datum
	if(!member)
		member = house.CreateFamilyMember(user)
	if(!member)
		ftpop_log("ERR join_house_direct: could not add [user.real_name] to '[house.housename || "Nameless"]'", FTLOG_ERROR)
		return "join_failed"

	if(!house.house_leader)
		house.SelectReplacementHouseHead()
	stop_tracking_human(user, "ftpop join existing house")
	wake_waiting_relative_seekers(house)
	var/join_summary = role_attempted ? "debug direct join as [forced_role]" : "debug direct join as member"
	if(role_attempted && used_fallback)
		join_summary += " (fallback direct member)"
	familytree_admin_log_house_assignment(user, house, join_summary, member)
	ftpop_log("OK join_house_direct user=[user.real_name] house='[house.housename || "Nameless"]' role=[forced_role || "direct"] fallback=[used_fallback]", FTLOG_INFO)
	var/result_role_text = role_attempted && !used_fallback ? forced_role : "direct member"
	return "OK: joined '[house.housename || "Nameless"]' as [result_role_text]"

/datum/controller/subsystem/familytree/proc/ftpop_add_house_member(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_ADULT, "house_member")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	stop_tracking_human(npc, "ftpop house member")
	ftpop_log("OK house_member [npc.real_name] joined '[house.housename || "Nameless"]'", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_parent(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null, adopted = FALSE)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		ftpop_log("ERR add_parent: could not make member for user", FTLOG_ERROR)
		return "no_user_member"
	if(user_member.get_parent_members().len >= 2)
		ftpop_log("add_parent blocked: user already has 2 parents", FTLOG_WARN)
		return "has_2_parents"
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_OLD, "parent")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		ftpop_log("ERR add_parent: could not make member for npc", FTLOG_ERROR)
		return "no_npc_member"
	if(adopted)
		user_member.adoption_status = TRUE
		SSfamilytree.graph_sync_adoption_status(user, TRUE)
	user_member.AddParent(npc_member)
	ftpop_log("OK parent [npc.real_name] -> child [user.real_name] adopted=[adopted] house='[house.housename]'", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_child(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null, adopted = FALSE)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_ADULT, "child")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	if(adopted)
		npc_member.adoption_status = TRUE
		SSfamilytree.graph_sync_adoption_status(npc, TRUE)
	npc_member.AddParent(user_member)
	ftpop_log("OK child [npc.real_name] <- parent [user.real_name] adopted=[adopted]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_sibling(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/list/parents = user_member.get_parent_members()
	var/datum/family_member/shared_parent = null
	if(parents.len)
		shared_parent = parents[1]
		ftpop_log("sibling uses existing parent [shared_parent.person?.real_name || "phantom"]", FTLOG_DEBUG)
	else
		var/mob/living/carbon/human/parent_npc = ftpop_spawn_relative(get_turf(user), species_type, null, AGE_OLD, "sibling_parent_gap")
		if(!parent_npc)
			return "spawn_failed"
		shared_parent = ftpop_member_for(parent_npc, house)
		user_member.AddParent(shared_parent)
		ftpop_log("sibling created shared parent [parent_npc.real_name] for user", FTLOG_DEBUG)
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_ADULT, "sibling")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	npc_member.AddParent(shared_parent)
	ftpop_log("OK sibling [npc.real_name] shares parent with [user.real_name]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_spouse(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null, make_former = FALSE, polygamy = FALSE)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/target_gender = desired_gender
	if(isnull(target_gender))
		target_gender = user.gender == MALE ? FEMALE : MALE
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, target_gender, AGE_ADULT, make_former ? "former_spouse" : (polygamy ? "poly_spouse" : "spouse"))
	if(!npc)
		return "spawn_failed"
	if(polygamy)
		user.polygamy_mode = POLYGAMY_ALLOW_MULTIPLE
		npc.polygamy_mode = POLYGAMY_ALLOW_BE_SECOND
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	user_member.AddSpouse(npc_member)
	if(make_former)
		user_member.RemoveSpouse(npc_member, TRUE)
		ftpop_log("OK former_spouse [npc.real_name] divorced from [user.real_name]", FTLOG_INFO)
	else
		ftpop_log("OK spouse [npc.real_name] married to [user.real_name] polygamy=[polygamy]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_uncle_aunt(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/list/parents = user_member.get_parent_members()
	var/datum/family_member/parent_member = null
	if(parents.len)
		parent_member = parents[1]
	else
		var/mob/living/carbon/human/parent_npc = ftpop_spawn_relative(get_turf(user), species_type, null, AGE_OLD, "uncle_parent_gap")
		if(!parent_npc)
			return "spawn_failed"
		parent_member = ftpop_member_for(parent_npc, house)
		user_member.AddParent(parent_member)
	var/list/grandparents = parent_member.get_parent_members()
	var/datum/family_member/gp_member = null
	if(grandparents.len)
		gp_member = grandparents[1]
	else
		var/mob/living/carbon/human/gp_npc = ftpop_spawn_relative(get_turf(user), species_type, null, AGE_OLD, "uncle_gp_gap")
		if(!gp_npc)
			return "spawn_failed"
		gp_member = ftpop_member_for(gp_npc, house)
		parent_member.AddParent(gp_member)
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_OLD, "uncle_aunt")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	npc_member.AddParent(gp_member)
	ftpop_log("OK uncle/aunt [npc.real_name] shares grandparent with [user.real_name]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_cousin(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/result = ftpop_add_uncle_aunt(user, species_type, null)
	if(!istype(result, /mob/living/carbon/human))
		return result
	var/mob/living/carbon/human/uncle_npc = result
	var/datum/family_member/uncle_member = ftpop_member_for(uncle_npc, house)
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_ADULT, "cousin")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	npc_member.AddParent(uncle_member)
	ftpop_log("OK cousin [npc.real_name] via uncle/aunt [uncle_npc.real_name]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_grandparent(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/list/parents = user_member.get_parent_members()
	var/datum/family_member/parent_member = null
	if(parents.len)
		parent_member = parents[1]
	else
		var/mob/living/carbon/human/parent_npc = ftpop_spawn_relative(get_turf(user), species_type, null, AGE_OLD, "gp_parent_gap")
		if(!parent_npc)
			return "spawn_failed"
		parent_member = ftpop_member_for(parent_npc, house)
		user_member.AddParent(parent_member)
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_OLD, "grandparent")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	parent_member.AddParent(npc_member)
	ftpop_log("OK grandparent [npc.real_name] parent of user's parent", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_grandchild(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/list/children = user_member.get_child_members()
	var/datum/family_member/child_member = null
	if(children.len)
		child_member = children[1]
	else
		var/mob/living/carbon/human/child_npc = ftpop_spawn_relative(get_turf(user), species_type, null, AGE_ADULT, "gc_child_gap")
		if(!child_npc)
			return "spawn_failed"
		child_member = ftpop_member_for(child_npc, house)
		child_member.AddParent(user_member)
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_ADULT, "grandchild")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	npc_member.AddParent(child_member)
	ftpop_log("OK grandchild [npc.real_name] via child [child_member.person?.real_name]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_inlaw(mob/living/carbon/human/user, datum/species/species_type = null, desired_gender = null)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	var/list/spouses = user_member.get_spouse_members()
	var/datum/family_member/spouse_member = null
	if(spouses.len)
		spouse_member = spouses[1]
	else
		var/result = ftpop_add_spouse(user, species_type, null)
		if(!istype(result, /mob/living/carbon/human))
			return result
		spouse_member = ftpop_member_for(result, house)
	if(!spouse_member)
		return "no_spouse"
	if(spouse_member.get_parent_members().len >= 2)
		ftpop_log("in-law blocked: spouse already has 2 parents", FTLOG_WARN)
		return "spouse_has_2_parents"
	var/mob/living/carbon/human/npc = ftpop_spawn_relative(get_turf(user), species_type, desired_gender, AGE_OLD, "inlaw")
	if(!npc)
		return "spawn_failed"
	var/datum/family_member/npc_member = ftpop_member_for(npc, house)
	if(!npc_member)
		return "no_npc_member"
	spouse_member.AddParent(npc_member)
	ftpop_log("OK in-law [npc.real_name] parent of spouse [spouse_member.person?.real_name]", FTLOG_INFO)
	return npc

/datum/controller/subsystem/familytree/proc/ftpop_add_phantom_parent(mob/living/carbon/human/user)
	var/datum/heritage/house = ftpop_ensure_user_house(user)
	if(!house)
		return "no_house"
	var/datum/family_member/user_member = ftpop_member_for(user, house)
	if(!user_member)
		return "no_user_member"
	if(user_member.get_parent_members().len >= 2)
		return "has_2_parents"
	var/datum/family_member/phantom = new /datum/family_member(null, house)
	phantom.phantom = TRUE
	if(!(phantom in house.members))
		house.members += phantom
	user_member.AddParent(phantom)
	ftpop_log("OK phantom parent added to [user.real_name]", FTLOG_INFO)
	return phantom

/datum/controller/subsystem/familytree/proc/ftpop_quick_nuclear(mob/living/carbon/human/user)
	ftpop_log("QUICK nuclear family for [user.real_name] START", FTLOG_INFO)
	var/list/out = list()
	out += list(ftpop_add_parent(user, null, MALE))
	out += list(ftpop_add_parent(user, null, FEMALE))
	out += list(ftpop_add_sibling(user))
	out += list(ftpop_add_sibling(user))
	ftpop_log("QUICK nuclear family for [user.real_name] DONE", FTLOG_INFO)
	return out

/datum/controller/subsystem/familytree/proc/ftpop_quick_extended(mob/living/carbon/human/user)
	ftpop_log("QUICK extended family for [user.real_name] START", FTLOG_INFO)
	var/list/out = list()
	out += list(ftpop_add_parent(user, null, MALE))
	out += list(ftpop_add_parent(user, null, FEMALE))
	out += list(ftpop_add_grandparent(user, null, MALE))
	out += list(ftpop_add_grandparent(user, null, FEMALE))
	out += list(ftpop_add_sibling(user))
	out += list(ftpop_add_uncle_aunt(user))
	out += list(ftpop_add_cousin(user))
	out += list(ftpop_add_spouse(user))
	out += list(ftpop_add_child(user))
	out += list(ftpop_add_inlaw(user))
	ftpop_log("QUICK extended family for [user.real_name] DONE", FTLOG_INFO)
	return out

/datum/controller/subsystem/familytree/proc/ftpop_variation_all(mob/living/carbon/human/user)
	ftpop_log("QUICK ALL VARIATIONS for [user.real_name] START", FTLOG_INFO)
	var/list/out = list()
	out += list(ftpop_add_parent(user, /datum/species/human/northern, MALE, FALSE))
	out += list(ftpop_add_parent(user, /datum/species/elf/wood, FEMALE, TRUE))
	out += list(ftpop_add_sibling(user, /datum/species/human/northern))
	out += list(ftpop_add_child(user, null, null, FALSE))
	out += list(ftpop_add_child(user, /datum/species/dwarf, null, TRUE))
	out += list(ftpop_add_grandparent(user, /datum/species/human/northern, MALE))
	out += list(ftpop_add_grandchild(user))
	out += list(ftpop_add_uncle_aunt(user))
	out += list(ftpop_add_cousin(user))
	out += list(ftpop_add_spouse(user, null, null, FALSE, FALSE))
	out += list(ftpop_add_spouse(user, null, null, TRUE, FALSE))
	out += list(ftpop_add_spouse(user, null, null, FALSE, TRUE))
	out += list(ftpop_add_inlaw(user))
	out += list(ftpop_add_phantom_parent(user))
	ftpop_log("QUICK ALL VARIATIONS for [user.real_name] DONE", FTLOG_INFO)
	return out

/datum/controller/subsystem/familytree/proc/ftpop_clear_user_house(mob/living/carbon/human/user)
	if(!user || !user.family_datum)
		ftpop_log("clear: user has no house", FTLOG_WARN)
		return 0
	var/datum/heritage/house = user.family_datum
	var/cleaned = 0
	ftpop_log("CLEAR house '[house.housename]' members=[house.member_nodes.len] START", FTLOG_INFO)
	var/list/nodes_copy = house.member_nodes.Copy()
	for(var/datum/family_node/node as anything in nodes_copy)
		if(!node.person || node.person == user)
			continue
		if(!(node.person in debug_entities))
			continue
		var/mob/living/carbon/human/H = node.person
		var/removed_name = H.real_name
		house.RemovePersonFromFamily(H, TRUE)
		if(H.spouse_mob)
			var/mob/living/carbon/human/sp = H.spouse_mob
			if(!QDELETED(sp))
				sp.spouse_mob = null
			H.spouse_mob = null
		viable_spouses -= H
		stop_tracking_human(H, "ftpop_clear")
		debug_entities -= H
		ftdebug_cleanup_mind(H)
		qdel(H)
		cleaned++
		ftpop_log("CLEAR removed [removed_name]", FTLOG_DEBUG)
	ftpop_log("CLEAR house '[house.housename]' DONE removed=[cleaned]", FTLOG_INFO)
	return cleaned

/datum/controller/subsystem/familytree/proc/ftpop_dump_user_house(mob/living/carbon/human/user)
	var/list/out = list()
	if(!user || !user.family_datum)
		out += "USER has no house"
		return out
	var/datum/heritage/house = user.family_datum
	out += "HOUSE '[house.housename]' race=[house.dominant_race?.name || "none"] members=[house.member_nodes.len]"
	var/datum/family_member/user_member = user.family_member_datum
	if(user_member)
		out += "USER_MEMBER: parents=[user_member.get_parent_members().len] children=[user_member.get_child_members().len] spouses=[user_member.get_spouse_members().len] former_spouses=[user_member.get_former_spouse_members().len]"
	for(var/datum/family_node/node as anything in house.member_nodes)
		if(!node.person)
			out += "  NODE(phantom) edges=[node.edges.len]"
			continue
		var/mob/living/carbon/human/H = node.person
		var/datum/family_member/mem = H.family_member_datum
		var/rel_info = ""
		if(mem && mem != user_member && user_member)
			var/rel = user_member.GetRelationshipTo(mem)
			rel_info = " rel='[rel || "?"]'"
		out += "  [H.real_name] ([H.gender == MALE ? "M" : "F"], [H.dna?.species?.name]) parents=[mem?.get_parent_members()?.len || 0] children=[mem?.get_child_members()?.len || 0] adopted=[mem?.adoption_status ? "Y" : "N"][rel_info]"
	var/datum/family_graph_cache/cache = get_family_graph_cache(house, FALSE)
	if(cache)
		out += "CACHE dirty_rel=[cache.dirty_relations] dirty_disp=[cache.dirty_display] rev=[cache.revision]"
	return out

/datum/controller/subsystem/familytree/proc/ftpop_report_html(mob/living/carbon/human/user, action_title, result_payload)
	var/list/dump = ftpop_dump_user_house(user)
	var/list/out = list()
	out += {"<html><head><style>
		body { font-family: Consolas, monospace; font-size: 13px; background: #0f1420; color: #e4e7ef; padding: 12px; }
		h2 { color: #60a5fa; margin: 0 0 8px 0; font-size: 17px; }
		h3 { color: #f472b6; margin: 10px 0 4px 0; }
		.ok { color: #4ade80; } .warn { color: #fbbf24; } .err { color: #ef4444; }
		.tag { color: #8b92a5; } .info { color: #a5b4fc; }
		.line { border-bottom: 1px solid #232a3d; padding: 3px 0; }
		.node { padding: 2px 0 2px 12px; }
		pre { background: #171c2a; padding: 8px; border-radius: 6px; color: #e4e7ef; white-space: pre-wrap; }
		</style></head><body>"}
	out += "<h2>FT Populate: [action_title]</h2>"
	out += "<span class='tag'>session=#[debug_session_id] errors=[ftlog_error_count] warns=[ftlog_warn_count] families=[families.len]</span>"
	out += "<h3>Result</h3>"
	if(islist(result_payload))
		for(var/line in result_payload)
			out += "<div class='line'>[line]</div>"
	else
		out += "<div class='line'>[result_payload]</div>"
	out += "<h3>User's House State</h3>"
	for(var/line in dump)
		out += "<div class='line'>[line]</div>"
	out += "<h3>Log Tail (ss_family.log)</h3>"
	out += "<pre>Tail the <b>data/logs/ss_family.log</b> for the full flow. This panel reflects state AFTER the action.</pre>"
	out += "</body></html>"
	return out.Join("")

/datum/controller/subsystem/familytree/proc/ftpop_result_to_summary(result)
	if(!result)
		return "(null)"
	if(istext(result))
		return findtext(result, "OK:") == 1 ? result : "FAIL: [result]"
	if(istype(result, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = result
		return "OK: spawned [H.real_name] ([H.gender == MALE ? "M" : "F"], [H.dna?.species?.name || "?"])"
	if(istype(result, /datum/heritage))
		var/datum/heritage/house = result
		return "OK: house '[house.housename || "Nameless"]' members=[house.members.len]"
	if(istype(result, /datum/family_member))
		return "OK: phantom member"
	if(islist(result))
		var/list/lines = list()
		for(var/item in result)
			lines += ftpop_result_to_summary(item)
		return lines.Join("<br>")
	return "OK: [result]"

#endif

/client/proc/familytree_populate_house()
	set name = "FamilyTree Populate House"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

#ifdef FAMILYTREE_DEBUG_LOGGING
	if(!istype(mob, /mob/living/carbon/human))
		to_chat(mob, span_warning("You must be a human mob."))
		return
	var/mob/living/carbon/human/user = mob

	var/list/options = list(
		"=== QUICK ===",
		"Nuclear family (2 parents + 2 siblings)",
		"Extended family (3 generations + spouse + child + in-law)",
		"ALL variations (every relation type at once)",
		"=== MEMBERSHIP ===",
		"Create my debug house (direct)",
		"Join existing house (direct)",
		"Spawn NPC house member",
		"=== SINGLE RELATIVE ===",
		"Add father",
		"Add mother",
		"Add sibling",
		"Add biological child",
		"Add adopted child",
		"Add spouse",
		"Add former spouse (divorced)",
		"Add second spouse (polygamy)",
		"Add uncle/aunt",
		"Add cousin",
		"Add grandparent",
		"Add grandchild",
		"Add in-law (spouse's parent)",
		"=== RITUAL/EDGE ===",
		"Add phantom parent (ritual sibling bond seed)",
		"Add cross-species adopted child",
		"=== STATE ===",
		"Dump my house state",
		"Clear debug NPCs from my house",
		"Full log state snapshot",
	)

	var/choice = tgui_input_list(user, "Populate My House", "FT Populate", options)
	if(!choice || findtext(choice, "==="))
		return

	SSfamilytree.debug_session_id++
	SSfamilytree.ftpop_log("=== POPULATE action='[choice]' user=[user.real_name] session=#[SSfamilytree.debug_session_id] START ===", FTLOG_INFO)
	SSfamilytree.ftlog_state("FTPOP_PRE")

	var/result = null
	var/title = choice
	switch(choice)
		if("Nuclear family (2 parents + 2 siblings)")
			result = SSfamilytree.ftpop_quick_nuclear(user)
		if("Extended family (3 generations + spouse + child + in-law)")
			result = SSfamilytree.ftpop_quick_extended(user)
		if("ALL variations (every relation type at once)")
			result = SSfamilytree.ftpop_variation_all(user)
		if("Create my debug house (direct)")
			result = SSfamilytree.ftpop_ensure_user_house(user)
		if("Join existing house (direct)")
			var/list/house_choices = SSfamilytree.ftpop_house_choices(user)
			if(!house_choices.len)
				result = "no_other_houses"
			else
				var/house_choice = tgui_input_list(user, "Choose a house to join directly", "FT Populate", house_choices)
				if(!house_choice)
					result = "OK: cancelled"
				else
					var/list/role_choices = list(
						"Direct member (guaranteed)" = "direct",
						"Child (try relation)" = "child",
						"Sibling (try relation)" = "sibling",
						"Parent (try relation)" = "parent",
						"Spouse (try relation)" = "spouse",
					)
					var/role_choice = tgui_input_list(user, "How should you join?", "FT Populate", role_choices)
					if(!role_choice)
						result = "OK: cancelled"
					else
						result = SSfamilytree.ftpop_join_house_direct(user, house_choices[house_choice], role_choices[role_choice])
		if("Spawn NPC house member")
			result = SSfamilytree.ftpop_add_house_member(user)
		if("Add father")
			result = SSfamilytree.ftpop_add_parent(user, null, MALE, FALSE)
		if("Add mother")
			result = SSfamilytree.ftpop_add_parent(user, null, FEMALE, FALSE)
		if("Add sibling")
			result = SSfamilytree.ftpop_add_sibling(user)
		if("Add biological child")
			result = SSfamilytree.ftpop_add_child(user, null, null, FALSE)
		if("Add adopted child")
			result = SSfamilytree.ftpop_add_child(user, null, null, TRUE)
		if("Add spouse")
			result = SSfamilytree.ftpop_add_spouse(user)
		if("Add former spouse (divorced)")
			result = SSfamilytree.ftpop_add_spouse(user, null, null, TRUE, FALSE)
		if("Add second spouse (polygamy)")
			result = SSfamilytree.ftpop_add_spouse(user, null, null, FALSE, TRUE)
		if("Add uncle/aunt")
			result = SSfamilytree.ftpop_add_uncle_aunt(user)
		if("Add cousin")
			result = SSfamilytree.ftpop_add_cousin(user)
		if("Add grandparent")
			result = SSfamilytree.ftpop_add_grandparent(user)
		if("Add grandchild")
			result = SSfamilytree.ftpop_add_grandchild(user)
		if("Add in-law (spouse's parent)")
			result = SSfamilytree.ftpop_add_inlaw(user)
		if("Add phantom parent (ritual sibling bond seed)")
			result = SSfamilytree.ftpop_add_phantom_parent(user)
		if("Add cross-species adopted child")
			result = SSfamilytree.ftpop_add_child(user, pick(/datum/species/elf/dark, /datum/species/dwarf, /datum/species/tieberian), null, TRUE)
		if("Dump my house state")
			result = SSfamilytree.ftpop_dump_user_house(user)
		if("Clear debug NPCs from my house")
			result = "OK: Cleared [SSfamilytree.ftpop_clear_user_house(user)] debug NPCs"
		if("Full log state snapshot")
			SSfamilytree.ftlog_state("ADMIN_SNAPSHOT")
			result = "OK: Snapshot written to ss_family.log"

	var/summary = istype(result, /list) ? result : SSfamilytree.ftpop_result_to_summary(result)
	SSfamilytree.ftpop_log("=== POPULATE action='[choice]' DONE result=[SSfamilytree.ftpop_result_to_summary(result)] ===", FTLOG_INFO)
	SSfamilytree.ftlog_state("FTPOP_POST")
	user << browse(SSfamilytree.ftpop_report_html(user, title, summary), "window=ftpop;size=760x720")
#else
	to_chat(mob, span_warning("FamilyTree debugging is disabled. Define FAMILYTREE_DEBUG_LOGGING in familytree_module_config.dm"))
#endif

#ifdef FAMILYTREE_DEBUG_LOGGING
#undef FTDBG_POP_SESSION_TAG
#endif
