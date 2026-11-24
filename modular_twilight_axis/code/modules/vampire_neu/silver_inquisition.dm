SUBSYSTEM_DEF(ta_silver_inquisition)
	name = "TA Silver Inquisition"
	wait = 5 SECONDS
	runlevels = RUNLEVEL_GAME
	can_fire = FALSE
	var/list/victims = list()

/datum/controller/subsystem/ta_silver_inquisition/Initialize(timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))

/datum/controller/subsystem/ta_silver_inquisition/fire(resumed)
	if(wave_arrived())
		can_fire = FALSE
		return
	if(SSmigrants.track_forming[MIGRANT_TRACK_EVENT] || SSmigrants.get_forming_track(get_wave()))
		return
	if(wave_allowed())
		call_wave()

/datum/controller/subsystem/ta_silver_inquisition/proc/get_wave()
	RETURN_TYPE(/datum/migrant_wave)
	return MIGRANT_WAVE(/datum/migrant_wave/silver_inquisition)

/datum/controller/subsystem/ta_silver_inquisition/proc/wave_arrived()
	return SSmigrants.spawned_waves[/datum/migrant_wave/silver_inquisition] > 0

/datum/controller/subsystem/ta_silver_inquisition/proc/wave_allowed()
	return ta_vampire_lord_expansion_active() && get_active_player_count() >= TA_SILVER_INQUISITION_MIN_PLAYERS

/datum/controller/subsystem/ta_silver_inquisition/proc/on_mob_death(datum/source, mob/dead_mob, gibbed)
	SIGNAL_HANDLER
	if(can_fire || !ishuman(dead_mob) || !ta_vampire_lord_expansion_active() || wave_arrived())
		return
	var/mob/living/carbon/human/victim = dead_mob
	if(!victim.ta_damage_log || !is_counted_victim(victim))
		return
	var/victim_ckey = ckey(victim.mind.key)
	if(victim_ckey in victims)
		return
	addtimer(CALLBACK(src, PROC_REF(judge_death), victim_ckey, victim.ta_damage_log), 1)

/datum/controller/subsystem/ta_silver_inquisition/proc/judge_death(victim_ckey, list/damage_log)
	if(can_fire || (victim_ckey in victims))
		return
	var/datum/mind/killer = get_top_attacker(damage_log)
	if(!istype(killer) || !killer.has_antag_datum(/datum/antagonist/vampire))
		return
	victims += victim_ckey
	log_game("Silver Inquisition: [victim_ckey] was killed by the vampire [killer.key] ([length(victims)] total).")
	if(length(victims) <= TA_SILVER_INQUISITION_KILL_LIMIT)
		return
	can_fire = TRUE
	message_admins("Серебряная инквизиция: вампиры убили [length(victims)] игроков, отряд будет созван при онлайне от [TA_SILVER_INQUISITION_MIN_PLAYERS].")
	log_game("Silver Inquisition: kill limit exceeded, the squad is unlocked.")

/datum/controller/subsystem/ta_silver_inquisition/proc/get_top_attacker(list/damage_log)
	var/list/damage_by_attacker = list()
	for(var/list/attack as anything in damage_log)
		if(world.time <= attack["time"] + TA_SILVER_INQUISITION_KILL_WINDOW)
			damage_by_attacker[attack["attacker"]] += attack["damage"]
	var/datum/weakref/top_attacker
	for(var/datum/weakref/attacker as anything in damage_by_attacker)
		if(!top_attacker || damage_by_attacker[attacker] > damage_by_attacker[top_attacker])
			top_attacker = attacker
	return top_attacker?.resolve()

