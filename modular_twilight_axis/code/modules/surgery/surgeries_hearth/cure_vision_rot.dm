// SURGERY: Cure Vision Rot (modeled on Black Rot extirpation)
/datum/surgery/cure_vision_rot
	name = "Vision Rot Extirpation"
	desc = "A dangerous surgical procedure to excise Vision Rot from ocular tissue. Highly damaging to the eyes."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/extract_vision_rot_residue,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_HEAD)

/datum/surgery_step/extract_vision_rot_residue
	name = "Excise vision rot"
	implements = list(
		TOOL_SCALPEL = 85,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 12 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/extract_vision_rot_residue/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return FALSE
	var/has_vision_rot = FALSE
	for(var/thing in target.diseases)
		if(istype(thing, /datum/disease/vision_rot))
			has_vision_rot = TRUE
			break
	return has_vision_rot

/datum/surgery_step/extract_vision_rot_residue/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_userdanger("I carefully attempt to excise the corrupted ocular tissue..."),
		span_userdanger("[user] carefully tries to excise corrupted tissue from [target]'s eyes."),
		span_userdanger("[user] carefully tries to excise corrupted tissue from [target]'s eyes."))
	return TRUE

/datum/surgery_step/extract_vision_rot_residue/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	// find active Vision Rot disease instance
	var/datum/disease/vision_rot/vd = null
	for(var/D in target.diseases)
		if(istype(D, /datum/disease/vision_rot))
			vd = D
			break
	if(!vd)
		display_results(user, target, span_warning("The site burns cleanly. No active Vision Rot infection found."),
			"[user] cauterizes the wound.",
			"[user] cauterizes the wound.")
		return TRUE

	// base damage reduced by surgeon's medicine skill
	var/damage = 50
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	damage -= (medskill * 6)
	damage = max(0, damage)

	// apply generic brute loss and also punish ocular tissue
	target.adjustBruteLoss(damage)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(damage, BRUTE, BODY_ZONE_PRECISE_L_EYE)
		H.apply_damage(damage, BRUTE, BODY_ZONE_PRECISE_R_EYE)
	else
		target.apply_damage(damage, BRUTE, BODY_ZONE_PRECISE_L_EYE)

	// cure the disease
	vd.cure()
	display_results(user, target, span_notice("The vision rot corruption recedes."),
		"[user] finishes excising the corrupted tissue from [target]'s eyes.",
		"[user] cauterizes and purifies [target]'s eyes.")
	playsound(target, pick('sound/vo/male/gen/agony (11).ogg', 'sound/vo/male/gen/agony (13).ogg', 'sound/vo/male/gen/agony (4).ogg'), 80, FALSE)
	return TRUE

