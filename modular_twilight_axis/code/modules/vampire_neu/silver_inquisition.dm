SUBSYSTEM_DEF(ta_silver_inquisition)
	name = "TA Silver Inquisition"
	wait = 5 SECONDS
	runlevels = RUNLEVEL_GAME
	can_fire = FALSE
	var/gathering = FALSE
	var/list/victims = list()

/datum/controller/subsystem/ta_silver_inquisition/Initialize(timeofday)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))

/datum/controller/subsystem/ta_silver_inquisition/fire(resumed)
	if(wave_arrived())
		can_fire = FALSE
		gathering = FALSE
		return
	drop_stale_queue()
	if(SSmigrants.track_forming[MIGRANT_TRACK_EVENT] || SSmigrants.get_forming_track(get_wave()))
		return
	gathering = FALSE
	if(wave_allowed())
		call_wave()

/datum/controller/subsystem/ta_silver_inquisition/proc/get_wave()
	RETURN_TYPE(/datum/migrant_wave)
	return MIGRANT_WAVE(/datum/migrant_wave/silver_inquisition)

/datum/controller/subsystem/ta_silver_inquisition/proc/wave_arrived()
	return SSmigrants.spawned_waves[/datum/migrant_wave/silver_inquisition] > 0

/datum/controller/subsystem/ta_silver_inquisition/proc/wave_allowed()
	return ta_vampire_lord_expansion_active() && length(GLOB.clients) >= TA_SILVER_INQUISITION_MIN_PLAYERS

/datum/controller/subsystem/ta_silver_inquisition/proc/on_mob_death(datum/source, mob/dead_mob, gibbed)
	SIGNAL_HANDLER
	if(can_fire || !ishuman(dead_mob) || !ta_vampire_lord_expansion_active() || wave_arrived())
		return
	var/mob/living/carbon/human/victim = dead_mob
	if(!is_counted_victim(victim))
		return
	var/victim_ckey = ckey(victim.mind.key)
	if(victim_ckey in victims)
		return
	LAZYINITLIST(victim.ta_damage_log)
	addtimer(CALLBACK(src, PROC_REF(judge_death), victim_ckey, victim.ta_damage_log, WEAKREF(victim)), 1)

/datum/controller/subsystem/ta_silver_inquisition/proc/judge_death(victim_ckey, list/damage_log, datum/weakref/body_ref)
	var/datum/mind/killer = get_top_attacker(damage_log)
	if(!istype(killer) || !killer.has_antag_datum(/datum/antagonist/vampire))
		return
	var/mob/living/body = body_ref?.resolve()
	addtimer(CALLBACK(src, PROC_REF(count_death), victim_ckey, killer.key, body_ref, body?.timeofdeath), TA_SILVER_INQUISITION_CONFIRM_TIME)

/datum/controller/subsystem/ta_silver_inquisition/proc/count_death(victim_ckey, killer_key, datum/weakref/body_ref, death_time)
	if(can_fire || wave_arrived() || (victim_ckey in victims))
		return
	var/mob/living/body = body_ref?.resolve()
	if(body && (body.stat != DEAD || body.timeofdeath != death_time))
		return
	victims += victim_ckey
	log_game("Silver Inquisition: [victim_ckey] was killed by the vampire [killer_key] ([length(victims)] total).")
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
	if(istype(deadite) && deadite.has_turned)
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
	gathering = TRUE
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

/datum/controller/subsystem/ta_silver_inquisition/proc/release_track(track)
	gathering = FALSE
	SSmigrants.track_forming[track] = null
	SSmigrants.track_arrival[track] = 0
	SSmigrants.track_forced[track] = FALSE

/datum/controller/subsystem/ta_silver_inquisition/proc/is_gathering_on(track)
	return gathering && SSmigrants.track_forming[track] == /datum/migrant_wave/silver_inquisition

