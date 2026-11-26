/datum/crafting_recipe/roguetown/artillery
	abstract_type = /datum/crafting_recipe/roguetown/artillery/
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/artillery/mortar_wheel
	name = "mortar carriage wheel"
	result = /obj/item/mortar_wheel
	reqs = list(/obj/item/grown/log/tree/stick = 4, /obj/item/grown/log/tree/small = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	craftdiff = 1

/datum/crafting_recipe/roguetown/artillery/mortar_base
	name = "mortar carriage"
	result = /obj/item/artillery_assembly/mortar
	reqs = list(/obj/item/grown/log/tree/small = 4, /obj/item/grown/log/tree = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	craftdiff = 1

/datum/crafting_recipe/roguetown/artillery/finish_mortar
	name = "assemble mortar"
	result = /obj/structure/artillery/mortar
	reqs = list(/obj/item/mortar_wheel = 4, /obj/item/mortar_barrel  = 1, /obj/item/artillery_assembly/mortar = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	craftdiff = 0


///////////////////////////////////////////////////////////////////////
/// Говно артифишера
/// Плацебо, проще купить у торговца, но игроки попросили
//////////////////////////////////////////////////////////////////////
/obj/item/artillery_barrel_assembly
	name = "artillery barrel blank"
	desc = "Можно специализировать для конкретной артиллерии"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "barrel"
	color = "#5c524b"
	sellprice = 50

/obj/item/mortar_barrel_assembly
	name = "mortar barrel blank"
	desc = "Тщательная полировки и будет готово"
	icon = 'modular_twilight_axis/awful_artillery/icons/artillery.dmi'
	icon_state = "barrel"
	color = "#96745e"

/datum/anvil_recipe/engineering/artillery/mortar_barrel_from_universal
	name = "Artillery Barrel Blank "
	req_bar = /obj/item/ingot/steel
	additional_items = list(/obj/item/artillery_barrel_assembly)
	created_item = /obj/item/mortar_barrel_assembly
	createditem_num = 1
	craftdiff = 6

/datum/anvil_recipe/engineering/artillery
	category = "Artillery"

/datum/anvil_recipe/engineering/artillery/mortar_barrel
	name = "Mortar Barrel Blank, (+9 Blacksteel)"
	req_bar = /obj/item/ingot/blacksteel
	additional_items = list(/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel,/obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel, /obj/item/ingot/blacksteel)
	created_item = /obj/item/mortar_barrel_assembly
	createditem_num = 1
	craftdiff = 6
	max_progress = 1000

/datum/crafting_recipe/roguetown/artillery/polish_mortar_barrel
	name = "finish mortar barrel"
	result = /obj/item/mortar_barrel
	reqs = list(/obj/item/mortar_barrel_assembly = 1)
	tools = list(/obj/item/natural/cloth)
	verbage_simple = "polish"
	verbage = "polishes"
	craftdiff = 4
	time = 60 SECONDS
