/datum/sex_panel_action/other/tail/squeeze_breasts
	abstract_type = FALSE
	name = "Сжать хвостом грудь"
	required_target = SEX_ORGAN_BREASTS
	armor_slot_target = BODY_ZONE_CHEST
	stamina_cost = 0.06
	affects_self_arousal	= 0.25
	affects_arousal			= 1.0
	affects_self_pain		= 0.005
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} обвивает хвостом грудь {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} сжимает хвостом грудь {partner}."
	message_on_finish  = "{actor} уводит хвост от {partner}."
