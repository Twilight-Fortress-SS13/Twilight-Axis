// Source class: /datum/advclass/barbersurgeon
// Missing TAT traits: none
// Missing TAT items: /obj/item/natural/worms/leech/cheele, /obj/item/natural/cloth, /obj/item/hair_dye_cream, /obj/item/heart_blood_canister/filled, /obj/item/bait/leech, /obj/item/recipe_book/alchemy
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=4.5, traits=9, items_static=6
/datum/tat_preset/sample/barbersurgeon
	id = "barbersurgeon"
	name = "Barber Surgeon"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_LCK = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/labor/lumberjacking = 1,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/climbing = 1,
			/datum/skill/misc/sneaking = 1,
			/datum/skill/misc/medicine = 5,
			/datum/skill/craft/sewing = 3,
			/datum/skill/craft/alchemy = 2,
		),

		"traits" = list(
			TRAIT_EMPATH = TRUE,
			TRAIT_NOSTINK = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife/scissors/steel = 1,
			/obj/item/folding_alchcauldron_stored = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/scissors/steel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/folding_alchcauldron_stored = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/blacksmith
// Missing TAT traits: TRAIT_TRAINED_SMITH
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Ironworker | Bronzeworker
// Encoded TAT points snapshot: stats=4.5, traits=3, items_static=0
/datum/tat_preset/sample/blacksmith
	id = "blacksmith"
	name = "Blacksmith"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 12,
			STATKEY_CON = 12,
			STATKEY_STR = 11,
			STATKEY_LCK = 11,
			STATKEY_SPD = 9,
		),

		"skills" = list(
			/datum/skill/combat/swords = 1,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/crossbows = 1,
			/datum/skill/misc/athletics = 2,
			/datum/skill/combat/bows = 1,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			// The strongest fists in the land. /datum/skill/combat/knives = 1,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/engineering = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/craft/blacksmithing = 4,
			/datum/skill/craft/armorsmithing = 4,
			/datum/skill/craft/weaponsmithing = 4,
			/datum/skill/craft/smelting = 4,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/cheesemaker
// Missing TAT traits: none
// Missing TAT items: /obj/item/reagent_containers/powder/salt, /obj/item/reagent_containers/food/snacks/rogue/cheddar, /obj/item/natural/cloth, /obj/item/book/rogue/yeoldecookingmanual, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=5, traits=3, items_static=0
/datum/tat_preset/sample/cheesemaker
	id = "cheesemaker"
	name = "Cheesemaker"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_CON = 12,
			//Cheeese diet STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/swords = 1,
			/datum/skill/combat/maces = 1,
			/datum/skill/combat/axes = 1,
			/datum/skill/misc/athletics = 2,
			/datum/skill/combat/bows = 1,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 3,
			/datum/skill/craft/crafting = 1,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/sewing = 1,
			/datum/skill/labor/butchering = 2,
			/datum/skill/craft/cooking = 4,
			/datum/skill/labor/farming = 2,
			/datum/skill/misc/medicine = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/drunkard
// Missing TAT traits: none
// Missing TAT items: /obj/item/storage/pill_bottle/dice, /obj/item/storage/pill_bottle/dice/farkle, /obj/item/reagent_containers/glass/cup, /obj/item/toy/cards/deck, /obj/item/reagent_containers/glass/bottle/rogue/wine
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=4, traits=3, items_static=0
/datum/tat_preset/sample/drunkard
	id = "drunkard"
	name = "Gambler"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 12,
			STATKEY_CON = 11,
			STATKEY_STR = 11,
		),

		"skills" = list(
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/climbing = 2,
			//Climbing into windows to steal drugs or booze. /datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/fisher
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=5, traits=4, items_static=0
/datum/tat_preset/sample/fisher
	id = "fisher"
	name = "Fisher"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_LCK = 12,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/labor/fishing = 4,
			/datum/skill/combat/swords = 1,
			/datum/skill/combat/axes = 1,
			/datum/skill/combat/maces = 1,
			/datum/skill/combat/crossbows = 1,
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/bows = 1,
			/datum/skill/combat/wrestling = 2,
			//Wrestling down those nasty carp. /datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/polearms = 1,
			/datum/skill/misc/swimming = 4,
			/datum/skill/misc/climbing = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/craft/sewing = 1,
			/datum/skill/labor/butchering = 3,
			/datum/skill/craft/traps = 1,
			/datum/skill/misc/medicine = 2,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/craft/cooking = 2,
			/datum/skill/craft/carpentry = 1,
		),

		"traits" = list(
			TRAIT_CAUTIOUS_FISHER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/homesteader
// Missing TAT traits: TRAIT_HOMESTEAD_EXPERT // No medicine but they get the full package // No hunting, as it's a specialty skill.
// Missing TAT items: /obj/item/flint, /obj/item/rogueweapon/handsaw, /obj/item/dye_brush, /obj/item/recipe_book/builder, /obj/item/recipe_book/survival, /obj/item/reagent_containers/powder/salt, /obj/item/reagent_containers/food/snacks/rogue/cheddar, /obj/item/natural/cloth, /obj/item/book/rogue/yeoldecookingmanual, /obj/item/natural/worms, /obj/item/rogueweapon/shovel/small, /obj/item/hair_dye_cream, /obj/item/rogueweapon/chisel, /obj/item/natural/clay, /obj/item/natural/clay/glassbatch, /obj/item/rogueore/coal, /obj/item/roguegear
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=5.5, traits=16, items_static=0
/datum/tat_preset/sample/homesteader
	id = "homesteader"
	name = "Homesteader"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_WIL = 11,
			STATKEY_PER = 11,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/labor/farming = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/stealing = 2,
			/datum/skill/misc/music = 2,
			/datum/skill/misc/reading = 2,
			/datum/skill/misc/medicine = 2,
			/datum/skill/craft/sewing = 2,
			/datum/skill/craft/ceramics = 2,
			/datum/skill/misc/tracking = 2,
			/datum/skill/misc/lockpicking = 2,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/misc/riding = 2,
			/datum/skill/misc/hunting = 1,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/craft/masonry = 2,
			/datum/skill/craft/engineering = 2,
			/datum/skill/craft/traps = 2,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/craft/tanning = 2,
			/datum/skill/craft/cooking = 2,
			/datum/skill/labor/lumberjacking = 2,
			/datum/skill/labor/fishing = 2,
			/datum/skill/labor/butchering = 2,
		),

		"traits" = list(
			TRAIT_JACKOFALLTRADES = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
			TRAIT_SEWING_EXPERT = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/hunter
// Missing TAT traits: TRAIT_OUTDOORSMAN, TRAIT_MASTERFUL_HUNTER
// Missing TAT items: /obj/item/flint, /obj/item/bait, /obj/item/rogueweapon/huntingknife/combat/messser, /obj/item/recipe_book/survival, /obj/item/recipe_book/leatherworking, /obj/item/hunting_map/white_stag
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Recurve Bow | Crossbow
// Encoded TAT points snapshot: stats=6, traits=3, items_static=0
/datum/tat_preset/sample/hunter
	id = "hunter"
	name = "Bow-Hunter"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 13,
			STATKEY_INT = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/axes = 1,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/craft/tanning = 3,
			/datum/skill/labor/fishing = 1,
			/datum/skill/craft/sewing = 2,
			/datum/skill/labor/butchering = 4,
			/datum/skill/craft/traps = 3,
			/datum/skill/misc/medicine = 2,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/tracking = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/hunting = 4,
		),

		"traits" = list(
			TRAIT_SURVIVAL_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/hunter/spear
// Missing TAT traits: TRAIT_OUTDOORSMAN, TRAIT_MASTERFUL_HUNTER
// Missing TAT items: /obj/item/flint, /obj/item/bait, /obj/item/rogueweapon/huntingknife/combat/messser, /obj/item/recipe_book/survival, /obj/item/recipe_book/leatherworking, /obj/item/hunting_map/white_stag
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=6, traits=3, items_static=0
/datum/tat_preset/sample/hunter_spear
	id = "hunter_spear"
	name = "Spear-Hunter"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/polearms = 3,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/craft/tanning = 3,
			/datum/skill/labor/fishing = 1,
			/datum/skill/craft/sewing = 2,
			/datum/skill/labor/butchering = 4,
			/datum/skill/craft/traps = 3,
			/datum/skill/misc/medicine = 2,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/tracking = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/hunting = 4,
		),

		"traits" = list(
			TRAIT_SURVIVAL_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/levy
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: MINE PITCHFORK | MINE THRESHER
// Encoded TAT points snapshot: stats=3, traits=3, items_static=4
/datum/tat_preset/sample/levy
	id = "levy"
	name = "Levy"
	build_data = list(
		"stats" = list(
			STATKEY_CON = 11,
			STATKEY_STR = 11,
			STATKEY_WIL = 11,
			STATKEY_INT = 9,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/knives = 1,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/crafting = 1,
			/datum/skill/craft/cooking = 1,
			/datum/skill/craft/sewing = 1,
			/datum/skill/craft/carpentry = 3,
			/datum/skill/labor/lumberjacking = 1,
			/datum/skill/labor/farming = 1,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch/metal = list(
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

// Source class: /datum/advclass/miner
// Missing TAT traits: TRAIT_DARKVISION
// Missing TAT items: /obj/item/flint, /obj/item/rogueweapon/chisel, /obj/item/rogueweapon/hammer/wood, /obj/item/recipe_book/survival, /obj/item/recipe_book/builder, /obj/item/storage/hip/orestore/bronze
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=8, traits=3, items_static=1
/datum/tat_preset/sample/miner
	id = "miner"
	name = "Miner"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 11,
			STATKEY_LCK = 12,
			STATKEY_WIL = 12,
		),

		"skills" = list(
			/datum/skill/combat/axes = 3,
			/datum/skill/misc/athletics = 4,
			// Tough. Well fed. The strongest of the strong. /datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/knives = 1,
			/datum/skill/combat/maces = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/traps = 2,
			/datum/skill/craft/engineering = 1,
			/datum/skill/craft/carpentry = 1,
			/datum/skill/craft/masonry = 3,
			/datum/skill/misc/medicine = 1,
			/datum/skill/labor/mining = 4,
			/datum/skill/craft/smelting = 4,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

// Source class: /datum/advclass/minstrel
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=2.5, traits=6, items_static=1.5
/datum/tat_preset/sample/minstrel
	id = "minstrel"
	name = "Minstrel"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 11,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/misc/music = 4,
			/datum/skill/misc/reading = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/misc/stealing = 2,
			/datum/skill/misc/athletics = 1,
			/datum/skill/craft/crafting = 1,
			/datum/skill/combat/unarmed = 1,
		),

		"traits" = list(
			TRAIT_EMPATH = TRUE,
			TRAIT_GOODLOVER = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/flute = 1,
			/obj/item/rogue/instrument/drum = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/peasant
// Missing TAT traits: none
// Missing TAT items: /obj/item/seeds/wheat, /obj/item/seeds/apple, /obj/item/ash, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=1, traits=3, items_static=0
/datum/tat_preset/sample/peasant
	id = "peasant"
	name = "Farmer"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_INT = 9,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/combat/polearms = 2,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/sewing = 1,
			/datum/skill/labor/farming = 4,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/medicine = 1,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/potter
// Missing TAT traits: none
// Missing TAT items: /obj/item/natural/clay, /obj/item/natural/clay/glassbatch, /obj/item/rogueore/coal, /obj/item/roguegear, /obj/item/dye_brush, /obj/item/recipe_book/ceramics
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=3, traits=3, items_static=0
/datum/tat_preset/sample/potter
	id = "potter"
	name = "Potter"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
			STATKEY_SPD = 9,
		),

		"skills" = list(
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/knives = 1,
			/datum/skill/misc/climbing = 2,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/craft/masonry = 2,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/ceramics = 5,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/seamstress
// Missing TAT traits: none
// Missing TAT items: /obj/item/natural/cloth, /obj/item/natural/bundle/fibers/full, /obj/item/recipe_book/sewing, /obj/item/recipe_book/leatherworking
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: The Familiar | The Unfamiliar
// Encoded TAT points snapshot: stats=5, traits=3, items_static=0
/datum/tat_preset/sample/seamstress
	id = "seamstress"
	name = "Seamster"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 12,
			STATKEY_INT = 12,
			STATKEY_PER = 11,
			STATKEY_STR = 9,
		),

		"skills" = list(
			/datum/skill/craft/sewing = 4,
			/datum/skill/craft/crafting = 3,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/medicine = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/labor/farming = 1,
			/datum/skill/craft/tanning = 3,
			/datum/skill/craft/cooking = 1,
		),

		"traits" = list(
			TRAIT_SEWING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/needle/thorn = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/needle/thorn = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/thug/goon
// Missing TAT traits: TRAIT_SEEPRICES_SHITTY
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Frypan | Knuckles | Navaja | Bare Hands | My Trusty Cudgel | Whatever I Can Find
// Encoded TAT points snapshot: stats=1, traits=0, items_static=4
/datum/tat_preset/sample/thug_goon
	id = "thug_goon"
	name = "Goon"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 11,
			STATKEY_CON = 12,
			STATKEY_SPD = 9,
			STATKEY_INT = 8,
			STATKEY_PER = 8,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/maces = 3,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/labor/mining = 1,
			/datum/skill/labor/lumberjacking = 2,
			/datum/skill/labor/farming = 1,
			/datum/skill/labor/fishing = 2,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
		),

		"items" = list(
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch/metal = list(
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

// Source class: /datum/advclass/thug/wiseguy
// Missing TAT traits: TRAIT_SEEPRICES_SHITTY
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Sling | Magic Bricks | Lockpicking Equipment
// Encoded TAT points snapshot: stats=0, traits=2, items_static=4
/datum/tat_preset/sample/thug_wiseguy
	id = "thug_wiseguy"
	name = "Wise Guy"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 8,
			STATKEY_CON = 8,
			STATKEY_STR = 9,
			STATKEY_SPD = 12,
			STATKEY_INT = 12,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/weaponsmithing = 1,
			/datum/skill/craft/armorsmithing = 1,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/labor/lumberjacking = 2,
			/datum/skill/labor/farming = 2,
			/datum/skill/labor/fishing = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 3,
		),

		"traits" = list(
			TRAIT_CICERONE = TRUE,
			TRAIT_NUTCRACKER = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch/metal = list(
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

// Source class: /datum/advclass/thug/bigman
// Missing TAT traits: TRAIT_SEEPRICES_SHITTY
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/recipe_book/leatherworking
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Hands-On | Big Axe | Dropkick - Pushback + Extra Damage | Chokeslam - Stamina Damage | Stunner - Dazed Debuff | Headbutt - Vulnerable Debuff
// Encoded TAT points snapshot: stats=2.5, traits=3, items_static=1
/datum/tat_preset/sample/thug_bigman
	id = "thug_bigman"
	name = "Big Fella"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 15,
			STATKEY_SPD = 6,
			STATKEY_INT = 4,
			STATKEY_PER = 7,
			STATKEY_LCK = 9,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 5,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/labor/mining = 3,
			/datum/skill/labor/lumberjacking = 3,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_HARDDISMEMBER = TRUE,
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

// Source class: /datum/advclass/elder
// Missing TAT traits: TRAIT_SEEPRICES_SHITTY
// Missing TAT items: /obj/item/rogueweapon/huntingknife/idagger/steel/special, /obj/item/storage/belt/rogue/pouch/coins/rich
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=6, traits=19, items_static=0
/datum/tat_preset/sample/elder
	id = "elder"
	name = "Town Elder"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
			STATKEY_SPD = 9,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/staves = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/craft/crafting = 5,
			/datum/skill/craft/carpentry = 3,
			/datum/skill/craft/masonry = 3,
			/datum/skill/craft/engineering = 2,
			/datum/skill/craft/sewing = 4,
			/datum/skill/misc/climbing = 3,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/craft/tanning = 3,
			/datum/skill/labor/farming = 1,
			/datum/skill/misc/athletics = 1,
			/datum/skill/misc/reading = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/medicine = 4,
			/datum/skill/misc/riding = 1,
			/datum/skill/misc/tracking = 3,
			/datum/skill/craft/cooking = 3,
			/datum/skill/craft/ceramics = 3,
		),

		"traits" = list(
			TRAIT_EMPATH = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
			TRAIT_SEWING_EXPERT = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/witch
// Missing TAT traits: TRAIT_DEATHSIGHT, TRAIT_WITCH
// Missing TAT items: /obj/item/candle/yellow
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Old Magick | Godsblood | Mystagogue | Zad | Cat | Cat (Black) | Bat | Lesser Volf | Lesser Venard | Small Rous | Cabbit | Mystagogue | Spitfire | Frost Bolt | Arc Bolt | Greater Arcyne Bolt | Stygian Efflorescence | Arcyne Lance | Lesser Gravel Blast
// Encoded TAT points snapshot: stats=7.5, traits=3, items_static=2
/datum/tat_preset/sample/witch
	id = "witch"
	name = "Witch"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_SPD = 12,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/misc/reading = 4,
			/datum/skill/craft/alchemy = 4,
			/datum/skill/misc/medicine = 2,
			/datum/skill/labor/farming = 1,
			/datum/skill/craft/cooking = 1,
			/datum/skill/craft/sewing = 1,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/carpentry = 2,
		),

		"traits" = list(
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/reagent_containers/glass/mortar = 1,
			/obj/item/pestle = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/reagent_containers/glass/mortar = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/pestle = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/chalk = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/woodworker
// Missing TAT traits: none
// Missing TAT items: /obj/item/flint, /obj/item/recipe_book/builder, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=3, items_static=1
/datum/tat_preset/sample/woodworker
	id = "woodworker"
	name = "Woodworker"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 11,
			STATKEY_CON = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/axes = 3,
			// AXE MEN! GIVE ME SPLINTERS! /datum/skill/misc/athletics = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/polearms = 1,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/carpentry = 4,
			/datum/skill/craft/masonry = 1,
			/datum/skill/craft/engineering = 1,
			/datum/skill/craft/sewing = 1,
			/datum/skill/labor/butchering = 1,
			/datum/skill/labor/lumberjacking = 4,
			/datum/skill/craft/traps = 1,
			/datum/skill/misc/medicine = 1,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/masterchef
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Honey | Truffles | Bacon
// Encoded TAT points snapshot: stats=5, traits=3, items_static=0
/datum/tat_preset/sample/masterchef
	id = "masterchef"
	name = "Master Chef"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_CON = 12,
		),

		"skills" = list(
			/datum/skill/combat/unarmed = 1,
			/datum/skill/combat/knives = 4,
			/datum/skill/craft/sewing = 1,
			/datum/skill/misc/climbing = 1,
			/datum/skill/labor/farming = 3,
			/datum/skill/misc/reading = 4,
			/datum/skill/craft/crafting = 4,
			/datum/skill/craft/cooking = 6,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/fishermaster
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=8, traits=3, items_static=0
/datum/tat_preset/sample/fishermaster
	id = "fishermaster"
	name = "Master Fisher"
	build_data = list(
		"stats" = list(
			STATKEY_CON = 12,
			STATKEY_PER = 12,
			STATKEY_SPD = 12,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/combat/knives = 4,
			/datum/skill/misc/swimming = 5,
			/datum/skill/craft/cooking = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/labor/fishing = 6,
			/datum/skill/misc/medicine = 1,
			/datum/skill/misc/athletics = 3,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/minermaster
// Missing TAT traits: TRAIT_DARKVISION
// Missing TAT items: /obj/item/flint, /obj/item/rogueweapon/chisel, /obj/item/rogueweapon/hammer/wood, /obj/item/recipe_book/survival, /obj/item/recipe_book/builder, /obj/item/storage/hip/orestore/bronze
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=12, traits=3, items_static=1
/datum/tat_preset/sample/minermaster
	id = "minermaster"
	name = "Master Miner"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 14,
			STATKEY_STR = 12,
			STATKEY_INT = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/axes = 3,
			/datum/skill/misc/athletics = 4,
			// Tough. Well fed. The strongest of the strong. /datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/knives = 1,
			/datum/skill/combat/maces = 3,
			/datum/skill/craft/traps = 2,
			/datum/skill/craft/engineering = 1,
			/datum/skill/craft/carpentry = 1,
			/datum/skill/craft/masonry = 3,
			/datum/skill/misc/medicine = 1,
			/datum/skill/craft/crafting = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/labor/mining = 6,
			/datum/skill/craft/smelting = 6,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

// Source class: /datum/advclass/farmermaster
// Missing TAT traits: none
// Missing TAT items: /obj/item/seeds/wheat, /obj/item/seeds/apple, /obj/item/ash
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=12, traits=3, items_static=1
/datum/tat_preset/sample/farmermaster
	id = "farmermaster"
	name = "Master Farmer"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 14,
			STATKEY_STR = 12,
			STATKEY_INT = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/polearms = 4,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/sewing = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/labor/farming = 6,
			/datum/skill/craft/cooking = 2,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_HOMESTEAD_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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

// Source class: /datum/advclass/masterblacksmith
// Missing TAT traits: TRAIT_TRAINED_SMITH
// Missing TAT items: /obj/item/flint, /obj/item/rogueore/coal, /obj/item/rogueore/iron, /obj/item/rogueore/silver
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=12, traits=3, items_static=0
/datum/tat_preset/sample/masterblacksmith
	id = "masterblacksmith"
	name = "Master Blacksmith"
	build_data = list(
		"stats" = list(
			STATKEY_LCK = 14,
			STATKEY_STR = 12,
			STATKEY_INT = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/maces = 4,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/masonry = 2,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/craft/blacksmithing = 6,
			/datum/skill/craft/armorsmithing = 6,
			/datum/skill/craft/weaponsmithing = 6,
			/datum/skill/craft/smelting = 6,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
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
