/datum/bond_probe
	var/list/violations = list()
	var/list/notes = list()
	var/list/scratch_minds = list()

	var/bonds_made = 0
	var/events_applied = 0
	var/events_skipped = 0
	var/dreams_rendered = 0
	var/stances_checked = 0

/datum/bond_probe/Destroy()
	release()
	violations = null
	notes = null
	return ..()

/datum/bond_probe/proc/fault(text)
	violations += text
	return FALSE

/datum/bond_probe/proc/note(text)
	notes += text

/datum/bond_probe/proc/scratch_mind()
	RETURN_TYPE(/datum/mind)
	var/datum/mind/created = new /datum/mind("BDPROBE_[length(scratch_minds) + 1]")
	created.name = "Probe [length(scratch_minds) + 1]"
	scratch_minds += created
	return created

/datum/bond_probe/proc/release()
	for(var/datum/mind/tracked as anything in scratch_minds)
		SSbonds.drop_actor(SSbonds.resolve_actor(tracked))
	scratch_minds = list()

/datum/bond_probe/proc/mortal_faction_ids()
	RETURN_TYPE(/list)
	var/list/out = list()
	for(var/faction_id in SSbonds.faction_prototypes)
		var/datum/bond_faction/faction = SSbonds.faction_prototypes[faction_id]
		if(istype(faction, /datum/bond_faction/clan))
			continue
		out += faction_id
	return out

/datum/bond_probe/proc/run_event_sweep(repeats = 1)
	if(!length(SSbonds.event_prototypes))
		return fault("no event prototypes exist, so nothing could be swept")

	for(var/event_type in SSbonds.event_prototypes)
		var/datum/bond_event/prototype = SSbonds.event_prototypes[event_type]
		if(!prototype)
			fault("[event_type] is indexed without a prototype")
			continue
		if(!length(prototype.category))
			fault("[event_type] has no category, so it can never occupy an active slot")
		for(var/pass in 1 to repeats)
			var/datum/mind/subject = scratch_mind()
			var/datum/mind/object = scratch_mind()
			var/datum/social_bond/bond = SSbonds.get_or_create_bond(subject, object)
			bonds_made++
			if(!bond)
				fault("could not open a bond for [event_type]")
				continue
			if(!bond.scored)
				events_skipped++
				continue
			bond.attach_event(event_type)
			events_applied++
			if(bond.warmth < BOND_WARMTH_MIN || bond.warmth > BOND_WARMTH_MAX)
				fault("[event_type] pushed warmth to [bond.warmth], outside the axis")
			if(bond.weight < BOND_WEIGHT_MIN || bond.weight > BOND_WEIGHT_MAX)
				fault("[event_type] pushed weight to [bond.weight], outside the axis")
			if(LAZYLEN(bond.history) > BOND_MAX_HISTORY)
				fault("[event_type] left [LAZYLEN(bond.history)] history entries, over the cap of [BOND_MAX_HISTORY]")
			if(!SSbonds.resolve_stage(bond))
				fault("[event_type] left the bond at warmth [bond.warmth] weight [bond.weight], where no stage matches")
	return !length(violations)

