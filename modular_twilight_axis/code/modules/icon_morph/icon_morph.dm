// code/modules/icon_morph/icon_morph.dm
// Core helpers for "FULL vs BASE -> DELTA -> apply to clothing"
// Minimal, self-contained.

/// Returns alpha (0..255) from GetPixel() color string.
/// GetPixel() usually returns "#rrggbb" or "#rrggbbaa" or null.
/proc/icon_pixel_alpha(pixel)
	if(!pixel)
		return 0
	var/list/rgba = ReadRGB(pixel)
	if(!islist(rgba) || !rgba.len)
		return 0
	if(rgba.len >= 4)
		return rgba[4]
	return 255

/// Draw a 1x1 pixel via DrawBox.
/// color_str should be rgb(...) or "#rrggbbaa" - anything DrawBox accepts.
/proc/icon_set_pixel(icon/I, x, y, color_str)
	I.DrawBox(color_str, x, y, x, y)
	return

/// Build delta mask: alpha exists in full but not in base.
/// Output: white mask with alpha from full.
/proc/icon_build_delta_mask(icon/full, icon/base)
	if(!full || !base)
		return null

	var/w = full.Width()
	var/h = full.Height()

	if(base.Width() != w || base.Height() != h)
		base = icon(base)
		base.Scale(w, h)

	var/icon/delta = icon('icons/blanks/32x32.dmi', "nothing")
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

/// Find nearest nontransparent pixel around (x,y) within radius R.
/// Returns color string (GetPixel format) or null.
/proc/icon_find_nearest_nontransparent(icon/I, x, y, R)
	var/w = I.Width()
	var/h = I.Height()

	for(var/r in 1 to R)
		// top/bottom edges
		for(var/dx in -r to r)
			var/tx = x + dx
			if(tx < 1 || tx > w)
				continue

			var/ty1 = y - r
			if(ty1 >= 1)
				var/p1 = I.GetPixel(tx, ty1)
				if(icon_pixel_alpha(p1) > 0)
					return p1

			var/ty2 = y + r
			if(ty2 <= h)
				var/p2 = I.GetPixel(tx, ty2)
				if(icon_pixel_alpha(p2) > 0)
					return p2

		// left/right edges (no corners)
		for(var/dy in (-r + 1) to (r - 1))
			var/ty = y + dy
			if(ty < 1 || ty > h)
				continue

			var/tx1 = x - r
			if(tx1 >= 1)
				var/p3 = I.GetPixel(tx1, ty)
				if(icon_pixel_alpha(p3) > 0)
					return p3

			var/tx2 = x + r
			if(tx2 <= w)
				var/p4 = I.GetPixel(tx2, ty)
				if(icon_pixel_alpha(p4) > 0)
					return p4

	return null

/// Apply delta mask to clothing: where delta is opaque and clothing pixel is transparent,
/// "grow" clothing color using nearest fill.
/// radius: search radius for donor pixel.
/// keep_alpha_from_delta: if TRUE, alpha is taken from delta pixel, else from donor.
/// debug_red: if TRUE, paints delta pixels red (for visual verification).
/proc/icon_apply_delta_to_clothing(icon/clothing, icon/delta, radius = 3, keep_alpha_from_delta = TRUE, debug_red = FALSE, debug_paint_over = FALSE)
	if(!clothing || !delta)
		return clothing

	var/w = clothing.Width()
	var/h = clothing.Height()

	if(delta.Width() != w || delta.Height() != h)
		delta = icon(delta)
		delta.Scale(w, h)

	var/icon/out = icon(clothing)

	for(var/y in 1 to h)
		for(var/x in 1 to w)
			var/a_delta = icon_pixel_alpha(delta.GetPixel(x, y))
			if(a_delta <= 0)
				continue

			var/p_cl = out.GetPixel(x, y)
			if(!debug_paint_over && icon_pixel_alpha(p_cl) > 0)
				continue

			if(debug_red)
				icon_set_pixel(out, x, y, rgb(255, 0, 0, 200))
				continue

			var/p_src = icon_find_nearest_nontransparent(out, x, y, radius)
			if(!p_src)
				continue

			var/list/src_rgba = ReadRGB(p_src)
			if(!islist(src_rgba) || src_rgba.len < 3)
				continue

			var/new_a = keep_alpha_from_delta ? a_delta : (src_rgba.len >= 4 ? src_rgba[4] : 255)
			icon_set_pixel(out, x, y, rgb(src_rgba[1], src_rgba[2], src_rgba[3], new_a))

	return out

/proc/morph_add_forced_breasts(list/full_overlays, mob/living/carbon/human/H)
	if(!H || !islist(full_overlays))
		return

	var/obj/item/organ/breasts/B = H.getorganslot(ORGAN_SLOT_BREASTS)
	if(!B || B.breast_size <= 0)
		return

	var/datum/sprite_accessory/breasts/SA = new B.accessory_type
	if(!SA)
		return

	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	var/state = SA.get_icon_state(B, chest, H)

	var/forced_layer = BODY_FRONT_LAYER
	if(islist(SA.relevant_layers) && length(SA.relevant_layers))
		forced_layer = SA.relevant_layers[1]

	var/mutable_appearance/MA = mutable_appearance(SA.icon, state, -forced_layer)

	var/list/tmp = list(MA)
	SA.adjust_appearance_list(tmp, B, chest, H)

	full_overlays += tmp
