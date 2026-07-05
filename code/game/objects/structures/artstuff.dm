/obj/item/canvas
	name = "canvas"
	desc = "A perfect place to paint"

	icon = 'icons/roguetown/items/paint_supplies/canvas_32.dmi'
	icon_state = "canvas"

	var/easel_offset = 9
	var/canvas_size_x = 32
	var/canvas_size_y = 32

	var/atom/movable/screen/canvas/used_canvas
	var/list/showers = list()

	var/icon/draw
	var/icon/base

	var/title
	var/author
	var/author_ckey
	var/canvas_size = "32x32"
	var/reject = FALSE

	var/canvas_icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	var/canvas_icon_state = "canvas"
	var/canvas_screen_loc = "6,6"
	var/canvas_divider_x = 5
	var/canvas_divider_y = 5
	var/pixel_size_x = 4
	var/pixel_size_y = 4

	var/list/overlay_to_index = list()
	var/current_overlays = 0

	var/painting_id //TA EDIT
	var/persistence_path = "data/paintings/" //TA EDIT

/obj/item/canvas/Initialize()
	. = ..()
	used_canvas = new
	used_canvas.host = src
	used_canvas.base_icon = icon(icon, icon_state)
	used_canvas.icon = canvas_icon
	used_canvas.screen_loc = canvas_screen_loc
	used_canvas.icon_state = canvas_icon_state
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	underlays += base
	icon = draw
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_showers))

/obj/item/canvas/Destroy()
	. = ..()
	for(var/mob/mob in showers)
		remove_shower(mob)

/obj/item/canvas/get_mechanics_examine(mob/user)
	. = ..()

	. += span_info("Click left-mouse button to toggle drawing mode. Don't hold it down.")
	. += span_info("Click right-mouse button to toggle erase mode. Don't hold it down.")
	. += span_info("Click alt+left-mouse button to toggle shade adjustment mode. Don't hold it down.")
	. += span_info("Click ctrl+left-mouse button to pick colour.")

/obj/item/canvas/attack_hand(mob/user)
	. = ..()
	if(user.cmode)
		return
	if(!anchored)
		return

	to_chat(user, "You start unmounting [src]")
	if(!do_after(user, 3 SECONDS, target = src))
		return
	anchored = FALSE
	to_chat(user, "You unmount [src]")

/obj/item/canvas/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/natural/feather))
		author = input("Who's the author of this painting?")
		author_ckey = user.ckey
		title = input("What's the title of this painting.")
		if(title)
			name = title
		if(author)
			desc = "Painted by: [author]."
		return

	if(!istype(I, /obj/item/paint_brush))
		return
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/proc/remove_showers(datum/source, turf/T)
	SIGNAL_HANDLER
	for(var/mob/mob in showers)
		remove_shower(mob)

/obj/item/canvas/attack_turf(turf/T, mob/living/user)
	. = ..()
	to_chat(user, "You start mounting [src] to [T]")
	if(!do_after(user, 3 SECONDS, target = T))
		return
	forceMove(T)
	pixel_x = 0
	pixel_y = 0
	anchored = TRUE
	to_chat(user, "You mount [src] to [T]")

/obj/item/canvas/proc/remove_shower(mob/source)
	if(!source) return
	showers -= source
	if(source.client)
		source.client.screen -= used_canvas
	UnregisterSignal(source, COMSIG_MOVABLE_TURF_ENTERED)

	if(istype(used_canvas))
		used_canvas.is_drawing = FALSE
		used_canvas.last_draw_x = null
		used_canvas.last_draw_y = null
		used_canvas.drawing_is_erasing = FALSE
		used_canvas.shade_adjustment_mode = FALSE
		used_canvas.finalize_painting(source)

