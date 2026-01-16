/datum/sex_session_tgui
	var/mob/living/carbon/human/user
	var/mob/living/carbon/human/target

	var/obj/item/bodypart/partner_bodypart_override

	var/selected_actor_organ_id
	var/selected_partner_organ_id

	var/global_speed = SEX_SPEED_MID
	var/global_force = SEX_FORCE_MID

	var/do_until_finished = TRUE
	var/has_knotted_penis = FALSE
	var/do_knot_action = FALSE

	var/actor_arousal_ui = 0
	var/partner_arousal_ui = 0

	var/list/current_actions = list()

	var/list/locked_actor_categories = list()

	var/list/speed_names = list("МЕДЛЕННО", "ПОСТЕПЕННО", "БЫСТРО", "НЕУМОЛИМО")
	var/list/force_names = list("НЕЖНО", "НАСТОЙЧИВО", "ГРУБО", "ЖЕСТОКО")

	var/list/partners = list()
	var/current_partner_ref = null

	var/yield_to_partner = FALSE
	var/arousal_frozen = FALSE

	var/next_broadcast_time = 0
	var/allow_user_moan = TRUE
	var/hidden_mode = FALSE

	var/last_sent_actor_arousal = -1
	var/last_sent_partner_arousal = -1

	var/dirty_heavy = TRUE
	var/dirty_actions = TRUE
	var/dirty_org_nodes = TRUE
	var/dirty_links = TRUE
	var/dirty_partners = TRUE
	var/dirty_custom_actions = TRUE

	var/list/cached_actions_for_menu
	var/list/cached_actor_organs
	var/list/cached_partner_organs
	var/list/cached_status_organs
	var/list/cached_partners_data
	var/list/cached_active_links
	var/list/cached_passive_links
	var/list/cached_custom_actions

	var/next_actions_time = 0

/datum/sex_session_tgui/New(mob/living/carbon/human/U, mob/living/carbon/human/T)
	. = ..()
	if(U)
		user = U
	if(T && T != U)
		target = T
		if(!(T in partners))
			partners += T
		current_partner_ref = REF(T)
	else
		target = user
		if(user)
			current_partner_ref = REF(user)

	update_knotted_penis_flag()

	var/datum/component/arousal/arousal_object = user.GetComponent(/datum/component/arousal)
	arousal_object.update_info()
	if(user)
		RegisterSignal(user, COMSIG_SEX_CLIMAX, PROC_REF(on_resolution_event))
		RegisterSignal(user, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed))
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	if(target && target != user)
		RegisterSignal(target, COMSIG_SEX_AROUSAL_CHANGED, PROC_REF(on_arousal_changed))
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

	START_PROCESSING(SSerp_sytem, src)

/datum/sex_session_tgui/Destroy()
	STOP_PROCESSING(SSerp_sytem, src)
	if(user)
		user.set_sex_surrender_to(null)
		UnregisterSignal(user, list(COMSIG_SEX_CLIMAX, COMSIG_SEX_AROUSAL_CHANGED, COMSIG_MOVABLE_MOVED))
	if(target && target != user)
		UnregisterSignal(target, list(COMSIG_SEX_AROUSAL_CHANGED, COMSIG_MOVABLE_MOVED))

	partner_bodypart_override = null

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(I)
			qdel(I)
	current_actions.Cut()
	locked_actor_categories.Cut()
	for(var/mob/living/carbon/human/M in partners)
		if(istype(M, /mob/living/carbon/human/erp_proxy))
			qdel(M)
	partners.Cut()
	LAZYREMOVE(GLOB.sex_sessions, src)
	return ..()

/datum/sex_session_tgui/proc/update_knotted_penis_flag()
	has_knotted_penis = FALSE
	if(!user)
		return

	var/obj/item/organ/penis/P = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!P || !P.sex_organ)
		return

	var/datum/sex_organ/penis/PO = P.sex_organ
	if(istype(PO) && PO.have_knot)
		has_knotted_penis = TRUE

/datum/sex_session_tgui/proc/add_partner(mob/living/carbon/human/M)
	if(!M || M == user)
		return

	if(!(M in partners))
		partners += M
		dirty_partners = TRUE
		dirty_org_nodes = TRUE

	if(!current_partner_ref)
		current_partner_ref = REF(M)

/datum/sex_session_tgui/proc/get_partner_display_name(mob/living/carbon/human/M)
	if(partner_bodypart_override && M && M == target)
		if(istype(partner_bodypart_override, /obj/item/bodypart/head/dullahan))
			var/obj/item/bodypart/head/dullahan/D = partner_bodypart_override

			var/name = D.original_owner?.real_name
			if(!name)
				name = D.original_owner?.name
			if(!name)
				name = D.name

			return "[name]"

		return "[partner_bodypart_override.name] ([M.name])"

	return M?.name || "—"

/datum/sex_session_tgui/proc/set_partner_bodypart_override(obj/item/bodypart/B)
	partner_bodypart_override = B

/datum/sex_session_tgui/proc/get_current_partner()
	if(current_partner_ref)
		var/mob/living/carbon/human/M = locate(current_partner_ref)
		if(M && !QDELETED(M))
			return M
	if(target && !QDELETED(target))
		return target
	return user

/datum/sex_session_tgui/proc/build_org_nodes(mob/living/carbon/human/M, side)
	if(side == "partner" && partner_bodypart_override && M == target)
		return build_org_nodes_for_bodypart(partner_bodypart_override, side)

	var/list/out = list()
	out += list(list(
		"id" = SEX_ORGAN_FILTER_ALL,
		"name" = "Все",
		"busy" = FALSE,
		"side" = side,
	))

	out += list(list(
		"id" = SEX_ORGAN_FILTER_BODY,
		"name" = "Тело",
		"busy" = FALSE,
		"side" = side,
	))

	var/is_actor = (side == "actor")

	#define BUSY_FOR(id) (is_actor ? !slot_available_for(id) : is_partner_node_reserved(id, M))

	var/obj/item/bodypart/head/HD = M.get_bodypart(BODY_ZONE_HEAD)
	if(HD)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_MOUTH,
			"name" = "Рот",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_MOUTH),
			"side" = side,
		))

	var/obj/item/bodypart/l_arm/LA = M.get_bodypart(BODY_ZONE_L_ARM)
	if(LA)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_LHAND,
			"name" = "Левая рука",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_LHAND),
			"side" = side,
		))

	var/obj/item/bodypart/r_arm/RA = M.get_bodypart(BODY_ZONE_R_ARM)
	if(RA)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_RHAND,
			"name" = "Правая рука",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_RHAND),
			"side" = side,
		))

	var/obj/item/bodypart/l_leg/LL = M.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/r_leg/RL = M.get_bodypart(BODY_ZONE_R_LEG)

	var/is_lamia = ishuman(M) && M.is_lamia_taur()

	if((LL || RL) && !is_lamia)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_LEGS,
			"name" = "Ноги",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_LEGS),
			"side" = side,
		))

	var/has_tail = FALSE
	if(is_lamia)
		has_tail = TRUE
	else if(M.getorganslot(ORGAN_SLOT_TAIL))
		has_tail = TRUE

	if(has_tail)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_TAIL,
			"name" = "Хвост",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_TAIL),
			"side" = side,
		))

	if(M.getorganslot(ORGAN_SLOT_BREASTS))
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_BREASTS,
			"name" = "Грудь",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_BREASTS),
			"side" = side,
		))

	if(M.getorganslot(ORGAN_SLOT_VAGINA))
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_VAGINA,
			"name" = "Вагина",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_VAGINA),
			"side" = side,
		))

	if(M.getorganslot(ORGAN_SLOT_PENIS))
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_PENIS,
			"name" = "Член",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_PENIS),
			"side" = side,
		))

	var/obj/item/bodypart/chest/C = M.get_bodypart(BODY_ZONE_CHEST)
	if(C)
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_ANUS,
			"name" = "Анус",
			"busy" = BUSY_FOR(SEX_ORGAN_FILTER_ANUS),
			"side" = side,
		))

	#undef BUSY_FOR

	return out

/datum/sex_session_tgui/proc/build_org_nodes_for_bodypart(obj/item/bodypart/B, side)
	var/list/out = list()
	out += list(list("id" = SEX_ORGAN_FILTER_BODY, "name" = "Тело", "busy" = FALSE, "side" = side))

	if(istype(B, /obj/item/bodypart/head) || istype(B, /obj/item/bodypart/head/dullahan))
		out += list(list(
			"id"   = SEX_ORGAN_FILTER_MOUTH,
			"name" = "Рот",
			"busy" = FALSE,
			"side" = side,
		))

	return out

