/// Auto-generated TAT preset pack for archetype: wretch
/// Source: types.zip + tat_system.zip
/// NOTE: Dynamic class choices, spells, money, and non-TAT-only mechanics are preserved as comments where direct 1:1 encoding was not possible.

// ---------------------------------------------------------------------------
// Unbound Ancient Death Knight  (wretch/ancient_deathknight.dm)
// Advclass path: /datum/advclass/wretch/ancient_deathknight
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/cloak/tabard/lich; /obj/item/clothing/cloak/tabard/stabard/surcoat/lich; /obj/item/clothing/gloves/roguetown/plate/paalloy; /obj/item/clothing/neck/roguetown/chaincoif/paalloy; /obj/item/clothing/shoes/roguetown/boots/paalloy; /obj/item/clothing/suit/roguetown/armor/plate/paalloy; /obj/item/clothing/under/roguetown/platelegs/paalloy; /obj/item/clothing/wrists/roguetown/bracers/paalloy; /obj/item/rogueweapon/huntingknife/idagger/steel/corroded; /obj/item/rogueweapon/mace/warhammer/steel/paalloy; /obj/item/rogueweapon/shield/tower/metal/palloy; /obj/item/rogueweapon/sword/long/death
// Dynamic note: Choice list `helmets`: Gilbranze Knight Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
// Dynamic note: Choice list `tabards`: Black Tabard; Black Jupon
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonemend)
/datum/tat_preset/wretch/wretch_ancient_deathknight
	id = "wretch_ancient_deathknight"
	name = "Unbound Ancient Death Knight"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_CON = 0,
			STATKEY_WIL = 1,
			STATKEY_INT = -2,
			,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_HEAVYARMOR = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/scabbard/sword = 2,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/clothing/under/roguetown/platelegs/paalloy = 1,
			/obj/item/clothing/shoes/roguetown/boots/paalloy = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/paalloy = 1,
			/obj/item/clothing/gloves/roguetown/plate/paalloy = 1,
			/obj/item/clothing/neck/roguetown/chaincoif/paalloy = 1,
			/obj/item/clothing/wrists/roguetown/bracers/paalloy = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogueweapon/sword/long/death = 1,
			/obj/item/rogueweapon/shield/tower/metal/palloy = 2,
			/obj/item/rogueweapon/mace/warhammer/steel/paalloy = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/halberd = 1,
			/obj/item/clothing/cloak/tabard/stabard/surcoat/lich = 1,
			/obj/item/clothing/cloak/tabard/lich = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/book/spellbook = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/platelegs/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/death = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/tower/metal/palloy = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/steel/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/surcoat/lich = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/lich = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Unbound Ancient Azurcaephan  (wretch/ancient_spellblade.dm)
