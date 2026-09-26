
#define MAX_ADMINBANS_PER_ADMIN 1
#define MAX_ADMINBANS_PER_HEADMIN 3

/proc/ta_roleban_list(list/base, list/extras)
	. = list()
	if(base)
		. |= base
	if(extras)
		. |= extras

/proc/ta_roleban_canonical_role(role)
	if(!role)
		return
	switch(role)
		if("Sultan")
			return "Grand Duke"
		if("Vizier")
			return "Hand"
		if("Sheikh")
			return "Councillor"
		if("Head Slave")
			return "Seneschal"
		if("Palace Slave")
			return "Servant"
		if("Harem Favorite")
			return "Suitor"
		if("Cataphract", "Royal Knight")
			return "Knight"
		if("Sergeant", "Janissary Sergeant", "Azeb Agha", "Royal Guard Sergeant")
			return "Sergeant-at-Arms"
		if("Man-at-Arms")
			return "Man at Arms"
		if("Royal Guard", "Janissary")
			return "Man at Arms"
		if("Vanguard", "Azeb", "Azeb Agha")
			return "Warden"
		if("Freeman", "Lost Grenzel")
			return ROLE_BANDIT
	return role

/proc/ta_roleban_canonicalize_roles(roles)
	. = list()
	if(islist(roles))
		for(var/role in roles)
			var/canonical_role = ta_roleban_canonical_role(role)
			if(canonical_role)
				. |= canonical_role
	else
		var/canonical_role = ta_roleban_canonical_role(roles)
		if(canonical_role)
			. |= canonical_role

/proc/ta_roleban_panel_list(list/base, list/extras)
	return ta_roleban_canonicalize_roles(ta_roleban_list(base, extras))

/proc/ta_roleban_panel_list_without(list/base, list/extras, list/excluded)
	. = ta_roleban_panel_list(base, extras)
	for(var/role in ta_roleban_canonicalize_roles(excluded))
		. -= role

/proc/ta_roleban_department_class(department)
	switch(department)
		if("Ducal Family")
			return "nobles"
		if("Courtiers")
			return "courtier"
		if("Retinue")
			return "mercenaries"
		if("Wanderers")
			return "yeomen"
		if("Burghers")
			return "yeomen"
		if("ATC")
			return "mercenaries"
	return ckey(department)


/proc/ta_roleban_department_style(department)
	switch(department)
		if("Ducal Family")
			return "background-color: #aa83b9; color: #443a39;"
		if("Courtiers")
			return "background-color: #81adc8; color: #443a39;"
		if("Retinue")
			return "background-color: #c86e3a; color: #443a39;"
		if("Wanderers")
			return "background-color: #819e82; color: #443a39;"
		if("Burghers")
			return "background-color: #819e82; color: #443a39;"
		if("ATC")
			return "background-color: #c86e3a; color: #443a39;"
	return null

/proc/ta_roleban_department_style_attribute(department)
	var/department_style = ta_roleban_department_style(department)
	if(department == "Garrison")
		if(department_style)
			department_style += " display: block; width: 100%; box-sizing: border-box; text-align: center;"
		else
			department_style = "display: block; width: 100%; box-sizing: border-box; text-align: center;"
	if(department_style)
		return " style='[department_style]'"
	return ""

/proc/ta_roleban_department_column_style_attribute(department)
	switch(department)
		if("Garrison")
			return " style='clear: both; float: none; width: 100%; display: block; margin-top: 8px; text-align: center;'"
	return ""

/proc/ta_roleban_department_content_style_attribute(department)
	switch(department)
		if("Garrison")
			return " style='display: block; width: 100%; text-align: center;'"
	return ""

/proc/ta_roleban_equivalent_roles(role)
	. = list()
	if(!role)
		return
	var/canonical_role = ta_roleban_canonical_role(role)
	if(canonical_role)
		. |= canonical_role
	. |= role
	switch(canonical_role)
		if("Grand Duke")
			. |= list("Sultan")
		if("Hand")
			. |= list("Vizier")
		if("Councillor")
			. |= list("Sheikh")
		if("Seneschal")
			. |= list("Head Slave")
		if("Servant")
			. |= list("Palace Slave")
		if("Suitor")
			. |= list("Harem Favorite")
		if("Knight")
			. |= list("Cataphract", "Royal Knight")
		if("Sergeant-at-Arms")
			. |= list("Sergeant", "Janissary Sergeant", "Azeb Agha", "Royal Guard Sergeant")
		if("Man at Arms")
			. |= list("Royal Guard", "Janissary")
		if("Warden")
			. |= list("Vanguard", "Azeb")
		if(ROLE_BANDIT)
			. |= list("Freeman", "Lost Grenzel")

/proc/ta_roleban_expand_roles(roles)
	. = list()
	if(islist(roles))
		for(var/role in roles)
			. |= ta_roleban_equivalent_roles(role)
	else
		. |= ta_roleban_equivalent_roles(roles)

/proc/ta_roleban_display_name(role)
	if(!role)
		return role
	if(role == ROLE_CULT)
		return "Zizo Cultist"
	var/list/linked_roles = ta_roleban_equivalent_roles(role)
	linked_roles -= role
	if(role == "Sergeant-at-Arms")
		linked_roles -= "Sergeant"
	if(!length(linked_roles))
		return role
	return "[role] ([linked_roles.Join(", ")])"

/proc/ta_roleban_is_already_banned(role, list/banned_from)
	if(!role || !length(banned_from))
		return FALSE
	for(var/check_role in ta_roleban_equivalent_roles(role))
		if(check_role in banned_from)
			return TRUE
	return FALSE

