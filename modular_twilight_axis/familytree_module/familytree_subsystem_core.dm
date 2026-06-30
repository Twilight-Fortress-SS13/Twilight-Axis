SUBSYSTEM_DEF(familytree)
	name = "familytree"
	flags = SS_NO_FIRE
	lazy_load = FALSE

	var/datum/heritage/ruling_family
	var/allow_nobles_in_ruling_family = FALSE
	var/list/families = list()
	var/list/viable_spouses = list()
	// Species that can only match within their isolated group (gnolls + antag goblins)
	var/list/isolated_group_types = list(
		/datum/species/gnoll,
		/datum/species/goblin,
		)
	// Species that cannot reproduce biologically but can have families
	var/list/sterile_species_types = list(
		/datum/species/construct,
		)
	var/list/banned_antag_types = list(
		/datum/antagonist/zombie,
		/datum/antagonist/skeleton,
		/datum/antagonist/lich,
		/datum/antagonist/werewolf,
		/datum/antagonist/unbound_death_knight,
		/datum/antagonist/hag,
		/datum/antagonist/maniac,
		/datum/antagonist/dreamwalker,
		/datum/antagonist/assassin,
		)
	var/list/preset_family_species = list()
	var/list/royal_partner_job_baselines = list()
	var/mob/living/carbon/human/current_royal_partner_owner
	var/current_royal_partner_mode = "closed"
	var/list/current_royal_partner_snapshot = list()

	var/familytree_busy_retry_limit = 30
	var/familytree_busy_retry_delay = 10 SECONDS
	var/familytree_log_file
	var/ftlog_counter = 0
	var/ftlog_error_count = 0
	var/ftlog_warn_count = 0

#define FTLOG_DEBUG "DEBUG"
#define FTLOG_INFO  "INFO"
#define FTLOG_WARN  "WARN"
#define FTLOG_ERROR "ERROR"
#define FTLOG_CRIT  "CRIT"

/datum/controller/subsystem/familytree/proc/ftlog(msg, level = FTLOG_INFO)
#ifdef FAMILYTREE_DEBUG_LOGGING
	if(!familytree_log_file)
		if(GLOB.log_directory)
			familytree_log_file = "[GLOB.log_directory]/ss_family.log"
		else
			familytree_log_file = "data/logs/ss_family.log"
	ftlog_counter++
	if(level == FTLOG_ERROR || level == FTLOG_CRIT)
		ftlog_error_count++
	if(level == FTLOG_WARN)
		ftlog_warn_count++
	WRITE_LOG(familytree_log_file, "\[[logtime]] [level] #[ftlog_counter] [msg]")
#endif
	return

/datum/controller/subsystem/familytree/proc/ftlog_state(tag = "SNAPSHOT")
#ifdef FAMILYTREE_DEBUG_LOGGING
	ftlog("=== [tag] ===", FTLOG_INFO)
	ftlog("[tag] families=[families.len] viable_spouses=[viable_spouses.len] errors=[ftlog_error_count] warns=[ftlog_warn_count]", FTLOG_INFO)
	var/assigned_count = 0
	var/pending_count = 0
	var/bound_count = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H?.client)
			continue
		if(H.family_datum)
			assigned_count++
		else if(H.familytree_assignment_scheduled)
			pending_count++
		if(H.familytree_module_signal_bound)
			bound_count++
	ftlog("[tag] players: assigned=[assigned_count] pending=[pending_count] signal_bound=[bound_count]", FTLOG_INFO)
	for(var/datum/heritage/house as anything in families)
		if(!house.member_nodes.len)
			continue
		var/list/names = list()
		for(var/datum/family_node/node as anything in house.member_nodes)
			if(node.person)
				names += "[node.person.real_name]([node.person.ckey || "NPC"])"
		ftlog("[tag] HOUSE '[house.housename]' race=[house.dominant_race] members=[house.member_nodes.len]: [names.Join(", ")]", FTLOG_DEBUG)
	ftlog("=== /[tag] ===", FTLOG_INFO)
