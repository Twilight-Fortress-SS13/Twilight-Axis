/datum/config_entry/string/admin_bans_channel
	default = null

/datum/config_entry/string/admin_bans_channel2
	default = null

/datum/config_entry/string/admin_notes_channel
	default = null

// TODO: Обрати внимание на каждый прок. Их нужно будет упростить по DRY.

/world/proc/create_discord_embed_footer()
	return new /datum/tgs_chat_embed/footer(
		"[GLOB.rogue_round_id] / [time2text(world.timeofday, "DD.MM.YYYY hh:mm:ss", world.timezone)]"
	)

/world/proc/split_discord_log_text(text, max_length = 1900)
	var/list/chunks = list()
	var/remaining = "[text]"
	while(length_char(remaining) > max_length)
		var/cut_position = max_length + 1
		var/minimum_position = max(1, max_length - 250)
		for(var/newline_index = max_length; newline_index >= minimum_position; newline_index--)
			if(copytext_char(remaining, newline_index, newline_index + 1) == "\n")
				cut_position = newline_index + 1
				break
		if(cut_position == max_length + 1)
			for(var/space_index = max_length; space_index >= minimum_position; space_index--)
				if(copytext_char(remaining, space_index, space_index + 1) == " ")
					cut_position = space_index + 1
					break
		var/chunk = trim(copytext_char(remaining, 1, cut_position))
		if(length(chunk))
			chunks += chunk
		remaining = trim(copytext_char(remaining, cut_position))
	if(length(remaining))
		chunks += remaining
	return chunks

/world/proc/send_discord_ban_log(title, description, colour, player_ckey, admin_ckey, reason, admin_bans_channel, admin_bans_channel2)
	var/full_text = "[description]\n\n**Игрок:** `[player_ckey]`\n**Администратор:** `[admin_ckey]`\n**Причина:**\n[reason]"
	if(length_char(full_text) <= 1900 && length_char(reason) <= 1000)
		var/datum/tgs_chat_embed/structure/embed = new()
		embed.title = title
		embed.description = description
		embed.colour = colour
		embed.footer = create_discord_embed_footer()
		var/datum/tgs_chat_embed/field/field_player_ckey = new(
			"Игрок", "`[player_ckey]`"
		)
		var/datum/tgs_chat_embed/field/field_admin_ckey = new(
			"Администратор", "`[admin_ckey]`"
		)
		var/datum/tgs_chat_embed/field/field_reason = new(
			"Причина", "[copytext_char(reason, 1)]"
		)
		field_player_ckey.is_inline = TRUE
		field_admin_ckey.is_inline = TRUE
		field_reason.is_inline = FALSE
		embed.fields = list(
			field_player_ckey,
			field_admin_ckey,
			field_reason,
		)
		var/datum/tgs_message_content/message = new("")
		message.embed = embed
		if(admin_bans_channel)
			send2chat(message, admin_bans_channel)
		if(admin_bans_channel2)
			send2chat(message, admin_bans_channel2)
		return
	var/list/chunks = split_discord_log_text(full_text)
	for(var/index in 1 to chunks.len)
		var/datum/tgs_chat_embed/structure/embed = new()
		if(index == 1)
			embed.title = title
		embed.description = chunks[index]
		embed.colour = colour
		if(index == chunks.len)
			embed.footer = create_discord_embed_footer()
		var/datum/tgs_message_content/message = new("")
		message.embed = embed
		if(admin_bans_channel)
			send2chat(message, admin_bans_channel)
		if(admin_bans_channel2)
			send2chat(message, admin_bans_channel2)

/// Отправляет средствами TGS сообщение о блокировке игрока или его ролей.
/world/proc/TgsAnnounceBan(player_ckey, admin_ckey, duration, time_message, roles, reason, severity, applies_to_admins)
	if(!TgsAvailable())
		return

	var/admin_bans_channel = CONFIG_GET(string/admin_bans_channel)
	var/admin_bans_channel2 = CONFIG_GET(string/admin_bans_channel2)


	if(!admin_bans_channel && !admin_bans_channel2)
		return

	var/severity_dict = list(
		"high" = "Высокая",
		"medium" = "Средняя",
		"minor" = "Малая",
		"none" = "None",
	)

	var/is_role_ban = roles[1] != "Server"

	var/title = is_role_ban ? "Бан ролей" : "Бан"
	var/description = "Игрок теряет возможность играть на сервере."

	if(is_role_ban)
		var/list/role_lines = list()
		for(var/role_name in roles)
			role_lines += "• `[role_name]`"
		description = "Игрок потерял доступ к указанным ролям:\n[role_lines.Join("\n")]"

	description += "\n"

	var/localized_severity = severity_dict[lowertext(severity)]
	if(localized_severity != "none")
		description += "**Тяжесть наказания:** [localized_severity]\n"

	description += "**Срок наказания:** [duration ? time_message : "*НАВСЕГДА*"]"

	if(applies_to_admins)
		description += "\n*Применено к администратору*"

	send_discord_ban_log(
		title,
		description,
		"#ed8796",
		player_ckey,
		admin_ckey,
		reason,
		admin_bans_channel,
		admin_bans_channel2,
	)

