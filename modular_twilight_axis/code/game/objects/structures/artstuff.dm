/obj/item/canvas
	name = "canvas"
	desc = "A perfect place to paint"
	icon = 'icons/roguetown/items/paint_supplies/canvas_32.dmi'
	icon_state = "canvas"

	anchored = FALSE

	var/painting_id
	var/persistence_path = "data/paintings/"
	var/ic_date
	var/round_id

/obj/item/canvas/attack_hand(mob/user)
	. = ..()
	if(user.cmode || !anchored) return
	to_chat(user, "You start unmounting [src]")
	if(do_after(user, 3 SECONDS, target = src))
		anchored = FALSE
		to_chat(user, "You unmount [src]")

/obj/item/canvas/attack_turf(turf/T, mob/living/user)
	. = ..()
	to_chat(user, "You start mounting [src] to [T]")
	if(do_after(user, 3 SECONDS, target = T))
		forceMove(T)
		pixel_x = 0; pixel_y = 0
		anchored = TRUE
		to_chat(user, "You mount [src] to [T]")


/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/feather))
		var/new_author = input(user, "Кто автор этой картины?", "Подпись", user.real_name)
		var/new_title = input(user, "Как называется эта картина?", "Название", "Без названия")

		if(new_author && new_title)
			author = new_author
			author_ckey = user.ckey
			title = new_title
			name = title
			ic_date = get_ic_date_short_as_string()
			round_id = GLOB.rogue_round_id
			desc = "Автор: [author]. Дата: [ic_date]."

			to_chat(user, span_notice("Вы наносите последние штрихи и подписываете холст..."))
			if(save_to_disk())
				to_chat(user, span_notice("Картина '[title]' подписана."))
		return

	if(istype(I, /obj/item/paint_brush))
		ui_interact(user)
		return

	return ..()

/obj/item/canvas/ui_interact(mob/user, datum/tgui/ui)
	var/obj/item/paint_brush/B = user.get_active_held_item()
	if(!istype(B))
		to_chat(user, span_warning("Мне нужна кисть в руке, чтобы начать рисовать!"))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CanvasPainter", name)
		ui.open()
/obj/item/canvas/ui_data(mob/user)
	var/list/data = list()
	data["canvas_name"] = name

	if(icon)
		data["canvas_data"] = icon2base64(icon)

	return data

/obj/item/canvas/ui_act(action, list/params)
	. = ..()
	if(.) return

	switch(action)
		if("save_painting")
			var/list/palette = params["palette"]
			var/pixels_string = params["pixels"]

			if(!palette || !pixels_string || length(pixels_string) != 2048)
				return TRUE

			var/icon/new_art = icon('icons/roguetown/items/paint_supplies/canvas_32.dmi', "canvas")

			for(var/i = 1 to 1024)
				var/pos = ((i - 1) * 2) + 1
				var/hex = copytext(pixels_string, pos, pos + 2)
				var/color_idx = text2num(hex, 16)
				var/color_hex = palette[color_idx + 1]

				var/idx = i - 1
				var/px = (idx % 32) + 1
				var/py = (floor(idx / 32)) + 1

				new_art.DrawBox(color_hex, px, py, px, py)

			src.icon = new_art
			to_chat(usr, span_notice("Вы закончили рисовать."))

			SStgui.close_uis(src)
			return TRUE

/obj/item/canvas/proc/save_to_disk()
	if(!author || !title)
		return FALSE

	if(!painting_id)
		painting_id = "art_[author_ckey]_[world.realtime]_[rand(100,999)]"

	var/full_path = "[persistence_path][painting_id].png"
	if(fcopy(src.icon, full_path))
		save_metadata()
		return TRUE
	return FALSE

/obj/item/canvas/proc/load_from_disk(id)
	var/img_path = "[persistence_path][id].png"
	var/json_path = "[persistence_path][id].json"
	if(!fexists(img_path) || !fexists(json_path))
		return FALSE
	src.icon = icon(img_path)
	src.painting_id = id
	var/list/data = json_decode(file2text(json_path))
	if(!islist(data)) return FALSE
	src.author = data["author"]
	src.author_ckey = data["author_ckey"]
	src.title = data["title"]
	src.ic_date = data["ic_date"]
	src.name = src.title
	src.desc = "Painted by: [src.author]. Написана: [src.ic_date]."
	src.round_id = data["round_id"]
	return TRUE

/obj/effect/spawner/roguetown/random_painting
	name = "random painting spawner"
	icon = 'icons/obj/library.dmi'
	icon_state = "book4"
	var/persistence_path = "data/paintings/"

/obj/effect/spawner/roguetown/random_painting/Initialize(mapload)
	. = ..()
	var/list/files = flist(persistence_path)
	var/list/valid_paintings = list()

	for(var/f in files)
		if(findtext(f, ".json"))
			valid_paintings += replacetext(f, ".json", "")

	if(valid_paintings.len)
		var/obj/item/canvas/C = new(get_turf(src))
		var/chosen_id = pick(valid_paintings)
		if(!C.load_from_disk(chosen_id))
			C.name = "отбракованный холст"
		C.anchored = FALSE
		C.pixel_x = rand(-4, 4); C.pixel_y = rand(-4, 4)

	return INITIALIZE_HINT_QDEL


/obj/item/canvas/proc/save_metadata()
	var/list/data = list()
	data["author"] = author
	data["author_ckey"] = author_ckey
	data["title"] = title
	data["id"] = painting_id
	data["ic_date"] = ic_date

	var/full_path = "[persistence_path][painting_id].json"
	data["real_date"] = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	data["round_id"] = round_id
	fdel(full_path)
	text2file(json_encode(data), full_path)

