/datum/erp_controller_actions
	var/datum/erp_controller/controller

/datum/erp_controller_actions/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Gets action by type path or id (core+custom).
/datum/erp_controller_actions/proc/get_action_by_id_or_path(action_type)
	if(!action_type)
		return null

	var/datum/erp_action/A = SSerp.get_action(action_type)
	if(A)
		return A

	for(var/k in SSerp.actions)
		var/datum/erp_action/T = SSerp.actions[k]
		if(T && T.id == action_type)
			return T

	for(var/datum/erp_action/CA in controller.owner.custom_actions)
		if(CA.id == action_type)
			return CA

	return null

/// Returns all actions filtered by self/other scope.
/datum/erp_controller_actions/proc/get_all_actions_for_ui(datum/erp_actor/actor, datum/erp_actor/partner)
	var/list/out = list()
	var/is_self = FALSE

	if(actor && partner)
		if(actor == partner)
			is_self = TRUE
		else if(actor.physical && partner.physical && actor.physical == partner.physical)
			is_self = TRUE

	for(var/k in SSerp.actions)
		var/datum/erp_action/A = SSerp.actions[k]
		if(!A || A.abstract)
			continue

		if(is_self)
			if(A.action_scope != ERP_SCOPE_SELF)
				continue
		else
			if(A.action_scope != ERP_SCOPE_OTHER)
				continue

		out += A

	for(var/datum/erp_action/A2 in controller.owner.custom_actions)
		if(!A2 || A2.abstract)
			continue

		if(is_self)
			if(A2.action_scope != ERP_SCOPE_SELF)
				continue
		else
			if(A2.action_scope != ERP_SCOPE_OTHER)
				continue

		out += A2

	return out

/datum/erp_controller_actions/proc/validate_action(datum/erp_action/A, datum/erp_sex_organ/init, datum/erp_sex_organ/target, datum/erp_action_context/ctx)
	if(!A)
		return "Нет действия."
	if(!init)
		return "Нет органа-инициатора."
	if(!target)
		return "Нет цели."
	if(!controller.active_partner)
		return "Нет партнёра."

	if(ctx.distance > 1)
		return "Слишком далеко."

	if(A.require_same_tile && !(ctx.same_tile || ctx.has_passive_grab))
		return "Нужно быть на одном тайле или держать партнёра."

	if(A.require_grab && !ctx.has_aggressive_grab)
		return "Нужен более сильный захват."

	if(A.required_init_organ && init.erp_organ_type != A.required_init_organ)
		return "Нужен другой орган-инициатор."

	if(A.required_target_organ && target.erp_organ_type != A.required_target_organ)
		return "Нужна другая цель."

	if(!ctx.has_passive_grab)
		var/it = init.erp_organ_type
		if(!(it in ctx.self_access))
			ctx.self_access[it] = controller.owner.is_organ_accessible_for(controller.owner, it, FALSE)

		if(!ctx.self_access[it])
			return "Орган-инициатор закрыт одеждой."

		var/tt = target.erp_organ_type
		if(!(tt in ctx.other_access))
			ctx.other_access[tt] = controller.active_partner.is_organ_accessible_for(controller.owner, tt, FALSE)

		if(!ctx.other_access[tt])
			return "Цель закрыта одеждой."

	if(init.get_free_slots() <= 0)
		return "Орган занят."

	if(islist(A.action_tags) && ("testicles" in A.action_tags))
		if(!controller.active_partner.has_testicles())
			return "У цели нет тестикул."

	if(A.inject_timing != INJECT_NONE && A.inject_target_mode == INJECT_CONTAINER)
		if(!ctx.has_container)
			return "Нужен контейнер с реагентами рядом."

	if(islist(A.required_item_tags) && A.required_item_tags.len)
		if(!has_required_item_tags(controller.owner, A.required_item_tags))
			return "Нужен определенный предмет."

	if(istype(init, /datum/erp_sex_organ/penis))
		var/datum/erp_sex_organ/penis/P = init

		if(P.have_knot)
			var/mob/living/top = P.get_owner()
			var/datum/component/erp_knotting/K = controller.knot_d?.get_knotting_component(top)

			if(K)
				var/max_units = max(1, P.count_to_action)
				var/can_use_any = FALSE
				for(var/i = 0; i < max_units; i++)
					if(K.can_start_action_with_penis(P, target, i))
						can_use_any = TRUE
						break

				if(!can_use_any)
					return "Все узлы зафиксированы."

	return null

