/datum/coven_power/potence/activate(atom/target)
	. = ..()
	if(level >= 4)
		ADD_TRAIT(owner, TRAIT_ARMOR_NOSPDCAP, TRAIT_VAMPIRE)

/datum/coven_power/potence/deactivate(atom/target, direct)
	. = ..()
	if(level >= 4)
		REMOVE_TRAIT(owner, TRAIT_ARMOR_NOSPDCAP, TRAIT_VAMPIRE)

	do_deactivation_notification()

/datum/coven_power/celerity/activate(atom/target)
	. = ..()
	if(. && (level < 4))
		qdel(owner.GetComponent(/datum/component/after_image))

/datum/coven_power/potence/one
	vitae_cost = 35

/datum/coven_power/potence/two
	vitae_cost = 40

/datum/coven_power/potence/three
	vitae_cost = 45

/datum/coven_power/potence/four
	vitae_cost = 50

/datum/coven_power/potence/five
	vitae_cost = 55
/datum/coven_power/celerity/one
	vitae_cost = 15

/datum/coven_power/celerity/two
	vitae_cost = 25

/datum/coven_power/celerity/three
	vitae_cost = 35

/datum/coven_power/celerity/four
	vitae_cost = 45

/datum/coven_power/celerity/five
	vitae_cost = 55

/datum/coven_power/presence/summon/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/buff/auspex))
		if(alert)
			to_chat(owner, span_warning("My senses are stretched too thin through the veil of Auspex to focus [src] - it must be dormant first."))
		return FALSE

