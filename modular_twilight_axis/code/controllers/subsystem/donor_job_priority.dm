GLOBAL_VAR_INIT(donor_job_boost_round_index, 0)
GLOBAL_VAR_INIT(donor_job_boost_round_index_loaded, FALSE)

/proc/donor_job_boost_load_round_index()
	if(GLOB.donor_job_boost_round_index_loaded)
		return

	GLOB.donor_job_boost_round_index_loaded = TRUE

	if(fexists(DONOR_JOB_BOOST_ROUND_INDEX_FILE))
		var/savefile/S = new /savefile(DONOR_JOB_BOOST_ROUND_INDEX_FILE)
		if(S)
			S["round_index"] >> GLOB.donor_job_boost_round_index

	GLOB.donor_job_boost_round_index = max(0, GLOB.donor_job_boost_round_index)

/proc/donor_job_boost_round_tick()
	donor_job_boost_load_round_index()

	GLOB.donor_job_boost_round_index++

	var/savefile/S = new /savefile(DONOR_JOB_BOOST_ROUND_INDEX_FILE)
	if(S)
		WRITE_FILE(S["round_index"], GLOB.donor_job_boost_round_index)

/proc/donor_job_boost_has_no_cooldown(patreon_level)
	return patreon_level >= DONOR_JOB_BOOST_NO_COOLDOWN_LEVEL

/proc/donor_job_boost_grants_any_job(patreon_level)
	return patreon_level >= DONOR_JOB_BOOST_ANY_JOB_LEVEL

/proc/donor_job_boost_rounds_remaining(datum/preferences/prefs, ckey = null, client/owner = null)
	donor_job_boost_load_round_index()

	if(donor_job_boost_has_no_cooldown(donor_job_boost_patreon_level(ckey, owner)))
		return 0

	if(!prefs)
		return DONOR_JOB_BOOST_COOLDOWN_ROUNDS

	if(!prefs.donor_priority_last_round_index)
		return 0

	if(GLOB.donor_job_boost_round_index < prefs.donor_priority_last_round_index)
		GLOB.donor_job_boost_round_index = prefs.donor_priority_last_round_index
		var/savefile/S = new /savefile(DONOR_JOB_BOOST_ROUND_INDEX_FILE)
		if(S)
			WRITE_FILE(S["round_index"], GLOB.donor_job_boost_round_index)

	var/rounds_since = GLOB.donor_job_boost_round_index - prefs.donor_priority_last_round_index
	return max((DONOR_JOB_BOOST_COOLDOWN_ROUNDS) - rounds_since, 0)

/proc/donor_job_boost_available(datum/preferences/prefs, ckey = null, client/owner = null)
	if(!prefs)
		return FALSE
	if(donor_job_boost_has_no_cooldown(donor_job_boost_patreon_level(ckey, owner)))
		return TRUE
	if(!prefs.donor_priority_last_round_index)
		return TRUE
	return donor_job_boost_rounds_remaining(prefs, ckey, owner) <= 0

/proc/donor_job_boost_patreon_level(ckey, client/owner = null)
	var/level = check_patreon_lvl(ckey)
	if(owner?.ckey == ckey)
		level = max(level, owner.patreonlevel())
	return level

/proc/donor_job_boost_ckey_eligible(ckey, client/owner = null)
	var/level = donor_job_boost_patreon_level(ckey, owner)
	return level >= DONOR_JOB_BOOST_MIN_PATREON_LEVEL

/proc/job_pref_shows_in_lobby(job_pref)
	return job_pref == JP_HIGH || job_pref == JP_BOOST

/proc/donor_job_boost_job_eligible(datum/job/job, ckey = null, client/owner = null)
	if(!job)
		return FALSE
	if(donor_job_boost_grants_any_job(donor_job_boost_patreon_level(ckey, owner)))
		return TRUE
	return job.spawn_positions > 1 || job.spawn_positions == -1

/datum/preferences/proc/get_donor_boost_job()
	for(var/job_title in job_preferences)
		if(job_preferences[job_title] == JP_BOOST)
			return SSjob.GetJob(job_title)
	return null

/datum/preferences/proc/sanitize_donor_job_boost(mob/user)
	var/ckey = user?.ckey
	if(!ckey || !donor_job_boost_ckey_eligible(ckey, user?.client))
		for(var/job_title in job_preferences)
			if(job_preferences[job_title] == JP_BOOST)
				job_preferences[job_title] = JP_HIGH
		return
	var/datum/job/boost_job = get_donor_boost_job()
	if(boost_job && !donor_job_boost_job_eligible(boost_job, ckey, user?.client))
		job_preferences[boost_job.title] = JP_HIGH

/datum/controller/subsystem/job/proc/donor_boost_clear_slot_for_lord(datum/job/job, mob/dead/new_player/claimer)
	if(!job || job.spawn_positions != 1)
		return TRUE
	if(job.current_positions < 1)
		return TRUE
	for(var/mob/dead/new_player/incumbent in GLOB.new_player_list)
		if(incumbent == claimer || QDELETED(incumbent))
			continue
		if(incumbent.mind?.assigned_role != job.title)
			continue
		var/datum/job/old_job = GetJob(incumbent.mind.assigned_role)
		if(old_job)
			old_job.current_positions = max(old_job.current_positions - 1, 0)
		incumbent.mind.assigned_role = null
		unassigned |= incumbent
		JobDebug("Donor boost (Lord) bumped [incumbent] from [job.title] for [claimer]")
		return TRUE
	return FALSE

