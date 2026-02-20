/datum/advclass/mercenary/twilight_miragefen_rogue
	name = "Miragefen Rogue"
	tutorial = "With their eloquence and thieving skills, some Tabaxi from Miragefen began offering their services to obtain necessary items or assist in combat due to their agility."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/tabaxi)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_miragefen_rogue
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 3
	cmode_music = 'modular_twilight_axis/sound/music/combat_tabaxi.ogg'
	subclass_languages = list(/datum/language/celestial)
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
		/datum/skill/craft/traps = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass is race-limited to: Tabaxi Only."

/datum/outfit/job/roguetown/mercenary/twilight_miragefen_rogue/pre_equip(mob/living/carbon/human/H) //Без защиты рук и лап, хех, кошки в сапожках...
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("With their eloquence and thieving skills, some Tabaxi from Miragefen began offering their services to obtain necessary items or assist in combat due to their agility."))
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat
	cloak = /obj/item/clothing/cloak/twilight_desert
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
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
	var/weapons = list("Hooksword and Sling", "Dual Daggers", "Trident")
	var/weapon_choice = input("Choose your weapon.", "The paw chooses...") as anything in weapons
	switch(weapon_choice) //Трезубец ради тестов, Владмар сказал посмотрим как это будет играться, если будет имба пиздец, удалить это : - выделить и нажать Бекспейс.
		if ("Hooksword and Sling")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/hook)
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
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/trident)
			H.change_stat(STATKEY_SPD, -1)
			H.change_stat(STATKEY_STR, 2) //Выходит -1 спд, +1 сила, т.к. идёт -1 сила сверху, то есть общее число статов остаётся тем же.

//Спецайтемы.

/obj/item/rogueweapon/huntingknife/idagger/steel/curved_dagger
	name ="curved dagger"
	desc = "A curved blade notoriously used by assassins of the Zybantenee deserts. Particularly effective against targets already debilitated."
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	icon_state = "curved_dagger"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	altgripped = TRUE
	force = 21

/obj/item/clothing/cloak/twilight_desert
	name = "desert cloak"
	desc = "This one will help against the dusty weather."
	color = CLOTHING_PURPLE
	icon = 'modular_twilight_axis/icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	icon_state = "desert_cloak"
	item_state = "desert_cloak"
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	hoodtype = /obj/item/clothing/head/hooded/desert_hood
	toggle_icon_state = FALSE
	detail_tag = "_detail"
	detail_color = CLOTHING_YARROW

/obj/item/clothing/head/hooded/desert_hood
	name = "desert cloak hood"
	desc = "This one will shelter me from the sand."
	icon_state = "desert_hood"
	item_state = "desert_hood"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head_48.dmi'
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEHAIR
	detail_tag = "_detail"
	detail_color = CLOTHING_YARROW

/obj/item/clothing/mask/rogue/facemask/steel/miragefen_rogue
	name = "bronze-decorated steel mask"
	desc = "A steel mask with bronze inlays"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "miragefen_rogue"
