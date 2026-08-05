/datum/character_setup_jobs_panel
	parent_type = /datum/character_setup_panel
	var/datum/character_setup_panel/owner_panel
	var/list/active_job_detail = null
	var/processing_owner_action = FALSE

/datum/character_setup_jobs_panel/New(datum/preferences/prefs_owner, datum/character_setup_panel/owner)
	owner_panel = owner
	return ..(prefs_owner)

/datum/character_setup_jobs_panel/ui_interact(mob/user, datum/tgui/ui)
	last_user = user
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CharacterSetupJobs")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/character_setup_jobs_panel/ui_data(mob/user)
	return build_jobs_ui_data(user, TRUE)

/datum/character_setup_jobs_panel/proc/main_ui_data(mob/user)
	return build_jobs_ui_data(user, FALSE)

/datum/character_setup_jobs_panel/proc/build_jobs_ui_data(mob/user, include_full_entries)
	if(!prefs || !user)
		return list()
	var/player_quality = null
	#ifdef USES_PQ
	player_quality = get_playerquality(user.ckey)
	#endif
	var/list/data = list(
		"job_slot_target" = active_job_slot_title,
		"job_slot_choices" = active_job_slot_title ? (owner_panel ? owner_panel.build_job_slot_choices(active_job_slot_title) : build_job_slot_choices(active_job_slot_title)) : list(),
		"current_joblessrole" = "[prefs.joblessrole]",
		"active_job_detail" = active_job_detail,
		"use_female_job_titles" = (prefs.titles_pref == TITLES_F),
		"job_player_quality" = player_quality,
	)
	if(include_full_entries)
		data["job_entries"] = prefs.character_setup_job_entries(user)
	else
		data["job_state"] = prefs.character_setup_job_state(user)
		if(owner_panel && !owner_panel.job_catalog_in_static_data)
			data["job_entries"] = prefs.character_setup_job_entries(user)
	return data

/datum/character_setup_jobs_panel/proc/push_both_updates()
	if(processing_owner_action)
		SStgui.update_uis(src)
	else if(owner_panel)
		SStgui.update_uis(owner_panel)

/datum/preferences/proc/character_setup_job_catalog(mob/user)
	var/list/output = list()
	if(!SSjob?.initialized || !length(SSjob.occupations) || !user?.client)
		return output

	var/static/list/split_jobs = list("Court Magician", "Bishop", "Merchant", "Guildmaster", "Archivist", "Towner", "Grenzelhoft Mercenary", "Beggar", "Prisoner", "Goblin King")
	for(var/datum/job/job in sortList(SSjob.occupations, GLOBAL_PROC_REF(cmp_job_display_asc)))
		if(!job.spawn_positions && !job.always_show_on_latechoices)
			continue

		var/rank = job.title
		var/default_name = job.display_title ? job.display_title : job.title
		var/female_name = job.f_title ? job.f_title : default_name
		var/min_pq = null
		var/max_pq = null
		#ifdef USES_PQ
		min_pq = job.min_pq
		max_pq = job.max_pq
		#endif
		var/list/tooltip_parts = list()
		if(job.tutorial)
			tooltip_parts += "[job.tutorial]"
		tooltip_parts += "Слоты: [job.spawn_positions]"
		if(job.round_contrib_points)
			tooltip_parts += "RCP: +[job.round_contrib_points]"

		output += list(list(
			id = rank,
			name = "[default_name]",
			female_name = "[female_name]",
			tutorial = job.tutorial,
			slots = job.spawn_positions,
			round_contrib_points = job.round_contrib_points,
			min_pq = min_pq,
			max_pq = max_pq,
			has_details = !!job.class_setup_examine,
			tooltip = jointext(tooltip_parts, "\n"),
			has_subclasses = !!length(job.job_subclasses),
			separator_before = (rank in split_jobs)
		))
	return output

