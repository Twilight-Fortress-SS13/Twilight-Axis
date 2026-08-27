/proc/bonds_split_words(text)
	RETURN_TYPE(/list)
	var/list/out = list()
	for(var/token in splittext(replacetext(text, "\t", " "), " "))
		var/clean = trim(token)
		if(length(clean))
			out += clean
	return out

/proc/bonds_parse_stance_cell(cell)
	RETURN_TYPE(/list)
	if(cell == "-")
		return null
	var/split = findtext(cell, "/")
	if(!split)
		return null
	var/warmth = text2num(copytext(cell, 1, split))
	var/weight = text2num(copytext(cell, split + 1))
	if(isnull(warmth) || isnull(weight))
		return null
	return list(warmth, weight)

/datum/controller/subsystem/bonds/proc/parse_stance_triangle(list/axis, list/rows_by_label, name, section)
	RETURN_TYPE(/list)
	var/count = length(axis)
	var/list/warmth_rows = list()
	var/list/weight_rows = list()
	for(var/i in 1 to count)
		var/label = axis[i]
		var/expected = count - i
		var/list/cells = rows_by_label[label]
		if(isnull(cells))
			if(expected)
				bondlog("[name] [section] names [label] but never gives it a row", BONDLOG_WARN)
			cells = list()
		else if(length(cells) != expected)
			bondlog("[name] [section] row [label] holds [length(cells)] cells, expected [expected]", BONDLOG_WARN)
		var/list/warmth_row = list()
		var/list/weight_row = list()
		for(var/column in 1 to expected)
			var/list/pair = (column <= length(cells)) ? bonds_parse_stance_cell(cells[column]) : null
			if(isnull(pair))
				if(column <= length(cells) && cells[column] != "-")
					bondlog("[name] [section] row [label] column [column] reads \"[cells[column]]\", expected warmth/weight", BONDLOG_WARN)
				warmth_row += null
				weight_row += null
				continue
			warmth_row += pair[1]
			weight_row += pair[2]
		warmth_rows += list(warmth_row)
		weight_rows += list(weight_row)
	return list(warmth_rows, weight_rows)

/datum/controller/subsystem/bonds/proc/load_stance_file(name)
	RETURN_TYPE(/list)
	var/path = "[BOND_STANCE_DIRECTORY]/[name]"
	if(!fexists(path))
		bondlog("stance config [path] is missing; every pair it would declare stays at flat zero", BONDLOG_WARN)
		return null

	var/list/axis = list()
	var/list/rows_by_label = list()
	var/line_number = 0
	for(var/line in world.file2list(path))
		line_number++
		var/trimmed = trim(line)
		if(!length(trimmed) || findtextEx(trimmed, "#") == 1)
			continue
		var/split = findtext(trimmed, ":")
		if(!split)
			bondlog("[name]:[line_number] has no colon; expected 'faction: cells'", BONDLOG_WARN)
			continue
		var/label = lowertext(trim(copytext(trimmed, 1, split)))
		var/payload = copytext(trimmed, split + 1)
		if(label == "axis")
			axis = bonds_split_words(payload)
			continue
		if(!length(label))
			bondlog("[name]:[line_number] has no faction before the colon", BONDLOG_WARN)
			continue
		if(!isnull(rows_by_label[label]))
			bondlog("[name]:[line_number] declares [label] a second time; the later row would silently win", BONDLOG_WARN)
			continue
		rows_by_label[label] = bonds_split_words(payload)

	if(!length(axis))
		bondlog("[name] never declares an axis, so none of its rows can be placed", BONDLOG_WARN)
		return null

	var/list/triangle = parse_stance_triangle(axis, rows_by_label, name, "matrix")
	return list(axis, triangle[1], triangle[2])

