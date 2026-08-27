GLOBAL_LIST_EMPTY(bonds_debug_population)
GLOBAL_LIST_EMPTY(bonds_debug_rows)

/datum/controller/subsystem/bonds/proc/register_debug_verbs()
	GLOB.admin_verbs_debug |= list(
		/client/proc/bonds_debug_load,
		/client/proc/bonds_debug_timeskip,
		/client/proc/bonds_debug_degrade,
		/client/proc/bonds_debug_purge,
		/client/proc/bonds_toggle_verbose_logging,
		/client/proc/bonds_toggle_reacting,
	)

/client/proc/bonds_toggle_reacting()
	set name = "Bonds: Kill Switch"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	SSbonds.reacting = !SSbonds.reacting
	var/state = SSbonds.reacting ? "ВКЛЮЧЕНЫ" : "ЗАМОРОЖЕНЫ"
	SSbonds.bondlog("reacting turned [SSbonds.reacting ? "ON" : "OFF"] by [key_name(mob)]", BONDLOG_WARN)
	log_admin("[key_name(mob)] set bonds reacting to [SSbonds.reacting]")
	message_admins("[key_name_admin(mob)] [SSbonds.reacting ? "включил" : "заморозил"] реакцию системы связей.")
	to_chat(src, span_notice("Связи [state]. Граф и панели на месте, новые события [SSbonds.reacting ? "обрабатываются" : "игнорируются"]."))

/client/proc/bonds_toggle_verbose_logging()
	set name = "Bonds: Verbose Log"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	SSbonds.verbose_logging = !SSbonds.verbose_logging
	SSbonds.bondlog("verbose logging turned [SSbonds.verbose_logging ? "ON" : "OFF"] by [key_name(mob)]", BONDLOG_INFO)
	to_chat(src, span_notice("Подробный лог связей [SSbonds.verbose_logging ? "включён" : "выключен"]. Каждое действие пишется в data/logs/ss_bonds.log"))

/datum/bonds_bench
	var/label = ""
	var/phase = ""
	var/op_start = 0
	var/accumulated_ms = 0
	var/worst_ms = 0
	var/crossings = 0
	var/samples = 0
	var/wall_start = 0
	var/list/tally_mark
	var/owns_profiler = FALSE
	var/forced_profiler = FALSE
	var/list/rows = list()

/datum/bonds_bench/New(bench_label = "bench", force_profiler = FALSE)
	label = bench_label
	forced_profiler = force_profiler
	SSbonds.instrumented = TRUE
	SSbonds.tallies = list()
	owns_profiler = forced_profiler || !CONFIG_GET(flag/auto_profile)
	SSbonds.bondlog("BENCH|run=[label]|event=begin|profiler=[owns_profiler ? "ours" : "shared, left alone"]", BONDLOG_INFO)
	if(owns_profiler)
		world.Profile(PROFILE_CLEAR)
		world.Profile(PROFILE_START)

/datum/bonds_bench/proc/open(name)
	phase = name
	accumulated_ms = 0
	worst_ms = 0
	crossings = 0
	samples = 0
	wall_start = world.timeofday
	tally_mark = SSbonds.tallies.Copy()

/datum/bonds_bench/proc/op_begin()
	op_start = TICK_USAGE_REAL

/datum/bonds_bench/proc/op_end()
	var/ms = TICK_USAGE_TO_MS(op_start)
	if(ms < 0)
		crossings++
		return
	samples++
	accumulated_ms += ms
	if(ms > worst_ms)
		worst_ms = ms

/datum/bonds_bench/proc/close(ops = 0)
	var/wall = world.timeofday - wall_start
	if(wall < 0)
		wall += 864000
	var/per_op = samples > 0 ? (accumulated_ms * 1000 / samples) : 0
	var/list/state = SSbonds.debug_graph_state()
	var/line = "BENCH|run=[label]|phase=[phase]|ops=[ops]|sampled=[samples]|ms=[round(accumulated_ms, 0.01)]|us_op=[round(per_op, 0.1)]|worst_us=[round(worst_ms * 1000, 0.1)]|tick_crossings=[crossings]|wall_ms=[wall * 100]|nodes=[state["nodes"]]|bonds=[state["bonds"]]|kin=[state["kin"]]|history=[state["history"]]|active=[state["active"]]|stances=[state["stances"]]|pools=[state["pools"]]"
	rows += line
	GLOB.bonds_debug_rows += line
	SSbonds.bondlog(line, BONDLOG_INFO)
	report_tallies()
	return line

