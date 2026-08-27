/datum/bonds_admin_panel
	var/tab = "factions"
	var/focus_ref
	var/partner_ref

/datum/controller/subsystem/bonds/proc/admin_candidates()
	RETURN_TYPE(/list)
	var/list/out = list()
	for(var/mob/living/carbon/human/person in GLOB.mob_list)
		if(!person.mind || istype(person, /mob/living/carbon/human/dummy))
			continue
		out += person
	return out

/datum/controller/subsystem/bonds/proc/admin_resolve_person(person_ref)
	RETURN_TYPE(/mob/living/carbon/human)
	if(!istext(person_ref))
		return null
	for(var/mob/living/carbon/human/person as anything in admin_candidates())
		if(REF(person) == person_ref)
			return person
	return null

/datum/controller/subsystem/bonds/proc/admin_people_list()
	RETURN_TYPE(/list)
	var/list/out = list()
	for(var/mob/living/carbon/human/person as anything in admin_candidates())
		var/datum/bond_faction/faction = faction_for(person)
		out += list(list(
			"ref" = REF(person),
			"name" = person.real_name || person.name,
			"job" = person.job || "-",
			"faction" = faction?.name || "-",
			"dead" = person.stat == DEAD,
		))
	return out

/datum/controller/subsystem/bonds/proc/admin_bond_entry(datum/social_bond/bond, datum/bond_actor/target)
	RETURN_TYPE(/list)
	var/datum/bond_stage/stage = bond.stage
	return list(
		"target" = target.name_of(),
		"warmth" = round(bond.warmth, 0.1),
		"weight" = round(bond.weight, 0.1),
		"warmthCommitted" = round(bond.warmth_committed, 0.1),
		"weightCommitted" = round(bond.weight_committed, 0.1),
		"stage" = stage?.label || "-",
		"accent" = stage?.accent || "#8a8a8a",
		"tags" = bond.tags,
		"history" = LAZYLEN(bond.history),
		"active" = LAZYLEN(bond.active_events),
	)

/datum/controller/subsystem/bonds/proc/admin_person_dump(mob/living/carbon/human/person)
	RETURN_TYPE(/list)
	if(!person?.mind)
		return null
	var/datum/bond_actor/actor = resolve_actor(person.mind)
	if(!actor)
		return null
	var/datum/bond_node/node = get_node(actor)
	var/list/bonds_out = list()
	var/list/kin_out = list()
	if(node)
		for(var/datum/bond_actor/target as anything in node.bonds)
			bonds_out += list(admin_bond_entry(node.bonds[target], target))
		for(var/datum/social_bond/kin/link as anything in node.kin)
			kin_out += list(list(
				"target" = link.other?.name_of() || "?",
				"kind" = link.kind,
				"adopted" = link.adopted,
				"house" = link.house?.housename || "-",
			))
	var/datum/bond_faction/faction = faction_for(person)
	return list(
		"ref" = REF(person),
		"name" = person.real_name || person.name,
		"job" = person.job || "-",
		"jobType" = "[job_type_of(person) || "-"]",
		"faction" = faction?.name || "-",
		"archetypes" = archetypes_for(person),
		"influence" = influence_left(person.mind),
		"muted" = influence_muted(person.mind),
		"bonds" = bonds_out,
		"kin" = kin_out,
	)

/datum/controller/subsystem/bonds/proc/admin_pair_dump(mob/living/carbon/human/subject, mob/living/carbon/human/object)
	RETURN_TYPE(/list)
	if(!subject?.mind || !object?.mind)
		return null
	var/datum/bond_actor/subject_actor = resolve_actor(subject.mind)
	var/datum/bond_actor/object_actor = resolve_actor(object.mind)
	if(!subject_actor || !object_actor)
		return null
	var/datum/social_bond/forward = get_bond(subject_actor, object_actor)
	var/datum/social_bond/backward = get_bond(object_actor, subject_actor)
	var/list/kinds = list()
	for(var/kind in bonds_kin_kinds())
		if(find_kin(subject_actor, object_actor, kind))
			kinds += kind
	return list(
		"forward" = forward ? admin_bond_entry(forward, object_actor) : null,
		"backward" = backward ? admin_bond_entry(backward, subject_actor) : null,
		"kin" = kinds,
	)

/proc/bonds_kin_kinds()
	RETURN_TYPE(/list)
	return list(BOND_KIN_PARENT, BOND_KIN_CHILD, BOND_KIN_SPOUSE, BOND_KIN_FORMER_SPOUSE, BOND_KIN_SWORN_SIBLING)