#endif

/datum/controller/subsystem/familytree/proc/register_family(datum/heritage/house)
	if(!house)
		return FALSE
	if(house == ruling_family)
		return TRUE
	if(!(house in families))
		families += house
	return TRUE

/datum/controller/subsystem/familytree/Initialize()
	ftlog("Initialize() START")
	ruling_family = new /datum/heritage(null, "Royal", /datum/species/human/northern)
	preset_family_species = build_preset_family_species()
	ftlog("preset_family_species built: [preset_family_species.len] species")
	ensure_royal_partner_job_baselines()
	reset_royal_partner_jobs()
	for(var/pioneer_household in preset_family_species)
		var/datum/species/species_instance = new pioneer_household()
		for(var/I = 1 to 2)
			var/datum/heritage/family = new /datum/heritage
			family.dominant_race = species_instance
			families += family
	ftlog("families after preset: [families.len]")
	create_isolated_species_houses()
	ftlog("families after isolated houses: [families.len]")
	load_enigma_roles()
	load_deserttown_roles()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	var/registered_count = 0
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		register_human(H)
		registered_count++
	ftlog("registered [registered_count] humans from GLOB.mob_list")
	addtimer(CALLBACK(src, PROC_REF(scan_and_grant_holy_spells)), 30 SECONDS)
	ftlog("Initialize() DONE, holy spell scan scheduled in 30s")
	ftlog_state("POST_INIT")
	return ..()

/datum/controller/subsystem/familytree/proc/build_preset_family_species() as /list
	. = familytree_module_get_selectable_species_types()

/datum/controller/subsystem/familytree/proc/create_isolated_species_houses()
	var/list/created_types = list()
	for(var/species_type in isolated_group_types)
		if(species_type in created_types)
			continue
		created_types += species_type
		var/datum/species/species_instance = new species_type()
		for(var/I = 1 to 2)
			var/datum/heritage/family = new /datum/heritage
			family.dominant_race = species_instance
			families += family

/datum/controller/subsystem/familytree/proc/load_familytree_runtime_preferences(mob/living/carbon/human/H, datum/preferences/P)
	if(!H || !P)
		return FALSE
	P.familytree_module_load_character()
	var/old_setspouse = H.setspouse
	H.familytree_pref = P.family
	H.gender_choice_pref = P.gender_choice_pref
	H.setspouse = P.setspouse
	if(old_setspouse != H.setspouse)
		H.familytree_setspouse_retries = 0
		H.familytree_setspouse_timeout_offered = FALSE
	H.species_preference_mode = P.species_preference_mode
	H.preferred_species_types = islist(P.preferred_species_types) ? P.preferred_species_types.Copy() : list()
	H.preferred_species_anatomy = P.preferred_species_anatomy
	H.polygamy_mode = P.polygamy_mode
	H.desired_relative_role = P.desired_relative_role
	H.allow_low_status_marriage = P.allow_low_status_marriage
	H.allow_relatives_in_family = P.allow_relatives_in_family
	H.know_your_fate = P.know_your_fate
	H.familytree_father_name = istext(P.familytree_father_name) ? P.familytree_father_name : ""
	H.familytree_mother_name = istext(P.familytree_mother_name) ? P.familytree_mother_name : ""
	H.familytree_father_species = istext(P.familytree_father_species) ? P.familytree_father_species : ""
	H.familytree_mother_species = istext(P.familytree_mother_species) ? P.familytree_mother_species : ""
	if(familytree_donator_relatives_enabled(H.ckey))
		H.familytree_random_siblings = sanitize_integer(text2num("[P.familytree_random_siblings]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
		H.familytree_random_children = sanitize_integer(text2num("[P.familytree_random_children]"), 0, FAMILYTREE_MAX_RANDOM_RELATIVES, 0)
	else
		H.familytree_random_siblings = 0
		H.familytree_random_children = 0
	return TRUE

/datum/controller/subsystem/familytree/proc/on_familytree_target_preference_changed(mob/living/carbon/human/H, old_setspouse)
	if(!H || QDELETED(H))
		return
	var/old_target = istext(old_setspouse) ? old_setspouse : ""
	var/new_target = istext(H.setspouse) ? H.setspouse : ""
	if(old_target == new_target)
		return
	H.familytree_setspouse_retries = 0
	H.familytree_setspouse_timeout_offered = FALSE
	ftlog("target preference changed for [H.real_name]: '[old_target]' -> '[new_target]'")
	if(H.family_datum || H.familytree_opted_out || H.familytree_confirmation_pending)
		return
	if(!familytree_pref_enabled(H.familytree_pref))
		return
	if(H.familytree_assignment_scheduled)
		return
	H.familytree_assignment_scheduled = TRUE
	addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), 1 SECONDS)

