// THE GRIME-FLU CURE - craft recipe for alchemy station

/obj/item/reagent_containers/glass/bottle/rogue/grime_flu_cure
	list_reagents = list(/datum/reagent/medicine/grime_flu_cure = 50)

/datum/crafting_recipe/roguetown/alchemy/grime_flu_cure
	name = "The Grime-Flu cure"
	category = "Alchemy"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/grime_flu_cure = 1)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle/rogue = 1,
		/obj/item/alch/mentha = 1,
		/obj/item/alch/hypericum = 1,
		/datum/reagent/water = 50
	)
	craftdiff = 2
	verbage_simple = "mix"
