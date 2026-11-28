// Prestige is assessed on worn layers, never on cargo, bags, or weapons.
GLOBAL_LIST_INIT(ta_noble_attire_slots, list( \
	SLOT_HEAD, \
	SLOT_WEAR_MASK, \
	SLOT_GLASSES, \
	SLOT_NECK, \
	SLOT_CLOAK, \
	SLOT_ARMOR, \
	SLOT_SHIRT, \
	SLOT_PANTS, \
	SLOT_SHOES, \
	SLOT_GLOVES, \
	SLOT_WRISTS, \
	SLOT_RING, \
))

GLOBAL_LIST_INIT(ta_noble_attire_prestigious_types, typecacheof(list( \
	/obj/item/clothing/suit/roguetown/shirt/dress/royal, \
	/obj/item/clothing/suit/roguetown/shirt/dress/nobledress, \
	/obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat, \
	/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic, \
	/obj/item/clothing/suit/roguetown/armor/silkcoat, \
	/obj/item/clothing/cloak/lordcloak, \
	/obj/item/clothing/cloak/half/azuria, \
	/obj/item/clothing/cloak/tabard/retinue/banneret, \
	/obj/item/clothing/cloak/tabard/stabard/surcoat/bailiff, \
	/obj/item/clothing/neck/roguetown/ornateamulet/noble, \
	/obj/item/clothing/ring/gold, \
	/obj/item/clothing/ring/band/gold, \
)))

/mob/living/carbon/human
	var/list/ta_noble_issued_attire
	var/ta_next_noble_attire_check = 0

/// Record the actual pieces issued to a fixed T3 role, before the player can
// change outfits.
/mob/living/carbon/human/proc/taRecordNobleRoleAttire()
	if(ta_noble_issued_attire)
		return
	ta_noble_issued_attire = list()
	for(var/slot in GLOB.ta_noble_attire_slots)
		var/obj/item/clothing/piece = get_item_by_slot(slot)
		if(istype(piece))
			ta_noble_issued_attire += WEAKREF(piece)

/proc/taNobleAttireIsPrestigious(obj/item/clothing/piece)
	if(
		piece.item_quality != ITEM_QUALITY_WORN \
		&& piece.item_quality < ITEM_QUALITY_STANDARD
	)
		return FALSE
	if(piece.salvage_result == /obj/item/natural/silk || is_type_in_typecache(
		piece,
		GLOB.ta_noble_attire_prestigious_types
	))
		return TRUE
	// Stable catalogue prices make this a property of the outfit rather than a
	// market roll.
	var/base_value = initial(piece.sellprice) \
		|| GLOB.derived_sellprices?[piece.type] \
		|| lookup_derived_subtype_price(piece.type)
	return base_value >= 45

