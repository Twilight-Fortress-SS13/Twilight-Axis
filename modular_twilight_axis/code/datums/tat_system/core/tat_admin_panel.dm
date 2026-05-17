/// TGUI admin integration for SQL-backed TAT role locks.
///
/// The actual restriction rows are normal Twilight-Axis role bans in SS13_ban:
/// TAT Towner, TAT Trader, TAT Adventurer. This panel is only a pleasant TGUI
/// front-end over the stock ban pipeline.

/client/var/datum/tat_role_locks_admin_panel/tat_role_locks_panel

/proc/tat_get_role_lock_state_text(raw_key, bucket)
	return tat_is_role_bucket_locked(raw_key, bucket) ? "Locked" : "Open"

/proc/tat_apply_restriction_side_effects_to_online_client(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	if(!key)
		return FALSE

	for(var/client/C in GLOB.clients)
		if(C.ckey != key)
			continue

		if(!ishuman(C.mob))
			return TRUE

		var/mob/living/carbon/human/H = C.mob
		var/datum/tat_build/build = C.prefs?.tat_build
		if(!build)
			return TRUE

		build.attach_preferences_from_mob(H)

		if(build.is_owner_tat_banned(H) || build.is_owner_tat_role_locked(H))
			build.disable_from_human(H)

			if(build.is_owner_tat_banned(H))
				tat_tell_banned(H)
			else
				to_chat(H, span_warning(build.get_owner_tat_role_lock_message(H)))

		return TRUE

	return FALSE

/client/proc/tat_admin_set_role_bucket_for_ckey(raw_key, bucket, allow_role = null, reason = null, duration = null, interval = TAT_ROLE_LOCK_DEFAULT_INTERVAL, severity = TAT_ROLE_LOCK_DEFAULT_SEVERITY, applies_to_admins = FALSE)
	if(!tat_admin_can_manage_role_locks(src))
		return FALSE

	var/key = tat_normalize_ckey(raw_key)
	if(!key)
		to_chat(src, span_warning("Invalid ckey."))
		return FALSE

	if(!tat_is_valid_role_bucket(bucket))
		to_chat(src, span_warning("Invalid TAT role bucket."))
		return FALSE

	if(isnull(allow_role))
		allow_role = tat_is_role_bucket_locked(key, bucket)

	var/bucket_name = tat_role_bucket_display_name(bucket)

	if(allow_role)
		if(!tat_remove_role_lock(src, key, bucket, reason))
			to_chat(src, span_warning("Failed to unlock [bucket_name] TAT role for [key]."))
			return FALSE

		tat_apply_restriction_side_effects_to_online_client(key)
		return TRUE

	if(!istext(reason) || !length(trim(reason)))
		reason = TAT_ROLE_LOCK_DEFAULT_REASON
	else
		reason = trim(reason)

	if(!tat_create_role_lock(src, key, bucket, duration, interval, severity, reason, applies_to_admins))
		to_chat(src, span_warning("Failed to lock [bucket_name] TAT role for [key]."))
		return FALSE

	tat_apply_restriction_side_effects_to_online_client(key)
	return TRUE

/// Builds a tiny legacy href entry for the INDIVIDUAL player panel.
/// The actual controls are TGUI; this is only the launch button for the old browse() player panel.
/proc/tat_build_admin_role_locks_html(raw_key, href_prefix, refresh_ref = null)
	var/key = tat_normalize_ckey(raw_key)
	if(!key || !istext(href_prefix) || !length(href_prefix))
		return ""

	return "<br><hr><b>TAT role locks:</b> <a href='[href_prefix];tat_open_role_locks=[key]'>Open TGUI</a>"

/// Call this near the top of /datum/admins/Topic(), after CheckAdminHref().
/// Returns TRUE when the href was a TAT action and was fully handled.
/client/proc/tat_handle_admin_panel_href(list/href_list)
	if(!holder || !islist(href_list))
		return FALSE

	var/key = href_list["tat_open_role_locks"]
	if(!key)
		return FALSE

	tat_open_role_locks_panel(key)
	return TRUE

/client/proc/tat_open_role_locks_panel(raw_key = null)
	if(!tat_admin_can_manage_role_locks(src))
		to_chat(src, span_warning("You need ban permissions to manage TAT role locks."))
		return FALSE

	if(QDELETED(tat_role_locks_panel))
		tat_role_locks_panel = null

	if(!tat_role_locks_panel)
		tat_role_locks_panel = new(src)

	if(raw_key)
		tat_role_locks_panel.set_selected_ckey(raw_key)

	tat_role_locks_panel.ui_interact(mob)
	return TRUE

/client/proc/tat_role_locks_panel()
	set name = "TAT Role Locks"
	set category = "-Admin-"

	tat_open_role_locks_panel()

/proc/tat_cmp_client_ckey_asc(client/A, client/B)
	return sorttext(A?.ckey || "", B?.ckey || "")

/datum/ui_state/tat_role_locks_admin_state/can_use_topic(src_object, mob/user)
	if(tat_admin_can_manage_role_locks(user?.client))
		return UI_INTERACTIVE

	return UI_CLOSE

/datum/tat_role_locks_admin_panel
	var/client/admin_client
	var/selected_ckey
	var/filter = ""
	var/default_reason = TAT_ROLE_LOCK_DEFAULT_REASON
	var/duration = TAT_ROLE_LOCK_DEFAULT_DURATION
	var/interval = TAT_ROLE_LOCK_DEFAULT_INTERVAL
	var/permanent = FALSE
	var/severity = TAT_ROLE_LOCK_DEFAULT_SEVERITY
	var/applies_to_admins = FALSE

/datum/tat_role_locks_admin_panel/New(client/C)
	. = ..()
	admin_client = C

	if(C?.ckey)
		selected_ckey = C.ckey

/datum/tat_role_locks_admin_panel/proc/set_selected_ckey(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	if(!key)
		return FALSE

	selected_ckey = key
	return TRUE

/datum/tat_role_locks_admin_panel/ui_state(mob/user)
	var/static/datum/ui_state/tat_role_locks_admin_state/state = new
	return state

/datum/tat_role_locks_admin_panel/ui_interact(mob/user, datum/tgui/ui)
	if(!tat_admin_can_manage_role_locks(user?.client))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TatRoleLocksPanel")
		ui.open()

/datum/tat_role_locks_admin_panel/proc/build_player_rows()
	var/list/result = list()
	var/filter_key = lowertext(trim(filter || ""))

	for(var/client/C in sort_list(GLOB.clients, GLOBAL_PROC_REF(tat_cmp_client_ckey_asc)))
		if(!C?.ckey)
			continue

		if(length(filter_key) && !findtext(lowertext(C.ckey), filter_key) && !findtext(lowertext(C.key), filter_key))
			continue

		result += list(list(
			"key" = C.key,
			"ckey" = C.ckey,
			"mob_name" = C.mob ? "[C.mob]" : "No mob",
			"selected" = (C.ckey == selected_ckey),
		))

	return result

/datum/tat_role_locks_admin_panel/proc/build_role_rows(raw_key)
	var/key = tat_normalize_ckey(raw_key)
	var/list/result = list()
	var/list/names = tat_role_bucket_names()

	for(var/bucket in names)
		var/list/active_entry = key ? tat_get_locked_role_entry(key, bucket) : null
		var/list/history_entry = key ? tat_get_role_lock_history_entry(key, bucket) : null
		var/active_lock = islist(active_entry)

		var/list/display_entry = active_lock ? active_entry : history_entry

		var/expires = ""
		if(active_lock)
			expires = active_entry["expiration_time"] ? "Expires [active_entry["expiration_time"]]" : "Permanent"
		else if(islist(history_entry))
			if(history_entry["unbanned_datetime"])
				expires = "Removed [history_entry["unbanned_datetime"]]"
			else if(history_entry["expiration_time"])
				expires = "Expired [history_entry["expiration_time"]]"
			else
				expires = "Inactive"

		var/reason = "Open"
		if(active_lock)
			reason = active_entry["reason"] || TAT_ROLE_LOCK_DEFAULT_REASON
		else if(islist(history_entry))
			if(history_entry["reason"])
				reason = "Previous: [history_entry["reason"]]"
			else
				reason = "Previous lock exists"

		result += list(list(
			"id" = bucket,
			"name" = names[bucket],
			"locked" = active_lock,
			"state" = active_lock ? "Locked" : "Open",
			"reason" = reason,
			"locked_by" = islist(display_entry) ? (display_entry["locked_by"] || "") : "",
			"locked_at" = islist(display_entry) ? (display_entry["bantime"] || "") : "",
			"expires" = expires,
			"ban_id" = islist(display_entry) ? (display_entry["id"] || "") : "",
			"expired_entry" = islist(history_entry) && !active_lock,
		))

	return result

/datum/tat_role_locks_admin_panel/ui_data(mob/user)
	if(!tat_admin_can_manage_role_locks(user?.client))
		return list()

	var/list/data = list()
	data["players"] = build_player_rows()
	data["selected_ckey"] = selected_ckey
	data["filter"] = filter
	data["default_reason"] = default_reason
	data["duration"] = duration
	data["interval"] = interval
	data["permanent"] = permanent
	data["severity"] = severity
	data["applies_to_admins"] = applies_to_admins
	data["roles"] = build_role_rows(selected_ckey)

	return data

/datum/tat_role_locks_admin_panel/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(!tat_admin_can_manage_role_locks(usr?.client))
		return FALSE

	switch(action)
		if("select_player")
			return set_selected_ckey(params["ckey"])

		if("set_filter")
			filter = copytext(params["filter"] || "", 1, 64)
			return TRUE

		if("set_manual_ckey")
			return set_selected_ckey(params["ckey"])

		if("set_default_reason")
			default_reason = copytext(params["reason"] || TAT_ROLE_LOCK_DEFAULT_REASON, 1, 512)
			return TRUE

		if("set_duration")
			duration = max(1, text2num(params["duration"] || TAT_ROLE_LOCK_DEFAULT_DURATION))
			return TRUE

		if("set_interval")
			var/new_interval = uppertext(params["interval"] || TAT_ROLE_LOCK_DEFAULT_INTERVAL)
			if(new_interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR"))
				interval = new_interval

			return TRUE

		if("set_permanent")
			permanent = !!params["permanent"]
			return TRUE

		if("set_severity")
			var/new_severity = params["severity"] || TAT_ROLE_LOCK_DEFAULT_SEVERITY
			if(new_severity in list("None", "Minor", "Medium", "High"))
				severity = new_severity

			return TRUE

		if("set_applies_to_admins")
			applies_to_admins = !!params["applies_to_admins"]
			return TRUE

		if("toggle_role")
			var/key = tat_normalize_ckey(params["ckey"] || selected_ckey)
			var/bucket = params["bucket"]

			if(!key || !tat_is_valid_role_bucket(bucket))
				return FALSE

			var/allow_role = tat_is_role_bucket_locked(key, bucket)
			var/reason = params["reason"] || default_reason || TAT_ROLE_LOCK_DEFAULT_REASON
			var/actual_duration = permanent ? null : duration

			if(allow_role)
				return tat_remove_role_lock(key, bucket, reason)

			return usr.client.tat_admin_set_role_bucket_for_ckey(key, bucket, allow_role, reason, actual_duration, interval, severity, applies_to_admins)

	return FALSE
