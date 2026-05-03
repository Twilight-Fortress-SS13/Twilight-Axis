// contractor helpers
// Consolidated helper layer: core lookup, Lux economy, stat/skill helpers, seal/contract helpers, items/enchantments.

// --- BEGIN contractor_helpers_core.dm ---
// Contractor helper procs: core.

/proc/is_contractor_mob(mob/living/carbon/human/H)
	return H?.GetComponent(/datum/component/contractor)

/proc/get_contractor_component(mob/living/carbon/human/H)
	return H?.GetComponent(/datum/component/contractor)

/proc/get_or_add_contractee(mob/living/carbon/human/H, datum/component/contractor/contractor)
	if(!H)
		return null
	var/datum/component/contractee/contractee = H.GetComponent(/datum/component/contractee)
	if(!contractee)
		contractee = H.AddComponent(/datum/component/contractee, contractor)
	else if(contractor && !contractee.contractor)
		contractee.contractor = contractor
	return contractee

/proc/contractor_get_arcana_power(mob/living/carbon/human/H)
	if(!H)
		return 0
	return H.get_skill_level(/datum/skill/magic/arcane)

/proc/contractor_get_miracle_power(mob/living/carbon/human/H)
	if(!H)
		return 0
	return H.get_skill_level(/datum/skill/magic/holy)

/proc/contractor_get_reading_power(mob/living/carbon/human/H)
	if(!H)
		return 0
	return H.get_skill_level(/datum/skill/misc/reading)

/proc/contractor_heal_in_seal(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	H.adjustBruteLoss(-1)
	H.adjustFireLoss(-1)
	return TRUE

/proc/contractor_grant_mind_spell_if_missing(mob/living/carbon/human/H, spell_type)
	if(!H || !H.mind || !ispath(spell_type))
		return FALSE
	if(islist(H.mind.spell_list))
		for(var/datum/existing_spell as anything in H.mind.spell_list)
			if(istype(existing_spell, spell_type))
				return FALSE
	if(islist(H.actions))
		for(var/datum/action/existing_action as anything in H.actions)
			if(istype(existing_action, spell_type))
				return FALSE
	var/datum/new_spell = new spell_type
	if(!new_spell)
		return FALSE
	H.mind.AddSpell(new_spell)
	return TRUE

/proc/contractor_remove_mind_spell(mob/living/carbon/human/H, spell_type)
	if(!H || !H.mind || !ispath(spell_type))
		return FALSE
	var/removed = FALSE
	if(islist(H.mind.spell_list))
		for(var/datum/existing_spell as anything in H.mind.spell_list.Copy())
			if(istype(existing_spell, spell_type))
				H.mind.RemoveSpell(existing_spell)
				qdel(existing_spell)
				removed = TRUE
	if(islist(H.actions))
		for(var/datum/action/existing_action as anything in H.actions.Copy())
			if(istype(existing_action, spell_type))
				qdel(existing_action)
				removed = TRUE
	return removed

/proc/contractor_grant_body_mark_spell(mob/living/carbon/human/editor, mob/living/carbon/human/target, duration = CONTRACTOR_BODY_CHANGE_PERMISSION_TIME)
	if(!editor || !editor.mind || !target || !ispath(/datum/action/cooldown/spell/contractor/body_mark_contract))
		return FALSE

	var/datum/action/cooldown/spell/contractor/body_mark_contract/spell = new
	spell.mark_target = target
	spell.expire_time = world.time + duration
	editor.mind.AddSpell(spell)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(contractor_remove_body_mark_spell), editor, spell), duration)
	to_chat(editor, span_notice("The contract gives you [round(duration / 600)] minutes to reshape [target] with Body Mark."))
	return TRUE

/proc/contractor_remove_body_mark_spell(mob/living/carbon/human/editor, datum/action/cooldown/spell/contractor/body_mark_contract/spell)
	if(!spell || QDELETED(spell))
		return FALSE
	if(editor?.mind)
		editor.mind.RemoveSpell(spell)
	qdel(spell)
	return TRUE

