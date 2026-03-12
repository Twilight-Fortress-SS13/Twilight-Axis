
/datum/customizer_entry/organ/belly
	var/belly_size = BELLY_SIZE_MIN
	var/allow_to_grow = FALSE

/datum/customizer/organ/belly
	abstract_type = /datum/customizer/organ/belly
	name = "Belly"
	allows_disabling = TRUE
	default_disabled = FALSE

/datum/customizer/organ/belly/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/belly
	abstract_type = /datum/customizer_choice/organ/belly
	name = "Belly"
	customizer_entry_type = /datum/customizer_entry/organ/belly
	organ_type = /obj/item/organ/belly
	organ_slot = ORGAN_SLOT_BELLY
	organ_dna_type = /datum/organ_dna/belly

/datum/customizer_choice/organ/belly/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	belly_entry.belly_size = sanitize_integer(belly_entry.belly_size, BELLY_SIZE_MIN, BELLY_SIZE_BIG, BELLY_SIZE_LITTLE)

/datum/customizer_choice/organ/belly/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/belly/belly_dna = organ_dna
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	belly_dna.belly_size = belly_entry.belly_size
	belly_dna.allow_to_grow = belly_entry.allow_to_grow

/datum/customizer_choice/organ/belly/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	dat += "<br>Belly size: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=belly_size''>[find_key_by_value(BELLY_SIZES_BY_NAME_CUSTOMIZER, belly_entry.belly_size)]</a>"
	dat += "<br>Allow to grow: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=allow_to_grow''>[belly_entry.allow_to_grow ? "Enabled" : "Disabled"]</a>"

/datum/customizer_choice/organ/belly/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/belly/belly_entry = entry
	switch(href_list["customizer_task"])
		if("belly_size")
			var/named_size = input(user, "Choose your belly size:", "Character Preference", find_key_by_value(BELLY_SIZES_BY_NAME_CUSTOMIZER, belly_entry.belly_size)) as anything in BELLY_SIZES_BY_NAME_CUSTOMIZER
			if(isnull(named_size))
				return
			var/new_size = BELLY_SIZES_BY_NAME_CUSTOMIZER[named_size]
			belly_entry.belly_size = sanitize_integer(new_size, BELLY_SIZE_MIN, BELLY_SIZE_BIG, BELLY_SIZE_LITTLE)
		if("allow_to_grow")
			belly_entry.allow_to_grow = !belly_entry.allow_to_grow

/datum/customizer/organ/belly/human
	customizer_choices = list(/datum/customizer_choice/organ/belly/human)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/organ/belly/human
	sprite_accessories = list(/datum/sprite_accessory/belly)
	allows_accessory_color_customization = FALSE
