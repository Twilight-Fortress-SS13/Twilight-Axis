GLOBAL_LIST_EMPTY(ta_clan_layout_cache)

/proc/ta_clan_layout_node(id, parent, name, desc, rank_level, max_subordinates, can_assign_positions, position_color)
	return list(
		"id" = id,
		"parent" = parent,
		"name" = name,
		"desc" = desc,
		"rank_level" = rank_level,
		"max_subordinates" = max_subordinates,
		"can_assign_positions" = can_assign_positions,
		"position_color" = position_color,
	)

/proc/ta_clan_public_layout()
	var/list/nodes = list()
	UNTYPED_LIST_ADD(nodes, ta_clan_layout_node("jarl", null, "Ярл", "Владыка чертога. Здесь кончается каждая клятва, данная внутри клана.", 0, 10, TRUE, "#e02020"))
	var/list/flanks = list("left" = "Левый херсир", "right" = "Правый херсир")
	for(var/flank in flanks)
		var/hersir_id = "[flank]_hersir"
		UNTYPED_LIST_ADD(nodes, ta_clan_layout_node(hersir_id, "jarl", flanks[flank], "Присягнувший воевода. Держит свой фланг и повелевает трэллами на нём.", 1, 5, TRUE, "#a83232"))
		for(var/thrall_number in 1 to 3)
			UNTYPED_LIST_ADD(nodes, ta_clan_layout_node("[hersir_id]_thrall_[thrall_number]", hersir_id, "Трэлл-воин", "Связанный воин. Бьётся там, где велит его херсир.", 2, 5, FALSE, "#6e2a2a"))
	return list(
		"name" = "Простой клан",
		"nodes" = nodes,
	)

/proc/ta_clan_layout_path(ckey)
	return "data/player_saves/[ckey[1]]/[ckey]/[TA_CLAN_LAYOUT_SAVE_FILE]"

/proc/ta_get_clan_layouts(ckey)
	if(!istext(ckey) || !length(ckey))
		return null
	var/list/slots = GLOB.ta_clan_layout_cache[ckey]
	if(!slots)
		slots = ta_read_clan_layouts(ckey)
		GLOB.ta_clan_layout_cache[ckey] = slots
	return slots

/proc/ta_read_clan_layouts(ckey)
	var/list/slots = new /list(TA_CLAN_LAYOUT_SLOTS)
	var/path = ta_clan_layout_path(ckey)
	if(!rustg_file_exists(path))
		return slots
	var/list/data = safe_json_decode(rustg_file_read(path))
	var/list/saved = islist(data) ? data["slots"] : null
	if(!islist(saved))
		return slots
	for(var/slot_number in 1 to min(length(saved), TA_CLAN_LAYOUT_SLOTS))
		var/list/entry = saved[slot_number]
		if(islist(entry) && istext(entry["name"]) && islist(entry["nodes"]))
			slots[slot_number] = entry
	return slots

/proc/ta_write_clan_layouts(ckey, list/slots)
	rustg_file_write(json_encode(list("version" = TA_CLAN_LAYOUT_VERSION, "slots" = slots)), ta_clan_layout_path(ckey))

/proc/ta_plain_text(text, max_length)
	if(!istext(text))
		return ""
	text = replacetext(replacetext(text, "<", ""), ">", "")
	return copytext_char(trim(text), 1, max_length + 1)

/datum/clan_hierarchy_node/Destroy()
	remove_member()
	superior = null
	subordinates.Cut()
	return ..()

/datum/clan/initialize_hierarchy()
	if(hierarchy_root)
		return
	if(!ta_apply_layout(ta_clan_public_layout()))
		stack_trace("The public clan layout was rejected")
	return ..()

/datum/clan/proc/ta_apply_layout(list/layout, mob/living/carbon/human/importing_user)
	var/datum/clan_hierarchy_node/old_root = hierarchy_root
	import_hierarchy_data(layout, importing_user)
	if(hierarchy_root == old_root)
		return FALSE
	for(var/mob/living/carbon/human/member in clan_members)
		var/datum/clan_menu_interface/menu = member.clan_menu_interface
		if(!menu)
			continue
		menu.selected_position = null
		menu.hierarchy_interface?.selected_position = null
	return TRUE

/datum/clan_hierarchy_interface
	COOLDOWN_DECLARE(layout_cooldown)

/datum/clan_hierarchy_interface/calculate_hierarchy_positions()
	. = ..()
	if(!user_clan?.hierarchy_root)
		return
	var/left_margin = 20
	var/min_x = left_margin
	for(var/datum/clan_hierarchy_node/position as anything in user_clan.all_positions)
		min_x = min(min_x, position.node_x)
	if(min_x >= left_margin)
		return
	for(var/datum/clan_hierarchy_node/position as anything in user_clan.all_positions)
		position.node_x += left_margin - min_x

/datum/clan_hierarchy_interface/generate_hierarchy_sidebar()
	. = ..()
	if(!can_manage_hierarchy())
		return
	var/insert_at = findlasttext(., "</div>", findtext(., "<style>"))
	if(!insert_at)
		return
	. = "[copytext(., 1, insert_at)][generate_library_html()][copytext(., insert_at)]"