// Advclass path: /datum/advclass/wretch/ancient_spellblade
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/cloak/tabard/lich; /obj/item/clothing/cloak/tabard/stabard/surcoat/lich; /obj/item/clothing/gloves/roguetown/chain/paalloy; /obj/item/clothing/mask/rogue/ragmask/black; /obj/item/clothing/neck/roguetown/chaincoif/paalloy; /obj/item/clothing/shoes/roguetown/sandals/paalloy; /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy; /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy; /obj/item/clothing/wrists/roguetown/bracers/paalloy; /obj/item/rogueweapon/halberd/bardiche/paalloy; /obj/item/rogueweapon/huntingknife/idagger/steel/corroded; /obj/item/rogueweapon/mace/goden/steel/paalloy; /obj/item/rogueweapon/mace/steel/palloy; /obj/item/rogueweapon/mace/warhammer/steel/paalloy; /obj/item/rogueweapon/spear/paalloy; /obj/item/rogueweapon/spear/spellblade; /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe; /obj/item/rogueweapon/sword/sabre/palloy
// Dynamic note: Choice list `helmets`: Gilbranze Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/paalloy; None
// Dynamic note: Choice list `weapons`: Ancient Khopesh; Sabre; Corroded Dagger
// Dynamic note: Choice list `weapons`: Ancient Spear; Ancient Bardiche; Dory
// Dynamic note: Choice list `weapons`: Ancient Mace; Ancient Warhammer; Ancient Grand Mace; Ancient Alloy Axe; Steel Greataxe
// Dynamic note: Choice list `tabards`: Black Tabard; Black Jupon
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
/datum/tat_preset/wretch/wretch_ancient_spellblade
	id = "wretch_ancient_spellblade"
	name = "Unbound Ancient Azurcaephan"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 0,
			STATKEY_PER = 1,
			STATKEY_STR = -1,
			) 
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4,
		),

		"skills" = list(
			/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ARCYNE = TRUE,
		),

		"items" = list(
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/studded = 1,
			/obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy = 1,
			/obj/item/clothing/neck/roguetown/chaincoif/paalloy = 1,
			/obj/item/clothing/shoes/roguetown/sandals/paalloy = 1,
			/obj/item/clothing/gloves/roguetown/chain/paalloy = 1,
			/obj/item/clothing/wrists/roguetown/bracers/paalloy = 1,
			/obj/item/clothing/mask/rogue/ragmask/black = 1,
			/obj/item/rogueweapon/shield/heater = 2,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogueweapon/sword/sabre/palloy = 1,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,
			/obj/item/rogueweapon/spear/paalloy = 1,
			/obj/item/rogueweapon/halberd/bardiche/paalloy = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/spear/spellblade = 1,
			/obj/item/rogueweapon/mace/steel/palloy = 1,
			/obj/item/rogueweapon/mace/warhammer/steel/paalloy = 1,
			/obj/item/rogueweapon/mace/goden/steel/paalloy = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe = 1,
			/obj/item/rogueweapon/greataxe/steel = 1,
			/obj/item/clothing/cloak/tabard/stabard/surcoat/lich = 1,
			/obj/item/clothing/cloak/tabard/lich = 1,
			/obj/item/book/spellbook = 1,
		),

		"item_loadout" = list(
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/studded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/sandals/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/ragmask/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/heater = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/palloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd/bardiche/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/spellblade = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel/palloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/steel/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/steel/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/surcoat/lich = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/lich = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Berserker  (wretch/berserker.dm)
// Advclass path: /datum/advclass/wretch/berserker
// Extra context: "This subclass gains access to the RAGE ability."
// Missing traits in TAT: TRAIT_STRONGBITE; TRAIT_RAGE
// Missing items in TAT catalog: /obj/item/clothing/cloak/raincloak/furcloak/brown; /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker; /obj/item/clothing/mask/rogue/wildguard; /obj/item/clothing/suit/roguetown/armor/manual/pushups/leather/good; /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/berserker; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/greatsword/paalloy; /obj/item/rogueweapon/huntingknife/combat; /obj/item/rogueweapon/stoneaxe/woodcut
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
			if("Martial Expert") // designed to compete with unarmed by giving you alternatives to approaching fights- only expert 
				var/list/martial_options = list("Discipline - Bodybuilder", "Battle Axe", "Grand Mace", "Longsword
// Dynamic note: Choice list `helmets`: Berserker's Volfskulle Bascinet; Steel Kettle + Wildguard
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rage)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
/datum/tat_preset/wretch/wretch_berserker
	id = "wretch_berserker"
	name = "Berserker"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 3,
			STATKEY_CON = 2,
			STATKEY_WIL = 1,
			STATKEY_SPD = 1,
			STATKEY_INT = -2,
		),

		"skills" = list(
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_STRONGBITE = TRUE,
			TRAIT_CRITICAL_RESISTANCE = TRUE,
			TRAIT_NOPAINSTUN = TRUE,
			TRAIT_RAGE = TRUE,
		),

		"items" = list(
			/obj/item/clothing/cloak/raincloak/furcloak/brown = 1,
			/obj/item/clothing/gloves/roguetown/plate = 1,
			/obj/item/clothing/wrists/roguetown/bracers = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/clothing/neck/roguetown/coif/heavypadding = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/clothing/gloves/roguetown/bandages/weighted = 1,
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/berserker = 1,
			/obj/item/rogueweapon/katar = 1,
			/obj/item/clothing/gloves/roguetown/knuckles = 1,
			/obj/item/rogueweapon/katar/punchdagger = 1,
			/obj/item/rogueweapon/greatsword/paalloy = 1,
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather/good = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/mace/goden/steel = 1,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/rogueweapon/sword/falx = 1,
			/obj/item/rogueweapon/sword/iron = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/rogueweapon/mace = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker = 1,
			/obj/item/clothing/head/roguetown/helmet/kettle = 1,
			/obj/item/clothing/mask/rogue/wildguard = 1,
			/obj/item/rogueweapon/huntingknife/combat = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/cloak/raincloak/furcloak/brown = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/heavypadding = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages/weighted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/berserker = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/knuckles = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar/punchdagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greatsword/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather/good = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/falx = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/berserker = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/kettle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/wildguard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/combat = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Disgraced Knight  (wretch/deserter.dm)
// Advclass path: /datum/advclass/wretch/deserter
// Missing items in TAT catalog: /obj/item/clothing/cloak/tabard/stabard/surcoat; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/estoc; /obj/item/rogueweapon/huntingknife/idagger/steel/special; /obj/item/rogueweapon/spear/lance; /obj/item/rogueweapon/sword/long/ap; /obj/item/rogueweapon/sword/sabre/shamshir; /obj/item/rogueweapon/sword/sabre/steppesman; /obj/item/storage/belt/rogue/leather/steel
// Dynamic note: Choice list `weapons`: Estoc; Stecher; Mace + Shield; Flail + Shield; Longsword + Shield; Lucerne; Battle Axe; Lance + Kite Shield; Samshir; Ssangsudo; Shashka + Shield; Steel Poleaxe
// Dynamic note: Choice list `helmets`: Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard; Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff; Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket; Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader; Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume; Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet; Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle; Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen; Kabuto"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto; //No mask; fuck you
			"Shishak"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak; Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor; Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great; Volf-Face Helm"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate; None
// Dynamic note: Choice list `armors`: Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine; Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy; Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass; Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted; Lamellar Scalemail"		= /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe; Haraate Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
// Dynamic note: Choice list `weapons`: Warhammer & Shield; Sabre & Shield; Axe & Shield; Billhook; Greataxe; Halberd; Crossbow
// Dynamic note: Choice list `helmets`: Pigface Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Hounskull Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Klappvisier Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader; Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume
// Dynamic note: Choice list `armors`: Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine; Half-Plate"		= /obj/item/clothing/suit/roguetown/armor/plate/iron; Scalemail"			= /obj/item/clothing/suit/roguetown/armor/plate/scale
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
/datum/tat_preset/wretch/wretch_deserter
	id = "wretch_deserter"
	name = "Disgraced Knight"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 3,
			STATKEY_CON = 2,
			STATKEY_STR = 2,
			STATKEY_PER = 2,
			STATKEY_LCK = 1,
		),

		"skills" = list(
			/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_HEAVYARMOR = TRUE,
			TRAIT_NOBLE = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/estoc = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 6,
			/obj/item/rogueweapon/scabbard/sword = 5,
			/obj/item/rogueweapon/sword/long/ap = 1,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/shield/tower/metal = 4,
			/obj/item/rogueweapon/mace/steel = 1,
			/obj/item/rogueweapon/flail/sflail = 1,
			/obj/item/rogueweapon/eaglebeak/lucerne = 1,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/spear/lance = 1,
			/obj/item/rogueweapon/sword/sabre/shamshir = 1,
			/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun/noparry = 1,
			/obj/item/rogueweapon/sword/sabre/steppesman = 1,
			/obj/item/rogueweapon/shield/iron/steppesman = 1,
			/obj/item/rogueweapon/greataxe/steel/knight = 1,
			/obj/item/clothing/gloves/roguetown/plate = 1,
			/obj/item/clothing/under/roguetown/chainlegs = 2,
			/obj/item/clothing/neck/roguetown/bevor = 2,
			/obj/item/clothing/suit/roguetown/armor/chainmail = 1,
			/obj/item/clothing/wrists/roguetown/bracers = 2,
			/obj/item/clothing/shoes/roguetown/boots/armor = 1,
			/obj/item/storage/belt/rogue/leather/steel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/rogueweapon/mace/warhammer = 1,
			/obj/item/rogueweapon/shield/iron = 2,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/shield/wood = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = 1,
			/obj/item/rogueweapon/spear/billhook = 1,
			/obj/item/rogueweapon/halberd = 1,
			/obj/item/rogueweapon/greataxe = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
			/obj/item/quiver/bolt/standard = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
			/obj/item/clothing/cloak/tabard/stabard/surcoat = 1,
			/obj/item/clothing/gloves/roguetown/chain = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/estoc = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 6,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 5,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/ap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/tower/metal = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/sflail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/eaglebeak/lucerne = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/lance = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/shamshir = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/kazengun/noparry = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/steppesman = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/iron/steppesman = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/steel/knight = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/bevor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/billhook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe = list(
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
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/surcoat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Heretic  (wretch/heretic.dm)
// Advclass path: /datum/advclass/wretch/heretic
// Extra context: "This subclass gain the Wound Heal miracle and the Convert Heretic spell."
// Missing traits in TAT: TRAIT_RITUALIST
// Missing items in TAT catalog: /obj/item/clothing/cloak/raincloak/mortus; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/ritechalk; /obj/item/rogueweapon/flail/sflail/psyflail; /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger; /obj/item/rogueweapon/spear/psyspear; /obj/item/rogueweapon/stoneaxe/battle/psyaxe; /obj/item/rogueweapon/sword/long/psysword; /obj/item/rogueweapon/sword/rapier/psy
// Dynamic note: Choice list `weapons`: Longsword; Mace; Flail; Axe; Billhook
// Dynamic note: Choice list `helmets`: Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard; Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff; Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket; Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet; Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader; Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume; Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle; Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor; Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great; Volfskulle Bascinet" = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate; None"
		)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, SLOT_RING, TRUE)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			helmets += list("Decorated Bucket Helmet" = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gold/cleric,) // This is so stupid. - Just a little; but it does look cool!
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios, SLOT_RING, TRUE)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_STR, 1)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha, SLOT_RING, TRUE)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_PER, 3)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar, SLOT_RING, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_WIL, 1)
		if(/datum/patron/divine/astrata)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/astrata, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/astratan, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp)
			helmets += list("Old Astratan Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm)
		if(/datum/patron/divine/abyssor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/abyssor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/abyssorite, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.grant_language(/datum/language/abyssal)
			ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/xylix, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/xylixian, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/combat_jester.ogg'
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)
		if(/datum/patron/divine/dendor)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/dendor, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/dendor, SLOT_CLOAK, TRUE)
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
			H.adjust_skillrank(/datum/skill/labor/farming, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		if(/datum/patron/divine/necra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/necra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/necran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
			helmets += list("Old Necran Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm)
		if(/datum/patron/divine/pestra)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/pestra, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/pestran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
		if(/datum/patron/divine/eora)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/eora, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/eoran, SLOT_CLOAK, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
			helmets += list("Old Eoran Sallet" = /obj/item/clothing/head/roguetown/helmet/sallet/eoran)
		if(/datum/patron/divine/noc)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/noc, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/tabard/crusader/noc, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/nocgrasp)
		if(/datum/patron/divine/ravox)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/ravox, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/ravox, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/ravoxgrasp)
		if(/datum/patron/divine/malum)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/malum, SLOT_RING, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/cloak/templar/malumite, SLOT_CLOAK, TRUE)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		if(/datum/patron/divine/undivided)
			H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/psicross/undivided, SLOT_RING, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/divine_strike/undivided)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
			if(H.mind)
				var/cloaks = list("Cloak", "Tabard
// Dynamic note: Choice list `weapons`: Rapier; Sabre; Bow; Crossbow; Slurbow
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
// Dynamic note: H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_heal)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
// Dynamic note: ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
// Dynamic note: H.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/astratagrasp)
// Dynamic note: ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 2, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 2, TRUE)
/datum/tat_preset/wretch/wretch_heretic
	id = "wretch_heretic"
	name = "Heretic"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
			STATKEY_LCK = 1,
		),

		"skills" = list(
			/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_RITUALIST = TRUE,
			TRAIT_HEAVYARMOR = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/scabbard/sword = 3,
			/obj/item/rogueweapon/sword/long/psysword = 1,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/mace/goden/psymace = 1,
			/obj/item/rogueweapon/mace/steel = 1,
			/obj/item/rogueweapon/flail/sflail/psyflail = 1,
			/obj/item/rogueweapon/flail/sflail = 1,
			/obj/item/rogueweapon/stoneaxe/battle/psyaxe = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/spear/psyspear = 1,
			/obj/item/rogueweapon/spear/billhook = 1,
			/obj/item/clothing/mask/rogue/facemask/steel = 1,
			/obj/item/clothing/neck/roguetown/gorget = 2,
			/obj/item/clothing/under/roguetown/chainlegs = 1,
			/obj/item/storage/backpack/rogue/satchel = 2,
			/obj/item/rogueweapon/shield/tower/metal = 1,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/clothing/cloak/raincloak/mortus = 1,
			/obj/item/rogueweapon/sword/rapier/psy = 1,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/quiver/arrows = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 1,
			/obj/item/rogueweapon/scabbard/sheath = 4,
			/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger = 3,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 3,
			/obj/item/quiver/bolt/standard = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
			/obj/item/quiver/bolt/light = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/ritechalk = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/psysword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/psymace = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/sflail/psyflail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/sflail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle/psyaxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/psyspear = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/billhook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/tower/metal = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/mortus = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier/psy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/arrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 3,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/standard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/ritechalk = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Heretic Azurcaephan  (wretch/heretic_spellblade.dm)
// Advclass path: /datum/advclass/wretch/heretic_spellblade
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/cloak/tabard/black; /obj/item/clothing/head/roguetown/roguehood; /obj/item/rogueweapon/spear/spellblade; /obj/item/rogueweapon/sword/long/zizo
// Dynamic note: Choice list `armor_style`: Discretion (Spellblade Disguise); Confrontation (Medium Armor)
// Dynamic note: Choice list `helmets`: Pigface Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Guard Helmet"			= /obj/item/clothing/head/roguetown/helmet/heavy/guard; Bucket Helmet"			= /obj/item/clothing/head/roguetown/helmet/heavy/bucket; Knight Helmet"			= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Armet"					= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet; Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Klappvisier Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Hounskull Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle; Volf-Face Helm"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate; None"
			)
			if(istype(H.patron, /datum/patron/divine/noc))
				helmets += list("Greatplumed Owl Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/owl
// Dynamic note: Choice list `polearm_weapons`: Halberd; Bardiche; Boar Spear; Dory; Naginata
// Dynamic note: Choice list `mace_weapons`: Steel Mace; Steel Warhammer; Grand Mace; Battle Axe; Steel Greataxe
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
/datum/tat_preset/wretch/wretch_heretic_spellblade
	id = "wretch_heretic_spellblade"
	name = "Heretic Azurcaephan"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 1,
			STATKEY_INT = 1,
			STATKEY_PER = 1,
			STATKEY_CON = 1,
			STATKEY_WIL = 2,
			,
		),

		"skills" = list(
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
			,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ARCYNE = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/clothing/gloves/roguetown/chain = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/wrists/roguetown/bracers/iron = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/clothing/under/roguetown/chainlegs = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/clothing/cloak/tabard/black = 1,
			/obj/item/rogueweapon/shield/heater = 2,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/rogueweapon/sword/long/zizo = 1,
			/obj/item/rogueweapon/sword/long/kriegmesser = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 5,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/sword = 1,
			/obj/item/rogueweapon/greatsword = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rogueweapon/halberd = 1,
			/obj/item/rogueweapon/halberd/bardiche = 1,
			/obj/item/rogueweapon/spear/boar = 1,
			/obj/item/rogueweapon/spear/spellblade = 1,
			/obj/item/rogueweapon/spear/naginata = 1,
			/obj/item/clothing/suit/roguetown/armor/basiceast = 1,
			/obj/item/rogueweapon/mace/steel = 1,
			/obj/item/rogueweapon/mace/warhammer/steel = 1,
			/obj/item/rogueweapon/mace/goden/steel = 1,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/greataxe/steel = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/chalk = 1,
			/obj/item/book/spellbook = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
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
			/obj/item/clothing/wrists/roguetown/bracers/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/heater = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/zizo = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/kriegmesser = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 5,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greatsword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd/bardiche = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/boar = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/spellblade = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/naginata = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/basiceast = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch = list(
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
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Heretic Spellfist  (wretch/heretic_spellfist.dm)
// Advclass path: /datum/advclass/wretch/heretic_spellfist
// Missing traits in TAT: TRAIT_BLOOD_RESISTANCE
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/head/roguetown/headband/monk
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/fist_of_psydon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/grasp_of_psydon())
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/blink)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/storm_of_psydon())
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
/datum/tat_preset/wretch/wretch_heretic_spellfist
	id = "wretch_heretic_spellfist"
	name = "Heretic Spellfist"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 1,
			STATKEY_SPD = 1,
			STATKEY_WIL = 2,
			STATKEY_PER = 1,
			STATKEY_CON = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_CIVILIZEDBARBARIAN = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_BLOOD_RESISTANCE = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/headband/monk = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/clothing/under/roguetown/brigandinelegs = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/clothing/suit/roguetown/armor/brigandine/light = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/clothing/neck/roguetown/gorget = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/headband/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/brigandinelegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/brigandine/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
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
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
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
			/obj/item/book/spellbook = list(
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

// ---------------------------------------------------------------------------
// Licker  (wretch/licker.dm)
// Advclass path: /datum/advclass/wretch/licker
// Missing traits in TAT: TRAIT_SILVER_WEAK
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/magic/blood, 4, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(M, TRAIT_DRUQK, "based")
/datum/tat_preset/wretch/wretch_licker
	id = "wretch_licker"
	name = "Licker"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_SILVER_WEAK = TRUE,
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Mistwalker  (wretch/mistwalker.dm)
// Advclass path: /datum/advclass/wretch/mistwalker
// Extra context: "This subclass gains addition stat points from weapon selection, and is race-limited from: Constructs."
// Missing traits in TAT: TRAIT_BLOOD_RESISTANCE; TRAIT_JOURNEYS_END); literally made to bleed
	maximum_possible_slots = 1 

	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	subclass_stats = list(
		STATKEY_STR = 2, 
		STATKEY_CON = 1,
		STATKEY_WIL = 1
// Missing items in TAT catalog: /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black; /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black; /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black; /obj/item/clothing/wrists/roguetown/bracers/black; /obj/item/flashlight/flare/torch/lantern/prelit
// Dynamic note: Choice list `weapons`: Ssangsudo +2 CON; Kanabo +1 STR; Naginata +2 PER; Hwando +2 WIL; Kodachi +1 SPD
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
/datum/tat_preset/wretch/wretch_mistwalker
	id = "wretch_mistwalker"
	name = "Mistwalker"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			,
			same as berserker
		STATKEY_CON = 1,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			,
		),

		"traits" = list(
			TRAIT_NOPAINSTUN = TRUE,
			TRAIT_BLOOD_RESISTANCE = TRUE,
			TRAIT_JOURNEYS_END) = TRUE,
			literally made to bleed
	maximum_possible_slots = 1 

	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	subclass_stats = list(
		STATKEY_STR = 2, 
		STATKEY_CON = 1,
		STATKEY_WIL = 1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1 = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black = 1,
			/obj/item/clothing/head/roguetown/mentorhat = 1,
			/obj/item/clothing/gloves/roguetown/eastgloves1 = 1,
			/obj/item/clothing/neck/roguetown/gorget/steel/kazengun = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black = 1,
			/obj/item/clothing/mask/rogue/facemask/steel/kazengun = 1,
			/obj/item/clothing/wrists/roguetown/bracers/black = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun/noparry = 1,
			/obj/item/rogueweapon/mace/goden/kanabo = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 2,
			/obj/item/rogueweapon/spear/naginata = 1,
			/obj/item/rogueweapon/sword/sabre/mulyeog = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun = 1,
			/obj/item/rogueweapon/sword/short/kazengun = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1 = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/mentorhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/eastgloves1 = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget/steel/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
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
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/kazengun/noparry = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/kanabo = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/naginata = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/mulyeog = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Munitioneer  (wretch/munitioneer.dm)
// Advclass path: /datum/advclass/wretch/munitioneer
// Missing traits in TAT: TRAIT_TRAINED_SMITH; TRAIT_RITUALIST
// Missing items in TAT catalog: /obj/item/clothing/cloak/templar/malumite; /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith; /obj/item/clothing/head/roguetown/roguehood/warden/munitioneer; /obj/item/clothing/mask/rogue/facemask/steel/paalloy; /obj/item/clothing/suit/roguetown/shirt/tunic/white; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/riddleofsteel; /obj/item/ritechalk; /obj/item/rogueweapon/huntingknife/combat; /obj/item/storage/backpack/rogue/satchel/beltpack
// Dynamic note: Choice list `weapons`: Path of the Hammer - Steel Warhammer; Path of the Crossbow - Crossbow and Bolts; Path of the Pick - Pulaski Axe
// Dynamic note: Choice list `crimes`: I'm nobody; They fear me
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
/datum/tat_preset/wretch/wretch_munitioneer
	id = "wretch_munitioneer"
	name = "Munitioneer"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_CON = 2,
			STATKEY_INT = 2,
			STATKEY_PER = 1,
			like guildsmaster.,
		),

		"skills" = list(
			/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER,
			/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_TRAINED_SMITH = TRUE,
			TRAIT_SMITHING_EXPERT = TRUE,
			TRAIT_RITUALIST = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/warden/munitioneer = 1,
			/obj/item/clothing/mask/rogue/facemask/steel/paalloy = 1,
			/obj/item/clothing/neck/roguetown/gorget = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/cloak/templar/malumite = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/studded = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/storage/backpack/rogue/satchel/beltpack = 1,
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/neck/roguetown/psicross/malum = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/ritechalk = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/rogueweapon/huntingknife/combat = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/riddleofsteel = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/warden/munitioneer = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel/paalloy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/templar/malumite = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/studded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = list(
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
			/obj/item/storage/backpack/rogue/satchel/beltpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/malum = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/ritechalk = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/combat = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/riddleofsteel = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Necromancer  (wretch/necromancer.dm)
// Advclass path: /datum/advclass/wretch/necromancer
// Missing traits in TAT: TRAIT_ZOMBIE_IMMUNE
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/head/roguetown/roguehood/black; /obj/item/clothing/suit/roguetown/shirt/robe/black; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/necro_relics/necro_crystal
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/eyebite)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_guard)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tame_undead)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/raise_deadite)
/datum/tat_preset/wretch/wretch_necromancer
	id = "wretch_necromancer"
	name = "Necromancer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 4,
			STATKEY_PER = 2,
			STATKEY_WIL = 1,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			,
			but can use the ZRONK chair right away
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
			/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
			,
		),

		"traits" = list(
			TRAIT_ZOMBIE_IMMUNE = TRUE,
			TRAIT_NOSTINK = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/black = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
			/obj/item/clothing/neck/roguetown/gorget = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/necro_relics/necro_crystal = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/necro_relics/necro_crystal = list(
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

// ---------------------------------------------------------------------------
// Outlaw  (wretch/outlaw.dm)
// Advclass path: /datum/advclass/wretch/outlaw
// Extra context: "Fleet-Footed grants Light Steps and +1 to Sneaking, Marksmanship grants +1 PERCEPTION and +1 to Crossbows, Athleticism grants +1 CONSTITUTION and +1 to Athletics, Night-Burglar grants Night Vision and +1 to Lockpicking, Master-Tracker grants Perfect Tracker + Sleuth and +1 to Tracking, Dualist grants Dual-Wielder and Guarded (Decieving Meekness)."
// Missing traits in TAT: TRAIT_SEEPRICES_SHITTY) 
	extra_context = "Fleet-Footed grants Light Steps and +1 to Sneaking, Marksmanship grants +1 PERCEPTION and +1 to Crossbows, Athleticism grants +1 CONSTITUTION and +1 to Athletics, Night-Burglar grants Night Vision and +1 to Lockpicking, Master-Tracker grants Perfect Tracker + Sleuth and +1 to Tracking, Dualist grants Dual-Wielder and Guarded (Decieving Meekness)."
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1
// Missing items in TAT catalog: /obj/item/clothing/cloak/tabard/stabard/dungeon; /obj/item/clothing/mask/rogue/ragmask/black; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/huntingknife/idagger/steel/special
// Dynamic note: Choice list `weapons`: Rapier; Parrying Dagger; Whip
// Dynamic note: Choice list `specialization`: Fleet-Footed; Marksmanship; Athleticism; Night-Burglar; Master-Tracker; Dualist
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_LEGENDARY, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_LEGENDARY, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_LEGENDARY, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_LEGENDARY, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_SLEUTH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
/datum/tat_preset/wretch/wretch_outlaw
	id = "wretch_outlaw"
	name = "Outlaw"
	build_data = list(
		"stats" = list(
			STATKEY_SPD = 3,
			STATKEY_WIL = 2,
			STATKEY_PER = 1,
		),

		"skills" = list(
			/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
			/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
			/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
			/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
			/datum/skill/craft/traps = SKILL_LEVEL_MASTER,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
			TRAIT_SEEPRICES_SHITTY) 
	extra_context = "Fleet-Footed grants Light Steps and +1 to Sneaking, Marksmanship grants +1 PERCEPTION and +1 to Crossbows, Athleticism grants +1 CONSTITUTION and +1 to Athletics, Night-Burglar grants Night Vision and +1 to Lockpicking, Master-Tracker grants Perfect Tracker + Sleuth and +1 to Tracking, Dualist grants Dual-Wielder and Guarded (Decieving Meekness)."
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/helmet/kettle = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/clothing/cloak/tabard/stabard/dungeon = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
			/obj/item/storage/backpack/rogue/satchel/short = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/black/steel = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/neck/roguetown/coif/heavypadding = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/mask/rogue/ragmask/black = 1,
			/obj/item/quiver/bolt/standard = 1,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/scabbard/sheath = 2,
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
			/obj/item/rogueweapon/whip = 1,
			/obj/item/lockpickring/mundane = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/helmet/kettle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/dungeon = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel/short = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/black/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/heavypadding = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/ragmask/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/standard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 1,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/lockpickring/mundane = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Black Oaken Pariah  (wretch/pariah.dm)
// Advclass path: /datum/advclass/wretch/pariah
// Extra context: "This class is restricted to the Elf, Half-Elf, and Dark Elf species."
// Missing traits in TAT: TRAIT_AZURENATIVE; TRAIT_OUTDOORSMAN; TRAIT_BLACKOAK; TRAIT_WOODWALKER; TRAIT_EXPERT_HUNTER)
	
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2, 
		STATKEY_CON = 1,
		STATKEY_WIL = 1
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/cloak/forrestercloak; /obj/item/clothing/gloves/roguetown/elven_gloves; /obj/item/clothing/shoes/roguetown/boots/elven_boots; /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/trophyfur; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/greatsword/elvish; /obj/item/rogueweapon/halberd/glaive/elvish; /obj/item/rogueweapon/huntingknife/idagger/steel/special; /obj/item/rogueweapon/sword/long/elvish; /obj/item/rogueweapon/sword/sabre/elf
// Dynamic note: Choice list `weapons`: Elvish Longsword; Elvish Saber; Elvish Curveblade; Steel Dagger
// Dynamic note: Choice list `mace_weapons`: Steel Mace; Steel Warhammer; Grand Mace; Battle Axe; Steel Greataxe
// Dynamic note: Choice list `helmets`: Woad Elven Barbute; Elven Barbute; Winged Elven Barbute
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
/datum/tat_preset/wretch/wretch_pariah
	id = "wretch_pariah"
	name = "Black Oaken Pariah"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 1,
			STATKEY_PER = 1,
			STATKEY_SPD = 2,
			STATKEY_CON = 1,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_AZURENATIVE = TRUE,
			TRAIT_OUTDOORSMAN = TRUE,
			TRAIT_BLACKOAK = TRUE,
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_ARCYNE = TRUE,
			TRAIT_WOODWALKER = TRUE,
			TRAIT_EXPERT_HUNTER)
	
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2, 
		STATKEY_CON = 1,
		STATKEY_WIL = 1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/trophyfur = 1,
			/obj/item/clothing/shoes/roguetown/boots/elven_boots = 1,
			/obj/item/clothing/cloak/forrestercloak = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/clothing/gloves/roguetown/elven_gloves = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rogueweapon/sword/long/elvish = 1,
			/obj/item/rogueweapon/scabbard/sword = 2,
			/obj/item/rogueweapon/shield/wood = 4,
			/obj/item/rogueweapon/sword/sabre/elf = 1,
			/obj/item/rogueweapon/greatsword/elvish = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 2,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rogueweapon/halberd/glaive/elvish = 1,
			/obj/item/rogueweapon/mace/steel = 1,
			/obj/item/rogueweapon/mace/warhammer/steel = 1,
			/obj/item/rogueweapon/mace/goden/steel = 1,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/greataxe/steel = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/trophyfur = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/elven_boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/forrestercloak = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/elven_gloves = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/elvish = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/elf = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greatsword/elvish = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd/glaive/elvish = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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
			/obj/item/book/spellbook = list(
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

// ---------------------------------------------------------------------------
// Malpractitioner  (wretch/plaguebearer.dm)
// Advclass path: /datum/advclass/wretch/plaguebearer
// Extra context: "This subclass has a choice of starting with a poisonable dagger and a bow and poison arrows, or a rapier and the ability to dodge well."
// Missing items in TAT catalog: /obj/item/clothing/head/roguetown/physician; /obj/item/clothing/mask/rogue/physician; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/robe/physician; /obj/item/clothing/under/roguetown/trou/leather/mourning; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/quiver/poisonarrows; /obj/item/reagent_containers/glass/bottle/rogue/poison; /obj/item/reagent_containers/glass/bottle/rogue/stampoison; /obj/item/reagent_containers/glass/bottle/rogue/strongpoison; /obj/item/recipe_book/alchemy; /obj/item/storage/belt/rogue/surgery_bag/full/physician
// Dynamic note: Choice list `weapon_choices`: A Poison Dagger and Arrows; A Rapier and Agility
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
/datum/tat_preset/wretch/wretch_plaguebearer
	id = "wretch_plaguebearer"
	name = "Malpractitioner"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 4,
			STATKEY_PER = 3,
			STATKEY_CON = 2,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			,
			fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/medicine = SKILL_LEVEL_MASTER,
			/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/alchemy = SKILL_LEVEL_MASTER,
			/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
			,
		),

		"traits" = list(
			TRAIT_CICERONE = TRUE,
			TRAIT_NOSTINK = TRUE,
			TRAIT_MEDICINE_EXPERT = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/physician = 1,
			/obj/item/clothing/mask/rogue/physician = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/clothing/under/roguetown/trou/leather/mourning = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/physician = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/surgery_bag/full/physician = 1,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 1,
			/obj/item/quiver/poisonarrows = 2,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/stampoison = 1,
			/obj/item/recipe_book/alchemy = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/natural/worms/leech/cheele = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/physician = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/physician = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather/mourning = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/physician = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/surgery_bag/full/physician = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/poisonarrows = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/poison = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/stampoison = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/alchemy = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/natural/worms/leech/cheele = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Poacher  (wretch/poacher.dm)
// Advclass path: /datum/advclass/wretch/poacher
// Missing traits in TAT: TRAIT_AZURENATIVE; TRAIT_WOODSMAN; TRAIT_OUTDOORSMAN; TRAIT_EXPERT_HUNTER); but still stronger than MAA Skirm out of town.
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1
// Missing items in TAT catalog: /obj/item/bait; /obj/item/clothing/cloak/raincloak/furcloak/darkgreen; /obj/item/clothing/head/roguetown/roguehood/darkgreen; /obj/item/clothing/mask/rogue/wildguard; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/stoneaxe/woodcut
// Dynamic note: Choice list `weapons`: Dagger; Axe; Cudgel; My Bow Is Enough
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_LEGENDARY, TRUE)
/datum/tat_preset/wretch/wretch_poacher
	id = "wretch_poacher"
	name = "Poacher"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 3,
			STATKEY_SPD = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 1,
		),

		"skills" = list(
			/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/stealing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_AZURENATIVE = TRUE,
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_WOODSMAN = TRUE,
			TRAIT_OUTDOORSMAN = TRUE,
			TRAIT_SURVIVAL_EXPERT = TRUE,
			TRAIT_EXPERT_HUNTER) = TRUE,
			but still stronger than MAA Skirm out of town.
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/darkgreen = 1,
			/obj/item/clothing/mask/rogue/wildguard = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/clothing/cloak/raincloak/furcloak/darkgreen = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/neck/roguetown/gorget = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 1,
			/obj/item/quiver/arrows = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/clothing/head/roguetown/helmet/kettle = 1,
			/obj/item/bait = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/darkgreen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/wildguard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/furcloak/darkgreen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
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
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
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
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/kettle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/bait = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Pyromaniac  (wretch/pyromaniac.dm)
// Advclass path: /datum/advclass/wretch/pyromaniac
// Missing items in TAT catalog: /obj/item/bomb; /obj/item/clothing/mask/rogue/facemask/; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/runicflask/charged
// Dynamic note: Choice list `weapons`: Archery; Crossbows; BOMBS
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_BOMBER_EXPERT, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 4, TRUE)
/datum/tat_preset/wretch/wretch_pyromaniac
	id = "wretch_pyromaniac"
	name = "Pyromaniac"
	build_data = list(
		"stats" = list(
			STATKEY_WIL = 3,
			STATKEY_CON = 3,
			STATKEY_INT = 3,
		),

		"skills" = list(
			/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			,
			fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_MEDIUMARMOR = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
			TRAIT_EXPLOSIVE_SUPPLY = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/helmet/heavy/sheriff = 1,
			/obj/item/clothing/mask/rogue/facemask/ = 1,
			/obj/item/clothing/neck/roguetown/chaincoif/full = 1,
			/obj/item/clothing/under/roguetown/brigandinelegs = 1,
			/obj/item/clothing/suit/roguetown/armor/brigandine/light = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/gloves/roguetown/plate/iron = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor = 1,
			/obj/item/clothing/wrists/roguetown/bracers/brigandine = 1,
			/obj/item/bomb = 4,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 1,
			/obj/item/quiver/arrows = 1,
			/obj/item/runicflask/charged = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1,
			/obj/item/quiver/bolt/pyro = 1,
			/obj/item/twstrap/bombstrap/firebomb = 1,
			/obj/item/twstrap/bombstrap/bomb_and_fire = 2,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/flint = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/helmet/heavy/sheriff = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/ = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif/full = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/brigandinelegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/brigandine/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = list(
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
			/obj/item/clothing/gloves/roguetown/plate/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/brigandine = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/bomb = list(
				"equip" = 2,
				"bag" = 2,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/arrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/runicflask/charged = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/pyro = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/twstrap/bombstrap/firebomb = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/twstrap/bombstrap/bomb_and_fire = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flint = list(
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

// ---------------------------------------------------------------------------
// Rogue Mage  (wretch/roguemage.dm)
// Advclass path: /datum/advclass/wretch/roguemage
// Missing traits in TAT: TRAIT_ALCHEMY_EXPERT); same reasoning
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/head/roguetown/roguehood/black; /obj/item/clothing/mask/rogue/eyepatch; /obj/item/clothing/suit/roguetown/shirt/robe/black; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/storage/magebag
/datum/tat_preset/wretch/wretch_roguemage
	id = "wretch_roguemage"
	name = "Rogue Mage"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 4,
			STATKEY_PER = 2,
			STATKEY_WIL = 1,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
			/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
			/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT) = TRUE,
			same reasoning
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/mask/rogue/eyepatch = 1,
			/obj/item/clothing/head/roguetown/roguehood/black = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/studded = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/black = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
			/obj/item/clothing/neck/roguetown/leather = 1,
			/obj/item/storage/magebag = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/chalk = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/mask/rogue/eyepatch = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/studded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/magebag = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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

// ---------------------------------------------------------------------------
// Disturbed  (wretch/slasher.dm)
// Advclass path: /datum/advclass/wretch/slasher
// Extra context: "This subclass, like all wretch subclasses, is still subject to the elevated rules and expectations that wretches must follow. You are held to a higher roleplay standard than everyone else, and your psychosis is not an OOC excuse for your gameplay to exclusively be killing others. Your character might be an insidious killer - but you are merely an actor, sharing the stage with everyone else."
// Missing traits in TAT: TRAIT_PSYCHOSIS; TRAIT_ORGAN_EATER; TRAIT_NASTY_EATER) 
	maximum_possible_slots = 2 
	extra_context = "This subclass, like all wretch subclasses, is still subject to the elevated rules and expectations that wretches must follow. You are held to a higher roleplay standard than everyone else, and your psychosis is not an OOC excuse for your gameplay to exclusively be killing others. Your character might be an insidious killer - but you are merely an actor, sharing the stage with everyone else."
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 1,
    	STATKEY_WIL = 1, 
		STATKEY_INT = -1
// Missing items in TAT catalog: /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/rogueweapon/huntingknife/combat
// Dynamic note: Choice list `weapons`: Executioner's Sword; Cudgel; Axe
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_BLOOD_RESISTANCE, TRAIT_GENERIC)
/datum/tat_preset/wretch/wretch_slasher
	id = "wretch_slasher"
	name = "Disturbed"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_SPD = 1,
			STATKEY_WIL = 1,
			,
			gains +1 to str or spd later
		STATKEY_INT = -1,
		),

		"skills" = list(
			/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			,
			jason
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
			/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
			/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		),

		"traits" = list(
			TRAIT_PSYCHOSIS = TRUE,
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TRAIT_ORGAN_EATER = TRUE,
			TRAIT_NASTY_EATER) 
	maximum_possible_slots = 2 
	extra_context = "This subclass, like all wretch subclasses, is still subject to the elevated rules and expectations that wretches must follow. You are held to a higher roleplay standard than everyone else, and your psychosis is not an OOC excuse for your gameplay to exclusively be killing others. Your character might be an insidious killer - but you are merely an actor, sharing the stage with everyone else."
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 1,
    	STATKEY_WIL = 1, 
		STATKEY_INT = -1 = TRUE,
		),

		"items" = list(
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = 1,
			/obj/item/storage/backpack/rogue/satchel/short = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/clothing/neck/roguetown/coif/heavypadding = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/mask/rogue/facemask = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rogueweapon/sword/long/exe = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = 1,
			/obj/item/rope = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/huntingknife/combat = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel/short = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/heavypadding = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/exe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rope = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/combat = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Masked Lunatic  (wretch/vigilante.dm)
// Advclass path: /datum/advclass/wretch/vigilante
// Extra context: "This class is best experienced without preparation."
// Missing traits in TAT: TRAIT_PERFECT_TRACKER
// Missing items in TAT catalog: /obj/item/clothing/cloak/cape; /obj/item/clothing/cloak/cape/puritan; /obj/item/clothing/cloak/thief_cloak; /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood; /obj/item/clothing/mask/rogue/duelmask; /obj/item/clothing/neck/roguetown/chaincoif/; /obj/item/clothing/wrists/roguetown/bracers/jackchain; /obj/item/flashlight/flare/torch/lantern/prelit; /obj/item/grapplinghook; /obj/item/storage/backpack/rogue/backpack/bagpack
// Dynamic note: Choice list `classes`: The Watchman; The Gadgeteer; I AM JUSTICE INCARNATE!!!
// Dynamic note: Choice list `weapons`: THE FISTS OF JUSTICE ARE UNISEX!; JUSTICE DISPENSED THROUGH KNUCKLE AND BLADE!
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 5, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 5, TRUE)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
// Dynamic note: H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
// Dynamic note: ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_MASTER, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/slings, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 5, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 3, TRUE)
/datum/tat_preset/wretch/wretch_vigilante
	id = "wretch_vigilante"
	name = "Masked Lunatic"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
			/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
			,
			fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
			,
		),

		"traits" = list(
			TRAIT_DECEIVING_MEEKNESS = TRUE,
			TRAIT_PERFECT_TRACKER = TRUE,
		),

		"items" = list(
			/obj/item/clothing/neck/roguetown/chaincoif/ = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/storage/backpack/rogue/satchel = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/black/steel = 1,
			/obj/item/clothing/gloves/roguetown/plate = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/clothing/wrists/roguetown/bracers/jackchain = 1,
			/obj/item/storage/backpack/rogue/backpack/bagpack = 1,
			/obj/item/rogueweapon/stoneaxe/hurlbat = 4,
			/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood = 1,
			/obj/item/clothing/cloak/thief_cloak = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/rogueweapon/katar = 1,
			/obj/item/clothing/gloves/roguetown/knuckles = 1,
			/obj/item/rogueweapon/woodstaff/quarterstaff/steel = 1,
			/obj/item/quiver/sling/iron = 1,
			/obj/item/grapplinghook = 1,
			/obj/item/bomb/smoke = 2,
			/obj/item/clothing/cloak/cape/puritan = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/studded = 1,
			/obj/item/clothing/mask/rogue/duelmask = 1,
			/obj/item/quiver/javelin/steel = 2,
			/obj/item/clothing/cloak/cape = 1,
			/obj/item/clothing/mask/rogue/facemask = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/flashlight/flare/torch/lantern/prelit = 1,
			/obj/item/rope/chain = 1,
			/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/neck/roguetown/chaincoif/ = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/black/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/jackchain = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack/bagpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/hurlbat = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/thief_cloak = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/knuckles = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/sling/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/grapplinghook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/bomb/smoke = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/studded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/duelmask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/javelin/steel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/flashlight/flare/torch/lantern/prelit = list(
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
