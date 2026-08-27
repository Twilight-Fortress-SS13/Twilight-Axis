/datum/controller/subsystem/bonds/proc/build_family_entries(mob/living/carbon/human/viewer)
	RETURN_TYPE(/list)
	var/list/entries = list()
	var/datum/heritage/house = viewer?.family_datum
	var/datum/family_member/checker = viewer?.family_member_datum
	if(!house || !checker)
		return entries
	for(var/datum/family_member/member as anything in house.members)
		if(!member?.person || member == checker)
			continue
		if(member.cosmetic || member.phantom)
			continue
		var/relation = SSfamilytree.get_cached_relation(house, checker, member)
		if(!relation)
			continue
		entries += list(build_family_entry(viewer, house, member, relation))
	return entries

/datum/controller/subsystem/bonds/proc/build_family_entry(mob/living/carbon/human/viewer, datum/heritage/house, datum/family_member/member, relation)
	RETURN_TYPE(/list)
	var/list/history = list()
	var/sentiment = ""
	var/datum/social_bond/bond = get_bond(viewer.mind, member.person?.mind)
	if(bond && bond.weight >= BOND_VISIBLE_WEIGHT)
		sentiment = bond.stage_label()
		for(var/datum/bond_history/entry as anything in bond.history)
			history += list(list(
				"label" = entry.label,
				"story" = entry.story,
			))
	return list(
		"name" = member.person.real_name,
		"label" = uppertext(relation),
		"desc" = sentiment,
		"accent" = house.GetRelationColor(relation) || "#c0a060",
		"job" = member.person.job || "",
		"species" = member.person.dna?.species?.name || "",
		"history" = history,
	)

/datum/controller/subsystem/bonds/proc/family_mind_set(mob/living/carbon/human/viewer)
	RETURN_TYPE(/list)
	var/list/actors = list()
	var/datum/heritage/house = viewer?.family_datum
	if(!house)
		return actors
	for(var/datum/family_member/member as anything in house.members)
		var/datum/bond_actor/actor = resolve_actor(member)
		if(!actor)
			continue
		actors[actor] = TRUE
	return actors

/datum/bonds_panel
	var/mob/living/carbon/human/viewer

/datum/bonds_panel/New(mob/living/carbon/human/new_viewer)
	viewer = new_viewer

/datum/bonds_panel/Destroy(force)
	viewer = null
	return ..()

/datum/bonds_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/bonds_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Bonds")
		ui.open()
		ui.set_autoupdate(FALSE)
	return TRUE

/datum/bonds_panel/ui_data(mob/user)
	if(user != viewer || !viewer?.mind)
		return list("groups" = list())
	return list("groups" = SSbonds.build_panel_groups(viewer))

/datum/bonds_panel/ui_close()
	QDEL_NULL(src)

/datum/controller/subsystem/bonds/proc/build_panel_groups(mob/living/carbon/human/viewer)
	RETURN_TYPE(/list)
	var/list/groups = list()
	var/list/family_entries = build_family_entries(viewer)
	var/list/kin = family_mind_set(viewer)
	if(length(family_entries))
		groups += list(list(
			"key" = BOND_GROUP_FAMILY,
			"entries" = family_entries,
		))

	var/list/buckets = list()
	for(var/datum/social_bond/bond as anything in get_bonds_for(viewer.mind))
		if(bond.weight < BOND_VISIBLE_WEIGHT)
			continue
		if(kin[bond.other])
			continue
		var/group = bond.stage_group()
		if(!buckets[group])
			buckets[group] = list()
		buckets[group] += list(build_panel_entry(bond))
	for(var/group_key in buckets)
		groups += list(list(
			"key" = group_key,
			"entries" = buckets[group_key],
		))
	return groups

