/datum/component/contractee
	var/mob/living/carbon/human/owner
	var/datum/component/contractor/contractor
	var/list/contracts = list()
	var/submission = 0
	var/submission_threshold = CONTRACTOR_SUBMISSION_THRESHOLD
	var/lux_drink_count = 0
	var/last_lux_drink_time = 0

/datum/component/contractee/Initialize(datum/component/contractor/_contractor)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	contractor = _contractor
	submission_threshold = CONTRACTOR_SUBMISSION_THRESHOLD

/datum/component/contractee/Destroy(force, silent)
	contractor = null
	contracts.Cut()
	owner = null
	return ..()

/datum/component/contractee/proc/adjust_submission(amount)
	if(!amount)
		return FALSE
	submission = clamp(submission + amount, 0, submission_threshold)
	if(is_submitted())
		to_chat(owner, span_userdanger("Something inside you yields to an infernal claim."))
	return TRUE

/datum/component/contractee/proc/is_submitted()
	return submission >= submission_threshold

/datum/component/contractee/proc/requires_drink_consent()
	return !is_submitted()

/datum/component/contractee/proc/on_lux_drunk(amount, add_submission = TRUE)
	lux_drink_count++
	last_lux_drink_time = world.time
	if(add_submission)
		adjust_submission(max(1, round(amount * 0.25)))
	return TRUE

/datum/component/contractee/proc/get_lux_diminishing_multiplier()
	return max(CONTRACTOR_DRINK_DIMINISH_FLOOR, 1 - (lux_drink_count * CONTRACTOR_DRINK_DIMINISH_STEP))
