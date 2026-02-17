// PLAGUE CURE: reagent container + alchemical cauldron recipe

/obj/item/reagent_containers/glass/bottle/alchemical/plague_cure
	name = "bottle of Plague Cure"
	list_reagents = list(/datum/reagent/medicine/plague_cure = 50)
	desc = "A glass bottle containing a potent Plague Cure. Must be consumed before cauterization."

/datum/alch_cauldron_recipe/plague_cure
	name = "Plague Cure"
	smells_like = "sour herbs and iron"
	skill_required = SKILL_LEVEL_MASTER
	output_reagents = list(/datum/reagent/medicine/plague_cure = 50)

// Optional crafting recipe to produce an already-filled bottle (legacy support)
/datum/crafting_recipe/roguetown/alchemy/plague_cure
	name = "Plague Cure (bottle)"
	category = "Alchemy"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/plague_cure = 1)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle/rogue = 1,
		/obj/item/rogueore/gold = 5,
		/obj/item/alch/hypericum = 1,
		/datum/reagent/water = 50,
		/obj/item/organ/heart = 1
	)
	craftdiff = 4
	skillcraft = /datum/skill/craft/alchemy
	verbage_simple = "mix"
