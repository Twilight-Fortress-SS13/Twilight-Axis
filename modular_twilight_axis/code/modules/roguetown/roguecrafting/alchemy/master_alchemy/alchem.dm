/obj/machinery/alch_workbench
	name = "Great Alchemical Laboratory"
	desc = "A massive setup for legendary alchemy. It spans exactly two tiles."
	icon = 'modular_twilight_axis/icons/roguetown/misc/Lab.dmi'
	icon_state = "labs"
	
	density = TRUE
	anchored = TRUE


	bound_width = 64
	bound_height = 32
	bound_x = 0
	bound_y = 0
	pixel_x = 0
	pixel_y = -16

	var/upgrade_level = 1
	var/on = TRUE
	var/amount_per_transfer = 10 

	var/list/obj/item/alch/slots = list(null, null, null, null, null, null)
	var/list/slot_links = list()
	
	var/list/discovered_recipes = list()
	var/list/partial_knowledge = list()

	var/list/obj/item/crafting_grid = list(null, null, null, null, null, null, null, null, null)
	var/obj/item/transmute_slot = null

	var/obj/item/reagent_containers/beaker_1 = null
	var/obj/item/reagent_containers/beaker_2 = null
	
	var/flour_efficiency = 0
	var/datum/reagents/pill_buffer
	var/lux_charges = 0
	var/max_lux_charges = 1000 

/obj/machinery/alch_workbench/Initialize(mapload)
	. = ..()
	create_reagents(500, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE | TRANSPARENT)
	pill_buffer = new /datum/reagents(100)
	pill_buffer.my_atom = src
	var/datum/component/storage/concrete/STR = AddComponent(/datum/component/storage/concrete/roguetown/bin)
	if(STR)
		STR.grid = TRUE
		STR.max_items = 30
		STR.screen_max_columns = 6
		STR.screen_max_rows = 5
	update_icon()


/obj/machinery/alch_workbench/is_refillable()
	return TRUE

/obj/machinery/alch_workbench/is_drainable()
	return TRUE

/obj/machinery/alch_workbench/attack_hand(mob/user)
	if(on)
		interact(user)
	else
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR?.show_to(user)

/obj/machinery/alch_workbench/update_icon()
	. = ..()
	cut_overlays()
	
	if(upgrade_level <= 1)
		icon_state = "labs"
	else
		icon_state = "labs[upgrade_level]"

	if(reagents && reagents.total_volume > 0)
		var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_full")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/machinery/alch_workbench/process()
	..()
	var/update_needed = FALSE
	for(var/i in 1 to 6)
		var/obj/item/I = slots[i]
		if(I && !(I in src.contents))
			slots[i] = null
			var/list/new_links = list()
			for(var/list/L in slot_links)
				if(L[1] != i && L[2] != i) new_links += list(L)
			slot_links = new_links
			update_needed = TRUE
			

	for(var/i in 1 to 9)
		var/obj/item/C = crafting_grid[i]
		if(C && !(C in src.contents))
			crafting_grid[i] = null
			update_needed = TRUE

	if(transmute_slot && !(transmute_slot in src.contents))
		transmute_slot = null
		update_needed = TRUE
	if(update_needed) update_icon()
	if(beaker_1 && !(beaker_1 in src.contents)) beaker_1 = null
	if(beaker_2 && !(beaker_2 in src.contents)) beaker_2 = null

/obj/machinery/alch_workbench/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/C = I

		if(upgrade_level < 3)
			to_chat(user, span_warning("На этом этапе лаборатория не имеет работающего котла. Потребуются золотые змеевики (Ур. 3)!"))
			return TRUE

		if(user.used_intent.type == INTENT_POUR)
			if(!C.reagents.total_volume || reagents.holder_full()) return TRUE
			user.visible_message(span_notice("[user] начинает заливать [C] в [src]."))
			if(C.poursounds) playsound(user.loc, pick(C.poursounds), 100, TRUE)
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(!C.reagents.total_volume || reagents.holder_full()) break
					C.reagents.trans_to(src, amount_per_transfer, transfered_by = user)
					update_icon()
				else break
			return TRUE

		if(user.used_intent.type == /datum/intent/fill)
			if(!reagents.total_volume || C.reagents.holder_full()) return TRUE
			user.visible_message(span_notice("[user] наполняет [C] из [src]."))
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(!reagents.total_volume || C.reagents.holder_full()) break
					reagents.trans_to(C, amount_per_transfer, transfered_by = user)
					update_icon()
				else break
			return TRUE

	return ..()