/obj/item/canvas/proc/update_drawing(x, y, current_color, mob/user)
	var/pos_key = "[x][y]"
	if(pos_key in overlay_to_index)
		cut_overlay(overlay_to_index[pos_key])
		overlay_to_index -= pos_key
	var/mutable_appearance/MA = mutable_appearance('icons/roguetown/items/paint_supplies/pixel.dmi', "pixel")
	MA.color = current_color
	MA.pixel_x = x
	MA.pixel_y = y
	add_overlay(MA)
	overlay_to_index[pos_key] = MA
	current_overlays++
	if(current_overlays > 150 && user?.client)
		var/icon/rendered = user.client.RenderIcon(src)
		if(rendered)
			icon = rendered
			draw = icon(rendered)
		current_overlays = 0
		cut_overlays()
		overlay_to_index = list()

/obj/item/canvas/proc/upload_painting(mob/user)
	if(!author || !title)
		return
	if(!user?.client)
		return
	var/icon/rendered = user.client.RenderIcon(src)
	cut_overlays()
	if(rendered)
		icon = rendered

/atom/movable/screen/canvas
	icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	icon_state = "canvas"
	screen_loc = "6,6"

	var/obj/item/canvas/host
	var/list/modified_areas = list()
	var/icon/base_icon
	var/icon/draw
	var/icon/base

	var/list/overlay_to_index = list()
	var/current_overlays = 0

	var/loads_painting = FALSE
	
	// Drag drawing support
	var/is_drawing = FALSE
	var/last_draw_x = null
	var/last_draw_y = null
	var/drawing_is_erasing = FALSE
	var/shade_adjustment_mode = FALSE

	var/max_ink = 50 //TA EDIT 
	var/current_ink = 0 //TA EDIT 

/atom/movable/screen/canvas/Initialize(mapload, ...)
	. = ..()
	var/icon/I = icon(icon, icon_state)
	I.Scale(160, 160) 
	
	draw = I
	base = I
	icon = draw
	underlays += base

/atom/movable/screen/canvas/Click(location, control, params)
	. = ..()
	if(!host || (host.item_flags & IN_STORAGE)) return
	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush) && !params2list(params)["ctrl"]) return

	var/list/P = params2list(params)
	var/x = clamp(floor(text2num(P["icon-x"]) / host.canvas_divider_x), 0, host.canvas_size_x - 1)
	var/y = clamp(floor(text2num(P["icon-y"]) / host.canvas_divider_y), 0, host.canvas_size_y - 1)

	if(P["ctrl"])
		if("[x][y]" in modified_areas)
			var/picked = draw.GetPixel(x+1, y+1)
			if(picked && istype(brush))
				brush.current_color = picked
				brush.update_overlays()
		return

	if(P["alt"])
		shade_adjustment_mode = !shade_adjustment_mode
		return

	if(P["right"])
		drawing_is_erasing = !drawing_is_erasing
		is_drawing = drawing_is_erasing
	else
		is_drawing = !is_drawing
		drawing_is_erasing = FALSE

	last_draw_x = x
	last_draw_y = y

	if(is_drawing)
		current_ink = 0
	else
		finalize_painting(usr)

/atom/movable/screen/canvas/proc/draw_pixel(x, y, color, is_erasing)
	if(!host || !is_drawing) return
	
	if(current_ink >= max_ink)
		is_drawing = FALSE
		finalize_painting(usr)
		return

	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	var/brush_size = istype(brush) ? brush.brush_size : 1
	var/offset = (brush_size - 1) / 2

	for(var/px = x - offset to x + offset)
		for(var/py = y - offset to y + offset)
			if(px < 0 || px >= host.canvas_size_x || py < 0 || py >= host.canvas_size_y)
				continue

			var/pos_key = "[px][py]"

			if(is_erasing)
				modified_areas -= pos_key
				if(pos_key in overlay_to_index)
					cut_overlay(overlay_to_index[pos_key])
					overlay_to_index -= pos_key
			else
				modified_areas |= pos_key
				if(pos_key in overlay_to_index)
					cut_overlay(overlay_to_index[pos_key])

				var/mutable_appearance/MA = mutable_appearance(host.canvas_icon, "pixel")
				MA.color = color
				
				MA.pixel_x = px * host.canvas_divider_x
				MA.pixel_y = py * host.canvas_divider_y
				
				add_overlay(MA)
				overlay_to_index[pos_key] = MA
				current_overlays++
				current_ink++

				if(current_overlays > 150 && usr?.client)
					var/icon/rendered = usr.client.RenderIcon(src)
					if(rendered)
						icon = rendered
						draw = icon(rendered)
					current_overlays = 0
					cut_overlays()
					overlay_to_index = list()

				host.update_drawing(px, py, color, usr)

