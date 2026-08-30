/datum/job/roguetown/bandit //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!
	title = "Bandit"
	flag = BANDIT
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE

	tutorial = "Desertation, desperation, rebelious desires, unmeetable quotas, outcast from society or driven to greed, it matters not. In the teachings of Matthios you found solace; liberate yourself from your misfortunes of your past by taking from others."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 25
	max_pq = null
	round_contrib_points = null

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_STEELHEARTED)//Bandits and knaves truly though
	vice_restrictions = list(/datum/charflaw/wanted)
	same_job_respawn_delay = 30 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	job_subclasses = list(
		/datum/advclass/brigand,
		/datum/advclass/hedgealchemist,
		/datum/advclass/hedgeknight,
		/datum/advclass/hedgemage,
		/datum/advclass/iconoclast,
		/datum/advclass/knave,
		/datum/advclass/sellsword,
		/datum/advclass/twilight_afreet
	)

/datum/job/roguetown/bandit/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/bandit/pre_equip(mob/living/carbon/human/H)
	. = ..()
	add_verb(H, /mob/proc/haltyell_exhausting)

/datum/outfit/job/roguetown/bandit/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "BANDIT"), 5 SECONDS)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input(H, "Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return

// Changed up proc from Wretch to suit bandits bit more
/proc/bandit_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs

	var/bounty_poster_key
	var/bounty_severity_key
	var/my_crime

	if(P?.preset_bounty_enabled)
		bounty_poster_key = P.preset_bounty_poster_key
		bounty_severity_key = P.preset_bounty_severity_b_key
		my_crime = P.preset_bounty_crime

	if(bounty_poster_key && !GLOB.bounty_posters[bounty_poster_key])
		bounty_poster_key = null

	if(bounty_severity_key && !GLOB.bandit_bounty_severities[bounty_severity_key])
		bounty_severity_key = null
	if(!bounty_poster_key)
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		var/choice = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in poster_choices
		bounty_poster_key = poster_choices[choice]

	if(!bounty_severity_key)
		var/list/sev_choices = list()
		for(var/key in GLOB.bandit_bounty_severities)
			sev_choices[GLOB.bandit_bounty_severities[key]["name"]] = key
		var/choice = input(H, "How notorious are you?", "Bounty Amount") as anything in sev_choices
		bounty_severity_key = sev_choices[choice]
	var/bounty_poster = GLOB.bounty_posters[bounty_poster_key]

	var/list/sev_data = GLOB.bandit_bounty_severities[bounty_severity_key]
	var/bounty_total = rand(sev_data["min"], sev_data["max"])

	if(!my_crime)
		my_crime = input(H, "What is your crime?", "Crime") as text|null
	if(!my_crime)
		my_crime = "Brigandry"

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()

	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)


/proc/update_bandits_slots(override_player_count = null) // TA EDIT
	//update_lost_grenzel_slots() // Lost Grenzel comment

	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job)
		return

	var/is_desert_town = SSmapping?.config?.map_name == "Desert Town"
	var/datum/job/slot_job = bandit_job
	var/antag_path = /datum/antagonist/bandit
	var/admin_slot_key = "Bandit"

	if(is_desert_town)
		bandit_job.always_show_on_latechoices = FALSE
		bandit_job.total_positions = 0
		bandit_job.spawn_positions = 0

		slot_job = SSjob.GetJob("Freeman")
		if(!slot_job)
			return

		antag_path = /datum/antagonist/bandit/freeman
		admin_slot_key = "Freeman"
		slot_job.always_show_on_latechoices = FALSE
		slot_job.total_positions = 0
		slot_job.spawn_positions = 0

	if(slot_job.admin_slot_override)
		return

	if(!SSgamemode)
		slot_job.total_positions = 0
		slot_job.spawn_positions = 0
		return

	var/player_count = isnull(override_player_count) ? SSgamemode.get_correct_popcount() : override_player_count // TA EDIT

	slot_job.always_show_on_latechoices = TRUE
	if(!SSgamemode.story_antag_open_slots(antag_path, player_count))
		slot_job.total_positions = 0
		slot_job.spawn_positions = 0
		return

	var/slots = 0
	var/admin_slot = !SSgamemode.allow_vote ? SSgamemode.admin_slots[admin_slot_key] : null
	if(!isnull(admin_slot))
		slots = max(0, admin_slot)
	else
		var/storyteller_type = SSgamemode.story_policy_type(TRUE)
		var/max_slots = SSgamemode.story_antag_slot_cap(antag_path, TRUE, storyteller_type)
		if(max_slots <= 0)
			slot_job.total_positions = 0
			slot_job.spawn_positions = 0
			return

		slots = 4 // TA EDIT START
		if(player_count > 40)
			if(storyteller_type == /datum/storyteller/gamemode/guaranteed_antag)
				slots += floor((player_count - 40) / 10)
			else
				slots += floor((player_count - 40) / 20)
		slots = min(slots, max_slots)
		if(SSticker.IsRoundInProgress())
			slots = min(slots, SSgamemode.combat_positions_alive) // TA EDIT END

	slots = SSgamemode.story_antag_slots(slots, antag_path, player_count)

	slot_job.total_positions = max(slot_job.current_positions, slots)
	slot_job.spawn_positions = max(slot_job.current_positions, slots)

