/datum/sex_panel_action/other/hands/finger_vaginal
	abstract_type = FALSE
	name = "Фингеринг вагины"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.05
	affects_self_arousal = 0.0
	affects_arousal = 0.75
	affects_self_pain = 0.01
	affects_pain = 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} касается пальцем лона {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит пальцем внутри киски {partner}."
	message_on_finish  = "{actor} убирает палец от промежности {partner}."
	message_on_climax_target = "{partner} кончает, сжимая киской палец {actor}."
	climax_liquid_mode_passive = "onto"
