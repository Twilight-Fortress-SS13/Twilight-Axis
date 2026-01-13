/datum/sex_panel_action/other/legs/legsjob
	abstract_type = FALSE
	name = "Работа бедрами"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.06
	affects_self_arousal = 0.25
	affects_arousal = 1.5
	affects_self_pain = 0
	affects_pain = 0.02
	require_grab = TRUE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	target_do_thrust = TRUE

	message_on_start   = "{actor} {pose} зажимает член {partner} бедрами."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит ножками по члену {partner}."
	message_on_finish  = "{actor} выпускает из захвата бедрами член {partner}."
	message_on_climax_target = "{partner} кончает на бедра {actor}."
	climax_liquid_mode_passive = "onto"
