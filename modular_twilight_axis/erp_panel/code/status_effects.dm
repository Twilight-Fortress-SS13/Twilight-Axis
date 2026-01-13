/datum/status_effect/mouth_full
	id = "mouth_full"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/mouth_full

/atom/movable/screen/alert/status_effect/mouth_full
	name = "Full Mouth"
	desc = "Click to swallow a bit."

/atom/movable/screen/alert/status_effect/mouth_full/Click(location, control, params)
	..()

	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return FALSE

	user.swallow_from_mouth(5)
	return FALSE
