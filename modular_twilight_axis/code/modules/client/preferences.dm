/datum/preferences/proc/open_origin_picker(mob/user)
	var/datum/origin_picker_panel/origin_picker = new(src)
	origin_picker.ui_interact(user)

/proc/origin_picker_group_name(group_order)
	switch(group_order)
		if(1)
			return "Западный континент"
		if(2)
			return "Восточный континент"
		if(3)
			return "Островные государства"
		else
			return "Отсутствуют на карте"


/proc/origin_picker_species_name(species_ref)
	var/static/list/species_name_cache = list()

	if(istype(species_ref, /datum/species))
		var/datum/species/species_instance = species_ref
		if(species_instance.name)
			return species_instance.name
		if(species_instance.base_name)
			return species_instance.base_name
		return "[species_instance.type]"

	if(!ispath(species_ref, /datum/species))
		return null

	var/cache_key = "[species_ref]"
	if(species_name_cache[cache_key])
		return species_name_cache[cache_key]

	var/species_type = null
	if(islist(GLOB.species_list))
		species_type = GLOB.species_list[species_ref]

	if(!ispath(species_type, /datum/species))
		species_type = species_ref

	var/datum/species/species_instance = new species_type()
	var/species_name = null
	if(species_instance)
		species_name = species_instance.name
		if(!species_name)
			species_name = species_instance.base_name

	if(!species_name)
		species_name = "[species_ref]"

	species_name_cache[cache_key] = species_name
	if(species_instance)
		qdel(species_instance)
	return species_name

/proc/origin_picker_species_list_text(list/species_paths)
	if(!islist(species_paths) || !length(species_paths))
		return null

	var/list/names = list()
	for(var/species_path in species_paths)
		var/species_name = origin_picker_species_name(species_path)
		if(species_name)
			names += species_name

	if(!length(names))
		return null

	if(length(names) == 1)
		return "[names[1]]"
	if(length(names) == 2)
		return "[names[1]] и [names[2]]"

	var/result = ""
	for(var/i = 1, i <= length(names), i++)
		if(i == 1)
			result += "[names[i]]"
		else if(i == length(names))
			result += " и [names[i]]"
		else
			result += ", [names[i]]"

	return result

/proc/origin_picker_language_name(language_ref)
	var/static/list/language_name_cache = list()

	if(istype(language_ref, /datum/language))
		var/datum/language/language_instance = language_ref
		if(language_instance.name)
			return language_instance.name
		return "[language_instance.type]"

	if(!ispath(language_ref, /datum/language))
		return null

	var/cache_key = "[language_ref]"
	if(language_name_cache[cache_key])
		return language_name_cache[cache_key]

	var/datum/language/language_instance = new language_ref()
	var/language_name = null

	if(language_instance)
		language_name = language_instance.name

	if(!language_name)
		language_name = "[language_ref]"

	language_name_cache[cache_key] = language_name

	if(language_instance)
		qdel(language_instance)

	return language_name

/proc/origin_picker_language_list_text(list/language_refs)
	if(!islist(language_refs) || !length(language_refs))
		return null

	var/list/names = list()
	for(var/language_ref in language_refs)
		var/language_name = origin_picker_language_name(language_ref)
		if(language_name)
			names += language_name

	if(!length(names))
		return null

	return english_list(names, nothing_text = null, and_text = " и ")

/proc/origin_picker_trait_name(trait_ref)
	if(isnull(trait_ref))
		return null

	var/trait_name = "[trait_ref]"
	if(!length(trait_name))
		return null

	trait_name = replacetext(trait_name, "_", " ")
	return capitalize(lowertext(trait_name))

/proc/origin_picker_trait_list_text(list/trait_refs)
	if(!islist(trait_refs) || !length(trait_refs))
		return null

	var/list/names = list()
	for(var/trait_ref in trait_refs)
		var/trait_name = origin_picker_trait_name(trait_ref)
		if(trait_name)
			names += trait_name

	if(!length(names))
		return null

	return english_list(names, nothing_text = null, and_text = " и ")

/datum/asset/simple/origin_picker
	assets = list(
		"origin_picker_map.jpg" = 'modular_twilight_axis/lore/interface/origin_picker_map.jpg',
	)

/datum/origin_picker_panel
	var/datum/preferences/preferences

/datum/origin_picker_panel/New(datum/preferences/new_preferences)
	. = ..()
	preferences = new_preferences

/datum/origin_picker_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/origin_picker_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OriginPicker", "Выбор происхождения")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/origin_picker_panel/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/origin_picker))

/datum/origin_picker_panel/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/origin_picker_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui ? ui.user : null
	switch(action)
		if("select_origin")
			var/chosen_path = text2path(params["origin_type"])
			if(!ispath(chosen_path, /datum/virtue/origin))
				return FALSE

			var/datum/virtue/origin/chosen_origin = GLOB.virtues[chosen_path]
			if(!chosen_origin)
				return FALSE

			if(!origin_check(chosen_origin, preferences.pref_species))
				var/warning_text = "Это происхождение недоступно для выбранной расы."
				if(islist(chosen_origin.races) && length(chosen_origin.races))
					var/required_races_text = origin_picker_species_list_text(chosen_origin.races)
					if(required_races_text)
						warning_text += " Доступно для рас: [required_races_text]."
				to_chat(user, span_warning(warning_text))
				return FALSE

			preferences.virtue_origin = chosen_origin
			to_chat(user, preferences.process_virtue_text(chosen_origin))
			if(user)
				preferences.ShowChoices(user)
			SStgui.update_uis(src)
			return TRUE


	return FALSE

