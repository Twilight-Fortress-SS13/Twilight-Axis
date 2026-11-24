/proc/ta_filter_weapon_intents(list/intents, datum/alt_grip/grip)
	if(!length(intents))
		return intents
	var/static/list/always_allowed = list()
	var/static/list/always_blocked = list()
	var/static/list/blocked_intents
	if(isnull(blocked_intents))
		blocked_intents = list()
		for(var/datum/intent/intent_type as anything in typesof(/datum/intent))
			if(intent_type in always_allowed)
				continue
			if(initial(intent_type.no_attack) || initial(intent_type.tranged) || initial(intent_type.canparry))
				continue
			if(initial(intent_type.penfactor) >= 4 || (initial(intent_type.penfactor) >= 3 && !initial(intent_type.candodge)))
				blocked_intents[intent_type] = TRUE
	var/gated = grip && (grip.skill_req > SKILL_LEVEL_NONE || length(grip.grip_skill) || length(grip.trait_applied))
	var/list/filtered
	for(var/intent_type as anything in intents)
		if(!(intent_type in always_blocked) && (gated || !blocked_intents[intent_type]))
			continue
		if(isnull(filtered))
			filtered = intents.Copy()
		filtered -= intent_type
	if(isnull(filtered))
		return intents
	if(!length(filtered))
		return list(/datum/intent/use)
	return filtered

/obj/item/proc/ta_get_available_weapon_intents(list/intents, datum/alt_grip/grip)
	if(!istype(src, /obj/item/rogueweapon))
		return intents
	return ta_filter_weapon_intents(intents, grip)

/obj/item/proc/ta_get_grip_intents(datum/alt_grip/grip)
	if(grip)
		var/list/intents = grip.get_grip_intents(src)
		if(length(intents))
			return ta_get_available_weapon_intents(intents, grip)
	return ta_get_available_weapon_intents(possible_item_intents)

