/obj/item/clothing/under/roguetown/gambeson
	name = "gamboised cuisses"
	desc = "A heavy fabric trousers, stuffed with padding. Protect the legs from blows and weather. Worn under armor or alone."
	icon_state = "gambeson"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	body_parts_covered = COVERAGE_ALL_UNDERGROIN
	slot_flags = ITEM_SLOT_PANTS
	armor = ARMOR_PADDED
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	color = "#ad977d"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	chunkcolor = "#978151"
	material_category = ARMOR_MAT_LEATHER
	cold_protection = 10

/obj/item/clothing/under/roguetown/gambeson/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/under/roguetown/gambeson/heavy
	name = "padded gamboised cuisses"
	desc = "A thick, padded cloth trousers, worn beneath armor. A warriors first defense - simple, humble, but vital against bruises and cold."
	icon_state = "gambesonp"
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25
	color = "#976E6B"
