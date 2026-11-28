/datum/ambush_config
	var/list/mob_types = list()

/datum/ambush_config/antlion_party
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/antlion = 1,
	)

/datum/ambush_config/dunewell_raider
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/dunewell_raider/ambush = 2,
		/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear/ambush = 1
	)

/datum/ambush_config/dunewell_raider/hard
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/dunewell_raider/better_gear/ambush = 2,
		/mob/living/carbon/human/species/human/northern/dunewell_raider/ambush = 1,
	)

/datum/ambush_config/lamia_party
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/lamia = 1,
	)

/datum/ambush_config/worm_hatchling_party
	mob_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/sandworm/wormling = 2,
	)