/datum/bonds_bench/proc/report_tallies()
	var/list/moved = list()
	for(var/key in SSbonds.tallies)
		var/delta = SSbonds.tallies[key] - (tally_mark?[key] || 0)
		if(delta > 0)
			moved += "[key]=[delta]"
	if(!length(moved))
		return
	SSbonds.bondlog("TALLY|run=[label]|phase=[phase]|[moved.Join("|")]", BONDLOG_INFO)

/datum/bonds_bench/proc/finish()
	if(owns_profiler)
		world.Profile(PROFILE_STOP)
		SSbonds.debug_dump_profile(label)
	else
		SSbonds.bondlog("PROFILE|run=[label]|skipped=server is auto-profiling; read data/logs/profiler/ instead", BONDLOG_INFO)
	SSbonds.debug_report_distribution(label)
	SSbonds.instrumented = FALSE
	SSbonds.bondlog("BENCH|run=[label]|event=end", BONDLOG_INFO)

/datum/controller/subsystem/bonds/proc/profile_row_is_ours(list/row)
	for(var/entry in row)
		if(!istext(entry))
			continue
		if(findtext(entry, "bond") || findtext(entry, "familytree"))
			return TRUE
		var/value = row[entry]
		if(istext(value) && (findtext(value, "bond") || findtext(value, "familytree")))
			return TRUE
	return FALSE

/datum/controller/subsystem/bonds/proc/debug_dump_profile(label)
	var/raw = world.Profile(PROFILE_REFRESH, format = "json")
	if(!length(raw))
		bondlog("PROFILE|run=[label]|error=empty (profiling stopped early?)", BONDLOG_WARN)
		return FALSE
	var/list/decoded
	try
		decoded = json_decode(raw)
	catch
		bondlog("PROFILE|run=[label]|error=undecodable", BONDLOG_WARN)
		return FALSE
	var/list/rows
	if(islist(decoded))
		if(islist(decoded["data"]))
			rows = decoded["data"]
		else if(length(decoded) && islist(decoded[1]))
			rows = decoded
	if(!islist(rows) || !length(rows))
		bondlog("PROFILE|run=[label]|error=no rows|decoded_len=[islist(decoded) ? length(decoded) : 0]", BONDLOG_WARN)
		return FALSE
	var/list/keep = list()
	for(var/list/row as anything in rows)
		if(!islist(row) || !length(row))
			continue
		if(profile_row_is_ours(row))
			keep += list(row)
	if(!length(keep) && length(rows))
		var/list/sample = rows[1]
		bondlog("PROFILE|run=[label]|nothing matched|row_shape=[sample.Join(",")]", BONDLOG_WARN)
	var/directory = GLOB.log_directory || "data/logs"
	var/path = "[directory]/bonds_profile-[label].json"
	var/payload = json_encode(list(
		"run" = label,
		"columns" = islist(decoded) ? decoded["columns"] : null,
		"sample_row" = length(rows) ? rows[1] : null,
		"note" = "rows are verbatim from world.Profile(PROFILE_REFRESH); see columns if present",
		"rows" = keep,
	))
	if(fexists(path))
		fdel(path)
	WRITE_FILE(file(path), payload)
	bondlog("PROFILE|run=[label]|matched=[length(keep)]|of=[length(rows)]|file=[path]", BONDLOG_INFO)
	return TRUE

