/datum/asset/spritesheet_batched/character_setup_hair_icons
	parent_type = /datum/asset/spritesheet
	name = "character_setup_hair_icons"

/datum/asset/spritesheet_batched/character_setup_hair_icons/create_spritesheets()
	var/list/ids = list()
	for(var/choice_type as anything in subtypesof(/datum/customizer_choice))
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(choice_type)
		if(!choice || !ispath(choice.customizer_entry_type, /datum/customizer_entry/hair))
			continue
		for(var/accessory_type as anything in choice.sprite_accessories)
			var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
			if(!accessory?.icon || isnull(accessory.icon_state))
				continue
			var/id = sanitize_css_class_name("[accessory_type]")
			if(id in ids)
				continue
			ids += id
			Insert(id, accessory.icon, accessory.icon_state)

/datum/asset/spritesheet_batched/character_setup_hair_icons/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(64, 64)
	return pre_asset


/datum/asset/spritesheet_batched/character_setup_marking_icons
	parent_type = /datum/asset/spritesheet
	name = "character_setup_marking_icons"

/datum/asset/spritesheet_batched/character_setup_marking_icons/create_spritesheets()
	var/list/ids = list()
	for(var/marking_name in GLOB.body_markings)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(!marking?.icon || isnull(marking.icon_state))
			continue
		var/id = sanitize_css_class_name("[marking.type]")
		if(id in ids)
			continue
		ids += id
		Insert(id, marking.icon, marking.icon_state)

/datum/asset/spritesheet_batched/character_setup_marking_icons/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(64, 64)
	return pre_asset

/proc/character_setup_drink_icon_type(drink_quality)
	if(drink_quality <= 0)
		return /obj/item/reagent_containers/glass/cup/wooden
	if(drink_quality <= 1)
		return /obj/item/reagent_containers/glass/cup
	if(drink_quality <= 2)
		return /obj/item/reagent_containers/glass/bottle
	if(drink_quality <= 3)
		return /obj/item/reagent_containers/glass/cup/silver
	return /obj/item/reagent_containers/glass/cup/golden

/datum/asset/spritesheet_batched/character_setup_culinary_icons
	parent_type = /datum/asset/spritesheet
	name = "character_setup_culinary_icons"

/datum/asset/spritesheet_batched/character_setup_culinary_icons/create_spritesheets()
	var/list/ids = list()
	for(var/list/food_data in GLOB.food_with_faretypes)
		var/atom/food_type = food_data["type"]
		if(!ispath(food_type))
			continue
		var/food_icon = initial(food_type.icon)
		var/food_icon_state = initial(food_type.icon_state)
		if(!food_icon || isnull(food_icon_state))
			continue
		var/food_id = sanitize_css_class_name("[food_type]")
		var/food_sheet_id = "food_[food_id]"
		if(food_sheet_id in ids)
			continue
		ids += food_sheet_id
		Insert(food_sheet_id, food_icon, food_icon_state)

	for(var/list/drink_data in GLOB.drink_with_qualities)
		var/drink_quality = drink_data["quality"]
		var/obj/item/reagent_containers/glass/icon_type = character_setup_drink_icon_type(drink_quality)
		var/drink_icon = initial(icon_type.icon)
		var/drink_icon_state = initial(icon_type.icon_state)
		if(!drink_icon || isnull(drink_icon_state))
			continue
		var/drink_id = sanitize_css_class_name("[icon_type]")
		var/drink_sheet_id = "drink_[drink_id]"
		if(drink_sheet_id in ids)
			continue
		ids += drink_sheet_id
		Insert(drink_sheet_id, drink_icon, drink_icon_state)

/datum/asset/spritesheet_batched/character_setup_culinary_icons/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(64, 64)
	return pre_asset
