/datum/sex_panel_action/other/hands/toy_vaginal
	abstract_type = FALSE

	name = "Секс-игрушка вагинальная"
	required_target = SEX_ORGAN_VAGINA
	armor_slot_init = BODY_ZONE_PRECISE_GROIN
	check_same_tile = FALSE

	affects_self_arousal = 0
	affects_arousal = 1.5
	affects_self_pain = 0
	affects_pain = 0.02

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} подносит игрушку к лону {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит игрушкой внутри лона {partner}."
	message_on_finish  = "{actor} отстраняет игрушку от {partner}."
	message_on_climax_target = "{partner} кончает, сжимая киской игрушку {actor}."
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/hands/toy_vaginal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/item_object = user.get_active_held_item()
	if(!is_sex_toy(item_object))
		return FALSE

	return TRUE
