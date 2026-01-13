/datum/sex_panel_action/other/penis/anal_sex
	abstract_type = FALSE

	name = "Анальный секс"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.0
	affects_arousal			= 0.75
	affects_self_pain		= 0.03
	affects_pain			= 0.03
	can_knot = TRUE

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} приставляет свой член к анальному кольцу {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трахает {partner} в задницу{knot}."
	message_on_finish  = "{actor} вытаскивает член из попки {partner}."
	message_on_climax_actor  = "{actor} кончает в попку {partner}."
	message_on_climax_target = "{partner} кончает сжимая анус вокруг члена {actor}."
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/penis/anal_sex/get_knot_count()
	return 1