/datum/sex_session_tgui/proc/is_locked(category)
	return (category in locked_actor_categories)

/datum/sex_session_tgui/proc/slot_available_for(id)
	var/cat = category_of_actor_node(id)
	if(!cat)
		return FALSE
	return !is_locked(cat)

/datum/sex_session_tgui/proc/actions_for_menu()
	var/list/actions = list()

	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/T = get_current_partner()

	var/a_sel = selected_actor_organ_id
	var/p_sel = selected_partner_organ_id

	var/user_ckey = U?.client?.ckey

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue

		if(A.ckey && A.ckey != user_ckey)
			continue

		if(!A.shows_on_menu(U, T))
			continue

		if(A.required_init || A.required_target)
			if(!U)
				continue

			if(!(partner_bodypart_override && A.required_target == SEX_ORGAN_MOUTH))
				var/list/orgs = A.get_action_organs(U, T, FALSE, FALSE)
				if(!orgs)
					continue

			if(a_sel && a_sel != SEX_ORGAN_FILTER_ALL)
				if(a_sel == SEX_ORGAN_FILTER_BODY)
					if(A.required_init)
						continue
				else
					var/a_type = node_organ_type(a_sel)
					if(A.required_init && a_type && A.required_init != a_type)
						continue

			if(p_sel && p_sel != SEX_ORGAN_FILTER_ALL)
				var/list/targets = A.get_filter_target_organ_types()

				if(p_sel == SEX_ORGAN_FILTER_BODY)
					if(targets && targets.len)
						continue
				else
					var/p_type = node_organ_type(p_sel)
					if(targets && targets.len)
						if(!p_type || !(p_type in targets))
							continue
					else if(A.required_target && p_type && A.required_target != p_type)
						continue

		actions += list(list(
			"name" = A.name,
			"type" = key,
			"tags" = list(),
		))

	return actions

/datum/sex_session_tgui/proc/inherent_perform_check(datum/sex_panel_action/A, mob/living/carbon/human/U, mob/living/carbon/human/T)
	if(!T || !U)
		return FALSE
	if(U.stat != CONSCIOUS)
		return FALSE
	if(A.check_incapacitated && U.incapacitated())
		return FALSE

	var/atom/real_target = T
	if(partner_bodypart_override && T == target)
		real_target = partner_bodypart_override

	var/dist = get_dist(U, real_target)
	if(dist > 1)
		return FALSE

	if(A.check_same_tile)
		var/same_tile = (get_turf(U) == get_turf(real_target))
		var/grabstate = U.get_highest_grab_state_on(T)
		var/grab_bypass = (grabstate && grabstate >= GRAB_PASSIVE)

		if(!same_tile && !grab_bypass)
			return FALSE

	if(A.require_grab)
		var/grabstate2 = U.get_highest_grab_state_on(T)
		if(isnull(grabstate2) || grabstate2 < A.required_grab_state)
			return FALSE

	return TRUE

/datum/sex_session_tgui/proc/can_perform_action_type(action_type, performing = FALSE, actor_node_id = null, partner_node_id = null)
	if(!action_type)
		return FALSE

	var/datum/sex_panel_action/A = SEX_PANEL_ACTION(action_type)
	if(!A)
		return FALSE

	var/a_id = actor_node_id
	if(!a_id)
		a_id = selected_actor_organ_id

	var/p_id = partner_node_id
	if(!p_id)
		p_id = selected_partner_organ_id

	return can_execute_action(A, a_id, p_id, performing)

/datum/sex_session_tgui/proc/ui_key()
	return "EroticRolePlayPanel"

/datum/sex_session_tgui/ui_state(mob/user)
	return GLOB.conscious_state

/datum/sex_session_tgui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_key(), "Утолить Желания")
		ui.open()

/datum/sex_session_tgui/ui_static_data(mob/user)
	var/list/D = list()
	D["speed_names"] = speed_names.Copy()
	D["force_names"] = force_names.Copy()
	D["has_knotted_penis"] = has_knotted_penis

	D["climax_modes"] = list(
		list("id" = "none", "name" = "Не задано"),
		list("id" = "self", "name" = "Под себя"),
		list("id" = "into", "name" = "Внутрь"),
		list("id" = "onto", "name" = "Снаружи"),
	)
	
	D["organ_type_options"] = list(
		list("id" = ORG_KEY_NONE,              "name" = "Не важно"),
		list("id" = SEX_ORGAN_FILTER_MOUTH,    "name" = "Рот"),
		list("id" = SEX_ORGAN_FILTER_HANDS,    "name" = "Руки"),
		list("id" = SEX_ORGAN_FILTER_LEGS,     "name" = "Ноги"),
		list("id" = SEX_ORGAN_FILTER_TAIL,     "name" = "Хвост"),
		list("id" = SEX_ORGAN_FILTER_BREASTS,  "name" = "Грудь"),
		list("id" = SEX_ORGAN_FILTER_VAGINA,   "name" = "Вагина"),
		list("id" = SEX_ORGAN_FILTER_PENIS,    "name" = "Член"),
		list("id" = SEX_ORGAN_FILTER_ANUS,     "name" = "Анус"),
	)

	D["custom_templates"] = build_custom_templates_for_ui()
	return D

/datum/sex_session_tgui/ui_data(mob/user)
	update_partners_proximity()
	update_knotted_penis_flag()
	var/list/D = list()

	var/datum/preferences/P = user.client?.prefs
	if(P)
		P.apply_erp_kinks_to_mob(user)
		P.apply_erp_organ_sensitivity_to_mob(user)

	var/mob/living/carbon/human/active_partner = get_current_partner()
	D["title"] = "Соитие с [get_partner_display_name(active_partner)]"
	D["session_name"] = "Private Session"
	D["actor_name"] = src.user?.name || "—"
	D["partner_name"] = get_partner_display_name(active_partner)
	D["selected_actor_organ"] = selected_actor_organ_id
	D["selected_partner_organ"] = selected_partner_organ_id
	D["speed"] = global_speed
	D["force"] = global_force
	D["do_until_finished"] = do_until_finished
	D["yield_to_partner"] = yield_to_partner
	D["allow_user_moan"] = allow_user_moan
	D["hidden_mode"] = hidden_mode

	var/list/ad_user = list()
	if(src.user)
		SEND_SIGNAL(src.user, COMSIG_SEX_GET_AROUSAL, ad_user)

	var/cur_u = ad_user["arousal"] || 0
	var/is_frozen = ad_user["frozen"] || FALSE
	actor_arousal_ui = min(100, (cur_u / ERP_UI_MAX_AROUSAL) * 100)
	arousal_frozen = is_frozen
	D["actor_arousal"] = clamp(round(actor_arousal_ui), 0, 100)
	D["frozen"] = arousal_frozen

	var/charge_u = ad_user["charge"] || 0
	D["actor_charge"] = round(charge_u)
	D["actor_charge_max"] = ad_user["charge_max"]
	D["actor_charge_for_climax"] = ad_user["charge_for_climax"]

	if(can_see_partner_arousal())
		D["partner_arousal"] = clamp(round(partner_arousal_ui), 0, 100)
		D["partner_arousal_hidden"] = FALSE
	else
		D["partner_arousal"] = null
		D["partner_arousal_hidden"] = TRUE

	if(dirty_actions || !cached_actions_for_menu)
		cached_actions_for_menu = actions_for_menu()
		dirty_actions = FALSE
	D["actions"] = cached_actions_for_menu

	if(dirty_org_nodes || !cached_actor_organs || !cached_partner_organs)
		cached_actor_organs = build_org_nodes(src.user, "actor")
		cached_partner_organs = build_org_nodes(active_partner, "partner")
		dirty_org_nodes = FALSE

	D["actor_organs"] = cached_actor_organs
	D["partner_organs"] = cached_partner_organs
	D["status_organs"] = build_status_org_nodes(src.user)

	var/list/cur_types = list()
	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(I && I.action_type)
			cur_types |= I.action_type
	D["current_actions"] = cur_types

	if(dirty_partners || !cached_partners_data)
		var/list/partners_data = list()
		if(src.user)
			partners_data += list(list(
				"ref" = REF(src.user),
				"name" = "[src.user.name]",
			))

		for(var/mob/living/carbon/human/M in partners)
			if(QDELETED(M))
				continue
			partners_data += list(list(
				"ref" = REF(M),
				"name" = M.name,
			))

		if(!current_partner_ref && src.user)
			current_partner_ref = REF(src.user)

		cached_partners_data = partners_data
		dirty_partners = FALSE

	D["partners"] = cached_partners_data
	D["current_partner_ref"] = current_partner_ref

	if(dirty_links || !cached_active_links)
		var/list/links = list()
		for(var/id in current_actions)
			var/datum/sex_action_session/I = current_actions[id]
			if(!I)
				continue

			var/datum/sex_organ/tuned_org = resolve_organ_datum(I.actor, I.actor_node_id)
			if(!tuned_org)
				tuned_org = resolve_organ_datum(I.partner, I.partner_node_id)

			var/sens = tuned_org ? tuned_org.sensitivity : 0
			var/pain = tuned_org ? tuned_org.pain : 0
			links += list(list(
				"id"                = I.instance_id,
				"actor_organ_id"    = I.actor_node_id,
				"partner_organ_id"  = I.partner_node_id,
				"action_type"       = I.action_proto,
				"action_name"       = I.action_proto?.name,
				"speed"             = I.speed,
				"force"             = I.force,
				"do_until_finished" = do_until_finished,
				"sensitivity"       = sens,
				"pain"              = pain,
			))

		cached_active_links = links
		dirty_links = FALSE

	D["active_links"] = cached_active_links
	D["passive_links"] = collect_passive_links_for(user)

	var/can_knot_now = FALSE
	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I)
			continue

		if(I.action_proto?.can_knot)
			can_knot_now = TRUE
			break

	D["has_knotted_penis"] = has_knotted_penis
	D["do_knot_action"] = do_knot_action
	D["can_knot_now"] = can_knot_now

	if(dirty_custom_actions || !cached_custom_actions)
		cached_custom_actions = build_custom_actions_for_ui()
		dirty_custom_actions = FALSE

	D["custom_actions"] = cached_custom_actions

	var/list/can = list()
	var/user_ckey = src.user?.client?.ckey
	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue
		if(A.ckey && A.ckey != user_ckey)
			continue
		if(can_start_action_now(key))
			can += key

	D["can_perform"] = can
	D["organ_filtered"] = actions_matching_nodes()
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		D["kinks"] = get_kink_ui_payload(H, active_partner)

	return D

