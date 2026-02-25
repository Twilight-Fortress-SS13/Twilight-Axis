/obj/item/clothing/wrists/roguetown/bracers/twilight_elven
	name = "elven rider bracers"
	desc = "Elegant steel bracers, meant to protect the wearer's wrists from cutting attacks. Their sleek design marks them as a product of elven craftsmanship."
	icon_state = "elven_armplates"
	item_state = "elven_armplates"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	alternate_worn_layer = WRISTS_LAYER

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()
