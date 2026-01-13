/datum/sex_panel_action/other/hands/tease_vagina
	abstract_type = FALSE
	name = "Ласкать клитор рукой"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	break_on_move = FALSE
	stamina_cost = 0.05
	affects_self_arousal	= 0
	affects_arousal			= 1.25
	affects_self_pain		= 0
	affects_pain			= 0.04

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE

	message_on_start   = "{actor} {pose} касается рукой киски {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит рукой по клитору {partner}."
	message_on_finish  = "{actor} убирает руку от лона {partner}."
