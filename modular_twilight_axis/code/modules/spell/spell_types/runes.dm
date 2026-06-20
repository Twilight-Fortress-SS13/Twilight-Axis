/obj/effect/proc_holder/spell/invoked/stasis
	name = "Stasis"
	desc = "Dangerous rune spell copied from forbiden Naledi schools. It will leave your or yours victim's mark on the floor, then teleport after a short time"
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/inq.dmi'
	action_icon = 'modular_twilight_axis/icons/mob/actions/inq.dmi'
	overlay_state = "stasis"
	action_icon_state = "stasis"
	releasedrain = 25
	chargedrain = 5
	chargetime = 10
	cost = 15
	charging_slowdown = 3
	recharge_time = 1.5 MINUTES
	associated_skill = /datum/skill/magic
	hide_charge_effect = TRUE
	ignore_los = FALSE
	sound = 'sound/magic/timeforward.ogg'
	chargedloop = /datum/looping_sound/invokegen
	var/brute = 0
	var/burn = 0
	var/oxy = 0
	var/toxin = 0
	var/turf/origin
	var/firestacks = 0
	var/divinefirestacks = 0
	var/sunderfirestacks = 0
	var/blood = 0
	
/obj/effect/proc_holder/spell/invoked/stasis/cast(list/targets, mob/user = usr)
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/target = targets[1]
	brute = target.getBruteLoss()
	burn = target.getFireLoss()
	oxy = target.getOxyLoss()
	toxin = target.getToxLoss()
	origin = get_turf(target)
	blood = target.blood_volume
	var/datum/status_effect/fire_handler/fire_stacks/fire_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	firestacks = fire_status?.stacks
	var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	sunderfirestacks = sunder_status?.stacks
	var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = target.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	divinefirestacks = divine_status?.stacks
	to_chat(target, span_warning("I feel a part of me was left behind..."))
	play_indicator(target,'modular_twilight_axis/icons/mob/overhead_effects.dmi', "timestop_rune", 30 SECONDS, OBJ_LAYER)
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 30 SECONDS)

	return TRUE

/obj/effect/proc_holder/spell/invoked/stasis/proc/remove_buff(mob/living/carbon/target)
	do_teleport(target, origin, no_effects=TRUE)
	var/brutenew = target.getBruteLoss()
	var/burnnew = target.getFireLoss()
	var/oxynew = target.getOxyLoss()
	var/toxinnew = target.getToxLoss()
	target.adjust_fire_stacks(firestacks)
	target.adjust_fire_stacks(sunderfirestacks, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.adjust_fire_stacks(divinefirestacks, /datum/status_effect/fire_handler/fire_stacks/divine)
	if(brutenew>brute)
		target.adjustBruteLoss(brutenew*-1 + brute)
	if(burnnew>burn)
		target.adjustFireLoss(burnnew*-1 + burn)
	if(oxynew>oxy)
		target.adjustOxyLoss(oxynew*-1 + oxy)
	if(toxinnew>toxin)
		target.adjustToxLoss(target.getToxLoss()*-1 + toxin)
	if(target.blood_volume<blood)
		target.blood_volume = blood
	playsound(target.loc, 'sound/magic/timereverse.ogg', 100, FALSE)

/obj/effect/proc_holder/spell/invoked/stasis/proc/play_indicator(mob/living/carbon/target, icon_path, overlay_name, clear_time, overlay_layer)
	if(!ishuman(target))
		return
	if(target.stat != DEAD)
		var/mob/living/carbon/humie = target
		var/datum/species/species =	humie.dna.species
		var/list/offset_list
		if(humie.gender == FEMALE)
			offset_list = species.offset_features[OFFSET_HEAD_F]
		else
			offset_list = species.offset_features[OFFSET_HEAD]
			var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
			if(offset_list)
				appearance.pixel_x += (offset_list[1])
				appearance.pixel_y += (offset_list[2]+12)
			appearance.appearance_flags = RESET_COLOR
			target.overlays_standing[OBJ_LAYER] = appearance
			target.apply_overlay(OBJ_LAYER)
			update_icon()
			addtimer(CALLBACK(humie, PROC_REF(clear_overhead_indicator), appearance, target), clear_time)

/obj/effect/proc_holder/spell/invoked/stasis/proc/clear_overhead_indicator(appearance,mob/living/carbon/target)
	target.remove_overlay(OBJ_LAYER)
	cut_overlay(appearance, TRUE)
	qdel(appearance)
	update_icon()
	return

/datum/action/cooldown/spell/repulse/runed
	name = "Runed Repulse"
	desc = "Trigger a ryne on your chest, repelling anyone around you.\
	Deal massive damage to anyone below you on the ground for the Psydon."
	button_icon = 'modular_twilight_axis/icons/mob/actions/inq.dmi'
	button_icon_state = "repulse"
	invocations = list("Éloigne-toi!", "Pas Maintenant!")

/obj/effect/proc_holder/spell/self/invisibility/runed
	name = "Runed Cloak"
	desc = "Make yourself completly invisible to chase your prey in her nightmares."
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "stalk"
	action_icon_state = "stalk"
	recharge_time = 30 SECONDS
	
/obj/effect/proc_holder/spell/self/invisibility/cast(list/targets, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.anti_magic_check(TRUE, TRUE))
			return FALSE
		H.visible_message(span_warning("[H] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur = 20
		H.apply_status_effect(/datum/status_effect/buff/psy_inv)
		animate(H, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		H.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[H] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/psy_inv
	alert_type = /atom/movable/screen/alert/status_effect/buff/psy_inv
	id = "triumph"

/atom/movable/screen/alert/status_effect/buff/psy_inv
	name = "Invisible"
	desc = "Psydon covers me"
	icon_state = "triumph"

/datum/status_effect/buff/psy_inv/on_apply()
	duration = 20 SECONDS
	ADD_TRAIT(owner, TRAIT_VOLF, "redlens")
	effectedstats = list(STATKEY_SPD = 5)
	. = ..()

/datum/status_effect/buff/psy_inv/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_VOLF, "redlens")
	owner.visible_message(span_warning("[owner] wavers, their energies simmering down."))
	owner.OffBalance(5 SECONDS)

/atom/movable/screen/fullscreen/volf
	icon_state = "curse1"
	layer = BLIND_LAYER

/datum/client_colour/volf
	colour = list(rgb(74, 114, 162), rgb(169, 116, 204), rgb(16, 16, 16), rgb(0,0,0))
	priority = 1

/atom/movable/screen/alert/status_effect/debuff/blindness/psy
	name = "Blindness"
	desc = "I see naught but darkness!"

/datum/status_effect/debuff/blindness/psy
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blindness/psy
	duration = 15 SECONDS

/datum/status_effect/debuff/blindness/on_creation(mob/living/new_owner, assocskill)
	. = ..()

/datum/status_effect/debuff/blindness/psy/on_apply()
	. = ..()

/datum/status_effect/debuff/blindness/psy/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))
