#define CHARACTER_SETUP_PREVIEW_MIN_GRID 2
#define CHARACTER_SETUP_PREVIEW_MAX_GRID 4
#define CHARACTER_SETUP_PREVIEW_CANVAS_GRID 4
#define CHARACTER_SETUP_PREVIEW_FLOOR_HAREM "harem"
#define CHARACTER_SETUP_PREVIEW_FLOOR_COBBLEROCK "cobblerock"
#define CHARACTER_SETUP_PREVIEW_FLOOR_DIRT_ROAD "dirt_road"

/proc/character_setup_preview_floor_type(floor_id)
	switch(floor_id)
		if(CHARACTER_SETUP_PREVIEW_FLOOR_COBBLEROCK)
			return /turf/open/floor/rogue/cobblerock
		if(CHARACTER_SETUP_PREVIEW_FLOOR_DIRT_ROAD)
			return /turf/open/floor/rogue/dirt/road
	return /turf/open/floor/rogue/tile/harem

/proc/character_setup_preview_floor_label(floor_id)
	switch(floor_id)
		if(CHARACTER_SETUP_PREVIEW_FLOOR_COBBLEROCK)
			return "Каменная"
		if(CHARACTER_SETUP_PREVIEW_FLOOR_DIRT_ROAD)
			return "Земляная"
	return "Арлекинская"

/datum/preferences/proc/apply_to_character_setup_preview(mob/living/carbon/human/dummy/character)
	if(!character || !pref_species)
		return
	character.age = age
	character.dna.features = features.Copy()
	character.gender = gender
	character.set_species(pref_species.type, icon_update = FALSE, pref_load = src)
	character.dna.update_body_size()
	character.real_name = real_name
	character.name = real_name
	character.dna.real_name = real_name
	character.eye_color = eye_color
	character.hair_color = hair_color
	character.facial_hair_color = facial_hair_color
	character.skin_tone = skin_tone
	character.vampire_skin = vampire_skin
	character.vampire_eyes = vampire_eyes
	character.vampire_hair = vampire_hair
	character.vampire_ears = vampire_ears
	character.hairstyle = hairstyle
	character.facial_hairstyle = facial_hairstyle
	character.detail = detail
	character.jumpsuit_style = jumpsuit_style
	character.pronouns = pronouns
	character.titles_pref = titles_pref
	character.clothes_pref = clothes_pref
	var/obj/item/organ/eyes/organ_eyes = character.getorgan(/obj/item/organ/eyes)
	if(organ_eyes && !initial(organ_eyes.eye_color))
		organ_eyes.eye_color = eye_color
	if(taur_type)
		character.Taurize(taur_type, "#[taur_color]")
	else
		character.ensure_not_taur()
	character.update_body()
	character.update_hair()
	character.update_body_parts(redraw = FALSE)

/atom/movable/screen/character_setup_preview
	name = "character preview"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = MOB_LAYER
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER | TILE_BOUND
	var/datum/preferences/preferences
	var/mob/living/carbon/human/dummy/body
	var/client/viewer
	var/map_id
	var/atom/movable/screen/character_setup_preview/background/background
	var/grid_size = 3
	var/grid_size_overridden = FALSE
	var/current_direction = SOUTH
	var/floor_id = CHARACTER_SETUP_PREVIEW_FLOOR_HAREM

/atom/movable/screen/character_setup_preview/New(datum/preferences/prefs_owner, preview_map_id)
	. = ..()
	preferences = prefs_owner
	map_id = preview_map_id || "character_setup_preview_[copytext(md5("[REF(src)]"), 1, 9)]"
	background = new
	set_floor(floor_id)
	set_preview_position()

/atom/movable/screen/character_setup_preview/Destroy()
	hide_from_client()
	QDEL_NULL(background)
	if(body)
		body.wipe_state()
	QDEL_NULL(body)
	preferences = null
	return ..()

/atom/movable/screen/character_setup_preview/proc/display_to(client/new_viewer, force_rebind = FALSE)
	if(!new_viewer)
		return
	if(viewer && (viewer != new_viewer || force_rebind))
		viewer.screen -= src
		if(background)
			viewer.screen -= background
	viewer = new_viewer
	update_background()
	set_preview_position()
	if(background)
		viewer.screen |= background
	viewer.screen |= src

/atom/movable/screen/character_setup_preview/proc/hide_from_client()
	if(!viewer)
		return
	viewer.screen -= src
	viewer.screen -= background
	viewer = null

/atom/movable/screen/character_setup_preview/proc/ensure_body()
	if(body)
		return TRUE
	if(!SSatoms || SSatoms.initialized != INITIALIZATION_INNEW_REGULAR)
		return FALSE
	body = new /mob/living/carbon/human/dummy
	return !!body