/datum/controller/subsystem/bonds/proc/debug_report_distribution(label)
	var/list/stages = list()
	var/list/warmth_buckets = list("hostile" = 0, "cold" = 0, "neutral" = 0, "warm" = 0)
	var/list/per_node = list()
	var/total_bonds = 0
	for(var/datum/bond_actor/owner as anything in nodes)
		var/datum/bond_node/node = nodes[owner]
		if(!node)
			continue
		per_node += length(node.bonds)
		for(var/datum/bond_actor/target as anything in node.bonds)
			var/datum/social_bond/bond = node.bonds[target]
			total_bonds++
			var/stage_label = bond.stage?.label || "-"
			stages[stage_label] = (stages[stage_label] || 0) + 1
			switch(bond.warmth)
				if(-100 to -40)
					warmth_buckets["hostile"]++
				if(-39 to -10)
					warmth_buckets["cold"]++
				if(-9 to 14)
					warmth_buckets["neutral"]++
				else
					warmth_buckets["warm"]++

	var/widest = 0
	var/emptiest = -1
	var/sum = 0
	for(var/count in per_node)
		sum += count
		if(count > widest)
			widest = count
		if(emptiest < 0 || count < emptiest)
			emptiest = count
	bondlog("DIST|run=[label]|bonds=[total_bonds]|nodes=[length(per_node)]|per_node_avg=[length(per_node) ? round(sum / length(per_node), 0.1) : 0]|per_node_max=[widest]|per_node_min=[max(0, emptiest)]|at_cap=[widest >= BOND_MAX_PER_MIND ? "YES" : "no"]", BONDLOG_INFO)

	var/list/stage_parts = list()
	for(var/key in stages)
		stage_parts += "[key]=[stages[key]]"
	bondlog("DIST|run=[label]|stages|[stage_parts.Join("|")]", BONDLOG_INFO)
	var/applied = tallies["record.applied"] || 0
	var/evicted = tallies["cap.evicted"] || 0
	bondlog("DIST|run=[label]|churn|records=[applied]|evictions=[evicted]|evict_per_record=[applied ? round(evicted / applied, 0.001) : 0]", BONDLOG_INFO)
	bondlog("DIST|run=[label]|warmth|hostile=[warmth_buckets["hostile"]]|cold=[warmth_buckets["cold"]]|neutral=[warmth_buckets["neutral"]]|warm=[warmth_buckets["warm"]]", BONDLOG_INFO)

	var/list/tally_parts = list()
	for(var/key in tallies)
		tally_parts += "[key]=[tallies[key]]"
	if(length(tally_parts))
		bondlog("TALLY|run=[label]|phase=TOTAL|[tally_parts.Join("|")]", BONDLOG_INFO)
	return TRUE

/datum/controller/subsystem/bonds/proc/debug_graph_state()
	RETURN_TYPE(/list)
	var/bonds_total = 0
	var/kin_total = 0
	var/history_total = 0
	var/active_total = 0
	for(var/datum/bond_actor/owner as anything in nodes)
		var/datum/bond_node/node = nodes[owner]
		if(!node)
			continue
		bonds_total += length(node.bonds)
		kin_total += length(node.kin)
		for(var/datum/bond_actor/target as anything in node.bonds)
			var/datum/social_bond/bond = node.bonds[target]
			history_total += LAZYLEN(bond.history)
			active_total += LAZYLEN(bond.active_events)
	return list(
		"nodes" = length(nodes),
		"bonds" = bonds_total,
		"kin" = kin_total,
		"history" = history_total,
		"active" = active_total,
		"stances" = length(faction_stances),
		"pools" = length(influence_pools),
	)

/datum/controller/subsystem/bonds/proc/debug_job_pool()
	RETURN_TYPE(/list)
	var/list/pool = list()
	for(var/job_type in faction_index)
		pool += job_type
	return pool

/datum/controller/subsystem/bonds/proc/debug_spawn_population(count, turf/spot)
	RETURN_TYPE(/list)
	var/list/pool = list()
	var/list/job_types = debug_job_pool()
	if(!length(job_types) || !spot)
		return pool
	for(var/i in 1 to count)
		var/mob/living/carbon/human/body = new(spot)
		body.real_name = "Bench [i]"
		body.name = body.real_name
		body.ckey = "BENCH[i]"
		if(!body.mind)
			body.mind = new /datum/mind(body.ckey)
		body.mind.current = body
		body.mind.name = body.real_name
		var/job_type = job_types[((i - 1) % length(job_types)) + 1]
		var/datum/job/role = SSjob.GetJobType(job_type)
		if(role)
			body.mind.assigned_role = role.title
			body.job = role.title
		register_human(body)
		var/datum/bonds_round_prefs/prefs = new()
		prefs.ckey = body.ckey
		prefs.seed_count = BOND_MAX_SEEDS
		prefs.seed_flavors = valid_seed_flavors().Copy()
		round_prefs_by_ckey[body.ckey] = prefs
		pool += body
	return pool

