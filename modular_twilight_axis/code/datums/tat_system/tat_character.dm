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
	H.adjust_skillrank_up_to(path, amount, TRUE)

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
	grant_skill_bonus_if_exists(H, "/datum/skill/magic/holy", 1)
	if(H.patron?.type ==/datum/patron/inhumen/zizo && cleric_tier >= CLERIC_T2)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)

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
		if(H in SStreasury.bank_accounts)
			SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
		else
			SStreasury.create_bank_account(H, ECONOMIC_LOWER_MIDDLE_CLASS)
		H.mind?.special_items["Resident Manuscript"] = /obj/item/book/granter/residentcardvirtue
		apply_resident_package(H)
	if(traits[TAT_TRAIT_SPELLBLADE])
		ADD_TRAIT(H, TRAIT_ARCYNE, TAT_TRAIT_SOURCE)
		if(H.mind)
			to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

			var/subclass_list = list("Blade", "Phalangite", "Macebearer")
			var/subclass_selected = tgui_input_list(H, "Who are you?", "The spellblade specialization", subclass_list)			
			switch(subclass_selected)
				if("Blade")
					H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
					H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
					H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
					H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
				if("Phalangite")
					H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
					H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
					H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
					H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
				if("Macebearer")
					H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
					H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
					H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
					H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)
					
			H.mind.setup_mage_aspects(build_mage_aspects(FALSE))
			H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
			H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
	if(traits[TAT_TRAIT_SOUNDBREAKER])
		H.LoadComponent(/datum/component/combo_core/soundbreaker)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/soundbreaker_codex(H), SLOT_IN_BACKPACK)
	if(traits[TAT_TRAIT_TROPHY_BOUNTY])
		H.LoadComponent(/datum/component/trophy_hunter)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/trophy_rules(H), SLOT_IN_BACKPACK)
	if(traits[TAT_TRAIT_RONIN])
		H.LoadComponent(/datum/component/combo_core/ronin)
		H.equip_to_slot_or_del(new /obj/item/book/rogue/ronin_codex(H), SLOT_IN_BACKPACK)
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

/datum/tat_build/proc/append_unique_equip_slot(list/slots, slot_id)
	if(!(slot_id in slots))
		slots += slot_id

/datum/tat_build/proc/get_equip_slots_for_item(obj/item/I)
	var/list/slots = list()
	if(!I)
		return slots

	var/flags = I.slot_flags

	if(flags & ITEM_SLOT_BELT)
		append_unique_equip_slot(slots, SLOT_BELT_L)
		append_unique_equip_slot(slots, SLOT_BELT_R)
		append_unique_equip_slot(slots, SLOT_BELT)

	if(flags & ITEM_SLOT_HIP)
		append_unique_equip_slot(slots, SLOT_BELT_L)
		append_unique_equip_slot(slots, SLOT_BELT_R)
		append_unique_equip_slot(slots, SLOT_BELT)

	if(flags & ITEM_SLOT_BACK_L)
		append_unique_equip_slot(slots, SLOT_BACK_L)
	if(flags & ITEM_SLOT_BACK_R)
		append_unique_equip_slot(slots, SLOT_BACK_R)
	if(flags & ITEM_SLOT_BACK)
		append_unique_equip_slot(slots, SLOT_BACK_L)
		append_unique_equip_slot(slots, SLOT_BACK_R)
		append_unique_equip_slot(slots, SLOT_BACK)

	if(flags & ITEM_SLOT_SHIRT)
		append_unique_equip_slot(slots, SLOT_SHIRT)
	if(flags & ITEM_SLOT_PANTS)
		append_unique_equip_slot(slots, SLOT_PANTS)
	if(flags & ITEM_SLOT_ICLOTHING)
		append_unique_equip_slot(slots, SLOT_SHIRT)
		append_unique_equip_slot(slots, SLOT_PANTS)

	if(flags & ITEM_SLOT_WRISTS)
		append_unique_equip_slot(slots, SLOT_WRISTS)
	if(flags & ITEM_SLOT_GLOVES)
		append_unique_equip_slot(slots, SLOT_GLOVES)
	if(flags & ITEM_SLOT_SHOES)
		append_unique_equip_slot(slots, SLOT_SHOES)
	if(flags & ITEM_SLOT_RING)
		append_unique_equip_slot(slots, SLOT_RING)
	if(flags & ITEM_SLOT_HEAD)
		append_unique_equip_slot(slots, SLOT_HEAD)
	if(flags & ITEM_SLOT_MOUTH)
		append_unique_equip_slot(slots, SLOT_MOUTH)
	if(flags & ITEM_SLOT_MASK)
		append_unique_equip_slot(slots, SLOT_WEAR_MASK)
	if(flags & ITEM_SLOT_NECK)
		append_unique_equip_slot(slots, SLOT_NECK)
	if(flags & ITEM_SLOT_CLOAK)
		append_unique_equip_slot(slots, SLOT_CLOAK)

	if(flags & ITEM_SLOT_ARMOR)
		append_unique_equip_slot(slots, SLOT_ARMOR)
	if(flags & ITEM_SLOT_OCLOTHING)
		append_unique_equip_slot(slots, SLOT_ARMOR)

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

	var/list/handled_groups = list(
		"belt",
		"back",
		"armor",
		"suit",
	)

	spawn_equipped_items_for_slot_group(H, "belt")
	spawn_equipped_items_for_slot_group(H, "back")
	spawn_equipped_items_for_slot_group(H, "armor")
	spawn_equipped_items_for_slot_group(H, "suit")
	spawn_equipped_items_except_slot_groups(H, handled_groups)

	spawn_bag_items(H)

