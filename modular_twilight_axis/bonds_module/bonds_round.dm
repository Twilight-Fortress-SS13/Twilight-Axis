SUBSYSTEM_DEF(bonds)
	name = "bonds"
	flags = SS_NO_FIRE
	lazy_load = FALSE

	var/list/nodes = list()
	var/list/actors_by_mind = list()
	var/list/actors_by_phantom = list()
	var/list/event_prototypes = list()
	var/list/stage_prototypes = list()
	var/list/round_prefs_by_ckey = list()
	var/list/round_ledger = list()
	var/list/faction_prototypes = list()
	var/list/faction_index = list()
	var/list/clan_index = list()
	var/list/origin_prototypes = list()
	var/list/origin_index = list()
	var/list/origin_lore = list()
	var/list/role_weights = list()
	var/list/map_lenses = list()
	var/list/influence_pools = list()
	var/list/zone_lenses = list()
	var/list/dispositions = list()
	var/list/hierarchy_by_faction = list()
	var/list/rank_by_title = list()
	var/list/weight_shares = list()
	var/share_role = 0
	var/share_lore = 0
	var/share_teller = 0
	var/share_zone = 0
	var/share_map = 0
	var/list/faction_stances = list()
	var/list/stance_blocks_cache
	var/list/realm_templates_cache
	var/list/house_stances = list()
	var/list/storyteller_lenses = list()
	var/storyteller_lens_applied = FALSE
	var/list/seed_flavor_cache
	var/list/present_factions_cache
	var/list/faction_map_cache
	var/faction_map_cache_revision = -1
	var/stance_revision = 0
	var/list/zone_lens_cache = list()
	var/map_weight_cache
	var/reacting = TRUE
#ifdef BONDS_EVOLUTION_FROZEN
	var/dreams_enabled = FALSE
#else
	var/dreams_enabled = TRUE
#endif
	var/instrumented = FALSE
	var/list/tallies = list()
	var/seeding_idle = FALSE
	var/bonds_log_file
	var/bondlog_counter = 0
	var/bondlog_error_count = 0
	var/bondlog_warn_count = 0
#ifdef BONDS_DEBUG_LOGGING
	var/verbose_logging = TRUE
#else
	var/verbose_logging = FALSE
#endif

/datum/controller/subsystem/bonds/Initialize()
	build_event_prototypes()
	build_stage_prototypes()
	build_faction_index()
	build_archetype_index()
	apply_dream_config()
	build_dream_index()
	build_clan_index()
	build_origin_index()
	build_origin_lore()
	build_role_weights()
	build_map_lenses()
	build_zone_lenses()
	build_dispositions()
	build_hierarchy()
	build_weight_shares()
	build_storyteller_lenses()
	build_faction_stances()
	register_debug_verbs()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	schedule_seeding()
	bondlog("Initialize() DONE, events=[event_prototypes.len] stages=[stage_prototypes.len]", BONDLOG_INFO)
	return ..()

/datum/controller/subsystem/bonds/proc/bondlog(msg, level = BONDLOG_DEBUG)
	if(level == BONDLOG_DEBUG && !verbose_logging)
		return
	if(!bonds_log_file)
		if(GLOB.log_directory)
			bonds_log_file = "[GLOB.log_directory]/ss_bonds.log"
		else
			bonds_log_file = "data/logs/ss_bonds.log"
	bondlog_counter++
	if(level == BONDLOG_ERROR)
		bondlog_error_count++
	if(level == BONDLOG_WARN)
		bondlog_warn_count++
	WRITE_LOG(bonds_log_file, "\[[logtime]] [level] #[bondlog_counter] [msg]")

/datum/controller/subsystem/bonds/proc/build_event_prototypes()
	for(var/datum/bond_event/event_type as anything in typesof(/datum/bond_event))
		if(IS_ABSTRACT(event_type))
			continue
		event_prototypes[event_type] = new event_type()

