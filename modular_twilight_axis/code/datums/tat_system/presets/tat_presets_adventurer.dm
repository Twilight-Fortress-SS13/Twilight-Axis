// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; holy skill 2 needs divine module progression.
/datum/tat_preset/sample/cleric
	id = "cleric"
	name = "Monk"
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

// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; holy skill 2 needs divine module progression.
/datum/tat_preset/sample/cleric_paladin
	id = "cleric_paladin"
	name = "Paladin"
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

// Source class: /datum/advclass/cleric/cantor
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Harp | Lute | Accordion | Guitar | Hurdy-Gurdy | Viola | Vocal Talisman | Psyaltery | Flute | Drum
// Encoded TAT points snapshot: stats=7, traits=3, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; holy skill 2 needs divine module progression; bard/music chassis needs Bardic Inspiration I; master bard/music chassis needs Bardic Inspiration II.
/datum/tat_preset/sample/cleric_cantor
	id = "cleric_cantor"
	name = "Cantor"
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

// Source class: /datum/advclass/cleric/missionary
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Woodstaff | Quarterstaff
// Encoded TAT points snapshot: stats=7, traits=0, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_DIVINE_BOON_3.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; holy skill 4 needs divine module progression.
/datum/tat_preset/sample/cleric_missionary
	id = "cleric_missionary"
	name = "Missionary"
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

// Source class: /datum/advclass/foreigner
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Naginata | Quarterstaff | Hwando
// Encoded TAT points snapshot: stats=7, traits=1, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner
	id = "foreigner"
	name = "Eastern Warrior"
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

// Source class: /datum/advclass/foreigner/yoruku
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Tanto | Kodachi | Oni | Kitsune
// Encoded TAT points snapshot: stats=8, traits=3, items_static=6
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner_yoruku
	id = "foreigner_yoruku"
	name = "Eastern Assassin"
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

// Source class: /datum/advclass/foreigner/repentant
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=2, traits=8, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/foreigner_repentant
	id = "foreigner_repentant"
	name = "Otavan Repentant"
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

// Source class: /datum/advclass/foreigner/refugee
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=3, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/foreigner_refugee
	id = "foreigner_refugee"
	name = "Naledi Refugee"
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

// Source class: /datum/advclass/foreigner/slaver
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=4, items_static=2
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner_slaver
	id = "foreigner_slaver"
	name = "Ranesheni Slaver"
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

// Source class: /datum/advclass/foreigner/shepherd
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=5, traits=0, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner_shepherd
	id = "foreigner_shepherd"
	name = "Szöréndnížine Shepherd"
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

// Source class: /datum/advclass/foreigner/fencerguy
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Balanced Longsword & Seax | Spear & Punch Dagger | Sabre
// Encoded TAT points snapshot: stats=5, traits=4, items_static=5
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner_fencerguy
	id = "foreigner_fencerguy"
	name = "Foreign Fencer"
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

// Source class: /datum/advclass/foreigner/bronzeclad
// Missing TAT traits: TRAIT_BLOOD_RESISTANCE
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Spatha & +1 Unarmed | Trident & +1 Unarmed | Greataxe & +1 Unarmed | Axepick & +1 Unarmed | Winged Spear + Greatshield | Heavy Khopesh + Greatshield | Shortsword + Shield | Messer + Shield | Falchion + Shield | Khopesh + Shield | Axe + Shield | Warclub + Shield | Flail + Shield | Spear + Shield | Axegauntlet + Shortsword | Nothing - Skilled Pugilist, +I STR / -I WIL | A Javelin's Bag | A Sling With Bronze Pellets | A Bow With Bronze Arrows | Another Shortsword & Skills In Dual-Wielding ...
// Encoded TAT points snapshot: stats=3, traits=1, items_static=4
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4.
/datum/tat_preset/sample/foreigner_bronzeclad
	id = "foreigner_bronzeclad"
	name = "Thespian-Errant"
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

// Source class: /datum/advclass/foreigner/lesserblackoak
// Missing TAT traits: TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_WOODWALKER
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/rogueweapon/huntingknife/idagger/elvish/autumn
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Autumned Longsword | Autumned Glaive | Autumned Bow
// Encoded TAT points snapshot: stats=7, traits=2, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/foreigner_lesserblackoak
	id = "foreigner_lesserblackoak"
	name = "Azurian Grovewalker"
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

// Source class: /datum/advclass/mage
// Missing TAT traits: none
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=4, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; arcane access/skill 3 needs mage module progression.
/datum/tat_preset/sample/mage
	id = "mage"
	name = "Sorcerer"
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

// Source class: /datum/advclass/mage/spellblade
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: blade | phalangite | macebearer | blade | Longsword | Rapier | Sabre | Iron Arming Sword | Shortsword | Hwando | Steel Dagger | phalangite | Spear | Dory | Naginata | macebearer | Mace | Warhammer | Goedendag | Iron Axe ...
// Encoded TAT points snapshot: stats=4, traits=1, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_SPELLBLADE.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; arcane access/skill 2 needs mage module progression; spellblade source gimmick needs Spellblade module.
/datum/tat_preset/sample/mage_spellblade
	id = "mage_spellblade"
	name = "Azurcaephan"
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

