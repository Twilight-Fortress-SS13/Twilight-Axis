/// Character application layer for TAT build.

/datum/tat_build/proc/apply_stats(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/stat_id in available_stats)
		var/base = get_stat_base(stat_id)
		var/value = get_stat_value(stat_id)
		var/diff = value - base
		if(diff)
			H.change_stat(stat_id, diff)

/datum/tat_build/proc/apply_skills(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(level > 0)
			H.adjust_skillrank_up_to(skill_type, level, TRUE)

/datum/tat_build/proc/grant_skill_bonus_if_exists(mob/living/carbon/human/H, path_text, amount = 3)
	if(!H || !path_text || !istext(path_text))
		return
	var/path = text2path(path_text)
	if(!ispath(path, /datum/skill))
		return
	H.adjust_skillrank(path, amount, TRUE)

/datum/tat_build/proc/apply_trait_skill_bonuses(mob/living/carbon/human/H)
	if(!H)
		return
	if(traits[TRAIT_SMITHING_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smithing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/smelting", 3)
	if(traits[TRAIT_ALCHEMY_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/alchemy", 3)
	if(traits[TRAIT_MEDICINE_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/medicine", 3)
	if(traits[TRAIT_HOMESTEAD_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/carpentry", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/masonry", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/crafting", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/farming", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/mining", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/cooking", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/fishing", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/butchering", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/lumberjacking", 2)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/ceramics", 2)
	if(traits[TRAIT_SURVIVAL_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/butchering", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/traps", 3)
	if(traits[TRAIT_SEWING_EXPERT])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/sewing", 3)
	if(traits[TRAIT_SEEDKNOW])
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/farming", 3)
	if(traits[TRAIT_CAUTIOUS_FISHER])
		grant_skill_bonus_if_exists(H, "/datum/skill/labor/fishing", 3)
	if(traits[TRAIT_SQUIRE_REPAIR])
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/armorsmithing", 3)
		grant_skill_bonus_if_exists(H, "/datum/skill/craft/weaponsmithing", 3)
	if(traits[TRAIT_ARCYNE] && !has_defensive_trait_lockout())
		var/current_arcane = get_skill_value(/datum/skill/magic/arcane)
		var/target_arcane = min(6, current_arcane + 2)
		var/bonus_arcane = max(0, target_arcane - current_arcane)
		if(bonus_arcane > 0)
			grant_skill_bonus_if_exists(H, "/datum/skill/magic/arcane", bonus_arcane)

/datum/tat_build/proc/apply_divine_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_DIVINE_INITIATE])
		return
	var/cleric_tier = get_effective_divine_tier()
	var/passive_gain = get_divine_passive_gain_for_tier(cleric_tier)
	var/devotion_limit = get_divine_devotion_limit_for_tier(cleric_tier)
	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = cleric_tier, passive_gain = passive_gain, devotion_limit = devotion_limit)

/datum/tat_build/proc/apply_mage_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_MAGE_INITIATE] || !H.mind)
		return
	ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
	var/list/aspects = build_mage_aspects(TRUE)
	H.mind.setup_mage_aspects(aspects)
	set_magic_value("mage_aspects", aspects.Copy())
	if(get_magic_value("mage_spellbook", TRUE))
		H.equip_to_slot_or_del(new /obj/item/book/spellbook(H), SLOT_IN_BACKPACK)

/datum/tat_build/proc/apply_druid_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_DRUID_INITIATE])
		return
	if(get_magic_value("druid_force_dendor", TRUE))
		H.set_patron(/datum/patron/divine/dendor)
	if(get_magic_value("druid_alert", TRUE))
		H.AddComponent(/datum/component/wise_tree_alert)
	H.AddSpell(new /obj/effect/proc_holder/spell/targeted/create_seed)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_claws)
	H.AddSpell(new /obj/effect/proc_holder/spell/self/beast_rage)
	var/datum/devotion/D = new /datum/devotion(H, H.patron)
	D.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)

/datum/tat_build/proc/apply_witch_package(mob/living/carbon/human/H)
	if(!H || !traits[TAT_TRAIT_WITCH_INITIATE])
		return
	if(!H.client)
		return
	ADD_TRAIT(H, TRAIT_WITCH, TAT_TRAIT_SOURCE)
	ADD_TRAIT(H, TRAIT_DEATHSIGHT, TAT_TRAIT_SOURCE)
	var/shapeshifts = list("Zad", "Cat", "Cat (Black)", "Bat", "Lesser Volf", "Cabbit", "Small Rous", "Lesser Venard")
	var/shapeshiftchoice = tgui_input_list(H, "What form does your second skin take?", "THE OLD WAYS", shapeshifts)
	if(H.mind)
		switch(shapeshiftchoice)
			if("Zad")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/crow)
			if("Cat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat)
			if("Cat (Black)")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cat/black)
			if("Bat")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/bat)
			if("Lesser Volf")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_wolf)
			if("Lesser Venard")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/lesser_vernard)
			if("Small Rous")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/rous)
			if("Cabbit")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/witch/cabbit)

