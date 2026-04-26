/obj/item/clothing/suit/roguetown/armor/gambeson/steward
	name = "steward tailcoat"
	desc = "A thick, pristine leather tailcoat adorned with polished bronze buttons."
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'
	icon_state = "stewardtailcoat"
	item_state = "stewardtailcoat"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/noble.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/noble.dmi'

/obj/item/clothing/suit/roguetown/shirt/padedetrshirt
	name = "padded etruscan shirt"
	desc = "A strong loosely worn quilted shirt that places little weight on the arms."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	allowed_race = NON_DWARVEN_RACE_TYPES
	boobed = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	icon_state = "etrrubaha"
	color = "#FFFFFF"
	var/shiftable = FALSE
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 35
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
/obj/item/clothing/suit/roguetown/shirt/padedetrshirt/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/shirt/padedetrshirt/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)