/datum/sex_session_tgui/proc/get_kink_ui_payload(mob/living/carbon/human/H, mob/living/carbon/human/PH)
	if(!H)
		return null

	var/datum/component/kinks/K = H.ensure_kinks_component()
	var/datum/component/kinks/PK = null
	if(PH)
		if(PH == H)
			PK = K
		else
			PK = PH.GetComponent(/datum/component/kinks)
			if(!PK)
				PK = PH.ensure_kinks_component()

	var/list/out = list()
	var/list/entries = list()
	for(var/kink_type in GLOB.available_kinks)
		var/datum/kink/KD = GLOB.available_kinks[kink_type]
		if(!KD)
			continue

		var/self_pref = K ? K.get_pref(KD.type) : 0
		var/partner_pref = null
		var/partner_pref_known = FALSE
		if(PH == H)
			partner_pref = self_pref
			partner_pref_known = TRUE
		else if(PK)
			partner_pref_known = PK.has_pref(KD.type)
			if(partner_pref_known)
				partner_pref = PK.get_pref(KD.type)

		entries += list(list(
			"type" = "[KD.type]",
			"name" = KD.name,
			"description" = KD.description,
			"category" = KD.category,
			"intensity" = KD.intensity,
			"pref" = self_pref,
			"partner_pref" = partner_pref_known ? partner_pref : null,
			"partner_pref_known" = partner_pref_known,
		))

	out["entries"] = entries
	return out

/datum/sex_session_tgui/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_kink_pref")
			if(!user || !istype(user, /mob/living/carbon/human))
				return FALSE
			var/mob/living/carbon/human/H = user
			var/kink_type_txt = params["type"]
			var/value = text2num(params["value"])
			if(!kink_type_txt)
				return FALSE
			var/kink_type = text2path(kink_type_txt)
			if(!ispath(kink_type, /datum/kink))
				return FALSE
			var/datum/component/kinks/K = H.ensure_kinks_component()
			if(!K)
				return FALSE
			K.set_pref(kink_type, value)
			var/datum/preferences/P = H.client?.prefs
			if(P)
				P.capture_erp_kinks_from_mob(H)
				P.save_preferences()
			SStgui.update_uis(src)
			return TRUE

		if("select_organ")
			var/side = params["side"]
			var/id = params["id"]
			if(side == "actor")
				selected_actor_organ_id = id
			else if(side == "partner")
				selected_partner_organ_id = id

			dirty_actions = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("start_action")
			try_start_action(params["action_type"])
			dirty_links = TRUE
			dirty_org_nodes = TRUE
			dirty_actions = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("toggle_knot")
			if(can_toggle_knot())
				do_knot_action = !do_knot_action
			SStgui.update_uis(src)
			return TRUE

		if("quick")
			var/op = params["op"]
			if(op == "increase")
				global_force = clamp(global_force + 1, SEX_FORCE_MIN, SEX_FORCE_MAX)
				global_speed = clamp(global_speed + 1, SEX_SPEED_MIN, SEX_SPEED_MAX)
			else if(op == "yield")
				yield_to_partner = !yield_to_partner

				var/mob/living/carbon/human/partner = get_current_partner()
				if(yield_to_partner && partner)
					user.set_sex_surrender_to(partner)
				else
					user.set_sex_surrender_to(null)

				if(yield_to_partner)
					stop_all_actions()
					dirty_links = TRUE
					dirty_org_nodes = TRUE
					dirty_actions = TRUE

			SStgui.update_uis(src)
			return TRUE

		if("set_partner")
			var/ref = params["ref"]
			if(!ref)
				return
			for(var/mob/living/carbon/human/M in partners + list(user))
				if(REF(M) == ref)
					current_partner_ref = ref
					if(M != user)
						target = M
					if(!partner_bodypart_override || !istype(partner_bodypart_override, /obj/item/bodypart/head/dullahan))
						partner_bodypart_override = null

					dirty_org_nodes = TRUE
					dirty_actions = TRUE

					SStgui.update_uis(src)
					return TRUE

		if("stop_all")
			stop_all_actions()
			dirty_links = TRUE
			dirty_org_nodes = TRUE
			dirty_actions = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("stop_link")
			var/id = params["id"]
			if(id)
				stop_instance(id)
				dirty_links = TRUE
				dirty_org_nodes = TRUE
				dirty_actions = TRUE
				SStgui.update_uis(src)
				return TRUE

		if("set_link_speed")
			var/id = params["id"]
			var/value = clamp(text2num(params["value"]), SEX_SPEED_MIN, SEX_SPEED_MAX)
			var/datum/sex_action_session/I = current_actions[id]
			if(I)
				I.speed = value
				dirty_links = TRUE
				SStgui.update_uis(src)
				return TRUE

		if("set_link_force")
			var/id2 = params["id"]
			var/value2 = clamp(text2num(params["value"]), SEX_FORCE_MIN, SEX_FORCE_MAX)
			var/datum/sex_action_session/I2 = current_actions[id2]
			if(I2)
				I2.force = value2
				dirty_links = TRUE
				SStgui.update_uis(src)
				return TRUE

		if("toggle_link_finished")
			do_until_finished = !do_until_finished
			dirty_links = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("set_arousal_value")
			var/target_type = params["target"]
			var/amount = clamp(text2num(params["amount"]), 0, 100)
			if(target_type == "actor" && user)
				SEND_SIGNAL(user, COMSIG_SEX_SET_AROUSAL, amount)
			else if(target_type == "partner")
				var/mob/living/carbon/human/P = get_current_partner()
				if(P)
					SEND_SIGNAL(P, COMSIG_SEX_SET_AROUSAL, amount)

			SStgui.update_uis(src)
			return TRUE

		if("set_organ_tuning")
			var/id = params["id"]
			var/field = params["field"]
			var/value = text2num(params["value"])

			var/datum/sex_organ/O = resolve_organ_datum(user, id)
			if(!O)
				return FALSE

			switch(field)
				if("sensitivity")
					O.set_sensitivity(value)
					var/datum/preferences/P = user.client?.prefs
					if(P)
						P.capture_erp_organ_sensitivity_from_mob(user)
						P.save_preferences()

			dirty_links = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("set_link_tuning")
			var/id = params["id"]
			var/value = text2num(params["value"])

			var/datum/sex_action_session/I = current_actions[id]
			if(!I)
				return FALSE

			var/datum/sex_organ/user_org = resolve_organ_datum(I.actor, I.actor_node_id)
			if(!user_org)
				return FALSE

			user_org.set_sensitivity(value)
			var/datum/preferences/P = user.client?.prefs
			if(P)
				P.capture_erp_organ_sensitivity_from_mob(user)
				P.save_preferences()
			dirty_links = TRUE
			SStgui.update_uis(src)
			return TRUE

		if("flip")
			if(user)
				if(!islist(user.mob_timers))
					user.mob_timers = list()

				var/last = user.mob_timers["sexpanel_flip"] || 0
				if(world.time < last + 1 SECONDS)
					return FALSE

				user.mob_timers["sexpanel_flip"] = world.time
				user.sexpanel_flip()
			SStgui.update_uis(src)
			return TRUE

		if("freeze_arousal")
			if(user)
				SEND_SIGNAL(user, COMSIG_SEX_FREEZE_AROUSAL)

				var/list/ad = list()
				SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, ad)
				arousal_frozen = !!ad["frozen"]

			SStgui.update_uis(src)
			return TRUE

		if("toggle_erect")
			var/target_state = params["state"]
			var/id = params["id"]
			if(!id || id != SEX_ORGAN_FILTER_PENIS)
				return FALSE

			var/datum/sex_organ/O = resolve_organ_datum(user, id)
			if(!O)
				return FALSE

			var/obj/item/organ/penis/P = user.getorganslot(ORGAN_SLOT_PENIS)
			if(!P)
				return FALSE

			if(target_state == "auto")
				P.disable_manual_erect()
			else if(target_state == "none")
				P.set_manual_erect_state(ERECT_STATE_NONE)
			else if(target_state == "partial")
				P.set_manual_erect_state(ERECT_STATE_PARTIAL)
			else if(target_state == "hard")
				P.set_manual_erect_state(ERECT_STATE_HARD)

			update_knotted_penis_flag()
			SStgui.update_uis(src)
			return TRUE

		if("custom_create")
			handle_custom_create(params)
			dirty_custom_actions = TRUE
			dirty_actions = TRUE
			var/datum/preferences/P = user.client?.prefs
			if(P)
				P.erp_sync_from_globals(user.client.ckey)
				P.save_preferences()
			SStgui.update_uis(src)
			return TRUE

		if("custom_update")
			handle_custom_update(params)
			dirty_custom_actions = TRUE
			dirty_actions = TRUE
			var/datum/preferences/P = user.client?.prefs
			if(P)
				P.erp_sync_from_globals(user.client.ckey)
				P.save_preferences()
			SStgui.update_uis(src)
			return TRUE

		if("custom_delete")
			handle_custom_delete(params)
			dirty_custom_actions = TRUE
			dirty_actions = TRUE
			var/datum/preferences/P = user.client?.prefs
			if(P)
				P.erp_sync_from_globals(user.client.ckey)
				P.save_preferences()
			SStgui.update_uis(src)
			return TRUE

		if("toggle_moan")
			allow_user_moan = !allow_user_moan
			SStgui.update_uis(src)
			return TRUE

		if("toggle_hidden")
			hidden_mode = !hidden_mode
			SStgui.update_uis(src)
			return TRUE

	return FALSE

