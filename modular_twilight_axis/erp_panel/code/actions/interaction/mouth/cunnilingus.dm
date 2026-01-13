/datum/sex_panel_action/other/mouth/cunnilingus
	abstract_type = FALSE
	name = "Куннилингус"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.01
	affects_self_arousal = 0.25
	affects_arousal = 1.0
	affects_self_pain = 0.01
	affects_pain = 0.02

	actor_sex_hearts = TRUE
	actor_suck_sound = TRUE

	message_on_start   = "{actor} припадет к лону {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} вылизывает киску {partner}."
	message_on_finish  = "{actor} убирает лицо от паха {partner}."
	message_on_climax_target = "{partner} кончает на лицо {actor}."
	climax_liquid_mode_passive = "onto"
