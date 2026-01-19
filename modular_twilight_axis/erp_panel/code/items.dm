/obj/item/clothing
	var/list/propagade_kink = null
	var/is_bra = FALSE

/obj/item/clothing/suit/roguetown/armor/chainmail/bikini/bra
	name = "chainmail bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "chainbra"
	item_state = "chainbra"
	desc = "Try not to get your nipples caught between the chains."
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/bikini/bra
	name = "iron chainmail bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "chainbra"
	item_state = "chainbra"
	color = "#9EA48E"
	desc = "Try not to get your nipples caught between the chains."
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/bikini/bra
	name = "half-plate bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "halfplatebra"
	item_state = "halfplatebra"
	desc = "Half plate that's even half-er, still just as protective somehow."
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/full/bikini/bra
	name = "fullplate bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "platebra"
	item_state = "platebra"
	desc = "The black and white line between absolute protection and none."
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/bikini/bra
	name = "Leather armor bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "leatherbra"
	item_state = "leatherbra"
	desc = "Flexible cowhide armor. Lightweight, better than nothing, Although the bottom half is literally covered by nothing, it somehow still protects the full torso!"
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini/bra
	name = "studded Leather bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "studleatherbra"
	item_state = "studleatherbra"
	desc = "Studded leather is the most durable of all hides and leathers and about as light. Although the bottom half is literally covered by nothing, it somehow still protects the full torso!"
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini/bra
	name = "hide bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "hidearmorbra"
	item_state = "hidearmorbra"
	desc = "A light armor of wildbeast hide. Far more durable than leather. This will not keep a person warm though... The bottom half is literally covered by nothing, it somehow still protects the full torso!"
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/advanced/bikini/bra
	name = "hardened leather bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "advbra"
	item_state = "advbra"
	desc = "Sturdy, durable, flexible. Will keep you alive in style, and now even... EVEN less than before!"
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/masterwork/bikini/bra
	name = "enhanced leather bra"
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	icon_state = "mastbra"
	item_state = "mastbra"
	desc = "This... bra is a craftsmanship marvel. Made with the finest leather. Strong, VERY VERY nimible, reliable."
	flags_inv = HIDEBOOB
	is_bra = TRUE

/obj/item/clothing/suit/roguetown/armor/corset/pony
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "pony corset"
	desc = "A tight leather corset with straps and rings. It forces posture, breath, and obedience."
	icon_state = "hcorset"
	item_state = "hcorset"
	armor_class = ARMOR_CLASS_LIGHT
	body_parts_covered = CHEST
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/shoes/roguetown/boots/pony
	name = "pony boots"
	color = "#3f2f22"
	desc = "Heavy leather boots built for a clipped, controlled gait."
	gender = PLURAL
	icon_state = "hlegs"
	item_state = "hlegs"
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	salvage_amount = 2
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/gloves/roguetown/leather/ponyhooves
	name = "pony hooves"
	desc = "Leather gloves shaped into hooves, awkward for work and perfect for play."
	icon_state = "harms"
	item_state = "harms"
	armor = ARMOR_LEATHER
	prevent_crits = PREVENT_CRITS_NONE
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	unarmed_bonus = 1.0
	color = "#4b3a2c"
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	cold_protection = 2
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/head/roguetown/helmet/pony_harness
	name = "pony harness gag"
	desc = "A leather muzzle-harness with a gag piece. Talking becomes a suggestion."
	icon_state = "hbit"
	item_state = "hbit"
	sewrepair = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/obj/item/clothing/head/roguetown/helmet/pony_harness/Initialize(mapload)
	. = ..()
	flags_inv |= HIDEMASK

/obj/item/clothing/head/roguetown/helmet/pony_harness/equipped(mob/living/user, slot)
	. = ..()
	if(istype(user))
		user.update_mobility()

/obj/item/clothing/head/roguetown/helmet/pony_harness/dropped(mob/living/user)
	. = ..()
	if(istype(user))
		user.update_mobility()

