// Consolidated contractor curses/price clauses.

// ---- _contractor_curse.dm ----

/datum/contractor_curse
	var/name = "infernal curse"
	var/desc = "A hidden price attached to an infernal contract."
	var/power_value = 10
	var/hidden = TRUE

/datum/contractor_curse/proc/can_apply(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_curse/proc/apply(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_curse/proc/remove(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_curse/proc/on_contract_broken(datum/contractor_contract/contract, reason)
	remove(contract)
	return TRUE

/datum/contractor_curse/proc/on_contract_fulfilled(datum/contractor_contract/contract, reason)
	return TRUE

/datum/contractor_curse/proc/fire_contract_fulfillment(datum/contractor_contract/contract, reason)
	return on_contract_fulfilled(contract, reason)

/datum/contractor_curse/proc/get_power_value(datum/contractor_contract/contract)
	return max(1, power_value * 2)

/datum/contractor_curse/proc/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = desc, "power" = get_power_value(contract), "hidden" = hidden)

/datum/contractor_curse/conditional
	var/trigger_key = "sex_process"
	var/climax_source = CONTRACTOR_CLIMAX_SOURCE_ANY
	var/required_phrase
	var/trigger_chance = 100
	var/tmp/datum/contractor_contract/source_contract
	var/tmp/fulfillment_price_fired = FALSE

/datum/contractor_curse/conditional/apply(datum/contractor_contract/contract)
	source_contract = contract
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(!H)
		return FALSE
	RegisterSignal(H, COMSIG_ATTACK_TRY_CONSUME, PROC_REF(on_attack))
	RegisterSignal(H, COMSIG_SEX_RECEIVE_ACTION, PROC_REF(on_sex_action))
	RegisterSignal(H, COMSIG_SEX_CLIMAX, PROC_REF(on_climax))
	RegisterSignal(H, COMSIG_MOB_SAY, PROC_REF(on_say))
	RegisterSignal(H, COMSIG_MOB_EAT, PROC_REF(on_eat))
	RegisterSignal(H, COMSIG_MOB_SLEEP, PROC_REF(on_sleep))
	return TRUE

/datum/contractor_curse/conditional/remove(datum/contractor_contract/contract)
	var/mob/living/carbon/human/H = contract.contractee?.owner
	if(H)
		UnregisterSignal(H, COMSIG_ATTACK_TRY_CONSUME)
		UnregisterSignal(H, COMSIG_SEX_RECEIVE_ACTION)
		UnregisterSignal(H, COMSIG_SEX_CLIMAX)
		UnregisterSignal(H, COMSIG_MOB_SAY)
		UnregisterSignal(H, COMSIG_MOB_EAT)
		UnregisterSignal(H, COMSIG_MOB_SLEEP)
	source_contract = null
	return TRUE

/datum/contractor_curse/conditional/proc/condition_matches(key)
	return source_contract && source_contract.is_active() && trigger_key == key

/datum/contractor_curse/conditional/proc/on_condition_met()
	return TRUE

/datum/contractor_curse/conditional/proc/on_attack(datum/source, atom/target_atom, zone, obj/item/W)
	SIGNAL_HANDLER
	if(!condition_matches("attack"))
		return 0
	if(!prob(trigger_chance))
		return 0
	on_condition_met()
	return 0

/datum/contractor_curse/conditional/proc/on_sex_action(datum/source, power = 1, forced = 0, active = TRUE, stage = 1, tick_count = 1, datum/link = null)
	SIGNAL_HANDLER
	if(condition_matches("sex_process"))
		on_condition_met()
	return 0

/datum/contractor_curse/conditional/proc/on_climax(datum/source, source_type = CONTRACTOR_CLIMAX_SOURCE_ANY)
	SIGNAL_HANDLER
	if(!condition_matches("climax"))
		return 0
	if(climax_source != CONTRACTOR_CLIMAX_SOURCE_ANY && source_type != climax_source)
		return 0
	on_condition_met()
	return 0

/datum/contractor_curse/conditional/proc/on_eat(datum/source)
	SIGNAL_HANDLER
	if(condition_matches("eat"))
		on_condition_met()
	return 0

/datum/contractor_curse/conditional/proc/on_sleep(datum/source)
	SIGNAL_HANDLER
	if(condition_matches("sleep"))
		on_condition_met()
	return 0

/datum/contractor_curse/conditional/proc/on_say(mob/source, list/speech_args)
	SIGNAL_HANDLER
	if(!condition_matches("phrase"))
		return 0
	if(!required_phrase)
		return 0
	var/message = ""
	if(islist(speech_args))
		message = speech_args[SPEECH_MESSAGE]
	else
		message = "[speech_args]"
	if(findtext(lowertext(message), lowertext(required_phrase)))
		on_condition_met()
	return 0

/datum/contractor_curse/conditional/fire_contract_fulfillment(datum/contractor_contract/contract, reason)
	if(trigger_key != "fulfillment")
		return on_contract_fulfilled(contract, reason)
	if(fulfillment_price_fired)
		return TRUE
	fulfillment_price_fired = TRUE

	// Fulfillment is not a normal mob signal. It happens inside the contract
	// completion stack, including instant contracts and self-test contracts, so
	// it must bypass condition_matches()/is_active() entirely.
	source_contract = contract
	return on_condition_met()

/datum/contractor_curse/conditional/proc/trigger_power_multiplier()
	if(trigger_key == "fulfillment")
		return 0.5
	if(trigger_key == "attack")
		return max(1, trigger_chance / 5)
	if(trigger_key == "climax" && climax_source == CONTRACTOR_CLIMAX_SOURCE_ANY)
		return 4
	return 1

/datum/contractor_curse/conditional/proc/apply_trigger_power(base_value)
	return max(1, round(base_value * 2 * trigger_power_multiplier()))

/datum/contractor_curse/conditional/proc/trigger_summary()
	if(trigger_key == "attack")
		return "attack ([trigger_chance]% chance)"
	if(trigger_key == "sex_process")
		return "sex process"
	if(trigger_key == "phrase")
		return "phrase '[required_phrase]'"
	if(trigger_key == "eat")
		return "eating"
	if(trigger_key == "sleep")
		return "sleeping"
	if(trigger_key == "fulfillment")
		return "contract fulfillment (half price)"
	if(trigger_key == "climax")
		if(climax_source == CONTRACTOR_CLIMAX_SOURCE_ANY)
			return "any climax (x4 price)"
		return "climax from [climax_source]"
	return trigger_key


// ---- submission_curse.dm ----

/datum/contractor_curse/submission
	name = "obedience clause"
	desc = "Adds submission to the contractee immediately."
	power_value = 20
	var/submission_amount = 25

/datum/contractor_curse/submission/apply(datum/contractor_contract/contract)
	contract.contractee?.adjust_submission(submission_amount)
	return TRUE


// ---- stat_transfer_curse.dm ----

/datum/contractor_curse/stat_transfer
	name = "attribute tithe"
	desc = "Transfers temporary stat strength from contractee to contractor."
	power_value = 30
	var/stat_key = STATKEY_STR
	var/amount = 1
	var/duration = 10 MINUTES

/datum/contractor_curse/stat_transfer/get_power_value(datum/contractor_contract/contract)
	return max(1, amount) * 10

/datum/contractor_curse/stat_transfer/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/contractee = contract.contractee?.owner
	var/mob/living/carbon/human/contractor = contract.contractor?.owner
	if(!contractee || !contractor)
		return FALSE
	contractor_apply_temp_stat(contractee, stat_key, -amount, duration)
	contractor_apply_temp_stat(contractor, stat_key, amount, duration)
	return TRUE


// ---- orgasm_curse.dm ----

/datum/contractor_curse/orgasm
	parent_type = /datum/contractor_curse/conditional
	name = "pleasure shock clause"
	desc = "Forces climax when its condition is met."
	var/count = 1

/datum/contractor_curse/orgasm/can_apply(datum/contractor_contract/contract)
	return !contractor_is_defiant(contract.contractee.owner)

/datum/contractor_curse/orgasm/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(max(1, count) * 10)

/datum/contractor_curse/orgasm/on_condition_met()
	if(!source_contract)
		return FALSE
	var/mob/living/carbon/human/H = source_contract.contractee?.owner
	if(!H)
		return FALSE
	var/result = contractor_force_climax(H, max(1, count))
	if(result)
		to_chat(H, span_love("The contract shocks your body into a sudden climax."))
	return result

/datum/contractor_curse/orgasm/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], forces [max(1, count)] climax[ max(1, count) == 1 ? "" : "es" ]", "power" = get_power_value(contract), "hidden" = hidden)


// ---- skill_transfer_curse.dm ----

/datum/contractor_curse/skill_transfer
	name = "skill tithe"
	desc = "Temporarily lends a skill imprint to the contractor."
	power_value = 30
	var/skill_key
	var/amount = 1
	var/duration = 10 MINUTES

/datum/contractor_curse/skill_transfer/get_power_value(datum/contractor_contract/contract)
	return contractor_contract_power_for_skill(skill_key, amount)

/datum/contractor_curse/skill_transfer/apply(datum/contractor_contract/contract)
	var/mob/living/carbon/human/contractee = contract.contractee?.owner
	var/mob/living/carbon/human/contractor = contract.contractor?.owner
	if(!contractee || !contractor)
		return FALSE
	contractor_apply_temp_skill(contractee, skill_key, -amount, duration)
	contractor_apply_temp_skill(contractor, skill_key, amount, duration)
	return TRUE


// ---- phrase_curse.dm ----

/datum/contractor_curse/phrase
	parent_type = /datum/contractor_curse/effect
	name = "spoken clause"
	desc = "Rewards submission when the contractee says a phrase."
	trigger_key = "phrase"
	var/submission_reward = 10

/datum/contractor_curse/phrase/get_power_value(datum/contractor_contract/contract)
	return max(5, round(submission_reward / 2) * 5)

/datum/contractor_curse/phrase/on_condition_met()
	if(!source_contract)
		return FALSE
	source_contract.contractee.adjust_submission(submission_reward)
	return TRUE


// ---- emotion_curse.dm ----

/datum/contractor_curse/emotion
	parent_type = /datum/contractor_curse/conditional
	name = "emotional trigger"
	desc = "Applies a roleplay/emotion pressure when the condition fires."
	power_value = 10
	var/emotion_text = "longing"

/datum/contractor_curse/emotion/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(power_value)

/datum/contractor_curse/emotion/on_condition_met()
	var/mob/living/carbon/human/H = source_contract?.contractee?.owner
	if(!H)
		return FALSE
	H.apply_status_effect(/datum/status_effect/debuff/contractor_emotion_pressure, emotion_text)
	to_chat(H, span_notice("You feel a strange [emotion_text] settle in your chest."))
	return TRUE

/datum/contractor_curse/emotion/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], emotion: [emotion_text]. No timer; once triggered, it remains as a contract price.", "power" = get_power_value(contract), "hidden" = hidden)