/datum/controller/subsystem/bonds/proc/load_realm_template(name)
	RETURN_TYPE(/list)
	var/path = "[BOND_STANCE_DIRECTORY]/[name]"
	if(!fexists(path))
		return null

	var/realm
	var/list/fallback
	var/list/blocs = list()
	var/list/bloc_names = list()
	var/list/raw_sections = list()
	var/list/overrides = list()
	var/list/current_rows
	var/section = "top"
	var/list/stray = list()
	var/line_number = 0

	for(var/line in world.file2list(path))
		line_number++
		var/trimmed = trim(line)
		if(!length(trimmed) || findtextEx(trimmed, "#") == 1)
			continue
		var/split = findtext(trimmed, ":")
		if(!split)
			bondlog("[name]:[line_number] has no colon", BONDLOG_WARN)
			continue
		var/label = lowertext(trim(copytext(trimmed, 1, split)))
		var/payload = copytext(trimmed, split + 1)
		var/list/words = bonds_split_words(label)

		if(!length(words))
			bondlog("[name]:[line_number] has nothing before the colon", BONDLOG_WARN)
			continue

		if(words[1] == "realm")
			realm = trim(payload)
			continue

		if(words[1] == "default")
			fallback = bonds_parse_stance_cell(trim(payload))
			if(isnull(fallback))
				bondlog("[name]:[line_number] default reads \"[trim(payload)]\", expected warmth/weight", BONDLOG_WARN)
			continue

		if(words[1] == "bloc")
			if(length(words) != 2)
				bondlog("[name]:[line_number] expected 'bloc <id>:'", BONDLOG_WARN)
				continue
			blocs[words[2]] = bonds_split_words(payload)
			continue

		if(words[1] == "name")
			if(length(words) != 2)
				bondlog("[name]:[line_number] expected 'name <bloc>:'", BONDLOG_WARN)
				continue
			bloc_names[words[2]] = trim(payload)
			continue

		if(words[1] == "matrix")
			if(length(words) != 2)
				bondlog("[name]:[line_number] expected 'matrix <id>:'", BONDLOG_WARN)
				continue
			section = "matrix"
			current_rows = list()
			raw_sections[words[2]] = current_rows
			continue

		if(words[1] == "override")
			section = "override"
			current_rows = null
			continue

		if(words[1] == "dream")
			section = "dream"
			current_rows = null
			continue

		if(section == "dream")
			continue

		if(section == "override" && length(words) == 2)
			var/list/pair = bonds_parse_stance_cell(trim(payload))
			if(isnull(pair))
				bondlog("[name]:[line_number] override [words[1]]|[words[2]] reads \"[trim(payload)]\", expected warmth/weight", BONDLOG_WARN)
				continue
			overrides[bonds_stance_key(words[1], words[2])] = pair
			continue

		if(section != "matrix" || isnull(current_rows))
			stray += "[line_number]:[label]"
			continue
		current_rows[label] = bonds_split_words(payload)

	if(!realm && !length(blocs))
		return null
	if(length(stray))
		bondlog("[name] has [length(stray)] rows outside any matrix: [stray.Join(", ")]", BONDLOG_WARN)
	if(!realm)
		bondlog("[name] declares blocs but no realm, so no map can select it", BONDLOG_WARN)
		return null
	if(!length(blocs))
		bondlog("[name] declares realm [realm] but no blocs", BONDLOG_WARN)
		return null

	var/list/inner = list()
	for(var/bloc_id in blocs)
		var/list/members = blocs[bloc_id]
		if(length(members) < 2)
			continue
		var/list/rows = raw_sections[bloc_id]
		if(isnull(rows))
			bondlog("[name] bloc [bloc_id] holds [length(members)] factions but has no matrix", BONDLOG_WARN)
			continue
		inner[bloc_id] = parse_stance_triangle(members, rows, name, "matrix [bloc_id]")

	var/list/bloc_axis = list()
	for(var/bloc_id in blocs)
		bloc_axis += bloc_id

	var/list/between = null
	if(length(bloc_axis) > 1)
		var/list/rows = raw_sections["blocs"]
		if(isnull(rows))
			bondlog("[name] declares [length(bloc_axis)] blocs but no 'matrix blocs'", BONDLOG_WARN)
		else
			between = parse_stance_triangle(bloc_axis, rows, name, "matrix blocs")

	return list("realm" = realm, "default" = fallback, "blocs" = blocs, "bloc_names" = bloc_names, "inner" = inner, "bloc_axis" = bloc_axis, "between" = between, "overrides" = overrides)

/datum/controller/subsystem/bonds/proc/realm_templates()
	RETURN_TYPE(/list)
	if(realm_templates_cache)
		return realm_templates_cache
	var/list/found = list()
	for(var/name in flist("[BOND_STANCE_DIRECTORY]/"))
		if(!findtextEx(name, ".txt", -4))
			continue
		var/list/template = load_realm_template(name)
		if(!template)
			continue
		found[template["realm"]] = template
	realm_templates_cache = found
	bondlog("realm templates loaded: [found.len]", BONDLOG_INFO)
	return found

/datum/controller/subsystem/bonds/proc/current_realm_name()
	return SSmapping?.map_adjustment?.realm_name

/datum/controller/subsystem/bonds/proc/current_realm_template()
	RETURN_TYPE(/list)
	var/realm = current_realm_name()
	if(!realm)
		return null
	return realm_templates()[realm]

/datum/controller/subsystem/bonds/proc/stance_blocks()
	RETURN_TYPE(/list)
	if(stance_blocks_cache)
		return stance_blocks_cache
	var/list/blocks = list()
	var/list/block = load_stance_file("clan_stances.txt")
	if(block)
		blocks += list(block)
	stance_blocks_cache = blocks
	return blocks