/obj/item/clothing/mask/rogue/blindfold/pony
	name = "pony blindfold"
	desc = "A thick blindfold that leaves only trust (or panic)."
	icon_state = "hblinders"
	item_state = "hblinders"
	body_parts_covered = EYES
	sewrepair = TRUE
	tint = 2
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	icon = 'modular_twilight_axis/erp_panel/icons/clothing.dmi'
	mob_overlay_icon = 'modular_twilight_axis/erp_panel/icons/onmob/clothing.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

/datum/anvil_recipe/armor/ironchainbra
	name = "Iron Chainmail Bra"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/iron/bikini/bra
	i_type = "Armor"

/datum/anvil_recipe/armor/chainbra
	name = "Chainmail Bra"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/clothing/suit/roguetown/armor/chainmail/bikini/bra
	i_type = "Armor"

/datum/crafting_recipe/roguetown/sewing/leather/coat/masterworkbra
	name = "masterwork leather bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/masterwork/bikini/bra
	reqs = list(/obj/item/natural/hide/cured = 4,
				/obj/item/natural/cured/essence = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/leather/hardenedbra
	name = "hardened leather bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/advanced/bikini/bra
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/leather/pony_corset
	name = "pony attire (corset)"
	reqs = list(
		/obj/item/natural/hide/cured = 3,
		/obj/item/natural/fibers = 2
	)
	result = /obj/item/clothing/suit/roguetown/armor/corset/pony

/datum/crafting_recipe/roguetown/leather/pony_boots
	name = "pony attire (boots)"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	result = /obj/item/clothing/shoes/roguetown/boots/pony

/datum/crafting_recipe/roguetown/leather/pony_hooves
	name = "pony attire (hooves)"
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1
	)
	result = /obj/item/clothing/gloves/roguetown/leather/ponyhooves

/datum/crafting_recipe/roguetown/leather/pony_harness
	name = "pony attire (harness gag)"
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	result = /obj/item/clothing/head/roguetown/helmet/pony_harness

/datum/crafting_recipe/roguetown/leather/pony_blindfold
	name = "pony attire (blindfold)"
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	result = /obj/item/clothing/mask/rogue/blindfold/pony

/datum/crafting_recipe/roguetown/larmorconv
	name = "leather bikini to bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/bikini/bra
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/bikini = 1)

/datum/crafting_recipe/roguetown/hidearmorconv
	name = "hide bikini to bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/hide/bikini/bra
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini = 1)

/datum/crafting_recipe/roguetown/studdedconv
	name = "studded bikini to bra"
	result = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini/bra)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini = 1)

/datum/crafting_recipe/roguetown/lharmorconv
	name = "hardened leather bikini to bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/advanced/bikini/bra
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/advanced/bikini = 1)

/datum/crafting_recipe/roguetown/lmarmorconv
	name = "enhanced leather bikini to bra"
	result = /obj/item/clothing/suit/roguetown/armor/leather/masterwork/bikini/bra
	reqs = list(/obj/item/clothing/suit/roguetown/armor/leather/masterwork/bikini = 1)

/datum/crafting_recipe/roguetown/ichainkiniconv
	name = "chainmail bikini to bra"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/iron/bikini/bra)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/iron/bikini = 1)

/datum/crafting_recipe/roguetown/chainkiniconv
	name = "chainmail bikini to bra"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/bikini/bra)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/bikini = 1)

/datum/crafting_recipe/roguetown/halfplateconv
	name = "halfplate bikini to bra"
	result = list(/obj/item/clothing/suit/roguetown/armor/plate/bikini/bra)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/bikini = 1)

/datum/crafting_recipe/roguetown/halfplateconv
	name = "fullplate bikini to bra"
	result = list(/obj/item/clothing/suit/roguetown/armor/plate/full/bikini/bra)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/full/bikini = 1)