/// Builds action list UI for current active partner and type filters.
/datum/erp_controller_actions/proc/get_action_list_ui(actor_type, partner_type)
	var/list/out = list()

	if(!controller.active_partner)
		return out

	// собираем контекст один раз
	var/datum/erp_action_context/ctx = build_action_context()

	var/list/p1 = pick_first_by_type(controller.owner, TRUE)
	var/list/p2 = pick_first_by_type(controller.active_partner, FALSE)

	var/datum/erp_sex_organ/any_init = p1["any"]
	var/list/init_by = p1["by"]

	var/datum/erp_sex_organ/any_tgt = p2["any"]
	var/list/tgt_by = p2["by"]

	var/datum/erp_sex_organ/forced_init = null
	if(actor_type)
		forced_init = init_by[actor_type]

	var/datum/erp_sex_organ/forced_tgt = null
	if(partner_type)
		forced_tgt = tgt_by[partner_type]

	for(var/datum/erp_action/Act in get_all_actions_for_ui(controller.owner, controller.active_partner))
		if(!Act || Act.abstract)
			continue

		// фильтр по выбранному типу органов
		if(actor_type && Act.required_init_organ && Act.required_init_organ != actor_type)
			continue
		if(partner_type && Act.required_target_organ && Act.required_target_organ != partner_type)
			continue

		// подбираем орган-инициатор
		var/datum/erp_sex_organ/init = forced_init
		if(!init)
			if(Act.required_init_organ)
				init = init_by[Act.required_init_organ]
			else
				init = any_init

		// подбираем орган-цель
		var/datum/erp_sex_organ/tgt = forced_tgt
		if(!tgt)
			if(Act.required_target_organ)
				tgt = tgt_by[Act.required_target_organ]
			else
				tgt = any_tgt

		var/reason = validate_action(Act, init, tgt, ctx)

		out += list(list(
			"id" = Act.id,
			"name" = Act.name,
			"can" = isnull(reason),
			"reason" = reason,
			"tags" = Act.action_tags,
			"is_custom" = (Act in controller.owner.custom_actions)
		))

	return out

/// Checks if action can start.
/datum/erp_controller_actions/proc/can_start_action(datum/erp_action/A, datum/erp_sex_organ/init, datum/erp_sex_organ/target)
	return isnull(get_action_block_reason(A, init, target))

/// Returns string reason why action cannot start (or null).
/datum/erp_controller_actions/proc/get_action_block_reason(datum/erp_action/A, datum/erp_sex_organ/init, datum/erp_sex_organ/target)
	if(!controller)
		return "Нет контроллера."

	var/datum/erp_action_context/ctx = build_action_context()

	return validate_action(A, init, target, ctx)

/// Checks if actor holds required tagged items.
/datum/erp_controller_actions/proc/has_required_item_tags(datum/erp_actor/A, list/required_tags)
	if(!A || !islist(required_tags) || !required_tags.len)
		return TRUE

	var/mob/living/M = A.get_effect_mob()
	if(!M)
		return FALSE

	var/obj/item/I1 = M.get_active_held_item()
	if(item_has_any_tag(I1, required_tags))
		return TRUE

	var/obj/item/I2 = M.get_inactive_held_item()
	if(item_has_any_tag(I2, required_tags))
		return TRUE

	return FALSE

/// Checks if item or it's namehas any of required tags.
/datum/erp_controller_actions/proc/item_has_any_tag(obj/item/I, list/required_tags)
	if(!istype(I) || !islist(required_tags) || !required_tags.len)
		return FALSE

	var/name_lower = lowertext(I.name)
	if(islist(I.erp_item_tags) && I.erp_item_tags.len)
		for(var/t in required_tags)
			if(t in I.erp_item_tags)
				return TRUE

	for(var/t in required_tags)
		if(!istext(t))
			continue

		var/tag_lower = lowertext("[t]")
		if(findtext(name_lower, tag_lower))
			return TRUE

	return FALSE

/// Picks first free organ by type and any.
/datum/erp_controller_actions/proc/pick_first_by_type(datum/erp_actor/A, require_free = TRUE)
	var/list/by = list()
	var/datum/erp_sex_organ/any = null

	for(var/datum/erp_sex_organ/O in A.get_organs_ref())
		if(!O)
			continue
		if(require_free && O.get_free_slots() <= 0)
			continue

		if(!any)
			any = O
		if(!by[O.erp_organ_type])
			by[O.erp_organ_type] = O

	return list("any" = any, "by" = by)

/// Normalizes organ type value (number or trimmed text).
/datum/erp_controller_actions/proc/normalize_organ_type(v)
	if(isnull(v))
		return null
	if(isnum(v))
		return v

	var/t = "[v]"
	t = trim(t)
	if(!length(t) || t == "null")
		return null

	var/n = text2num(t)
	if(isnum(n) && "[n]" == t)
		return n

	return t
