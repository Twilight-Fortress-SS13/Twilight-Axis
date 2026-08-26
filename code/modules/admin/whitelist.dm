/proc/check_whitelist(key)
	if(!SSdbcore.Connect())
		log_world("Failed to connect to database in check_whitelist(). Disabling whitelist for current round.")
		log_game("Failed to connect to database in check_whitelist(). Disabling whitelist for current round.")
		CONFIG_SET(flag/usewhitelist, FALSE)
		return TRUE

	var/datum/DBQuery/query_get_whitelist = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = key)
	)

	if(!query_get_whitelist.Execute())
		log_sql("Whitelist check for ckey [key] failed to execute. Rejecting")
		message_admins("Whitelist check for ckey [key] failed to execute. Rejecting")
		qdel(query_get_whitelist)
		return FALSE

	var/allow = query_get_whitelist.NextRow()

	qdel(query_get_whitelist)

	return allow


/datum/config_entry/keyed_list/whitelist_remove_limit_exempt
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG
	protection = CONFIG_ENTRY_LOCKED

#define WHITELIST_REMOVE_LIMIT 5
#define WHITELIST_REMOVE_WINDOW (6 HOURS)
#define WHITELIST_REMOVE_LIMIT_FILE "data/whitelist_remove_limits.sav"

GLOBAL_LIST_EMPTY(whitelist_remove_limits)
GLOBAL_VAR_INIT(whitelist_remove_limits_loaded, FALSE)

/proc/load_whitelist_remove_limits()
	if(GLOB.whitelist_remove_limits_loaded)
		return

	GLOB.whitelist_remove_limits_loaded = TRUE
	if(!fexists(WHITELIST_REMOVE_LIMIT_FILE))
		return

	var/savefile/limit_file = new(WHITELIST_REMOVE_LIMIT_FILE)
	var/list/loaded_limits
	limit_file["limits"] >> loaded_limits
	if(islist(loaded_limits))
		GLOB.whitelist_remove_limits = loaded_limits

/proc/save_whitelist_remove_limits()
	var/savefile/limit_file = new(WHITELIST_REMOVE_LIMIT_FILE)
	limit_file["limits"] << GLOB.whitelist_remove_limits

/proc/get_whitelist_remove_limit_state(sender_id)
	load_whitelist_remove_limits()

	var/sender_key = "[sender_id]"
	var/list/remove_state = GLOB.whitelist_remove_limits[sender_key]
	if(!islist(remove_state))
		return null

	var/window_started = remove_state["window_started"]
	var/remove_count = remove_state["remove_count"]
	if(!isnum(window_started) || !isnum(remove_count) || world.realtime - window_started >= WHITELIST_REMOVE_WINDOW)
		GLOB.whitelist_remove_limits -= sender_key
		save_whitelist_remove_limits()
		return null

	return remove_state

/proc/register_whitelist_remove(sender_id)
	load_whitelist_remove_limits()

	var/sender_key = "[sender_id]"
	var/list/remove_state = get_whitelist_remove_limit_state(sender_id)
	if(!remove_state)
		remove_state = list(
			"window_started" = world.realtime,
			"remove_count" = 0
		)
		GLOB.whitelist_remove_limits[sender_key] = remove_state

	remove_state["remove_count"] += 1
	save_whitelist_remove_limits()
	return remove_state["remove_count"]

/proc/whitelist_remove_limit_reached(sender_id)
	var/list/remove_state = get_whitelist_remove_limit_state(sender_id)
	return remove_state && remove_state["remove_count"] >= WHITELIST_REMOVE_LIMIT

/proc/whitelist_remove_limit_exempt(datum/tgs_chat_user/sender)
	var/list/exempt_ids = CONFIG_GET(keyed_list/whitelist_remove_limit_exempt)
	if("[sender.id]" in exempt_ids)
		return TRUE
	for(var/exempt_id in exempt_ids)
		if(sender.mention == "<@[exempt_id]>" || sender.mention == "<@![exempt_id]>")
			return TRUE
	return FALSE