/atom/movable/screen/canvas/proc/finalize_painting(mob/user)
	if(!user || !user.client) return
	
	var/icon/I = user.client.RenderIcon(src)
	if(I)
		icon = I
		cut_overlays()
		overlay_to_index = list()
		
		if(host)
			var/icon/world_icon = icon(I)
			world_icon.Scale(host.canvas_size_x, host.canvas_size_y)
			
			host.icon = world_icon
			host.cut_overlays() 
			
			draw = icon(I) 

	current_ink = 0
	current_overlays = 0

/atom/movable/screen/canvas/proc/draw_line(start_x, start_y, end_x, end_y, color, is_erasing)
	// AI suggested implementing bresenham and it blew my mind because i hadn't done that shit since college lol - Ryan FUCK YOU RYAN
	var/cx = start_x
	var/cy = start_y
	var/dx = abs(end_x - cx)
	var/dy = abs(end_y - cy)
	var/sx = cx < end_x ? 1 : -1
	var/sy = cy < end_y ? 1 : -1
	var/err = dx - dy
	
	var/safety = 250
	while(safety > 0)
		safety--
		draw_pixel(cx, cy, color, is_erasing)
		if(cx == end_x && cy == end_y) break
		var/e2 = err * 2
		if(e2 > -dy) { err -= dy; cx += sx }
		if(e2 < dx) { err += dx; cy += sy }

/atom/movable/screen/canvas/MouseMove(location, control, params)
	if(world.cpu > 90) return 

	. = ..()
	if(!is_drawing || !usr || !usr.client || !host) return
	
	var/list/param_list = params2list(params)
	var/raw_x = text2num(param_list["icon-x"])
	var/raw_y = text2num(param_list["icon-y"])
	
	if(isnull(raw_x) || isnull(raw_y)) return

	var/x = clamp(floor(raw_x / host.canvas_divider_x), 0, host.canvas_size_x - 1)
	var/y = clamp(floor(raw_y / host.canvas_divider_y), 0, host.canvas_size_y - 1)

	if(last_draw_x == x && last_draw_y == y) return

	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush)) return

	var/color = drawing_is_erasing ? "#ffffff" : brush.current_color
	
	draw_line(last_draw_x, last_draw_y, x, y, color, drawing_is_erasing)

	last_draw_x = x
	last_draw_y = y


///////////
// EASEL //
///////////

/obj/structure/easel
	name = "easel"
	desc = ""
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "easel"
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 60
	var/obj/item/canvas/painting = null
	anchored = 0

//Adding canvases
/obj/structure/easel/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/canvas))
		return ..()
	var/obj/item/canvas/C = I
	user.dropItemToGround(C)
	painting = C
	painting.pixel_x = 0
	painting.pixel_y = painting.easel_offset
	C.forceMove(get_turf(src))
	C.layer = layer+0.1
	user.visible_message("<span class='notice'>[user] puts \the [C] on \the [src].</span>","<span class='notice'>I place \the [C] on \the [src].</span>")

//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null

///////////
// BRUSH //
///////////

/obj/item/paint_brush
	name = "paint brush"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "paintbrush"

	grid_height = 32
	grid_width = 64
	var/current_color
	var/brush_size = 1
	var/max_brush_size = 5

/obj/item/paint_brush/examine(mob/user)
	. = ..()
	if(current_color)
		to_chat(user, span_notice("[src] is lathered with <font color=[current_color]>colour</font>."))
	if(brush_size)
		to_chat(user, span_notice("The size is at: [brush_size]."))