/proc/contractor_level_name(level)
	switch(level)
		if(CONTRACTOR_LEVEL_SLEEPING)
			return "Sleeping entity"
		if(CONTRACTOR_LEVEL_AWAKENED)
			return "Awakened entity"
		if(CONTRACTOR_LEVEL_AWARE)
			return "Aware entity"
		if(CONTRACTOR_LEVEL_WATCHFUL)
			return "Watchful entity"
		if(CONTRACTOR_LEVEL_COMPLETE)
			return "Complete entity"
	return "Unknown entity"

/proc/contractor_is_tat_contract_gear_entry(item_path, list/entry)
	return contractor_tat_contract_gear_kind(item_path, entry) ? TRUE : FALSE

/proc/contractor_apply_magic_item_enchantment(obj/item/I, enchantment_spell_path, mob/user)
	if(!I || !enchantment_spell_path || enchantment_spell_path == "none")
		return FALSE
	var/component_path = contractor_magic_item_component_path()
	if(!component_path)
		I.desc += " It bears a dormant enchantment, but this codebase has no /datum/component/magic_item."
		return FALSE
	var/enchantment_path = null
	if(enchantment_spell_path == "random")
		enchantment_path = contractor_pick_random_magic_item_spell_path()
	else
		enchantment_path = text2path("[enchantment_spell_path]")
	if(!enchantment_path)
		I.desc += " Its enchantment matrix failed to find a valid magic_item datum."
		return FALSE
	if(ispath(enchantment_path, component_path))
		I.AddComponent(enchantment_path)
	else
		I.AddComponent(component_path, enchantment_path)
	var/enchant_name = contractor_magic_item_enchantment_name("[enchantment_path]")
	I.desc += " It bears a [enchant_name] enchantment."
	if(user)
		to_chat(user, span_notice("[I] accepts a magic item enchantment: [enchant_name]."))
	return TRUE


// --- END contractor_helpers_core.dm ---

// --- BEGIN contractor_helpers_lux.dm ---
// Contractor helper procs: lux.

/proc/contractor_get_lux_amount(mob/living/carbon/human/H)
	if(!H)
		return 0
	if(H.devotion)
		return H.devotion.devotion
	return 0

/proc/contractor_drain_lux(mob/living/carbon/human/H, requested_amount)
	if(!H || requested_amount <= 0)
		return 0
	if(H.devotion)
		var/current_devotion = H.devotion.devotion || 0
		var/devotion_drained = min(current_devotion, requested_amount)
		if(devotion_drained <= 0)
			return 0
		H.devotion.update_devotion(-devotion_drained, 0, TRUE)
		return devotion_drained
	return 0

/proc/contractor_adjust_lux(mob/living/carbon/human/H, amount)
	if(!H)
		return FALSE
	if(H.devotion)
		if(amount < 0 && H.devotion.devotion <= 0)
			return FALSE
		H.devotion.update_devotion(amount, 0, TRUE)
		return TRUE
	return FALSE

/proc/contractor_get_loose_lux_amount(atom/A)
	if(!A)
		return 0
	if(!istype(A, /obj/item/contractor_loose_lux))
		return 0
	var/obj/item/contractor_loose_lux/L = A
	return L.lux_power || 0

/proc/contractor_consume_loose_lux(atom/A, amount)
	if(!A || amount <= 0)
		return FALSE
	if(!istype(A, /obj/item/contractor_loose_lux))
		return FALSE
	var/obj/item/contractor_loose_lux/L = A
	L.lux_power = max(0, (L.lux_power || 0) - amount)
	if(L.lux_power <= 0)
		qdel(L)
	return TRUE


// --- END contractor_helpers_lux.dm ---

// --- BEGIN contractor_helpers_stats_skills.dm ---
// Contractor helper procs: stats_skills.

/proc/contractor_apply_all_stat_delta(mob/living/carbon/human/H, amount)
	if(!H || !amount)
		return FALSE
	for(var/stat_id in contractor_get_tat_stat_ids())
		H.change_stat(stat_id, amount)
	return TRUE

