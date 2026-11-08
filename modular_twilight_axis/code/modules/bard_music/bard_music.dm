#define BARD_TRACK_MAX_LYRICS 6000
#define BARD_TRACK_MAX_PHRASES 200
#define BARD_TRACK_DEFAULT_LOOP_TICKS 2400
#define BARD_TRACK_DEFAULT_DURATION_SECONDS 240
#define BARD_TRACK_DEFAULT_SPACING_SECONDS 2

SUBSYSTEM_DEF(bard_music)
	name = "bard music"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_CHAT
	var/list/active_instruments = list()
	var/list/current_run = list()

/datum/controller/subsystem/bard_music/proc/register(obj/item/rogue/instrument/instrument)
	if(!instrument || QDELETED(instrument))
		return
	active_instruments |= instrument

/datum/controller/subsystem/bard_music/proc/unregister(obj/item/rogue/instrument/instrument)
	if(!instrument)
		return
	active_instruments -= instrument

/datum/controller/subsystem/bard_music/fire(resumed = 0)
	if(!active_instruments.len)
		return
	if(!resumed || !current_run.len)
		current_run = active_instruments.Copy()
	while(current_run.len)
		var/obj/item/rogue/instrument/instrument = current_run[current_run.len]
		current_run.len--
		if(!(instrument in active_instruments))
			continue
		if(!instrument || QDELETED(instrument) || !instrument.process_auto_song())
			active_instruments -= instrument
		if(MC_TICK_CHECK)
			break

/datum/bard_timed_phrase
	var/time = 0
	var/text = ""

/datum/bard_timed_phrase/proc/export_data()
	return list("time" = time, "text" = text)

/datum/bard_band_member
	var/mob/living/player
	var/obj/item/rogue/instrument/instrument
	var/track_title = ""
	var/sing = FALSE

/datum/bard_band_member/proc/export_data()
	return list(
		"name" = player ? player.real_name : "Unknown",
		"instrument" = instrument ? instrument.name : "unknown",
		"track" = track_title,
		"mode" = sing ? "Sing" : "Mute"
	)

/mob/living
	var/tmp/obj/item/rogue/instrument/bard_band_owner
	var/tmp/bard_music_playing = FALSE
	var/tmp/bard_auto_singing = FALSE
	var/tmp/bard_auto_song_token = 0

/mob/living/proc/is_blocked_by_music_consumption()
	return bard_music_playing || has_status_effect(/datum/status_effect/buff/playing_music)

/mob/living/proc/is_blocked_by_auto_song()
	return bard_auto_singing

/datum/bard_timed_track
	var/title = ""
	var/file_path = null
	var/duration_seconds = 0
	var/lyrics = ""
	var/custom = FALSE
	var/analyzed_duration = FALSE
	var/phrase_spacing_seconds = BARD_TRACK_DEFAULT_SPACING_SECONDS
	var/list/phrases = list()

/datum/bard_timed_track/proc/set_song(song_title, song_file, custom_track = FALSE)
	title = song_title
	file_path = song_file
	duration_seconds = bard_track_file_duration_seconds(song_file)
	analyzed_duration = (duration_seconds != BARD_TRACK_DEFAULT_DURATION_SECONDS)
	custom = custom_track

/datum/bard_timed_track/proc/rebuild_from_lyrics(raw_lyrics)
	lyrics = copytext(raw_lyrics ? raw_lyrics : "", 1, BARD_TRACK_MAX_LYRICS)
	phrases = bard_track_build_phrases(lyrics, phrase_spacing_seconds)

/datum/bard_timed_track/proc/set_spacing(new_spacing)
	phrase_spacing_seconds = clamp(round(bard_track_num(new_spacing)), 1, 120)
	rebuild_from_lyrics(lyrics)

/datum/bard_timed_track/proc/set_phrase_time(index, new_time)
	index = round(bard_track_num(index))
	if(index < 1 || index > phrases.len)
		return FALSE
	var/datum/bard_timed_phrase/base_phrase = phrases[index]
	var/old_time = base_phrase.time
	var/target_time = max(round(bard_track_num(new_time)), 0)
	var/delta = target_time - old_time
	for(var/i in index to phrases.len)
		var/datum/bard_timed_phrase/phrase = phrases[i]
		phrase.time = max(round(phrase.time + delta, 0.1), 0)
	return TRUE

/datum/bard_timed_track/proc/set_phrase_text(index, new_text)
	index = round(bard_track_num(index))
	if(index < 1 || index > phrases.len)
		return FALSE
	var/datum/bard_timed_phrase/phrase = phrases[index]
	var/text = istext(new_text) ? new_text : "[new_text]"
	phrase.text = trimtext(copytext(text, 1, MAX_MESSAGE_LEN))
	sync_lyrics_from_phrases()
	return TRUE