/// Отправляет средствами TGS сообщение в дискорд об изменении PQ игрока.
/world/proc/TgsAnnouncePQChanges(value, player_ckey, admin_ckey, reason)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)

	if(!admin_notes_channel)
		return

	var/datum/tgs_chat_embed/structure/embed = new()
	embed.title = "Изменение PQ"
	embed.description = reason ? "**Причина**\n" + reason : "Причина не указана!"
	embed.colour = value > 0 ? "#a6da95" : "#ed8796"
	embed.footer = create_discord_embed_footer()

	var/datum/tgs_chat_embed/field/field_player_ckey = new(
		"Игрок", "`[player_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_admin_ckey = new(
		"Администратор", "`[admin_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_changed_value = new(
		"Изменено на", "`[value]`"
	)

	field_player_ckey.is_inline = TRUE
	field_admin_ckey.is_inline = TRUE
	field_changed_value.is_inline = TRUE

	embed.fields = list(
		field_player_ckey,
		field_admin_ckey,
		field_changed_value,
	)

	var/datum/tgs_message_content/message = new("")
	message.embed = embed

	send2chat(
		message,
		admin_notes_channel
	)


/world/proc/TgsAnnounceTriumphChanges(value, player_ckey, admin_ckey, reason)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)

	if(!admin_notes_channel)
		return

	var/datum/tgs_chat_embed/structure/embed = new()
	embed.title = "Изменение триумфов"
	embed.description = reason ? "**Причина**\n" + reason : "Причина не указана!"
	embed.colour = value > 0 ? "#a6da95" : "#ed8796"
	embed.footer = create_discord_embed_footer()

	var/datum/tgs_chat_embed/field/field_player_ckey = new(
		"Игрок", "`[player_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_admin_ckey = new(
		"Администратор", "`[admin_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_changed_value = new(
		"Изменено на", "`[value]`"
	)

	field_player_ckey.is_inline = TRUE
	field_admin_ckey.is_inline = TRUE
	field_changed_value.is_inline = TRUE

	embed.fields = list(
		field_player_ckey,
		field_admin_ckey,
		field_changed_value,
	)

	var/datum/tgs_message_content/message = new("")
	message.embed = embed

	send2chat(
		message,
		admin_notes_channel
	)

/world/proc/TgsAnnounceNote(note, player_ckey, admin_ckey)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)

	if(!admin_notes_channel)
		return

	var/datum/tgs_chat_embed/structure/embed = new()
	embed.title = "PQ Note"
	embed.description = note
	embed.colour = "#8aadf4"
	embed.footer = create_discord_embed_footer()

	var/datum/tgs_chat_embed/field/field_player_ckey = new(
		"Игрок", "`[player_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_admin_ckey = new(
		"Администратор", "`[admin_ckey]`"
	)

	field_player_ckey.is_inline = TRUE
	field_admin_ckey.is_inline = TRUE

	embed.fields = list(
		field_player_ckey,
		field_admin_ckey,
	)

	var/datum/tgs_message_content/message = new("")
	message.embed = embed

	send2chat(
		message,
		admin_notes_channel
	)

