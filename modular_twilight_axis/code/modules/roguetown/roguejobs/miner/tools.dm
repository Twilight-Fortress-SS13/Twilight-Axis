/obj/item/rogueweapon/pick/bronze/Initialize()
	. = ..()
	new /obj/item/rogueweapon/stoneaxe/bronze(get_turf(src))
	qdel(src)

/obj/item/rogueweapon/stoneaxe/bronze
	name = "dolabra"
	desc = "A so-called 'legionnaire's tool'; antiquated, but nevertheless beloved by many for its verastility. It offers an answer for labors both above-and-below, courtesy of its bronze axhead-and-picktip."
	force = 20
	force_wielded = 25
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "bronzepick"
	possible_item_intents = list(/datum/intent/mace/warhammer/pick, /datum/intent/axe/cut, /datum/intent/mace/strike, /datum/intent/till)
	gripped_intents = list(/datum/intent/mace/warhammer/pick, /datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike)
	max_integrity = 500
	max_blade_int = 225
	smeltresult = /obj/item/ingot/bronze