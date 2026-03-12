/datum/sprite_accessory/belly
	name = "Belly"
	icon = 'modular_twilight_axis/icons/mob/sprite_accessory/belly/belly.dmi'
	color_key_name = "Belly"
	icon_state = "pair"
	relevant_layers = list(BODY_LAYER)
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/belly/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/belly/belleh = organ
	return "[icon_state]_[(belleh.belly_size)]"

/datum/sprite_accessory/belly/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_ID, OFFSET_ID_F)

/datum/sprite_accessory/belly/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)