/datum/sex_session_tgui/proc/update_partners_proximity()
	if(partner_bodypart_override && istype(partner_bodypart_override, /obj/item/bodypart/head/dullahan))
		var/list/proxies = get_erp_proxies_for_part(partner_bodypart_override)
		if(proxies)
			for(var/mob/living/carbon/human/erp_proxy/P in proxies)
				if(!(P in partners))
					partners += P

	if(QDELETED(user))
		return

	var/list/new_partners = list()
	var/atom/partner_anchor = null
	if(partner_bodypart_override && istype(partner_bodypart_override, /obj/item/bodypart/head/dullahan))
		partner_anchor = partner_bodypart_override

	for(var/mob/living/carbon/human/M in partners)
		if(QDELETED(M))
			continue

		if(istype(M, /mob/living/carbon/human/erp_proxy))
			var/mob/living/carbon/human/erp_proxy/P = M
			if(partner_anchor && P.source_part == partner_anchor)
				if(get_dist(user, partner_anchor) > 2)
					continue
				new_partners += M
				continue

		if(get_dist(user, M) > 2)
			continue

		new_partners += M

	var/old_len = partners.len
	partners = new_partners

	if(length(new_partners) != old_len)
		dirty_partners = TRUE
		dirty_org_nodes = TRUE
		dirty_actions = TRUE
		dirty_links = TRUE
		dirty_custom_actions = TRUE

	var/mob/living/carbon/human/cur = null
	if(current_partner_ref)
		cur = locate(current_partner_ref)

	if(cur && cur != user && !(cur in partners))
		current_partner_ref = REF(user)
		target = user
		partner_bodypart_override = null

		dirty_partners = TRUE
		dirty_org_nodes = TRUE
		dirty_actions = TRUE

/datum/sex_session_tgui/proc/try_start_action(action_type)
	var/datum/sex_panel_action/A = SEX_PANEL_ACTION(action_type)
	if(!A)
		return

	var/a_id = pick_actor_node_for_action(A)
	var/p_id = pick_partner_node_for_action(A)

	if(!a_id || !p_id)
		return

	if(!can_execute_action(A, a_id, p_id, TRUE))
		return

	var/datum/sex_action_session/existing = find_existing_action_session(action_type, a_id, p_id)
	if(existing)
		existing.action_type = action_type
		existing.speed = global_speed
		existing.force = global_force
		SStgui.update_uis(src)
		return

	var/cat = category_of_actor_node(a_id)
	if(cat)
		locked_actor_categories |= cat

	var/datum/sex_action_session/I = new(src, A, a_id, p_id, action_type)
	I.action_type = action_type
	I.speed = global_speed
	I.force = global_force

	current_actions[I.instance_id] = I
	INVOKE_ASYNC(I, TYPE_PROC_REF(/datum/sex_action_session, start))

	start_broadcast_loop()
	dirty_actions = TRUE
	dirty_links = TRUE
	dirty_org_nodes = TRUE
	SStgui.update_uis(src)

/datum/sex_session_tgui/proc/stop_all_actions()
	var/list/ids = current_actions.Copy()
	for(var/id in ids)
		stop_instance(id)

	if(!length(current_actions))
		clear_actor_locks()

	dirty_actions = TRUE
	dirty_links = TRUE
	dirty_org_nodes = TRUE

/datum/sex_session_tgui/proc/stop_instance(id)
	var/datum/sex_action_session/I = current_actions[id]
	if(!I)
		return

	current_actions -= id

	dirty_actions = TRUE
	dirty_links = TRUE
	dirty_org_nodes = TRUE

	var/cat = category_of_actor_node(I.actor_node_id)
	if(cat)
		locked_actor_categories -= cat

	var/datum/sex_organ/src_org = resolve_organ_datum(I.actor, I.actor_node_id)
	if(src_org)
		src_org.unbind()

	I.action_proto?.on_finish(I.actor, I.partner, I.ctx)
	qdel(I)

	if(!length(current_actions))
		clear_actor_locks()
		stop_broadcast_loop()

	SStgui.update_uis(src)

/datum/sex_session_tgui/proc/sync_arousal_ui()
	var/list/ad_user = list()
	var/list/ad_tgt = list()
	if(user)
		SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, ad_user)

	var/mob/living/carbon/human/P = get_current_partner()
	if(P)
		SEND_SIGNAL(P, COMSIG_SEX_GET_AROUSAL, ad_tgt)

	var/cur_u = ad_user["arousal"] || 0
	var/cur_t = ad_tgt["arousal"] || 0

	actor_arousal_ui = min(100, (cur_u / ERP_UI_MAX_AROUSAL) * 100)
	partner_arousal_ui = min(100, (cur_t / ERP_UI_MAX_AROUSAL) * 100)

