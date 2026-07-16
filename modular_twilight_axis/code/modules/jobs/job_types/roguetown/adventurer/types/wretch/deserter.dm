/datum/advclass/wretch/deserter/generic
	name = "Militant"
	tutorial = "It matters not what cause you swing your weapon for, in the end you fight the same way your ancestors and their ancestors did: clad in metal and intimately intertwined with gore and death."
	outfit = /datum/outfit/job/roguetown/wretch/desertergeneric
	maximum_possible_slots = -1

	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wretch/desertergeneric/pre_equip(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		if(!weapon_choice)
			weapon_choice = weapons[1]
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Sabre & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				backl = /obj/item/quiver/bolt/standard
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorders)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/helmets = list(
			"Simple Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"Bascinet Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"Sallet Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/sallet,
			"Winged Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/winged,
			"Grenzelhoftian Plume Hat"	= /obj/item/clothing/head/roguetown/grenzelhofthat,
			"Steel Shishak" 			= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"Gronnic Ownel Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
			"Varangian Owl Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi,
			"Kulah Khud"				= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen,
			"Jingasa"					= /obj/item/clothing/head/roguetown/helmet/kettle/jingasa,
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(!helmchoice)
			helmchoice = "Simple Helmet"
		head = helmets[helmchoice]

		var/armors = list("Brigandine Set", "Maille Set", "Cuirass Set", "Grenzelhoftian Set", "Steppesman Set", "Gronnic Set", "Varangian Set", "Raneshen Set", "Kazengunite Set", "Otavan Set")
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		if(!armorchoice)
			armorchoice = "Brigandine Set"
		switch(armorchoice)
			if("Brigandine Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Maille Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/chainlegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Cuirass Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/chainlegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Grenzelhoftian Set")
				neck = /obj/item/clothing/neck/roguetown/gorget
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
				shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
			if("Steppesman Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
			if("Gronnic Set")
				neck = /obj/item/clothing/neck/roguetown/leather
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/chainlegs/gronn
				wrists = /obj/item/clothing/wrists/roguetown/bracers/splint
				gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			if("Varangian Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			if("Raneshen Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif/full
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
			if("Kazengunite Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				gloves = /obj/item/clothing/gloves/roguetown/plate/kote
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
			if("Otavan Set")
				neck = /obj/item/clothing/neck/roguetown/fencerguard
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/otavan
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
		var/specialization = list("Offence & Defence", "Mobility & Ranged Combat", "Cavalry", "Field Medicine", "Faith", "Leadership")
		var/specialization_choice = input (H, "Choose your primary training.", "HOW DO YOU KILL?") as anything in specialization
		if(!specialization_choice)
			specialization_choice = "Offence & Defence"
		switch(specialization_choice)
			if("Offence & Defence")
				cloak = /obj/item/clothing/cloak/tabard/stabard
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("You trained to fight as a part of dense infantry formations. This made you fit, but you didn't have a chance to pick up any other skills."))
			if("Mobility & Ranged Combat")
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				beltl = /obj/item/quiver/javelin/steel
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, 1)
				to_chat(H, span_warning("You trained to fight in loose formations, harassing your foes from afar with throwing weapons and swift attacks."))
			if("Cavalry")
				cloak = /obj/item/clothing/cloak/tabard
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_PER, 1)
				H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
				to_chat(H, span_warning("You trained in equestrianism, fighting atop mighty steeds and raising yourself above common infantry."))
			if("Field Medicine")
				cloak = /obj/item/clothing/suit/roguetown/shirt/robe/feld
				beltl = /obj/item/storage/belt/rogue/surgery_bag
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_INT, 2)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("You were a field chirurgeon, a healer rather than a killer. In time, you learned how to murder and became both."))
			if("Faith")
				cloak = /obj/item/clothing/cloak/cape/crusader
				beltl = /obj/item/clothing/neck/roguetown/psicross
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 1)
				var/datum/devotion/C = new /datum/devotion(H, H.patron)
				C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
				to_chat(H, span_warning("Your training in combat was merely a step in your path to becoming a living weapon of your deity."))
			if("Leadership")
				cloak = /obj/item/clothing/cloak/tabard/stabard
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 1)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
				to_chat(H, span_warning("You trained how to organise and lead your fellow fighters into battles."))
		var/crimes = list("I'm nobody", "They fear me")
		var/crimeschoice = input(H, "Who am I?", "How much have I done?") as anything in crimes
		if(!crimeschoice)
			crimeschoice = "I'm nobody"
		wretch_select_bounty(H)
		if(crimeschoice == "They fear me")
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, 1)

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)
