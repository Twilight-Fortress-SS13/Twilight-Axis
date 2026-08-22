#define ADVANCED_POTION_VOLUME_STANDARD 30

/datum/alch_cauldron_recipe/advanced
	abstract_type = /datum/alch_cauldron_recipe/advanced
	category = "Great Work"

/datum/alch_cauldron_recipe/advanced/swift_feet
	name = "Elixir of Swift Feet"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/speed = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/cats_grace
	name = "Cat's Grace Draught"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/grace = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/growth
	name = "Potion of Giant's Might"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/growth = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/paralysis
	name = "Spider's Kiss"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/advanced/paralysis = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/elixir_of_life
	name = "Elixir of Life"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/advanced/elixir_of_life = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/mist_form
	name = "Mist Form"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/advanced/mist_form = ADVANCED_POTION_VOLUME_STANDARD)

#undef ADVANCED_POTION_VOLUME_STANDARD
