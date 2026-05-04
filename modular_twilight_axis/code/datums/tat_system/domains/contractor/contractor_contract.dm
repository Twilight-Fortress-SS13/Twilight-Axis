
/datum/contractor_contract
	var/datum/component/contractor/contractor
	var/datum/component/contractee/contractee
	var/list/bonuses = list()
	var/list/curses = list()
	var/status = CONTRACTOR_CONTRACT_DRAFT
	var/lux_power = 0
	var/bonus_power = 0
	var/curse_power = 0
	var/created_time = 0
	var/activated_time = 0
	var/fulfilled_time = 0
	var/broken_time = 0
	var/cancelled_time = 0
	var/gift_contract = FALSE
	var/applied = FALSE
	var/pending_fulfillment = FALSE
	var/reward_recorded = FALSE
	var/tmp/curse_read_checked = FALSE
	var/tmp/curse_read_success = FALSE

/datum/contractor_contract/New(datum/component/contractor/_contractor, datum/component/contractee/_contractee)
	..()
	contractor = _contractor
	contractee = _contractee
	created_time = world.time

/datum/contractor_contract/Destroy(force, ...)
	if(applied)
		for(var/datum/contractor_bonus/bonus as anything in bonuses)
			bonus.remove(src)
		for(var/datum/contractor_curse/curse as anything in curses)
			curse.remove(src)
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		qdel(bonus)
	for(var/datum/contractor_curse/curse as anything in curses)
		qdel(curse)
	bonuses.Cut()
	curses.Cut()
	if(contractor)
		contractor.contracts -= src
	if(contractee)
		contractee.contracts -= src
	contractor = null
	contractee = null
	return ..()

/datum/contractor_contract/proc/add_bonus(datum/contractor_bonus/bonus)
	if(!bonus || applied)
		return FALSE
	if(!gift_contract && length(bonuses))
		return FALSE
	bonuses += bonus
	bonus_power = calculate_bonus_power()
	return TRUE

/datum/contractor_contract/proc/add_curse(datum/contractor_curse/curse)
	if(!curse || applied)
		return FALSE
	curses += curse
	curse_power = calculate_curse_power()
	return TRUE

/datum/contractor_contract/proc/calculate_bonus_power()
	var/total = 0
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		total += bonus.power_cost
	bonus_power = total
	return total

/datum/contractor_contract/proc/calculate_curse_power()
	var/total = 0
	for(var/datum/contractor_curse/curse as anything in curses)
		total += curse.get_power_value(src)
	curse_power = total
	return total

/datum/contractor_contract/proc/is_active()
	return applied && status == CONTRACTOR_CONTRACT_ACTIVE

/datum/contractor_contract/proc/can_finalize()
	if(applied)
		return FALSE
	if(status == CONTRACTOR_CONTRACT_BROKEN || status == CONTRACTOR_CONTRACT_FULFILLED || status == CONTRACTOR_CONTRACT_CANCELLED)
		return FALSE
	if(!contractor?.owner || !contractee?.owner)
		return FALSE
	if(!length(bonuses))
		return FALSE
	bonus_power = calculate_bonus_power()
	curse_power = calculate_curse_power()
	if(curse_power > bonus_power)
		return FALSE
	if(!gift_contract && contractor.lux_power < CONTRACTOR_CONTRACT_SEAL_LUX_COST)
		return FALSE
	return TRUE


/datum/contractor_contract/proc/has_effect_clause()
	for(var/datum/contractor_curse/curse as anything in curses)
		if(istype(curse, /datum/contractor_curse/effect))
			return TRUE
	return FALSE

/datum/contractor_contract/proc/has_unlinked_arousal_clause()
	var/has_arousal = FALSE
	for(var/datum/contractor_curse/curse as anything in curses)
		if(istype(curse, /datum/contractor_curse/arousal))
			has_arousal = TRUE
	return has_arousal && !has_effect_clause()

/datum/contractor_contract/proc/finalize()
	return activate()

