/datum/advclass/mercenary/twilight_conquistador
	name = "Сonquistador Adelantado"
	tutorial = "A fallen etruscan grandee and a hardened veteran of the Lirvas colonization. Tempered by the deadly wilds and terrors of the eastern jungles, he reclaims his lost glory through rapier and pistol, forging a path for the crown amidst gunpowder and cold steel."
	allowed_sexes = list(MALE, FEMALE)
	var/list/allowed_races = list(\
	/datum/species/human/northern,\
	/datum/species/aasimar,\
	/datum/species/anthromorph,\
	/datum/species/demihuman,\
	/datum/species/aura,\
	/datum/species/tieberian,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/dark/raider,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_conquistador
	maximum_possible_slots = 2
	min_pq = 25 // Все мерки в данный момент с 25 открываются
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_conquistador.ogg'
	class_select_category = CLASS_CAT_ETRUSCA
	subclass_languages = list(/datum/language/etruscan)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_NOBLE)
	classes = list("Tercio" = "Волею судьбы ваш путь лежал в авангарде, вместе с вашей верной алебардой.",
					"Hidalgo" = "Волею судьбы ваш путь связан с порохом и дестрезой.")
	extra_context = "Класс не имеет изначальных характеристик поскольку все его характеристики выдаются после выбора сабкласса. Сабкласс Tercio - это сабкласс имеющий Medium Armor и алебарду; Сабкласс Hidalgo - это класс имеющий Dodge Expert и пистоль с рапирой."
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/advclass/mercenary/twilight_conquistador/New()
	..()
	forbidden_races = ALL_RACES_TYPES - allowed_races

/datum/outfit/job/roguetown/mercenary/twilight_conquistador/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	H.set_blindness(0)
	var/classes = list("Tercio (Medium Armor & Halberd)","Hidalgo (Light Armor & Rapier + Pistol)")
	var/classchoice = input("Choose your style", "Available styles") as anything in classes

	switch(classchoice)
		if("Tercio (Medium Armor & Halberd)")
			H.set_blindness(0)
			to_chat(H, span_warning("Волею судьбы ваш путь лежал в авангарде, вместе с вашей верной алебардой."))
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_PER, 2)
			H.change_stat(STATKEY_CON, 3)
			H.change_stat(STATKEY_WIL, 2)
			r_hand = /obj/item/rogueweapon/halberd
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			backl = /obj/item/storage/backpack/rogue/satchel/black
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft/gunslinger
			gloves = /obj/item/clothing/gloves/roguetown/plate
			cloak = /obj/item/clothing/cloak/duelcape
			head = /obj/item/clothing/head/roguetown/helmet/sallet/morion
			pants = /obj/item/clothing/under/roguetown/chainlegs
			wrists = /obj/item/clothing/wrists/roguetown/bracers
			belt = /obj/item/storage/belt/rogue/leather
			neck = /obj/item/clothing/neck/roguetown/gorget
			shirt = /obj/item/clothing/suit/roguetown/shirt/padedetrshirt
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/etrcuirass
			mask = /obj/item/clothing/mask/rogue/facemask/etrmask
			backl = /obj/item/storage/backpack/rogue/satchel/black
			backpack_contents = list(/obj/item/roguekey/mercenary = 1, /obj/item/rogueweapon/huntingknife/idagger/navaja = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/clothing/head/roguetown/duelhat/etrusca = 1, /obj/item/lockpickring/mundane = 1)
			H.set_blindness(0)
		if("Hidalgo (Light Armor & Rapier + Pistol)")
			to_chat(H, span_warning("Волею судьбы ваш путь связан с порохом и дестрезой."))
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/twilight_firearms, 5, TRUE)
			H.change_stat(STATKEY_SPD, 3)
			H.change_stat(STATKEY_INT, 2)
			H.change_stat(STATKEY_PER, 3)
			ADD_TRAIT(H, TRAIT_FIREARMS_MARKSMAN, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			beltl = /obj/item/quiver/twilight_bullet/lead
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
			shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft/gunslinger
			gloves = /obj/item/clothing/gloves/roguetown/leather
			cloak = /obj/item/clothing/cloak/duelcape
			head = /obj/item/clothing/head/roguetown/helmet/sallet/morion
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
			wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
			belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
			neck = /obj/item/clothing/neck/roguetown/gorget
			shirt = /obj/item/clothing/suit/roguetown/shirt/padedetrshirt
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
			backl = /obj/item/storage/backpack/rogue/satchel/black
			backpack_contents = list(/obj/item/roguekey/mercenary = 1, /obj/item/twilight_powderflask = 1, /obj/item/rogueweapon/huntingknife/idagger/navaja = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/clothing/head/roguetown/duelhat/etrusca = 1, /obj/item/lockpickring/mundane = 1)