/datum/controller/subsystem/bonds/proc/build_panel_entry(datum/social_bond/bond)
	RETURN_TYPE(/list)
	var/list/history = list()
	for(var/datum/bond_history/entry as anything in bond.history)
		history += list(list(
			"label" = entry.label,
			"story" = entry.story,
		))
	return list(
		"name" = bond.display_name(),
		"label" = bond.stage_label(),
		"desc" = bond.stage?.desc || "",
		"accent" = bond.stage?.accent || "#8a8a8a",
		"job" = bond.snapshot?["job"] || "",
		"species" = bond.snapshot?["species"] || "",
		"history" = history,
	)

/datum/bonds_tree_panel
	var/mob/living/carbon/human/viewer

/datum/bonds_tree_panel/New(mob/living/carbon/human/new_viewer)
	viewer = new_viewer

/datum/bonds_tree_panel/Destroy(force)
	viewer = null
	return ..()

/datum/bonds_tree_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/bonds_tree_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BondsTree")
		ui.open()
		ui.set_autoupdate(FALSE)
	return TRUE

/datum/bonds_tree_panel/ui_data(mob/user)
	if(user != viewer || !viewer?.mind)
		return list("self" = null, "edges" = list())
	return SSbonds.build_bonds_tree(viewer)

/datum/bonds_tree_panel/ui_close()
	QDEL_NULL(src)

/proc/bonds_history_payload(datum/social_bond/bond)
	RETURN_TYPE(/list)
	var/list/out = list()
	if(!LAZYLEN(bond.history))
		return out
	for(var/i in max(1, bond.history.len - BOND_MAX_HISTORY + 1) to bond.history.len)
		var/datum/bond_history/entry = bond.history[i]
		out += list(list(
			"label" = entry.label,
			"story" = entry.story,
			"warmth" = round(entry.warmth_delta, 0.1),
			"weight" = round(entry.weight_delta, 0.1),
			"dream" = entry.dream,
		))
	return out

/datum/controller/subsystem/bonds/proc/build_bonds_tree(mob/living/carbon/human/person)
	RETURN_TYPE(/list)
	var/list/edges = list()
	for(var/datum/social_bond/bond as anything in get_bonds_for(person.mind))
		if(bond.weight < BOND_VISIBLE_WEIGHT)
			continue
		var/datum/social_bond/mirror = get_bond(bond.other, person.mind)
		edges += list(list(
			"name" = bond.display_name(),
			"accent" = bond.stage?.accent || "#8a8a8a",
			"outLabel" = bond.stage_label(),
			"outProgress" = round(bond.progress_to_next(), 0.01),
			"inLabel" = mirror ? mirror.stage_label() : null,
			"inProgress" = mirror ? round(mirror.progress_to_next(), 0.01) : 0,
			"inAccent" = mirror?.stage?.accent || "#5a5a5a",
			"job" = bond.snapshot?["job"] || "",
			"log" = bonds_history_payload(bond),
		))
	return list(
		"self" = list(
			"name" = person.real_name,
			"accent" = "#d0c090",
		),
		"edges" = edges,
	)

/mob/living/carbon/human/verb/bonds_tree()
	set name = "Bonds Tree"
	set category = "Bonds"

	if(!mind)
		to_chat(src, span_warning("Вам некого вспоминать."))
		return
	var/datum/bonds_tree_panel/panel = new(src)
	panel.ui_interact(src)

/datum/controller/subsystem/bonds/proc/build_faction_map(mob/living/carbon/human/viewer)
	RETURN_TYPE(/list)
	var/list/shape = faction_map_shape()
	var/own_id = faction_id_for(viewer)
	var/list/nodes = list()
	for(var/list/node as anything in shape["nodes"])
		nodes += list(node + list("own" = (node["id"] == own_id)))
	return list("nodes" = nodes, "edges" = shape["edges"])

