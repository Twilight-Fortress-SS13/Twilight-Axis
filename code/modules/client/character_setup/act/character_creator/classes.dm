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
	topjob = null
