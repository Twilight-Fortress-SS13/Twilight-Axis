/// Auto-generated TAT preset pack for archetype: pilgrim
/// Source: types.zip + tat_system.zip
/// NOTE: Dynamic class choices, spells, money, and non-TAT-only mechanics are preserved as comments where direct 1:1 encoding was not possible.

// ---------------------------------------------------------------------------
// Barber Surgeon  (pilgrim/barbersurgeon.dm)
// Advclass path: /datum/advclass/barbersurgeon
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/nightman; /obj/item/clothing/mask/rogue/spectacles; /obj/item/clothing/shoes/roguetown/simpleshoes; /obj/item/clothing/suit/roguetown/shirt/robe/physician; /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan; /obj/item/hair_dye_cream; /obj/item/natural/cloth; /obj/item/recipe_book/alchemy; /obj/item/storage/belt/rogue/pouch/coins/mid; /obj/item/storage/belt/rogue/surgery_bag/full
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
/datum/tat_preset/pilgrim/pilgrim_barbersurgeon
	id = "pilgrim_barbersurgeon"
	name = "Barber Surgeon"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_LCK = 1,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
			/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_EMPATH = TRUE,
			TRAIT_NOSTINK = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/mask/rogue/spectacles = 1,
			/obj/item/clothing/head/roguetown/nightman = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/physician = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/belt/rogue/surgery_bag/full = 1,
			/obj/item/rogueweapon/huntingknife/chefknife/cleaver = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/shoes/roguetown/simpleshoes = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/natural/worms/leech/cheele = 1,
			/obj/item/natural/cloth = 2,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife/scissors/steel = 1,
			/obj/item/hair_dye_cream = 3,
			/obj/item/heart_blood_canister/filled = 2,
			/obj/item/bait/leech = 4,
			/obj/item/folding_alchcauldron_stored = 1,
			/obj/item/recipe_book/alchemy = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/mask/rogue/spectacles = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/nightman = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/physician = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/surgery_bag/full = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/chefknife/cleaver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/simpleshoes = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/natural/worms/leech/cheele = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/cloth = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/scissors/steel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/hair_dye_cream = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/heart_blood_canister/filled = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/bait/leech = list(
				"equip" = 0,
				"bag" = 4,
			),
			/obj/item/folding_alchcauldron_stored = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/alchemy = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Blacksmith  (pilgrim/blacksmith.dm)
