/*
/obj/effect/proc_holder/spell/self/library
	name = "Compendium of Arcane Arts"
	desc = "Summon the knowledge of the arcane library to learn new spells."
	school = "transmutation"
	overlay_state = "book1"
	chargedrain = 0
	chargetime = 0
	var/hide_unavailable = FALSE

/obj/effect/proc_holder/spell/self/library/cast(list/targets, mob/user = usr)
	. = ..()
	if(!GLOB.learnable_spells)
		return
	if(!user.mind)
		return
	ui_interact(user)

/obj/effect/proc_holder/spell/self/library/ui_state(mob/user)
	return GLOB.conscious_state

/obj/effect/proc_holder/spell/self/library/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user << browse_rsc('html/KettleParallaxBG.png', "bg_texture.png")

		ui = new(user, src, "SpellLibrary")
		ui.open()

/obj/effect/proc_holder/spell/self/library/ui_data(mob/user)
	var/list/data = list()
	if(!user.mind)
		return data

	if(LAZYLEN(user.mind.spell_point_pools))
		var/list/pools_data = list()
		for(var/pool_name in user.mind.spell_point_pools)
			var/max_pts = user.mind.spell_point_pools[pool_name]
			var/used_pts = user.mind.spell_points_used_by_pool?[pool_name] || 0
			pools_data += list(list(
				"name" = capitalize(pool_name),
				"remaining" = max_pts - used_pts,
				"max" = max_pts
			))
		data["spell_pools"] = pools_data
	else
		data["user_points"] = user.mind.spell_points - user.mind.used_spell_points

	data["hide_unavailable"] = hide_unavailable

	var/list/possible_spells = list()
	var/list/sorter = list()

	for(var/spell_type in GLOB.learnable_spells)
		var/status = can_learn_spell(user, spell_type, FALSE)
		if(status == "tier" || status == "evil")
			continue
		if(hide_unavailable)
			var/visible_status = can_learn_spell(user, spell_type, TRUE)
			if(visible_status != "ok" && visible_status != "known")
				continue

		possible_spells += spell_type

		var/tier = get_spell_tier(spell_type)
		var/cost = get_spell_cost(spell_type)
		sorter[spell_type] = (tier * 1000) + cost

	possible_spells = sortList(sorter)

	var/list/spells_to_send = list()
	for(var/spell_type in possible_spells)
		var/status = can_learn_spell(user, spell_type, TRUE)
		var/icon/I = get_spell_icon(spell_type)

		spells_to_send += list(list(
			"name" = get_spell_name(spell_type),
			"desc" = get_spell_desc(spell_type),
			"cost" = get_spell_cost(spell_type),
			"tier" = get_spell_tier(spell_type),
			"path" = "[spell_type]",
			"img64" = icon2base64(I),
			"is_known" = (status == "known"),
			"can_afford" = (status == "ok")
		))

	data["spells"] = spells_to_send
	return data

/obj/effect/proc_holder/spell/self/library/ui_act(action, list/params, datum/tgui/ui)
	var/mob/living/user = ui.user

	switch(action)
		if("toggle_filter")
			hide_unavailable = !hide_unavailable
			return TRUE

		if("learn")
			var/spell_path = text2path(params["path"])
			if(!ispath(spell_path))
				return TRUE

			var/status = can_learn_spell(user, spell_path, TRUE)
			if(status != "ok")
				return TRUE

			var/cost = get_spell_cost(spell_path)
			var/learned_pool = null

			if(user.mind)
				if(LAZYLEN(user.mind.spell_point_pools))
					if(!islist(user.mind.spell_points_used_by_pool))
						user.mind.spell_points_used_by_pool = list()

					for(var/pool_name in user.mind.spell_point_pools)
						var/list/pool_spells = get_spell_pool_list(pool_name)
						if(spell_path in pool_spells)
							user.mind.spell_points_used_by_pool[pool_name] += cost
							learned_pool = pool_name
							break
				else
					user.mind.used_spell_points += cost

				learn_spell_from_path(user, spell_path, learned_pool)
				addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
				to_chat(user, span_notice("You have woven <b>[get_spell_name(spell_path)]</b>!"))
				playsound(user, 'sound/magic/lightning.ogg', 50, 1)

			return TRUE

	return ..()

/// Get the spell cost from a typepath (works for both old proc_holder and new action spells)
/obj/effect/proc_holder/spell/self/library/proc/get_spell_cost(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.point_cost) || 0

	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.cost) || 0

/// Get the spell tier from a typepath (works for both types)
/obj/effect/proc_holder/spell/self/library/proc/get_spell_tier(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.spell_tier) || 0

	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.spell_tier) || 0

/// Get the spell name from a typepath
/obj/effect/proc_holder/spell/self/library/proc/get_spell_name(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.name)

	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.name)

/// Get the spell desc from a typepath
/obj/effect/proc_holder/spell/self/library/proc/get_spell_desc(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.desc)

	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.desc)

/// Get the zizo flag from a typepath
/obj/effect/proc_holder/spell/self/library/proc/get_spell_zizo(spell_path)
	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		return initial(S.zizo_spell) || 0

	var/obj/effect/proc_holder/spell/S = spell_path
	return initial(S.zizo_spell) || 0

/// Build a spell icon for the UI (supports both proc_holder spells and action spells)
/obj/effect/proc_holder/spell/self/library/proc/get_spell_icon(spell_path)
	var/icon_file = 'icons/mob/actions/roguespells.dmi'
	var/icon_state_str = "spell"

	if(ispath(spell_path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = spell_path
		if(initial(S.button_icon))
			icon_file = initial(S.button_icon)
		if(initial(S.button_icon_state))
			icon_state_str = initial(S.button_icon_state)
	else
		var/obj/effect/proc_holder/spell/S = spell_path
		if(initial(S.action_icon))
			icon_file = initial(S.action_icon)
		if(initial(S.overlay_state))
			icon_state_str = initial(S.overlay_state)
		else if(initial(S.action_icon_state))
			icon_state_str = initial(S.action_icon_state)

	if(!(icon_state_str in icon_states(icon_file)))
		icon_file = 'icons/mob/actions/roguespells.dmi'
		icon_state_str = "spell"

	return icon(icon_file, icon_state_str)

/// Check if user already knows a spell by typepath (checks both spell systems)
/obj/effect/proc_holder/spell/self/library/proc/user_knows_spell(mob/user, spell_path)
	if(!user?.mind)
		return FALSE

	for(var/datum/known in user.mind.spell_list)
		if(known.type == spell_path)
			return TRUE

	return FALSE

/// Instantiate and add a spell from a typepath (handles both types)
/obj/effect/proc_holder/spell/self/library/proc/learn_spell_from_path(mob/user, spell_path, pool_name = null)
	var/datum/new_spell = new spell_path

	if(istype(new_spell, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/action_spell = new_spell
		action_spell.refundable = TRUE
		if(pool_name)
			action_spell.learned_from_pool = pool_name
	else if(istype(new_spell, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/proc_spell = new_spell
		proc_spell.refundable = TRUE
		if(pool_name)
			proc_spell.learned_from_pool = pool_name

	user.mind.AddSpell(new_spell)
	return TRUE

/obj/effect/proc_holder/spell/self/library/proc/can_learn_spell(mob/user, spell_type, check_cost = TRUE)
	if(!user || !user.mind)
		return "error"

	if(user_knows_spell(user, spell_type))
		return "known"

	if(get_spell_zizo(spell_type) > get_user_evilness(user))
		return "evil"

	if(get_spell_tier(spell_type) > get_user_spell_tier(user))
		return "tier"

	if(check_cost)
		var/cost = get_spell_cost(spell_type)

		if(LAZYLEN(user.mind.spell_point_pools))
			var/can_afford = FALSE

			for(var/pool_name in user.mind.spell_point_pools)
				var/list/pool_spells = get_spell_pool_list(pool_name)
				if(spell_type in pool_spells)
					var/max_pts = user.mind.spell_point_pools[pool_name]
					var/used_pts = user.mind.spell_points_used_by_pool?[pool_name] || 0
					if((max_pts - used_pts) >= cost)
						can_afford = TRUE
					break

			if(!can_afford)
				return "cost"
		else
			var/points_left = user.mind.spell_points - user.mind.used_spell_points
			if(cost > points_left)
				return "cost"

	return "ok"
*/