/datum/controller/subsystem/familytree/proc/is_familytree_player_busy(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return null
	if(H.notransform)
		return "notransform"
	if(istype(H.loc, /mob/dead/new_player))
		return "new_player loc"
	if(H.ckey && SSrole_class_handler?.class_select_handlers)
		var/list/class_handlers = SSrole_class_handler.class_select_handlers
		if(class_handlers[H.ckey])
			return "class picker"
	return null

/datum/controller/subsystem/familytree/proc/on_mob_created(datum/controller/subsystem/processing/dcs/source, mob/new_mob)
	SIGNAL_HANDLER
	ftlog("on_mob_created: [new_mob?.type] ckey=[new_mob?.ckey] name=[new_mob?.real_name]")
	if(!ishuman(new_mob))
		ftlog("on_mob_created SKIP: not human")
		return
	if(QDELETED(new_mob))
		ftlog("on_mob_created SKIP: qdeleted", FTLOG_WARN)
		return
	if(istype(new_mob, /mob/living/carbon/human/dummy))
		ftlog("on_mob_created SKIP: dummy")
		return
	var/mob/living/carbon/human/H = new_mob
	ftlog("on_mob_created PASS: registering [H.real_name] (ckey=[H.ckey] - may be empty, login will handle)")
	register_human(H)
	if(H.ckey)
		addtimer(CALLBACK(src, PROC_REF(try_grant_holy_spells), H), 10 SECONDS)
		try_queue_assignment(H)

/datum/controller/subsystem/familytree/proc/scan_and_grant_holy_spells()
	ftlog("scan_and_grant_holy_spells START, GLOB.player_list=[GLOB.player_list.len]")
	var/scanned = 0
	var/granted = 0
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(QDELETED(H) || !H.ckey || !H.mind)
			ftlog("scan_holy SKIP: [H?.real_name] ckey=[H?.ckey] mind=[H?.mind ? "yes" : "no"] qdel=[QDELETED(H)]")
			continue
		scanned++
		if(try_grant_holy_spells(H))
			granted++
	ftlog("scan_and_grant_holy_spells DONE: scanned=[scanned] granted=[granted]")

/datum/controller/subsystem/familytree/proc/try_grant_holy_spells(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || !H.ckey || !H.mind)
		ftlog("try_grant_holy SKIP: [H?.real_name] null/qdel/nockey/nomind")
		return FALSE
	if(!familytree_priest_can_perform_bond(H))
		ftlog("try_grant_holy SKIP: [H.real_name] patron/level not eligible")
		return FALSE
	ftlog("try_grant_holy: [H.real_name] GRANTING familytree_establish_bond + familytree_dissolve_marriage")
	H.verbs |= list(
		/mob/living/carbon/human/proc/familytree_establish_bond,
		/mob/living/carbon/human/proc/familytree_dissolve_marriage,
	)
	return TRUE

/datum/controller/subsystem/familytree/proc/register_human(mob/living/carbon/human/H)
	if(!H || istype(H, /mob/living/carbon/human/dummy))
		ftlog("register_human SKIP: null or dummy", FTLOG_WARN)
		return
	if(H.familytree_module_signal_bound)
		ftlog("register_human SKIP: [H.real_name] already bound")
		return
	ftlog("register_human: [H.real_name] ([H.ckey]) binding signals")
	H.familytree_module_signal_bound = TRUE
	RegisterSignal(H, COMSIG_MOB_LOGIN, PROC_REF(on_human_login))
	RegisterSignal(H, COMSIG_MOB_LOGOUT, PROC_REF(on_human_logout))
	RegisterSignal(H, COMSIG_MOB_DEATH, PROC_REF(on_human_death))
	RegisterSignal(H, COMSIG_LIVING_REVIVE, PROC_REF(on_human_revive))
	RegisterSignal(H, COMSIG_JOB_RECEIVED, PROC_REF(on_human_job_received))
	ftlog("register_human: [H.real_name] signals bound OK")

/datum/controller/subsystem/familytree/proc/stop_tracking_human(mob/living/carbon/human/H, reason = "unspecified")
	if(!H)
		ftlog("stop_tracking SKIP: null human")
		return
	H.familytree_assignment_scheduled = FALSE
	H.familytree_confirmation_pending = FALSE
	viable_spouses -= H
	if(!H.familytree_module_signal_bound)
		ftlog("stop_tracking SKIP: [H.real_name] not bound")
		return
	ftlog("stop_tracking: [H.real_name] ([H.ckey]) reason=[reason]")
	H.familytree_module_signal_bound = FALSE
	UnregisterSignal(H, list(COMSIG_MOB_LOGIN, COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_LIVING_REVIVE, COMSIG_JOB_RECEIVED))

/datum/controller/subsystem/familytree/proc/on_human_login(mob/living/carbon/human/H)
	SIGNAL_HANDLER
	ftlog("on_human_login: [H?.real_name] ([H?.ckey]) client=[H?.client ? "yes" : "no"]")
	if(H?.family_datum)
		schedule_house_member_resync(H.family_datum)
	try_queue_assignment(H)
	addtimer(CALLBACK(src, PROC_REF(try_grant_holy_spells), H), 5 SECONDS)

/datum/controller/subsystem/familytree/proc/on_human_logout(mob/living/carbon/human/H)
	SIGNAL_HANDLER
	ftlog("on_human_logout: [H?.real_name] ([H?.ckey])")
	if(H)
		viable_spouses -= H
		notify_family_head_departure(H)

/datum/controller/subsystem/familytree/proc/on_human_death(mob/living/carbon/human/H, gibbed)
	SIGNAL_HANDLER
	ftlog("on_human_death: [H?.real_name] ([H?.ckey]) gibbed=[gibbed]")
	pause_familytree_human(H, "death")

/datum/controller/subsystem/familytree/proc/on_human_revive(mob/living/carbon/human/H, full_heal, admin_revive)
	SIGNAL_HANDLER
	ftlog("on_human_revive: [H?.real_name] ([H?.ckey])")
	addtimer(CALLBACK(src, PROC_REF(run_revive_recheck), H, full_heal, admin_revive, 1), 2)

/datum/controller/subsystem/familytree/proc/run_revive_recheck(mob/living/carbon/human/H, full_heal, admin_revive, attempt)
	if(!H || QDELETED(H))
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		if(attempt < 5)
			addtimer(CALLBACK(src, PROC_REF(run_revive_recheck), H, full_heal, admin_revive, attempt + 1), 2)
		return
	try_queue_assignment(H)

/datum/controller/subsystem/familytree/proc/on_human_job_received(mob/living/carbon/human/H, rank)
	SIGNAL_HANDLER
	ftlog("on_human_job_received: [H?.real_name] ([H?.ckey]) rank=[rank]")
	if(H?.family_datum)
		schedule_house_member_resync(H.family_datum)
	try_queue_assignment(H)
	addtimer(CALLBACK(src, PROC_REF(try_grant_holy_spells), H), 2 SECONDS)

/datum/controller/subsystem/familytree/proc/on_family_formed(datum/heritage/house)
	if(!house)
		return
	schedule_house_member_resync(house)

/datum/controller/subsystem/familytree/proc/try_queue_assignment(mob/living/carbon/human/H)
	ftlog("try_queue_assignment: [H?.real_name] ([H?.ckey])")
	if(!H || QDELETED(H) || istype(H, /mob/living/carbon/human/dummy))
		ftlog("try_queue SKIP: null/qdel/dummy", FTLOG_WARN)
		return
	var/unsubscribe_reason = get_familytree_unsubscribe_reason(H)
	if(unsubscribe_reason)
		ftlog("try_queue UNSUB: [H.real_name] reason=[unsubscribe_reason]", FTLOG_WARN)
		unsubscribe_familytree_human(H, unsubscribe_reason)
		return
	if(H.stat == DEAD)
		ftlog("try_queue SKIP: [H.real_name] dead")
		return
	if(!H.client)
		ftlog("try_queue SKIP: [H.real_name] no client")
		return

	var/datum/job/job = get_familytree_job(H)
	ftlog("try_queue: [H.real_name] job=[job?.title] species=[H.dna?.species?.type]")
	var/datum/preferences/P = H.client?.prefs
	if(P && is_royal_monarch_job(job) && !current_royal_partner_owner)
		ftlog("try_queue: [H.real_name] is royal monarch, refreshing partner jobs")
		P.familytree_module_load_character()
		refresh_royal_partner_jobs(H, P)

	if(H.family_datum)
		ftlog("try_queue STOP: [H.real_name] family already assigned ([H.family_datum])")
		stop_tracking_human(H, "family already assigned")
		return

	if(H.familytree_confirmation_pending)
		ftlog("try_queue SKIP: [H.real_name] confirmation already pending")
		return

	if(H.familytree_assignment_scheduled)
		ftlog("try_queue SKIP: [H.real_name] assignment already scheduled")
		return

	if(H in viable_spouses)
		ftlog("try_queue WAIT: [H.real_name] already in viable_spouses; scheduling recheck")
		wait_for_new_family_match(H, "queue requested while already waiting in new-family pool")
		return

	if(!P)
		ftlog("try_queue SKIP: [H.real_name] no prefs")
		return

	load_familytree_runtime_preferences(H, P)
	ftlog("try_queue: [H.real_name] pref=[H.familytree_pref] setspouse=[H.setspouse] role=[H.desired_relative_role]")
	if(is_royal_suitor_job(job))
		ftlog("try_queue STOP: [H.real_name] royal suitor job")
		stop_tracking_human(H, "royal suitor bypasses familytree assignment")
		return

	var/royal_status = get_royal_status(H)
	if(royal_status == FAMILY_OMMER)
		if(GetCurrentMonarch())
			ftlog("try_queue ROYAL HAND OFFER: [H.real_name] delay=[get_royal_delay(H)]s")
			H.familytree_assignment_scheduled = TRUE
			addtimer(CALLBACK(src, PROC_REF(run_royal_hand_assignment_offer), H), get_royal_delay(H) SECONDS)
			return
		ftlog("try_queue ROYAL HAND: [H.real_name] no current monarch; falling back to normal prefs")
	else if(royal_status)
		ftlog("try_queue ROYAL: [H.real_name] status=[royal_status] delay=[get_royal_delay(H)]s")
		H.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(src, PROC_REF(run_royal_assignment), H, royal_status), get_royal_delay(H) SECONDS)
		return

	if(familytree_pref_enabled(H.familytree_pref))
		var/target_name = familytree_get_target_name(H)
		var/timer = (target_name && length(target_name)) ? 3 : (rand(1, 30) + 10)
		ftlog("try_queue LOCAL: [H.real_name] pref=[H.familytree_pref] timer=[timer]s")
		H.familytree_assignment_scheduled = TRUE
		addtimer(CALLBACK(src, PROC_REF(run_local_assignment), H, H.familytree_pref), timer SECONDS)
		return

	if(H.client && (H.mind?.assigned_role || H.job))
		ftlog("try_queue STOP: [H.real_name] familytree disabled (pref=FAMILY_NONE)")
		stop_tracking_human(H, "familytree disabled for this character")