/datum/tat_build/proc/apply_traits(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/trait_id in traits)
		switch(trait_id)
			if(
				TAT_TRAIT_WARRIOR_EXPERT,
				TAT_TRAIT_WARRIOR_MASTER,
				TAT_TRAIT_SOUNDBREAKER,
				TAT_TRAIT_RONIN,
				TAT_TRAIT_RESIDENT,
				TAT_TRAIT_STEEL_SUPPLIER,
				TAT_TRAIT_SILVER_SUPPLIER,
				TAT_TRAIT_BRONZE_SUPPLIER,
				TAT_TRAIT_LEATHER_SUPPLIER,
				TAT_TRAIT_MAIL_SUPPLIER,
				TAT_TRAIT_PLATE_SUPPLIER,
				TAT_TRAIT_SPELLBLADE,
				TAT_TRAIT_BARDIC_INSPIRATION_T1,
				TAT_TRAIT_BARDIC_INSPIRATION_T2,
				TAT_TRAIT_PARTY_LEADER,
				TAT_TRAIT_BONUS_STAT_POOL,
				TAT_TRAIT_WANTED,
				TAT_TRAIT_DIVINE_INITIATE,
				TAT_TRAIT_MAGE_INITIATE,
				TAT_TRAIT_DRUID_INITIATE,
				TAT_TRAIT_WITCH_INITIATE,
				TAT_TRAIT_ARTIFACTS_SUPPLIER,
				TAT_TRAIT_FIREARMS_SUPPLIER,
				TAT_TRAIT_TROPHY_BOUNTY,
			)
				continue
			else
				ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)
	if(traits[TAT_TRAIT_RESIDENT])
		ADD_TRAIT(H, TRAIT_RESIDENT, TAT_TRAIT_SOURCE)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
	if(traits[TAT_TRAIT_SPELLBLADE])
		ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
		if(H.mind)
			H.mind.setup_mage_aspects(build_mage_aspects(FALSE))
			H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
	if(traits[TAT_TRAIT_SOUNDBREAKER])
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
	if(traits[TAT_TRAIT_TROPHY_BOUNTY])
		H.LoadComponent(/datum/component/trophy_hunter)
	if(traits[TAT_TRAIT_RONIN])
		H.LoadComponent(/datum/component/combo_core/ronin)
	if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T1] || traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
		var/bard_tier = BARD_T1
		if(traits[TAT_TRAIT_BARDIC_INSPIRATION_T2])
			bard_tier = BARD_T2
		if(!H.inspiration)
			var/datum/inspiration/I = new /datum/inspiration(H)
			I.grant_inspiration(H, bard_tier)
		else
			H.inspiration.grant_inspiration(H, bard_tier)
	if(traits[TAT_TRAIT_PARTY_LEADER])
		H.LoadComponent(/datum/component/tat_party_leader)
	if(traits[TAT_TRAIT_WARRIOR_MASTER])
		ADD_TRAIT(H, TRAIT_BADTRAINER, TAT_TRAIT_SOURCE)
	if(traits[TAT_TRAIT_WANTED])
		ADD_TRAIT(H, TRAIT_OUTLAW, TAT_TRAIT_SOURCE)
		ADD_TRAIT(H, TRAIT_HERESIARCH, TAT_TRAIT_SOURCE)
		wretch_select_bounty(H)
	apply_divine_package(H)
	apply_mage_package(H)
	apply_druid_package(H)
	apply_witch_package(H)

