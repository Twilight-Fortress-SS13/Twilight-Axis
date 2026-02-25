/datum/erp_scene_messaging
	var/datum/erp_controller/controller

/datum/erp_scene_messaging/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Sends message respecting hidden_mode.
/datum/erp_scene_messaging/proc/send_message(text, datum/erp_sex_link/L = null)
	if(!text)
		return

	var/datum/erp_actor/A = null
	var/datum/erp_actor/B = null

	if(L)
		A = L.actor_active
		B = L.actor_passive
	else
		return

	if(controller.hidden_mode)
		if(A)
			A.send_private_message(text)

		if(B && B != A)
			B.send_private_message(text)

		return

	if(A)
		A.send_visible_message(text)
	else if(B)
		B.send_visible_message(text)

/// Wraps scene tick text with force/speed intensity spans.
/datum/erp_scene_messaging/proc/spanify_scene_text(text, force, speed, intensity = null)
	if(!text)
		return null

	var/level = clamp((force || 0) + (speed || 0), 1, 8)
	var/span_class = "love_mid"

	switch(level)
		if(1 to 2) span_class = "love_low"
		if(3 to 4) span_class = "love_mid"
		if(5 to 6) span_class = "love_high"
		if(7 to 8) span_class = "love_extreme"

	if(!isnull(intensity))
		var/i = clamp(round(intensity), 1, 5)
		switch(i)
			if(1) span_class = "love_low"
			if(2) span_class = "love_mid"
			if(3) span_class = "love_high"
			if(4 to 5) span_class = "love_extreme"
		text = "<b>[text]</b>"

	return "<span class='[span_class]'>[text]</span>"

/// Styles start/end messages.
/datum/erp_scene_messaging/proc/spanify_scene_start_end(text)
	if(!text)
		return null
	return "<span style='color:[ERP_SCENE_START_END_COLOR]; font-size:80%; font-weight:bold;'>[text]</span>"

/// Styles climax messages.
/datum/erp_scene_messaging/proc/spanify_scene_climax(text)
	if(!text)
		return null
	return "<span style='color:[ERP_SCENE_CLIMAX_COLOR]; font-size:105%; font-weight:bold; letter-spacing:0.2px;'>[text]</span>"

/// Sends link start message.
/datum/erp_scene_messaging/proc/send_link_start_message(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.action)
		return

	var/text = null
	if(SSerp?.action_message_renderer && L.action.message_start)
		text = SSerp.action_message_renderer.build_message(L.action.message_start, L)

	if(!text)
		text = "Начинается: [L.action.name]."

	send_message(spanify_scene_start_end(text), L)

/// Sends link finish message.
/datum/erp_scene_messaging/proc/send_link_finish_message(datum/erp_sex_link/L)
	if(!L || QDELETED(L) || !L.action)
		return

	var/text = null
	if(SSerp?.action_message_renderer && L.action.message_finish)
		text = SSerp.action_message_renderer.build_message(L.action.message_finish, L)

	if(!text)
		text = "Заканчивается: [L.action.name]."

	send_message(spanify_scene_start_end(text), L)
