/datum/sex_panel_action/other/vagina/sex
	abstract_type = FALSE
	name = "Седлать вагиной"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.06
	affects_self_arousal	= 1.0
	affects_arousal			= 1.0
	affects_self_pain		= 0.01
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose}, {force} и {speed} прижимается вагиной к члену {partner}, раздвигая ноги."
	message_on_perform = "{actor} {pose}, {force} и {speed} скачет вагиной на члене {partner}."
	message_on_finish  = "{actor} соскальзывает вагиной с члена {partner}."
	message_on_climax_actor  = "{actor} кончает, киской сжимая член {partner}."
	message_on_climax_target = "{partner} кончает в лоно {actor}."
	climax_liquid_mode_active = "onto"
	climax_liquid_mode_passive = "into"

