/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe/soundbreakerrobe
	slot_flags = ITEM_SLOT_ARMOR
	name = "soundbreaker robes"
	desc = "A set of reinforced, leather-padded robes worn by soundbreakers."
	color = CLOTHING_RED
	icon_state = "soundbreaker"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	body_parts_covered = CHEST | GROIN | LEGS | ARMS 

/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe
	name = "foreign robes"
	desc = "Flower-styled robes, said to have been infused with magical protection. The Merchant Guild says that this is from the southern Kazengite region."
	icon_state = "eastsuit4"
	item_state = "eastsuit4"
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25 // Head Honcho gets a buff
	sellprice = 25

// this robe spawns on a role that offers no leg protection nor further upgrades to the loadout, in exchange for better roundstart gear