/datum/sex_session_tgui/proc/on_arousal_changed()
	sync_arousal_ui()

	var/changed = FALSE

	if(abs(actor_arousal_ui - last_sent_actor_arousal) >= 1)
		last_sent_actor_arousal = actor_arousal_ui
		changed = TRUE

	if(abs(partner_arousal_ui - last_sent_partner_arousal) >= 1)
		last_sent_partner_arousal = partner_arousal_ui
		changed = TRUE

	if(changed)
		SStgui.update_uis(src)

/datum/sex_session_tgui/proc/on_resolution_event(mob/source)
	if(source != user)
		return

	if(do_until_finished)
		stop_all_actions()

	if(!selected_actor_organ_id)
		return

	var/datum/sex_organ/src_org = resolve_organ_datum(user, selected_actor_organ_id)
	if(!src_org)
		return

	var/mob/living/carbon/human/P = get_current_partner()

	if(selected_partner_organ_id && P)
		var/datum/sex_organ/tgt_org = resolve_organ_datum(P, selected_partner_organ_id)
		if(tgt_org)
			src_org.bind_with(tgt_org)

	var/moved = src_org.inject_liquid()
	if(moved <= 0)
		return

/datum/sex_session_tgui/proc/resolve_organ_from_bodypart(obj/item/bodypart/B, id)
	if(!B || !id)
		return null

	if(istype(B, /obj/item/bodypart/head) || istype(B, /obj/item/bodypart/head/dullahan))
		if(id == SEX_ORGAN_FILTER_MOUTH)
			return B.sex_organ

	return null

/datum/sex_session_tgui/proc/resolve_organ_datum(mob/living/carbon/human/M, id)
	if(!M || !id)
		return null

	if(M == target && partner_bodypart_override)
		var/datum/sex_organ/over_org = resolve_organ_from_bodypart(partner_bodypart_override, id)
		if(over_org)
			return over_org

	switch(id)
		if(SEX_ORGAN_FILTER_MOUTH)
			var/obj/item/bodypart/head/HD = M.get_bodypart(BODY_ZONE_HEAD)
			return HD?.sex_organ
		if(SEX_ORGAN_FILTER_LHAND)
			var/obj/item/bodypart/l_arm/LA = M.get_bodypart(BODY_ZONE_L_ARM)
			return LA?.sex_organ
		if(SEX_ORGAN_FILTER_RHAND)
			var/obj/item/bodypart/r_arm/RA = M.get_bodypart(BODY_ZONE_R_ARM)
			return RA?.sex_organ
		if(SEX_ORGAN_FILTER_LEGS)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				return H.ensure_legs_organ()
			return null
		if(SEX_ORGAN_FILTER_TAIL)
			if(ishuman(M) && M.is_lamia_taur())
				var/obj/item/bodypart/taur/T  = M.get_bodypart(BODY_ZONE_TAUR)
				return T?.sex_organ
			else
				var/obj/item/organ/tail/T = M.getorganslot(ORGAN_SLOT_TAIL)
				return T?.sex_organ
		if(SEX_ORGAN_FILTER_BREASTS)
			var/obj/item/organ/breasts/B = M.getorganslot(ORGAN_SLOT_BREASTS)
			return B?.sex_organ
		if(SEX_ORGAN_FILTER_VAGINA)
			var/obj/item/organ/vagina/V = M.getorganslot(ORGAN_SLOT_VAGINA)
			return V?.sex_organ
		if(SEX_ORGAN_FILTER_PENIS)
			var/obj/item/organ/penis/P = M.getorganslot(ORGAN_SLOT_PENIS)
			return P?.sex_organ
		if(SEX_ORGAN_FILTER_ANUS)
			var/obj/item/bodypart/chest/A = M.get_bodypart(BODY_ZONE_CHEST)
			return A?.sex_organ
		if(SEX_ORGAN_FILTER_BODY)
			if(ishuman(M))
				var/mob/living/carbon/human/H2 = M
				return H2.ensure_body_organ()
			return null

	return null

/datum/sex_session_tgui/proc/node_organ_type(id)
	return GLOB.sex_node_defs[id]?["organ_type"]

/datum/sex_session_tgui/proc/category_of_actor_node(id)
	return GLOB.sex_node_defs[id]?["category"]

/datum/sex_session_tgui/proc/pick_actor_node_for_action(datum/sex_panel_action/A)
	if(!A)
		return null

	if(!A.required_init)
		var/body_cat = category_of_actor_node(SEX_ORGAN_FILTER_BODY)
		if(!is_locked(body_cat))
			return SEX_ORGAN_FILTER_BODY
		return null

	if(selected_actor_organ_id)
		var/sel_type = node_organ_type(selected_actor_organ_id)
		if(sel_type && sel_type == A.required_init)
			var/sel_cat = category_of_actor_node(selected_actor_organ_id)
			if(!is_locked(sel_cat))
				return selected_actor_organ_id

	var/list/nodes = build_org_nodes(user, "actor")
	for(var/i in 1 to nodes.len)
		var/list/N = nodes[i]
		var/id = N["id"]

		if(id == SEX_ORGAN_FILTER_BODY)
			continue

		var/t = node_organ_type(id)
		if(!t || t != A.required_init)
			continue

		var/cat = category_of_actor_node(id)
		if(is_locked(cat))
			continue

		return id

	return null

/datum/sex_session_tgui/proc/pick_partner_node_for_action(datum/sex_panel_action/A)
	var/mob/living/carbon/human/P = get_current_partner()
	if(!P)
		return null

	if(!A.required_target)
		return SEX_ORGAN_FILTER_BODY

	if(selected_partner_organ_id)
		var/t = node_organ_type(selected_partner_organ_id)
		if(A.required_target == t)
			return selected_partner_organ_id

	var/list/nodes = build_org_nodes(P, "partner")
	for(var/i in 1 to nodes.len)
		var/list/N = nodes[i]
		var/id = N["id"]
		if(id == SEX_ORGAN_FILTER_BODY)
			continue

		var/t2 = node_organ_type(id)
		if(A.required_target && A.required_target != t2)
			continue

		return id

	return null

/datum/sex_session_tgui/proc/start_broadcast_loop()
	if(next_broadcast_time)
		return
	next_broadcast_time = world.time + 1 SECONDS

/datum/sex_session_tgui/proc/stop_broadcast_loop()
	next_broadcast_time = 0

/datum/sex_session_tgui/proc/recalc_next_actions_time()
	var/min = 0
	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I))
			continue
		if(!min || I.next_tick_time < min)
			min = I.next_tick_time
	next_actions_time = min

/datum/sex_session_tgui/process(delta_time)
	var/next = 0
	if(next_broadcast_time) next = next_broadcast_time
	if(next_actions_time && (!next || next_actions_time < next)) next = next_actions_time

	if(!next || world.time < next)
		return

	if(next_broadcast_time && world.time >= next_broadcast_time)
		update_partners_proximity()
		broadcast_step()

	if(next_actions_time && world.time >= next_actions_time)
		for(var/id in current_actions)
			var/datum/sex_action_session/I = current_actions[id]
			if(!I || QDELETED(I))
				continue
			if(world.time >= I.next_tick_time)
				I.tick()

		recalc_next_actions_time()

/datum/sex_session_tgui/proc/broadcast_step()
	if(QDELETED(src))
		next_broadcast_time = 0
		return

	if(!length(current_actions))
		next_broadcast_time = 0
		return
	
	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I) || !I.action_proto)
			continue

		if(!I.should_hard_stop())
			continue

		var/mob/living/carbon/human/blocker

		if(ishuman(I.actor))
			var/mob/living/carbon/human/H1 = I.actor
			if(H1.is_erp_blocked_as_target())
				blocker = H1

		if(!blocker && ishuman(I.partner))
			var/mob/living/carbon/human/H2 = I.partner
			if(H2.is_erp_blocked_as_target())
				blocker = H2

		if(blocker)
			hard_abort_for(blocker)
		else
			qdel(src)

		next_broadcast_time = 0
		return

	var/list/candidates = list()

	for(var/id in current_actions)
		var/datum/sex_action_session/A = current_actions[id]
		if(!A || QDELETED(A))
			continue
		if(!A.action_proto)
			continue
		if(A.session.user != user)
			continue
		candidates += A

	if(!length(candidates))
		next_broadcast_time = 0
		return

	var/datum/sex_action_session/choice = pick(candidates)
	if(choice && choice.action_proto)
		choice.action_proto.on_perform(choice.actor, choice.partner, choice.ctx)

	var/total_mult = 0.0
	var/count = 0

	for(var/datum/sex_action_session/S in candidates)
		total_mult += get_speed_multiplier(S.speed)
		count++

	var/avg_mult = (count > 0) ? (total_mult / count) : 1.0

	var/base_delay = 5 SECONDS
	var/next_delay = base_delay

	if(avg_mult > 0)
		next_delay = round(base_delay / avg_mult)

	if(next_delay < 1 SECONDS)
		next_delay = 1 SECONDS

	next_broadcast_time = world.time + next_delay

