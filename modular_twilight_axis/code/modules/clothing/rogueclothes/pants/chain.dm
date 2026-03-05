/obj/item/clothing/under/roguetown/chainlegs/grenzelhoft
	name = "grenzelhoftian paumpers w/chain chausses"
	desc = "A set of mail chausses forged from interlinked steel rings, worn over vibrant Grenzelhoftian padded paumpers."
	icon_state = "grenzelchain_legs"
	item_state = "grenzelchain_legs"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	detail_color = "#1d1d22"
	altdetail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_LEG_STEEL_CHAIN + 10

/obj/item/clothing/under/roguetown/chainlegs/grenzelhoft/update_icon()
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

/obj/item/clothing/under/roguetown/trou/leather/hakama
	name = "hakama"
	desc = ""
	icon_state = "hakama"
	item_state = "hakama"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	salvage_result = null
