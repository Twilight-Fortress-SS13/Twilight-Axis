#define ADVANCED_POTION_VOLUME_STANDARD 30

/datum/alch_cauldron_recipe/advanced
	abstract_type = /datum/alch_cauldron_recipe/advanced
	category = "Great Work"

/datum/alch_cauldron_recipe/advanced/swift_feet
	name = "Elixir of Swift Feet"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/speed = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/sleep_draught
//	name = "Morpheus Draught"
//	skill_required = SKILL_LEVEL_EXPERT
//	output_reagents = list(/datum/reagent/advanced/sleep = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/cats_grace
	name = "Cat's Grace Draught"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/grace = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/growth
	name = "Potion of Giant's Might"
	skill_required = SKILL_LEVEL_APPRENTICE
	output_reagents = list(/datum/reagent/advanced/growth = ADVANCED_POTION_VOLUME_STANDARD)


///datum/alch_cauldron_recipe/advanced/invisible
//	name = "Void Ichor"
//	skill_required = SKILL_LEVEL_APPRENTICE
//	output_reagents = list(/datum/reagent/advanced/invisible = ADVANCED_POTION_VOLUME_STANDARD)


///datum/alch_cauldron_recipe/advanced/paralysis
//	name = "Spider's Kiss"
//	skill_required = SKILL_LEVEL_EXPERT
//	output_reagents = list(/datum/reagent/advanced/paralysis = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/elixir_of_life
	name = "Elixir of Life"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/advanced/elixir_of_life = ADVANCED_POTION_VOLUME_STANDARD)

//datum/alch_cauldron_recipe/advanced/lycanthropy
//	name = "Catalyst of Dendor's Madness"
//	skill_required = SKILL_LEVEL_MASTER
//	output_reagents = list(/datum/reagent/advanced/lycanthropy = 15)

/datum/alch_cauldron_recipe/advanced/night_vision
	name = "Draught of the Night-Owl"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/advanced/night_vision = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/vampirism
//	name = "Sanguine Catalyst: Night-Born"
//	skill_required = SKILL_LEVEL_MASTER
//	output_reagents = list(/datum/reagent/advanced/vampirism = 15)

///datum/alch_cauldron_recipe/advanced/titan_strength
//	name = "Titan's Draught"
//	skill_required = SKILL_LEVEL_EXPERT
//	output_reagents = list(/datum/reagent/advanced/titan_strength = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/mist_form
//	name = "Mist Form"
//	skill_required = SKILL_LEVEL_JOURNEYMAN
//	output_reagents = list(/datum/reagent/advanced/mist_form = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/mirror_potion
//	name = "Mirror-Glass Draught"
//	skill_required = SKILL_LEVEL_MASTER
//	output_reagents = list(/datum/reagent/advanced/mirror_potion = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/levitation
//	name = "Alchemical Flight: Levitation"
//	skill_required = SKILL_LEVEL_JOURNEYMAN
//	output_reagents = list(/datum/reagent/advanced/levitation = ADVANCED_POTION_VOLUME_STANDARD)

///datum/alch_cauldron_recipe/advanced/stoneskin
//	name = "Draught of the Gargoyle"
//	skill_required = SKILL_LEVEL_JOURNEYMAN
//	output_reagents = list(/datum/reagent/advanced/stoneskin = ADVANCED_POTION_VOLUME_STANDARD)

/datum/alch_cauldron_recipe/advanced/bloodhound
	name = "Elixir of the Predator"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/advanced/bloodhound = ADVANCED_POTION_VOLUME_STANDARD)

#undef ADVANCED_POTION_VOLUME_STANDARD
