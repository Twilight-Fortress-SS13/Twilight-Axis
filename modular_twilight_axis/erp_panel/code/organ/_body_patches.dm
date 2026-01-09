/obj/item/organ
	var/datum/sex_organ/sex_organ

/obj/item/organ/breasts/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/breasts(src)

/obj/item/organ/penis
	var/manual_erection_override = FALSE

/obj/item/organ/penis/proc/sync_knotting_component()
	var/mob/living/carbon/human/human_object = owner
	if(!human_object)
		return

	var/needs_knot = (penis_type in list(
		PENIS_TYPE_KNOTTED,
		PENIS_TYPE_TAPERED_DOUBLE_KNOTTED,
		PENIS_TYPE_BARBED_KNOTTED,
		PENIS_TYPE_TAPERED
	))

	var/datum/component/knotting/knoting_object = human_object.GetComponent(/datum/component/knotting)

	if(needs_knot)
		if(!knoting_object)
			human_object.AddComponent(/datum/component/knotting)
	else
		if(knoting_object)
			qdel(knoting_object)

/obj/item/organ/penis/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	RegisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed), TRUE)
	sync_knotting_component()
	refresh_sex_organ()

/obj/item/organ/penis/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	UnregisterSignal(M, COMSIG_SEX_AROUSAL_CHANGED)
	var/datum/component/knotting/knoting_object = M.GetComponent(/datum/component/knotting)
	if(knoting_object)
		qdel(knoting_object)

/obj/item/organ/penis/on_arousal_changed()
	if(manual_erection_override)
		return

	var/list/arousal_data = list()
	SEND_SIGNAL(owner, COMSIG_SEX_GET_AROUSAL, arousal_data)

	var/max_arousal = MAX_AROUSAL || 120
	var/current_arousal = arousal_data["arousal"] || 0
	var/arousal_percent = min(100, (current_arousal / max_arousal) * 100)

	var/new_state = ERECT_STATE_NONE
	switch(arousal_percent)
		if(0 to 10)
			new_state = ERECT_STATE_NONE
		if(11 to 35)
			new_state = ERECT_STATE_PARTIAL
		if(36 to 100)
			new_state = ERECT_STATE_HARD

	update_erect_state(new_state)

/obj/item/organ/penis/proc/refresh_sex_organ()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/penis(src)
	else
		var/datum/sex_organ/penis/SP = sex_organ
		SP.refresh_from_organ(src)

/obj/item/organ/penis/proc/set_manual_erect_state(state)
	manual_erection_override = TRUE
	erect_state = state
	if(owner)
		owner.update_body_parts(TRUE)

/obj/item/organ/penis/proc/disable_manual_erect()
	manual_erection_override = FALSE
	erect_state = null
	on_arousal_changed()

/obj/item/organ/vagina/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/vagina(src)

/obj/item/organ/tail/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/tail(src)

/obj/item/bodypart/taur/lamia/attach_limb(mob/living/carbon/C)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/tail(src)

/obj/item/bodypart
	var/datum/sex_organ/sex_organ

/obj/item/bodypart/head/Initialize()
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/mouth(src)

/obj/item/bodypart/r_arm/attach_limb(mob/living/carbon/C)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/hand/right(src)
	
/obj/item/bodypart/l_arm/attach_limb(mob/living/carbon/C)
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/hand(src)

/mob/living/carbon/human
	var/datum/sex_organ/legs/legs_organ

/mob/living/carbon/human/proc/ensure_legs_organ()
	if(is_lamia_taur())
		if(legs_organ)
			qdel(legs_organ)
			legs_organ = null
		return null

	var/obj/item/bodypart/l_leg/lleg_object = get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/r_leg/rleg_object = get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/bodypart_object = lleg_object || rleg_object

	if(!bodypart_object)
		if(legs_organ)
			qdel(legs_organ)
			legs_organ = null
		return null

	if(legs_organ)
		if(legs_organ.organ_link == bodypart_object)
			return legs_organ

		qdel(legs_organ)
		legs_organ = null

	var/datum/sex_organ/legs/legs_object = new /datum/sex_organ/legs(bodypart_object)
	legs_organ = legs_object
	bodypart_object.sex_organ = legs_object
	return legs_object

/obj/item/bodypart/chest/Initialize()
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/anus(src)

/obj/item/bodypart/head/dullahan/Initialize()
	. = ..()
	if(!sex_organ)
		sex_organ = new /datum/sex_organ/mouth(src)

/obj/item/bodypart/head/dullahan/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	var/mob/living/carbon/human/target = src.original_owner
	if(user.mmb_intent)
		return ..()

	if(!istype(dragged))
		return
	if(dragged != user)
		return

	if(!user.can_do_sex())
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	if(!user.client?.prefs?.sexable)
		to_chat(user, "<span class='warning'>I don't want to touch [target]. (Your ERP preference, in the options)</span>")
		return
	if(!target.client || !target.client.prefs)
		to_chat(user, span_warning("[target] is simply not there. I can't do this."))
		log_combat(user, target, "tried ERP menu against d/ced")
		return
	if(!target.client.prefs.sexable)
		to_chat(user, "<span class='warning'>[target] doesn't want to be touched. (Their ERP preference, in the options)</span>")
		to_chat(target, "<span class='warning'>[user] failed to touch you. (Your ERP preference, in the options)</span>")
		log_combat(user, target, "tried unwanted ERP menu against")
		return

	user.start_sex_session_with_dullahan_head(src)

/obj/item/organ/penis/human
	name = "human penis"
	penis_type = PENIS_TYPE_PLAIN
	sheath_type = SHEATH_TYPE_NONE

/datum/customizer_choice/organ/penis/human_anthro
	name = "Plain Penis"
	organ_type = /obj/item/organ/penis/human
	sprite_accessories = list(/datum/sprite_accessory/penis/human)
	allows_accessory_color_customization = TRUE

/datum/customizer_choice/organ/penis
	abstract_type = /datum/customizer_choice/organ/penis
	name = "Penis"
	organ_type = /obj/item/organ/penis/human
	sprite_accessories = list(/datum/sprite_accessory/penis/human)
	organ_slot = ORGAN_SLOT_PENIS
	organ_dna_type = /datum/organ_dna/penis
	customizer_entry_type = /datum/customizer_entry/organ/penis