/datum/controller/subsystem/ta_silver_inquisition/proc/is_counted_victim(mob/living/carbon/human/victim)
	var/datum/mind/victim_mind = victim.mind
	if(!victim_mind?.key || victim_mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	var/datum/antagonist/zombie/deadite = victim_mind.has_antag_datum(/datum/antagonist/zombie)
	if(deadite?.has_turned)
		return FALSE
	var/datum/job/victim_job = ta_get_assigned_job_datum(victim_mind)
	return victim_job && (victim_job.title in get_counted_jobs())

/datum/controller/subsystem/ta_silver_inquisition/proc/get_counted_jobs()
	var/static/list/counted_jobs
	if(!counted_jobs)
		counted_jobs = list("Adventurer", "Court Agent", "Veteran")
		counted_jobs |= GLOB.noble_positions
		counted_jobs |= GLOB.courtier_positions
		counted_jobs |= GLOB.retinue_positions
		counted_jobs |= GLOB.garrison_positions
		counted_jobs |= GLOB.citywatch_positions
		counted_jobs |= GLOB.vanguard_positions
		counted_jobs |= GLOB.church_positions
		counted_jobs |= GLOB.inquisition_positions
		counted_jobs |= GLOB.burgher_positions
		counted_jobs |= GLOB.atc_positions
		counted_jobs |= GLOB.peasant_positions
	return counted_jobs

/datum/controller/subsystem/ta_silver_inquisition/proc/call_wave()
	if(!SSmigrants.begin_forming(MIGRANT_TRACK_EVENT, /datum/migrant_wave/silver_inquisition, TRUE))
		return
	SSmigrants.track_arrival[MIGRANT_TRACK_EVENT] = world.time + TA_SILVER_INQUISITION_WAVE_TIME
	message_admins("Серебряная инквизиция: отряд созван, сбор [TA_SILVER_INQUISITION_WAVE_TIME / (1 MINUTES)] мин.")
	announce_wave()

/datum/controller/subsystem/ta_silver_inquisition/proc/hold_wave(track)
	if(!wave_allowed())
		cancel_wave(track)
		return TRUE
	var/list/candidates = SSmigrants.get_wave_candidates(/datum/migrant_wave/silver_inquisition)
	if(length(candidates) && !isnull(SSmigrants.assemble_role_wave(get_wave(), candidates, list())))
		return FALSE
	SSmigrants.track_arrival[track] = world.time + TA_SILVER_INQUISITION_WAVE_TIME
	log_game("Silver Inquisition: the squad failed to gather, calling it again.")
	announce_wave()
	return TRUE

/datum/controller/subsystem/ta_silver_inquisition/proc/cancel_wave(track)
	SSmigrants.track_forming[track] = null
	SSmigrants.track_arrival[track] = 0
	SSmigrants.track_forced[track] = FALSE
	for(var/client/candidate as anything in SSmigrants.get_wave_candidates(/datum/migrant_wave/silver_inquisition))
		to_chat(candidate, span_boldwarning("В этих землях осталось слишком мало душ, сбор отряда отложен."))
	SSmigrants.reset_wave_queue(/datum/migrant_wave/silver_inquisition)
	log_game("Silver Inquisition: the gathering is postponed, conditions are no longer met.")

/datum/controller/subsystem/ta_silver_inquisition/proc/announce_wave()
	var/datum/migrant_wave/wave = get_wave()
	var/required_amount = 0
	for(var/role_type in wave.required_roles)
		required_amount += wave.required_roles[role_type]
	var/announcement = "<b>Серебряная инквизиция собирает отряд, чтобы очистить эти земли от вампиров.</b><br>Мест в отряде: [wave.get_roles_amount()], для выступления нужно не меньше [required_amount]. Сбор продлится [TA_SILVER_INQUISITION_WAVE_TIME / (1 MINUTES)] мин."
	var/lobby_hint = "<a href='?src=[REF(SSmigrants)];open_panel=1'>Записаться в отряд</a>"
	var/ghost_hint = "Чтобы вступить, вернитесь в лобби и запишитесь в панели мигрантов."
	var/sound/bell = sound('sound/misc/bell.ogg', volume = 80)
	for(var/mob/listener as anything in GLOB.player_list)
		if(!listener.client || isscryeye(listener))
			continue
		if(!isdead(listener) && listener.stat != DEAD && !istype(listener, /mob/living/carbon/spirit))
			continue
		to_chat(listener, "<br><font color='purple'>[announcement]<br>[isnewplayer(listener) ? lobby_hint : ghost_hint]</font>")
		SEND_SOUND(listener, bell)
		window_flash(listener.client)

/datum/controller/subsystem/migrants/resolve_forming_wave(track)
	if(SSta_silver_inquisition.can_fire && track_forming[track] == /datum/migrant_wave/silver_inquisition && SSta_silver_inquisition.hold_wave(track))
		return
	return ..()

/mob/living/proc/ta_note_attacker(mob/living/attacker)
	lastattacker = attacker.real_name
	lastattackerckey = attacker.ckey
	lastattacker_weakref = WEAKREF(attacker)
	if(mind)
		mind.attackedme[attacker.real_name] = world.time

/mob/living/carbon/human
	var/tmp/list/ta_damage_log

/mob/living/carbon/human/proc/ta_log_damage(mob/living/attacker, damage)
	if(damage <= 0 || !mind || !istype(attacker) || attacker == src || !ta_vampire_lord_expansion_active())
		return
	var/datum/attacker_identity = attacker.mind || attacker
	LAZYINITLIST(ta_damage_log)
	ta_damage_log += list(list("attacker" = WEAKREF(attacker_identity), "damage" = damage, "time" = world.time))
	if(length(ta_damage_log) > TA_SILVER_INQUISITION_LOG_SIZE)
		ta_damage_log.Cut(1, 2)

/mob/living/carbon/human/proc/ta_get_current_attacker()
	if(!mind || !lastattacker || world.time > mind.attackedme[lastattacker] + TA_SILVER_INQUISITION_HIT_WINDOW)
		return null
	return lastattacker_weakref?.resolve()

/mob/living/carbon/human/proc/ta_get_health_damage()
	return getBruteLoss() + getFireLoss() + getToxLoss() + getOxyLoss() + getCloneLoss()

/datum/species/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/victim, forced = FALSE, spread_damage = FALSE)
	if(!victim.mind || !ta_vampire_lord_expansion_active())
		return ..()
	var/mob/living/attacker = victim.ta_get_current_attacker()
	if(!attacker)
		return ..()
	LAZYINITLIST(victim.ta_damage_log)
	var/damage_before = victim.ta_get_health_damage()
	. = ..()
	victim.ta_log_damage(attacker, victim.ta_get_health_damage() - damage_before)

/mob/living/carbon/human/bullet_act(obj/projectile/hit_projectile, def_zone = BODY_ZONE_CHEST)
	var/mob/living/shooter = hit_projectile?.firer
	if(istype(shooter) && shooter != src)
		ta_note_attacker(shooter)
	return ..()

/mob/living/carbon/human/hitby(atom/movable/thrown_thing, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	var/mob/living/thrower = throwingdatum?.thrower
	if(istype(thrower) && thrower != src)
		ta_note_attacker(thrower)
	return ..()

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/animal)
	if(istype(animal) && animal.melee_damage_upper > 0)
		ta_note_attacker(animal)
	return ..()
