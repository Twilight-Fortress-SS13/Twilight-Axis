/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket
	name = "noble jacket"
	icon_state = "handcoat"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/noble.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_BLACK
	body_parts_covered = COVERAGE_SHIRT

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/handjacket/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen/new_coat
	name = "ranesheni scale coat"
	desc = "A lightweight armor made from the scales of the Ranesheni \'megarmach\', an armored reptilian creacher that ambushes prey by the riverside, and drags them deep into Abyssor's domain."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/32х48/sleeves_armor.dmi'
	icon_state = "light_armour"
	item_state = "light_armour"
	body_parts_covered = COVERAGE_FULL
