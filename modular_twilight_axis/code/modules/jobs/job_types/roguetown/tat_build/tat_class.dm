/datum/job/roguetown/tat_class
	title = "Free roam"
	department_flag = PEASANTS
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	tutorial = "Free roam."
	display_order = JDO_MERCENARY
	selection_color = JCOLOR_WANDERER
	min_pq = 0
	max_pq = null
	round_contrib_points = null
	outfit = null
	outfit_female = null
	job_traits = list(TRAIT_STEELHEARTED)
	always_show_on_latechoices = TRUE
	class_categories = FALSE

/datum/job/roguetown/tat_class/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()
	if(!L || !ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(!H.mind)
		return

	var/datum/preferences/P
	if(H.client?.prefs)
		P = H.client.prefs
	else if(M?.client?.prefs)
		P = M.client.prefs

	if(!P?.tat_build)
		return

	if(!P.tat_build.can_save())
		P.sanitize_tat_build(P.tat_build.export_to_list())

	if(!P.tat_build?.can_save())
		return

	P.tat_build.apply_to_human(H)