/datum/tat_build/proc/get_equip_slots_for_item(obj/item/I)
	var/list/slots = list()
	if(!I)
		return slots
	var/flags = I.slot_flags
	if(flags & ITEM_SLOT_WRISTS)
		slots += SLOT_WRISTS
	if(flags & ITEM_SLOT_GLOVES)
		slots += SLOT_GLOVES
	if(flags & ITEM_SLOT_SHOES)
		slots += SLOT_SHOES
	if(flags & ITEM_SLOT_RING)
		slots += SLOT_RING
	if(flags & ITEM_SLOT_HEAD)
		slots += SLOT_HEAD
	if(flags & ITEM_SLOT_MOUTH)
		slots += SLOT_MOUTH
	if(flags & ITEM_SLOT_MASK)
		slots += SLOT_WEAR_MASK
	if(flags & ITEM_SLOT_NECK)
		slots += SLOT_NECK
	if(flags & ITEM_SLOT_CLOAK)
		slots += SLOT_CLOAK
	if(flags & ITEM_SLOT_ARMOR)
		slots += SLOT_ARMOR
	if(flags & ITEM_SLOT_SHIRT)
		slots += SLOT_SHIRT
	if(flags & ITEM_SLOT_PANTS)
		slots += SLOT_PANTS
	if(flags & ITEM_SLOT_OCLOTHING)
		if(!(SLOT_ARMOR in slots))
			slots += SLOT_ARMOR
	if(flags & ITEM_SLOT_ICLOTHING)
		if(!(SLOT_SHIRT in slots))
			slots += SLOT_SHIRT
		if(!(SLOT_PANTS in slots))
			slots += SLOT_PANTS
	if(flags & ITEM_SLOT_BELT)
		slots += SLOT_BELT_L
		slots += SLOT_BELT_R
		slots += SLOT_BELT
	if(flags & ITEM_SLOT_HIP)
		if(!(SLOT_BELT_L in slots))
			slots += SLOT_BELT_L
		if(!(SLOT_BELT_R in slots))
			slots += SLOT_BELT_R
		if(!(SLOT_BELT in slots))
			slots += SLOT_BELT
	if(flags & ITEM_SLOT_BACK_L)
		slots += SLOT_BACK_L
	if(flags & ITEM_SLOT_BACK_R)
		slots += SLOT_BACK_R
	if(flags & ITEM_SLOT_BACK)
		if(!(SLOT_BACK_L in slots))
			slots += SLOT_BACK_L
		if(!(SLOT_BACK_R in slots))
			slots += SLOT_BACK_R
		if(!(SLOT_BACK in slots))
			slots += SLOT_BACK
	return slots

/datum/tat_build/proc/get_storage_targets(mob/living/carbon/human/H)
	var/list/targets = list()
	if(!H)
		return targets
	var/obj/item/I = H.get_item_by_slot(SLOT_BACK_L)
	if(I)
		targets += I
	I = H.get_item_by_slot(SLOT_BACK_R)
	if(I && !(I in targets))
		targets += I
	I = H.get_item_by_slot(SLOT_BELT_L)
	if(I && !(I in targets))
		targets += I
	I = H.get_item_by_slot(SLOT_BELT_R)
	if(I && !(I in targets))
		targets += I
	I = H.get_item_by_slot(SLOT_BACK)
	if(I && !(I in targets))
		targets += I
	I = H.get_item_by_slot(SLOT_BELT)
	if(I && !(I in targets))
		targets += I
	I = H.get_item_by_slot(SLOT_CLOAK)
	if(I && !(I in targets))
		targets += I
	return targets

/datum/tat_build/proc/try_insert_into_storage(obj/item/I, atom/storage_owner, mob/living/carbon/human/H)
	if(!I || !storage_owner)
		return FALSE
	return !!SEND_SIGNAL(storage_owner, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, TRUE)

/datum/tat_build/proc/try_put_into_any_storage_or_drop(obj/item/I, mob/living/carbon/human/H)
	if(!I || !H)
		return FALSE
	for(var/storage_owner in get_storage_targets(H))
		if(try_insert_into_storage(I, storage_owner, H))
			return TRUE
	I.forceMove(get_turf(H))
	return TRUE

/datum/tat_build/proc/spawn_item_into_bag_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return
	try_put_into_any_storage_or_drop(I, H)

/datum/tat_build/proc/spawn_item_equipped_or_fallback(mob/living/carbon/human/H, path)
	if(!H || !ispath(path))
		return
	var/obj/item/I = new path(get_turf(H))
	if(!I)
		return
	var/list/slots = get_equip_slots_for_item(I)
	for(var/slot_id in slots)
		if(H.equip_to_slot_if_possible(I, slot_id, FALSE, TRUE, TRUE, TRUE))
			return
	try_put_into_any_storage_or_drop(I, H)

/datum/tat_build/proc/apply_items(mob/living/carbon/human/H)
	if(!H)
		return
	for(var/path in items)
		var/amount = items[path]
		if(!isnum(amount) || amount <= 0)
			continue
		var/equip_amount = get_item_equip_amount(path)
		var/bag_amount = get_item_bag_amount(path)
		for(var/i in 1 to equip_amount)
			spawn_item_equipped_or_fallback(H, path)
		for(var/i in 1 to bag_amount)
			spawn_item_into_bag_or_fallback(H, path)

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H)
		return
	sanitize_build()
	var/obj/item/storage/backpack/rogue/satchel/B = new /obj/item/storage/backpack/rogue/satchel(H)
	H.equip_to_slot_if_possible(B, SLOT_BACK_R, TRUE, TRUE, TRUE, TRUE)
	apply_items(H)
	apply_stats(H)
	apply_skills(H)
	apply_trait_skill_bonuses(H)
	apply_traits(H)
