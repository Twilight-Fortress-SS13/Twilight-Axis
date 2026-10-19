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

/obj/item/storage/belt/rogue/leather/knifebelt/smoke
	name = "smoke belt"
	desc = "A four-slotted belt meant for smoke grenades. Little room left over."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = "smokebelt"
	item_state = "smokebelt"
	strip_delay = STRIP_DELAY_FAST
	max_storage = 3
	var/list/grenades = list()
	sewrepair = TRUE
	component_type = /datum/component/storage/concrete/roguetown/belt/knife_belt

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/attack_turf(turf/T, mob/living/user)
	if(grenades.len >= max_storage)
		to_chat(user, span_warning("Your [src.name] is full!"))
		return
	to_chat(user, span_notice("You begin to gather the ammunition..."))
	for(var/obj/item/impact_grenade/smoke/K in T.contents)
		if(do_after(user, 5))
			if(!eatsmoke(K))
				break

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/proc/eatsmoke(obj/A)
	if(A.type in typesof(/obj/item/impact_grenade/smoke))
		if(grenades.len < max_storage)
			A.forceMove(src)
			grenades += A
			update_icon()
			return TRUE
		else
			return FALSE

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/attackby(obj/A, loc, params)
	if(A.type in typesof(/obj/item/impact_grenade/smoke))
		if(grenades.len < max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			grenades += A
			update_icon()
			to_chat(usr, span_notice("I discreetly slip [A] into [src]."))
		else
			to_chat(loc, span_warning("Full!"))
		return
	..()

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/attack_right(mob/user)
	if(grenades.len)
		var/obj/O = grenades[grenades.len]
		grenades -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/examine(mob/user)
	. = ..()
	if(grenades.len)
		. += span_notice("[grenades.len] inside.")

/obj/item/storage/belt/rogue/leather/knifebelt/smoke/Initialize(mapload)
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/impact_grenade/smoke/A = new()
		grenades += A