/datum/controller/subsystem/familytree/proc/run_local_assignment(mob/living/carbon/human/H, status, busy_attempt = 0)
	ftlog("run_local_assignment: [H?.real_name] ([H?.ckey]) status=[status] busy_attempt=[busy_attempt]")
	if(!H || QDELETED(H))
		ftlog("run_local ABORT: null/qdel", FTLOG_ERROR)
		return
	var/effective_status = status
	var/datum/preferences/P = H.client?.prefs
	if(P && load_familytree_runtime_preferences(H, P))
		effective_status = H.familytree_pref
	if(H.familytree_opted_out || !familytree_pref_enabled(effective_status))
		ftlog("run_local STOP: [H.real_name] familytree disabled before local assignment")
		H.familytree_assignment_scheduled = FALSE
		stop_tracking_human(H, "familytree disabled for this character")
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		ftlog("run_local DEFER: [H.real_name] dead")
		pause_familytree_human(H, "local assignment deferred: dead")
		return
	if(block_reason == "no client")
		ftlog("run_local DEFER: [H.real_name] no client")
		H.familytree_assignment_scheduled = FALSE
		return
	if(block_reason)
		ftlog("run_local UNSUB: [H.real_name] block=[block_reason]", FTLOG_WARN)
		unsubscribe_familytree_human(H, "local assignment aborted: [block_reason]")
		return
	if(H.family_datum)
		ftlog("run_local SKIP: [H.real_name] already has family")
		H.familytree_assignment_scheduled = FALSE
		stop_tracking_human(H, "local assignment skipped; family already assigned")
		return
	if(H.familytree_confirmation_pending)
		ftlog("run_local SKIP: [H.real_name] confirmation already pending")
		H.familytree_assignment_scheduled = FALSE
		return
	H.familytree_assignment_scheduled = FALSE
	if(try_force_mutual_targeted_match(H))
		ftlog("run_local TARGETED: [H.real_name] matched via mutual target before AddLocal")
		return
	ftlog("run_local GO: [H.real_name] calling AddLocal status=[effective_status]")
	AddLocal(H, effective_status)

