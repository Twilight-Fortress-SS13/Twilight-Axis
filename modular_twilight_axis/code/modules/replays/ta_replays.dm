/datum/config_entry/flag/record_replays

SUBSYSTEM_DEF(replays)
	name = "Replay Recorder"
	flags = SS_BACKGROUND
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	wait = 2
	priority = FIRE_PRIORITY_DEFAULT
	init_order = INIT_ORDER_TA_REPLAYS

	var/recording = FALSE
	var/snapshot_complete = FALSE
	var/demo_file
	var/replay_complete_path
	var/last_written_time = null
	var/recording_start_time = 0

	var/list/marked_dirty = list()
	var/list/marked_new = list()
	var/list/marked_turfs = list()
	var/list/del_list = list()
	var/list/icon_cache = list()
	var/appearance_dictionary_version = 0
	var/list/icon_state_caches = list()
	var/list/name_cache = list()
	var/list/full_appearance_cache = list()
	var/list/full_appearance_cache_order = list()
	var/full_appearance_cache_slot = 1
	var/max_cached_appearances = 2048
	var/list/normal_diff_cache = list()
	var/list/overlay_diff_cache = list()
	var/normal_diff_cache_count = 0
	var/overlay_diff_cache_count = 0
	var/max_cached_diffs = 2048
	var/max_entries_per_fire = 128
	var/max_pending_entries = 8192
	var/list/replay_client_mobs = list()
	var/list/replay_identity_cache = list()
	var/next_client_scan = 0

/datum/controller/subsystem/replays/Initialize(timeofday)
	if(!CONFIG_GET(flag/record_replays))
		can_fire = FALSE
		return ..()

	if(!GLOB.log_directory || !length(GLOB.log_directory))
		log_world("\[replay\] Recording disabled: GLOB.log_directory is empty.")
		can_fire = FALSE
		return ..()

	var/demo_path = "[GLOB.log_directory]/demo.txt"
	if(fexists(demo_path))
		log_world("\[replay\] Recording disabled: replay output path already exists.")
		can_fire = FALSE
		return ..()

	demo_file = file(demo_path)
	replay_complete_path = "[demo_path].complete"
	recording = TRUE
	write_demo_line("demo version 1")
	var/commit = "unknown"
	if(GLOB.revdata && GLOB.revdata.commit)
		commit = GLOB.revdata.commit
	write_demo_line("commit [commit]")
	write_demo_line("init [world.maxx] [world.maxy] [world.maxz]")

	write_initial_turfs()
	write_initial_objects()

	var/list/pending_new = marked_new.Copy()
	for(var/atom/movable/M as anything in pending_new)
		if(!M || M.gc_destroyed || !M.demo_snapshot_written)
			continue
		marked_new -= M
		if(get_turf(M) != M.demo_last_loc)
			marked_dirty[M] = TRUE

	snapshot_complete = TRUE
	recording_start_time = world.time
	last_written_time = 0
	var/replay_wall_clock = time2text(world.timeofday, "hh:mm:ss")
	write_demo_line("clock [replay_wall_clock]")
	write_demo_line("mode dolls")
	write_demo_line("time 0")
	scan_replay_clients(0)
	next_client_scan = world.time + 10
	return ..()

