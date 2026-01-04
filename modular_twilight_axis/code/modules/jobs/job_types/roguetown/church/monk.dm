/datum/job/roguetown/monk/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(ishuman(H))
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/churchiny = "Brother"
		if(should_wear_femme_clothes(H))
			churchiny = "Sister"
		H.real_name = "[churchiny] [prev_real_name]"
		H.name = "[churchiny] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)