/datum/controller/subsystem/familytree/proc/run_royal_assignment(mob/living/carbon/human/H, status)
	ftlog("run_royal_assignment: [H?.real_name] ([H?.ckey]) status=[status]")
	if(!H || QDELETED(H))
		ftlog("run_royal ABORT: null/qdel", FTLOG_ERROR)
		return
	var/block_reason = get_familytree_runtime_block_reason(H, TRUE)
	if(block_reason == "dead")
		ftlog("run_royal DEFER: [H.real_name] dead")
		pause_familytree_human(H, "royal assignment deferred: dead")
		return
	if(block_reason == "no client")
		ftlog("run_royal DEFER: [H.real_name] no client")
		H.familytree_assignment_scheduled = FALSE
		return
	if(block_reason)
		ftlog("run_royal UNSUB: [H.real_name] block=[block_reason]", FTLOG_WARN)
		unsubscribe_familytree_human(H, "royal assignment aborted: [block_reason]")
		return
	if(H.family_datum)
		ftlog("run_royal SKIP: [H.real_name] already has family")
		H.familytree_assignment_scheduled = FALSE
		stop_tracking_human(H, "royal assignment skipped; family already assigned")
		return
	if(H.familytree_confirmation_pending)
		ftlog("run_royal SKIP: [H.real_name] confirmation already pending")
		H.familytree_assignment_scheduled = FALSE
		return
	H.familytree_assignment_scheduled = FALSE
	ftlog("run_royal GO: [H.real_name] calling AddRoyal status=[status]")
	AddRoyal(H, status)