/world/proc/TgsAnnounceAdminMessageEntry(admin_ckey, target_key, type, text, secret, expiry)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)

	if(!admin_notes_channel)
		return

	var/datum/tgs_chat_embed/structure/embed = new()
	embed.title = capitalize(type)
	embed.description = text
	embed.colour = "#ef9f76"
	embed.footer = create_discord_embed_footer()

	var/datum/tgs_chat_embed/field/field_player_ckey = new(
		"Игрок", "`[target_key]`"
	)

	var/datum/tgs_chat_embed/field/field_admin_ckey = new(
		"Администратор", "`[admin_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_secret = new(
		"Secret?", "[secret ? "Да" : "Нет"]"
	)

	field_player_ckey.is_inline = TRUE
	field_admin_ckey.is_inline = TRUE
	field_secret.is_inline = TRUE

	embed.fields = list(
		field_player_ckey,
		field_admin_ckey,
		field_secret,
	)

	if(expiry)
		embed.fields.Add(new /datum/tgs_chat_embed/field("Исчезнет", "[expiry]"))

	var/datum/tgs_message_content/message = new("")
	message.embed = embed

	send2chat(
		message,
		admin_notes_channel
	)

/world/proc/TgsAnnounceUnban(player_ckey, admin_ckey, roles, reason)
	if(!TgsAvailable())
		return

	var/admin_bans_channel = CONFIG_GET(string/admin_bans_channel)
	var/admin_bans_channel2 = CONFIG_GET(string/admin_bans_channel2)

	if(!admin_bans_channel && !admin_bans_channel2)
		return

	var/list/unbanned_roles
	if(islist(roles))
		var/list/role_list = roles
		unbanned_roles = role_list.Copy()
	else
		unbanned_roles = list(roles)
	var/list/non_server_roles = list()
	var/server_unban = FALSE
	for(var/role in unbanned_roles)
		if(lowertext("[role]") == "server")
			server_unban = TRUE
		else
			non_server_roles |= role
	var/list/role_lines = list()
	for(var/role in non_server_roles)
		role_lines += "• `[role]`"
	var/description
	if(server_unban && !length(non_server_roles))
		description = "Игрок получил доступ к серверу!"
	else if(server_unban)
		description = "Игрок получил доступ к серверу!\n\nИгрок получил доступ к указанным ролям:\n[role_lines.Join("\n")]"
	else if(length(non_server_roles) == 1)
		description = "Игрок получил доступ к указанной роли `[non_server_roles[1]]`!"
	else
		description = "Игрок получил доступ к указанным ролям:\n[role_lines.Join("\n")]"

	send_discord_ban_log(
		"Разбан",
		description,
		"#a6da95",
		player_ckey,
		admin_ckey,
		reason,
		admin_bans_channel,
		admin_bans_channel2,
	)

/world/proc/TgsAnnounceBanEdit(player_ckey, admin_ckey, list/changes)
	if(!TgsAvailable() || !length(changes))
		return

	var/admin_bans_channel = CONFIG_GET(string/admin_bans_channel)
	var/admin_bans_channel2 = CONFIG_GET(string/admin_bans_channel2)

	if(!admin_bans_channel && !admin_bans_channel2)
		return

	var/list/change_names = list(
		"Key" = "Ключ",
		"IP" = "IP",
		"CID" = "CID",
		"Applies to admins" = "Применение к администраторам",
		"Duration" = "Срок",
		"Reason" = "Причина",
	)
	var/list/change_lines = list()
	for(var/change_key in changes)
		var/change_name = change_names[change_key]
		if(!change_name)
			change_name = change_key
		var/change_value = replacetext("[changes[change_key]]", "<br>", "\n")
		change_lines += "**[change_name]:**\n[change_value]"

	var/full_text = "**Игрок:** `[player_ckey]`\n**Администратор:** `[admin_ckey]`\n\n[change_lines.Join("\n\n")]"
	var/list/chunks = split_discord_log_text(full_text)
	for(var/index in 1 to chunks.len)
		var/datum/tgs_chat_embed/structure/embed = new()
		if(index == 1)
			embed.title = "Изменение бана"
		embed.description = chunks[index]
		embed.colour = "#f5a97f"
		if(index == chunks.len)
			embed.footer = create_discord_embed_footer()

		var/datum/tgs_message_content/message = new("")
		message.embed = embed
		if(admin_bans_channel)
			send2chat(message, admin_bans_channel)
		if(admin_bans_channel2)
			send2chat(message, admin_bans_channel2)

