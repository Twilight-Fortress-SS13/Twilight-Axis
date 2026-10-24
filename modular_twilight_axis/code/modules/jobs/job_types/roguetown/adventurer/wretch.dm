/datum/job/roguetown/wretch/New()
	job_traits += list(TRAIT_OUTLANDER)
	job_subclasses += list(
		/datum/advclass/wretch/twilight_corsair,
		/datum/advclass/wretch/lunacyembracer,
		/datum/advclass/wretch/twilight_blood_raider,
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
		var/crimeschoice_baotha = input(H, "Who is me", "How much have I done?") as anything in crimes
		switch(crimeschoice_baotha)
			if("I'm nobody")
				to_chat(H, span_purple("Я хорошо скрывался, но и тренировался плохо..."))
			if("They fear me")
				if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
					H.put_in_hands(new /obj/item/clothing/mask/rogue/spectacles/inq)
					H.put_in_hands(new /obj/item/grapplinghook)
				wretch_select_bounty(H)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_INT, 1)
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
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 2)

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
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_SPD, 1)

/proc/bountychoice_blood_raider(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	if(istype(H.dna.species, /datum/species/elf/dark))
		switch(crimeschoice)
			if("I'm nobody")
				to_chat(H, span_warning("Моя прошлая жизнь не даёт мне покоя по ночам. Кошмары заставляют меня оглядываться назад чаще..."))
			if("They fear me")
				wretch_select_bounty(H)
				ADD_TRAIT(H, TRAIT_ANTHRAXI, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, 1)
				to_chat(H, span_warning("Они боятся меня. Моя ловкость и зоркость не подводили ни разу на рейдах мерзких чужеземцев."))
	else
		switch(crimeschoice)
			if("I'm nobody")
				to_chat(H, span_warning("Антракс идут по мою душу, я не могу быть уверенным в завтрашнем дне..."))
			if("They fear me")
				wretch_select_bounty(H)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("Приспособившись к новому оружию, мне стало легче избегать охотников за головой."))

/proc/bountychoice_freeblade(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_slasher(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_WIL, 1)

/proc/bountychoice_profane_champion(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_MASTER, TRUE)

/proc/bountychoice_pariah(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 0))

/proc/bountychoice_pyromaniac(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_SPD, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_PER, 1)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_MASTER, TRUE)

/proc/bountychoice_mistwalker(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_plaguebearer(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_SPD, 1)

/proc/bountychoice_outlaw(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 1)
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_LEGENDARY, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_LEGENDARY, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_LEGENDARY, TRUE)

/proc/bountychoice_necromancer(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_roguemage(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_PER, 1)
			H.mind.mage_aspect_config["minor"] += 1
			H.mind.mage_aspect_config["utility"] += 3
			H.mind.check_learnspell()

/proc/bountychoice_berserker(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_STR, 1)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 1)

/proc/bountychoice_deserter(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_WIL, 2)
			H.change_stat(STATKEY_PER, 1)

/proc/bountychoice_deserter_knight(mob/living/carbon/human/H)
	var/crimes = list("I'm nobody", "They fear me")
	var/crimeschoice = input(H, "Who is me", "How much have I done?") as anything in crimes
	switch(crimeschoice)
		if("I'm nobody")
			return
		if("They fear me")
			wretch_select_bounty(H)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_INT, 1)
