/datum/asset/spritesheet_batched/loadout_icons
	parent_type = /datum/asset/spritesheet
	name = "loadout_icons"

/datum/asset/spritesheet_batched/loadout_icons/create_spritesheets()
	var/list/ids = list()

	for(var/key in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
		var/atom/movable/typepath = item.path
		var/icon_file = typepath::icon
		var/icon_state = typepath::icon_state

		if(ispath(typepath, /obj/item/enchantingkit))
			var/obj/item/enchantingkit/kit_typepath = typepath
			var/obj/item/result = initial(kit_typepath.result_item) || initial(kit_typepath.icon_loadout)
			icon_file = initial(result.icon)
			icon_state = initial(result.icon_state)

		if(!icon_file || isnull(icon_state))
			continue

		var/id = sanitize_css_class_name("[typepath]")
		if(id in ids)
			continue

		ids += id
		Insert(id, icon_file, icon_state)

/datum/asset/spritesheet_batched/loadout_icons/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(128, 128)
	return pre_asset
