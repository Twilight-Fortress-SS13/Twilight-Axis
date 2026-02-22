// code/__HELPERS/icon_morph.dm
// Core для "BASE vs FULL -> DELTA -> apply to clothing" (Axis/Azure fork)
//
// Требования:
// - ReadRGB() должен существовать (обычно в icons.dm)
// - 'icons/blanks/32x32.dmi' state "nothing" должен существовать
//
// Важно: relies on /icon.GetPixel() and DrawBox().

/// Возвращает alpha (0..255) из строки цвета, которую отдаёт GetPixel().
/// GetPixel() обычно даёт "#rrggbb" или "#rrggbbaa" (иногда null).
/proc/icon_pixel_alpha(pixel)
	if(!pixel)
		return 0

	var/list/rgba = ReadRGB(pixel)
	if(!rgba || !length(rgba))
		return 0

	if(rgba.len >= 4)
		return rgba[4]

	// если без альфы — считаем полностью непрозрачным
	return 255

/// Быстро рисует 1 пиксель (с альфой) в иконку.
/// color_str должен быть rgb(...) или "#rrggbbaa" (любой формат, который понимает DrawBox).
/proc/icon_set_pixel(icon/I, x, y, color_str)
	// DrawBox рисует inclusive box; 1x1 = пиксель
	I.DrawBox(color_str, x, y, x, y)
	return

/// Строит DELTA_MASK: альфа есть в full, но нет в base.
/// Результат: белая маска с альфой (удобно применять/читать).
/proc/icon_build_delta_mask(icon/full, icon/base)
	if(!full || !base)
		return null

	var/w = full.Width()
	var/h = full.Height()
	if(!w || !h)
		return null

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

			// белый пиксель с альфой full
			icon_set_pixel(delta, x, y, rgb(255, 255, 255, a_full))

	return delta

/// Находит "ближайший" пиксель одежды вокруг (x,y) в радиусе R.
/// Возвращает строку цвета (как GetPixel), или null если не найдено.
/// Поиск по кольцам: 1..R. 8-соседство.
proc/icon_find_nearest_nontransparent(icon/I, x, y, R)
	var/w = I.Width()
	var/h = I.Height()

	if(!w || !h)
		return null

	for(var/r in 1 to R)
		// верх/низ
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

		// лево/право (без углов, чтобы не повторять)
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

/// Применяет DELTA_MASK к одежде: там где delta непрозрачна, а одежда прозрачна — "дорастить"
/// цветом ближайшего пикселя одежды (nearest fill).
///
/// radius: насколько далеко искать "донорный" пиксель одежды.
/// keep_alpha_from_delta: если TRUE — альфа нового пикселя берётся из delta, иначе — из донора.
/// debug_red: если TRUE — рисуем красным в местах применения (для проверки пайплайна).
/proc/icon_apply_delta_to_clothing(icon/clothing, icon/delta, radius = 3, keep_alpha_from_delta = TRUE, debug_red = FALSE)
	if(!clothing || !delta)
		return clothing

	var/w = clothing.Width()
	var/h = clothing.Height()
	if(!w || !h)
		return clothing

	if(delta.Width() != w || delta.Height() != h)
		delta = icon(delta)
		delta.Scale(w, h)

	// копия, чтобы не портить оригинал
	var/icon/out = icon(clothing)

	for(var/y in 1 to h)
		for(var/x in 1 to w)
			var/a_delta = icon_pixel_alpha(delta.GetPixel(x, y))
			if(a_delta <= 0)
				continue

			var/p_cl = out.GetPixel(x, y)
			if(icon_pixel_alpha(p_cl) > 0)
				continue // уже есть одежда

			if(debug_red)
				icon_set_pixel(out, x, y, rgb(255, 0, 0, 200))
				continue

			// важно: ищем донорный пиксель в out (учитывая уже дорисованное)
			var/p_src = icon_find_nearest_nontransparent(out, x, y, radius)
			if(!p_src)
				continue

			var/list/src_rgba = ReadRGB(p_src)
			if(!src_rgba || src_rgba.len < 3)
				continue

			var/new_a = keep_alpha_from_delta ? a_delta : (src_rgba.len >= 4 ? src_rgba[4] : 255)
			icon_set_pixel(out, x, y, rgb(src_rgba[1], src_rgba[2], src_rgba[3], new_a))

	return out
