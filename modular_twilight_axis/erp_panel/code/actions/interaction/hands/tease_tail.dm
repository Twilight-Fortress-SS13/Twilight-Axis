/datum/sex_panel_action/other/hands/tease_tail
	abstract_type = FALSE
	name = "Ласкать хвост"
	required_target = SEX_ORGAN_TAIL
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 0.5
	affects_self_pain = 0
	affects_pain = 0.04
	break_on_move = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} касается руками хвоста {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит руками по хвосту {partner}."
	message_on_finish  = "{actor} убирает руки от хвоста {partner}."