/datum/controller/subsystem/bonds/proc/get_event_prototype(event_type)
	RETURN_TYPE(/datum/bond_event)
	return event_prototypes[event_type]

/datum/controller/subsystem/bonds/proc/bondlog_state(tag = "SNAPSHOT")
	bondlog("=== [tag] ===", BONDLOG_INFO)
	var/total_bonds = 0
	for(var/datum/mind/owner as anything in nodes)
		var/datum/bond_node/node = nodes[owner]
		total_bonds += length(node.bonds)
	bondlog("[tag] nodes=[nodes.len] bonds=[total_bonds] errors=[bondlog_error_count] warns=[bondlog_warn_count]", BONDLOG_INFO)
	bondlog("=== /[tag] ===", BONDLOG_INFO)

/datum/bond_rank
	abstract_type = /datum/bond_rank
	var/faction_id = ""
	var/level = 1
	var/label = ""
	var/list/titles

/datum/bond_rank/noble_duke
	faction_id = BOND_FACTION_NOBLE
	level = 1
	label = "Правитель"
	titles = list("Grand Duke", "Sultan")

/datum/bond_rank/noble_family
	faction_id = BOND_FACTION_NOBLE
	level = 2
	label = "Семья правителя"
	titles = list("Consort", "Prince", "Harem Favorite")

/datum/bond_rank/court_hand
	faction_id = BOND_FACTION_COURT
	level = 1
	label = "Десница"
	titles = list("Hand", "Vizier")

/datum/bond_rank/court_council
	faction_id = BOND_FACTION_COURT
	level = 2
	label = "Советники"
	titles = list("Steward", "Seneschal", "Councillor", "Sheikh")

/datum/bond_rank/court_household
	faction_id = BOND_FACTION_COURT
	level = 3
	label = "Двор"
	titles = list("Clerk", "Jester", "Archivist", "Court Magician", "Court Physician", "Suitor", "Head Slave", "Slave Master")

/datum/bond_rank/retinue_marshal
	faction_id = BOND_FACTION_RETINUE
	level = 1
	label = "Маршал"
	titles = list("Marshal")

/datum/bond_rank/retinue_royal
	faction_id = BOND_FACTION_RETINUE
	level = 2
	label = "Королевские рыцари"
	titles = list("Royal Knight")

/datum/bond_rank/retinue_knights
	faction_id = BOND_FACTION_RETINUE
	level = 3
	label = "Рыцари"
	titles = list("Knight", "Cataphract")

/datum/bond_rank/retinue_squires
	faction_id = BOND_FACTION_RETINUE
	level = 4
	label = "Оруженосцы"
	titles = list("Squire")

/datum/bond_rank/garrison_sergeant
	faction_id = BOND_FACTION_GARRISON
	level = 1
	label = "Сержант"
	titles = list("Sergeant", "Royal Guard Sergeant", "Janissary Sergeant", "Azeb Agha")

/datum/bond_rank/garrison_guards
	faction_id = BOND_FACTION_GARRISON
	level = 2
	label = "Гвардия"
	titles = list("Man at Arms", "Royal Guard", "Warden", "Janissary")

/datum/bond_rank/garrison_watch
	faction_id = BOND_FACTION_GARRISON
	level = 3
	label = "Дозор"
	titles = list("Watchman", "Azeb")

/datum/bond_rank/citywatch_sheriff
	faction_id = BOND_FACTION_CITYWATCH
	level = 1
	label = "Шериф"
	titles = list("Town Sheriff")

/datum/bond_rank/citywatch_watch
	faction_id = BOND_FACTION_CITYWATCH
	level = 2
	label = "Городская стража"
	titles = list("Town Watch")

/datum/bond_rank/vanguard_overseer
	faction_id = BOND_FACTION_VANGUARD
	level = 1
	label = "Надзиратель"
	titles = list("Overseer")

/datum/bond_rank/vanguard_ranks
	faction_id = BOND_FACTION_VANGUARD
	level = 2
	label = "Авангард"
	titles = list("Vanguard")