/proc/resolve_roundstart_bandit_preferences(list/original_character_slots) // TA EDIT START
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job)
		return TRUE
	if(SSgamemode?.story_bandit_conflicts())
		var/reassign_bandits = FALSE
		for(var/mob/dead/new_player/player in GLOB.new_player_list)
			if(player.mind?.assigned_role != "Bandit")
				continue
			var/original_slot = original_character_slots ? original_character_slots[player.ckey] : null
			if(original_slot && player.client?.prefs && player.client.prefs.loaded_slot != original_slot)
				player.client.prefs.load_character(original_slot)
			SSrole_class_handler.clear_roundstart_subclass_state(player.ckey)
			if(player.mind in SSgamemode.roundstart_build_replacement_minds)
				continue
			reassign_bandits = TRUE
			player.mind.assigned_role = null
		bandit_job.current_positions = 0
		bandit_job.total_positions = 0
		bandit_job.spawn_positions = 0
		if(reassign_bandits)
			SSjob.unassigned.Cut()
			return SSjob.DivideOccupations(list())
		return TRUE
	update_bandits_slots()
	assign_roundstart_bandit_preferences()
	return TRUE // TA EDIT END

/proc/assign_roundstart_bandit_preferences() // TA EDIT START
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job || bandit_job.spawn_positions <= bandit_job.current_positions)
		return

	var/list/candidates = list()
	for(var/mob/dead/new_player/player in GLOB.new_player_list)
		if(player.ready != PLAYER_READY_TO_PLAY || !player.client || !player.client.prefs || !player.mind)
			continue
		if(player.mind.assigned_role == "Bandit")
			continue
		if(!(ROLE_BANDIT in player.client.prefs.be_special))
			continue
		if(is_banned_from(player.ckey, list(ROLE_SYNDICATE, ROLE_BANDIT)))
			continue
		if(QDELETED(player))
			continue
		if(!bandit_job.player_old_enough(player.client))
			continue
		if(bandit_job.required_playtime_remaining(player.client))
			continue
		var/datum/preferences/char_prefs = player.client.prefs.get_job_prefs("Bandit")
		if(!bandit_job.validate_prefs_for_job(char_prefs))
			continue
		if(bandit_job.prefs_all_subclasses_restricted(player.client))
			continue
		#ifdef USES_PQ
		if(!isnull(bandit_job.min_pq) && (get_playerquality(player.ckey) < bandit_job.min_pq))
			continue
		if(!isnull(bandit_job.max_pq) && (get_playerquality(player.ckey) > bandit_job.max_pq))
			continue
		#endif
		if(CONFIG_GET(flag/usewhitelist) && bandit_job.whitelist_req && !player.client.whitelisted())
			continue
		if(!bandit_job.special_job_check(player))
			continue
		candidates += player

	candidates = shuffle(candidates)
	for(var/mob/dead/new_player/player as anything in candidates)
		if(bandit_job.current_positions >= bandit_job.spawn_positions)
			break
		var/old_rank = player.mind.assigned_role
		if(SSjob.AssignRole(player, "Bandit"))
			continue
		if(SSjob.GetJob(old_rank))
			SSjob.AssignRole(player, old_rank) // TA EDIT END
