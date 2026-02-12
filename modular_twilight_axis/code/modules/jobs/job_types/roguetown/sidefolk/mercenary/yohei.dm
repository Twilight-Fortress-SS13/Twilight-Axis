/datum/advclass/mercenary/twilight_heishi
	name = "Heishi-Yōhei"
	tutorial = "Battle is a craft, and you have honed it well, you are. A steady hand, a tempered spirit, and armor worn not for glory, but for duty - this is the measure of a true mercenary. Steel meets steel at your command, and you endure where lighter warriors break and heavier ones slow. Every contract, every fight, every scar is for your family. The honor of your clan is your guide, and their legacy moves with you into every battle."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(/datum/species/aura)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_heishi
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 2
	cmode_music = 'modular_twilight_axis/sound/music/combat_heishi.ogg'
	subclass_languages = list(/datum/language/kazengunese)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
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

/datum/outfit/job/roguetown/mercenary/twilight_heishi/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("A worthy conflict tempers the spirit, strengthens the arm, and brings prosperity to the clan waiting beyond the horizon. Above all stands family. Clan is not a memory left behind, but a presence carried with every step. Each contract you accept, each blade you draw, each wound you endure... all of it is for the home where, one day, you may lay your armor aside."))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto/zunari
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/chainlegs
	belt = /obj/item/storage/belt/rogue/leather/cloth
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
		/obj/item/rogueweapon/scabbard/sheath/kazengun
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/twilight_heishi/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Great Sword", "Great Mace", "Spear", "Longbow", "Quarterstaff")
	var/weapon_choice = input("Choose your weapon.", "LET YOUR HANDS SPEAK BEFORE YOUR MOUTH.") as anything in weapons
	switch(weapon_choice)
		if ("Great Sword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/miaodao)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
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
			H.change_stat(STATKEY_STR, 1) //Longbows require a bit more strength to use effectively.
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
	allowed_races = list(/datum/species/aura)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_yohei
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	maximum_possible_slots = 2
	cmode_music = 'modular_twilight_axis/sound/music/combat_yohei.ogg'
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
	belt = /obj/item/storage/belt/rogue/leather/cloth
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
	var/weapons = list("Great Sword", "Dual Wield Hookswords", "Bow")
	var/weapon_choice = input("Choose your weapon.", "THE BLADE DECIDES...") as anything in weapons
	switch(weapon_choice) //A large selection of exotic starter options, as per the class gimmick.
		if ("Great Sword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/miaodao)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
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
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei/oni, SLOT_WEAR_MASK, TRUE)
		if("Kitsune")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei/kitsune, SLOT_WEAR_MASK, TRUE)

///////////////////////////
//Kagekiri Specific Items//
///////////////////////////
/datum/intent/sword/cut/miaodao
	reach = 2
	penfactor = 20

/datum/intent/sword/cut/miaodao/fast
	clickcd = 9

/datum/intent/sword/peel/miaodao
	name = "long sword armor peel"
	reach = 2

/obj/item/rogueweapon/greatsword/miaodao
	name = "miaodao"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "odachi"
	desc = "An unusually long saber of Kazengunese origin. The lighter blade lends itself to one-handed use better than a zweihander, but maintaining edge alignment is tricky and requires experience."
	force = 24
	force_wielded = 30
	minstr = 8
	wdefense = 6
	wdefense_wbonus = 1
	max_blade_int = 150 
	wbalance = WBALANCE_SWIFT
	possible_item_intents = list(/datum/intent/sword/cut/miaodao, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/miaodao/fast, /datum/intent/sword/thrust/zwei, /datum/intent/sword/peel/miaodao, /datum/intent/sword/chop/long)
	alt_intents = null

/obj/item/clothing/suit/roguetown/armor/basiceast/yohei
	name = "black dobo robe"
	desc = "A dark dobo robe with reinforced leather inlays. Offers decent protection while allowing for ease of movement."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "yoheisuit"
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yohei
	name = "shadowed hood"
	max_integrity = 100
	armor = ARMOR_SPELLSINGER
	color = CLOTHING_BLACK
	desc = "A traditional Kazengunese hood, dyed in dark colors."

