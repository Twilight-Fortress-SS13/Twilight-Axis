/datum/coven_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	target.stop_pulling()

/datum/coven_power/presence/fall/activate(mob/living/carbon/human/target)
	. = ..()

	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = presence_overlay
	target.apply_overlay(MUTATIONS_LAYER)
	target.Knockdown(3)
	target.apply_status_effect(/datum/status_effect/debuff/vulnerable, 2 SECONDS)
	playsound(target,'sound/villain/wonder_secret_known.ogg', 40)
