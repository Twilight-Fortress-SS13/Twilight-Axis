/obj/weather_effect
	icon = 'icons/effects/weather_screen.dmi'
	icon_state = null
	pixel_x = -768
	pixel_y = -768
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_PLANE
	alpha = 0
	var/weather_tile_size = 512

/obj/weather_effect/proc/configure(new_icon, new_icon_state, scroll_x = 0, scroll_y = -256, scroll_time = 10, tile_size = 512, tile_count = 3, scroll_pingpong = FALSE, offset_x = 0, offset_y = 0)
	animate(src)
	transform = null
	cut_overlays()
	filters = list()

	icon = new_icon
	icon_state = new_icon_state
	weather_tile_size = tile_size
	var/offset = -round((tile_size * tile_count) / 2)
	pixel_x = offset + offset_x
	pixel_y = offset + offset_y

	if(!icon_state)
		return

	for(var/tile_x in 0 to tile_count - 1)
		for(var/tile_y in 0 to tile_count - 1)
			if(tile_x == 0 && tile_y == 0)
				continue
			var/mutable_appearance/tile = mutable_appearance(icon, icon_state)
			tile.pixel_x = tile_x * tile_size
			tile.pixel_y = tile_y * tile_size
			add_overlay(tile)

	if(!scroll_x && !scroll_y)
		return

	var/matrix/end_transform = matrix()
	end_transform.Translate(scroll_x, scroll_y)
	animate(src, transform = end_transform, time = max(1, scroll_time), loop = -1)
	if(scroll_pingpong)
		animate(transform = null, time = max(1, scroll_time))
	else
		animate(transform = null, time = 0)

/obj/weather_effect/proc/clear_visual()
	animate(src)
	transform = null
	cut_overlays()
	filters = list()
	icon_state = null
	alpha = 0
	color = null
	blend_mode = BLEND_DEFAULT


/atom/movable/screen/weather
	icon = 'icons/effects/weather_screen.dmi'
	screen_loc = "CENTER-2:-16,CENTER"
	pixel_x = -768
	pixel_y = -768
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = WEATHER_PLANE

/atom/movable/screen/weather/rain
	icon_state = "rain"
	color = "#ccffff"
	alpha = 205

/atom/movable/screen/weather/rain/New()
	. = ..()
	for(var/tile_x in 0 to 2)
		for(var/tile_y in 0 to 2)
			if(tile_x == 0 && tile_y == 0)
				continue
			var/mutable_appearance/tile = mutable_appearance(icon, icon_state)
			tile.pixel_x = tile_x * 512
			tile.pixel_y = tile_y * 512
			add_overlay(tile)

	var/matrix/end_transform = matrix()
	end_transform.Translate(0, -256)
	animate(src, transform = end_transform, time = 10, loop = -1)
	animate(transform = null, time = 0)


/atom/movable/screen/weather/fog
	alpha = 180
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "phog1"
	screen_loc = "1,1"
	pixel_x = 0
	pixel_y = 0

/atom/movable/screen/weather/fog/New(client/C)
	. = ..()
	var/mutable_appearance/MA = mutable_appearance(icon, "phog2")
	MA.pixel_x = 480
	add_overlay(MA)

	var/matrix/M = matrix()
	M.Translate(-480,0)
	animate(src, transform = M, time = 300, loop = -1)
	animate(transform = null, time = 0)

/atom/movable/screen/weather/fog/bloodfog
	color = COLOR_MAROON

/obj/weather_effect/fog_parallax_detail
	icon = 'icons/effects/weather_fog_detail.dmi'
	icon_state = "fog"
	pixel_x = 0
	pixel_y = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_PLANE
	alpha = 0
	appearance_flags = KEEP_TOGETHER

/obj/weather_effect/fog_parallax_detail/proc/configure_detail(datum/particle_weather/W, effect_color, effect_alpha, tile_size, tile_count)
	animate(src)
	transform = null
	cut_overlays()
	filters = list()
	icon = 'icons/effects/weather_fog_detail.dmi'
	icon_state = W.weather_icon_state
	color = effect_color
	alpha = max(0, round(effect_alpha * 0.48))
	blend_mode = W.blend_type ? W.blend_type : BLEND_DEFAULT
	pixel_x = 0
	pixel_y = 0
	pixel_w = 0
	pixel_z = 0
	for(var/tile_x in 0 to tile_count - 1)
		for(var/tile_y in 0 to tile_count - 1)
			if(tile_x == 0 && tile_y == 0)
				continue
			var/mutable_appearance/texture_overlay = mutable_appearance(icon, icon_state)
			texture_overlay.pixel_x = tile_x * tile_size
			texture_overlay.pixel_y = tile_y * tile_size
			texture_overlay.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			add_overlay(texture_overlay)
	var/drift_time = max(360, round(max(1, W.weather_scroll_time) * 0.96))
	animate(src, pixel_w = round(tile_size * 0.25), pixel_z = round(tile_size * -0.09375), time = drift_time, loop = -1, easing = SINE_EASING)
	animate(pixel_w = round(tile_size * 0.15625), pixel_z = round(tile_size * 0.140625), time = max(330, round(drift_time * 1.0)), easing = SINE_EASING)
	animate(pixel_w = round(tile_size * -0.1875), pixel_z = round(tile_size * 0.078125), time = max(390, round(drift_time * 1.15)), easing = SINE_EASING)
	animate(pixel_w = 0, pixel_z = 0, time = max(360, round(drift_time * 1.05)), easing = SINE_EASING)

