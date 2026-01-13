/datum/sex_panel_action/other/hands/force_crotch
	abstract_type = FALSE
	name = "Прижать к паху"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_HEAD
	stamina_cost = 0.05
	affects_self_arousal = 1.0
	affects_arousal = 0.5
	affects_self_pain = 0.02
	affects_pain = 0.01
	require_grab = TRUE

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} хватает {dullahan?отделенную :}головы {partner}, прижимая к своей промежности."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит лицом {dullahan?отделенной головы :}{partner} по своей промежности."
	message_on_finish  = "{actor} отпускает {dullahan?отделенную :}голову {partner}."
