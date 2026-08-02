/mob/living/carbon/human
	var/image/scent_image

/mob/living/carbon/human/proc/is_werewolf_infected()
	for(var/datum/wound/W in simple_wounds)
		if(W.werewolf_infection_timer)
			return TRUE
	for(var/obj/item/bodypart/BP in bodyparts)
		for(var/datum/wound/W in BP.wounds)
			if(W.werewolf_infection_timer)
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/create_scent_image()

	if(scent_image)
		return

	if(mind && mind.has_antag_datum(/datum/antagonist/werewolf))
		return

	if(is_werewolf_infected())
		return
	
	scent_image = image('icons/effects/effects.dmi', src, "mist")
	scent_image.plane = 19
	scent_image.layer = 19
	scent_image.alpha = 180
	scent_image.color = "#8a2be2"
	scent_image.appearance_flags = RESET_ALPHA | RESET_COLOR
	
	add_scent_to_werewolves()

/mob/living/carbon/human/proc/add_scent_to_werewolves()
	if(!scent_image)
		return
	for(var/mob/living/L in get_active_werewolves())
		if(L.client)
			L.client.images |= scent_image

/mob/living/carbon/human/proc/remove_scent_from_all()
	if(!scent_image)
		return
	for(var/mob/living/L in get_active_werewolves())
		if(L.client)
			L.client.images -= scent_image

/proc/get_active_werewolves()
	var/list/werewolves = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && H.mind.has_antag_datum(/datum/antagonist/werewolf))
			if(istype(H, /mob/living/carbon/human/species/werewolf))
				werewolves += H
	return werewolves

/mob/living/carbon/human/proc/clear_scent_image()
	if(scent_image)
		qdel(scent_image)
		scent_image = null

/mob/living/carbon/human/proc/has_scent_image()
	return !isnull(scent_image)
