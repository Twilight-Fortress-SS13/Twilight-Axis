/proc/icon_pixel_alpha(pixel)
	if(!pixel)
		return 0
	var/list/rgba = ReadRGB(pixel)
	if(!islist(rgba) || !rgba.len)
		return 0
	if(rgba.len >= 4)
		return rgba[4]
	return 255

/proc/icon_set_pixel(icon/I, x, y, color_str)
	I.DrawBox(color_str, x, y, x, y)
	return

/proc/icon_build_delta_mask(icon/full, icon/base)
	if(!full || !base)
		return null

	var/w = full.Width()
	var/h = full.Height()

	if(!w || !h)
		return null

	if(base.Width() != w || base.Height() != h)
		base = icon(base)
		if(!base)
			return null
		if(!base.Width() || !base.Height())
			return null
		base.Scale(w, h)

	var/icon/delta = icon('icons/blanks/32x32.dmi', "nothing")
	if(!delta)
		return null

	if(delta.Width() != w || delta.Height() != h)
		delta.Scale(w, h)

	for(var/y in 1 to h)
		for(var/x in 1 to w)
			var/a_full = icon_pixel_alpha(full.GetPixel(x, y))
			if(a_full <= 0)
				continue
			var/a_base = icon_pixel_alpha(base.GetPixel(x, y))
			if(a_base > 0)
				continue
			icon_set_pixel(delta, x, y, rgb(255, 255, 255, a_full))

	return delta

/proc/icon_read_rgb_safe(pixel)
	if(!pixel)
		return null
	var/list/rgba = ReadRGB(pixel)
	if(!islist(rgba) || rgba.len < 3)
		return null
	if(rgba.len < 4)
		rgba += 255
	return rgba

/proc/icon_used_key(x, y)
	return "[x],[y]"

/proc/icon_is_used(list/used, x, y)
	if(!islist(used))
		return FALSE
	return !!used[icon_used_key(x, y)]

/proc/icon_mark_used(list/used, x, y)
	if(!islist(used))
		return
	used[icon_used_key(x, y)] = TRUE

/proc/icon_paint(icon/out, x, y, r, g, b, a)
	icon_set_pixel(out, x, y, rgb(r, g, b, a))

/proc/icon_collect_delta_len(icon/delta, list/used, w, h, x_start, y_start, dx, dy)
	var/len = 0
	var/x = x_start
	var/y = y_start

	while(TRUE)
		if(x < 1 || x > w || y < 1 || y > h)
			break
		if(icon_pixel_alpha(delta.GetPixel(x, y)) <= 0)
			break
		if(icon_is_used(used, x, y))
			break
		len++
		x += dx
		y += dy

	return len

/proc/icon_apply_segment(icon/out, icon/delta, list/used, w, h, x_start, y_start, dx, dy, len, list/inner_rgba, list/edge_rgba, keep_alpha_from_delta, debug_red, debug_paint_over)
	if(len <= 0)
		return

	var/x = x_start
	var/y = y_start
	var/last_i = len - 1

	for(var/i = 0, i <= last_i, i++)
		if(x < 1 || x > w || y < 1 || y > h)
			break

		if(icon_is_used(used, x, y))
			x += dx
			y += dy
			continue

		var/is_edge_pixel = (i == last_i)
		var/list/pick_rgba = is_edge_pixel ? edge_rgba : inner_rgba

		if(debug_red)
			icon_paint(out, x, y, 255, 0, 0, 200)
			icon_mark_used(used, x, y)
			x += dx
			y += dy
			continue

		var/p_here = out.GetPixel(x, y)
		var/a_here = icon_pixel_alpha(p_here)

		if(a_here > 0 && !debug_paint_over)
			x += dx
			y += dy
			continue

		if(i != 0)
			var/a_d = icon_pixel_alpha(delta.GetPixel(x, y))
			if(a_d <= 0)
				break

		var/a_out = pick_rgba[4]
		if(keep_alpha_from_delta)
			var/a_d2 = icon_pixel_alpha(delta.GetPixel(x, y))
			if(a_d2 > 0)
				a_out = a_d2

		icon_paint(out, x, y, pick_rgba[1], pick_rgba[2], pick_rgba[3], a_out)
		icon_mark_used(used, x, y)

		x += dx
		y += dy