/datum/controller/subsystem/bonds/proc/debug_purge_population()
	for(var/mob/living/carbon/human/body as anything in GLOB.bonds_debug_population)
		if(QDELETED(body))
			continue
		if(body.mind)
			drop_actor(resolve_actor(body.mind))
			round_prefs_by_ckey -= body.ckey
			round_ledger -= body.ckey
		qdel(body)
	GLOB.bonds_debug_population = list()

/datum/controller/subsystem/bonds/proc/debug_storm(list/pool, count, list/event_types, datum/bonds_bench/bench)
	var/fired = 0
	for(var/i in 1 to count)
		var/mob/living/carbon/human/subject = pick(pool)
		var/mob/living/carbon/human/object = pick(pool)
		if(subject == object || QDELETED(subject) || QDELETED(object))
			continue
		var/event_type = pick(event_types)
		bench?.op_begin()
		record(subject.mind, object.mind, event_type, object, TRUE)
		social_impact(subject.mind, object.mind, event_type)
		bench?.op_end()
		fired++
	return fired

/datum/controller/subsystem/bonds/proc/debug_timeskip(deciseconds)
	var/expired = 0
	for(var/datum/bond_actor/owner as anything in nodes)
		var/datum/bond_node/node = nodes[owner]
		if(!node)
			continue
		for(var/datum/bond_actor/target as anything in node.bonds)
			var/datum/social_bond/bond = node.bonds[target]
			bond.swing_reset -= deciseconds
			bond.updated_at -= deciseconds
			if(bond.commit_times)
				for(var/category in bond.commit_times)
					bond.commit_times[category] -= deciseconds
			for(var/datum/bond_history/entry as anything in bond.history)
				entry.created_at -= deciseconds
			if(LAZYLEN(bond.active_events))
				for(var/category in bond.active_events.Copy())
					var/datum/bond_event/live = bond.active_events[category]
					if(!live || live.timeout <= 0)
						continue
					if(live.timeout > deciseconds)
						continue
					if(live.timer_id)
						deltimer(live.timer_id)
						live.timer_id = null
					live.expire()
					expired++
			bond.recalculate()
	for(var/datum/bond_actor/actor as anything in influence_pools)
		var/list/state = influence_pools[actor]
		if(!islist(state))
			continue
		state["refill"] -= deciseconds
		state["banned_until"] = max(0, state["banned_until"] - deciseconds)
	return expired

/datum/controller/subsystem/bonds/proc/debug_seeding_pass(list/pool, datum/bonds_bench/bench)
	var/paired = 0
	for(var/mob/living/carbon/human/seeker as anything in pool)
		if(remaining_seeds(seeker.ckey) <= 0)
			continue
		bench?.op_begin()
		var/list/candidates = seed_candidates(seeker, pool)
		var/hit = length(candidates) ? apply_seed(seeker, pick(candidates)) : FALSE
		bench?.op_end()
		if(hit)
			paired++
	return paired

/datum/controller/subsystem/bonds/proc/debug_panel_pass(list/pool, samples, datum/bonds_bench/bench, mode = "all")
	var/built = 0
	for(var/i in 1 to samples)
		var/mob/living/carbon/human/viewer = pool[((i - 1) % length(pool)) + 1]
		bench?.op_begin()
		switch(mode)
			if("list")
				build_panel_groups(viewer)
			if("tree")
				build_bonds_tree(viewer)
			if("map")
				build_faction_map(viewer)
			else
				build_panel_groups(viewer)
				build_bonds_tree(viewer)
				build_faction_map(viewer)
		bench?.op_end()
		built++
	return built

