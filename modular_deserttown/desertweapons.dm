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


/obj/item/rogueweapon/sword/sabre/shamshir/steel
	name = "steel shamshir"
	desc = "A curved one-handed sword. This is a forged steel copy of the traditional Ranesheni shamshir."
	force = 23
	max_blade_int = 230
	smeltresult = /obj/item/ingot/steel

/datum/anvil_recipe/weapons/steel/shamshir
	name = "Shamshir, Steel"
	category = "Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir/steel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/obj/item/rogueweapon/sword/sabre/shamshir/blacksteel
	name = "blacksteel shamshir"
	desc = "A curved one-handed sword. This is a forged blacksteel version of the traditional Ranesheni shamshir."
	force = 27
	wdefense = 7
	icon_state = "bshamshir"
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	smeltresult = /obj/item/ingot/blacksteel
	special_picks = list(
		/datum/special_intent/side_sweep,
		/datum/special_intent/axe_swing,
		/datum/special_intent/piercing_lunge,
		/datum/special_intent/polearm_backstep,
		/datum/special_intent/limbguard,
		/datum/special_intent/dagger_dash,
		/datum/special_intent/flail_sweep,
		)
	max_blade_int = 300
	max_integrity = 200

/obj/item/rogueweapon/sword/sabre/shamshir/blacksteel/sultan
	name = "\"Jihad\""
	desc = "A curved shamshir made of the blacksteel, forged specifically for the Sultan’s hand. Its blade, as light as a breath of wind and as sharp as the ruler’s will, is designed to unleash sacred wrath upon the enemies of the throne."
	icon_state = "sultan_bshamshir"
	force = 31
	wdefense = 8
	sellprice = 2000
	static_price = TRUE

/datum/anvil_recipe/weapons/blacksteel/shamshir
	name = "Blacksteel Shamshir (+1 Blacksteel, +1 Gemerald, +1 Silk)"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/green, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/sabre/shamshir/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS

/obj/item/rogueweapon/sword/long/kriegmesser/zybantine
	name = "heavy scimitar"
	desc = "A large zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "Kmesser"

/obj/item/rogueweapon/sword/long/kriegmesser/zybantine/mushir
	name = "\"Zulfiqar\""
	desc = "A large ornate golden zybantine sword with a single-edged blade, a crossguard and with a ruby embedded in the knife-like hilt, given to the Mushir for their valiant service to the Sultanate."
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "mushirmesser"
	sheathe_icon = "kingslayer"
	force = 27
	force_wielded = 33
	sellprice = 140

/obj/item/rogueweapon/sword/long/kriegmesser/zybantine/blacksteel
	name = "blacksteel heavy scimitar"
	desc = "A large blacksteel zybantine sword with a single-edged blade, a crossguard and a knife-like hilt. "
	icon = 'modular_deserttown/icons/items/desertweapons64.dmi'
	icon_state = "bKmesser"
	force = 30
	force_wielded = 35
	wdefense = 5
	wdefense_wbonus = 9
	smeltresult = /obj/item/ingot/blacksteel
	special_picks = list(
		/datum/special_intent/side_sweep,
		/datum/special_intent/axe_swing,
		/datum/special_intent/piercing_lunge,
		/datum/special_intent/polearm_backstep,
		/datum/special_intent/limbguard,
		/datum/special_intent/dagger_dash,
		/datum/special_intent/flail_sweep,
		)
	max_blade_int = 400
	max_integrity = 200

/obj/item/rogueweapon/sword/long/kriegmesser/zybantine/blacksteel/sultan
	name = "\"Al-Battar\""
	desc = "A massive scimitar made of blacksteel, belonging to the Sultan. The mere sight of it strikes fear into the heart: its broad blade is capable of cleaving through a shield, chain mail, and whoever is hiding behind them with a single blow."
	icon_state = "sultan_bKmesser"
	wdefense = 6
	wdefense_wbonus = 10
	force_wielded = 36
	sellprice = 2000
	static_price = TRUE

/datum/anvil_recipe/weapons/blacksteel/scimitar
	name = "Blacksteel Heavy Scimitar (+1 Blacksteel, +1 Rontz, +1 Silk)"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/roguegem/ruby, /obj/item/natural/silk)
	created_item = /obj/item/rogueweapon/sword/long/kriegmesser/zybantine/blacksteel
	display_category = ITEM_CAT_WEAPONS_SWORDS
