/datum/job/roguetown/veteran
	title = "Veteran"
	flag = VETERAN
	department_flag = SIDEFOLK
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_OOZE)
	tutorial = "You've known combat your entire life. There isn't a way to kill a man you haven't practiced in the tapestries of war itself. You wouldn't call yourself a hero--those belong to the men left rotting in the fields where you honed your ancient trade. You don't sleep well at night anymore, you don't like remembering what you've had to do to survive. Trading adventure for stable pay was the only logical solution, and maybe someday you'll get to lay down the blade and rest your weary body..."
	allowed_ages = list(AGE_OLD)
	advclass_cat_rolls = list(CTAG_VETERAN = 20)
	display_order = JDO_VETERAN
	whitelist_req = TRUE
	give_bank_account = 35
	min_pq = 12
	max_pq = null
	round_contrib_points = 2
	same_job_respawn_delay = 30 MINUTES

	cmode_music = sound("sound/music/combat_veteran.ogg")
	job_subclasses = list(
		/datum/advclass/veteran/battlemaster,
		/datum/advclass/veteran/footman,
		/datum/advclass/veteran/calvaryman,
		/datum/advclass/veteran/merc,
		/datum/advclass/veteran/scout,
		/datum/advclass/veteran/spy
	)

/datum/outfit/job/roguetown/veteran
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/veteran/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/half/vet))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "veteran cloak ([index])"


/datum/advclass/veteran/battlemaster
	name = "Veteran Battlemaster"
	tutorial = "You have served under a hundred masters, some good, some bad. You were a general once. A marshal, a captain. To some a hero, others a monster. Something of the sorts. You made strategies, tactics, new innovations of war. A thousand new ways for one man to kill another. It still keeps you up at night."
	outfit = /datum/outfit/job/roguetown/vet/battlemaster
	cmode_music = sound("sound/music/cmode/towner/combat_retired.ogg")

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_BREADY, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 4,
		STATKEY_CON = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/maces = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vet/battlemaster
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/battlemaster/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	beltr = /obj/item/roguekey/veteran
	backr = /obj/item/storage/backpack/rogue/satchel/black
	cloak = /obj/item/clothing/cloak/half/vet
	belt = /obj/item/storage/belt/rogue/leather/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)