/obj/machinery/alch_workbench/proc/check_grid_recipe()

    for(var/datum/alch_grid_recipe/R in GLOB.alch_grid_recipes)
        if(!R.result_type) continue
        
        var/match = TRUE
        for(var/i in 1 to 9)
            var/obj/item/I = crafting_grid[i]
            var/req = R.grid[i]
            

            if(!req && I) { match = FALSE; break }

            if(req && !I) { match = FALSE; break }

            if(req && I && !istype(I, req)) { match = FALSE; break }
            
        if(match) return R
    return null


/obj/machinery/alch_workbench/ui_interact(mob/user, datum/tgui/ui)
	if(!GLOB.alchemy_index_initialized)
		var/datum/alchemy_dynamic_manager/ADM = GLOB.alchemy_dynamic_manager
		if(ADM)
			ADM.build_transmute_index()
			GLOB.alchemy_index_initialized = TRUE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AlchemyWorkbench", name)
		ui.open()

/obj/machinery/alch_workbench/ui_data(mob/user)
	var/list/data = list()
	data["upgrade_lvl"] = upgrade_level
	var/list/reagent_data = list()

	data["lux_tank"] = list(
		"charges" = lux_charges, 
		"max" = max_lux_charges
		)
		
	if(reagents && reagents.reagent_list.len)
		for(var/datum/reagent/R in reagents.reagent_list)
			reagent_data += list(list(
				"name" = R.name,
				"volume" = round(R.volume, 0.1),
				"color" = R.color || "#3498db"
			))
	
	data["reagents"] = reagent_data
	data["total_volume"] = reagents ? round(reagents.total_volume, 0.1) : 0
	data["max_volume"] = reagents ? reagents.maximum_volume : 500
	
	var/req_text = "Максимальный уровень достигнут."
	switch(upgrade_level)
		if(1) req_text = "Требуется: 1 Железный слиток (положите в склад стола)"
		if(2) req_text = "Требуется: 1 Золотой слиток (положите в склад стола)"
		if(3) req_text = "Требуется: 1 Алмаз, 1 Загадка Стали, 2 Синих самоцвета, 4 Огненной пыли 2 чистых люкса (положите в склад стола)"
	data["next_upgrade_req"] = req_text


	var/list/s_data = list()
	for(var/i in 1 to 6)
		var/obj/item/alch/SL = slots[i]
		var/icon_base64 = null
		if(SL)
			var/icon/I = icon(SL.icon, SL.icon_state, frame = 1)
			if(I) icon_base64 = "data:image/png;base64,[icon2base64(I)]"

		s_data += list(list(
			"name" = SL ? SL.name : "Empty",
			"ref" = SL ? "\ref[SL]" : null,
			"smell" = SL ? SL.major_smell : null,
			"image" = icon_base64
		))
	data["slots"] = s_data
	data["links"] = slot_links


	var/list/available_ingredients = list()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		for(var/obj/item/alch/A in STR.real_location())
			if(!(A in slots)) 
				var/icon/I = icon(A.icon, A.icon_state, frame = 1)
				available_ingredients += list(list(
					"name" = A.name,
					"ref" = "\ref[A]",
					"smell" = A.major_smell,
					"image" = "data:image/png;base64,[icon2base64(I)]"
				))
	data["available_ingredients"] = available_ingredients



	var/list/grid_data = list()
	for(var/i in 1 to 9)
		var/obj/item/C = crafting_grid[i]
		var/c_icon = null
		if(C)
			var/icon/IC = icon(C.icon, C.icon_state, frame = 1)
			if(IC) c_icon = "data:image/png;base64,[icon2base64(IC)]"
		grid_data += list(list("ref" = C ? "\ref[C]" : null, "image" = c_icon))
	data["crafting_grid"] = grid_data

	var/matched_recipe = check_grid_recipe()
	if(matched_recipe)
		var/datum/alch_grid_recipe/R = matched_recipe
		var/res_icon = initial(R.result_icon)
		var/res_state = initial(R.result_icon_state)
		
		var/icon/RI = icon(res_icon, res_state)
		if(RI)
			data["craft_result"] = list(
				"name" = initial(R.name),
				"image" = "data:image/png;base64,[icon2base64(RI)]"
			)
	else
		data["craft_result"] = null


	var/list/all_items = list()
	if(STR)
		for(var/obj/item/I in STR.real_location())
			if(!(I in slots) && !(I in crafting_grid))
				var/icon/IC = icon(I.icon, I.icon_state, frame = 1)
				all_items += list(list(
					"name" = I.name,
					"ref" = "\ref[I]",
					"image" = "data:image/png;base64,[icon2base64(IC)]"
				))
	data["available_all_items"] = all_items

	var/list/knowledge = list()
	var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)

	data["beaker1"] = get_beaker_ui_data(beaker_1)
	data["beaker2"] = get_beaker_ui_data(beaker_2)

	var/list/c_reagents = list()
	if(reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			c_reagents += list(list("name" = R.name, "id" = "[R.type]", "vol" = round(R.volume, 0.1)))
	data["cauldron_reagents"] = c_reagents

	var/list/p_reagents = list()
	if(pill_buffer)
		for(var/datum/reagent/R in pill_buffer.reagent_list)
			p_reagents += list(list("name" = R.name, "vol" = round(R.volume, 0.1), "id" = "[R.type]"))
		data["pill_mix"] = p_reagents
		data["pill_mix_total"] = round(pill_buffer.total_volume, 0.1)
	else
		data["pill_mix_total"] = 0

	var/f_count = 0
	if(STR)
		for(var/obj/item/reagent_containers/powder/flour/F in STR.real_location()) 
			f_count++
	data["flour_count"] = f_count

	for(var/path in GLOB.alchemy_dynamic_manager.round_recipes)
		var/datum/alch_cauldron_recipe/advanced/R = path
		var/req_skill = initial(R.skill_required)
		
		var/is_discovered = (path in discovered_recipes) || (alch_skill > req_skill)
		var/has_hint = (path in partial_knowledge) || (alch_skill == req_skill)
		
		if(is_discovered || has_hint)
			var/list/reqs = GLOB.alchemy_dynamic_manager.round_recipes[path]
			
			var/list/ui_reqs = list(
				"strong" = list(),
				"medium" = list(),
				"light" = list()
			)
			
			if(is_discovered)
				ui_reqs["strong"] = reqs["strong"]
				ui_reqs["medium"] = reqs["medium"]
				ui_reqs["light"] = reqs["light"]
			else if(has_hint)

				if(length(reqs["strong"]))
					ui_reqs["strong"] += reqs["strong"][1]
					if(length(reqs["strong"]) > 1)
						for(var/i in 2 to length(reqs["strong"]))
							ui_reqs["strong"] += "???"
				
				if(length(reqs["medium"]))
					for(var/i in 1 to length(reqs["medium"]))
						ui_reqs["medium"] += "???"

				if(length(reqs["light"]))
					for(var/i in 1 to length(reqs["light"]))
						ui_reqs["light"] += "???"

			knowledge += list(list(
				"name" = initial(R.name),
				"found" = is_discovered,
				"is_hint" = has_hint && !is_discovered,
				"type" = "infusion",
				"reqs" = ui_reqs
			))


	for(var/datum/alch_grid_recipe/GR in GLOB.alch_grid_recipes)
		var/list/grid_icons = list()
		for(var/item_path in GR.grid)
			if(item_path)

				var/atom/A = item_path
				

				var/icon_file = initial(A.icon)
				var/icon_state_val = initial(A.icon_state)
				
				if(icon_file && icon_state_val)
					var/icon/I = icon(icon_file, icon_state_val, frame = 1)
					grid_icons += "data:image/png;base64,[icon2base64(I)]"
				else
					grid_icons += null
			else
				grid_icons += null

		knowledge += list(list(
			"name" = GR.name,
			"found" = TRUE, 
			"type" = "grid",
			"grid_icons" = grid_icons,
			"result_img" = "data:image/png;base64,[icon2base64(icon(initial(GR.result_icon), initial(GR.result_icon_state), frame = 1))]"
		))

	data["knowledge"] = knowledge

	if(transmute_slot && STR && (transmute_slot in STR.real_location()))
		var/icon/T_IMG = icon(transmute_slot.icon, transmute_slot.icon_state, frame = 1)
		data["transmute_item"] = list("name" = transmute_slot.name, "image" = "data:image/png;base64,[icon2base64(T_IMG)]")
	else
		transmute_slot = null
		data["transmute_item"] = null
	
	var/list/avail_transmutes = list()
	if(transmute_slot)
		var/current_type = transmute_slot.type
		var/safety = 0
		
		while(current_type && current_type != /obj/item && current_type != /obj && safety < 10)
			safety++
			
			if(GLOB.alchemy_transmute_index[current_type])
				for(var/list/R in GLOB.alchemy_transmute_index[current_type])
					var/list/final_data = R.Copy()
					final_data["icon"] = get_cached_alchemy_icon(R["result_type"])
					
					var/is_duplicate = FALSE
					for(var/list/D in avail_transmutes)
						if(D["ref"] == final_data["ref"])
							is_duplicate = TRUE
							break
					
					if(!is_duplicate)
						avail_transmutes += list(final_data)
			
			current_type = type2parent(current_type)

	data["transmute_recipes"] = avail_transmutes
	return data

/obj/machinery/alch_workbench/ui_act(action, params)
	if(..()) return
	var/mob/living/carbon/human/user = usr
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)

	switch(action)
		if("open_inventory")
			STR?.show_to(user)
			return TRUE

		if("assign_slot")
			var/slot_idx = text2num(params["slot"])
			var/obj/item/alch/A = locate(params["item_ref"]) in STR?.real_location()
			if(A && slot_idx >= 1 && slot_idx <= 6)
				slots[slot_idx] = A
				update_icon()
			return TRUE

		if("eject")
			var/idx = text2num(params["slot"])
			if(idx >= 1 && idx <= 6 && slots[idx])
				slots[idx] = null
				var/list/new_links = list()
				for(var/list/L in slot_links)
					if(L[1] != idx && L[2] != idx) new_links += list(L)
				slot_links = new_links
				update_icon()
			return TRUE

		if("clear_links")
			slot_links = list()
			update_icon()
			return TRUE

		if("link")
			var/s1 = text2num(params["from"])
			var/s2 = text2num(params["to"])
			if(s1 != s2 && slots[s1] && slots[s2])
				var/found = FALSE
				var/list/new_links = list()
				for(var/list/L in slot_links)
					if((L[1] == s1 && L[2] == s2) || (L[1] == s2 && L[2] == s1)) found = TRUE
					else new_links += list(L)
				if(!found) new_links += list(list(s1, s2))
				slot_links = new_links
				update_icon()
			return TRUE

		if("assign_craft")
			var/idx = text2num(params["slot"])
			var/obj/item/I = locate(params["item_ref"]) in STR?.real_location()
			if(I && idx >= 1 && idx <= 9)
				crafting_grid[idx] = I
				update_icon()
			return TRUE
			
		if("clear_craft")
			var/idx = text2num(params["slot"])
			if(idx >= 1 && idx <= 9)
				crafting_grid[idx] = null
				update_icon()
			return TRUE

		if("do_grid_craft")
			var/matched_recipe = check_grid_recipe()
			if(matched_recipe)
				var/datum/alch_grid_recipe/R = matched_recipe
				for(var/i in 1 to 9)
					var/obj/item/I = crafting_grid[i]
					if(I)
						if(STR) STR.remove_from_storage(I, null)
						qdel(I)
						crafting_grid[i] = null
				new R.result_type(get_turf(src))
				playsound(src, 'sound/effects/hood_ignite.ogg', 50, TRUE)
				to_chat(user, span_nicegreen("Успешно создано: [initial(R.name)]."))
				update_icon()
			else
				to_chat(user, span_warning("Рецепт не найден!"))
				for(var/i in 1 to 9)
					if(crafting_grid[i])
						to_chat(user, "Слот [i] содержит: [crafting_grid[i].type]")
			return TRUE

		if("upgrade")
			if(!STR) return TRUE
			if(upgrade_level >= 4) return TRUE
			
			var/list/requirements = list()
			switch(upgrade_level)
				if(1)
					requirements[/obj/item/ingot/iron] = 1
				if(2)
					requirements[/obj/item/ingot/gold] = 1
				if(3)
					requirements[/obj/item/roguegem/diamond] = 1
					requirements[/obj/item/riddleofsteel] = 1
					requirements[/obj/item/roguegem/blue] = 2
					requirements[/obj/item/alch/firedust] = 4
					requirements[/obj/item/reagent_containers/lux] = 2


			var/list/items_to_consume = list()
			var/has_everything = TRUE
			
			for(var/req_type in requirements)
				var/needed_amount = requirements[req_type]
				var/found_amount = 0
				

				for(var/obj/item/I in STR.real_location())
					if((I.type == req_type) && !(I in items_to_consume))
						items_to_consume += I
						found_amount++
						if(found_amount >= needed_amount)
							break

				if(found_amount < needed_amount)
					has_everything = FALSE
					break

			if(has_everything)
				for(var/obj/item/I in items_to_consume)
					STR.remove_from_storage(I, null)
					qdel(I)

				upgrade_level++
				update_icon()
				
				var/msg = ""
				if(upgrade_level == 2) msg = "Вы укрепили стол железными креплениями. Доступна Лаборатория!"
				if(upgrade_level == 3) msg = "Вы установили золотые змеевики. Теперь доступна Инфузия!"
				if(upgrade_level == 4) msg = "Вы встроили Призматическую Линзу. Лаборатория достигла пика могущества!"
				to_chat(user, span_notice(msg))
			else
				var/req_text = ""
				switch(upgrade_level)
					if(1) req_text = "1 Железный слиток"
					if(2) req_text = "1 Золотой слиток"
					if(3) req_text = "1 Алмаз, 1 Загадка Стали, 2 Синих самоцвета, 4 Огненной пыли 2 чистых люкса."
				to_chat(user, span_warning("Не хватает компонентов! Требуется: [req_text]."))

			return TRUE

		if("mix")
			do_mix(user)
			return TRUE

		if("transmute_assign")
			var/obj/item/I = locate(params["item_ref"]) in STR.real_location()
			if(I && !transmute_slot)
				transmute_slot = I
				update_icon()
			return TRUE

		if("transmute_eject")
			transmute_slot = null
			update_icon()
			return TRUE

		if("consume_lux")
			if(!STR) return TRUE
			var/obj/item/reagent_containers/lux/L = locate(/obj/item/reagent_containers/lux) in STR.real_location()
			var/obj/item/reagent_containers/lux_impure/LI = locate(/obj/item/reagent_containers/lux_impure) in STR.real_location()
			
			var/obj/item/consumed = null
			var/charge_gain = 0
			
			if(L)
				consumed = L
				charge_gain = 15
			else if(LI)
				consumed = LI
				charge_gain = 5
				
			if(consumed)
				if(lux_charges + charge_gain > max_lux_charges)
					to_chat(usr, span_warning("Бак энергии лаборатории полон!"))
					return TRUE
					
				STR.remove_from_storage(consumed, null)
				qdel(consumed)
				lux_charges += charge_gain
				to_chat(usr, span_notice("Лаборатория успешно расщепила [consumed.name] на чистую энергию."))
			else
				to_chat(usr, span_warning("На складе стола нет Люкса для поглощения!"))
			return TRUE


		if("do_transmute")
			var/recipe_ref = params["recipe_ref"]
			var/list/R_DATA = GLOB.alchemy_recipe_lookup[recipe_ref]
			if(!R_DATA) return TRUE

			var/cost = R_DATA["cost"]
			var/atom/out_type = R_DATA["result_type"]

			if(lux_charges < cost)
				to_chat(usr, span_warning("Недостаточно энергии Люкса для этой формы!"))
				return TRUE

			if(transmute_slot && out_type)
				lux_charges -= cost
				if(STR) STR.remove_from_storage(transmute_slot, null)
				
				qdel(transmute_slot)
				transmute_slot = null
				new out_type(get_turf(src))
				update_icon()
			return TRUE

	var/obj/item/reagent_containers/target_beaker = (params["slot"] == "1") ? beaker_1 : beaker_2

	switch(action)
		if("lab_assign_beaker")
			var/obj/item/reagent_containers/I = locate(params["item_ref"]) in STR.real_location()
			if(I)
				if(params["slot"] == "1") beaker_1 = I
				else beaker_2 = I
			return TRUE

		if("lab_eject_beaker")
			if(params["slot"] == "1") beaker_1 = null
			else beaker_2 = null
			return TRUE

		if("pour_to_cauldron")
			if(!target_beaker || !params["reagent"]) return TRUE
			var/reag_type = text2path(params["reagent"])
			var/amount = text2num(params["amount"])
			
			target_beaker.reagents.trans_id_to(src, reag_type, amount)
			update_icon()
			return TRUE

		if("fill_from_cauldron")
			if(!target_beaker || !params["reagent"]) return TRUE
			var/reag_type = text2path(params["reagent"])
			var/amount = text2num(params["amount"])
			
			reagents.trans_id_to(target_beaker, reag_type, amount)
			update_icon()
			return TRUE

		if("add_to_pill_mix")
			if(!target_beaker || !params["reagent"]) return TRUE
			var/reag_type = text2path(params["reagent"])
			var/amount = text2num(params["amount"])
			
			var/datum/reagent/R = target_beaker.reagents.get_reagent(reag_type)
			if(R)
				var/transfer_vol = min(amount, R.volume)
				var/can_receive = pill_buffer.maximum_volume - pill_buffer.total_volume
				transfer_vol = min(transfer_vol, can_receive)
				
				if(transfer_vol > 0)
					pill_buffer.add_reagent(reag_type, transfer_vol)
					target_beaker.reagents.remove_reagent(reag_type, transfer_vol)
			
			update_icon()
			return TRUE

		if("make_pills")
			var/obj/item/reagent_containers/powder/flour/F = locate() in STR.real_location()
			
			if(!F || pill_buffer.total_volume < 15)
				to_chat(usr, span_warning("Нужна мука и 15u смеси в буфере!"))
				return TRUE

			var/obj/item/reagent_containers/powder/alchemical/P = new(get_turf(src))
			pill_buffer.trans_to(P, 15)

			if(P.reagents.reagent_list.len)
				var/datum/reagent/main = P.reagents.get_master_reagent()
				P.name = "powdered [main.name]"

			src.flour_efficiency++
			if(src.flour_efficiency >= 3)
				STR.remove_from_storage(F, null)
				qdel(F)
				src.flour_efficiency = 0
			
			update_icon()
			return TRUE
		
		if("pill_to_cauldron")
			var/reag_id = text2path(params["reagent"])
			var/amount = text2num(params["amount"])
			var/datum/reagent/R = pill_buffer.get_reagent(reag_id)
			if(R)
				var/transfer_vol = min(amount, R.volume)
				reagents.add_reagent(reag_id, transfer_vol)
				pill_buffer.remove_reagent(reag_id, transfer_vol)
			update_icon()
			return TRUE

		if("pill_to_beaker")
			var/obj/item/reagent_containers/B = (params["slot"] == "1") ? beaker_1 : beaker_2
			if(!B) return TRUE
			var/reag_id = text2path(params["reagent"])
			var/amount = text2num(params["amount"])
			var/datum/reagent/R = pill_buffer.get_reagent(reag_id)
			if(R)
				var/transfer_vol = min(amount, R.volume)
				B.reagents.add_reagent(reag_id, transfer_vol)
				pill_buffer.remove_reagent(reag_id, transfer_vol)
			update_icon()
			return TRUE

