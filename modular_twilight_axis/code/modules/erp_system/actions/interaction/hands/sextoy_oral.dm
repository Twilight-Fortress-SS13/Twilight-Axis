/datum/erp_action/other/hands/toy_oral
	abstract = FALSE

	name = "Секс-игрушка оральная"
	required_target_organ = SEX_ORGAN_MOUTH
	require_same_tile = FALSE
	message_start = "{actor} {pose} подносит игрушку к губам {dullahan?отделенной головы :}{partner}."
	message_tick = "{actor} {pose}, {force} и {speed} водит игрушкой во рту {dullahan?отделенной головы :}{partner}."
	message_finish =  "{actor}  убирает игрушку от {dullahan?отделенной головы :}{partner}."
	required_item_tags = list("dildo")