/datum/sex_session_tgui/proc/can_continue_action_session(datum/sex_action_session/I)
	if(!I || !I.action_proto)
		return FALSE

	var/mob/living/carbon/human/U = I.actor
	var/mob/living/carbon/human/T = I.partner

	if(!U || !T)
		return FALSE

	if(!inherent_perform_check(I.action_proto, U, T))
		return FALSE

	if(!I.action_proto.can_perform(U, T))
		return FALSE

	var/datum/sex_organ/src_org = null
	var/datum/sex_organ/tgt_org = null

	if(I.actor_node_id)
		src_org = resolve_organ_datum(U, I.actor_node_id)
	if(I.partner_node_id)
		tgt_org = resolve_organ_datum(T, I.partner_node_id)

	if(I.action_proto.required_init && !src_org)
		return FALSE

	if(I.action_proto.required_target && !tgt_org)
		return FALSE

	var/a_type = I.actor_node_id ? node_organ_type(I.actor_node_id) : null
	var/p_type = I.partner_node_id ? node_organ_type(I.partner_node_id) : null

	if(I.action_proto.required_init && !a_type)
		return FALSE
	if(I.action_proto.required_target && !p_type)
		return FALSE

	return TRUE

/datum/sex_session_tgui/proc/clear_actor_locks()
	if(locked_actor_categories)
		locked_actor_categories.Cut()

/datum/sex_session_tgui/proc/build_status_org_nodes(mob/living/carbon/human/M)
	if(!M)
		return list()

	var/list/nodes = build_org_nodes(M, "actor")
	var/list/out = list()

	for(var/i in 1 to nodes.len)
		var/list/N = nodes[i]
		var/id = N["id"]

		// "Все" — чистый фильтр для меню, в статусе не нужен
		if(id == SEX_ORGAN_FILTER_ALL)
			continue

		var/datum/sex_organ/O = resolve_organ_datum(M, id)
		var/sens = O ? O.sensitivity : 0
		var/pain = O ? O.pain : 0

		var/fullness = 0
		if(O && O.stored_liquid && O.stored_liquid_max > 0)
			var/cur = O.stored_liquid.total_volume
			if(cur > 0)
				fullness = clamp(round((cur / O.stored_liquid_max) * 100), 0, 100)

		if(id == SEX_ORGAN_FILTER_PENIS)
			var/obj/item/organ/penis/P = M.getorganslot(ORGAN_SLOT_PENIS)
			if(P)
				N["erect"] = P.erect_state
				N["manual"] = P.manual_erection_override

		N["sensitivity"] = sens
		N["pain"] = pain
		N["fullness"] = fullness

		out += list(N)

	return out

/datum/sex_session_tgui/proc/can_see_partner_arousal()
	if(!user)
		return FALSE

	var/mob/living/carbon/human/P = get_current_partner()
	if(!P)
		return FALSE
	if(user == P)
		return FALSE

	if(HAS_TRAIT(user, TRAIT_EMPATH))
		return TRUE

	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		return TRUE

	return FALSE

/datum/sex_session_tgui/proc/can_toggle_knot()
	if(!has_knotted_penis)
		return FALSE
	if(!length(current_actions))
		return FALSE

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || !I.action_proto)
			continue
		if(I.session.user != user)
			continue
		if(node_organ_type(I.actor_node_id) != SEX_ORGAN_PENIS)
			continue
		if(!I.action_proto.can_knot)
			continue
		return TRUE

	return FALSE

/datum/sex_session_tgui/proc/on_moved(atom/movable/mover, atom/oldloc, direction)
	SIGNAL_HANDLER

	if(!length(current_actions))
		return

	if(!ishuman(mover))
		return

	var/mob/living/carbon/human/H = mover
	var/list/to_stop = list()
	var/moved_breaks_any = FALSE

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I) || !I.action_proto)
			continue

		if(H != I.actor && H != I.partner)
			continue

		var/stop = FALSE
		if(!can_continue_action_session(I))
			stop = TRUE
		else
			var/datum/sex_panel_action/A = I.action_proto
			if(A.break_on_move)
				stop = TRUE
				moved_breaks_any = TRUE

		if(stop)
			to_stop += id

	for(var/id in to_stop)
		stop_instance(id)

	if(moved_breaks_any)
		to_chat(H, span_notice("Движение прерывает часть интимных действий."))

/proc/get_or_create_sex_session_tgui(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return get_or_create_sex_session_tgui_with_bodypart(user, target, null)

/proc/get_or_create_sex_session_tgui_with_bodypart(mob/living/carbon/human/user, mob/living/carbon/human/target, obj/item/bodypart/body_override)
	if(!user)
		return null

	var/list/sessions = return_sessions_with_user_tgui(user)
	var/datum/sex_session_tgui/session

	if(length(sessions))
		session = sessions[1]
	else
		session = new /datum/sex_session_tgui(user, target)

	if(target && target != user)
		session.add_partner(target)
		if(!session.current_partner_ref || !locate(session.current_partner_ref))
			session.current_partner_ref = REF(target)
			session.target = target

	if(body_override)
		session.set_partner_bodypart_override(body_override)

		if(istype(body_override, /obj/item/bodypart/head/dullahan))
			for(var/mob/living/carbon/human/erp_proxy/proxy in world)
				if(proxy.source_part == body_override)
					session.add_partner(proxy)
					session.current_partner_ref = REF(proxy)
					session.target = proxy

	session.update_knotted_penis_flag()
	return session

/datum/sex_session_tgui/proc/actions_matching_nodes()
	var/list/res = list()

	if(!selected_actor_organ_id || !selected_partner_organ_id)
		return res

	var/a_sel = selected_actor_organ_id
	var/p_sel = selected_partner_organ_id

	var/a_type = node_organ_type(a_sel)
	var/p_type = node_organ_type(p_sel)

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue

		if(a_sel == SEX_ORGAN_FILTER_BODY)
			if(A.required_init)
				continue
		else if(a_sel != SEX_ORGAN_FILTER_ALL)
			if(!A.required_init || !a_type || A.required_init != a_type)
				continue

		var/list/targets = A.get_filter_target_organ_types()
		if(p_sel == SEX_ORGAN_FILTER_BODY)
			if(targets && targets.len)
				continue
		else if(p_sel != SEX_ORGAN_FILTER_ALL)
			if(!targets || !p_type || !(p_type in targets))
				continue

		res += key

	return res

/datum/sex_session_tgui/proc/get_best_action_session_for(mob/living/carbon/human/U)
	if(!U || !length(current_actions))
		return null

	var/datum/sex_action_session/best = null
	var/best_score = -1

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I) || !I.action_proto)
			continue

		var/score = I.get_priority_for(U)
		if(score > best_score)
			best_score = score
			best = I

	return best

/datum/sex_session_tgui/proc/can_start_action_now(action_type)
	if(!action_type)
		return FALSE

	var/datum/sex_panel_action/A = SEX_PANEL_ACTION(action_type)
	if(!A)
		return FALSE

	var/a_id = pick_actor_node_for_action(A)
	var/p_id = pick_partner_node_for_action(A)

	return can_execute_action(A, a_id, p_id, TRUE)

/datum/sex_session_tgui/proc/is_partner_node_reserved(node_id, mob/living/carbon/human/P)
	if(!node_id || !P)
		return FALSE
	if(!length(current_actions))
		return FALSE

	var/candidate_type = node_organ_type(node_id)
	if(!candidate_type)
		return FALSE

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I) || !I.action_proto)
			continue

		if(I.partner != P)
			continue

		if(!I.action_proto.reserve_target_for_session)
			continue

		var/list/reserved_types = I.action_proto.get_reserved_target_organ_types()
		if(!islist(reserved_types) || !reserved_types.len)
			continue

		if(candidate_type in reserved_types)
			return TRUE

	return FALSE

