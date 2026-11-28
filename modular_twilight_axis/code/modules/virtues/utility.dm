/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(visualsOnly)
		return
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(resident_manuscript_grant_deferred), H)

/proc/resident_manuscript_grant_deferred(mob/living/carbon/human/H)
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

/datum/virtue/utility/noble
	desc = "By birth, blade or brain, I am noble known to the royalty of these lands, and have all the benefits associated with it. \
	I've cleverly stashed away a healthy amount of coinage, alongside a familial heirloom.<br><br>\
	Высокое положение обязывает: чем выше мой достаток, \
	тем взыскательнее я отношусь к одежде, столу и домашним удобствам.<br><br>\
	Если должность позволяет выбрать положение, я могу стать мелким дворянином, богатым дворянином \
	или представителем высшей аристократии за 0, 20 или 40 триумфов соответственно.<br>\
	Выбрав Nobility дважды, я получаю первые два варианта бесплатно, а высшее положение обойдётся в 20 триумфов.<br><br>\
	Если дворянство уже положено мне по должности, я сохраняю её ранг и получаю выбранную семейную реликвию. \
	Для остальных дворцовых должностей доступно лишь мелкое дворянство."
	stackable = TRUE

/datum/virtue/utility/noble/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!HAS_TRAIT(recipient, TRAIT_OUTLAW))
		recipient.taApplyNobilityVirtue()

/mob/living/carbon/human/proc/taApplyNobilityVirtue()
	if(!mind)
		return
	mind.ta_nobility_virtue_picks = min(2, mind.ta_nobility_virtue_picks + 1)
	if(isnull(taRoleNobilityTier()))
		taPrepareNobility()
