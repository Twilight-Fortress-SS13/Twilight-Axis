/datum/sex_panel_action/other/penis/force_blowjob
	abstract_type = FALSE

	name = "Заставить отсосать"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = null
	can_knot = FALSE
	
	affects_self_arousal	= 1.25
	affects_arousal			= 0.25
	affects_self_pain		= 0.01
	affects_pain			= 0.03

	message_on_start			= "{actor} {pose} приставляет свой член к лицу {dullahan?отделенной головы :}{partner}."
	message_on_perform			= "{actor} {pose}, {force} и {speed} трахает в глотку {dullahan?отделенной головы :}{partner}{knot}."
	message_on_finish			= "{actor} вытаскивает член из рта {dullahan?отделенной головы :}{partner}."
	message_on_climax_actor		= "{actor} кончает в рот {dullahan?отделенной головы :}{partner}."
	message_on_climax_target	= "{partner} кончает под себя!"
	climax_liquid_mode_active = "into"

	actor_do_onomatopoeia = TRUE
	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	target_suck_sound = TRUE