// Source class: /datum/advclass/mage/spellsinger
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Spitfire | Frost Bolt | Arc Bolt | Greater Arcyne Bolt | Stygian Efflorescence | Arcyne Lance | Lesser Gravel Blast | Harp | Lute | Accordion | Guitar | Hurdy-Gurdy | Viola | Vocal Talisman | Psyaltery | Flute
// Encoded TAT points snapshot: stats=7, traits=4, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; arcane access/skill 2 needs mage module progression; bard/music chassis needs Bardic Inspiration I; master bard/music chassis needs Bardic Inspiration II.
/datum/tat_preset/sample/mage_spellsinger
	id = "mage_spellsinger"
	name = "Spellsinger"
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

// Source class: /datum/advclass/mage/spellfist
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: katar | knuckledusters
// Encoded TAT points snapshot: stats=7, traits=3, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/mage_spellfist
	id = "mage_spellfist"
	name = "Spellfist"
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

// Source class: /datum/advclass/mystic
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=6, traits=2, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; holy skill 2 needs divine module progression; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/mystic
	id = "mystic"
	name = "Mystic"
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

// Source class: /datum/advclass/mystic/resilientsoul
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/recipe_book/alchemy, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Spitfire | Frost Bolt | Arc Bolt | Greater Arcyne Bolt | Stygian Efflorescence | Arcyne Lance | Lesser Gravel Blast | Goedendag | Quarterstaff
// Encoded TAT points snapshot: stats=6, traits=2, items_static=5
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; holy skill 2 needs divine module progression; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/mystic_resilientsoul
	id = "mystic_resilientsoul"
	name = "Sage"
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

// Source class: /datum/advclass/mystic/holyblade
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Spitfire | Frost Bolt | Arc Bolt | Greater Arcyne Bolt | Stygian Efflorescence | Arcyne Lance | Lesser Gravel Blast | Sword & Shield | Axe & Shield | Warhammer & Shield | Spear
// Encoded TAT points snapshot: stats=6, traits=2, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; holy skill 2 needs divine module progression; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/mystic_holyblade
	id = "mystic_holyblade"
	name = "Holyblade"
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

// Source class: /datum/advclass/mystic/theurgist
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Spitfire | Frost Bolt | Arc Bolt | Greater Arcyne Bolt | Stygian Efflorescence | Arcyne Lance | Lesser Gravel Blast
// Encoded TAT points snapshot: stats=6, traits=2, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; holy skill 2 needs divine module progression; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/mystic_theurgist
	id = "mystic_theurgist"
	name = "Theurgist"
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

// Source class: /datum/advclass/noble
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=8, traits=1, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4.
/datum/tat_preset/sample/noble
	id = "noble"
	name = "Aristocrat"
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

// Source class: /datum/advclass/noble/knighte
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Longsword | Mace + Shield | Flail + Shield | Greatflail | Billhook | Battle Axe | Greataxe
// Encoded TAT points snapshot: stats=7, traits=6, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/noble_knighte
	id = "noble_knighte"
	name = "Knight Errant"
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

// Source class: /datum/advclass/noble/squire
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/repair_kit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Light Armor | Medium Armor
// Encoded TAT points snapshot: stats=7, traits=2, items_static=9
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/noble_squire
	id = "noble_squire"
	name = "Squire Errant"
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

// Source class: /datum/advclass/ranger
// Missing TAT traits: TRAIT_OUTDOORSMAN, TRAIT_EXPERT_HUNTER
// Missing TAT items: /obj/item/bait, /obj/item/rogueweapon/huntingknife/combat, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Recurve Bow | Crossbow
// Encoded TAT points snapshot: stats=7, traits=2, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/ranger
	id = "ranger"
	name = "Sentinel"
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

// Source class: /datum/advclass/ranger/wayfarer
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=2, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/ranger_wayfarer
	id = "ranger_wayfarer"
	name = "Wayfarer"
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

// Source class: /datum/advclass/ranger/bombadier
// Missing TAT traits: TRAIT_BOMBER_EXPERT
// Missing TAT items: /obj/item/bomb, /obj/item/recipe_book/survival, /obj/item/flint
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=8, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/ranger_bombadier
	id = "ranger_bombadier"
	name = "Bombadier"
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

// Source class: /datum/advclass/ranger/bwanderer
// Missing TAT traits: TRAIT_OUTDOORSMAN
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Recurve Bow | Billhook | Sling | Crossbow | Light Armor | Medium Armor
// Encoded TAT points snapshot: stats=5, traits=0, items_static=2
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/ranger_bwanderer
	id = "ranger_bwanderer"
	name = "Biome Wanderer"
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

// Source class: /datum/advclass/rogue
// Missing TAT traits: none
// Missing TAT items: /obj/item/lockpick, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Sabre | Whip
// Encoded TAT points snapshot: stats=7, traits=5, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4.
/datum/tat_preset/sample/rogue
	id = "rogue"
	name = "Treasure Hunter"
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

