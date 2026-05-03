/datum/contractor_contract/ui_state(mob/user)
	if(ui_user_can_see(user))
		return GLOB.always_state
	return GLOB.never_state

/datum/contractor_contract/ui_interact(mob/user, datum/tgui/ui)
	if(!user)
		return
	if(!ui_user_can_see(user))
		to_chat(user, span_notice("The infernal contract waits for another party."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SuccubusContract", gift_contract ? "Succubus Gift" : "Infernal Contract")
		ui.open()

/datum/contractor_contract/proc/ui_user_can_see(mob/user)
	return user == contractee?.owner || user == contractor?.owner

/datum/contractor_contract/proc/ui_role_for(mob/user)
	if(user == contractor?.owner)
		return "succubus"
	if(user == contractee?.owner)
		return "contractor"
	return "viewer"

/datum/contractor_contract/proc/ui_phase_for(mob/user)
	if(status == CONTRACTOR_CONTRACT_DRAFT && user == contractee?.owner)
		return "contractor_boons"
	if(status == CONTRACTOR_CONTRACT_PENDING_CONTRACTOR && user == contractor?.owner)
		if(gift_contract && !length(bonuses))
			return "succubus_gift_boons"
		return "succubus_curses"
	if(status == CONTRACTOR_CONTRACT_PENDING_CONTRACTEE && user == contractee?.owner)
		return "contractor_signature"
	if(status == CONTRACTOR_CONTRACT_ACTIVE || status == CONTRACTOR_CONTRACT_FULFILLED)
		return "summary"
	return "locked"

/datum/contractor_contract/ui_data(mob/user)
	var/list/data = list()
	var/role = ui_role_for(user)
	var/phase = ui_phase_for(user)
	var/read_chance = gift_contract ? 100 : contractor_contract_read_chance(contractee?.owner, contractor)
	var/read_success = ui_get_curse_read_success(user, read_chance)

	data["title"] = gift_contract ? "Succubus Gift" : "Infernal Contract"
	data["role"] = role
	data["phase"] = phase
	data["status"] = status
	data["gift_contract"] = gift_contract
	data["succubus_name"] = contractor?.true_name || contractor?.owner?.real_name || contractor?.owner?.name || "Unknown"
	data["contractor_name"] = contractee?.owner?.real_name || contractee?.owner?.name || "Unknown"
	data["can_edit_bonuses"] = (phase == "contractor_boons" || phase == "succubus_gift_boons")
	data["can_edit_curses"] = (phase == "succubus_curses")
	data["can_submit_bonuses"] = data["can_edit_bonuses"] && length(bonuses)
	data["can_submit_curses"] = data["can_edit_curses"] && calculate_curse_power() <= calculate_bonus_power()
	data["can_accept"] = (phase == "contractor_signature")
	data["can_refuse"] = (phase == "contractor_signature")
	data["read_chance"] = read_chance
	data["curse_read_success"] = read_success
	data["bonus_power"] = calculate_bonus_power()
	data["curse_power"] = calculate_curse_power()
	data["required_curse_power"] = calculate_bonus_power()
	data["lux_power"] = contractor?.lux_power || 0
	data["level"] = contractor?.level || 0
	data["level_name"] = contractor_level_name(contractor?.level || 0)
	data["bonuses"] = ui_clause_list(bonuses, FALSE, TRUE)
	data["curses"] = ui_clause_list(curses, TRUE, TRUE)
	data["visible_curses"] = ui_clause_list(curses, TRUE, read_success)
	data["catalog"] = ui_catalog()
	return data


/datum/contractor_contract/proc/ui_get_curse_read_success(mob/user, read_chance)
	if(gift_contract)
		return TRUE
	if(user != contractee?.owner)
		return curse_read_success
	if(!curse_read_checked)
		curse_read_checked = TRUE
		curse_read_success = prob(read_chance)
	return curse_read_success

/datum/contractor_contract/proc/ui_clause_list(list/source, are_curses, reveal_hidden)
	var/list/out = list()
	var/index = 1
	if(are_curses)
		for(var/datum/contractor_curse/C as anything in source)
			var/list/entry = C.get_ui_data(src)
			entry["type"] = ui_curse_type(C)
			entry["hidden"] = C.hidden
			entry["revealed"] = reveal_hidden || !C.hidden
			entry["id"] = "curse_[index]"
			entry["index"] = index
			if(!entry["summary"])
				entry["summary"] = entry["desc"]
			out += list(entry)
			index++
	else
		for(var/datum/contractor_bonus/B as anything in source)
			var/list/entry = B.get_ui_data(src)
			entry["type"] = ui_bonus_type(B)
			entry["id"] = "bonus_[index]"
			entry["index"] = index
			if(!entry["summary"])
				entry["summary"] = entry["desc"]
			out += list(entry)
			index++
	return out

/datum/contractor_contract/proc/ui_catalog()
	return list(
		"bonus_types" = list(
			list("id" = "information", "name" = "Information", "desc" = "Reveal a target and give the succubus a mark."),
			list("id" = "body_change", "name" = "Body Change", "desc" = "Temporary mirror-like body editing."),
			list("id" = "orgasm", "name" = "Orgasm", "desc" = "Complete after selected climaxes."),
			list("id" = "item", "name" = "Item", "desc" = "Gold or prepared potion base."),
			list("id" = "custom_item", "name" = "Thing", "desc" = "Selected TAT gear with numeric/passive enchantments."),
			list("id" = "skill", "name" = "Training", "desc" = "Raise a skill."),
			list("id" = "stat", "name" = "Empowerment", "desc" = "Raise a stat.")
		),
		"curse_types" = list(
			list("id" = "effect", "name" = "Trigger: Submission", "desc" = "When the condition fires, adjust submission. Can be positive or negative."),
			list("id" = "arousal", "name" = "Trigger: Arousal", "desc" = "When the condition fires, adjust arousal. Can be positive or negative."),
			list("id" = "orgasm", "name" = "Trigger: Pleasure Shock", "desc" = "When the condition fires, forces climax."),
			list("id" = "stat_loss", "name" = "Trigger: Stat Adjustment", "desc" = "Adjust a stat when the condition fires. Negative hurts, positive blesses."),
			list("id" = "skill_loss", "name" = "Trigger: Skill Adjustment", "desc" = "Adjust a skill when the condition fires. Negative hurts, positive blesses."),
			list("id" = "body_change", "name" = "Body Mark", "desc" = "Succubus edits the target on contract fulfilment."),
			list("id" = "emotion", "name" = "Trigger: Emotion", "desc" = "Shows emotional pressure when the condition fires."),
			list("id" = "flaw", "name" = "Trigger: Vice", "desc" = "Adds a selected vice/flaw once when the condition fires.")
		),
		"stats" = ui_stat_catalog(),
		"skills" = ui_skill_catalog(),
		"item_types" = ui_item_catalog(),
		"custom_item_templates" = contractor_tat_contract_gear_catalog(),
		"custom_item_enchantments" = contractor_magic_item_enchantment_catalog(),
		"flaws" = contractor_charflaw_catalog(),
		"triggers" = list(
			list("id" = "attack", "name" = "Attack"),
			list("id" = "sex_process", "name" = "Sex Process"),
			list("id" = "climax", "name" = "Climax"),
			list("id" = "phrase", "name" = "Phrase"),
			list("id" = "eat", "name" = "Eating"),
			list("id" = "sleep", "name" = "Sleeping"),
			list("id" = "fulfillment", "name" = "Contract Fulfillment")
		),
		"actions" = list(
			list("id" = "attack", "name" = "Attack"),
			list("id" = "sex_process", "name" = "Sex Process"),
			list("id" = "climax", "name" = "Climax"),
			list("id" = "phrase", "name" = "Phrase"),
			list("id" = "eat", "name" = "Eating"),
			list("id" = "sleep", "name" = "Sleeping"),
			list("id" = "fulfillment", "name" = "Contract Fulfillment")
		)
	)

/datum/contractor_contract/proc/ui_stat_catalog()
	var/list/out = list()
	for(var/stat_id in contractor_get_tat_stat_ids())
		out += list(list("id" = stat_id, "name" = contractor_pretty_stat(stat_id)))
	return out

/datum/contractor_contract/proc/ui_skill_catalog()
	var/list/out = list()
	for(var/skill_path in contractor_get_tat_skill_paths())
		out += list(list("id" = "[skill_path]", "name" = contractor_pretty_skill(skill_path), "is_combat" = contractor_is_combat_skill(skill_path)))
	return out

/datum/contractor_contract/proc/ui_item_catalog()
	return list(
		list("id" = "gold_coin", "name" = "Gold coin", "desc" = "Simple Mammon payment."),
		list("id" = "strpot", "name" = "Strength Potion", "desc" = "Alchemical potion."),
		list("id" = "perpot", "name" = "Perception Potion", "desc" = "Alchemical potion."),
		list("id" = "intpot", "name" = "Intelligence Potion", "desc" = "Alchemical potion."),
		list("id" = "conpot", "name" = "Constitution Potion", "desc" = "Alchemical potion."),
		list("id" = "endpot", "name" = "Willpower Potion", "desc" = "Alchemical potion."),
		list("id" = "spdpot", "name" = "Speed Potion", "desc" = "Alchemical potion."),
		list("id" = "lucpot", "name" = "Luck Potion", "desc" = "Alchemical potion."),
		list("id" = "antidote", "name" = "Poison Antidote", "desc" = "Strong antidote."),
		list("id" = "rotcure", "name" = "Rotcure Potion", "desc" = "Expensive rotcure potion."),
		list("id" = "random_spell_scroll", "name" = "Random enchantment scroll", "desc" = "A random spell-granting scroll. More expensive than gold or potion bases.")
	)

/datum/contractor_contract/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!ui_user_can_see(user))
		return FALSE
	switch(action)
		if("add_bonus")
			if(!(ui_phase_for(user) in list("contractor_boons", "succubus_gift_boons")))
				return FALSE
			var/datum/contractor_bonus/B = bonus_from_ui(params)
			if(!B)
				return FALSE
			if(!add_bonus(B))
				qdel(B)
				return FALSE
			return TRUE
		if("remove_bonus")
			if(!(ui_phase_for(user) in list("contractor_boons", "succubus_gift_boons")))
				return FALSE
			return remove_bonus_at(ui_param_num(params, "index", 0))
		if("submit_bonuses")
			if(!(ui_phase_for(user) in list("contractor_boons", "succubus_gift_boons")))
				return FALSE
			if(!length(bonuses))
				return FALSE
			status = CONTRACTOR_CONTRACT_PENDING_CONTRACTOR
			if(contractor?.owner)
				SStgui.update_uis(src)
				ui_interact(contractor.owner)
			return TRUE
		if("add_curse")
			if(ui_phase_for(user) != "succubus_curses")
				return FALSE
			var/datum/contractor_curse/C = curse_from_ui(params)
			if(!C)
				return FALSE
			if(!add_curse(C))
				qdel(C)
				return FALSE
			return TRUE
		if("remove_curse")
			if(ui_phase_for(user) != "succubus_curses")
				return FALSE
			return remove_curse_at(ui_param_num(params, "index", 0))
		if("submit_curses")
			if(ui_phase_for(user) != "succubus_curses")
				return FALSE
			if(calculate_curse_power() > calculate_bonus_power())
				return FALSE
			status = CONTRACTOR_CONTRACT_PENDING_CONTRACTEE
			if(contractee?.owner)
				SStgui.update_uis(src)
				ui_interact(contractee.owner)
			return TRUE
		if("accept_contract")
			if(ui_phase_for(user) != "contractor_signature")
				return FALSE
			return finalize()
		if("refuse_contract")
			if(ui_phase_for(user) != "contractor_signature")
				return FALSE
			if(!gift_contract && contractor?.is_inside_active_seal())
				var/atom/seal = contractor_find_nearby_seal(contractor.owner)
				contractor_break_seal(seal)
			qdel(src)
			return TRUE
		if("cancel_contract")
			if(user != contractor?.owner && user != contractee?.owner)
				return FALSE
			cancel_contract("The contract is cancelled.")
			return TRUE
	return FALSE

/datum/contractor_contract/proc/remove_bonus_at(index)
	if(index < 1 || index > length(bonuses))
		return FALSE
	var/datum/contractor_bonus/B = bonuses[index]
	bonuses.Cut(index, index + 1)
	qdel(B)
	calculate_bonus_power()
	return TRUE

/datum/contractor_contract/proc/remove_curse_at(index)
	if(index < 1 || index > length(curses))
		return FALSE
	var/datum/contractor_curse/C = curses[index]
	curses.Cut(index, index + 1)
	qdel(C)
	calculate_curse_power()
	return TRUE


/datum/contractor_contract/proc/ui_param_text(list/params, key, fallback = "")
	if(!params || !(key in params) || isnull(params[key]))
		return fallback
	return "[params[key]]"

/datum/contractor_contract/proc/ui_param_num(list/params, key, fallback = 0)
	if(!params || !(key in params) || isnull(params[key]))
		return fallback
	var/value = text2num("[params[key]]")
	if(isnull(value))
		return fallback
	return value

/datum/contractor_contract/proc/bonus_from_ui(list/params)
	var/type = ui_param_text(params, "type")
	switch(type)
		if("information")
			var/datum/contractor_bonus/information/B = new
			B.target_name = copytext(ui_param_text(params, "target_name"), 1, MAX_NAME_LEN)
			B.power_cost = 30
			return B
		if("body_change")
			var/datum/contractor_bonus/body_change/B = new
			B.duration = max(1, ui_param_num(params, "duration_minutes", 5)) MINUTES
			B.power_cost = 20
			return B
		if("orgasm")
			var/datum/contractor_bonus/orgasm/B = new
			B.source_type = ui_param_text(params, "source_type", "any")
			B.count = max(1, ui_param_num(params, "count", 1))
			B.power_cost = 20 + max(0, B.count - 1) * 10
			return B
		if("item")
			var/datum/contractor_bonus/item/B = new
			var/item_kind = ui_param_text(params, "item_kind", "gold_coin")
			B.item_kind = item_kind
			B.item_path = item_path_from_ui(item_kind)
			B.amount = max(1, ui_param_num(params, "amount", 1))
			B.value_per_item = item_value_from_ui(item_kind)
			if(item_kind == "random_spell_scroll")
				B.power_cost = 20 + (B.amount * 30)
			else
				B.power_cost = 20 + round((B.amount * B.value_per_item) / 10) * 2
			return B
		if("custom_item")
			var/datum/contractor_bonus/enchanted_item/B = new
			B.item_template = contractor_tat_contract_gear_path(ui_param_text(params, "item_template"))
			if(!B.item_template)
				B.item_template = contractor_tat_contract_first_gear_path()
			if(!B.item_template)
				qdel(B)
				return null
			B.item_color = ui_param_text(params, "color", B.item_color)
			if(contractor_is_contract_weapon_path(B.item_template))
				B.force_bonus = max(0, ui_param_num(params, "force_bonus", 0))
				B.defense_bonus = max(0, ui_param_num(params, "defense_bonus", 0))
			B.passive_stat_key = ui_param_text(params, "passive_stat_key", "")
			B.passive_stat_bonus = max(0, ui_param_num(params, "passive_stat_bonus", 0))
			B.enchantment_spell_path = ui_param_text(params, "enchantment_spell_path", "")
			if(B.enchantment_spell_path == "none")
				B.enchantment_spell_path = null
			B.recalculate_power()
			return B
		if("skill")
			var/datum/contractor_bonus/skill/B = new
			B.skill_type = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			B.amount = max(1, ui_param_num(params, "amount", 1))
			B.power_cost = contractor_contract_power_for_skill(B.skill_type, B.amount)
			return B
		if("stat")
			var/datum/contractor_bonus/stat/B = new
			B.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			B.amount = max(1, ui_param_num(params, "amount", 1))
			B.power_cost = contractor_contract_power_for_stat(B.stat_key, B.amount)
			return B
	return null

/datum/contractor_contract/proc/curse_from_ui(list/params)
	var/type = ui_param_text(params, "type")
	switch(type)
		if("submission")
			var/datum/contractor_curse/submission/C = new
			C.submission_amount = ui_param_num(params, "submission_amount", 25)
			C.power_value = max(5, round(abs(C.submission_amount) / 2) * 5)
			return C
		if("effect")
			var/datum/contractor_curse/effect/C = new
			ui_apply_trigger(C, params)
			C.chunks = ui_param_num(params, "chunks", 1)
			return C
		if("arousal")
			var/datum/contractor_curse/arousal/C = new
			ui_apply_trigger(C, params)
			C.chunks = ui_param_num(params, "chunks", 1)
			if(!C.chunks)
				C.chunks = 1
			return C
		if("orgasm")
			var/datum/contractor_curse/orgasm/C = new
			ui_apply_trigger(C, params)
			C.count = max(1, ui_param_num(params, "count", 1))
			return C
		if("stat_loss")
			var/datum/contractor_curse/stat_loss/C = new
			ui_apply_trigger(C, params)
			C.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			C.amount = ui_param_num(params, "amount", -1)
			if(!C.amount)
				C.amount = -1
			return C
		if("skill_loss")
			var/datum/contractor_curse/skill_loss/C = new
			ui_apply_trigger(C, params)
			C.skill_key = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			C.amount = ui_param_num(params, "amount", -1)
			if(!C.amount)
				C.amount = -1
			return C
		if("stat_transfer")
			var/datum/contractor_curse/stat_transfer/C = new
			C.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			C.amount = max(1, ui_param_num(params, "amount", 1))
			return C
		if("skill_transfer")
			var/datum/contractor_curse/skill_transfer/C = new
			C.skill_key = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			C.amount = max(1, ui_param_num(params, "amount", 1))
			return C
		if("body_change")
			return new /datum/contractor_curse/body
		if("emotion")
			var/datum/contractor_curse/emotion/C = new
			ui_apply_trigger(C, params)
			C.emotion_text = copytext(ui_param_text(params, "emotion_text", C.emotion_text), 1, 1024)
			return C
		if("flaw")
			var/datum/contractor_curse/flaw/C = new
			ui_apply_trigger(C, params)
			C.flaw_type = contractor_charflaw_path(ui_param_text(params, "flaw_type"))
			if(!C.flaw_type)
				qdel(C)
				return null
			return C
	return null

/datum/contractor_contract/proc/ui_apply_trigger(datum/contractor_curse/conditional/C, list/params)
	C.trigger_key = ui_param_text(params, "trigger_key", "sex_process")
	if(!(C.trigger_key in list("attack", "sex_process", "climax", "phrase", "eat", "sleep", "fulfillment")))
		C.trigger_key = "sex_process"
	C.climax_source = ui_param_text(params, "source_type", CONTRACTOR_CLIMAX_SOURCE_ANY)
	C.required_phrase = copytext(ui_param_text(params, "required_phrase", C.required_phrase), 1, 1024)
	C.trigger_chance = clamp(ui_param_num(params, "trigger_chance", C.trigger_chance), CONTRACTOR_ATTACK_TRIGGER_CHANCE_MIN, CONTRACTOR_ATTACK_TRIGGER_CHANCE_MAX)
	return C

/datum/contractor_contract/proc/item_value_from_ui(kind)
	switch(kind)
		if("strpot", "perpot", "intpot", "conpot", "endpot", "spdpot", "lucpot")
			return 30
		if("antidote")
			return 10
		if("rotcure")
			return 250
		if("random_spell_scroll")
			return 150
	return 10

/datum/contractor_contract/proc/item_path_from_ui(kind)
	switch(kind)
		if("strpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/strpot
		if("perpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/perpot
		if("intpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/intpot
		if("conpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/conpot
		if("endpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/endpot
		if("spdpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/spdpot
		if("lucpot")
			return /obj/item/reagent_containers/glass/bottle/alchemical/lucpot
		if("antidote")
			return /obj/item/reagent_containers/glass/bottle/rogue/strong_antidote
		if("rotcure")
			return /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure
		if("random_spell_scroll")
			return text2path("/obj/item/book/granter/spell/random") || /obj/item/roguecoin/gold
	return /obj/item/roguecoin/gold

/datum/contractor_contract/proc/ui_bonus_type(datum/contractor_bonus/B)
	if(istype(B, /datum/contractor_bonus/information))
		return "information"
	if(istype(B, /datum/contractor_bonus/body_change))
		return "body_change"
	if(istype(B, /datum/contractor_bonus/orgasm))
		return "orgasm"
	if(istype(B, /datum/contractor_bonus/item))
		return "item"
	if(istype(B, /datum/contractor_bonus/enchanted_item))
		return "custom_item"
	if(istype(B, /datum/contractor_bonus/skill))
		return "skill"
	if(istype(B, /datum/contractor_bonus/stat))
		return "stat"
	return "bonus"

/datum/contractor_contract/proc/ui_curse_type(datum/contractor_curse/C)
	if(istype(C, /datum/contractor_curse/submission))
		return "submission"
	if(istype(C, /datum/contractor_curse/effect))
		return "effect"
	if(istype(C, /datum/contractor_curse/arousal))
		return "arousal"
	if(istype(C, /datum/contractor_curse/orgasm))
		return "orgasm"
	if(istype(C, /datum/contractor_curse/stat_loss))
		return "stat_loss"
	if(istype(C, /datum/contractor_curse/skill_loss))
		return "skill_loss"
	if(istype(C, /datum/contractor_curse/stat_transfer))
		return "stat_transfer"
	if(istype(C, /datum/contractor_curse/skill_transfer))
		return "skill_transfer"
	if(istype(C, /datum/contractor_curse/body))
		return "body_change"
	if(istype(C, /datum/contractor_curse/emotion))
		return "emotion"
	if(istype(C, /datum/contractor_curse/flaw))
		return "flaw"
	return "curse"