/datum/controller/subsystem/bonds/proc/faction_bloc_layout()
	RETURN_TYPE(/list)
	var/list/template = current_realm_template()
	var/list/present = present_faction_ids()
	var/list/blocs = list()
	var/list/bloc_of = list()

	if(template)
		var/list/declared = template["blocs"]
		var/list/labels = template["bloc_names"]
		for(var/bloc_id in declared)
			var/list/members = list()
			for(var/faction_id in declared[bloc_id])
				if(!(faction_id in present))
					continue
				members += faction_id
				bloc_of[faction_id] = bloc_id
			if(!length(members))
				continue
			blocs += list(list(
				"id" = bloc_id,
				"name" = labels?[bloc_id] || bloc_id,
				"members" = members,
			))

	var/list/loose = list()
	for(var/faction_id in present)
		if(!bloc_of[faction_id])
			loose += faction_id
			bloc_of[faction_id] = BOND_LOOSE_BLOC
	if(length(loose))
		blocs += list(list(
			"id" = BOND_LOOSE_BLOC,
			"name" = "Прочие",
			"members" = loose,
		))

	return list("blocs" = blocs, "bloc_of" = bloc_of)

/datum/controller/subsystem/bonds/proc/faction_map_shape()
	RETURN_TYPE(/list)
	if(faction_map_cache && faction_map_cache_revision == stance_revision)
		return faction_map_cache

	var/list/layout = faction_bloc_layout()
	var/list/blocs = layout["blocs"]
	var/list/bloc_of = layout["bloc_of"]
	var/list/template = current_realm_template()
	var/list/overrides = template?["overrides"] || list()

	var/list/nodes = list()
	var/list/ordered = list()
	for(var/faction_id in present_faction_ids())
		var/datum/bond_faction/faction = faction_prototypes[faction_id]
		ordered += faction_id
		nodes += list(list(
			"id" = faction.id,
			"name" = faction.name,
			"accent" = faction.accent,
			"icon" = faction.icon_glyph,
			"bloc" = bloc_of[faction_id],
		))

	var/list/edges = list()
	for(var/i in 1 to length(ordered))
		for(var/j in (i + 1) to length(ordered))
			var/id_a = ordered[i]
			var/id_b = ordered[j]
			var/datum/faction_stance/stance = get_stance(id_a, id_b)
			var/warmth = stance ? stance.warmth : 0
			var/weight = stance ? stance.weight : 0
			edges += list(list(
				"a" = id_a,
				"b" = id_b,
				"label" = bonds_stance_label(warmth),
				"accent" = bonds_stance_accent(warmth),
				"warmth" = round(warmth),
				"weight" = round(weight),
				"declared" = (!isnull(stance) && (warmth || weight >= BOND_MAP_MIN_WEIGHT)),
				"inner" = (bloc_of[id_a] == bloc_of[id_b]),
				"exception" = !isnull(overrides[bonds_stance_key(id_a, id_b)]),
			))

	var/list/bloc_edges = list()
	var/list/bloc_axis = template?["bloc_axis"]
	var/list/between = template?["between"]
	if(length(bloc_axis) > 1 && between)
		var/list/live = list()
		for(var/list/entry as anything in blocs)
			live[entry["id"]] = TRUE
		var/list/warmth_rows = between[1]
		var/list/weight_rows = between[2]
		for(var/i in 1 to length(bloc_axis))
			var/list/warmth_row = warmth_rows[i]
			var/list/weight_row = weight_rows[i]
			for(var/j in (i + 1) to length(bloc_axis))
				if(!live[bloc_axis[i]] || !live[bloc_axis[j]])
					continue
				var/warmth = warmth_row[j - i]
				var/weight = weight_row[j - i]
				if(isnull(warmth) || isnull(weight))
					continue
				bloc_edges += list(list(
					"a" = bloc_axis[i],
					"b" = bloc_axis[j],
					"label" = bonds_stance_label(warmth),
					"accent" = bonds_stance_accent(warmth),
					"warmth" = round(warmth),
					"weight" = round(weight),
				))

	faction_map_cache = list("nodes" = nodes, "edges" = edges, "blocs" = blocs, "blocEdges" = bloc_edges)
	faction_map_cache_revision = stance_revision
	return faction_map_cache