/proc/set_discord_ckey_assoc(raw_key, key, discord_id)
	var/datum/DBQuery/query_get_discord = SSdbcore.NewQuery({"
		SELECT ckey FROM [format_table_name("discord_ckey_assoc")]
		WHERE discord_id = :discord_id
	"}, list("discord_id" = discord_id))

	if(!query_get_discord.Execute())
		var/get_error_message = query_get_discord.ErrorMsg()
		qdel(query_get_discord)
		return "Failed to check Discord ID `[discord_id]`\n[get_error_message]"

	var/discord_id_exists = FALSE
	if(query_get_discord.NextRow())
		discord_id_exists = TRUE
		var/existing_key = query_get_discord.item[1]
		if(ckey(existing_key) != key)
			qdel(query_get_discord)
			return "Discord ID `[discord_id]` is already associated with ckey `[existing_key]`."

	qdel(query_get_discord)

	if(discord_id_exists)
		var/datum/DBQuery/query_update_discord = SSdbcore.NewQuery({"
			UPDATE [format_table_name("discord_ckey_assoc")]
			SET ckey = :ckey
			WHERE discord_id = :discord_id
		"}, list(
			"ckey" = key,
			"discord_id" = discord_id
		))

		if(!query_update_discord.Execute())
			var/update_error_message = query_update_discord.ErrorMsg()
			qdel(query_update_discord)
			return "Failed to update Discord ID `[discord_id]` for ckey `[key]`\n[update_error_message]"

		qdel(query_update_discord)
	else
		var/datum/DBQuery/query_add_discord = SSdbcore.NewQuery({"
			INSERT INTO [format_table_name("discord_ckey_assoc")] (discord_id, ckey)
			VALUES (:discord_id, :ckey)
		"}, list(
			"discord_id" = discord_id,
			"ckey" = key
		))

		if(!query_add_discord.Execute())
			var/add_error_message = query_add_discord.ErrorMsg()
			qdel(query_add_discord)
			return "Failed to associate Discord ID `[discord_id]` with ckey `[key]`\n[add_error_message]"

		qdel(query_add_discord)

	var/datum/DBQuery/query_remove_old_discord = SSdbcore.NewQuery({"
		DELETE FROM [format_table_name("discord_ckey_assoc")]
		WHERE (ckey = :raw_ckey OR ckey = :ckey)
		AND discord_id != :discord_id
	"}, list(
		"raw_ckey" = raw_key,
		"ckey" = key,
		"discord_id" = discord_id
	))

	if(!query_remove_old_discord.Execute())
		var/remove_error_message = query_remove_old_discord.ErrorMsg()
		qdel(query_remove_old_discord)
		return "Discord ID `[discord_id]` was set for ckey `[key]`, but old Discord associations could not be removed\n[remove_error_message]"

	qdel(query_remove_old_discord)
	return null


// usually, this would go into chat_commands.dm
// BUT i don't want to put so much code there
/datum/tgs_chat_command/whitelist
	name = "whitelist"
	help_text = "whitelist <add <ckey> <discord_id>|remove <ckey>|reload|list>"
	admin_only = TRUE

/datum/tgs_chat_command/whitelist/Run(datum/tgs_chat_user/sender, params)
	. = ""
	if(!CONFIG_GET(flag/usewhitelist))
		. += "The whitelist is not enabled!\nThe command will continue to execute anyway\n"

	var/list/all_params = splittext(params, " ")
	if(length(all_params) < 1)
		. += "Invalid argument"
		return

	switch(all_params[1])
		if("add")
			if(length(all_params) < 3)
				. += "Invalid argument. Usage: whitelist add <ckey> <discord_id>"
				return

			var/raw_key = all_params[2]
			var/key = ckey(raw_key)
			var/discord_id = all_params[3]

			if(!key || !length(discord_id) || length(discord_id) > 32)
				. += "Invalid ckey or Discord ID"
				return

			var/datum/DBQuery/query_get_whitelist = SSdbcore.NewQuery({"
				SELECT id FROM [format_table_name("whitelist")]
				WHERE ckey = :ckey
			"}, list("ckey" = key)
			)
			if(!query_get_whitelist.Execute())
				. += "Failed to add ckey `[key]`\n"
				. += query_get_whitelist.ErrorMsg()
				qdel(query_get_whitelist)
				return

			if(query_get_whitelist.NextRow())
				. += "`[key]` is already in whitelist! Use `discord [key] <discord_id>` to update the Discord ID.\n"
				qdel(query_get_whitelist)
				return

			qdel(query_get_whitelist)

			var/datum/DBQuery/query_add_whitelist = SSdbcore.NewQuery({"
				INSERT INTO [format_table_name("whitelist")] (ckey)
				VALUES (:ckey)
			"}, list("ckey" = key))
			if(!query_add_whitelist.Execute())
				. += "Failed to add ckey `[key]`\n"
				. += query_add_whitelist.ErrorMsg()
				qdel(query_add_whitelist)
				return

			qdel(query_add_whitelist)

			var/discord_error = set_discord_ckey_assoc(raw_key, key, discord_id)
			if(discord_error)
				var/datum/DBQuery/query_rollback_whitelist = SSdbcore.NewQuery({"
					DELETE FROM [format_table_name("whitelist")]
					WHERE ckey = :ckey
				"}, list("ckey" = key))
				if(!query_rollback_whitelist.Execute())
					. += "[discord_error]\nFailed to roll back whitelist entry for `[key]`\n"
					. += query_rollback_whitelist.ErrorMsg()
					qdel(query_rollback_whitelist)
					return
				qdel(query_rollback_whitelist)
				. += "[discord_error]\nWhitelist addition for `[key]` was rolled back."
				return

			. += "`[key]` has been added to the whitelist with Discord ID `[discord_id]`!\n"
			return

		if("remove")
			if(length(all_params) < 2)
				. += "Invalid argument"
				return

			var/remove_limit_exempt = whitelist_remove_limit_exempt(sender)
			if(!remove_limit_exempt && whitelist_remove_limit_reached(sender.id))
				. += "Whitelist remove limit reached: [WHITELIST_REMOVE_LIMIT] removals per 6 hours."
				return

			var/key = ckey(all_params[2])
			if(!key)
				. += "Invalid ckey"
				return

			var/datum/DBQuery/query_get_whitelist = SSdbcore.NewQuery({"
				SELECT id FROM [format_table_name("whitelist")]
				WHERE ckey = :ckey
			"}, list("ckey" = key))

			if(!query_get_whitelist.Execute())
				. += "Failed to check ckey `[key]`\n"
				. += query_get_whitelist.ErrorMsg()
				qdel(query_get_whitelist)
				return

			if(!query_get_whitelist.NextRow())
				qdel(query_get_whitelist)
				. += "`[key]` is not in the whitelist!"
				return

			qdel(query_get_whitelist)

			var/datum/DBQuery/query_remove_whitelist = SSdbcore.NewQuery({"
				DELETE FROM [format_table_name("whitelist")]
				WHERE ckey = :ckey
			"}, list("ckey" = key))

			if(!query_remove_whitelist.Execute())
				. += "Failed to remove ckey `[key]`"
				. += query_remove_whitelist.ErrorMsg()
				qdel(query_remove_whitelist)
				return

			qdel(query_remove_whitelist)

			. += "`[key]` has been removed from the whitelist!\n"
			if(!remove_limit_exempt)
				var/remove_count = register_whitelist_remove(sender.id)
				if(remove_count >= WHITELIST_REMOVE_LIMIT)
					. += "Whitelist remove limit reached: [WHITELIST_REMOVE_LIMIT] removals per 6 hours."
			return

		if("list")
			var/datum/DBQuery/query_get_all_whitelist = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("whitelist")]")

			if(!query_get_all_whitelist.Execute())
				. += "Failed to get all whitelisted keys\n"
				. += query_get_all_whitelist.ErrorMsg()
				qdel(query_get_all_whitelist)
				return

			while(query_get_all_whitelist.NextRow())
				var/key = query_get_all_whitelist.item[1]
				. += "`[key]`\n"

			qdel(query_get_all_whitelist)
			return

		else
			. += "Unknown command!"
			return


/datum/tgs_chat_command/discord
	name = "discord"
	help_text = "discord <ckey> <discord_id>"
	admin_only = TRUE

/datum/tgs_chat_command/discord/Run(datum/tgs_chat_user/sender, params)
	. = ""
	var/list/all_params = splittext(params, " ")
	if(length(all_params) < 2)
		. += "Invalid argument. Usage: discord <ckey> <discord_id>"
		return

	var/raw_key = all_params[1]
	var/key = ckey(raw_key)
	var/discord_id = all_params[2]

	if(!key || !length(discord_id) || length(discord_id) > 32)
		. += "Invalid ckey or Discord ID"
		return

	var/discord_error = set_discord_ckey_assoc(raw_key, key, discord_id)
	if(discord_error)
		. += discord_error
		return

	. += "Discord ID for ckey `[key]` has been set to `[discord_id]`."
	return

#undef WHITELIST_REMOVE_LIMIT
#undef WHITELIST_REMOVE_WINDOW
#undef WHITELIST_REMOVE_LIMIT_FILE