/obj/item/proc/ta_get_current_weapon_intents()
	if(altgripped)
		return get_altgrip_intents()
	return ta_get_available_weapon_intents(wielded ? gripped_intents : possible_item_intents)

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/datum/unit_test/ta_weapon_intent_filter/Run()
	var/list/blocked = list(
		/datum/intent/axe/chop/heavy,
		/datum/intent/sword/cut/falx/heavy,
		/datum/intent/sword/cut/sabre/heavy,
		/datum/intent/sword/thrust/long/halfsword,
		/datum/intent/sword/thrust/long/halfsword/lesser,
		/datum/intent/sword/thrust/long/halfsword/frei,
		/datum/intent/sword/thrust/rapier/lunge
	)
	var/list/allowed = list(
		/datum/intent/sword/thrust/rapier,
		/datum/intent/sword/cut/rapier,
		/datum/intent/sword/thrust/estoc/lunge,
		/datum/intent/sword/lunge,
		/datum/intent/claw/lunge/steel,
		/datum/intent/axe/cut/lunge,
		/datum/intent/sword/thrust/long/halfsword/jab,
		/datum/intent/dagger/sucker_punch
	)
	var/list/original = blocked + allowed
	var/list/filtered = ta_filter_weapon_intents(original)
	if(!compare_list(original, blocked + allowed))
		Fail("Filtering modified its source list", __FILE__, __LINE__)
	if(length(filtered) != length(allowed))
		Fail("Filtering returned an unexpected number of intents", __FILE__, __LINE__)
	for(var/intent_type as anything in blocked)
		if(intent_type in filtered)
			Fail("Blocked intent remained: [intent_type]", __FILE__, __LINE__)
	for(var/index in 1 to length(allowed))
		if(index > length(filtered) || filtered[index] != allowed[index])
			Fail("Allowed intent removed or reordered: [allowed[index]]", __FILE__, __LINE__)
	if(ta_filter_weapon_intents(allowed) != allowed)
		Fail("Unchanged list was unnecessarily copied", __FILE__, __LINE__)
	var/list/fallback = ta_filter_weapon_intents(blocked)
	if(length(fallback) != 1 || fallback[1] != /datum/intent/use)
		Fail("Fully blocked list must expose only the non-attack use intent", __FILE__, __LINE__)

	var/obj/item/rogueweapon/sword/rapier/weapon = allocate(/obj/item/rogueweapon/sword/rapier)
	var/list/initial_intents = weapon.possible_item_intents
	if(!(/datum/intent/sword/thrust/rapier/lunge in initial_intents))
		Fail("Initialization must preserve the original rapier intents", __FILE__, __LINE__)
	if(/datum/intent/sword/thrust/rapier/lunge in weapon.ta_get_current_weapon_intents())
		Fail("Rapier exposes deep lunge", __FILE__, __LINE__)
	var/list/card = weapon.build_stat_card()
	var/list/groups = card["groups"]
	var/list/first_group = groups[1]
	var/list/card_intents = first_group["intents"]
	if(length(card_intents) != length(weapon.ta_get_current_weapon_intents()))
		Fail("Stat card and available attacks differ", __FILE__, __LINE__)
	if(weapon.possible_item_intents != initial_intents || !(/datum/intent/sword/thrust/rapier/lunge in initial_intents))
		Fail("Stat card modified original intents", __FILE__, __LINE__)

	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	if(!user.put_in_hands(weapon, forced = TRUE) || user.get_active_held_item() != weapon)
		return Fail("Could not equip test weapon", __FILE__, __LINE__)
	weapon.possible_item_intents = original
	weapon.gripped_intents = list(/datum/intent/axe/chop/heavy, /datum/intent/axe/chop)
	user.update_a_intents()
	if(length(user.possible_a_intents) != length(allowed))
		Fail("Active hand was not filtered", __FILE__, __LINE__)
	var/obj/item/rogueweapon/sword/rapier/offhand = allocate(/obj/item/rogueweapon/sword/rapier)
	if(!user.put_in_hand(offhand, user.get_inactive_hand_index(), TRUE))
		return Fail("Could not equip offhand weapon", __FILE__, __LINE__)
	user.update_a_intents()
	if(length(user.possible_offhand_intents) != 2)
		Fail("Offhand was not filtered", __FILE__, __LINE__)
	for(var/datum/intent/offhand_intent as anything in user.possible_offhand_intents)
		if(istype(offhand_intent, /datum/intent/sword/thrust/rapier/lunge))
			Fail("Deep lunge remained available in the offhand", __FILE__, __LINE__)
	user.dropItemToGround(offhand, TRUE)
	weapon.wielded = TRUE
	user.update_a_intents()
	if(length(user.possible_a_intents) != 1 || !istype(user.a_intent, /datum/intent/axe/chop))
		Fail("Wielded intents were not filtered", __FILE__, __LINE__)
	weapon.wielded = FALSE

	var/datum/alt_grip/grip = new
	allocated += grip
	grip.grip_intents = blocked
	weapon.current_alt_grip = grip
	weapon.altgripped = TRUE
	user.update_a_intents()
	if(length(user.possible_a_intents) != 1 || !istype(user.a_intent, /datum/intent/use))
		Fail("Fully blocked grip fell back to normal attacks", __FILE__, __LINE__)
	grip.skill_req = SKILL_LEVEL_JOURNEYMAN
	if(length(weapon.get_altgrip_intents()) != length(blocked))
		Fail("Skill-gated attacks were filtered", __FILE__, __LINE__)
	grip.grip_intents = null
	if(length(weapon.get_altgrip_intents()) != length(allowed))
		Fail("Empty grip bypassed filtering of normal attacks", __FILE__, __LINE__)
	weapon.current_alt_grip = null
	weapon.altgripped = FALSE
	user.update_a_intents()
	if(!compare_list(weapon.possible_item_intents, original))
		Fail("Grip changes modified original intents", __FILE__, __LINE__)
	user.dropItemToGround(weapon, TRUE)

	var/obj/item/rogueweapon/sword/rapier/foldsword/folding = allocate(/obj/item/rogueweapon/sword/rapier/foldsword)
	if(!user.put_in_hands(folding, forced = TRUE))
		return Fail("Could not equip folding sword", __FILE__, __LINE__)
	folding.extended = FALSE
	folding.attack_self(user)
	if(!(/datum/intent/sword/thrust/rapier/lunge in folding.possible_item_intents) || (/datum/intent/sword/thrust/rapier/lunge in folding.ta_get_current_weapon_intents()))
		Fail("Unfolding did not preserve and filter deep lunge", __FILE__, __LINE__)
	folding.attack_self(user)
	var/list/folded_intents = folding.ta_get_current_weapon_intents()
	if(length(folded_intents) != 1 || folded_intents[1] != SWORD_STRIKE)
		Fail("Folding sword lost its normal folded attack", __FILE__, __LINE__)
	user.dropItemToGround(folding, TRUE)

	var/obj/item/enchantingkit/kit = allocate(/obj/item/enchantingkit)
	var/obj/item/rogueweapon/sword/rapier/result = allocate(/obj/item/rogueweapon/sword/rapier)
	kit.inherit_item_mechanics(weapon, result)
	if(!compare_list(result.possible_item_intents, original) || length(result.ta_get_current_weapon_intents()) != length(allowed))
		Fail("Transmogrification changed source intents or bypassed filtering", __FILE__, __LINE__)
#endif
