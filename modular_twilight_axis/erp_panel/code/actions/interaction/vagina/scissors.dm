/datum/sex_panel_action/other/vagina/scissors
	abstract_type = FALSE
	name = "Ножницы"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.06
	affects_self_arousal	= 1.5
	affects_arousal			= 1.5
	affects_self_pain		= 0.01
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} прижимается вагиной к киске {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трётся своей вагиной об вагину {partner}."
	message_on_finish  = "{actor} расцепляет вагины с {partner}."
	message_on_climax_actor  = "{actor} кончает на промежность {partner}."
	message_on_climax_target = "{partner} кончает на промежность {actor}."
	climax_liquid_mode_passive = "onto"
