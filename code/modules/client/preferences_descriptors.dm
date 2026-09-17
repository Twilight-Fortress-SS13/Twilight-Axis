/proc/sanitize_custom_descriptor_text(text)
	if(!istext(text))
		return null

	text = STRIP_HTML_SIMPLE(LOWER_TEXT(text), CUSTOM_DESCRIPTOR_TEXT_LENGTH)
	if(!is_english_custom_descriptor_text(text))
		return null

	return text

/proc/is_english_custom_descriptor_text(text)
	if(!istext(text))
		return FALSE

	var/has_letter = FALSE

	for(var/i in 1 to length(text))
		var/char = text2ascii(text, i)

		if(char >= 97 && char <= 122)
			has_letter = TRUE
			continue

		if(char == 32 || char == 39 || char == 45)
			continue

		return FALSE

	return has_letter

/datum/preferences/proc/validate_descriptors()
	descriptor_entries = SANITIZE_LIST(descriptor_entries) // TA EDIT START
	custom_descriptors = SANITIZE_LIST(custom_descriptors)

	var/list/valid_descriptor_entries = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		if(!choice || !length(choice.descriptors))
			continue

		var/datum/descriptor_entry/entry
		for(var/entry_value as anything in descriptor_entries)
			if(!istype(entry_value, /datum/descriptor_entry))
				continue
			var/datum/descriptor_entry/candidate = entry_value
			if(candidate.descriptor_choice_type != choice_type)
				continue
			if(!entry)
				entry = candidate
			if(candidate.descriptor_type in choice.descriptors)
				entry = candidate
				break

		if(!entry)
			entry = new /datum/descriptor_entry()

		var/descriptor_type = entry.descriptor_type
		if(isnull(descriptor_type) || !(descriptor_type in choice.descriptors))
			descriptor_type = choice.default_descriptor
			if(!(descriptor_type in choice.descriptors))
				descriptor_type = pick(choice.descriptors)
		entry.set_values(choice_type, descriptor_type)
		valid_descriptor_entries += entry

	descriptor_entries = valid_descriptor_entries

	var/list/valid_custom_descriptors = list()
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry
		if(length(custom_descriptors) >= i && istype(custom_descriptors[i], /datum/custom_descriptor_entry))
			custom_entry = custom_descriptors[i]
		else
			custom_entry = new /datum/custom_descriptor_entry()

		custom_entry.prefix_type = sanitize_integer(custom_entry.prefix_type, 1, CUSTOM_PREFIX_AMOUNT, CUSTOM_PREFIX_HAS_A)
		custom_entry.content_text = sanitize_custom_descriptor_text(custom_entry.content_text)
		if(isnull(custom_entry.content_text))
			custom_entry.content_text = ""
		valid_custom_descriptors += custom_entry

	custom_descriptors = valid_custom_descriptors // TA EDIT END

/datum/preferences/proc/reset_descriptors()
	descriptor_entries = list()
	custom_descriptors = list()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		var/datum/descriptor_entry/entry = new /datum/descriptor_entry()
		if(choice.default_descriptor)
			entry.set_values(choice_type, choice.default_descriptor)
		else
			entry.set_values(choice_type, pick(choice.descriptors))
		descriptor_entries += entry
	for(var/i in 1 to CUSTOM_DESCRIPTOR_AMOUNT)
		var/datum/custom_descriptor_entry/custom_entry = new /datum/custom_descriptor_entry()
		custom_descriptors += custom_entry

/datum/preferences/proc/has_descriptor_type_in_entries(descriptor_type)
	if(length(descriptor_entries))
		for(var/entry_value as anything in descriptor_entries) // TA EDIT START
			if(!istype(entry_value, /datum/descriptor_entry))
				continue
			var/datum/descriptor_entry/entry = entry_value // TA EDIT END
			if(entry.descriptor_type != descriptor_type)
				continue
			return TRUE
	return FALSE

/datum/preferences/proc/get_descriptor_entry_for_choice(choice_type)
	if(length(descriptor_entries))
		for(var/entry_value as anything in descriptor_entries) // TA EDIT START
			if(!istype(entry_value, /datum/descriptor_entry))
				continue
			var/datum/descriptor_entry/entry = entry_value // TA EDIT END
			if(entry.descriptor_choice_type != choice_type)
				continue
			return entry
	return null

/datum/preferences/proc/apply_descriptors(mob/living/character)
	character.clear_mob_descriptors()
	for(var/choice_type in pref_species.descriptor_choices)
		var/datum/descriptor_entry/entry = get_descriptor_entry_for_choice(choice_type)
		if(!entry) // TA EDIT
			continue // TA EDIT
		character.add_mob_descriptor(entry.descriptor_type)
	character.custom_descriptors = list()
	for(var/entry_value as anything in custom_descriptors)
		if(!istype(entry_value, /datum/custom_descriptor_entry)) // TA EDIT START
			continue
		var/datum/custom_descriptor_entry/entry = entry_value // TA EDIT END
		var/datum/custom_descriptor_entry/new_entry = new /datum/custom_descriptor_entry()
		new_entry.prefix_type = entry.prefix_type
		new_entry.content_text = entry.content_text
		character.custom_descriptors += new_entry
