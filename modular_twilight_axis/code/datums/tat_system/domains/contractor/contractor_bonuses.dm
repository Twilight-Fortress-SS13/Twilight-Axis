// Consolidated contractor boons/bonuses.

// ---- _contractor_bonus.dm ----

/datum/contractor_bonus
	var/name = "infernal bonus"
	var/desc = "A granted benefit from an infernal contract."
	var/power_cost = 10
	var/persists_after_contractor_death = FALSE
	var/fulfills_contract_immediately = TRUE

/datum/contractor_bonus/proc/can_apply(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_bonus/proc/apply(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_bonus/proc/remove(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_bonus/proc/on_contract_broken(datum/contractor_contract/contract, reason)
	if(!persists_after_contractor_death)
		remove(contract)
	return TRUE

/datum/contractor_bonus/proc/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = desc, "power" = power_cost)


// ---- information_bonus.dm ----

/datum/contractor_bonus/information
	name = "revealed mark"
	desc = "Marks a person or object for the succubus and fulfills after a short confirmation window."
	power_cost = 30
	fulfills_contract_immediately = FALSE
	var/target_name
	var/tmp/atom/marked_target

/datum/contractor_bonus/information/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/contractee = contract.contractee?.owner
	var/mob/living/carbon/human/succubus = contract.contractor?.owner
	if(!contractee)
		return FALSE
	marked_target = contractor_find_atom_by_name(target_name)
	if(!marked_target)
		to_chat(contractee, span_warning("The contract finds no such person or object."))
		return FALSE
	var/area/A = get_area(marked_target)
	var/turf/T = get_turf(marked_target)
	if(contractee)
		to_chat(contractee, span_notice("The pact whispers that [marked_target] is near [A?.name || "unknown lands"]."))
	if(succubus)
		var/direction = contractor_direction_to_text(succubus, marked_target)
		to_chat(succubus, span_notice("The contract marks [marked_target] for you: [A?.name || "unknown lands"], [direction][T ? " ([T.x], [T.y], [T.z])" : ""]."))
	addtimer(CALLBACK(contract, TYPE_PROC_REF(/datum/contractor_contract, fulfill), "information_confirmed"), CONTRACTOR_CONTRACT_INFORMATION_CONFIRM_TIME)
	return TRUE


// ---- item_bonus.dm ----

/datum/contractor_bonus/item
	name = "granted item"
	desc = "Creates gold or prepared potion bases for the contractee."
	power_cost = 20
	var/item_kind = "gold"
	var/item_path = /obj/item/roguecoin/gold
	var/amount = 1
	var/value_per_item = 10

/datum/contractor_bonus/item/can_apply(datum/contractor_contract/contract)
	return ispath(item_path, /obj/item)

/datum/contractor_bonus/item/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H || !ispath(item_path, /obj/item))
		return FALSE
	var/spawned = 0
	for(var/i in 1 to max(1, amount))
		var/obj/item/I = new item_path(get_turf(H))
		if(!I)
			continue
		spawned++
		if(!H.put_in_hands(I))
			I.forceMove(get_turf(H))
	if(spawned <= 0)
		return FALSE
	to_chat(H, span_notice("The contract creates [spawned] item[spawned == 1 ? "" : "s"] for you."))
	return TRUE


// ---- enchanted_item_bonus.dm ----
/datum/contractor_bonus/enchanted_item
	name = "contract-forged item"
	desc = "Creates one selected TAT item with optional contract enchantments."
	power_cost = 20
	var/item_template = null
	var/item_color = "#8B003C"
	var/force_bonus = 0
	var/defense_bonus = 0
	var/passive_stat_key = null
	var/passive_stat_bonus = 0
	var/enchantment_spell_path = null
	var/tmp/obj/item/created_item

/datum/contractor_bonus/enchanted_item/proc/is_weapon_template()
	return contractor_is_contract_weapon_path(item_template)

/datum/contractor_bonus/enchanted_item/proc/recalculate_power()
	var/template_cost = 0
	if(item_template && islist(GLOB.tat_available_items))
		var/list/entry = GLOB.tat_available_items[item_template]
		if(islist(entry) && isnum(entry["cost"]))
			template_cost = entry["cost"]

	power_cost = 20 + (template_cost * 5)
	if(is_weapon_template())
		power_cost += (max(0, force_bonus) * 10)
		power_cost += (max(0, defense_bonus) * 10)
	power_cost += (max(0, passive_stat_bonus) * 8)
	if(enchantment_spell_path)
		power_cost += contractor_magic_item_enchantment_power(enchantment_spell_path)
	return power_cost

/datum/contractor_bonus/enchanted_item/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H || !ispath(item_template, /obj/item))
		return FALSE

	var/obj/item/I = new item_template(get_turf(H))
	if(!I)
		return FALSE
	created_item = I

	I.color = item_color

	if(is_weapon_template())
		if(force_bonus)
			contractor_apply_weapon_force_bonus(I, force_bonus)
		if(defense_bonus)
			contractor_apply_weapon_defense_bonus(I, defense_bonus)

	if(passive_stat_key && passive_stat_bonus)
		I.desc += " While worn, it is meant to grant +[passive_stat_bonus] [passive_stat_key]."
		to_chat(H, span_notice("[I] hums with a passive +[passive_stat_bonus] [passive_stat_key] enchantment."))

	if(enchantment_spell_path)
		contractor_apply_magic_item_enchantment(I, enchantment_spell_path, H)

	if(H.put_in_hands(I))
		to_chat(H, span_notice("The contract places [I] into your hands."))
	else
		I.forceMove(get_turf(H))
		to_chat(H, span_notice("The contract creates [I] at your feet."))
	return TRUE

