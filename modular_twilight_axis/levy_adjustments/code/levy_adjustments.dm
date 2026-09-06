/datum/advclass/levy
	name = "Levy"
	tutorial = "When the Bailiff came knocking for you, it was the worst dae of your lyfe. Hastily pressed into the Crown's service with little more than a helmet, a household tool turned weapon and a bottle of beer for comfort, you joined the Levy squad.<br><br>As one of Azurea's so-called \"folk-heroes\", you are first to answer a peasant's reports of danger beyond the walls. Find the problem and solve it yourself or, if dire, send word for backup, and hold the line until the Armsmen or Wardens arrive to earn their keep."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)

	outfit = /datum/outfit/job/roguetown/adventurer/levy
	traits_applied = list(TRAIT_LEVY, TRAIT_HOMESTEAD_EXPERT)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_TOWNER)
	townie_contract_gate_exempt = TRUE
	maximum_possible_slots = 5 // They're still Towners who contribute to the econ, even when not fighting or bog-larping.
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/levy/pre_equip(mob/living/carbon/human/H)
	..()
	if(!H)
		return
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/pick/bronze
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife/triumph = 1,
		/obj/item/signal_horn = 1,
	)


	to_chat(H, span_notice("<b>WHO YOU WERE BEFORE THE LEVY?</b>"))

	to_chat(H, span_info("<b>AN AVERAGE JOE, SER!!</b><br>\
	Traits: None.<br>\
	Final Stats: + 1 PER, +1 CON, +1 SPD, -1 INT.<br><br>\
	Skills: No extras.<br>\
	Equipment: None.<br><br>"))

	to_chat(H, span_info("<b>A TOUGH SOD, SER!!</b><br>\
	Traits: None.<br>\
	Final Stats: +1 CON, +1 STR, +1 WIL, -1 INT, -1 SPD.<br>\
	Skills: No extras.<br>\
	Equipment: None.<br>"))

	to_chat(H, span_info("<b>A SKINNY WIMP, SER!!</b><br>\
	Traits: None.<br>\
	Final Stats: -1 CON, -1 STR, +1 PER, +1 SPD.<br>\
	Skills: No extras.<br>\
	Equipment: None.<br><br>"))

	to_chat(H, span_info("<b>A SMART COOKIE, SER!!</b><br>\
	Traits: None.<br>\
	Final Stats: +1 INT, +1 WIL, -1 SPD, -1 STR.<br>\
	Equipment: None.<br><br>"))

	if(H.mind)
		var/list/specialties = list(
			"AN AVERAGE JOE, SER!!",
			"A TOUGH SOD, SER!!",
			"A SKINNY WIMP, SER!!",
			"A SMART COOKIE, SER!!",
		)
		var/specialty_choice = tgui_input_list(H, "What type of a Peasant were ya'?", "FIT BEFORE THE LEVY?", specialties)
		if(QDELETED(H))
			return
		if(!specialty_choice)
			specialty_choice = "AN AVERAGE JOE, SER!!"
		switch(specialty_choice)

			if("AN AVERAGE JOE, SER!!")
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_INT, -1)

			if("A TOUGH SOD, SER!!")
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, -1)
				H.change_stat(STATKEY_SPD, -1)

			if("A SKINNY WIMP, SER!!")
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, 1)

			if("A SMART COOKIE, SER!!")
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_SPD, -1)

	to_chat(H, span_notice("<b>THE WEAPON I COULD SCROUNGE UP:</b>"))
	to_chat(H, span_info("<b>THE FAMILY SWORD</b> - Journeyman Swords. Comes with a militia falchion."))
	to_chat(H, span_info("<b>A BIG KNIFE</b> - Journeyman Daggers. Comes with a Combat Knife."))
	to_chat(H, span_info("<b>THE LEGENDARY BOG-STICK</b> - Journeyman Maces. Comes with a militia club."))
	to_chat(H, span_info("<b>AN OLDE CATTLE LASH</b> - Journeyman Whips & Flails. Comes with a whip."))
	to_chat(H, span_info("<b>THE FINEST PITCHFORK</b> - Journeyman Polearms. Comes with a militia spear."))
	to_chat(H, span_info("<b>THE GOOD DAE'S GREETINGS</b> - Journeyman Polearms. Comes with a militia Goedendag."))
	to_chat(H, span_info("<b>MINE THRESHER</b> - Journeyman Whips & Flails. Comes with a militia flail."))
	to_chat(H, span_info("<b>A GOOD SHOVEL</b> - Journeyman Axes. Comes with a militia greataxe."))
	to_chat(H, span_info("<b>THE MINER'S PICKAXE</b> - Journeyman Mining. Comes with a militia pickaxe."))
	to_chat(H, span_info("<b>MINE SCYTHE</b> - Journeyman Farming. Comes with a militia scythe."))
	to_chat(H, span_info("<b>THE WHOLE KITCHEN</b> - Journeyman Cooking and Knives. Comes with a mess kit and cleaver."))
	to_chat(H, span_info("<b>THESE GODS-GIVEN FISTS</b> - Journeyman Unarmed & Wrestling. Comes with handwraps."))

	if(H.mind)
		var/list/weapons = list(
			"THE FAMILY SWORD (Sword)",
			"A BIG KNIFE (Dagger)",
			"THE LEGENDARY BOG-STICK (Club)",
			"THE BOGMAN'S BOW (Sling)",
			"AN OLDE CATTLE LASH (Whip)",
			"THE FINEST PITCHFORK (Polearm)",
			"THE GOOD DAE'S GREETINGS (Polearm)",
			"MINE THRESHER (Flail)",
			"MINE WAR THRESHER (Flail, 2H)",
			"A GOOD SHOVEL (Axe)",
			"THE MINER'S PICKAXE (Pickaxe)",
			"MINE SCYTHE (Scythe)",
			"THE RELIABLE VOLFKILLER (Staff)",
			"THE WHOLE KITCHEN (Mess Kit + Cleaver)",
			"THESE GODS-GIVEN FISTS (Unarmed & Wrestling)",
		)

		var/weapon_choice = tgui_input_list(H, "Choose what you could nab and turn into a weapon.", "WHAT IS YOUR WEAPON?", weapons)
		if(QDELETED(H))
			return
		if(!weapon_choice)
			weapon_choice = "THE FAMILY SWORD (Sword)"
		H.set_blindness(0)
		gloves = /obj/item/clothing/gloves/roguetown/leather
		switch(weapon_choice)

			if ("THE FAMILY SWORD (Sword)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
	
				backr = /obj/item/rogueweapon/scabbard/sword

			if ("THE LEGENDARY BOG-STICK (Club)")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/woodclub
	

			if ("AN OLDE CATTLE LASH (Whip)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/whip
	

			if("THE FINEST PITCHFORK (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/militia
	
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if("MINE THRESHER (Flail)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/militia
	

			if("MINE WAR THRESHER (Flail, 2H)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail
				backr = /obj/item/rogueweapon/scabbard/gwstrap
	

			if("THE GOOD DAE'S GREETINGS (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/militia
				backr = /obj/item/rogueweapon/scabbard/gwstrap
	

			if ("A GOOD SHOVEL (Axe)")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/militia
	
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if ("THE MINER'S PICKAXE (Pickaxe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/militia
	

			if ("MINE SCYTHE (Scythe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/scythe
	
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if ("A BIG KNIFE (Dagger)")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/combat/iron
				backr = /obj/item/rogueweapon/scabbard/sheath
	

			if ("THE WHOLE KITCHEN (Mess Kit + Cleaver)")
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/storage/gadget/messkit
				l_hand = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
	

			if ("THE BOGMAN'S BOW (Sling)")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
	
				r_hand = /obj/item/quiver/sling/iron
				l_hand = /obj/item/quiver/sling/iron
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling

			if ("THE RELIABLE VOLFKILLER (Staff)")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
	
				backr = /obj/item/rogueweapon/woodstaff/quarterstaff

			if ("THESE GODS-GIVEN FISTS (Unarmed & Wrestling)")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted

		var/helmets = list(
		"Nasal Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
		"Leather Helmet"	= /obj/item/clothing/head/roguetown/helmet/leather,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"Chain coif"		= /obj/item/clothing/neck/roguetown/chaincoif/iron,
		"None"
		)
		var/helmchoice = tgui_input_list(H, "Choose yer nogginpad.", "TAKE UP HELMS", helmets)
		if(helmchoice && helmchoice != "None")
			head = helmets[helmchoice]

	if(H.mind)
		var/tabards = list("Levy Tabard", "Levy hood")
		var/tabard_choice = tgui_input_list(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.", tabards)
		if(QDELETED(H))
			return
		if(!tabard_choice)
			tabard_choice = "Levy Tabard"
		switch(tabard_choice)
			if("Levy Tabard")
				cloak = /obj/item/clothing/cloak/tabard/stabard/bog/levy
			if("Levy hood")
				cloak = /obj/item/clothing/cloak/tabard/stabard/bog/levy/hood

	if(H.mind)
		var/armor_options = list("Leather Armor.", "Gambeson Armor.")
		var/armor_choice = tgui_input_list(H, "Put your clothes on!.", "TAKE UP ARMAMENTS!", armor_options)
		if(QDELETED(H))
			return
		if(!armor_choice)
			armor_choice = "Gambeson Armor."

		switch(armor_choice)
			if("Leather Armor.")
				armor = /obj/item/clothing/suit/roguetown/armor/leather
				pants = /obj/item/clothing/under/roguetown/tights

			if("Gambeson Armor.")
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson
				pants = /obj/item/clothing/under/roguetown/trou/leather

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)
