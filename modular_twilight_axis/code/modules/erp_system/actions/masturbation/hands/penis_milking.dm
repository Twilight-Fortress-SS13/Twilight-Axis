/datum/erp_action/self/hands/penis_milking
	abstract = FALSE

	name = "Доение члена"
	required_target_organ = SEX_ORGAN_PENIS
	inject_timing      = INJECT_ON_FINISH
	inject_source      = INJECT_FROM_PASSIVE
	inject_target_mode = INJECT_CONTAINER
	message_start = "{actor} {pose} берёт свой член в руку."
	message_tick = "{actor} {pose} мастурбирует рукой свой член."
	message_finish =  "{actor} ослабляет хватку и останавливается."
	message_climax_active = "Я чувствую, как семя вырывается наружу."
