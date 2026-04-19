// Heavy armour NECK coverage buff:

/obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/brigandine/banneret
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/brigandine/light/handmade
	slot_flags = ITEM_SLOT_ARMOR
	name = "'jack of plate' brigandine"
	desc = "This brigandine is an example of the painstaking work of a skilled, and very poor, craftsman. The gambenison, lined with metal parts and scraps of chain mail, is impossible to ruin even with such 'artistry'."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "light_brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	smeltresult = /obj/item/ingot/iron
	equip_delay_self = 40
	armor_class = ARMOR_CLASS_LIGHT
	w_class = WEIGHT_CLASS_BULKY
