/datum/advclass/ranger/twilight_hunter
	name = "Blackpowder Hunter"
	tutorial = "As gunpowder becomes more widespread accross Psydonia, so do the Gunslingers - those who earn their living through their skill with those advanced weapons. But you are not one of 'em, you are just a wanderer with the weapon of new times. You are too young or too old to learn properly how to use effectively"
	outfit = /datum/outfit/job/roguetown/adventurer/twilight_hunter
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowderhunter.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/twilight_hunter/pre_equip(mob/living/carbon/human/H)
	..()
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/quiver/twilight_bullet/lead
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/recipe_book/survival = 1, 
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/twilight_powderflask = 1,
	)
	var/classes = list("Noble", "Peasant")
	var/class_choice = input("Choose your archetypes", "Available archetypes") as anything in classes

	switch(class_choice)
		if("Noble")
			to_chat(H, span_purple("'..Ох, твои прародители явно постарались дабы получить благословение Астраты, не опозорь их.. А, ты уже..как ты умудрился загнать досмерти свою лошадь?..'"))
			var/helmets = list(
				"Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
				"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron,
				"Kettle Helmet"		= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
				"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
				"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
				"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron,
				"None"
				)
			var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
			if(helmchoice != "None")
				head = helmets[helmchoice]
			cloak = /obj/item/clothing/cloak/raincloak/green
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
			belt = /obj/item/storage/belt/rogue/leather/battleskirt/black
			pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
			wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			gloves = /obj/item/clothing/gloves/roguetown/angle
			backl = /obj/item/gun/ballistic/twilight_firearm/hunt_arquebus
			H.put_in_hands(new /obj/item/natural/feather(H), TRUE)
			H.put_in_hands(new /obj/item/natural/cloth(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
		if("Peasant")
			to_chat(H, span_purple("'..Та-ак... ты выбрал быть простым охотником. У тебя есть хороший потенциал в будущем!..'"))
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/clothing/neck/roguetown/leather
			backl = /obj/item/gun/ballistic/twilight_firearm/barker
			gloves = /obj/item/clothing/gloves/roguetown/fingerless
			pants = /obj/item/clothing/under/roguetown/trou/leather
			shoes = /obj/item/clothing/shoes/roguetown/boots
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			head = /obj/item/clothing/head/roguetown/hatfur
			H.put_in_hands(new /obj/item/natural/bundle/fibers/full(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/twilight_firearms, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
