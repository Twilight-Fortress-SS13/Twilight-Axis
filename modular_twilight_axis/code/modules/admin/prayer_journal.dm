GLOBAL_DATUM_INIT(ta_prayer_journal, /datum/ta_prayer_journal, new)

/datum/ta_prayer_entry
	var/id
	var/speaker_ckey = ""
	var/speaker_name = ""
	var/patron_name = ""
	var/prayer_kind = "PRAYER"
	var/message = ""
	var/created_at = ""
	var/datum/weakref/speaker_ref
	var/processed = FALSE
	var/processed_by = ""
	var/processed_at = ""

/datum/ta_prayer_entry/proc/resolve_speaker()
	var/mob/M = speaker_ref?.resolve()
	if(M && !QDELETED(M))
		return M
	return null

/datum/ta_prayer_journal
	var/list/prayers = list()
	var/next_id = 0

/datum/ta_prayer_journal/New()
	. = ..()
	if(islist(GLOB.admin_verbs_admin) && !(/client/proc/ta_open_prayer_journal in GLOB.admin_verbs_admin))
		GLOB.admin_verbs_admin += /client/proc/ta_open_prayer_journal

/datum/ta_prayer_journal/proc/record(mob/speaker, message_text, patron_name, prayer_kind = "PRAYER")
	if(!speaker || !length(message_text))
		return
	var/datum/ta_prayer_entry/entry = new
	entry.id = ++next_id
	entry.speaker_ckey = ckey(speaker.key)
	entry.speaker_name = html_decode("[speaker.real_name || speaker.name]")
	var/clean_patron_name = trim("[patron_name]")
	if(findtext(clean_patron_name, "to ") == 1)
		clean_patron_name = copytext(clean_patron_name, 4)
	entry.patron_name = html_decode("[clean_patron_name || "Unknown"]")
	entry.prayer_kind = prayer_kind
	entry.message = html_decode("[message_text]")
	entry.created_at = time2text(world.realtime, "hh:mm:ss")
	entry.speaker_ref = WEAKREF(speaker)
	prayers += entry
	SStgui.update_uis(src)

/datum/ta_prayer_journal/proc/get_entry(id)
	if(!isnum(id) || id < 1 || id > next_id)
		return null
	for(var/datum/ta_prayer_entry/entry as anything in prayers)
		if(entry.id == id)
			return entry
	return null

/datum/ta_prayer_journal/ui_state(mob/user)
	if(user?.client?.holder && check_rights_for(user.client, R_ADMIN))
		return GLOB.always_state
	return GLOB.never_state

/datum/ta_prayer_journal/ui_interact(mob/user, datum/tgui/ui)
	if(!user?.client?.holder || !check_rights_for(user.client, R_ADMIN))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PrayerJournal", "Prayer Journal")
		ui.open()

/datum/ta_prayer_journal/ui_data(mob/user)
	var/list/rows = list()
	var/pending_count = 0
	if(!user?.client?.holder || !check_rights_for(user.client, R_ADMIN))
		return list("prayers" = rows, "pending" = pending_count)
	for(var/datum/ta_prayer_entry/entry as anything in prayers)
		var/mob/M = entry.resolve_speaker()
		var/client/current_client = GLOB.directory[entry.speaker_ckey]
		if(!entry.processed)
			pending_count++
		rows += list(list(
			"id" = entry.id,
			"ckey" = entry.speaker_ckey,
			"name" = entry.speaker_name,
			"patron" = entry.patron_name,
			"kind" = entry.prayer_kind,
			"message" = entry.message,
			"time" = entry.created_at,
			"processed" = entry.processed,
			"processed_by" = entry.processed_by,
			"processed_at" = entry.processed_at,
			"target_exists" = !!M,
			"target_located" = !!get_turf(M),
			"online" = !!current_client,
		))
	return list("prayers" = rows, "pending" = pending_count)

/datum/ta_prayer_journal/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui?.user
	var/client/admin_client = user?.client
	if(!admin_client?.holder || !check_rights_for(admin_client, R_ADMIN))
		return
	if(action == "refresh")
		return TRUE
	var/datum/ta_prayer_entry/entry = get_entry(text2num(params["id"]))
	if(!entry)
		return TRUE
	if(action == "toggle-processed")
		entry.processed = !entry.processed
		entry.processed_by = entry.processed ? admin_client.ckey : ""
		entry.processed_at = entry.processed ? time2text(world.realtime, "hh:mm:ss") : ""
		log_admin("[key_name(user)] marked prayer #[entry.id] from [entry.speaker_ckey] as [entry.processed ? "processed" : "unprocessed"].")
		SStgui.update_uis(src)
		return TRUE
	if(action == "private-message")
		var/client/recipient = GLOB.directory[entry.speaker_ckey]
		if(recipient)
			admin_client.cmd_admin_pm(recipient, null)
		else
			to_chat(user, span_warning("The player is currently offline."))
		return TRUE
	var/mob/target = entry.resolve_speaker()
	if(!target)
		to_chat(user, span_warning("The original prayer sender no longer exists. PM may still work if they are online."))
		return TRUE
	switch(action)
		if("view-variables")
			admin_client.debug_variables(target)
			return TRUE
		if("player-panel")
			admin_client.holder.show_player_panel(target)
			return TRUE
		if("jump")
			var/turf/T = get_turf(target)
			if(!T)
				return TRUE
			if(!isobserver(user))
				if(!admin_client.admin_ghost())
					return TRUE
			admin_client.jumptocoord(T.x, T.y, T.z)
			return TRUE
		if("follow")
			if(!isobserver(user))
				if(!admin_client.admin_ghost())
					return TRUE
			if(isobserver(admin_client.mob))
				var/mob/dead/observer/O = admin_client.mob
				O.ManualFollow(target)
			return TRUE
	return FALSE

/client/proc/ta_open_prayer_journal()
	set name = "Prayer Journal"
	set category = "Admin.Admin"
	set desc = "Browse all round prayers, mark them handled, or interact with their senders."
	if(!holder || !check_rights(R_ADMIN))
		return
	GLOB.ta_prayer_journal.ui_interact(mob)