// Source class: /datum/advclass/rogue/thief
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=2, items_static=4
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4.
/datum/tat_preset/sample/rogue_thief
	id = "rogue_thief"
	name = "Thief"
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

// Source class: /datum/advclass/rogue/bard
// Missing TAT traits: none
// Missing TAT items: /obj/item/lockpick, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Harp | Lute | Accordion | Guitar | Hurdy-Gurdy | Viola | Vocal Talisman | Psyaltery | Flute
// Encoded TAT points snapshot: stats=7, traits=5, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_BARDIC_INSPIRATION_T1, TAT_TRAIT_BARDIC_INSPIRATION_T2.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4; bard/music chassis needs Bardic Inspiration I; master bard/music chassis needs Bardic Inspiration II.
/datum/tat_preset/sample/rogue_bard
	id = "rogue_bard"
	name = "Bard"
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

// Source class: /datum/advclass/rogue/swashbuckler
// Missing TAT traits: none
// Missing TAT items: /obj/item/bomb, /obj/item/lockpick, /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7, traits=4, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander.
/datum/tat_preset/sample/rogue_swashbuckler
	id = "rogue_swashbuckler"
	name = "Swashbuckler"
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

// Source class: /datum/advclass/sfighter
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Short Sword & Iron Shield | Arming Sword & Wood Shield | Longsword & +1 Wrestling | Broadsword & +1 Wrestling | Battle Axe & Wood Shield | Mace & Iron Shield | Flail & Iron Shield | Billhook | Greatflail | Chainmaille Set | Iron Breastplate | Gambeson & Helmet | Light Raneshi Armor
// Encoded TAT points snapshot: stats=7, traits=4, items_static=1
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/sfighter
	id = "sfighter"
	name = "Battlemaster"
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

// Source class: /datum/advclass/sfighter/duelist
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Rapier & Parrying Dagger | Sabre & Buckler | Messer & Buckler | Dagger & Parrying Dagger | Heavy Dagger & +1 Unarmed | Dual Wield Shortswords | Classical Set | Cuirass Set
// Encoded TAT points snapshot: stats=7, traits=4, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/sfighter_duelist
	id = "sfighter_duelist"
	name = "Duelist"
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

// Source class: /datum/advclass/sfighter/barbarian
// Missing TAT traits: TRAIT_RAGE
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Bronze Katar | Bronze Axe | Bronze Sword | Bronze Mace | Bronze Spear | Bronze Flail | Discipline - Whiphunter (+I PER / -I SPD)
// Encoded TAT points snapshot: stats=7, traits=8, items_static=4
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +6 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/sfighter_barbarian
	id = "sfighter_barbarian"
	name = "Barbarian"
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

// Source class: /datum/advclass/sfighter/ironclad
// Missing TAT traits: none
// Missing TAT items: /obj/item/recipe_book/survival
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Breastplate, Hauberk, & Kilt | Half-Plate, Gambeson, & Chausses | Banded Iron, Light Gambeson, & Pants | Executioner's Sword | Broadsword | Warhammer + Shield | Flail + Shield | Studded Flail + Shield | Greatflail | Lucerne | Greataxe | Banded Sword + Shield
// Encoded TAT points snapshot: stats=7, traits=5, items_static=5
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/sfighter_ironclad
	id = "sfighter_ironclad"
	name = "Ironclad"
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

// Source class: /datum/advclass/sfighter/mhunter
// Missing TAT traits: TRAIT_EXPERT_HUNTER
// Missing TAT items: /obj/item/recipe_book/survival, /obj/item/book/rogue/trophy_rules
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Silver Dagger | Silver Shortsword | Silver Arming Sword | Silver Rapier | Silver Longsword | Silver Broadsword | Silver Mace | Silver Warhammer | Silver Morningstar | Silver Whip | Silver War Axe | Silver Poleaxe | Silver Spear | Silver Quarterstaff | Broadsword - Steel | Dagger - Steel | Parrying Dagger - Steel | Heavy Dagger - Steel | Blessed Silver Stake | Blessed Silver Shovel ...
// Encoded TAT points snapshot: stats=7, traits=6, items_static=3
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +5 exceeds base +4.
/datum/tat_preset/sample/sfighter_mhunter
	id = "sfighter_mhunter"
	name = "Exorcist"
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

// Source class: /datum/advclass/sfighter/deprived
// Missing TAT traits: TRAIT_SHIRTLESS, TRAIT_WILD_EATER, TRAIT_OUTDOORSMAN
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=7.5, traits=11, items_static=0
// TAT finalization: added/required gating traits: TRAIT_OUTLANDER, TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: adventurer preset must carry Outlander; stat total +7 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/sfighter_deprived
	id = "sfighter_deprived"
	name = "Deprived"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 13,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
			STATKEY_LCK = 11,
			// A single point of fortune over barbarian. STATKEY_INT = 8,
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
