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
	data["succubus_name"] = contractor?.owner?.real_name || contractor?.owner?.name || "Unknown"
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
			var/datum/contractor_bonus/information/inf = new
			inf.target_name = copytext(ui_param_text(params, "target_name"), 1, MAX_NAME_LEN)
			inf.power_cost = 30
			return inf
		if("body_change")
			var/datum/contractor_bonus/body_change/bc = new
			bc.duration = max(1, ui_param_num(params, "duration_minutes", 5)) MINUTES
			bc.power_cost = 20
			return bc
		if("orgasm")
			var/datum/contractor_bonus/orgasm/org = new
			org.source_type = ui_param_text(params, "source_type", "any")
			org.count = max(1, ui_param_num(params, "count", 1))
			org.power_cost = 20 + max(0, org.count - 1) * 10
			return org
		if("item")
			var/datum/contractor_bonus/item/it = new
			var/item_kind = ui_param_text(params, "item_kind", "gold_coin")
			it.item_kind = item_kind
			it.item_path = item_path_from_ui(item_kind)
			it.amount = max(1, ui_param_num(params, "amount", 1))
			it.value_per_item = item_value_from_ui(item_kind)
			if(item_kind == "random_spell_scroll")
				it.power_cost = 20 + (it.amount * 30)
			else
				it.power_cost = 20 + round((it.amount * it.value_per_item) / 10) * 2
			return it
		if("custom_item")
			var/datum/contractor_bonus/enchanted_item/ei = new
			ei.item_template = contractor_tat_contract_gear_path(ui_param_text(params, "item_template"))
			if(!ei.item_template)
				ei.item_template = contractor_tat_contract_first_gear_path()
			if(!ei.item_template)
				qdel(ei)
				return null
			ei.item_color = ui_param_text(params, "color", ei.item_color)
			if(contractor_is_contract_weapon_path(ei.item_template))
				ei.force_bonus = max(0, ui_param_num(params, "force_bonus", 0))
				ei.defense_bonus = max(0, ui_param_num(params, "defense_bonus", 0))
			ei.passive_stat_bonus = max(0, ui_param_num(params, "passive_stat_bonus", 0))
			ei.passive_stat_key = ui_param_text(params, "passive_stat_key", ei.passive_stat_bonus ? STATKEY_STR : "")
			if(ei.passive_stat_bonus)
				ei.passive_stat_key = contractor_normalize_stat_key(ei.passive_stat_key, STATKEY_STR)
			ei.enchantment_spell_path = ui_param_text(params, "enchantment_spell_path", "none")
			if(!ei.enchantment_spell_path || ei.enchantment_spell_path == "none")
				ei.enchantment_spell_path = null
			ei.recalculate_power()
			return ei
		if("skill")
			var/datum/contractor_bonus/skill/sk = new
			sk.skill_type = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			sk.amount = max(1, ui_param_num(params, "amount", 1))
			sk.power_cost = contractor_contract_power_for_skill(sk.skill_type, sk.amount)
			return sk
		if("stat")
			var/datum/contractor_bonus/stat/st = new
			st.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			st.amount = max(1, ui_param_num(params, "amount", 1))
			st.power_cost = contractor_contract_power_for_stat(st.stat_key, st.amount)
			return st
	return null

/datum/contractor_contract/proc/curse_from_ui(list/params)
	var/type = ui_param_text(params, "type")
	switch(type)
		if("submission")
			var/datum/contractor_curse/submission/sub = new
			sub.submission_amount = ui_param_num(params, "submission_amount", 25)
			sub.power_value = max(5, round(abs(sub.submission_amount) / 2) * 5)
			return sub
		if("effect")
			var/datum/contractor_curse/effect/eff = new
			ui_apply_trigger(eff, params)
			eff.chunks = ui_param_num(params, "chunks", 1)
			return eff
		if("arousal")
			var/datum/contractor_curse/arousal/ar = new
			ui_apply_trigger(ar, params)
			ar.chunks = ui_param_num(params, "chunks", 1)
			if(!ar.chunks)
				ar.chunks = 1
			return ar
		if("orgasm")
			var/datum/contractor_curse/orgasm/org = new
			ui_apply_trigger(org, params)
			org.count = max(1, ui_param_num(params, "count", 1))
			return org
		if("stat_loss")
			var/datum/contractor_curse/stat_loss/sl = new
			ui_apply_trigger(sl, params)
			sl.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			sl.amount = ui_param_num(params, "amount", -1)
			if(!sl.amount)
				sl.amount = -1
			return sl
		if("skill_loss")
			var/datum/contractor_curse/skill_loss/skl = new
			ui_apply_trigger(skl, params)
			skl.skill_key = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			skl.amount = ui_param_num(params, "amount", -1)
			if(!skl.amount)
				skl.amount = -1
			return skl
		if("stat_transfer")
			var/datum/contractor_curse/stat_transfer/st = new
			st.stat_key = ui_param_text(params, "stat_key", STATKEY_STR)
			st.amount = max(1, ui_param_num(params, "amount", 1))
			return st
		if("skill_transfer")
			var/datum/contractor_curse/skill_transfer/skt = new
			skt.skill_key = text2path(ui_param_text(params, "skill_key")) || /datum/skill/misc/reading
			skt.amount = max(1, ui_param_num(params, "amount", 1))
			return skt
		if("body_change")
			return new /datum/contractor_curse/body
		if("emotion")
			var/datum/contractor_curse/emotion/em = new
			ui_apply_trigger(em, params)
			em.emotion_text = copytext(ui_param_text(params, "emotion_text", em.emotion_text), 1, 1024)
			return em
		if("flaw")
			var/datum/contractor_curse/flaw/fl = new
			ui_apply_trigger(fl, params)
			fl.flaw_type = contractor_charflaw_path(ui_param_text(params, "flaw_type"))
			if(!fl.flaw_type)
				var/list/flaw_catalog = contractor_charflaw_catalog()
				if(length(flaw_catalog))
					var/list/first_flaw = flaw_catalog[1]
					fl.flaw_type = contractor_charflaw_path(first_flaw?["id"])
			if(!fl.flaw_type)
				qdel(fl)
				return null
			return fl
	return null

/datum/contractor_contract/proc/ui_apply_trigger(datum/contractor_curse/conditional/C, list/params)
	C.trigger_key = ui_param_text(params, "trigger_key", ui_param_text(params, "action_id", "attack"))
	if(!(C.trigger_key in list("attack", "sex_process", "climax", "phrase", "eat", "sleep", "fulfillment")))
		C.trigger_key = "attack"
	C.climax_source = ui_param_text(params, "source_type", ui_param_text(params, "climax_source", CONTRACTOR_CLIMAX_SOURCE_ANY))
	C.required_phrase = copytext(ui_param_text(params, "required_phrase", C.required_phrase), 1, 1024)
	C.trigger_chance = clamp(ui_param_num(params, "trigger_chance", ui_param_num(params, "chance", C.trigger_chance)), CONTRACTOR_ATTACK_TRIGGER_CHANCE_MIN, CONTRACTOR_ATTACK_TRIGGER_CHANCE_MAX)
	return C

/datum/contractor_contract/proc/item_value_from_ui(kind)
	switch(kind)
		if("strpot", "perpot", "intpot", "conpot", "spdpot", "lucpot")
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
