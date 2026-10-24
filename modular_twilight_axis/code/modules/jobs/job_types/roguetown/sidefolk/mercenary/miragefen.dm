/datum/advclass/mercenary/twilight_miragefen_rogue
	name = "Miragefen Rogue"
	tutorial = "With their eloquence and thieving skills, some Tabaxi from Miragefen began offering their services to obtain necessary items or assist in combat due to their agility."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_miragefen_rogue
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 3
	cmode_music = sound("modular_twilight_axis/sound/music/combat_tabaxi.ogg")
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 1,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = -1
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass is race-limited to: Tabaxi Only."

/datum/advclass/mercenary/twilight_miragefen_rogue/New()
	..()
	forbidden_races = ALL_RACES_TYPES - /datum/species/tabaxi

/datum/outfit/job/roguetown/mercenary/twilight_miragefen_rogue/pre_equip(mob/living/carbon/human/H) //Без защиты рук и лап, хех, кошки в сапожках...
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("With their eloquence and thieving skills, some Tabaxi from Miragefen began offering their services to obtain necessary items or assist in combat due to their agility."))
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat
	cloak = /obj/item/clothing/cloak/twilight_desert
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/shalal
	neck = 	/obj/item/clothing/neck/roguetown/leather
	mask = /obj/item/clothing/mask/rogue/facemask/steel/miragefen_rogue
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/twilight_miragefen_rogue/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Shamshir and Sling", "Dual Daggers", "Trident")
	var/weapon_choice = input("Choose your weapon.", "The paw chooses...") as anything in weapons
	switch(weapon_choice) //Трезубец ради тестов, Владмар сказал посмотрим как это будет играться, если будет имба пиздец, удалить это : - выделить и нажать Бекспейс.
		if ("Shamshir and Sling")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/shamshir)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/quiver/sling/iron, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/sling, SLOT_BELT_L, TRUE)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_STR, 2) //Выходит -1 спд, +1 сила, т.к. идёт -1 сила сверху, то есть общее число статов остаётся тем же.
		if ("Dual Daggers")
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/curved_dagger)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/curved_dagger)
		if ("Trident") //Исходя из кода 25 форса в 1 руке и 20 в 2 руках, с 30 сроуфорса, посмотрим как играется на доджере. Ес чё удалить дело 10 минут ИРЛа.
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/trident)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/curved_dagger)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolt/light, SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_WRISTS, TRUE)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_STR, 2) //Выходит -1 спд, +1 сила, т.к. идёт -1 сила сверху, то есть общее число статов остаётся тем же.
