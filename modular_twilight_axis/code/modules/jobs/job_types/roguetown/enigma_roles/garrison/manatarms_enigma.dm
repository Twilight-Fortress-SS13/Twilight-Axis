/datum/job/roguetown/royal_guard
	title = "Royal Guard"
	flag = ROYALGUARD
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4 //Not getting filled either way

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED)
	tutorial = "Доказав свою преданность и способности, вы получили смысл жизни - защищать Королевскую семью и её двор в качестве лейб-гвардейца. \
				Вы непосредственно подчиняетесь своему сержанту лейб-гвардии. Если вы регулярно проходите обучение боевым и осадным действиям, у вас есть небольшой шанс пережить правление Короля.\
				Умереть в составе лейб-гвардии Его Высочества - большая честь, маршал напоминает вам об этом каждую ночь."
	display_order = JDO_ROYALGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/royal_guard
	advclass_cat_rolls = list(CTAG_ROYALGUARD_ENIGMA = 20)

	give_bank_account = TRUE
	min_pq = 8
	max_pq = null
	round_contrib_points = 2
	same_job_respawn_delay = 30 MINUTES

	cmode_music = 'modular_twilight_axis/sound/music/combat/combat_retinue.ogg'
	job_subclasses = list(
		/datum/advclass/royal_guard/footsman,
		/datum/advclass/royal_guard/skirmisher,

		/datum/advclass/royal_guard/standard_bearer,

	)

/datum/outfit/job/roguetown/royal_guard
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/royal_guard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "royal guard surcoat ([index])"

/datum/outfit/job/roguetown/royal_guard
	cloak = /obj/item/clothing/cloak/tabard/stabard/guard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

// Melee goon
/datum/advclass/royal_guard/footsman
	name = "Retinue Footman"
	tutorial = "Вы - член королевской дружины. Обеспечьте безопасность Короля и его жителей, защитите власть предержащих от ужасов внешнего мира и сохраните Королевству Энигму."
	outfit = /datum/outfit/job/roguetown/royal_guard/footsman

	category_tags = list(CTAG_ROYALGUARD_ENIGMA)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,// seems kinda lame but remember guardsman bonus!!
		STATKEY_INT = 1,
		STATKEY_CON = 3, //Like other footman classes their main thing is constitution more so than anything else
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/royal_guard/footsman
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/chain
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/manatarms = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)

/datum/outfit/job/roguetown/royal_guard/footsman/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Axe & Shield","Sword & Shield","Halberd & Sword","Greataxe & Sword")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/battle
				backl = /obj/item/rogueweapon/shield/iron
			if("Sword & Shield")
				l_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/iron
			if("Halberd & Sword")
				l_hand = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Greataxe & Sword")
				l_hand = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sword
		var/riding = list("I love saiga (your pet with you)", "I walk on my legs (+1 for athletics)")
		var/ridingchoice = input(H, "Choose your faith", "FAITH") as anything in riding
		switch(ridingchoice)
			if("I love saiga (your pet with you)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("I walk on my legs (+1 for athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)		
	H.verbs |= /mob/proc/haltyell

	if(H.mind)

		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/royal_guard/skirmisher
	name = "Retinue Skirmisher"
	tutorial = "Вы - член королевской дружины. Обеспечьте безопасность Короля и его жителей, защитите власть предержащих от ужасов внешнего мира и сохраните Королевству Энигму."
	outfit = /datum/outfit/job/roguetown/royal_guard/skirmisher

	category_tags = list(CTAG_ROYALGUARD_ENIGMA)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_SPD = 2,
		STATKEY_PER = 3,
		STATKEY_WIL = 2
	)
	traits_applied = list(TRAIT_ARTILLERY_EXPERT)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Chooses between Light Armor (Dodge Expert) & Medium Armor."

/datum/outfit/job/roguetown/royal_guard/skirmisher
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/combat/messser = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/manatarms = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/outfit/job/roguetown/royal_guard/skirmisher/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Crossbow","Bow","Sling", "Arquebus Pistol", "Arquebus Rifle")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_options = list("Maille Set(Medium Armor)", "Brigandine Armor(Expert Dodger)")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Crossbow")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Bow")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Sling")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			if("Arquebus Pistol")
				beltr = /obj/item/quiver/twilight_bullet/lead
				r_hand = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
				l_hand = /obj/item/twilight_powderflask
			if("Arquebus Rifle")
				beltr = /obj/item/quiver/twilight_bullet/lead
				r_hand = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet
				l_hand = /obj/item/twilight_powderflask
		switch(armor_choice)
			if("Maille Set(Medium Armor)")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Brigandine Armor(Expert Dodger)")
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

		H.verbs |= /mob/proc/haltyell

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

/datum/advclass/royal_guard/standard_bearer
	name = "Retinue Standard Bearer"
	tutorial = "Ты тот, кому была удостоена честь нести знамя Королества. \
	Вдохновляй своих товарищей на подвиги во имя Короля."
	outfit = /datum/outfit/job/roguetown/royal_guard/standard_bearer
	category_tags = list(CTAG_ROYALGUARD_ENIGMA)
	traits_applied = list(TRAIT_STANDARD_BEARER, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2, // seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 1

/datum/outfit/job/roguetown/royal_guard/standard_bearer
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	wrists =/obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/chainlegs
	r_hand = /obj/item/rogueweapon/spear/keep_standard
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/manatarms = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/outfit/job/roguetown/royal_guard/standard_bearer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	H.verbs |= /mob/proc/haltyell