/datum/controller/subsystem/replays/proc/scan_replay_clients(at_time)
	if(!recording || !snapshot_complete)
		return
	var/list/seen = list()
	var/list/lines = list()
	for(var/client/C in GLOB.clients)
		if(!C || !C.ckey)
			continue
		var/client_ckey = C.ckey
		seen[client_ckey] = TRUE
		var/mob_ref = C.mob ? "\ref[C.mob]" : "null"
		if(C.mob)
			if(!C.mob.demo_snapshot_written && !marked_new[C.mob])
				mark_new(C.mob)
			var/recorded_real_name = ""
			if("real_name" in C.mob.vars)
				recorded_real_name = C.mob.vars["real_name"]
			if(!istext(recorded_real_name))
				recorded_real_name = ""
			recorded_real_name = copytext(recorded_real_name, 1, 161)
			var/visible_name = C.mob.name
			if(!istext(visible_name))
				visible_name = ""
			visible_name = copytext(visible_name, 1, 161)
			var/list/previous_identity = replay_identity_cache[mob_ref]
			if(!islist(previous_identity) || previous_identity[1] != recorded_real_name || previous_identity[2] != client_ckey || previous_identity[3] != visible_name)
				replay_identity_cache[mob_ref] = list(recorded_real_name, client_ckey, visible_name)
				var/identity_payload = json_encode(list("real_name" = recorded_real_name, "ckey" = client_ckey, "visible_name" = visible_name))
				lines += "identity [mob_ref] [identity_payload]"
		var/old_ref = replay_client_mobs[client_ckey]
		if(isnull(old_ref))
			lines += "login [client_ckey]"
			replay_client_mobs[client_ckey] = mob_ref
			lines += "setmob [client_ckey] [mob_ref]"
		else if(old_ref != mob_ref)
			replay_client_mobs[client_ckey] = mob_ref
			lines += "setmob [client_ckey] [mob_ref]"
	for(var/client_ckey in replay_client_mobs)
		if(!seen[client_ckey])
			lines += "logout [client_ckey]"
			replay_client_mobs -= client_ckey
	write_batch(lines, at_time)

/datum/controller/subsystem/replays/proc/write_demo_line(line)
	if(!demo_file)
		return FALSE
	WRITE_FILE(demo_file, "[line]")
	return TRUE

/datum/controller/subsystem/replays/proc/write_batch(list/lines, at_time)
	if(!lines.len)
		return
	var/batch_text = jointext(lines, "\n")
	if(last_written_time != at_time)
		batch_text = "time [at_time]\n[batch_text]"
		last_written_time = at_time
	write_demo_line(batch_text)

/datum/controller/subsystem/replays/proc/write_initial_turfs()
	var/list/snapshot_cache = list()
	var/snapshot_cache_size = 0
	for(var/z in 1 to world.maxz)
		var/list/row_list = list()
		var/last_appearance
		var/rle_count = 1
		for(var/y in 1 to world.maxy)
			for(var/x in 1 to world.maxx)
				var/turf/T = locate(x, y, z)
				var/this_appearance
				if(T)
					this_appearance = T.appearance
					T.demo_last_appearance = this_appearance
					T.demo_last_recorded_type = T.type
					T.demo_last_recorded_icon = T.icon
					T.demo_last_recorded_icon_state = T.icon_state
					T.demo_last_recorded_dir = T.dir
					T.demo_last_recorded_density = T.density
					T.demo_last_recorded_opacity = T.opacity
				else
					this_appearance = "n"
				if(this_appearance == last_appearance)
					rle_count++
				else
					if(rle_count > 1)
						row_list += rle_count
					rle_count = 1
					if(istext(this_appearance))
						row_list += this_appearance
					else
						var/list/type_cache = snapshot_cache[T.type]
						var/encoded_appearance = type_cache ? type_cache[this_appearance] : null
						if(isnull(encoded_appearance))
							var/dictionary_version_before = appearance_dictionary_version
							encoded_appearance = encode_appearance(this_appearance, encoded_type = T.type)
							if(snapshot_cache_size < 8192 && dictionary_version_before == appearance_dictionary_version)
								if(!type_cache)
									type_cache = list()
									snapshot_cache[T.type] = type_cache
								type_cache[this_appearance] = encoded_appearance
								snapshot_cache_size++
						row_list += encoded_appearance
				last_appearance = this_appearance
			CHECK_TICK
		if(rle_count > 1)
			row_list += rle_count
		write_demo_line(jointext(row_list, ","))
		CHECK_TICK

