/datum/asset/spritesheet_batched/loadout_icons
	parent_type = /datum/asset/spritesheet
	// TA EDIT - Keep layered previews separate from the old 128px cache.
	name = "loadout_previews"

/datum/asset/spritesheet_batched/loadout_icons/create_spritesheets()
	// TA EDIT START
	var/list/ids = list()
	for(var/key in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
		for(var/list/layer as anything in item.get_loadout_preview_layers())
			var/sprite_id = layer["sprite_id"]
			if(sprite_id in ids)
				continue
			ids += sprite_id
			Insert(sprite_id, layer["icon"], layer["icon_state"], SOUTH, 1)
	// TA EDIT END

/datum/asset/spritesheet_batched/loadout_icons/ModifyInserted(icon/pre_asset)
	pre_asset.Scale(40, 40) // TA EDIT
	return pre_asset
