/datum/sex_panel_action/other/vagina/tail
	abstract_type = FALSE
	name = "Использовать хвост"
	required_target = SEX_ORGAN_TAIL
	stamina_cost = 0.06
	affects_self_arousal	= 0.5
	affects_arousal			= 1.0
	affects_self_pain		= 0.01
	affects_pain			= 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose}, {force} и {speed} хватает хвост {partner}, прижимая его к своему лону."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит хвостом {partner} в своей киске."
	message_on_finish  = "{actor} вытаскивает хвост {partner} из своего влагалища."
	message_on_climax_actor  = "{actor} кончает, киской сжимая хвост {partner}."

