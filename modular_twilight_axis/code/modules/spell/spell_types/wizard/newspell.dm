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
	if(!user.mind) return data

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
		if(status == "tier" || status == "evil") continue
		possible_spells += spell_type
		var/obj/effect/proc_holder/spell/S = spell_type
		sorter[spell_type] = initial(S.spell_tier) * 1000 + initial(S.cost)
	
	possible_spells = sortList(sorter)

	var/list/spells_to_send = list()
	for(var/spell_type in possible_spells)
		var/obj/effect/proc_holder/spell/S = spell_type
		var/status = can_learn_spell(user, spell_type, TRUE)
		
		var/icon_file = initial(S.action_icon) || 'icons/mob/actions/roguespells.dmi'
		var/icon_state_str = initial(S.overlay_state) || initial(S.action_icon_state)
		var/icon/I = (icon_state_str in icon_states(icon_file)) ? icon(icon_file, icon_state_str) : icon('icons/mob/actions/roguespells.dmi', "spell")

		spells_to_send += list(list(
			"name" = initial(S.name),
			"desc" = initial(S.desc),
			"cost" = initial(S.cost),
			"tier" = initial(S.spell_tier),
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
			if(!ispath(spell_path)) return TRUE
			
			var/status = can_learn_spell(user, spell_path, TRUE)
			if(status != "ok") return TRUE

			var/obj/effect/proc_holder/spell/S_Type = spell_path
			var/cost = initial(S_Type.cost)
			
			if(user.mind)
				var/obj/effect/proc_holder/spell/new_spell = new spell_path()
				new_spell.refundable = TRUE 

				if(LAZYLEN(user.mind.spell_point_pools))
					for(var/pool_name in user.mind.spell_point_pools)
						var/list/pool_spells = get_spell_pool_list(pool_name)
						if(spell_path in pool_spells)
							user.mind.spell_points_used_by_pool[pool_name] += cost
							new_spell.learned_from_pool = pool_name
							break
				else
					user.mind.used_spell_points += cost
				
				user.mind.AddSpell(new_spell)
				addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
				to_chat(user, span_notice("You have woven <b>[initial(S_Type.name)]</b>!")) 
				playsound(user, 'sound/magic/lightning.ogg', 50, 1) 
			return TRUE
	return ..()


/obj/effect/proc_holder/spell/self/library/proc/can_learn_spell(mob/user, spell_type, check_cost = TRUE)
	var/obj/effect/proc_holder/spell/S = spell_type
	if(!user || !user.mind) return "error"
	
	for(var/obj/effect/proc_holder/spell/known in user.mind.spell_list)
		if(known.type == spell_type) return "known"

	if(initial(S.zizo_spell) > get_user_evilness(user)) return "evil"
	if(initial(S.spell_tier) > get_user_spell_tier(user)) return "tier"

	if(check_cost)
		var/cost = initial(S.cost)
		if(LAZYLEN(user.mind.spell_point_pools))
			var/can_afford = FALSE
			for(var/pool_name in user.mind.spell_point_pools)
				var/list/pool_spells = get_spell_pool_list(pool_name)
				if(spell_type in pool_spells)
					var/max_pts = user.mind.spell_point_pools[pool_name]
					var/used_pts = user.mind.spell_points_used_by_pool?[pool_name] || 0
					if((max_pts - used_pts) >= cost) can_afford = TRUE
					break
			if(!can_afford) return "cost"
		else
			var/points_left = user.mind.spell_points - user.mind.used_spell_points
			if(cost > points_left) return "cost"
	return "ok"
