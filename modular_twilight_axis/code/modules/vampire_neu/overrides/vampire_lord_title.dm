/*
 * Keep the Vampire Lord's forced title aligned with the character's title
 * preference instead of deriving it from body sex.
 */

/datum/antagonist/vampire/lord/after_name_change()
	. = ..()

	var/mob/living/carbon/human/lord = owner?.current
	if(!istype(lord))
		return

	var/old_name = lord.real_name
	var/current_title
	var/untitled_name = old_name
	if(findtextEx(old_name, "Lord ") == 1)
		current_title = "Lord"
		untitled_name = copytext_char(old_name, 6)
	else if(findtextEx(old_name, "Lady ") == 1)
		current_title = "Lady"
		untitled_name = copytext_char(old_name, 6)

	var/preferred_title = lord.titles_pref == TITLES_F ? "Lady" : "Lord"
	if(current_title == preferred_title)
		return

	var/new_name = "[preferred_title] [untitled_name]"
	lord.fully_replace_character_name(old_name, new_name)

	if(GLOB.character_ckey_list[old_name])
		GLOB.character_ckey_list -= old_name
	GLOB.character_ckey_list[new_name] = lord.ckey

	var/display_key = lord.ckey
	if(lord.ckey in GLOB.anonymize)
		display_key = get_fake_key(lord.ckey)
	GLOB.character_list[lord.mobid] = "[display_key] was [new_name] ([name])<BR>"
