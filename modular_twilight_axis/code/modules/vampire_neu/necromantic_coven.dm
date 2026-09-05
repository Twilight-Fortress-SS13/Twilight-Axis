#define ROLE_VAMPIRE_UNDEAD "Vampire Undead"
#define POLL_IGNORE_VAMPIRE_UNDEAD "vampire_undead"
#define TA_NECROMANTIC_MAX_UNDEAD 1

/datum/coven/necromantic
	name = "Necromantic"
	desc = "Speak with the dead, summon undead spirits, and manipulate life force itself."
	icon_state = "daimonion"
	clan_restricted = FALSE
	power_type = /datum/coven_power/necromantic
	max_level = 4

/datum/coven_power/necromantic
	name = "Necromantic power name"
	desc = "Necromantic power description"

/datum/coven_power/necromantic/proc/ta_refund_failed_use()
	if(owner && cost_system == COVEN_COST_VITAE)
		owner.adjust_bloodpool(vitae_cost)
	return FALSE

/datum/coven_power/necromantic/speak_with_dead
	name = "Speak with the Dead"
	desc = "Ask a question of the dead and hear what they choose to answer."

	level = 1
	research_cost = 0
	target_type = TARGET_MOB
	range = 1
	cooldown_length = 2 MINUTES
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/speak_with_dead/pre_activation_checks(atom/target)
	. = ..()
	if(!.)
		return FALSE

	var/mob/dead_target = target
	if(!ismob(dead_target) || dead_target.stat != DEAD)
		to_chat(owner, span_warning("Your target is not dead."))
		return ta_refund_failed_use()

	var/input_message = tgui_input_text(owner, "What do you wish to ask of the dead?", "Speak with the Dead")
	if(!input_message)
		return ta_refund_failed_use()

	var/mob/player_mob = dead_target
	if(!dead_target.client)
		var/mob/ghost_mob = dead_target.get_ghost(TRUE, TRUE)
		if(ghost_mob?.client)
			player_mob = ghost_mob

	if(!player_mob.client)
		to_chat(owner, span_warning("Necra's grasp on this one is too strong, not even your blood magic can reach them."))
		return ta_refund_failed_use()

	var/dead_message = tgui_input_text(player_mob, "The vampyre [owner.real_name] asks of you: [input_message]. You are not compelled in any way. What is your response?", "Speak with the Dead", timeout = 2 MINUTES)
	if(!dead_message)
		to_chat(owner, span_notice("The dead remain silent."))
		return ta_refund_failed_use()

	var/audible_message = "The raspy voice of [dead_target] echoes, \"<i>[capitalize(dead_message)]</i>\"."
	owner.audible_message(audible_message, runechat_message = dead_message, custom_spans = list("mindlink", "italic"))
	return TRUE

/datum/coven_power/necromantic/raise_spirits
	name = "Raise Spirits"
	desc = "Summon two vengeful spirits and set them upon your target."

	level = 2
	research_cost = 1
	target_type = TARGET_LIVING
	range = 7
	cooldown_length = 90 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/raise_spirits/pre_activation_checks(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(!isliving(target))
		to_chat(owner, span_warning("You must target a living creature to direct your spirits towards."))
		return ta_refund_failed_use()

	var/list/haunts = list()
	if(owner.dir == SOUTH || owner.dir == NORTH)
		haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_turf(owner), owner)
		if(prob(50))
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(owner, EAST), owner)
		else
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(owner, WEST), owner)
	else
		haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_turf(owner), owner)
		if(prob(50))
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(owner, NORTH), owner)
		else
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(owner, SOUTH), owner)

	for(var/mob/living/simple_animal/hostile/rogue/haunt/omen/swarm in haunts)
		swarm.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	owner.say("Awaken, my spirits!")
	return TRUE

/datum/coven_power/necromantic/raise_unholy_undead
	name = "Raise Unholy Undead"
	desc = "Raise a single revenant that serves you. They are imbued with a fragment of a soul and are more intelligent than simple-minded lesser undead."

	level = 3
	research_cost = 2
	target_type = TARGET_TURF | TARGET_LIVING | TARGET_MOB
	range = 7
	cooldown_length = 60 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	var/list/summoned_undead = list()

/datum/coven_power/necromantic/raise_unholy_undead/Destroy()
	for(var/mob/living/undead as anything in summoned_undead)
		UnregisterSignal(undead, list(COMSIG_MOB_DEATH, COMSIG_QDELETING))
	summoned_undead = null
	return ..()

/datum/coven_power/necromantic/raise_unholy_undead/proc/ta_forget_undead(mob/living/undead)
	if(!undead)
		return
	UnregisterSignal(undead, list(COMSIG_MOB_DEATH, COMSIG_QDELETING))
	LAZYREMOVE(summoned_undead, undead)

