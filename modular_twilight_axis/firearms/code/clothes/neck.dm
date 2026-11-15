/obj/item/clothing/neck/roguetown/bevor/blackpowder
	name = "blackpowder order coverall"
	desc = "A robust coverall, worn by the warriors of the Otavan Blackpowder Order. A garnament fitting for the Final War."
	icon = 'modular_twilight_axis/firearms/icons/obj_neck.dmi'
	mob_overlay_icon = 'modular_twilight_axis/firearms/icons/onmob_neck.dmi'
	icon_state = "confessorcoif"
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS

/obj/item/clothing/neck/roguetown/bevor/blackpowder/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, "sound/foley/cloth_wipe (1).ogg", null, (UPD_HEAD|UPD_MASK|UPD_NECK))
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)
