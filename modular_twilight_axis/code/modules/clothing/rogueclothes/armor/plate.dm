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

/obj/item/clothing/head/roguetown/helmet/baotha_ta
	name = "saccharine sallet"
	desc = "Lo', the twins of beauty; Eora and Belladoth, they sought a prize which but one may have.."
	icon_state = "baothahelm"
	item_state = "baothahelm"
	body_parts_covered = HEAD | HAIR | EARS | MOUTH | EYES
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_HELMET_ANTAG - 250 //Halved durability, compared to traditional Ascendant-tier armor.
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/head/roguetown/helmet/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "HELMET")

/obj/item/clothing/head/roguetown/helmet/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/neck/roguetown/coif/baotha_ta
	name = "saccharine veil"
	desc = "And yet, their methods differed; Belladoth proposed with Her lust and temptation, Eora with Her love and warmth.."
	icon_state = "baothacoif"
	item_state = "baothacoif"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	body_parts_covered = NECK | HAIR | EARS | HEAD | NOSE
	armor_class = ARMOR_CLASS_LIGHT
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	color = null
	chunkcolor = "#645567"
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/neck/roguetown/coif/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "VEIL")
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/cloth_wipe (1).ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/coif/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/coif/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha_ta
	name = "saccharine plate armor"
	desc = "Is it not obvious what Ravox would've chosen? Yet upon the dae of His choice, She refused to gift any chance to Her sister.."
	icon_state = "baothaplate"
	item_state = "baothaplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG - 250 //TA EDIT
	armor_class = ARMOR_CLASS_LIGHT //The big, big thing.
	color = null
	chunkcolor = "#dd2166"
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "ARMOR")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/plate/fluted/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha_ta
	name = "saccharine vestments"
	desc = "A gemmed chalice, Eora's own, swilled with Psydonia's most noxious venoms - and but a simple sip was enough to bring Her to death's door.."
	icon_state = "baothagamb"
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_BRIGANDINE
	color = null
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	armor_class = ARMOR_CLASS_LIGHT
	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "VESTMENTS")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/gambeson/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/wrists/roguetown/bracers/leather/baotha_ta
	name = "saccharine cuffs"
	desc = "A betrayal without compare, and a sin without redemption; or so, She believed.."
	icon_state = "baothabracers"
	chunkcolor = "#6d1c87"
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/wrists/roguetown/bracers/leather/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "BRACERS")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/wrists/roguetown/bracers/leather/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/wrists/roguetown/bracers/leather/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/under/roguetown/skirt/baotha_ta
	name = "saccharine fauldcoat"
	desc = "Only did Belladona's haze clear, once She heard Eora's gasps and Ravox's fright; what else could She've done besides fleeing the heavens?"
	armor = ARMOR_MAILLE
	icon_state = "baothaskirt"
	chunkcolor = "#6d1c87"
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	body_parts_covered = GROIN | LEGS
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/under/roguetown/skirt/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SKIRT")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/under/roguetown/skirt/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/under/roguetown/skirt/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/gloves/roguetown/plate/baotha_ta
	name = "saccharine gauntlets"
	desc = "Belladonna's ego died on that dae, and Baotha's venomous id rose in Her stead; for it was better to numb the regret than to face the guilt.."
	icon_state = "baothagloves"
	item_state = "baothagloves"
	chunkcolor = "#6d1c87"
	max_integrity = ARMOR_INT_SIDE_ANTAG - 250
	armor_class = ARMOR_CLASS_LIGHT
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/gloves/roguetown/plate/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "GLOVES")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/gloves/roguetown/plate/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/gloves/roguetown/plate/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta
	name = "saccharine heels"
	desc = "..yet, even as She indulges and mourns beneath the stars, one must wonder; is She truly damned by the Pantheon, or by Herself alone?"
	icon_state = "baothaboots"
	item_state = "baothaboots"
	chunkcolor = "#6d1c87"
	max_integrity = ARMOR_INT_SIDE_ANTAG - 200
	armor_class = ARMOR_CLASS_LIGHT
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_HEELS, 2)
	stepnoise_flag = STEPNOISE_HEELS // This will prevent default footstep noise from being made by the heels (sounds odd)

/obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "BOOTS")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/shoes/roguetown/boots/armor/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)