/datum/sex_session_tgui/proc/can_execute_action(datum/sex_panel_action/A, actor_node_id, partner_node_id, perform_checks = FALSE)
	if(!A)
		return FALSE

	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/T = get_current_partner()

	var/a_id = actor_node_id
	var/p_id = partner_node_id

	var/a_type = a_id ? node_organ_type(a_id) : null
	var/p_type = p_id ? node_organ_type(p_id) : null

	if(a_type == SEX_ORGAN_PENIS && U)
		var/datum/component/knotting/K = U.GetComponent(/datum/component/knotting)
		if(K && K.knotted_status == KNOTTED_AS_TOP && K.knotted_recipient)
			if(A.can_knot)
				return FALSE

	if(A.required_init && a_type && A.required_init != a_type)
		return FALSE
	if(A.required_target && p_type && A.required_target != p_type)
		return FALSE

	if(!A.can_perform(U, T))
		return FALSE

	var/a_cat = a_id ? category_of_actor_node(a_id) : null
	if(a_cat && is_locked(a_cat))
		return FALSE

	if(perform_checks)
		if(A.required_init && !a_type)
			return FALSE
		if(A.required_target && !p_type)
			return FALSE

		if(p_id && T)
			var/mob/living/carbon/human/P = T
			if(P && is_partner_node_reserved(p_id, P))
				return FALSE

		if(!inherent_perform_check(A, U, T))
			return FALSE

	return TRUE

/datum/sex_session_tgui/proc/find_existing_action_session(action_key, actor_node_id, partner_node_id)
	if(!action_key || !actor_node_id || !partner_node_id)
		return null
	if(!length(current_actions))
		return null

	for(var/id in current_actions)
		var/datum/sex_action_session/I = current_actions[id]
		if(!I || QDELETED(I) || !I.action_proto)
			continue

		if(I.action_type != action_key)
			continue
		if(I.actor_node_id != actor_node_id)
			continue
		if(I.partner_node_id != partner_node_id)
			continue

		return I

	return null

/datum/sex_session_tgui/proc/is_node_busy_for_side(node_id, mob/living/carbon/human/M, side)
	if(!node_id || !M)
		return FALSE

	if(side == "actor")
		return !slot_available_for(node_id)

	if(side == "partner")
		return is_partner_node_reserved(node_id, M)

	return FALSE

/datum/sex_action_session/proc/should_hard_stop()
	var/mob/living/carbon/human/actor_h = actor
	var/mob/living/carbon/human/partner_h = partner

	if(actor_h && actor_h.is_erp_blocked_as_target())
		return TRUE

	if(partner_h && partner_h.is_erp_blocked_as_target())
		return TRUE

	return FALSE

/datum/sex_session_tgui/proc/hard_abort_for(mob/living/carbon/human/H)
	if(!(H in partners) && H != user && H != target)
		return

	for(var/mob/living/carbon/human/M in partners)
		if(M == H)
			continue
		to_chat(M, span_warning("[H] больше не готов продолжать."))

	qdel(src)

/datum/sex_session_tgui/proc/get_action_by_key(key)
	if(!key || !islist(GLOB.sex_panel_actions))
		return null
	return GLOB.sex_panel_actions[key]

/datum/sex_session_tgui/proc/build_custom_templates_for_ui()
	var/list/out = list()

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue
		if(A.abstract_type)
			continue
		if(!A.can_be_custom)
			continue
		if(A.ckey)
			continue

		var/base_kind = "generic"
		if(istype(A, /datum/sex_panel_action/self))
			base_kind = "self"
		else if(istype(A, /datum/sex_panel_action/other))
			base_kind = "other"

		out += list(list(
			"type" = key,
			"name" = A.name,
			"stamina_cost" = A.stamina_cost,
			"affects_self_arousal" = A.affects_self_arousal,
			"affects_arousal" = A.affects_arousal,
			"affects_self_pain" = A.affects_self_pain,
			"affects_pain" = A.affects_pain,
			"can_knot" = A.can_knot,
			"climax_liquid_mode_active" = A.climax_liquid_mode_active,
			"climax_liquid_mode_passive" = A.climax_liquid_mode_passive,

			"required_init" = organ_type_to_filter_id(A.required_init),
			"required_target" = organ_type_to_filter_id(A.required_target),
			"reserve_target_for_session" = A.reserve_target_for_session,
			"check_same_tile" = A.check_same_tile,
			"break_on_move" = A.break_on_move,

			"actor_sex_hearts" = A.actor_sex_hearts,
			"target_sex_hearts" = A.target_sex_hearts,
			"actor_suck_sound" = A.actor_suck_sound,
			"target_suck_sound" = A.target_suck_sound,
			"actor_make_sound" = A.actor_make_sound,
			"target_make_sound" = A.target_make_sound,
			"actor_make_fingering_sound" = A.actor_make_fingering_sound,
			"target_make_fingering_sound" = A.target_make_fingering_sound,
			"actor_do_onomatopoeia" = A.actor_do_onomatopoeia,
			"target_do_onomatopoeia" = A.target_do_onomatopoeia,
			"actor_do_thrust" = A.actor_do_thrust,
			"target_do_thrust" = A.target_do_thrust,

			"message_on_start" = A.message_on_start,
			"message_on_perform" = A.message_on_perform,
			"message_on_finish" = A.message_on_finish,
			"message_on_climax_actor" = A.message_on_climax_actor,
			"message_on_climax_target" = A.message_on_climax_target,

			"base_kind" = base_kind,
		))

	return out


/datum/sex_session_tgui/proc/build_custom_actions_for_ui()
	var/list/out = list()
	var/ck = user?.client?.ckey
	if(!ck || !islist(GLOB.sex_panel_actions))
		return out

	for(var/key in GLOB.sex_panel_actions)
		var/datum/sex_panel_action/A = GLOB.sex_panel_actions[key]
		if(!A)
			continue
		if(A.ckey != ck)
			continue
		
		var/base_kind = "generic"
		if(istype(A, /datum/sex_panel_action/self))
			base_kind = "self"
		else if(istype(A, /datum/sex_panel_action/other))
			base_kind = "other"

		out += list(list(
			"type" = A.custom_key,
			"name" = A.name,
			"stamina_cost" = A.stamina_cost,
			"affects_self_arousal" = A.affects_self_arousal,
			"affects_arousal" = A.affects_arousal,
			"affects_self_pain" = A.affects_self_pain,
			"affects_pain" = A.affects_pain,
			"can_knot" = A.can_knot,
			"climax_liquid_mode_active" = A.climax_liquid_mode_active,
			"climax_liquid_mode_passive" = A.climax_liquid_mode_passive,

			"required_init" = organ_type_to_filter_id(A.required_init),
			"required_target" = organ_type_to_filter_id(A.required_target),
			"reserve_target_for_session" = A.reserve_target_for_session,
			"check_same_tile" = A.check_same_tile,
			"break_on_move" = A.break_on_move,
			"base_kind" = base_kind,

			"actor_sex_hearts" = A.actor_sex_hearts,
			"target_sex_hearts" = A.target_sex_hearts,
			"actor_suck_sound" = A.actor_suck_sound,
			"target_suck_sound" = A.target_suck_sound,
			"actor_make_sound" = A.actor_make_sound,
			"target_make_sound" = A.target_make_sound,
			"actor_make_fingering_sound" = A.actor_make_fingering_sound,
			"target_make_fingering_sound" = A.target_make_fingering_sound,
			"actor_do_onomatopoeia" = A.actor_do_onomatopoeia,
			"target_do_onomatopoeia" = A.target_do_onomatopoeia,
			"actor_do_thrust" = A.actor_do_thrust,
			"target_do_thrust" = A.target_do_thrust,

			"message_on_start" = A.message_on_start,
			"message_on_perform" = A.message_on_perform,
			"message_on_finish" = A.message_on_finish,
			"message_on_climax_actor" = A.message_on_climax_actor,
			"message_on_climax_target" = A.message_on_climax_target,
		))

	return out

