/proc/tat_normalize_ckey(raw_key)
	if(!istext(raw_key))
		return null
	var/key = ckey(raw_key)
	if(!length(key))
		return null
	return key

/proc/tat_role_bucket_names()
	var/list/names = list()
	names[TAT_ROLE_BUCKET_TOWNER] = "Towner"
	names[TAT_ROLE_BUCKET_TRADER] = "Trader"
	names[TAT_ROLE_BUCKET_ADVENTURER] = "Adventurer"
	names[TAT_ROLE_BUCKET_WRETCH] = "Wretch"
	return names

/proc/tat_is_valid_role_bucket(bucket)
	if(!istext(bucket))
		return FALSE
	return bucket in tat_role_bucket_names()

/proc/tat_role_bucket_display_name(bucket)
	var/list/names = tat_role_bucket_names()
	return names[bucket] || "Unknown"

/proc/tat_role_bucket_to_ban_role(bucket)
	switch(bucket)
		if(TAT_ROLE_BUCKET_TOWNER)
			return TAT_SQL_ROLE_TOWNER
		if(TAT_ROLE_BUCKET_TRADER)
			return TAT_SQL_ROLE_TRADER
		if(TAT_ROLE_BUCKET_ADVENTURER)
			return TAT_SQL_ROLE_ADVENTURER
		if(TAT_ROLE_BUCKET_WRETCH)
			return TAT_SQL_ROLE_WRETCH
	return null

/proc/tat_ban_role_to_role_bucket(role)
	switch(role)
		if(TAT_SQL_ROLE_TOWNER)
			return TAT_ROLE_BUCKET_TOWNER
		if(TAT_SQL_ROLE_TRADER)
			return TAT_ROLE_BUCKET_TRADER
		if(TAT_SQL_ROLE_ADVENTURER)
			return TAT_ROLE_BUCKET_ADVENTURER
		if(TAT_SQL_ROLE_WRETCH)
			return TAT_ROLE_BUCKET_WRETCH
	return null

/proc/tat_all_sql_role_locks()
	return list(TAT_SQL_ROLE_TOWNER, TAT_SQL_ROLE_TRADER, TAT_SQL_ROLE_ADVENTURER, TAT_SQL_ROLE_WRETCH)