/proc/contractor_apply_all_skill_delta(mob/living/carbon/human/H, amount)
	if(!H || !H.mind || !amount)
		return FALSE
	for(var/skill_path in contractor_get_tat_skill_paths())
		var/current_level = H.get_skill_level(skill_path)
		var/new_level = max(0, current_level + amount)
		if(amount > 0)
			H.adjust_skillrank_up_to(skill_path, new_level, TRUE)
		else
			H.adjust_skillrank(skill_path, amount, TRUE)
	return TRUE

/proc/contractor_imprint_best_from(mob/living/carbon/human/contractor, mob/living/carbon/human/target)
	if(!contractor || !target)
		return FALSE
	var/list/best_skills = list()
	var/best_skill_level = 0
	for(var/skill_path in contractor_get_tat_skill_paths())
		var/level = target.get_skill_level(skill_path)
		if(level > best_skill_level)
			best_skill_level = level
			best_skills = list(skill_path)
		else if(level == best_skill_level && level > 0)
			best_skills += skill_path
	if(length(best_skills) && contractor.mind)
		var/picked = pick(best_skills)
		contractor.adjust_skillrank_up_to(picked, max(contractor.get_skill_level(picked), best_skill_level), TRUE)

	var/best_stat = null
	var/best_stat_value = -999999
	for(var/stat_id in contractor_get_tat_stat_ids())
		var/value = target.get_stat_level(stat_id)
		if(value > best_stat_value)
			best_stat_value = value
			best_stat = stat_id
	if(best_stat)
		contractor.change_stat(best_stat, 1)
	return TRUE

/proc/contractor_apply_temp_stat(mob/living/carbon/human/H, stat_key, amount, duration)
	if(!H || !stat_key || !amount)
		return FALSE
	H.change_stat(stat_key, amount)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(contractor_remove_temp_stat), H, stat_key, amount), duration)
	return TRUE

/proc/contractor_remove_temp_stat(mob/living/carbon/human/H, stat_key, amount)
	if(!H || QDELETED(H))
		return
	H.change_stat(stat_key, -amount)

/proc/contractor_get_tat_stat_ids()
	return TAT_STATS_ORDER_LIST

/proc/contractor_get_tat_skill_paths()
	return TAT_SKILLS_ALL

/proc/contractor_apply_stat_delta(mob/living/carbon/human/H, stat_key, amount)
	if(!H || !stat_key || !amount)
		return FALSE
	H.change_stat(stat_key, amount)
	return TRUE

/proc/contractor_skill_key_to_path(skill_key)
	if(ispath(skill_key))
		return skill_key
	if(!skill_key)
		return null
	var/text_key = lowertext("[skill_key]")
	for(var/skill_path in contractor_get_tat_skill_paths())
		var/path_text = lowertext("[skill_path]")
		if(path_text == text_key || findtext(path_text, text_key))
			return skill_path
	return null

/proc/contractor_is_combat_skill(skill_key)
	var/skill_path = contractor_skill_key_to_path(skill_key)
	return skill_path && ispath(skill_path, /datum/skill/combat)

/proc/contractor_apply_skill_delta(mob/living/carbon/human/H, skill_key, amount)
	if(!H || !H.mind || !skill_key || !amount)
		return FALSE
	var/skill_path = contractor_skill_key_to_path(skill_key)
	if(!skill_path)
		return FALSE
	var/current_level = H.get_skill_level(skill_path)
	var/new_level = max(0, current_level + amount)
	if(amount > 0)
		H.adjust_skillrank_up_to(skill_path, new_level, TRUE)
		return TRUE
	H.adjust_skillrank(skill_path, amount, TRUE)
	return TRUE

/proc/contractor_add_arousal(mob/living/carbon/human/H, amount, duration)
	if(!H || !amount)
		return FALSE

	var/datum/component/arousal/A = H.GetComponent(/datum/component/arousal)
	if(!A)
		return FALSE

	A.adjust_arousal(A, amount, TRUE)
	return TRUE

/proc/contractor_force_climax(mob/living/carbon/human/H, count = 1)
	if(!H || count <= 0)
		return FALSE
	for(var/i in 1 to count)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(contractor_do_single_climax), H), max(0, (i - 1) * 25))
	return TRUE

/proc/contractor_do_single_climax(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.stat == DEAD)
		return FALSE

	var/datum/component/arousal/A = H.GetComponent(/datum/component/arousal)
	if(!A)
		return FALSE

	A.ejaculate()
	return TRUE