/datum/preferences/proc/character_setup_job_state(mob/user)
	var/list/output = list()
	if(!SSjob?.initialized || !length(SSjob.occupations) || !user?.client)
		return output

	var/static/list/acceptable_unavailables = list(JOB_AVAILABLE, JOB_UNAVAILABLE_SLOTFULL)
	var/player_quality = null
	#ifdef USES_PQ
	player_quality = get_playerquality(user.ckey)
	#endif

	for(var/datum/job/job in SSjob.occupations)
		if(!job.spawn_positions && !job.always_show_on_latechoices)
			continue

		var/rank = job.title
		var/disabled_reason = null
		var/priority_disabled_reason = null
		if(is_banned_from(user.ckey, rank))
			disabled_reason = "Забанено"
		else
			var/required_playtime_remaining = job.required_playtime_remaining(user.client)
			if(required_playtime_remaining)
				disabled_reason = "[get_exp_format(required_playtime_remaining)] как [job.get_exp_req_type()]"
			else if(!job.player_old_enough(user.client))
				var/available_in_days = job.available_in_days(user.client)
				disabled_reason = "Доступно через [available_in_days] дн."
			else
				#ifdef USES_PQ
				if(!isnull(job.min_pq) && !isnull(player_quality) && (player_quality < job.min_pq))
					disabled_reason = "Мин. PQ: [job.min_pq]"
				else if(!isnull(job.max_pq) && !isnull(player_quality) && (player_quality > job.max_pq))
					disabled_reason = "Макс. PQ: [job.max_pq]"
				#endif
				if(!disabled_reason)
					var/datum/preferences/char_prefs = get_job_prefs(rank)
					if(!job.validate_prefs_for_job(char_prefs))
						priority_disabled_reason = "Недоступно"
					else
						var/job_unavailable_status = JOB_AVAILABLE
						if(isnewplayer(user))
							var/mob/dead/new_player/new_player = user
							job_unavailable_status = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
						if(!(job_unavailable_status in acceptable_unavailables))
							priority_disabled_reason = "Недоступно"

		var/current_pref = "never"
		switch(job_preferences[rank])
			if(JP_BOOST)
				current_pref = "boost"
			if(JP_HIGH)
				current_pref = "high"
			if(JP_MEDIUM)
				current_pref = "medium"
			if(JP_LOW)
				current_pref = "low"

		var/list/pref_ui = job_pref_display_data(job, user)
		output += list(list(
			id = rank,
			current_pref = current_pref,
			next_pref_level = pref_ui ? pref_ui["upper"] : null,
			previous_pref_level = pref_ui ? pref_ui["lower"] : null,
			disabled_reason = disabled_reason,
			priority_disabled_reason = priority_disabled_reason,
			assigned_slot = job_characters[rank] ? "Слот [job_characters[rank]]" : "Активный слот",
			subclass_preference = job_subclass_preferences[rank],
			subclass_strict = !!job_subclass_strict[rank]
		))
	return output

/datum/preferences/proc/character_setup_job_entries(mob/user)
	var/list/catalog = character_setup_job_catalog(user)
	var/list/state_by_id = list()
	for(var/list/state_entry as anything in character_setup_job_state(user))
		state_by_id[state_entry["id"]] = state_entry

	var/list/output = list()
	for(var/list/catalog_entry as anything in catalog)
		var/list/entry = catalog_entry.Copy()
		var/list/state_entry = state_by_id[entry["id"]]
		if(state_entry)
			for(var/key in state_entry)
				entry[key] = state_entry[key]
		output += list(entry)
	return output

/datum/character_setup_jobs_panel/proc/sanitize_job_panel_text(value)
	if(isnull(value))
		return null
	var/original_text = "[value]"
	if(!length(original_text))
		return original_text

	var/static/list/job_panel_text_cache = list()
	if(original_text in job_panel_text_cache)
		return job_panel_text_cache[original_text]

	var/text = original_text
	if(findtext(text, "<") || findtext(text, "&nbsp;") || findtext(text, ascii2text(13)) || findtext(text, "\n\n\n"))
		text = replacetext(text, "<br>", "\n")
		text = replacetext(text, "<br/>", "\n")
		text = replacetext(text, "<br />", "\n")
		text = replacetext(text, "&nbsp;", " ")

		if(findtext(text, "<"))
			text = strip_simple_html_tags(text)

		if(findtext(text, ascii2text(13)))
			text = replacetext(text, ascii2text(13), "")
		while(findtext(text, "\n\n\n"))
			text = replacetext(text, "\n\n\n", "\n\n")

	if(length(job_panel_text_cache) > 2048)
		job_panel_text_cache = list()
	job_panel_text_cache[original_text] = text
	return text

/datum/character_setup_jobs_panel/proc/strip_simple_html_tags(text)
	if(isnull(text))
		return text
	var/result = "[text]"
	var/start = findtext(result, "<")
	while(start)
		var/end = findtext(result, ">", start + 1)
		if(!end)
			break
		result = copytext(result, 1, start) + copytext(result, end + 1)
		start = findtext(result, "<")
	return result