// Advclass path: /datum/advclass/blacksmith
// Missing traits in TAT: TRAIT_TRAINED_SMITH
// Missing items in TAT catalog: /obj/item/blueprint/mace_mushroom; /obj/item/clothing/cloak/apron/blacksmith; /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/dress/gen/random; /obj/item/clothing/suit/roguetown/shirt/shortshirt; /obj/item/recipe_book/blacksmithing; /obj/item/recipe_book/survival; /obj/item/rogueore/coal; /obj/item/rogueore/iron; /obj/item/rogueweapon/hammer/bronze; /obj/item/rogueweapon/tongs/bronze
// Dynamic note: Choice list `smith_type`: Ironworker; Bronzeworker
/datum/tat_preset/pilgrim/pilgrim_blacksmith
	id = "pilgrim_blacksmith"
	name = "Blacksmith"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 2,
			STATKEY_CON = 2,
			STATKEY_STR = 1,
			STATKEY_LCK = 1,
			STATKEY_SPD = -1,
		),

		"skills" = list(
			/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_TRAINED_SMITH = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith = 1,
			/obj/item/clothing/cloak/apron/blacksmith = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/rogueweapon/hammer/bronze = 1,
			/obj/item/rogueweapon/tongs/bronze = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/flint = 1,
			/obj/item/rogueore/coal = 4,
			/obj/item/rogueore/iron = 5,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/recipe_book/blacksmithing = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/blueprint/mace_mushroom = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron/blacksmith = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hammer/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/tongs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hammer/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/tongs/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueore/coal = list(
				"equip" = 0,
				"bag" = 4,
			),
			/obj/item/rogueore/iron = list(
				"equip" = 0,
				"bag" = 5,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/blacksmithing = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/blueprint/mace_mushroom = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Cheesemaker  (pilgrim/cheesemaker.dm)
// Advclass path: /datum/advclass/cheesemaker
// Missing items in TAT catalog: /obj/item/book/rogue/yeoldecookingmanual; /obj/item/clothing/cloak/apron; /obj/item/clothing/shoes/roguetown/simpleshoes; /obj/item/clothing/suit/roguetown/shirt/shortshirt/random; /obj/item/clothing/under/roguetown/tights/random; /obj/item/natural/cloth; /obj/item/reagent_containers/food/snacks/rogue/cheddar; /obj/item/reagent_containers/powder/salt; /obj/item/recipe_book/survival
/datum/tat_preset/pilgrim/pilgrim_cheesemaker
	id = "pilgrim_cheesemaker"
	name = "Cheesemaker"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
			/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/under/roguetown/tights/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = 1,
			/obj/item/clothing/cloak/apron = 1,
			/obj/item/clothing/shoes/roguetown/simpleshoes = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/reagent_containers/glass/bottle/waterskin/milk = 1,
			/obj/item/flint = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/reagent_containers/powder/salt = 3,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
			/obj/item/natural/cloth = 2,
			/obj/item/book/rogue/yeoldecookingmanual = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/simpleshoes = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/waterskin/milk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/powder/salt = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/reagent_containers/food/snacks/rogue/cheddar = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/natural/cloth = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/book/rogue/yeoldecookingmanual = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Gambler  (pilgrim/drunkard.dm)
// Advclass path: /datum/advclass/drunkard
// Missing items in TAT catalog: /obj/item/clothing/mask/cigarette/rollie/cannabis; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/shortshirt/random; /obj/item/clothing/under/roguetown/tights/vagrant; /obj/item/reagent_containers/glass/bottle/rogue/wine; /obj/item/reagent_containers/glass/cup; /obj/item/storage/pill_bottle/dice; /obj/item/storage/pill_bottle/dice/farkle; /obj/item/toy/cards/deck
// Dynamic note: ADD_TRAIT(H, TRAIT_CRACKHEAD, TRAIT_GENERIC)
/datum/tat_preset/pilgrim/pilgrim_drunkard
	id = "pilgrim_drunkard"
	name = "Gambler"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 2,
			STATKEY_CON = 1,
			STATKEY_STR = 1,
		),

		"skills" = list(
			/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/under/roguetown/tights/vagrant = 1,
			/obj/item/clothing/gloves/roguetown/fingerless = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/mask/cigarette/rollie/cannabis = 1,
			/obj/item/flint = 1,
			/obj/item/storage/pill_bottle/dice = 1,
			/obj/item/storage/pill_bottle/dice/farkle = 1,
			/obj/item/reagent_containers/glass/cup = 1,
			/obj/item/toy/cards/deck = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/wine = 1,
			/obj/item/flashlight/flare/torch = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/under/roguetown/tights/vagrant = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/cigarette/rollie/cannabis = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/pill_bottle/dice = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/pill_bottle/dice/farkle = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/cup = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/toy/cards/deck = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/wine = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Fisher  (pilgrim/fisher.dm)
// Advclass path: /datum/advclass/fisher
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/fisherhat; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/dress/gen/random; /obj/item/clothing/suit/roguetown/shirt/shortshirt/random; /obj/item/clothing/under/roguetown/tights/random; /obj/item/fishingrod; /obj/item/natural/worms; /obj/item/recipe_book/survival; /obj/item/rogueweapon/shovel/small
/datum/tat_preset/pilgrim/pilgrim_fisher
	id = "pilgrim_fisher"
	name = "Fisher"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 2,
			STATKEY_LCK = 2,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/labor/fishing = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/traps = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_CAUTIOUS_FISHER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/under/roguetown/tights/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 2,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 2,
			/obj/item/clothing/head/roguetown/fisherhat = 2,
			/obj/item/rogueweapon/huntingknife = 2,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/fishingrod = 2,
			/obj/item/cooking/pan = 2,
			/obj/item/flint = 2,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = 1,
			/obj/item/natural/worms = 4,
			/obj/item/rogueweapon/shovel/small = 2,
			/obj/item/flashlight/flare/torch = 2,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 2,
		),

		"item_loadout" = list(
			/obj/item/clothing/under/roguetown/tights/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/fisherhat = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/fishingrod = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/cooking/pan = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/natural/worms = list(
				"equip" = 0,
				"bag" = 4,
			),
			/obj/item/rogueweapon/shovel/small = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 2,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Homesteader  (pilgrim/homesteader.dm)
// Advclass path: /datum/advclass/homesteader
// Missing traits in TAT: as it's a specialty skill.
// Missing items in TAT catalog: /obj/item/book/rogue/yeoldecookingmanual; /obj/item/clothing/mask/rogue/spectacles; /obj/item/dye_brush; /obj/item/hair_dye_cream; /obj/item/natural/clay; /obj/item/natural/clay/glassbatch; /obj/item/natural/cloth; /obj/item/natural/worms; /obj/item/reagent_containers/food/snacks/rogue/cheddar; /obj/item/reagent_containers/powder/salt; /obj/item/recipe_book/builder; /obj/item/recipe_book/survival; /obj/item/roguegear; /obj/item/rogueore/coal; /obj/item/rogueweapon/chisel; /obj/item/rogueweapon/handsaw; /obj/item/rogueweapon/shovel/small; /obj/item/storage/belt/rogue/pouch/coins/mid
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
/datum/tat_preset/pilgrim/pilgrim_homesteader
	id = "pilgrim_homesteader"
	name = "Homesteader"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_STR = 1,
			STATKEY_WIL = 1,
			STATKEY_PER = 1,
			STATKEY_LCK = 1,
		),

		"skills" = list(
			/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/music = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/ceramics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_JACKOFALLTRADES = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
			TRAIT_SEWING_EXPERT = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			as it's a specialty skill. = TRUE,
		),

		"items" = list(
			/obj/item/clothing/mask/rogue/spectacles = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/flint = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/handsaw = 1,
			/obj/item/dye_brush = 1,
			/obj/item/recipe_book/builder = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/reagent_containers/powder/salt = 3,
			/obj/item/reagent_containers/food/snacks/rogue/cheddar = 2,
			/obj/item/natural/cloth = 2,
			/obj/item/book/rogue/yeoldecookingmanual = 1,
			/obj/item/natural/worms = 2,
			/obj/item/rogueweapon/shovel/small = 1,
			/obj/item/hair_dye_cream = 3,
			/obj/item/rogueweapon/chisel = 1,
			/obj/item/natural/clay = 3,
			/obj/item/natural/clay/glassbatch = 1,
			/obj/item/rogueore/coal = 1,
			/obj/item/roguegear = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/mask/rogue/spectacles = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/handsaw = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/dye_brush = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/builder = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/powder/salt = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/reagent_containers/food/snacks/rogue/cheddar = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/natural/cloth = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/book/rogue/yeoldecookingmanual = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/worms = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/rogueweapon/shovel/small = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/hair_dye_cream = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/rogueweapon/chisel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/clay = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/natural/clay/glassbatch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueore/coal = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/roguegear = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Bow-Hunter  (pilgrim/hunter.dm)
// Advclass path: /datum/advclass/hunter
// Missing traits in TAT: TRAIT_OUTDOORSMAN; TRAIT_MASTERFUL_HUNTER
// Missing items in TAT catalog: /obj/item/bait; /obj/item/clothing/cloak/raincloak/furcloak/brown; /obj/item/clothing/head/roguetown/archercap; /obj/item/clothing/head/roguetown/roguehood/red; /obj/item/clothing/shoes/roguetown/boots/furlinedboots; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/tunic/green; /obj/item/clothing/suit/roguetown/shirt/undershirt/green; /obj/item/clothing/under/roguetown/tights/green; /obj/item/hunting_map/white_stag; /obj/item/recipe_book/leatherworking; /obj/item/recipe_book/survival; /obj/item/rogueweapon/huntingknife/combat/messser; /obj/item/storage/meatbag
// Dynamic note: Choice list `weapons`: Recurve Bow; Crossbow
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/huntersyell)
/datum/tat_preset/pilgrim/pilgrim_hunter
	id = "pilgrim_hunter"
	name = "Bow-Hunter"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 3,
			STATKEY_INT = 1,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/fishing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_OUTDOORSMAN = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
			TRAIT_MASTERFUL_HUNTER = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/archercap = 1,
			/obj/item/clothing/head/roguetown/roguehood/red = 2,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 2,
			/obj/item/clothing/suit/roguetown/shirt/tunic/green = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/green = 1,
			/obj/item/clothing/under/roguetown/tights/green = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/backpack/rogue/backpack = 2,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/flashlight/flare/torch/lantern = 2,
			/obj/item/storage/meatbag = 2,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 1,
			/obj/item/quiver/arrows = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
			/obj/item/quiver/bolt/standard = 1,
			/obj/item/clothing/head/roguetown/armingcap = 1,
			/obj/item/clothing/cloak/raincloak/furcloak/brown = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/hide = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/shoes/roguetown/boots/furlinedboots = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/spear = 1,
			/obj/item/flint = 1,
			/obj/item/bait = 1,
			/obj/item/rogueweapon/huntingknife/combat/messser = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/recipe_book/leatherworking = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/hunting_map/white_stag = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/archercap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/red = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/green = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/green = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/green = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/meatbag = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/arrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/standard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/armingcap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/furcloak/brown = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/hide = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/furlinedboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/bait = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/combat/messser = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/leatherworking = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/hunting_map/white_stag = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Levy  (pilgrim/levy.dm)
// Advclass path: /datum/advclass/levy
// Missing items in TAT catalog: /obj/item/clothing/cloak/tabard/stabard/bog; /obj/item/clothing/neck/roguetown/coif; /obj/item/clothing/suit/roguetown/shirt/undershirt/guard; /obj/item/recipe_book/survival; /obj/item/rogueweapon/flail/militia; /obj/item/rogueweapon/greataxe/militia; /obj/item/rogueweapon/spear/militia; /obj/item/rogueweapon/stoneaxe/woodcut; /obj/item/rogueweapon/sword/falchion/militia
// Dynamic note: Choice list `weapons`: MINE PITCHFORK; MINE THRESHER; THE FAMILY SWORD; MINE SHOVEL
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
/datum/tat_preset/pilgrim/pilgrim_levy
	id = "pilgrim_levy"
	name = "Levy"
	build_data = list(
		"stats" = list(
			STATKEY_CON = 1,
			STATKEY_STR = 1,
			STATKEY_WIL = 1,
			STATKEY_INT = -1,
		),

		"skills" = list(
			/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/helmet/kettle/iron = 1,
			/obj/item/clothing/neck/roguetown/coif = 1,
			/obj/item/clothing/head/roguetown/armingcap = 1,
			/obj/item/clothing/cloak/tabard/stabard/bog = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/guard = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/clothing/gloves/roguetown/leather = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/spear/militia = 1,
			/obj/item/rogueweapon/flail/militia = 1,
			/obj/item/rogueweapon/sword/falchion/militia = 1,
			/obj/item/rogueweapon/greataxe/militia = 1,
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/helmet/kettle/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/armingcap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/bog = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/guard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/militia = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/militia = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/falchion/militia = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/militia = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/metal = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Miner  (pilgrim/miner.dm)
// Advclass path: /datum/advclass/miner
// Missing traits in TAT: TRAIT_DARKVISION; TRAIT_SMITHING_EXPERT); because from what I observe of miner players they tend to do smithing far more than farming etc.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_LCK = 2,
		STATKEY_WIL = 2
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/cap; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/dress/gen; /obj/item/clothing/suit/roguetown/shirt/undershirt/brown; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/recipe_book/builder; /obj/item/recipe_book/survival; /obj/item/rogueweapon/chisel; /obj/item/rogueweapon/hammer/wood; /obj/item/storage/hip/orestore/bronze
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
/datum/tat_preset/pilgrim/pilgrim_miner
	id = "pilgrim_miner"
	name = "Miner"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_CON = 1,
			STATKEY_LCK = 2,
			STATKEY_WIL = 2,
		),

		"skills" = list(
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_DARKVISION = TRUE,
			TRAIT_SMITHING_EXPERT) = TRUE,
			because from what I observe of miner players they tend to do smithing far more than farming etc.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_LCK = 2,
		STATKEY_WIL = 2 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/cap = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/pick = 1,
			/obj/item/storage/hip/orestore/bronze = 2,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/brown = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/flint = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/chisel = 1,
			/obj/item/rogueweapon/hammer/wood = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/recipe_book/builder = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/cap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/pick = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/hip/orestore/bronze = list(
				"equip" = 1,
				"bag" = 1,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/brown = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/chisel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/hammer/wood = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/builder = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Minstrel  (pilgrim/minstrel.dm)
// Advclass path: /datum/advclass/minstrel
// Missing items in TAT catalog: /obj/item/clothing/cloak/half; /obj/item/clothing/suit/roguetown/shirt/tunic/white
// Dynamic note: I.grant_inspiration(H, bard_tier = BARD_T2)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
/datum/tat_preset/pilgrim/pilgrim_minstrel
	id = "pilgrim_minstrel"
	name = "Minstrel"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 1,
			STATKEY_LCK = 1,
		),

		"skills" = list(
			/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_EMPATH = TRUE,
			TRAIT_GOODLOVER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/cloak/half = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = 1,
			/obj/item/rogue/instrument/accord = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/belt/rogue/leather/cloth = 1,
			/obj/item/rogueweapon/huntingknife/idagger = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/flute = 1,
			/obj/item/rogue/instrument/drum = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/half = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/accord = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/cloth = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/lute = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogue/instrument/flute = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogue/instrument/drum = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Farmer  (pilgrim/peasant.dm)
// Advclass path: /datum/advclass/peasant
// Missing items in TAT catalog: /obj/item/ash; /obj/item/clothing/head/roguetown/cap; /obj/item/clothing/shoes/roguetown/simpleshoes; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/dress/gen/random; /obj/item/clothing/suit/roguetown/shirt/undershirt; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/recipe_book/survival; /obj/item/seeds/apple; /obj/item/seeds/wheat
// Dynamic note: Choice list `seeds`: Berry seeds" = /obj/item/storage/roguebag/farmer_berries; Rocknut seeds" = /obj/item/storage/roguebag/farmer_rocknut; Exotic fruit seeds" = /obj/item/storage/roguebag/farmer_fruits; Some extra smokes" = /obj/item/storage/roguebag/farmer_smokes; )
		var/seedbag_names = list()
		for (var/name in seeds)
			seedbag_names += name
		for (var/i = 1 to 2
/datum/tat_preset/pilgrim/pilgrim_peasant
	id = "pilgrim_peasant"
	name = "Farmer"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 1,
			STATKEY_INT = -1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/head/roguetown/cap = 1,
			/obj/item/clothing/shoes/roguetown/simpleshoes = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/flint = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt = 1,
			/obj/item/rogueweapon/sickle = 1,
			/obj/item/rogueweapon/hoe = 1,
			/obj/item/seeds/wheat = 1,
			/obj/item/seeds/apple = 1,
			/obj/item/ash = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/cap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/simpleshoes = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sickle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hoe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/seeds/wheat = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/seeds/apple = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/ash = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Potter  (pilgrim/potter.dm)
// Advclass path: /datum/advclass/potter
// Missing items in TAT catalog: /obj/item/clothing/cloak/apron/blacksmith; /obj/item/clothing/head/roguetown/hatblu; /obj/item/clothing/head/roguetown/hatfur; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/dye_brush; /obj/item/natural/clay; /obj/item/natural/clay/glassbatch; /obj/item/recipe_book/ceramics; /obj/item/roguegear; /obj/item/rogueore/coal; /obj/item/storage/belt/rogue/pouch/coins/mid
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/digclay)
/datum/tat_preset/pilgrim/pilgrim_potter
	id = "pilgrim_potter"
	name = "Potter"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
			STATKEY_SPD = -1,
		),

		"skills" = list(
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			,
			having to source their own clay.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/ceramics = SKILL_LEVEL_MASTER,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/hatfur = 1,
			/obj/item/clothing/head/roguetown/hatblu = 1,
			/obj/item/clothing/cloak/apron/blacksmith = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/rogueweapon/blowrod = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/rogueweapon/shovel = 1,
			/obj/item/natural/clay = 3,
			/obj/item/natural/clay/glassbatch = 1,
			/obj/item/rogueore/coal = 1,
			/obj/item/roguegear = 1,
			/obj/item/dye_brush = 1,
			/obj/item/recipe_book/ceramics = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/hatfur = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/hatblu = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron/blacksmith = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/blowrod = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/tongs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shovel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/natural/clay = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/natural/clay/glassbatch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueore/coal = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/roguegear = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/dye_brush = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/ceramics = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Master Chef  (pilgrim/rare/Lchef.dm)
// Advclass path: /datum/advclass/masterchef
// Missing items in TAT catalog: /obj/item/book/rogue/yeoldecookingmanual; /obj/item/clothing/cloak/apron; /obj/item/clothing/head/roguetown/chef; /obj/item/clothing/suit/roguetown/shirt/shortshirt/random; /obj/item/clothing/under/roguetown/tights/random; /obj/item/kitchen/spoon; /obj/item/natural/cloth; /obj/item/reagent_containers/food/snacks/butter; /obj/item/reagent_containers/food/snacks/rogue/handpie; /obj/item/reagent_containers/food/snacks/rogue/honey/spider; /obj/item/reagent_containers/peppermill; /obj/item/reagent_containers/powder/flour; /obj/item/reagent_containers/powder/salt; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/pilgrim/pilgrim_Lchef
	id = "pilgrim_Lchef"
	name = "Master Chef"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_CON = 2,
		),

		"skills" = list(
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/under/roguetown/tights/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = 1,
			/obj/item/clothing/cloak/apron = 1,
			/obj/item/clothing/head/roguetown/chef = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/cooking/pan = 1,
			/obj/item/rogueweapon/huntingknife/chefknife/cleaver = 1,
			/obj/item/flint = 2,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/kitchen/rollingpin = 1,
			/obj/item/kitchen/spoon = 1,
			/obj/item/natural/cloth = 1,
			/obj/item/reagent_containers/peppermill = 1,
			/obj/item/reagent_containers/powder/flour = 2,
			/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 2,
			/obj/item/reagent_containers/powder/salt = 1,
			/obj/item/reagent_containers/food/snacks/butter = 1,
			/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
			/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
			/obj/item/book/rogue/yeoldecookingmanual = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/chef = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/cooking/pan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/chefknife/cleaver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/kitchen/rollingpin = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/kitchen/spoon = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/cloth = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/peppermill = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/powder/flour = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/reagent_containers/food/snacks/rogue/honey/spider = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/reagent_containers/powder/salt = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/food/snacks/butter = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/food/snacks/rogue/meat/salami = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/food/snacks/rogue/handpie = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/book/rogue/yeoldecookingmanual = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Master Fisher  (pilgrim/rare/Lfish.dm)
// Advclass path: /datum/advclass/fishermaster
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/fisherhat; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor; /obj/item/clothing/suit/roguetown/shirt/shortshirt/random; /obj/item/fishingrod; /obj/item/natural/worms; /obj/item/rogueweapon/shovel/small; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/pilgrim/pilgrim_Lfish
	id = "pilgrim_Lfish"
	name = "Master Fisher"
	build_data = list(
		"stats" = list(
			STATKEY_CON = 2,
			STATKEY_PER = 2,
			STATKEY_SPD = 2,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
			/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/fishing = SKILL_LEVEL_LEGENDARY,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/under/roguetown/trou = 2,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather = 2,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 2,
			/obj/item/clothing/head/roguetown/fisherhat = 2,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor = 2,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/fishingrod = 2,
			/obj/item/cooking/pan = 1,
			/obj/item/rogueweapon/huntingknife = 2,
			/obj/item/flint = 1,
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/natural/worms = 4,
			/obj/item/rogueweapon/shovel/small = 2,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt/random = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/fisherhat = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/fishingrod = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/cooking/pan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/natural/worms = list(
				"equip" = 0,
				"bag" = 4,
			),
			/obj/item/rogueweapon/shovel/small = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Master Miner  (pilgrim/rare/Lminer.dm)
// Advclass path: /datum/advclass/minermaster
// Missing traits in TAT: TRAIT_DARKVISION
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/cap; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/recipe_book/builder; /obj/item/recipe_book/survival; /obj/item/rogueweapon/chisel; /obj/item/rogueweapon/hammer/wood; /obj/item/storage/belt/rogue/pouch/coins/mid; /obj/item/storage/hip/orestore/bronze
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
/datum/tat_preset/pilgrim/pilgrim_Lminer
	id = "pilgrim_Lminer"
	name = "Master Miner"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 4,
			STATKEY_STR = 2,
			STATKEY_INT = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/mining = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/smelting = SKILL_LEVEL_LEGENDARY,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_DARKVISION = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/cap = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/rogueweapon/pick = 1,
			/obj/item/storage/hip/orestore/bronze = 2,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/flint = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/chisel = 1,
			/obj/item/rogueweapon/hammer/wood = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/recipe_book/builder = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/cap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/pick = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/hip/orestore/bronze = list(
				"equip" = 1,
				"bag" = 1,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/chisel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/hammer/wood = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/builder = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Master Farmer  (pilgrim/rare/Lpeasant.dm)
// Advclass path: /datum/advclass/farmermaster
// Missing items in TAT catalog: /obj/item/ash; /obj/item/clothing/head/roguetown/strawhat; /obj/item/clothing/mask/cigarette/pipe/westman; /obj/item/clothing/shoes/roguetown/simpleshoes; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/dress/gen/random; /obj/item/clothing/suit/roguetown/shirt/undershirt; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/seeds/apple; /obj/item/seeds/wheat; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/pilgrim/pilgrim_Lpeasant
	id = "pilgrim_Lpeasant"
	name = "Master Farmer"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 4,
			STATKEY_STR = 2,
			STATKEY_INT = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/farming = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/head/roguetown/strawhat = 1,
			/obj/item/clothing/shoes/roguetown/simpleshoes = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/clothing/mask/cigarette/pipe/westman = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt = 1,
			/obj/item/rogueweapon/sickle = 1,
			/obj/item/flint = 1,
			/obj/item/rogueweapon/hoe = 1,
			/obj/item/seeds/wheat = 1,
			/obj/item/seeds/apple = 1,
			/obj/item/ash = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/strawhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/simpleshoes = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/cigarette/pipe/westman = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sickle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hoe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/seeds/wheat = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/seeds/apple = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/ash = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Master Blacksmith  (pilgrim/rare/Lsmith.dm)
// Advclass path: /datum/advclass/masterblacksmith
// Missing traits in TAT: TRAIT_TRAINED_SMITH
// Missing items in TAT catalog: /obj/item/clothing/cloak/apron/blacksmith; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/dress/gen/random; /obj/item/clothing/suit/roguetown/shirt/shortshirt; /obj/item/clothing/suit/roguetown/shirt/undershirt; /obj/item/rogueore/coal; /obj/item/rogueore/iron; /obj/item/rogueore/silver; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/pilgrim/pilgrim_Lsmith
	id = "pilgrim_Lsmith"
	name = "Master Blacksmith"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 4,
			STATKEY_STR = 2,
			STATKEY_INT = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/blacksmithing = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/armorsmithing = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/weaponsmithing = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/smelting = SKILL_LEVEL_LEGENDARY,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_TRAINED_SMITH = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/clothing/gloves/roguetown/leather = 1,
			/obj/item/clothing/mask/rogue/facemask/steel = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/cloak/apron/blacksmith = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/flint = 1,
			/obj/item/rogueore/coal = 2,
			/obj/item/rogueore/iron = 2,
			/obj/item/rogueore/silver = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hammer/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/tongs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron/blacksmith = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueore/coal = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/rogueore/iron = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/rogueore/silver = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Seamster  (pilgrim/seamstress.dm)
// Advclass path: /datum/advclass/seamstress
// Missing items in TAT catalog: /obj/item/book/granter/crafting_recipe/tailor/eastern; /obj/item/book/granter/crafting_recipe/tailor/western; /obj/item/clothing/cloak/raincloak/furcloak; /obj/item/clothing/suit/roguetown/armor/armordress; /obj/item/clothing/suit/roguetown/shirt/tunic/white; /obj/item/clothing/under/roguetown/tights/random; /obj/item/natural/bundle/fibers/full; /obj/item/natural/cloth; /obj/item/recipe_book/leatherworking; /obj/item/recipe_book/sewing; /obj/item/storage/belt/rogue/leather/cloth/lady
// Dynamic note: Choice list `regions`: The Familiar; The Unfamiliar
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)
/datum/tat_preset/pilgrim/pilgrim_seamstress
	id = "pilgrim_seamstress"
	name = "Seamster"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 2,
			STATKEY_INT = 2,
			STATKEY_PER = 1,
			STATKEY_STR = -1,
		),

		"skills" = list(
			/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_SEWING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/cloak/raincloak/furcloak = 1,
			/obj/item/clothing/suit/roguetown/armor/armordress = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = 1,
			/obj/item/clothing/under/roguetown/tights/random = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/belt/rogue/leather/cloth/lady = 1,
			/obj/item/needle = 1,
			/obj/item/rogueweapon/huntingknife/scissors = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/book/granter/crafting_recipe/tailor/western = 1,
			/obj/item/book/granter/crafting_recipe/tailor/eastern = 1,
			/obj/item/natural/cloth = 2,
			/obj/item/natural/bundle/fibers/full = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/needle/thorn = 1,
			/obj/item/recipe_book/sewing = 1,
			/obj/item/recipe_book/leatherworking = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/furcloak = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/armordress = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/cloth/lady = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/needle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/scissors = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/granter/crafting_recipe/tailor/western = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/granter/crafting_recipe/tailor/eastern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/natural/cloth = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/natural/bundle/fibers/full = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/needle/thorn = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/sewing = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/leatherworking = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Goon  (pilgrim/thug.dm)
// Advclass path: /datum/advclass/thug/goon
// Missing traits in TAT: TRAIT_SEEPRICES_SHITTY
// Missing items in TAT catalog: /obj/item/clothing/gloves/roguetown/bandages; /obj/item/clothing/suit/roguetown/armor/manual/pushups/leather; /obj/item/clothing/suit/roguetown/shirt/desertbra; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/clothing/under/roguetown/tights/random; /obj/item/recipe_book/survival
// Dynamic note: Choice list `options`: Frypan; Knuckles; Navaja; Bare Hands; My Trusty Cudgel; Whatever I Can Find
// Dynamic note: Choice list `options`: Sling; Magic Bricks; Lockpicking Equipment
// Dynamic note: Choice list `options`: Hands-On; Big Axe
// Dynamic note: Choice list `techniques`: Dropkick - Pushback + Extra Damage; Chokeslam - Stamina Damage; Stunner - Dazed Debuff; Headbutt - Vulnerable Debuff") // cool wrestling moves
	var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
	switch(technique_choice)
		if("Dropkick - Pushback + Extra Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("Chokeslam - Stamina Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("Stunner - Dazed Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("Headbutt - Vulnerable Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)

	var/prefixs = list(
		"Skinny" = "Skinny", // Why
		"Fat" = "Fat",
		"Big" = "Big", // Yes, There is two cases where if someone calls themselves "Boss", we need to explode them.
		"Small" = "Small",
		"Huge" = "Huge",
		"Little" = "Little",
		"Thick" = "Thick",
		"Thin" = "Thin",
		"Long" = "Long",
		"Short" = "Short",
		"Wide" = "Wide",
		"Slug" = "Slug",
		"Molasses" = "Molasses",
		"Stony" = "Stony",
		"Quick" = "Quick
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_APPRENTICE, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/magicians_brick)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_BASHDOORS, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
/datum/tat_preset/pilgrim/pilgrim_thug
	id = "pilgrim_thug"
	name = "Goon"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_WIL = 1,
			STATKEY_CON = 2,
			STATKEY_SPD = -1,
			STATKEY_INT = -2,
			STATKEY_PER = -2,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/mining = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_SEEPRICES_SHITTY = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather/rope = 3,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 2,
			/obj/item/clothing/under/roguetown/tights/random = 2,
			/obj/item/clothing/shoes/roguetown/shortboots = 3,
			/obj/item/storage/backpack/rogue/satchel = 3,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 3,
			/obj/item/clothing/gloves/roguetown/fingerless = 3,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/clothing/suit/roguetown/armor/leather = 2,
			/obj/item/cooking/pan = 1,
			/obj/item/clothing/gloves/roguetown/knuckles/bronze = 1,
			/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 1,
			/obj/item/quiver/sling/iron = 1,
			/obj/item/lockpickring/mundane = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather = 1,
			/obj/item/clothing/suit/roguetown/shirt/desertbra = 1,
			/obj/item/clothing/gloves/roguetown/bandages = 1,
			/obj/item/rogueweapon/greataxe = 1,
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/random = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 3,
				"bag" = 1,
			),
			/obj/item/clothing/suit/roguetown/armor/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/cooking/pan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/knuckles/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/navaja = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/sling/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/lockpickring/mundane = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/desertbra = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/metal = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Town Elder  (pilgrim/townelder.dm)
// Advclass path: /datum/advclass/elder
// Missing traits in TAT: TRAIT_SEEPRICES_SHITTY
// Missing items in TAT catalog: /obj/item/clothing/cloak/tabard/stabard/guardhood/elder; /obj/item/clothing/head/roguetown/chaperon/greyscale/elder; /obj/item/clothing/suit/roguetown/armor/leather/vest/white; /obj/item/clothing/suit/roguetown/shirt/dress/silkdress; /obj/item/clothing/suit/roguetown/shirt/tunic; /obj/item/clothing/under/roguetown/tights; /obj/item/roguekey/manor; /obj/item/rogueweapon/huntingknife/idagger/steel/special; /obj/item/storage/belt/rogue/pouch/coins/rich
/datum/tat_preset/pilgrim/pilgrim_townelder
	id = "pilgrim_townelder"
	name = "Town Elder"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
			STATKEY_SPD = -1,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_MASTER,
			/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/ceramics = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_SEEPRICES_SHITTY = TRUE,
			TRAIT_EMPATH = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
			TRAIT_SEWING_EXPERT = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/cloak/tabard/stabard/guardhood/elder = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/vest/white = 1,
			/obj/item/roguekey/manor = 1,
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = 1,
			/obj/item/clothing/under/roguetown/tights = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/clothing/head/roguetown/chaperon/greyscale/elder = 2,
			/obj/item/clothing/suit/roguetown/shirt/dress/silkdress = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic = 1,
			/obj/item/clothing/gloves/roguetown/leather = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/cloak/tabard/stabard/guardhood/elder = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest/white = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/roguekey/manor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/chaperon/greyscale/elder = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/silkdress = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/rich = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Witch  (pilgrim/witch.dm)
// Advclass path: /datum/advclass/witch
// Missing traits in TAT: TRAIT_DEATHSIGHT; TRAIT_WITCH
// Missing items in TAT catalog: /obj/item/candle/yellow; /obj/item/clothing/gloves/roguetown/leather/black; /obj/item/clothing/head/roguetown/roguehood/black; /obj/item/clothing/head/roguetown/witchhat; /obj/item/clothing/suit/roguetown/armor/corset; /obj/item/clothing/suit/roguetown/shirt/robe/phys; /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut; /obj/item/clothing/suit/roguetown/shirt/undershirt/priest; /obj/item/clothing/under/roguetown/skirt/red; /obj/item/storage/magebag/starter
// Dynamic note: Choice list `classes`: Old Magick; Godsblood; Mystagogue
// Dynamic note: Choice list `shapeshifts`: Zad; Cat; Cat (Black); Bat; Lesser Volf; Cabbit; Small Rous; Lesser Venard
// Dynamic note: ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
/datum/tat_preset/pilgrim/pilgrim_witch
	id = "pilgrim_witch"
	name = "Witch"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_SPD = 2,
			STATKEY_LCK = 1,
		),

		"skills" = list(
			/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_DEATHSIGHT = TRUE,
			TRAIT_WITCH = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/witchhat = 1,
			/obj/item/clothing/head/roguetown/roguehood/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/phys = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/priest = 1,
			/obj/item/clothing/gloves/roguetown/leather/black = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/magebag/starter = 2,
			/obj/item/clothing/neck/roguetown/psicross/wood = 2,
			/obj/item/clothing/suit/roguetown/armor/corset = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut = 1,
			/obj/item/clothing/under/roguetown/skirt/red = 1,
			/obj/item/reagent_containers/glass/mortar = 1,
			/obj/item/pestle = 1,
			/obj/item/candle/yellow = 2,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/witchhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/phys = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/priest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/magebag/starter = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/wood = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/corset = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/skirt/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/mortar = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/pestle = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/candle/yellow = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/chalk = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Woodworker  (pilgrim/woodworker.dm)
// Advclass path: /datum/advclass/woodworker
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/roguehood; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/dress/gen; /obj/item/clothing/suit/roguetown/shirt/undershirt/random; /obj/item/recipe_book/builder; /obj/item/recipe_book/survival; /obj/item/rogueweapon/hammer/wood; /obj/item/rogueweapon/handsaw
/datum/tat_preset/pilgrim/pilgrim_woodworker
	id = "pilgrim_woodworker"
	name = "Woodworker"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_WIL = 1,
			STATKEY_CON = 1,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/traps = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/head/roguetown/roguehood = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/rogueweapon/handsaw = 1,
			/obj/item/rogueweapon/hammer/wood = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = 1,
			/obj/item/flint = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/recipe_book/builder = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/handsaw = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/hammer/wood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/random = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flint = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/builder = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)
