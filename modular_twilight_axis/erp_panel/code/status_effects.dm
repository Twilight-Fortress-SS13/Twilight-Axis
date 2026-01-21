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

/datum/status_effect/love_potion
	id = "love_potion"
	duration = 48 MINUTES
	tick_interval = 0 // никаких тиков
	alert_type = /atom/movable/screen/alert/status_effect/love_potion

	var/mob/living/carbon/human/target

/datum/status_effect/love_potion/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(target)
			to_chat(H, span_love("Вы чувствуете непреодолимую тягу к [target]."))
			update_alert()
		else
			to_chat(H, span_love("Ваше сердце странно дрожит..."))

/datum/status_effect/love_potion/on_remove()
	if(ishuman(owner))
		to_chat(owner, span_notice("Чары любви спадают."))
	return ..()

/datum/status_effect/love_potion/proc/set_target(mob/living/carbon/human/new_target)
	target = new_target
	if(ishuman(owner) && target)
		to_chat(owner, span_love("Ваше сердце тянется к [target]."))
		update_alert()

/datum/status_effect/love_potion/proc/update_alert()
	if(!owner || !target)
		return

	var/atom/movable/screen/alert/status_effect/love_potion/A = linked_alert

	if(A)
		A.desc = "Вы чувствуете непреодолимую тягу к [target]."

/atom/movable/screen/alert/status_effect/love_potion
	name = "love sickness"
	desc = "Непреодолимая тяга к тому, кого вы любите."


