/datum/anvil_recipe/metal_food
	abstract_type = /datum/anvil_recipe/metal_food
	appro_skill = /datum/skill/craft/blacksmithing
	i_type = "Food"

/datum/anvil_recipe/metal_food/iron
	name = "Wafers, Iron"
	category = "Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/reagent_containers/food/snacks/metal/iron
	craftdiff = SKILL_LEVEL_APPRENTICE

/datum/anvil_recipe/metal_food/steel
	name = "Wafers, Steel"
	category = "Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/reagent_containers/food/snacks/metal/steel
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/metal_food/bronze
	name = "Wafers, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/reagent_containers/food/snacks/metal/bronze
	craftdiff = SKILL_LEVEL_NOVICE

/datum/anvil_recipe/metal_food/silver
	name = "Wafers, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/reagent_containers/food/snacks/metal/silver
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/metal_food/gold
	name = "Wafers, Gold"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/reagent_containers/food/snacks/metal/gold
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/metal_food/blacksteel
	name = "Wafers, Blacksteel"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/reagent_containers/food/snacks/metal/blacksteel
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/metal_food/silverblessed
	name = "Wafers, Blessed Silver"
	category = "Blessed Silver"
	req_bar = /obj/item/ingot/silverblessed
	created_item = /obj/item/reagent_containers/food/snacks/metal/silverblessed
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/metal_food/steelholy
	name = "Wafers, Holy Steel"
	category = "Holy Steel"
	req_bar = /obj/item/ingot/steelholy
	created_item = /obj/item/reagent_containers/food/snacks/metal/steelholy
	craftdiff = SKILL_LEVEL_MASTER

/datum/anvil_recipe/metal_food/crackers
	name = "Gilded Steel Crackers (+1 Gold)"
	category = "Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/reagent_containers/food/snacks/metal/crackers
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/ingot/gold)
