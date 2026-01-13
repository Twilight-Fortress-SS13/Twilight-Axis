/datum/sex_panel_action/other/tail/spanking
	abstract_type = FALSE
	name = "Шлепать хвостом"
	required_target = null
	stamina_cost = 0.06
	affects_self_arousal	= 0
	affects_arousal			= 1.25
	affects_self_pain		= 0.005
	affects_pain			= 0.04

	actor_sex_hearts = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} прикладывает хвост к попе {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} шлепает хвостом по заднице {partner}."
	message_on_finish  = "{actor} убирает хвост от попки {partner}."

/datum/sex_panel_action/other/tail/spanking/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/sound = pick('sound/foley/slap.ogg', 'sound/foley/smackspecial.ogg')
	playsound(user, sound, 50, TRUE, -2, ignore_walls = FALSE)
	. = ..()
