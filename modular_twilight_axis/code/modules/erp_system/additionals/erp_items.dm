
/obj/item
	var/list/erp_item_tags = null

/obj/item/dildo
	erp_item_tags = list("dildo")

/obj/item/clothing
	var/list/propagade_kink = null
	var/is_bra = FALSE

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
	icon = 'modular_twilight_axis/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/erp_cloth.dmi'
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
	icon = 'modular_twilight_axis/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/erp_cloth.dmi'
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
	icon = 'modular_twilight_axis/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/erp_cloth.dmi'
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
	icon = 'modular_twilight_axis/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/erp_cloth.dmi'
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
	icon = 'modular_twilight_axis/icons/clothing/erp_cloth.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/erp_cloth.dmi'
	propagade_kink = list(
		/datum/kink/submissive = 1,
		/datum/kink/bondage = 1
	)

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

/obj/item/clothing/proc/get_propagade_kinks()
	if(islist(propagade_kink) && propagade_kink.len)
		return propagade_kink
	return null