/proc/bonds_stance_label(warmth)
	if(warmth >= 60)
		return "союз"
	if(warmth >= 25)
		return "дружба"
	if(warmth >= 10)
		return "приязнь"
	if(warmth <= -60)
		return "вражда"
	if(warmth <= -25)
		return "неприязнь"
	if(warmth <= -10)
		return "трения"
	return "нейтралитет"

/proc/bonds_stance_accent(warmth)
	if(warmth >= 25)
		return "#4c9f70"
	if(warmth >= 10)
		return "#7fb069"
	if(warmth <= -25)
		return "#b4553f"
	if(warmth <= -10)
		return "#c08a3e"
	return "#8a8a8a"

/proc/bonds_stance_intensity(weight)
	if(weight >= 60)
		return "тесно переплетены"
	if(weight >= 30)
		return "считаются друг с другом"
	return "почти не пересекаются"

/datum/bonds_faction_panel
	var/mob/living/carbon/human/viewer

/datum/bonds_faction_panel/New(mob/living/carbon/human/new_viewer)
	viewer = new_viewer

/datum/bonds_faction_panel/Destroy(force)
	viewer = null
	return ..()

/datum/bonds_faction_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/bonds_faction_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BondsFactions")
		ui.open()
		ui.set_autoupdate(FALSE)
	return TRUE

/datum/bonds_faction_panel/ui_data(mob/user)
	if(user != viewer)
		return list("ownFaction" = null, "map" = list("nodes" = list(), "edges" = list()), "ownHouse" = null, "houses" = list(), "ownClan" = null, "clans" = list())
	return SSbonds.build_faction_panel(viewer)

/datum/bonds_faction_panel/ui_close()
	QDEL_NULL(src)

/datum/controller/subsystem/bonds/proc/build_faction_panel(mob/living/carbon/human/person)
	RETURN_TYPE(/list)
	var/datum/bond_faction/own = faction_for(person)
	return list(
		"ownFaction" = own ? list("name" = own.name, "accent" = own.accent, "icon" = own.icon_glyph) : null,
		"map" = build_faction_map(person),
		"ownHouse" = person.family_datum?.GetDisplayHouseTitle(),
		"houses" = build_house_panel(person),
		"ownClan" = clan_faction_for(person)?.name,
		"clans" = build_clan_panel(person),
	)

/datum/controller/subsystem/bonds/proc/build_house_panel(mob/living/carbon/human/person)
	RETURN_TYPE(/list)
	var/list/out = list()
	var/datum/heritage/own = person?.family_datum
	if(!own)
		return out
	for(var/datum/house_stance/stance as anything in house_stances_for(own))
		var/datum/heritage/other = other_house_in(stance, own)
		if(!other)
			continue
		out += list(list(
			"name" = other.GetDisplayHouseTitle() || other.housename || "безымянный дом",
			"label" = bonds_stance_label(stance.warmth),
			"labelAccent" = bonds_stance_accent(stance.warmth),
			"intensity" = bonds_stance_intensity(stance.weight),
			"incidents" = stance.incidents,
		))
	return out

/mob/living/carbon/human/verb/bonds_factions()
	set name = "Faction Standing"
	set category = "Bonds"

	if(!SSbonds.faction_for(src) && !family_datum && !SSbonds.clan_faction_for(src))
		to_chat(src, span_notice("Вы не представляете никого, кроме себя."))
		return
	var/datum/bonds_faction_panel/panel = new(src)
	panel.ui_interact(src)

/datum/bonds_roster_panel
	var/mob/living/carbon/human/viewer

/datum/bonds_roster_panel/New(mob/living/carbon/human/new_viewer)
	viewer = new_viewer

/datum/bonds_roster_panel/Destroy(force)
	viewer = null
	return ..()

