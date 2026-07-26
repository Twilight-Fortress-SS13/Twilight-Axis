/*
 * Presence tweaks: shorter Awe / Dread Gaze cooldowns. Everything else is
 * left to upstream so the powers aren't run twice or in two languages.
 */

/datum/coven_power/presence/awe
	cooldown_length = 30 SECONDS

/datum/coven_power/presence/dread_gaze
	cooldown_length = 30 SECONDS

/datum/coven_power/presence/summon/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/buff/auspex))
		if(alert)
			to_chat(owner, span_warning("My senses are stretched too thin through the veil of Auspex to focus [src] - it must be dormant first."))
		return FALSE
