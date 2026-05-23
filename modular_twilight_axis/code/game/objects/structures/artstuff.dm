/obj/item/canvas/proc/save_to_disk()
	if(!author || !title)
		return FALSE

	if(!painting_id)
		painting_id = "art_[author_ckey]_[world.realtime]_[rand(100,999)]"

	var/mob/painter = usr
	if(painter && painter.client)
		var/icon/final_icon = painter.client.RenderIcon(src)
		if(final_icon)
			src.icon = final_icon
			src.cut_overlays()

	var/full_path = "[persistence_path][painting_id].png"
	if(fcopy(src.icon, full_path))
		save_metadata()
		return TRUE
	return FALSE


/obj/item/canvas/proc/save_metadata()
	var/list/data = list()
	data["author"] = author
	data["author_ckey"] = author_ckey
	data["title"] = title
	data["id"] = painting_id
	
	var/full_path = "[persistence_path][painting_id].json"
	fdel(full_path)
	text2file(json_encode(data), full_path)

/obj/item/canvas/proc/load_from_disk(id)
	var/img_path = "[persistence_path][id].png"
	var/json_path = "[persistence_path][id].json"
	
	if(!fexists(img_path) || !fexists(json_path))
		return FALSE
		
	src.icon = icon(img_path)
	src.painting_id = id
	
	var/list/data = json_decode(file2text(json_path))
	src.author = data["author"]
	src.author_ckey = data["author_ckey"]
	src.title = data["title"]
	src.name = src.title
	src.desc = "Автор: [src.author]."
	return TRUE

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/natural/feather))
		var/new_author = input(user, "Кто автор этой картины?", "Подпись", user.real_name)
		var/new_title = input(user, "Как называется эта картина?", "Название", "Без названия")
		
		if(new_author && new_title)
			author = new_author
			author_ckey = user.ckey
			title = new_title
			name = title
			desc = "Автор: [author]."
			
			to_chat(user, span_notice("Вы наносите последние штрихи и подписываете холст..."))
			if(save_to_disk())
				to_chat(user, span_notice("Картина '[title]' подписана."))
		return
	..()

/obj/effect/spawner/roguetown/random_painting
	name = "random painting spawner"
	icon = 'icons/obj/library.dmi'
	icon_state = "book4"
	
	var/persistence_path = "data/paintings/"

/obj/effect/spawner/roguetown/random_painting/Initialize(mapload)
	. = ..()
	spawn_random_art()
	qdel(src)

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