/datum/bard_timed_track/proc/export_data()
	var/list/out_phrases = list()
	for(var/datum/bard_timed_phrase/phrase as anything in phrases)
		out_phrases += list(phrase.export_data())
	return list(
		"title" = title,
		"file" = "[file_path]",
		"duration_seconds" = duration_seconds,
		"spacing_seconds" = phrase_spacing_seconds,
		"phrases" = out_phrases
	)

/datum/bard_timed_track/proc/export_json()
	return json_encode(export_data())

/datum/bard_timed_track/proc/import_json(raw_json)
	if(!raw_json)
		return FALSE
	var/list/data = safe_json_decode(raw_json)
	if(!islist(data))
		return FALSE
	var/list/imported_phrases = data["phrases"]
	if(!islist(imported_phrases))
		return FALSE
	if(data["spacing_seconds"])
		var/imported_spacing = data["spacing_seconds"]
		phrase_spacing_seconds = clamp(round(bard_track_num(imported_spacing), 0.1), 0.1, 120)
	phrases = list()
	for(var/list/entry as anything in imported_phrases)
		if(!islist(entry))
			continue
		var/imported_text = entry["text"]
		var/text = trimtext(istext(imported_text) ? imported_text : "[imported_text]")
		if(!text)
			continue
		var/datum/bard_timed_phrase/phrase = new
		var/imported_time = entry["time"]
		phrase.time = max(bard_track_num(imported_time), 0)
		phrase.text = text
		phrases += phrase
		if(phrases.len >= BARD_TRACK_MAX_PHRASES)
			break
	sync_lyrics_from_phrases()
	return TRUE

/datum/bard_timed_track/proc/sync_lyrics_from_phrases()
	var/list/imported_lines = list()
	for(var/datum/bard_timed_phrase/phrase as anything in phrases)
		imported_lines += phrase.text
	lyrics = jointext(imported_lines, "\n")

/proc/bard_track_file_duration_seconds(song_file)
	. = BARD_TRACK_DEFAULT_DURATION_SECONDS
	if(!song_file)
		return
	var/length_ticks = rustg_sound_length("[song_file]")
	if(length_ticks)
		. = max(round(length_ticks / 10), 1)

/proc/bard_track_num(value, fallback = 0)
	if(isnum(value))
		return value
	if(istext(value))
		var/parsed = text2num(value)
		return isnum(parsed) ? parsed : fallback
	return fallback

/proc/bard_track_format_duration(total_seconds)
	total_seconds = max(round(bard_track_num(total_seconds)), 0)
	var/minutes = round(total_seconds / 60)
	var/seconds = total_seconds % 60
	return "[minutes]:[seconds < 10 ? "0[seconds]" : seconds]"

/proc/bard_track_strip_tags(raw_text)
	var/static/regex/tag_regex = regex(@"\[[^\]]*\]", "g")
	return trimtext(tag_regex.Replace(raw_text ? raw_text : "", ""))

/proc/bard_track_build_phrases(raw_lyrics, spacing_seconds)
	var/list/out = list()
	var/clean = bard_track_strip_tags(raw_lyrics)
	clean = replacetext(clean, ascii2text(13), "")
	clean = replacetext(clean, "\t", " ")
	var/list/source_lines = splittext(clean, "\n")
	var/list/final_lines = list()
	for(var/line in source_lines)
		var/trimmed = trimtext(line)
		if(trimmed)
			final_lines += trimmed
	if(!final_lines.len && clean)
		var/list/words = splittext(clean, " ")
		var/list/chunk = list()
		for(var/word in words)
			var/trimmed_word = trimtext(word)
			if(!trimmed_word)
				continue
			chunk += trimmed_word
			if(chunk.len >= 8)
				final_lines += jointext(chunk, " ")
				chunk = list()
		if(chunk.len)
			final_lines += jointext(chunk, " ")
	if(final_lines.len > BARD_TRACK_MAX_PHRASES)
		final_lines.Cut(BARD_TRACK_MAX_PHRASES + 1)
	var/step = max(spacing_seconds, 0.1)
	for(var/i in 1 to final_lines.len)
		var/datum/bard_timed_phrase/phrase = new
		phrase.time = round((i - 1) * step)
		phrase.text = final_lines[i]
		out += phrase
	return out

/obj/item/rogue/instrument
	var/repeat_enabled = FALSE
	var/mob/living/current_player = null
	var/datum/bard_timed_track/current_track = null
	var/current_track_title = null
	var/music_started_at = 0
	var/music_realtime_started_at = 0
	var/music_playback_id = 0
	var/music_stop_token = 0
	var/auto_song_enabled = FALSE
	var/auto_singing_title = null
	var/datum/bard_timed_track/auto_song_track = null
	var/auto_song_next_phrase_index = 1
	var/auto_song_cycle_started_at = 0
	var/obj/item/rogue/instrument/band_owner
	var/list/saved_band_members = list()
	var/saved_band_track_title
	var/saved_band_sing = FALSE
	var/saved_band_repeat = FALSE
	var/list/band_reserved_instruments = list()
	var/list/band_reserved_members = list()
	var/list/band_preloads = list()
	var/band_accepting = FALSE
	var/band_repeating = FALSE
	var/band_invite_active = FALSE
	var/band_invite_until = 0
	var/mob/living/band_invite_leader = null
	var/list/band_members = list()
	var/band_pending_responses = 0
	var/band_invite_token = 0
	var/list/datum/bard_timed_track/timed_tracks = list()
	var/music_panel_selected = null

