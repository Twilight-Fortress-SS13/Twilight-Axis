// rmd (Rapid Mapping Device) bake profile: https://github.com/exdal/rmd
// The editor's bake view defines __DEMIR_BAKE__ and runs the hooks below to preview smoothing,
// both lighting systems and the day cycle. BYOND compiles this file to nothing.
#ifdef __DEMIR_BAKE__

#define DEMIR_GROUP_WINDOWS (1<<0)
#define DEMIR_GROUP_MOVABLE_LIGHTS (1<<1)
#define DEMIR_GROUP_TURFS (1<<2)

/datum/controller/global_vars/demir_preview/New()
	GLOB = src
	gvars_datum_init_order = list()
	InitGlobalcardinals()
	InitGlobalGLOBAL_LIGHT_RANGE()

// ---------- prepare: the light state Initialize() would leave behind ----------

/atom/proc/demir_prepare_light_state()
	return

// Sky visibility walks the z stack and neighbor contents; cache it in prepare so a time-of-day
// rebake only writes the light fields. Stale only if a roof is edited on another z without this
// turf being touched; any full rebake (map reload, lighting toggle) refreshes it.
/turf/var/demir_skylit = FALSE

/atom/proc/demir_prepare_sky()
	return

/turf/demir_prepare_sky()
	demir_skylit = demir_sees_sky()

// update() copies the bulb vars over the live light vars through set_light().
/obj/machinery/light/demir_prepare_light_state()
	light_on = on && status == LIGHT_OK
	if(!light_on)
		return
	light_power = bulb_power
	light_color = color ? color : bulb_colour
	light_outer_range = brightness
	if(light_outer_range > 0 && light_outer_range < MINIMUM_USEFUL_LIGHT_RANGE)
		light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE

// seton(TRUE) from /obj/machinery/light/rogue/Initialize()
/obj/machinery/light/rogue/demir_prepare_light_state()
	on = !roundstart_forbid && status == LIGHT_OK
	..()

// lights_on() from Initialize()
/obj/machinery/light/roguestreet/demir_prepare_light_state()
	on = TRUE
	..()

/obj/machinery/light/oldlight/demir_prepare_light_state()
	on = TRUE
	..()

// update_brightness() derives `on` from the mapped icon state.
/obj/item/flashlight/demir_prepare_light_state()
	if(icon_state == "[initial(icon_state)]-on")
		on = TRUE
	light_on = on

/obj/item/flashlight/flare/torch/prelit/demir_prepare_light_state()
	on = TRUE
	light_on = TRUE

/obj/item/flashlight/flare/torch/metal/prelit/demir_prepare_light_state()
	on = TRUE
	light_on = TRUE

/obj/item/flashlight/flare/torch/lantern/prelit/demir_prepare_light_state()
	on = TRUE
	light_on = TRUE

// ---------- bake: appearances ----------

// smooth_icon(atom) is a global proc here, unlike newer codebases where it is an atom proc; route
// through a global so the call cannot bind to /atom/proc/smooth_icon().
/proc/demir_smooth_atom(atom/A)
	return smooth_icon(A)

/atom/proc/demir_bake_appearance()
	if(!demir_profile().smooth)
		return
	if(smooth & (SMOOTH_TRUE | SMOOTH_MORE))
		demir_smooth_atom(src)
	else if(smooth & USES_BITMASK_SMOOTHING)
		smooth()

// SSnightshift flips GLOB.tod and update_icon() re-picks the shutter state; the panel picks instead.
/obj/structure/roguewindow/openclose/demir_bake_appearance()
	var/isnight = demir_profile().window_night
	if(brokenstate)
		icon_state = isnight ? "[base_state]br" : "w-[base_state]br"
	else if(climbable)
		icon_state = isnight ? "[base_state]op" : "w-[base_state]op"
	else
		icon_state = isnight ? "[base_state]" : "w-[base_state]"

/atom/proc/demir_finish_appearance()
	return

/proc/demir_light_overlay_icon(pixel_bounds)
	switch(pixel_bounds)
		if(32)
			return 'icons/effects/light_overlays/light_32.dmi'
		if(64)
			return 'icons/effects/light_overlays/light_64.dmi'
		if(96)
			return 'icons/effects/light_overlays/light_96.dmi'
		if(128)
			return 'icons/effects/light_overlays/light_128.dmi'
		if(160)
			return 'icons/effects/light_overlays/light_160.dmi'
		if(192)
			return 'icons/effects/light_overlays/light_192.dmi'
		if(224)
			return 'icons/effects/light_overlays/light_224.dmi'
		if(256)
			return 'icons/effects/light_overlays/light_256.dmi'
		if(288)
			return 'icons/effects/light_overlays/light_288.dmi'
		if(320)
			return 'icons/effects/light_overlays/light_320.dmi'
		if(352)
			return 'icons/effects/light_overlays/light_352.dmi'
		if(384)
			return 'icons/effects/light_overlays/light_384.dmi'
		if(416)
			return 'icons/effects/light_overlays/light_416.dmi'
		if(448)
			return 'icons/effects/light_overlays/light_448.dmi'
		if(480)
			return 'icons/effects/light_overlays/light_480.dmi'
		if(512)
			return 'icons/effects/light_overlays/light_512.dmi'
		if(544)
			return 'icons/effects/light_overlays/light_544.dmi'
	return null

