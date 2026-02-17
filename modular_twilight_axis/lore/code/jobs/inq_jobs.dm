/datum/job/roguetown/inquisitor
	allowed_races = RACES_TOLERATED_UP

/datum/outfit/job/roguetown/inquisitor/inspector/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(isdarkelf(H))
		mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed

/datum/outfit/job/roguetown/inquisitor/ordinator/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(isdarkelf(H))
		mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/psydoniantemplar/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(isdarkelf(H))
		mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/psyaltrist/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(isdarkelf(H))
		mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/absolver/basic/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(isdarkelf(H))
		mask = /obj/item/clothing/mask/rogue/facemask/steel/psythorns

/datum/outfit/job/roguetown/disciple/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(isdarkelf(H) && mask == /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns)
		mask = /obj/item/clothing/mask/rogue/facemask/steel/psythorns