/obj/effect/spawner/roguetown/random_painting/proc/spawn_random_art()
	var/list/files = flist(persistence_path)
	var/list/valid_paintings = list()

	for(var/f in files)
		if(findtext(f, ".json"))
			valid_paintings += replacetext(f, ".json", "")

	var/obj/item/canvas/C = new(get_turf(src))

	if(!valid_paintings.len)
		return

	var/chosen_id = pick(valid_paintings)
	if(!C.load_from_disk(chosen_id))
		C.name = "отбракованный холст"
		return


	C.anchored = FALSE
	C.pixel_x = rand(-4, 4)
	C.pixel_y = rand(-4, 4)

var/global/datum/art_gallery/glob_gallery
var/global/list/art_gallery_deletion_logs = null
var/global/const/art_gallery_log_path = "data/paintings/deletion_logs.json"
var/global/list/art_gallery_likes = list()


/client/verb/open_art_gallery()
	set name = "Art Gallery"
	set category = "OOC"
	set desc = "View paintings created by players."

	if(!glob_gallery)
		glob_gallery = new()

	glob_gallery.ui_interact(usr)

/datum/art_gallery
	var/persistence_path = "data/paintings/"

/datum/art_gallery/ui_status(mob/user)
	return UI_INTERACTIVE


/datum/art_gallery/proc/load_logs()
	if(!art_gallery_deletion_logs)
		art_gallery_deletion_logs = list()
		if(fexists(art_gallery_log_path))
			var/text_data = file2text(art_gallery_log_path)
			if(text_data)
				var/list/decoded = json_decode(text_data)
				if(islist(decoded))
					art_gallery_deletion_logs = decoded

/datum/art_gallery/proc/save_logs()
	fdel(art_gallery_log_path)
	text2file(json_encode(art_gallery_deletion_logs), art_gallery_log_path)

/datum/art_gallery/ui_interact(mob/user, datum/tgui/ui)
	load_logs()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArtGallery", "Server Art Gallery")
		ui.open()

/datum/art_gallery/ui_static_data(mob/user)
	var/list/data = list()
	var/list/paintings = list()
	var/list/files = flist(persistence_path)

	for(var/f in files)
		if(findtext(f, ".json") && f != "deletion_logs.json")
			var/id = replacetext(f, ".json", "")
			var/json_path = "[persistence_path][id].json"
			if(fexists(json_path))
				var/list/meta = json_decode(file2text(json_path))
				if(islist(meta))
					paintings += list(list(
						"id" = id,
						"title" = meta["title"],
						"author" = meta["author"],
						"author_ckey" = meta["author_ckey"],
						"ic_date" = meta["ic_date"],
						"real_date" = meta["real_date"],
						"round_id" = meta["round_id"]
					))

					var/list/likes = meta["likes"]
					if(!islist(likes))
						likes = list()
					art_gallery_likes[id] = likes

	data["paintings"] = paintings
	return data

/datum/art_gallery/ui_data(mob/user)
	var/list/data = list()
	var/is_admin = user.client.holder ? TRUE : FALSE
	data["is_admin"] = is_admin
	data["my_ckey"] = user.ckey
	data["likes_map"] = art_gallery_likes

	if(is_admin)
		load_logs()
		data["deletion_logs"] = art_gallery_deletion_logs

	return data

/datum/art_gallery/proc/save_painting_likes(id, list/likes)
	var/json_path = "[persistence_path][id].json"
	if(fexists(json_path))
		var/list/meta = json_decode(file2text(json_path))
		if(islist(meta))
			meta["likes"] = likes
			fdel(json_path)
			text2file(json_encode(meta), json_path)

/datum/art_gallery/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.) return
	var/mob/user = ui.user

	switch(action)
		if("get_image")
			var/id = params["id"]
			if(!id || findtext(id, "/") || findtext(id, "\\") || findtext(id, ".."))
				return TRUE

			var/img_path = "[persistence_path][id].png"
			if(fexists(img_path))
				var/icon/I = icon(img_path)
				SStgui.update_uis(src)
				ui.send_update(list("image_data" = list("id" = id, "base64" = icon2base64(I))))
			return TRUE

		if("like_painting")
			var/id = params["id"]
			if(!id || findtext(id, "/") || findtext(id, "\\") || findtext(id, ".."))
				return TRUE

			var/user_ckey = user.ckey
			var/list/likes = art_gallery_likes[id]
			if(!islist(likes))
				likes = list()

			if(user_ckey in likes)
				likes -= user_ckey
			else
				likes += user_ckey

			art_gallery_likes[id] = likes

			save_painting_likes(id, likes)
			SStgui.update_uis(src)
			return TRUE

		if("delete_painting")
			if(!user.client.holder) return
			var/id = params["id"]

			if(!id || findtext(id, "/") || findtext(id, "\\") || findtext(id, ".."))
				return TRUE

			var/json_path = "[persistence_path][id].json"
			if(fexists(json_path))
				var/list/meta = json_decode(file2text(json_path))
				if(islist(meta))
					load_logs()
					var/time_str = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
					var/log_entry = "\[[time_str]\] Admin [user.key] deleted '[meta["title"]]' (Author: [meta["author"]] / [meta["author_ckey"]])"

					art_gallery_deletion_logs += log_entry
					save_logs()

			if(fexists("[persistence_path][id].png")) fdel("[persistence_path][id].png")
			if(fexists("[persistence_path][id].json")) fdel("[persistence_path][id].json")

			art_gallery_likes -= id

			SStgui.close_uis(src)
			return TRUE
