/obj/item/recipe_book/zizo
	name = "The Tome: ???"
	icon = 'modular_twilight_axis/lore/icons/books.dmi'
	icon_state = "zizo_guide_0"
	base_icon_state = "zizo_guide"
	wiki_name = "Книга Темных Ритуалов"
	types = list(
		/datum/ritual,
	)

/obj/item/recipe_book/zizo/proc/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return

/obj/item/recipe_book/zizo/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	current_reader = user
	var/datum/recipe_wiki/wiki = get_recipe_wiki()
	wiki.show_to_user(user, types, wiki_name || name, /obj/item/recipe_book/zizo, TRUE)
	user.update_inv_hands()

/obj/item/recipe_book/zizo/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/recipe_book/zizo/read(mob/user)
	if(!open)
		to_chat(user, span_info("Open me first."))
		return FALSE

/obj/item/recipe_book/zizo/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_icon()
	user.update_inv_hands()

/obj/item/recipe_book/zizo/update_icon()
	icon_state = "[base_icon_state]_[open]"

/datum/ritual/proc/generate_html(mob/user)
	var/html = ""
	html += "<h2 class='recipe-title'>[name]</h2>"
	html += "<p>[desk]</p>"
	html += "<h3>Требования к ритуалу:</h3>"
	html += "<ul>"

	if(center_requirement)
		if(center_book != null)
			html += "<li><b>Центр:</b> [center_book]</li>"
		else if(ispath(center_requirement, /mob/living/carbon/human))
			html += "<li><b>Центр:</b> Живой человек</li>"
		else if(ispath(center_requirement, /mob))
			html += "<li><b>Центр:</b> Живое животное</li>"
		else
			var/atom/center_item = new center_requirement()
			html += "<li><b>Центр:</b> [icon2html(center_item, user)] [center_item.name]</li>"
			qdel(center_item)

	if(n_req)
		if(north_book != null)
			html += "<li><b>Север:</b> [north_book]</li>"
		else if(ispath(n_req, /mob/living/carbon/human))
			html += "<li><b>Север:</b> Живой человек</li>"
		else if(ispath(n_req, /mob))
			html += "<li><b>Север:</b> Живое животное</li>"
		else
			var/atom/n_item = new n_req()
			html += "<li><b>Север:</b> [icon2html(n_item, user)] [n_item.name]</li>"
			qdel(n_item)

	if(e_req)
		if(east_book != null)
			html += "<li><b>Восток:</b> [east_book]</li>"
		else if(ispath(e_req, /mob/living/carbon/human))
			html += "<li><b>Восток:</b> Живой человек</li>"
		else if(ispath(e_req, /mob))
			html += "<li><b>Восток:</b> Живое животное</li>"
		else
			var/atom/e_item = new e_req()
			html += "<li><b>Восток:</b> [icon2html(e_item, user)] [e_item.name]</li>"
			qdel(e_item)

	if(s_req)
		if(south_book != null)
			html += "<li><b>Юг:</b> [south_book]</li>"
		else if(ispath(s_req, /mob/living/carbon/human))
			html += "<li><b>Юг:</b> Живой человек</li>"
		else if(ispath(s_req, /mob))
			html += "<li><b>Юг:</b> Живое животное</li>"
		else
			var/atom/s_item = new s_req()
			html += "<li><b>Юг:</b> [icon2html(s_item, user)] [s_item.name]</li>"
			qdel(s_item)

	if(w_req)
		if(west_book != null)
			html += "<li><b>Запад:</b> [west_book]</li>"
		else if(ispath(w_req, /mob/living/carbon/human))
			html += "<li><b>Запад:</b> Живой человек</li>"
		else if(ispath(w_req, /mob))
			html += "<li><b>Запад:</b> Живое животное</li>"
		else
			var/atom/w_item = new w_req()
			html += "<li><b>Запад:</b> [icon2html(w_item, user)] [w_item.name]</li>"
			qdel(w_item)

	if(cultist_number > 0)
		html += "<li><b>Требуется культистов:</b> [cultist_number] (минимум)</li>"

	if(is_cultist_ritual)
		html += "<li><i>Этот ритуал доступен лишь культистам.</i></li>"

	if(ritual_limit > 0)
		html += "<li><b>Limit:</b>Возможное количество проведенных ритуалов: [ritual_limit]"
		if(number_cultist_for_add_limit > 0)
			html += " (+1 к количеству за [number_cultist_for_add_limit] культистов)"
		html += ".</li>"

	html += "</ul>"
	html += "<p><em>Примечание: Разложите предметы на руне, как указано в требованиях. Ритуал сработает при активации, если выполнены все требования.</em></p>"
	return html