/datum/controller/subsystem/replays/proc/write_initial_objects()
	var/list/mobs_by_row = list()
	var/list/nullspace_list = list()
	for(var/mob/M in world)
		if(isturf(M.loc))
			var/row_key = "[M.z],[M.y]"
			var/list/bucket_row = mobs_by_row[row_key]
			if(!bucket_row)
				bucket_row = list()
				mobs_by_row[row_key] = bucket_row
			var/x_key = "[M.x]"
			var/list/bucket_cell = bucket_row[x_key]
			if(!bucket_cell)
				bucket_cell = list()
				bucket_row[x_key] = bucket_cell
			bucket_cell += encode_init_obj(M)
		else if(isnull(M.loc))
			nullspace_list += encode_init_obj(M)
		CHECK_TICK

	for(var/z in 1 to world.maxz)
		var/spacing = 0
		var/list/row_list = list()
		for(var/y in 1 to world.maxy)
			var/list/mapped_row = mobs_by_row["[z],[y]"]
			if(!mapped_row)
				spacing += world.maxx
				CHECK_TICK
				continue
			for(var/x in 1 to world.maxx)
				var/list/mapped_cell = mapped_row["[x]"]
				if(mapped_cell)
					if(spacing)
						row_list += spacing
						spacing = 0
					row_list += mapped_cell
				spacing++
			CHECK_TICK
		write_demo_line(jointext(row_list, ","))
	write_demo_line(jointext(nullspace_list, ","))

/datum/controller/subsystem/replays/proc/encode_doll_name(mob/M)
	var/mob_name = istext(M.name) ? M.name : ""
	return "{;;[json_encode(mob_name)]}"

/datum/controller/subsystem/replays/proc/encode_init_obj(mob/M)
	M.demo_last_loc = get_turf(M)
	M.demo_snapshot_written = TRUE
	return "\ref[M]=[encode_doll_name(M)]"

/datum/controller/subsystem/replays/fire(resumed = FALSE)
	if(!recording || !snapshot_complete)
		return

	var/current_replay_time = world.time - recording_start_time
	if(world.time >= next_client_scan)
		next_client_scan = world.time + 10
		scan_replay_clients(current_replay_time)
	if(!marked_new.len && !marked_dirty.len && !marked_turfs.len && !del_list.len)
		return

	var/list/output_lines = list()
	var/processed_entries = 0
	var/canceled = FALSE
	var/list/deleted_entries = list()
	while(del_list.len && processed_entries < max_entries_per_fire)
		if(MC_TICK_CHECK)
			canceled = TRUE
			break
		var/deleted_ref = del_list[del_list.len]
		del_list.len--
		deleted_entries += deleted_ref
		processed_entries++
	if(deleted_entries.len)
		output_lines += "del [jointext(deleted_entries, ",")]"
	if(canceled || processed_entries >= max_entries_per_fire)
		write_batch(output_lines, current_replay_time)
		return

	var/list/dirty_updates = list()
	while(marked_dirty.len && processed_entries < max_entries_per_fire)
		if(MC_TICK_CHECK)
			canceled = TRUE
			break
		var/atom/movable/M = marked_dirty[marked_dirty.len]
		marked_dirty.len--
		processed_entries++
		if(!M || M.gc_destroyed)
			continue
		if(!ismob(M))
			continue
		var/turf/current_turf = get_turf(M)
		if(current_turf == M.demo_last_loc)
			continue
		M.demo_last_loc = current_turf
		var/doll_loc = current_turf ? "[current_turf.x],[current_turf.y],[current_turf.z]" : "null"
		dirty_updates += "\ref[M] [doll_loc] ="
		M.demo_snapshot_written = TRUE
	if(dirty_updates.len)
		output_lines += "update [jointext(dirty_updates, ",")]"
	if(canceled || processed_entries >= max_entries_per_fire)
		write_batch(output_lines, current_replay_time)
		return

	var/list/new_updates = list()
	while(marked_new.len && processed_entries < max_entries_per_fire)
		if(MC_TICK_CHECK)
			canceled = TRUE
			break
		var/atom/movable/M = marked_new[marked_new.len]
		marked_new.len--
		processed_entries++
		if(!M || M.gc_destroyed)
			continue
		if(!ismob(M))
			continue
		var/turf/mob_turf = get_turf(M)
		var/loc_string = mob_turf ? "[mob_turf.x],[mob_turf.y],[mob_turf.z]" : "null"
		M.demo_last_loc = mob_turf
		M.demo_snapshot_written = TRUE
		new_updates += "\ref[M] [loc_string] [encode_doll_name(M)]"
	if(new_updates.len)
		output_lines += "new [jointext(new_updates, ",")]"
	if(canceled || processed_entries >= max_entries_per_fire)
		write_batch(output_lines, current_replay_time)
		return

	var/list/turf_updates = list()
	while(marked_turfs.len && processed_entries < max_entries_per_fire)
		if(MC_TICK_CHECK)
			canceled = TRUE
			break
		var/coord = marked_turfs[marked_turfs.len]
		marked_turfs.len--
		processed_entries++
		var/list/parts = splittext(coord, ",")
		if(parts.len != 3)
			continue
		var/turf/T = locate(text2num(parts[1]), text2num(parts[2]), text2num(parts[3]))
		if(!T)
			continue
		if(T.demo_last_recorded_type == T.type && T.demo_last_recorded_icon == T.icon && T.demo_last_recorded_icon_state == T.icon_state && T.demo_last_recorded_dir == T.dir && T.demo_last_recorded_density == T.density && T.demo_last_recorded_opacity == T.opacity)
			continue
		var/current_appearance = T.appearance
		if(current_appearance != T.demo_last_appearance)
			turf_updates += "([coord])=[encode_appearance(current_appearance, encoded_type = T.type)]"
		T.demo_last_appearance = current_appearance
		T.demo_last_recorded_type = T.type
		T.demo_last_recorded_icon = T.icon
		T.demo_last_recorded_icon_state = T.icon_state
		T.demo_last_recorded_dir = T.dir
		T.demo_last_recorded_density = T.density
		T.demo_last_recorded_opacity = T.opacity
	if(turf_updates.len)
		output_lines += "turf [jointext(turf_updates, ",")]"

	write_batch(output_lines, current_replay_time)

