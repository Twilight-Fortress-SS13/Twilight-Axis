/datum/component/contractee
	var/mob/living/carbon/human/owner
	var/list/contracts = list()
	var/list/submission_by_contractor = list()
	var/submission_threshold = CONTRACTOR_SUBMISSION_THRESHOLD
	var/list/lux_drink_counts = list()
	var/list/last_lux_drink_times = list()

/datum/component/contractee/Initialize(datum/component/contractor/_contractor)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	submission_threshold = CONTRACTOR_SUBMISSION_THRESHOLD

/datum/component/contractee/Destroy(force, silent)
	contracts.Cut()
	submission_by_contractor.Cut()
	lux_drink_counts.Cut()
	last_lux_drink_times.Cut()
	owner = null
	return ..()

/datum/component/contractee/proc/get_contractor_key(datum/component/contractor/contractor)
	if(!contractor)
		return null
	return "\\ref[contractor]"

/datum/component/contractee/proc/get_submission(datum/component/contractor/contractor)
	var/key = get_contractor_key(contractor)
	if(!key)
		return 0
	return submission_by_contractor[key] || 0

/datum/component/contractee/proc/adjust_submission(amount, datum/component/contractor/contractor)
	if(!amount)
		return FALSE
	var/key = get_contractor_key(contractor)
	if(!key)
		return FALSE
	submission_by_contractor[key] = clamp(get_submission(contractor) + amount, 0, submission_threshold)
	if(is_submitted(contractor))
		to_chat(owner, span_userdanger("Something inside you yields to an infernal claim."))
	return TRUE

/datum/component/contractee/proc/is_submitted(datum/component/contractor/contractor)
	return get_submission(contractor) >= submission_threshold

/datum/component/contractee/proc/requires_drink_consent(datum/component/contractor/contractor)
	return !is_submitted(contractor)

/datum/component/contractee/proc/get_lux_drink_count(datum/component/contractor/contractor)
	var/key = get_contractor_key(contractor)
	if(!key)
		return 0
	return lux_drink_counts[key] || 0

/datum/component/contractee/proc/on_lux_drunk(amount, datum/component/contractor/contractor, add_submission = TRUE)
	var/key = get_contractor_key(contractor)
	if(!key)
		return FALSE
	lux_drink_counts[key] = get_lux_drink_count(contractor) + 1
	last_lux_drink_times[key] = world.time
	if(add_submission)
		adjust_submission(max(1, round(amount * 0.25)), contractor)
	return TRUE

/datum/component/contractee/proc/get_lux_diminishing_multiplier(datum/component/contractor/contractor)
	return max(CONTRACTOR_DRINK_DIMINISH_FLOOR, 1 - (get_lux_drink_count(contractor) * CONTRACTOR_DRINK_DIMINISH_STEP))
