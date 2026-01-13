
/datum/sex_panel_action/other/hands/masturbation
	abstract_type = FALSE
	name = "Ласкать член рукой"
	required_target = SEX_ORGAN_PENIS
	break_on_move = FALSE
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 1.0
	affects_self_pain = 0
	affects_pain = 0.04

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} касается руками члена {partner} и обхватывает его."
	message_on_perform = "{actor} {pose}, {force} и {speed} дрочит член {partner}."
	message_on_finish  = "{actor} убирает руки от члена {partner}."
	message_on_climax_target = "{partner} кончает на {actor}."
	climax_liquid_mode_passive = "onto"