// MOVABLE_LIGHT cuts a pre-baked mask into the darkness from the holder's vis_contents. Emit the
// same mask as a tagged underlay so the editor composites it over the static lightmap without
// starting the overlay_lighting component.
/atom/movable/proc/demir_add_light_mask(outer_range, mask_color)
	var/rounded_range = clamp(CEILING(outer_range, 0.5), 1, 9)
	var/pixel_bounds = ((rounded_range - 1) * 64) + 32
	var/image/mask = new
	mask.icon = demir_light_overlay_icon(pixel_bounds)
	mask.icon_state = "light"
	mask.plane = O_LIGHTING_VISUAL_PLANE
	mask.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mask.alpha = 255
	mask.color = mask_color
	mask.pixel_x = -((pixel_bounds - 32) * 0.5)
	mask.pixel_y = mask.pixel_x
	mask.demir_overlay_light = 1
	underlays += mask

/atom/movable/demir_finish_appearance()
	if(light_system != MOVABLE_LIGHT || !light_on || !light_outer_range)
		return
	if(!demir_profile().lighting)
		return
	demir_add_light_mask(light_outer_range, light_color)

// ---------- light: the lightmap ----------

/atom/proc/demir_apply_light()
	if(light_system != STATIC_LIGHT || !light_on || !light_outer_range || !light_power)
		return
	if(!demir_profile().lighting)
		return
	demir_light_range = max(light_outer_range, MINIMUM_USEFUL_LIGHT_RANGE)
	demir_light_inner_range = light_inner_range
	demir_light_curve = light_falloff_curve
	// APPLY_CORNER multiplies the falloff by light_power linearly; LUM_FALLOFF keeps
	// LIGHTING_HEIGHT under the root, which is the editor's default source height.
	demir_light_power = light_power
	demir_light_color = light_color

// is_sky_visible() walks the z stack through the mapping subsystem's level links, which the editor
// never builds. Adjacent z levels stack instead.
/turf/proc/demir_sees_sky()
	if(pseudo_roof)
		return FALSE
	var/turf/above = locate(x, y, z + 1)
	if(above)
		return above.demir_sky_passes()
	var/area/here = get_area(src)
	return here && here.outdoors

/turf/proc/demir_sky_passes()
	return FALSE

// is_sky_visible_through(): transparent turfs pass the sky unless a weatherproof structure blocks it.
/turf/proc/demir_sky_clear()
	for(var/obj/structure/thing in src)
		if(thing.weatherproof)
			return FALSE
	return demir_sees_sky()

/turf/open/transparent/demir_sky_passes()
	return demir_sky_clear()

/turf/closed/transparent/demir_sky_passes()
	return demir_sky_clear()

// Light crosses levels through transparent cells, the way corners sample LUM_FALLOFF_MULTIZ.
/turf/open/transparent
	demir_z_transparent = 1

/turf/closed/transparent
	demir_z_transparent = 1

// Sunlight spreads GLOBAL_LIGHT_RANGE tiles from every turf that can see the sky. hardSun is the
// -0.5 under the root and corners keep the strongest source rather than the sum, so this is a peak
// source. A lit turf reaches its own corners at full strength.
/turf/demir_apply_light()
	if(!demir_skylit)
		return ..()
	demir_light_range = GLOB.GLOBAL_LIGHT_RANGE
	demir_light_power = 1
	demir_light_height = -0.5
	demir_light_color = demir_profile().sun_color
	demir_light_peak = 1

/area/demir_apply_light()
	// Disabling lighting lights the whole map up rather than blacking it out.
	demir_fullbright = !demir_profile().lighting || !dynamic_lighting

// ---------- water ----------

// Initialize() rewrites the mapped icon_state and picks a color/dir before the overlays exist;
// pick() is seeded per atom in the bake, so the same tile keeps the same choice.
/turf/open/water/proc/demir_water_initialize()
	return

/turf/open/water/bath/demir_water_initialize()
	icon_state = "bathtile"

/turf/open/water/sewer/demir_water_initialize()
	icon_state = "paving"
	water_color = pick("#705a43","#697043")

/turf/open/water/swamp/demir_water_initialize()
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#705a43")

/turf/open/water/bloody/demir_water_initialize()
	icon_state = "dirt"
	dir = pick(GLOB.cardinals)
	water_color = pick("#880808")

/turf/open/water/cleanshallow/demir_water_initialize()
	icon_state = "rock"
	dir = pick(GLOB.cardinals)

/turf/open/water/river/demir_water_initialize()
	icon_state = "rock"

/turf/open/water/proc/demir_water_bottom_state()
	return "bottom[water_level]"

/turf/open/water/proc/demir_water_top_state()
	return "top[water_level]"

// update_icon() swaps the river sprites in and follows dir.
/turf/open/water/river/demir_water_bottom_state()
	return "riverbot"

/turf/open/water/river/demir_water_top_state()
	return "rivertop"

