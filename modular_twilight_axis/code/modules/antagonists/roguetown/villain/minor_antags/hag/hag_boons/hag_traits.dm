/datum/hag_boon/trait/no_hunger
	name = "Trait - Foodless"
	trait_to_apply = TRAIT_NOHUNGER
	desc = "The bearer can survive and live without food and water."
	points = 20

/datum/hag_boon/trait/death_sight
	name = "Trait - Death Sight"
	trait_to_apply = TRAIT_DEATHSIGHT
	desc = "The bearer can feel if someone died near him..."
	points = 20

/datum/hag_boon/trait/parry_expert
	name = "Trait - Parry Expert"
	trait_to_apply = TRAIT_PARRYEXPERT
	desc = "Enhances the bearer's abiliy to parry with weapon."
	points = 40

/datum/hag_boon/trait/poison_immune
	name = "Trait - Poison Immune"
	trait_to_apply = TRAIT_TOXIMMUNE
	desc = "Grants the snake constitution, that allows to endure any poison."
	points = 30

/datum/hag_boon/trait/eoran_serene
	name = "Trait - No Stress"
	trait_to_apply = TRAIT_EORAN_SERENE
	desc = "Grants the bearer the blessing of Eora, removing any stress."
	points = 40

/datum/hag_boon/trait/light_step
	name = "Trait - Light Steps"
	trait_to_apply = TRAIT_LIGHT_STEP
	desc = "Bearer steps more lighty and swifty, makes less noise when walking and can sneak much quicker."
	points = 30

/datum/hag_boon/trait/noble
	name = "Trait - Noble"
	trait_to_apply = TRAIT_NOBLE
	desc = "Bearer becomes noble!"
	points = 50

/datum/hag_boon/trait/noble/apply_boon_effect(mob/living/L)
	ADD_TRAIT(L, TRAIT_NOBLE_UNLANDED, TRAIT_HAG_BOON)
	..()

/datum/hag_boon/trait/regeneration
	name = "Trait - Regeneration"
	trait_to_apply = TRAIT_REGENERATION
	desc = "The bearer will start to regenerate - especially near the campfire. This regeneration will be enough to restore the lost limb, if sleeping..."
	points = 85
