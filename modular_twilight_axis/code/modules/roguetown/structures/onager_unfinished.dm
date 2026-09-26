/obj/structure/multistage/onager_unfinished
	name = "unfinished onager"
	desc = "A skeleton of an onager. It is missing a few key components."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/oneger/onager_unfinished.dmi'
	icon_state = "build_stage_0"
	base_desc = "An unfinished onager."

	stage_types = list(
		/datum/crafting_stage/onager/stage_1,
		/datum/crafting_stage/onager/stage_2,
		/datum/crafting_stage/onager/stage_3
	)
	final_product_type = /obj/structure/onager


/datum/crafting_stage/onager
	var/recipe_type

/datum/crafting_stage/onager/stage_1
	icon_state = "build_stage_1"
	description = "\nRequired: 3 iron ingots. (Hammer, Engineering)"
	recipe = /datum/crafting_recipe/onager_internal/stage_1

/datum/crafting_stage/onager/stage_2
	icon_state = "build_stage_2"
	description = "\nRequired: 5 ropes, 3 bronze cogs. (Hammer, Engineering)"
	recipe = /datum/crafting_recipe/onager_internal/stage_2

/datum/crafting_stage/onager/stage_3
	icon_state = "build_stage_3"
	description = "\nRequired: 2 steel ingots. (Hammer, Engineering)"
	recipe = /datum/crafting_recipe/onager_internal/stage_3

/datum/crafting_recipe/roguetown/engineering/onager_base
	name = "unfinished onager"
	category = "Machines"
	result = /obj/structure/multistage/onager_unfinished
	reqs = list(/obj/item/natural/stone = 10, /obj/item/natural/wood/plank = 10)
	tools = list(/obj/item/rogueweapon/hammer = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3


/datum/crafting_recipe/onager_internal
	name = "" 
	hides_from_books = TRUE
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/hammer = 1)

/datum/crafting_recipe/onager_internal/stage_1
	reqs = list(/obj/item/ingot/iron = 3)
	craftdiff = 2

/datum/crafting_recipe/onager_internal/stage_2
	
	reqs = list(/obj/item/rope = 5, /obj/item/roguegear = 3) 
	craftdiff = 3

/datum/crafting_recipe/onager_internal/stage_3
	reqs = list(/obj/item/ingot/steel = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/boulder
	name = "boulder"
	category = "Ranged"
	result = /obj/item/boulder
	reqs = list(/obj/item/natural/stone = 10)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2