//checks client ban cache or DB ban table if ckey is banned from one or more roles
//doesn't return any details, use only for if statements
/proc/is_banned_from(player_ckey, list/roles)
	if(!player_ckey)
		return
	roles = ta_roleban_expand_roles(roles)
	if(!length(roles))
		return
	var/client/C = GLOB.directory[player_ckey]
	if(C)
		if(!C.ban_cache)
			build_ban_cache(C)
		if(islist(roles))
			for(var/R in roles)
				if(R in C.ban_cache)
					return TRUE //they're banned from at least one role, no need to keep checking
		else if(roles in C.ban_cache)
			return TRUE
	else
		var/values = list(
			"player_ckey" = player_ckey,
			"must_apply_to_admins" = !!(GLOB.admin_datums[player_ckey] || GLOB.deadmins[player_ckey]),
		)
		var/sql_roles
		if(islist(roles))
			var/list/sql_roles_list = list()
			for (var/i in 1 to roles.len)
				values["role[i]"] = roles[i]
				sql_roles_list += ":role[i]"
			sql_roles = sql_roles_list.Join(", ")
		else
			values["role"] = roles
			sql_roles = ":role"
		var/datum/DBQuery/query_check_ban = SSdbcore.NewQuery({"
			SELECT 1
			FROM [format_table_name("ban")]
			WHERE
				ckey = :player_ckey AND
				role IN ([sql_roles]) AND
				unbanned_datetime IS NULL AND
				(expiration_time IS NULL OR expiration_time > NOW())
				AND (NOT :must_apply_to_admins OR applies_to_admins = 1)
		"}, values)
		if(!query_check_ban.warn_execute())
			qdel(query_check_ban)
			return
		if(query_check_ban.NextRow())
			qdel(query_check_ban)
			return TRUE
		qdel(query_check_ban)

//checks DB ban table if a ckey, ip and/or cid is banned from a specific role
//returns an associative nested list of each matching row's ban id, bantime, ban round id, expiration time, ban duration, applies to admins, reason, key, ip, cid and banning admin's key in that order
/proc/is_banned_from_with_details(player_ckey, player_ip, player_cid, role)
	if(!player_ckey && !player_ip && !player_cid)
		return
	var/list/check_roles = ta_roleban_expand_roles(role)
	if(!length(check_roles))
		return
	var/list/role_values = list("ckey" = player_ckey, "ip" = player_ip, "computerid" = player_cid)
	var/list/sql_roles_list = list()
	for(var/i in 1 to check_roles.len)
		role_values["role[i]"] = check_roles[i]
		sql_roles_list += ":role[i]"
	var/sql_roles = sql_roles_list.Join(", ")
	var/datum/DBQuery/query_check_ban = SSdbcore.NewQuery({"
		SELECT
			id,
			bantime,
			round_id,
			expiration_time,
			TIMESTAMPDIFF(MINUTE, bantime, expiration_time),
			applies_to_admins,
			reason,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey),
			INET_NTOA(ip),
			computerid,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey)
		FROM [format_table_name("ban")]
		WHERE role IN ([sql_roles])
			AND (ckey = :ckey OR ip = INET_ATON(:ip) OR computerid = :computerid)
			AND unbanned_datetime IS NULL
			AND (expiration_time IS NULL OR expiration_time > NOW())
		ORDER BY bantime DESC
	"}, role_values)
	if(!query_check_ban.warn_execute())
		qdel(query_check_ban)
		return
	. = list()
	while(query_check_ban.NextRow())
		. += list(list("id" = query_check_ban.item[1], "bantime" = query_check_ban.item[2], "round_id" = query_check_ban.item[3], "expiration_time" = query_check_ban.item[4], "duration" = query_check_ban.item[5], "applies_to_admins" = query_check_ban.item[6], "reason" = query_check_ban.item[7], "key" = query_check_ban.item[8], "ip" = query_check_ban.item[9], "computerid" = query_check_ban.item[10], "admin_key" = query_check_ban.item[11]))
	qdel(query_check_ban)

/proc/build_ban_cache(client/C)
	if(!SSdbcore.Connect())
		return
	if(C && istype(C))
		C.ban_cache = list()
		var/is_admin = FALSE
		if(GLOB.admin_datums[C.ckey] || GLOB.deadmins[C.ckey])
			is_admin = TRUE
		var/datum/DBQuery/query_build_ban_cache = SSdbcore.NewQuery(
			"SELECT role, applies_to_admins FROM [format_table_name("ban")] WHERE ckey = :ckey AND unbanned_datetime IS NULL AND (expiration_time IS NULL OR expiration_time > NOW())",
			list("ckey" = C.ckey)
		)
		if(!query_build_ban_cache.warn_execute())
			qdel(query_build_ban_cache)
			return
		while(query_build_ban_cache.NextRow())
			if(is_admin && !text2num(query_build_ban_cache.item[2]))
				continue
			C.ban_cache[query_build_ban_cache.item[1]] = TRUE
		qdel(query_build_ban_cache)

/proc/ta_roleban_tgui_groups()
	var/list/listed_rolebans = list()
	var/list/groups = list()
	var/list/group_sources = list(
		"Ducal Family" = ta_roleban_panel_list_without(GLOB.noble_positions, list("Grand Duke", "Sultan"), list("Suitor", "Harem Favorite")),
		"Courtiers" = ta_roleban_panel_list(GLOB.courtier_positions, list("Hand", "Councillor", "Seneschal", "Vizier", "Sheikh", "Head Slave", "Suitor", "Harem Favorite")),
		"Retinue" = ta_roleban_panel_list(GLOB.retinue_positions, list("Knight", "Cataphract", "Royal Knight")),
		"Garrison" = ta_roleban_panel_list(ta_roleban_list(ta_roleban_list(GLOB.garrison_positions, GLOB.citywatch_positions), GLOB.vanguard_positions), list("Sergeant-at-Arms", "Man at Arms", "Sergeant", "Janissary Sergeant", "Janissary", "Azeb Agha", "Royal Guard Sergeant", "Royal Guard", "Slave Master", "Warden", "Vanguard", "Azeb", "Sheriff", "Watchman")),
		"Church" = ta_roleban_panel_list(GLOB.church_positions, null),
		"Inquisition" = ta_roleban_panel_list(GLOB.inquisition_positions, null),
		"Wanderers" = ta_roleban_panel_list(GLOB.wanderer_positions, null),
		"Abstract" = list("Appearance", "Emote", "Deadchat", "OOC", "LOOC", "MENTORHELP"),
		"Peasants" = ta_roleban_panel_list(GLOB.peasant_positions, list("Servant", "Palace Slave")),
		"Burghers" = ta_roleban_panel_list(GLOB.burgher_positions, null),
		"ATC" = ta_roleban_panel_list(GLOB.atc_positions, null),
		"Sidefolk" = ta_roleban_panel_list(GLOB.sidefolk_positions, null),
		"Ghost and Other Roles" = list(ROLE_NECRO_SKELETON, ROLE_LICH_SKELETON, ROLE_UNBOUND_DEATHKNIGHT, ROLE_DARK_ITINERANT),
		"Antagonist Positions" = ta_roleban_panel_list(list(ROLE_ASCENDANT, ROLE_ASPIRANT, ROLE_BANDIT, "Freeman", "Lost Grenzel", ROLE_NBEAST, ROLE_WEREWOLF, ROLE_LICH, ROLE_PREBEL, ROLE_REBEL_LEADER, ROLE_CULT), null),
		"Lesser Antagonst Positions" = list(ROLE_WRETCH, ROLE_DREAMWALKER, ROLE_GNOLL, ROLE_VAMPIRE),
	)
	for(var/group_name in group_sources)
		var/list/display_roles = list()
		for(var/role in group_sources[group_name])
			var/canonical_role = ta_roleban_canonical_role(role)
			if(!canonical_role || (canonical_role in listed_rolebans))
				continue
			listed_rolebans |= canonical_role
			display_roles += list(list(
				"name" = canonical_role,
				"display_name" = ta_roleban_display_name(canonical_role),
			))
		if(length(display_roles))
			groups += list(list(
				"name" = group_name,
				"roles" = display_roles,
			))
	return groups

/proc/ta_roleban_tgui_roles()
	var/list/roles = list()
	for(var/list/group in ta_roleban_tgui_groups())
		for(var/list/role_data in group["roles"])
			roles |= role_data["name"]
	return roles

/datum/admin_ban_panel
	var/datum/admins/admin_holder
	var/mode = "ban"
	var/ban_player_key
	var/ban_player_ip
	var/ban_player_cid
	var/ban_key_enabled = TRUE
	var/ban_ip_enabled = FALSE
	var/ban_cid_enabled = TRUE
	var/ban_use_last_connection = TRUE
	var/ban_applies_to_admins = FALSE
	var/ban_permanent = FALSE
	var/ban_duration = 1440
	var/ban_interval = "MINUTE"
	var/ban_reason
	var/ban_role
	var/edit_id
	var/edit_old_key
	var/edit_old_ip
	var/edit_old_cid
	var/edit_old_applies_to_admins = FALSE
	var/edit_old_duration
	var/edit_old_reason
	var/edit_admin_key
	var/form_revision = 0
	var/search_player_key
	var/search_admin_key
	var/search_player_ip
	var/search_player_cid
	var/search_page = 0
	var/search_active_only = TRUE

/datum/admin_ban_panel/New(datum/admins/new_admin_holder, panel_mode = "ban", player_key, player_ip, player_cid, role, duration = 1440, applies_to_admins, reason, new_edit_id, page, admin_key)
	admin_holder = new_admin_holder
	mode = (panel_mode in list("ban", "unban")) ? panel_mode : "ban"
	ban_player_key = player_key
	ban_player_ip = player_ip
	ban_player_cid = player_cid
	ban_key_enabled = TRUE
	ban_ip_enabled = !!player_ip
	ban_cid_enabled = isnull(new_edit_id) ? TRUE : !!player_cid
	ban_use_last_connection = isnull(new_edit_id)
	ban_applies_to_admins = !!applies_to_admins
	ban_permanent = isnull(duration)
	ban_duration = isnull(duration) ? 1440 : duration
	ban_reason = reason
	ban_role = role
	edit_id = new_edit_id
	edit_old_key = player_key
	edit_old_ip = player_ip
	edit_old_cid = player_cid
	edit_old_applies_to_admins = !!applies_to_admins
	edit_old_duration = duration
	edit_old_reason = reason
	edit_admin_key = admin_key
	search_player_key = mode == "unban" ? player_key : null
	search_admin_key = mode == "unban" ? admin_key : null
	search_player_ip = mode == "unban" ? player_ip : null
	search_player_cid = mode == "unban" ? player_cid : null
	search_page = max(0, text2num(page))

/datum/admin_ban_panel/Destroy(force)
	SStgui.close_uis(src)
	admin_holder = null
	return ..()

/datum/admin_ban_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AdminBanPanel")
		ui.open()

/datum/admin_ban_panel/ui_close(mob/user)
	. = ..()
	if(!QDELETED(src))
		qdel(src)

/datum/admin_ban_panel/ui_state(mob/user)
	return GLOB.tgui_always_state

/datum/admin_ban_panel/ui_data(mob/user)
	var/list/data = list()
	if(!user?.client || user.client.holder != admin_holder || !check_rights_for(user.client, R_BAN))
		return data
	data["mode"] = mode
	data["form_revision"] = form_revision
	data["is_editing"] = !!edit_id
	data["ban_form"] = list(
		"player_key" = ban_player_key,
		"player_ip" = ban_player_ip,
		"player_cid" = ban_player_cid,
		"key_enabled" = ban_key_enabled,
		"ip_enabled" = ban_ip_enabled,
		"cid_enabled" = ban_cid_enabled,
		"use_last_connection" = ban_use_last_connection,
		"applies_to_admins" = ban_applies_to_admins,
		"permanent" = ban_permanent,
		"duration" = ban_duration,
		"interval" = ban_interval,
		"reason" = ban_reason,
		"role" = ban_role,
	)
	data["role_groups"] = ta_roleban_tgui_groups()
	data["banned_roles"] = mode == "ban" ? get_banned_roles() : list()
	data["search"] = list(
		"player_key" = search_player_key,
		"admin_key" = search_admin_key,
		"player_ip" = search_player_ip,
		"player_cid" = search_player_cid,
		"active_only" = search_active_only,
	)
	if(mode == "unban")
		populate_unban_data(data)
	else
		data["has_search"] = FALSE
		data["total_bans"] = 0
		data["results"] = list()
	return data

/datum/admin_ban_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!usr?.client || usr.client.holder != admin_holder || !check_rights_for(usr.client, R_BAN))
		return FALSE
	switch(action)
		if("set_mode")
			var/new_mode = params["mode"]
			if(new_mode in list("ban", "unban"))
				mode = new_mode
			return TRUE
		if("search_unbans")
			search_player_key = limited_text(params["player_key"], 64)
			search_admin_key = limited_text(params["admin_key"], 64)
			search_player_ip = limited_text(params["player_ip"], 64)
			search_player_cid = limited_text(params["player_cid"], 64)
			search_active_only = !!params["active_only"]
			search_page = 0
			mode = "unban"
			return TRUE
		if("submit_ban")
			return submit_ban(params)
		if("bulk_unban")
			var/list/ban_ids = params["ban_ids"]
			if(!islist(ban_ids))
				ban_ids = list(ban_ids)
			return admin_holder.unban_ids(ban_ids)
		if("edit_ban")
			return load_edit_ban(params["ban_id"])
		if("cancel_edit")
			clear_edit()
			mode = "unban"
			return TRUE
		if("edit_log")
			admin_holder.ban_log(params["ban_id"])
			return TRUE
	return FALSE

/datum/admin_ban_panel/proc/limited_text(value, maximum_length)
	if(isnull(value))
		return null
	var/text = trim("[value]")
	if(!length(text))
		return null
	return copytext_char(text, 1, maximum_length + 1)

/datum/admin_ban_panel/proc/get_banned_roles()
	var/list/banned_roles = list()
	if(!ban_player_key || !SSdbcore.Connect())
		return banned_roles
	var/datum/DBQuery/query_get_banned_roles = SSdbcore.NewQuery({"
		SELECT role
		FROM [format_table_name("ban")]
		WHERE
			ckey = :player_ckey AND
			role <> 'server' AND
			unbanned_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW())
	"}, list("player_ckey" = ckey(ban_player_key)))
	if(!query_get_banned_roles.warn_execute())
		qdel(query_get_banned_roles)
		return banned_roles
	while(query_get_banned_roles.NextRow())
		banned_roles |= ta_roleban_canonical_role(query_get_banned_roles.item[1])
	qdel(query_get_banned_roles)
	return banned_roles

/datum/admin_ban_panel/proc/populate_unban_data(list/data)
	data["has_search"] = FALSE
	data["total_bans"] = 0
	data["results"] = list()
	if(!search_player_key && !search_admin_key && !search_player_ip && !search_player_cid)
		return
	data["has_search"] = TRUE
	if(!SSdbcore.Connect())
		return
	var/active_filter = search_active_only ? " AND unbanned_datetime IS NULL AND (expiration_time IS NULL OR expiration_time > NOW())" : ""
	var/list/query_parameters = list(
		"player_key" = ckey(search_player_key),
		"admin_key" = ckey(search_admin_key),
		"player_ip" = search_player_ip || null,
		"player_cid" = search_player_cid || null,
	)
	var/datum/DBQuery/query_unban_search_bans = SSdbcore.NewQuery({"
		SELECT
			id,
			bantime,
			round_id,
			role,
			expiration_time,
			TIMESTAMPDIFF(MINUTE, bantime, expiration_time),
			IF(expiration_time < NOW(), 1, NULL),
			applies_to_admins,
			reason,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey),
			INET_NTOA(ip),
			computerid,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey),
			IF(edits IS NOT NULL, 1, NULL),
			unbanned_datetime,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].unbanned_ckey), unbanned_ckey),
			unbanned_round_id
		FROM [format_table_name("ban")]
		WHERE
			(:player_key IS NULL OR ckey = :player_key) AND
			(:admin_key IS NULL OR a_ckey = :admin_key) AND
			(:player_ip IS NULL OR ip = INET_ATON(:player_ip)) AND
			(:player_cid IS NULL OR computerid = :player_cid)
			[active_filter]
		ORDER BY CASE WHEN role = 'Server' THEN 0 ELSE 1 END, id DESC
	"}, query_parameters)
	if(!query_unban_search_bans.warn_execute())
		qdel(query_unban_search_bans)
		return
	var/list/results = list()
	while(query_unban_search_bans.NextRow())
		var/expiration_time = query_unban_search_bans.item[5]
		var/duration = query_unban_search_bans.item[6]
		var/expired = !!text2num(query_unban_search_bans.item[7])
		var/unban_datetime = query_unban_search_bans.item[15]
		var/result_player_key = query_unban_search_bans.item[10]
		var/result_player_ip = query_unban_search_bans.item[11]
		var/result_player_cid = query_unban_search_bans.item[12]
		results += list(list(
			"id" = text2num(query_unban_search_bans.item[1]),
			"ban_datetime" = query_unban_search_bans.item[2],
			"ban_round_id" = query_unban_search_bans.item[3],
			"role" = query_unban_search_bans.item[4],
			"expiration_time" = expiration_time,
			"duration" = expiration_time ? DisplayTimeText(text2num(duration) MINUTES) : "Permanent",
			"expired" = expired,
			"applies_to_admins" = !!text2num(query_unban_search_bans.item[8]),
			"reason" = query_unban_search_bans.item[9],
			"player_key" = result_player_key,
			"player_ip" = result_player_ip,
			"player_cid" = result_player_cid,
			"target" = admin_holder.ban_target_string(result_player_key, result_player_ip, result_player_cid),
			"admin_key" = query_unban_search_bans.item[13],
			"has_edits" = !!text2num(query_unban_search_bans.item[14]),
			"unban_datetime" = unban_datetime,
			"unban_key" = query_unban_search_bans.item[16],
			"unban_round_id" = query_unban_search_bans.item[17],
			"active" = !expired && !unban_datetime,
		))
	qdel(query_unban_search_bans)
	data["total_bans"] = length(results)
	data["results"] = results


