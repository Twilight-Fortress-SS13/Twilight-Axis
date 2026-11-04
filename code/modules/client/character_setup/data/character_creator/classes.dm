/datum/preferences/proc/ui_data_character_creator_classes(mob/user)
	if(joblessrole != RETURNTOLOBBY && joblessrole != BERANDOMJOB) // this is to catch those that used the previous definition and reset.
		joblessrole = RETURNTOLOBBY

	var/donor_boost_visible = donor_job_boost_ckey_eligible(user.ckey, user.client)
	var/list/data = list(
		"joblessrole" = joblessrole,
		"classes" = list(),
		"donor_boost_visible" = donor_boost_visible,
		"donor_boost_available" = donor_boost_visible && donor_job_boost_available(src, user.ckey, user.client),
		"donor_boost_rounds_remaining" = donor_boost_visible ? donor_job_boost_rounds_remaining(src, user.ckey, user.client) : 0
	)

	// just in case, force SSjob to load
	SSjob.GetJob()

	var/list/classes_data = list()
	for(var/datum/job/job as anything in SSjob.occupations)
		if(!job.spawn_positions && !job.always_show_on_latechoices)
			continue

		UNTYPED_LIST_ADD(classes_data, ui_data_for_class(user, job))
	data["classes"] = classes_data

	return data

/// Turn info about datum/job/job into a list suitable for TGUI consumption
/datum/preferences/proc/ui_data_for_class(mob/user, datum/job/job)
	var/list/data = job.ui_data(user)

	data["unavailable"] = JOB_AVAILABLE
	data["unavailable_details"] = ""
	data["pref"] = job_preferences[job.title]
	data["donor_boost_job_eligible"] = donor_job_boost_ckey_eligible(user.ckey, user.client) && donor_job_boost_job_eligible(job, user.ckey, user.client)
	data["has_subclass_preferences"] = length(job.job_subclasses) || length(job.advclass_cat_rolls)
	data["has_job_subclasses"] = length(job.job_subclasses) ? TRUE : FALSE
	data["preferred_subclass"] = job_subclass_preferences[job.title]
	data["preferred_subclass_strict"] = job_subclass_strict[job.title] ? TRUE : FALSE
	data["character_slot"] = job_characters[job.title] ? job_characters[job.title] : null
	var/datum/preferences/character_prefs = get_job_prefs(job.title)
	if(!data["preferred_subclass"] && (job.has_subprefs || data["has_subclass_preferences"]))
		var/list/roleprefs = job.get_roleprefs(user.client)
		var/favorite_advclass = roleprefs?["favorite_advclass"]
		if(favorite_advclass)
			var/datum/advclass/favorite_type = favorite_advclass
			data["preferred_subclass"] = initial(favorite_type.name)

	if(is_banned_from(user.ckey, job.title))
		data["unavailable"] = JOB_UNAVAILABLE_BANNED
		return data
	var/required_playtime_remaining = job.required_playtime_remaining(user.client)
	if(required_playtime_remaining)
		data["unavailable"] = JOB_UNAVAILABLE_PLAYTIME
		data["unavailable_details"] = "\[ [get_exp_format(required_playtime_remaining)] as [job.get_exp_req_type()] \]"
		return data
	if(!job.player_old_enough(user.client))
		var/available_in_days = job.available_in_days(user.client)
		data["unavailable"] = JOB_UNAVAILABLE_ACCOUNTAGE
		data["unavailable_details"] = "\[IN [(available_in_days)] DAYS\]"
		return data
	#ifdef USES_PQ
	if(!isnull(job.min_pq) && (get_playerquality(user.ckey) < job.min_pq))
		data["unavailable"] = JOB_UNAVAILABLE_PQ
		data["unavailable_details"] = "(Min PQ: [job.min_pq])"
		return data
	#endif
	if(!isnull(job.max_pq) && (get_playerquality(user.ckey) > job.max_pq))
		data["unavailable"] = JOB_UNAVAILABLE_PQ
		data["unavailable_details"] = "(Max PQ: [job.max_pq])"
		return data
	if(length(job.virtue_restrictions) && length(job.vice_restrictions))
		var/list/restricted_list = list()
		if(character_prefs.virtue.type in job.virtue_restrictions)
			restricted_list.Add(character_prefs.virtue.name)
		if(character_prefs.virtuetwo?.type in job.virtue_restrictions)
			restricted_list.Add(character_prefs.virtuetwo.name)
		for(var/cf_type in character_prefs.charflaws)
			if(cf_type in job.vice_restrictions)
				var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_type]
				restricted_list.Add(cf.name)
		if(length(restricted_list))
			var/restrict_text = english_list(restricted_list)
			data["unavailable"] = JOB_UNAVAILABLE_VIRTUESVICE
			data["unavailable_details"] = "(Disallowed by Virtues / Vice: [restrict_text])"
			return data
	if(length(job.virtue_restrictions))
		var/list/restricted_list = list()
		if(character_prefs.virtue.type in job.virtue_restrictions)
			restricted_list.Add(character_prefs.virtue.name)
		if(character_prefs.virtuetwo?.type in job.virtue_restrictions)
			restricted_list.Add(character_prefs.virtuetwo.name)
		if(length(restricted_list))
			var/restrict_text = english_list(restricted_list)
			data["unavailable"] = JOB_UNAVAILABLE_VIRTUESVICE
			data["unavailable_details"] = "(Disallowed by Virtue: [restrict_text])"
			return data
	if(length(job.vice_restrictions))
		var/list/restricted_list = list()
		for(var/cf_type in character_prefs.charflaws)
			if(cf_type in job.vice_restrictions)
				var/datum/charflaw/cf = GLOB.character_flaws_singletons[cf_type]
				restricted_list.Add(cf.name)
		if(length(restricted_list))
			var/restrict_text = english_list(restricted_list)
			data["unavailable"] = JOB_UNAVAILABLE_VIRTUESVICE
			data["unavailable_details"] = "(Disallowed by Vice: [restrict_text])"
			return data
	if(!job.validate_prefs_for_job(character_prefs))
		data["unavailable"] = JOB_UNAVAILABLE_GENERIC
		data["unavailable_details"] = "(Selected character is ineligible)"
		return data
	if(job.prefs_all_subclasses_restricted(user.client))
		data["unavailable"] = JOB_UNAVAILABLE_VIRTUESVICE
		data["unavailable_details"] = "(Disallowed by Subclass Virtues/Vice)"
		return data
	var/job_unavailable = JOB_AVAILABLE
	if(isnewplayer(parent?.mob))
		var/mob/dead/new_player/new_player = parent.mob
		job_unavailable = new_player.IsJobUnavailable(job.title, latejoin = FALSE)
	var/static/list/acceptable_unavailables = list(
		JOB_AVAILABLE,
		JOB_UNAVAILABLE_SLOTFULL,
	)
	if(!(job_unavailable in acceptable_unavailables))
		data["unavailable"] = job_unavailable
		return data

	return data
