/mob/living/carbon/human/species/dwarf
	race = /datum/species/dwarf

/datum/species/dwarf
	name = "Dwarfb"
	id = "dwarf"
	max_age = 200
	languages = list(
		/datum/language/common,
		/datum/language/dwarvish
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

/datum/species/dwarf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/dwarf/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, "<span class='info'>I can speak Dwarfish with ,d before my speech.</span>")

/datum/species/dwarf/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/dwarf/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/dwarf/get_skin_list()
	return sortList(list(
	"skin1" = "ffe0d1",
	"skin2" = "fcccb3"
	))

/datum/species/dwarf/get_hairc_list()
	return sortList(list(
	"black - nightsky" = "0a0707",
	"brown - treebark" = "362e25",
	"blonde - moonlight" = "dfc999",
	"red - autumn" = "a34332"
	))

