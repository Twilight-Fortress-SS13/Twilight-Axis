/datum/sex_panel_action/other/hands/spanking
	abstract_type = FALSE
	name = "Шлепать ягодицы"
	required_target = SEX_ORGAN_ANUS
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 1.5
	affects_self_pain = 0
	affects_pain = 0.05

	actor_sex_hearts = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} размещает руки на ягодицах {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} шлепает {aggr?зад:ягодицы} {partner}."
	message_on_finish  = "{actor} убирает руки от ягодиц {partner}."

/datum/sex_panel_action/other/hands/spanking/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/sound = pick('sound/foley/slap.ogg', 'sound/foley/smackspecial.ogg')
	playsound(user, sound, 50, TRUE, -2, ignore_walls = FALSE)
	. = ..()
