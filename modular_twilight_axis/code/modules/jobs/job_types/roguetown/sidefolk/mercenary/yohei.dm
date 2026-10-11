/datum/advclass/mercenary/twilight_heishi
	name = "Heishi-Yōhei"
	tutorial = "Battle is a craft, and you have honed it well, you are. A steady hand, a tempered spirit, and armor worn not for glory, but for duty - this is the measure of a true mercenary. Steel meets steel at your command, and you endure where lighter warriors break and heavier ones slow. Every contract, every fight, every scar is for your family. The honor of your clan is your guide, and their legacy moves with you into every battle."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_heishi
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 2
	cmode_music = sound("modular_twilight_axis/sound/music/combat_heishi.ogg")
	subclass_languages = list(/datum/language/kazengunese)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = -1 //Au Ra bodies are naturally more agile, so a slight speed penalty to balance out their racial bonus
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This subclass is race-limited to: Au Ra Only."

/datum/advclass/mercenary/twilight_heishi/New()
	..()
	forbidden_races = ALL_RACES_TYPES - /datum/species/aura

/datum/outfit/job/roguetown/mercenary/twilight_heishi/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("A worthy conflict tempers the spirit, strengthens the arm, and brings prosperity to the clan waiting beyond the horizon. Above all stands family. Clan is not a memory left behind, but a presence carried with every step. Each contract you accept, each blade you draw, each wound you endure... all of it is for the home where, one day, you may lay your armor aside."))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto/zunari
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	cloak = /obj/item/clothing/cloak/kazengun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun,
		/obj/item/rogueweapon/scabbard/sheath/kazengun,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/twilight_heishi/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Greatsword", "Great Mace", "Spear", "Longbow", "Quarterstaff")
	var/weapon_choice = input("Choose your weapon.", "LET YOUR HANDS SPEAK BEFORE YOUR MOUTH.") as anything in weapons
	switch(weapon_choice)
		if ("Greatsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/miaodao)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/kazengun/miaodao, SLOT_BELT_R, TRUE)
		if ("Great Mace")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel/tetsubo)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if ("Spear")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/boar/kazengun)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if ("Longbow")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/yumi)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L, TRUE)
		if ("Quarterstaff")
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/quarterstaff/bostaff)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
	var/masks = list("Half-Mask", "Full Mask")
	var/mask_choice = input("Choose your mask.", "HIDE OR REVEAL YOUR STRIKE.") as anything in masks
	switch(mask_choice)
		if("Half-Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun, SLOT_WEAR_MASK, TRUE)
		if("Full Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full/ogre, SLOT_WEAR_MASK, TRUE)

/datum/advclass/mercenary/twilight_yohei
	name = "Kagekiri-Yōhei"
	tutorial = "A worthy conflict tempers the spirit and sharpens the body. Strength alone does not win wars - precision does. Speed is mercy; hesitation is death. You move where steel is slow, strike where armor is thin, and end fights before they can drag into slaughter. Above all stands family. Clan is not a memory left behind, but a presence carried with every step."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_yohei
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 2
	cmode_music = sound("modular_twilight_axis/sound/music/combat_yohei.ogg")
	subclass_languages = list(/datum/language/kazengunese)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE
	)
	extra_context = "This subclass is race-limited to: Au Ra Only."

/datum/advclass/mercenary/twilight_yohei/New()
	..()
	forbidden_races = ALL_RACES_TYPES - /datum/species/aura

/datum/outfit/job/roguetown/mercenary/twilight_yohei/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("A worthy conflict tempers the spirit and sharpens the body. Strength alone does not win wars - precision does. Speed is mercy; hesitation is death. You move where steel is slow, strike where armor is thin, and end fights before they can drag into slaughter. Above all stands family. Clan is not a memory left behind, but a presence carried with every step."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yohei
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	armor = /obj/item/clothing/suit/roguetown/armor/basiceast/yohei
	cloak = /obj/item/clothing/cloak/thief_cloak/yohei
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded
	neck = 	/obj/item/storage/belt/rogue/pouch/coins/poor
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun,
		/obj/item/rogueweapon/scabbard/sheath/kazengun
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/twilight_yohei/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Greatsword", "Dual Wield Hookswords", "Bow")
	var/weapon_choice = input("Choose your weapon.", "THE BLADE DECIDES...") as anything in weapons
	switch(weapon_choice) //A large selection of exotic starter options, as per the class gimmick.
		if ("Greatsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/miaodao)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/kazengun/miaodao, SLOT_BELT_R, TRUE)
		if ("Dual Wield Hookswords")
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/hook)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/hook)
		if ("Bow")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/hankyu)
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L, TRUE)
	var/masks = list("Half-Mask", "Oni", "Kitsune")
	var/mask_choice = input("Choose your mask.", "...BEHIND THE HORN AND STEEL.") as anything in masks
	switch(mask_choice)
		if("Half-Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei, SLOT_WEAR_MASK, TRUE)
		if("Oni")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full/yohei, SLOT_WEAR_MASK, TRUE)
		if("Kitsune")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full/yohei/kitsune, SLOT_WEAR_MASK, TRUE)

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yohei
	name = "shadowed hood"
	item_state = "hijab"
	icon_state = "hijab"
	max_integrity = ARMOR_INT_HELMET_LEATHER
	armor = ARMOR_LEATHER
	color = CLOTHING_BLACK
	desc = "A traditional Kazengunese hood, dyed in dark colors."

/obj/item/clothing/cloak/thief_cloak/yohei
	name = "shadowed cloak"
	desc = "A dark cloak favored by Kazengunese mercenaries."
	color = CLOTHING_BLACK
