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

/obj/item/clothing/under/roguetown/chainlegs/grenzelhoft/Initialize()
	. = ..()
	update_icon()

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

/obj/item/clothing/under/roguetown/chainlegs/twilight_drow
	name = "scourge chain chausses"
	desc = "The Dark Elves rarely don chainmail, preferring much more comfortable leathers and spider silk. Still, it is not unheard of, especially among the shock troops embedded with the raiding parties that venture into the surface world."
	icon_state = "shadowchains"
	item_state = "shadowchains"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 2

/obj/item/clothing/under/roguetown/bloodsplintlegs
	name = "raiders splintlegs"
	desc = "Raiders best friend, designed to protect the legs while still providing almost complete free range of movement."
	icon_state = "bloodsplintlegs"
	item_state = "bloodsplintlegs"
	max_integrity = ARMOR_INT_LEG_BRIGANDINE
	armor = ARMOR_BRIGANDINE
	blocksound = SOFTHIT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	armor_class = ARMOR_CLASS_LIGHT
	w_class = WEIGHT_CLASS_NORMAL
	//resistance_flags = FIRE_PROOF // these ones should be burning since is cloth + metal
	sewrepair = FALSE
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'

/obj/item/clothing/under/roguetown/bloodsplintlegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_COAT_STEP, 10)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/under/roguetown/bloodsplintlegs/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)
