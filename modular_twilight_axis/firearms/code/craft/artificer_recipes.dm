/datum/anvil_recipe/engineering/twilight_ammunition
	i_type = "Ammo (Engineering)"

/datum/anvil_recipe/engineering/twilight_ammunition/musket
	name = "Lead Spheres, Tin (x8)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead
	createditem_num = 8
	craftdiff = 2

/datum/anvil_recipe/engineering/twilight_ammunition/silver_musket
	name = "Spheres, Silver (x8)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead/silver
	createditem_num = 8
	craftdiff = 5

/datum/anvil_recipe/engineering/twilight_ammunition/runelock
	name = "Runed Spheres, Blacksteel (x6)"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead/runelock
	createditem_num = 6
	craftdiff = 5

/datum/anvil_recipe/engineering/twilight_ammunition/cannonball
	name = "Lead Cannonballs, Tin (x6)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_cannonball
	createditem_num = 6
	craftdiff = 2

/datum/anvil_recipe/engineering/twilight_ammunition/grapeshot
	name = "Lead Grapeshot, Tin (x6)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_cannonball/grapeshot
	createditem_num = 6
	craftdiff = 2

/datum/anvil_recipe/weapons/twilight_ammunition
	i_type = "Ammo (Smithing)"

/datum/anvil_recipe/weapons/twilight_ammunition/musket
	name = "Lead Spheres, Tin (x8)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead
	createditem_num = 8
	craftdiff = 2

/datum/anvil_recipe/weapons/twilight_ammunition/silver_musket
	name = "Spheres, Silver (x8)"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead/silver
	createditem_num = 8
	craftdiff = 5

/datum/anvil_recipe/weapons/twilight_ammunition/runelock
	name = "Runed Spheres, Blacksteel (x6)"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_lead/runelock
	createditem_num = 6
	craftdiff = 5

/datum/anvil_recipe/weapons/twilight_ammunition/cannonball
	name = "Lead Cannonballs, Tin (x6)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_cannonball
	createditem_num = 6
	craftdiff = 2

/datum/anvil_recipe/weapons/twilight_ammunition/grapeshot
	name = "Lead Grapeshot, Tin (x6)"
	req_bar = /obj/item/ingot/tin
	created_item = /obj/item/ammo_casing/caseless/rogue/twilight_cannonball/grapeshot
	createditem_num = 6
	craftdiff = 2

// --------- GUNS -----------

/obj/item/twilight_gunlock
	name = "gunlock"
	icon_state = "gunlock"
	desc = "The 'firing' part of a gun."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'

/obj/item/twilight_gunstock
	name = "steel stock"
	icon_state = "gunstock"
	desc = "The 'holding' part of a gun."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'

/obj/item/twilight_simplestock
	name = "iron stock"
	icon_state = "ironstock"
	desc = "The 'holding' part of a gun."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'

/obj/item/twilight_gunbarrel
	name = "steel barrel"
	icon_state = "gunbarrel"
	desc = "The 'aiming' part of a gun."
	smeltresult = /obj/item/ingot/steel
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'

/obj/item/twilight_ironbarrel
	name = "iron barrel"
	icon_state = "ironbarrel"
	desc = "The 'aiming' part of a gun."
	smeltresult = /obj/item/ingot/iron
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'

/datum/anvil_recipe/engineering/twilight_guns
	i_type = "Firearms"

/datum/anvil_recipe/engineering/twilight_guns/barrel
	name = "Steel Barrel (+1 Steel)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/twilight_gunbarrel
	additional_items = list(/obj/item/ingot/steel = 1)
	craftdiff = 3

/datum/anvil_recipe/engineering/twilight_guns/ironbarrel
	name = "Iron Barrel (+1 Iron)"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/twilight_ironbarrel
	additional_items = list(/obj/item/ingot/iron = 1)
	craftdiff = 1

/datum/anvil_recipe/engineering/twilight_guns/parts
	name = "Gunlock (+1 Cog)"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/twilight_gunlock
	additional_items = list(/obj/item/roguegear = 1)
	craftdiff = 1

