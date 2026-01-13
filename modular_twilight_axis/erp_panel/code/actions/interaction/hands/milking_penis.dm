/datum/sex_panel_action/other/hands/milking_penis
	abstract_type = FALSE
	name = "Доить член"
	required_target = SEX_ORGAN_PENIS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 1.5
	affects_self_pain = 0
	affects_pain = 0.05

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} кладет руки на член {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит руками по члену {partner}."
	message_on_finish  = "{actor} убирает руки от члена {partner}."
	message_on_climax_target = "{partner} кончает в руках {actor}."
	climax_liquid_mode_passive = "self"

/datum/sex_panel_action/other/penis/vaginal_sex/handle_climax_message(mob/living/carbon/human/user, mob/living/carbon/human/target, is_active = TRUE)
	var/datum/sex_session_tgui/SS = get_or_create_sex_session_tgui(user, target)
	if(SS)
		var/datum/sex_organ/organ_object = SS.resolve_organ_datum(target, SEX_ORGAN_FILTER_PENIS)
		if(organ_object)
			var/obj/item/container = find_best_container(target, target, organ_object)
			organ_object.inject_liquid(container, target)
			to_chat(user, "Я чувствую, как семя [target] выплескивается наружу!")
			to_chat(target, "Я чувствую, как семя выплескивается наружу!")
	. = ..()
