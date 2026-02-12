/datum/advclass/cleric/vigilant
	name = "Vigilant"
	tutorial = "You were too weak to carry armour or heavy blade, but your devoution dragged you to serving Gods. You are knife in shadows and eternal vigilant."
	outfit = /datum/outfit/job/roguetown/cleric/vigilant
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_STR = -2
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	class_select_category = CLASS_CAT_CLERIC
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass can pick twin daggers, gaining increased speed, or ranged options, gaining increased perception."

/datum/outfit/job/roguetown/cleric/vigilant/pre_equip(mob/living/carbon/human/H)
	..()
	wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
	cloak = /obj/item/clothing/cloak/undivided
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
			var/cloaks = list("Cloak", "Tabard")
			var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
			switch(cloakchoice)
				if("Cloak")
					cloak = /obj/item/clothing/cloak/undivided
				if("Tabard")
					cloak = /obj/item/clothing/cloak/templar/undivided
		if(/datum/patron/divine/astrata)
			head = /obj/item/clothing/head/roguetown/roguehood/astrata
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
			cloak = /obj/item/clothing/cloak/tabard/crusader/astrata
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/roguetown/roguehood/abyssor
			wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
			cloak = /obj/item/clothing/cloak/tabard/abyssortabard
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
			cloak = /obj/item/clothing/cloak/templar/xylixian
			H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
			cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
			mask = /obj/item/clothing/head/roguetown/dendormask
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			head = /obj/item/clothing/head/roguetown/necrahood
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
			cloak = /obj/item/clothing/cloak/templar/necran
		if(/datum/patron/divine/pestra)
			head = /obj/item/clothing/head/roguetown/roguehood/phys
			wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			head = /obj/item/clothing/head/roguetown/eoramask
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
		if(/datum/patron/divine/noc)
			head = /obj/item/clothing/head/roguetown/roguehood/nochood
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
			cloak = /obj/item/clothing/cloak/tabard/crusader/noc
		if(/datum/patron/divine/ravox)
			head = /obj/item/clothing/head/roguetown/roguehood
			wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
		if(/datum/patron/divine/malum)
			head = /obj/item/clothing/head/roguetown/roguehood
			wrists = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross
			head = /obj/item/clothing/head/roguetown/roguehood
			cloak = /obj/item/clothing/cloak/tabard/psydontabard
		else
			head = /obj/item/clothing/head/roguetown/roguehood
			var/cloaks = list("Simple", "Undercover")
			var/cloakchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in cloaks
			switch(cloakchoice)
				if("Simple")
					cloak = /obj/item/clothing/cloak/tabard
				if("Undercover")
					var/covers = list ("Astrata", "Noc", "Ravox", "Dendor", "Necra", "Abyssor", "Xylix", "Eora", "Pestra", "Malum", "Ten", "Psydon")
					var/coverchoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in covers
					switch(coverchoice)
						if("Astrata")
							head = /obj/item/clothing/head/roguetown/roguehood/astrata
							wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
							cloak = /obj/item/clothing/cloak/tabard/crusader/astrata
						if("Noc")
							head = /obj/item/clothing/head/roguetown/roguehood/nochood
							wrists = /obj/item/clothing/neck/roguetown/psicross/noc
							cloak = /obj/item/clothing/cloak/tabard/crusader/noc
						if("Ravox")
							head = /obj/item/clothing/head/roguetown/roguehood
							wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
							cloak = /obj/item/clothing/cloak/templar/ravox
						if("Dendor")
							wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
							cloak = /obj/item/clothing/cloak/tabard/crusader/dendor
							mask = /obj/item/clothing/head/roguetown/dendormask
						if("Necra")
							head = /obj/item/clothing/head/roguetown/necrahood
							wrists = /obj/item/clothing/neck/roguetown/psicross/necra
							cloak = /obj/item/clothing/cloak/templar/necran
						if("Abyssor")
							head = /obj/item/clothing/head/roguetown/roguehood/abyssor
							wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
							cloak = /obj/item/clothing/cloak/tabard/abyssortabard
						if("Xylix")
							wrists = /obj/item/clothing/neck/roguetown/psicross/xylix
							cloak = /obj/item/clothing/cloak/templar/xylixian
						if("Eora")
							head = /obj/item/clothing/head/roguetown/eoramask
							wrists = /obj/item/clothing/neck/roguetown/psicross/eora
							cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
						if("Pestra")
							head = /obj/item/clothing/head/roguetown/roguehood/phys
							wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
							cloak = /obj/item/clothing/cloak/templar/pestran
						if("Malum")
							head = /obj/item/clothing/head/roguetown/roguehood
							wrists = /obj/item/clothing/neck/roguetown/psicross/malum
							cloak = /obj/item/clothing/cloak/templar/malumite
						if("Ten")
							head = /obj/item/clothing/head/roguetown/roguehood
							cloak = /obj/item/clothing/cloak/undivided
							wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
						if("Psydon")
							head = /obj/item/clothing/head/roguetown/roguehood
							cloak = /obj/item/clothing/cloak/tabard/psydontabard
							wrists = /obj/item/clothing/neck/roguetown/psicross
			if(H.patron?.type == /datum/patron/inhumen/graggar)
				backpack_contents+= list(/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar)
			if(H.patron?.type == /datum/patron/inhumen/matthios)
				backpack_contents+= list(/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios)
			if(H.patron?.type == /datum/patron/inhumen/zizo)
				backpack_contents+= list(/obj/item/clothing/neck/roguetown/psicross/inhumen/iron)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
				H.mind?.current.faction += "[H.name]_faction"

	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	neck = /obj/item/clothing/neck/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	// -- End of section for god specific bonuses --

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

	var/weapons = list("Dagger + Parrying Dagger","Rapier + Parrying Dagger","Recurve Bow + Dagger","Slurbow + Dagger")
	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Dagger + Parrying Dagger")
			l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel
			r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			beltl = /obj/item/rogueweapon/scabbard/sheath
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 3, TRUE)
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_INT, 1)
		if("Rapier + Parrying Dagger")
			l_hand = /obj/item/rogueweapon/sword/rapier
			r_hand =/obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			beltl = /obj/item/rogueweapon/scabbard/sword
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 3, TRUE)
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_INT, 1)
		if("Recurve Bow + Dagger")
			l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special
			beltl = /obj/item/quiver/arrows
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			H.change_stat(STATKEY_PER, 3)
			H.change_stat(STATKEY_SPD, 1)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 2, TRUE)
		if("Slurbow + Dagger")
			l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			beltl = /obj/item/quiver/bolts
			H.change_stat(STATKEY_PER, 3)
			H.change_stat(STATKEY_SPD, 1)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, 2, TRUE)
	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank_up_to(/datum/skill/magic/holy, 1, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank_up_to(/datum/skill/labor/farming, 1, TRUE)
		H.grant_language (/datum/language/beast)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank_up_to(/datum/skill/misc/reading, 3, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank_up_to(/datum/skill/labor/fishing, 2, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 1, TRUE)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		H.mind.special_items["Alt Tabard"] = /obj/item/clothing/cloak/templar/eoran/alt
	if(H.patron?.type == /datum/patron/divine/malum)
		H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, 1, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, 1, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/craft/smelting, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 5, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 4, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/music, 1, TRUE)

