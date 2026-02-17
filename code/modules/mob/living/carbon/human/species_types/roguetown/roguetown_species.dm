/datum/species
	var/amtfail = 0

/datum/species/proc/get_accent_list(mob/living/carbon/human/H, type)
	var/list/accents = list(
		"Dwarven accent" = "dwarf_replacement.json",
		"Dwarf Gibberish accent" = "dwarf_replacement.json",
		"Dark Elven accent" = "french_replacement.json",
		"West Elven accent" = "russian_replacement.json",
		"East Elven accent" = "korean_replacement.json",
		"Old Empire Accent" = "empire_replacement.json",
		"Grenzel accent" = "german_replacement.json",
		"Otavian accent" = "russian_replacement.json",
		"Hammerhold accent" = "Anglish.json",
		"Assimari accent" = "proper_replacement.json",
		"Sissean accent" = "brazillian_replacement.json",
		"Tiefling accent" = "spanish_replacement.json",
		"Half Orc accent" = "middlespeak.json",
		"Lupian accent" = "polish_replacement.json",
		"Gronn accent" = "mongolian_replacement.json",
		"Urban Orc accent" = "norf_replacement.json",
		"Drakian accent" = "hissy_replacement.json",
		"Inzectoid accent" = "inzectoid_replacement.json",
	//	"Feline accent" = "feline_replacement.json",
		"Slopes accent" = "welsh_replacement.json",
		"Axian accent" = "welsh_replacement.json",
		"Abyssal accent" = "abyssal_accent.json"
	)
	var/filename = accents[H.char_accent]
	if (!filename)
		return null

	if (GLOB.string_cache[filename])
		return GLOB.string_cache[filename]

	strings(filename, "full") //populate glob
	return GLOB.string_cache[filename]

/datum/species/proc/get_accent(mob/living/carbon/human/H)
	return get_accent_list(H)

#define UNIVERSAL_ACCENT_FILENAME "accent_universal.json"

/datum/species/proc/handle_speech(datum/source, mob/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]

	if(!GLOB.string_cache[UNIVERSAL_ACCENT_FILENAME])
		strings(UNIVERSAL_ACCENT_FILENAME, "full") //populate glob

	message = treat_message_accent(message, GLOB.string_cache[UNIVERSAL_ACCENT_FILENAME])

	message = treat_message_accent(message, get_accent(source))

	message = autopunct_bare(message)

	speech_args[SPEECH_MESSAGE] = trim(message)


/proc/treat_message_accent(message, list/accent_list)
	if(!message || !accent_list)
		return message
	if(message[1] == "*") //this is to ignore emotes
		return message
	message = html_decode(message)

	var/list/tokens = splittext_char(message, " ")
	var/list/modded_tokens = list()
	var/total_tokens = length_char(tokens)
	var i = 1

	while(i <= total_tokens)
		var/original_word = tokens[i]
		
		var/modified_token = original_word
		var/list/phrase_tokens = list(original_word)

		// multi-words (max 2 words)
		if(accent_list["multi"])
			for (var/j = 1; j <= 2 && (i + j - 1) <= total_tokens; j++) 
				if (j > 1)
					phrase_tokens += tokens[i + j - 1]
				var/phrase = jointext(phrase_tokens, " ")
				var/matching_phrase = accent_list["multi"][lowertext(phrase)]
				if(islist(matching_phrase)) //delete this and all corresponding list entries from json if perf is an issue
					matching_phrase = pick(matching_phrase)

				if (matching_phrase)
					var/replacement = match_case(phrase, matching_phrase)
					modified_token = replacement
					i += (j - 1) // Skip ahead past matched words
					break
		
		// single words
		if(modified_token == original_word)
			var/matching_token = accent_list["full"][lowertext(original_word)] //full word match using dict, lowercase here but ignore case in regex
			if(islist(matching_token)) //delete this and all corresponding list entries from json if perf is an issue
				matching_token = pick(matching_token)
			if (matching_token)
				var/replacement = match_case(original_word, matching_token)
				modified_token = replacement
		
		modified_token = apply_accent_modifications(modified_token, accent_list)
		modded_tokens += modified_token
		i++ 
	// while end
	var/final_text = jointext(modded_tokens, " ")
	return html_encode(final_text)

/proc/apply_accent_modifications(var/text, list/accent_list)
	//These are barely okay because they aren't yet 1000 words like fullword. Use these sparingly or preferably not at all until we can offload regex to rustg
	//it is inarguably incorrect behaviour to break the prefix/suffix loops on the first match but for the sake of performance we break and
	//trust the accent json is structured intelligently

	// startswith.
	for(var/prefix in accent_list["start"])
		if(findtext(text, prefix) == 1)
			var/accent_prefix = accent_list["start"][prefix]
			var/picked_prefix = ""
			if(islist(accent_prefix))
				picked_prefix = pick(accent_prefix)
			else 
				picked_prefix = accent_prefix

			var/original_match = copytext_char(text, 1, 1 + length(prefix))
			var/replacement = match_case(original_match, picked_prefix)
			text = replacetextEx_char(text, regex("^" + prefix, "i"), replacement)
			break //remove this for potentially more fidelity and marginally less performance

	// endswith
	for(var/suffix in accent_list["end"])
		if(findtext(text, suffix, length(text) - length(suffix) + 1))
			var/accent_suffix = accent_list["end"][suffix]
			var/picked_suffix = ""
			if(islist(accent_suffix))
				picked_suffix = pick(accent_suffix)
			else 
				picked_suffix = accent_suffix

			text = replacetextEx_char(text, regex(suffix + "$", "i"), picked_suffix)
			break //remove this for potentially more fidelity and marginally less performance

	// syllable (match all)
	for(var/syllable in accent_list["syllable"])
		var/accent_syllable = accent_list["syllable"][syllable]
		var/picked_syllable = ""
		if(islist(accent_syllable))
			picked_syllable = pick(accent_syllable)
		else 
			picked_syllable = accent_syllable
			
		text = replacetextEx_char(text, uppertext(syllable), uppertext(picked_syllable))
		text = replacetextEx_char(text, syllable, picked_syllable)

	return text

/proc/match_case(var/original, var/replacement)
	if (original == uppertext(original))
		return uppertext(replacement)
	if (original == lowertext(original))
		return lowertext(replacement)
	if (original == capitalize(original))
		return capitalize(replacement)
	return replacement

#undef UNIVERSAL_ACCENT_FILENAME 
