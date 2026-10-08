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

/obj/item/storage/belt/rogue/leather/overseer
	name = "confessor belt pouch"
	desc = "Несколько вместительных отделений, пришитых к кожаному поясу для распределения веса."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/overseer.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/onmob/overseer_onmob.dmi'
	icon_state = "overseerbelt"
	item_state = "overseerbelt"
	color = null

/obj/item/quiver/bolt/light/bandolier
	name = "bolt bandolier"
	desc = "A leather bandolier that can be used to carry bolts. Smaller, sleeker, yet nevertheless spacious enough to pack enough ammunition for a full nite's hunt."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/ammo.dmi'
	icon_state = "bandolier0"
	item_state = "bandolier"
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/weapons/ammo_onmob.dmi'
	alternate_worn_layer = null
	slot_flags = ITEM_SLOT_CLOAK

/obj/item/quiver/bolt/light/bandolier/update_icon()
	if(arrows.len)
		icon_state = "bandolier1"
	else
		icon_state = "bandolier0"

/obj/item/quiver/bolt/light/bandolier/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/light/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/light/bandolier/getonmobprop(tag)
	..()
	return list("shrink" = 0.38,"sx" = 0,"sy" = 2,"nx" = 0,"ny" = 1,"wx" = 0,"wy" = 0,"ex" = 1,"ey" = -1,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = 0,"sturn" = 0,"wturn" = -30,"eturn" = -35,"nflip" = -1,"sflip" = 0,"wflip" = 5,"eflip" = 0)
