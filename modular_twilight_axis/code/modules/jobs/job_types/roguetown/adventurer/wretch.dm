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

/proc/bountychoice_heretic(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
		H.put_in_hands(new /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns)

/proc/bountychoice_hereticspy(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	if(HAS_TRAIT(H, TRAIT_PSYDONIAN_GRIT))
		H.put_in_hands(new /obj/item/clothing/mask/rogue/spectacles/inq)
		H.put_in_hands(new /obj/item/grapplinghook)

/proc/bountychoice_lunacy(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
	H.put_in_hands(new /obj/item/rogueweapon/handclaw(H))

/proc/bountychoice_blood_raider(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	if(istype(H.dna.species, /datum/species/elf/dark))
		ADD_TRAIT(H, TRAIT_ANTHRAXI, TRAIT_GENERIC)
		to_chat(H, span_warning("Они боятся меня. Моя ловкость и зоркость не подводили ни разу на рейдах мерзких чужеземцев."))
	else
		to_chat(H, span_warning("Приспособившись к новому оружию, мне стало легче избегать охотников за головой."))

/proc/bountychoice_profane_champion(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_MASTER, TRUE)

/proc/bountychoice_pariah(mob/living/carbon/human/H)
	H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 0))
	wretch_select_bounty(H)

/proc/bountychoice_pyromaniac(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_MASTER, TRUE)

/proc/bountychoice_outlaw(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_LEGENDARY, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_LEGENDARY, TRUE)

/proc/bountychoice_necromancer(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.mind.mage_aspect_config["minor"] += 1
	H.mind.mage_aspect_config["utility"] += 3
	H.mind.check_learnspell()

/proc/bountychoice_roguemage(mob/living/carbon/human/H)
	wretch_select_bounty(H)
	H.mind.mage_aspect_config["minor"] += 1
	H.mind.mage_aspect_config["utility"] += 3
	H.mind.check_learnspell()