/obj/weather_effect/fog_parallax
	icon = 'icons/effects/weather_fog.dmi'
	icon_state = "fog"
	pixel_x = -768
	pixel_y = -768
	alpha = 0
	var/speed = 32
	var/offset_x = 0
	var/offset_y = 0
	var/camera_offset_x = 0
	var/camera_offset_y = 0
	var/obj/weather_effect/fog_parallax_detail/detail_layer

/obj/weather_effect/fog_parallax/proc/set_effect_alpha(effect_alpha, animate_time = 0)
	var/detail_alpha = max(0, round(effect_alpha * 0.48))
	if(animate_time > 0)
		animate(src, alpha = effect_alpha, time = animate_time, tag = "weather_alpha")
		if(detail_layer)
			animate(detail_layer, alpha = detail_alpha, time = animate_time, tag = "weather_alpha")
	else
		animate(src, tag = "weather_alpha")
		alpha = effect_alpha
		if(detail_layer)
			animate(detail_layer, tag = "weather_alpha")
			detail_layer.alpha = detail_alpha

/obj/weather_effect/fog_parallax/proc/configure_parallax(datum/particle_weather/W, effect_color, effect_alpha)
	if(!W)
		return
	animate(src)
	transform = null
	cut_overlays()
	filters = list()
	icon = W.weather_icon
	icon_state = W.weather_icon_state
	color = effect_color
	blend_mode = W.blend_type ? W.blend_type : BLEND_DEFAULT
	speed = W.weather_parallax_speed
	weather_tile_size = max(world.icon_size, W.weather_tile_size)
	var/tile_count = max(3, W.weather_tile_count)
	var/offset = -round((weather_tile_size * tile_count) / 2)
	pixel_x = offset
	pixel_y = offset
	pixel_w = 0
	pixel_z = 0
	for(var/tile_x in 0 to tile_count - 1)
		for(var/tile_y in 0 to tile_count - 1)
			if(tile_x == 0 && tile_y == 0)
				continue
			var/mutable_appearance/texture_overlay = mutable_appearance(icon, icon_state)
			texture_overlay.pixel_x = tile_x * weather_tile_size
			texture_overlay.pixel_y = tile_y * weather_tile_size
			texture_overlay.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			add_overlay(texture_overlay)
	if(!detail_layer)
		detail_layer = new
	if(!(detail_layer in vis_contents))
		vis_contents += detail_layer
	detail_layer.configure_detail(W, effect_color, effect_alpha, weather_tile_size, tile_count)
	set_effect_alpha(effect_alpha)

/obj/weather_effect/fog_parallax/proc/apply_parallax_position(transition_time = 0, easing_mode = 0)
	var/target_x = round(offset_x - camera_offset_x, 1)
	var/target_y = round(offset_y - camera_offset_y, 1)
	if(transition_time > 0)
		animate(src, pixel_w = target_x, pixel_z = target_y, time = transition_time, easing = easing_mode, tag = "weather_parallax_position")
	else
		animate(src, tag = "weather_parallax_position")
		pixel_w = target_x
		pixel_z = target_y

/obj/weather_effect/fog_parallax/proc/set_absolute_position(turf/T)
	if(!T)
		return
	var/world_pixel_x = (T.x - 1) * speed
	var/world_pixel_y = (T.y - 1) * speed
	offset_x = -(world_pixel_x % weather_tile_size)
	offset_y = -(world_pixel_y % weather_tile_size)
	var/half_tile = weather_tile_size * 0.5
	if(offset_x > half_tile)
		offset_x -= weather_tile_size
	else if(offset_x < -half_tile)
		offset_x += weather_tile_size
	if(offset_y > half_tile)
		offset_y -= weather_tile_size
	else if(offset_y < -half_tile)
		offset_y += weather_tile_size
	apply_parallax_position()

/obj/weather_effect/fog_parallax/proc/set_camera_offset(new_offset_x, new_offset_y, transition_time = 0, easing_mode = 0)
	camera_offset_x = new_offset_x
	camera_offset_y = new_offset_y
	apply_parallax_position(transition_time, easing_mode)

/obj/weather_effect/fog_parallax/proc/update_parallax(offset_tiles_x, offset_tiles_y, glide_rate, animate_parallax)
	var/change_x = offset_tiles_x * speed
	var/change_y = offset_tiles_y * speed
	var/old_x = offset_x
	var/old_y = offset_y
	var/half_tile = weather_tile_size * 0.5
	while(old_x - change_x > half_tile)
		offset_x -= weather_tile_size
		old_x -= weather_tile_size
		pixel_w = round(offset_x - camera_offset_x, 1)
	while(old_x - change_x < -half_tile)
		offset_x += weather_tile_size
		old_x += weather_tile_size
		pixel_w = round(offset_x - camera_offset_x, 1)
	while(old_y - change_y > half_tile)
		offset_y -= weather_tile_size
		old_y -= weather_tile_size
		pixel_z = round(offset_y - camera_offset_y, 1)
	while(old_y - change_y < -half_tile)
		offset_y += weather_tile_size
		old_y += weather_tile_size
		pixel_z = round(offset_y - camera_offset_y, 1)
	offset_x -= change_x
	offset_y -= change_y
	if(animate_parallax && max(abs(offset_tiles_x), abs(offset_tiles_y)) * speed > 1)
		apply_parallax_position(max(1, glide_rate))
	else
		apply_parallax_position()

/obj/weather_effect/fog_parallax/Destroy()
	if(detail_layer)
		vis_contents -= detail_layer
		QDEL_NULL(detail_layer)
	return ..()