/obj/item/rogue/instrument/proc/ensure_timed_tracks()
	if(!timed_tracks)
		timed_tracks = list()
	for(var/song_title in song_list)
		if(timed_tracks[song_title])
			continue
		var/datum/bard_timed_track/track = new
		track.set_song(song_title, song_list[song_title])
		timed_tracks[song_title] = track
	if(!music_panel_selected && song_list.len)
		for(var/song_title in song_list)
			music_panel_selected = song_title
			break

/obj/item/rogue/instrument/proc/get_selected_track()
	ensure_timed_tracks()
	if(!music_panel_selected || !timed_tracks[music_panel_selected])
		if(song_list.len)
			for(var/song_title in song_list)
				music_panel_selected = song_title
				break
	return timed_tracks[music_panel_selected]

/obj/item/rogue/instrument/proc/music_skill_event(mob/living/user)
	var/stressevent = /datum/stressevent/music
	note_color = "#7f7f7f"
	if(user?.mind)
		switch(user.get_skill_level(/datum/skill/misc/music))
			if(1)
				note_color = "#ffffff"; stressevent = /datum/stressevent/music/novice
			if(2)
				note_color = "#ffffff"; stressevent = /datum/stressevent/music/apprentice
			if(3)
				note_color = "#1eff00"; stressevent = /datum/stressevent/music/journeyman
			if(4)
				note_color = "#0070dd"; stressevent = /datum/stressevent/music/expert
			if(5)
				note_color = "#a335ee"; stressevent = /datum/stressevent/music/master
			if(6)
				note_color = "#ff8000"; stressevent = /datum/stressevent/music/legendary
	soundloop.stress2give = stressevent
	return stressevent

/obj/item/rogue/instrument/proc/stop_music(mob/living/user)
	music_stop_token++
	if(band_owner && current_player?.bard_band_owner == band_owner && (QDELETED(band_owner) || !band_owner.band_invite_active))
		current_player.bard_band_owner = null
		band_owner = null
	playing = FALSE
	groupplaying = FALSE
	if(soundloop)
		soundloop.stop()
	var/mob/living/player = current_player || user
	if(player)
		player.bard_music_playing = FALSE
		player.bard_auto_singing = FALSE
		player.bard_auto_song_token++
		player.remove_status_effect(/datum/status_effect/buff/playing_music)
	current_player = null
	current_track = null
	current_track_title = null
	music_started_at = 0
	music_realtime_started_at = 0
	music_playback_id++
	auto_singing_title = null
	auto_song_track = null
	auto_song_next_phrase_index = 1
	auto_song_cycle_started_at = 0
	SSbard_music.unregister(src)

/obj/item/rogue/instrument/proc/song_duration_loop(mob/living/user, token)
	set waitfor = FALSE
	if(!user || !current_player || token != music_stop_token)
		return
	while(!QDELETED(src) && !QDELETED(user) && token == music_stop_token && playing && current_player == user)
		if(!user.client || user.stat || !(src in user.held_items))
			stop_music(user)
			SStgui.update_uis(src)
			return
		var/duration_ticks = max(round((current_track?.duration_seconds || BARD_TRACK_DEFAULT_DURATION_SECONDS) * 10), 1)
		if(REALTIMEOFDAY - music_realtime_started_at >= duration_ticks && !repeat_enabled)
			stop_music(user)
			SStgui.update_uis(src)
			return
		sleep(1 SECONDS)
	if(!QDELETED(src) && token == music_stop_token && playing)
		stop_music(current_player)

/obj/item/rogue/instrument/proc/play_track(mob/living/user, datum/bard_timed_track/track, shared_start = null)
	if(!user || user.stat || !track || playing || !(src in user.held_items))
		return
	for(var/obj/item/rogue/instrument/other in user.held_items)
		if(other != src && other.playing)
			other.stop_music(user)
	var/stressevent = music_skill_event(user)
	curfile = track.file_path
	if(!curfile)
		stop_music(user)
		return
	if(!soundloop.acquire_channel())
		to_chat(user, span_warning("All 32 music channels are busy. Try again after another performance ends."))
		return
	playing = TRUE
	soundloop.set_mid_sounds(list(curfile))
	soundloop.mid_length = max(track.duration_seconds * 10, 1)
	soundloop.preload_persistent_to_all_clients = !track.custom && isnull(shared_start) // Bands preload only nearby listeners during invitations.
	soundloop.start()
	user.apply_status_effect(/datum/status_effect/buff/playing_music, stressevent, note_color)
	user.bard_music_playing = TRUE
	current_player = user
	current_track = track
	current_track_title = track.title
	music_started_at = world.time
	music_realtime_started_at = isnull(shared_start) ? REALTIMEOFDAY : shared_start
	music_playback_id++
	music_stop_token++
	INVOKE_ASYNC(src, PROC_REF(song_duration_loop), user, music_stop_token)
	if(auto_song_enabled)
		start_auto_song(user, track)
	record_round_statistic(STATS_SONGS_PLAYED)

