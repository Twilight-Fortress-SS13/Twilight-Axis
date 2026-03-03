/datum/erp_actor/human
	parent_type = /datum/erp_actor/mob

/datum/erp_actor/human/New(atom/A)
	var/mob/living/carbon/human/H = A
	if(!istype(H))
		qdel(src)
		return
	. = ..(A)

/// Returns the underlying human mob.
/datum/erp_actor/human/proc/get_human()
	var/mob/living/carbon/human/H = physical
	return istype(H) ? H : null

/// Collects sex organs from human bodyparts and internal organs.
/datum/erp_actor/human/collect_organs()
	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return

	_collect_bodypart_organs(H)
	_collect_internal_organs(H)

/// Collects sex organs attached to bodyparts.
/datum/erp_actor/human/proc/_collect_bodypart_organs(mob/living/carbon/human/H)
	var/obj/item/bodypart/head/HD = H.get_bodypart(BODY_ZONE_HEAD)
	if(HD?.sex_organ)
		add_organ(HD.sex_organ)

	var/obj/item/bodypart/chest/CH = H.get_bodypart(BODY_ZONE_CHEST)
	if(CH?.sex_organ)
		add_organ(CH.sex_organ)

	var/obj/item/bodypart/l_arm/LA = H.get_bodypart(BODY_ZONE_L_ARM)
	if(LA?.sex_organ)
		add_organ(LA.sex_organ)

	var/obj/item/bodypart/r_arm/RA = H.get_bodypart(BODY_ZONE_R_ARM)
	if(RA?.sex_organ)
		add_organ(RA.sex_organ)

	if(!H.is_lamia_taur())
		var/obj/item/bodypart/l_leg/LL = H.get_bodypart(BODY_ZONE_L_LEG)
		if(LL?.sex_organ)
			add_organ(LL.sex_organ)

		var/obj/item/bodypart/r_leg/RL = H.get_bodypart(BODY_ZONE_R_LEG)
		if(RL?.sex_organ)
			add_organ(RL.sex_organ)

/// Collects sex organs attached to internal organs.
/datum/erp_actor/human/proc/_collect_internal_organs(mob/living/carbon/human/H)
	for(var/obj/item/organ/O in H.internal_organs)
		if(O?.sex_organ)
			add_organ(O.sex_organ)

/// Adds species-specific organs (lamia tail, etc).
/datum/erp_actor/human/collect_species_overrides()
	..()

	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return

	if(H.is_lamia_taur())
		var/datum/erp_sex_organ/tail/T = get_or_create_tail_organ()
		if(!(T in organs))
			add_organ(T)

/// Returns an existing TAIL organ or creates a new one.
/datum/erp_actor/human/proc/get_or_create_tail_organ()
	for(var/datum/erp_sex_organ/O in organs)
		if(O.erp_organ_type == SEX_ORGAN_TAIL)
			return O

	var/datum/erp_sex_organ/tail/T = new(physical)
	T.erp_organ_type = SEX_ORGAN_TAIL
	return T

/// Returns TRUE if human is physically restrained.
/datum/erp_actor/human/is_restrained(organ_flags = null)
	var/mob/living/carbon/human/H = get_human()
	return H ? H.is_physically_restrained(organ_flags) : FALSE

/// Returns TRUE if human has a worn kink tag.
/datum/erp_actor/human/has_kink_tag(kink_typepath)
	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return FALSE

	var/list/L = H.get_worn_kink_tags()
	return !!L?[kink_typepath]

/// Returns TRUE if human has large breasts.
/datum/erp_actor/human/has_big_breasts()
	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return FALSE

	var/obj/item/organ/breasts/B = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B || !isnum(B.breast_size))
		return FALSE

	return B.breast_size >= BREAST_SIZE_LARGE

/// Returns TRUE if this scene is dullahan-specific for the human.
/datum/erp_actor/human/is_dullahan_scene()
	var/mob/living/carbon/human/H = get_human()
	return H ? H.is_dullahan_head_partner() : FALSE

/// Returns highest grab state the human has on another actor's mob.
/datum/erp_actor/human/get_highest_grab_state_on(datum/erp_actor/other)
	var/mob/living/carbon/human/A = get_human()
	if(!A)
		return -1

	var/mob/living/B = other?.get_mob()
	if(!istype(B))
		return -1

	var/state = A.get_highest_grab_state_on(B)
	if(isnull(state))
		return -1

	return state

/// Adds stamina to the underlying human.
/datum/erp_actor/human/stamina_add(delta)
	var/mob/living/carbon/human/H = get_human()
	if(H)
		H.stamina_add(delta)

/// Normalizes zones that might be missing due to removed bodyparts.
/datum/erp_actor/human/normalize_target_zone(zone, datum/erp_actor/other_actor)
	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return zone

	if(zone in list(
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_PRECISE_L_FOOT
	))
		if(!(H.get_bodypart(BODY_ZONE_R_LEG) || H.get_bodypart(BODY_ZONE_L_LEG)))
			return BODY_ZONE_CHEST

	if(zone in list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_R_INHAND,
		BODY_ZONE_PRECISE_L_INHAND
	))
		if(!(H.get_bodypart(BODY_ZONE_R_ARM) || H.get_bodypart(BODY_ZONE_L_ARM)))
			return BODY_ZONE_CHEST

	if(zone in list(
		BODY_ZONE_HEAD,
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_PRECISE_EARS,
		BODY_ZONE_PRECISE_R_EYE,
		BODY_ZONE_PRECISE_L_EYE,
		BODY_ZONE_PRECISE_NOSE,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_PRECISE_NECK
	))
		if(!H.get_bodypart(BODY_ZONE_HEAD))
			return BODY_ZONE_CHEST

	return zone

/// Returns whether an organ type is accessible for interaction without forcing.
/datum/erp_actor/human/is_organ_accessible_for(datum/erp_actor/by_actor, organ_type, allow_force = FALSE)
	var/mob/living/carbon/human/target = get_human()
	if(!target || !organ_type)
		return TRUE

	if(allow_force)
		return TRUE

	if(organ_type == SEX_ORGAN_HANDS)
		return TRUE

	var/zone = _organ_type_to_bodyzone(organ_type)
	if(!zone)
		return TRUE

	return get_location_accessible(target, zone)

/// Maps organ type to a bodyzone used by clothing/access checks.
/datum/erp_actor/human/proc/_organ_type_to_bodyzone(organ_type)
	switch(organ_type)
		if(SEX_ORGAN_PENIS, SEX_ORGAN_VAGINA, SEX_ORGAN_ANUS)
			return BODY_ZONE_PRECISE_GROIN
		if(SEX_ORGAN_BREASTS)
			return BODY_ZONE_CHEST
		if(SEX_ORGAN_MOUTH)
			return BODY_ZONE_PRECISE_MOUTH
	return null

/// Returns TRUE if human has testicles.
/datum/erp_actor/human/has_testicles()
	var/mob/living/carbon/human/H = get_human()
	if(!H)
		return FALSE

	var/obj/item/organ/testicles/T = H.getorganslot(ORGAN_SLOT_TESTICLES)
	return !!T

/// Human actors can register signals.
/datum/erp_actor/human/can_register_signals()
	return TRUE