/datum/sex_session_tgui/proc/handle_custom_create(list/params)
	if(!user || !user.client)
		return

	var/template_type = params["template_type"]
	if(!template_type)
		return

	var/datum/sex_panel_action/base = get_action_by_key(template_type)
	if(!base || base.abstract_type || !base.can_be_custom)
		return

	var/datum/sex_panel_action/custom = new base.type
	custom.abstract_type = FALSE
	custom.ckey = user.client.ckey

	custom.required_init = base.required_init
	custom.required_target = base.required_target
	custom.armor_slot_init = null
	custom.armor_slot_target = null
	custom.can_knot = base.can_knot
	custom.reserve_target_for_session = base.reserve_target_for_session

	var/init_key = params["required_init"]
	if(init_key && init_key != ORG_KEY_NONE)
		custom.required_init = node_organ_type(init_key)

	var/target_key = params["required_target"]
	if(target_key && target_key != ORG_KEY_NONE)
		custom.required_target = node_organ_type(target_key)

	if("reserve_target_for_session" in params)
		custom.reserve_target_for_session = !!params["reserve_target_for_session"]

	if("can_knot" in params)
		custom.can_knot = !!params["can_knot"]

	if("check_same_tile" in params)
		custom.check_same_tile = !!params["check_same_tile"]
	if("break_on_move" in params)
		custom.break_on_move = !!params["break_on_move"]

	if("actor_sex_hearts" in params)
		custom.actor_sex_hearts = !!params["actor_sex_hearts"]
	if("target_sex_hearts" in params)
		custom.target_sex_hearts = !!params["target_sex_hearts"]

	if("actor_suck_sound" in params)
		custom.actor_suck_sound = !!params["actor_suck_sound"]
	if("target_suck_sound" in params)
		custom.target_suck_sound = !!params["target_suck_sound"]

	if("actor_make_sound" in params)
		custom.actor_make_sound = !!params["actor_make_sound"]
	if("target_make_sound" in params)
		custom.target_make_sound = !!params["target_make_sound"]

	if("actor_make_fingering_sound" in params)
		custom.actor_make_fingering_sound = !!params["actor_make_fingering_sound"]
	if("target_make_fingering_sound" in params)
		custom.target_make_fingering_sound = !!params["target_make_fingering_sound"]

	if("actor_do_onomatopoeia" in params)
		custom.actor_do_onomatopoeia = !!params["actor_do_onomatopoeia"]
	if("target_do_onomatopoeia" in params)
		custom.target_do_onomatopoeia = !!params["target_do_onomatopoeia"]

	if("actor_do_thrust" in params)
		custom.actor_do_thrust = !!params["actor_do_thrust"]
	if("target_do_thrust" in params)
		custom.target_do_thrust = !!params["target_do_thrust"]

	custom.name = params["name"] || base.name

	custom.stamina_cost = text2num(params["stamina_cost"] || "[base.stamina_cost]")
	custom.affects_self_arousal = text2num(params["affects_self_arousal"] || "[base.affects_self_arousal]")
	custom.affects_arousal = text2num(params["affects_arousal"] || "[base.affects_arousal]")
	custom.affects_self_pain = text2num(params["affects_self_pain"] || "[base.affects_self_pain]")
	custom.affects_pain = text2num(params["affects_pain"] || "[base.affects_pain]")

	custom.climax_liquid_mode_active = params["climax_liquid_mode_active"] || base.climax_liquid_mode_active
	custom.climax_liquid_mode_passive = params["climax_liquid_mode_passive"] || base.climax_liquid_mode_passive

	custom.message_on_start   = params["message_on_start"]   || base.message_on_start
	custom.message_on_perform = params["message_on_perform"] || base.message_on_perform
	custom.message_on_finish  = params["message_on_finish"]  || base.message_on_finish
	custom.message_on_climax_actor  = params["message_on_climax_actor"]  || base.message_on_climax_actor
	custom.message_on_climax_target = params["message_on_climax_target"] || base.message_on_climax_target

	register_custom_sex_action(custom)
	dirty_custom_actions = TRUE
	dirty_actions = TRUE

/datum/sex_session_tgui/proc/handle_custom_update(list/params)
	if(!user || !user.client)
		return

	var/key = params["type"]
	if(!key)
		return

	var/datum/sex_panel_action/A = get_action_by_key(key)
	if(A.ckey != user.client.ckey)
		return

	if(params["name"])
		A.name = params["name"]

	if(params["stamina_cost"])
		A.stamina_cost = text2num(params["stamina_cost"])
	if(params["affects_self_arousal"])
		A.affects_self_arousal = text2num(params["affects_self_arousal"])
	if(params["affects_arousal"])
		A.affects_arousal = text2num(params["affects_arousal"])
	if(params["affects_self_pain"])
		A.affects_self_pain = text2num(params["affects_self_pain"])
	if(params["affects_pain"])
		A.affects_pain = text2num(params["affects_pain"])

	if("required_init" in params)
		A.required_init = node_organ_type(params["required_init"])
	if("required_target" in params)
		A.required_target = node_organ_type(params["required_target"])

	if("reserve_target_for_session" in params)
		A.reserve_target_for_session = !!params["reserve_target_for_session"]
	if("can_knot" in params)
		A.can_knot = !!params["can_knot"]

	if("check_same_tile" in params)
		A.check_same_tile = !!params["check_same_tile"]
	if("break_on_move" in params)
		A.break_on_move = !!params["break_on_move"]

	if("actor_sex_hearts" in params)
		A.actor_sex_hearts = !!params["actor_sex_hearts"]
	if("target_sex_hearts" in params)
		A.target_sex_hearts = !!params["target_sex_hearts"]

	if("actor_suck_sound" in params)
		A.actor_suck_sound = !!params["actor_suck_sound"]
	if("target_suck_sound" in params)
		A.target_suck_sound = !!params["target_suck_sound"]

	if("actor_make_sound" in params)
		A.actor_make_sound = !!params["actor_make_sound"]
	if("target_make_sound" in params)
		A.target_make_sound = !!params["target_make_sound"]

	if("actor_make_fingering_sound" in params)
		A.actor_make_fingering_sound = !!params["actor_make_fingering_sound"]
	if("target_make_fingering_sound" in params)
		A.target_make_fingering_sound = !!params["target_make_fingering_sound"]

	if("actor_do_onomatopoeia" in params)
		A.actor_do_onomatopoeia = !!params["actor_do_onomatopoeia"]
	if("target_do_onomatopoeia" in params)
		A.target_do_onomatopoeia = !!params["target_do_onomatopoeia"]

	if("actor_do_thrust" in params)
		A.actor_do_thrust = !!params["actor_do_thrust"]
	if("target_do_thrust" in params)
		A.target_do_thrust = !!params["target_do_thrust"]

	if(params["climax_liquid_mode_active"])
		A.climax_liquid_mode_active = params["climax_liquid_mode_active"]
	if(params["climax_liquid_mode_passive"])
		A.climax_liquid_mode_passive = params["climax_liquid_mode_passive"]

	if(params["message_on_start"])
		A.message_on_start = params["message_on_start"]
	if(params["message_on_perform"])
		A.message_on_perform = params["message_on_perform"]
	if(params["message_on_finish"])
		A.message_on_finish = params["message_on_finish"]
	if(params["message_on_climax_actor"])
		A.message_on_climax_actor = params["message_on_climax_actor"]
	if(params["message_on_climax_target"])
		A.message_on_climax_target = params["message_on_climax_target"]

	dirty_custom_actions = TRUE
	dirty_actions = TRUE

/datum/sex_session_tgui/proc/handle_custom_delete(list/params)
	if(!user || !user.client)
		return

	var/key = params["type"]
	if(!key)
		return

	var/datum/sex_panel_action/A = get_action_by_key(key)
	if(!A)
		return

	if(A.ckey != user.client.ckey)
		return

	dirty_custom_actions = TRUE
	dirty_actions = TRUE

	unregister_custom_sex_action(A)
	qdel(A)

/datum/sex_session_tgui/proc/dispatch_sex_message(mob/living/carbon/human/user, mob/living/carbon/human/target,	message)
	if(!message)
		return

	if(!hidden_mode)
		if(user)
			user.visible_message(message)
		return

	var/list/receivers = list()

	if(user)
		receivers |= user
	if(target)
		receivers |= target

	for(var/mob/living/carbon/human/P in partners)
		if(P)
			receivers |= P

	for(var/mob/living/carbon/human/H in receivers)
		if(get_dist(user, H) <= 2)
			to_chat(H, message)

