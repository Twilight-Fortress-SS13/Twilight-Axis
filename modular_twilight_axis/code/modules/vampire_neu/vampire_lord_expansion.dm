#define VAMPIRE_LORD (1<<11)

#define VL_MAP_NAME "Dun World"
#define VL_LORD_PQ 60
#define VL_KNIGHT_PQ 30
#define VL_SERVANT_PQ 10
#define VL_KNIGHT_SLOTS 2
#define VL_SERVANT_SLOTS 4
#define VL_AUTO_KNIGHT_SLOTS 1
#define VL_AUTO_SERVANT_SLOTS 2
#define VL_AUTO_CHANCE 25
#define VL_AUTO_ROLL_DELAY (2 SECONDS)
#define VL_WARD_TICK (5 SECONDS)
#define VL_WARD_ESCALATE_AFTER (20 SECONDS)
#define VL_WARD_STACKS_EARLY 1
#define VL_WARD_STACKS_LATE 3
#define VL_WARD_SOURCE "ta_astrata_ward"
#define VL_MANOR_SOURCE "ta_manor_shelter"
#define VL_WARD_WARNING "Астрата хранит покой этого города, уходи!"
#define VL_ASCENSION_LOCK_DELAY (1 MINUTES)

GLOBAL_VAR_INIT(ta_vampire_lord_expansion, FALSE)
GLOBAL_VAR_INIT(ta_vampire_lord_auto_event, FALSE)
GLOBAL_VAR_INIT(ta_vampire_lord_taken, FALSE)
GLOBAL_VAR_INIT(ta_vampire_knights_taken, 0)
GLOBAL_VAR_INIT(ta_vampire_servants_taken, 0)
GLOBAL_VAR_INIT(ta_vampire_wretch_slots_refunded, FALSE)
GLOBAL_VAR_INIT(ta_storyteller_vampire_lord, FALSE)
GLOBAL_VAR_INIT(ta_vampire_lord_ascension_locked, FALSE)

SUBSYSTEM_DEF(ta_vampire_lord_expansion)
	name = "TA Vampire Lord Expansion"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT
	var/auto_attempted = FALSE

/datum/controller/subsystem/ta_vampire_lord_expansion/Initialize(timeofday)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(schedule_ascension_lock)))

/datum/controller/subsystem/ta_vampire_lord_expansion/proc/schedule_ascension_lock()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ta_lock_vampire_lord_ascension)), VL_ASCENSION_LOCK_DELAY)
	addtimer(CALLBACK(src, PROC_REF(attempt_auto_expansion)), VL_AUTO_ROLL_DELAY)

/datum/controller/subsystem/ta_vampire_lord_expansion/proc/attempt_auto_expansion()
	if(auto_attempted)
		return
	if(!SSticker.HasRoundStarted())
		addtimer(CALLBACK(src, PROC_REF(attempt_auto_expansion)), 1 SECONDS)
		return
	auto_attempted = TRUE

	if(GLOB.ta_vampire_lord_expansion || GLOB.ta_vampire_lord_taken)
		return
	if(!ta_vampire_lord_expansion_allowed())
		return
	if(!length(GLOB.vlord_starts))
		log_storyteller("Vampire Lord Expansion auto-event skipped: no vampire lord landmark on the map.")
		return
	if(SSgamemode.halted_storyteller || SSgamemode.current_storyteller?.disable_distribution)
		log_storyteller("Vampire Lord Expansion auto-event skipped: storyteller distribution is halted.")
		return
	if(SSgamemode.storyteller_is(/datum/storyteller/gamemode/extended, TRUE))
		log_storyteller("Vampire Lord Expansion auto-event skipped: Extended is active.")
		return
	if(istype(SSgamemode.current_roundstart_event, /datum/round_event_control/antagonist/solo/vampires))
		log_storyteller("Vampire Lord Expansion auto-event skipped: the storyteller already rolled the Vampire Lord.")
		return
	if(!prob(VL_AUTO_CHANCE))
		log_storyteller("Vampire Lord Expansion auto-event skipped: failed the [VL_AUTO_CHANCE]% roll.")
		return

	ta_set_vampire_lord_expansion(TRUE, TRUE)
	message_admins("STORYTELLER: Vampire Lord Expansion самостоятельно открылся (прошёл [VL_AUTO_CHANCE]% ролл). Свита урезана: [VL_AUTO_KNIGHT_SLOTS] рыцарь, [VL_AUTO_SERVANT_SLOTS] слуги.")
	log_storyteller("Vampire Lord Expansion auto-event triggered (passed the [VL_AUTO_CHANCE]% roll), reduced retinue [VL_AUTO_KNIGHT_SLOTS]/[VL_AUTO_SERVANT_SLOTS].")