// ---- action_curse.dm ----

/datum/contractor_curse/action
	parent_type = /datum/contractor_curse/conditional
	name = "action clause"
	desc = "Adds submission when the contractee performs a chosen action."
	var/action_id = "attack"
	var/submission_reward = 10

/datum/contractor_curse/action/apply(datum/contractor_contract/contract)
	trigger_key = action_id
	return ..()

/datum/contractor_curse/action/get_power_value(datum/contractor_contract/contract)
	return max(5, round(submission_reward / 2) * 5)

/datum/contractor_curse/action/on_condition_met()
	if(!source_contract)
		return FALSE
	source_contract.contractee.adjust_submission(submission_reward)
	return TRUE


// ---- body_curse.dm ----

/datum/contractor_curse/body
	name = "body mark"
	desc = "Lets the succubus reshape the contractee when the contract is fulfilled."
	power_value = 25

/datum/contractor_curse/body/apply(datum/contractor_contract/contract)
	return TRUE

/datum/contractor_curse/body/on_contract_fulfilled(datum/contractor_contract/contract, reason)
	var/mob/living/carbon/human/editor = contract.contractor?.owner
	var/mob/living/carbon/human/target = contract.contractee?.owner
	if(!editor || !target)
		return FALSE
	return contractor_grant_body_mark_spell(editor, target, CONTRACTOR_BODY_CHANGE_PERMISSION_TIME)