/obj/item/clothing/cloak/thief_cloak/yohei
	name = "shadowed cloak"
	desc = "A dark cloak favored by Kazengunese mercenaries."
	color = CLOTHING_BLACK

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei
	name = "steel half-mask"
	desc = "\"The first article: Forget nothing, forgive nothing.\""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "kazengunhalf"
	armor = ARMOR_PLATE

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei/oni
	name = "steel oni mask"
	desc = "\"The second article: Endure in silence, speak only through steel.\""
	icon_state = "kazengunoni"
	armor = ARMOR_PLATE
	body_parts_covered = FACE

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/yohei/kitsune
	name = "steel kitsune mask"
	desc = "\"The third article: Mercy is a luxury the wise cannot afford.\""
	icon_state = "kazengunkitsune"
	armor = ARMOR_PLATE
	body_parts_covered = FACE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/hankyu
	name = "hankyu bow"
	desc = "A smaller version of the asymmetrical bow named Yumi. It must be shot overhead, and it is perfect for horseback use."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "hankyu_bow"

/////////////////////////
//Heishi Specific Items//
/////////////////////////

/obj/item/clothing/head/roguetown/helmet/heavy/kabuto/zunari
	name = "zunari-kabuto"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	desc = "A battle-forged helm of Kazengun make, constructed from layered steel plates and reinforced along the head. Darkened to mute its shine, it is built for endurance rather than ceremony."
	icon_state = "kazengunmediumhelm"

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi
	name = "hara-yoroi cuirass"
	desc = "A practical lightweight cuirass favored by disciplined mercenaries and provincial retainers of Kazengun. Layered blacksteel-coated steel plates to dull the shine of war, offer reliable protection without the burden of full battle harness."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "kazengunlight"
	boobed = TRUE
	item_state = "kazengunlight"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 25
	var/picked = FALSE

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Uniform colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/suit/roguetown/armor/brigandine/harayoroi/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full/ogre
	name = "soldier's ogre mask"
	desc = "\"The fourth lesson: The wise learn from the fatal mistakes of others.\""
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "kazengunfull"
	item_state = "kazengunfull"

/datum/intent/mace/strike/tetsubo
	reach = 2

/datum/intent/mace/smash/tetsubo
	reach = 2

/obj/item/rogueweapon/mace/goden/steel/tetsubo
	name = "tetsubo"
	desc = "A heavier variant of the kanabo, fitted with a steel sleeve bearing menacing spikes and favored by Ogre Warlords. Requires immense strength to use, but hits like a raging bull."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "tetsubo"
	force = 20
	possible_item_intents = list(/datum/intent/mace/strike/tetsubo)
	gripped_intents = list(/datum/intent/mace/strike/tetsubo, /datum/intent/mace/smash/tetsubo, /datum/intent/effect/daze)
	sharpness = IS_SHARP
	minstr = 11
	slot_flags = ITEM_SLOT_BACK

/obj/item/rogueweapon/greatsword/miaodao/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") 
				return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = 3,"nx" = -7,"ny" = 3,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -10,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)

/obj/item/rogueweapon/spear/boar/kazengun
	name = "jūmonji yari"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "jumonjiyari"
	desc = "A spear with a long, straight head and a pair of curved blades pointing upward. A Kazengunese design, the side-blades parallel an Aavnic partizan. Its function is certainly similar, tearing the flesh of any unfortunate enough to be pierced by it."
	gripped_intents = list(/datum/intent/spear/thrust, /datum/intent/spear/cut/naginata, /datum/intent/rend/reach/partizan)
	wdefense = 7

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/yumi
	name = "yumi bow"
	desc = "The asymmetrical and elegant relic from Kazengun, hard-hitting and powerful, bringing fear to orcish hordes and demons on a whim."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "yumi_bow"

/obj/item/rogueweapon/woodstaff/quarterstaff/bostaff
	name = "bo staff"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "bostaff"
	desc = "The bo, or 'kazengunese quarterstaff', is a simple weapon used in martial arts to entrap, strike and sweep the enemy."
	wdefense_wbonus = 9
