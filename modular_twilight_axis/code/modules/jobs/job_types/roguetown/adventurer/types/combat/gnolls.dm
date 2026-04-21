/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/invisibility/gnoll)

/datum/outfit/job/roguetown/gnoll/knight/pre_equip(mob/living/carbon/human/H)
	..()