/proc/contractor_is_defiant(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	return H.is_erp_defiant()

/proc/contractor_apply_temp_skill(mob/living/carbon/human/H, skill_key, amount, duration)
	if(!contractor_apply_skill_delta(H, skill_key, amount))
		return FALSE
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(contractor_remove_temp_skill), H, skill_key, amount), duration)
	return TRUE

/proc/contractor_remove_temp_skill(mob/living/carbon/human/H, skill_key, amount)
	if(!H || QDELETED(H))
		return
	contractor_apply_skill_delta(H, skill_key, -amount)

/proc/contractor_contract_power_for_stat(stat_key, amount)
	var/base = (stat_key == STATKEY_STR || stat_key == STATKEY_SPD) ? 20 : 10
	return base ** max(1, amount)

/proc/contractor_contract_power_for_skill(skill_key, amount)
	return (contractor_is_combat_skill(skill_key) ? 20 : 10) * max(1, amount)

/proc/contractor_pretty_stat(stat_key)
	switch(stat_key)
		if(STATKEY_STR)
			return "Strength"
		if(STATKEY_PER)
			return "Perception"
		if(STATKEY_INT)
			return "Intelligence"
		if(STATKEY_CON)
			return "Constitution"
		if(STATKEY_SPD)
			return "Speed"
		if(STATKEY_WIL)
			return "Willpower"
		if(STATKEY_LCK)
			return "Luck"
	return capitalize(replacetext("[stat_key]", "_", " "))

/proc/contractor_pretty_skill(skill_key)
	var/skill_path = contractor_skill_key_to_path(skill_key)
	if(!skill_path)
		return "[skill_key]"
	var/text = "[skill_path]"
	var/slash = findlasttext(text, "/")
	if(slash)
		text = copytext(text, slash + 1)
	return capitalize(replacetext(text, "_", " "))



// Character flaw helpers used by contractor vice clauses.
/proc/contractor_charflaw_catalog()
	var/list/out = list()
	var/list/flaws = GLOB.character_flaws
	if(length(flaws))
		for(var/flaw_name in flaws)
			var/flaw_type = flaws[flaw_name]
			if(!ispath(flaw_type))
				continue
			out += list(list("id" = "[flaw_type]", "name" = "[flaw_name]"))
	else
		for(var/flaw_type in contractor_charflaw_fallback_paths())
			out += list(list("id" = "[flaw_type]", "name" = contractor_pretty_charflaw(flaw_type)))
	return out

/proc/contractor_charflaw_fallback_paths()
	return list(
		/datum/charflaw/addiction/alcoholic,
		/datum/charflaw/averse,
		/datum/charflaw/addiction/godfearing,
		/datum/charflaw/addiction/caffiend,
		/datum/charflaw/colorblind,
		/datum/charflaw/addiction/smoker,
		/datum/charflaw/addiction/junkie,
		/datum/charflaw/unintelligible,
		/datum/charflaw/greedy,
		/datum/charflaw/narcoleptic,
		/datum/charflaw/addiction/lovefiend,
		/datum/charflaw/addiction/sadist,
		/datum/charflaw/addiction/masochist,
		/datum/charflaw/clingy,
		/datum/charflaw/finicky,
		/datum/charflaw/lonely,
		/datum/charflaw/addiction/paranoid,
		/datum/charflaw/addiction/clamorous,
		/datum/charflaw/addiction/thrillseeker,
		/datum/charflaw/indebted,
		/datum/charflaw/addiction/voyeur,
		/datum/charflaw/badsight,
		/datum/charflaw/noeyer,
		/datum/charflaw/noeyel,
		/datum/charflaw/noeyeall,
		/datum/charflaw/limbloss/arm_r,
		/datum/charflaw/limbloss/arm_l,
		/datum/charflaw/sleepless,
		/datum/charflaw/mute,
		/datum/charflaw/critweakness,
		/datum/charflaw/hunted,
		/datum/charflaw/mind_broken,
		/datum/charflaw/noflaw,
		/datum/charflaw/leprosy,
		/datum/charflaw/randflaw,
		/datum/charflaw/lawless,
		/datum/charflaw/gefheretic
	)