/datum/coven_power/necromantic/raise_unholy_undead/proc/ta_on_undead_lost(mob/living/undead)
	SIGNAL_HANDLER
	ta_forget_undead(undead)

/datum/coven_power/necromantic/raise_unholy_undead/proc/ta_track_undead(mob/living/undead)
	if(!undead)
		return
	LAZYOR(summoned_undead, undead)
	RegisterSignal(undead, COMSIG_MOB_DEATH, PROC_REF(ta_on_undead_lost))
	RegisterSignal(undead, COMSIG_QDELETING, PROC_REF(ta_on_undead_lost))

/datum/coven_power/necromantic/raise_unholy_undead/proc/ta_living_undead_count()
	var/count = 0
	for(var/mob/living/undead as anything in summoned_undead?.Copy())
		if(QDELETED(undead) || undead.stat == DEAD)
			ta_forget_undead(undead)
			continue
		count++
	return count

/datum/coven_power/necromantic/raise_unholy_undead/pre_activation_checks(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(ta_living_undead_count() >= TA_NECROMANTIC_MAX_UNDEAD)
		to_chat(owner, span_warning("My revenant already walks these lands. My blood cannot hold another."))
		return ta_refund_failed_use()

	var/turf/landing = get_turf(target)
	if(!isopenturf(landing))
		to_chat(owner, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return ta_refund_failed_use()

	var/list/candidates = pollGhostCandidates("Do you want to play as a Vampyre's chosen undead?", ROLE_VAMPIRE_UNDEAD, null, null, 10 SECONDS, POLL_IGNORE_VAMPIRE_UNDEAD)
	if(!LAZYLEN(candidates))
		to_chat(owner, span_warning("The depths are hollow."))
		return TRUE

	var/mob/candidate = pick(candidates)
	if(!candidate || !istype(candidate, /mob/dead))
		return ta_refund_failed_use()

	if(istype(candidate, /mob/dead/new_player))
		var/mob/dead/new_player/new_candidate = candidate
		new_candidate.close_spawn_windows()

	var/mob/living/carbon/human/species/dullahan/revenant = new /mob/living/carbon/human/species/dullahan(landing)
	revenant.key = candidate.key
	SSjob.EquipRank(revenant, "Fortified Skeleton", TRUE)
	revenant.copy_known_languages_from(owner, TRUE)
	revenant.visible_message(span_warning("[revenant]'s eyes light up with an eerie glow!"))
	ta_track_undead(revenant)
	addtimer(CALLBACK(revenant, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "UNHOLY UNDEAD"), 3 SECONDS)
	addtimer(CALLBACK(revenant, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	return TRUE

/datum/coven_power/necromantic/harvest_lux
	name = "Harvest Lux"
	desc = "Reach out and siphon the lux from any non-undead surrounding you."

	level = 4
	research_cost = 3
	cooldown_length = 60 SECONDS
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING
	var/harvest_range = 3

/datum/coven_power/necromantic/harvest_lux/pre_activation_checks(atom/target)
	. = ..()
	if(!.)
		return FALSE

	var/targets_hit = 0
	for(var/mob/living/carbon/human/victim in view(harvest_range, owner))
		if(victim == owner)
			continue
		if(victim.mind?.has_antag_datum(/datum/antagonist/vampire))
			continue
		if((FACTION_UNDEAD in victim.faction) || (FACTION_DUNDEAD in victim.faction) || (FACTION_ZOMBIE in victim.faction) || (FACTION_SKELETON in victim.faction))
			continue
		if(victim.has_status_effect(/datum/status_effect/debuff/devitalised) || victim.has_status_effect(/datum/status_effect/debuff/devitalised/lesser))
			continue
		victim.apply_status_effect(/datum/status_effect/debuff/devitalised/lesser)
		to_chat(victim, span_artery("Your breath catches in your throat. Cold, unseen fingers burrow into your chest, clawing at your very life force!"))
		targets_hit++

	if(!targets_hit)
		to_chat(owner, span_warning("You don't manage to extract lux from anyone..."))
		return ta_refund_failed_use()

	var/vitae_regained = targets_hit * 50
	to_chat(owner, span_notice("You siphon lux from [targets_hit] targets around you, regenerating [vitae_regained] vitae."))
	owner.apply_status_effect(/datum/status_effect/buff/vitae)
	owner.adjust_bloodpool(vitae_regained)
	owner.say("Gaan'Lah'Haas!")
	return TRUE

#undef ROLE_VAMPIRE_UNDEAD
#undef POLL_IGNORE_VAMPIRE_UNDEAD
#undef TA_NECROMANTIC_MAX_UNDEAD