/datum/admin_ban_panel/proc/parse_ban_form(list/params)
	var/list/errors = list()
	var/list/form = list()
	var/key_enabled = !!params["key_enabled"]
	var/ip_enabled = !!params["ip_enabled"]
	var/cid_enabled = !!params["cid_enabled"]
	var/use_last_connection = !!params["use_last_connection"]
	var/player_key = key_enabled ? limited_text(params["player_key"], 64) : null
	var/player_ip = ip_enabled && !use_last_connection ? limited_text(params["player_ip"], 64) : null
	var/player_cid = cid_enabled && !use_last_connection ? limited_text(params["player_cid"], 64) : null
	if(key_enabled && !player_key)
		errors += "Key was enabled but none was provided."
	if(ip_enabled && !use_last_connection && !player_ip)
		errors += "IP was enabled but none was provided."
	if(cid_enabled && !use_last_connection && !player_cid)
		errors += "CID was enabled but none was provided."
	if(!player_key && !player_ip && !player_cid)
		errors += "At least a key, IP or CID must be provided."
	if(use_last_connection && !player_key)
		errors += "A key is required to use the last connection."
	if(use_last_connection && !ip_enabled && !cid_enabled)
		errors += "Use last connection was enabled, but neither IP nor CID was enabled."
	var/permanent = !!params["permanent"]
	var/duration
	var/interval = uppertext(limited_text(params["interval"], 16) || "MINUTE")
	if(!permanent)
		duration = text2num(params["duration"])
		if(duration <= 0)
			errors += "Temporary bans require a duration greater than zero."
	if(!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"
	var/reason = limited_text(params["reason"], 2048)
	if(!reason)
		errors += "A reason is required."
	form["errors"] = errors
	form["player_key"] = player_key
	form["ip_enabled"] = ip_enabled
	form["player_ip"] = player_ip
	form["cid_enabled"] = cid_enabled
	form["player_cid"] = player_cid
	form["use_last_connection"] = use_last_connection
	form["applies_to_admins"] = !!params["applies_to_admins"]
	form["duration"] = permanent ? null : duration
	form["interval"] = interval
	form["reason"] = reason
	return form

/datum/admin_ban_panel/proc/submit_ban(list/params)
	var/list/form = parse_ban_form(params)
	var/list/errors = form["errors"]
	if(edit_id)
		var/list/changes = list()
		var/new_player_key = form["player_key"]
		var/new_player_ip = form["player_ip"]
		var/new_player_cid = form["player_cid"]
		var/new_applies_to_admins = form["applies_to_admins"]
		var/new_duration = form["duration"]
		var/new_interval = form["interval"]
		var/new_reason = form["reason"]
		if(new_player_key != edit_old_key)
			changes["Key"] = "[edit_old_key] to [new_player_key]"
		if(form["use_last_connection"] && form["ip_enabled"])
			changes["IP"] = "[edit_old_ip] to last connection"
		else if(new_player_ip != edit_old_ip)
			changes["IP"] = "[edit_old_ip] to [new_player_ip]"
		if(form["use_last_connection"] && form["cid_enabled"])
			changes["CID"] = "[edit_old_cid] to last connection"
		else if(new_player_cid != edit_old_cid)
			changes["CID"] = "[edit_old_cid] to [new_player_cid]"
		if(new_applies_to_admins != edit_old_applies_to_admins)
			changes["Applies to admins"] = "[edit_old_applies_to_admins] to [new_applies_to_admins]"
		if(isnull(new_duration) != isnull(edit_old_duration) || (!isnull(new_duration) && (text2num(new_duration) != text2num(edit_old_duration) || new_interval != "MINUTE")))
			var/old_duration_text = isnull(edit_old_duration) ? "permanent" : "[edit_old_duration] MINUTE"
			var/new_duration_text = isnull(new_duration) ? "permanent" : "[new_duration] [new_interval]"
			changes["Duration"] = "[old_duration_text] to [new_duration_text]"
		if(new_reason != edit_old_reason)
			changes["Reason"] = "[edit_old_reason]<br>to<br>[new_reason]"
		if(!length(changes))
			errors += "No changes were detected."
		if(length(errors))
			to_chat(usr, span_danger("Ban not edited because the following errors were present:\n[errors.Join("\n")]"))
			return TRUE
		var/mirror_edit = !!params["mirror_edit"]
		if(admin_holder.edit_ban(edit_id, new_player_key, form["ip_enabled"], new_player_ip, form["cid_enabled"], new_player_cid, form["use_last_connection"], new_applies_to_admins, new_duration, new_interval, new_reason, mirror_edit, edit_old_key, edit_old_ip, edit_old_cid, edit_old_applies_to_admins, search_admin_key, search_page, changes, FALSE))
			clear_edit()
			search_player_key = new_player_key
			search_player_ip = null
			search_player_cid = null
			search_page = 0
			mode = "unban"
		return TRUE
	var/severity = LOWER_TEXT(limited_text(params["severity"], 16) || "")
	if(!(severity in list("none", "minor", "medium", "high")))
		errors += "A severity must be selected."
	var/ban_type = params["ban_type"]
	var/list/roles_to_ban = list()
	if(ban_type == "server")
		roles_to_ban += "Server"
	else if(ban_type == "role")
		var/list/selected_roles = params["roles"]
		var/list/valid_roles = ta_roleban_tgui_roles()
		if(islist(selected_roles))
			for(var/selected_role in selected_roles)
				var/canonical_role = ta_roleban_canonical_role(selected_role)
				if(canonical_role in valid_roles)
					roles_to_ban |= canonical_role
		if(!length(roles_to_ban))
			errors += "Role ban was selected but no roles were selected."
	else

		errors += "A ban type must be selected."
	if(length(errors))
		to_chat(usr, span_danger("Ban not created because the following errors were present:\n[errors.Join("\n")]"))
		return TRUE
	admin_holder.create_ban(form["player_key"], form["ip_enabled"], form["player_ip"], form["cid_enabled"], form["player_cid"], form["use_last_connection"], form["applies_to_admins"], form["duration"], form["interval"], severity, form["reason"], roles_to_ban)
	return TRUE

/datum/admin_ban_panel/proc/load_edit_ban(raw_ban_id)
	var/ban_id = round(text2num(raw_ban_id))
	if(ban_id <= 0 || !SSdbcore.Connect())
		return TRUE
	var/datum/DBQuery/query_get_ban = SSdbcore.NewQuery({"
		SELECT
			id,
			role,
			TIMESTAMPDIFF(MINUTE, bantime, expiration_time),
			applies_to_admins,
			reason,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey),
			INET_NTOA(ip),
			computerid,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].a_ckey), a_ckey)
		FROM [format_table_name("ban")]
		WHERE id = :ban_id
	"}, list("ban_id" = ban_id))
	if(!query_get_ban.warn_execute())
		qdel(query_get_ban)
		return TRUE
	if(query_get_ban.NextRow())
		edit_id = text2num(query_get_ban.item[1])
		ban_role = query_get_ban.item[2]
		edit_old_duration = query_get_ban.item[3]
		ban_permanent = isnull(edit_old_duration)
		ban_duration = ban_permanent ? 1440 : edit_old_duration
		ban_interval = "MINUTE"
		ban_applies_to_admins = !!text2num(query_get_ban.item[4])
		ban_reason = query_get_ban.item[5]
		ban_player_key = query_get_ban.item[6]
		ban_player_ip = query_get_ban.item[7]
		ban_player_cid = query_get_ban.item[8]
		edit_admin_key = query_get_ban.item[9]
		ban_key_enabled = !!ban_player_key
		ban_ip_enabled = !!ban_player_ip
		ban_cid_enabled = !!ban_player_cid
		ban_use_last_connection = FALSE
		edit_old_key = ban_player_key
		edit_old_ip = ban_player_ip
		edit_old_cid = ban_player_cid
		edit_old_applies_to_admins = ban_applies_to_admins
		edit_old_reason = ban_reason
		form_revision++
		mode = "ban"
	qdel(query_get_ban)
	return TRUE

