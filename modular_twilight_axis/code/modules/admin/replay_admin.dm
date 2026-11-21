
GLOBAL_DATUM_INIT(ta_replay_admin, /datum/ta_replay_admin, new)

/datum/ta_replay_admin/New()
	. = ..()
	if(islist(GLOB.admin_verbs_admin) && !(/client/proc/ta_open_replay_viewer in GLOB.admin_verbs_admin))
		GLOB.admin_verbs_admin += /client/proc/ta_open_replay_viewer

/datum/ta_replay_admin/proc/list_replay_days()
	var/static/regex/year_pattern = regex(@"^\d{4}/$")
	var/static/regex/part_pattern = regex(@"^\d{2}/$")
	var/list/days = list()
	for(var/year in flist("data/logs/"))
		if(!year_pattern.Find(year))
			continue
		for(var/month in flist("data/logs/[year]"))
			if(!part_pattern.Find(month))
				continue
			for(var/day in flist("data/logs/[year][month]"))
				if(part_pattern.Find(day))
					days += copytext("[year][month][day]", 1, -1)
	return sortList(days, /proc/cmp_text_dsc)

/datum/ta_replay_admin/proc/list_replay_rounds(day)
	var/list/rounds = list()
	var/list/components = splittext(day, "/")
	if(length(components) != 3)
		return rounds
	var/static/regex/year_pattern = regex(@"^\d{4}$")
	var/static/regex/part_pattern = regex(@"^\d{2}$")
	if(!year_pattern.Find(components[1]) || !part_pattern.Find(components[2]) || !part_pattern.Find(components[3]))
		return rounds
	for(var/name in flist("data/logs/[day]/"))
		if(copytext(name, 1, 7) != "round-" || copytext(name, -1) != "/")
			continue
		var/folder = copytext(name, 1, -1)
		if(fexists("data/logs/[day]/[folder]/demo.txt") && fexists("data/logs/[day]/[folder]/demo.txt.complete"))
			rounds += folder
	return sortList(rounds, /proc/cmp_text_dsc)

/datum/ta_replay_admin/proc/issue_link(client/requester, day, round_name)
	if(!requester?.holder || !check_rights_for(requester, R_ADMIN))
		return null
	var/config_path = "config/replay_private.json"
	if(!fexists(config_path))
		return null
	var/list/config
	try
		config = json_decode(file2text(config_path))
	catch
		return null
	if(!islist(config))
		return null
	var/shared_secret = config["game_issuer_secret"]
	if(!istext(shared_secret) || length(shared_secret) < 32)
		return null
	var/list/parts = splittext(day, "/")
	if(length(parts) != 3)
		return null
	var/list/form = list(
		"secret" = shared_secret,
		"admin_ckey" = requester.ckey,
		"year" = parts[1],
		"month" = parts[2],
		"day" = parts[3],
		"round" = round_name
	)
	var/list/response = world.Export("http://127.0.0.1:8846/internal/game-issue", form, 0, null, "POST")
	if(!islist(response) || text2num("[response["STATUS"]]") != 200)
		return null
	var/content = response["CONTENT"]
	if(!content)
		return null
	var/list/parsed
	try
		parsed = json_decode(file2text(content))
	catch
		return null
	if(!islist(parsed) || !istext(parsed["url"]))
		return null
	var/link = parsed["url"]
	if(copytext(link, 1, 9) != "https://" || length(link) > 700)
		return null
	return link

/client
	var/ta_replay_link_cooldown = 0

/client/proc/ta_open_replay_viewer()
	set name = "Round Replays"
	set category = "Admin.Admin"
	set desc = "Get a private temporary link to view a completed round replay."
	if(!holder || !check_rights(R_ADMIN))
		return
	if(world.time < ta_replay_link_cooldown)
		to_chat(src, span_warning("Please wait before requesting another replay link."))
		return
	var/list/days = GLOB.ta_replay_admin.list_replay_days()
	if(!length(days))
		to_chat(src, span_warning("No recorded round days found."))
		return
	var/selected_day = input(src, "Choose the date of the recorded round.", "Round Replays") as null|anything in days
	if(!selected_day || !(selected_day in days))
		return
	var/list/rounds = GLOB.ta_replay_admin.list_replay_rounds(selected_day)
	if(!length(rounds))
		to_chat(src, span_warning("No replay files were found for that date."))
		return
	var/selected_round = input(src, "Choose a completed round.", "Round Replays") as null|anything in rounds
	if(!selected_round || !(selected_round in rounds))
		return
	if(!holder || !check_rights(R_ADMIN) || !(selected_day in GLOB.ta_replay_admin.list_replay_days()) || !(selected_round in GLOB.ta_replay_admin.list_replay_rounds(selected_day)))
		return
	ta_replay_link_cooldown = world.time + 50
	var/link = GLOB.ta_replay_admin.issue_link(src, selected_day, selected_round)
	if(!link)
		to_chat(src, span_warning("Replay access is unavailable, or this round is not yet eligible for viewing."))
		return
	to_chat(src, span_notice("Personal replay link (5 minutes): <a href='[html_encode(link)]'>Open replay in browser</a>. Discord login is required."))
	log_admin("[key_name(mob)] requested a replay link for [selected_day]/[selected_round].")