/datum/outfit/job/roguetown/vet/battlemaster/choose_loadout(mob/living/carbon/human/H)
	. = ..()

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Longsword","Sabre", "Mace")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Longsword")
				H.put_in_hands(new /obj/item/rogueweapon/sword/long)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L)
			if("Sabre")
				H.put_in_hands(new /obj/item/rogueweapon/sword/sabre)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L)
			if("Mace")
				H.put_in_hands(new /obj/item/rogueweapon/mace)
		var/retirement = list("Pursue Homesteading", "Dabble Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/advclass/veteran/footman
	name = "Fechtmaster"
	tutorial = "You have gained fame on the continent as a legendary swordsman. You are not a warrior in the conventional sense. You have not really participated in real battles, instead immersing yourself in competitions and duels. For you, wielding a weapon is a science to which you have devoted your long life. The local monarch has invited you to share your skill and wisdom with both his warriors and his courtiers. You specialize in swords and spears."
	outfit = /datum/outfit/job/roguetown/vet/footman

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_WIL = 3
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vet/footman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	head = /obj/item/clothing/head/roguetown/duelhat
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	l_hand = /obj/item/rogueweapon/sword/long/training
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/roguekey/veteran
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/shield/tower/metal
	r_hand = /obj/item/rogueweapon/spear/billhook
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/duelcape
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/manor,
		/obj/item/flashlight/flare/torch/lantern
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)
	H.adjust_blindness(-3)
	if(H.mind)
		var/retirement = list("Pursue Homesteading", "Dabble in Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your practice, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/advclass/veteran/calvaryman
	name = "Tarnished Knight"
	tutorial = "Once, you were part of the retinue of the local ruler, perhaps even serving his predecessor. But time spares no one, and so you were granted an honorable retirement, removed from regular service. Your influence at court has noticeably diminished, but it has not disappeared. You are still entrusted with the upbringing of the younger generation in the form of squires. Most likely, it will be your decision that will determine whether they receive a knighthood."
	outfit = /datum/outfit/job/roguetown/vet/calvaryman

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_GOODTRAINER, TRAIT_NOBLE)
	noble_income = 15
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 4,
		STATKEY_STR = 1,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/shields = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vet/calvaryman/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron
	pants = /obj/item/clothing/under/roguetown/platelegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/veteran = 1,
		/obj/item/roguekey/manor = 1,
		/obj/item/flashlight/flare/torch/lantern
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Longsword + Shield","Axe + Shield","Halberd", "Mace + Shield", "flail + Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Longsword + Shield")
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/tower/metal

			if("Axe + Shield")
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/tower/metal

			if ("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap

			if ("Mace + Shield")
				beltr = /obj/item/rogueweapon/mace/steel
				backl = /obj/item/rogueweapon/shield/tower/metal

			if("flail + Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower/metal

		var/retirement = list("Pursue Homesteading", "Dabble in Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/advclass/veteran/merc
	name = "Retired Mercenary"
	tutorial = "You were a sell-sword, a warrior of coin. Your pockets were never light, you always had a warm place to stay and food in your belly, but you knew that every battle could be your last. You're the last of your unit, and you can't help but regret it. You specialize in swords and polearms, or axes and polearms."
	outfit = /datum/outfit/job/roguetown/vet/merc

	subclass_languages = list(/datum/language/grenzelhoftian)
	cmode_music = sound("sound/music/combat_grenzelhoft.ogg")
	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/vet/merc
	has_loadout = TRUE

/datum/outfit/job/roguetown/vet/merc/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/grenzelhofthat
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/steel
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	beltl = /obj/item/rogueweapon/sword/short
	beltr = /obj/item/roguekey/veteran
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)

/datum/outfit/job/roguetown/vet/merc/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Zweihander","Halberd")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Zweihander")
				H.put_in_hands(new /obj/item/rogueweapon/greatsword/grenz)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			if("Halberd")
				H.put_in_hands(new /obj/item/rogueweapon/halberd)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 6, TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
		var/retirement = list("Pursue Homesteading", "Dabble in Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/advclass/veteran/scout
	name = "Retired Bogmaster"
	tutorial = "Even before the creation of the Wardens, it was you who maintained order in the local lands and swamps, preventing dangerous beasts from approaching the walls of the city. However, time passes, and the swamp guard has already been decommissioned. Nevertheless, your hunting and survival skills are still with you. Specialist in axes and bows."
	outfit = /datum/outfit/job/roguetown/vet/scout

	category_tags = list(CTAG_VETERAN)
	traits_applied = list(TRAIT_LONGSTRIDER, TRAIT_HOMESTEAD_EXPERT, TRAIT_OUTDOORSMAN, TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 3,
		STATKEY_CON = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/crossbows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/hunting = SKILL_LEVEL_LEGENDARY,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_LEGENDARY,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vet/scout/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	gloves = /obj/item/clothing/gloves/roguetown/cloth
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	shoes = /obj/item/clothing/shoes/roguetown/footwraps/padded
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	var/weapons = list("Long Bow", "Slurbow", "Crossbow")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Long Bow")
			beltl = /obj/item/quiver/arrows
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
		if("Slurbow")
			beltr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			beltl = /obj/item/quiver/bolt/light
		if("Crossbow")
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)
			beltl = /obj/item/quiver/bolt/standard
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/stoneaxe/woodcut/pick
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/half/vet
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/roguekey/veteran = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	add_verb(H, /mob/proc/haltyell)
	H.cmode_music = sound("sound/music/cmode/antag/combat_deadlyshadows.ogg")
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)
	H.adjust_blindness(-3)
	if(H.mind)
		var/retirement = list("Dabble in Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/advclass/veteran/spy
	name = "Ex-Spy"
	tutorial = "For many years, you devoted yourself to the secret service of the Hand. However, now you are old and cannot boast of your former agility and speed. Yet your skills as a professional spy and assassin are still with you. To whom will you offer them now? You specialize in knives, whips, and stealth."
	outfit = /datum/outfit/job/roguetown/vet/spy
	subclass_languages = list(/datum/language/thievescant)
	cmode_music = sound("sound/music/cmode/nobility/combat_spymaster.ogg")
	category_tags = list(CTAG_VETERAN)
	vice_limits = list(/datum/charflaw/silverweakness)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_CICERONE, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_CON = 1,
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/knives = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vet/spy/pre_equip(mob/living/carbon/human/H)
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/leather/cuirass
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	beltl = /obj/item/rogueweapon/whip/bronze
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/veteran = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/lockpickring/mundane,
		/obj/item/grapplinghook,
		)
	add_verb(H, /mob/proc/haltyell)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Retirement.", mint_new = TRUE, mint_label = "Retirement savings", income_acct = LEDGER_CITIZEN_ESTATE)
	H.adjust_blindness(-3)
	if(H.mind)
		var/retirement = list("Pursue Homesteading", "Dabble in Smithing", "Write an autobiography")
		var/retirement_choice = input(H, "During your retirement, you decided to...", "PICK A HOBBY.") as anything in retirement
		switch(retirement_choice)
			if("Pursue Homesteading")
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Dabble in Smithing")
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Write an autobiography")
				ADD_TRAIT(H, TRAIT_GOODWRITER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)