/datum/tat_build/proc/get_item_slot_group_lower(path)
	var/list/entry = get_item_entry(path)
	if(!islist(entry))
		return null
	return lowertext("[entry["slot_group"]]")

/datum/tat_build/proc/spawn_equipped_items_for_slot_group(mob/living/carbon/human/H, target_slot_group)
	if(!H || !target_slot_group)
		return

	var/target_group = lowertext("[target_slot_group]")

	for(var/path in items)
		var/amount = items[path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/slot_group = get_item_slot_group_lower(path)
		if(slot_group != target_group)
			continue

		var/equip_amount = get_item_equip_amount(path)
		for(var/i in 1 to equip_amount)
			spawn_item_equipped_or_fallback(H, path)

/datum/tat_build/proc/spawn_equipped_items_except_slot_groups(mob/living/carbon/human/H, list/excluded_groups)
	if(!H)
		return

	for(var/path in items)
		var/amount = items[path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/slot_group = get_item_slot_group_lower(path)
		if(slot_group && islist(excluded_groups) && (slot_group in excluded_groups))
			continue

		var/equip_amount = get_item_equip_amount(path)
		for(var/i in 1 to equip_amount)
			spawn_item_equipped_or_fallback(H, path)

/datum/tat_build/proc/spawn_bag_items(mob/living/carbon/human/H)
	if(!H)
		return

	for(var/path in items)
		var/amount = items[path]
		if(!isnum(amount) || amount <= 0)
			continue

		var/bag_amount = get_item_bag_amount(path)
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
	apply_allowed_post_tat_virtues(H)

/datum/tat_build/proc/apply_resident_package(mob/living/carbon/human/H)
	if(!H || !H.mind || !traits[TAT_TRAIT_RESIDENT])
		return

	var/medicine_skill = get_resident_skill_value(/datum/skill/misc/medicine)
	var/butchering_skill = get_resident_skill_value(/datum/skill/labor/butchering)
	var/mining_skill = get_resident_skill_value(/datum/skill/labor/mining)
	var/music_skill = get_resident_skill_value(/datum/skill/misc/music)
	var/ceramics_skill = get_resident_skill_value(/datum/skill/craft/ceramics)
	var/sewing_skill = get_resident_skill_value(/datum/skill/craft/sewing)
	var/tanning_skill = get_resident_skill_value(/datum/skill/craft/tanning)
	var/unarmed_skill = get_resident_skill_value(/datum/skill/combat/unarmed)
	if(medicine_skill >= TAT_RESIDENT_SKILL_MEDICINE_MIN || traits[TRAIT_HOMESTEAD_EXPERT])
		grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/diagnose/secular)

	if(butchering_skill >= TAT_RESIDENT_SKILL_BUTCHERING_MIN)
		grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/huntersyell)

	if(mining_skill >= TAT_RESIDENT_SKILL_MINING_MIN)
		grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/mineroresight)

	if(music_skill >= TAT_RESIDENT_SKILL_MUSIC_MIN)
		grant_mind_spell_if_missing(H, /datum/action/cooldown/spell/projectile/vicious_mockery)

	if(ceramics_skill >= TAT_RESIDENT_SKILL_CERAMICS_MIN)
		grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/digclay)

	if(sewing_skill >= TAT_RESIDENT_SKILL_SEWING_MIN || tanning_skill >= TAT_RESIDENT_SKILL_TANNING_MIN)
		grant_mind_spell_if_missing(H, /obj/effect/proc_holder/spell/invoked/fittedclothing)

	if(unarmed_skill >= TAT_RESIDENT_SKILL_UNARMED_MIN && traits[TRAIT_CIVILIZEDBARBARIAN])
		var/choice = get_resident_pugilist_spell_choice(H)
		var/spell_type = get_resident_pugilist_spell_type(choice)
		grant_mind_spell_if_missing(H, spell_type)

/datum/tat_build/proc/apply_allowed_post_tat_virtues(mob/living/carbon/human/H)
	if(!H)
		return
	if(!H.client)
		return
	if(!H.client.prefs)
		return

	var/virtuous = FALSE
	var/heretic = FALSE
	var/species = H.dna?.species

	if(istype(H.client.prefs.selected_patron, /datum/patron/inhumen))
		heretic = TRUE

	if(H.client.prefs.statpack?.virtuous)
		virtuous = TRUE

	var/datum/virtue/virtue_type = H.client.prefs.virtue
	var/datum/virtue/virtuetwo_type = H.client.prefs.virtuetwo

	if(virtue_type && is_allowed_post_tat_virtue(virtue_type))
		if(virtue_check(virtue_type, heretic, species))
			apply_virtue(H, virtue_type)

	if(virtuetwo_type && virtuous && is_allowed_post_tat_virtue(virtuetwo_type))
		if(virtue_check(virtuetwo_type, heretic, species))
			apply_virtue(H, virtuetwo_type)
