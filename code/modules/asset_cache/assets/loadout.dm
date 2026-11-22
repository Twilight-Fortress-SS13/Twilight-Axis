/datum/asset/spritesheet_batched/loadout_icons
	// TA EDIT
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
			var/datum/universal_icon/preview = uni_icon(
				layer["icon"], layer["icon_state"], SOUTH, 1)
			preview.scale(40, 40)
			insert_icon(sprite_id, preview)
	// TA EDIT END