/datum/bonds_roster_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/bonds_roster_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BondsRoster")
		ui.open()
		ui.set_autoupdate(FALSE)
	return TRUE

/datum/bonds_roster_panel/ui_data(mob/user)
	if(user != viewer)
		return list("own" = null, "ally" = null)
	return SSbonds.build_roster_data(viewer)

/datum/bonds_roster_panel/ui_close()
	QDEL_NULL(src)

/datum/controller/subsystem/bonds/proc/build_roster_block(faction_id, mob/living/carbon/human/viewer, leaders_only = FALSE)
	RETURN_TYPE(/list)
	var/datum/bond_faction/faction = get_faction(faction_id)
	if(!faction)
		return null
	var/list/members = faction_members(faction_id)
	var/list/ranks = list()
	var/list/seen = list()

	for(var/datum/bond_rank/rank as anything in hierarchy_by_faction[faction_id])
		if(leaders_only && rank.level > 2)
			continue
		var/list/people = list()
		for(var/mob/living/carbon/human/person as anything in members)
			if(seen[person] || !(person.job in rank.titles))
				continue
			seen[person] = TRUE
			people += list(list(
				"name" = person.real_name,
				"job" = person.job,
				"self" = (person == viewer),
			))
		var/list/vacant = list()
		if(!leaders_only)
			for(var/title in rank.titles)
				var/taken = FALSE
				for(var/list/entry as anything in people)
					if(entry["job"] == title)
						taken = TRUE
						break
				if(!taken)
					vacant += title
		ranks += list(list(
			"label" = rank.label,
			"level" = rank.level,
			"leader" = (rank.level == 1),
			"people" = people,
			"vacant" = vacant,
		))

	if(!leaders_only)
		var/list/unranked = list()
		for(var/mob/living/carbon/human/person as anything in members)
			if(seen[person])
				continue
			unranked += list(list(
				"name" = person.real_name,
				"job" = person.job,
				"self" = (person == viewer),
			))
		if(length(unranked))
			ranks += list(list(
				"label" = "Прочие",
				"level" = 99,
				"leader" = FALSE,
				"people" = unranked,
				"vacant" = list(),
			))

	return list(
		"id" = faction.id,
		"name" = faction.name,
		"accent" = faction.accent,
		"icon" = faction.icon_glyph,
		"ranks" = ranks,
		"total" = length(members),
	)

/datum/controller/subsystem/bonds/proc/build_roster_data(mob/living/carbon/human/viewer)
	RETURN_TYPE(/list)
	var/own_id = faction_id_for(viewer)
	if(!own_id)
		return list("own" = null, "ally" = null)
	var/ally_id = best_allied_faction(own_id)
	var/list/leaders = list()
	for(var/faction_id in present_faction_ids())
		if(faction_id == own_id || faction_id == ally_id)
			continue
		var/list/block = build_roster_block(faction_id, viewer, TRUE)
		if(!block)
			continue
		var/warmth = own_id ? round(stance_warmth(own_id, faction_id)) : 0
		block["warmth"] = warmth
		block["label"] = own_id ? bonds_stance_label(warmth) : ""
		block["labelAccent"] = bonds_stance_accent(warmth)
		leaders += list(block)
	return list(
		"own" = own_id ? build_roster_block(own_id, viewer, FALSE) : null,
		"ally" = ally_id ? build_roster_block(ally_id, viewer, TRUE) : null,
		"allyWarmth" = ally_id ? round(stance_warmth(own_id, ally_id)) : 0,
		"leaders" = leaders,
	)

/mob/living/carbon/human/verb/bonds_roster()
	set name = "Faction Roster"
	set category = "Bonds"

	if(!SSbonds.faction_for(src))
		to_chat(src, span_notice("Вы никому не подчиняетесь и никем не командуете, но знать, кто здесь распоряжается, вам никто не мешает."))
	var/datum/bonds_roster_panel/panel = new(src)
	panel.ui_interact(src)

