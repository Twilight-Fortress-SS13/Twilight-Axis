/datum/job/roguetown/lord/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	..()
	if(!latejoin && ishuman(H))
		SSticker.taRegisterInitialDuke(H)
	if(ishuman(H))
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/nobility = "Duke"
		if(SSmapping.config.map_name == "Rockhill")
			nobility = "King"
			if(H.titles_pref == TITLES_F)
				nobility = "Queen"
		else
			nobility = "Duke"
			if(H.titles_pref == TITLES_F)
				nobility = "Duchess"
		H.real_name = "[nobility] [prev_real_name]"
		H.name = "[nobility] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/advclass/lord/merchant
	noble_income = 550

/obj/effect/proc_holder/spell/self/grant_nobility/grant_nobility(
	mob/living/carbon/human/recruit,
	mob/living/carbon/human/recruiter,
)
	if(QDELETED(recruit) || !recruit.mind)
		return FALSE
	. = ..()
	if(!.)
		return
	if(isnull(recruit.mind.ta_nobility_tier) \
		&& !recruit.mind.ta_nobility_pending)
		recruit.mind.ta_nobility_tier = 1
	recruit.taRefreshNobleRoleActions()
