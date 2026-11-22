/datum/asset/spritesheet_batched/loadout_icons
	// TA EDIT
	name = "loadout_previews"

/datum/asset/spritesheet_batched/loadout_icons/create_spritesheets()
	// TA EDIT START
	// TA EDIT - fcopy() does not create directories on a fresh deployment.
	var/source_directory = "data/spritesheets/loadout_sources"
	var/marker = "[source_directory]/.keep"
	rustg_file_write("", marker)
	fdel(marker)
	var/list/source_files = list()
	for(var/key in GLOB.loadout_items_by_name)
		var/datum/loadout_item/item = GLOB.loadout_items_by_name[key]
		for(var/list/layer as anything in item.get_loadout_preview_layers())
			var/sprite_id = layer["sprite_id"]
			if(sprite_id in entries)
				continue
			var/icon_file = layer["icon"]
			var/source_name = "[icon_file]"
			if(!(source_name in source_files))
				// TA EDIT - IconForge needs a disk file, even on RSC-only deployments.
				var/source_path = "[source_directory]/[md5(source_name)].dmi"
				if(fcopy(icon_file, source_path))
					source_files[source_name] = file(source_path)
				else
					source_files[source_name] = null
					log_asset("Could not extract loadout preview source: [source_name]")
			var/source_file = source_files[source_name]
			if(!source_file)
				continue
			var/datum/universal_icon/preview = uni_icon(
				source_file, layer["icon_state"], SOUTH, 1)
			preview.scale(40, 40)
			insert_icon(sprite_id, preview)
	// TA EDIT END
