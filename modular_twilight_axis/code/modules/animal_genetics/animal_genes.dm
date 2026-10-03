/datum/animal_gene/fat
	name = "Fat"
	desc = "Heavyset build. Produces more meat but moves more slowly."
	rarity = 8
	exclusion_group = GENE_GROUP_BODY_SIZE
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/fat/apply_to(mob/living/simple_animal/target)
	target.genetic_butcher_scale = max(target.genetic_butcher_scale, intensity)
	target.genetic_health_multiplier += (intensity - 1) * 0.5
	target.genetic_speed_delta += round((intensity - 1) * 5)

/datum/animal_gene/lean
	name = "Lean"
	desc = "Slender build. Produces less meat but moves more quickly."
	rarity = 8
	exclusion_group = GENE_GROUP_BODY_SIZE
	intensity_min = 3
	intensity_max = 8

/datum/animal_gene/lean/apply_to(mob/living/simple_animal/target)
	target.genetic_butcher_scale = min(target.genetic_butcher_scale, intensity)
	target.genetic_health_multiplier -= (1 - intensity) * 0.4
	target.genetic_speed_delta -= round((1 - intensity) * 3)

/datum/animal_gene/hardy
	name = "Hardy"
	desc = "Robust constitution. Significantly increases maximum health."
	rarity = 6
	exclusion_group = GENE_GROUP_CONSTITUTION
	intensity_min = 2
	intensity_max = 6

/datum/animal_gene/hardy/apply_to(mob/living/simple_animal/target)
	target.genetic_health_multiplier += intensity

/datum/animal_gene/frail
	name = "Frail"
	desc = "Delicate constitution. Reduces maximum health."
	rarity = 6
	exclusion_group = GENE_GROUP_CONSTITUTION
	intensity_min = 1
	intensity_max = 5

/datum/animal_gene/frail/apply_to(mob/living/simple_animal/target)
	target.genetic_health_multiplier = max(0.25, target.genetic_health_multiplier - intensity)

/datum/animal_gene/swift
	name = "Swift"
	desc = "Naturally quick and harder to herd or catch."
	rarity = 6
	exclusion_group = GENE_GROUP_SPEED
	intensity_min = 5
	intensity_max = 30

/datum/animal_gene/swift/apply_to(mob/living/simple_animal/target)
	target.genetic_speed_delta -= round(intensity)

/datum/animal_gene/sluggish
	name = "Sluggish"
	desc = "Naturally slow and easy to herd."
	rarity = 8
	exclusion_group = GENE_GROUP_SPEED
	intensity_min = 10
	intensity_max = 50

/datum/animal_gene/sluggish/apply_to(mob/living/simple_animal/target)
	target.genetic_speed_delta += round(intensity)

/datum/animal_gene/fecundity
	name = "Fecund"
	desc = "Strong reproductive drive. Shortens the time between breeding cycles."
	rarity = 6
	exclusion_group = GENE_GROUP_BREEDING
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/fecundity/apply_to(mob/living/simple_animal/target)
	target.genetic_breed_multiplier *= max(0.5, 1 - intensity * 0.5)

/datum/animal_gene/barren
	name = "Barren"
	desc = "Weak reproductive drive. Lengthens the time between breeding cycles."
	rarity = 6
	exclusion_group = GENE_GROUP_BREEDING
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/barren/apply_to(mob/living/simple_animal/target)
	target.genetic_breed_multiplier *= 1 + intensity

/datum/animal_gene/prolific
	name = "Prolific"
	desc = "Carries a hereditary tendency toward larger litters."
	rarity = 4
	exclusion_group = GENE_GROUP_PROGENY
	intensity_min = 1
	intensity_max = 10

/datum/animal_gene/prolific/apply_to(mob/living/simple_animal/target)
	target.genetic_extra_litter_chance = max(target.genetic_extra_litter_chance, intensity * 60)
	target.genetic_max_extra_litter = max(target.genetic_max_extra_litter, max(1, round(intensity * 3)))

/datum/animal_gene/productive
	name = "Productive"
	desc = "High-yield metabolism. Milk production builds faster."
	rarity = 4
	exclusion_group = GENE_GROUP_PRODUCTIVITY
	intensity_min = 11
	intensity_max = 18
	type_whitelist = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/cow,
		/mob/living/simple_animal/hostile/retaliate/rogue/goat,
	)

/datum/animal_gene/productive/apply_to(mob/living/simple_animal/target)
	target.genetic_production_multiplier *= intensity

/datum/animal_gene/efficient_metabolism
	name = "Efficient Metabolism"
	desc = "Needs less food to sustain itself."
	rarity = 6
	exclusion_group = GENE_GROUP_METABOLISM
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/efficient_metabolism/apply_to(mob/living/simple_animal/target)
	var/reduction = (intensity - 1) * 0.5
	target.genetic_food_consumption_multiplier *= max(0.5, 1 - reduction)

