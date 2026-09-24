/obj/effect/proc_holder/spell/invoked/psydonvicariate
	name = "VICARIATE"
	overlay_state = "VICARIATE"
	desc = "A lesser form of the mighty art of ABSOLUTION. You take upon yourself the wounds, sickness, and frailty of another. Use carefully."
	releasedrain = 25
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'modular_twilight_axis/sound/magic/psyvicariate.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS // 60 seconds cooldown
	miracle = TRUE
	devotion_cost = 100
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'

/obj/effect/proc_holder/spell/invoked/psydonvicariate/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("VICARIATE is for those who walk in HIS image!"))
		revert_cast()
		return FALSE

	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	var/mob/living/carbon/human/C = user

	if(H == C)
		to_chat(C, span_warning("You cannot bear your own burden through VICARIATE!"))
		revert_cast()
		return FALSE

	if(H.stat >= DEAD)
		to_chat(C, span_warning("The still and silent cannot be borne through VICARIATE."))
		revert_cast()
		return FALSE

	// CONSEQUENCE WARNING CHECKS
	var/will_die_oxy = FALSE
	var/will_lose_limbs = FALSE

	// Vicariate-exclusive: Oxygen damage warning instead of resurrection warning
	if(H.getOxyLoss() >= 150)
		will_die_oxy = TRUE

	// Limb restoration costs your limbs.
	var/list/warning_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	for(var/zone in warning_zones)
		if(!H.get_bodypart(zone))
			if(C.get_bodypart(zone))
				will_lose_limbs = TRUE
				break

	if(will_die_oxy || will_lose_limbs)

		var/list/messages = list()

		if(will_die_oxy)
			messages += span_userdanger("THEIR BREATH IS NEARLY GONE. THIS BURDEN MAY SLAY YOU.")

		if(will_lose_limbs)
			messages += span_userdanger("THIS TARGET IS MISSING LIMBS. YOU WILL SACRIFICE YOUR OWN LIMBS.")

		messages += ""
		messages += "Continue?"

		if(alert(C, messages.Join("\n"), "VICARIATE WARNING", "YES", "NO") != "YES")
			revert_cast()
			return FALSE

	// INVOCATION AND IRONMAN REACTIONS
	if(C.cmode)
		C.say(pick("LET IT BE MINE...","I'LL BLEED IN YOUR STEAD!","I SHALL WEEP IN YOUR STEAD!","PERSIST, AS HE DOES!"))
		if(HAS_TRAIT(C, TRAIT_IRONMAN))
			C.electrocute_act(10, C)
	else
		C.say(pick("Let it be mine...","May your injuries be mine to bear!","I bear your wounds as my own."))
		if(HAS_TRAIT(C, TRAIT_IRONMAN))
			C.adjustFireLoss(25)

	// LIMB TRANSFER
	var/list/zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	for(var/zone in zones)
		var/obj/item/bodypart/tBP = H.get_bodypart(zone)

		if(!tBP)
			H.regenerate_limb(zone)
			var/obj/item/bodypart/cBP = C.get_bodypart(zone)
			if(cBP)
				cBP.dismember()
				if(HAS_TRAIT(H, TRAIT_IRONMAN)) 
					var/obj/item/bodypart/daChest = H.get_bodypart(BODY_ZONE_CHEST)
					daChest.add_wound(/datum/wound/integrity/chest)
				else
					qdel(cBP)

	// WOUND TRANSFER
	var/list/wounds = H.get_wounds()

	for(var/datum/wound/W in wounds)
		if(!W.bodypart_owner)
			continue

		var/obj/item/bodypart/cBP = C.get_bodypart(W.bodypart_owner.body_zone)
		if(!cBP)
			continue

		var/new_type = translate_wound_for_target(W, C)

		if(!new_type)
			continue

		var/datum/wound/newW = new new_type()

		W.copy_to(newW)

		if(W.is_clotted() || W.is_sewn())
			newW.set_bleed_rate(0)

		newW = cBP.add_wound(newW)

		if(!newW)
			cBP.receive_damage(W.whp)

		var/obj/item/bodypart/tBP = H.get_bodypart(W.bodypart_owner.body_zone)

		if(tBP)
			tBP.remove_wound(W.type)

	// DAMAGE TRANSFER
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()

	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)

	C.adjustBruteLoss(brute_transfer)
	C.adjustFireLoss(burn_transfer)
	C.adjustToxLoss(tox_transfer)
	C.adjustOxyLoss(oxy_transfer)
	C.adjustCloneLoss(clone_transfer)

	// BLOOD TRANSFER
	var/blood_needed = max(0, BLOOD_VOLUME_NORMAL - H.blood_volume)

	if(blood_needed)
		if(NOBLOOD in C.dna?.species?.species_traits)
			H.blood_volume = BLOOD_VOLUME_NORMAL
			C.adjustFireLoss(round(blood_needed / 4))
		else
			var/transferred = min(blood_needed, C.blood_volume)

			if(transferred > 0)
				H.blood_volume += transferred
				C.blood_volume -= transferred

			if(H.blood_volume < BLOOD_VOLUME_NORMAL)
				var/remaining = BLOOD_VOLUME_NORMAL - H.blood_volume

				H.blood_volume += remaining
				C.blood_volume -= remaining

			if(C.blood_volume <= 0)
				C.blood_volume = BLOOD_VOLUME_SURVIVE

	// VISUALS
	C.visible_message(span_danger("[C] assumes [H]'s suffering through VICARIATE!"))

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#5e1d1d") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#5e1d1d") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#5e1d1d") 

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(C), "#5e1d1d") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(C), "#5e1d1d") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(C), "#5e1d1d") 
	
	to_chat(C, span_warning("You take [H]'s suffering into your own flesh."))
	to_chat(H, span_notice("[C] bears your wounds as their own."))
	
	return TRUE
