/datum/job/roguetown/inquisitor/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(/datum/advclass/inquisitor/blackpowder)
	. = ..()

/datum/job/roguetown/inquisitor/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(ishuman(H))
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/inq = "Magister"
		H.real_name = "[inq] [prev_real_name]"
		H.name = "[inq] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)
