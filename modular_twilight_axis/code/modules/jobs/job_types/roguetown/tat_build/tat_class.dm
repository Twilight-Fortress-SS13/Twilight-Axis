/datum/job/roguetown/tat_class
	title = "Pliant Soul"
	f_title = "Pliant Soul"
	department_flag = SIDEFOLK
	flag = SIDEFOLK
	faction = "Station"

	total_positions = 10
	spawn_positions = 10

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS

	tutorial = "Pliant soul in the rough Psydonia. Who you are? Deside by yourself, this is YOUR Journey."
	display_order = JDO_MERCENARY
	selection_color = JCOLOR_WANDERER

	min_pq = 0
	max_pq = null
	round_contrib_points = 0

	outfit = /datum/outfit/job/roguetown/tat_class/basic
	outfit_female = /datum/outfit/job/roguetown/tat_class/basic

	always_show_on_latechoices = TRUE
	announce_latejoin = TRUE
	class_categories = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	bypass_lastclass = TRUE
	can_random = FALSE

	advclass_cat_rolls = list(CTAG_FREE_ROAM = 1)
	job_subclasses = list(/datum/advclass/tat_class)

/datum/job/roguetown/tat_class/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	return ..()

/datum/job/roguetown/tat_class/override_latejoin_spawn(mob/living/L)
	if(!L)
		return FALSE

	var/list/choices = list()
	for(var/obj/effect/landmark/start/adventurerlate/S in GLOB.start_landmarks_list)
		choices += S

	if(!length(choices))
		return FALSE

	var/obj/effect/landmark/start/adventurerlate/target = pick(choices)
	target.JoinPlayerHere(L, FALSE)
	return TRUE

/datum/advclass/tat_class
	name = "Pliant Soul"
	tutorial = "A freeform class used for the TAT build system."
	category_tags = list(CTAG_FREE_ROAM)

	subclass_stats = list()
	subclass_skills = list()
	traits_applied = list()

/datum/outfit/job/roguetown/tat_class
	name = "Pliant Soul"
	jobtype = /datum/job/roguetown/tat_class

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

	var/datum/preferences/P = H.client?.prefs
	if(!P?.tat_build)
		return

	// if(!P.tat_build?.can_save())
	// 	return

	relocate_tat_spawn(H, P.tat_build)
	P.tat_build.apply_to_human(H)

/datum/outfit/job/roguetown/tat_class/basic/proc/get_tat_spawn_turf(mob/living/carbon/human/H, datum/tat_build/build)
	if(!H || !build)
		return null

	// if(build.traits[TAT_TRAIT_RESIDENT])
	// 	if(length(SSjob.latejoin_trackers))
	// 		return pick(SSjob.latejoin_trackers)

	return null

/datum/outfit/job/roguetown/tat_class/basic/proc/relocate_tat_spawn(mob/living/carbon/human/H, datum/tat_build/build)
	if(!H || !build)
		return FALSE

	var/turf/T = get_tat_spawn_turf(H, build)
	if(!T)
		return FALSE

	H.forceMove(T)

/obj/effect/landmark/start/adventurerlate
	jobspawn_override = list("Pilgrim", "Adventurer", "Migrant", "Trader", "Pliant Soul")

/datum/job/roguetown/adventurer
	total_positions = 10 //На время тестов ТАТ - удалить позже (было 20)
	spawn_positions = 10 //На время тестов ТАТ - удалить позже (было 20)
