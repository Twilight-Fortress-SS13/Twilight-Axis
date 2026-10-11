/datum/status_effect/buff/contractor_evasion
	id = "contractor_evasion"
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/contractor_evasion

/datum/status_effect/buff/contractor_evasion/on_creation(mob/living/new_owner, new_duration)
	if(isnum(new_duration))
		duration = new_duration
	return ..()

/atom/movable/screen/alert/status_effect/contractor_evasion
	name = "Contractor Evasion"
	desc = "Your next successful dodges will slip you behind attackers."
	icon_state = "buff"

/datum/status_effect/buff/contractor_exchange
	id = "contractor_exchange"
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/contractor_exchange

/datum/status_effect/buff/contractor_exchange/on_creation(mob/living/new_owner, new_duration)
	if(isnum(new_duration))
		duration = new_duration
	return ..()

/atom/movable/screen/alert/status_effect/contractor_exchange
	name = "Contractor Exchange"
	desc = "Your next successful parries will trade places with attackers."
	icon_state = "buff"

/datum/status_effect/buff/contractor_invisibility
	id = "contractor_invisibility"
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/contractor_invisibility

/datum/status_effect/buff/contractor_invisibility/on_creation(mob/living/new_owner, new_duration)
	if(isnum(new_duration))
		duration = new_duration
	return ..()

/atom/movable/screen/alert/status_effect/contractor_invisibility
	name = "Contractor Invisibility"
	desc = "You are hidden by an infernal veil. Attacking breaks it."
	icon_state = "buff"

/datum/status_effect/buff/contractor_incorporeal
	id = "contractor_incorporeal"
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/contractor_incorporeal

/datum/status_effect/buff/contractor_incorporeal/on_creation(mob/living/new_owner, new_duration)
	if(isnum(new_duration))
		duration = new_duration
	return ..()

/atom/movable/screen/alert/status_effect/contractor_incorporeal
	name = "Contractor Incorporeal"
	desc = "Your body is thin enough to pass through matter."
	icon_state = "buff"


/datum/status_effect/buff/contractor_mirror_permission
	id = "contractor_mirror_permission"
	duration = CONTRACTOR_BODY_CHANGE_PERMISSION_TIME
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/contractor_mirror_permission
	var/datum/contractor_contract/source_contract

/datum/status_effect/buff/contractor_mirror_permission/on_creation(mob/living/new_owner, new_duration, datum/contractor_contract/contract)
	if(isnum(new_duration))
		duration = new_duration
	source_contract = contract
	return ..()

/datum/status_effect/buff/contractor_mirror_permission/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_MIRROR_MAGIC, CONTRACTOR_TRAIT_SOURCE)
	return TRUE

/datum/status_effect/buff/contractor_mirror_permission/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_MIRROR_MAGIC, CONTRACTOR_TRAIT_SOURCE)
	if(source_contract && !QDELETED(source_contract) && source_contract.is_active())
		source_contract.fulfill("body_change_complete")
	source_contract = null

/atom/movable/screen/alert/status_effect/contractor_mirror_permission
	name = "Mirror Permission"
	desc = "Infernal contract power lets you reshape yourself through mirrors."
	icon_state = "buff"

/datum/status_effect/debuff/contractor_emotion_pressure
	id = "contractor_emotion_pressure"
	duration = INFINITY
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/contractor_emotion_pressure
	var/emotion_text = "longing"

/datum/status_effect/debuff/contractor_emotion_pressure/on_creation(mob/living/new_owner, new_emotion_text)
	if(new_emotion_text)
		emotion_text = "[new_emotion_text]"
	return ..()

/datum/status_effect/debuff/contractor_emotion_pressure/on_apply()
	. = ..()
	to_chat(owner, span_notice("The contract presses [emotion_text] into your thoughts."))
	return TRUE

/atom/movable/screen/alert/status_effect/contractor_emotion_pressure
	name = "Contract Emotion"
	desc = "An infernal contract is pressing an emotion into your thoughts."
	icon_state = "debuff"
