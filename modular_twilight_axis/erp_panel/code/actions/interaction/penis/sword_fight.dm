
/datum/sex_panel_action/other/penis/sword_fight
	abstract_type = FALSE

	name = "Фехтование"
	required_target = SEX_ORGAN_PENIS
	armor_slot_target = null
	can_knot = FALSE
	check_same_tile = FALSE

	affects_self_arousal	= 0.5
	affects_arousal			= 0.5
	affects_self_pain		= 0.01
	affects_pain			= 0.03

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} приставляет свой член к члену {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся членом об член {partner}."
	message_on_finish  = "{actor} убирает член от члена {partner}."
	message_on_climax_actor  = "{actor} кончает на {partner}."
	message_on_climax_target = "{partner} кончает на {actor}."
	climax_liquid_mode_active = "onto"
	climax_liquid_mode_passive = "onto"