/datum/bond_probe/proc/run_dream_sweep()
	if(!length(SSbonds.dream_prototypes))
		return fault("no dreams are indexed, so the whole memory layer is dead")

	var/datum/mind/subject = scratch_mind()
	var/datum/mind/object = scratch_mind()
	var/datum/social_bond/bond = SSbonds.get_or_create_bond(subject, object)
	if(!bond)
		return fault("could not open a bond to render dreams against")

	var/list/seen_labels = list()
	for(var/event_type in SSbonds.dream_prototypes)
		var/datum/bond_event/dream/prototype = SSbonds.event_prototypes[event_type]
		if(!istype(prototype))
			fault("[event_type] is indexed as a dream but carries no dream prototype")
			continue
		var/story = prototype.build_story(bond)
		var/echo = prototype.build_echo(bond)
		if(!length(story))
			fault("[event_type] renders an empty story")
		if(!length(echo))
			fault("[event_type] renders an empty echo")
		if(findtext(story, "{name}") || findtext(echo, "{name}"))
			fault("[event_type] leaves an unreplaced {name} placeholder")
		if(!length(prototype.history_label))
			fault("[event_type] has no history label, so it renders as a blank row")
		if(prototype.valence != BOND_DREAM_POSITIVE && prototype.valence != BOND_DREAM_NEGATIVE)
			fault("[event_type] carries valence [prototype.valence], which belongs to no bucket")
		if(!prototype.scopes)
			fault("[event_type] fits no scope, so it can never be drawn")
		if(!prototype.rarity)
			fault("[event_type] has zero rarity, so the weighted draw can never pick it")
		seen_labels[prototype.history_label] = (seen_labels[prototype.history_label] || 0) + 1
		dreams_rendered++

	if(dreams_rendered != length(SSbonds.dream_prototypes))
		fault("rendered [dreams_rendered] of [length(SSbonds.dream_prototypes)] indexed dreams")
	return !length(violations)

/datum/bond_probe/proc/run_stance_sweep()
	var/list/templates = SSbonds.realm_templates()
	if(!length(templates))
		return fault("no realm template parsed, so every map would run on flat zero")

	var/list/mortal = mortal_faction_ids()
	for(var/realm in templates)
		var/list/template = templates[realm]
		var/list/blocs = template["blocs"]
		var/list/bloc_of = list()
		for(var/bloc_id in blocs)
			for(var/faction_id in blocs[bloc_id])
				if(!SSbonds.faction_prototypes[faction_id])
					fault("[realm] bloc [bloc_id] names [faction_id], which is not a faction")
					continue
				if(bloc_of[faction_id])
					fault("[realm] puts [faction_id] in both [bloc_of[faction_id]] and [bloc_id]")
					continue
				bloc_of[faction_id] = bloc_id
		if(!template["default"])
			fault("[realm] declares no default, so any pair its blocs miss falls to flat zero")
		var/list/loose = list()
		for(var/faction_id in mortal)
			if(!bloc_of[faction_id])
				loose += faction_id
		if(length(loose))
			note("[realm] leaves [loose.Join(", ")] outside every bloc")
		stances_checked += length(mortal) * (length(mortal) - 1) / 2
	return !length(violations)

/datum/bond_probe/proc/run_roster_sweep()
	var/list/mortal = mortal_faction_ids()
	if(length(mortal) < 2)
		return fault("the mortal roster collapsed to [length(mortal)] factions")

	for(var/faction_id in SSbonds.faction_prototypes)
		var/datum/bond_faction/faction = SSbonds.faction_prototypes[faction_id]
		if(!length(faction.name))
			fault("[faction_id] has no display name")
		if(!length(faction.id))
			fault("a faction prototype carries an empty id")
		if(istype(faction, /datum/bond_faction/clan))
			continue
		if(!length(faction.titles()))
			note("[faction_id] claims no job titles, so nobody can ever belong to it")

	for(var/i in 1 to length(mortal))
		for(var/j in (i + 1) to length(mortal))
			var/key = bonds_stance_key(mortal[i], mortal[j])
			if(!key)
				fault("[mortal[i]] and [mortal[j]] produce no stance key")
			if(key != bonds_stance_key(mortal[j], mortal[i]))
				fault("[mortal[i]]|[mortal[j]] is not symmetric under the key builder")
	return !length(violations)

/datum/bond_probe/proc/report()
	var/list/out = list()
	out += "bonds:   [bonds_made] opened, [events_applied] events applied, [events_skipped] skipped"
	out += "dreams:  [dreams_rendered] rendered of [length(SSbonds.dream_prototypes)] indexed"
	out += "stances: [stances_checked] pairs walked across [length(SSbonds.realm_templates())] realms"
	if(length(notes))
		out += "notes:"
		for(var/line in notes)
			out += "  . [line]"
	if(length(violations))
		out += "FAULTS ([length(violations)]):"
		for(var/line in violations)
			out += "  - [line]"
	else
		out += "no faults"
	return out.Join("\n")
