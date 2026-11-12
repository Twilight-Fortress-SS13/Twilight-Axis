/proc/donor_job_boost_prefs_banner(mob/user)
	if(!user?.ckey || !donor_job_boost_ckey_eligible(user.ckey, user.client))
		return ""
	var/datum/preferences/prefs = user.client?.prefs
	var/patreon_level = donor_job_boost_patreon_level(user.ckey, user.client)
	var/remaining = donor_job_boost_rounds_remaining(prefs, user.ckey, user.client)
	var/status = remaining ? "будет доступно через [remaining] раунд" : "доступно"
	var/cooldown_text = donor_job_boost_has_no_cooldown(patreon_level) ? "каждый раунд" : "раз в два раунда ([status])"
	var/job_limit_text = donor_job_boost_grants_any_job(patreon_level) ? "любая роль" : "только роли с несколькими слотами"
	return "<b>Меценат ([DONOR_JOB_BOOST_MIN_PATREON_LEVEL]+ ур.):</b> один класс с <font color='gold'>HIGH +</font> ([cooldown_text]), [job_limit_text].<br>"

/datum/preferences/proc/job_pref_display_data(datum/job/job, mob/user)
	var/list/result = list(
		"label" = "NEVER",
		"color" = "red",
		"upper" = JOB_PREF_UI_LOW,
		"lower" = JOB_PREF_UI_HIGH,
	)
	var/can_show_boost = donor_job_boost_ckey_eligible(user?.ckey, user?.client) && donor_job_boost_job_eligible(job, user?.ckey, user?.client)
	var/can_use_boost = can_show_boost && donor_job_boost_available(src, user?.ckey, user?.client)
	switch(job_preferences[job.title])
		if(JP_BOOST)
			if(can_use_boost)
				result["label"] = "HIGH +"
				result["color"] = "gold"
			else
				var/remaining = donor_job_boost_rounds_remaining(src, user?.ckey, user?.client)
				result["label"] = remaining ? "HIGH + ([remaining])" : "HIGH +"
				result["color"] = "gray"
			result["upper"] = JOB_PREF_UI_NEVER
			result["lower"] = JOB_PREF_UI_HIGH
			var/mob/dead/new_player/P = user
			if(istype(P))
				P.topjob = job.title
				topjob = job.title
		if(JP_HIGH)
			result["label"] = "High"
			result["color"] = "slateblue"
			if(can_use_boost)
				result["upper"] = JOB_PREF_UI_BOOST
			else
				result["upper"] = JOB_PREF_UI_NEVER
			result["lower"] = JOB_PREF_UI_MEDIUM
			var/mob/dead/new_player/P = user
			if(istype(P))
				P.topjob = job.title
				topjob = job.title
		if(JP_MEDIUM)
			result["label"] = "Medium"
			result["color"] = "green"
			result["upper"] = JOB_PREF_UI_HIGH
			result["lower"] = JOB_PREF_UI_LOW
		if(JP_LOW)
			result["label"] = "Low"
			result["color"] = "orange"
			result["upper"] = JOB_PREF_UI_MEDIUM
			result["lower"] = JOB_PREF_UI_NEVER
	return result

/datum/preferences/proc/desired_lvl_to_job_pref(desired_lvl, datum/job/job, mob/user)
	switch(desired_lvl)
		if(JOB_PREF_UI_LOW)
			return JP_LOW
		if(JOB_PREF_UI_MEDIUM)
			return JP_MEDIUM
		if(JOB_PREF_UI_HIGH)
			return JP_HIGH
		if(JOB_PREF_UI_BOOST)
			if(!donor_job_boost_ckey_eligible(user?.ckey, user?.client))
				to_chat(user, span_warning("HIGH + доступен меценатам от [DONOR_JOB_BOOST_MIN_PATREON_LEVEL]-го уровня и выше."))
				return null
			if(!donor_job_boost_job_eligible(job, user?.ckey, user?.client))
				to_chat(user, span_warning("HIGH + нельзя выбрать для ролей с одним слотом (доступно с [DONOR_JOB_BOOST_ANY_JOB_LEVEL]-го уровня)."))
				return null
			if(!donor_job_boost_available(src, user?.ckey, user?.client))
				var/remaining = donor_job_boost_rounds_remaining(src, user?.ckey, user?.client)
				to_chat(user, span_warning("HIGH + будет доступен через [remaining] раунд(ов) (с [DONOR_JOB_BOOST_NO_COOLDOWN_LEVEL]-го уровня — каждый раунд)."))
				return null
			return JP_BOOST
	return null

/datum/preferences/proc/clear_job_preference(datum/job/job)
	if(!job)
		return FALSE
	job_preferences -= job.title
	if(topjob == job.title)
		topjob = null
	return TRUE

/datum/preferences/proc/load_donor_job_boost_prefs(savefile/S)
	S["donor_priority_last_round_index"] >> donor_priority_last_round_index
	donor_priority_last_round_index = max(0, donor_priority_last_round_index)

/datum/preferences/proc/save_donor_job_boost_prefs(savefile/S)
	WRITE_FILE(S["donor_priority_last_round_index"], donor_priority_last_round_index)
