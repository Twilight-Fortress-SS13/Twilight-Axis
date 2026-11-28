/obj/item/rogueweapon/greatsword/grenz/flamberge/relevement
	name = "\"Relevement\""
	desc = "The grave wounds caused by flame-bladed swords make them a highly sought-after weapon among the Dark Elves - the charges of dishonorable warfare notwithstanding. Consequentially, these weapons are often wielded by both sides of the Underdark Feud Wars."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords64.dmi'
	icon_state = "drowflamberge"
	item_state = "drowflamberge"
	max_integrity = 240
	max_blade_int = 240
	smeltresult = /obj/item/ingot/drow

/obj/item/rogueweapon/greatsword/miaodao
	name = "miaodao"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/swords64.dmi'
	icon_state = "odachi"
	sheathe_icon = "odachi"
	desc = "An unusually long saber of Kazengunese origin. The lighter blade lends itself to one-handed use better than a zweihander, but maintaining edge alignment is tricky and requires experience."
	force = 25
	force_wielded = 30
	minstr = 8
	wdefense = 5
	wdefense_wbonus = 2
	max_blade_int = 150
	wbalance = WBALANCE_SWIFT
	possible_item_intents = list(/datum/intent/sword/cut/miaodao, /datum/intent/sword/cut/zwei/cleave, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut/miaodao/fast, /datum/intent/sword/thrust/zwei, /datum/intent/sword/cut/zwei/sweep, /datum/intent/sword/cut/rend)
	special = /datum/special_intent/shin_swipe
	alt_grips = null