/obj/item/rogue/instrument/proc/start_auto_song(mob/living/user, datum/bard_timed_track/track)
	if(!track || !track.custom)
		return
	if(!playing || current_player != user || current_track != track)
		return
	if(!track.phrases.len)
		return
	var/elapsed_seconds = max((REALTIMEOFDAY - music_realtime_started_at) / 10, 0)
	if(track.duration_seconds > 0 && repeat_enabled)
		elapsed_seconds = elapsed_seconds % track.duration_seconds
	else if(track.duration_seconds > 0 && elapsed_seconds >= track.duration_seconds)
		return
	user.bard_auto_singing = TRUE
	user.bard_auto_song_token++
	auto_singing_title = track.title
	auto_song_track = track
	auto_song_cycle_started_at = music_realtime_started_at
	auto_song_next_phrase_index = get_auto_song_phrase_index(track, elapsed_seconds)
	SSbard_music.register(src)

/obj/item/rogue/instrument/proc/stop_auto_song(mob/living/user)
	if(user)
		user.bard_auto_singing = FALSE
		user.bard_auto_song_token++
	auto_singing_title = null
	auto_song_track = null
	auto_song_next_phrase_index = 1
	auto_song_cycle_started_at = 0
	SSbard_music.unregister(src)

/obj/item/rogue/instrument/proc/band_ready(mob/living/user, obj/item/rogue/instrument/instrument)
	var/turf/player_turf = get_turf(user)
	var/turf/leader_turf = get_turf(band_invite_leader)
	return !QDELETED(user) && !QDELETED(instrument) && player_turf && leader_turf && user.client && !user.stat && (instrument in user.held_items) && player_turf.z == leader_turf.z && get_dist(user, band_invite_leader) <= 7

/obj/item/rogue/instrument/proc/preload_band_track(mob/living/performer, datum/bard_timed_track/track)
	if(!track?.file_path || band_preloads["[track.file_path]"])
		return
	var/datum/preload_owner = new
	var/preload_channel = SSsounds.instrument_channels.acquire_channel(preload_owner)
	if(!preload_channel)
		qdel(preload_owner)
		return
	var/list/listeners = list()
	// Warm the native sound cache during the invitation, only for nearby listeners.
	// A silent one-shot uses a separate temporary channel and never changes an active performance.
	for(var/mob/listener in get_hearers_in_range(world.view + 5, get_turf(performer), SPATIAL_GRID_CONTENTS_TYPE_CLIENTS))
		if(!(listener.client?.prefs.toggles & SOUND_INSTRUMENTS))
			continue
		SEND_SOUND(listener, sound(track.file_path, volume = 0, channel = preload_channel))
		listeners += WEAKREF(listener)
	band_preloads["[track.file_path]"] = list("channel" = preload_channel, "listeners" = listeners, "owner" = preload_owner)