// ---- effect_curse.dm ----

/datum/contractor_curse/effect
	parent_type = /datum/contractor_curse/conditional
	name = "Submission trigger"
	desc = "Adjusts submission when the chosen condition fires. Positive or negative values are allowed."
	var/chunks = 1

/datum/contractor_curse/effect/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(max(1, abs(chunks)) * 5)

/datum/contractor_curse/effect/on_condition_met()
	if(!source_contract)
		return FALSE
	var/delta = 2 * chunks
	source_contract.contractee.adjust_submission(delta)
	if(source_contract.contractee.owner)
		to_chat(source_contract.contractee.owner, span_notice("The contract shifts your submission by [delta]."))
	return TRUE

/datum/contractor_curse/effect/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], [chunks >= 0 ? "+" : ""][2 * chunks] submission", "power" = get_power_value(contract), "hidden" = hidden)


// ---- arousal_curse.dm ----

/datum/contractor_curse/arousal
	parent_type = /datum/contractor_curse/conditional
	name = "Arousal trigger"
	desc = "Adjusts arousal when the chosen condition fires. Positive or negative values are allowed."
	var/chunks = 1

/datum/contractor_curse/arousal/can_apply(datum/contractor_contract/contract)
	return !contractor_is_defiant(contract.contractee.owner)