/datum/controller/subsystem/replays/Shutdown()
	if(recording && snapshot_complete)
		if(SSticker?.current_state == GAME_STATE_FINISHED)
			var/remaining_flushes = 128
			while(remaining_flushes-- > 0 && (marked_new.len || marked_dirty.len || marked_turfs.len || del_list.len))
				fire()
				CHECK_TICK
		else
			fire()
		if(SSticker?.current_state == GAME_STATE_FINISHED && !marked_new.len && !marked_dirty.len && !marked_turfs.len && !del_list.len && replay_complete_path)
			var/final_replay_time = world.time - recording_start_time
			if(last_written_time != final_replay_time)
				write_demo_line("time [final_replay_time]")
				last_written_time = final_replay_time
			WRITE_FILE(file(replay_complete_path), "ta-replay-complete-v1")
	recording = FALSE
	return ..()

/datum/controller/subsystem/replays/proc/check_backlog()
	if(!recording || !snapshot_complete)
		return
	if(marked_new.len + marked_dirty.len + marked_turfs.len + del_list.len < max_pending_entries)
		return
	recording = FALSE
	can_fire = FALSE
	log_world("\[replay\] Recording stopped: event backlog exceeded [max_pending_entries]. Replay remains incomplete.")

/datum/controller/subsystem/replays/proc/mark_new(atom/A)
	if(!recording || !A || !ismob(A))
		return
	if(A.gc_destroyed)
		return
	if(marked_new[A])
		return
	marked_dirty -= A
	marked_new[A] = TRUE
	check_backlog()

