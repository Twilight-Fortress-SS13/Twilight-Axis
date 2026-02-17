// SURGERY: Cure Plague
/datum/surgery/cure_plague
	name = "Cure Plague"
	desc = "A cauterization operation to cure the Plague. Requires the patient to have consumed Plague Cure potion. Causes severe burns and agony."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/cauterize_plague,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/cauterize_plague
	name = "Cauterize Plague Infection"
	implements = list(
		TOOL_CAUTERY = 90,
		/obj/item/clothing/neck/roguetown/psicross = 90,
		TOOL_WELDER = 70,
		TOOL_HOT = 40
	)
	target_mobtypes = list(/mob/living/carbon/human)
	time = 12 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/cauterize_plague/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return FALSE
	var/has_plague = FALSE
	for(var/thing in target.diseases)
		if(istype(thing, /datum/disease/plague))
			has_plague = TRUE
			break
	return has_plague

/datum/surgery_step/cauterize_plague/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		span_notice("I begin to cauterize the plague infection in [target]'s body..."),
		span_notice("[user] begins to cauterize the plague infection in [target]."),
		span_notice("[user] begins to cauterize [target]'s infected tissue."))
	return TRUE

/datum/surgery_step/cauterize_plague/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/datum/disease/plague/plague = null
	for(var/datum/disease/D in target.diseases)
		if(istype(D, /datum/disease/plague))
			plague = D
			break
	if(!plague)
		display_results(user, target,
			span_warning("The infection has already been cleared."),
			span_notice("[user] pauses, finding no plague to cure."),
			span_notice("[user] pauses their cauterization."))
		return TRUE

	var/has_cure = FALSE
	var/datum/reagent/reagent_ref = null
	for(var/datum/reagent/R in target.reagents?.reagent_list)
		if(istype(R, /datum/reagent/medicine/plague_cure))
			has_cure = TRUE
			reagent_ref = R
			break
	
	if(!has_cure)
		display_results(user, target,
			span_warning("The cauterization fails - [target] has not consumed the Plague Cure potion!"),
			span_warning("[user]'s cauterization fails - the potion is required!"),
			span_warning("[user]'s cauterization fails."))
		to_chat(target, span_userdanger("Сжигание тканей приносит только боль без зелья!"))
		target.apply_damage(15, BURN, BODY_ZONE_CHEST)
		return FALSE

	// consume reagent in patient
	if(reagent_ref)
		target.reagents.remove_reagent(/datum/reagent/medicine/plague_cure, reagent_ref.volume)
	
	plague.cure()
	
	var/burn_damage = 50
	if(user?.mind)
		var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
		burn_damage = max(20, burn_damage - (medskill * 2))
	
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(burn_damage, BURN, BODY_ZONE_CHEST, spread_damage = TRUE)
	else
		target.apply_damage(burn_damage, BURN, BODY_ZONE_CHEST)
	
	display_results(user, target,
		span_notice("You cauterize the plague infection from [target]'s body!"),
		span_notice("[user] successfully cauterizes the plague from [target]!"),
		span_notice("[user] sears [target]'s plague-ridden tissue with [tool]."))
	to_chat(target, span_notice("Операция завершена, чума устранена, но я получил сильные ожоги!"))
	if(target.gender == FEMALE)
		playsound(target, pick('sound/vo/female/dainty/painscream (1).ogg', 'sound/vo/female/dainty/painscream (2).ogg'), 80, FALSE)
	else
		playsound(target, pick('sound/vo/male/gen/agony (11).ogg', 'sound/vo/male/gen/agony (13).ogg', 'sound/vo/male/gen/agony (4).ogg'), 80, FALSE)
	return TRUE

