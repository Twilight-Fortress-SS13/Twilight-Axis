/proc/get_mentor_stats(key)
	if(!key)
		return
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/mentor_stats.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(!json[ckey(key)])
		json[ckey(key)] = list(
			"likes" = 0,
			"dislikes" = 0,
			"real_likes" = 0,
			"answered" = 0,
			"triumph_gained" = 0
		)
		fdel(json_file)
		WRITE_FILE(json_file, json_encode(json))

	return json[ckey(key)]



/proc/update_mentor_stat(key, field, amt, mob/mob_c)
	if(!key || !field)
		return
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/mentor_stats.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(!json[ckey(key)])
		json[ckey(key)] = list(
			"likes" = 0,
			"dislikes" = 0,
			"real_likes" = 0,
			"answered" = 0,
			"triumph_gained" = 0
		)

	if(!(field in json[ckey(key)]))
		return

	json[ckey(key)][field] += amt
	// Check if this update triggers new Triumphs for real likes
	var/real_likes = json[ckey(key)]["real_likes"]
	var/triumph_chunks_awarded = json[ckey(key)]["triumph_gained"]  // store as integer chunks
	var/expected_chunks = floor(real_likes / 7)

	if(expected_chunks > triumph_chunks_awarded)
		var/delta = expected_chunks - triumph_chunks_awarded
		mob_c.adjust_triumphs(delta)
		json[ckey(key)]["triumph_gained"] = expected_chunks


	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

/proc/check_mentor_stats_menu(ckey)
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/mentor_stats.json"))
		to_chat(usr, "<span class='boldwarning'>User does not exist.</span>")


	var/list/stats = get_mentor_stats(ckey)
	var/rating = calc_mentor_rating(stats)
	var/popup_window_data = "<center><b>[ckey] - Mentor Stats</b></center>"
	popup_window_data += "<center>Mentor Rating: <b>[rating]/10</b></center>"
	popup_window_data += "<table width=100%>"
	popup_window_data += "<tr><td width=33%><div style='text-align:left'>"
	popup_window_data += "<span style='color: #00ff00;'><b>Voices answers likes:</b> [stats["likes"]]</span></div></td>"
	popup_window_data += "<td width=34%><center><span style='color: #a8ff8c;'><b>Real Likes:</b> [stats["real_likes"]]</span></center></td>"
	popup_window_data += "<td width=33%><div style='text-align:right'><span style='color: #ff6666;'><b>Voices answers dislikes:</b> [stats["dislikes"]]</span></div></td></tr>"
	popup_window_data += "<tr><td width=33%><div style='text-align:left'><span style='color: #ffff66;'><b>Voices Answered:</b> [stats["answered"]]</span></div></td>"
	popup_window_data += "<td width=34%><center><span style='color: #41095e;'><b>Triumph Gained:</b> [stats["triumph_gained"]]</span></center></td>"
	popup_window_data += "<td width=33%></td></tr>"
	popup_window_data += "</table>"

	var/datum/browser/noclose/popup = new(usr, "mentor_stats", "", 550, 200)
	popup.set_content(popup_window_data)
	popup.open()

/proc/calc_mentor_rating(stats)
	if(!stats)
		return 0
	var/answered = stats["answered"]
	var/likes = stats["likes"]
	var/dislikes = stats["dislikes"]

	var/ratio = 0
	if(likes + dislikes)
		ratio = likes / (likes + dislikes)

	var/base = min(answered / 10, 5)
	var/bonus = ratio * 5

	return round(base + bonus, 1)
