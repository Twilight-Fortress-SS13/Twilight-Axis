/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	grant_roundstart_faction_manuscript(H)
	resident_manuscript_place_resident_in_tavern(H)

/datum/virtue/utility/notable/New()
	. = ..()
	if(!resident_manuscripts_enabled())
		extra_choices = extra_choices.Copy()
		choice_tooltips = choice_tooltips.Copy()
		extra_choices -= "Residency"
		choice_tooltips.Remove("Residency")

/proc/resident_manuscript_is_resident_tavern_role(mob/living/carbon/human/recipient)
	if(!ishuman(recipient) || !recipient.mind)
		return FALSE
	var/datum/job/job = SSjob.GetJob(recipient.job || recipient.mind?.assigned_role)
	return istype(job, /datum/job/roguetown/adventurer) || istype(job, /datum/job/roguetown/mercenary)

/proc/resident_manuscript_find_resident_tavern_area()
	for(var/area/A in world)
		if(istype(A, /area/rogue/indoors/town/tavern))
			return A
	return null

/proc/resident_manuscript_is_valid_resident_tavern_turf(turf/T, use_dun_filter = FALSE, y_offset = 0)
	if(!T || T.density || T.is_blocked_turf(FALSE))
		return FALSE
	if(use_dun_filter && (T.z != 3 || T.y <= (234 + y_offset)))
		return FALSE
	return TRUE

/proc/resident_manuscript_place_resident_in_tavern(mob/living/carbon/human/recipient)
	if(!HAS_TRAIT(recipient, TRAIT_RESIDENT) || resident_manuscript_uses_dun_world_tavern_filter())
		return
	if(!resident_manuscript_uses_resident_tavern_spawn() || !resident_manuscript_is_resident_tavern_role(recipient))
		return
	var/area/spawn_area = resident_manuscript_find_resident_tavern_area()
	if(!spawn_area)
		return
	var/use_dun_filter = resident_manuscript_uses_dun_world_tavern_filter()
	var/list/possible_chairs = list()
	for(var/obj/structure/chair/C in spawn_area)
		var/turf/T = get_turf(C)
		if(istype(C, /obj/structure/chair/wood/rogue) && resident_manuscript_is_valid_resident_tavern_turf(T, use_dun_filter))
			possible_chairs += C
	if(length(possible_chairs))
		var/obj/structure/chair/chosen_chair = pick(possible_chairs)
		recipient.forceMove(get_turf(chosen_chair))
		chosen_chair.buckle_mob(recipient)
		to_chat(recipient, span_notice("Как житель города, вы оказываетесь на стуле в местной таверне."))
		return
	var/list/possible_spawns = list()
	for(var/turf/T in spawn_area)
		if(resident_manuscript_is_valid_resident_tavern_turf(T, use_dun_filter, 4))
			possible_spawns += T
	if(length(possible_spawns))
		var/turf/spawn_loc = pick(possible_spawns)
		recipient.forceMove(spawn_loc)
		to_chat(recipient, span_notice("Как житель города, вы оказываетесь в местной таверне."))