/datum/controller/subsystem/replays/proc/mark_dirty(atom/A)
	if(!recording || !A)
		return
	if(isturf(A))
		var/turf/T = A
		mark_turf(T, TRUE)
		return
	if(!ismob(A) || A.gc_destroyed)
		return
	if(marked_dirty[A] || marked_new[A])
		return
	var/mob/actor = A
	if(!actor.demo_snapshot_written)
		mark_new(A)
		return
	var/turf/current_turf = isturf(actor.loc) ? actor.loc : get_turf(actor)
	if(current_turf == actor.demo_last_loc)
		return
	marked_dirty[A] = TRUE
	check_backlog()

/datum/controller/subsystem/replays/proc/mark_destroyed(atom/A)
	if(!recording || !A || !ismob(A))
		return
	var/atom/movable/M = A
	marked_new -= M
	marked_dirty -= M
	if(M.demo_snapshot_written)
		var/ref_key = "\ref[M]"
		if(!del_list[ref_key])
			del_list[ref_key] = TRUE
			check_backlog()

/datum/controller/subsystem/replays/proc/mark_turf(turf/T, visual_update = FALSE)
	if(!recording || !T)
		return
	if(visual_update && T.demo_last_recorded_type == T.type && T.demo_last_recorded_icon == T.icon && T.demo_last_recorded_icon_state == T.icon_state && T.demo_last_recorded_dir == T.dir && T.demo_last_recorded_density == T.density && T.demo_last_recorded_opacity == T.opacity)
		return
	var/coord = "[T.x],[T.y],[T.z]"
	if(!marked_turfs[coord])
		marked_turfs[coord] = TRUE
		check_backlog()

/datum/controller/subsystem/replays/proc/cache_appearance_diff(image/appearance, image/before, diff_remove_overlays, encoded)
	var/list/cache = diff_remove_overlays ? overlay_diff_cache : normal_diff_cache
	if(diff_remove_overlays)
		if(overlay_diff_cache_count >= max_cached_diffs)
			return
	else if(normal_diff_cache_count >= max_cached_diffs)
		return
	var/list/previous_values = cache[appearance]
	if(!previous_values)
		previous_values = list()
		cache[appearance] = previous_values
	if(!isnull(previous_values[before]))
		return
	previous_values[before] = encoded
	if(diff_remove_overlays)
		overlay_diff_cache_count++
	else
		normal_diff_cache_count++

