/datum/job/roguetown/manorguard/New()
	job_subclasses += list(/datum/advclass/manorguard/twilight_grenadier)
	. = ..()

/datum/advclass/manorguard/twilight_grenadier
	name = "Grenadier"
	tutorial = "You are a professional soldier of the realm, specializing in revolutionary gunpowder weaponry. There are many men who can block a blade, but you're yet to find one who can block a bullet."
	outfit = /datum/outfit/job/roguetown/manorguard/twilight_grenadier
	maximum_possible_slots = 2
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_ARTILLERY_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/manorguard/twilight_grenadier/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	beltl = /obj/item/rogueweapon/scabbard/sheath

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Arquebus Rifle","Culverin")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_options = list("Brigandine Armor", "Cuirass Armor")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Arquebus Rifle")
				beltr = /obj/item/quiver/twilight_bullet/lead
				backl = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet
			if("Culverin")
				beltr = /obj/item/quiver/twilight_bullet/cannonball/grapeshot
				backl = /obj/item/gun/ballistic/twilight_firearm/handgonne
				backpack_contents += list(/obj/item/natural/bundle/fibers/full = 1)

		switch(armor_choice)
			if("Brigandine Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Cuirass Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		var/helmets = list(
		"Simple Helmet" = /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" = /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" = /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/manatarms = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			/obj/item/twilight_powderflask = 1
			)
		add_verb(H, /mob/proc/haltyell)

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