/datum/controller/subsystem/ta_silver_inquisition/proc/yield_track(track)
	if(!is_gathering_on(track))
		return
	release_track(track)
	for(var/client/candidate as anything in SSmigrants.get_wave_candidates(/datum/migrant_wave/silver_inquisition))
		to_chat(candidate, span_boldwarning("Дорогу занял другой отряд. Сбор инквизиции продолжится следом, моя запись сохранена."))
	log_game("Silver Inquisition: the gathering yields the event track.")

/datum/controller/subsystem/ta_silver_inquisition/proc/drop_stale_queue()
	for(var/client/player in GLOB.clients)
		var/datum/migrant_pref/migrant = player.prefs?.migrant
		if(migrant?.queued_wave == /datum/migrant_wave/silver_inquisition && player.mob && !isnewplayer(player.mob))
			migrant.clear_queue(silent = TRUE)

/datum/controller/subsystem/ta_silver_inquisition/proc/cancel_wave(track)
	release_track(track)
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
	if(SSta_silver_inquisition.is_gathering_on(track) && SSta_silver_inquisition.hold_wave(track))
		return
	return ..()

/datum/round_event/migrant_wave/start()
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	if(wave && !SSmigrants.get_forming_track(wave))
		SSta_silver_inquisition.yield_track(MIGRANT_TRACK_EVENT)
	return ..()

/datum/controller/subsystem/migrants
	var/list/ta_cooldown_exempt = list()

/datum/controller/subsystem/migrants/get_respawn_cooldown_remaining(client/player)
	if(player && ta_cooldown_exempt[player.ckey])
		return 0
	return ..()

/datum/controller/subsystem/migrants/can_be_role(client/player, role_type)
	if(!player || !ispath(role_type, /datum/migrant_role/silver_inquisitor))
		return ..()
	if(ta_has_banned_flaw(player, role_type))
		return FALSE
	var/player_ckey = player.ckey
	ta_cooldown_exempt[player_ckey]++
	. = ..()
	ta_cooldown_exempt[player_ckey]--

/datum/controller/subsystem/migrants/proc/ta_has_banned_flaw(client/player, role_type)
	var/datum/migrant_role/role = MIGRANT_ROLE(role_type)
	for(var/flaw in player.prefs?.charflaws)
		var/datum/charflaw/flaw_instance = flaw
		var/flaw_type = ispath(flaw) ? flaw : flaw_instance.type
		if(flaw_type in role.banned_flaws)
			return TRUE
	return FALSE

/datum/migrant_pref/queue_for(wave_type, role_type)
	if(!prefs.parent || wave_type != /datum/migrant_wave/silver_inquisition)
		return ..()
	var/player_ckey = prefs.parent.ckey
	SSmigrants.ta_cooldown_exempt[player_ckey]++
	. = ..()
	SSmigrants.ta_cooldown_exempt[player_ckey]--

/mob/living/carbon/human
	var/tmp/list/ta_damage_log
	var/tmp/datum/weakref/ta_attacker_ref
	var/tmp/ta_attacker_time = 0

/mob/living/carbon/human/proc/ta_note_attacker(mob/living/attacker)
	if(!mind || !istype(attacker) || attacker == src || !ta_vampire_lord_expansion_active())
		return
	ta_attacker_ref = WEAKREF(attacker)
	ta_attacker_time = world.time

/mob/living/carbon/human/proc/ta_get_current_attacker()
	if(!mind)
		return null
	var/struck_time = lastattacker ? mind.attackedme[lastattacker] : 0
	var/datum/weakref/attacker_ref = lastattacker_weakref
	if(ta_attacker_time >= struck_time)
		struck_time = ta_attacker_time
		attacker_ref = ta_attacker_ref
	if(world.time > struck_time + TA_SILVER_INQUISITION_HIT_WINDOW)
		return null
	return attacker_ref?.resolve()

/mob/living/carbon/human/proc/ta_log_damage(mob/living/attacker, damage)
	if(damage <= 0 || !mind || !istype(attacker) || attacker == src || !ta_vampire_lord_expansion_active())
		return
	var/datum/attacker_identity = attacker.mind || attacker
	LAZYINITLIST(ta_damage_log)
	ta_damage_log += list(list("attacker" = WEAKREF(attacker_identity), "damage" = damage, "time" = world.time))
	if(length(ta_damage_log) > TA_SILVER_INQUISITION_LOG_SIZE)
		ta_damage_log.Cut(1, 2)