/proc/tat_is_ckey_banned(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	if(!key)
		return FALSE
	return is_banned_from(key, TAT_SQL_ROLE_SYSTEM)

/proc/tat_get_ban_reason(raw_key)
	var/list/entry = tat_get_sql_ban_entry(raw_key, TAT_SQL_ROLE_SYSTEM)
	if(!islist(entry))
		return null
	var/reason = entry["reason"]
	if(!istext(reason) || !length(reason))
		return TAT_BAN_DEFAULT_REASON
	return reason

/proc/tat_is_mob_banned(mob/user)
	if(!user?.ckey)
		return FALSE
	return tat_is_ckey_banned(user.ckey)

/proc/tat_tell_banned(mob/user)
	if(!user)
		return FALSE
	var/reason = tat_get_ban_reason(user.ckey) || TAT_BAN_DEFAULT_REASON
	to_chat(user, span_warning("You are banned from using the TAT build system. Reason: [reason]"))
	return TRUE

/proc/tat_get_sql_ban_entry(raw_key, role)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !istext(role) || !length(role))
		return null
	if(!SSdbcore.Connect())
		return null

	var/datum/DBQuery/query_get_tat_ban = SSdbcore.NewQuery({"
		SELECT id, bantime, round_id, role, expiration_time, TIMESTAMPDIFF(MINUTE, bantime, expiration_time), reason, a_ckey
		FROM [format_table_name("ban")]
		WHERE ckey = :ckey
			AND role = :role
			AND unbanned_datetime IS NULL
			AND (expiration_time IS NULL OR expiration_time > NOW())
		ORDER BY bantime DESC
		LIMIT 1
	"}, list("ckey" = key, "role" = role))
	if(!query_get_tat_ban.warn_execute())
		qdel(query_get_tat_ban)
		return null

	var/list/result
	if(query_get_tat_ban.NextRow())
		result = list(
			"id" = query_get_tat_ban.item[1],
			"bantime" = query_get_tat_ban.item[2],
			"round_id" = query_get_tat_ban.item[3],
			"role" = query_get_tat_ban.item[4],
			"expiration_time" = query_get_tat_ban.item[5],
			"duration_minutes" = query_get_tat_ban.item[6],
			"reason" = query_get_tat_ban.item[7],
			"locked_by" = query_get_tat_ban.item[8],
		)

	qdel(query_get_tat_ban)
	return result

/proc/tat_get_locked_role_entry(raw_key, bucket)
	if(!tat_is_valid_role_bucket(bucket))
		return null
	return tat_get_sql_ban_entry(raw_key, tat_role_bucket_to_ban_role(bucket))

/proc/tat_is_role_bucket_locked(raw_key, bucket)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !tat_is_valid_role_bucket(bucket))
		return FALSE

	return islist(tat_get_locked_role_entry(key, bucket))

/proc/tat_get_sql_ban_history_entry(raw_key, role)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !istext(role) || !length(role))
		return null
	if(!SSdbcore.Connect())
		return null

	var/datum/DBQuery/query_get_tat_ban_history = SSdbcore.NewQuery({"
		SELECT id, bantime, round_id, role, expiration_time, TIMESTAMPDIFF(MINUTE, bantime, expiration_time), reason, a_ckey, unbanned_datetime, unbanned_ckey
		FROM [format_table_name("ban")]
		WHERE ckey = :ckey
			AND role = :role
		ORDER BY bantime DESC
		LIMIT 1
	"}, list(
		"ckey" = key,
		"role" = role,
	))

	if(!query_get_tat_ban_history.warn_execute())
		qdel(query_get_tat_ban_history)
		return null

	var/list/result
	if(query_get_tat_ban_history.NextRow())
		result = list(
			"id" = query_get_tat_ban_history.item[1],
			"bantime" = query_get_tat_ban_history.item[2],
			"round_id" = query_get_tat_ban_history.item[3],
			"role" = query_get_tat_ban_history.item[4],
			"expiration_time" = query_get_tat_ban_history.item[5],
			"duration_minutes" = query_get_tat_ban_history.item[6],
			"reason" = query_get_tat_ban_history.item[7],
			"locked_by" = query_get_tat_ban_history.item[8],
			"unbanned_datetime" = query_get_tat_ban_history.item[9],
			"unbanned_by" = query_get_tat_ban_history.item[10],
		)

	qdel(query_get_tat_ban_history)
	return result


/proc/tat_get_role_lock_history_entry(raw_key, bucket)
	if(!tat_is_valid_role_bucket(bucket))
		return null
	return tat_get_sql_ban_history_entry(raw_key, tat_role_bucket_to_ban_role(bucket))

/proc/tat_get_role_lock_reason(raw_key, bucket)
	var/list/entry = tat_get_locked_role_entry(raw_key, bucket)
	if(!islist(entry))
		return null
	var/reason = entry["reason"]
	if(!istext(reason) || !length(reason))
		return TAT_ROLE_LOCK_DEFAULT_REASON
	return reason

/proc/tat_format_duration_message(duration, interval)
	if(isnull(duration))
		return "permanently"

	var/amount = text2num(duration)
	if(amount <= 0)
		return "permanently"

	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"

	var/time_message = "[amount] [lowertext(interval)]"
	if(amount != 1)
		time_message += "s"

	return "for [time_message]"