// The game hangs two overlay objects in the turf and cardinal_smooth() feeds roguesmooth()'s edge
// list to them from newwater.dmi; roguesmooth() also adds those states to the turf itself from the
// turf's own icon. Emit the same look: turf-level neighborlays via the real roguesmooth(), and the
// water sprites as turf overlays.
/turf/open/water/demir_bake_appearance()
	demir_water_initialize()

	var/adjacencies = 0
	if(demir_profile().smooth && smooth)
		adjacencies = calculate_adjacencies(src)
		roguesmooth(adjacencies)

	var/image/bottom = new
	bottom.icon = 'icons/turf/newwater.dmi'
	bottom.icon_state = demir_water_bottom_state()
	bottom.color = water_color
	bottom.dir = dir
	bottom.layer = BELOW_MOB_LAYER
	overlays += bottom

	var/image/top = new
	top.icon = 'icons/turf/newwater.dmi'
	top.icon_state = demir_water_top_state()
	top.color = water_color
	top.dir = dir
	top.layer = BELOW_MOB_LAYER
	overlays += top

	// water's roguesmooth() applies these to the overlay objects; neighborlay_override is "edge".
	if(adjacencies & N_NORTH)
		demir_lay_water_edge("edge-n")
	if(adjacencies & N_SOUTH)
		demir_lay_water_edge("edge-s")
	if(adjacencies & N_WEST)
		demir_lay_water_edge("edge-w")
	if(adjacencies & N_EAST)
		demir_lay_water_edge("edge-e")

/turf/open/water/proc/demir_lay_water_edge(edge_state)
	var/image/edge = new
	edge.icon = 'icons/turf/newwater.dmi'
	edge.icon_state = edge_state
	edge.color = water_color
	edge.dir = dir
	edge.layer = BELOW_MOB_LAYER
	overlays += edge

// ---------- profile ----------

/datum/demir/twilight_axis
	default = TRUE
	var/smooth = TRUE
	var/lighting = TRUE
	// daytime: what a mapper wants to see by default
	var/tod_index = 3
	var/sun_color
	var/window_night = FALSE
	var/list/tod_steps = list(
		/datum/time_of_day/dawn,
		/datum/time_of_day/sunrise,
		/datum/time_of_day/daytime,
		/datum/time_of_day/sunset,
		/datum/time_of_day/dusk,
		/datum/time_of_day/midnight,
	)

	New()
		..()
		if(!GLOB)
			GLOB = new /datum/controller/global_vars/demir_preview
		demir_define_group(DEMIR_GROUP_WINDOWS, /obj/structure/roguewindow)
		demir_define_group(DEMIR_GROUP_MOVABLE_LIGHTS, /obj/item/flashlight)
		demir_define_group(DEMIR_GROUP_TURFS, /turf)
		set_tod(tod_index)

	// SSoutdoor_effects pick()s one of the step's tints at random; a fixed first pick keeps the
	// view from shimmering between bakes.
	proc/set_tod(index)
		tod_index = index
		var/datum/time_of_day/tod_step = tod_steps[index]
		var/tint = initial(tod_step.color)
		if(islist(tint))
			var/list/tints = tint
			tint = length(tints) ? tints[1] : COLOR_WHITE
		sun_color = tint || COLOR_WHITE
		// settod() holds "night" for the whole midnight step; the shutters follow it.
		window_night = tod_step == /datum/time_of_day/midnight

	prepare(atom/target)
		target.demir_prepare_sky()
		target.demir_prepare_light_state()

	bake(atom/target)
		target.demir_bake_appearance()
		target.demir_finish_appearance()

	light(atom/target)
		target.demir_apply_light()

	ui(atom/target)
		if(!imgui_begin("Twilight Axis"))
			imgui_end()
			return

		imgui_separator("Time of day")
		var/index = 1
		for(var/tod_type in tod_steps)
			var/datum/time_of_day/tod = tod_type
			if(imgui_radio(initial(tod.name), tod_index == index) && tod_index != index)
				set_tod(index)
				// Only the sun sources recolor; fixtures and masks keep their light.
				demir_rebake(DEMIR_BAKE_LIGHT, DEMIR_GROUP_TURFS)
				demir_rebake(DEMIR_BAKE_APPEARANCE, DEMIR_GROUP_WINDOWS)
			if(index != length(tod_steps))
				imgui_same_line()
			index++
		imgui_text_colored(sun_color, "Sun tint [sun_color]")

		imgui_separator("Baking")
		var/smoothed = imgui_checkbox("Smoothing", smooth)
		if(smoothed != smooth)
			smooth = smoothed
			demir_rebake(DEMIR_BAKE_APPEARANCE)

		var/lit = imgui_checkbox("Lighting", lighting)
		if(lit != lighting)
			lighting = lit
			demir_rebake(DEMIR_BAKE_LIGHT)
			demir_rebake(DEMIR_BAKE_APPEARANCE, DEMIR_GROUP_MOVABLE_LIGHTS)

		imgui_end()

#undef DEMIR_GROUP_WINDOWS
#undef DEMIR_GROUP_MOVABLE_LIGHTS
#undef DEMIR_GROUP_TURFS

#endif
