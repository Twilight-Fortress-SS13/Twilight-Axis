/datum/advclass/apothecary
	subclass_stashed_items = list(
		"Physician Mask" = /obj/item/clothing/mask/rogue/physician,
	)

/datum/outfit/job/roguetown/apothecary/basic/pre_equip(mob/living/carbon/human/H)
	..()
	if(!backpack_contents)
		backpack_contents = list()
	backpack_contents[/obj/item/clothing/mask/rogue/physician] = 1
