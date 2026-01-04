/datum/job/roguetown/prince/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(ishuman(H))
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/nobility = "Lord"
		if(should_wear_femme_clothes(H))
			nobility = "Lady"
		H.real_name = "[nobility] [prev_real_name]"
		H.name = "[nobility] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)
