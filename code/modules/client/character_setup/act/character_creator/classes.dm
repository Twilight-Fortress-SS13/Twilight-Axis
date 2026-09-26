/datum/preferences/proc/ui_act_character_creator_classes(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("select_joblessrole")
			switch(joblessrole)
				if(RETURNTOLOBBY)
					joblessrole = BERANDOMJOB
				if(BERANDOMJOB)
					joblessrole = RETURNTOLOBBY
			verbose_pref_log_change(user, "notice", "If Role Unavailable", joblessrole == RETURNTOLOBBY ? "Get Random Job" : "Return To Lobby", joblessrole == BERANDOMJOB ? "Get Random Job" : "Return To Lobby")
			return CHARACTER_ACT_DATA_UPDATE
		if("set_job_preference")
			if(SSticker.job_change_locked)
				to_chat(user, span_warning("Try again later, SSticker is busy spawning players."))
				return CHARACTER_ACT_DATA_UPDATE

			var/title = params["job"]
			var/level = params["level"]

			if(level != null && level != JP_LOW && level != JP_MEDIUM && level != JP_HIGH && level != JP_BOOST)
				return CHARACTER_ACT_DATA_UPDATE

			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE

			if(level == JP_BOOST)
				if(!donor_job_boost_ckey_eligible(user.ckey, user.client))
					return CHARACTER_ACT_DATA_UPDATE
				if(!donor_job_boost_available(src, user.ckey, user.client))
					var/rounds_remaining = donor_job_boost_rounds_remaining(src, user.ckey, user.client)
					to_chat(user, span_warning("High+ is on cooldown for [rounds_remaining] more round[rounds_remaining == 1 ? "" : "s"]."))
					return CHARACTER_ACT_DATA_UPDATE
				if(!donor_job_boost_job_eligible(job, user.ckey, user.client))
					to_chat(user, span_warning("High+ cannot be used for [title]."))
					return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_notification(user, "notice", "[title] preference set to [level == JP_BOOST ? "High+" : level == JP_HIGH ? "High" : level == JP_MEDIUM ? "Medium" : level == JP_LOW ? "Low" : "Never"]")
			SetJobPreferenceLevel(job, level)
			return CHARACTER_ACT_DATA_UPDATE // note: change this if we ever readd job clothing preview
		if("set_job_slot")
			if(SSticker.job_change_locked)
				to_chat(user, span_warning("Try again later, SSticker is busy spawning players."))
				return CHARACTER_ACT_DATA_UPDATE

			var/job_title = params["job"]
			if(!istext(job_title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(job_title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE

			if(!path || !fexists(path))
				return CHARACTER_ACT_DATA_UPDATE

			var/list/valid_slots = list("Active Slot (Default)" = "default")
			var/default_choice = "Active Slot (Default)"
			var/current_slot = job_characters[job_title]
			var/savefile/S = new /savefile(path)
			var/datum/preferences/dummy_pref = new(parent)

			for(var/i = 1 to max_save_slots)
				if(i % 5 == 0)
					CHECK_TICK

				S.cd = "/character[i]"
				var/slot_name
				S["real_name"] >> slot_name
				if(!slot_name)
					continue

				dummy_pref.fast_scan_for_job(S, i)
				if(!job.validate_prefs_for_job(dummy_pref))
					continue

				var/slot_label = "Slot [i] - [dummy_pref.real_name] ([dummy_pref.pref_species.name])"
				valid_slots[slot_label] = i
				if(i == current_slot)
					default_choice = slot_label

			var/choice = tgui_input_list(user, "Choose character for [job_title]:", "Character Select", valid_slots, default_choice)
			if(!choice)
				return CHARACTER_ACT_DATA_UPDATE

			if(valid_slots[choice] == "default")
				job_characters -= job_title
			else
				job_characters[job_title] = valid_slots[choice]

			save_character()
			return CHARACTER_ACT_DATA_UPDATE
		if("set_job_subclass")
			if(SSticker.job_change_locked)
				to_chat(user, span_warning("Try again later, SSticker is busy spawning players."))
				return CHARACTER_ACT_DATA_UPDATE

			var/job_title = params["job"]
			if(!istext(job_title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(job_title)
			if(!job || !length(job.job_subclasses))
				return CHARACTER_ACT_DATA_UPDATE

			var/list/valid_subclasses = list("No subclass preference")
			var/datum/preferences/character_prefs = get_job_prefs(job_title)
			for(var/subclass_path in job.job_subclasses)
				var/datum/advclass/subclass_type = subclass_path
				var/datum/advclass/subclass = SSrole_class_handler.get_advclass_by_name(initial(subclass_type.name))
				if(!subclass)
					continue
				if(!subclass.check_preferences_requirements(character_prefs, user.client, FALSE, FALSE))
					continue
				valid_subclasses += subclass.name

			var/current_subclass = job_subclass_preferences[job_title]
			var/default_subclass = "No subclass preference"
			if(current_subclass && (current_subclass in valid_subclasses))
				default_subclass = current_subclass

			var/selected_subclass = tgui_input_list(user, "Choose a preferred subclass for [job_title]:", "Subclass Preference", valid_subclasses, default_subclass)
			if(!selected_subclass)
				return CHARACTER_ACT_DATA_UPDATE

			if(selected_subclass == "No subclass preference")
				job_subclass_preferences -= job_title
				job_subclass_strict -= job_title
			else
				var/list/failure_modes = list(
					"Try another role, otherwise return to lobby",
					"Let me choose another subclass"
				)
				var/default_failure_mode = job_subclass_strict[job_title] ? failure_modes[1] : failure_modes[2]
				var/failure_choice = tgui_input_list(user, "What should happen if [selected_subclass] is unavailable?", "Subclass Preference", failure_modes, default_failure_mode)
				if(!failure_choice)
					return CHARACTER_ACT_DATA_UPDATE
				job_subclass_preferences[job_title] = selected_subclass
				if(failure_choice == failure_modes[1])
					job_subclass_strict[job_title] = TRUE
				else
					job_subclass_strict -= job_title

			job.get_roleprefs(user.client)
			save_character()
			return CHARACTER_ACT_DATA_UPDATE
		if("subprefs")
			var/title = params["job"]
			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE
			if(!job.has_subprefs && !length(job.job_subclasses) && !length(job.advclass_cat_rolls))
				return CHARACTER_ACT_DATA_UPDATE

			job.update_subprefs_window(user)
			return CHARACTER_ACT_DATA_UPDATE
		if("explainjob")
			var/title = params["job"]
			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE

			job.show_explain(user)
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if(level == JP_BOOST)
		for(var/j in job_preferences)
			if(j != job.title && job_preferences[j] == JP_BOOST)
				job_preferences[j] = JP_MEDIUM
	else if(level == JP_HIGH)
		for(var/j in job_preferences)
			if(j != job.title && job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM

	job_preferences[job.title] = level
	topjob = null
	for(var/j in job_preferences)
		if(job_preferences[j] == JP_BOOST)
			topjob = j
			break
	if(!topjob)
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				topjob = j
				break
	if(isnewplayer(parent))
		var/mob/dead/new_player/N = parent
		N.topjob = topjob
	return TRUE

/datum/preferences/proc/ResetJobs()
	job_preferences = list()
	job_characters = list()
	topjob = null
