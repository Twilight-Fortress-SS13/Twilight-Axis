/datum/sprite_accessory/butt
	icon = 'modular_twilight_axis/icons/mob/sprite_accessory/butt/butt.dmi'
	color_key_name = "Butt"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/butt/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_ID, OFFSET_ID_F)

/datum/sprite_accessory/butt/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/butt/buttie = organ
	return "[icon_state]_[(buttie.butt_size - 1)]"

/datum/sprite_accessory/butt/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner && owner.underwear)
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/butt/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)
