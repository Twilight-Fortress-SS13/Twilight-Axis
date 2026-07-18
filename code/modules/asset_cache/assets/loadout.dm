/datum/asset/spritesheet_batched/loadout_icons
	name = "loadout_icons"
	ignore_dir_errors = TRUE

/datum/asset/spritesheet_batched/loadout_icons/create_spritesheets()
	var/list/ids = list()
	for(var/key in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
		var/atom/movable/typepath = item.path
		var/icon = typepath::icon
		var/icon_state = typepath::icon_state
		if(ispath(typepath, /obj/item/enchantingkit))
			var/obj/item/enchantingkit/kit_typepath = typepath
			var/obj/item/result = initial(kit_typepath.result_item) || initial(kit_typepath.icon_loadout)
			icon = initial(result.icon)
			icon_state = initial(result.icon_state)

		if(!icon || !icon_state)
			continue

		var/id = sanitize_css_class_name("[typepath]")

		if(id in ids)
			continue

		ids += id
		var/datum/universal_icon/new_icon = uni_icon(icon, icon_state)
		new_icon.scale(128,128)
		insert_icon(id, new_icon)