/proc/tat_refresh_ban_cache_for_ckey(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	if(!key)
		return FALSE

	var/client/C = GLOB.directory[key]
	if(C)
		build_ban_cache(C)

	return TRUE

/proc/tat_sql_safe_ip(raw_ip)
	if(istext(raw_ip) && length(raw_ip))
		return raw_ip
	return "127.0.0.1"

/proc/tat_sql_safe_cid(raw_cid)
	if(!isnull(raw_cid) && "[raw_cid]" != "")
		return raw_cid
	return "0"

/proc/tat_collect_online_lists_for_ban()
	var/list/clients_online = GLOB.clients.Copy()
	var/list/admins_online = list()

	for(var/client/C in clients_online)
		if(C.holder)
			admins_online += C

	return list(
		"who" = clients_online.Join(", "),
		"adminwho" = admins_online.Join(", "),
	)

/proc/tat_ban_target_string(player_key, player_ip, player_cid)
	var/list/parts = list()

	if(istext(player_key) && length(player_key))
		parts += player_key

	if(istext(player_ip) && length(player_ip))
		parts += "IP: [player_ip]"

	if(!isnull(player_cid) && "[player_cid]" != "")
		parts += "CID: [player_cid]"

	if(!length(parts))
		return "unknown target"

	return parts.Join(" / ")

/proc/tat_create_role_lock(client/admin, raw_key, bucket, duration = null, interval = TAT_ROLE_LOCK_DEFAULT_INTERVAL, severity = TAT_ROLE_LOCK_DEFAULT_SEVERITY, reason = TAT_ROLE_LOCK_DEFAULT_REASON, applies_to_admins = FALSE)
	if(!admin?.holder || !check_rights_for(admin, R_BAN))
		return FALSE

	if(!SSdbcore.Connect())
		to_chat(admin, span_danger("Failed to establish database connection."))
		return FALSE

	var/key = tat_normalize_ckey(raw_key)
	if(!key || !tat_is_valid_role_bucket(bucket))
		return FALSE

	if(tat_is_role_bucket_locked(key, bucket))
		return TRUE

	if(!istext(reason) || !length(trim(reason)))
		reason = TAT_ROLE_LOCK_DEFAULT_REASON
	else
		reason = trim(reason)

	if(!(severity in list("None", "Minor", "Medium", "High")))
		severity = TAT_ROLE_LOCK_DEFAULT_SEVERITY

	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = TAT_ROLE_LOCK_DEFAULT_INTERVAL

	duration = isnull(duration) ? null : max(1, text2num(duration))

	var/sql_role = tat_role_bucket_to_ban_role(bucket)
	var/bucket_name = tat_role_bucket_display_name(bucket)
	var/time_message = tat_format_duration_message(duration, interval)
	var/note_reason = "Banned from Roles: [sql_role] [time_message] - [reason]"

	var/player_key = key
	var/player_ip = "127.0.0.1"
	var/player_cid = "0"

	var/client/target_client = GLOB.directory[key]
	if(target_client)
		player_key = target_client.key || key
		player_ip = tat_sql_safe_ip(target_client.address)
		player_cid = tat_sql_safe_cid(target_client.computer_id)

	var/list/online_data = tat_collect_online_lists_for_ban()
	var/admin_ip = tat_sql_safe_ip(admin.address)
	var/admin_cid = tat_sql_safe_cid(admin.computer_id)
	var/server_ip = tat_sql_safe_ip(world.internet_address)
	var/round_id = GLOB.round_id || 0

	var/datum/DBQuery/query_create_tat_role_lock = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("ban")]
		(server_ip, server_port, round_id, role, expiration_time, applies_to_admins, reason, ckey, ip, computerid, a_ckey, a_ip, a_computerid, who, adminwho, bantime)
		VALUES
		(INET_ATON(:server_ip), :server_port, :round_id, :role, IF(:duration IS NULL, NULL, NOW() + INTERVAL :duration [interval]), :applies_to_admins, :reason, :ckey, INET_ATON(:player_ip), :player_cid, :admin_ckey, INET_ATON(:admin_ip), :admin_cid, :who, :adminwho, NOW())
	"}, list(
		"server_ip" = server_ip,
		"server_port" = world.port || 0,
		"round_id" = round_id,
		"role" = sql_role,
		"duration" = duration,
		"applies_to_admins" = applies_to_admins,
		"reason" = reason,
		"ckey" = key,
		"player_ip" = player_ip,
		"player_cid" = player_cid,
		"admin_ckey" = admin.ckey,
		"admin_ip" = admin_ip,
		"admin_cid" = admin_cid,
		"who" = online_data["who"],
		"adminwho" = online_data["adminwho"],
	))

	if(!query_create_tat_role_lock.warn_execute())
		qdel(query_create_tat_role_lock)
		return FALSE

	qdel(query_create_tat_role_lock)

	create_message("note", key, admin.ckey, note_reason, null, null, 0, 0, null, 0, severity)

	var/target = tat_ban_target_string(player_key, player_ip, player_cid)
	var/kn = key_name(admin)
	var/kna = key_name_admin(admin)
	var/msg = "has created a [isnull(duration) ? "permanent" : "temporary [time_message]"] TAT role lock for [target]."

	log_admin_private("[kn] [msg] Role: [sql_role] Reason: [reason]")
	message_admins("[kna] [msg]<br>Role: [sql_role]<br>Reason: [reason]")

	tat_refresh_ban_cache_for_ckey(key)

	if(target_client)
		to_chat(target_client, span_boldannounce("You have been [applies_to_admins ? "admin " : ""]banned by [admin.key] from TAT [bucket_name].<br>Reason: [reason]<br>This ban is [isnull(duration) ? "permanent." : "temporary, it will be removed in [time_message]."] The round ID is [round_id]."))
		world.TgsAnnounceBan(
			key,
			admin.ckey,
			isnull(duration) ? 0 : duration,
			isnull(duration) ? "НАВСЕГДА" : time_message,
			list(sql_role),
			reason,
			severity,
			applies_to_admins
		)
	return TRUE