/datum/controller/subsystem/bonds/proc/debug_dream_pass(list/pool, datum/bonds_bench/bench)
	var/rolled = 0
	for(var/mob/living/carbon/human/dreamer as anything in pool)
		if(QDELETED(dreamer))
			continue
		bench?.op_begin()
		roll_dream(dreamer)
		bench?.op_end()
		rolled++
	return rolled

/datum/controller/subsystem/bonds/proc/debug_forced_dream_pass(list/pool, datum/bonds_bench/bench)
	var/fired = 0
	for(var/mob/living/carbon/human/dreamer as anything in pool)
		if(QDELETED(dreamer))
			continue
		bench?.op_begin()
		var/hit = fire_dream(dreamer, BOND_DREAM_POSITIVE, BOND_DREAM_SCOPE_FOREIGN, TRUE)
		bench?.op_end()
		if(hit)
			fired++
	return fired

/datum/controller/subsystem/bonds/proc/debug_event_pool()
	RETURN_TYPE(/list)
	return list(
		/datum/bond_event/struck_by,
		/datum/bond_event/struck_them,
		/datum/bond_event/beaten_by,
		/datum/bond_event/embraced_by,
		/datum/bond_event/embraced_them,
	)

/client/proc/bonds_debug_load()
	set name = "Bonds Bench: Load"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	var/turf/spot = get_turf(mob)
	if(!spot)
		to_chat(src, span_warning("Нужна точка отсчёта: встаньте на турф."))
		return
	var/players = input(src, "Сколько синтетических игроков?", "Bonds Bench", 120) as num|null
	if(!players)
		return
	var/events = input(src, "Сколько событий прогнать?", "Bonds Bench", 600) as num|null
	if(isnull(events))
		return
	players = clamp(players, 2, 400)
	events = clamp(events, 0, 20000)
	var/profile = tgui_alert(mob, "Снять профиль процов? На этом сервере включён AUTO_PROFILE, и захват выпьет буфер SSprofiler.", "Bonds Bench", list("Снять", "Не трогать")) == "Снять"

	if(length(GLOB.bonds_debug_population))
		SSbonds.debug_purge_population()

	to_chat(src, span_notice("Бенчмарк запущен. Сервер будет подвисать: замеры идут без CHECK_TICK внутри фаз."))
	var/datum/bonds_bench/bench = new("load[players]", profile)

	bench.open("spawn+register")
	bench.op_begin()
	GLOB.bonds_debug_population = SSbonds.debug_spawn_population(players, spot)
	bench.op_end()
	bench.close(players)
	var/list/pool = GLOB.bonds_debug_population
	if(!length(pool))
		to_chat(src, span_warning("Не удалось создать популяцию."))
		return
	CHECK_TICK

	bench.open("seeding")
	var/paired = SSbonds.debug_seeding_pass(pool, bench)
	bench.close(length(pool))
	to_chat(src, span_notice("Сидинг связал пар: [paired]"))
	CHECK_TICK

	bench.open("events")
	var/fired = SSbonds.debug_storm(pool, events, SSbonds.debug_event_pool(), bench)
	bench.close(fired)
	CHECK_TICK

	bench.open("dreams")
	var/rolled = SSbonds.debug_dream_pass(pool, bench)
	bench.close(rolled)
	CHECK_TICK

	bench.open("dreams-forced")
	SSbonds.debug_forced_dream_pass(pool, bench)
	bench.close(length(pool))
	CHECK_TICK

	var/panel_samples = min(length(pool), 60)
	for(var/mode in list("list", "tree", "map"))
		bench.open("panels-[mode]")
		bench.close(SSbonds.debug_panel_pass(pool, panel_samples, bench, mode))

	for(var/line in bench.rows)
		to_chat(src, span_smallnotice(line))
	bench.finish()
	to_chat(src, span_notice("Готово. Отчёт в ss_bonds.log, профиль процов в bonds_profile-[bench.label].json"))