/obj/item/paint_brush/get_mechanics_examine(mob/user)
	. = ..()

	. += span_info("Click shift+right-mouse button to increase brush size.")
	. += span_info("Click alt+right-mouse button to decrease brush size.")
	. += span_info("Use in hand to clear colour.")

/obj/item/paint_brush/update_overlays()
	. = ..()
	cut_overlays()
	if(!current_color)
		return

	var/mutable_appearance/MA = mutable_appearance(icon, "paintbrush-color")
	MA.color = current_color
	add_overlay(MA)

/obj/item/paint_brush/proc/increase_brush_size()
	if(brush_size < max_brush_size)
		brush_size++
		return TRUE
	return FALSE

/obj/item/paint_brush/proc/decrease_brush_size()
	if(brush_size > 1)
		brush_size--
		return TRUE
	return FALSE

/obj/item/paint_brush/ShiftRightClick(mob/user)
	if(increase_brush_size())
		to_chat(user, span_notice("Brush size increased to [brush_size]."))
	else
		to_chat(user, span_notice("Brush size is at maximum."))

	return ..()

/obj/item/paint_brush/AltRightClick(mob/user)
	. = ..()
	if(!istype(loc, /mob/living/carbon))
		return
	if(decrease_brush_size())
		to_chat(user, span_notice("Brush size decreased to [brush_size]."))
	else
		to_chat(user, span_notice("Brush size is at minimum."))

/obj/item/paint_brush/attack_self(mob/user)
	. = ..()
	current_color = null
	update_overlays()
	to_chat(user, span_notice("Brush color cleared"))

/obj/item/paint_brush/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /obj/item/paint_palette))
		var/merge_color = input(user, "Choose a color to blend") as anything in target:colors
		if(!merge_color)
			return
		var/list/colors = target:colors
		merge_color = colors[merge_color]
		if(!current_color)
			current_color = merge_color
		else
			current_color = BlendRGB(current_color, merge_color, 0.5)
		update_overlays()
		return

	if(!target.reagents)
		return
	if(!(target.reagents.flags & OPENCONTAINER))
		return

	if(target.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_notice("You start to wash [src] in [target]."))
		if(!do_after(user, 1 SECONDS, target = target))
			return
		current_color = null
		update_overlays()

/obj/item/paint_palette/filled
	colors = list(
		"Red" = COLOR_RED,
		"Blue" = COLOR_BLUE,
		"Green" = COLOR_GREEN,
		"Purple" = COLOR_PURPLE,
		"Cyan" = COLOR_CYAN
	)

///////////
// Palette //
///////////

/obj/item/paint_palette
	name = "paint palette"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "palette"

	grid_height = 32
	grid_width = 64
	var/list/colors = list()

/obj/item/paint_palette/Initialize()
	. = ..()
	update_overlays()

/obj/item/paint_palette/proc/add_color(mob/user)
	if(length(colors) >= 5)
		return
	var/add_color = input(user, "Choose a color to add") as color|null
	if(!add_color)
		return
	var/color_name = input(user, "Choose a name for this color")
	if(!color_name)
		return
	if(length(colors) >= 5)
		return
	colors |= color_name
	colors[color_name] = add_color
	update_overlays()

/obj/item/paint_palette/proc/remove_color(mob/user)
	var/remove_color = input(user, "Choose a color to remove") as anything in colors
	if(!remove_color)
		return
	colors -= remove_color
	update_overlays()

/obj/item/paint_palette/attack_right(mob/user)
	. = ..()
	remove_color(user)

/obj/item/paint_palette/attack_self(mob/user)
	. = ..()
	add_color(user)

/obj/item/paint_palette/update_overlays()
	. = ..()
	cut_overlays()

	for(var/i = 1 to length(colors))
		var/mutable_appearance/MA = mutable_appearance(icon, "palette-greyscale[i]")
		var/color_name = colors[i]
		MA.color = colors[color_name]
		add_overlay(MA)