/datum/animal_gene/ravenous
	name = "Ravenous"
	desc = "Burns through food reserves unusually quickly."
	rarity = 8
	exclusion_group = GENE_GROUP_METABOLISM
	intensity_min = 11
	intensity_max = 18

/datum/animal_gene/ravenous/apply_to(mob/living/simple_animal/target)
	var/increase = (intensity - 1) * 0.5
	target.genetic_food_consumption_multiplier *= 1 + increase

/datum/animal_gene/docile
	name = "Docile"
	desc = "Calm and trusting. Easier to tame and less dangerous."
	rarity = 4
	exclusion_group = GENE_GROUP_TEMPERAMENT
	intensity_min = 5
	intensity_max = 10

/datum/animal_gene/docile/apply_to(mob/living/simple_animal/target)
	target.genetic_tame_chance_bonus += round(20 + intensity * 10)
	target.genetic_bonus_tame_bonus += round(5 + intensity * 5)
	target.genetic_melee_multiplier *= max(0.65, 1 - intensity * 0.2)

/datum/animal_gene/aggressive
	name = "Aggressive"
	desc = "Territorial and difficult to handle, but more dangerous in a fight."
	rarity = 3
	exclusion_group = GENE_GROUP_TEMPERAMENT
	intensity_min = 5
	intensity_max = 10

/datum/animal_gene/aggressive/apply_to(mob/living/simple_animal/target)
	target.genetic_tame_chance_bonus -= round(15 + intensity * 10)
	target.genetic_bonus_tame_bonus -= round(5 + intensity * 5)
	target.genetic_melee_multiplier *= 1 + intensity * 0.25

/datum/animal_gene/diet
	name = "Diet"
	desc = "A hereditary feeding preference."
	rarity = 5
	exclusion_group = GENE_GROUP_DIET

/datum/animal_gene/diet/omnivore
	name = "Opportunistic Omnivore"
	desc = "Will readily eat meat in addition to its normal feed."
	rarity = 4

/datum/animal_gene/diet/omnivore/apply_to(mob/living/simple_animal/target)
	target.genetic_added_foods |= /obj/item/reagent_containers/food/snacks/rogue/meat

/datum/animal_gene/diet/strict_herbivore
	name = "Strict Herbivore"
	desc = "Refuses meat even when its species would normally accept it."
	rarity = 5

/datum/animal_gene/diet/strict_herbivore/apply_to(mob/living/simple_animal/target)
	target.genetic_removed_foods |= /obj/item/reagent_containers/food/snacks/rogue/meat

/datum/animal_gene/hide
	name = "Hide"
	desc = "Inherited natural protection."
	rarity = 4
	exclusion_group = GENE_GROUP_HIDE
	var/list/armor_covered = list()

/datum/animal_gene/hide/thick_hide
	name = "Thick Hide"
	desc = "Dense skin that resists stabbing and slashing attacks."
	rarity = 4
	intensity_min = 50
	intensity_max = 200
	armor_covered = list("stab", "slash")

/datum/animal_gene/hide/ironhide
	name = "Ironhide"
	desc = "Exceptionally dense flesh that resists most edged physical attacks."
	rarity = 2
	intensity_min = 150
	intensity_max = 400
	armor_covered = list("stab", "slash", "piercing")

/datum/animal_gene/dominant_lineage
	name = "Dominant Lineage"
	desc = "A strong bloodline that biases offspring toward one parent's traits."
	rarity = 3
	exclusion_group = GENE_GROUP_LINEAGE
	intensity_min = 1
	intensity_max = 10
	var/favored_side = LINEAGE_MOTHER

/datum/animal_gene/dominant_lineage/New()
	. = ..()
	favored_side = pick(LINEAGE_MOTHER, LINEAGE_FATHER)

/datum/animal_gene/dominant_lineage/breed_with(datum/animal_gene/other)
	var/datum/animal_gene/dominant_lineage/offspring = ..()
	offspring.favored_side = favored_side
	return offspring

GLOBAL_LIST_INIT(ta_animal_genes_weighted, list(
	/datum/animal_gene/fat = 8,
	/datum/animal_gene/lean = 8,
	/datum/animal_gene/hardy = 6,
	/datum/animal_gene/frail = 6,
	/datum/animal_gene/swift = 6,
	/datum/animal_gene/sluggish = 8,
	/datum/animal_gene/fecundity = 6,
	/datum/animal_gene/barren = 6,
	/datum/animal_gene/prolific = 4,
	/datum/animal_gene/productive = 4,
	/datum/animal_gene/efficient_metabolism = 6,
	/datum/animal_gene/ravenous = 8,
	/datum/animal_gene/docile = 4,
	/datum/animal_gene/aggressive = 3,
	/datum/animal_gene/diet/omnivore = 4,
	/datum/animal_gene/diet/strict_herbivore = 5,
	/datum/animal_gene/hide/thick_hide = 4,
	/datum/animal_gene/hide/ironhide = 2,
	/datum/animal_gene/dominant_lineage = 3,
))