/datum/clan_hierarchy_interface/proc/generate_library_html()
	var/can_load = (user == user_clan.clan_leader)
	var/list/public_layout = ta_clan_public_layout()
	var/list/rows = list(library_row_html(public_layout["name"], TA_CLAN_LAYOUT_PUBLIC_SLOT, FALSE, can_load))
	var/list/slots = ta_get_clan_layouts(user.ckey)
	for(var/slot in 1 to TA_CLAN_LAYOUT_SLOTS)
		var/list/entry = slots ? slots[slot] : null
		var/label = entry ? "[slot]. [html_encode(entry["name"])]" : "[slot]. <em>пусто</em>"
		rows += library_row_html(label, slot, TRUE, can_load && entry)

	return {"
		<div style='margin-top:15px; padding-top:10px; border-top:1px solid #444; color:#ccc; font-size:12px;'>
			<h3 style='margin:0 0 8px 0; color:#fff; font-size:14px;'>Библиотека</h3>
			[jointext(rows, "")]
			[can_load ? "" : "<p style='color:#888; font-style:italic;'>Загрузить раскладку может только глава клана.</p>"]
		</div>
	"}

/datum/clan_hierarchy_interface/proc/library_row_html(label, slot_id, can_save, can_load)
	var/save_link = can_save ? "<a href='?src=[REF(src)];action=ta_layout_save;slot=[slot_id]' class='btn-secondary' style='padding:2px 6px; text-decoration:none;'>Сохранить</a>" : ""
	var/load_link = can_load ? "<a href='?src=[REF(src)];action=ta_layout_load;slot=[slot_id]' class='btn-primary' style='padding:2px 6px; text-decoration:none;'>Загрузить</a>" : ""
	return "<div style='padding:4px 0; border-bottom:1px solid #333;'><div>[label]</div>[save_link] [load_link]</div>"

/datum/clan_hierarchy_interface/Topic(href, href_list)
	if(!user || usr != user)
		return
	switch(href_list["action"])
		if("ta_layout_save")
			save_layout(href_list["slot"])
			return
		if("ta_layout_load")
			load_layout(href_list["slot"])
			return
	return ..()

/datum/clan_menu_interface/can_import_hierarchy()
	return user_clan && user == user_clan.clan_leader

/datum/clan_menu_interface/Topic(href, href_list)
	if(!user || usr != user)
		return
	return ..()

/datum/clan_hierarchy_interface/proc/parse_layout_slot(slot_text)
	var/slot = text2num(slot_text)
	if(!isnum(slot) || slot != round(slot) || slot < 1 || slot > TA_CLAN_LAYOUT_SLOTS)
		return null
	return slot

/datum/clan_hierarchy_interface/proc/can_save_layout()
	return !QDELETED(src) && user_clan && user.clan == user_clan && can_manage_hierarchy()

/datum/clan_hierarchy_interface/proc/save_layout(slot_text)
	var/slot = parse_layout_slot(slot_text)
	var/list/slots = ta_get_clan_layouts(user.ckey)
	if(!slot || !slots || !can_save_layout() || !COOLDOWN_FINISHED(src, layout_cooldown))
		return

	var/list/current = slots[slot]
	var/layout_name = tgui_input_text(user, "Как назвать раскладку?", "Библиотека клана", current ? current["name"] : user_clan.name, encode = FALSE)
	if(isnull(layout_name))
		return
	layout_name = ta_plain_text(layout_name, TA_CLAN_LAYOUT_NAME_LENGTH) || "Слот [slot]"
	if(current && tgui_alert(user, "Заменить «[current["name"]]» в слоте [slot]?", "Библиотека клана", list("Заменить", "Отмена")) != "Заменить")
		return
	if(!can_save_layout())
		return

	COOLDOWN_START(src, layout_cooldown, TA_CLAN_LAYOUT_COOLDOWN)
	var/list/layout = user_clan.export_hierarchy_data()
	if(length(layout["nodes"]) > TA_CLAN_LAYOUT_MAX_NODES)
		to_chat(user, span_warning("В иерархии больше [TA_CLAN_LAYOUT_MAX_NODES] должностей, такую раскладку потом не загрузить."))
		return
	slots[slot] = list("name" = layout_name, "nodes" = layout["nodes"])
	ta_write_clan_layouts(user.ckey, slots)
	to_chat(user, span_notice("Иерархия клана сохранена в слот [slot] как «[html_encode(layout_name)]»."))
	refresh_hierarchy()

/datum/clan_hierarchy_interface/proc/can_load_layout()
	return !QDELETED(src) && user_clan && user.clan == user_clan && user == user_clan.clan_leader

/datum/clan_hierarchy_interface/proc/load_layout(slot_text)
	if(!can_load_layout())
		to_chat(user, span_warning("Загрузить раскладку может только глава клана."))
		return
	if(!COOLDOWN_FINISHED(src, layout_cooldown))
		return

	var/list/layout
	if(slot_text == TA_CLAN_LAYOUT_PUBLIC_SLOT)
		layout = ta_clan_public_layout()
	else
		var/slot = parse_layout_slot(slot_text)
		var/list/slots = slot ? ta_get_clan_layouts(user.ckey) : null
		layout = slots ? slots[slot] : null
	if(!layout)
		return

	var/layout_name = layout["name"]
	if(tgui_alert(user, "Загрузить «[layout_name]»? Все должности будут заменены, и каждый, кроме меня, лишится своей.", "Библиотека клана", list("Загрузить", "Отмена")) != "Загрузить")
		return
	if(!can_load_layout())
		return

	COOLDOWN_START(src, layout_cooldown, TA_CLAN_LAYOUT_COOLDOWN)
	if(!user_clan.ta_apply_layout(layout, user))
		to_chat(user, span_warning("Раскладка «[html_encode(layout_name)]» повреждена и не загружена."))
		return
	for(var/mob/living/carbon/human/member in user_clan.clan_members)
		if(member == user)
			to_chat(member, span_notice("Клан выстроен по раскладке «[html_encode(layout_name)]»."))
		else
			to_chat(member, span_notice("[user.real_name] перестраивает иерархию клана [user_clan.name]."))
	refresh_hierarchy()
