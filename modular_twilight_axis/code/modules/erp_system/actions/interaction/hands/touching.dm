/datum/erp_action/other/hands/touching
	abstract = FALSE
	name = "Ласкать"
	required_target_organ = SEX_ORGAN_BODY
	action_tags = list("race_body")
	message_start = "{actor} касается руками {partner}."
	message_tick = "{actor} {force} и {speed} ласкает {zone} {partner}."
	message_finish =  "{actor} убирает руки от {partner}."
