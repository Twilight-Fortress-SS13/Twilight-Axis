/client/proc/clear_job_respawn_delay()
	set name = "Clear Job Respawn Delay"
	set category = "Admin.Admin"
	set desc = "Remove a ckey from the same-job respawn delay list."

	if(!check_rights(R_ADMIN))
		return

	var/list/delay_choices = list()
	for(var/player_ckey in GLOB.job_respawn_delays)
		var/delay_until = GLOB.job_respawn_delays[player_ckey]
		var/display_text
		if(isnum(delay_until))
			var/remaining_time = max(0, round((delay_until - world.time) / 10))
			display_text = "[player_ckey] ([remaining_time] seconds remaining)"
		else
			display_text = "[player_ckey] (invalid delay value)"
		delay_choices[display_text] = player_ckey

	var/manual_input = "Type ckey manually"
	delay_choices[manual_input] = manual_input

	var/selected_delay = input(src, "Choose a ckey to clear from job respawn delays.", "Clear Job Respawn Delay") as null|anything in sortList(delay_choices)
	if(!selected_delay)
		return

	var/target_ckey = delay_choices[selected_delay]
	if(target_ckey == manual_input)
		target_ckey = ckey(input(src, "Enter ckey to clear from job respawn delays.", "Clear Job Respawn Delay") as null|text)

	if(!target_ckey)
		return

	if(!(target_ckey in GLOB.job_respawn_delays))
		to_chat(src, span_warning("[target_ckey] is not in job respawn delays."))
		return

	var/old_delay = GLOB.job_respawn_delays[target_ckey]
	var/remaining_text = ""
	if(isnum(old_delay))
		var/remaining_time = max(0, round((old_delay - world.time) / 10))
		remaining_text = " ([remaining_time] seconds remaining)"

	GLOB.job_respawn_delays -= target_ckey

	to_chat(src, span_interface("Cleared job respawn delay for [target_ckey]."))
	log_admin("[key_name(usr)] cleared job respawn delay for [target_ckey][remaining_text].")
	message_admins("[key_name_admin(usr)] cleared job respawn delay for [target_ckey][remaining_text].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Clear Job Respawn Delay")

/client/proc/client_render_stats()
	set name = "Client Render Stats"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/images_count = images ? images.len : 0
	var/screen_count = screen ? screen.len : 0
	var/runechat_queue = SSrunechat?.message_queue ? SSrunechat.message_queue.len : 0
	var/overlays_count = mob?.overlays ? mob.overlays.len : 0
	var/underlays_count = mob?.underlays ? mob.underlays.len : 0
	var/vis_contents_count = mob?.vis_contents ? mob.vis_contents.len : 0
	var/z_level = mob ? mob.z : 0

	to_chat(mob, span_notice("RenderStats: images=[images_count] screen=[screen_count] overlays=[overlays_count] underlays=[underlays_count] vis_contents=[vis_contents_count] runechat_queue=[runechat_queue] z=[z_level]"))