/datum/contractor_bonus/enchanted_item/remove(datum/contractor_contract/contract)
	// A fulfilled contract must not delete the granted item when the contract datum qdels.
	// Broken/cancelled/rollback contracts still clean it up.
	if(contract?.status == CONTRACTOR_CONTRACT_FULFILLED)
		created_item = null
		return TRUE
	if(created_item && !QDELETED(created_item))
		qdel(created_item)
	created_item = null
	return TRUE

/datum/contractor_bonus/enchanted_item/get_ui_data(datum/contractor_contract/contract)
	var/template_name = "unknown item"
	if(item_template && islist(GLOB.tat_available_items))
		var/list/entry = GLOB.tat_available_items[item_template]
		if(islist(entry))
			template_name = entry["name"] || "[item_template]"

	var/passive_name = passive_stat_key || "none"
	var/enchant_name = contractor_magic_item_enchantment_name(enchantment_spell_path)
	var/weapon_text = is_weapon_template() ? ", force +[force_bonus], defense +[defense_bonus]" : ""
	return list("name" = name, "desc" = "[template_name][weapon_text], passive [passive_name] +[passive_stat_bonus], enchantment: [enchant_name]", "power" = power_cost)


// ---- orgasm_bonus.dm ----

/datum/contractor_bonus/orgasm
	name = "promised climax"
	desc = "Fulfills when the contractee climaxes enough times."
	power_cost = 20
	fulfills_contract_immediately = FALSE
	var/count = 1
	var/source_type = "any"
	var/tmp/current_count = 0
	var/tmp/datum/contractor_contract/source_contract

/datum/contractor_bonus/orgasm/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H)
		return FALSE
	source_contract = contract
	current_count = 0
	RegisterSignal(H, COMSIG_SEX_CLIMAX, PROC_REF(on_climax))
	to_chat(H, span_notice("The contract waits for [count] promised climax[count == 1 ? "" : "es"]."))
	return TRUE

/datum/contractor_bonus/orgasm/remove(datum/contractor_contract/contract)
	if(contract.contractee?.owner)
		UnregisterSignal(contract.contractee.owner, COMSIG_SEX_CLIMAX)
	source_contract = null
	return TRUE

/datum/contractor_bonus/orgasm/proc/on_climax(datum/source)
	SIGNAL_HANDLER
	if(!source_contract || !source_contract.is_active())
		return
	current_count++	
	if(current_count >= max(1, count))
		source_contract.fulfill("orgasm_boon_complete")


// ---- body_change_bonus.dm ----

/datum/contractor_bonus/body_change
	name = "body alteration"
	desc = "Grants temporary mirror-changing permission."
	power_cost = 20
	fulfills_contract_immediately = FALSE
	var/duration = CONTRACTOR_BODY_CHANGE_PERMISSION_TIME

/datum/contractor_bonus/body_change/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H)
		return FALSE
	H.apply_status_effect(/datum/status_effect/buff/contractor_mirror_permission, duration, contract)
	to_chat(H, span_notice("The contract lets you reshape yourself through mirrors for [round(duration / 600)] minutes."))
	return TRUE

/datum/contractor_bonus/body_change/remove(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(H)
		H.remove_status_effect(/datum/status_effect/buff/contractor_mirror_permission)
	return TRUE


// ---- stat_bonus.dm ----

/datum/contractor_bonus/stat
	name = "stat boon"
	desc = "Improves a stat."
	power_cost = 10
	var/stat_key = STATKEY_STR
	var/amount = 1

/datum/contractor_bonus/stat/apply(datum/contractor_contract/contract)
	return contractor_apply_stat_delta(contract.contractee?.owner, stat_key, amount)


// ---- skill_bonus.dm ----

/datum/contractor_bonus/skill
	name = "skill boon"
	desc = "Improves a Twilight Axis skill."
	power_cost = 10
	var/skill_type = /datum/skill/misc/reading
	var/amount = 1

/datum/contractor_bonus/skill/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H || !ispath(skill_type, /datum/skill))
		return FALSE
	var/current = H.get_skill_level(skill_type)
	H.adjust_skillrank_up_to(skill_type, current + amount, TRUE)
	return TRUE


