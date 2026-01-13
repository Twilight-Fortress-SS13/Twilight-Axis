/datum/sex_panel_action/other/breasts/titjob
	abstract_type = FALSE
	name = "Работа грудью"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.05
	affects_self_arousal = 0.5
	affects_arousal = 1.0
	affects_self_pain = 0.005
	affects_pain = 0.01

	require_grab = TRUE
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} {bigbreast?обхватывает:зажимает} член {partner} грудью."
	message_on_perform = "{actor} {pose}, {force} и {speed} {bigbreast?утопает в своей груди член:водит грудью по члену} {partner}."
	message_on_finish  = "{actor} убирает грудь от члена {partner}."
	message_on_climax_target = "{partner} кончает на грудь {actor}."
	climax_liquid_mode_passive = "onto"
