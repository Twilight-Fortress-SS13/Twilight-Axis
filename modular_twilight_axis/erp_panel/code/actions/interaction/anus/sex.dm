/datum/sex_panel_action/other/anus/sex
	abstract_type = FALSE
	name = "Седлать анусом"
	required_target = SEX_ORGAN_PENIS
	stamina_cost = 0.06
	affects_self_arousal = 0.25
	affects_arousal = 0.25
	affects_self_pain = 0.01
	affects_pain = 0.01

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE

	message_on_start   = "{actor} {pose} прижимается анусом к члену {partner}, раздвигая ягодицы."
	message_on_perform = "{actor} {pose}, {force} и {speed} скачет {aggr?задницей:ягодицами} на члене {partner}."
	message_on_finish  = "{actor} соскальзывает попкой с члена {partner}."
	message_on_climax_actor  = "{actor} кончает, сжимая попкой член {partner}."
	message_on_climax_target = "{partner} кончает в попку {actor}."
	climax_liquid_mode_passive = "into"