/datum/contractor_contract/proc/activate()
	if(!can_finalize())
		if(contractor?.owner)
			if(!length(bonuses))
				to_chat(contractor.owner, span_warning("The contract has no boon."))
			else if(curse_power > bonus_power)
				to_chat(contractor.owner, span_warning("The price exceeds the boon budget by [curse_power - bonus_power] power."))
			else if(contractor.lux_power < CONTRACTOR_CONTRACT_SEAL_LUX_COST && !gift_contract)
				to_chat(contractor.owner, span_warning("You need [CONTRACTOR_CONTRACT_SEAL_LUX_COST] Lux power to seal this contract. Current Lux power: [contractor.lux_power]."))
		return FALSE
	if(!gift_contract)
		contractor.lux_power = max(0, contractor.lux_power - CONTRACTOR_CONTRACT_SEAL_LUX_COST)
		var/leftover_power = max(0, bonus_power - curse_power)
		var/lux_rebate = round(leftover_power / CONTRACTOR_CONTRACT_LEFTOVER_TO_LUX_RATIO)
		if(lux_rebate > 0)
			contractor.lux_power += lux_rebate
			to_chat(contractor.owner, span_notice("You leave [leftover_power] price power unwritten and distill it into [lux_rebate] Lux."))
		contractor.adjust_devotion(CONTRACTOR_CONTRACT_DEVOTION_GAIN, TRUE)
	applied = TRUE
	status = CONTRACTOR_CONTRACT_ACTIVE
	activated_time = world.time
	pending_fulfillment = FALSE
	if(!apply_curses())
		rollback_failed_finalize()
		return FALSE
	if(!apply_bonuses())
		rollback_failed_finalize()
		return FALSE
	if(!pending_fulfillment)
		fulfill("instant")
	return TRUE

/datum/contractor_contract/proc/rollback_failed_finalize()
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		bonus.remove(src)
	for(var/datum/contractor_curse/curse as anything in curses)
		curse.remove(src)
	applied = FALSE
	status = CONTRACTOR_CONTRACT_PENDING_CONTRACTEE
	return TRUE

/datum/contractor_contract/proc/apply_bonuses()
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		if(!bonus.can_apply(src))
			return FALSE
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		if(!bonus.fulfills_contract_immediately)
			pending_fulfillment = TRUE
		if(!bonus.apply(src))
			return FALSE
	return TRUE

/datum/contractor_contract/proc/apply_curses()
	for(var/datum/contractor_curse/curse as anything in curses)
		if(!curse.can_apply(src))
			return FALSE
	for(var/datum/contractor_curse/curse as anything in curses)
		if(!curse.apply(src))
			return FALSE
	return TRUE

/datum/contractor_contract/proc/fulfill(reason)
	if(status == CONTRACTOR_CONTRACT_BROKEN || status == CONTRACTOR_CONTRACT_CANCELLED)
		return FALSE

	if(reward_recorded)
		return TRUE

	reward_recorded = TRUE
	fulfilled_time = world.time

	
	
	
	
	for(var/datum/contractor_curse/curse as anything in curses)
		curse.fire_contract_fulfillment(src, reason)

	if(!gift_contract)
		contractee?.adjust_submission(max(1, round(curse_power * 0.1)))
		contractor?.on_contract_fulfilled(src)
	else
		contractor?.fill_devotion(TRUE)

	if(has_ongoing_clauses())
		status = CONTRACTOR_CONTRACT_ACTIVE
		return TRUE

	status = CONTRACTOR_CONTRACT_FULFILLED
	qdel(src)
	return TRUE

/datum/contractor_contract/proc/has_ongoing_clauses()
	for(var/datum/contractor_curse/conditional/curse as anything in curses)
		
		if(curse.trigger_key == "fulfillment")
			continue
		return TRUE
	return FALSE

/datum/contractor_contract/proc/break_contract(reason)
	if(status == CONTRACTOR_CONTRACT_BROKEN)
		return FALSE
	status = CONTRACTOR_CONTRACT_BROKEN
	broken_time = world.time
	for(var/datum/contractor_bonus/bonus as anything in bonuses)
		bonus.on_contract_broken(src, reason)
	for(var/datum/contractor_curse/curse as anything in curses)
		curse.on_contract_broken(src, reason)
	if(contractee?.owner)
		to_chat(contractee.owner, span_userdanger("An infernal contract tears apart within you."))
	qdel(src)
	return TRUE

/datum/contractor_contract/proc/cancel_contract(reason)
	status = CONTRACTOR_CONTRACT_CANCELLED
	cancelled_time = world.time
	if(contractee?.owner && reason)
		to_chat(contractee.owner, span_notice(reason))
	qdel(src)
	return TRUE