/datum/controller/subsystem/bonds/proc/admin_cache_dump()
	RETURN_TYPE(/list)
	var/list/state = debug_graph_state()
	var/list/houses = list()
	for(var/datum/heritage/house as anything in SSfamilytree?.families)
		var/datum/family_graph_cache/cache = SSfamilytree.get_family_graph_cache(house, FALSE)
		houses += list(list(
			"ref" = REF(house),
			"name" = house.housename || "?",
			"members" = length(house.members),
			"cached" = !!cache,
			"revision" = cache?.revision || 0,
			"dirtyRelations" = cache ? cache.dirty_relations : FALSE,
			"dirtyGenerations" = cache ? cache.dirty_generations : FALSE,
			"dirtyDisplay" = cache ? cache.dirty_display : FALSE,
			"relationRows" = cache ? length(cache.relation_matrix) : 0,
			"displayTrees" = cache ? length(cache.display_tree_by_checker) : 0,
		))
	return list(
		"graph" = state,
		"seedFlavors" = length(seed_flavor_cache),
		"zoneLens" = length(zone_lens_cache),
		"mapWeight" = isnull(map_weight_cache) ? "не считан" : "[map_weight_cache]",
		"dreams" = length(dream_prototypes),
		"rulingGod" = "[ruling_god_type() || "нет"]",
		"lensApplied" = storyteller_lens_applied,
		"houses" = houses,
	)

/datum/controller/subsystem/bonds/proc/admin_resolve_house(house_ref)
	RETURN_TYPE(/datum/heritage)
	if(!istext(house_ref) || !SSfamilytree)
		return null
	for(var/datum/heritage/house as anything in SSfamilytree.families)
		if(REF(house) == house_ref)
			return house
	return null

/datum/controller/subsystem/bonds/proc/build_admin_payload(datum/bonds_admin_panel/panel)
	RETURN_TYPE(/list)
	var/list/payload = build_admin_data()
	payload["tab"] = panel.tab
	payload["people"] = admin_people_list()
	var/mob/living/carbon/human/focus = admin_resolve_person(panel.focus_ref)
	var/mob/living/carbon/human/partner = admin_resolve_person(panel.partner_ref)
	payload["focus"] = focus ? admin_person_dump(focus) : null
	payload["partner"] = partner ? admin_person_dump(partner) : null
	payload["pair"] = (focus && partner) ? admin_pair_dump(focus, partner) : null
	payload["kinKinds"] = bonds_kin_kinds()
	payload["caches"] = admin_cache_dump()
	return payload

/datum/controller/subsystem/bonds/proc/admin_set_bond(mob/user, mob/living/carbon/human/subject, mob/living/carbon/human/object, warmth, weight)
	if(!subject?.mind || !object?.mind || subject == object)
		return FALSE
	if(!isnum(warmth) || !isnum(weight))
		return FALSE
	var/datum/social_bond/bond = get_or_create_bond(subject.mind, object.mind)
	if(!bond)
		return FALSE
	bond.warmth_committed = clamp(round(warmth), BOND_WARMTH_MIN, BOND_WARMTH_MAX)
	bond.weight_committed = clamp(round(weight), BOND_WEIGHT_MIN, BOND_WEIGHT_MAX)
	bond.recalculate()
	log_admin("[key_name(user)] set bond [subject.real_name] -> [object.real_name] warmth [bond.warmth_committed] weight [bond.weight_committed]")
	bondlog("admin [key_name(user)] set bond [subject.real_name] -> [object.real_name] warmth=[bond.warmth_committed] weight=[bond.weight_committed]", BONDLOG_WARN)
	return TRUE

/datum/controller/subsystem/bonds/proc/admin_toggle_tag(mob/user, mob/living/carbon/human/subject, mob/living/carbon/human/object, tag_flag)
	if(!subject?.mind || !object?.mind || !isnum(tag_flag))
		return FALSE
	var/datum/social_bond/bond = get_bond(subject.mind, object.mind)
	if(!bond)
		return FALSE
	bond.tags ^= tag_flag
	bond.recalculate()
	log_admin("[key_name(user)] toggled bond tag [tag_flag] on [subject.real_name] -> [object.real_name]")
	return TRUE

/datum/controller/subsystem/bonds/proc/admin_drop_bond(mob/user, mob/living/carbon/human/subject, mob/living/carbon/human/object)
	if(!subject?.mind || !object?.mind)
		return FALSE
	var/datum/bond_node/node = get_node(subject.mind)
	if(!node)
		return FALSE
	if(!node.remove_bond(resolve_actor(object.mind)))
		return FALSE
	log_admin("[key_name(user)] dropped bond [subject.real_name] -> [object.real_name]")
	bondlog("admin [key_name(user)] dropped bond [subject.real_name] -> [object.real_name]", BONDLOG_WARN)
	return TRUE

