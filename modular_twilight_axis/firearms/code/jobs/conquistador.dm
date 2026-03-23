/datum/advclass/mercenary/twilight_conquistador
	name = "Сonquistador Adelantado"
	tutorial = "A fallen etruscan grandee and a hardened veteran of the Lirvas colonization. Tempered by the deadly wilds and terrors of the eastern jungles, he reclaims his lost glory through rapier and pistol, forging a path for the crown amidst gunpowder and cold steel."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(\
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
	traits_applied = list(TRAIT_FIREARMS_MARKSMAN, TRAIT_DODGEEXPERT, TRAIT_NOBLE)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
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

/datum/outfit/job/roguetown/mercenary/twilight_conquistador/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_blindness(-3)
	H.set_blindness(0)
	to_chat(H, span_warning("You came to these lands in search of gold, and you don't care how or by what means it is obtained"))
	beltl = /obj/item/quiver/twilight_bullet/lead
	beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
	backl = /obj/item/storage/backpack/rogue/satchel/black
	r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft/gunslinger
	gloves = /obj/item/clothing/gloves/roguetown/leather
	cloak = /obj/item/clothing/cloak/duelcape
	head = /obj/item/clothing/head/roguetown/helmet/sallet/morion
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
	neck = /obj/item/clothing/neck/roguetown/gorget
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
	backr = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(/obj/item/roguekey/mercenary = 1, /obj/item/twilight_powderflask = 1, /obj/item/rogueweapon/huntingknife/idagger/navaja = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/clothing/head/roguetown/duelhat/etrusca = 1, /obj/item/lockpickring/mundane = 1)