/datum/controller/subsystem/job/proc/player_eligible_for_job(mob/dead/new_player/player, datum/job/job, latejoin = FALSE)
	if(!player || !job || QDELETED(player))
		return FALSE
	if(is_banned_from(player.ckey, job.title))
		return FALSE
	if(!job.player_old_enough(player.client))
		return FALSE
	if(job.required_playtime_remaining(player.client))
		return FALSE
	if(player.mind && (job.title in player.mind.restricted_roles))
		return FALSE
	if(length(job.forbidden_races) && (player.client.prefs.pref_species.type in job.forbidden_races))
		return FALSE
	var/datum/preferences/char_prefs = player.client.prefs.get_job_prefs(job.title)
	if(!job.validate_prefs_for_job(char_prefs))
		return FALSE
	if(length(job.allowed_patrons) && !(player.client.prefs.selected_patron?.type in job.allowed_patrons))
		return FALSE
	if(length(job.virtue_restrictions) && ((player.client.prefs.virtue?.type in job.virtue_restrictions) || (player.client.prefs.virtuetwo?.type in job.virtue_restrictions) || (player.client.prefs.virtue_origin?.type in job.virtue_restrictions)))
		return FALSE
	if(length(job.vice_restrictions))
		for(var/datum/charflaw/cf in player.client.prefs.charflaws)
			if(cf.type in job.vice_restrictions)
				return FALSE
	#ifdef USES_PQ
	if(!isnull(job.min_pq) && (get_playerquality(player.ckey) < job.min_pq))
		return FALSE
	if(!isnull(job.max_pq) && (get_playerquality(player.ckey) > job.max_pq))
		return FALSE
	#endif
	if((player.client.prefs.lastclass == job.title) && !job.bypass_lastclass)
		return FALSE
	if(check_blacklist(player.client.ckey) && !job.bypass_jobban)
		return FALSE
	if(CONFIG_GET(flag/usewhitelist) && job.whitelist_req && !player.client.whitelisted())
		return FALSE
	if(!job.special_job_check(player))
		return FALSE
	if(job.plevel_req > player.client.patreonlevel())
		return FALSE
	if(!latejoin && (job.current_positions >= job.spawn_positions) && job.spawn_positions != -1)
		return FALSE
	return TRUE

/datum/controller/subsystem/job/proc/player_eligible_for_donor_boost(mob/dead/new_player/player, datum/job/job)
	var/patreon_level = donor_job_boost_patreon_level(player.ckey, player.client)
	if(donor_job_boost_grants_any_job(patreon_level) && job.spawn_positions == 1 && job.current_positions >= job.spawn_positions)
		if(!donor_boost_clear_slot_for_lord(job, player))
			return FALSE
	return player_eligible_for_job(player, job)

/datum/controller/subsystem/job/proc/mark_donor_job_boost_used(mob/dead/new_player/player)
	if(!player?.client?.prefs)
		return
	if(donor_job_boost_has_no_cooldown(donor_job_boost_patreon_level(player.ckey, player.client)))
		return
	player.client.prefs.donor_priority_last_round_index = GLOB.donor_job_boost_round_index
	player.client.prefs.save_preferences()


/datum/controller/subsystem/job/proc/FinalizeDonorJobBoostCooldowns()
	for(var/mob/dead/new_player/player as anything in GLOB.donor_job_boost_pending_cooldowns)
		if(!player?.client?.prefs || !player.mind)
			continue

		var/datum/job/boost_job = player.client.prefs.get_donor_boost_job()
		if(!boost_job)
			continue

		if(player.client.prefs.job_preferences[boost_job.title] != JP_BOOST)
			continue

		if(player.mind.assigned_role != boost_job.title)
			continue

		mark_donor_job_boost_used(player)

	GLOB.donor_job_boost_pending_cooldowns.Cut()


/datum/controller/subsystem/job/proc/AssignDonorPriorityJobs()
	var/assigned = 0
	GLOB.donor_job_boost_pending_cooldowns.Cut()

	var/list/candidates = shuffle(unassigned.Copy())

	for(var/mob/dead/new_player/player as anything in candidates)
		if(QDELETED(player) || !player.client?.prefs)
			continue

		if(!donor_job_boost_ckey_eligible(player.ckey, player.client))
			continue

		if(!donor_job_boost_available(player.client.prefs, player.ckey, player.client))
			continue

		var/datum/job/job = player.client.prefs.get_donor_boost_job()
		if(!job)
			continue

		if(!donor_job_boost_job_eligible(job, player.ckey, player.client))
			continue

		if(player.client.prefs.job_preferences[job.title] != JP_BOOST)
			continue

		if(!player_eligible_for_donor_boost(player, job))
			continue

		if(AssignRole(player, job.title))
			unassigned -= player
			GLOB.donor_job_boost_pending_cooldowns |= player
			assigned++
			JobDebug("Donor boost assigned [player] to [job.title]")

	return assigned
