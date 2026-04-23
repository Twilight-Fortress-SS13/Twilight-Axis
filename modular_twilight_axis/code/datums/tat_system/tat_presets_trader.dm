/// Auto-generated TAT preset pack for archetype: trader
/// Source: types.zip + tat_system.zip
/// NOTE: Dynamic class choices, spells, money, and non-TAT-only mechanics are preserved as comments where direct 1:1 encoding was not possible.

// ---------------------------------------------------------------------------
// Brewer  (trader/brewer.dm)
// Advclass path: /datum/advclass/trader/brewer
// Missing items in TAT catalog: /obj/item/clothing/mask/rogue/ragmask/black; /obj/item/clothing/suit/roguetown/armor/longcoat; /obj/item/clothing/suit/roguetown/shirt/tunic/red; /obj/item/clothing/under/roguetown/tights/black; /obj/item/ingot/copper; /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat; /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead; /obj/item/reagent_containers/glass/bottle/rogue/beer/voddena; /obj/item/reagent_containers/glass/bottle/rogue/elfblue; /obj/item/reagent_containers/glass/bottle/rogue/elfred; /obj/item/recipe_book/survival; /obj/item/roguegear; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/trader/trader_brewer
	id = "trader_brewer"
	name = "Brewer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 1,
			STATKEY_CON = 1,
			STATKEY_STR = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_CICERONE = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/mask/rogue/ragmask/black = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/armor/longcoat = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/red = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/elfblue = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/ingot/copper = 2,
			/obj/item/roguegear = 1,
			/obj/item/bottle_kit = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/mask/rogue/ragmask/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/longcoat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/elfred = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/elfblue = list(
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
			/obj/item/ingot/copper = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/roguegear = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/bottle_kit = list(
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
// Cuisiner  (trader/cuisiner.dm)
// Advclass path: /datum/advclass/trader/cuisiner
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/chef; /obj/item/clothing/suit/roguetown/armor/workervest; /obj/item/clothing/suit/roguetown/shirt/undershirt
/datum/tat_preset/trader/trader_cuisiner
	id = "trader_cuisiner"
	name = "Cuisiner"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 1,
			STATKEY_CON = 1,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_EXPERT,
			/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_GOODLOVER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/chef = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/under/roguetown/trou = 1,
			/obj/item/clothing/suit/roguetown/armor/workervest = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/cooking/pan = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/chef = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
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
			/obj/item/clothing/suit/roguetown/armor/workervest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/cooking/pan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Doomsayer  (trader/doomsayer.dm)
// Advclass path: /datum/advclass/trader/doomsayer
// Missing traits in TAT: TRAIT_PSYCHOSIS
// Missing items in TAT catalog: /obj/item/clothing/cloak/half; /obj/item/clothing/head/roguetown/roguehood/black; /obj/item/clothing/mask/rogue/skullmask; /obj/item/clothing/suit/roguetown/shirt/tunic/black; /obj/item/clothing/under/roguetown/tights/black; /obj/item/recipe_book/survival; /obj/item/rogueweapon/stoneaxe/woodcut; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/trader/trader_doomsayer
	id = "trader_doomsayer"
	name = "Doomsayer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 1,
			STATKEY_STR = 1,
			STATKEY_CON = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/axes = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_PSYCHOSIS = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = 1,
			/obj/item/clothing/mask/rogue/skullmask = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/black = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/clothing/cloak/half = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver = 3,
			/obj/item/clothing/neck/roguetown/psicross = 2,
			/obj/item/clothing/neck/roguetown/psicross/wood = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/skullmask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/half = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
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
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/clothing/neck/roguetown/psicross = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/clothing/neck/roguetown/psicross/wood = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
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
// Harlequin  (trader/harlequin.dm)
// Advclass path: /datum/advclass/trader/harlequin
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/jester; /obj/item/clothing/shoes/roguetown/jester; /obj/item/clothing/suit/roguetown/shirt/jester; /obj/item/clothing/under/roguetown/tights; /obj/item/recipe_book/survival; /obj/item/rogue/instrument/hurdygurdy; /obj/item/storage/belt/rogue/pouch/coins/mid; /obj/item/storage/pill_bottle/dice; /obj/item/toy/cards/deck
// Dynamic note: Choice list `weapons`: Harp; Lute; Accordion; Guitar; Hurdy-Gurdy; Viola; Vocal Talisman
/datum/tat_preset/trader/trader_harlequin
	id = "trader_harlequin"
	name = "Harlequin"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 2,
			STATKEY_PER = 1,
			STATKEY_WIL = 1,
			STATKEY_INT = 1,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_NUTCRACKER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/shoes/roguetown/jester = 1,
			/obj/item/clothing/under/roguetown/tights = 1,
			/obj/item/clothing/suit/roguetown/shirt/jester = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/rogueweapon/huntingknife/idagger = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/clothing/head/roguetown/jester = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/rogue/instrument/harp = 1,
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/accord = 1,
			/obj/item/rogue/instrument/guitar = 1,
			/obj/item/rogue/instrument/hurdygurdy = 1,
			/obj/item/rogue/instrument/viola = 1,
			/obj/item/rogue/instrument/vocals = 1,
			/obj/item/bomb/smoke = 3,
			/obj/item/storage/pill_bottle/dice = 1,
			/obj/item/toy/cards/deck = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/shoes/roguetown/jester = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/jester = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger = list(
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
			/obj/item/clothing/head/roguetown/jester = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/harp = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/lute = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/accord = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/guitar = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/hurdygurdy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/viola = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/vocals = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/bomb/smoke = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/storage/pill_bottle/dice = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/toy/cards/deck = list(
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
// Jeweler  (trader/jeweler.dm)
// Advclass path: /datum/advclass/trader/jeweler
// Missing traits in TAT: TRAIT_TRAINED_SMITH
// Missing items in TAT catalog: /obj/item/clothing/cloak/raincloak/purple; /obj/item/clothing/mask/rogue/lordmask; /obj/item/clothing/ring/gold; /obj/item/clothing/ring/silver; /obj/item/clothing/suit/roguetown/shirt/tunic/purple; /obj/item/clothing/under/roguetown/tights/black; /obj/item/recipe_book/survival; /obj/item/roguegem/green; /obj/item/roguegem/yellow; /obj/item/storage/belt/rogue/pouch/coins/mid
/datum/tat_preset/trader/trader_jeweler
	id = "trader_jeweler"
	name = "Jeweler"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 1,
			STATKEY_STR = 1,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/blacksmithing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_TRAINED_SMITH = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/mask/rogue/lordmask = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/purple = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/clothing/cloak/raincloak/purple = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/clothing/ring/silver = 2,
			/obj/item/clothing/ring/gold = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/rogueweapon/hammer/steel = 1,
			/obj/item/roguegem/yellow = 1,
			/obj/item/roguegem/green = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/mask/rogue/lordmask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
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
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/ring/silver = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/clothing/ring/gold = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/tongs = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/hammer/steel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/roguegem/yellow = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/roguegem/green = list(
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
// Wandering Servant  (trader/maid.dm)
// Advclass path: /datum/advclass/trader/servant
// Missing traits in TAT: TRAIT_KEENEARS
// Missing items in TAT catalog: /obj/item/clothing/cloak/apron/waist/fancymaid; /obj/item/clothing/head/roguetown/maidband; /obj/item/clothing/shoes/roguetown/simpleshoes; /obj/item/clothing/suit/roguetown/armor/leather/vest/black; /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy; /obj/item/clothing/suit/roguetown/shirt/undershirt/formal; /obj/item/clothing/under/roguetown/tights/shorts; /obj/item/recipe_book/survival; /obj/item/storage/belt/rogue/leather/sash/maid; /obj/item/storage/belt/rogue/leather/suspenders
// Dynamic note: Choice list `choice_list`: Butler; Maid
/datum/tat_preset/trader/trader_maid
	id = "trader_maid"
	name = "Wandering Servant"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 2,
			STATKEY_SPD = 2,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TRAIT_KEENEARS = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/maidband = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/maidfancy = 1,
			/obj/item/clothing/cloak/apron/waist/fancymaid = 1,
			/obj/item/storage/belt/rogue/leather/sash/maid = 1,
			/obj/item/clothing/shoes/roguetown/simpleshoes = 1,
			/obj/item/clothing/under/roguetown/tights/shorts = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/formal = 1,
			/obj/item/clothing/shoes/roguetown/shortboots = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/vest/black = 1,
			/obj/item/storage/belt/rogue/leather/suspenders = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/maidband = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/maidfancy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/apron/waist/fancymaid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/sash/maid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/simpleshoes = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/shorts = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/formal = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shortboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/suspenders = list(
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
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
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
// Peddler  (trader/peddler.dm)
// Advclass path: /datum/advclass/trader/peddler
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/roguehood; /obj/item/clothing/suit/roguetown/shirt/robe; /obj/item/clothing/under/roguetown/tights/black; /obj/item/reagent_containers/powder/moondust; /obj/item/reagent_containers/powder/ozium; /obj/item/reagent_containers/powder/spice; /obj/item/recipe_book/survival; /obj/item/storage/belt/rogue/pouch/coins/mid; /obj/item/storage/belt/rogue/surgery_bag/full
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
/datum/tat_preset/trader/trader_peddler
	id = "trader_peddler"
	name = "Peddler"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 2,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood = 1,
			/obj/item/clothing/mask/rogue/facemask/steel = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/storage/belt/rogue/surgery_bag/full = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/reagent_containers/powder/spice = 2,
			/obj/item/reagent_containers/powder/ozium = 1,
			/obj/item/reagent_containers/powder/moondust = 2,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/mid = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/surgery_bag/full = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/powder/spice = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/reagent_containers/powder/ozium = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/powder/moondust = list(
				"equip" = 0,
				"bag" = 2,
			),
			/obj/item/rogueweapon/huntingknife = list(
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
// Scholar  (trader/scholar.dm)
// Advclass path: /datum/advclass/trader/scholar
// Missing items in TAT catalog: /obj/item/book/rogue/knowledge1; /obj/item/clothing/head/roguetown/roguehood/black; /obj/item/clothing/mask/rogue/spectacles/golden; /obj/item/clothing/suit/roguetown/shirt/robe/mageyellow; /obj/item/clothing/under/roguetown/tights/black; /obj/item/natural/feather; /obj/item/paper/scroll; /obj/item/reagent_containers/glass/bottle/rogue/strongmanapot; /obj/item/recipe_book/survival; /obj/item/roguegem/amethyst; /obj/item/storage/belt/rogue/pouch/coins/mid
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
/datum/tat_preset/trader/trader_scholar
	id = "trader_scholar"
	name = "Scholar"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 1,
			STATKEY_SPD = 1,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = 1,
			/obj/item/clothing/mask/rogue/spectacles/golden = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/mageyellow = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/huntingknife/idagger = 1,
			/obj/item/paper/scroll = 3,
			/obj/item/book/rogue/knowledge1 = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot = 1,
			/obj/item/natural/feather = 1,
			/obj/item/roguegem/amethyst = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/spectacles/golden = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/mageyellow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
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
			/obj/item/rogueweapon/huntingknife/idagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/paper/scroll = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/book/rogue/knowledge1 = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/feather = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/roguegem/amethyst = list(
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
