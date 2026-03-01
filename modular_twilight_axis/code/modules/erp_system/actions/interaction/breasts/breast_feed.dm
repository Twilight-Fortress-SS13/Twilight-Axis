/datum/erp_action/other/breasts/breast_feed
	name = "Насильное кормление"
	abstract = FALSE
	required_target_organ = SEX_ORGAN_MOUTH
	require_grab = TRUE
	inject_timing = INJECT_CONTINUOUS
	inject_source = INJECT_FROM_ACTIVE
	inject_target_mode = INJECT_ORGAN
	message_start  = "{actor} {pose} прижимает лицо {partner} к своей груди."
	message_tick   = "{actor} {pose}, {force} и {speed} водит головой {partner} по своей груди."
	message_finish = "{actor} убирает голову {partner} от своей груди."
	message_climax_active = "{actor} вздрагивает от напряжённого удовольствия."
	message_climax_passive = "Рот {partner} наполняется вкусом и теплом."
