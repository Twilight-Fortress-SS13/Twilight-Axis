/obj/item/rogueweapon/shield/iron/zybantine
	name = "brass shield"
	desc = "A sturdy shield of Zybantium make."
	icon = 'modular_deserttown/icons/items/desertweapons32.dmi'
	icon_state = "zybshield"
	max_integrity = 250
	blade_dulling = DULLING_BASH
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	sellprice = 30
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/woodstaff/riddle_of_steel/serpent
	name = "\improper Staff of the Serpent"
	desc = "A mysterious golden staff shaped like a snake. You could swear its staring at you"
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "snakestaff"


/obj/item/rogueweapon/sword/long/kriegmesser/zybantine
	name = "heavy scimitar"
	desc = "A large zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "Kmesser"

/obj/item/rogueweapon/sword/sabre/shamshir/steel
	name = "steel shamshir"
	desc = "A curved one-handed sword. This is a forged steel copy of the traditional Ranesheni shamshir."
	force = 23
	max_blade_int = 230
	smeltresult = /obj/item/ingot/steel

/datum/anvil_recipe/weapons/steel/shamshir
	name = "Shamshir, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir/steel
	display_category = ITEM_CAT_WEAPONS_SWORDS
