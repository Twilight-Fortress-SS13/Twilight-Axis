/obj/item/organ/butt
	name = "butt"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'
	icon_state = "butt"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_BUTT
	accessory_type = /datum/sprite_accessory/butt
	var/butt_size = MIN_BUTT_SIZE

/obj/item/organ/butt/internal
	name = "internal butt"
	visible_organ = FALSE
	accessory_type = /datum/sprite_accessory/none

/obj/item/organ/belly
	name = "belly"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'
	icon_state = "belly"
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_BELLY
	accessory_type = /datum/sprite_accessory/belly
	var/belly_size = BELLY_SIZE_MIN
	var/allow_to_grow = FALSE

/obj/item/organ/belly/internal
	name = "internal belly"
	visible_organ = FALSE
	accessory_type = /datum/sprite_accessory/none

/obj/item/organ/penis
	icon_state = "penis"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'

/obj/item/organ/vagina
	icon_state = "vagina"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'

/obj/item/organ/breasts
	icon_state = "breasts"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'

/obj/item/organ/testicles
	icon_state = "testicles"
	icon = 'modular_twilight_axis/icons/mob/surgery.dmi'
