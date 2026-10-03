/datum/crafting_recipe/roguetown/structure/barricade
	name = "barricade"
	category = "Misc"
	result = /obj/structure/barricade/crude
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/grown/log/tree/stake = 1)
	verbage_simple = "construct"
	verbage = "constructs"
	doorcraft = TRUE
	windowcraft = TRUE
	ignoredensity = TRUE
	skillcraft = /datum/skill/craft/crafting

/datum/crafting_recipe/roguetown/structure/barricade/plank
	name = "barricade(plank)"
	category = "Misc"
	result = /obj/structure/barricade/crude
	reqs = list(/obj/item/natural/wood/plank = 2)
	verbage_simple = "construct"
	verbage = "constructs"
	doorcraft = TRUE
	windowcraft = TRUE
	ignoredensity = TRUE
	skillcraft = /datum/skill/craft/crafting
