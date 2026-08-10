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

			var/key = ckey(all_params[2])

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
