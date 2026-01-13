/datum/sex_panel_action/other/anus/force_face
	abstract_type = FALSE
	name = "Сесть на лицо"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 0.1
	affects_self_arousal = 1.25
	affects_arousal = 0.5
	affects_self_pain = 0.01
	affects_pain = 0.04

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} прижимает {dullahan?отделенную :}голову {partner} к своей заднице.."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит {aggr?задницей:ягодицами} по {dullahan?отделенной :}голове {partner}."
	message_on_finish  = "{actor} отводит попку от лица {dullahan?отделенной головы :}{partner}."
	message_on_climax_actor  = "{actor} кончает под себя."
	message_on_climax_target = "{partner} кончает под себя."