/datum/contractor_curse/arousal/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(max(1, abs(chunks)) * 5)

/datum/contractor_curse/arousal/on_condition_met()
	if(!source_contract)
		return FALSE
	var/mob/living/carbon/human/H = source_contract.contractee?.owner
	if(!H)
		return FALSE
	var/result = contractor_add_arousal(H, 5 * chunks, 5 MINUTES * max(1, abs(chunks)))
	if(result)
		to_chat(H, span_love("The contract stirs your arousal."))
	return result

/datum/contractor_curse/arousal/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], [chunks >= 0 ? "+" : ""][5 * chunks] arousal for [5 * max(1, abs(chunks))] minutes", "power" = get_power_value(contract), "hidden" = hidden)


// ---- stat_loss_curse.dm ----

/datum/contractor_curse/stat_loss
	parent_type = /datum/contractor_curse/conditional
	name = "Stat adjustment"
	desc = "Contractee gains or loses a stat when the condition fires."
	var/stat_key = STATKEY_STR
	var/amount = -1

/datum/contractor_curse/stat_loss/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(max(1, abs(amount)) * 10)

/datum/contractor_curse/stat_loss/on_condition_met()
	return contractor_apply_stat_delta(source_contract.contractee.owner, stat_key, amount)

/datum/contractor_curse/stat_loss/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], [amount >= 0 ? "+" : ""][amount] [stat_key]", "power" = get_power_value(contract), "hidden" = hidden)


// ---- skill_loss_curse.dm ----

/datum/contractor_curse/skill_loss
	parent_type = /datum/contractor_curse/conditional
	name = "Skill adjustment"
	desc = "Contractee gains or loses a skill when the condition fires."
	var/skill_key
	var/amount = -1

/datum/contractor_curse/skill_loss/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(contractor_contract_power_for_skill(skill_key, abs(amount)))

/datum/contractor_curse/skill_loss/on_condition_met()
	return contractor_apply_skill_delta(source_contract.contractee.owner, skill_key, amount)

/datum/contractor_curse/skill_loss/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], [amount >= 0 ? "+" : ""][amount] [skill_key]", "power" = get_power_value(contract), "hidden" = hidden)




// ---- flaw_curse.dm ----

/datum/contractor_curse/flaw
	parent_type = /datum/contractor_curse/conditional
	name = "Vice trigger"
	desc = "Adds a selected character vice/flaw once when the condition fires."
	var/flaw_type = /datum/charflaw/addiction/lovefiend
	var/applied = FALSE

/datum/contractor_curse/flaw/get_power_value(datum/contractor_contract/contract)
	return apply_trigger_power(30)

/datum/contractor_curse/flaw/on_condition_met()
	if(applied || !source_contract?.contractee?.owner)
		return FALSE
	var/mob/living/carbon/human/H = source_contract.contractee.owner
	if(contractor_apply_charflaw_once(H, flaw_type))
		applied = TRUE
		to_chat(H, span_warning("The contract brands a new vice into your soul: [contractor_pretty_charflaw(flaw_type)]."))
		return TRUE
	return FALSE

/datum/contractor_curse/flaw/get_ui_data(datum/contractor_contract/contract)
	return list("name" = name, "desc" = "Trigger: [trigger_summary()], vice: [contractor_pretty_charflaw(flaw_type)] (once)", "power" = get_power_value(contract), "hidden" = hidden)