/atom/movable/screen/character_setup_preview/proc/update_body()
	if(!preferences || !ensure_body())
		return FALSE
	body.wipe_state()
	preferences.apply_to_character_setup_preview(body)
	body.rebuild_obscured_flags()
	body.dir = current_direction
	appearance = new /mutable_appearance(body)
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = MOB_LAYER
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER | TILE_BOUND
	if(!grid_size_overridden)
		set_grid_size(get_recommended_grid_size())
	set_preview_position()
	return TRUE

/atom/movable/screen/character_setup_preview/proc/get_recommended_grid_size()
	var/body_size = BODY_SIZE_NORMAL
	if(preferences && preferences.features && preferences.features["body_size"])
		body_size = preferences.features["body_size"]
	if((preferences && preferences.taur_type) || body_size > 1.1)
		return 4
	return 3

/atom/movable/screen/character_setup_preview/proc/rotate_preview(backwards = FALSE)
	current_direction = turn(current_direction, backwards ? 90 : -90)
	if(body)
		body.dir = current_direction
	dir = current_direction

/atom/movable/screen/character_setup_preview/proc/cycle_grid()
	grid_size_overridden = TRUE
	set_grid_size(grid_size >= CHARACTER_SETUP_PREVIEW_MAX_GRID ? CHARACTER_SETUP_PREVIEW_MIN_GRID : grid_size + 1)

/atom/movable/screen/character_setup_preview/proc/set_grid_size(new_grid_size)
	new_grid_size = clamp(round(new_grid_size), CHARACTER_SETUP_PREVIEW_MIN_GRID, CHARACTER_SETUP_PREVIEW_MAX_GRID)
	if(grid_size == new_grid_size && background && background.screen_loc)
		return
	grid_size = new_grid_size

/atom/movable/screen/character_setup_preview/proc/set_floor(new_floor_id)
	if(!(new_floor_id in list(CHARACTER_SETUP_PREVIEW_FLOOR_HAREM, CHARACTER_SETUP_PREVIEW_FLOOR_COBBLEROCK, CHARACTER_SETUP_PREVIEW_FLOOR_DIRT_ROAD)))
		return FALSE
	floor_id = new_floor_id
	var/floor_type = character_setup_preview_floor_type(new_floor_id)
	background?.apply_floor_appearance(floor_type)
	update_background()
	if(viewer && background)
		viewer.screen |= background
	return TRUE

/atom/movable/screen/character_setup_preview/proc/update_background()
	if(!background)
		return
	background.screen_loc = "[map_id]:1,1 to [CHARACTER_SETUP_PREVIEW_CANVAS_GRID],[CHARACTER_SETUP_PREVIEW_CANVAS_GRID]"

/atom/movable/screen/character_setup_preview/proc/set_preview_position()
	var/grid_pixels = CHARACTER_SETUP_PREVIEW_CANVAS_GRID * world.icon_size
	var/x_offset = max(0, round((grid_pixels - world.icon_size) * 0.5))
	var/y_offset = max(0, round((grid_pixels - (world.icon_size * 2)) * 0.5))
	var/x_cell = 1
	var/y_cell = 1
	while(x_offset >= world.icon_size)
		x_offset -= world.icon_size
		x_cell++
	while(y_offset >= world.icon_size)
		y_offset -= world.icon_size
		y_cell++
	screen_loc = "[map_id]:[x_cell]:[x_offset],[y_cell]:[y_offset]"

/atom/movable/screen/character_setup_preview/background
	name = "preview floor"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = GAME_PLANE
	layer = TURF_LAYER
	appearance_flags = APPEARANCE_UI | TILE_BOUND

/atom/movable/screen/character_setup_preview/background/proc/apply_floor_appearance(floor_type)
	if(!ispath(floor_type, /turf/open/floor/rogue))
		floor_type = /turf/open/floor/rogue/tile/harem
	var/turf/open/floor/rogue/preview_floor_type = floor_type
	icon = initial(preview_floor_type.icon)
	icon_state = initial(preview_floor_type.icon_state)
	dir = initial(preview_floor_type.dir)
	color = initial(preview_floor_type.color)
	alpha = initial(preview_floor_type.alpha)

#undef CHARACTER_SETUP_PREVIEW_MIN_GRID
#undef CHARACTER_SETUP_PREVIEW_MAX_GRID
#undef CHARACTER_SETUP_PREVIEW_CANVAS_GRID
#undef CHARACTER_SETUP_PREVIEW_FLOOR_HAREM
#undef CHARACTER_SETUP_PREVIEW_FLOOR_COBBLEROCK
#undef CHARACTER_SETUP_PREVIEW_FLOOR_DIRT_ROAD
