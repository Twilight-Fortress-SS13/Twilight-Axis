/obj/item/clothing/wrists/roguetown/bracers/twilight_elven
	name = "elven rider bracers"
	desc = "Elegant steel bracers, meant to protect the wearer's wrists from cutting attacks. Their sleek design marks them as a product of elven craftsmanship."
	icon_state = "elven_armplates"
	item_state = "elven_armplates"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	alternate_worn_layer = WRISTS_LAYER

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/bloodraider
	name = "raiders bracers"
	desc = "A pair of steel vambraces, protecting the arms from blows-most-foul. Painted in black and red"
	icon_state = "bloodbracers"
	item_state = "bloodbracers"
	allowed_race = NON_DWARVEN_RACE_TYPES
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'
	sleeved = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'
	alternate_worn_layer = WRISTS_LAYER

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/bloodraider/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/bloodraider/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/wrists/roguetown/bracers/twilight_elven/bloodraider/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

// --- Lunacy Embracer ---
/obj/item/clothing/wrists/roguetown/bracers/lunacy
	name = "lunacy bracers"
	desc = "The moon's touch hardened the furthest reaches of me - my hands, my wrists, the places that once trembled with fear.\
	</br>Now they do not. I meditate, and they remember their strength."
	icon_state = null
	body_parts_covered = ARMS
	armor = ARMOR_PLATE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_STEEL
	anvilrepair = null
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	blocking_behavior = SAMEWEAR
	pickup_sound = 'sound/foley/equip/equip_armor.ogg'
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/repairmsg_end = "The moonlight fades from my bracers as they settle into calm strength."
	var/repairmsg_continue = "My bracers mend some of their abuse..."
	var/repairmsg_full = "My lunacy bracers are already whole."
	var/repair_fraction = 0.35
	var/repair_percent

/obj/item/clothing/wrists/roguetown/bracers/lunacy/Initialize(mapload)
	. = ..()
	if(isnull(repair_percent))
		repair_percent = repair_fraction * max_integrity
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/wrists/roguetown/bracers/lunacy/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(ishuman(user) && slot == SLOT_WRISTS)
		RegisterSignal(user, COMSIG_MOB_MEDITATED, PROC_REF(on_wearer_meditated), override = TRUE)

/obj/item/clothing/wrists/roguetown/bracers/lunacy/dropped(mob/living/carbon/human/user)
	if(ismob(user))
		UnregisterSignal(user, COMSIG_MOB_MEDITATED)
	..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/wrists/roguetown/bracers/lunacy/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Repairable by completing a *meditate emote.")

/obj/item/clothing/wrists/roguetown/bracers/lunacy/proc/on_wearer_meditated(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = loc
	if(!ishuman(H) || H.wear_wrists != src)
		return
	if(obj_integrity >= max_integrity)
		to_chat(user, span_warning(repairmsg_full))
		return
	armour_regen()

/obj/item/clothing/wrists/roguetown/bracers/lunacy/proc/armour_regen(repair_amount = repair_percent)
	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
	to_chat(loc, span_notice(repairmsg_continue))
	obj_integrity = min(obj_integrity + repair_amount, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)
