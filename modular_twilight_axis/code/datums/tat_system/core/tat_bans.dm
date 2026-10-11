/proc/tat_normalize_ckey(raw_key)
	if(!istext(raw_key))
		return null
	var/key = ckey(raw_key)
	if(!length(key))
		return null
	return key

/proc/tat_role_bucket_names()
	return list(
		TAT_ROLE_BUCKET_TOWNER = "Towner",
		TAT_ROLE_BUCKET_TRADER = "Trader",
		TAT_ROLE_BUCKET_ADVENTURER = "Adventurer",
		TAT_ROLE_BUCKET_WRETCH = "Wretch",
	)

/proc/tat_is_valid_role_bucket(bucket)
	return istext(bucket) && (bucket in tat_role_bucket_names())

/proc/tat_role_bucket_display_name(bucket)
	return tat_role_bucket_names()[bucket] || "Unknown"

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

/proc/tat_is_ckey_banned(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	return key && is_banned_from(key, TAT_SQL_ROLE_SYSTEM)

/proc/tat_get_ban_reason(raw_key)
	var/list/entry = tat_get_sql_ban_entry(raw_key, TAT_SQL_ROLE_SYSTEM)
	var/reason = entry?["reason"]
	return istext(reason) && length(reason) ? reason : TAT_BAN_DEFAULT_REASON

/proc/tat_is_mob_banned(mob/user)
	return user?.ckey && tat_is_ckey_banned(user.ckey)

/proc/tat_tell_banned(mob/user)
	if(!user)
		return FALSE
	to_chat(user, span_warning("You are banned from using the TAT build system. Reason: [tat_get_ban_reason(user.ckey)]"))
	return TRUE

/// Applies an already-created stock role ban to an active TAT character.
/proc/tat_apply_restriction_side_effects_to_online_client(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	var/client/C = key ? GLOB.directory[key] : null
	if(!C || !ishuman(C.mob))
		return FALSE

	var/mob/living/carbon/human/H = C.mob
	var/datum/tat_build/build = C.prefs?.tat_build
	if(!build)
		return FALSE

	build.attach_preferences_from_mob(H)
	if(!(build.is_owner_tat_banned(H) || build.is_owner_tat_role_locked(H)))
		return TRUE

	build.disable_from_human(H)
	if(build.is_owner_tat_banned(H))
		tat_tell_banned(H)
	else
		to_chat(H, span_warning(build.get_owner_tat_role_lock_message(H)))
	return TRUE

/proc/tat_get_sql_ban_entry(raw_key, role)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !istext(role) || !length(role) || !SSdbcore.Connect())
		return null

	var/datum/DBQuery/query = SSdbcore.NewQuery({"
		SELECT id, bantime, round_id, role, expiration_time, TIMESTAMPDIFF(MINUTE, bantime, expiration_time), reason, a_ckey
		FROM [format_table_name("ban")]
		WHERE ckey = :ckey
			AND role = :role
			AND unbanned_datetime IS NULL
			AND (expiration_time IS NULL OR expiration_time > NOW())
		ORDER BY bantime DESC
		LIMIT 1
	"}, list("ckey" = key, "role" = role))
	if(!query.warn_execute())
		qdel(query)
		return null

	var/list/result
	if(query.NextRow())
		result = list(
			"id" = query.item[1],
			"bantime" = query.item[2],
			"round_id" = query.item[3],
			"role" = query.item[4],
			"expiration_time" = query.item[5],
			"duration_minutes" = query.item[6],
			"reason" = query.item[7],
			"locked_by" = query.item[8],
		)
	qdel(query)
	return result

/proc/tat_get_locked_role_entry(raw_key, bucket)
	if(!tat_is_valid_role_bucket(bucket))
		return null
	return tat_get_sql_ban_entry(raw_key, tat_role_bucket_to_ban_role(bucket))

/proc/tat_is_role_bucket_locked(raw_key, bucket)
	return islist(tat_get_locked_role_entry(raw_key, bucket))

/proc/tat_get_role_lock_reason(raw_key, bucket)
	var/list/entry = tat_get_locked_role_entry(raw_key, bucket)
	var/reason = entry?["reason"]
	return istext(reason) && length(reason) ? reason : null

/proc/tat_refresh_ban_cache_for_ckey(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	var/client/C = key ? GLOB.directory[key] : null
	if(C)
		build_ban_cache(C)
	return !!key