/obj/item/rogue/instrument/proc/start_band_invite(mob/living/user, repeat_band = FALSE)
	if(band_invite_active && band_invite_leader == user)
		cancel_band_invite()
		to_chat(user, span_notice("Your band invitation was cancelled."))
		return
	if(band_invite_active)
		to_chat(user, span_warning("Only the invitation leader can cancel this invitation."))
		return
	if(user.bard_band_owner && user.bard_band_owner != src)
		to_chat(user, span_warning("You are already preparing to play in another band."))
		return
	band_invite_leader = user
	if(!band_ready(user, src))
		to_chat(user, span_warning("Hold your instrument in either hand to form a band."))
		band_invite_leader = null
		return
	band_invite_active = TRUE
	band_accepting = TRUE
	band_repeating = repeat_band
	if(repeat_band && timed_tracks[saved_band_track_title])
		music_panel_selected = saved_band_track_title
		auto_song_enabled = saved_band_sing
		repeat_enabled = saved_band_repeat
	band_invite_until = world.time + 30 SECONDS
	band_members = list()
	band_pending_responses = 0
	band_invite_token++
	user.bard_band_owner = src
	band_owner = src
	var/current_token = band_invite_token
	preload_band_track(user, get_selected_track())
	var/list/candidates = list()
	if(repeat_band)
		for(var/datum/bard_band_member/member as anything in saved_band_members.Copy())
			if(!band_ready(member.player, member.instrument))
				to_chat(user, span_notice("[member.player ? member.player.real_name : "A performer"] is no longer available within 7 tiles and was removed."))
				saved_band_members -= member
				continue
			candidates += member
	else
		for(var/mob/living/carbon/human/candidate in range(7, user))
			if(candidate == user)
				continue
			for(var/obj/item/rogue/instrument/instrument in candidate.held_items)
				var/datum/bard_band_member/member = new
				member.player = candidate
				member.instrument = instrument
				candidates += member
				break
	for(var/datum/bard_band_member/member as anything in candidates)
		if(!band_ready(member.player, member.instrument) || (member.player.bard_band_owner && member.player.bard_band_owner != src) || (member.instrument.band_owner && member.instrument.band_owner != src))
			to_chat(user, span_warning("[member.player.real_name] cannot join this band right now."))
			continue
		member.player.bard_band_owner = src
		member.instrument.band_owner = src
		band_reserved_instruments |= member.instrument
		band_reserved_members += member
		band_pending_responses++
		to_chat(user, span_notice("Invitation sent to [member.player.real_name]."))
		INVOKE_ASYNC(src, PROC_REF(prompt_band_member), member, current_token)
	if(!band_pending_responses)
		to_chat(user, span_warning("No available performers within 7 tiles."))
		cancel_band_invite()
		return
	addtimer(CALLBACK(src, PROC_REF(finish_band_invite), current_token), 30 SECONDS)
	to_chat(user, span_notice("Band invitations sent. You will confirm the performance in 30 seconds. Use Group again to cancel."))
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/release_band_member(datum/bard_band_member/member)
	if(member.player?.bard_band_owner == src)
		member.player.bard_band_owner = null
	if(member.instrument?.band_owner == src)
		member.instrument.band_owner = null

/obj/item/rogue/instrument/proc/prompt_band_member(datum/bard_band_member/member, prompt_token)
	var/mob/living/candidate = member.player
	var/obj/item/rogue/instrument/candidate_instrument = member.instrument
	if(QDELETED(src) || !band_invite_active || prompt_token != band_invite_token || !band_ready(candidate, candidate_instrument))
		return
	var/answer = alert(candidate, "[band_invite_leader.real_name] предлагает сыграть с вами. Согласиться?", "Приглашение в группу", "Да", "Нет")
	if(QDELETED(src) || !band_invite_active || !band_accepting || prompt_token != band_invite_token)
		return
	if(answer != "Да" || !band_ready(candidate, candidate_instrument))
		to_chat(band_invite_leader, span_notice("[candidate.real_name] did not join."))
		release_band_member(member)
		band_pending_responses--
		return
	if(!band_repeating)
		candidate_instrument.ensure_timed_tracks()
		var/choice = input(candidate, "Which track will you perform?", "Band Track") as null|anything in candidate_instrument.song_list
		if(QDELETED(src) || !band_invite_active || !band_accepting || prompt_token != band_invite_token)
			return
		if(!choice || !band_ready(candidate, candidate_instrument))
			to_chat(band_invite_leader, span_notice("[candidate.real_name] did not prepare a track."))
			release_band_member(member)
			band_pending_responses--
			return
		member.track_title = choice
		var/datum/bard_timed_track/track = candidate_instrument.timed_tracks[choice]
		if(track?.custom && track.phrases.len)
			member.sing = alert(candidate, "Use timed singing?", "Band Mode", "Sing", "Mute") == "Sing"
	if(QDELETED(src) || !band_invite_active || !band_accepting || prompt_token != band_invite_token)
		return
	if(!band_ready(candidate, candidate_instrument))
		release_band_member(member)
		band_pending_responses--
		to_chat(band_invite_leader, span_notice("[candidate ? candidate.real_name : "A performer"] is no longer ready."))
		return
	band_members += member
	preload_band_track(candidate, candidate_instrument.timed_tracks[member.track_title])
	band_pending_responses--
	to_chat(candidate, span_notice("You joined [band_invite_leader.real_name]'s band. Waiting for the leader to start."))
	to_chat(band_invite_leader, span_notice("[candidate.real_name] is ready: [member.track_title] ([member.sing ? "Sing" : "Mute"])."))
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/finish_band_invite(invite_token)
	if(!band_invite_active || invite_token != band_invite_token)
		return
	if(!band_ready(band_invite_leader, src))
		cancel_band_invite()
		return
	band_accepting = FALSE
	for(var/datum/bard_band_member/member as anything in band_reserved_members)
		if(!(member in band_members) && member.player?.bard_band_owner == src)
			to_chat(band_invite_leader, span_notice("[member.player ? member.player.real_name : "A performer"] did not join before the deadline."))
			release_band_member(member)
	if(!band_members.len)
		to_chat(band_invite_leader, span_warning("No performers are ready. The invitation was cancelled."))
		cancel_band_invite()
		return
	if(band_pending_responses)
		to_chat(band_invite_leader, span_notice("[band_pending_responses] performers did not finish responding in time."))
	var/list/names = list()
	preload_band_track(band_invite_leader, get_selected_track())
	for(var/datum/bard_band_member/member as anything in band_members)
		names += !QDELETED(member.player) ? member.player.real_name : "Unavailable"
	// An unanswered confirmation must not keep preparation channels occupied.
	clear_band_preloads()
	var/answer = alert(band_invite_leader, "С вами готовы сыграть: [jointext(names, ", ")]. Начать?", "Группа готова", "Да", "Нет")
	if(QDELETED(src) || !band_invite_active || invite_token != band_invite_token)
		return
	if(answer == "Да")
		start_synced_band(band_invite_leader, TRUE)
	else
		cancel_band_invite()

