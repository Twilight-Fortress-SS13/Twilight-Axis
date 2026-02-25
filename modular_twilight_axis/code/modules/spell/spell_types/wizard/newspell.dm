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
	
	
	var/points_avail = 0
	if(user.mind)
		points_avail = user.mind.spell_points - user.mind.used_spell_points
	
	data["user_points"] = points_avail
	data["hide_unavailable"] = hide_unavailable


	var/list/possible_spells = list()
	
	for(var/spell_type in GLOB.learnable_spells)
		
		var/status = can_learn_spell(user, spell_type, check_cost = FALSE)
		if(status == "tier" || status == "evil")
			continue
		possible_spells += spell_type

	
	var/len = possible_spells.len
	if(len > 1)
		for(var/i = 1 to len)
			for(var/j = 1 to len - i)
				var/pathA = possible_spells[j]
				var/pathB = possible_spells[j+1]
				

				var/obj/effect/proc_holder/spell/A = pathA
				var/obj/effect/proc_holder/spell/B = pathB
				
				var/tierA = initial(A.spell_tier)
				var/tierB = initial(B.spell_tier)
				var/costA = initial(A.cost)
				var/costB = initial(B.cost)
				
				var/swap = FALSE
				
				if(tierA > tierB)
					swap = TRUE
				else if(tierA == tierB)
					if(costA > costB)
						swap = TRUE
				
				if(swap)
					possible_spells.Swap(j, j+1)


	var/list/spells = list()
	
	for(var/spell_type in possible_spells)
		var/obj/effect/proc_holder/spell/S = spell_type
		
		var/status = can_learn_spell(user, spell_type, check_cost = FALSE)
		
		var/can_afford = (can_learn_spell(user, spell_type, check_cost = TRUE) != "cost")
		var/is_known = (status == "known")
		
		var/icon_file = initial(S.action_icon)
		var/icon_state_str = initial(S.overlay_state) || initial(S.action_icon_state)
		
		if(!icon_file) icon_file = 'icons/mob/actions/roguespells.dmi' 
		
		var/icon/final_icon_obj = null
		
	
		var/list/valid_states = icon_states(icon_file)

		
		if(icon_state_str && (icon_state_str in valid_states))
			final_icon_obj = icon(icon_file, icon_state_str)
		else
			
			final_icon_obj = icon('icons/mob/actions/roguespells.dmi', "spell")

		var/icon_base64 = null
		if(final_icon_obj)
			try
				icon_base64 = icon2base64(final_icon_obj)
			catch
				icon_base64 = null

		var/list/spell_data = list(
			"name" = initial(S.name),
			"desc" = initial(S.desc),
			"cost" = initial(S.cost),
			"tier" = initial(S.spell_tier),
			"path" = "[spell_type]", 
			"img64" = icon_base64,
			"is_known" = is_known,
			"can_afford" = can_afford
		)
		
		spells += list(spell_data)
	
	data["spells"] = spells
	return data

/obj/effect/proc_holder/spell/self/library/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/living/user = ui.user

	switch(action)
		if("toggle_filter")
			hide_unavailable = !hide_unavailable
			return TRUE 

		if("learn")
			var/path_text = params["path"]
			if(!path_text) return TRUE

			
			var/spell_path = text2path(path_text)
			
			
			if(!ispath(spell_path))
				return TRUE

			
			if(!(spell_path in GLOB.learnable_spells))
				return TRUE

			
			var/status = can_learn_spell(user, spell_path, check_cost = TRUE)
			if(status != "ok")
				return TRUE

			var/obj/effect/proc_holder/spell/S_Type = spell_path
			var/cost = initial(S_Type.cost)
			var/spell_name = initial(S_Type.name)
			
			if(user.mind)
				user.mind.used_spell_points += cost
				
				
				var/obj/effect/proc_holder/spell/new_spell = new spell_path()
				new_spell.refundable = TRUE 
				user.mind.AddSpell(new_spell)
				
				
				addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
				
				to_chat(user, span_notice("You have woven <b>[spell_name]</b> into your mind!")) 
				playsound(user, 'sound/magic/lightning.ogg', 50, 1) 
			
			return TRUE

	return ..()

/obj/effect/proc_holder/spell/self/library/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/living/user = ui.user

	switch(action)
		if("toggle_filter")
			hide_unavailable = !hide_unavailable
			return TRUE 

		if("learn")
			var/path_text = params["path"]
			if(!path_text) return TRUE

			var/spell_path = text2path(path_text)
			
			if(!ispath(spell_path))
				return TRUE

			if(!(spell_path in GLOB.learnable_spells))
				return TRUE

			var/status = can_learn_spell(user, spell_path, check_cost = TRUE)
			if(status != "ok")
				return TRUE

			var/obj/effect/proc_holder/spell/S_Type = spell_path
			var/cost = initial(S_Type.cost)
			var/spell_name = initial(S_Type.name)
			
			if(user.mind)
				user.mind.used_spell_points += cost
				var/obj/effect/proc_holder/spell/new_spell = new spell_path()
				new_spell.refundable = TRUE 
				user.mind.AddSpell(new_spell)
				addtimer(CALLBACK(user.mind, TYPE_PROC_REF(/datum/mind, check_learnspell)), 2 SECONDS)
				
				to_chat(user, span_notice("You have woven <b>[spell_name]</b> into your mind!")) 
				playsound(user, 'sound/magic/lightning.ogg', 50, 1) 
			
			return TRUE

	return ..()

/obj/effect/proc_holder/spell/self/library/proc/can_learn_spell(mob/user, spell_type, check_cost = TRUE)
	var/obj/effect/proc_holder/spell/S = spell_type
	
	for(var/obj/effect/proc_holder/spell/known in user.mind.spell_list)
		if(known.type == spell_type) return "known"

	if(initial(S.zizo_spell) > get_user_evilness(user)) return "evil"
	if(initial(S.spell_tier) > get_user_spell_tier(user)) return "tier"

	if(check_cost)
		var/points_left = user.mind.spell_points - user.mind.used_spell_points
		if(initial(S.cost) > points_left) return "cost"
            
	return "ok"
