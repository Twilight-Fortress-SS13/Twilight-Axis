
/datum/sex_panel_action/other/tail/penis
	abstract_type = FALSE
	name = "Мастурбация хвостом"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.06
	affects_self_arousal	= 0.5
	affects_arousal			= 1.0
	affects_self_pain		= 0.005
	affects_pain			= 0.03

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} обвивает хвостом член {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит хвостом по члену {partner}."
	message_on_finish  = "{actor} отводит хвост от члена {partner}."
	message_on_climax_target = "{partner} кончает на хвост {actor}."
	climax_liquid_mode_passive = "onto"
