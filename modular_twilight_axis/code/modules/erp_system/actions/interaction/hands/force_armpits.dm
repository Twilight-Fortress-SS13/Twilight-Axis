/datum/erp_action/other/hands/force_armpits
	abstract = FALSE
	name = "Прижать к подмышкам"
	required_target_organ = SEX_ORGAN_MOUTH
	require_grab = TRUE
	message_start = "{actor} хватает {dullahan?отделенную :}голову {partner}."
	message_tick = "{actor} {force} и {speed} водит лицом {dullahan?отделенной головы :}{partner} по своим подмышкам."
	message_finish =  "{actor} убирает руку от {dullahan?отделенной головы :}{partner}."
