// Elven reinforced clothes
/obj/item/clothing/gloves/roguetown/angle/twilight_elven
	name = "elven rider gloves"
	desc = "Comfortable leather gloves, reinforced with metal plates for extra protection. Crafted by elven masters, based on a design lost to ages."
	icon_state = "elven_gloves"
	item_state = "elven_gloves"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	color = null

/obj/item/clothing/gloves/roguetown/bloodraider
	name = "raiders gauntlets"
	desc = "Clawed plate gauntlets, capable of tormenting N'wah with their tips"
	icon_state = "bloodgauntlets"
	item_state = "bloodgauntlets"
	armor = ARMOR_PLATE
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'

/obj/item/clothing/gloves/roguetown/bloodraider/ComponentInitialize()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/gloves/roguetown/bloodraider/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)
