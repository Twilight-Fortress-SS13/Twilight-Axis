/datum/job/roguetown/orthodoxist/New()
	job_subclasses += list(/datum/advclass/blackpowder_legionnaire)
	. = ..()

/datum/advclass/blackpowder_legionnaire
	name = "Blackpowder Legionnaire"
	tutorial = "In the Blackpowder Order, every fourth soldier is a sharpshooter, armed with advanced Otavan firearms. These Legionnaires are the very essence of the everchanging face of warfare, and when the Final War begins, it is with their power that the evil will be driven back."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/blackpowder_legionnaire
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg'
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(TRAIT_PSYDONITE)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose between light and medium armor options, gaining Dodge Expert or Maille Training, respectively."

/datum/outfit/job/roguetown/blackpowder_legionnaire
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/blackpowder_legionnaire/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	cloak = /obj/item/clothing/cloak/tabard/psydontabard
	neck = /obj/item/clothing/neck/roguetown/leather/blackpowder
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/silver

	if(H.mind)
		var/weapons = list("Purgatory (Handcannon)", "Runelock Pistol")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Purgatory (Handcannon)")
				belt = /obj/item/storage/belt/rogue/leather/black
				l_hand = /obj/item/gun/ballistic/twilight_firearm/handgonne/purgatory
				backpack_contents = list(/obj/item/roguekey/inquisition = 1,
				/obj/item/paper/inqslip/arrival/ortho = 1,
				/obj/item/twilight_powderflask/holyfyre = 1,
				/obj/item/natural/bundle/fibers/full = 1,
				/obj/item/storage/belt/rogue/pouch/coins/mid = 1)
				var/quivers = list("Grapeshot", "Cannonballs")
				var/ammochoice = input(H,"Choose your MUNITIONS.", "TAKE UP PSYDON'S MISSILES.") as anything in quivers
				switch(ammochoice)
					if("Grapeshot")
						beltr = /obj/item/quiver/twilight_bullet/cannonball/grapeshot
					if("Cannonballs")
						beltr = /obj/item/quiver/twilight_bullet/cannonball/lead
			if("Runelock Pistol")
				belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
				beltr = /obj/item/quiver/twilight_bullet/runed
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock
				backpack_contents = list(/obj/item/roguekey/inquisition = 1,
				/obj/item/paper/inqslip/arrival/ortho = 1,
				/obj/item/storage/belt/rogue/pouch/coins/mid = 1)
		var/armors = list("Medium Armor", "Light Armor")
		var/armor_choice = input(H, "Choose your ARMOR.", "TAKE UP PSYDON'S MANTLE.") as anything in armors
		switch(armor_choice)
			if("Medium Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
				pants = /obj/item/clothing/under/roguetown/chainlegs
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			if("Light Armor")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/short/psy