/proc/contractor_charflaw_path(id)
	if(!id)
		return null
	var/path = text2path("[id]")
	if(ispath(path, /datum/charflaw))
		return path
	var/list/flaws = GLOB.character_flaws
	if(length(flaws) && flaws[id] && ispath(flaws[id], /datum/charflaw))
		return flaws[id]
	return null

/proc/contractor_pretty_charflaw(datum/charflaw/flaw_type)
	if(!flaw_type)
		return "Unknown vice"
	return initial(flaw_type.name) || "[flaw_type]"

/proc/contractor_human_has_charflaw(mob/living/carbon/human/H, flaw_type)
	if(!H || !ispath(flaw_type, /datum/charflaw))
		return FALSE
	for(var/datum/charflaw/existing in H.charflaws)
		if(istype(existing, flaw_type))
			return TRUE
	if(H.client?.prefs?.charflaws)
		for(var/datum/charflaw/existing_pref in H.client.prefs.charflaws)
			if(istype(existing_pref, flaw_type))
				return TRUE
	return FALSE



/proc/contractor_apply_charflaw_once(mob/living/carbon/human/H, flaw_type)
	if(!H || !ispath(flaw_type, /datum/charflaw))
		return FALSE
	if(H.has_flaw(flaw_type) || contractor_human_has_charflaw(H, flaw_type))
		return FALSE

	if(!islist(H.charflaws))
		H.charflaws = list()

	var/datum/charflaw/flaw = new flaw_type()
	if(!flaw)
		return FALSE

	H.charflaws.Add(flaw)

	// Character flaws already have the authoritative runtime hooks.
	// Do not guess proc names, do not fake traits, do not silently mark it as applied.
	// Apply the exact same hooks the character setup pipeline uses.
	flaw.on_mob_creation(H)
	flaw.apply_post_equipment(H)
	flaw.flaw_on_life(H)

	return TRUE

// --- END contractor_helpers_stats_skills.dm ---

// --- BEGIN contractor_helpers_seal_contract.dm ---
// Contractor helper procs: seal_contract.

/proc/contractor_find_person_by_name(query)
	if(!query)
		return null
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(findtext(lowertext(H.real_name), lowertext(query)))
			return H
	return null

/proc/contractor_find_nearby_seal(atom/movable/A)
	if(!A)
		return null
	var/turf/T = get_turf(A)
	if(!T)
		return null
	for(var/obj/effect/contractor_seal/seal in range(CONTRACTOR_SEAL_CHECK_RANGE, T))
		if(seal.active && seal.contains(A))
			return seal
	for(var/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/rune_seal in range(CONTRACTOR_SEAL_CHECK_RANGE, T))
		if(rune_seal.active && rune_seal.contains(A))
			return rune_seal
	return null

/proc/contractor_value_offering(obj/item/I)
	if(!I)
		return 0
	return max(1, I.sellprice)

/proc/contractor_contract_read_chance(mob/living/carbon/human/H, datum/component/contractor/contractor)
	var/reading = contractor_get_reading_power(H)
	var/chance = 0
	switch(reading)
		if(1)
			chance = 2
		if(2)
			chance = 2
		if(3)
			chance = 5
		if(4)
			chance = 10
		if(5)
			chance = 25
		if(6 to 999)
			chance = 50
	if(contractor)
		chance -= contractor.concealment_power
	return clamp(chance, 0, 100)

/proc/contractor_contract_has_history(datum/component/contractor/S, mob/living/carbon/human/H)
	if(!S || !H)
		return FALSE
	var/datum/component/contractee/C = H.GetComponent(/datum/component/contractee)
	if(C && C.contractor == S)
		return TRUE
	return FALSE

/proc/contractor_direction_to_text(atom/source_atom, atom/target_atom)
	if(!source_atom || !target_atom)
		return "nowhere"
	var/turf/source_turf = get_turf(source_atom)
	var/turf/target_turf = get_turf(target_atom)
	if(!source_turf || !target_turf)
		return "nowhere"
	var/dx = target_turf.x - source_turf.x
	var/dy = target_turf.y - source_turf.y
	var/list/parts = list()
	if(dy > 0)
		parts += "north"
	else if(dy < 0)
		parts += "south"
	if(dx > 0)
		parts += "east"
	else if(dx < 0)
		parts += "west"
	if(!length(parts))
		return "right here"
	return jointext(parts, "-")

