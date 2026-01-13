/datum/sex_panel_action/other/legs/footjob
	abstract_type = FALSE
	name = "Работа ножками"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.06
	affects_self_arousal	= 0
	affects_arousal			= 1.0
	affects_self_pain		= 0
	affects_pain			= 0.01
	require_grab = TRUE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} зажимает член {partner} ступнями.."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит ступнями по члену {partner}."
	message_on_finish  = "{actor} убирает ножки от члена {partner}."
	message_on_climax_target = "{partner} кончает на ножки {actor}."
	climax_liquid_mode_passive = "onto"
