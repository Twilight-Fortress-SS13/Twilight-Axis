/datum/sex_panel_action/self/hands/toy_anal
	abstract_type = FALSE

	name = "Секс-игрушка анальная"
	required_target = SEX_ORGAN_ANUS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN

	affects_self_arousal	= 1.25
	affects_self_pain		= 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} примеряет игрушку у своего анального кольца."
	message_on_perform = "{actor} {pose}, {force} и {speed} сношает себя в попку игрушкой."
	message_on_finish  = "{actor} выводит игрушку из своей попки."

/datum/sex_panel_action/self/hands/toy_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/item_object = user.get_active_held_item()
	if(!is_sex_toy(item_object))
		return FALSE

	return TRUE