/proc/contractor_find_atom_by_name(query)
	if(!query)
		return null
	var/lower_query = lowertext(query)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(findtext(lowertext(H.real_name), lower_query) || findtext(lowertext(H.name), lower_query))
			return H
	for(var/obj/O in world)
		if(QDELETED(O))
			continue
		if(findtext(lowertext(O.name), lower_query))
			return O
	return null

/proc/contractor_damage_seal(atom/seal, amount)
	if(!seal || QDELETED(seal) || amount <= 0)
		return FALSE
	if(istype(seal, /obj/effect/contractor_seal))
		var/obj/effect/contractor_seal/old_seal = seal
		old_seal.damage_seal(amount)
		return TRUE
	if(istype(seal, /obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal))
		var/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/rune_seal = seal
		rune_seal.damage_seal(amount)
		return TRUE
	return FALSE

/proc/contractor_break_seal(atom/seal)
	if(!seal || QDELETED(seal))
		return FALSE
	if(istype(seal, /obj/effect/contractor_seal))
		var/obj/effect/contractor_seal/old_seal = seal
		old_seal.break_seal()
		return TRUE
	if(istype(seal, /obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal))
		var/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/rune_seal = seal
		rune_seal.break_seal()
		return TRUE
	return FALSE


// --- END contractor_helpers_seal_contract.dm ---

// --- BEGIN contractor_helpers_items_enchantments.dm ---
// Contractor helper procs: items_enchantments.

/proc/contractor_is_contract_weapon_path(item_path, list/entry = null)
	if(!ispath(item_path, /obj/item))
		return FALSE
	if(ispath(item_path, /obj/item/rogueweapon) || ispath(item_path, /obj/item/gun))
		return TRUE
	if(islist(entry) && entry["category"] == TAT_ITEM_CATEGORY_WEAPON)
		var/slot_group = entry["slot_group"]
		if(slot_group in list("ranged", "knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip"))
			return TRUE
	return FALSE

/proc/contractor_tat_contract_gear_kind(item_path, list/entry)
	if(!ispath(item_path, /obj/item) || !islist(entry))
		return null
	var/category = entry["category"]
	var/slot_group = entry["slot_group"]
	if(category == TAT_ITEM_CATEGORY_WEAPON)
		if(slot_group in list("ranged", "knife", "sword", "greatsword", "axe", "blunt", "polearm", "whip"))
			return "weapon"
		return null
	if(category == TAT_ITEM_CATEGORY_CLOTHING)
		if(slot_group in list("armor", "cloak", "ring", "neck", "head", "mask", "suit", "shirt", "pants", "under", "gloves", "shoes", "wrists", "belt"))
			return "gear"
	return null

/proc/contractor_tat_contract_gear_catalog()
	var/list/out = list()
	if(!islist(GLOB.tat_available_items))
		return out
	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		var/kind = contractor_tat_contract_gear_kind(item_path, entry)
		if(!kind)
			continue
		out += list(list(
			"id" = "[item_path]",
			"name" = entry["name"] || "[item_path]",
			"category" = kind,
			"slot_group" = entry["slot_group"] || "other",
			"cost" = entry["cost"] || 1,
			"is_weapon" = contractor_is_contract_weapon_path(item_path, entry)
		))
	return out

/proc/contractor_tat_contract_gear_path(id, expected_kind = null)
	var/path = text2path("[id]")
	if(!ispath(path, /obj/item))
		return null
	if(!islist(GLOB.tat_available_items))
		return path
	var/list/entry = GLOB.tat_available_items[path]
	var/kind = contractor_tat_contract_gear_kind(path, entry)
	if(!kind)
		return null
	if(expected_kind && kind != expected_kind)
		return null
	return path