/datum/bond_rank/church_bishop
	faction_id = BOND_FACTION_CHURCH
	level = 1
	label = "Епископ"
	titles = list("Bishop")

/datum/bond_rank/church_ordained
	faction_id = BOND_FACTION_CHURCH
	level = 2
	label = "Служители"
	titles = list("Templar", "Martyr", "Keeper", "Druid")

/datum/bond_rank/church_acolytes
	faction_id = BOND_FACTION_CHURCH
	level = 3
	label = "Аколиты"
	titles = list("Acolyte")

/datum/bond_rank/church_sexton
	faction_id = BOND_FACTION_CHURCH
	level = 4
	label = "Алтарники"
	titles = list("Sexton")

/datum/bond_rank/inquisition_inquisitor
	faction_id = BOND_FACTION_INQUISITION
	level = 1
	label = "Инквизитор"
	titles = list("Inquisitor")

/datum/bond_rank/inquisition_absolver
	faction_id = BOND_FACTION_INQUISITION
	level = 2
	label = "Искупитель"
	titles = list("Absolver")

/datum/bond_rank/inquisition_orthodoxist
	faction_id = BOND_FACTION_INQUISITION
	level = 3
	label = "Ортодоксист"
	titles = list("Orthodoxist")

/datum/bond_rank/burgher_master
	faction_id = BOND_FACTION_BURGHER
	level = 1
	label = "Гильдмастер"
	titles = list("Guildmaster", "Mayor")

/datum/bond_rank/burgher_guild
	faction_id = BOND_FACTION_BURGHER
	level = 2
	label = "Гильдия"
	titles = list("Guildsman", "Tailor", "Apothecary", "Innkeeper", "Bathmaster", "Magicians Associate", "Head Physician", "Bailiff")

/datum/bond_rank/peasant_hearth
	faction_id = BOND_FACTION_PEASANT
	level = 1
	label = "Хозяева очага"
	titles = list("Towner", "Cook", "Tapster")

/datum/bond_rank/peasant_hands
	faction_id = BOND_FACTION_PEASANT
	level = 2
	label = "Рабочие руки"
	titles = list("Soilson", "Bathhouse Attendant")

/datum/bond_rank/peasant_bound
	faction_id = BOND_FACTION_PEASANT
	level = 3
	label = "Подневольные"
	titles = list("Servant", "Palace Slave")

/datum/bond_rank/sidefolk_blooded
	faction_id = BOND_FACTION_SIDEFOLK
	level = 1
	label = "Битые жизнью"
	titles = list("Veteran", "Mercenary")

/datum/bond_rank/sidefolk_drifters
	faction_id = BOND_FACTION_SIDEFOLK
	level = 2
	label = "Пришлые"
	titles = list("Migrant", "Pilgrim", "Vagabond")

/datum/bond_rank/sidefolk_lost
	faction_id = BOND_FACTION_SIDEFOLK
	level = 3
	label = "Пропащие"
	titles = list("Lunatic")

/datum/bond_rank/wanderer_agents
	faction_id = BOND_FACTION_WANDERER
	level = 1
	label = "Люди с поручением"
	titles = list("Court Agent", "Trader")

/datum/bond_rank/wanderer_road
	faction_id = BOND_FACTION_WANDERER
	level = 2
	label = "Дорожные"
	titles = list("Adventurer")

/datum/bond_rank/outlaw_hunted
	faction_id = BOND_FACTION_OUTLAW
	level = 1
	label = "За чью голову платят"
	titles = list("Assassin", "Hag")

/datum/bond_rank/outlaw_bandits
	faction_id = BOND_FACTION_OUTLAW
	level = 2
	label = "Лихие люди"
	titles = list("Bandit", "Lost Grenzel", "Freeman")

/datum/bond_rank/outlaw_dregs
	faction_id = BOND_FACTION_OUTLAW
	level = 3
	label = "Отребье"
	titles = list("Wretch", "Gnoll")