/proc/icon_find_edge_pixel_y(icon/out, x, y, h, radius)
	var/p = out.GetPixel(x, y)
	if(icon_pixel_alpha(p) > 0)
		return y

	for(var/r in 1 to radius)
		var/y1 = y - r
		if(y1 >= 1)
			var/p1 = out.GetPixel(x, y1)
			if(icon_pixel_alpha(p1) > 0)
				return y1
		var/y2 = y + r
		if(y2 <= h)
			var/p2 = out.GetPixel(x, y2)
			if(icon_pixel_alpha(p2) > 0)
				return y2

	return 0

/proc/icon_apply_axis_y(icon/out, icon/delta, list/used, w, h, radius, keep_alpha_from_delta, debug_red, debug_paint_over)
	for(var/x in 1 to w)
		for(var/y in 1 to h)
			if(icon_is_used(used, x, y))
				continue
			if(icon_pixel_alpha(delta.GetPixel(x, y)) <= 0)
				continue

			var/y_edge = y - 1
			if(y_edge < 1)
				continue

			var/p_edge = out.GetPixel(x, y_edge)
			if(icon_pixel_alpha(p_edge) <= 0)
				continue

			var/list/edge_rgba = icon_read_rgb_safe(p_edge)
			if(!islist(edge_rgba))
				continue

			var/list/inner_rgba = null
			var/y_inner = y_edge - 1
			if(y_inner >= 1)
				var/p_inner = out.GetPixel(x, y_inner)
				if(icon_pixel_alpha(p_inner) > 0)
					inner_rgba = icon_read_rgb_safe(p_inner)
			if(!islist(inner_rgba))
				inner_rgba = edge_rgba

			var/len_delta = icon_collect_delta_len(delta, used, w, h, x, y, 0, 1)
			if(len_delta <= 0)
				continue

			icon_apply_segment(out, delta, used, w, h, x, y_edge, 0, 1, len_delta + 1, inner_rgba, edge_rgba, keep_alpha_from_delta, debug_red, debug_paint_over)

	for(var/x2 in 1 to w)
		for(var/y2 = h, y2 >= 1, y2--)
			if(icon_is_used(used, x2, y2))
				continue
			if(icon_pixel_alpha(delta.GetPixel(x2, y2)) <= 0)
				continue

			var/y_edge2 = y2 + 1
			if(y_edge2 > h)
				continue

			var/p_edge2 = out.GetPixel(x2, y_edge2)
			if(icon_pixel_alpha(p_edge2) <= 0)
				continue

			var/list/edge_rgba2 = icon_read_rgb_safe(p_edge2)
			if(!islist(edge_rgba2))
				continue

			var/list/inner_rgba2 = null
			var/y_inner2 = y_edge2 + 1
			if(y_inner2 <= h)
				var/p_inner2 = out.GetPixel(x2, y_inner2)
				if(icon_pixel_alpha(p_inner2) > 0)
					inner_rgba2 = icon_read_rgb_safe(p_inner2)
			if(!islist(inner_rgba2))
				inner_rgba2 = edge_rgba2

			var/len_delta2 = icon_collect_delta_len(delta, used, w, h, x2, y2, 0, -1)
			if(len_delta2 <= 0)
				continue

			icon_apply_segment(out, delta, used, w, h, x2, y_edge2, 0, -1, len_delta2 + 1, inner_rgba2, edge_rgba2, keep_alpha_from_delta, debug_red, debug_paint_over)