/datum/origin_picker_panel/ui_data(mob/user)
	var/list/data = list()
	var/datum/virtue/origin/current_origin = preferences.virtue_origin
	var/datum/species/current_species = preferences.pref_species
	var/list/groups = list()
	var/list/map_states = list()
	var/list/group_entry_index = list()

	for(var/group_order in 1 to 4)
		group_entry_index["[group_order]"] = list()

	for(var/group_order in 1 to 4)
		for(var/state_order in 1 to 100)
			var/list/state_origins = list()
			var/state_id
			var/state_name
			var/on_map = FALSE
			var/x = 50
			var/y = 50
			var/selected = FALSE

			for(var/origin_variant_order in 1 to 10)
				for(var/path as anything in GLOB.virtues)
					var/datum/virtue/origin/O = GLOB.virtues[path]
					if(!istype(O, /datum/virtue/origin))
						continue
					if(!O.name)
						continue
					if(O.map_group_order != group_order)
						continue
					if(O.map_state_order != state_order)
						continue
					if(O.map_origin_order != origin_variant_order)
						continue

					if(!state_id)
						state_id = O.map_state_id ? O.map_state_id : "[O.origin_name]"
						state_name = O.map_state_name ? O.map_state_name : (O.origin_name ? O.origin_name : O.name)
						on_map = O.map_visible
						x = O.map_x
						y = O.map_y

					var/is_available = origin_check(O, current_species)
					var/required_races_text = null
					if(!is_available && islist(O.races) && length(O.races))
						required_races_text = origin_picker_species_list_text(O.races)

					var/language_text = origin_picker_language_list_text(O.added_languages)
					if(O.extra_language)
						if(language_text)
							language_text += "; свободный выбор языка"
						else
							language_text = "свободный выбор языка"

					var/trait_text = origin_picker_trait_list_text(O.added_traits)

					var/is_selected = FALSE
					if(current_origin && istype(current_origin, /datum/virtue/origin))
						is_selected = (current_origin.type == O.type)
						if(is_selected)
							selected = TRUE

					var/list/origin_data = list(
						"name" = O.name,
						"display_name" = O.map_origin_name ? O.map_origin_name : (O.map_state_name ? O.map_state_name : (O.origin_name ? O.origin_name : O.name)),
						"origin_name" = O.origin_name,
						"type" = "[O.type]",
						"desc" = O.desc,
						"origin_desc" = O.origin_desc,
						"selected" = is_selected,
						"available" = is_available,
						"required_races_text" = required_races_text,
						"language_text" = language_text,
						"trait_text" = trait_text,
						"state_id" = state_id,
						"state_name" = state_name,
						"subgroup_name" = O.list_subgroup_name ? O.list_subgroup_name : null,
						"item_order" = O.list_item_order ? O.list_item_order : origin_variant_order,
					)
					state_origins += list(origin_data)

					var/list/entries_for_group = group_entry_index["[group_order]"]
					var/entry_id = O.list_group_id ? O.list_group_id : state_id
					var/list/entry_data = entries_for_group[entry_id]
					if(!islist(entry_data))
						entry_data = list(
							"id" = entry_id,
							"name" = O.list_group_name ? O.list_group_name : state_name,
							"order" = O.list_group_order ? O.list_group_order : state_order,
							"selected" = FALSE,
							"items" = list(),
						)
						entries_for_group[entry_id] = entry_data

					if(is_selected)
						entry_data["selected"] = TRUE

					var/list/entry_items = entry_data["items"]
					entry_items += list(origin_data)

			if(length(state_origins))
				var/list/state_data = list(
					"id" = state_id,
					"name" = state_name,
					"on_map" = on_map,
					"x" = x,
					"y" = y,
					"selected" = selected,
					"origins" = state_origins,
				)
				map_states += list(state_data)

	for(var/group_order in 1 to 4)
		var/list/entries_for_group = group_entry_index["[group_order]"]
		if(!islist(entries_for_group) || !length(entries_for_group))
			continue

		var/list/group_entries = list()
		for(var/entry_order in 1 to 100)
			for(var/entry_key in entries_for_group)
				var/list/entry_data = entries_for_group[entry_key]
				if(!islist(entry_data))
					continue
				if(entry_data["order"] != entry_order)
					continue

				var/list/items = entry_data["items"]
				var/list/ordered_items = list()
				for(var/item_order in 1 to 20)
					for(var/i in 1 to length(items))
						var/list/item_data = items[i]
						if(item_data["item_order"] != item_order)
							continue
						ordered_items += list(item_data)

				if(length(ordered_items))
					entry_data["items"] = ordered_items

				group_entries += list(entry_data)

		if(length(group_entries))
			var/list/group_data = list(
				"name" = origin_picker_group_name(group_order),
				"is_off_map" = (group_order == 4),
				"entries" = group_entries,
			)
			groups += list(group_data)

	data["groups"] = groups
	data["map_states"] = map_states
	data["current_origin_type"] = current_origin ? "[current_origin.type]" : null
	data["current_species_name"] = current_species ? origin_picker_species_name(current_species) : "Неизвестно"
	return data
