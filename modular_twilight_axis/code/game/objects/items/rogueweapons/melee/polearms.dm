/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe
	name = "equipoise"
	desc = "Often wielded by the Necran Immortals, this silver scythe is claimed to be capable of bypassing all protection, striking directly at the enemy's soul."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "necrascythe"
	possible_item_intents = list(/datum/intent/spear/cut/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/rend/reach, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	force_wielded = 35
	max_integrity = 300
	wdefense = 4
	is_silver = TRUE

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)
/obj/item/rogueweapon/spear/partizan/baotha_ta
	name = "saccharine swordspear"
	desc = "Keep the rest at arm's length, lest you're burdened with the pain of rememberance."
	force = 25
	force_wielded = 35
	possible_item_intents = list(/datum/intent/sword/thrust/long, /datum/intent/sword/cut/long, /datum/intent/sword/strike, /datum/intent/sword/thrust/heavy)
	gripped_intents = list(SPEAR_THRUST, /datum/intent/spear/cut, PARTIZAN_REND, /datum/intent/spear/cut/glaive/sweep)
	icon_state = "swordstaff"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	parrysound = list(
	'sound/combat/parry/bladed/bladedmedium (1).ogg',
	'sound/combat/parry/bladed/bladedmedium (2).ogg',
	'sound/combat/parry/bladed/bladedmedium (3).ogg',
	)
	pickup_sound = 'sound/foley/equip/swordlarge1.ogg'
	minstr = 4
	thrown_bclass = BCLASS_PIERCE
	max_blade_int = 400
	max_integrity = 400
	throwforce = 45 //Pierce the heavens!
	wdefense = 4
	wdefense_wbonus = 5
	smeltresult = /obj/item/ingot/component/baotha
	slot_flags = ITEM_SLOT_BACK //No need for a supplemental greatweapon strap.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS
	icon_angle_wielded = null

/obj/item/rogueweapon/spear/partizan/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SWORDSPEAR")

/obj/item/rogueweapon/spear/partizan/baotha_ta/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.7, "sx" = -14, "sy" = -8, "nx" = 9, "ny" = -6, "wx" = -6, "wy" = -6, "ex" = -1, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -10, "sturn" = 108, "wturn" = -72, "eturn" = -10, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.75, "sx" = 5, "sy" = -3, "nx" = -5, "ny" = -3, "wx" = -5, "wy" = -3, "ex" = 3, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 6, "sturn" = -8, "wturn" = 10, "eturn"= -10, "nflip" = 8, "sflip" = 0, "wflip" = 8, "eflip" = 0)

/obj/item/rogueweapon/spear/partizan/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)