/proc/tat_remove_role_lock(raw_key, bucket, reason = null)
	var/client/admin = usr.client
	if(!admin?.holder || !check_rights_for(admin, R_BAN))
		return FALSE

	var/key = tat_normalize_ckey(raw_key)
	if(!key || !tat_is_valid_role_bucket(bucket))
		return FALSE

	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return FALSE

	var/sql_role = tat_role_bucket_to_ban_role(bucket)
	var/list/entry = tat_get_sql_ban_entry(key, sql_role)
	if(!islist(entry))
		return TRUE

	var/datum/DBQuery/query_unlock_tat_role = SSdbcore.NewQuery({"
		UPDATE [format_table_name("ban")]
		SET unbanned_datetime = NOW(),
			unbanned_ckey = :admin_ckey,
			unbanned_ip = INET_ATON(:admin_ip),
			unbanned_computerid = :admin_cid,
			unbanned_round_id = :round_id
		WHERE ckey = :ckey
			AND role = :role
			AND unbanned_datetime IS NULL
			AND (expiration_time IS NULL OR expiration_time > NOW())
	"}, list(
		"admin_ckey" = admin.ckey,
		"admin_ip" = tat_sql_safe_ip(admin.address),
		"admin_cid" = tat_sql_safe_cid(admin.computer_id),
		"round_id" = GLOB.round_id || 0,
		"ckey" = key,
		"role" = sql_role,
	))

	if(!query_unlock_tat_role.warn_execute())
		qdel(query_unlock_tat_role)
		return FALSE

	qdel(query_unlock_tat_role)

	var/bucket_name = tat_role_bucket_display_name(bucket)
	var/note_reason = "TAT role lock removed: [bucket_name][istext(reason) && length(trim(reason)) ? " - [trim(reason)]" : ""]"

	create_message("note", key, admin.ckey, note_reason, null, null, 0, 0, null, 0, "None")
	log_admin_private("[key_name(admin)] removed TAT role lock [bucket_name] from [key].")
	message_admins("[key_name_admin(admin)] removed TAT role lock [bucket_name] from [key].")

	var/client/C = GLOB.directory[key]
	if(C)
		build_ban_cache(C)
		to_chat(C, span_boldannounce("[admin.key] has removed your TAT [bucket_name] role lock."))
		world.TgsAnnounceUnban(
			key,
			admin.ckey,
			sql_role
		)
	return TRUE

/proc/tat_admin_can_manage_role_locks(client/C)
	return C?.holder && check_rights_for(C, R_BAN)