/world/proc/TgsAnnounceAdminMessageEdit(editor_ckey, target_key, author_key, type, old_text, new_text)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)
	if(!admin_notes_channel)
		return

	var/pretty_type
	switch(type)
		if("note")
			pretty_type = "заметки"
		if("message")
			pretty_type = "сообщения"
		if("watchlist entry")
			pretty_type = "записи в watchlist"
		else
			return

	var/old_discord_text = replacetext("[old_text]", "<br>", "\n")
	var/new_discord_text = replacetext("[new_text]", "<br>", "\n")
	var/full_text = "**Игрок:** `[target_key]`\n**Автор записи:** `[author_key]`\n**Изменил:** `[editor_ckey]`\n\n**Было:**\n[old_discord_text]\n\n**Стало:**\n[new_discord_text]"
	var/list/chunks = split_discord_log_text(full_text)
	for(var/index in 1 to chunks.len)
		var/datum/tgs_chat_embed/structure/embed = new()
		if(index == 1)
			embed.title = "Изменение [pretty_type]"
		embed.description = chunks[index]
		embed.colour = "#f5a97f"
		if(index == chunks.len)
			embed.footer = create_discord_embed_footer()

		var/datum/tgs_message_content/message = new("")
		message.embed = embed
		send2chat(message, admin_notes_channel)

/world/proc/TgsAnnounceAdminMessageDeletion(admin_ckey, target_key, type, text)
	if(!TgsAvailable())
		return

	var/admin_notes_channel = CONFIG_GET(string/admin_notes_channel)
	if(!admin_notes_channel)
		return

	var/pretty_type = capitalize("[type]")
	var/datum/tgs_chat_embed/structure/embed = new()
	embed.title = "Удаление [pretty_type]"
	embed.description = copytext_char("[text]", 1, 4000)
	embed.colour = "#ed8796"
	embed.footer = create_discord_embed_footer()

	var/datum/tgs_chat_embed/field/field_player_ckey = new(
		"Игрок", "`[target_key]`"
	)

	var/datum/tgs_chat_embed/field/field_admin_ckey = new(
		"Удалил", "`[admin_ckey]`"
	)

	var/datum/tgs_chat_embed/field/field_type = new(
		"Тип", "`[type]`"
	)

	field_player_ckey.is_inline = TRUE
	field_admin_ckey.is_inline = TRUE
	field_type.is_inline = TRUE

	embed.fields = list(
		field_player_ckey,
		field_admin_ckey,
		field_type,
	)

	var/datum/tgs_message_content/message = new("")
	message.embed = embed

	send2chat(message, admin_notes_channel)

// Трогаем ПКью через дискорд бота

/datum/world_topic/pq_adjust
	keyword = "pqadjust"

/datum/world_topic/pq_adjust/Run(list/input)
	var/admin_ckey = ckey(input["admin"])
	var/target_ckey = ckey(input["ckey"])
	var/amount = text2num(input["amount"])
	var/reason = trim(input["reason"])

	if(!admin_ckey)
		return list("status" = "error", "message" = "Admin ckey is empty.")
	if(!can_adjust_playerquality_by_admin_ckey(admin_ckey))
		return list("status" = "error", "message" = "No rights to adjust PQ.")
	if(!target_ckey)
		return list("status" = "error", "message" = "Target ckey is empty.")
	if(admin_ckey == target_ckey)
		return list("status" = "error", "message" = "Самому себе PQ менять нельзя.")
	if(isnull(amount))
		return list("status" = "error", "message" = "Amount is invalid.")
	amount = round(amount)
	if(amount < -20 || amount > 20)
		return list("status" = "error", "message" = "Amount must be between -20 and 20.")
	if(amount != 0 && !reason)
		return list("status" = "error", "message" = "Reason is required.")
	if(length_char(reason) > 500)
		reason = copytext_char(reason, 1, 501)

	var/folder_prefix = copytext(target_ckey, 1, 2)
	var/full_path = "data/player_saves/[folder_prefix]/[target_ckey]/preferences.sav"
	if(!fexists(full_path))
		return list("status" = "error", "message" = "User does not exist.")

	var/old_pq = get_playerquality(target_ckey, FALSE)
	adjust_playerquality(amount, target_ckey, admin_ckey, reason)
	var/new_pq = get_playerquality(target_ckey, FALSE)

	for(var/client/C in GLOB.clients)
		if(C.ckey == target_ckey)
			to_chat(C, "<span class='admin'><span class='prefix'>ADMIN LOG:</span> <span class='message linkify'>Your PQ has been adjusted by [amount] by [admin_ckey] for reason: [reason]</span></span>")
			break

	return list("status" = "ok", "ckey" = target_ckey, "admin" = admin_ckey, "amount" = amount, "old_pq" = old_pq, "new_pq" = new_pq)
