/obj/item/clothing/suit/roguetown/armor/plate/Initialize()
	. = ..()
	if(body_parts_covered == COVERAGE_ALL_BUT_HANDFEET || armor_class == ARMOR_CLASS_HEAVY)
		body_parts_covered |= NECK

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
	name = "ranesheni scalemail"
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
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smelt_bar_num = 4
	armor_class = ARMOR_CLASS_HEAVY

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

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/legion
	name = "elyrian lorica masculata"
	desc = "Доспех, демонстрирующий высокое мастерство кузнеца. Чётко выведенный рельеф анатомического торса подчеркивает красоту и мужество его обладателя. Из-за высокой цены маскулату носят в основном преторианцы и почтенные патриции Элиррии."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "legioncuirass"
	item_state = "legioncuirass"
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL

/obj/item/clothing/suit/roguetown/armor/plate/legion
	name = "elyrian lorica segmentata"
	desc = "Пластинчатый доспех, собранный из скрепленных между собой стальных пластин. Несмотря на дороговизну, легионеры и преторианцы отдают ему предпочтение за надёжность и удобство."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "legionplate"
	item_state = "legionplate"

/obj/item/clothing/suit/roguetown/armor/plate/fluted/zizo/bloodraider
	name = "raider's cuirass"
	desc = "An elegant cuirass that doesn't restrict movement, intimidates enemies, and is simply beautiful. What more could you need?"
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'
	icon_state = "bloodcuirass"
	item_state = "bloodcuirass"
	allowed_race = list(/datum/species/elf/wood, /datum/species/human/halfelf, /datum/species/elf/dark)
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG - 400
	armor_class = ARMOR_CLASS_LIGHT
	unenchantable = FALSE
	smelt_bar_num = 1

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bloodraider/ComponentInitialize()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bloodraider/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/overseer
	name = "confessor coat"
	desc = "Тяжелое, укрепленное пальто с изысканным бордовым покрытием не оставит никого равнодушным."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/overseer.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/onmob/overseer_onmob.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/inquisition_overseer/onmob/overseer_onmob.dmi'
	icon_state = "viceseercoat"
	item_state = "viceseercoat"
	color = null
	boobed = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/hussar
	name = "hussar's plate harness"
	desc = "An ornate suit of plate armour made with Aavnr's finest Vyšvou steel, meant to be used by the Potentate's elite cavalry. A frame is attached to the back of the cuirass, and raptor feathers create the illusion of an angel's wings."
	icon_state = "hussar"
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/armor.dmi'
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	body_parts_covered = COVERAGE_ALL_BUT_HANDLEGS
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	equip_delay_other = 2 SECONDS
	strip_delay = 4 SECONDS
	smelt_bar_num = 2
	boobed = FALSE
	worn_x_dimension = 32
	worn_y_dimension = 36
	allowed_race = NON_DWARVEN_RACE_TYPES