/datum/admin_ban_panel/proc/clear_edit()
	edit_id = null
	edit_old_key = null
	edit_old_ip = null
	edit_old_cid = null
	edit_old_applies_to_admins = FALSE
	edit_old_duration = null
	edit_old_reason = null
	edit_admin_key = null
	ban_role = null
	form_revision++

/datum/admins/proc/ban_panel(player_key, player_ip, player_cid, role, duration = 1440, applies_to_admins, reason, edit_id, page, admin_key)
	if(!check_rights(R_BAN))
		return
	var/datum/admin_ban_panel/panel = new(src, "ban", player_key, player_ip, player_cid, role, duration, applies_to_admins, reason, edit_id, page, admin_key)
	panel.ui_interact(usr)


/datum/admins/proc/ban_parse_href(list/href_list)
	if(!check_rights(R_BAN))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return
	var/list/error_state = list()
	var/player_key
	var/ip_check = FALSE
	var/player_ip
	var/cid_check = FALSE
	var/player_cid
	var/use_last_connection = FALSE
	var/applies_to_admins = FALSE
	var/duration
	var/interval
	var/severity
	var/reason
	var/mirror_edit
	var/edit_id
	var/old_key
	var/old_ip
	var/old_cid
	var/old_applies
	var/page
	var/admin_key
	var/list/changes = list()
	var/list/roles_to_ban = list()
	if(href_list["keycheck"])
		player_key = href_list["keytext"]
		if(!player_key)
			error_state += "Key was ticked but none was provided."
	if(href_list["ipcheck"])
		ip_check = TRUE
	if(href_list["cidcheck"])
		cid_check = TRUE
	if(href_list["lastconn"])
		if(player_key)
			use_last_connection = TRUE
	else
		if(ip_check)
			player_ip = href_list["iptext"]
			if(!player_ip && !use_last_connection)
				error_state += "IP was ticked but none was provided."
		if(cid_check)
			player_cid = href_list["cidtext"]
			if(!player_cid && !use_last_connection)
				error_state += "CID was ticked but none was provided."
	if(!use_last_connection && !player_ip && !player_cid && !player_key)
		error_state += "At least a key, IP or CID must be provided."
	if(use_last_connection && !ip_check && !cid_check)
		error_state += "Use last connection was ticked, but neither IP nor CID was."
	if(href_list["applyadmins"])
		applies_to_admins = TRUE
	switch(href_list["radioduration"])
		if("permanent")
			duration = null
		if("temporary")
			duration = href_list["duration"]
			interval = href_list["intervaltype"]
			if(!duration)
				error_state += "Temporary ban was selected but no duration was provided."
		else
			error_state += "No duration was selected."
	reason = href_list["reason"]
	if(!reason)
		error_state += "No reason was provided."
	if(href_list["editid"])
		edit_id = href_list["editid"]
		if(href_list["mirroredit"])
			mirror_edit = TRUE
		old_key = href_list["oldkey"]
		old_ip = href_list["oldip"]
		old_cid = href_list["oldcid"]
		page = href_list["page"]
		admin_key = href_list["adminkey"]
		if(player_key != old_key)
			changes += list("Key" = "[old_key] to [player_key]")
		if(player_ip != old_ip)
			changes += list("IP" = "[old_ip] to [player_ip]")
		if(player_cid != old_cid)
			changes += list("CID" = "[old_cid] to [player_cid]")
		old_applies = text2num(href_list["oldapplies"])
		if(applies_to_admins != old_applies)
			changes += list("Applies to admins" = "[old_applies] to [applies_to_admins]")
		if(duration != href_list["oldduration"])
			changes += list("Duration" = "[href_list["oldduration"]] MINUTE to [duration] [interval]")
		if(reason != href_list["oldreason"])
			changes += list("Reason" = "[href_list["oldreason"]]<br>to<br>[reason]")
		if(!changes.len)
			error_state += "No changes were detected."
	else
		severity = href_list["radioseverity"]
		if(!severity)
			error_state += "No severity was selected."
		switch(href_list["radioban"])
			if("server")
				roles_to_ban += "Server"
			if("role")
				href_list.Remove("Command", "Security", "Engineering", "Medical", "Science", "Supply", "Silicon", "Abstract", "Service", "Ducal Family", "Courtiers", "Retinue", "Garrison", "Church", "Inquisition", "Wanderers", "Peasants", "Burghers", "ATC", "Sidefolk", "Ghost and Other Roles", "Antagonist Positions", "Lesser Antagonst Positions") //remove the role banner hidden input values
				if(href_list[href_list.len] == "roleban_delimiter")
					error_state += "Role ban was selected but no roles to ban were selected."
				else
					var/delimiter_pos = href_list.Find("roleban_delimiter")
					href_list.Cut(1, delimiter_pos+1)//remove every list element before and including roleban_delimiter so we have a list of only the roles to ban
					for(var/key in href_list) //flatten into a list of only unique keys
						roles_to_ban |= key
			else
				error_state += "No ban type was selected."
	if(error_state.len)
		to_chat(usr, span_danger("Ban not [edit_id ? "edited" : "created"] because the following errors were present:\n[error_state.Join("\n")]"))
		return
	if(edit_id)
		edit_ban(edit_id, player_key, ip_check, player_ip, cid_check, player_cid, use_last_connection, applies_to_admins, duration, interval, reason, mirror_edit, old_key, old_ip, old_cid, old_applies, admin_key, page, changes)
	else
		create_ban(player_key, ip_check, player_ip, cid_check, player_cid, use_last_connection, applies_to_admins, duration, interval, severity, reason, roles_to_ban)