/datum/character_setup_jobs_panel/proc/build_stat_rows(list/source)
	var/list/rows = list()
	if(!islist(source))
		return rows
	for(var/stat in source)
		var/value = source[stat]
		rows += list(list(
			"name" = capitalize("[stat]"),
			"value" = "\Roman[value]",
			"positive" = (isnum(value) ? (value >= 0) : null),
		))
	return rows

/datum/character_setup_jobs_panel/proc/build_trait_rows(list/source)
	var/list/rows = list()
	if(!islist(source))
		return rows
	for(var/trait in source)
		rows += list(list(
			"name" = "[trait]",
			"description" = sanitize_job_panel_text(GLOB.roguetraits[trait]),
		))
	return rows

/datum/character_setup_jobs_panel/proc/build_string_rows(list/source)
	var/list/rows = list()
	if(!islist(source))
		return rows
	for(var/item in source)
		rows += sanitize_job_panel_text(item)
	return rows

/datum/character_setup_jobs_panel/proc/build_skill_rows(list/source)
	var/list/rows = list()
	if(!islist(source))
		return rows
	var/list/notable_skills = list()
	for(var/sk in source)
		if(source[sk] >= SKILL_LEVEL_JOURNEYMAN)
			notable_skills[sk] = source[sk]
		else if(ispath(sk, /datum/skill/combat))
			notable_skills[sk] = source[sk]
	if(!length(notable_skills))
		return rows
	notable_skills = sortTim(notable_skills, /proc/cmp_numeric_dsc, TRUE)
	var/max_skills = 5
	for(var/sk in notable_skills)
		if(max_skills <= 0)
			break
		var/datum/skill/skill = sk
		var/skill_name = sanitize_job_panel_text(initial(skill.name))
		var/skill_level = sanitize_job_panel_text(SSskills.level_names[notable_skills[sk]])
		rows += "[skill_name] — [skill_level]"
		max_skills--
	return rows

/datum/character_setup_jobs_panel/proc/build_mage_aspect_rows(list/aspect_cfg)
	var/list/rows = list()
	if(!islist(aspect_cfg) || !LAZYLEN(aspect_cfg))
		return rows
	if(aspect_cfg["mastery"])
		rows += sanitize_job_panel_text("Mastery: Unlocked")
	if(aspect_cfg["major"] > 0)
		rows += sanitize_job_panel_text("Major Aspects: [aspect_cfg["major"]]")
	if(aspect_cfg["minor"] > 0)
		rows += sanitize_job_panel_text("Minor Aspects: [aspect_cfg["minor"]]")
	if(aspect_cfg["utilities"] > 0)
		rows += sanitize_job_panel_text("Utility Slots: [aspect_cfg["utilities"]]")
	if(LAZYLEN(aspect_cfg["locked_aspects"]))
		var/list/locked_names = list()
		var/list/locked = aspect_cfg["locked_aspects"]
		for(var/aspect_path in locked)
			var/datum/magic_aspect/A = aspect_path
			locked_names += "[initial(A.name)]"
		rows += sanitize_job_panel_text("Innate: [jointext(locked_names, ", ")]")
	if(islist(aspect_cfg["variants"]))
		var/list/overrides = aspect_cfg["variants"]
		for(var/aspect_path in overrides)
			var/datum/magic_aspect/A = aspect_path
			rows += sanitize_job_panel_text("Tradition: [capitalize(overrides[aspect_path])] [initial(A.name)]")
	return rows

/datum/character_setup_jobs_panel/proc/build_language_rows(list/source)
	var/list/rows = list()
	if(!islist(source))
		return rows
	for(var/lang_path in source)
		var/datum/language/lang = lang_path
		rows += sanitize_job_panel_text(initial(lang.name))
	return rows

