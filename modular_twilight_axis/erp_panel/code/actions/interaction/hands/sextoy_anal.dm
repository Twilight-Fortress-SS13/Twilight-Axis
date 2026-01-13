
/datum/sex_panel_action/other/hands/toy_anal
	abstract_type = FALSE
	name = "Секс-игрушка анальная"
	required_target = SEX_ORGAN_ANUS
	armor_slot_init = BODY_ZONE_PRECISE_GROIN
	check_same_tile = FALSE

	affects_self_arousal = 0
	affects_arousal = 1.25
	affects_self_pain = 0
	affects_pain = 0.03

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} примеряет игрушку у анального кольца {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} сношает анус {partner} игрушкой."
	message_on_finish  = "{actor} медленно прекращает движение игрушки в попке {partner}."
	message_on_climax_target = "{partner} кончает, сжимая попкой игрушку {actor}."
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/hands/toy_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/item_object = user.get_active_held_item()
	if(!is_sex_toy(item_object))
		return FALSE

	return TRUE
