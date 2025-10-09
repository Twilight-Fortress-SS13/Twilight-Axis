/datum/crafting_recipe/roguetown/leather/apothecary_gloves
	name = "apothecary gloves"
	result = /obj/item/clothing/gloves/roguetown/leather/apothecary
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/natural/fibers = 1
	)
	tools = list(/obj/item/needle)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/apothecary_overcoat
	name = "apothecary overcoat"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/apothecary
    reqs = list(/obj/item/natural/fibers = 1,
				/obj/item/natural/hide/cured = 4)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/apothecary_boots
	name = "apothecary boots"
	result = /obj/item/clothing/shoes/roguetown/apothboots
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/apothecary_mask
	name = "apothecary mask"
	result = /obj/item/clothing/mask/rogue/physician/apothecary
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
	tools = list(/obj/item/needle)

/datum/crafting_recipe/roguetown/leather/physician_gloves
	name = "physician gloves"
	result = /obj/item/clothing/gloves/roguetown/leather/phys
	reqs = list(
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/worms/leech = 1
	)
	tools = list(/obj/item/needle)
	craftdiff = 3

/datum/crafting_recipe/roguetown/leather/physician_mask
	name = "physician mask"
	result = /obj/item/clothing/mask/rogue/physician/head
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/natural/fibers = 1,/obj/item/natural/bone = 1)
	craftdiff = 2
	tools = list(/obj/item/needle)