/datum/bond_rank/atc_merchant
	faction_id = BOND_FACTION_ATC
	level = 1
	label = "Купец"
	titles = list("Merchant")

/datum/bond_rank/atc_shophand
	faction_id = BOND_FACTION_ATC
	level = 2
	label = "Приказчики"
	titles = list("Shophand")

/datum/controller/subsystem/bonds/proc/build_hierarchy()
	hierarchy_by_faction = list()
	rank_by_title = list()
	for(var/datum/bond_rank/rank_type as anything in typesof(/datum/bond_rank))
		if(IS_ABSTRACT(rank_type))
			continue
		var/datum/bond_rank/rank = new rank_type()
		if(!rank.faction_id)
			qdel(rank)
			continue
		if(!hierarchy_by_faction[rank.faction_id])
			hierarchy_by_faction[rank.faction_id] = list()
		hierarchy_by_faction[rank.faction_id] += rank
		for(var/title in rank.titles)
			rank_by_title[title] = rank
	for(var/faction_id in hierarchy_by_faction)
		sortTim(hierarchy_by_faction[faction_id], GLOBAL_PROC_REF(cmp_bond_rank_level))
	bondlog("hierarchy built: [hierarchy_by_faction.len] factions, [rank_by_title.len] titles", BONDLOG_INFO)

/proc/cmp_bond_rank_level(datum/bond_rank/a, datum/bond_rank/b)
	return a.level - b.level

/datum/controller/subsystem/bonds/proc/rank_for_title(title)
	RETURN_TYPE(/datum/bond_rank)
	if(!title)
		return null
	return rank_by_title[title]

/datum/controller/subsystem/bonds/proc/faction_members(faction_id)
	RETURN_TYPE(/list)
	var/list/out = list()
	if(!faction_id)
		return out
	for(var/mob/living/carbon/human/person in GLOB.player_list)
		if(!person.client || !person.mind || istype(person, /mob/living/carbon/human/dummy))
			continue
		if(faction_id_for(person) != faction_id)
			continue
		out += person
	return out

/datum/controller/subsystem/bonds/proc/best_allied_faction(faction_id)
	if(!faction_id)
		return null
	var/best_id
	var/best_warmth = 0
	for(var/other_id in faction_prototypes)
		if(other_id == faction_id)
			continue
		var/datum/bond_faction/other = faction_prototypes[other_id]
		if(istype(other, /datum/bond_faction/clan))
			continue
		var/warmth = stance_warmth(faction_id, other_id)
		if(warmth <= best_warmth)
			continue
		best_warmth = warmth
		best_id = other_id
	return best_id

/datum/preferences
	var/bonds_seed_count = 0
	var/list/bonds_seed_flavors = list()
	var/tmp/bonds_module_loaded_slot
	var/tmp/bonds_module_loaded_path

/datum/preferences/proc/bonds_module_save_key_map()
	RETURN_TYPE(/list)
	var/static/list/key_map
	if(!key_map)
		key_map = list(
			"bonds_seed_count" = "bonds_seed_count",
			"bonds_seed_flavors" = "bonds_seed_flavors",
		)
	return key_map

/datum/preferences/proc/bonds_module_read_savefile(savefile/S)
	if(!S)
		return FALSE
	var/list/key_map = bonds_module_save_key_map()
	for(var/save_key in key_map)
		var/var_name = key_map[save_key]
		S[save_key] >> vars[var_name]
	return TRUE

/datum/preferences/proc/bonds_module_write_savefile(savefile/S)
	if(!S)
		return FALSE
	var/list/key_map = bonds_module_save_key_map()
	for(var/save_key in key_map)
		var/var_name = key_map[save_key]
		WRITE_FILE(S[save_key], vars[var_name])
	return TRUE

