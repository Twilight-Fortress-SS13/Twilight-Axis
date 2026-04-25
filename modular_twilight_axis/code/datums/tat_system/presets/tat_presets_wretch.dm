// Source class: /datum/advclass/wretch/ancient_deathknight
// Missing TAT traits: none
// Missing TAT items: /obj/item/rogueweapon/huntingknife/idagger/steel/corroded, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Longsword | Ancient Warhammer | Halberd | Black Jupon | Black Tabard
// Encoded TAT points snapshot: stats=3, traits=4, items_static=0
// TAT finalization: added/required gating traits: TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_ancient_deathknight
	id = "wretch_ancient_deathknight"
	name = "Unbound Ancient Death Knight"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 10,
			STATKEY_WIL = 11,
			STATKEY_INT = 8,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/polearms = 3,
			/datum/skill/combat/maces = 3,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/swords = 3,
			/datum/skill/misc/riding = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/combat/shields = 4,
		),

		"traits" = list(
			TRAIT_HEAVYARMOR = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
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

// Source class: /datum/advclass/wretch/ancient_spellblade
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: blade | phalangite | macebearer | blade | Ancient Khopesh | Sabre | Corroded Dagger | phalangite | Ancient Spear | Ancient Bardiche | Dory | macebearer | Ancient Mace | Ancient Warhammer | Ancient Grand Mace | Ancient Alloy Axe | Steel Greataxe | Black Jupon | Black Tabard
// Encoded TAT points snapshot: stats=3, traits=4, items_static=0
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_SPELLBLADE.
// TAT finalization: remaining class-parity notes: stat total +5 exceeds base +4; arcane access/skill 2 needs mage module progression; spellblade source gimmick needs Spellblade module.
/datum/tat_preset/sample/wretch_ancient_spellblade
	id = "wretch_ancient_spellblade"
	name = "Unbound Ancient Azurcaephan"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 10,
			STATKEY_PER = 11,
			STATKEY_STR = 9,
		),

		"skills" = list(
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/climbing = 2,
			/datum/skill/magic/arcane = 2,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ARCYNE = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_SPELLBLADE = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/berserker
// Missing TAT traits: TRAIT_STRONGBITE, TRAIT_RAGE
// Missing TAT items: /obj/item/rogueweapon/huntingknife/combat
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Unarmed Master | Discipline - Unarmed | Katar | Knuckledusters | Punch Dagger | Dropkick - Pushback + Extra Damage | Chokeslam - Stamina Damage | Stunner - Dazed Debuff | Headbutt - Vulnerable Debuff | Martial Expert | Discipline - Bodybuilder | Battle Axe | Grand Mace | Longsword | Iron Arming Sword | Iron Axe | Mace | Berserker's Volfskulle Bascinet | Steel Kettle + Wildguard
// Encoded TAT points snapshot: stats=9, traits=7, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +7 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_berserker
	id = "wretch_berserker"
	name = "Berserker"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 13,
			STATKEY_CON = 12,
			STATKEY_WIL = 11,
			STATKEY_SPD = 11,
			STATKEY_INT = 8,
		),

		"skills" = list(
			/datum/skill/combat/maces = 3,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/axes = 3,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/swimming = 4,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/tracking = 3,
			/datum/skill/misc/medicine = 1,
			/datum/skill/craft/tanning = 2,
			/datum/skill/craft/cooking = 1,
			/datum/skill/labor/butchering = 1,
		),

		"traits" = list(
			TRAIT_CRITICAL_RESISTANCE = TRUE,
			TRAIT_NOPAINSTUN = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/deserter
// Missing TAT traits: none
// Missing TAT items: /obj/item/rogueweapon/huntingknife/idagger/steel/special, /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Estoc | Stecher | Longsword + Shield | Mace + Shield | Flail + Shield | Lucerne | Battle Axe | Lance + Kite Shield | Samshir | Ssangsudo | Shashka + Shield | Steel Poleaxe
// Encoded TAT points snapshot: stats=11.5, traits=5, items_static=3
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +10 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_deserter
	id = "wretch_deserter"
	name = "Disgraced Knight"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 13,
			STATKEY_CON = 12,
			STATKEY_STR = 12,
			STATKEY_PER = 12,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 4,
			/datum/skill/combat/maces = 4,
			/datum/skill/combat/axes = 4,
			/datum/skill/combat/swords = 4,
			/datum/skill/combat/knives = 4,
			/datum/skill/combat/shields = 4,
			/datum/skill/combat/whipsflails = 4,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/misc/swimming = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/riding = 3,
			/datum/skill/misc/reading = 3,
		),

		"traits" = list(
			TRAIT_HEAVYARMOR = TRUE,
			TRAIT_NOBLE = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/deserter/generic
// Missing TAT traits: none
// Missing TAT items: /obj/item/natural/cloth, /obj/item/rogueweapon/huntingknife/idagger/steel/special, /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Warhammer & Shield | Sabre & Shield | Axe & Shield | Billhook | Halberd | Greataxe | Crossbow
// Encoded TAT points snapshot: stats=9, traits=3, items_static=4
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +7 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_deserter_generic
	id = "wretch_deserter_generic"
	name = "Deserter"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_WIL = 12,
			STATKEY_INT = 11,
			STATKEY_CON = 11,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 4,
			/datum/skill/combat/swords = 4,
			/datum/skill/combat/maces = 4,
			/datum/skill/combat/axes = 4,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/whipsflails = 3,
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/climbing = 4,
			// Better at climbing away than your average MaA. Only slightly. /datum/skill/misc/swimming = 3,
			// Worse at swimming than the above class. /datum/skill/misc/reading = 1,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/riding = 3,
			// That saiga was stolen. Probably. /datum/skill/misc/tracking = 1,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rope/chain = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/rope/chain = list(
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

// Source class: /datum/advclass/wretch/heretic
// Missing TAT traits: TRAIT_RITUALIST
// Missing TAT items: /obj/item/ritechalk, /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Longsword | Mace | Flail | Axe | Billhook
// Encoded TAT points snapshot: stats=8.5, traits=4, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_DIVINE_BOON_3.
// TAT finalization: remaining class-parity notes: stat total +7 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap; holy skill 4 needs divine module progression.
/datum/tat_preset/sample/wretch_heretic
	id = "wretch_heretic"
	name = "Heretic"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 12,
			STATKEY_WIL = 12,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/magic/holy = 4,
			/datum/skill/combat/maces = 3,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/axes = 3,
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/whipsflails = 3,
			/datum/skill/combat/polearms = 3,
			/datum/skill/combat/staves = 3,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 3,
		),

		"traits" = list(
			TRAIT_HEAVYARMOR = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_DIVINE_BOON_2 = TRUE,
			TAT_TRAIT_DIVINE_BOON_3 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/heretic/spy
// Missing TAT traits: TRAIT_RITUALIST
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/storage/roguebag, /obj/item/ritechalk
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Rapier | Sabre | Bow | Crossbow | Slurbow
// Encoded TAT points snapshot: stats=9.5, traits=2, items_static=8
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_DIVINE_BOON_1, TAT_TRAIT_DIVINE_BOON_2, TAT_TRAIT_DIVINE_BOON_3.
// TAT finalization: remaining class-parity notes: stat total +8 exceeds base +4; holy skill 4 needs divine module progression.
/datum/tat_preset/sample/wretch_heretic_spy
	id = "wretch_heretic_spy"
	name = "Heretic Spy"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 12,
			STATKEY_WIL = 12,
			STATKEY_SPD = 12,
			STATKEY_INT = 11,
			STATKEY_LCK = 11,
		),

		"skills" = list(
			/datum/skill/magic/holy = 4,
			/datum/skill/misc/tracking = 4,
			/datum/skill/combat/knives = 3,
			/datum/skill/combat/swords = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 5,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/sneaking = 4,
			/datum/skill/misc/stealing = 4,
			/datum/skill/misc/lockpicking = 4,
			/datum/skill/craft/traps = 3,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_DIVINE_BOON_1 = TRUE,
			TAT_TRAIT_DIVINE_BOON_2 = TRUE,
			TAT_TRAIT_DIVINE_BOON_3 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/lockpickring/mundane = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/lockpickring/mundane = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/heretic_spellblade
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: blade | phalangite | macebearer | Discretion (Spellblade Disguise) | Confrontation (Medium Armor) | blade | Avantyne Longsword | Kriegmesser | Longsword | Rapier | Sabre | Steel Arming Sword | Steel Greatsword | Steel Dagger | phalangite | Halberd | Bardiche | Boar Spear | Dory | Naginata ...
// Encoded TAT points snapshot: stats=7, traits=4, items_static=1
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_SPELLBLADE.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4; holy skill 1 needs divine module progression; arcane access/skill 2 needs mage module progression; spellblade source gimmick needs Spellblade module.
/datum/tat_preset/sample/wretch_heretic_spellblade
	id = "wretch_heretic_spellblade"
	name = "Heretic Azurcaephan"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_INT = 11,
			// Weighted 7. But a very nice statblock STATKEY_PER = 11,
			STATKEY_CON = 11,
			STATKEY_WIL = 12,
		),

		"skills" = list(
			/datum/skill/misc/climbing = 3,
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 3,
			/datum/skill/magic/arcane = 2,
			/datum/skill/misc/swimming = 1,
			/datum/skill/magic/holy = 1,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ARCYNE = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
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

// Source class: /datum/advclass/wretch/heretic_spellfist
// Missing TAT traits: TRAIT_BLOOD_RESISTANCE
// Missing TAT items: /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: katar | knuckledusters
// Encoded TAT points snapshot: stats=8, traits=3, items_static=3
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_DIVINE_INITIATE, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap; holy skill 1 needs divine module progression; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/wretch_heretic_spellfist
	id = "wretch_heretic_spellfist"
	name = "Heretic Spellfist"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_SPD = 11,
			STATKEY_WIL = 12,
			STATKEY_PER = 11,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 4,
			/datum/skill/misc/swimming = 1,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/reading = 2,
			/datum/skill/magic/arcane = 2,
			/datum/skill/magic/holy = 1,
		),

		"traits" = list(
			TRAIT_CIVILIZEDBARBARIAN = TRUE,
			TRAIT_ARCYNE = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
			TAT_TRAIT_DIVINE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
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
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
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

// Source class: /datum/advclass/wretch/licker
// Missing TAT traits: TRAIT_SILVER_WEAK
// Missing TAT items: none
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=0, traits=1, items_static=0
// TAT finalization: added/required gating traits: none.
// TAT finalization: remaining class-parity notes: manual item/loadout parity review remains.
/datum/tat_preset/sample/wretch_licker
	id = "wretch_licker"
	name = "Licker"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/mistwalker
// Missing TAT traits: TRAIT_BLOOD_RESISTANCE, TRAIT_JOURNEYS_END
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Ssangsudo +2 CON | Kanabo +1 STR | Naginata +2 PER | Hwando +2 WIL | Kodachi +1 SPD
// Encoded TAT points snapshot: stats=6, traits=3, items_static=5
// TAT finalization: added/required gating traits: TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_mistwalker
	id = "wretch_mistwalker"
	name = "Mistwalker" //works"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 3,
			/datum/skill/combat/axes = 3,
			//wish there was an oni axe or something /datum/skill/combat/swords = 3,
			/datum/skill/combat/knives = 4,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/misc/swimming = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/medicine = 3,
			//you'll get real familiar with bleeding /datum/skill/labor/butchering = 3,
			//flavour and useful for making armour /datum/skill/misc/reading = 1,
		),

		"traits" = list(
			TRAIT_NOPAINSTUN = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath/kazengun = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/munitioneer
// Missing TAT traits: TRAIT_TRAINED_SMITH, TRAIT_RITUALIST
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/ritechalk, /obj/item/rogueweapon/huntingknife/combat, /obj/item/riddleofsteel
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=8, traits=3, items_static=2
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4.
/datum/tat_preset/sample/wretch_munitioneer
	id = "wretch_munitioneer"
	name = "Munitioneer"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_CON = 12,
			STATKEY_INT = 12,
		),

		"skills" = list(
			/datum/skill/combat/crossbows = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/combat/maces = 2,
			/datum/skill/combat/axes = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/climbing = 4,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/craft/masonry = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/medicine = 2,
			/datum/skill/craft/sewing = 2,
			/datum/skill/craft/armorsmithing = 3,
			/datum/skill/craft/blacksmithing = 5,
			/datum/skill/craft/weaponsmithing = 3,
			/datum/skill/labor/mining = 4,
			/datum/skill/craft/smelting = 4,
			/datum/skill/craft/engineering = 2,
		),

		"traits" = list(
			TRAIT_SMITHING_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
		),

		"items" = list(
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
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

// Source class: /datum/advclass/wretch/necromancer
// Missing TAT traits: TRAIT_ZOMBIE_IMMUNE
// Missing TAT items: /obj/item/book/spellbook, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/necro_relics/necro_crystal
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=9, traits=11, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_2.
// TAT finalization: remaining class-parity notes: stat total +8 exceeds base +4; arcane access/skill 4 needs mage module progression.
/datum/tat_preset/sample/wretch_necromancer
	id = "wretch_necromancer"
	name = "Necromancer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 14,
			STATKEY_PER = 12,
			STATKEY_WIL = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/polearms = 3,
			/datum/skill/combat/staves = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/reading = 5,
			/datum/skill/misc/medicine = 3,
			/datum/skill/craft/alchemy = 4,
			/datum/skill/magic/arcane = 4,
		),

		"traits" = list(
			TRAIT_NOSTINK = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_MAGE_MAJOR_SLOT = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_2 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/chalk = 1,
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
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
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

// Source class: /datum/advclass/wretch/outlaw
// Missing TAT traits: TRAIT_SEEPRICES_SHITTY
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/rogueweapon/huntingknife/idagger/steel/special
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Rapier | Parrying Dagger | Fleet-Footed | Marksmanship | Athleticism | Night-Burglar | Master-Tracker | Dualist
// Encoded TAT points snapshot: stats=9, traits=7, items_static=5
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_outlaw
	id = "wretch_outlaw"
	name = "Outlaw"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 13,
			STATKEY_WIL = 12,
			STATKEY_PER = 11,
		),

		"skills" = list(
			/datum/skill/misc/tracking = 5,
			/datum/skill/combat/crossbows = 4,
			/datum/skill/combat/knives = 4,
			/datum/skill/combat/swords = 3,
			/datum/skill/combat/whipsflails = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 6,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 5,
			/datum/skill/misc/stealing = 5,
			/datum/skill/misc/lockpicking = 5,
			/datum/skill/craft/traps = 5,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/lockpickring/mundane = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/lockpickring/mundane = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/pariah
// Missing TAT traits: TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_WOODWALKER, TRAIT_EXPERT_HUNTER
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/book/spellbook
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: blade | phalangite | macebearer | blade | Elvish Longsword | Elvish Saber | Elvish Curveblade | Steel Dagger | phalangite | macebearer | Steel Mace | Steel Warhammer | Grand Mace | Battle Axe | Steel Greataxe | Woad Elven Barbute | Elven Barbute | Winged Elven Barbute
// Encoded TAT points snapshot: stats=8, traits=3, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1.
// TAT finalization: remaining class-parity notes: stat total +6 exceeds base +4; arcane access/skill 2 needs mage module progression.
/datum/tat_preset/sample/wretch_pariah
	id = "wretch_pariah"
	name = "Black Oaken Pariah"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 11,
			STATKEY_PER = 11,
			STATKEY_SPD = 12,
			// 7 Weight instead of 9 full weight STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/misc/athletics = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/combat/shields = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/swimming = 3,
			/datum/skill/misc/climbing = 4,
			//Why the fuck did the treeclimber role have worse skills than THE KNIGHTS? /datum/skill/misc/reading = 3,
			/datum/skill/misc/tracking = 2,
			/datum/skill/craft/carpentry = 2,
			/datum/skill/craft/sewing = 2,
			/datum/skill/misc/medicine = 1,
			/datum/skill/craft/tanning = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/labor/farming = 2,
			/datum/skill/magic/arcane = 2,
			/datum/skill/misc/hunting = 1,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_ARCYNE = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/chalk = 1,
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
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
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

// Source class: /datum/advclass/wretch/plaguebearer
// Missing TAT traits: none
// Missing TAT items: /obj/item/reagent_containers/glass/bottle/rogue/poison, /obj/item/reagent_containers/glass/bottle/rogue/stampoison, /obj/item/recipe_book/alchemy, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/reagent_containers/glass/bottle/rogue/strongpoison, /obj/item/natural/worms/leech/cheele
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: A Poison Dagger and Arrows | A Rapier and Agility
// Encoded TAT points snapshot: stats=9, traits=9, items_static=5
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +9 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_plaguebearer
	id = "wretch_plaguebearer"
	name = "Malpractitioner"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 14,
			STATKEY_PER = 13,
			STATKEY_CON = 12,
		),

		"skills" = list(
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/climbing = 4,
			/datum/skill/craft/crafting = 3,
			/datum/skill/craft/carpentry = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/misc/reading = 3,
			/datum/skill/misc/medicine = 5,
			/datum/skill/craft/sewing = 3,
			/datum/skill/craft/alchemy = 5,
			/datum/skill/labor/farming = 3,
		),

		"traits" = list(
			TRAIT_CICERONE = TRUE,
			TRAIT_NOSTINK = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/poacher
// Missing TAT traits: TRAIT_AZURENATIVE, TRAIT_WOODSMAN, TRAIT_OUTDOORSMAN, TRAIT_EXPERT_HUNTER
// Missing TAT items: /obj/item/bait, /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Dagger | Axe
// Encoded TAT points snapshot: stats=10, traits=5, items_static=7
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT, TAT_TRAIT_WARRIOR_MASTER.
// TAT finalization: remaining class-parity notes: stat total +8 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap; combat skill above Expert needs Master Warrior cap.
/datum/tat_preset/sample/wretch_poacher
	id = "wretch_poacher"
	name = "Poacher"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 13,
			STATKEY_SPD = 12,
			STATKEY_WIL = 12,
			STATKEY_CON = 11,
		),

		"skills" = list(
			/datum/skill/misc/tracking = 4,
			/datum/skill/combat/bows = 5,
			/datum/skill/combat/knives = 4,
			/datum/skill/combat/axes = 2,
			/datum/skill/combat/maces = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/combat/wrestling = 2,
			/datum/skill/combat/unarmed = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/misc/stealing = 2,
			/datum/skill/craft/traps = 4,
			/datum/skill/craft/crafting = 1,
			/datum/skill/craft/tanning = 1,
			/datum/skill/craft/cooking = 1,
			/datum/skill/labor/butchering = 1,
			/datum/skill/misc/hunting = 2,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
			TAT_TRAIT_WARRIOR_MASTER = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/pyromaniac
// Missing TAT traits: none
// Missing TAT items: /obj/item/bomb, /obj/item/flashlight/flare/torch/lantern/prelit, /obj/item/flint
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Archery | Crossbows | BOMBS
// Encoded TAT points snapshot: stats=9, traits=8, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: stat total +9 exceeds base +4; combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_pyromaniac
	id = "wretch_pyromaniac"
	name = "Pyromaniac"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 13,
			STATKEY_CON = 13,
			STATKEY_INT = 13,
		),

		"skills" = list(
			/datum/skill/combat/bows = 2,
			/datum/skill/combat/crossbows = 2,
			/datum/skill/combat/knives = 2,
			/datum/skill/misc/swimming = 2,
			/datum/skill/misc/athletics = 4,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/traps = 4,
			/datum/skill/craft/alchemy = 4,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/engineering = 1,
			/datum/skill/labor/farming = 1,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_EXPLOSIVE_SUPPLY = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/roguemage
// Missing TAT traits: none
// Missing TAT items: /obj/item/book/spellbook, /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: none
// Encoded TAT points snapshot: stats=9, traits=4, items_static=8
// TAT finalization: added/required gating traits: TAT_TRAIT_BONUS_STAT_POOL, TAT_TRAIT_MAGE_INITIATE, TAT_TRAIT_MAGE_MINOR_SLOT_1, TAT_TRAIT_MAGE_MAJOR_SLOT, TAT_TRAIT_MAGE_MINOR_SLOT_2.
// TAT finalization: remaining class-parity notes: stat total +8 exceeds base +4; arcane access/skill 4 needs mage module progression.
/datum/tat_preset/sample/wretch_roguemage
	id = "wretch_roguemage"
	name = "Rogue Mage"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 14,
			STATKEY_PER = 12,
			STATKEY_WIL = 11,
			STATKEY_SPD = 11,
		),

		"skills" = list(
			/datum/skill/combat/staves = 3,
			/datum/skill/combat/polearms = 3,
			/datum/skill/misc/climbing = 3,
			/datum/skill/misc/athletics = 3,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/reading = 5,
			/datum/skill/craft/alchemy = 4,
			/datum/skill/magic/arcane = 4,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TAT_TRAIT_BONUS_STAT_POOL = TRUE,
			TAT_TRAIT_MAGE_INITIATE = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_1 = TRUE,
			TAT_TRAIT_MAGE_MAJOR_SLOT = TRUE,
			TAT_TRAIT_MAGE_MINOR_SLOT_2 = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/chalk = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/chalk = list(
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
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/slasher
// Missing TAT traits: TRAIT_PSYCHOSIS, TRAIT_ORGAN_EATER
// Missing TAT items: /obj/item/rogueweapon/huntingknife/combat
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: Executioner's Sword | Cudgel | Fast (Dodge Expert, Sneaking, +1 SPD) | Strong (No Pain Stun, Blood Resistance, +1 STR)
// Encoded TAT points snapshot: stats=6, traits=3, items_static=3
// TAT finalization: added/required gating traits: TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_slasher
	id = "wretch_slasher"
	name = "Disturbed"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 12,
			STATKEY_SPD = 11,
			STATKEY_WIL = 11,
			STATKEY_INT = 9,
		),

		"skills" = list(
			/datum/skill/combat/knives = 4,
			/datum/skill/misc/swimming = 4,
			/datum/skill/combat/wrestling = 3,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/athletics = 5,
			/datum/skill/misc/tracking = 4,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/reading = 1,
			/datum/skill/misc/sneaking = 3,
			/datum/skill/craft/crafting = 2,
			/datum/skill/misc/medicine = 3,
			/datum/skill/craft/sewing = 2,
			/datum/skill/craft/cooking = 3,
		),

		"traits" = list(
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TRAIT_NASTY_EATER = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/rope = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rope = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// Source class: /datum/advclass/wretch/vigilante
// Missing TAT traits: TRAIT_PERFECT_TRACKER
// Missing TAT items: /obj/item/flashlight/flare/torch/lantern/prelit
// Missing/blocked TAT skills: none
// Dynamic choices in original class not encoded into this single preset: The Watchman | The Gadgeteer | I AM JUSTICE INCARNATE!!!
// Encoded TAT points snapshot: stats=0, traits=1, items_static=6
// TAT finalization: added/required gating traits: TAT_TRAIT_WARRIOR_EXPERT.
// TAT finalization: remaining class-parity notes: combat skill at Expert tier needs Expert Warrior cap.
/datum/tat_preset/sample/wretch_vigilante
	id = "wretch_vigilante"
	name = "Masked Lunatic"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
			/datum/skill/misc/swimming = 4,
			/datum/skill/misc/athletics = 4,
			/datum/skill/combat/wrestling = 4,
			/datum/skill/combat/unarmed = 3,
			/datum/skill/misc/climbing = 4,
			/datum/skill/misc/reading = 2,
			/datum/skill/craft/crafting = 2,
			/datum/skill/craft/sewing = 2,
			/datum/skill/misc/medicine = 2,
			/datum/skill/misc/tracking = 4,
		),

		"traits" = list(
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rope/chain = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)
