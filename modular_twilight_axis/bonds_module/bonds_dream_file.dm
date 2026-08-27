GLOBAL_LIST_INIT(bond_dream_archetype_words, list(
	"warrior" = BOND_ARCH_WARRIOR,
	"lawman" = BOND_ARCH_LAWMAN,
	"devout" = BOND_ARCH_DEVOUT,
	"noble" = BOND_ARCH_NOBLE,
	"scholar" = BOND_ARCH_SCHOLAR,
	"healer" = BOND_ARCH_HEALER,
	"crafter" = BOND_ARCH_CRAFTER,
	"merchant" = BOND_ARCH_MERCHANT,
	"outlaw" = BOND_ARCH_OUTLAW,
	"servile" = BOND_ARCH_SERVILE,
	"wanderer" = BOND_ARCH_WANDERER,
	"undead" = BOND_ARCH_UNDEAD,
))

/proc/bonds_parse_archetype_mask(text, list/unknown)
	var/mask = 0
	for(var/word in bonds_split_words(lowertext(text)))
		var/found = GLOB.bond_dream_archetype_words[word]
		if(isnull(found))
			unknown += word
			continue
		mask |= found
	return mask

/datum/controller/subsystem/bonds/proc/apply_dream_config()
	var/applied = 0
	var/list/unknown_ids = list()
	for(var/name in flist("[BOND_STANCE_DIRECTORY]/"))
		if(!findtextEx(name, ".txt", -4))
			continue
		applied += load_dream_file(name, unknown_ids)
	if(length(unknown_ids))
		bondlog("dream config names memories that have no type: [unknown_ids.Join(", ")]", BONDLOG_WARN)

	var/list/starved = list()
	for(var/event_type in event_prototypes)
		var/datum/bond_event/dream/prototype = event_prototypes[event_type]
		if(!istype(prototype))
			continue
		if(!prototype.story_template)
			starved += "[event_type]"
	if(length(starved))
		bondlog("[length(starved)] memories have a type but no text, so they would fire blank: [starved.Join(", ")]", BONDLOG_ERROR)
	bondlog("dream config applied: [applied] memories", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/load_dream_file(name, list/unknown_ids)
	var/path = "[BOND_STANCE_DIRECTORY]/[name]"
	if(!fexists(path))
		return 0

	var/applied = 0
	var/line_number = 0
	var/datum/bond_event/dream/current
	var/list/unknown_words = list()

	for(var/line in world.file2list(path))
		line_number++
		var/trimmed = trim(line)
		if(!length(trimmed) || findtextEx(trimmed, "#") == 1)
			continue
		var/split = findtext(trimmed, ":")
		if(!split)
			bondlog("[name]:[line_number] has no colon", BONDLOG_WARN)
			continue
		var/label = trim(copytext(trimmed, 1, split))
		var/value = trim(copytext(trimmed, split + 1))
		var/list/words = bonds_split_words(lowertext(label))

		if(length(words) == 1 && (words[1] in list("realm", "default", "override")))
			current = null
			continue

		if(length(words) == 2 && (words[1] in list("bloc", "matrix")))
			current = null
			continue

		if(length(words) == 2 && words[1] == "dream")
			current = null
			var/dream_type = text2path("/datum/bond_event/dream/[words[2]]")
			if(!dream_type)
				unknown_ids += words[2]
				continue
			var/datum/bond_event/dream/prototype = event_prototypes[dream_type]
			if(!istype(prototype))
				unknown_ids += words[2]
				continue
			current = prototype
			applied++
			continue

		if(!current)
			continue

		switch(lowertext(label))
			if("valence")
				current.valence = (lowertext(value) == "negative") ? BOND_DREAM_NEGATIVE : BOND_DREAM_POSITIVE
			if("scopes")
				switch(lowertext(value))
					if("own")
						current.scopes = BOND_DREAM_SCOPE_OWN
					if("foreign")
						current.scopes = BOND_DREAM_SCOPE_FOREIGN
					else
						current.scopes = BOND_DREAM_SCOPE_ANY
			if("dreamer")
				current.dreamer_mask = bonds_parse_archetype_mask(value, unknown_words)
			if("other")
				current.other_mask = bonds_parse_archetype_mask(value, unknown_words)
			if("warmth")
				current.warmth_commit = text2num(value)
			if("weight")
				current.weight_commit = text2num(value)
			if("rarity")
				current.rarity = text2num(value)
			if("vampire")
				switch(lowertext(value))
					if("other")
						current.vampire_rule = BOND_DREAM_VAMPIRE_OTHER
					if("dreamer")
						current.vampire_rule = BOND_DREAM_VAMPIRE_DREAMER
					else
						current.vampire_rule = BOND_DREAM_VAMPIRE_NONE
			if("label")
				current.history_label = value
			if("story")
				current.story_template = value
			if("echo")
				current.echo_template = value
			else
				bondlog("[name]:[line_number] does not know the field [label]", BONDLOG_WARN)

	if(length(unknown_words))
		bondlog("[name] names archetypes that do not exist: [unknown_words.Join(", ")]", BONDLOG_WARN)
	return applied
