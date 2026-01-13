/datum/sex_panel_action/other/tail/anal
	abstract_type = FALSE
	name = "Трахнуть зад хвостом"
	required_target = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.06
	affects_self_arousal	= 0.5
	affects_arousal			= 1.0
	affects_self_pain		= 0.005
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} вводит хвост в попку {partner}."
	message_on_perform = "{actor} {pose} сношает хвостом попку {partner}."
	message_on_finish  = "{actor} вытаскивает хвост из задницы {partner}."
	message_on_climax_target = "{partner} кончает сжимая попку вокруг хвоста {actor}."
	climax_liquid_mode_passive = "onto"