/proc/ta_lock_vampire_lord_ascension()
	GLOB.ta_vampire_lord_ascension_locked = TRUE

/proc/ta_vampire_lord_expansion_allowed()
	return SSmapping.config?.map_name == VL_MAP_NAME

/proc/ta_vampire_lord_ascension()
	return GLOB.ta_storyteller_vampire_lord

/datum/round_event/antagonist/solo/vampire/start()
	if(!GLOB.ta_vampire_lord_ascension_locked)
		GLOB.ta_storyteller_vampire_lord = TRUE
	. = ..()
	ta_refresh_vampire_zone_watches()

/world/AVerbsAdmin()
	. = ..()
	. += /client/proc/toggle_vampire_lord_expansion

/proc/ta_vampire_lord_spawn_turf()
	if(!length(GLOB.vlord_starts))
		return null
	return pick(GLOB.vlord_starts)

/proc/ta_get_vampire_lord_body()
	for(var/datum/antagonist/vampire/lord/methuselah in GLOB.antagonists)
		var/mob/living/carbon/human/lord_body = methuselah.owner?.current
		if(!istype(lord_body) || QDELETED(lord_body) || lord_body.stat == DEAD)
			continue
		return lord_body
	return null

/proc/ta_in_vampire_lord_clan(mob/living/carbon/human/target, mob/living/carbon/human/lord_body)
	if(!istype(target) || !istype(lord_body))
		return FALSE
	if(target == lord_body)
		return TRUE
	var/datum/clan_hierarchy_node/lord_node = lord_body.clan_position
	var/datum/clan_hierarchy_node/target_node = target.clan_position
	if(!lord_node || !target_node)
		return FALSE
	if(target_node == lord_node)
		return TRUE
	return (lord_node in target_node.get_all_superiors())

GLOBAL_LIST_INIT(ta_astrata_extra_wards, typecacheof(list(
	/area/rogue/indoors/inq/chapel,
	/area/rogue/druidsgrove,
)))

/proc/ta_in_astrata_ward_zone(mob/living/carbon/human/target)
	if(is_in_roguetown(target))
		return TRUE
	var/area/current_area = get_area(target)
	return current_area && is_type_in_typecache(current_area.type, GLOB.ta_astrata_extra_wards)

/proc/ta_astrata_ward_applies(mob/living/carbon/human/target)
	if(!istype(target) || QDELETED(target) || target.stat == DEAD)
		return FALSE
	if(ta_vampire_lord_ascension())
		return FALSE
	if(!target.mind?.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(target.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		return TRUE
	return ta_in_vampire_lord_clan(target, ta_get_vampire_lord_body())

/proc/ta_assign_vampire_lord_subordinate(mob/living/carbon/human/member, position_name)
	if(!istype(member) || member.clan_position)
		return
	var/mob/living/carbon/human/lord_body = ta_get_vampire_lord_body()
	if(!istype(lord_body) || !lord_body.clan || member.clan != lord_body.clan)
		return
	var/datum/clan_hierarchy_node/lord_node = lord_body.clan_position
	if(!lord_node)
		return
	var/datum/clan/lord_clan = lord_body.clan
	var/datum/clan_hierarchy_node/new_position = lord_clan.create_position(position_name, "Служит владыке клана напрямую.", lord_node, 1)
	if(!new_position)
		return
	new_position.assign_member(member)


/datum/status_effect/vampire_spawn_protection/ta_manor
	id = "ta_manor_shelter"
	duration = -1
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/vampire_spawn_protection/ta_manor

/atom/movable/screen/alert/status_effect/buff/vampire_spawn_protection/ta_manor
	name = "Тень поместья"
	desc = "Стены родового поместья укрывают меня от взора Солнца-Тирана. Пока я здесь, Её свет мне не страшен."

/datum/status_effect/vampire_spawn_protection/ta_manor/on_apply()
	ADD_TRAIT(owner, TRAIT_VAMPIRE_SPAWN_PROTECTION, VL_MANOR_SOURCE)
	return TRUE

/datum/status_effect/vampire_spawn_protection/ta_manor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_VAMPIRE_SPAWN_PROTECTION, VL_MANOR_SOURCE)


/datum/component/ta_vampire_zone_watch
	var/ward_timer
	var/ward_started_at = 0
	var/warded = FALSE
	var/sheltered = FALSE

/datum/component/ta_vampire_zone_watch/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ENTER_AREA, PROC_REF(on_area_change))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/ta_vampire_zone_watch/Destroy()
	var/mob/living/carbon/human/vampire = parent
	if(!ishuman(vampire))
		vampire = null
	stop_ward(vampire)
	drop_shelter(vampire)
	return ..()