/obj/item/rogue/instrument/proc/clear_band_preloads()
	for(var/file_path in band_preloads)
		var/list/preload = band_preloads[file_path]
		for(var/datum/weakref/listener_ref as anything in preload["listeners"])
			var/mob/listener = listener_ref.resolve()
			listener?.stop_sound_channel(preload["channel"])
		var/datum/preload_owner = preload["owner"]
		SSsounds.instrument_channels.release_channel(preload_owner)
		qdel(preload_owner)
	band_preloads = list()

/obj/item/rogue/instrument/proc/cancel_band_invite()
	clear_band_preloads()
	for(var/datum/bard_band_member/member as anything in band_reserved_members)
		if(!QDELETED(member.player))
			to_chat(member.player, span_notice("Band invitation finished or cancelled."))
		release_band_member(member)
	if(band_invite_leader?.bard_band_owner == src)
		band_invite_leader.bard_band_owner = null
	band_reserved_members = list()
	band_reserved_instruments = list()
	band_owner = null
	band_invite_active = FALSE
	band_accepting = FALSE
	band_invite_until = 0
	band_invite_leader = null
	band_members = list()
	band_pending_responses = 0
	band_invite_token++
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/start_synced_band(mob/living/user, from_invite = FALSE)
	if(!from_invite || !band_invite_active || user != band_invite_leader)
		return
	if(!band_ready(user, src))
		to_chat(user, span_warning("You can no longer start this performance."))
		cancel_band_invite()
		return
	var/list/ready = list()
	for(var/datum/bard_band_member/member as anything in band_members)
		if(!band_ready(member.player, member.instrument) || !member.instrument.timed_tracks[member.track_title]?.file_path)
			to_chat(user, span_warning("[member.player ? member.player.real_name : "A performer"] cannot play now (distance, instrument or track)."))
			continue
		ready += member
	if(!ready.len)
		to_chat(user, span_warning("No other performers are ready. Group play cancelled."))
		cancel_band_invite()
		return
	var/datum/bard_timed_track/leader_track = get_selected_track()
	// Preparation must return its music slots before the actual ensemble takes them.
	clear_band_preloads()
	stop_music(user)
	var/list/started = list()
	var/shared_start = REALTIMEOFDAY
	play_track(user, leader_track, shared_start)
	if(!playing)
		to_chat(user, span_warning("The leader could not start the selected track."))
		cancel_band_invite()
		return
	for(var/datum/bard_band_member/member as anything in ready)
		member.instrument.stop_music(member.player)
		member.instrument.music_panel_selected = member.track_title
		member.instrument.auto_song_enabled = member.sing
		member.instrument.repeat_enabled = repeat_enabled
		member.instrument.play_track(member.player, member.instrument.timed_tracks[member.track_title], shared_start)
		if(member.instrument.playing)
			started += member
			to_chat(member.player, span_notice("You are now playing with [user.real_name]."))
		else
			to_chat(user, span_warning("[member.player.real_name] could not start their track."))
		SStgui.update_uis(member.instrument)
	if(!started.len)
		stop_music(user)
		to_chat(user, span_warning("No other instruments could start. Group performance cancelled."))
		cancel_band_invite()
		return
	saved_band_members = started.Copy()
	saved_band_track_title = leader_track.title
	saved_band_sing = auto_song_enabled
	saved_band_repeat = repeat_enabled
	cancel_band_invite()
	band_owner = src
	user.bard_band_owner = src
	for(var/datum/bard_band_member/member as anything in started)
		member.player.bard_band_owner = src
		member.instrument.band_owner = src
	to_chat(user, span_notice("Your band started. The lineup was saved for the next performance."))

/obj/item/rogue/instrument/proc/get_auto_song_phrase_index(datum/bard_timed_track/track, elapsed_seconds)
	if(!track?.phrases?.len)
		return 1
	for(var/i in 1 to track.phrases.len)
		var/datum/bard_timed_phrase/phrase = track.phrases[i]
		if(phrase.time >= elapsed_seconds)
			return i
	return track.phrases.len + 1

