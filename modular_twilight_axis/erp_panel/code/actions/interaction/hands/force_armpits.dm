/datum/sex_panel_action/other/hands/force_armpits
	abstract_type = FALSE
	name = "Прижать к подмышкам"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_HEAD
	stamina_cost = 0.05
	affects_self_arousal = 0.75
	affects_arousal = 0
	affects_self_pain = 0.02
	affects_pain = 0.01
	require_grab = TRUE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} хватает {dullahan?отделенную :}голову {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит лицом {dullahan?отделенной головы :}{partner} по своим подмышкам."
	message_on_finish  = "{actor} убирает руку от {dullahan?отделенной головы :}{partner}."
