/proc/get_client_active_tat_build(client/C)
	if(!C?.prefs)
		return null

	return C.prefs.tat_build

/proc/client_can_use_tat_role_bucket(client/C, required_bucket)
	if(!required_bucket)
		return TRUE

	if(!C?.ckey)
		return FALSE

	if(tat_is_role_bucket_locked(C.ckey, required_bucket))
		return FALSE

	return TRUE

/proc/human_can_use_tat_role_bucket(mob/living/carbon/human/H, required_bucket)
	if(!required_bucket)
		return TRUE

	if(!H)
		return FALSE

	var/key = H.ckey || H.client?.ckey
	if(!key)
		return FALSE

	if(tat_is_role_bucket_locked(key, required_bucket))
		return FALSE

	return TRUE

/proc/client_has_tat_role_bucket(client/C, required_bucket)
	if(!required_bucket)
		return TRUE

	if(!client_can_use_tat_role_bucket(C, required_bucket))
		return FALSE

	var/datum/tat_build/build = get_client_active_tat_build(C)
	if(!build)
		return FALSE

	if(!build.can_save())
		return FALSE

	return build.get_role_bucket() == required_bucket

/proc/tat_build_has_role_bucket(datum/tat_build/build, required_bucket)
	if(!required_bucket)
		return TRUE

	if(!build)
		return FALSE

	if(!build.can_save())
		return FALSE

	return build.get_role_bucket() == required_bucket

/proc/human_has_tat_role_bucket(mob/living/carbon/human/H, required_bucket)
	if(!required_bucket)
		return TRUE

	if(!human_can_use_tat_role_bucket(H, required_bucket))
		return FALSE

	if(H?.active_tat_build)
		return tat_build_has_role_bucket(H.active_tat_build, required_bucket)

	if(!H?.client)
		return FALSE

	return client_has_tat_role_bucket(H.client, required_bucket)

/proc/get_human_active_tat_build(mob/living/carbon/human/H)
	if(!H)
		return null

	if(H.client)
		H.active_tat_build = get_client_active_tat_build(H.client)

	return H.active_tat_build

/mob/living/carbon/human
	var/datum/tat_build/active_tat_build = null
	var/tat_build_pre_client_applied = FALSE
	var/tat_build_post_client_applied = FALSE

/datum/advclass/tat_class
	name = "Pliant Soul"
	tutorial = "A freeform class used for the TAT build system."

	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/tat_class/basic

	subclass_stats = list()
	subclass_skills = list()
	traits_applied = list()

	var/required_tat_bucket = null

/datum/advclass/tat_class/check_requirements(mob/living/carbon/human/H)
	var/key = H?.ckey || H?.client?.ckey
	if(key)
		tat_refresh_ban_cache_for_ckey(key)

	if(!..())
		return FALSE

	if(!human_can_use_tat_role_bucket(H, required_tat_bucket))
		return FALSE

	return human_has_tat_role_bucket(H, required_tat_bucket)

/datum/advclass/tat_class/towner
	name = "Pliant Towner"
	tutorial = "A custom-built local resident of Psydonia. Your home, work, and place among the townfolk are defined by your active TAT build."

	category_tags = list(CTAG_TOWNER)
	required_tat_bucket = TAT_ROLE_BUCKET_TOWNER

/datum/advclass/tat_class/trader
	name = "Pliant Trader"
	tutorial = "A custom-built traveler, supplier, artisan, or free tradesoul. This path is for TAT builds without resident, wanted, or outlander status."

	category_tags = list(CTAG_TRADER)
	class_select_category = CLASS_CAT_TRADER
	required_tat_bucket = TAT_ROLE_BUCKET_TRADER

/datum/advclass/tat_class/adventurer
	name = "Pliant Adventurer"
	tutorial = "A custom-built wanderer-outlander, or dangerous free soul. This path is for TAT builds with Outlander."

	class_select_category = CLASS_CAT_NOMAD
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	required_tat_bucket = TAT_ROLE_BUCKET_ADVENTURER

/datum/advclass/tat_class/wretch
	name = "Pliant Wretch"
	tutorial = "A custom-built outlaw, a nightmare free soul. This path is for TAT builds with Wanted."

	class_select_category = CLASS_CAT_NOMAD
	category_tags = list(CTAG_WRETCH)
	required_tat_bucket = TAT_ROLE_BUCKET_WRETCH

/datum/outfit/job/roguetown/tat_class
	name = "Pliant Soul"

/datum/outfit/job/roguetown/tat_class/basic/pre_equip(mob/living/carbon/human/H)
	..()

/datum/outfit/job/roguetown/tat_class/basic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return

	if(!H || !H.mind)
		return

	apply_tat_build_pre_client(H)

/datum/outfit/job/roguetown/tat_class/basic/proc/apply_tat_build_pre_client(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	if(H.tat_build_pre_client_applied)
		addtimer(CALLBACK(src, PROC_REF(apply_tat_build_post_client), H), 10)
		return

	var/datum/tat_build/build = get_human_active_tat_build(H)
	if(!build)
		addtimer(CALLBACK(src, PROC_REF(apply_tat_build_pre_client), H), 10)
		return

	if(!build.can_save())
		return

	if(!build.apply_pre_client_to_human(H))
		return

	H.tat_build_pre_client_applied = TRUE

	addtimer(CALLBACK(src, PROC_REF(apply_tat_build_post_client), H), 10)

/datum/outfit/job/roguetown/tat_class/basic/proc/apply_tat_build_post_client(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	if(H.tat_build_post_client_applied)
		return

	if(!H.client)
		addtimer(CALLBACK(src, PROC_REF(apply_tat_build_post_client), H), 10)
		return

	var/datum/tat_build/build = get_human_active_tat_build(H)
	if(!build)
		return

	if(!build.can_save())
		return

	if(!build.apply_post_client_to_human(H))
		return

	H.tat_build_post_client_applied = TRUE
