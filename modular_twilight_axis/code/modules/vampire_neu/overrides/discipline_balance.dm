/*
 * Azure Peak vampire discipline balance port.
 *
 * Kept in one late-included TA override so the whole Potence/Celerity
 * balance block can be reverted without touching upstream files.
 */

#define TA_POTENCE_TRAIT_SOURCE "ta_potence"
#define TA_CELERITY_TRAIT_SOURCE "ta_celerity"

/atom/movable/screen/alert/status_effect/buff/celerity
	name = "Celerity"
	desc = "My body is under perfect control."
	icon_state = "buff"

/datum/status_effect/buff/celerity
	alert_type = /atom/movable/screen/alert/status_effect/buff/celerity

/atom/movable/screen/alert/status_effect/buff/ta_potence
	name = "Potence"
	desc = "I am a force of destruction."
	icon_state = "buff"

/datum/status_effect/buff/ta_potence
	id = "ta_potence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ta_potence
	effectedstats = list(STATKEY_STR = 1)
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/ta_potence/New(list/arguments)
	if(length(arguments) >= 2)
		effectedstats[STATKEY_STR] = arguments[2]
	return ..()

/datum/coven_power/potence
	var/ta_punch_damage_bonus = 0

/datum/coven_power/potence/one
	ta_punch_damage_bonus = 5

/datum/coven_power/potence/two
	ta_punch_damage_bonus = 10

/datum/coven_power/potence/three
	ta_punch_damage_bonus = 15

/datum/coven_power/potence/four
	ta_punch_damage_bonus = 25

/datum/coven_power/potence/five
	ta_punch_damage_bonus = 30

/datum/coven_power/potence/activate(atom/target)
	. = ..()
	owner.apply_status_effect(/datum/status_effect/buff/ta_potence, level)
	owner.dna.species.punch_damage += ta_punch_damage_bonus

	// Upstream still reads this field in weapon attacks. Real STR replaces it.
	owner.potence_weapon_buff = 0

	if(level >= 3)
		owner.visible_message(span_warning("[owner] tenses their muscles, looking exceptionally strong!"))
	if(level >= 4)
		ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TA_POTENCE_TRAIT_SOURCE)
		ADD_TRAIT(owner, TRAIT_ZJUMP, TA_POTENCE_TRAIT_SOURCE)
		ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TA_POTENCE_TRAIT_SOURCE)

/datum/coven_power/potence/deactivate(atom/target, direct)
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/ta_potence)
	owner.dna.species.punch_damage -= ta_punch_damage_bonus
	owner.potence_weapon_buff = 0

	if(level >= 3)
		owner.visible_message(span_warning("[owner] relaxes their body."))
	if(level >= 4)
		REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TA_POTENCE_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_ZJUMP, TA_POTENCE_TRAIT_SOURCE)
		REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TA_POTENCE_TRAIT_SOURCE)

	do_deactivation_notification()

// Replace the upstream level-specific punch and virtual-STR adjustments.
/datum/coven_power/potence/one/activate()
	return ..()

/datum/coven_power/potence/one/deactivate()
	return ..()

/datum/coven_power/potence/two/activate()
	return ..()

/datum/coven_power/potence/two/deactivate()
	return ..()

/datum/coven_power/potence/three/activate()
	return ..()

/datum/coven_power/potence/three/deactivate()
	return ..()

/datum/coven_power/potence/four/activate()
	return ..()

/datum/coven_power/potence/four/deactivate()
	return ..()

/datum/coven_power/potence/five/activate()
	return ..()

/datum/coven_power/potence/five/deactivate()
	return ..()

/datum/coven_power/celerity/activate(atom/target)
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = multiplicative_slowdown)
	owner.apply_status_effect(/datum/status_effect/buff/celerity, level)

	if(level >= 4)
		owner.AddComponent(/datum/component/after_image)
		playsound(owner, 'sound/magic/timeforward.ogg', 40, TRUE)
		owner.visible_message(span_warning("[owner] движется с нечеловеческой скоростью, и каждое движение сливается в размытый след!"))
	if(level >= 4)
		ADD_TRAIT(owner, TRAIT_LEAPER, TA_CELERITY_TRAIT_SOURCE)
	if(level >= 5)
		ADD_TRAIT(owner, TRAIT_DODGEEXPERT, TA_CELERITY_TRAIT_SOURCE)

/datum/coven_power/celerity/deactivate(atom/target, direct)
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/celerity)
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)

	if(level >= 4)
		qdel(owner.GetComponent(/datum/component/after_image))
		playsound(owner, 'sound/magic/timestop.ogg', 40, TRUE)
	if(level >= 4)
		REMOVE_TRAIT(owner, TRAIT_LEAPER, TA_CELERITY_TRAIT_SOURCE)
	if(level >= 5)
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TA_CELERITY_TRAIT_SOURCE)

#undef TA_POTENCE_TRAIT_SOURCE
#undef TA_CELERITY_TRAIT_SOURCE
