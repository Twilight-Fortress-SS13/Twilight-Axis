/datum/sex_panel_action/other/hands/toy_oral
	abstract_type = FALSE

	name = "Секс-игрушка оральная"
	required_target = SEX_ORGAN_MOUTH
	check_same_tile = FALSE

	affects_self_arousal = 0
	affects_arousal = 1.0
	affects_self_pain = 0
	affects_pain = 0.01

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} подносит игрушку к губам {dullahan?отделенной головы :}{partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} водит игрушкой во рту {dullahan?отделенной головы :}{partner}."
	message_on_finish  = "{actor}  убирает игрушку от {dullahan?отделенной головы :}{partner}."

/datum/sex_panel_action/other/hands/toy_oral/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/item_object = user.get_active_held_item()
	if(!is_sex_toy(item_object))
		return FALSE

	return TRUE
