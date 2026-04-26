/datum/tat_preset/sample/cleric
	id = "cleric_monk"
	name = "Adventurer: Monk"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 10,
			STATKEY_CON = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/staves = 2,
			/datum/skill/combat/polearms = 2,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/magic/holy = 1,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_CIVILIZEDBARBARIAN = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
			TAT_TRAIT_STRAYING_SOUL = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
			/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/food/snacks/rogue/meat/salami = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/food/snacks/rogue/bread = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/beer = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/cleric_paladin
	id = "cleric_paladin"
	name = "Adventurer: Paladin"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/whipsflails = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/magic/holy = 2,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
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
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/cleric_cantor
	id = "cleric_cantor"
	name = "Adventurer: Cantor"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_WIL = 11,
			STATKEY_SPD = 12,
		),

		"skills" = list(
			/datum/skill/misc/music = 4,
			/datum/skill/magic/holy = 2,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 3,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_EMPATH = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T2 = TRUE,
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

/datum/tat_preset/sample/cleric_missionary
	id = "cleric_missionary"
	name = "Adventurer: Missionary"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_PER = 12,
			STATKEY_WIL = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/staves = 2,
			/datum/skill/magic/holy = 4,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 4,
			/datum/skill/misc/medicine = 2,
			/datum/skill/craft/crafting = 2,
		),

		"traits" = list(
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_DIVINE_BOON_2 = TRUE,
			TAT_TRAIT_DIVINE_BOON_3 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
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

/datum/tat_preset/sample/foreigner
	id = "foreigner"
	name = "Adventurer: Eastern Warrior"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/craft/sewing = 2,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/foreigner_yoruku
	id = "foreigner_yoruku"
	name = "Adventurer: Eastern Assassin"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 13,
			STATKEY_PER = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/tracking = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/misc/lockpicking = 4,
			/datum/skill/craft/traps = 4,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 4,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/bomb/smoke = 3,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/bomb/smoke = list(
				"equip" = 0,
				"bag" = 3,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/foreigner_repentant
	id = "foreigner_repentant"
	name = "Adventurer: Otavan Repentant"
	build_data = list(
		"stats" = list(
			STATKEY_CON = 13,
			STATKEY_SPD = 9,
			STATKEY_STR = 9,
			STATKEY_WIL = 13,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/combat/whipsflails = 4,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_CRITICAL_RESISTANCE = TRUE,
			TRAIT_NOPAINSTUN = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/foreigner_refugee
	id = "foreigner_refugee"
	name = "Adventurer: Naledi Refugee"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 12,
			STATKEY_PER = 11,
			STATKEY_WIL = 11,
			STATKEY_INT = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/combat/polearms = 4,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/foreigner_slaver
	id = "foreigner_slaver"
	name = "Adventurer: Ranesheni Slaver"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/whipsflails = 3,
			/datum/skill/combat/shields = 3,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/huntingknife = 1,
		),

		"item_loadout" = list(
			/obj/item/rope/chain = list(
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

/datum/tat_preset/sample/foreigner_shepherd
	id = "foreigner_shepherd"
	name = "Adventurer: Szöréndnížine Shepherd"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 11,
			STATKEY_PER = 12,
			STATKEY_CON = 12,
		),

		"skills" = list(
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/axes = 3,
			/datum/skill/craft/crafting = 1,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/labor/lumberjacking = 1,
			/datum/skill/labor/farming = 3,
			/datum/skill/labor/butchering = 2,
			/datum/skill/craft/cooking = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/craft/sewing = 3,
		),

		"traits" = list(
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
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

/datum/tat_preset/sample/foreigner_fencerguy
	id = "foreigner_fencerguy"
	name = "Adventurer: Foreign Fencer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_PER = 13,
		),

		"skills" = list(
			/datum/skill/combat/swords = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/climbing = 2,
			/datum/skill/craft/sewing = 2,
			/datum/skill/misc/medicine = 2,
		),

		"traits" = list(
			TRAIT_INTELLECTUAL = TRUE,
			TRAIT_FENCERDEXTERITY = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/natural/bundle/cloth/bandage/full = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/bundle/cloth/bandage/full = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/foreigner_bronzeclad
	id = "foreigner_bronzeclad"
	name = "Adventurer: Thespian-Errant"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_WIL = 13,
			STATKEY_CON = 12,
			STATKEY_SPD = 8,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/medicine = 1,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/huntingknife/bronze = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/bronze = list(
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

/datum/tat_preset/sample/foreigner_lesserblackoak
	id = "foreigner_lesserblackoak"
	name = "Adventurer: Azurian Grovewalker"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_SPD = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/tracking = 3,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/tanning = 1,
			/datum/skill/craft/crafting = 1,
			/datum/skill/craft/carpentry = 1,
			/datum/skill/labor/farming = 1,
			/datum/skill/misc/medicine = 1,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/mage
	id = "mage"
	name = "Adventurer: Sorcerer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_PER = 12,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/staves = 2,
			/datum/skill/combat/polearms = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 1,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/reading = 4,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/magic/arcane = 3,
			/datum/skill/misc/swimming = 1,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_MAGE_MAJOR_SLOT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/mage_spellblade
	id = "mage_spellblade"
	name = "Adventurer: Azurcaephan"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 11,
			STATKEY_PER = 11,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/combat/shields = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/magic/arcane = 2,
			/datum/skill/misc/swimming = 1,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_SPELLBLADE = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

/datum/tat_preset/sample/mage_spellsinger
	id = "mage_spellsinger"
	name = "Adventurer: Spellsinger"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_SPD = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/music = 4,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/magic/arcane = 2,
			/datum/skill/misc/swimming = 1,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_EMPATH = TRUE,
			TRAIT_GOODLOVER = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T2 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

/datum/tat_preset/sample/mage_spellfist
	id = "mage_spellfist"
	name = "Adventurer: Spellfist"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 11,
			STATKEY_WIL = 12,
			STATKEY_PER = 12,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/magic/arcane = 2,
		),

		"traits" = list(
			TRAIT_CIVILIZEDBARBARIAN = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/chalk = 1,
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
			/obj/item/chalk = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/mystic
	id = "mystic"
	name = "Adventurer: Mystic"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_CON = 12,
			STATKEY_WIL = 12,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/misc/medicine = 2,
			/datum/skill/magic/arcane = 2,
			/datum/skill/magic/holy = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/combat/staves = 3,
		),

		"traits" = list(
			TRAIT_SEEDKNOW = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

/datum/tat_preset/sample/mystic_resilientsoul
	id = "mystic_resilientsoul"
	name = "Adventurer: Sage"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 11,
			STATKEY_CON = 13,
			STATKEY_WIL = 12,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/misc/medicine = 2,
			/datum/skill/magic/arcane = 2,
			/datum/skill/magic/holy = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/combat/staves = 3,
		),

		"traits" = list(
			TRAIT_SEEDKNOW = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/folding_alchcauldron_stored = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/folding_alchcauldron_stored = list(
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

/datum/tat_preset/sample/mystic_holyblade
	id = "mystic_holyblade"
	name = "Adventurer: Holyblade"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_PER = 11,
			STATKEY_INT = 11,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/alchemy = 1,
			/datum/skill/misc/medicine = 1,
			/datum/skill/magic/arcane = 2,
			/datum/skill/magic/holy = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/combat/shields = 2,
		),

		"traits" = list(
			TRAIT_SEEDKNOW = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

/datum/tat_preset/sample/mystic_theurgist
	id = "mystic_theurgist"
	name = "Adventurer: Theurgist"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 13,
			STATKEY_CON = 11,
			STATKEY_WIL = 12,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/reading = 3,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/misc/medicine = 1,
			/datum/skill/magic/arcane = 2,
			/datum/skill/magic/holy = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/combat/staves = 3,
		),

		"traits" = list(
			TRAIT_SEEDKNOW = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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

/datum/tat_preset/sample/noble
	id = "noble"
	name = "Adventurer: Aristocrat"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_INT = 12,
			STATKEY_STR = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/misc/riding = 4,
			/datum/skill/misc/reading = 4,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/music = 1,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_NOBLE = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/noble_knighte
	id = "noble_knighte"
	name = "Adventurer: Knight Errant"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
			STATKEY_INT = 11,
		),

		"skills" = list(
			/datum/skill/misc/riding = 2,
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/shields = 2,
			/datum/skill/combat/whipsflails = 2,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_NOBLE = TRUE,
			TRAIT_HEAVYARMOR = TRUE,
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/noble_squire
	id = "noble_squire"
	name = "Adventurer: Squire Errant"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_STR = 11,
			STATKEY_PER = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 3,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/shields = 2,
			/datum/skill/combat/whipsflails = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/misc/riding = 2,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_SQUIRE_REPAIR = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/hammer/iron = 1,
			/obj/item/rogueweapon/tongs = 1,
			/obj/item/repair_kit/metal = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/hammer/iron = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/tongs = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/repair_kit/metal = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/ranger
	id = "ranger"
	name = "Adventurer: Sentinel"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 13,
			STATKEY_SPD = 12,
		),

		"skills" = list(
			/datum/skill/combat/crossbows = 2,
			/datum/skill/combat/bows = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/wrestling = 1,
			/datum/skill/combat/unarmed = 1,
			/datum/skill/labor/fishing = 2,
			/datum/skill/labor/butchering = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/tanning = 2,
			/datum/skill/craft/sewing = 1,
			/datum/skill/craft/traps = 2,
			/datum/skill/craft/cooking = 2,
			/datum/skill/misc/tracking = 2,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/misc/hunting = 2,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
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

/datum/tat_preset/sample/ranger_wayfarer
	id = "ranger_wayfarer"
	name = "Adventurer: Wayfarer"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_SPD = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/crossbows = 4,
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/combat/knives = 3,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/reading = 1,
			/datum/skill/craft/traps = 3,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/tracking = 4,
			/datum/skill/misc/lockpicking = 2,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
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

/datum/tat_preset/sample/ranger_bombadier
	id = "ranger_bombadier"
	name = "Adventurer: Bombadier"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_INT = 12,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/combat/maces = 2,
			/datum/skill/misc/athletics = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/traps = 4,
			/datum/skill/craft/alchemy = 4,
			/datum/skill/craft/crafting = 2,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_EXPLOSIVE_SUPPLY = TRUE,
			TRAIT_OUTLANDER = TRUE,
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

/datum/tat_preset/sample/ranger_bwanderer
	id = "ranger_bwanderer"
	name = "Adventurer: Biome Wanderer"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_WIL = 12,
			STATKEY_INT = 11,
		),

		"skills" = list(
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/bows = 1,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/axes = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 2,
			/datum/skill/craft/tanning = 1,
			/datum/skill/labor/butchering = 1,
			/datum/skill/craft/cooking = 1,
			/datum/skill/misc/tracking = 3,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
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

/datum/tat_preset/sample/rogue
	id = "rogue"
	name = "Adventurer: Treasure Hunter"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 9,
			STATKEY_INT = 11,
			STATKEY_PER = 11,
			STATKEY_WIL = 11,
			STATKEY_SPD = 13,
		),

		"skills" = list(
			/datum/skill/misc/tracking = 3,
			/datum/skill/combat/swords = 2,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/whipsflails = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 5,
			/datum/skill/misc/reading = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/lockpicking = 3,
			/datum/skill/craft/traps = 3,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_SEEPRICES = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
			TRAIT_OUTLANDER = TRUE,
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

/datum/tat_preset/sample/rogue_thief
	id = "rogue_thief"
	name = "Adventurer: Thief"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 9,
			STATKEY_INT = 11,
			STATKEY_PER = 11,
			STATKEY_WIL = 11,
			STATKEY_SPD = 13,
		),

		"skills" = list(
			/datum/skill/misc/tracking = 4,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/bows = 2,
			/datum/skill/combat/maces = 3,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 6,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 4,
			/datum/skill/misc/stealing = 4,
			/datum/skill/misc/lockpicking = 4,
			/datum/skill/craft/traps = 4,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_STRAYING_SOUL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/lockpickring/mundane = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/lockpickring/mundane = list(
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

/datum/tat_preset/sample/rogue_bard
	id = "rogue_bard"
	name = "Adventurer: Bard"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_SPD = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/knives = 3,
			/datum/skill/misc/reading = 4,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/music = 5,
			/datum/skill/misc/lockpicking = 3,
			/datum/skill/craft/traps = 2,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_GOODLOVER = TRUE,
			TRAIT_EMPATH = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T1 = TRUE,
			TAT_TRAIT_BARDIC_INSPIRATION_T2 = TRUE,
			TAT_TRAIT_STRAYING_SOUL = TRUE,
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

/datum/tat_preset/sample/rogue_swashbuckler
	id = "rogue_swashbuckler"
	name = "Adventurer: Swashbuckler"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 12,
			STATKEY_STR = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/swords = 3,
			/datum/skill/misc/swimming = 4,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 3,
			/datum/skill/misc/music = 2,
			/datum/skill/misc/lockpicking = 2,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_NUTCRACKER = TRUE,
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_STRAYING_SOUL = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = list(
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

/datum/tat_preset/sample/sfighter
	id = "sfighter"
	name = "Adventurer: Battlemaster"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 11,
			STATKEY_CON = 12,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/shields = 1,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
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

/datum/tat_preset/sample/sfighter_duelist
	id = "sfighter_duelist"
	name = "Adventurer: Duelist"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_STR = 11,
			STATKEY_WIL = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/swords = 2,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/combat/shields = 2,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/sfighter_barbarian
	id = "sfighter_barbarian"
	name = "Adventurer: Barbarian"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 13,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
			STATKEY_INT = 8,
		),

		"skills" = list(
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_CRITICAL_RESISTANCE = TRUE,
			TRAIT_NOPAINSTUN = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife/bronze = 1,
		),

		"item_loadout" = list(
			/obj/item/flashlight/flare/torch = list(
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
			/obj/item/rogueweapon/huntingknife/bronze = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/sfighter_ironclad
	id = "sfighter_ironclad"
	name = "Adventurer: Ironclad"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 2,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/swords = 2,
			/datum/skill/combat/shields = 2,
			/datum/skill/combat/whipsflails = 2,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/misc/swimming = 1,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 2,
			/datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_HEAVYARMOR = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/repair_kit/metal/bad = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/repair_kit/metal/bad = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/sfighter_mhunter
	id = "sfighter_mhunter"
	name = "Adventurer: Exorcist"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_PER = 12,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/tracking = 4,
			/datum/skill/craft/alchemy = 2,
			/datum/skill/misc/hunting = 2,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_PURITAN_ADVENTURER = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch/metal = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
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
		),

		"magic_config" = list(),
	)

/datum/tat_preset/sample/sfighter_deprived
	id = "sfighter_deprived"
	name = "Adventurer: Deprived"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 13,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
			STATKEY_LCK = 11,
			STATKEY_INT = 8,
		),

		"skills" = list(
			/datum/skill/combat/maces = 3,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/combat/shields = 3,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_CRITICAL_RESISTANCE = TRUE,
			TRAIT_NOPAINSTUN = TRUE,
			TRAIT_HOMESTEAD_EXPERT = TRUE,
			TRAIT_OUTLANDER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)
