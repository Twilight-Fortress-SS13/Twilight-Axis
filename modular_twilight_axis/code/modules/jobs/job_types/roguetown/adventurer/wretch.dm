/datum/job/roguetown/wretch/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/wretch/twilight_corsair,
		/datum/advclass/wretch/lunacyembracer,
		/datum/advclass/wretch/gudsklor,
		/datum/advclass/wretch/thehero,
	)
	. = ..()

/proc/bountychoice_poacher(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			H.change_stat(STATKEY_CON, -1)
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_spellblade(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			GLOB.excommunicated_players += H.real_name
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_heretic(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	if(H.patron?.type == /datum/patron/inhumen/baotha)
		H.change_stat(STATKEY_WIL, -1)
		to_chat(H, span_purple("'Я менял свой образ так много раз, что сам уже не помню кем я был....'"))
		return
	else
		var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
		switch(crimeschoice)
			if("I'm nobody")
				GLOB.excommunicated_players += H.real_name
			if("They fear me")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					H.put_in_hands(new /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns)
				wretch_select_bounty(H)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_hereticspy(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	if(H.patron?.type == /datum/patron/inhumen/baotha)
		H.change_stat(STATKEY_SPD, -1)
		to_chat(H, span_purple("'Я менял свой образ так много раз, что сам уже не помню кем я был....'"))
	else
		var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
		switch(crimeschoice)
			if("I'm nobody")
				GLOB.excommunicated_players += H.real_name
			if("They fear me")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					H.put_in_hands(new /obj/item/clothing/mask/rogue/spectacles/inq)
					H.put_in_hands(new /obj/item/grapplinghook)
				wretch_select_bounty(H)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_INT, 1)

/proc/bountychoice_vigilante(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)								

/proc/bountychoice_lunacy(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			GLOB.excommunicated_players += H.real_name
		if("They fear me")
			H.put_in_hands(new /obj/item/rogueweapon/handclaw(H))
			wretch_select_bounty(H)						
			H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
			H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
