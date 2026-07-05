// Modular hunting categories for the desert zones
// This allows tracking system to spawn desert-specific animals without touching base game code.

/datum/hunting_category/desert_prey
	name = "Desert Prey"
	skill_weights = list(50, 80, 100, 60, 30, 10, 0) // Easy/Medium tier
	bonus_animal_amount = 6
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game = 20
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit = "small",
		/mob/living/simple_animal/hostile/retaliate/rogue/saiga/game = "hoof"
	)
	preferred_areas = list(
		/area/rogue/outdoors/desert = 40,
		/area/rogue/outdoors/desertdeep = 20
	)

/datum/hunting_category/desert_scavengers
	name = "Desert Scavengers"
	skill_weights = list(100, 80, 50, 20, 10, 5, 5) // Low tier, good for beginners
	bonus_animal_amount = 8
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 20
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = "canine",
		/mob/living/simple_animal/hostile/retaliate/rogue/badger = "small",
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = "small",
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = "small",
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = "small"
	)
	preferred_areas = list(
		/area/rogue/outdoors/desert = 10, // Hard to find in regular desert
		/area/rogue/outdoors/desertdeep = 30 // Easier to find in deep desert
	)

/datum/hunting_category/desert_predators
	name = "Sands Predators"
	skill_weights = list(0, 15, 40, 80, 100, 80, 50) // Mid/High tier, requires some skill
	bonus_animal_amount = 5
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/hyena = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 10, // Larger packs or tougher variants if possible, but rock spider fits
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 5 // Rare sand mole
	)
	preferred_tracks = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/hyena = "canine",
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = "canine",
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = "small",
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = "large"
	)
	preferred_areas = list(
		/area/rogue/outdoors/desert = 0, // Never found on the outskirts
		/area/rogue/outdoors/desertdeep = 50 // Primary habitat
	)