/obj/item/rogue/instrument/proc/process_auto_song()
	var/mob/living/user = current_player
	var/datum/bard_timed_track/track = auto_song_track
	if(QDELETED(src) || QDELETED(user) || QDELETED(track) || !playing || current_track != track || current_player != user || !user.bard_auto_singing || !track.phrases.len)
		stop_auto_song(user)
		return FALSE
	if(auto_song_cycle_started_at != music_realtime_started_at)
		auto_song_cycle_started_at = music_realtime_started_at
		auto_song_next_phrase_index = 1
	var/elapsed_ticks = REALTIMEOFDAY - music_realtime_started_at
	var/duration_ticks = round(track.duration_seconds * 10)
	if(duration_ticks > 0 && elapsed_ticks >= duration_ticks)
		if(!repeat_enabled)
			stop_auto_song(user)
			return FALSE
		var/cycles_passed = max(floor(elapsed_ticks / duration_ticks), 1)
		music_realtime_started_at += cycles_passed * duration_ticks
		auto_song_cycle_started_at = music_realtime_started_at
		auto_song_next_phrase_index = 1
		elapsed_ticks = REALTIMEOFDAY - music_realtime_started_at
	var/spoken = 0
	while(auto_song_next_phrase_index <= track.phrases.len)
		var/datum/bard_timed_phrase/phrase = track.phrases[auto_song_next_phrase_index]
		if(!phrase)
			auto_song_next_phrase_index++
			continue
		if(round(phrase.time * 10) > elapsed_ticks)
			break
		if(phrase.text && elapsed_ticks - round(phrase.time * 10) <= 20 && spoken >= 2)
			break
		auto_song_next_phrase_index++
		if(phrase.text && elapsed_ticks - round(phrase.time * 10) <= 20 && spoken < 2)
			spoken++
			user.say(phrase.text, forced = "bard auto song")
	if(!repeat_enabled && auto_song_next_phrase_index > track.phrases.len)
		stop_auto_song(user)
		return FALSE
	return TRUE

/obj/item/rogue/instrument/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/rogue/instrument/ui_interact(mob/user, datum/tgui/ui)
	ensure_timed_tracks()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardMusicLibrary", "Music")
		ui.open()
	ui.set_autoupdate(FALSE)

/obj/item/rogue/instrument/ui_data(mob/user)
	ensure_timed_tracks()
	var/datum/bard_timed_track/selected = get_selected_track()
	var/datum/bard_timed_track/playing_track = current_track || selected
	var/list/tracks = list()
	for(var/song_title in song_list)
		var/datum/bard_timed_track/track = timed_tracks[song_title]
		tracks += list(list(
			"title" = song_title,
			"selected" = (song_title == music_panel_selected),
			"duration_seconds" = track?.duration_seconds || 0,
			"duration_label" = bard_track_format_duration(track?.duration_seconds || 0),
			"phrase_count" = track?.phrases?.len || 0,
			"custom" = track?.custom || FALSE,
			"analyzed_duration" = track?.analyzed_duration || FALSE
		))
	var/list/selected_data = null
	if(selected)
		var/list/phrase_data = list()
		for(var/datum/bard_timed_phrase/phrase as anything in selected.phrases)
			phrase_data += list(list("time" = phrase.time, "text" = phrase.text))
		selected_data = list(
			"title" = selected.title,
			"custom" = selected.custom,
			"duration_seconds" = selected.duration_seconds,
			"duration_label" = bard_track_format_duration(selected.duration_seconds),
			"analyzed_duration" = selected.analyzed_duration,
			"spacing_seconds" = selected.phrase_spacing_seconds,
			"lyrics" = selected.lyrics,
			"json" = selected.export_json(),
			"phrases" = phrase_data
		)
	var/list/member_data = list()
	for(var/datum/bard_band_member/member as anything in band_members)
		member_data += list(member.export_data())
	return list(
		"tracks" = tracks,
		"selected" = selected_data,
		"is_expert" = user?.mind && user.get_skill_level(/datum/skill/misc/music) >= SKILL_LEVEL_EXPERT,
		"playing" = playing,
		"repeat_enabled" = repeat_enabled,
		"repeat_mode" = repeat_enabled ? "repeat" : "once",
		"elapsed_seconds" = playing ? max(round((REALTIMEOFDAY - music_realtime_started_at) / 10), 0) : 0,
		"progress_ratio" = (playing && playing_track?.duration_seconds) ? min(max(((REALTIMEOFDAY - music_realtime_started_at) / 10) / playing_track.duration_seconds, 0), 1) : 0,
		"playback_id" = music_playback_id,
		"auto_song_enabled" = auto_song_enabled,
		"auto_singing_title" = auto_singing_title,
		"playing_track_title" = current_track_title,
		"playing_duration_seconds" = playing_track?.duration_seconds || 0,
		"playing_duration_label" = bard_track_format_duration(playing_track?.duration_seconds || 0),
		"band_invite_active" = band_invite_active,
		"band_invite_seconds_left" = band_invite_active ? max(round((band_invite_until - world.time) / 10), 0) : 0,
		"band_members" = member_data,
		"is_band_leader" = band_invite_leader == user
	)

