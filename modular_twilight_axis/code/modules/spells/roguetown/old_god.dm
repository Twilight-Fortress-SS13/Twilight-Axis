/datum/action/cooldown/spell/psydon/lux/weep/oblate
	desc = "Bear another's lesser wounds and blood loss through your own \
		flesh. Requires a stationary 3-second channel; channeling leaves \
		you exposed and is interrupted by attacks."
	charge_swingdelay_type = SWINGDELAY_CANCEL

/datum/action/cooldown/spell/psydon/lux/vicariate
	name = "VICARIATE"
	button_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	button_icon_state = "VICARIATE"
	desc = "A lesser form of ABSOLUTION. Bear another's wounds, sickness, \
		and lost limbs through your own flesh. The dead are beyond its reach. \
		Requires a stationary 5-second channel; channeling leaves you exposed \
		and is interrupted by attacks."
	sound = 'modular_twilight_axis/sound/magic/psyvicariate.ogg'
	cast_range = 1
	primary_resource_cost = 100
	secondary_resource_cost = 25
	charge_time = 5 SECONDS
	charge_swingdelay_type = SWINGDELAY_CANCEL
	invocation_type = INVOCATION_NONE

/datum/action/cooldown/spell/psydon/lux/vicariate/is_valid_target(atom/cast_on)
	if(!..())
		return FALSE
	if(!ishuman(cast_on) || !ishuman(owner))
		to_chat(owner, span_warning(
			"VICARIATE is for those who walk in HIS image!"))
		return FALSE
	var/mob/living/carbon/human/target = cast_on
	if(target.stat >= DEAD)
		to_chat(owner, span_warning(
			"The still and silent cannot be borne through VICARIATE."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_NOHEAL))
		to_chat(owner, span_warning("Their Lux repels mine."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/psydon/lux/vicariate/before_cast(atom/cast_on)
	if(!is_valid_target(cast_on))
		return SPELL_CANCEL_CAST
	if(get_dist(owner, cast_on) > cast_range)
		return ..()

	var/mob/living/carbon/human/target = cast_on
	var/mob/living/carbon/human/caster = owner
	var/list/warnings = list()
	if(target.getOxyLoss() >= 150)
		warnings += "THEIR BREATH IS NEARLY GONE. THIS BURDEN MAY SLAY YOU."

	var/list/limb_zones = list(
		BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG,
	)
	for(var/zone in limb_zones)
		if(!target.get_bodypart(zone) && caster.get_bodypart(zone))
			warnings += "YOU WILL SACRIFICE YOUR OWN LIMBS TO RESTORE THEIRS."
			break

	if(length(warnings))
		warnings += "Continue?"
		var/answer = alert(caster, warnings.Join("\n\n"),
			"VICARIATE WARNING", "YES", "NO")
		if(answer != "YES")
			return SPELL_CANCEL_CAST

	return ..()

/datum/action/cooldown/spell/psydon/lux/vicariate/cast(atom/cast_on)
	. = ..()
	if(!is_valid_target(cast_on))
		return FALSE

	var/mob/living/carbon/human/target = cast_on
	var/mob/living/carbon/human/caster = owner
	if(caster.cmode)
		caster.say(pick(
			"LET IT BE MINE...",
			"I'LL BLEED IN YOUR STEAD!",
			"I SHALL WEEP IN YOUR STEAD!",
			"PERSIST, AS HE DOES!",
		))
		if(HAS_TRAIT(caster, TRAIT_IRONMAN))
			caster.electrocute_act(10, caster)
	else
		caster.say(pick(
			"Let it be mine...",
			"May your injuries be mine to bear!",
			"I bear your wounds as my own.",
		))
		if(HAS_TRAIT(caster, TRAIT_IRONMAN))
			caster.adjustFireLoss(25)

	var/list/limb_zones = list(
		BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG,
	)
	for(var/zone in limb_zones)
		if(target.get_bodypart(zone))
			continue
		target.regenerate_limb(zone)
		var/obj/item/bodypart/caster_part = caster.get_bodypart(zone)
		if(!caster_part)
			continue
		caster_part.dismember()
		if(HAS_TRAIT(target, TRAIT_IRONMAN))
			var/obj/item/bodypart/target_chest = target.get_bodypart(
				BODY_ZONE_CHEST)
			target_chest.add_wound(/datum/wound/integrity/chest)
		else
			qdel(caster_part)

	for(var/datum/wound/target_wound in target.get_wounds())
		if(!target_wound.bodypart_owner)
			continue
		var/zone = target_wound.bodypart_owner.body_zone
		var/obj/item/bodypart/caster_part = caster.get_bodypart(zone)
		if(!caster_part)
			continue
		var/wound_type = translate_wound_for_target(target_wound, caster)
		if(!wound_type)
			continue

		var/datum/wound/transferred_wound = new wound_type()
		target_wound.copy_to(transferred_wound)
		if(target_wound.is_clotted() || target_wound.is_sewn())
			transferred_wound.set_bleed_rate(0)
		transferred_wound = caster_part.add_wound(transferred_wound)
		if(!transferred_wound)
			caster_part.receive_damage(target_wound.whp)

		var/obj/item/bodypart/target_part = target.get_bodypart(zone)
		if(target_part)
			target_part.remove_wound(target_wound.type)

	var/brute_transfer = target.getBruteLoss()
	var/burn_transfer = target.getFireLoss()
	var/tox_transfer = target.getToxLoss()
	var/oxy_transfer = target.getOxyLoss()
	var/clone_transfer = target.getCloneLoss()

	target.adjustBruteLoss(-brute_transfer)
	target.adjustFireLoss(-burn_transfer)
	target.adjustToxLoss(-tox_transfer)
	target.adjustOxyLoss(-oxy_transfer)
	target.adjustCloneLoss(-clone_transfer)

	caster.adjustBruteLoss(brute_transfer)
	caster.adjustFireLoss(burn_transfer)
	caster.adjustToxLoss(tox_transfer)
	caster.adjustOxyLoss(oxy_transfer)
	caster.adjustCloneLoss(clone_transfer)

	var/blood_needed = max(0, BLOOD_VOLUME_NORMAL - target.blood_volume)
	if(blood_needed)
		if(NOBLOOD in caster.dna?.species?.species_traits)
			target.blood_volume = BLOOD_VOLUME_NORMAL
			caster.adjustFireLoss(round(blood_needed / 4))
		else
			var/transferred = min(blood_needed, caster.blood_volume)
			if(transferred > 0)
				target.blood_volume += transferred
				caster.blood_volume -= transferred
			if(target.blood_volume < BLOOD_VOLUME_NORMAL)
				var/remaining = BLOOD_VOLUME_NORMAL - target.blood_volume
				target.blood_volume += remaining
				caster.blood_volume -= remaining
			if(caster.blood_volume <= 0)
				caster.blood_volume = BLOOD_VOLUME_SURVIVE

	caster.visible_message(span_danger(
		"[caster] assumes [target]'s suffering through VICARIATE!"))
	for(var/iteration in 1 to 3)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(target), "#5e1d1d")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(caster), "#5e1d1d")
	to_chat(caster, span_warning(
		"You take [target]'s suffering into your own flesh."))
	to_chat(target, span_notice("[caster] bears your wounds as their own."))
	return TRUE