/datum/component/ta_vampire_zone_watch/proc/on_area_change(datum/source)
	SIGNAL_HANDLER
	evaluate()

/datum/component/ta_vampire_zone_watch/proc/on_death(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/vampire = parent
	stop_ward(ishuman(vampire) ? vampire : null)

/datum/component/ta_vampire_zone_watch/proc/evaluate()
	var/mob/living/carbon/human/vampire = parent
	if(!ishuman(vampire) || QDELETED(vampire))
		return
	update_shelter(vampire)
	update_ward(vampire)

/datum/component/ta_vampire_zone_watch/proc/update_shelter(mob/living/carbon/human/vampire)
	var/in_manor = istype(get_area(vampire), /area/rogue/indoors/vampire_manor)
	if(in_manor == sheltered)
		return
	if(in_manor)
		sheltered = TRUE
		vampire.apply_status_effect(/datum/status_effect/vampire_spawn_protection/ta_manor)
		to_chat(vampire, span_notice("Тени поместья смыкаются надо мной. Солнце меня здесь не достанет."))
		return
	drop_shelter(vampire)

/datum/component/ta_vampire_zone_watch/proc/drop_shelter(mob/living/carbon/human/vampire)
	if(!sheltered)
		return
	sheltered = FALSE
	if(!vampire || QDELETED(vampire))
		return
	vampire.remove_status_effect(/datum/status_effect/vampire_spawn_protection/ta_manor)

/datum/component/ta_vampire_zone_watch/proc/update_ward(mob/living/carbon/human/vampire)
	var/should_burn = ta_in_astrata_ward_zone(vampire) && ta_astrata_ward_applies(vampire)
	if(should_burn == warded)
		return
	if(!should_burn)
		stop_ward(vampire)
		return
	warded = TRUE
	ward_started_at = world.time
	ADD_TRAIT(vampire, TRAIT_NO_EXTINGUISH, VL_WARD_SOURCE)
	schedule_ward_tick()
	to_chat(vampire, span_userdanger(VL_WARD_WARNING))

/datum/component/ta_vampire_zone_watch/proc/schedule_ward_tick()
	ward_timer = addtimer(CALLBACK(src, PROC_REF(ward_tick)), VL_WARD_TICK, TIMER_STOPPABLE)

/datum/component/ta_vampire_zone_watch/proc/stop_ward(mob/living/carbon/human/vampire)
	warded = FALSE
	ward_started_at = 0
	if(ward_timer)
		deltimer(ward_timer)
		ward_timer = null
	if(vampire && !QDELETED(vampire))
		REMOVE_TRAIT(vampire, TRAIT_NO_EXTINGUISH, VL_WARD_SOURCE)

/datum/component/ta_vampire_zone_watch/proc/ward_tick()
	ward_timer = null
	var/mob/living/carbon/human/vampire = parent
	if(!ishuman(vampire) || QDELETED(vampire) || vampire.stat == DEAD)
		stop_ward(ishuman(vampire) ? vampire : null)
		return
	if(!ta_in_astrata_ward_zone(vampire) || !ta_astrata_ward_applies(vampire))
		stop_ward(vampire)
		return
	to_chat(vampire, span_userdanger(VL_WARD_WARNING))
	var/stacks = ((world.time - ward_started_at) > VL_WARD_ESCALATE_AFTER) ? VL_WARD_STACKS_LATE : VL_WARD_STACKS_EARLY
	vampire.adjust_fire_stacks(stacks, /datum/status_effect/fire_handler/fire_stacks/sunder)
	vampire.ignite_mob()
	schedule_ward_tick()


/proc/ta_sync_vampire_zone_watch(mob/living/carbon/human/vampire)
	if(!istype(vampire) || QDELETED(vampire))
		return
	var/datum/component/ta_vampire_zone_watch/watch = vampire.GetComponent(/datum/component/ta_vampire_zone_watch)
	if(!vampire.mind?.has_antag_datum(/datum/antagonist/vampire))
		if(watch)
			qdel(watch)
		return
	if(!watch)
		watch = vampire.AddComponent(/datum/component/ta_vampire_zone_watch)
	watch?.evaluate()

/proc/ta_refresh_vampire_zone_watches()
	var/list/vampire_minds = SSmapping?.retainer?.vampires
	if(!islist(vampire_minds))
		return
	for(var/datum/mind/vampire_mind in vampire_minds)
		ta_sync_vampire_zone_watch(vampire_mind.current)

/mob/living/carbon/human/set_clan(setting_clan, joining_round)
	. = ..()
	ta_sync_vampire_zone_watch(src)

/mob/living/carbon/human/set_clan_direct(datum/clan/new_clan)
	. = ..()
	ta_sync_vampire_zone_watch(src)

/datum/antagonist/vampire/lord/on_gain()
	. = ..()
	ta_refresh_vampire_zone_watches()


/proc/ta_set_vampire_lord_expansion(enabled, auto = FALSE)
	if(enabled && !ta_vampire_lord_expansion_allowed())
		return
	GLOB.ta_vampire_lord_expansion = enabled
	GLOB.ta_vampire_lord_auto_event = enabled ? auto : FALSE
	var/datum/job/lord_job = SSjob.GetJob("Vampire Lord")
	if(lord_job)
		lord_job.total_positions = (enabled && !GLOB.ta_vampire_lord_taken) ? (lord_job.current_positions + 1) : 0
	if(!enabled)
		ta_vampire_lord_expansion_close_retinue()
	else if(GLOB.ta_vampire_lord_taken)
		ta_vampire_lord_expansion_open_retinue()
	ta_refresh_vampire_zone_watches()

/proc/ta_vampire_lord_is_sole_major_antag()
	var/found_lord = FALSE
	for(var/datum/antagonist/antag as anything in GLOB.antagonists)
		if(QDELETED(antag) || QDELETED(antag.owner))
			continue
		if(istype(antag, /datum/antagonist/vampire/lord))
			found_lord = TRUE
			continue
		if(istype(antag, /datum/antagonist/lich) || istype(antag, /datum/antagonist/bandit))
			return FALSE
	return found_lord

/proc/ta_vampire_lord_blocked_wretch_slots()
	if(!GLOB.ta_vampire_lord_taken || ta_vampire_lord_ascension())
		return 0
	if(!ta_vampire_lord_is_sole_major_antag())
		return 0
	var/list/scaling = calculate_wretch_scaling()
	if(!scaling["major_antag_active"])
		return 0
	var/cap = scaling["cap"]
	var/tier1 = scaling["tier1_slots"]
	if(tier1 < 10 || cap <= 10)
		return 0
	return min(max(0, scaling["combat_total"] - 10), 5, cap - tier1)

/proc/ta_restore_stolen_wretch_slots()
	if(GLOB.ta_vampire_wretch_slots_refunded)
		return
	var/datum/job/wretch_job = SSjob.GetJob("Wretch")
	if(!wretch_job || wretch_job.admin_slot_override)
		return
	var/refund = ta_vampire_lord_blocked_wretch_slots()
	if(refund <= 0)
		return
	GLOB.ta_vampire_wretch_slots_refunded = TRUE
	var/list/scaling = calculate_wretch_scaling()
	wretch_job.total_positions = max(wretch_job.current_positions, max(0, scaling["final_slots"]) + refund)
	wretch_job.spawn_positions = wretch_job.total_positions
	wretch_job.admin_slot_override = TRUE
	log_game("Vampire Lord Expansion: returned [refund] Wretch slot(s) blocked by the expansion lord (now [wretch_job.total_positions]).")

/proc/ta_vampire_lord_expansion_open_retinue()
	if(!GLOB.ta_vampire_lord_expansion || !GLOB.ta_vampire_lord_taken)
		return
	var/knight_limit = GLOB.ta_vampire_lord_auto_event ? VL_AUTO_KNIGHT_SLOTS : VL_KNIGHT_SLOTS
	var/servant_limit = GLOB.ta_vampire_lord_auto_event ? VL_AUTO_SERVANT_SLOTS : VL_SERVANT_SLOTS
	var/datum/job/knight_job = SSjob.GetJob("Vampire Guard")
	if(knight_job)
		knight_job.total_positions = knight_job.current_positions + max(0, knight_limit - GLOB.ta_vampire_knights_taken)
		knight_job.min_pq = VL_KNIGHT_PQ
	var/datum/job/servant_job = SSjob.GetJob("Vampire Servant")
	if(servant_job)
		servant_job.total_positions = servant_job.current_positions + max(0, servant_limit - GLOB.ta_vampire_servants_taken)
		servant_job.min_pq = VL_SERVANT_PQ
	ta_restore_stolen_wretch_slots()

/proc/ta_vampire_lord_expansion_close_retinue()
	var/datum/job/knight_job = SSjob.GetJob("Vampire Guard")
	if(knight_job)
		knight_job.total_positions = 0
		knight_job.min_pq = initial(knight_job.min_pq)
	var/datum/job/servant_job = SSjob.GetJob("Vampire Servant")
	if(servant_job)
		servant_job.total_positions = 0
		servant_job.min_pq = initial(servant_job.min_pq)

/proc/ta_vampire_lord_expansion_setup_lord(mob/living/carbon/human/lord_body)
	if(!GLOB.ta_vampire_lord_expansion)
		return FALSE
	if(!istype(lord_body) || !lord_body.mind)
		return FALSE
	var/turf/spawn_turf = ta_vampire_lord_spawn_turf()
	if(!spawn_turf)
		message_admins("Vampire Lord Expansion: на карте нет стартовой точки вампир-лорда, роль отменена для [key_name(lord_body)].")
		log_game("Vampire Lord Expansion: aborted lord setup for [key_name(lord_body)], GLOB.vlord_starts is empty.")
		return FALSE
	GLOB.ta_vampire_lord_taken = TRUE
	var/datum/job/lord_job = SSjob.GetJob("Vampire Lord")
	if(lord_job)
		lord_job.total_positions = lord_job.current_positions
		lord_job.job_reopens_slots_on_death = FALSE
	if(!lord_body.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		lord_body.unequip_everything()
		var/datum/antagonist/vampire/lord/methuselah = new /datum/antagonist/vampire/lord()
		methuselah.antag_flags |= FLAG_ANTAG_CAP_IGNORE
		lord_body.mind.add_antag_datum(methuselah)
	lord_body.forceMove(spawn_turf)
	log_game("Vampire Lord Expansion: [key_name(lord_body)] placed at [get_area(lord_body)] ([lord_body.x],[lord_body.y],[lord_body.z]).")
	ta_vampire_lord_expansion_open_retinue()
	ta_refresh_vampire_zone_watches()
	return TRUE

/proc/ta_vampire_lord_expansion_setup_retinue(mob/living/carbon/human/retinue_body, generation, position_name, knight)
	if(!GLOB.ta_vampire_lord_expansion)
		return FALSE
	if(!istype(retinue_body) || !retinue_body.mind)
		return FALSE
	if(knight)
		GLOB.ta_vampire_knights_taken++
	else
		GLOB.ta_vampire_servants_taken++
	var/mob/living/carbon/human/lord_body = ta_get_vampire_lord_body()
	var/datum/clan/lord_clan = lord_body?.clan
	if(!retinue_body.mind.has_antag_datum(/datum/antagonist/vampire))
		var/datum/antagonist/vampire/retinue_antag = new /datum/antagonist/vampire(incoming_clan = lord_clan, forced_clan = (lord_clan ? TRUE : FALSE), generation = generation)
		retinue_antag.antag_flags |= FLAG_ANTAG_CAP_IGNORE
		retinue_body.mind.add_antag_datum(retinue_antag)
	ADD_TRAIT(retinue_body, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ta_assign_vampire_lord_subordinate(retinue_body, position_name)
	var/turf/spawn_turf = ta_vampire_lord_spawn_turf()
	if(spawn_turf)
		retinue_body.forceMove(spawn_turf)
		log_game("Vampire Lord Expansion: [key_name(retinue_body)] placed at [get_area(retinue_body)] ([retinue_body.x],[retinue_body.y],[retinue_body.z]).")
	ta_sync_vampire_zone_watch(retinue_body)
	ta_vampire_lord_expansion_open_retinue()
	return TRUE


/datum/job/roguetown/vampire_lord
	title = "Vampire Lord"
	flag = VAMPIRE_LORD
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = VL_LORD_PQ
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Древний владыка павшего королевства пробудился у Багрового Тигеля. Каков теперь мир вокруг него? Ему еще предстоит выяснить, что изменилось за тысячи лет сна"

	outfit = /datum/outfit/job/roguetown/vampire_lord
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE

	obsfuscated_job = TRUE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/outfit/job/roguetown/vampire_lord

/datum/outfit/job/roguetown/vampire_lord/pre_equip(mob/living/carbon/human/H)
	..()
	if(!H.client)
		return
	H.adjust_blindness(-3)
	var/list/possible_classes = list()
	for(var/datum/advclass/candidate in SSrole_class_handler.sorted_class_categories[CTAG_LICKER_WRETCH])
		possible_classes += candidate
	if(!length(possible_classes))
		return
	var/datum/advclass/chosen = input(H.client, "Кем я был до того, как лёг в торпор?", "ДРЕВНИЙ ВЛАДЫКА") as null|anything in possible_classes
	chosen?.equipme(H)

/datum/job/roguetown/vampire_lord/New()
	. = ..()
	GLOB.antagonist_positions |= list("Vampire Lord", "Vampire Guard", "Vampire Servant")

/datum/job/roguetown/vampire_lord/override_latejoin_spawn(mob/living/carbon/human/H)
	if(!ta_vampire_lord_expansion_setup_lord(H))
		return ..()
	return TRUE

/datum/job/roguetown/vampire_guard/override_latejoin_spawn(mob/living/carbon/human/H)
	if(!ta_vampire_lord_expansion_setup_retinue(H, GENERATION_ANCILLAE, "Рыцарь клана", TRUE))
		return ..()
	return TRUE

/datum/job/roguetown/vampire_servant/override_latejoin_spawn(mob/living/carbon/human/H)
	if(!ta_vampire_lord_expansion_setup_retinue(H, GENERATION_NEONATE, "Слуга клана", FALSE))
		return ..()
	return TRUE


/client/proc/toggle_vampire_lord_expansion()
	set name = "Vampire Lord Expansion"
	set category = "Admin.Admin"
	set desc = "Открыть или закрыть роли Вампир-лорда и его свиты."

	if(!check_rights(R_ADMIN))
		return

	if(!ta_vampire_lord_expansion_allowed())
		to_chat(src, span_warning("Vampire Lord Expansion доступен только на карте [VL_MAP_NAME]."))
		return

	var/enabling = !GLOB.ta_vampire_lord_expansion
	if(enabling && !length(GLOB.vlord_starts))
		to_chat(src, span_warning("На карте нет стартовой точки вампир-лорда. Режим не включён."))
		return
	if(enabling && GLOB.ta_vampire_lord_taken)
		to_chat(src, span_warning("Вампир-лорд уже занят в этом раунде, откроется только свита."))

	ta_set_vampire_lord_expansion(enabling)

	to_chat(src, span_interface("Vampire Lord Expansion: [enabling ? "ВКЛЮЧЕН" : "ВЫКЛЮЧЕН"]."))
	log_admin("[key_name(usr)] [enabling ? "enabled" : "disabled"] Vampire Lord Expansion.")
	message_admins("[key_name_admin(usr)] [enabling ? "enabled" : "disabled"] Vampire Lord Expansion.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Vampire Lord Expansion")

#undef VAMPIRE_LORD
#undef VL_MAP_NAME
#undef VL_LORD_PQ
#undef VL_KNIGHT_PQ
#undef VL_SERVANT_PQ
#undef VL_KNIGHT_SLOTS
#undef VL_SERVANT_SLOTS
#undef VL_AUTO_KNIGHT_SLOTS
#undef VL_AUTO_SERVANT_SLOTS
#undef VL_AUTO_CHANCE
#undef VL_AUTO_ROLL_DELAY
#undef VL_WARD_TICK
#undef VL_WARD_ESCALATE_AFTER
#undef VL_WARD_STACKS_EARLY
#undef VL_WARD_STACKS_LATE
#undef VL_WARD_SOURCE
#undef VL_MANOR_SOURCE
#undef VL_WARD_WARNING
#undef VL_ASCENSION_LOCK_DELAY