/obj/item/rogue/instrument/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!usr || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return FALSE
	var/mob/living/user = usr
	if(!(src in user.held_items))
		to_chat(user, span_warning("Hold the instrument in either hand."))
		return FALSE
	add_fingerprint(user)
	ensure_timed_tracks()
	switch(action)
		if("select")
			var/song_title = params["title"]
			if(song_list[song_title])
				music_panel_selected = song_title
			return TRUE
		if("set_lyrics")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				if(params["spacing"])
					var/spacing = params["spacing"]
					track.phrase_spacing_seconds = clamp(round(bard_track_num(spacing), 0.1), 0.1, 120)
				track.rebuild_from_lyrics(params["lyrics"])
			return TRUE
		if("set_spacing")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_spacing(params["spacing"])
			return TRUE
		if("set_phrase_time")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_phrase_time(params["index"], params["time"])
			return TRUE
		if("set_phrase_text")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_phrase_text(params["index"], params["text"])
			return TRUE
		if("clear_lyrics")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.rebuild_from_lyrics("")
			return TRUE
		if("import_json")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom && !track.import_json(params["json"]))
				to_chat(user, span_warning("Invalid track JSON."))
			return TRUE
		if("upload")
			if(!(user.mind && user.get_skill_level(/datum/skill/misc/music) >= SKILL_LEVEL_EXPERT))
				to_chat(user, span_warning("You need expert music skill to add tracks."))
				return TRUE
			if(lastfilechange && world.time < lastfilechange + 3 MINUTES)
				to_chat(user, span_warning("NOT YET!"))
				return TRUE
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			var/song_file = music_upload(user, src)
			if(!song_file || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return TRUE
			lastfilechange = world.time
			var/path = "[song_file]"
			var/entry = input(user, "Name your song:", "Song Name") as text|null
			if(QDELETED(src) || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return TRUE
			var/songname = strip_html(entry, MAX_NAME_LEN)
			if(!songname)
				songname = copytext(path, findlasttext(path, "/") + 1)
			song_list[songname] = song_file
			var/datum/bard_timed_track/new_track = new
			new_track.set_song(songname, song_file, TRUE)
			if(params["spacing"])
				var/spacing = params["spacing"]
				new_track.phrase_spacing_seconds = clamp(round(bard_track_num(spacing), 0.1), 0.1, 120)
			new_track.rebuild_from_lyrics(params["lyrics"])
			timed_tracks[songname] = new_track
			music_panel_selected = songname
			return TRUE
		if("play")
			if(band_invite_active && user == band_invite_leader)
				start_band_invite(user)
				return TRUE
			if(!playing && user.bard_band_owner && user.bard_band_owner != src)
				to_chat(user, span_warning("Answer or leave your current band invitation first."))
				return TRUE
			if(playing)
				stop_music(user)
			else
				var/datum/bard_timed_track/track = get_selected_track()
				var/play_mode = saved_band_members.len ? "Group" : alert(user, "How do you want to perform [track?.title]?", "Play Music", "Solo", "Group", "Cancel")
				if(play_mode == "Solo")
					play_track(user, track)
				else if(play_mode == "Group")
					if(band_invite_active)
						start_band_invite(user)
					else if(saved_band_members.len)
						var/list/names = list()
						for(var/datum/bard_band_member/member as anything in saved_band_members)
							names += member.player ? member.player.real_name : "Unknown"
						var/choice = alert(user, "Вы играли вместе с: [jointext(names, ", ")].", "Группа", "Собрать заново", "Играть так же", "Выйти")
						if(choice == "Выйти")
							saved_band_members = list()
						else if(choice == "Собрать заново" || choice == "Играть так же")
							start_band_invite(user, choice == "Играть так же")
					else
						start_band_invite(user)
			return TRUE
		if("toggle_repeat")
			repeat_enabled = !repeat_enabled
			return TRUE
		if("set_repeat_mode")
			repeat_enabled = params["mode"] == "repeat"
			return TRUE
		if("sing_track")
			var/song_title = params["title"]
			if(song_list[song_title])
				music_panel_selected = song_title
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				auto_song_enabled = !auto_song_enabled
				if(!auto_song_enabled)
					stop_auto_song(user)
					return TRUE
				if(playing && current_track == track)
					start_auto_song(user, track)
			return TRUE
		if("toggle_sing")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				auto_song_enabled = !auto_song_enabled
				if(!auto_song_enabled)
					stop_auto_song(user)
					return TRUE
				if(playing && current_track == track)
					start_auto_song(user, track)
			return TRUE
		if("cancel_band")
			if(user == band_invite_leader)
				cancel_band_invite()
			return TRUE
		if("start_band")
			start_synced_band(user)
			return TRUE
	return FALSE