/obj/machinery/alch_workbench/proc/get_beaker_ui_data(obj/item/reagent_containers/B)
	if(!B || !B.reagents)
		return null
	
	var/list/reag_list = list()
	for(var/datum/reagent/R in B.reagents.reagent_list)
		reag_list += list(list(
			"name" = R.name, 
			"id" = "[R.type]", 
			"vol" = round(R.volume, 0.1)
		))
	
	return list(
		"name" = B.name, 
		"cur" = round(B.reagents.total_volume, 0.1), 
		"max" = B.reagents.maximum_volume, 
		"contents" = reag_list
	)

/obj/machinery/alch_workbench/proc/do_mix(mob/user)
	if(reagents.get_reagent_amount(/datum/reagent/water) < 90)
		to_chat(user, span_warning("Недостаточно воды (нужно минимум 90 мл)."))
		return

	if(upgrade_level < 3)
		to_chat(user, span_warning("Для инфузии требуются золотые змеевики (Ур. 3)!"))
		return

	var/list/groups = list()
	var/list/visited = list()
	var/has_items = FALSE
	
	for(var/i in 1 to 6)
		if(!slots[i] || (i in visited)) continue
		has_items = TRUE
		
		var/list/current_group = list()
		var/obj/item/alch/base_item = slots[i]
		var/base_smell = base_item.major_smell
		
		var/list/queue = list(i)
		while(queue.len)
			var/curr = queue[1]
			queue.Cut(1,2)
			
			if(curr in visited) continue
			visited += curr
			
			var/obj/item/alch/curr_item = slots[curr]
			if(curr_item.major_smell == base_smell)
				current_group += curr
				for(var/list/L in slot_links)
					if(L[1] == curr && !(L[2] in visited)) queue += L[2]
					if(L[2] == curr && !(L[1] in visited)) queue += L[1]
		
		if(base_smell)
			groups += list(list("smell" = base_smell, "count" = current_group.len))

	if(!has_items)
		to_chat(user, span_warning("Слоты инфузии пусты."))
		return

	var/list/final_smells = list("strong" = list(), "medium" = list(), "light" = list())
	for(var/list/G in groups)
		if(G["count"] >= 3) final_smells["strong"] += G["smell"]
		else if(G["count"] == 2) final_smells["medium"] += G["smell"]
		else if(G["count"] == 1) final_smells["light"] += G["smell"]

	var/datum/alch_cauldron_recipe/advanced/found_path = null
	
	var/total_cauldron_groups = length(final_smells["strong"]) + length(final_smells["medium"]) + length(final_smells["light"])

	for(var/path in GLOB.alchemy_dynamic_manager.round_recipes)
		var/list/reqs = GLOB.alchemy_dynamic_manager.round_recipes[path]
		
		var/total_recipe_groups = length(reqs["strong"]) + length(reqs["medium"]) + length(reqs["light"])
		
		if(total_cauldron_groups != total_recipe_groups)
			continue

		var/match = TRUE
		for(var/s in reqs["strong"]) 
			if(!(s in final_smells["strong"])) 
				match = FALSE
				break
		if(!match) continue

		for(var/m in reqs["medium"]) 
			if(!(m in final_smells["medium"])) 
				match = FALSE
				break
		if(!match) continue

		for(var/l in reqs["light"])  
			if(!(l in final_smells["light"]))  
				match = FALSE
				break
		if(!match) continue

		found_path = path
		break

	if(found_path)
		var/datum/alch_cauldron_recipe/advanced/R = new found_path
		
		if(initial(R.skill_required) >= SKILL_LEVEL_MASTER && upgrade_level < 4)
			to_chat(user, span_boldwarning("Требуется Призматическая Линза (Ур. 4) для этого зелья!"))
			qdel(R)
			return

		if(initial(R.skill_required) <= user.get_skill_level(/datum/skill/craft/alchemy))
			to_chat(user, span_nicegreen("Успех! Получено: [R.name]."))
			reagents.remove_reagent(/datum/reagent/water, 90)
			reagents.add_reagent_list(R.output_reagents)
			discovered_recipes |= found_path
		else
			to_chat(user, span_warning("Ваш навык алхимии слишком низок! Реакция провалилась."))
			reagents.remove_reagent(/datum/reagent/water, 90)
			reagents.add_reagent(/datum/reagent/yuck, 90)
		qdel(R)
	else
		to_chat(user, span_warning("Смесь бурлит и превращается в отходы..."))
		reagents.remove_reagent(/datum/reagent/water, 90)
		reagents.add_reagent(/datum/reagent/yuck, 90)

		if(prob(50))
			for(var/path in GLOB.alchemy_dynamic_manager.round_recipes)
				if(path in discovered_recipes) continue
				if(path in partial_knowledge) continue
				
				var/list/reqs = GLOB.alchemy_dynamic_manager.round_recipes[path]
				var/list/all_req_smells = reqs["strong"] + reqs["medium"] + reqs["light"]
				
				for(var/s in final_smells["strong"] + final_smells["medium"] + final_smells["light"])
					if(s in all_req_smells)
						partial_knowledge |= path
						var/datum/alch_cauldron_recipe/advanced/RH = path
						to_chat(user, span_notice("Вы понимаете, что один из компонентов подходит для <b>[initial(RH.name)]</b>!"))
						break
				if(path in partial_knowledge) break

	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	for(var/i in 1 to 6)
		var/obj/item/I = slots[i]
		if(I)
			if(STR) STR.remove_from_storage(I, null)
			qdel(I)
		slots[i] = null
	
	slot_links = list()
	playsound(src, 'sound/effects/hood_ignite.ogg', 80, TRUE)
	update_icon()

