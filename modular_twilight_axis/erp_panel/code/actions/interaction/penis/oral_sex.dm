/datum/sex_panel_action/other/penis/oral_sex
	abstract_type = FALSE

	name = "Оральный секс"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH

	affects_self_arousal	= 1.0
	affects_arousal			= 0.5
	affects_self_pain		= 0.01
	affects_pain			= 0.02

	target_suck_sound = TRUE
	actor_sex_hearts = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} приставляет свой член к лицу {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трахает в рот {dullahan?отделенной головы :}{partner}{knot}."
	message_on_finish  = "{actor} выводит член из рта {dullahan?отделенной головы :}{partner}."
	message_on_climax_actor  = "{actor}  кончает в рот {dullahan?отделенной головы :}{partner}."
	message_on_climax_target = "{partner} кончает под себя!"
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "self"

/datum/sex_panel_action/other/penis/oral_sex/get_knot_count()
	return 1
