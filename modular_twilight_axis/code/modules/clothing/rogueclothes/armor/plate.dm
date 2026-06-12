/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/twilight_elven
	name = "elven rider cuirass"
	desc = "An expertly smithed form-fitting steel cuirass that is much lighter and agile, but breaks with much more ease. Its sleek design marks it as a product of elven craftsmanship."
	icon_state = "elven_chestplate"
	item_state = "elven_chestplate"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'

/obj/item/clothing/suit/roguetown/armor/plate/raneshen_scale
	slot_flags = ITEM_SLOT_ARMOR
	name = "ranesheni medium lamellar armor"
	desc = "Armor used by the Empire's vanguard fighters. The plates are connected to each other with cord for mobility. The arms are protected by pauldrons, and the legs by a small chainmail skirt. The armor itself is decorated with bronze."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/32х48/sleeves_armor.dmi'
	icon_state = "medium_armour"
	item_state = "medium_armour"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	allowed_sex = list(MALE, FEMALE)
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/full/raneshen_plated
	name = "ranesheni plate armor"
	desc = "Full-fledged armor with scales, a light chainmail skirt protects the lower legs, has bronze decorations and strong protective shoulder pads."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/helpers/32х48/sleeves_armor.dmi'
	icon_state = "heavy_armour"
	item_state = "heavy_armour"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smelt_bar_num = 4
	armor_class = ARMOR_CLASS_HEAVY

// Heavy armour NECK coverage buff:

/obj/item/clothing/suit/roguetown/armor/plate/fluted
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar // As specified in PR neck coverage buff is only for HEAVY, therefore i exclude graggar halfplate
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET

/obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/plate/otavan
	body_parts_covered = COVERAGE_TORSO | NECK

/obj/item/clothing/suit/roguetown/armor/plate/full
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | NECK

/obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa
	body_parts_covered = COVERAGE_ALL_BUT_LEGS | NECK

/obj/item/clothing/suit/roguetown/armor/plate/vampire
	body_parts_covered = COVERAGE_ALL_BUT_LEGS | NECK

/obj/item/clothing/suit/roguetown/armor/plate/full/bikini
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|NECK

/obj/item/clothing/suit/roguetown/armor/heartfelt/lord // In fact - is plate armour
	body_parts_covered = COVERAGE_ALL_BUT_LEGS | NECK

/obj/item/clothing/suit/roguetown/armor/heartfelt/hand
	body_parts_covered = COVERAGE_ALL_BUT_LEGS | NECK

/obj/item/clothing/suit/roguetown/armor/plate/scale/townguard
	name = "watchman's armor"
	desc = "Тяжелая броня, что выдается городскому Дозору."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/citywatch_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/helpers/citywatch_sleeves_armor.dmi'
	icon_state = "citywatch"
	item_state = "citywatch"

/obj/item/clothing/suit/roguetown/armor/plate/scale/townguard/sheriff
	name = "sheriff's armor"
	desc = "Тяжелая броня, которая принадлежит Шерифу Дозора."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/citywatch_armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/citywatch_armor.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/helpers/citywatch_sleeves_armor.dmi'
	icon_state = "sheriffarmor"
	item_state = "sheriffarmor"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/etrcuirass
	name = "etruscan cuirass"
	icon_state = "etrcuirass"
	desc = "An steel cuirass, fine fitted with tassets for additional coverage. Typically seen on Etruscan heavy infantry."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	body_parts_covered = CHEST | VITALS | LEGS | NECK
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	detail_color = "#FFFFFF"
	detail_tag = "_detail"
	boobed = FALSE
	detail_color = CLOTHING_WHITE
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/etrcuirass/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	name = "scourge pouncer"
	desc = "Segmented armour set consisting of overlapping avantyne plates riveted inside a Drow-crafted hide garment. While less sophisticated than the armor of Her true champions, this set is favoured by the Drow legionnaires who venture into the surface world."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "shadowfullplate"
	item_state = "shadowfullplate"

/obj/item/clothing/suit/roguetown/armor/plate/twilight_shadowplate
	name = "scourge half-plate"
	desc = "As close as most Dark Elves are willing to get to actual plate armor. This set consists of an avantyne cuirass and pauldrons with an underlying layer of sturdy Drow-crafted leather."
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "shadowplate"
	item_state = "shadowplate"
	allowed_race = NON_DWARVEN_RACE_TYPES
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 2
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