/obj/structure/multistage/alch_workbench_unfinished
	name = "unfinished alchemy workbench"
	desc = "A crude wooden frame. It needs glass vials and parchment to become a proper alchemical laboratory."
	icon = 'modular_twilight_axis/icons/roguetown/misc/Lab.dmi'
	icon_state = "labs_0"
	base_desc = "An unfinished alchemy workbench."

	density = TRUE
	anchored = TRUE

	bound_width = 64
	bound_height = 32
	bound_x = 0
	bound_y = 0
	pixel_x = 0
	pixel_y = -16    

	stage_types = list(
		/datum/crafting_stage/alch_workbench/stage_1
	)
	
	final_product_type = /obj/machinery/alch_workbench

/datum/crafting_stage/alch_workbench
	var/recipe_type

/datum/crafting_stage/alch_workbench/stage_1
	icon_state = "labs_0"
	description = "\nRequired: 2 Alchemical Vials, 1 Scroll/Parchment. (Hammer, Engineering)"
	recipe = /datum/crafting_recipe/alch_workbench_internal/stage_1

/datum/crafting_recipe/alch_workbench_internal
	name = "" 
	hides_from_books = TRUE
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/hammer = 1)

/datum/crafting_recipe/alch_workbench_internal/stage_1
	reqs = list(
		/obj/item/reagent_containers/glass/bottle/alchemical = 2, 
		/obj/item/paper/scroll = 1
	)
	craftdiff = 0 

/datum/crafting_recipe/roguetown/engineering/alch_workbench_base
	name = " Великий Алхимический Стол"
	category = "Machines"
	result = /obj/structure/multistage/alch_workbench_unfinished
	reqs = list(/obj/item/natural/wood/plank = 2)
	tools = list(/obj/item/rogueweapon/hammer = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 0
	verbage_simple = "construct"
	verbage = "constructs"