/datum/controller/subsystem/bonds/proc/admin_set_kin(mob/user, mob/living/carbon/human/subject, mob/living/carbon/human/object, kind, adding)
	if(!subject?.mind || !object?.mind || subject == object)
		return FALSE
	if(!(kind in bonds_kin_kinds()))
		return FALSE
	if(adding)
		if((kind == BOND_KIN_PARENT) && kin_would_cycle(subject.mind, object.mind))
			to_chat(user, span_warning("Это замкнуло бы родословную в петлю."))
			return FALSE
		if(!add_kin(subject.mind, object.mind, kind, FALSE, subject.family_datum))
			return FALSE
		log_admin("[key_name(user)] linked [subject.real_name] -> [object.real_name] as [kind]")
	else
		if(!remove_kin(subject.mind, object.mind, kind))
			return FALSE
		log_admin("[key_name(user)] unlinked [subject.real_name] -> [object.real_name] ([kind])")
	bondlog("admin [key_name(user)] [adding ? "added" : "removed"] kin [kind]: [subject.real_name] -> [object.real_name]", BONDLOG_WARN)
	if(subject.family_datum)
		SSfamilytree?.mark_family_dirty(SSfamilytree.get_family_node(subject), SSfamilytree.get_family_node(object), subject.family_datum)
	return TRUE

/datum/controller/subsystem/bonds/proc/admin_flush_lookup_caches(mob/user)
	seed_flavor_cache = null
	zone_lens_cache = list()
	map_weight_cache = null
	present_factions_cache = null
	faction_map_cache = null
	faction_map_cache_revision = -1
	log_admin("[key_name(user)] flushed bonds lookup caches")
	bondlog("admin [key_name(user)] flushed lookup caches", BONDLOG_WARN)
	return TRUE

/datum/controller/subsystem/bonds/proc/admin_house_cache(mob/user, datum/heritage/house, drop)
	if(!house || !SSfamilytree)
		return FALSE
	if(drop)
		SSfamilytree.drop_family_graph_cache(house)
		log_admin("[key_name(user)] dropped the family graph cache for [house.housename]")
	else
		var/datum/family_graph_cache/cache = SSfamilytree.get_family_graph_cache(house, TRUE)
		cache?.mark_all_dirty()
		log_admin("[key_name(user)] marked the family graph cache dirty for [house.housename]")
	return TRUE

/datum/bonds_admin_panel/proc/handle_admin_act(action, list/params, mob/user)
	switch(action)
		if("set_tab")
			var/requested = params["tab"]
			if(!(requested in list("factions", "person", "relation", "caches")))
				return FALSE
			tab = requested
			return TRUE

		if("pick_person")
			focus_ref = params["ref"]
			return TRUE

		if("pick_partner")
			partner_ref = params["ref"]
			return TRUE

		if("swap_pair")
			var/held = focus_ref
			focus_ref = partner_ref
			partner_ref = held
			return TRUE

		if("set_bond")
			var/mob/living/carbon/human/subject = SSbonds.admin_resolve_person(params["from"])
			var/mob/living/carbon/human/object = SSbonds.admin_resolve_person(params["to"])
			return SSbonds.admin_set_bond(user, subject, object, params["warmth"], params["weight"])

		if("toggle_tag")
			var/mob/living/carbon/human/subject = SSbonds.admin_resolve_person(params["from"])
			var/mob/living/carbon/human/object = SSbonds.admin_resolve_person(params["to"])
			return SSbonds.admin_toggle_tag(user, subject, object, params["tag"])

		if("drop_bond")
			var/mob/living/carbon/human/subject = SSbonds.admin_resolve_person(params["from"])
			var/mob/living/carbon/human/object = SSbonds.admin_resolve_person(params["to"])
			return SSbonds.admin_drop_bond(user, subject, object)

		if("set_kin")
			var/mob/living/carbon/human/subject = SSbonds.admin_resolve_person(params["from"])
			var/mob/living/carbon/human/object = SSbonds.admin_resolve_person(params["to"])
			return SSbonds.admin_set_kin(user, subject, object, params["kind"], !!params["adding"])

		if("flush_caches")
			return SSbonds.admin_flush_lookup_caches(user)

		if("house_cache")
			var/datum/heritage/house = SSbonds.admin_resolve_house(params["ref"])
			return SSbonds.admin_house_cache(user, house, !!params["drop"])

	return FALSE
