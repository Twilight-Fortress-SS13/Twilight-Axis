/obj/effect/contractor_seal
	name = "contractor seal"
	desc = "A ritual seal meant to suppress a contractor standing upon it."
	anchored = TRUE
	density = FALSE
	var/seal_power = CONTRACTOR_SEAL_BASE_POWER
	var/max_seal_power = CONTRACTOR_SEAL_BASE_POWER
	var/arcana_power = 0
	var/radius = 0
	var/active = TRUE
	var/fresh = TRUE

/obj/effect/contractor_seal/Initialize(mapload)
	. = ..()
	if(!arcana_power)
		var/mob/living/carbon/human/H
		for(H in range(1, src))
			break
		if(H)
			arcana_power = contractor_get_arcana_power(H)
	max_seal_power = CONTRACTOR_SEAL_BASE_POWER + (CONTRACTOR_SEAL_ARCANA_POWER * arcana_power)
	seal_power = max_seal_power

/obj/effect/contractor_seal/examine(mob/user)
	. = ..()
	. += span_notice("Seal power: [round(seal_power)]/[max_seal_power].")
	. += span_notice("Arcana binding: [arcana_power].")

/obj/effect/contractor_seal/Crossed(atom/movable/AM, oldloc)
	. = ..()
	bind_contractor(AM)

/obj/effect/contractor_seal/proc/bind_contractor(atom/movable/AM)
	if(!active || !fresh || !ishuman(AM))
		return FALSE
	var/mob/living/carbon/human/H = AM
	var/datum/component/contractor/S = H.GetComponent(/datum/component/contractor)
	if(!S)
		return FALSE
	S.set_true_form(TRUE, TRUE)
	var/mob/living/carbon/human/bound_body = H
	if(S.true_form_body && !QDELETED(S.true_form_body))
		bound_body = S.true_form_body
	else if(S.owner && ishuman(S.owner))
		bound_body = S.owner
	bound_body.Immobilize(CONTRACTOR_SEAL_DECAY_INTERVAL + 1 SECONDS)
	to_chat(bound_body, span_userdanger("The fresh seal bites into your true nature."))
	return TRUE

/obj/effect/contractor_seal/contains(atom/movable/A)
	if(!active || !A)
		return FALSE
	return get_dist(src, A) <= radius

/obj/effect/contractor_seal/proc/get_seal_power()
	return seal_power

/obj/effect/contractor_seal/proc/damage_seal(amount)
	if(!active || amount <= 0)
		return
	seal_power = max(0, seal_power - amount)
	if(seal_power <= 0)
		break_seal()

/obj/effect/contractor_seal/proc/break_seal()
	if(!active)
		return
	active = FALSE
	fresh = FALSE
	visible_message(span_danger("[src] cracks and burns away."))
	qdel(src)

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal
	name = "contractor binding seal"
	desc = "Arcane script curls into a hungry seal meant to suppress a contractor standing upon it."
	invoker_name = "contractor binding seal"
	invoker_desc = "A binding seal that forces a contractor into true form, suppresses their abilities, and slowly erodes as it holds them."
	invocation = "Vinculum Daemonis!"
	icon_state = "6"
	color = "#8B003C"
	tier = 1
	runesize = 0
	can_be_scribed = TRUE
	var/seal_power = CONTRACTOR_SEAL_BASE_POWER
	var/max_seal_power = CONTRACTOR_SEAL_BASE_POWER
	var/arcana_power = 0
	var/radius = 0
	active = TRUE
	var/fresh = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/Initialize(mapload, set_keyword)
	. = ..()
	if(!arcana_power)
		var/mob/living/carbon/human/H
		for(H in range(1, src))
			break
		if(H)
			arcana_power = contractor_get_arcana_power(H)
	max_seal_power = CONTRACTOR_SEAL_BASE_POWER + (CONTRACTOR_SEAL_ARCANA_POWER * arcana_power)
	seal_power = max_seal_power
	addtimer(CALLBACK(src, PROC_REF(bind_contractors_on_turf)), 1)

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/proc/bind_contractors_on_turf()
	if(QDELETED(src) || !active || !fresh)
		return
	for(var/mob/living/carbon/human/H in loc)
		bind_contractor(H)

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/attack_hand(mob/living/user)
	if(!isarcyne(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return
	to_chat(user, span_notice("The seal hums with a patient binding force."))
	return

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/examine(mob/user)
	. = ..()
	. += span_notice("Seal power: [round(seal_power)]/[max_seal_power].")
	. += span_notice("Arcana binding: [arcana_power].")

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/Crossed(atom/movable/AM, oldloc)
	. = ..()
	bind_contractor(AM)

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/proc/bind_contractor(atom/movable/AM)
	if(!active || !fresh || !ishuman(AM))
		return FALSE
	var/mob/living/carbon/human/H = AM
	var/datum/component/contractor/S = H.GetComponent(/datum/component/contractor)
	if(!S)
		return FALSE
	S.set_true_form(TRUE, TRUE)
	var/mob/living/carbon/human/bound_body = H
	if(S.true_form_body && !QDELETED(S.true_form_body))
		bound_body = S.true_form_body
	else if(S.owner && ishuman(S.owner))
		bound_body = S.owner
	bound_body.Immobilize(CONTRACTOR_SEAL_DECAY_INTERVAL + 1 SECONDS)
	to_chat(bound_body, span_userdanger("The fresh seal bites into your true nature."))
	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/contains(atom/movable/A)
	if(!active || !A)
		return FALSE
	return get_dist(src, A) <= radius

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/proc/get_seal_power()
	return seal_power

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/proc/damage_seal(amount)
	if(!active || amount <= 0)
		return
	seal_power = max(0, seal_power - amount)
	if(seal_power <= 0)
		break_seal()

/obj/effect/decal/cleanable/roguerune/arcyne/contractor_seal/proc/break_seal()
	if(!active)
		return
	active = FALSE
	fresh = FALSE
	visible_message(span_danger("[src] cracks and burns away."))
	qdel(src)
