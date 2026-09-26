/datum/job/roguetown/manorguard/New()
	job_subclasses += list(/datum/advclass/manorguard/twilight_grenadier)
	. = ..()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier
	name = "padded garb"
	desc = "A thickly padded shirt, designed to protect the wearer from the recoil of firearms. It is made of heavy cloth and reinforced with leather patches on the shoulders and elbows."
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	icon_state = "grenadiershirt"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	boobed = FALSE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	color = CLOTHING_AZURE
	detail_color = CLOTHING_WHITE
	shiftable = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenadier
	name = "padded pantaloons"
	desc = "Padded pants for extra comfort and protection, adorned in vibrant colors."
	icon_state = "grenadierpants"
	item_state = "grenadierpants"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	detail_tag = "_detail"
	color = CLOTHING_AZURE
	detail_color = CLOTHING_WHITE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenadier/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenadier/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenadier/lordcolor(primary,secondary)
	color = primary
	detail_color = secondary
	update_icon()
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier/Destroy()
	GLOB.lordcolor -= src
	return ..()

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
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenadier
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenadier
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	beltl = /obj/item/rogueweapon/scabbard/sheath

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Arquebus Rifle","Culverin")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_options = list("Leather Armor", "Fluted Cuirass Armor")
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
			if("Leather Armor")
				head = /obj/item/clothing/head/roguetown/roguehood/studded/retinue
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
				beltl = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/special
				H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Fluted Cuirass Armor") //Leather pants, so we give him fluted cuirass
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				beltl = /obj/item/rogueweapon/scabbard
				r_hand = /obj/item/rogueweapon/sword/short
				H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
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
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/manatarms = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			/obj/item/twilight_powderflask = 1
			)
		add_verb(H, /mob/proc/haltyell)

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
