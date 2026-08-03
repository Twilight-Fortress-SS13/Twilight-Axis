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

/datum/asset/spritesheet_batched/character_setup_culinary_icons
	parent_type = /datum/asset/spritesheet
	name = "character_setup_culinary_icons"

/datum/asset/spritesheet_batched/character_setup_culinary_icons/create_spritesheets()
	return