/proc/taNobleAttireCosmetics(obj/item/clothing/piece)
	var/attachment_type
	if(istype(piece, /obj/item/clothing/suit/roguetown/armor))
		var/obj/item/clothing/suit/roguetown/armor/armour = piece
		attachment_type = armour.attachment_component
	else if(istype(piece, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = piece
		attachment_type = hat.attachment_component
	else if(istype(piece, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/gauntlets = piece
		attachment_type = gauntlets.attachment_component
	if(attachment_type)
		return piece.GetComponent(attachment_type)

/proc/taNobleAttireSlotIsPrestigious(obj/item/clothing/piece)
	if(taNobleAttireIsPrestigious(piece))
		return TRUE
	var/datum/component/storage/concrete/roguetown/cosmetics = \
		taNobleAttireCosmetics(piece)
	if(!cosmetics)
		return FALSE
	for(var/obj/item/clothing/cosmetic in cosmetics.item_to_grid_coordinates)
		if(
			!(cosmetic.item_flags & NOT_SHOW_IN_STORAGE) \
			&& taNobleAttireIsPrestigious(cosmetic)
		)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/taNobilityOutfitEvent()
	var/coverage = NONE
	var/issued_coverage = NONE
	var/issued_pieces = 0
	var/prestigious_slots = 0
	var/list/visible_slots = GLOB.ta_noble_attire_slots - \
		check_obscured_slots(FALSE)
	for(var/slot in visible_slots)
		var/obj/item/clothing/piece = get_item_by_slot(slot)
		if(!istype(piece))
			continue
		var/covers_body = slot == SLOT_SHIRT || slot == SLOT_ARMOR \
			|| slot == SLOT_PANTS || slot == SLOT_CLOAK
		var/piece_coverage = piece.body_parts_covered
		if(slot == SLOT_ARMOR && (piece.flags_inv & HIDEJUMPSUIT))
			// The outer garment is drawn in place of trousers.
			piece_coverage |= GROIN
		if(covers_body)
			coverage |= piece_coverage
		// A shirt buried under chest armour may still dress the legs, as with a
		// gown.
		if(
			slot == SLOT_SHIRT \
			&& (wear_armor?.body_parts_covered & CHEST) \
			&& !(piece.body_parts_covered & (GROIN|LEGS))
		)
			continue
		if(
			ta_noble_issued_attire \
			&& (piece.weak_reference in ta_noble_issued_attire)
		)
			issued_pieces++
			if(covers_body)
				issued_coverage |= piece_coverage
		if(taNobleAttireSlotIsPrestigious(piece))
			prestigious_slots++
		if(
			prestigious_slots >= 2 \
			&& (coverage & CHEST) \
			&& (coverage & (GROIN|LEGS))
		)
			return /datum/stressevent/ta_noble_representative_attire
	if(!(coverage & CHEST) || !(coverage & (GROIN|LEGS)))
		return /datum/stressevent/ta_noble_improper_attire
	if(prestigious_slots >= 2)
		return /datum/stressevent/ta_noble_representative_attire
	if(
		prestigious_slots \
		|| (
			issued_pieces >= 2 \
			&& (issued_coverage & CHEST) \
			&& (issued_coverage & (GROIN|LEGS))
		)
	)
		return null
	return /datum/stressevent/ta_noble_improper_attire

/mob/living/carbon/human/proc/taUpdateNobleAttireMood(tier)
	var/outfit_event = tier == 3 ? taNobilityOutfitEvent() : null
	if(outfit_event != /datum/stressevent/ta_noble_improper_attire)
		remove_stress(/datum/stressevent/ta_noble_improper_attire)
	if(outfit_event != /datum/stressevent/ta_noble_representative_attire)
		remove_stress(/datum/stressevent/ta_noble_representative_attire)
	if(outfit_event && !has_stress_event(outfit_event))
		add_stress(outfit_event)

// Cosmetic visibility and stains can change without an equip/unequip event.
/mob/living/carbon/human/update_stress()
	if(!client || stat != CONSCIOUS)
		return ..()
	taUpdateNobleWetness()
	if(
		world.time >= ta_next_noble_attire_check \
		&& (ta_next_noble_attire_check || taAppliedNobilityTier() >= 1)
	)
		check_equipment_mood_penalty()
	return ..()

/datum/stressevent/ta_noble_improper_attire
	stressadd = 1
	desc = span_red("Мой наряд не подобает моему положению.")
	timer = 999 MINUTES // Cleared when the outfit changes.

/datum/stressevent/ta_noble_representative_attire
	stressadd = -1
	desc = span_green("Мой наряд подобает моему положению.")
	timer = 999 MINUTES // Cleared when the outfit changes.

/mob/living/carbon/human/proc/taCheckNobleEquipment()
	var/tier = taAppliedNobilityTier()
	ta_next_noble_attire_check = tier >= 1 ? world.time + 5 SECONDS : 0
	var/any_bad = FALSE
	var/any_bloody = FALSE
	if(tier >= 1)
		for(var/obj/item/I in get_equipped_items())
			if(
				(I.item_quality != ITEM_QUALITY_WORN) \
				&& (I.item_quality < ITEM_QUALITY_STANDARD)
			)
				any_bad = TRUE
			if(
				!cmode \
				&& (
					HAS_BLOOD_DNA(I) \
					|| I.GetComponent(/datum/component/decal/blood)
				)
			)
				any_bloody = TRUE
			if(any_bad && (cmode || any_bloody))
				break
	if(
		any_bad \
		&& !has_stress_event(/datum/stressevent/unlanded_noble_shitty_equipment)
	)
		add_stress(/datum/stressevent/unlanded_noble_shitty_equipment)
	else if(!any_bad)
		remove_stress(/datum/stressevent/unlanded_noble_shitty_equipment)

	if(
		any_bloody \
		&& !has_stress_event(/datum/stressevent/unlanded_noble_bloody_equipment)
	)
		add_stress(/datum/stressevent/unlanded_noble_bloody_equipment)
	else if(!any_bloody)
		remove_stress(/datum/stressevent/unlanded_noble_bloody_equipment)

	taUpdateNobleAttireMood(tier)
