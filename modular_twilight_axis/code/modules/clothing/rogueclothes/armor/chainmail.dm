/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft
	name = "grenzelhoftian hip-shirt w/hauberk"
	desc = "A maille-aketon of steel layered atop a vividly adorned Grenzelhoftian padded hip-shirt, uniting bold fashion with steadfast protection."
	icon_state = "grenzelhauberk"
	item_state = "grenzelhauberk"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	detail_color = "#1d1d22"
	altdetail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL + 10

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft/update_icon()
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

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ornate // Heavy armour NECK coverage buff
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/citywatch
