



/mob/do_dodge(mob/user, turf/turfy)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOB_DODGE_SUCCESS, user, turfy)
	return .




/mob/living/setDir(newdir)
	. = ..()
	var/datum/component/contractor/S = src.GetComponent(/datum/component/contractor)
	S?.update_true_form_visuals()
	return .




/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/datum/component/contractor/core = GetComponent(/datum/component/contractor)
	var/examine_text = core?.get_true_form_examine_text(user)
	if(examine_text)
		if(islist(.))
			. += examine_text
		else
			to_chat(user, examine_text)
	var/datum/component/contractor/user_contractor = ishuman(user) ? user.GetComponent(/datum/component/contractor) : null
	var/datum/component/contractee/contractee = GetComponent(/datum/component/contractee)
	if(user_contractor && contractee?.contractor == user_contractor)
		var/mark = contractee.is_submitted() ? "fully submitted" : "bound"
		var/text = span_love("An infernal mark tells you this one is [mark]: [contractee.submission]/[contractee.submission_threshold].")
		if(islist(.))
			. += text
		else
			to_chat(user, text)








/mob/living/carbon/human/species/wildshape/contractor_trueform
	name = "Contractor"
	desc = "A demonic entity wearing a beautiful shape like a threat."
	race = /datum/species/contractor_trueform
	ambushable = FALSE
	footstep_type = FOOTSTEP_MOB_HEAVY
	pixel_x = CONTRACTOR_TRUE_FORM_PIXEL_X
	pixel_y = CONTRACTOR_TRUE_FORM_PIXEL_Y

/mob/living/carbon/human/species/wildshape/contractor_trueform/Destroy()
	stored_mob = null
	return ..()

/mob/living/carbon/human/species/wildshape/contractor_trueform/death(gibbed, nocutscene = FALSE)
	var/datum/component/contractor/S = GetComponent(/datum/component/contractor)
	if(S?.true_form)
		S.exit_true_form_body(TRUE)
		return
	return ..()

/datum/species/contractor_trueform
	name = "contractor"
	id = "contractor_trueform"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_NIGHT_VISION,
		TRAIT_NOPAINSTUN,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE, SLOT_RING, SLOT_NECK)
	nojumpsuit = TRUE
	sexes = TRUE
	offset_features = list(OFFSET_HANDS = list(0,0), OFFSET_HANDS_F = list(0,0))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)

/datum/species/contractor_trueform/regenerate_icons(mob/living/carbon/human/human)
	
	
	
	
	if(!human)
		return FALSE

	human.icon = CONTRACTOR_TRUE_FORM_ICON
	var/base_state = CONTRACTOR_TRUE_FORM_ICON_STATE
	var/form_gender = "f"
	switch(lowertext("[human.gender]"))
		if("male")
			form_gender = "m"
		if("female")
			form_gender = "f"
	var/datum/component/contractor/core = human.GetComponent(/datum/component/contractor)
	var/form_type = contractor_normalize_true_form_type(core?.true_form_type) || "1"
	human.icon_state = "[base_state]_[form_gender]_[form_type]"
	if(islist(human.overlays))
		human.overlays.Cut()
	if(islist(human.underlays))
		human.underlays.Cut()
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	return TRUE

/datum/species/contractor_trueform/update_damage_overlays(mob/living/carbon/human/human)
	
	
	
	return TRUE



