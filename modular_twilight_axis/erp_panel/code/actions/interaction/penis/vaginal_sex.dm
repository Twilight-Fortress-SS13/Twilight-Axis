/datum/sex_panel_action/other/penis/vaginal_sex
	abstract_type = FALSE

	name = "Вагинальный секс"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.0
	affects_arousal			= 1.0
	affects_self_pain		= 0.02
	affects_pain			= 0.02

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} приставляет свой член к лону {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трахает {partner} в киску{knot}."
	message_on_finish  = "{actor} вытаскивает член из влагалища {partner}."
	message_on_climax_actor  = "{actor} кончает в лоно {partner}."
	message_on_climax_target = "{partner} кончает сжимая киску вокруг члена {actor}."
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/penis/vaginal_sex/get_knot_count()
	return 1
