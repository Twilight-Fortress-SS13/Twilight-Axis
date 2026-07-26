/*
 * Azure Peak vampire discipline balance port.
 *
 * Kept in one late-included TA override so the whole Potence/Celerity
 * balance block can be reverted without touching upstream files.
 */

#define TA_POTENCE_TRAIT_SOURCE "ta_potence"

/atom/movable/screen/alert/status_effect/buff/celerity
	name = "Celerity"
	desc = "My body is under perfect control."
	icon_state = "buff"

/datum/status_effect/buff/celerity
	alert_type = /atom/movable/screen/alert/status_effect/buff/celerity

/datum/coven_power/potence
	var/ta_punch_damage_bonus = 0

/datum/coven_power/potence/one
	ta_punch_damage_bonus = 4

/datum/coven_power/potence/two
	ta_punch_damage_bonus = 8

/datum/coven_power/potence/three
	ta_punch_damage_bonus = 12

/datum/coven_power/potence/four
	ta_punch_damage_bonus = 16

/datum/coven_power/potence/five
	ta_punch_damage_bonus = 22

/datum/coven_power/potence/activate(atom/target)
	. = ..()
	owner.dna.species.punch_damage += ta_punch_damage_bonus

	if(level == 3)
		ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TA_POTENCE_TRAIT_SOURCE)
	if(level >= 4)
		ADD_TRAIT(owner, TRAIT_ARMOR_NOSPDCAP, TA_POTENCE_TRAIT_SOURCE)

/datum/coven_power/potence/deactivate(atom/target, direct)
	. = ..()
	owner.dna.species.punch_damage -= ta_punch_damage_bonus

	if(level == 3)
		REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TA_POTENCE_TRAIT_SOURCE)
	if(level >= 4)
		REMOVE_TRAIT(owner, TRAIT_ARMOR_NOSPDCAP, TA_POTENCE_TRAIT_SOURCE)

/datum/coven_power/potence/proc/ta_cancel_upstream_punch_damage_bonus()
	owner.dna.species.punch_damage -= level * 2

/datum/coven_power/potence/proc/ta_restore_upstream_punch_damage_bonus()
	owner.dna.species.punch_damage += level * 2

/datum/coven_power/potence/one/activate()
	. = ..()
	ta_cancel_upstream_punch_damage_bonus()

/datum/coven_power/potence/one/deactivate()
	. = ..()
	ta_restore_upstream_punch_damage_bonus()

/datum/coven_power/potence/two/activate()
	. = ..()
	ta_cancel_upstream_punch_damage_bonus()

/datum/coven_power/potence/two/deactivate()
	. = ..()
	ta_restore_upstream_punch_damage_bonus()

/datum/coven_power/potence/three/activate()
	. = ..()
	ta_cancel_upstream_punch_damage_bonus()

/datum/coven_power/potence/three/deactivate()
	. = ..()
	ta_restore_upstream_punch_damage_bonus()

/datum/coven_power/potence/four/activate()
	. = ..()
	ta_cancel_upstream_punch_damage_bonus()

/datum/coven_power/potence/four/deactivate()
	. = ..()
	ta_restore_upstream_punch_damage_bonus()

/datum/coven_power/potence/five/activate()
	. = ..()
	ta_cancel_upstream_punch_damage_bonus()

/datum/coven_power/potence/five/deactivate()
	. = ..()
	ta_restore_upstream_punch_damage_bonus()

// Celerity is otherwise left to upstream; only stop its after-image "speed
// aura" from being applied below tier 4. Upstream's deactivate clears the
// component when it exists, so no deactivate override is needed.
/datum/coven_power/celerity/activate(atom/target)
	. = ..()
	if(. && (level < 4))
		qdel(owner.GetComponent(/datum/component/after_image))

#undef TA_POTENCE_TRAIT_SOURCE