/datum/admins/proc/create_ban(player_key, ip_check, player_ip, cid_check, player_cid, use_last_connection, applies_to_admins, duration, interval, severity, reason, list/roles_to_ban)
	if(!check_rights(R_BAN))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return
	roles_to_ban = ta_roleban_canonicalize_roles(roles_to_ban)
	if(!length(roles_to_ban))
		return
	var/player_ckey = ckey(player_key)
	if(player_ckey)
		var/datum/DBQuery/query_create_ban_get_player = SSdbcore.NewQuery({"
			SELECT byond_key, INET_NTOA(ip), computerid FROM [format_table_name("player")] WHERE ckey = :player_ckey
		"}, list("player_ckey" = player_ckey))
		if(!query_create_ban_get_player.warn_execute())
			qdel(query_create_ban_get_player)
			return
		if(query_create_ban_get_player.NextRow())
			player_key = query_create_ban_get_player.item[1]
			if(use_last_connection)
				if(ip_check)
					player_ip = query_create_ban_get_player.item[2]
				if(cid_check)
					player_cid = query_create_ban_get_player.item[3]
		else
			if(use_last_connection)
				if(alert(usr, "[player_key]/([player_ckey]) has not been seen before, unable to use IP and CID from last connection. Are you sure you want to create a ban for them?", "Unknown key", "Yes", "No", "Cancel") != "Yes")
					qdel(query_create_ban_get_player)
					return
			else
				if(alert(usr, "[player_key]/([player_ckey]) has not been seen before, are you sure you want to create a ban for them?", "Unknown key", "Yes", "No", "Cancel") != "Yes")
					qdel(query_create_ban_get_player)
					return
		qdel(query_create_ban_get_player)
	var/admin_ckey = usr.client.ckey
	if(applies_to_admins)
		var/datum/DBQuery/query_check_adminban_count = SSdbcore.NewQuery({"
			SELECT COUNT(DISTINCT bantime)
			FROM [format_table_name("ban")]
			WHERE
				a_ckey = :admin_ckey AND
				applies_to_admins = 1 AND
				unbanned_datetime IS NULL AND
				(expiration_time IS NULL OR expiration_time > NOW())
		"}, list("admin_ckey" = admin_ckey))
		if(!query_check_adminban_count.warn_execute()) //count distinct bantime to treat rolebans made at the same time as one ban
			qdel(query_check_adminban_count)
			return
		if(query_check_adminban_count.NextRow())
			var/adminban_count = text2num(query_check_adminban_count.item[1])
			var/max_adminbans = MAX_ADMINBANS_PER_ADMIN
			if(R_EVERYTHING && !(R_EVERYTHING & rank.can_edit_rights)) //edit rights are a more effective way to check hierarchical rank since many non-headmins have R_PERMISSIONS now
				max_adminbans = MAX_ADMINBANS_PER_HEADMIN
			if(adminban_count >= max_adminbans)
				to_chat(usr, span_danger("You've already logged [max_adminbans] admin ban(s) or more. Do not abuse this function!"))
				qdel(query_check_adminban_count)
				return
		qdel(query_check_adminban_count)
	var/admin_ip = usr.client.address
	var/admin_cid = usr.client.computer_id
	duration = text2num(duration)
	if (!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"
	var/time_message = "[duration] [LOWER_TEXT(interval)]" //no DisplayTimeText because our duration is of variable interval type
	if(duration > 1) //pluralize the interval if necessary
		time_message += "s"
	var/note_reason = "Banned from [roles_to_ban[1] == "Server" ? "the server" : " Roles: [roles_to_ban.Join(", ")]"] [isnull(duration) ? "permanently" : "for [time_message]"] - [reason]"
	var/list/clients_online = GLOB.clients.Copy()
	var/list/admins_online = list()
	for(var/client/C in clients_online)
		if(C.holder) //deadmins aren't included since they wouldn't show up on adminwho
			admins_online += C
	var/who = copytext(clients_online.Join(", "), 1, 2049)
	var/adminwho = admins_online.Join(", ")
	var/kn = key_name(usr)
	var/kna = key_name_admin(usr)

	var/special_columns = list(
		"bantime" = "NOW()",
		"server_ip" = "INET_ATON(?)",
		"ip" = "INET_ATON(?)",
		"a_ip" = "INET_ATON(?)",
		"expiration_time" = "IF(? IS NULL, NULL, NOW() + INTERVAL ? [interval])"
	)
	var/sql_ban = list()
	for(var/role in roles_to_ban)
		sql_ban += list(list(
			"server_ip" = world.internet_address || 0,
			"server_port" = world.port,
			"round_id" = GLOB.round_id,
			"role" = role,
			"expiration_time" = duration,
			"applies_to_admins" = applies_to_admins,
			"reason" = reason,
			"ckey" = player_ckey || null,
			"ip" = player_ip || null,
			"computerid" = player_cid || null,
			"a_ckey" = admin_ckey,
			"a_ip" = admin_ip || null,
			"a_computerid" = admin_cid,
			"who" = who,
			"adminwho" = adminwho,
		))
	if(!SSdbcore.MassInsert(format_table_name("ban"), sql_ban, warn = TRUE, special_columns = special_columns))
		return
	var/target = ban_target_string(player_key, player_ip, player_cid)
	var/msg = "has created a [isnull(duration) ? "permanent" : "temporary [time_message]"] [applies_to_admins ? "admin " : ""][roles_to_ban[1] == "Server" ? "server ban" : "role ban from [roles_to_ban.len] roles"] for [target]."
	log_admin_private("[kn] [msg][roles_to_ban[1] == "Server" ? "" : " Roles: [roles_to_ban.Join(", ")]"] Reason: [reason]")
	message_admins("[kna] [msg][roles_to_ban[1] == "Server" ? "" : " Roles: [roles_to_ban.Join("\n")]"]\nReason: [reason]")
	world.TgsAnnounceBan(player_key, admin_ckey, duration, time_message, roles_to_ban, reason, severity, applies_to_admins)
	if(applies_to_admins)
		send2irc("BAN ALERT","[kn] [msg]")
	if(player_ckey)
		create_message("note", player_ckey, admin_ckey, note_reason, logged = FALSE, note_severity = severity)
	var/client/C = GLOB.directory[player_ckey]
	var/datum/admin_help/AH = admin_ticket_log(player_ckey, "[kna] [msg]")
	var/appeal_url = "No ban appeal url set!"
	appeal_url = CONFIG_GET(string/banappeals)
	var/is_admin = FALSE
	if(C)
		build_ban_cache(C)
		to_chat(C, span_boldannounce("You have been [applies_to_admins ? "admin " : ""]banned by [usr.client.key] from [roles_to_ban[1] == "Server" ? "the server" : " Roles: [roles_to_ban.Join(", ")]"].\nReason: [reason]</span><br><span class='danger'>This ban is [isnull(duration) ? "permanent." : "temporary, it will be removed in [time_message]."] The round ID is [GLOB.round_id].</span><br><span class='danger'>To appeal this ban go to [appeal_url]"))
		if(GLOB.admin_datums[C.ckey] || GLOB.deadmins[C.ckey])
			is_admin = TRUE
		if(roles_to_ban[1] == "Server" && (!is_admin || (is_admin && applies_to_admins)))
			qdel(C)
	if(roles_to_ban[1] == "Server" && AH)
		AH.Resolve()
	for(var/client/i in GLOB.clients - C)
		if(i.address == player_ip || i.computer_id == player_cid)
			build_ban_cache(i)
			to_chat(i, span_boldannounce("You have been [applies_to_admins ? "admin " : ""]banned by [usr.client.key] from [roles_to_ban[1] == "Server" ? "the server" : " Roles: [roles_to_ban.Join(", ")]"].\nReason: [reason]</span><br><span class='danger'>This ban is [isnull(duration) ? "permanent." : "temporary, it will be removed in [time_message]."] The round ID is [GLOB.round_id].</span><br><span class='danger'>To appeal this ban go to [appeal_url]"))
			if(GLOB.admin_datums[i.ckey] || GLOB.deadmins[i.ckey])
				is_admin = TRUE
			if(roles_to_ban[1] == "Server" && (!is_admin || (is_admin && applies_to_admins)))
				qdel(i)
	return TRUE

/datum/admins/proc/unban_panel(player_key, admin_key, player_ip, player_cid, page = 0)
	if(!check_rights(R_BAN))
		return
	var/datum/admin_ban_panel/panel = new(src, "unban", player_key, player_ip, player_cid, null, 1440, FALSE, null, null, page, admin_key)
	panel.ui_interact(usr)

/datum/admins/proc/unban(ban_id, player_key, player_ip, player_cid, role, page, admin_key)
	if(unban_ids(list(ban_id)))
		unban_panel(player_key, admin_key, player_ip, player_cid, page)

/datum/admins/proc/unban_ids(list/raw_ban_ids)
	if(!check_rights(R_BAN))
		return FALSE
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return FALSE
	var/list/ban_ids = list()
	for(var/raw_ban_id in raw_ban_ids)
		var/ban_id = round(text2num(raw_ban_id))
		if(ban_id > 0)
			ban_ids |= ban_id
	if(!length(ban_ids))
		to_chat(usr, span_danger("No active bans were selected."))
		return FALSE
	var/id_list = ban_ids.Join(",")
	var/datum/DBQuery/query_get_bans = SSdbcore.NewQuery({"
		SELECT
			id,
			role,
			ckey,
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE [format_table_name("player")].ckey = [format_table_name("ban")].ckey), ckey),
			INET_NTOA(ip),
			computerid
		FROM [format_table_name("ban")]
		WHERE
			id IN ([id_list]) AND
			unbanned_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW())
		ORDER BY id
	"})
	if(!query_get_bans.warn_execute())
		qdel(query_get_bans)
		return FALSE
	var/list/active_ban_ids = list()
	var/list/roles = list()
	var/target_ckey
	var/target_key
	var/target_ip
	var/target_cid
	var/list/target_ips = list()
	var/list/target_cids = list()
	var/mixed_targets = FALSE
	while(query_get_bans.NextRow())
		var/row_ckey = query_get_bans.item[3]
		var/row_key = query_get_bans.item[4]
		var/row_ip = query_get_bans.item[5]
		var/row_cid = query_get_bans.item[6]
		if(!length(active_ban_ids))
			target_ckey = row_ckey
			target_key = row_key
			target_ip = row_ip
			target_cid = row_cid
		else if(target_ckey)
			if(row_ckey != target_ckey)
				mixed_targets = TRUE
		else if(row_ckey || row_ip != target_ip || row_cid != target_cid)
			mixed_targets = TRUE
		if(row_ip)
			target_ips |= row_ip
		if(row_cid)
			target_cids |= row_cid
		active_ban_ids |= text2num(query_get_bans.item[1])
		roles |= query_get_bans.item[2]
	qdel(query_get_bans)
	if(mixed_targets)
		to_chat(usr, span_danger("All selected bans must belong to the same player."))
		return FALSE
	if(!length(active_ban_ids))
		to_chat(usr, span_danger("The selected bans are no longer active."))
		return FALSE
	var/target = ban_target_string(target_key, target_ip, target_cid)
	var/server_unban = ("Server" in roles)
	var/list/non_server_roles = roles.Copy()
	non_server_roles -= "Server"
	var/grouped_roles = non_server_roles.Join(", ")
	var/role_text
	if(server_unban && length(non_server_roles))
		role_text = "the server and roles: [grouped_roles]"
	else if(server_unban)
		role_text = "the server"
	else if(length(non_server_roles) == 1)
		role_text = non_server_roles[1]
	else
		role_text = "roles: [grouped_roles]"
	if(tgui_alert(usr, "Remove [target]'s ban from [role_text]?", "Unban confirmation", list("Cancel", "Unban")) != "Unban")
		return FALSE
	var/unban_reason = tgui_input_text(usr, "Enter the reason for this unban.", "Unban reason", null, 1024, TRUE)
	if(isnull(unban_reason))
		return FALSE
	unban_reason = trim(unban_reason)
	if(!length(unban_reason))
		to_chat(usr, span_danger("An unban reason is required."))
		return FALSE
	id_list = active_ban_ids.Join(",")
	var/datum/DBQuery/query_unban = SSdbcore.NewQuery({"
		UPDATE [format_table_name("ban")] SET
			unbanned_datetime = NOW(),
			unbanned_ckey = :admin_ckey,
			unbanned_ip = INET_ATON(:admin_ip),
			unbanned_computerid = :admin_cid,
			unbanned_round_id = :round_id
		WHERE
			id IN ([id_list]) AND
			unbanned_datetime IS NULL AND
			(expiration_time IS NULL OR expiration_time > NOW())
	"}, list(
		"admin_ckey" = usr.client.ckey,
		"admin_ip" = usr.client.address,
		"admin_cid" = usr.client.computer_id,
		"round_id" = GLOB.round_id,
	))
	if(!query_unban.warn_execute())
		qdel(query_unban)
		return FALSE
	qdel(query_unban)
	var/kn = key_name(usr)
	var/kna = key_name_admin(usr)
	var/unban_subject
	var/notification_text
	if(server_unban && length(non_server_roles))
		unban_subject = "the server and roles: [grouped_roles]"
		notification_text = "the server and roles: [grouped_roles]"
	else if(server_unban)
		unban_subject = "the server"
		notification_text = "the server"
	else if(length(non_server_roles) == 1)
		unban_subject = non_server_roles[1]
		notification_text = non_server_roles[1]
	else
		unban_subject = "roles: [grouped_roles]"
		notification_text = "roles: [grouped_roles]"
	log_admin_private("[kn] has unbanned [target] from [unban_subject]. Reason: [unban_reason]")
	message_admins("[kna] has unbanned [target] from [unban_subject]. Reason: [unban_reason]")
	world.TgsAnnounceUnban(target, usr.ckey, roles, unban_reason)
	var/list/notified_clients = list()
	var/client/key_client = target_ckey ? GLOB.directory[target_ckey] : null
	if(key_client)
		build_ban_cache(key_client)
		to_chat(key_client, span_boldannounce("[usr.client.key] has removed your ban from [notification_text]."))
		notified_clients += key_client
	for(var/client/client_to_update in GLOB.clients)
		if(client_to_update in notified_clients)
			continue
		if((client_to_update.address in target_ips) || (client_to_update.computer_id in target_cids))
			build_ban_cache(client_to_update)
			to_chat(client_to_update, span_boldannounce("[usr.client.key] has removed the ban from [notification_text] for your IP or CID."))
			notified_clients += client_to_update
	return TRUE
/datum/admins/proc/edit_ban(ban_id, player_key, ip_check, player_ip, cid_check, player_cid, use_last_connection, applies_to_admins, duration, interval, reason, mirror_edit, old_key, old_ip, old_cid, old_applies, admin_key, page, list/changes, reopen_panel = TRUE)
	if(!check_rights(R_BAN))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return
	var/player_ckey = ckey(player_key)
	var/bantime
	if(player_ckey)
		var/datum/DBQuery/query_edit_ban_get_player = SSdbcore.NewQuery({"
			SELECT
				byond_key,
				(SELECT bantime FROM [format_table_name("ban")] WHERE id = :ban_id),
				ip,
				computerid
			FROM [format_table_name("player")]
			WHERE ckey = :player_ckey
		"}, list("player_ckey" = player_ckey, "ban_id" = ban_id))
		if(!query_edit_ban_get_player.warn_execute())
			qdel(query_edit_ban_get_player)
			return
		if(query_edit_ban_get_player.NextRow())
			player_key = query_edit_ban_get_player.item[1]
			bantime = query_edit_ban_get_player.item[2]
			if(use_last_connection)
				if(ip_check)
					player_ip = query_edit_ban_get_player.item[3]
				if(cid_check)
					player_cid = query_edit_ban_get_player.item[4]
		else
			if(use_last_connection)
				if(alert(usr, "[player_key]/([player_ckey]) has not been seen before, unable to use IP and CID from last connection. Are you sure you want to edit a ban for them?", "Unknown key", "Yes", "No", "Cancel") != "Yes")
					qdel(query_edit_ban_get_player)
					return
			else
				if(alert(usr, "[player_key]/([player_ckey]) has not been seen before, are you sure you want to edit a ban for them?", "Unknown key", "Yes", "No", "Cancel") != "Yes")
					qdel(query_edit_ban_get_player)
					return
		qdel(query_edit_ban_get_player)
	if(applies_to_admins && (applies_to_admins != old_applies))
		var/datum/DBQuery/query_check_adminban_count = SSdbcore.NewQuery({"
			SELECT COUNT(DISTINCT bantime)
			FROM [format_table_name("ban")]
			WHERE a_ckey = :admin_ckey
				AND applies_to_admins = 1
				AND unbanned_datetime IS NULL
				AND (expiration_time IS NULL OR expiration_time > NOW())
		"}, list("admin_ckey" = usr.client.ckey))
		if(!query_check_adminban_count.warn_execute()) //count distinct bantime to treat rolebans made at the same time as one ban
			qdel(query_check_adminban_count)
			return
		if(query_check_adminban_count.NextRow())
			var/adminban_count = text2num(query_check_adminban_count.item[1])
			var/max_adminbans = MAX_ADMINBANS_PER_ADMIN
			if(R_EVERYTHING && !(R_EVERYTHING & rank.can_edit_rights)) //edit rights are a more effective way to check hierarchical rank since many non-headmins have R_PERMISSIONS now
				max_adminbans = MAX_ADMINBANS_PER_HEADMIN
			if(adminban_count >= max_adminbans)
				to_chat(usr, span_danger("You've already logged [max_adminbans] admin ban(s) or more. Do not abuse this function!"))
				qdel(query_check_adminban_count)
				return
		qdel(query_check_adminban_count)

	if (!(interval in list("SECOND", "MINUTE", "HOUR", "DAY", "WEEK", "MONTH", "YEAR")))
		interval = "MINUTE"

	var/list/changes_text = list()
	var/list/changes_keys = list()
	for(var/i in changes)
		changes_text += "[i]: [changes[i]]"
		changes_keys += i
	var/change_message = "[usr.client.key] edited the following [jointext(changes_text, ", ")]<hr>"

	var/list/arguments = list(
		"duration" = duration || null,
		"reason" = reason,
		"applies_to_admins" = applies_to_admins,
		"ckey" = player_ckey || null,
		"ip" = player_ip || null,
		"cid" = player_cid || null,
		"change_message" = change_message,
	)
	var/where
	if(text2num(mirror_edit))
		var/list/wherelist = list("bantime = '[bantime]'")
		if(old_key)
			wherelist += "ckey = :old_ckey"
			arguments["old_ckey"] = ckey(old_key)
		if(old_ip)
			wherelist += "ip = INET_ATON(:old_ip)"
			arguments["old_ip"] = old_ip || null
		if(old_cid)
			wherelist += "computerid = :old_cid"
			arguments["old_cid"] = old_cid
		where = wherelist.Join(" AND ")
	else
		where = "id = :ban_id"
		arguments["ban_id"] = ban_id

	var/datum/DBQuery/query_edit_ban = SSdbcore.NewQuery({"
		UPDATE [format_table_name("ban")]
		SET
			expiration_time = IF(:duration IS NULL, NULL, bantime + INTERVAL :duration [interval]),
			applies_to_admins = :applies_to_admins,
			reason = :reason,
			ckey = :ckey,
			ip = INET_ATON(:ip),
			computerid = :cid,
			edits = CONCAT(IFNULL(edits,''), :change_message)
		WHERE [where]
	"}, arguments)
	if(!query_edit_ban.warn_execute())
		qdel(query_edit_ban)
		return
	qdel(query_edit_ban)

	var/changes_keys_text = jointext(changes_keys, ", ")
	var/kn = key_name(usr)
	var/kna = key_name_admin(usr)
	log_admin_private("[kn] has edited the [changes_keys_text] of a ban for [old_key ? "[old_key]" : "[old_ip]-[old_cid]"].") //if a ban doesn't have a key it must have an ip and/or a cid to have reached this point normally
	message_admins("[kna] has edited the [changes_keys_text] of a ban for [old_key ? "[old_key]" : "[old_ip]-[old_cid]"].")
	var/discord_target = player_key
	if(!discord_target)
		discord_target = old_key
	if(!discord_target)
		var/discord_ip = player_ip ? player_ip : old_ip
		var/discord_cid = player_cid ? player_cid : old_cid
		discord_target = "[discord_ip]-[discord_cid]"
	world.TgsAnnounceBanEdit(discord_target, usr.ckey, changes)
	if(changes["Applies to admins"])
		send2irc("BAN ALERT","[kn] has edited a ban for [old_key ? "[old_key]" : "[old_ip]-[old_cid]"] to [applies_to_admins ? "" : "not"]affect admins")
	var/client/C = GLOB.directory[old_key]
	if(C)
		build_ban_cache(C)
		to_chat(C, span_boldannounce("[usr.client.key] has edited the [changes_keys_text] of a ban for your key."))
	for(var/client/i in GLOB.clients - C)
		if(i.address == old_ip || i.computer_id == old_cid)
			build_ban_cache(i)
			to_chat(i, span_boldannounce("[usr.client.key] has edited the [changes_keys_text] of a ban for your IP or CID."))
	if(reopen_panel)
		unban_panel(player_key, null, null, null, page)
	return TRUE

/datum/admins/proc/ban_log(ban_id)
	if(!check_rights(R_BAN))
		return
	if(!SSdbcore.Connect())
		to_chat(usr, span_danger("Failed to establish database connection."))
		return
	var/datum/DBQuery/query_get_ban_edits = SSdbcore.NewQuery({"
		SELECT edits FROM [format_table_name("ban")] WHERE id = :ban_id
	"}, list("ban_id" = ban_id))
	if(!query_get_ban_edits.warn_execute())
		qdel(query_get_ban_edits)
		return
	if(query_get_ban_edits.NextRow())
		var/edits = query_get_ban_edits.item[1]
		var/datum/browser/edit_log = new(usr, "baneditlog", "Ban edit log")
		edit_log.set_content(edits)
		edit_log.open()
	qdel(query_get_ban_edits)

/datum/admins/proc/ban_target_string(player_key, player_ip, player_cid)
	. = list()
	if(player_key)
		. += player_key
	else
		if(player_ip)
			. += player_ip
		else
			. += "NULL"
		if(player_cid)
			. += player_cid
		else
			. += "NULL"
	. = jointext(., "/")

#undef MAX_ADMINBANS_PER_ADMIN
#undef MAX_ADMINBANS_PER_HEADMIN
