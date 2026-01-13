/datum/sex_panel_action/other/vagina/force_face
	abstract_type = FALSE
	name = "Заставить отлизать"
	required_target = SEX_ORGAN_MOUTH
	armor_slot_target = BODY_ZONE_PRECISE_MOUTH
	stamina_cost = 0.06
	affects_self_arousal	= 1.5
	affects_arousal			= 0.25
	affects_self_pain		= 0.02
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_do_thrust = TRUE
	target_suck_sound = TRUE

	message_on_start   = "{actor} {pose}, {force} и {speed} хватает {dullahan?отделенную голову :}{partner}, прижимая к своей промежности."
	message_on_perform = "{actor} {pose}, {force} и {speed} впечатывает лицо {dullahan?отделенной головы :}{partner} в свою промежность."
	message_on_finish  = "{actor} убирает руки от {dullahan?отделенной головы:головы} {partner}."
	message_on_climax_actor  = "{actor} кончает на лицо {dullahan?отделенной головы :}{partner}."