/datum/anvil_recipe/engineering/twilight_guns/stock
	name = "Steel Stock (+1 Wood)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/natural/wood/plank = 1)
	created_item = /obj/item/twilight_gunstock
	craftdiff = 3

/datum/anvil_recipe/engineering/twilight_guns/ironstock
	name = "Iron Stock (+1 Wood)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/wood/plank = 1)
	created_item = /obj/item/twilight_simplestock
	craftdiff = 1

/datum/anvil_recipe/engineering/twilight_guns/arquebus
	name = "Arquebus Rifle (+1 Steel Stock, +1 Gunlock, +1 Steel Barrel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/twilight_gunstock = 1,
							/obj/item/twilight_gunbarrel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/arquebus
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/hunt_arquebus
	name = "Hunter's Arquebus (+2 Small Logs, +1 Gunlock, +1 Steel Barrel, +1 Steel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/grown/log/tree/small = 2,
							/obj/item/twilight_gunbarrel = 1,
							/obj/item/ingot/steel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/hunt_arquebus
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/handgonne
	name = "Culverin (+1 Steel Stock, +1 Steel Barrel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/twilight_gunstock = 1,
							/obj/item/twilight_gunbarrel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/handgonne
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/mortar
	name = "Hand Mortar (+1 Iron Stock, +1 Gunlock, +1 Cured Leather)"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/twilight_simplestock = 1,
							/obj/item/natural/hide/cured = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol/mortar
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/arti_barker1
	name = "Barker, Ignited (+1 Ignited Stone, +1 Barker)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
							/obj/item/sharpener/ignited = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/barker/arti_barker1
	craftdiff = 3

/datum/anvil_recipe/engineering/twilight_guns/arti_barker2
	name = "Barker, Hunter's (+1 Ignited Barker, +2 Small Logs, +1 Iron)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker1 = 1,
							/obj/item/ingot/iron = 1,
							/obj/item/grown/log/tree/small = 2)
	created_item = /obj/item/gun/ballistic/twilight_firearm/barker/arti_barker2
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/arti_barker3
	name = "Barker, Shepherd's (+1 Hunter's Barker, +1 Steel, +2 Cured Leather)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker2 = 1,
							/obj/item/ingot/steel = 1,
							/obj/item/natural/hide/cured = 2)
	created_item = /obj/item/gun/ballistic/twilight_firearm/barker/arti_barker3
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/flintgonne
	name = "Hakenbüchse (+1 Simple Stock, +1 Gunlock, +1 Iron Barrel)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/twilight_simplestock = 1,
							/obj/item/twilight_ironbarrel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/flintgonne
	craftdiff = 2

/datum/anvil_recipe/engineering/twilight_guns/barker
	name = "Barker (+1 Simple Stock, +1 Iron Barrel)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/twilight_simplestock = 1,
							/obj/item/twilight_ironbarrel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/barker
	craftdiff = 1

/datum/anvil_recipe/engineering/twilight_guns/arquebus_pistol
	name = "Arquebus Pistol (+1 Steel Stock, +1 Gunlock, +1 Steel Barrel)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/twilight_gunstock = 1,
							/obj/item/twilight_gunbarrel = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
	craftdiff = 4

/datum/anvil_recipe/engineering/twilight_guns/arquebus_decorated
	name = "Decorated Arquebus Rifle (+1 Steel Stock, +1 Gunlock, +1 Steel Barrel, +1 Gold)"
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/twilight_gunlock = 1,
							/obj/item/twilight_gunstock = 1,
							/obj/item/twilight_gunbarrel = 1,
							/obj/item/ingot/gold = 1)
	created_item = /obj/item/gun/ballistic/twilight_firearm/arquebus/decorated
	craftdiff = 4

/datum/anvil_recipe/weapons/twilight_arquebus_decorated
	name = "Decorated Arquebus Rifle (+1 Arquebus Rifle)"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/gun/ballistic/twilight_firearm/arquebus)
	created_item = /obj/item/gun/ballistic/twilight_firearm/arquebus/decorated
	craftdiff = 2

/datum/anvil_recipe/weapons/twilight_ramrod
	name = "Ramrod, Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/twilight_ramrod
	craftdiff = 1