/datum/preferences/proc/bonds_module_sanitize_character()
	if(!isnum(bonds_seed_count))
		bonds_seed_count = 0
	bonds_seed_count = clamp(round(bonds_seed_count), 0, BOND_MAX_SEEDS)
	if(!islist(bonds_seed_flavors))
		bonds_seed_flavors = list()
	var/list/valid = SSbonds.valid_seed_flavors()
	for(var/flavor in bonds_seed_flavors.Copy())
		if(!(flavor in valid))
			bonds_seed_flavors -= flavor

/datum/preferences/proc/bonds_module_reset_character()
	bonds_seed_count = initial(bonds_seed_count)
	bonds_seed_flavors = list()

/datum/preferences/proc/bonds_module_load_character_from_savefile(savefile/S, slot, force = FALSE)
	if(!S)
		return FALSE
	if(!force && (bonds_module_loaded_path == path) && (bonds_module_loaded_slot == slot))
		return TRUE
	bonds_module_reset_character()
	bonds_module_read_savefile(S)
	bonds_module_sanitize_character()
	bonds_module_loaded_slot = slot
	bonds_module_loaded_path = path
	return TRUE

/datum/preferences/proc/bonds_module_load_character(slot)
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[slot || default_slot]"
	return bonds_module_load_character_from_savefile(S, slot || default_slot, TRUE)

/datum/preferences/proc/bonds_module_save_character_to_savefile(savefile/S, slot)
	if(!S)
		return FALSE
	bonds_module_sanitize_character()
	bonds_module_write_savefile(S)
	bonds_module_loaded_slot = slot
	bonds_module_loaded_path = path
	return TRUE

/datum/bonds_round_prefs
	var/ckey
	var/seed_count = 0
	var/list/seed_flavors

/datum/controller/subsystem/bonds/proc/capture_round_prefs(mob/living/carbon/human/person)
	if(!person?.ckey)
		return null
	var/datum/bonds_round_prefs/captured = round_prefs_by_ckey[person.ckey]
	if(captured)
		return captured
	var/datum/preferences/prefs = person.client?.prefs
	if(!prefs)
		return null
	prefs.bonds_module_load_character()
	captured = new()
	captured.ckey = person.ckey
	captured.seed_count = clamp(prefs.bonds_seed_count, 0, BOND_MAX_SEEDS)
	captured.seed_flavors = prefs.bonds_seed_flavors ? prefs.bonds_seed_flavors.Copy() : list()
	round_prefs_by_ckey[person.ckey] = captured
	bondlog("captured round prefs for [person.ckey]: seeds=[captured.seed_count]", BONDLOG_INFO)
	return captured

/datum/controller/subsystem/bonds/proc/get_round_prefs(target_ckey)
	if(!target_ckey)
		return null
	return round_prefs_by_ckey[target_ckey]

/datum/bonds_ledger_entry
	var/ckey
	var/seeds_granted = 0
	var/list/seeded_with = list()

/datum/controller/subsystem/bonds/proc/get_ledger(target_ckey)
	if(!target_ckey)
		return null
	var/datum/bonds_ledger_entry/entry = round_ledger[target_ckey]
	if(entry)
		return entry
	entry = new()
	entry.ckey = target_ckey
	round_ledger[target_ckey] = entry
	return entry

/datum/controller/subsystem/bonds/proc/already_seeded(ckey_a, ckey_b)
	var/datum/bonds_ledger_entry/entry = round_ledger[ckey_a]
	if(!entry)
		return FALSE
	return !!entry.seeded_with[ckey_b]

/datum/controller/subsystem/bonds/proc/remaining_seeds(target_ckey)
	var/datum/bonds_round_prefs/prefs = get_round_prefs(target_ckey)
	if(!prefs)
		return 0
	var/datum/bonds_ledger_entry/entry = round_ledger[target_ckey]
	var/granted = entry ? entry.seeds_granted : 0
	return max(0, prefs.seed_count - granted)

/datum/controller/subsystem/bonds/proc/mark_seeded(ckey_a, ckey_b)
	var/datum/bonds_ledger_entry/entry_a = get_ledger(ckey_a)
	var/datum/bonds_ledger_entry/entry_b = get_ledger(ckey_b)
	entry_a.seeded_with[ckey_b] = TRUE
	entry_b.seeded_with[ckey_a] = TRUE
	entry_a.seeds_granted++
	entry_b.seeds_granted++

