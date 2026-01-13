/datum/sex_panel_action/other/anus/face
	abstract_type = FALSE
	name = "Сесть на лицо"

	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH

	stamina_cost = 0.1
	affects_self_arousal = 0.75
	affects_arousal = 1.0
	affects_self_pain = 0.01
	affects_pain = 0.03

	actor_sex_hearts = TRUE
	target_suck_sound = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} прижимается анусом к лицу {dullahan?отделенной головы :}{partner}, раздвигая ягодицы.."
	message_on_perform = "{actor} {pose}, {force} и {speed} елозит {aggr?задницей:ягодицами} по лицу {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor} соскальзывает попкой с лица {dullahan?отделенной головы :}{partner}."
	message_on_climax_actor  = "{actor}  кончает под себя."
	message_on_climax_target = "{partner} кончает под себя."
