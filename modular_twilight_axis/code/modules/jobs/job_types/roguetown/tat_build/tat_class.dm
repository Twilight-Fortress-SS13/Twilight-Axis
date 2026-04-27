/proc/get_client_active_tat_build(client/C)
	if(!C?.prefs)
		return null

	return C.prefs.tat_build

/proc/client_has_tat_role_bucket(client/C, required_bucket)
	if(!required_bucket)
		return TRUE

	var/datum/tat_build/build = get_client_active_tat_build(C)
	if(!build)
		return FALSE

	if(!build.can_save())
		return FALSE

	return build.get_role_bucket() == required_bucket

/proc/human_has_tat_role_bucket(mob/living/carbon/human/H, required_bucket)
	if(!H?.client)
		return FALSE

	return client_has_tat_role_bucket(H.client, required_bucket)

/proc/get_human_active_tat_build(mob/living/carbon/human/H)
	if(!H?.client)
		return null

	return get_client_active_tat_build(H.client)

/datum/advclass/tat_class
	name = "Pliant Soul"
	tutorial = "A freeform class used for the TAT build system."

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

	outfit = /datum/outfit/job/roguetown/tat_class/basic

	subclass_stats = list()
	subclass_skills = list()
	traits_applied = list()

	maximum_possible_slots = 20

	same_job_respawn_delay = FALSE
	var/required_tat_bucket = null

/datum/advclass/tat_class/check_requirements(mob/living/carbon/human/H)
	if(!..())
		return FALSE

	return human_has_tat_role_bucket(H, required_tat_bucket)

/datum/advclass/tat_class/towner
	name = "Pliant Towner"
	tutorial = "A custom-built local resident of Psydonia. Your home, work, and place among the townfolk are defined by your active TAT build."

	category_tags = list(CTAG_TOWNER)
	required_tat_bucket = TAT_ROLE_BUCKET_TOWNER

	maximum_possible_slots = 20


/datum/advclass/tat_class/trader
	name = "Pliant Trader"
	tutorial = "A custom-built traveler, supplier, artisan, or free tradesoul. This path is for TAT builds without resident, wanted, or outlander status."

	category_tags = list(CTAG_TRADER)
	class_select_category = CLASS_CAT_TRADER
	required_tat_bucket = TAT_ROLE_BUCKET_TRADER

	maximum_possible_slots = 20

/datum/advclass/tat_class/adventurer
	name = "Pliant Adventurer"
	tutorial = "A custom-built wanderer, outlaw, outlander, or dangerous free soul. This path is for TAT builds with Wanted or Outlander."

	category_tags = list(CTAG_ADVENTURER)
	required_tat_bucket = TAT_ROLE_BUCKET_ADVENTURER

	maximum_possible_slots = 20

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

	addtimer(CALLBACK(src, PROC_REF(apply_tat_build_post_spawn), H), 10)

/datum/outfit/job/roguetown/tat_class/basic/proc/apply_tat_build_post_spawn(mob/living/carbon/human/H)
	if(!H || !H.mind)
		return

	if(!H.client)
		addtimer(CALLBACK(src, PROC_REF(apply_tat_build_post_spawn), H), 10)
		return

	var/datum/tat_build/build = get_human_active_tat_build(H)
	if(!build)
		return

	if(!build.can_save())
		return

	if(!human_has_tat_role_bucket(H, build.get_role_bucket()))
		return

	build.apply_to_human(H)
