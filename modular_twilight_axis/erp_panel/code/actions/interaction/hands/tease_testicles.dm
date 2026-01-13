/datum/sex_panel_action/other/hands/tease_testicles
	abstract_type = FALSE
	name = "Ласкать тестикулы рукой"
	required_target = SEX_ORGAN_PENIS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	stamina_cost = 0.05
	affects_self_arousal = 0
	affects_arousal = 0.5
	affects_self_pain = 0
	affects_pain = 0.05
	check_same_tile = FALSE

	actor_sex_hearts = TRUE
	actor_make_fingering_sound = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} касается руками тестикул {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} перебирает пальчиками тестикулы {partner}."
	message_on_finish  = "{actor} убирает руки от яиц {partner}."

/datum/sex_panel_action/other/penis/tea_bag/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()

	if(!target)
		return

	var/obj/item/organ/testicles/testicles = target.getorganslot(ORGAN_SLOT_TESTICLES)
	if(!testicles)
		return
