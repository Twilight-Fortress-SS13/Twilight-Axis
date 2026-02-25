/obj/item/clothing/mask/rogue/Initialize()
	. = ..()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_INQUISITION)

/obj/item/clothing/mask/rogue/lordmask/naledi/decorated
	armor = null
	prevent_crits = null

/obj/item/clothing/mask/rogue/facemask/xylixmask
	name = "xylixian mask"
	desc = "A ceramic mask, forever stuck with the joyful smile its patron god favors. While it will shatter easily from blows, its smug countenance shall taunt its foes."
	max_integrity = 50
	armor = null
	prevent_crits = null
	drop_sound = 'sound/foley/brickdrop.ogg'
	pickup_sound = 'sound/foley/brickdrop.ogg'
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "xylixmask"
	item_state = "xylixmask"
	detail_tag = "_l"
	altdetail_tag = "_r"
	color = "#FFFFFF"
	detail_color = "#4756d8"
	altdetail_color = "#b8252c"
	anvilrepair = /datum/skill/craft/ceramics
	smeltresult = null

/obj/item/clothing/mask/rogue/facemask/xylixmask/Initialize()
	..()
	update_icon()

/obj/item/clothing/mask/rogue/facemask/xylixmask/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/mask/rogue/facemask/xylixmask/armored
	max_integrity = 200
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)

/obj/item/clothing/mask/rogue/facemask/xylixmask/armored/Initialize()
	..()
	update_icon()

/obj/item/clothing/mask/rogue/facemask/xylixmask/armored/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/dendormask/armored
	max_integrity = 200
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)

/obj/item/clothing/mask/rogue/eyepatch
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	color = "#292929"

/obj/item/clothing/mask/rogue/eyepatch/fake
	desc = "An eyepatch, fitted for the right eye. It has an almost imperceptible gap so that you can see something."
	block2add = null

/obj/item/clothing/mask/rogue/eyepatch/left/fake
	desc = "An eyepatch, fitted for the left eye. It has an almost imperceptible gap so that you can see something."
	block2add = null

/obj/item/clothing/mask/rogue/facemask/steel/kazengun
	armor = ARMOR_PLATE

/obj/item/clothing/mask/rogue/ragmask/bishop
	name = "bishop mask"
	icon_state = "bishop_mask"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP|ITEM_SLOT_HEAD
	experimental_onhip = TRUE
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/rogue/ragmask/bishop/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CHOSEN, "VISAGE")

/obj/item/clothing/mask/rogue/facemask/steel/psythorns
	name = "mask of psydonian thorns"
	desc = "Expressionless steel mask, decorated with a set of blacksteel thorns. Never forget you are why Psydon wept."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/masks.dmi'
	icon_state = "psybarbsmask"
	item_state = "psybarbsmask"
	smeltresult = /obj/item/ingot/blacksteel
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = PREVENT_CRITS_ALL
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	body_parts_covered = FACE|HAIR|HEAD

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP|ITEM_SLOT_MASK
	name = "accursed mask"
	desc = "Mask made from the skull of Volf, detailed with blood of animals and heretics, enchanted with their souls."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "norswolf"
	item_state = "norswolf"
	var/on = FALSE
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_power = 1
	toggle_icon_state = TRUE

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch/Initialize(mapload)
	. = ..()
	set_light_on(FALSE)

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	toggle_helmet_light(user)
	to_chat(user, span_info("I spark [src] [on ? "on" : "off"]."))

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch/proc/toggle_helmet_light(mob/living/user)
	on = !on
	set_light_on(on)
	if(on)
		playsound(loc, 'sound/effects/hood_ignite.ogg', 100, TRUE)
		do_sparks(2, FALSE, user)
	else
		playsound(loc, 'sound/misc/toggle_lamp.ogg', 100)
	update_icon()

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch/update_icon()
	if(on)
		icon_state = "norswolf_lit"
		item_state = "norswolf_lit"
	else
		icon_state = "norswolf"
		item_state = "norswolf"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()
		H.update_inv_wear_mask()
	..()

/obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf/wretch/ResetAdjust(mob/user)
	. = ..()
	if(on)
		set_light_on(FALSE)
	update_icon()
