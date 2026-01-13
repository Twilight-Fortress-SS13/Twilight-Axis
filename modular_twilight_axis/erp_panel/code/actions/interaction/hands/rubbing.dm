/datum/sex_panel_action/other/hands/rubbing
	abstract_type = FALSE
	name = "Лапать тело"
	required_target = null
	stamina_cost = 0.05
	affects_self_arousal = 0.5
	affects_arousal = 1.25
	affects_self_pain = 0
	affects_pain = 0.03
	break_on_move = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} касается руками {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} лапает {partner}."
	message_on_finish  = "{actor} {pose} убирает руки от {partner}."