/datum/character_setup_jobs_panel/proc/build_subclass_payload(datum/advclass/adv_ref)
	if(!adv_ref)
		return null

	var/list/subclass = list(
		"id" = "[initial(adv_ref.name)]",
		"name" = "[adv_ref.name]",
		"description" = adv_ref.tutorial ? sanitize_job_panel_text(adv_ref.tutorial) : null,
		"stat_bonuses" = build_stat_rows(adv_ref.subclass_stats),
		"stat_limits" = build_stat_rows(adv_ref.adv_stat_ceiling),
		"traits" = build_trait_rows(adv_ref.traits_applied),
		"notable_skills" = build_skill_rows(adv_ref.subclass_skills),
		"virtues" = list(),
		"stashed_items" = build_string_rows(adv_ref.subclass_stashed_items),
		"languages" = build_language_rows(adv_ref.subclass_languages),
		"mage_aspects" = build_mage_aspect_rows(adv_ref.subclass_mage_aspects),
		"extra_context" = list(),
	)

	if(length(adv_ref.subclass_virtues))
		var/list/virtues = list()
		for(var/virtue_type in adv_ref.subclass_virtues)
			var/datum/virtue/virtue = virtue_type
			virtues += "[initial(virtue.name)]"
		subclass["virtues"] = virtues

	var/list/extra = list()
	if(adv_ref.extra_context)
		extra += sanitize_job_panel_text(adv_ref.extra_context)
	if(istype(adv_ref.age_mod))
		extra += "[adv_ref.age_mod.get_preview_string()]"
	subclass["extra_context"] = extra

	return subclass

/datum/character_setup_jobs_panel/proc/build_job_detail_payload(datum/job/job)
	if(!job)
		return null

	var/list/detail = list(
		"title" = job.display_title ? "[job.display_title]" : "[job.title]",
		"description" = job.tutorial ? sanitize_job_panel_text(job.tutorial) : null,
		"class_stats" = build_stat_rows(job.job_stats),
		"class_stat_limits" = build_stat_rows(job.stat_ceilings),
		"class_traits" = build_trait_rows(job.job_traits),
		"subclasses" = list(),
		"note" = sanitize_job_panel_text("This information is not all-encompassing. Many classes have other quirks and skills that define them."),
	)

	if((prefs?.titles_pref == TITLES_F) && job.f_title)
		detail["title"] = "[job.f_title]"

	if(length(job.job_subclasses))
		var/list/subclasses = list()
		for(var/sclass in job.job_subclasses)
			var/datum/advclass/adv = sclass
			var/datum/advclass/adv_ref = SSrole_class_handler.get_advclass_by_name(initial(adv.name))
			if(!adv_ref)
				continue
			var/list/subclass_payload = build_subclass_payload(adv_ref)
			if(subclass_payload)
				subclasses += list(subclass_payload)
		detail["subclasses"] = subclasses

	if(istype(job, /datum/job/roguetown/jester))
		detail["description"] = "Come one, come all, where Psydon Lies!\nLet Xylix roll the dice,\nunto our untimely demise! Ahahaha!"
		detail["class_stats"] = list(
			list("name" = "STR", "value" = "???"),
			list("name" = "WIL", "value" = "???"),
			list("name" = "CON", "value" = "???"),
			list("name" = "PER", "value" = "???"),
			list("name" = "INT", "value" = "???"),
			list("name" = "FOR", "value" = "???"),
		)
		detail["class_stat_limits"] = list()
		detail["class_traits"] = list()
		detail["subclasses"] = list()
		detail["note"] = null

	return detail

/datum/character_setup_jobs_panel/proc/set_active_job_details(datum/job/job)
	if(!job || !job.class_setup_examine)
		active_job_detail = null
		return
	active_job_detail = build_job_detail_payload(job)

/datum/character_setup_jobs_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/was_processing_tgui_action = owner_panel?.processing_tgui_action
	if(owner_panel)
		owner_panel.processing_tgui_action = TRUE
	. = ..()
	if(owner_panel)
		owner_panel.processing_tgui_action = was_processing_tgui_action

/datum/character_setup_jobs_panel/handle_ui_action(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(!prefs)
		return FALSE
	var/mob/user = ui ? ui.user : last_user

	switch(action)
		if("link")
			var/list/href_list = list()
			for(var/key in params)
				href_list[key] = "[params[key]]"
			if(user?.client)
				prefs.process_link(user, href_list)
				push_both_updates()
			return TRUE

		if("open_job_slot")
			active_job_slot_title = params["job"]
			push_both_updates()
			return TRUE

		if("assign_job_slot")
			if(active_job_slot_title)
				var/slot = params["slot"]
				if(slot == "default")
					prefs.job_characters -= active_job_slot_title
				else
					prefs.job_characters[active_job_slot_title] = text2num(slot)
				active_job_slot_title = null
				prefs.save_preferences()
				push_both_updates()
			return TRUE

		if("open_job_details")
			var/job_title = params["job"]
			var/datum/job/job = SSjob ? SSjob.GetJob(job_title) : null
			if(job)
				set_active_job_details(job)
				push_both_updates()
			return TRUE

		if("close_job_details")
			active_job_detail = null
			push_both_updates()
			return TRUE

	return FALSE