/mob/living/carbon/human/proc/ta_get_health_damage()
	return getBruteLoss() + getFireLoss() + getToxLoss() + getOxyLoss() + getCloneLoss()

/datum/species/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/victim, forced = FALSE, spread_damage = FALSE)
	if(!victim.mind || !ta_vampire_lord_expansion_active())
		return ..()
	var/mob/living/attacker = victim.ta_get_current_attacker()
	if(!attacker)
		return ..()
	var/damage_before = victim.ta_get_health_damage()
	. = ..()
	victim.ta_log_damage(attacker, victim.ta_get_health_damage() - damage_before)

/mob/living/carbon/human/revive(full_heal, admin_revive)
	. = ..()
	if(.)
		ta_damage_log = null

/mob/living/carbon/human/do_attack_animation(atom/target, visual_effect_icon, obj/item/used_item, no_effect, item_animation_override, datum/intent/used_intent, simplified)
	var/mob/living/carbon/human/victim = target
	if(istype(victim))
		victim.ta_note_attacker(src)
	return ..()

/mob/living/carbon/human/attack_hand(mob/user)
	ta_note_attacker(user)
	return ..()

/mob/living/carbon/human/onbite(mob/living/carbon/human/user)
	ta_note_attacker(user)
	return ..()

/datum/species/kicked(mob/living/carbon/human/user, mob/living/carbon/human/target)
	target.ta_note_attacker(user)
	return ..()

/mob/living/carbon/human/attacked_by(obj/item/weapon, mob/living/user)
	ta_note_attacker(user)
	return ..()

/mob/living/carbon/human/bullet_act(obj/projectile/hit_projectile, def_zone = BODY_ZONE_CHEST)
	ta_note_attacker(hit_projectile?.firer)
	return ..()

/mob/living/carbon/human/hitby(atom/movable/thrown_thing, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	ta_note_attacker(throwingdatum?.thrower)
	return ..()

/mob/living/carbon/human/check_shields(atom/attacker, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armor_penetration = 0)
	ta_note_attacker(attacker)
	return ..()

/obj/item/grabbing/proc/ta_note_grabber(mob/living/user)
	var/mob/living/carbon/human/victim = grabbed
	if(istype(victim))
		victim.ta_note_attacker(user)

/obj/item/grabbing/twistlimb(mob/living/user)
	ta_note_grabber(user)
	return ..()

/obj/item/grabbing/smashlimb(atom/surface, mob/living/user)
	ta_note_grabber(user)
	return ..()

/obj/item/grabbing/headbutt(mob/living/carbon/human/user)
	ta_note_grabber(user)
	return ..()

/obj/item/grabbing/twistitemlimb(mob/living/user)
	ta_note_grabber(user)
	return ..()

/obj/item/grabbing/bite/bitelimb(mob/living/carbon/human/user)
	ta_note_grabber(user)
	return ..()

/obj/item/grabbing/attack(mob/living/victim, mob/living/user)
	var/mob/living/carbon/human/choked = victim
	if(!istype(choked) || user?.used_intent?.type != /datum/intent/grab/choke)
		return ..()
	var/suffocation_before = choked.getOxyLoss()
	. = ..()
	if(!QDELETED(choked))
		choked.ta_log_damage(user, choked.getOxyLoss() - suffocation_before)

/datum/coven_power/activate(atom/target)
	var/mob/living/carbon/human/victim = target
	if(istype(victim))
		victim.ta_note_attacker(owner)
	return ..()

/datum/coven_power/siren/shattering_crescendo/activate()
	for(var/mob/living/carbon/human/listener in oviewers(7, owner))
		if(listener.clan != owner.clan)
			listener.ta_note_attacker(owner)
	return ..()
