/datum/sex_panel_action/other/penis/hemi/dp_vag_anal
	abstract_type = FALSE

	name = "Двойное проникновение"
	required_target = SEX_ORGAN_VAGINA
	var/required_target_second = SEX_ORGAN_ANUS
	armor_slot_target = BODY_ZONE_PRECISE_GROIN
	reserve_target_for_session = TRUE

	affects_self_arousal	= 2.25
	affects_arousal			= 1.25
	affects_self_pain		= 0.05
	affects_pain			= 0.03
	can_knot = TRUE

	actor_sex_hearts = TRUE
	actor_make_sound = TRUE
	actor_do_onomatopoeia = TRUE
	actor_do_thrust = TRUE
	can_be_custom = FALSE

	message_on_start   = "{actor} {pose} приставляет свои члены сразу к обоим дырочкам {partner}."
	message_on_perform = "{actor} {pose}, {force} и {speed} трахает {partner} сразу в киску и зад{knot}."
	message_on_finish  = "{actor} вытаскивает члены из дырок {partner}."
	message_on_climax_actor  = "{actor} кончает одновременно в киску и зад {partner}."
	message_on_climax_target = "{partner} кончает под себя!"
	climax_liquid_mode_active = "into"
	climax_liquid_mode_passive = "onto"

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/get_filter_target_organ_types()
	return list(required_target, required_target_second)

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/proc/get_action_organs_dp(mob/living/carbon/human/user, mob/living/carbon/human/target, only_free_init = TRUE,	only_free_target = FALSE, only_free_second = FALSE)
	var/datum/sex_organ/init_organ = user.get_sex_organ_by_type(SEX_ORGAN_PENIS, only_free_init)
	if(!init_organ)
		return null

	var/datum/sex_organ/vag = target.get_sex_organ_by_type(SEX_ORGAN_VAGINA, only_free_target)
	if(!vag)
		return null

	var/datum/sex_organ/anus = target.get_sex_organ_by_type(SEX_ORGAN_ANUS, only_free_second)
	if(!anus)
		return null

	return list(
		"init"   = init_organ,
		"vag"    = vag,
		"anus"   = anus,
	)

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/shows_on_menu(user, target)
	if(!..())
		return FALSE

	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/target_object = target
	if(!target_object.get_sex_organ_by_type(SEX_ORGAN_VAGINA, FALSE))
		return FALSE
	if(!target_object.get_sex_organ_by_type(SEX_ORGAN_ANUS, FALSE))
		return FALSE

	return TRUE

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/can_perform(user, target)
	. = ..()
	if(!user || !target)
		return FALSE

	var/list/orgs = get_action_organs_dp(user, target, FALSE, FALSE, FALSE)
	if(!orgs)
		return FALSE

	var/datum/sex_organ/init_organ = orgs["init"]
	var/datum/sex_organ/vag        = orgs["vag"]
	var/datum/sex_organ/anus       = orgs["anus"]

	var/list/to_check = list()
	if(init_organ)
		to_check += init_organ
	if(vag)
		to_check += vag
	if(anus)
		to_check += anus

	for(var/datum/sex_organ/organ_object in to_check)
		if(!organ_object)
			continue

		var/node_id = organ_object.organ_type
		if(!node_id)
			continue

		var/mob/living/carbon/human/owner

		if(istype(organ_object.organ_link, /obj/item/bodypart))
			var/obj/item/bodypart/bodypart_object = organ_object.organ_link
			owner = bodypart_object.owner
		else if(istype(organ_object.organ_link, /obj/item/organ))
			var/obj/item/organ/organ_item = organ_object.organ_link
			owner = organ_item.owner

		if(!owner)
			continue

		if(owner.is_sex_node_restrained(node_id))
			return FALSE

	if(!passes_armor_check(user, target))
		return FALSE

	return TRUE

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/connect_organs(user, target)
	var/list/orgs = get_action_organs_dp(user, target)
	if(!orgs)
		return FALSE

	var/datum/sex_organ/init_organ = orgs["init"]
	var/datum/sex_organ/vag        = orgs["vag"]
	var/datum/sex_organ/anus       = orgs["anus"]

	if(!init_organ)
		return FALSE

	if(vag)
		if(!init_organ.can_start_active())
			return FALSE
		if(!init_organ.start_active(vag))
			return FALSE

	if(anus)
		if(!init_organ.can_start_active())
			return FALSE
		if(!init_organ.start_active(anus))
			return FALSE

	return orgs

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/get_reserved_target_organ_types()
	if(!reserve_target_for_session)
		return null

	return list(SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS)

/datum/sex_panel_action/other/penis/hemi/dp_vag_anal/get_knot_count()
	return 2
