/datum/outfit/job/roguetown/guildsman/artificer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/twilight_firearms, 2, TRUE)
