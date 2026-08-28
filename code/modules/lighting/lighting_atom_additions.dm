
/atom
	var/light_power = 1 // Intensity of the light.
	///Range of the light, in tiles. Zero means no light.
	var/light_range = 0
	var/light_color		// Hexadecimal RGB string representing the colour of the light.
	///Boolean variable for toggleable lights. Has no effect without the proper light_system, light_range and light_power values.
	var/light_on = TRUE

	///What direction our angled (COMPLEX_LIGHT) light is pointed
	var/light_dir = NONE
	///How many degrees of a circle should our light show. 360 is all of it, 180 is half, etc
	var/light_angle = 360
	///The height of the light. The larger this is, the dimmer we'll start
	var/light_height = 0
	///Optional render_source to apply to this atom's OVERLAY_LIGHT light overlay, hooked up by /datum/light_middleman
	var/light_render_source

	// TODO(tg-light-port): DEPRECATED COMPAT SHIM - remove this var and migrate_legacy_light_range() once every
	// .dmm that still has a baked-in `light_outer_range = X` var override has been re-saved by the map editor
	// (post tg light port, the atom var is just `light_range`). Until then this exists purely so old maps compile.
	var/light_outer_range

	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!
	var/tmp/list/light_sources		// Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.

	var/light_system = STATIC_LIGHT
	///Bitflags to determine lighting-related atom properties.
	var/light_flags = NONE

///DEPRECATED COMPAT SHIM - see light_outer_range TODO above. Called from /atom/proc/Initialize and /turf/Initialize
///(which doesn't chain to the former) before either checks light_range, so mapped light_outer_range overrides still work.
/atom/proc/migrate_legacy_light_range()
	if(isnull(light_outer_range))
		return
	light_range = light_outer_range
	light_outer_range = null

/atom/movable
	///Lazylist to keep track on the sources of illumination.
	var/list/affected_dynamic_lights
	///Highest-intensity light affecting us, which determines our visibility.
	var/affecting_dynamic_lumi = 0

/atom/movable/Initialize(mapload, ...)
	. = ..()
	switch(light_system)
		if(OVERLAY_LIGHT)
			AddComponent(/datum/component/overlay_lighting)
		if(OVERLAY_LIGHT_DIRECTIONAL)
			AddComponent(/datum/component/overlay_lighting, is_directional = TRUE)
		if(OVERLAY_LIGHT_BEAM)
			AddComponent(/datum/component/overlay_lighting, is_directional = TRUE, is_beam = TRUE)

///Keeps track of the sources of dynamic luminosity and updates our visibility with the highest.
/atom/movable/proc/update_dynamic_luminosity()
	var/highest = 0
	for(var/i in affected_dynamic_lights)
		if(affected_dynamic_lights[i] <= highest)
			continue
		highest = affected_dynamic_lights[i]
	if(highest == affecting_dynamic_lumi)
		return
	luminosity -= affecting_dynamic_lumi
	affecting_dynamic_lumi = highest
	luminosity += affecting_dynamic_lumi


/**
 * Returns how visually "off" the atom is from its source turf as a list of x, y (in pixel steps)
 * it takes into account:
 * Pixel_x/y
 * Matrix x/y
 * Icon width/height
**/
/proc/get_visual_offset(atom/checked_atom)
	//Find checked_atom's matrix so we can use its X/Y pixel shifts
	var/matrix/atom_matrix = matrix(checked_atom.transform)

	var/pixel_x_offset = checked_atom.pixel_x + checked_atom.pixel_w + atom_matrix.get_x_shift()
	var/pixel_y_offset = checked_atom.pixel_y + checked_atom.pixel_z + atom_matrix.get_y_shift()

	//Irregular objects
	var/list/icon_dimensions = get_icon_dimensions(checked_atom.icon)
	var/checked_atom_icon_height = icon_dimensions["height"]
	var/checked_atom_icon_width = icon_dimensions["width"]
	if(checked_atom_icon_height != ICON_SIZE_Y || checked_atom_icon_width != ICON_SIZE_X)
		pixel_x_offset += ((checked_atom_icon_width / ICON_SIZE_X) - 1) * (ICON_SIZE_X * 0.5)
		pixel_y_offset += ((checked_atom_icon_height / ICON_SIZE_Y) - 1) * (ICON_SIZE_Y * 0.5)

	return list(pixel_x_offset, pixel_y_offset)

///Helper to change several lighting overlay settings.
/atom/movable/proc/set_light_range_power_color(range, power, color)
	set_light_range(range)
	set_light_power(power)
	set_light_color(color)

/obj/effect/overlay/light_visible
	name = ""
	icon = 'icons/effects/light_overlays/light_32.dmi'
	icon_state = "light"
	layer = O_LIGHTING_VISUAL_LAYER
	plane = O_LIGHTING_VISUAL_PLANE
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0
	vis_flags = NONE
