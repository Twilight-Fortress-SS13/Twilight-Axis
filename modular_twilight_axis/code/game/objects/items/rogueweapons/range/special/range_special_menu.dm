/datum/archery_perk_menu
	var/mob/living/carbon/human/owner

/datum/archery_perk_menu/New(mob/living/carbon/human/H)
	owner = H


/datum/archery_perk_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/archery_perk_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArcheryPerks", "Стиль Стрельбы (Эксперт)")
		ui.open()


/datum/archery_perk_menu/ui_data(mob/user)
	var/list/data = list()
	

	var/has_perk = FALSE
	var/selected_id = null
	
	if(HAS_TRAIT(owner, TRAIT_BOW_DOUBLESHOT))
		has_perk = TRUE
		selected_id = "doubleshot"
	else if(HAS_TRAIT(owner, TRAIT_BOW_LONGSHOT))
		has_perk = TRUE
		selected_id = "longshot"
	else if(HAS_TRAIT(owner, TRAIT_BOW_BACKSTEP))
		has_perk = TRUE
		selected_id = "backstep"
		
	data["has_perk"] = has_perk
	data["selected_perk"] = selected_id
	return data

/datum/archery_perk_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	
	if(action == "select_perk")

		if(HAS_TRAIT(owner, TRAIT_BOW_DOUBLESHOT) || HAS_TRAIT(owner, TRAIT_BOW_LONGSHOT) || HAS_TRAIT(owner, TRAIT_BOW_BACKSTEP))
			to_chat(owner, span_warning("Я уже выбрал свой стиль!"))
			return TRUE
			
		var/selected = params["perk_id"]
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = owner.get_active_held_item()
		
		if(selected == "doubleshot")
			ADD_TRAIT(owner, TRAIT_BOW_DOUBLESHOT, TRAIT_GENERIC)
			to_chat(owner, span_greentext("Я освоил Двойной выстрел!"))
			if(istype(B))
				B.special = new /datum/special_intent/range_special/bow_doubleshot()
				
		else if(selected == "longshot")
			ADD_TRAIT(owner, TRAIT_BOW_LONGSHOT, TRAIT_GENERIC)
			to_chat(owner, span_greentext("Я освоил Дальнобойный выстрел!"))
			if(istype(B))
				B.special = new /datum/special_intent/range_special/bow_longshot()
		else if(selected == "backstep")
			ADD_TRAIT(owner, TRAIT_BOW_BACKSTEP, TRAIT_GENERIC)
			to_chat(owner, span_greentext("Я освоил Выстрел с отскоком!"))
			if(istype(B))
				B.special = new /datum/special_intent/range_special/bow_backstep()
		
		SStgui.close_uis(src)
		return TRUE