/proc/contractor_apply_weapon_force_bonus(obj/item/I, amount)
	if(!I || !amount)
		return FALSE
	I.force = max(0, (I.force || 0) + amount)
	I.throwforce = max(0, (I.throwforce || 0) + amount)
	return TRUE

/proc/contractor_apply_weapon_defense_bonus(obj/item/I, amount)
	if(!I || !amount)
		return FALSE
	I.wdefense = max(0, (I.wdefense || 0) + amount)
	return TRUE

/proc/contractor_apply_item_numeric_bonus(obj/item/I, amount)
	return contractor_apply_weapon_force_bonus(I, amount)

/proc/contractor_tat_contract_first_gear_path(expected_kind = null)
	if(!islist(GLOB.tat_available_items))
		return null
	for(var/item_path in GLOB.tat_available_items)
		var/list/entry = GLOB.tat_available_items[item_path]
		var/kind = contractor_tat_contract_gear_kind(item_path, entry)
		if(!kind)
			continue
		if(!expected_kind || kind == expected_kind)
			return item_path
	return null

// Contractor pricing metadata for TA magic item enchantments.
//
// The base /datum/magic_item definitions do not expose a tier var, while
// contractor contracts need a stable boon-price multiplier for enchanted gear.
// Real enchantment subtypes may override tier here later.

/datum/magic_item
	/// Contractor boon pricing tier for enchanted items.
	var/tier = 1

/proc/contractor_magic_item_base_path()
	return /datum/magic_item

/proc/contractor_magic_item_component_path()
	return /datum/component/magic_item

/proc/contractor_magic_item_tier(enchantment_path)
	if(!ispath(enchantment_path, /datum/magic_item))
		return 0

	return max(1, initial(enchantment_path:tier))

/proc/contractor_magic_item_display_name(enchantment_path)
	if(!enchantment_path)
		return null
	var/datum/magic_item/D = new enchantment_path
	if(!D)
		return contractor_initial_name_for_path(enchantment_path)
	var/out = D.name
	qdel(D)
	return out || contractor_initial_name_for_path(enchantment_path)

/proc/contractor_magic_item_enchantment_catalog()
	var/list/out = list(list("id" = "none", "name" = "No enchantment", "desc" = "No magic item enchantment will be added.", "tier" = 0))
	var/base_path = contractor_magic_item_base_path()
	if(!base_path)
		return out
	out += list(list("id" = "random", "name" = "Random enchantment", "desc" = "Picks a random magic_item enchantment.", "tier" = 1))
	for(var/enchantment_path as anything in typesof(base_path))
		if(enchantment_path == base_path)
			continue
		var/tier = contractor_magic_item_tier(enchantment_path)
		out += list(list("id" = "[enchantment_path]", "name" = contractor_magic_item_display_name(enchantment_path), "desc" = "Tier [tier] magic item enchantment.", "tier" = tier))
	return out

/proc/contractor_initial_name_for_path(path_value)
	if(!path_value)
		return null
	var/list/path_parts = splittext("[path_value]", "/")
	if(length(path_parts))
		return path_parts[length(path_parts)]
	return "[path_value]"

/proc/contractor_magic_item_enchantment_name(enchantment_spell_path)
	if(!enchantment_spell_path)
		return "none"
	if(enchantment_spell_path == "random")
		return "random enchantment"
	var/path_value = text2path("[enchantment_spell_path]")
	return contractor_magic_item_display_name(path_value) || "[enchantment_spell_path]"

/proc/contractor_pick_random_magic_item_spell_path()
	var/base_path = contractor_magic_item_base_path()
	if(!base_path)
		return null
	var/list/candidates = list()
	for(var/enchantment_path as anything in typesof(base_path))
		if(enchantment_path == base_path)
			continue
		candidates += enchantment_path
	if(!length(candidates))
		return null
	return pick(candidates)

/proc/contractor_magic_item_enchantment_power(enchantment_spell_path)
	if(!enchantment_spell_path || enchantment_spell_path == "none")
		return 0
	if(enchantment_spell_path == "random")
		return 35
	var/path_value = text2path("[enchantment_spell_path]")
	return 20 + (contractor_magic_item_tier(path_value) * 20)


// --- END contractor_helpers_items_enchantments.dm ---