/datum/bonds_prefs_panel
	var/mob/living/carbon/human/viewer

/datum/bonds_prefs_panel/New(mob/living/carbon/human/new_viewer)
	viewer = new_viewer

/datum/bonds_prefs_panel/Destroy(force)
	viewer = null
	return ..()

/datum/bonds_prefs_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/bonds_prefs_panel/ui_interact(mob/user, datum/tgui/ui)
	if(user != viewer)
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BondsPrefs")
		ui.open()
		ui.set_autoupdate(FALSE)
	return TRUE

/datum/bonds_prefs_panel/ui_data(mob/user)
	var/datum/preferences/prefs = viewer?.client?.prefs
	if(user != viewer || !prefs)
		return list("seedCount" = 0, "maxSeeds" = BOND_MAX_SEEDS, "flavors" = list(), "locked" = TRUE)
	var/list/labels = SSbonds.seed_flavor_labels()
	var/list/flavors = list()
	for(var/flavor_key in labels)
		flavors += list(list(
			"key" = flavor_key,
			"label" = labels[flavor_key],
			"enabled" = (flavor_key in prefs.bonds_seed_flavors),
		))
	return list(
		"seedCount" = prefs.bonds_seed_count,
		"maxSeeds" = BOND_MAX_SEEDS,
		"flavors" = flavors,
		"locked" = !isnull(SSbonds.get_round_prefs(viewer.ckey)),
	)

/datum/bonds_prefs_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/datum/preferences/prefs = viewer?.client?.prefs
	if(!prefs || ui.user != viewer)
		return FALSE

	switch(action)
		if("set_seed_count")
			var/value = params["value"]
			if(!isnum(value))
				return FALSE
			prefs.bonds_seed_count = clamp(round(value), 0, BOND_MAX_SEEDS)
			prefs.bonds_module_sanitize_character()
			return TRUE

		if("toggle_flavor")
			var/flavor_key = params["key"]
			if(!istext(flavor_key))
				return FALSE
			if(!(flavor_key in SSbonds.valid_seed_flavors()))
				return FALSE
			if(flavor_key in prefs.bonds_seed_flavors)
				prefs.bonds_seed_flavors -= flavor_key
			else
				prefs.bonds_seed_flavors += flavor_key
			return TRUE

	return FALSE

/datum/bonds_prefs_panel/ui_close()
	QDEL_NULL(src)

/datum/bonds_admin_panel
	var/client/holder

/datum/bonds_admin_panel/New(client/new_holder)
	holder = new_holder

/datum/bonds_admin_panel/Destroy(force)
	holder = null
	return ..()

/datum/bonds_admin_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/bonds_admin_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BondsAdmin")
		ui.set_autoupdate(FALSE)
		ui.open()
	return TRUE

/datum/bonds_admin_panel/ui_data(mob/user)
	return SSbonds.build_admin_payload(src)

/datum/bonds_admin_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!check_rights_for(ui.user.client, R_ADMIN))
		return FALSE

	switch(action)
		if("set_stance")
			var/id_a = params["a"]
			var/id_b = params["b"]
			var/warmth = params["warmth"]
			var/weight = params["weight"]
			if(!istext(id_a) || !istext(id_b) || !isnum(warmth) || !isnum(weight))
				return FALSE
			if(!SSbonds.get_faction(id_a) || !SSbonds.get_faction(id_b))
				return FALSE
			var/datum/faction_stance/stance = SSbonds.get_or_create_stance(id_a, id_b)
			if(!stance)
				return FALSE
			stance.warmth = clamp(round(warmth), BOND_WARMTH_MIN, BOND_WARMTH_MAX)
			stance.weight = clamp(round(weight), BOND_WEIGHT_MIN, BOND_WEIGHT_MAX)
			stance.updated_at = world.time
			SSbonds.stance_revision++
			log_admin("[key_name(ui.user)] set bond stance [id_a]/[id_b] to warmth [stance.warmth] weight [stance.weight]")
			SSbonds.bondlog("admin [key_name(ui.user)] set [id_a]/[id_b] warmth=[stance.warmth] weight=[stance.weight]", BONDLOG_WARN)
			return TRUE

		if("reset_stance")
			var/id_a = params["a"]
			var/id_b = params["b"]
			var/key = bonds_stance_key(id_a, id_b)
			if(!key || !SSbonds.faction_stances[key])
				return FALSE
			var/datum/faction_stance/stance = SSbonds.faction_stances[key]
			SSbonds.faction_stances -= key
			SSbonds.stance_revision++
			qdel(stance)
			log_admin("[key_name(ui.user)] cleared bond stance [id_a]/[id_b]")
			return TRUE

	return handle_admin_act(action, params, ui.user)