/datum/controller/subsystem/bonds/proc/valid_seed_flavors()
	RETURN_TYPE(/list)
	if(seed_flavor_cache)
		return seed_flavor_cache
	var/list/flavors = list()
	for(var/event_type in event_prototypes)
		var/datum/bond_event/seed/prototype = event_prototypes[event_type]
		if(!istype(prototype) || !prototype.pickable)
			continue
		if(!(prototype.flavor_key in flavors))
			flavors += prototype.flavor_key
	seed_flavor_cache = flavors
	return flavors

/datum/controller/subsystem/bonds/proc/seed_flavor_labels()
	RETURN_TYPE(/list)
	var/list/labels = list()
	for(var/event_type in event_prototypes)
		var/datum/bond_event/seed/prototype = event_prototypes[event_type]
		if(!istype(prototype) || !prototype.pickable)
			continue
		labels[prototype.flavor_key] = prototype.flavor_label
	return labels

/datum/controller/subsystem/bonds/proc/bonds_seed_phase_open()
	if(!SSticker?.round_start_time)
		return FALSE
	return (world.time - SSticker.round_start_time) >= BOND_SEED_DELAY

/datum/controller/subsystem/bonds/proc/schedule_seeding(delay = BOND_SEED_DELAY)
	seeding_idle = FALSE
	addtimer(CALLBACK(src, PROC_REF(run_seeding)), delay, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/controller/subsystem/bonds/proc/stop_seeding(reason)
	seeding_idle = TRUE
	bondlog("seeding idle: [reason]", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/wake_seeding()
	if(!seeding_idle)
		return FALSE
	schedule_seeding(BOND_SEED_RETRY)
	return TRUE

/datum/controller/subsystem/bonds/proc/anyone_still_wants_seeds()
	for(var/target_ckey in round_prefs_by_ckey)
		if(remaining_seeds(target_ckey) > 0)
			return TRUE
	return FALSE

/datum/controller/subsystem/bonds/proc/run_seeding()
	if(!bonds_seed_phase_open())
		schedule_seeding(BOND_SEED_RETRY)
		return
	apply_storyteller_lens()
	var/list/pool = collect_seed_pool()
	if(length(pool) < 2)
		if(anyone_still_wants_seeds())
			schedule_seeding(BOND_SEED_RETRY)
		else
			stop_seeding("nobody is waiting for a starting acquaintance")
		return
	pool = shuffle(pool)
	var/paired = 0
	for(var/mob/living/carbon/human/seeker as anything in pool)
		if(QDELETED(seeker) || !seeker.mind || !seeker.ckey)
			continue
		if(remaining_seeds(seeker.ckey) <= 0)
			continue
		var/list/candidates = seed_candidates(seeker, pool)
		if(!length(candidates))
			CHECK_TICK
			continue
		var/mob/living/carbon/human/partner = pick(candidates)
		if(!QDELETED(partner) && partner.mind && apply_seed(seeker, partner))
			paired++
		CHECK_TICK
	bondlog("run_seeding paired=[paired] pool=[pool.len]", BONDLOG_INFO)
	if(anyone_still_wants_seeds())
		schedule_seeding(BOND_SEED_RETRY)
	else
		stop_seeding("every declared seed has been placed")

/datum/controller/subsystem/bonds/proc/collect_seed_pool()
	RETURN_TYPE(/list)
	var/list/pool = list()
	for(var/mob/living/carbon/human/person in GLOB.player_list)
		if(!person.client || !person.mind || !person.ckey)
			continue
		if(istype(person, /mob/living/carbon/human/dummy))
			continue
		if(!capture_round_prefs(person))
			continue
		if(remaining_seeds(person.ckey) <= 0)
			continue
		pool += person
	return pool

/datum/controller/subsystem/bonds/proc/seed_candidates(mob/living/carbon/human/seeker, list/pool)
	RETURN_TYPE(/list)
	var/list/weighted = list()
	var/datum/bond_faction/seeker_faction = faction_for(seeker)
	for(var/mob/living/carbon/human/candidate as anything in pool)
		if(candidate == seeker || !candidate.ckey)
			continue
		if(already_seeded(seeker.ckey, candidate.ckey))
			continue
		if(remaining_seeds(candidate.ckey) <= 0)
			continue
		if(!length(shared_seed_flavors(seeker.ckey, candidate.ckey)))
			continue
		var/datum/bond_faction/candidate_faction = faction_for(candidate)
		var/weight = 1
		if(seeker.job && candidate.job == seeker.job)
			weight = 8
		else if(seeker_faction && candidate_faction == seeker_faction)
			weight = 4
		else if(seeker_faction && candidate_faction && abs(stance_warmth(seeker_faction.id, candidate_faction.id)) >= BOND_STANCE_AFFINITY_THRESHOLD)
			weight = 2
		for(var/i in 1 to weight)
			weighted += candidate
	return weighted

/datum/controller/subsystem/bonds/proc/shared_seed_flavors(ckey_a, ckey_b)
	RETURN_TYPE(/list)
	var/datum/bonds_round_prefs/prefs_a = get_round_prefs(ckey_a)
	var/datum/bonds_round_prefs/prefs_b = get_round_prefs(ckey_b)
	if(!prefs_a || !prefs_b)
		return list()
	var/list/all_flavors = valid_seed_flavors()
	var/list/wanted_a = length(prefs_a.seed_flavors) ? prefs_a.seed_flavors : all_flavors
	var/list/wanted_b = length(prefs_b.seed_flavors) ? prefs_b.seed_flavors : all_flavors
	var/list/shared = list()
	for(var/flavor in wanted_a)
		if(flavor in wanted_b)
			shared += flavor
	return shared

/datum/controller/subsystem/bonds/proc/pick_seed_type(ckey_a, ckey_b)
	var/list/shared = shared_seed_flavors(ckey_a, ckey_b)
	if(!length(shared))
		return null
	var/chosen_flavor = pick(shared)
	var/list/matching = list()
	for(var/event_type in event_prototypes)
		var/datum/bond_event/seed/prototype = event_prototypes[event_type]
		if(!istype(prototype) || !prototype.pickable)
			continue
		if(prototype.flavor_key != chosen_flavor)
			continue
		matching += event_type
	if(!length(matching))
		return null
	return pick(matching)

/datum/controller/subsystem/bonds/proc/apply_seed(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b)
	if(!person_a?.mind || !person_b?.mind || person_a == person_b)
		return FALSE
	var/seed_type = pick_seed_type(person_a.ckey, person_b.ckey)
	if(!seed_type)
		return FALSE
	var/datum/bond_event/seed/prototype = get_event_prototype(seed_type)
	if(!prototype)
		return FALSE
	var/other_type = prototype.opposite_type || seed_type
	record(person_a.mind, person_b.mind, seed_type, person_b, TRUE)
	record(person_b.mind, person_a.mind, other_type, person_a, TRUE)
	mark_seeded(person_a.ckey, person_b.ckey)
	notify_seed(person_a, person_b)
	notify_seed(person_b, person_a)
	bondlog("seeded [person_a.ckey] <-> [person_b.ckey] as [seed_type]")
	return TRUE

/datum/controller/subsystem/bonds/proc/notify_seed(mob/living/carbon/human/person, mob/living/carbon/human/partner)
	var/datum/social_bond/bond = get_bond(person.mind, partner.mind)
	if(!bond)
		return
	var/datum/bond_history/latest = LAZYLEN(bond.history) ? bond.history[bond.history.len] : null
	if(!latest)
		return
	to_chat(person, span_notice("<b>Вы кое-кого припоминаете.</b> [latest.story]"))
