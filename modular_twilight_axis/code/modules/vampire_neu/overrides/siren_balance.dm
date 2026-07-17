/*
 * Shattering Crescendo effects adapted from Scarlet-Reach/Scarlet-Reach#1616.
 */

/datum/coven_power/siren/shattering_crescendo
	vitae_cost = 250
	cooldown_length = 60 SECONDS

/datum/coven_power/siren/shattering_crescendo/activate()
	. = ..()
	var/list/mobs_in_view = oviewers(7, owner)
	owner.emote("scream", forced = TRUE)

	if(!length(mobs_in_view))
		deactivate()
		return

	for(var/mob/living/carbon/human/listener in mobs_in_view)
		if(listener.clan == owner.clan)
			continue

		listener.Stun(duration_length)
		listener.confused += 10
		listener.jitteriness += 10
		listener.soundbang_act(intensity = 1, stun_pwr = 0, damage_pwr = 5, deafen_pwr = 15)
		listener.apply_damage(50, BRUTE, BODY_ZONE_HEAD)

		listener.remove_overlay(MUTATIONS_LAYER)
		var/mutable_appearance/song_overlay = mutable_appearance('icons/effects/clan.dmi', "song", -MUTATIONS_LAYER)
		listener.overlays_standing[MUTATIONS_LAYER] = song_overlay
		listener.apply_overlay(MUTATIONS_LAYER)

		addtimer(CALLBACK(src, PROC_REF(remove_effects), listener), duration_length)
