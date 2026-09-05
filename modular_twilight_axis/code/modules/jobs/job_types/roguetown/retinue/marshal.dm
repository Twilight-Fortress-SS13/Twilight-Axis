/datum/job/roguetown/marshal/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(ishuman(H))
		if(SSmapping.config.map_name == "Desert Town")
			var/prev_real_name = H.real_name
			var/prev_name = H.name
			var/nobility = "Mushir"
			if(H.titles_pref == TITLES_F)
				nobility = "Mushirah"
			H.real_name = "[nobility] [prev_real_name]"
			H.name = "[nobility] [prev_name]"

			for(var/X in peopleknowme)
				for(var/datum/mind/MF in get_minds(X))
					if(MF.known_people)
						MF.known_people -= prev_real_name
						H.mind.person_knows_me(MF)
		else
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
	var/client/player = H?.client
	if(player?.prefs)
		if(SSmapping.config.map_name == "Desert Town")
			if(!istype(player.prefs.virtue_origin, /datum/virtue/origin/raneshen) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/naledi) && !istype(player.prefs.virtue_origin, /datum/virtue/origin/zybantian))
				var/list/new_origins = list("Raneshen" = /datum/virtue/origin/raneshen, 
				"Naledi" = /datum/virtue/origin/naledi,
				"Zybantu" = /datum/virtue/origin/zybantian)
				var/new_origin
				var/choice = input(player, "Your origins are not compatible with the Sultanate. Where do you hail from?", "ANCESTRY") as anything in new_origins
				if(choice)
					new_origin = new_origins[choice]
				else
					to_chat(player, span_notice("No choice detected. Picking a random compatible origin."))
					new_origin = pick(/datum/virtue/origin/raneshen, /datum/virtue/origin/naledi, /datum/virtue/origin/zybantian)
				var/datum/virtue/origin/applied_origin = new new_origin()
				player.prefs.virtue_origin = applied_origin
				apply_virtue(H, applied_origin)
