/obj/item/organ/breasts
	name = "breasts"
	icon = 'modular_twilight_axis/icons/roguetown/items/surgery.dmi' //TA_EDIT
	icon_state = "breasts" //TA_EDIT
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BREASTS
	organ_dna_type = /datum/organ_dna/breasts
	accessory_type = /datum/sprite_accessory/breasts/pair
	var/breast_size = DEFAULT_BREASTS_SIZE

/obj/item/organ/breasts/get_cache_key()
	return "[..()]-[breast_size]"