/datum/controller/subsystem/replays/proc/encode_appearance(image/appearance, image/diff_appearance, diff_remove_overlays = FALSE, atom/encoded_type = null)
	if(isnull(appearance))
		return "n"
	if(appearance == diff_appearance)
		return "="

	var/dictionary_version_before = appearance_dictionary_version
	var/cache_allowed = (!encoded_type || initial(encoded_type.smooth) == SMOOTH_FALSE)
	var/cache_full = !diff_appearance && cache_allowed
	var/cache_diff = !!diff_appearance && cache_allowed
	if(cache_full)
		var/cached_full = full_appearance_cache[appearance]
		if(!isnull(cached_full))
			return cached_full
	if(cache_diff)
		var/list/diff_lookup = diff_remove_overlays ? overlay_diff_cache : normal_diff_cache
		var/list/appearance_diffs = diff_lookup[appearance]
		if(appearance_diffs)
			var/cached_diff = appearance_diffs[diff_appearance]
			if(!isnull(cached_diff))
				return cached_diff

	var/appearance_icon = appearance.icon
	var/appearance_icon_state = appearance.icon_state
	if(encoded_type && initial(encoded_type.smooth) != SMOOTH_FALSE)
		appearance_icon = initial(encoded_type.icon)
		appearance_icon_state = initial(encoded_type.icon_state)

	var/icon_txt = "[appearance_icon]"
	var/cached_icon = icon_cache[icon_txt] || icon_txt
	var/list/icon_state_cache
	if(!isnum(cached_icon))
		icon_cache[icon_txt] = icon_cache.len + 1
		appearance_dictionary_version++
		icon_state_caches[++icon_state_caches.len] = list()
		icon_state_cache = icon_state_caches[icon_cache[icon_txt]]
	else
		icon_state_cache = icon_state_caches[cached_icon]

	var/cached_icon_state = icon_state_cache[appearance_icon_state] || appearance_icon_state
	if(!isnum(cached_icon_state))
		icon_state_cache[appearance_icon_state] = icon_state_cache.len + 1
		appearance_dictionary_version++

	var/cached_name = name_cache[appearance.name] || appearance.name
	if(!isnum(cached_name))
		name_cache[appearance.name] = name_cache.len + 1
		appearance_dictionary_version++

	var/color_string = appearance.color || "w"
	if(islist(color_string))
		var/list/old_list = appearance.color
		var/list/inted = list()
		inted.len = old_list.len
		for(var/i in 1 to old_list.len)
			inted[i] = round(old_list[i] * 255)
		color_string = jointext(inted, ",")

	var/list/current_overlays = appearance.overlays
	var/list/current_underlays = appearance.underlays
	var/overlays_identical = FALSE
	var/underlays_identical = FALSE
	if(diff_appearance)
		if(diff_remove_overlays)
			overlays_identical = !current_overlays.len
			underlays_identical = !current_underlays.len
		else
			var/list/previous_overlays = diff_appearance.overlays
			var/list/previous_underlays = diff_appearance.underlays
			if(current_overlays.len == previous_overlays.len)
				overlays_identical = TRUE
				for(var/i in 1 to current_overlays.len)
					if(current_overlays[i] != previous_overlays[i])
						overlays_identical = FALSE
						break
			if(current_underlays.len == previous_underlays.len)
				underlays_identical = TRUE
				for(var/i in 1 to current_underlays.len)
					if(current_underlays[i] != previous_underlays[i])
						underlays_identical = FALSE
						break

	var/appearance_transform_string = "i"
	if(appearance.transform)
		var/matrix/M = appearance.transform
		appearance_transform_string = "[M.a],[M.b],[M.c],[M.d],[M.e],[M.f]"
		if(appearance_transform_string == "1,0,0,0,1,0")
			appearance_transform_string = "i"

	var/list/diffed_appearance_list
	if(diff_appearance)
		var/diff_transform_string = "i"
		if(diff_appearance.transform)
			var/matrix/DM = diff_appearance.transform
			diff_transform_string = "[DM.a],[DM.b],[DM.c],[DM.d],[DM.e],[DM.f]"
			if(diff_transform_string == "1,0,0,0,1,0")
				diff_transform_string = "i"

		diffed_appearance_list = list(
			json_encode(cached_icon),
			json_encode(cached_icon_state),
			json_encode(cached_name),
			appearance.appearance_flags == diff_appearance.appearance_flags ? "" : appearance.appearance_flags,
			appearance.layer == diff_appearance.layer ? "" : appearance.layer,
			appearance.plane == diff_appearance.plane ? "" : appearance.plane,
			appearance.dir == diff_appearance.dir ? "" : appearance.dir,
			appearance.color == diff_appearance.color ? "" : color_string,
			appearance.alpha == diff_appearance.alpha ? "" : appearance.alpha,
			appearance.pixel_x == diff_appearance.pixel_x ? "" : appearance.pixel_x,
			appearance.pixel_y == diff_appearance.pixel_y ? "" : appearance.pixel_y,
			appearance.blend_mode == diff_appearance.blend_mode ? "" : appearance.blend_mode,
			appearance_transform_string == diff_transform_string ? "" : appearance_transform_string,
			appearance:invisibility == diff_appearance:invisibility ? "" : appearance:invisibility,
			appearance.pixel_w == diff_appearance.pixel_w ? "" : appearance.pixel_w,
			appearance.pixel_z == diff_appearance.pixel_z ? "" : appearance.pixel_z,
			"",
			""
		)
		if(overlays_identical && underlays_identical && (current_overlays.len || current_underlays.len))
			while(diffed_appearance_list.len > 0 && diffed_appearance_list[diffed_appearance_list.len] == "")
				diffed_appearance_list.len--
			var/unchanged_layers_diff = "~{[jointext(diffed_appearance_list, ";")]}"
			if(cache_diff && dictionary_version_before == appearance_dictionary_version)
				cache_appearance_diff(appearance, diff_appearance, diff_remove_overlays, unchanged_layers_diff)
			return unchanged_layers_diff

	var/overlays_string = "\[]"
	if(current_overlays.len)
		var/list/overlays_list = list()
		for(var/i in 1 to current_overlays.len)
			var/image/overlay = current_overlays[i]
			overlays_list += encode_appearance(overlay, appearance, TRUE)
		overlays_string = "\[[jointext(overlays_list, ",")]]"

	var/underlays_string = "\[]"
	if(current_underlays.len)
		var/list/underlays_list = list()
		for(var/i in 1 to current_underlays.len)
			var/image/underlay = current_underlays[i]
			underlays_list += encode_appearance(underlay, appearance, TRUE)
		underlays_string = "\[[jointext(underlays_list, ",")]]"

	var/list/appearance_list = list(
		json_encode(cached_icon),
		json_encode(cached_icon_state),
		json_encode(cached_name),
		appearance.appearance_flags,
		appearance.layer,
		appearance.plane == -32767 ? "" : appearance.plane,
		appearance.dir == 2 ? "" : appearance.dir,
		appearance.color ? color_string : "",
		appearance.alpha == 255 ? "" : appearance.alpha,
		appearance.pixel_x == 0 ? "" : appearance.pixel_x,
		appearance.pixel_y == 0 ? "" : appearance.pixel_y,
		appearance.blend_mode <= 1 ? "" : appearance.blend_mode,
		appearance_transform_string != "i" ? appearance_transform_string : "",
		appearance:invisibility == 0 ? "" : appearance:invisibility,
		appearance.pixel_w == 0 ? "" : appearance.pixel_w,
		appearance.pixel_z == 0 ? "" : appearance.pixel_z,
		current_overlays.len ? overlays_string : "",
		current_underlays.len ? underlays_string : ""
	)
	while(appearance_list.len > 0 && appearance_list[appearance_list.len] == "")
		appearance_list.len--
	var/undiffed_string = "{[jointext(appearance_list, ";")]}"

	if(diff_appearance)
		diffed_appearance_list[17] = overlays_identical ? "" : overlays_string
		diffed_appearance_list[18] = underlays_identical ? "" : underlays_string
		while(diffed_appearance_list.len > 0 && diffed_appearance_list[diffed_appearance_list.len] == "")
			diffed_appearance_list.len--
		var/diffed_string = "~{[jointext(diffed_appearance_list, ";")]}"
		if(length(diffed_string) < length(undiffed_string))
			if(cache_diff && dictionary_version_before == appearance_dictionary_version)
				cache_appearance_diff(appearance, diff_appearance, diff_remove_overlays, diffed_string)
			return diffed_string
	if(cache_diff && dictionary_version_before == appearance_dictionary_version)
		cache_appearance_diff(appearance, diff_appearance, diff_remove_overlays, undiffed_string)
	if(cache_full && dictionary_version_before == appearance_dictionary_version && length(undiffed_string) <= 4096)
		if(full_appearance_cache.len >= max_cached_appearances)
			var/old_appearance = full_appearance_cache_order[full_appearance_cache_slot]
			full_appearance_cache -= old_appearance
			full_appearance_cache_order[full_appearance_cache_slot] = appearance
			full_appearance_cache_slot++
			if(full_appearance_cache_slot > max_cached_appearances)
				full_appearance_cache_slot = 1
		else
			full_appearance_cache_order += appearance
		full_appearance_cache[appearance] = undiffed_string
	return undiffed_string

/atom
	var/image/demo_last_appearance

/turf
	var/demo_last_recorded_type
	var/demo_last_recorded_icon
	var/demo_last_recorded_icon_state
	var/demo_last_recorded_dir
	var/demo_last_recorded_density
	var/demo_last_recorded_opacity

/atom/movable
	var/atom/demo_last_loc
	var/demo_snapshot_written = FALSE
