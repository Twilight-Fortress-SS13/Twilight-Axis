/proc/send2discordwh(var/data)
	world.Export("http://127.0.0.1:8081", data, 0, null, "POST")

/proc/roundend_notify_discord()
	var/list/data = list(
		"type"= "roundend"
	)
	send2discordwh(data)

/proc/discord_sanitize_ahelp(input)
    if(isnull(input))
        return ""

    var/text = "[input]"

    text = replacetext(text, "<br>", "\n")
    text = replacetext(text, "<br/>", "\n")
    text = replacetext(text, "<br />", "\n")
    text = replacetext(text, "&nbsp;", " ")
    text = replacetext(text, "&lt;", "<")
    text = replacetext(text, "&gt;", ">")
    text = replacetext(text, "&quot;", "\"")
    text = replacetext(text, "&#34;", "\"")
    text = replacetext(text, "&#39;", "'")
    text = replacetext(text, "&amp;", "&")

    while(findtext(text, "<"))
        var/start = findtext(text, "<")
        var/end = findtext(text, ">", start + 1)
        if(!start || !end)
            break
        text = copytext(text, 1, start) + copytext(text, end + 1)

    text = trim(text)
    return text

/datum/admin_help/New(msg, client/C, is_bwoink, author = FALSE)
	. = ..()
	var/initiator_who = author ? author : initiator
	var/list/data = list(
		"type"= "ahelp",
		"id"= "[id]",
		"round_id"= GLOB.rogue_round_id,
		"opened_at"= "[opened_at]",
		"initiator"= "[initiator_who]",
		"admin"= "[is_bwoink]",
		"message"= msg
	)
	send2discordwh(data)

/datum/admin_help/Close(key_name, silent)
	. = ..()
	if(silent)
		return

	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "close",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    

/datum/admin_help/Reopen(key_name)
	. = ..()
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "reopen",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    


/datum/admin_help/mentorissue(key_name)
	. = ..()
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "mentorissue",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    


/datum/admin_help/Resolve(key_name, silent)
	. = ..()
	if(silent)
		return
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "resolve",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    

	
/datum/admin_help/Reject(key_name)
	. = ..()
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "reject",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    


/datum/admin_help/ICIssue(key_name)
	. = ..()
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "icissue",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)    

	
/datum/admin_help/handle_issue(key_name)
	. = ..()
	if(!key_name)
		var/show_charname = !GLOB.ahelp_tickets.IsAdminInHideCharname(usr?.ckey)
		key_name = key_name(usr, FALSE, show_charname)

	var/list/data = list(
		"type"= "handle",
		"id"= "[id]",
		"initiator"= "[key_name]",
	)
	send2discordwh(data)

/datum/admin_help_tickets/ClientLogin(client/C)
	. = ..()
	if(C.current_ticket)
		var/list/data = list(
			"type"= "login",
			"id"= "[C.current_ticket.id]",
			"initiator"= "[C.ckey]",
		)
		send2discordwh(data)

/datum/admin_help_tickets/ClientLogout(client/C)
	if(C.current_ticket)
		var/list/data = list(
			"type"= "logout",
			"id"= "[C.current_ticket.id]",
			"initiator"= "[C.ckey]",
		)
		send2discordwh(data)
	. = ..()

/datum/world_topic/reopen_ticket
	keyword = "reopen"
	require_comms_key = TRUE

/datum/world_topic/reopen_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]    
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.Reopen(irc_tagged)

/datum/world_topic/close_ticket
	keyword = "close"
	require_comms_key = TRUE

/datum/world_topic/close_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.Close(irc_tagged)

/datum/world_topic/reject_ticket
	keyword = "reject"
	require_comms_key = TRUE

/datum/world_topic/reject_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.Reject(irc_tagged)


/datum/world_topic/icissue_ticket
	keyword = "icissue"
	require_comms_key = TRUE

/datum/world_topic/icissue_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.ICIssue(irc_tagged)

/datum/world_topic/mentorissue_ticket
	keyword = "mentorissue"
	require_comms_key = TRUE

/datum/world_topic/mentorissue_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.mentorissue(irc_tagged)

/datum/world_topic/resolve_ticket
	keyword = "resolve"
	require_comms_key = TRUE

/datum/world_topic/resolve_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.Resolve(irc_tagged)

/datum/world_topic/handle_ticket
	keyword = "handle"
	require_comms_key = TRUE

/datum/world_topic/handle_ticket/Run(list/input)
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/sender = input["initiator"]
	if(!ticket)
		return

	var/irc_tagged = "[sender]"
	ticket.handle_issue(irc_tagged, TRUE)

/datum/world_topic/reply_ticket
	keyword = "areply"
	require_comms_key = TRUE

/datum/world_topic/reply_ticket/Run(list/input)
	var/irc_name = input["initiator"]
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(text2num(input["id"]))
	var/message = copytext_char(input["message"], 1)
	if(!ticket || ticket.state != AHELP_ACTIVE)
		return

	ticket.AddInteraction("<font color='blue'>IRC-PM from [irc_name]: [message]</font>")
	// Send to player if connected
	if(ticket.initiator)
		to_chat(ticket.initiator, "<font color='red' size='4'><b>-- Administrator private message --</b></font>")
		to_chat(ticket.initiator, span_adminsay("Admin IRC PM from-<b>[irc_name]</b>: <span class='linkify'>[message]</span>"))
		to_chat(ticket.initiator, span_adminsay("<i><a href='?viewticket=1'>View ticket</a></i>"))
		admin_ticket_log(ticket.initiator, "<font color='purple'>IRC PM From [irc_name]: [message]</font>")
		//always play non-admin recipients the adminhelp sound
		SEND_SOUND(ticket.initiator, sound('sound/adminhelp.ogg'))

		message_admins(span_notice("Admin IRC PM from <b>[irc_name]</b> to-<b>[key_name(ticket.initiator)]</b>: <span class='linkify'>[message]</span>"))

	var/list/data = list(
		"type"= "areply",
		"id"= "[ticket.id]",
		"initiator"= irc_name,
		"admin"= "1",
		"message"= message
	)
	send2discordwh(data)

/datum/world_topic/pqckeck
	keyword = "pqcheck"
	require_comms_key = TRUE

/datum/world_topic/pqckeck/Run(list/input)
	var/ckey = input["ckey"]
	. = list()
	.["pq"] = get_playerquality(ckey, FALSE) // Что это за ебанина, почему аргумент называется text, а везде где это используется передается вообще три переменных нахуй.......
	.["commends"] = get_commends(ckey)
	.["rcp"] = get_roundpoints(ckey)
	.["played"] = get_roundsplayed(ckey)

/datum/world_topic/seenotes
	keyword = "seenotes"
	require_comms_key = TRUE

/datum/world_topic/seenotes/Run(list/input)
	var/canonical_ckey = replacetext(replacetext(replacetext(replacetext(lowertext(input["ckey"]), " ", ""), "_", ""), ".", ""), "-", "")
	var/folder_prefix = copytext(canonical_ckey, 1, 2)
	var/list/listy = world.file2list("data/player_saves/[folder_prefix]/[canonical_ckey]/playerquality.txt")
	. = list()
	.["data"] = ""

	if(!listy.len)
		.["data"] = "No data on record. Create some."
	else
		for(var/i = listy.len to 1 step -1)
			var/ya = listy[i]
			if(ya)
				.["data"] += copytext_char("[ya]\n", 1)
