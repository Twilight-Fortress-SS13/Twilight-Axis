/obj/item/storage/belt/rogue/leather/hammerhold_sash
	name = "hammerhold sash"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "hammerhold_sash"
	detail_tag = "_belt"

/obj/item/storage/hip/headhook/Entered(atom/movable/arrived, atom/oldloc)
	. = ..()
	if(istype(arrived, /obj/item/natural/head) || istype(arrived, /obj/item/bodypart/head))
		SEND_SIGNAL(src, COMSIG_HEADHOOK_CONTENTS_CHANGED)

/obj/item/storage/hip/headhook/Exited(atom/movable/gone, atom/newloc)
	. = ..()
	if(istype(gone, /obj/item/natural/head) || istype(gone, /obj/item/bodypart/head))
		SEND_SIGNAL(src, COMSIG_HEADHOOK_CONTENTS_CHANGED)

/obj/item/storage/hip/headhook/equipped(mob/user, slot, initial)
	. = ..()
	if(slot == SLOT_BELT_L || slot == SLOT_BELT_R)
		var/mob/living/carbon/human/carrier = src.loc
		if(carrier)
			SEND_SIGNAL(carrier, COMSIG_HEADHOOK_EQUIPPED, user)

/obj/item/storage/hip/headhook/dropped(mob/user, silent)
	var/mob/living/carbon/human/carrier = src.loc
	if(carrier)
		SEND_SIGNAL(carrier, COMSIG_HEADHOOK_UNEQUIPPED, user)
	. = ..()