/datum/bonds_admin_panel/ui_close()
	QDEL_NULL(src)

/datum/controller/subsystem/bonds/proc/build_admin_data()
	RETURN_TYPE(/list)
	var/list/factions = list()
	for(var/faction_id in faction_prototypes)
		var/datum/bond_faction/faction = faction_prototypes[faction_id]
		factions += list(list(
			"id" = faction.id,
			"name" = faction.name,
			"accent" = faction.accent,
			"clan" = istype(faction, /datum/bond_faction/clan),
		))

	var/list/stances = list()
	for(var/key in faction_stances)
		var/datum/faction_stance/stance = faction_stances[key]
		var/datum/bond_faction/faction_a = faction_prototypes[stance.faction_a]
		var/datum/bond_faction/faction_b = faction_prototypes[stance.faction_b]
		if(!faction_a || !faction_b)
			continue
		stances += list(list(
			"a" = stance.faction_a,
			"b" = stance.faction_b,
			"nameA" = faction_a.name,
			"nameB" = faction_b.name,
			"warmth" = round(stance.warmth),
			"weight" = round(stance.weight),
			"label" = bonds_stance_label(stance.warmth),
			"labelAccent" = bonds_stance_accent(stance.warmth),
			"history" = LAZYLEN(stance.history),
		))

	var/list/houses = list()
	for(var/key in house_stances)
		var/datum/house_stance/stance = house_stances[key]
		if(QDELETED(stance.house_a) || QDELETED(stance.house_b))
			continue
		houses += list(list(
			"nameA" = stance.house_a.housename || "безымянный",
			"nameB" = stance.house_b.housename || "безымянный",
			"warmth" = round(stance.warmth),
			"weight" = round(stance.weight),
			"incidents" = stance.incidents,
			"label" = bonds_stance_label(stance.warmth),
			"labelAccent" = bonds_stance_accent(stance.warmth),
		))

	var/datum/storyteller/teller = active_storyteller()
	return list(
		"factions" = factions,
		"stances" = stances,
		"houses" = houses,
		"storyteller" = teller ? "[teller.type]" : null,
		"mapName" = SSmapping?.config?.map_name,
		"warmthMin" = BOND_WARMTH_MIN,
		"warmthMax" = BOND_WARMTH_MAX,
		"weightMax" = BOND_WEIGHT_MAX,
	)

/client/proc/bonds_admin_panel()
	set name = "Bonds: Faction Relations"
	set category = "Admin.Game"

	if(!check_rights(R_ADMIN))
		return
	var/datum/bonds_admin_panel/panel = new(src)
	panel.ui_interact(mob)

/mob/living/carbon/human/proc/bonds_open_panel()
	var/datum/bonds_panel/panel = new(src)
	panel.ui_interact(src)
	return TRUE

/mob/living/carbon/human/verb/my_bonds()
	set name = "My Bonds"
	set category = "Bonds"

	if(!mind)
		to_chat(src, span_warning("Вам некого вспоминать."))
		return
	bonds_open_panel()

