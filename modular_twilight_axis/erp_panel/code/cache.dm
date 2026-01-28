/datum/sex_session_cache_worker
	var/datum/sex_session_tgui/session

	// “боевой” кэш, который читает UI
	var/list/cached_status_organs
	var/list/cached_actions_for_menu
	var/list/cached_kinks
	var/list/cached_actor_organs
	var/list/cached_partner_organs
	var/list/cached_partners_data
	var/list/cached_active_links
	var/list/cached_passive_links
	var/list/cached_can_perform
	var/list/cached_organ_filtered
	var/list/cached_custom_actions

	// staging (собираем сюда, потом атомарно подменяем)
	var/list/st_status_organs
	var/list/st_actions_for_menu
	var/list/st_kinks
	var/list/st_actor_organs
	var/list/st_partner_organs
	var/list/st_partners_data
	var/list/st_active_links
	var/list/st_passive_links
	var/list/st_can_perform
	var/list/st_organ_filtered
	var/list/st_custom_actions

	// dirty
	var/dirty_status = TRUE
	var/dirty_menu = TRUE
	var/dirty_kinks = TRUE
	var/dirty_org_nodes = TRUE
	var/dirty_partners = TRUE
	var/dirty_links = TRUE
	var/dirty_can_perform = TRUE
	var/dirty_filtered = TRUE

	// расписание (подстрой)
	var/next_status_time = 0
	var/next_menu_time = 0
	var/next_kinks_time = 0
	var/next_misc_time = 0

	var/status_interval = 5  // тиков
	var/menu_interval = 5
	var/kinks_interval = 20
	var/misc_interval = 5

/datum/sex_session_cache_worker/New(datum/sex_session_tgui/S)
	. = ..()
	session = S

/datum/sex_session_cache_worker/proc/mark_dirty_all()
	dirty_status = TRUE
	dirty_menu = TRUE
	dirty_kinks = TRUE
	dirty_org_nodes = TRUE
	dirty_partners = TRUE
	dirty_links = TRUE
	dirty_can_perform = TRUE
	dirty_filtered = TRUE

/datum/sex_session_cache_worker/proc/mark_dirty_status()
	dirty_status = TRUE

/datum/sex_session_cache_worker/proc/mark_dirty_links()
	dirty_links = TRUE
	dirty_can_perform = TRUE
	dirty_filtered = TRUE
	dirty_status = TRUE // статус часто зависит от линков (fullness, erect, etc)

/datum/sex_session_cache_worker/proc/mark_dirty_org_nodes()
	dirty_org_nodes = TRUE
	dirty_menu = TRUE
	dirty_can_perform = TRUE
	dirty_filtered = TRUE
	dirty_status = TRUE

/datum/sex_session_cache_worker/proc/mark_dirty_partners()
	dirty_partners = TRUE
	dirty_org_nodes = TRUE
	dirty_menu = TRUE
	dirty_kinks = TRUE
	dirty_links = TRUE
	dirty_can_perform = TRUE
	dirty_filtered = TRUE
	dirty_status = TRUE

