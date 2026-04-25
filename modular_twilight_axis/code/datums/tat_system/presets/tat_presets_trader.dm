// Source class: /datum/advclass/trader/brewer
// Missing TAT traits: none
// Missing TAT items: /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead, /obj/item/reagent_containers/glass/bottle/rogue/beer/voddena, /obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat, /obj/item/reagent_containers/glass/bottle/rogue/elfred, /obj/item/reagent_containers/glass/bottle/rogue/elfblue, /obj/item/ingot/copper, /obj/item/roguegear, /obj/item/bottle_kit, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=4, items_static=1
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_brewer
	id = "trader_brewer"
	name = "Trader: Brewer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 11,
			STATKEY_CON = 11,
			STATKEY_STR = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/maces = 1,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/cooking = 3,
			/datum/skill/craft/engineering = 1,
			// CBT to make a copper distillery /datum/skill/labor/farming = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 1,
		),

		"traits" = list(
			TRAIT_CICERONE = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/trader/cuisiner
// Missing TAT traits: none
// Missing TAT items: /obj/item/clothing/mask/cigarette/rollie/nicotine/cheroot, /obj/item/reagent_containers/peppermill, /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged, /obj/item/reagent_containers/food/snacks/butter, /obj/item/kitchen/rollingpin, /obj/item/flint, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=5, items_static=1
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_cuisiner
	id = "trader_cuisiner"
	name = "Trader: Cuisiner"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 11,
			STATKEY_CON = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/maces = 1,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/cooking = 4,
			/datum/skill/labor/farming = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 2,
		),

		"traits" = list(
			TRAIT_GOODLOVER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife/chefknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife/chefknife = list(
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

// Source class: /datum/advclass/trader/doomsayer
// Missing TAT traits: TRAIT_PSYCHOSIS
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=3, items_static=7
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_doomsayer
	id = "trader_doomsayer"
	name = "Trader: Doomsayer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 11,
			STATKEY_STR = 11,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/axes = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/carpentry = 3,
			/datum/skill/craft/masonry = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/labor/lumberjacking = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 2,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/clothing/neck/roguetown/psicross/silver = 3,
			/obj/item/clothing/neck/roguetown/psicross = 2,
			/obj/item/clothing/neck/roguetown/psicross/wood = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/trader/harlequin
// Missing TAT traits: none
// Missing TAT items: /obj/item/storage/pill_bottle/dice, /obj/item/toy/cards/deck, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Harp | Lute | Accordion | Guitar | Hurdy-Gurdy | Viola | Vocal Talisman
// Encoded TAT points snapshot: stats=7, traits=4, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2.
// TAT finalization: remaining class-parity notes: stat total +5 exceeds base +4; bard/music chassis needs Bardic Inspiration I; master bard/music chassis needs Bardic Inspiration II.
/datum/tat_preset/sample/trader_harlequin
	id = "trader_harlequin"
	name = "Trader: Harlequin"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 12,
			STATKEY_PER = 11,
			STATKEY_WIL = 11,
			STATKEY_INT = 11,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 4,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/music = 4,
			/datum/skill/misc/lockpicking = 2,
		),

		"traits" = list(
			TRAIT_NUTCRACKER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T2 = TRUE,
		),

		"items" = list(
			/obj/item/bomb/smoke = 3,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/bomb/smoke = list(
				"equip" = 0,
				"bag" = 3,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/trader/jeweler
// Missing TAT traits: TRAIT_TRAINED_SMITH
// Missing TAT items: /obj/item/clothing/ring/silver, /obj/item/clothing/ring/gold, /obj/item/roguegem/yellow, /obj/item/roguegem/green, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=3, items_static=3
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_jeweler
	id = "trader_jeweler"
	name = "Trader: Jeweler"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 11,
			STATKEY_STR = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/blacksmithing = 4,
			/datum/skill/craft/weaponsmithing = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/labor/mining = 2,
			/datum/skill/craft/smelting = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 1,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/rogueweapon/hammer/steel = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/tongs = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/hammer/steel = list(
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

// Source class: /datum/advclass/trader/servant
// Missing TAT traits: TRAIT_KEENEARS
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Maid | Butler
// Encoded TAT points snapshot: stats=6, traits=3, items_static=1
// TAT finalization: added/required gating traits: TAT_TRAIT_RESIDENT.
// TAT finalization: remaining class-parity notes: trader preset should be Resident/city trade chassis.
/datum/tat_preset/sample/trader_servant
	id = "trader_servant"
	name = "Trader: Wandering Servant"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_SPD = 12,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/craft/cooking = 3,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/sewing = 3,
			/datum/skill/misc/medicine = 1,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/lockpicking = 1,
			/datum/skill/misc/climbing = 2,
			/datum/skill/combat/wrestling = 2,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/trader/peddler
// Missing TAT traits: none
// Missing TAT items: /obj/item/reagent_containers/powder/spice, /obj/item/reagent_containers/powder/ozium, /obj/item/reagent_containers/powder/moondust, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=6, items_static=1
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_peddler
	id = "trader_peddler"
	name = "Trader: Peddler"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 12,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/stealing = 2,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/misc/medicine = 4,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 1,
			/datum/skill/craft/alchemy = 3,
		),

		"traits" = list(
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/trader/scholar
// Missing TAT traits: none
// Missing TAT items: /obj/item/paper/scroll, /obj/item/book/rogue/knowledge1, /obj/item/reagent_containers/glass/bottle/rogue/strongmanapot, /obj/item/natural/feather, /obj/item/roguegem/amethyst, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=3, items_static=3
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/trader_scholar
	id = "trader_scholar"
	name = "Trader: Scholar"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 11,
			STATKEY_SPD = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/knives = 1,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/reading = 6,
			/datum/skill/craft/crafting = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 1,
			/datum/skill/craft/alchemy = 4,
		),

		"traits" = list(
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = list(
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
