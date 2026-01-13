/datum/sex_panel_action/other/legs/footfetish
	abstract_type = FALSE
	name = "Заставить вылизать ножки"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 0.05
	affects_self_arousal = 0.25
	affects_arousal = 0.5
	affects_self_pain = 0.01
	affects_pain = 0.02
	require_grab = TRUE

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE

	message_on_start   = "{actor} {pose} пихает ноги в рот {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит пальцами ног во рту {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} убирает ножки от лица {dullahan?отделенной головы :}{partner}."