/proc/icon_apply_axis_x(icon/out, icon/delta, list/used, w, h, radius, keep_alpha_from_delta, debug_red, debug_paint_over)
	for(var/y in 1 to h)
		for(var/x in 1 to w)
			if(icon_is_used(used, x, y))
				continue
			if(icon_pixel_alpha(delta.GetPixel(x, y)) <= 0)
				continue

			var/x_edge = x - 1
			if(x_edge < 1)
				continue

			var/edge_y = icon_find_edge_pixel_y(out, x_edge, y, h, radius)
			if(!edge_y)
				continue

			var/p_edge = out.GetPixel(x_edge, edge_y)
			if(icon_pixel_alpha(p_edge) <= 0)
				continue

			var/list/edge_rgba = icon_read_rgb_safe(p_edge)
			if(!islist(edge_rgba))
				continue

			var/list/inner_rgba = null
			var/x_inner = x_edge - 1
			if(x_inner >= 1)
				var/inner_y = icon_find_edge_pixel_y(out, x_inner, edge_y, h, radius)
				if(inner_y)
					var/p_inner = out.GetPixel(x_inner, inner_y)
					if(icon_pixel_alpha(p_inner) > 0)
						inner_rgba = icon_read_rgb_safe(p_inner)
			if(!islist(inner_rgba))
				inner_rgba = edge_rgba

			var/len_delta = icon_collect_delta_len(delta, used, w, h, x, edge_y, 1, 0)
			if(len_delta <= 0)
				continue

			icon_apply_segment(out, delta, used, w, h, x_edge, edge_y, 1, 0, len_delta + 1, inner_rgba, edge_rgba, keep_alpha_from_delta, debug_red, debug_paint_over)

	for(var/y2 in 1 to h)
		for(var/x2 = w, x2 >= 1, x2--)
			if(icon_is_used(used, x2, y2))
				continue
			if(icon_pixel_alpha(delta.GetPixel(x2, y2)) <= 0)
				continue

			var/x_edge2 = x2 + 1
			if(x_edge2 > w)
				continue

			var/edge_y2 = icon_find_edge_pixel_y(out, x_edge2, y2, h, radius)
			if(!edge_y2)
				continue

			var/p_edge2 = out.GetPixel(x_edge2, edge_y2)
			if(icon_pixel_alpha(p_edge2) <= 0)
				continue

			var/list/edge_rgba2 = icon_read_rgb_safe(p_edge2)
			if(!islist(edge_rgba2))
				continue

			var/list/inner_rgba2 = null
			var/x_inner2 = x_edge2 + 1
			if(x_inner2 <= w)
				var/inner_y2 = icon_find_edge_pixel_y(out, x_inner2, edge_y2, h, radius)
				if(inner_y2)
					var/p_inner2 = out.GetPixel(x_inner2, inner_y2)
					if(icon_pixel_alpha(p_inner2) > 0)
						inner_rgba2 = icon_read_rgb_safe(p_inner2)
			if(!islist(inner_rgba2))
				inner_rgba2 = edge_rgba2

			var/len_delta2 = icon_collect_delta_len(delta, used, w, h, x2, edge_y2, -1, 0)
			if(len_delta2 <= 0)
				continue

			icon_apply_segment(out, delta, used, w, h, x_edge2, edge_y2, -1, 0, len_delta2 + 1, inner_rgba2, edge_rgba2, keep_alpha_from_delta, debug_red, debug_paint_over)

/proc/icon_apply_delta_to_clothing(icon/clothing, icon/delta, dir, radius = 3, keep_alpha_from_delta = TRUE, debug_red = FALSE, debug_paint_over = FALSE)
	if(!clothing || !delta)
		return clothing

	var/w = clothing.Width()
	var/h = clothing.Height()

	if(delta.Width() != w || delta.Height() != h)
		delta = icon(delta)
		delta.Scale(w, h)

	var/icon/out = icon(clothing)
	var/list/used = list()

	if(dir == EAST || dir == WEST)
		icon_apply_axis_x(out, delta, used, w, h, radius, keep_alpha_from_delta, debug_red, debug_paint_over)
	else
		icon_apply_axis_y(out, delta, used, w, h, radius, keep_alpha_from_delta, debug_red, debug_paint_over)

	return out
