/datum/job/roguetown/royal_sergeant
	title = "Royal Guard Sergeant"
	flag = ROYALSERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Большую часть своей жизни ты прослужил в лейб-гвардии Его Величества и тебе была удостоина величайшая честь вести твоих товарищей в бой во славу Короны, \
	хоть и первостепенной твоей целью является защита дворца, семьи монарха и его свиты на этом проклятом острове.  \
	Местные глупцы считают Барона еще ЖИВЫМ, когда ты прекрасно знаешь, что он МЕРТВ, иначе быть и не может. \
	Твой долг не дать Королевской династии пасть, во имя будущего Энигмы."
	display_order = JDO_ROYALSERGEANT
	selection_color = JCOLOR_GARRISON
	whitelist_req = TRUE
	round_contrib_points = 3

	advclass_cat_rolls = list(CTAG_ROYALSERGEANT = 20)

	give_bank_account = TRUE
	min_pq = 8
	max_pq = null
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_HEAVYARMOR)
	job_subclasses = list(
		/datum/advclass/sergeant/royal_sergeant
	)
	same_job_respawn_delay = 30 MINUTES
	
/datum/job/roguetown/royal_sergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(ishuman(L))
			if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/guard))
				var/obj/item/clothing/S = H.cloak
				var/index = findtext(H.real_name, " ")
				if(index)
					index = copytext(H.real_name, 1,index)
				if(!index)
					index = H.real_name
				S.name = "sergeant surcoat ([index])"

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/royal_sergeant
	job_bitflag = BITFLAG_GARRISON
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/tabard/stabard/guard
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	id = /obj/item/scomstone/garrison
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/sergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_hornn/red = 1,
		)

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/sergeant/royal_sergeant
	name = "Royal Guard Sergeant"
	tutorial = "You are a not just anybody but the Sergeant-at-Arms of the Duchy's garrison. While you may have started as some peasant or mercenary, you have advanced through the ranks to that of someone who commands respect and wields it. Take up arms, sergeant!"
	outfit = /datum/outfit/job/roguetown/royal_sergeant/sergeant

	category_tags = list(CTAG_ROYALSERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 3,
		STATKEY_CON = 2,//Glorified footman
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //John Athlete apparently
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/royal_sergeant/sergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard) // We'll just use Watchmen as sorta conscripts yeag?
	H.verbs |= list(/mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Flail & Kite Shield","Axe & Kite Shield","Halberd & Heater","Longsword & Crossbow","Sabre & Kite Shield", "Sabre & Pistol")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Flail & Kite Shield")
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
				H.change_stat(STATKEY_STR, 2)
			if("Axe & Kite Shield")
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/stoneaxe/battle
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
				H.change_stat(STATKEY_STR, 2)
			if("Halberd & Heater")
				r_hand = /obj/item/rogueweapon/halberd
				l_hand = /obj/item/rogueweapon/sword
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/shield/heater
				beltl = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
				H.change_stat(STATKEY_STR, 1)
			if("Longsword & Crossbow")
				beltl = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/long
				l_hand = /obj/item/rogueweapon/scabbard/sword
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_PER, 1)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
			if("Sabre & Kite Shield")
				backl = /obj/item/rogueweapon/shield/tower/metal
				r_hand = /obj/item/rogueweapon/sword/sabre
				l_hand = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/mace/cudgel
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_PER, 1)
			if("Sabre & Pistol")
				backl = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/twilight_powderflask
				l_hand = /obj/item/rogueweapon/scabbard/sword
				beltl = /obj/item/quiver/twilight_bullet/lead
				beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
				H.change_stat(STATKEY_PER, 2)
				H.adjust_skillrank_up_to(/datum/skill/combat/twilight_firearms, 4, TRUE)

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Scalemail"	= /obj/item/clothing/suit/roguetown/armor/plate/scale,
			"Half-plate" = /obj/item/clothing/suit/roguetown/armor/plate,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Klappvisier Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)

		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
