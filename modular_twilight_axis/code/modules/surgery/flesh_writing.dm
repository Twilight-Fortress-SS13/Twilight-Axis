/datum/surgery/flesh_writing
	name = "Flesh writing"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/write,
	)

	target_mobtypes = list(/mob/living/carbon/human)

/datum/surgery_step/write
	name = "Write"
	implements = list(
		TOOL_SCALPEL = 90,
		TOOL_SHARP = 70,
	)

	time = 3 SECONDS
	skill_min = SKILL_LEVEL_NONE
	var/text_to_write = null

/datum/surgery_step/write/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/BP = target.get_bodypart(check_zone(target_zone))
	if(BP.flesh_written_text)
		to_chat(user,span_info("There are already letters carved into it. I have to wait untill it heals."))
		return FALSE
	text_to_write = input(user,"Which words would your cruelty carve upon thy flesh?")
	if(!text_to_write)
		return FALSE
	display_results(user, target, span_notice("I begin to write on [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to to write on [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to to write on [target]'s [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/write/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("Blood pools around the grotesque letters on [target]'s [parse_zone(target_zone)]."),
		span_notice("Blood pools around the grotesque letters on [target]'s [parse_zone(target_zone)]."))
	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.flesh_written_text = text_to_write
		addtimer(CALLBACK(src, PROC_REF(clear_text),gotten_part), 30 MINUTES)
	return TRUE

/datum/surgery_step/write/proc/clear_text(obj/item/bodypart/BP)
	if(BP.flesh_written_text)
		BP.flesh_written_text = null
		return TRUE
	return FALSE
