/datum/sex_panel_action/other/hands/finger_oral
	abstract_type = FALSE
	name = "Пустить пальцы в рот"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 0.25
	affects_self_pain = 0.01
	affects_pain = 0.01

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} проникает пальцами в рот {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит пальцами во рту {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} убирает пальцы из рта {dullahan?отделенной головы :}{partner}."