/datum/sex_session_cache_worker/proc/flush_now(max_blocks = 4)
	if(!session || QDELETED(session))
		return

	var/now = world.time
	next_status_time = 0
	next_menu_time = 0
	next_kinks_time = 0
	next_misc_time = 0

	for(var/i in 1 to max_blocks)
		if(dirty_status && now >= next_status_time)
			st_status_organs = session.build_status_org_nodes(session.user)
			cached_status_organs = st_status_organs
			st_status_organs = null
			dirty_status = FALSE
			next_status_time = now + status_interval
			continue

		if(dirty_org_nodes && now >= next_misc_time)
			var/mob/living/carbon/human/A = session.get_effective_actor()
			var/mob/living/carbon/human/P = session.get_current_partner()
			st_actor_organs = session.build_org_nodes(A, "actor")
			st_partner_organs = session.build_org_nodes(P, "partner")
			cached_actor_organs = st_actor_organs
			cached_partner_organs = st_partner_organs
			st_actor_organs = null
			st_partner_organs = null
			dirty_org_nodes = FALSE
			next_misc_time = now + misc_interval
			continue

		if(dirty_menu && now >= next_menu_time)
			st_actions_for_menu = session.actions_for_menu()
			st_custom_actions = session.build_custom_actions_for_ui()
			cached_actions_for_menu = st_actions_for_menu
			cached_custom_actions = st_custom_actions
			st_actions_for_menu = null
			st_custom_actions = null
			dirty_menu = FALSE
			next_menu_time = now + menu_interval
			continue

		if(dirty_partners && now >= next_misc_time)
			st_partners_data = session.build_partners_payload()
			cached_partners_data = st_partners_data
			st_partners_data = null
			dirty_partners = FALSE
			next_misc_time = now + misc_interval
			continue

		if(dirty_links && now >= next_misc_time)
			st_active_links = session.build_active_links_payload()
			st_passive_links = collect_passive_links_for(session.user)
			cached_active_links = st_active_links
			cached_passive_links = st_passive_links
			st_active_links = null
			st_passive_links = null
			dirty_links = FALSE
			next_misc_time = now + misc_interval
			continue

		if((dirty_can_perform || dirty_filtered) && now >= next_misc_time)
			if(dirty_can_perform)
				st_can_perform = session.rebuild_can_perform()
				cached_can_perform = st_can_perform
				st_can_perform = null
				dirty_can_perform = FALSE

			if(dirty_filtered)
				st_organ_filtered = session.actions_matching_nodes()
				cached_organ_filtered = st_organ_filtered
				st_organ_filtered = null
				dirty_filtered = FALSE

			next_misc_time = now + misc_interval
			continue

		if(dirty_kinks && now >= next_kinks_time)
			if(istype(session.user, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = session.user
				st_kinks = session.get_kink_ui_payload(H, session.get_current_partner())
			else
				st_kinks = null
			cached_kinks = st_kinks
			st_kinks = null
			dirty_kinks = FALSE
			next_kinks_time = now + kinks_interval
			continue

		break

/datum/sex_session_cache_worker/proc/tick()
	if(!session || QDELETED(session))
		return FALSE

	if(QDELETED(session.user))
		mark_dirty_all()
		return FALSE

	var/now = world.time
	if(dirty_status && now >= next_status_time)
		st_status_organs = session.build_status_org_nodes(session.user)
		cached_status_organs = st_status_organs
		st_status_organs = null

		dirty_status = FALSE
		next_status_time = now + status_interval
		return TRUE

	if(dirty_org_nodes && now >= next_misc_time)
		var/mob/living/carbon/human/A = session.get_effective_actor()
		var/mob/living/carbon/human/P = session.get_current_partner()
		st_actor_organs = session.build_org_nodes(A, "actor")
		st_partner_organs = session.build_org_nodes(P, "partner")
		cached_actor_organs = st_actor_organs
		cached_partner_organs = st_partner_organs
		st_actor_organs = null
		st_partner_organs = null

		dirty_org_nodes = FALSE
		next_misc_time = now + misc_interval
		return TRUE

	if(dirty_menu && now >= next_menu_time)
		st_actions_for_menu = session.actions_for_menu()
		st_custom_actions = session.build_custom_actions_for_ui()

		cached_actions_for_menu = st_actions_for_menu
		cached_custom_actions = st_custom_actions

		st_actions_for_menu = null
		st_custom_actions = null

		dirty_menu = FALSE
		next_menu_time = now + menu_interval
		return TRUE

	if(dirty_partners && now >= next_misc_time)
		st_partners_data = session.build_partners_payload()
		cached_partners_data = st_partners_data
		st_partners_data = null

		dirty_partners = FALSE
		next_misc_time = now + misc_interval
		return TRUE

	if(dirty_links && now >= next_misc_time)
		st_active_links = session.build_active_links_payload()
		st_passive_links = collect_passive_links_for(session.user)

		cached_active_links = st_active_links
		cached_passive_links = st_passive_links

		st_active_links = null
		st_passive_links = null

		dirty_links = FALSE
		next_misc_time = now + misc_interval
		return TRUE

	if((dirty_can_perform || dirty_filtered) && now >= next_misc_time)
		if(dirty_can_perform)
			st_can_perform = session.rebuild_can_perform()
			cached_can_perform = st_can_perform
			st_can_perform = null
			dirty_can_perform = FALSE

		if(dirty_filtered)
			st_organ_filtered = session.actions_matching_nodes()
			cached_organ_filtered = st_organ_filtered
			st_organ_filtered = null
			dirty_filtered = FALSE

		next_misc_time = now + misc_interval
		return TRUE

	if(dirty_kinks && now >= next_kinks_time)
		if(istype(session.user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = session.user
			st_kinks = session.get_kink_ui_payload(H, session.get_current_partner())
		else
			st_kinks = null

		cached_kinks = st_kinks
		st_kinks = null

		dirty_kinks = FALSE
		next_kinks_time = now + kinks_interval
		return TRUE

	return FALSE
