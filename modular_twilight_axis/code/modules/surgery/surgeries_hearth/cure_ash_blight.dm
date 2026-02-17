/datum/surgery/cure_ash_blight
	name = "Cauterize Ash Blight"
	desc = "Burn away ash blight lesions through painful cauterization."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/burn_ash_blight,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/burn_ash_blight
	name = "burn ash blight"
	implements = list(
		TOOL_CAUTERY = 85,
		/obj/item/clothing/neck/roguetown/psicross = 85,
		TOOL_WELDER = 70,
		TOOL_HOT = 35,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 10 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/burn_ash_blight/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return FALSE
	var/has_blight = FALSE
	for(var/thing in target.diseases)
		if(istype(thing, /datum/disease/ash_blight))
			has_blight = TRUE
			break
	return has_blight

/datum/surgery_step/burn_ash_blight/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		span_notice("I begin to burn the ash blight across [target]'s body..."),
		span_notice("[user] begins to burn away the ash blight on [target]."),
		span_notice("[user] begins to cauterize [target]'s lesions."))
	return TRUE

/datum/surgery_step/burn_ash_blight/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/datum/disease/ash_blight/blight = null
	for(var/thing in target.diseases)
		if(istype(thing, /datum/disease/ash_blight))
			blight = thing
			break
	if(!blight)
		display_results(user, target,
			span_warning("The lesions have already faded."),
			span_notice("[user] pauses, finding no ash blight to burn."),
			span_notice("[user] pauses their cauterization."))
		return TRUE

	var/burn_damage = 35
	if(user?.mind)
		var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
		burn_damage = max(20, burn_damage - (medskill * 2))

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(burn_damage, BURN, BODY_ZONE_CHEST, spread_damage = TRUE)
	else
		target.apply_damage(burn_damage, BURN, BODY_ZONE_CHEST)

	blight.cure()
	display_results(user, target,
		span_notice("You burn away the ash blight infecting [target]."),
		span_notice("[user] burns away the ash blight on [target]."),
		span_notice("[user] sears [target]'s lesions with [tool]."))
	// patient screams in agony after the cauterization
	if(target.gender == FEMALE)
		playsound(target, pick('sound/vo/female/dainty/painscream (1).ogg', 'sound/vo/female/dainty/painscream (2).ogg'), 80, FALSE)
	else
		playsound(target, pick('sound/vo/male/gen/agony (11).ogg', 'sound/vo/male/gen/agony (13).ogg', 'sound/vo/male/gen/agony (4).ogg'), 80, FALSE)
	return TRUE
