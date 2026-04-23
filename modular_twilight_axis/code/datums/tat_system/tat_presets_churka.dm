/// Auto-generated TAT preset pack for archetype: churka
/// Source: types.zip + tat_system.zip
/// NOTE: Dynamic class choices, spells, money, and non-TAT-only mechanics are preserved as comments where direct 1:1 encoding was not possible.

// ---------------------------------------------------------------------------
// Monk  (combat/cleric.dm)
// Advclass path: /datum/advclass/cleric
// Extra context: "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception, but removes the 'Dodge Expert' trait."
// Missing items in TAT catalog: /obj/item/clothing/cloak/cape/crusader; /obj/item/clothing/cloak/tabard/devotee/abyssor; /obj/item/clothing/cloak/tabard/devotee/astrata; /obj/item/clothing/cloak/tabard/devotee/dendor; /obj/item/clothing/cloak/tabard/devotee/eora; /obj/item/clothing/cloak/tabard/devotee/malum; /obj/item/clothing/cloak/tabard/devotee/necra; /obj/item/clothing/cloak/tabard/devotee/noc; /obj/item/clothing/cloak/tabard/devotee/pestra; /obj/item/clothing/cloak/tabard/devotee/psydon; /obj/item/clothing/cloak/tabard/devotee/ravox; /obj/item/clothing/cloak/tabard/devotee/xylix; /obj/item/clothing/cloak/tabard/psydontabard; /obj/item/clothing/cloak/tabard/stabard/crusader/t; /obj/item/clothing/cloak/tabard/stabard/crusader/undivided; /obj/item/clothing/gloves/roguetown/bandages; /obj/item/clothing/gloves/roguetown/knuckles/psydon/old; /obj/item/clothing/head/roguetown/bardhat; /obj/item/clothing/head/roguetown/dendormask; /obj/item/clothing/head/roguetown/eoramask; /obj/item/clothing/head/roguetown/headband/monk; /obj/item/clothing/head/roguetown/necrahood; /obj/item/clothing/head/roguetown/roguehood; /obj/item/clothing/head/roguetown/roguehood/abyssor; /obj/item/clothing/head/roguetown/roguehood/astrata; /obj/item/clothing/head/roguetown/roguehood/nochood; /obj/item/clothing/head/roguetown/roguehood/psydon; /obj/item/clothing/neck/roguetown/luckcharm; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/shoes/roguetown/sandals; /obj/item/clothing/suit/roguetown/armor/leather/vest; /obj/item/clothing/suit/roguetown/armor/vestments_padded; /obj/item/clothing/suit/roguetown/shirt/robe; /obj/item/clothing/suit/roguetown/shirt/robe/abyssor; /obj/item/clothing/suit/roguetown/shirt/robe/astrata; /obj/item/clothing/suit/roguetown/shirt/robe/dendor; /obj/item/clothing/suit/roguetown/shirt/robe/eora; /obj/item/clothing/suit/roguetown/shirt/robe/monk; /obj/item/clothing/suit/roguetown/shirt/robe/necra; /obj/item/clothing/suit/roguetown/shirt/robe/noc; /obj/item/clothing/suit/roguetown/shirt/tunic; /obj/item/clothing/suit/roguetown/shirt/undershirt; /obj/item/clothing/under/roguetown/tights/black; /obj/item/needle/thorn/cleric; /obj/item/reagent_containers/glass/bottle/rogue/healthpot; /obj/item/recipe_book/survival; /obj/item/rogue/instrument/hurdygurdy; /obj/item/rogue/instrument/psyaltery; /obj/item/rogueweapon/huntingknife/idagger/steel/special; /obj/item/rogueweapon/stoneaxe/woodcut; /obj/item/storage/belt/rogue/leather/knifebelt/iron
// Dynamic note: Choice list `weapons`: Discipline - Unarmed; Katar; Knuckledusters; Quarterstaff
// Dynamic note: Choice list `helmets`: Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard; Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff; Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket; Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader; Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume; Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet; Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle; Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great; None"
	)

	to_chat(H, span_warning("You are a holy knight, clad in maille and armed with steel. Where others of the clergy may have spent their free time studying scriptures, you devoted yourself towards fighting Psydonia's evils - a longsword in one hand, and a clenched psycross in the other."))
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1, 
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/tabard/psydontabard
			if(H.mind)
				helmets += list("Psydonic Armet" = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm,
							"Psydonic Bucket Helm" = /obj/item/clothing/head/roguetown/helmet/heavy/psybucket)
				var/armors = list("Hauberk","Cuirass
// Dynamic note: Choice list `weapons`: Longsword; Broadsword; Mace; Flail; Flail, Studded; Whip; Spear; Axe
// Dynamic note: Choice list `oaths`: Cleric - Medicine Training + Supplies; Crusader - Silver Longsword + Surcoat; None
// Dynamic note: Choice list `weapons`: Harp; Lute; Accordion; Guitar; Hurdy-Gurdy; Viola; Vocal Talisman; Psyaltery; Flute; Drum")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Drum")
				backr = /obj/item/rogue/instrument/drum

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/cleric/missionary
	name = "Missionary"
	tutorial = "You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."
	outfit = /datum/outfit/job/roguetown/adventurer/missionary
	traits_applied = list()
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE, //If a potential staff-polearm user is at Apprentice-level or below, it's fine to match both combat skills.
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass regenerates Devotion far quicker, but only has access to lesser miracles."

/datum/outfit/job/roguetown/adventurer/missionary/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("You are a devout worshipper of the divine with a strong connection to your patron god. You've spent years studying scriptures and serving your deity - now you wander into foreign lands, spreading the word of your faith."))
	H.mind?.current.faction += "[H.name]_faction"
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/vestments_padded
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			cloak = /obj/item/clothing/cloak/tabard/psydontabard
			head = /obj/item/clothing/head/roguetown/roguehood/psydon
		if(/datum/patron/divine/undivided)
			head = /obj/item/clothing/head/roguetown/roguehood
			cloak = /obj/item/clothing/cloak/tabard/stabard/crusader/undivided
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			cloak = /obj/item/clothing/cloak/tabard/devotee/astrata
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		if(/datum/patron/divine/noc)
			head =  /obj/item/clothing/head/roguetown/roguehood/nochood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
			H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
			H.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_NOVICE, TRUE)
		if(/datum/patron/divine/dendor)
			head = /obj/item/clothing/head/roguetown/dendormask
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		if (/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood //placeholder
			cloak = /obj/item/clothing/cloak/tabard/devotee/malum
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_NOVICE, TRUE)
		if (/datum/patron/divine/eora)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
			head = /obj/item/clothing/head/roguetown/eoramask
			backpack_contents[/obj/item/reagent_containers/eoran_seed] = 1
			r_hand = /obj/item/rogueweapon/huntingknife/scissors
			H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		if (/datum/patron/divine/xylix)
			cloak = /obj/item/clothing/cloak/tabard/devotee/xylix
			H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, SKILL_LEVEL_NOVICE, TRUE)
		if (/datum/patron/divine/pestra)
			cloak = /obj/item/clothing/cloak/tabard/devotee/pestra
			H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if (/datum/patron/divine/ravox)
			cloak = /obj/item/clothing/cloak/tabard/devotee/ravox
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
			ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		if(/datum/patron/inhumen/zizo)
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe 
			head = /obj/item/clothing/head/roguetown/roguehood
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		else
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe //placeholder; anyone who doesn't have cool patron drip sprites just gets generic robes
			head = /obj/item/clothing/head/roguetown/roguehood
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_3)	//Minor regen; capped to T3; parity with other Holy and/or Arcyne caster - no others spend 15 minutes idling only to unlock their entire potencial.
	if(H.mind)
		var/weapons = list("Woodstaff", "Quarterstaff
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/staves, 3, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 2, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
/datum/tat_preset/churka/combat_cleric
	id = "combat_cleric"
	name = "Monk"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_WIL = 2,
			STATKEY_CON = 2,
			STATKEY_SPD = 1,
			,
			over the standard +7. Special clemency given to the Monk,
			as their playstyle is exceedingly lethal - light-to-no armor,
			while specializing in a dangerous melee style.,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
			)
	
	
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_CIVILIZEDBARBARIAN = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/headband/monk = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/monk = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/shoes/roguetown/sandals = 1,
			/obj/item/storage/backpack/rogue/satchel = 4,
			/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = 1,
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/flashlight/flare/torch/lantern = 2,
			/obj/item/clothing/gloves/roguetown/bandages/weighted = 1,
			/obj/item/rogueweapon/katar/bronze = 1,
			/obj/item/clothing/gloves/roguetown/bandages = 2,
			/obj/item/clothing/gloves/roguetown/knuckles/psydon/old = 1,
			/obj/item/clothing/gloves/roguetown/knuckles/bronze = 1,
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = 2,
			/obj/item/rogueweapon/scabbard/gwstrap = 2,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/cloak/tabard/psydontabard = 3,
			/obj/item/clothing/head/roguetown/roguehood/psydon = 2,
			/obj/item/clothing/head/roguetown/roguehood/astrata = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/astrata = 1,
			/obj/item/clothing/head/roguetown/roguehood/nochood = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/noc = 2,
			/obj/item/clothing/head/roguetown/roguehood/abyssor = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/abyssor = 2,
			/obj/item/clothing/head/roguetown/dendormask = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/dendor = 2,
			/obj/item/clothing/head/roguetown/necrahood = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/necra = 2,
			/obj/item/clothing/head/roguetown/roguehood = 6,
			/obj/item/clothing/cloak/tabard/devotee/malum = 4,
			/obj/item/clothing/suit/roguetown/shirt/robe/eora = 2,
			/obj/item/clothing/head/roguetown/eoramask = 2,
			/obj/item/clothing/cloak/tabard/devotee/xylix = 4,
			/obj/item/clothing/suit/roguetown/shirt/robe = 3,
			/obj/item/clothing/neck/roguetown/psicross = 4,
			/obj/item/clothing/neck/roguetown/psicross/undivided = 4,
			/obj/item/clothing/neck/roguetown/psicross/astrata = 4,
			/obj/item/clothing/neck/roguetown/psicross/noc = 4,
			/obj/item/clothing/neck/roguetown/psicross/abyssor = 4,
			/obj/item/clothing/neck/roguetown/psicross/dendor = 4,
			/obj/item/clothing/neck/roguetown/psicross/necra = 4,
			/obj/item/clothing/neck/roguetown/psicross/pestra = 4,
			/obj/item/clothing/neck/roguetown/psicross/ravox = 4,
			/obj/item/clothing/neck/roguetown/psicross/malum = 4,
			/obj/item/clothing/neck/roguetown/psicross/eora = 4,
			/obj/item/clothing/neck/roguetown/luckcharm = 4,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/rogueweapon/shield/iron = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/clothing/under/roguetown/chainlegs = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/gloves/roguetown/chain = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 12,
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = 1,
			/obj/item/clothing/cloak/tabard/devotee/astrata = 3,
			/obj/item/clothing/cloak/tabard/devotee/noc = 2,
			/obj/item/clothing/cloak/tabard/devotee/abyssor = 2,
			/obj/item/clothing/cloak/tabard/devotee/dendor = 2,
			/obj/item/clothing/cloak/tabard/devotee/necra = 2,
			/obj/item/clothing/cloak/tabard/devotee/eora = 2,
			/obj/item/clothing/cloak/tabard/devotee/ravox = 3,
			/obj/item/clothing/cloak/tabard/devotee/pestra = 3,
			/obj/item/clothing/cloak/tabard/stabard/crusader/undivided = 2,
			/obj/item/rogueweapon/sword/long/oldpsysword = 1,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/scabbard/sword = 2,
			/obj/item/rogueweapon/sword/long/broadsword = 1,
			/obj/item/rogueweapon/mace/cudgel/psy/old = 1,
			/obj/item/rogueweapon/mace = 1,
			/obj/item/rogueweapon/flail = 1,
			/obj/item/rogueweapon/flail/alt = 1,
			/obj/item/rogueweapon/whip = 1,
			/obj/item/rogueweapon/spear/psyspear/old = 1,
			/obj/item/rogueweapon/spear = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/needle/thorn/cleric = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			/obj/item/clothing/cloak/tabard/stabard/crusader/t = 1,
			/obj/item/rogueweapon/sword/long/silver = 1,
			/obj/item/clothing/head/roguetown/bardhat = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/vest = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 2,
			/obj/item/clothing/cloak/tabard/devotee/psydon = 1,
			/obj/item/clothing/cloak/cape/crusader = 1,
			/obj/item/rogue/instrument/harp = 1,
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/accord = 1,
			/obj/item/rogue/instrument/guitar = 1,
			/obj/item/rogue/instrument/hurdygurdy = 1,
			/obj/item/rogue/instrument/viola = 1,
			/obj/item/rogue/instrument/vocals = 1,
			/obj/item/rogue/instrument/psyaltery = 1,
			/obj/item/rogue/instrument/flute = 1,
			/obj/item/rogue/instrument/drum = 1,
			/obj/item/clothing/suit/roguetown/armor/vestments_padded = 1,
			/obj/item/clothing/shoes/roguetown/boots = 1,
			/obj/item/rogueweapon/huntingknife/scissors = 1,
			/obj/item/rogueweapon/woodstaff = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
			/obj/item/reagent_containers/food/snacks/rogue/bread = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/beer = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/headband/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/sandals = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages/weighted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/knuckles/psydon/old = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/knuckles/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/psydontabard = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/psydon = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/astrata = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/astrata = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/nochood = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/noc = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/abyssor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/abyssor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/dendormask = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/dendor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/necrahood = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/necra = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 6,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/malum = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/eora = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/eoramask = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/xylix = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/undivided = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/astrata = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/noc = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/abyssor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/dendor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/necra = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/pestra = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/ravox = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/malum = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/eora = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/luckcharm = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = list(
				"equip" = 12,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/astrata = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/noc = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/abyssor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/dendor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/necra = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/eora = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/ravox = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/devotee/pestra = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/crusader/undivided = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/oldpsysword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/broadsword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel/psy/old = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/alt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/psyspear/old = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/needle/thorn/cleric = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard/crusader/t = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/bardhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 1,
			),
			/obj/item/clothing/cloak/tabard/devotee/psydon = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape/crusader = list(
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
			/obj/item/rogue/instrument/psyaltery = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/flute = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/drum = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/vestments_padded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/scissors = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/recipe_book/survival = list(
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

// ---------------------------------------------------------------------------
// Eastern Warrior  (combat/foreigner.dm)
// Advclass path: /datum/advclass/foreigner
// Extra context: "This class is for experienced adventurers with a solid grasp on footwork and stamina management. Your weapon has special intents you can juggle through to make fights easier... Sometimes."
// Missing items in TAT catalog: /obj/item/clothing/cloak/cape/purple; /obj/item/clothing/cloak/cape/red; /obj/item/clothing/cloak/forrestercloak/autumn; /obj/item/clothing/cloak/tabard/psydontabard; /obj/item/clothing/cloak/thief_cloak/yoruku; /obj/item/clothing/gloves/roguetown/bandages; /obj/item/clothing/gloves/roguetown/chain/psydon; /obj/item/clothing/gloves/roguetown/elven_gloves/autumn; /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd; /obj/item/clothing/head/roguetown/headband/red; /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light; /obj/item/clothing/head/roguetown/roguehood/psydon; /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black; /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku; /obj/item/clothing/head/roguetown/roguehood/shalal/purple; /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched; /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune; /obj/item/clothing/mask/rogue/facemask/yoruku_oni; /obj/item/clothing/mask/rogue/lordmask/tarnished; /obj/item/clothing/neck/roguetown/coif; /obj/item/clothing/neck/roguetown/fencerguard/generic; /obj/item/clothing/neck/roguetown/psicross/naledi; /obj/item/clothing/shoes/roguetown/boots/elven_boots/autumn; /obj/item/clothing/shoes/roguetown/sandals; /obj/item/clothing/shoes/roguetown/shalal; /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian; /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light; /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/gladiator; /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd; /obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator; /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1; /obj/item/clothing/suit/roguetown/shirt/undershirt/purple; /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan; /obj/item/clothing/under/roguetown/loincloth/brown; /obj/item/clothing/under/roguetown/skirt/black; /obj/item/clothing/under/roguetown/skirt/red; /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator; /obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic; /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn; /obj/item/net; /obj/item/quiver/bronzearrows; /obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum; /obj/item/recipe_book/survival; /obj/item/rogueweapon/halberd/bardiche/elvish/autumn; /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter; /obj/item/rogueweapon/scabbard/sword/strap; /obj/item/rogueweapon/sword/long/elvish/autumn; /obj/item/rogueweapon/sword/long/fencerguy; /obj/item/rogueweapon/sword/long/shotel; /obj/item/storage/backpack/rogue/satchel/otavan; /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red; /obj/item/storage/belt/rogue/leather/rope/dark; /obj/item/storage/belt/rogue/leather/sash; /obj/item/storage/belt/rogue/leather/shalal/purple
// Dynamic note: Choice list `weapons`: Naginata; Quarterstaff; Hwando
// Dynamic note: Choice list `weapons`: Tanto; Kodachi
// Dynamic note: Choice list `masks`: Oni; Kitsune
// Dynamic note: Choice list `weapons`: Balanced Longsword & Seax; Spear & Punch Dagger; Sabre
// Dynamic note: Choice list `bronzeweapon`: Spatha & +1 Unarmed; Trident & +1 Unarmed; Greataxe & +1 Unarmed; Axepick & +1 Unarmed; Winged Spear + Greatshield; Heavy Khopesh + Greatshield; Shortsword + Shield; Falchion + Shield; Messer + Shield; Khopesh + Shield; Axe + Shield; Warclub + Shield; Flail + Shield; Spear + Shield; Axegauntlet + Shortsword; Nothing - Skilled Pugilist, +I STR / -I WIL
// Dynamic note: Choice list `bronzesidearm`: A Javelin's Bag; A Sling With Bronze Pellets; A Bow With Bronze Arrows; Another Shortsword & Skills In Dual-Wielding; Another Messer & Skills In Dual-Wielding; Another Khopesh & Skills In Dual-Wielding; Another Axe & Skills In Dual-Wielding; A Bottle Of Medicinal Fish Vinegar.. ?
// Dynamic note: Choice list `bronzediscipline`: Thespian - Dodge Expert, -I CON / +I SPD; Gladiator - Skin-Armored & Immunity To Pain; Shieldbearer - Well-Armored & Maille Training; Bulwark - Fully-Armored & Plate Training
// Dynamic note: Choice list `weapons`: Autumned Longsword; Autumned Glaive; Autumned Bow
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
/datum/tat_preset/churka/combat_foreigner
	id = "combat_foreigner"
	name = "Eastern Warrior"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 1,
		),

		"skills" = list(
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/mentorhat = 1,
			/obj/item/clothing/gloves/roguetown/eastgloves1 = 2,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1 = 2,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1 = 2,
			/obj/item/clothing/shoes/roguetown/boots = 2,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/storage/belt/rogue/leather/black = 3,
			/obj/item/storage/backpack/rogue/satchel = 7,
			/obj/item/rogueweapon/spear/naginata = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 6,
			/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit = 2,
			/obj/item/rogueweapon/woodstaff/quarterstaff/steel = 1,
			/obj/item/rogueweapon/sword/sabre/mulyeog = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun = 1,
			/obj/item/clothing/suit/roguetown/armor/basiceast = 1,
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun = 1,
			/obj/item/clothing/cloak/thief_cloak/yoruku = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
			/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
			/obj/item/rogueweapon/sword/short/kazengun = 1,
			/obj/item/rogueweapon/scabbard/sword/kazengun/kodachi = 1,
			/obj/item/clothing/mask/rogue/facemask/yoruku_oni = 1,
			/obj/item/clothing/mask/rogue/facemask/yoruku_kitsune = 1,
			/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched = 1,
			/obj/item/clothing/neck/roguetown/psicross = 1,
			/obj/item/clothing/cloak/tabard/psydontabard = 1,
			/obj/item/clothing/gloves/roguetown/chain/psydon = 1,
			/obj/item/clothing/shoes/roguetown/boots/psydonboots = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan = 1,
			/obj/item/storage/backpack/rogue/satchel/otavan = 1,
			/obj/item/storage/belt/rogue/leather/rope/dark = 1,
			/obj/item/clothing/head/roguetown/roguehood/psydon = 1,
			/obj/item/rogueweapon/whip = 1,
			/obj/item/clothing/mask/rogue/lordmask/tarnished = 1,
			/obj/item/rogueweapon/spear/assegai = 1,
			/obj/item/clothing/neck/roguetown/psicross/naledi = 1,
			/obj/item/clothing/shoes/roguetown/sandals = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian = 1,
			/obj/item/clothing/under/roguetown/skirt/black = 1,
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black = 1,
			/obj/item/flashlight/flare/torch/lantern = 2,
			/obj/item/clothing/mask/rogue/facemask/steel = 1,
			/obj/item/clothing/head/roguetown/roguehood/shalal/purple = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/clothing/shoes/roguetown/shalal = 1,
			/obj/item/clothing/under/roguetown/chainlegs = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/purple = 1,
			/obj/item/storage/belt/rogue/leather/shalal/purple = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/scale = 1,
			/obj/item/clothing/cloak/cape/purple = 1,
			/obj/item/rogueweapon/shield/heater = 1,
			/obj/item/rogueweapon/sword/long/shotel = 1,
			/obj/item/clothing/head/roguetown/armingcap/padded = 1,
			/obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd = 1,
			/obj/item/clothing/neck/roguetown/psicross/reform = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd = 1,
			/obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd = 1,
			/obj/item/storage/belt/rogue/leather/sash = 1,
			/obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa = 1,
			/obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd = 1,
			/obj/item/clothing/shoes/roguetown/grenzelhoft/freifechter = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/rogueweapon/sword/long/fencerguy = 1,
			/obj/item/rogueweapon/huntingknife/combat/fencerguy = 1,
			/obj/item/rogueweapon/scabbard/sword = 3,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/rogueweapon/spear/boar = 1,
			/obj/item/rogueweapon/katar/punchdagger = 1,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/huntingknife/idagger = 1,
			/obj/item/clothing/suit/roguetown/armor/leather = 1,
			/obj/item/clothing/suit/roguetown/shirt/freifechter = 1,
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves = 1,
			/obj/item/clothing/neck/roguetown/fencerguard/generic = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 2,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/shoes/roguetown/grenzelhoft = 1,
			/obj/item/storage/belt/rogue/leather = 3,
			/obj/item/rogueweapon/sword/long/broadsword/bronze = 1,
			/obj/item/rogueweapon/scabbard/sword/strap = 10,
			/obj/item/rogueweapon/spear/trident = 1,
			/obj/item/net = 1,
			/obj/item/rogueweapon/greataxe/bronze = 1,
			/obj/item/rogueweapon/pick/bronze = 1,
			/obj/item/rogueweapon/spear/bronze/winged/strapless = 1,
			/obj/item/rogueweapon/shield/bronze/great = 2,
			/obj/item/rogueweapon/sword/long/greatkhopesh = 1,
			/obj/item/rogueweapon/sword/short/gladius = 3,
			/obj/item/rogueweapon/shield/bronze = 8,
			/obj/item/rogueweapon/sword/short/messer/bronze = 2,
			/obj/item/rogueweapon/sword/falchion/militia/bronze = 1,
			/obj/item/rogueweapon/sword/sabre/bronzekhopesh = 2,
			/obj/item/rogueweapon/stoneaxe/woodcut/bronze = 2,
			/obj/item/rogueweapon/mace/warhammer/bronze = 1,
			/obj/item/rogueweapon/flail/bronze = 1,
			/obj/item/rogueweapon/spear/bronze/strapless = 1,
			/obj/item/rogueweapon/katar/bronze/gladiator = 1,
			/obj/item/clothing/gloves/roguetown/bandages = 1,
			/obj/item/clothing/gloves/roguetown/bandages/weighted = 1,
			/obj/item/quiver/javelin/bronze = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 1,
			/obj/item/quiver/sling/bronze = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic = 1,
			/obj/item/quiver/bronzearrows = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum = 1,
			/obj/item/clothing/head/roguetown/headband/red = 1,
			/obj/item/clothing/mask/rogue/facemask/bronze = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/bronze/light = 1,
			/obj/item/clothing/under/roguetown/skirt/red = 2,
			/obj/item/clothing/wrists/roguetown/bracers/bronze = 3,
			/obj/item/clothing/head/roguetown/helmet/bronzegladiator = 1,
			/obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator = 1,
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/gladiator = 1,
			/obj/item/clothing/under/roguetown/loincloth/brown = 2,
			/obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator = 1,
			/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red = 2,
			/obj/item/clothing/head/roguetown/helmet/heavy/bronze = 1,
			/obj/item/clothing/neck/roguetown/gorget/bronze = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/bronze = 1,
			/obj/item/clothing/cloak/cape/red = 2,
			/obj/item/clothing/head/roguetown/helmet/bronze = 1,
			/obj/item/clothing/neck/roguetown/bevor/bronze = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/bronze = 1,
			/obj/item/rogueweapon/sword/long/elvish/autumn = 1,
			/obj/item/rogueweapon/halberd/bardiche/elvish/autumn = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn = 1,
			/obj/item/quiver/arrows = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light = 1,
			/obj/item/clothing/neck/roguetown/coif = 1,
			/obj/item/clothing/shoes/roguetown/boots/elven_boots/autumn = 1,
			/obj/item/clothing/cloak/forrestercloak/autumn = 1,
			/obj/item/clothing/gloves/roguetown/elven_gloves/autumn = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/mentorhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/eastgloves1 = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1 = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1 = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 7,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/naginata = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 6,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/steel = list(
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
			/obj/item/clothing/suit/roguetown/armor/basiceast = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/thief_cloak/yoruku = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath/kazengun = list(
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
			/obj/item/clothing/mask/rogue/facemask/yoruku_oni = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/yoruku_kitsune = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/psydontabard = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain/psydon = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/psydonboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel/otavan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope/dark = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/psydon = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/lordmask/tarnished = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/assegai = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/naledi = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/sandals = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/skirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather/heavy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/shalal = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/shalal/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/scale = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/heater = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/shotel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/armingcap/padded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/reform = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/sash = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/grenzelhoft/freifechter = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/fencerguy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/combat/fencerguy = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/boar = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar/punchdagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/freifechter = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle/grenzelgloves = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/fencerguard/generic = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/grenzelhoft = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/broadsword/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/strap = list(
				"equip" = 10,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/trident = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/net = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/pick/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/bronze/winged/strapless = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/bronze/great = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/greatkhopesh = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/gladius = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/bronze = list(
				"equip" = 8,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/messer/bronze = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/falchion/militia/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/bronzekhopesh = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/bronze = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/bronze/strapless = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar/bronze/gladiator = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages/weighted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/javelin/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/sling/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/bronzearrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/headband/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/bronze/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/skirt/red = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/bronze = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/bronzegladiator = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/gladiator = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/loincloth/brown = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape/red = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/bevor/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/elvish/autumn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/halberd/bardiche/elvish/autumn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/arrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/elven_boots/autumn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/forrestercloak/autumn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/elven_gloves/autumn = list(
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
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Sorcerer  (combat/mage.dm)
// Advclass path: /datum/advclass/mage
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/head/roguetown/bucklehat; /obj/item/clothing/head/roguetown/headband/monk; /obj/item/clothing/head/roguetown/roguehood/mage; /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black; /obj/item/clothing/head/roguetown/spellcasterhat; /obj/item/clothing/shoes/roguetown/sandals; /obj/item/clothing/suit/roguetown/armor/gambeson/dark; /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian; /obj/item/clothing/suit/roguetown/shirt/robe/mage; /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe; /obj/item/clothing/suit/roguetown/shirt/tunic/black; /obj/item/clothing/under/roguetown/tights/black; /obj/item/rogue/instrument/hurdygurdy; /obj/item/rogue/instrument/psyaltery; /obj/item/rogueweapon/spear/spellblade; /obj/item/rogueweapon/stoneaxe/woodcut
// Dynamic note: Choice list `weapons`: Longsword; Rapier; Sabre; Iron Arming Sword; Shortsword; Hwando; Steel Dagger
// Dynamic note: Choice list `spear_weapons`: Spear; Dory; Naginata
// Dynamic note: Choice list `mace_weapons`: Mace; Warhammer; Goedendag; Iron Axe; Greataxe
// Dynamic note: Choice list `weapons`: Harp; Lute; Accordion; Guitar; Hurdy-Gurdy; Viola; Vocal Talisman; Psyaltery; Flute")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute

/datum/advclass/mage/spellfist
	name = "Spellfist"
	tutorial = "You are a Spellfist, an unarmed warrior who combines martial prowess with arcyne magyck. Your art descends from the Pontifexes of Naledi, warrior-monks who first learned to channel arcyne power through their fists, though the technique has since spread across the world — especially to Lingyuese Psydonites in the east. You eschew most weapons in favor of using magyck to accelerate and strengthen your own body, striking enemies with blows from afar and storms of fists up close."
	outfit = /datum/outfit/job/roguetown/adventurer/spellfist
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/spellfist
	var/sidearm_selected

/datum/outfit/job/roguetown/adventurer/spellfist/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

/datum/outfit/job/roguetown/adventurer/spellfist/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/headband/monk
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	pants = /obj/item/clothing/under/roguetown/tights/black
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/rogueweapon/huntingknife
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		(naledi_book) = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1
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
/datum/tat_preset/churka/combat_mage
	id = "combat_mage"
	name = "Sorcerer"
	build_data = list(
		"stats" = list(
			STATKEY_INT = 3,
			STATKEY_PER = 2,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
			/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_ARCYNE = TRUE,
			TRAIT_ALCHEMY_EXPERT = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/mage = 1,
			/obj/item/clothing/shoes/roguetown/boots = 3,
			/obj/item/clothing/under/roguetown/trou/leather = 3,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 3,
			/obj/item/clothing/suit/roguetown/shirt/robe/mage = 1,
			/obj/item/storage/belt/rogue/leather = 3,
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = 1,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/rogueweapon/huntingknife = 2,
			/obj/item/storage/backpack/rogue/satchel = 4,
			/obj/item/clothing/head/roguetown/bucklehat = 1,
			/obj/item/clothing/gloves/roguetown/angle = 3,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 2,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 1,
			/obj/item/rogueweapon/shield/wood = 1,
			/obj/item/rogueweapon/scabbard/sword = 2,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/sword/sabre = 2,
			/obj/item/rogueweapon/sword/iron = 1,
			/obj/item/rogueweapon/sword/short = 1,
			/obj/item/rogueweapon/sword/sabre/mulyeog = 1,
			/obj/item/clothing/suit/roguetown/armor/basiceast = 2,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/rogueweapon/spear = 1,
			/obj/item/rogueweapon/spear/spellblade = 1,
			/obj/item/rogueweapon/spear/naginata = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/rogueweapon/mace = 1,
			/obj/item/rogueweapon/mace/warhammer = 1,
			/obj/item/rogueweapon/mace/goden = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/rogueweapon/greataxe = 1,
			/obj/item/clothing/head/roguetown/spellcasterhat = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/dark = 1,
			/obj/item/clothing/neck/roguetown/gorget/steel = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe = 1,
			/obj/item/rogue/instrument/harp = 1,
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/accord = 1,
			/obj/item/rogue/instrument/guitar = 1,
			/obj/item/rogue/instrument/hurdygurdy = 1,
			/obj/item/rogue/instrument/viola = 1,
			/obj/item/rogue/instrument/vocals = 1,
			/obj/item/rogue/instrument/psyaltery = 1,
			/obj/item/rogue/instrument/flute = 1,
			/obj/item/clothing/head/roguetown/headband/monk = 1,
			/obj/item/clothing/shoes/roguetown/sandals = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/black = 1,
			/obj/item/clothing/neck/roguetown/leather = 1,
			/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = 1,
			/obj/item/storage/belt/rogue/leather/rope = 1,
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/chalk = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/mage = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/mage = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/reagent_containers/glass/bottle/rogue/manapot = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/bucklehat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 2,
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
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/mulyeog = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/basiceast = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear = list(
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
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/spellcasterhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/dark = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe = list(
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
			/obj/item/rogue/instrument/psyaltery = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/flute = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/headband/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/sandals = list(
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
			/obj/item/clothing/neck/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/cloth/monk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/rope = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/book/spellbook = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/chalk = list(
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
// Mystic  (combat/mystic.dm)
// Advclass path: /datum/advclass/mystic
// Missing items in TAT catalog: /obj/item/book/spellbook; /obj/item/clothing/head/roguetown/roguehood/mage; /obj/item/clothing/neck/roguetown/luckcharm; /obj/item/clothing/suit/roguetown/shirt/robe/mage; /obj/item/recipe_book/survival; /obj/item/rogueweapon/stoneaxe/woodcut
// Dynamic note: Choice list `weapons`: Goedendag; Quarterstaff
// Dynamic note: Choice list `weapons`: Sword & Shield; Axe & Shield; Warhammer & Shield; Spear
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/stoneskin)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/bestow_ward)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/staves, 3, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
/datum/tat_preset/churka/combat_mystic
	id = "combat_mystic"
	name = "Mystic"
	build_data = list(
		"stats" = list(
			,
			lower than the 7 adventurer gets on average
			STATKEY_INT = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
			STATKEY_PER = 2,
		),

		"skills" = list(
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
			,
			prev. novice
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
			/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
			,
		),

		"traits" = list(
			TRAIT_SEEDKNOW = TRUE,
			TRAIT_ARCYNE = TRUE,
		),

		"items" = list(
			/obj/item/clothing/head/roguetown/roguehood/mage = 4,
			/obj/item/clothing/shoes/roguetown/boots = 4,
			/obj/item/clothing/under/roguetown/trou/leather = 4,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 4,
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = 3,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 4,
			/obj/item/storage/belt/rogue/leather = 4,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/storage/backpack/rogue/satchel = 3,
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = 2,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/clothing/neck/roguetown/psicross = 3,
			/obj/item/clothing/neck/roguetown/psicross/undivided = 3,
			/obj/item/clothing/neck/roguetown/psicross/astrata = 3,
			/obj/item/clothing/neck/roguetown/psicross/noc = 3,
			/obj/item/clothing/neck/roguetown/psicross/abyssor = 3,
			/obj/item/clothing/neck/roguetown/psicross/dendor = 3,
			/obj/item/clothing/neck/roguetown/psicross/necra = 3,
			/obj/item/clothing/neck/roguetown/psicross/pestra = 3,
			/obj/item/clothing/neck/roguetown/psicross/ravox = 3,
			/obj/item/clothing/neck/roguetown/psicross/malum = 3,
			/obj/item/clothing/neck/roguetown/psicross/eora = 3,
			/obj/item/clothing/neck/roguetown/luckcharm = 3,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/rogueweapon/woodstaff = 2,
			/obj/item/rogueweapon/mace/goden = 1,
			/obj/item/clothing/neck/roguetown/coif/padded = 1,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/rogueweapon/shield/wood = 3,
			/obj/item/rogueweapon/sword/iron = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/rogueweapon/mace/warhammer = 1,
			/obj/item/rogueweapon/spear = 1,
			/obj/item/clothing/suit/roguetown/shirt/robe/mage = 1,
			/obj/item/clothing/gloves/roguetown/angle = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/book/spellbook = 1,
			/obj/item/chalk = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/head/roguetown/roguehood/mage = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/undivided = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/astrata = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/noc = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/abyssor = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/dendor = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/necra = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/pestra = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/ravox = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/malum = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/eora = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/luckcharm = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/goden = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/padded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood = list(
				"equip" = 3,
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
			/obj/item/rogueweapon/mace/warhammer = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/mage = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/recipe_book/survival = list(
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
// Aristocrat  (combat/noble.dm)
// Advclass path: /datum/advclass/noble
// Extra context: "Chooses between Light Armor (Dodge Expert) and Medium Armor."
// Missing items in TAT catalog: /obj/item/clothing/cloak/half/red; /obj/item/clothing/cloak/raincloak/purple; /obj/item/clothing/cloak/tabard/stabard; /obj/item/clothing/head/roguetown/roguehood; /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple; /obj/item/clothing/suit/roguetown/shirt/tunic/red; /obj/item/clothing/under/roguetown/tights/black; /obj/item/recipe_book/survival; /obj/item/rogueweapon/scabbard/sword/noble; /obj/item/rogueweapon/sword/sabre/dec; /obj/item/storage/belt/rogue/pouch/coins/rich
// Dynamic note: Choice list `helmets`: Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface; Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard; Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff; Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket; Sugarloaf Helmet"  = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader; Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight; Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume; Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored; Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet; Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull; Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan; Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle; Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor; Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great; None
// Dynamic note: Choice list `armors`: Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine; Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy; Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass
// Dynamic note: Choice list `weapons`: Longsword; Mace + Shield; Flail + Shield; Billhook; Battle Axe; Greataxe; Greatflail
// Dynamic note: Choice list `armors`: Light Armor; Medium Armor
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
/datum/tat_preset/churka/combat_noble
	id = "combat_noble"
	name = "Aristocrat"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 2,
			STATKEY_INT = 2,
			STATKEY_STR = 1,
			STATKEY_SPD = 1,
		),

		"skills" = list(
			/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
			/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/music = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_NOBLE = TRUE,
		),

		"items" = list(
			/obj/item/clothing/shoes/roguetown/boots = 2,
			/obj/item/storage/belt/rogue/leather/black = 1,
			/obj/item/flashlight/flare/torch/lantern = 3,
			/obj/item/storage/backpack/rogue/satchel = 3,
			/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
			/obj/item/rogueweapon/sword/sabre/dec = 1,
			/obj/item/rogueweapon/scabbard/sword/noble = 2,
			/obj/item/clothing/cloak/half/red = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/red = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple = 1,
			/obj/item/clothing/cloak/raincloak/purple = 1,
			/obj/item/clothing/gloves/roguetown/chain = 1,
			/obj/item/clothing/under/roguetown/chainlegs = 1,
			/obj/item/clothing/cloak/tabard/stabard = 2,
			/obj/item/clothing/neck/roguetown/bevor = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail = 1,
			/obj/item/clothing/wrists/roguetown/bracers = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor = 1,
			/obj/item/storage/belt/rogue/leather/steel/tasset = 1,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/mace = 1,
			/obj/item/rogueweapon/shield/tower/metal = 2,
			/obj/item/rogueweapon/flail = 1,
			/obj/item/rogueweapon/flail/peasantwarflail/iron = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 3,
			/obj/item/rogueweapon/spear/billhook = 1,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/greataxe = 1,
			/obj/item/clothing/head/roguetown/roguehood = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 1,
			/obj/item/clothing/neck/roguetown/chaincoif/iron = 1,
			/obj/item/storage/belt/rogue/leather = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/rogueweapon/huntingknife/idagger = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1,
			/obj/item/clothing/under/roguetown/chainlegs/iron = 1,
			/obj/item/clothing/gloves/roguetown/chain/iron = 1,
			/obj/item/rogueweapon/sword/iron = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/rich = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre/dec = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword/noble = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/half/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/dress/gen/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/purple = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/tabard/stabard = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/bevor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/steel/tasset = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/tower/metal = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/peasantwarflail/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/billhook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/recipe_book/survival = list(
				"equip" = 0,
				"bag" = 1,
			),
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Sentinel  (combat/ranger.dm)
// Advclass path: /datum/advclass/ranger
// Extra context: "Selecting Light Armor grants +1 SPD. Selecting Medium Armor grants +1 STR along with the corresponding traits."
// Missing traits in TAT: TRAIT_OUTDOORSMAN; TRAIT_EXPERT_HUNTER
// Missing items in TAT catalog: /obj/item/bait; /obj/item/clothing/cloak/raincloak/furcloak/darkgreen; /obj/item/clothing/cloak/raincloak/green; /obj/item/clothing/cloak/raincloak/mortus; /obj/item/clothing/head/roguetown/roguehood; /obj/item/clothing/neck/roguetown/coif; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/shirt/robe/mageorange; /obj/item/clothing/suit/roguetown/shirt/tunic; /obj/item/clothing/suit/roguetown/shirt/undershirt/green; /obj/item/recipe_book/survival; /obj/item/rogueweapon/huntingknife/combat; /obj/item/rogueweapon/stoneaxe/woodcut; /obj/item/storage/belt/rogue/leather/knifebelt/iron
// Dynamic note: Choice list `weapons`: Recurve Bow; Crossbow
// Dynamic note: Choice list `weapons`: Recurve Bow; Billhook; Sling; Crossbow
// Dynamic note: Choice list `armors`: Light Armor; Medium Armor
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
// Dynamic note: ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
/datum/tat_preset/churka/combat_ranger
	id = "combat_ranger"
	name = "Sentinel"
	build_data = list(
		"stats" = list(
			STATKEY_PER = 3,
			STATKEY_SPD = 2,
		),

		"skills" = list(
			/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
			/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
			/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
			/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
			/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_OUTDOORSMAN = TRUE,
			TRAIT_EXPERT_HUNTER = TRUE,
		),

		"items" = list(
			/obj/item/clothing/cloak/raincloak/furcloak/darkgreen = 1,
			/obj/item/clothing/neck/roguetown/coif = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/hide = 2,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/green = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 4,
			/obj/item/clothing/gloves/roguetown/leather = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather = 2,
			/obj/item/storage/belt/rogue/leather = 3,
			/obj/item/storage/backpack/rogue/satchel = 4,
			/obj/item/flashlight/flare/torch/lantern = 2,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = 2,
			/obj/item/quiver/arrows = 2,
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 3,
			/obj/item/quiver/bolt/standard = 3,
			/obj/item/clothing/shoes/roguetown/boots = 2,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = 1,
			/obj/item/clothing/gloves/roguetown/fingerless = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = 1,
			/obj/item/clothing/suit/roguetown/armor/leather = 1,
			/obj/item/clothing/cloak/raincloak/mortus = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/clothing/head/roguetown/roguehood = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 2,
			/obj/item/clothing/under/roguetown/chainlegs/iron = 2,
			/obj/item/clothing/suit/roguetown/shirt/robe/mageorange = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 2,
			/obj/item/twstrap/bombstrap/firebomb = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic = 1,
			/obj/item/clothing/cloak/raincloak/green = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut = 1,
			/obj/item/rogueweapon/spear/billhook = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 1,
			/obj/item/quiver/sling/iron = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants = 1,
			/obj/item/clothing/gloves/roguetown/chain/iron = 1,
			/obj/item/bait = 1,
			/obj/item/rogueweapon/huntingknife/combat = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/cloak/raincloak/furcloak/darkgreen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/hide = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/green = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/quiver/arrows = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/quiver/bolt/standard = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 3,
				"bag" = 1,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/mortus = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/robe/mageorange = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/twstrap/bombstrap/firebomb = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/green = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/billhook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/sling/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/sling = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/bait = list(
				"equip" = 0,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/combat = list(
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
// Treasure Hunter  (combat/rogue.dm)
// Advclass path: /datum/advclass/rogue
// Missing items in TAT catalog: /obj/item/clothing/cloak/half/red; /obj/item/clothing/cloak/raincloak/mortus; /obj/item/clothing/head/roguetown/bardhat; /obj/item/clothing/head/roguetown/fedora; /obj/item/clothing/head/roguetown/helmet/tricorn; /obj/item/clothing/shoes/roguetown/boots/leather; /obj/item/clothing/suit/roguetown/armor/leather/vest; /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor; /obj/item/clothing/suit/roguetown/shirt/shortshirt; /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red; /obj/item/lockpick; /obj/item/recipe_book/survival; /obj/item/rogue/instrument/hurdygurdy; /obj/item/rogue/instrument/psyaltery; /obj/item/storage/belt/rogue/leather/knifebelt/iron
// Dynamic note: Choice list `weapons`: Sabre; Whip
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: I.grant_inspiration(H, bard_tier = BARD_T2)
// Dynamic note: H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)
/datum/tat_preset/churka/combat_rogue
	id = "combat_rogue"
	name = "Treasure Hunter"
	build_data = list(
		"stats" = list(
			STATKEY_STR = -1,
			STATKEY_INT = 1,
			STATKEY_PER = 1,
			STATKEY_WIL = 1,
			STATKEY_SPD = 3,
		),

		"skills" = list(
			/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
			/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
			/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		),

		"traits" = list(
			TRAIT_DODGEEXPERT = TRUE,
			TRAIT_SEEPRICES = TRUE,
			TRAIT_GRAVEROBBER = TRUE,
		),

		"items" = list(
			/obj/item/clothing/under/roguetown/trou/leather = 3,
			/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor = 2,
			/obj/item/storage/backpack/rogue/satchel = 3,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 2,
			/obj/item/clothing/shoes/roguetown/boots/leather = 2,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 4,
			/obj/item/rogueweapon/shovel = 1,
			/obj/item/clothing/head/roguetown/fedora = 1,
			/obj/item/flashlight/flare/torch/lantern = 3,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 3,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/scabbard/sword = 1,
			/obj/item/rogueweapon/whip = 1,
			/obj/item/clothing/suit/roguetown/armor/leather = 1,
			/obj/item/storage/backpack/rogue/backpack = 1,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow = 1,
			/obj/item/clothing/shoes/roguetown/boots = 2,
			/obj/item/clothing/gloves/roguetown/fingerless = 2,
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = 2,
			/obj/item/clothing/cloak/raincloak/mortus = 1,
			/obj/item/quiver/Warrows = 1,
			/obj/item/rogueweapon/mace/cudgel = 1,
			/obj/item/clothing/head/roguetown/bardhat = 1,
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/vest = 1,
			/obj/item/clothing/cloak/half/red = 1,
			/obj/item/rogue/instrument/harp = 1,
			/obj/item/rogue/instrument/lute = 1,
			/obj/item/rogue/instrument/accord = 1,
			/obj/item/rogue/instrument/guitar = 1,
			/obj/item/rogue/instrument/hurdygurdy = 2,
			/obj/item/rogue/instrument/viola = 1,
			/obj/item/rogue/instrument/vocals = 1,
			/obj/item/rogue/instrument/psyaltery = 1,
			/obj/item/rogue/instrument/flute = 1,
			/obj/item/clothing/head/roguetown/helmet/tricorn = 1,
			/obj/item/clothing/under/roguetown/tights/sailor = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red = 1,
			/obj/item/rogueweapon/sword/cutlass = 1,
			/obj/item/lockpick = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/recipe_book/survival = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
		),

		"item_loadout" = list(
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shovel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/fedora = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/backpack = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/mortus = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/quiver/Warrows = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/cudgel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/bardhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/shortshirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/vest = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/half/red = list(
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
				"equip" = 2,
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
			/obj/item/rogue/instrument/psyaltery = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogue/instrument/flute = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/tricorn = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/sailor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor/red = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/cutlass = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/lockpick = list(
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
// Spellblade Chant  (combat/spellblade_chant.dm)
// Advclass path: 
/datum/tat_preset/churka/combat_spellblade_chant
	id = "combat_spellblade_chant"
	name = "Spellblade Chant"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
		),

		"traits" = list(
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Spellfist Chant  (combat/spellfist_chant.dm)
// Advclass path: 
/datum/tat_preset/churka/combat_spellfist_chant
	id = "combat_spellfist_chant"
	name = "Spellfist Chant"
	build_data = list(
		"stats" = list(
		),

		"skills" = list(
		),

		"traits" = list(
		),

		"items" = list(
		),

		"item_loadout" = list(
		),

		"magic_config" = list(),
	)

// ---------------------------------------------------------------------------
// Battlemaster  (combat/warrior.dm)
// Advclass path: /datum/advclass/sfighter
// Extra context: "This subclass gains access to the RAGE ability."
// Missing items in TAT catalog: /obj/item/clothing/cloak/cape/puritan; /obj/item/clothing/cloak/half; /obj/item/clothing/cloak/raincloak/furcloak/brown; /obj/item/clothing/gloves/roguetown/bandages; /obj/item/clothing/gloves/roguetown/plate/iron/banded; /obj/item/clothing/head/roguetown/duelhat; /obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted; /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume/fluted; /obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan; /obj/item/clothing/head/roguetown/puritan; /obj/item/clothing/head/roguetown/puritan/armored; /obj/item/clothing/head/roguetown/roguehood/shalal/hijab; /obj/item/clothing/mask/rogue/duelmask; /obj/item/clothing/shoes/roguetown/boots/furlinedboots; /obj/item/clothing/suit/roguetown/armor/longcoat; /obj/item/clothing/suit/roguetown/armor/manual/pushups/leather; /obj/item/clothing/suit/roguetown/armor/plate/iron/banded; /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian; /obj/item/clothing/suit/roguetown/shirt/tunic/random; /obj/item/clothing/suit/roguetown/shirt/tunic/white; /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan; /obj/item/clothing/under/roguetown/loincloth/deprived; /obj/item/clothing/under/roguetown/tights/black; /obj/item/clothing/under/roguetown/tights/puritan; /obj/item/recipe_book/survival; /obj/item/rogueweapon/huntingknife/combat; /obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed; /obj/item/rogueweapon/mace/woodclub/deprived; /obj/item/rogueweapon/sword/short/iron/banded; /obj/item/rogueweapon/sword/short/messer/duelist; /obj/item/storage/belt/rogue/leather/battleskirt/barbarian; /obj/item/storage/belt/rogue/leather/battleskirt/black
// Dynamic note: Choice list `weapons`: Short Sword & Iron Shield; Arming Sword & Wood Shield; Longsword & +1 Wrestling; Broadsword & +1 Wrestling; Battle Axe & Wood Shield; Mace & Iron Shield; Flail & Iron Shield; Billhook; Greatflail
// Dynamic note: Choice list `armors`: Chainmaille Set; Iron Breastplate; Gambeson & Helmet; Light Raneshi Armor
// Dynamic note: Choice list `weapons`: Rapier & Parrying Dagger; Sabre & Buckler; Messer & Buckler; Dagger & Parrying Dagger; Dual Wield Shortswords; Heavy Dagger & +1 Unarmed
// Dynamic note: Choice list `armors`: Classical Set; Cuirass Set
// Dynamic note: Choice list `weapons`: Bronze Katar; Bronze Sword; Bronze Axe; Bronze Mace; Bronze Spear; Bronze Flail; Discipline - Whiphunter (+I PER / -I SPD); Discipline - Unarmed; Discipline - Bodybuilder
// Dynamic note: Choice list `helmets`: Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/iron; Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron; Kettle Helmet"		= /obj/item/clothing/head/roguetown/helmet/kettle/iron; Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron; Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron; Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron; Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron/greatplume; Banded Iron Helmet"			=	/obj/item/clothing/head/roguetown/helmet/sallet/iron/banded; None
// Dynamic note: Choice list `armors`: Breastplate, Hauberk, & Kilt; Half-Plate, Gambeson, & Chausses; Banded Iron, Light Gambeson, & Pants
// Dynamic note: Choice list `weapons`: Executioner's Sword; Broadsword; Warhammer + Shield; Flail + Shield; Studded Flail + Shield; Lucerne; Greataxe; Greatflail; Banded Sword + Shield
// Dynamic note: Choice list `silver`: Silver Dagger; Silver Shortsword; Silver Arming Sword; Silver Rapier; Silver Longsword; Silver Broadsword; Silver Mace; Silver Warhammer; Silver Morningstar; Silver Whip; Silver War Axe; Silver Poleaxe; Silver Spear; Silver Quarterstaff; Broadsword - Steel
// Dynamic note: Choice list `sidearm`: Dagger - Steel; Parrying Dagger - Steel; Heavy Dagger - Steel; Greatshield; Blessed Silver Stake; Blessed Silver Shovel
// Dynamic note: Choice list `discipline`: Traditionalist - Hauberk & Alchemics (+I INT / -I LCK); Reformist - Chainmaille & Dodge Expert (+I SPD); Orthodoxist - Cuirass & Plate Training (+I CON / -I SPD)
// Dynamic note: Choice list `helmets`: Puritan's Armored Hat; Visored Sallet; Volfskulle Bascinet; Fluted Armet; Fluted Armet With Greatplume; Sugarloaf Greathelm; Barbute Greathelm
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
// Dynamic note: H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
/datum/tat_preset/churka/combat_warrior
	id = "combat_warrior"
	name = "Battlemaster"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 2,
			STATKEY_WIL = 1,
			STATKEY_CON = 2,
		),

		"skills" = list(
			/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
			/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
			/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
			/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
			/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		),

		"traits" = list(
			TRAIT_STEELHEARTED = TRUE,
			TRAIT_MEDIUMARMOR = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/shield/iron = 7,
			/obj/item/rogueweapon/scabbard/sword = 16,
			/obj/item/rogueweapon/sword/short = 3,
			/obj/item/rogueweapon/shield/wood = 2,
			/obj/item/rogueweapon/sword = 1,
			/obj/item/rogueweapon/sword/long = 1,
			/obj/item/rogueweapon/sword/long/broadsword/steel = 2,
			/obj/item/rogueweapon/stoneaxe/battle = 1,
			/obj/item/rogueweapon/mace/steel = 1,
			/obj/item/rogueweapon/flail/sflail = 1,
			/obj/item/rogueweapon/spear/billhook = 1,
			/obj/item/rogueweapon/scabbard/gwstrap = 10,
			/obj/item/rogueweapon/flail/peasantwarflail/iron = 2,
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/random = 3,
			/obj/item/clothing/under/roguetown/chainlegs/iron = 2,
			/obj/item/clothing/neck/roguetown/chaincoif/iron = 1,
			/obj/item/clothing/gloves/roguetown/chain/iron = 3,
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 2,
			/obj/item/clothing/neck/roguetown/coif/heavypadding = 1,
			/obj/item/clothing/under/roguetown/splintlegs = 1,
			/obj/item/clothing/gloves/roguetown/angle = 4,
			/obj/item/clothing/suit/roguetown/armor/gambeson = 2,
			/obj/item/clothing/neck/roguetown/coif/padded = 1,
			/obj/item/clothing/wrists/roguetown/bracers/splint = 1,
			/obj/item/clothing/under/roguetown/trou/leather = 2,
			/obj/item/clothing/head/roguetown/helmet/kettle = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen = 1,
			/obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen = 1,
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab = 1,
			/obj/item/storage/belt/rogue/leather = 2,
			/obj/item/storage/backpack/rogue/satchel = 5,
			/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
			/obj/item/clothing/wrists/roguetown/bracers/leather = 3,
			/obj/item/clothing/shoes/roguetown/boots = 2,
			/obj/item/clothing/cloak/raincloak/furcloak/brown = 1,
			/obj/item/rogueweapon/sword/rapier = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 3,
			/obj/item/rogueweapon/sword/sabre = 1,
			/obj/item/rogueweapon/shield/buckler = 2,
			/obj/item/rogueweapon/sword/short/messer/duelist = 1,
			/obj/item/rogueweapon/huntingknife/idagger/steel = 2,
			/obj/item/rogueweapon/scabbard/sheath = 4,
			/obj/item/rogueweapon/huntingknife/combat = 2,
			/obj/item/clothing/mask/rogue/duelmask = 1,
			/obj/item/clothing/cloak/half = 1,
			/obj/item/clothing/suit/roguetown/armor/leather = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = 1,
			/obj/item/clothing/gloves/roguetown/fingerless_leather = 1,
			/obj/item/clothing/suit/roguetown/armor/longcoat = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/cuirass = 1,
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = 1,
			/obj/item/clothing/gloves/roguetown/leather = 1,
			/obj/item/clothing/head/roguetown/duelhat = 1,
			/obj/item/clothing/neck/roguetown/gorget = 2,
			/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = 7,
			/obj/item/rogueweapon/katar/bronze = 1,
			/obj/item/clothing/gloves/roguetown/bandages = 7,
			/obj/item/rogueweapon/stoneaxe/woodcut/bronze = 1,
			/obj/item/rogueweapon/sword/bronze = 1,
			/obj/item/rogueweapon/mace/bronze = 1,
			/obj/item/rogueweapon/spear/bronze = 1,
			/obj/item/rogueweapon/flail/bronze = 1,
			/obj/item/clothing/head/roguetown/headband/monk/barbarian = 1,
			/obj/item/clothing/suit/roguetown/armor/leather/hide = 1,
			/obj/item/rogueweapon/whip/bronze = 1,
			/obj/item/clothing/gloves/roguetown/bandages/weighted = 1,
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian = 1,
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather = 1,
			/obj/item/rogueweapon/greatsword/iron = 1,
			/obj/item/storage/belt/rogue/leather/battleskirt/barbarian = 1,
			/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt = 1,
			/obj/item/clothing/shoes/roguetown/boots/furlinedboots = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1,
			/obj/item/clothing/neck/roguetown/bevor/iron = 2,
			/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/iron = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/iron/banded = 1,
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = 1,
			/obj/item/clothing/gloves/roguetown/plate/iron/banded = 1,
			/obj/item/clothing/under/roguetown/tights/black = 1,
			/obj/item/clothing/wrists/roguetown/bracers/iron = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = 1,
			/obj/item/storage/belt/rogue/leather/battleskirt/black = 1,
			/obj/item/flashlight/flare/torch/lantern = 1,
			/obj/item/rogueweapon/sword/long/exe = 1,
			/obj/item/rogueweapon/sword/long/broadsword = 1,
			/obj/item/rogueweapon/mace/warhammer = 1,
			/obj/item/rogueweapon/flail = 1,
			/obj/item/rogueweapon/flail/alt = 1,
			/obj/item/rogueweapon/eaglebeak/lucerne = 1,
			/obj/item/rogueweapon/greataxe = 1,
			/obj/item/rogueweapon/sword/short/iron/banded = 1,
			/obj/item/rogueweapon/huntingknife/idagger/silver = 1,
			/obj/item/rogueweapon/sword/short/silver = 1,
			/obj/item/rogueweapon/sword/silver = 1,
			/obj/item/rogueweapon/sword/rapier/silver = 1,
			/obj/item/rogueweapon/sword/long/silver = 1,
			/obj/item/rogueweapon/sword/long/kriegmesser/silver = 1,
			/obj/item/rogueweapon/mace/steel/silver = 1,
			/obj/item/rogueweapon/mace/warhammer/steel/silver = 1,
			/obj/item/rogueweapon/flail/sflail/silver = 1,
			/obj/item/rogueweapon/whip/silver = 1,
			/obj/item/rogueweapon/stoneaxe/woodcut/silver = 1,
			/obj/item/rogueweapon/greataxe/silver = 1,
			/obj/item/rogueweapon/spear/silver = 1,
			/obj/item/rogueweapon/woodstaff/quarterstaff/silver = 1,
			/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed = 1,
			/obj/item/rogueweapon/shovel/silver/preblessed = 1,
			/obj/item/rogueweapon/shield/tower/metal = 1,
			/obj/item/clothing/head/roguetown/puritan/armored = 2,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan = 3,
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
			/obj/item/storage/belt/rogue/leather/black = 2,
			/obj/item/clothing/head/roguetown/puritan = 1,
			/obj/item/clothing/suit/roguetown/armor/chainmail/light = 1,
			/obj/item/storage/belt/rogue/leather/knifebelt/black/silver = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = 1,
			/obj/item/clothing/head/roguetown/helmet/sallet/visored = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume/fluted = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/barbute/great = 1,
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = 1,
			/obj/item/clothing/under/roguetown/tights/puritan = 1,
			/obj/item/clothing/cloak/cape/puritan = 1,
			/obj/item/clothing/neck/roguetown/chaincoif = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver/astrata = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver/necra = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver/noc = 1,
			/obj/item/clothing/neck/roguetown/psicross/silver/undivided = 1,
			/obj/item/rogueweapon/mace/woodclub/deprived = 1,
			/obj/item/rogueweapon/shield/wood/deprived = 1,
			/obj/item/clothing/under/roguetown/loincloth/deprived = 1,
			/obj/item/flashlight/flare/torch = 1,
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/recipe_book/survival = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/shield/iron = list(
				"equip" = 7,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sword = list(
				"equip" = 16,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/broadsword/steel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/battle = list(
				"equip" = 1,
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
			/obj/item/rogueweapon/spear/billhook = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/gwstrap = list(
				"equip" = 10,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/peasantwarflail/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/random = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/chain/iron = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/heavypadding = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/splintlegs = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/angle = list(
				"equip" = 4,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/coif/padded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/splint = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/kettle = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/roguehood/shalal/hijab = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/storage/backpack/rogue/satchel = list(
				"equip" = 5,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/pouch/coins/poor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/leather = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/raincloak/furcloak/brown = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/sabre = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/buckler = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/messer/duelist = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/steel = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/rogueweapon/scabbard/sheath = list(
				"equip" = 3,
				"bag" = 1,
			),
			/obj/item/rogueweapon/huntingknife/combat = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/duelmask = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/half = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/fingerless_leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/longcoat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/cuirass = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/tunic/white = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/duelhat = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/gorget = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/leather/volfhelm = list(
				"equip" = 7,
				"bag" = 0,
			),
			/obj/item/rogueweapon/katar/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages = list(
				"equip" = 7,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/headband/monk/barbarian = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/leather/hide = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip/bronze = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/bandages/weighted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/manual/pushups/leather = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greatsword/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/battleskirt/barbarian = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/furlinedboots = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/bevor/iron = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/iron/banded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/gambeson/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate/iron/banded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/battleskirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch/lantern = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/exe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/broadsword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/alt = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/eaglebeak/lucerne = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/iron/banded = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/short/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/rapier/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/sword/long/kriegmesser/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/steel/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/warhammer/steel/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/flail/sflail/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/whip/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/stoneaxe/woodcut/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/greataxe/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/spear/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/woodstaff/quarterstaff/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shovel/silver/preblessed = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/tower/metal = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/puritan/armored = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan = list(
				"equip" = 3,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/black = list(
				"equip" = 2,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/chainmail/light = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/knifebelt/black/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/sallet/visored = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/knight/fluted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume/fluted = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/barbute/great = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/tights/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/cloak/cape/puritan = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/chaincoif = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver/astrata = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver/necra = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver/noc = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/psicross/silver/undivided = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/mace/woodclub/deprived = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/rogueweapon/shield/wood/deprived = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/loincloth/deprived = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/flashlight/flare/torch = list(
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
		),

		"magic_config" = list(),
	)