/client/proc/bonds_debug_timeskip()
	set name = "Bonds Bench: Time Skip"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	var/minutes = input(src, "На сколько минут промотать?", "Bonds Bench", 15) as num|null
	if(!minutes)
		return
	minutes = clamp(minutes, 1, 600)
	var/datum/bonds_bench/bench = new("skip[minutes]m")
	bench.open("timeskip")
	bench.op_begin()
	var/expired = SSbonds.debug_timeskip(minutes MINUTES)
	bench.op_end()
	bench.close(1)
	bench.finish()
	to_chat(src, span_notice("Промотано [minutes] мин, истекло транзиентов: [expired]"))
	to_chat(src, span_smallnotice(bench.rows[bench.rows.len]))

/client/proc/bonds_debug_degrade()
	set name = "Bonds Bench: Degradation"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	var/list/pool = GLOB.bonds_debug_population
	if(!length(pool))
		to_chat(src, span_warning("Сначала запустите Bonds Bench: Load."))
		return
	var/waves = input(src, "Сколько волн (одна волна = отрезок раунда)?", "Bonds Bench", 8) as num|null
	if(!waves)
		return
	var/events = input(src, "Событий на волну?", "Bonds Bench", 400) as num|null
	if(isnull(events))
		return
	var/minutes = input(src, "Минут на волну?", "Bonds Bench", 15) as num|null
	if(!minutes)
		return
	waves = clamp(waves, 1, 60)
	events = clamp(events, 0, 20000)
	minutes = clamp(minutes, 1, 120)
	var/profile = tgui_alert(mob, "Снять профиль процов? На этом сервере включён AUTO_PROFILE, и захват выпьет буфер SSprofiler.", "Bonds Bench", list("Снять", "Не трогать")) == "Снять"

	var/datum/bonds_bench/bench = new("degrade[waves]x[minutes]m", profile)
	var/list/event_types = SSbonds.debug_event_pool()
	for(var/wave in 1 to waves)
		bench.open("w[wave]-events")
		var/fired = SSbonds.debug_storm(pool, events, event_types, bench)
		bench.close(fired)
		CHECK_TICK

		bench.open("w[wave]-dreams")
		var/rolled = SSbonds.debug_dream_pass(pool, bench)
		bench.close(rolled)
		CHECK_TICK

		for(var/mode in list("list", "tree", "map"))
			bench.open("w[wave]-panels-[mode]")
			bench.close(SSbonds.debug_panel_pass(pool, min(length(pool), 30), bench, mode))
		CHECK_TICK

		bench.open("w[wave]-timeskip")
		bench.op_begin()
		SSbonds.debug_timeskip(minutes MINUTES)
		bench.op_end()
		bench.close(1)
		CHECK_TICK

	for(var/line in bench.rows)
		to_chat(src, span_smallnotice(line))
	bench.finish()
	to_chat(src, span_notice("Деградация за [waves * minutes] симулированных минут отработана."))

/client/proc/bonds_debug_purge()
	set name = "Bonds Bench: Purge"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	var/count = length(GLOB.bonds_debug_population)
	SSbonds.debug_purge_population()
	GLOB.bonds_debug_rows = list()
	to_chat(src, span_notice("Снесено синтетических тел: [count]"))

/client/proc/bonds_ecosystem_probe()
	set name = "Bonds: Ecosystem Probe"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return
	var/repeats = input(src, "Сколько проходов по каждому событию? Один проход открывает связь на каждое событие.", "Ecosystem Probe", 3) as num|null
	if(isnull(repeats))
		return
	repeats = clamp(round(repeats), 1, 50)

	var/datum/bond_probe/probe = new()
	probe.run_roster_sweep()
	probe.run_stance_sweep()
	probe.run_event_sweep(repeats)
	probe.run_dream_sweep()
	probe.run_deep_sweep(repeats * 4, 10)
	var/text = "[probe.report()]\n[probe.deep_report()]"
	var/faults = length(probe.violations)
	qdel(probe)

	to_chat(src, span_notice("<b>=== BONDS ECOSYSTEM PROBE ===</b><br><pre>[text]</pre>"))
	SSbonds.bondlog("ecosystem probe by [key_name(mob)]: [faults] faults", faults ? BONDLOG_ERROR : BONDLOG_INFO)
	log_admin("[key_name(mob)] ran the bonds ecosystem probe: [faults] faults")
