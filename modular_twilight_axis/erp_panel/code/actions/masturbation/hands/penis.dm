/datum/sex_panel_action/self/hands/masturbate_penis
	abstract_type = FALSE

	name = "Мастурбация члена"
	required_target = SEX_ORGAN_PENIS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.5
	affects_self_pain		= 0.01

	actor_sex_hearts = TRUE
	actor_do_onomatopoeia = TRUE

	message_on_start   = "{actor} {pose} хватает свой член."
	message_on_perform = "{actor} {pose}, {force} и {speed} дёргает свой член."
	message_on_finish  = "{actor} ослабляет хватку и останавливается."
