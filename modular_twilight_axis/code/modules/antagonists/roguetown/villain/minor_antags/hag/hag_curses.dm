/datum/hag_boon/trait/curse/vegan
	name = "Trait - Vegan"
	trait_to_apply = TRAIT_VEGAN
	desc = "The bearer becomes Vegan... What a awful fate!"
	points = 15

/datum/hag_boon/trait/curse/light_sensivity
	name = "Trait - Light Sensivity"
	trait_to_apply = TRAIT_SUNLIGHT_SENSITIVE
	desc = "The bearer eyes becomes really sensitive to light!"
	points = 65

/datum/hag_boon/trait/curse/pacifist
	name = "Trait - Pacifist"
	trait_to_apply = TRAIT_PACIFISM
	desc = "The bearer becomes a real pacifist."
	points = 100

/datum/hag_boon/trait/curse/sleepless
	name = "Trait - Sleepless"
	trait_to_apply = TRAIT_NOSLEEP
	desc = "The bearer will lose the ability to sleep."
	points = 50

/datum/hag_boon/trait/curse/atheism
	name = "Trait - Atheism Curse"
	trait_to_apply = TRAIT_ATHEISM_CURSE
	desc = "The bearer will be never affected by miracles, even positive one. The bearer WILL NOT BECOME ATHEIST."
	points = 50

/datum/hag_boon/curse/awful_voice
	name = "Trait - Awful Voice"
	desc = "The bearer's voice becomes really awful!"
	points = 5

/datum/hag_boon/curse/awful_voice/apply_boon_effect(mob/living/L)
	RegisterSignal(L, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/hag_boon/curse/awful_voice/remove_boon_effect(mob/living/L)
	UnregisterSignal(L, COMSIG_MOB_SAY)

/datum/hag_boon/curse/awful_voice/proc/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/hag_boon/curse/excommunicated
	name = "Excommunication"
	desc = "The bearer will become excommunicated without chance to mend it."
	points = 30

/datum/hag_boon/curse/excommunicated/apply_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	GLOB.excommunicated_players += H
	ADD_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NORECONCILE, TRAIT_GENERIC)
	to_chat(H, span_notice("You have been excommunicated from the Church of the Ten."))
	if(H.patron)
		if(istype(H.patron, /datum/patron/divine))
			H.add_stress(/datum/stressevent/excommunicated)
			H.apply_status_effect(/datum/status_effect/debuff/excomm)
			priority_announce("[H.patron.name] has excommunicated [H.real_name]! SHAME!", title = "EXCOMMUNICATION", sound = 'sound/misc/excomm.ogg')
		else
			priority_announce("Astrata has excommunicated [H.real_name]! SHAME!", title = "EXCOMMUNICATION", sound = 'sound/misc/excomm.ogg')

/datum/hag_boon/curse/excommunicated/remove_boon_effect(mob/living/L)
	var/mob/living/carbon/human/H = L
	GLOB.excommunicated_players -= H
	REMOVE_TRAIT(H, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
	REMOVE_TRAIT(H, TRAIT_NORECONCILE, TRAIT_GENERIC)
	to_chat(H, span_notice("You have been reconciled with the Church of the Ten."))
	if(H.patron)
		if(istype(H.patron, /datum/patron/divine))
			H.remove_stress(/datum/stressevent/excommunicated)
			H.remove_status_effect(/datum/status_effect/debuff/excomm)
			priority_announce("[H.patron.name] has reconciled [H.real_name] with the Church. They are once again part of the flock!", title = "RECONCILIATION", sound = 'sound/misc/bell.ogg')
		else
			priority_announce("Astrata has reconciled [H.real_name] with the Church. They are once again part of the flock!", title = "RECONCILIATION", sound = 'sound/misc/bell.ogg')
