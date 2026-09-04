/datum/manor_panel
	var/mob/living/carbon/human/holder

/datum/manor_panel/New(mob/holder_mob)
	. = ..()
	if(istype(holder_mob, /mob/living/carbon/human))
		holder = holder_mob

/datum/manor_panel/Destroy(force)
	holder = null
	return ..()

/datum/manor_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/manor_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ManorPanel", "Владение")
		ui.open()

/datum/asset/simple/manor
	assets = list(
		"field_icon.png" = 'modular_twilight_axis/manors/icons/field_icon.png',
		"fishing_icon.png" = 'modular_twilight_axis/manors/icons/fishing_icon.png',
		"forest_icon.png" = 'modular_twilight_axis/manors/icons/forest_icon.png',
		"fruit_icon.png" = 'modular_twilight_axis/manors/icons/fruit_icon.png',
		"hunting_icon.png" = 'modular_twilight_axis/manors/icons/hunting_icon.png',
		"ranch_icon.png" = 'modular_twilight_axis/manors/icons/ranch_icon.png',
		"trade_icon.png" = 'modular_twilight_axis/manors/icons/trade_icon.png',
		"mine_icon.png" = 'modular_twilight_axis/manors/icons/mine_icon.png',
		"mage_tower_icon.png" = 'modular_twilight_axis/manors/icons/mage_tower_icon.png',
		"cathedral_icon.png" = 'modular_twilight_axis/manors/icons/cathedral_icon.png',
		"outpost_icon.png" = 'modular_twilight_axis/manors/icons/outpost_icon.png',
	)

/datum/manor_panel/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/manor))

/datum/manor_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/request_user = holder
	if(ui?.user)
		request_user = ui.user

	var/datum/manor/manor = get_manor_for_user(request_user)
	if(!manor)
		return FALSE

	var/id = text2num(params["id"])
	if(!id || id < 1 || id > length(manor.workstations))
		return FALSE

	var/datum/workstation/workstation = manor.workstations[id]
	if(!workstation)
		return FALSE

	switch(action)
		if("inc_workers")
			if(manor.get_assigned_workers() >= manor.total_workers)
				return TRUE
			if(workstation.workers_employed >= workstation.workstation_size)
				return TRUE
			workstation.workers_employed += 1
			if(workstation.production_increase_per_job)
				for(var/datum/workstation/ws in manor.workstations)
					ws.production_modifier += workstation.production_increase_per_job
			SStgui.update_uis(src)
			return TRUE

		if("dec_workers")
			if(workstation.workers_employed <= 0)
				return TRUE
			workstation.workers_employed -= 1
			if(workstation.production_increase_per_job)
				for(var/datum/workstation/ws in manor.workstations)
					ws.production_modifier -= workstation.production_increase_per_job
			SStgui.update_uis(src)
			return TRUE

	return FALSE

/datum/manor_panel/proc/get_primary_role(mob/user)
	if(!user?.mind)
		return ""
	return lowertext("[user.mind.assigned_role]")

/datum/manor_panel/proc/is_allowed_manor_role(mob/user)
	var/datum/job/J = SSjob.GetJob(user.job)

	if(J)
		if(J.department_flag & NOBLEMEN)
			return FALSE
	
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE

	if(user.mind && (user.mind.has_antag_datum(/datum/antagonist/skeleton) || user.mind.has_antag_datum(/datum/antagonist/lich) || user.mind.has_antag_datum(/datum/antagonist/vampire) || user.mind.has_antag_datum(/datum/antagonist/vampire/lord)))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_NOBLE))
		return TRUE

	return FALSE

/datum/manor_panel/proc/can_have_manor(mob/user)
	if(!istype(user, /mob/living/carbon/human) || !user.mind)
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.check_manor_pref)
		return FALSE
	if(user.mind.get_owned_manor())
		return TRUE
	return is_allowed_manor_role(user)

/datum/manor_panel/proc/create_manor_for_user(mob/user)
	if(!istype(user, /mob/living/carbon/human))
		return null
	if(!user.mind)
		return null
	if(!can_have_manor(user))
		return null

	var/datum/manor/existing_manor = user.mind.get_owned_manor()
	if(existing_manor)
		return existing_manor.ensure_initialized(user)

	var/datum/manor/new_manor = new /datum/manor()
	new_manor.on_creation(user)
	user.mind.set_owned_manor(new_manor)
	return new_manor

/datum/manor_panel/proc/get_manor_for_user(mob/user)
	var/datum/manor/manor = null

	if(user?.mind)
		manor = user.mind.get_owned_manor()
		if(manor)
			return manor.ensure_initialized(user)

	if(holder?.mind)
		manor = holder.mind.get_owned_manor()
		if(manor)
			return manor.ensure_initialized(holder)

	if(user)
		manor = create_manor_for_user(user)
		if(manor)
			return manor

	if(holder)
		manor = create_manor_for_user(holder)
		if(manor)
			return manor

	return null

/datum/manor_panel/proc/capitalize(text_value)
	if(!istext(text_value) || !length(text_value))
		return ""
	return "[uppertext(copytext(text_value, 1, 2))][copytext(text_value, 2)]"

/datum/manor_panel/proc/get_readable_type_name(thing_path, fallback = "Неизвестно")
	var/as_text = "[thing_path]"
	var/last_slash = findlasttext(as_text, "/")
	if(last_slash)
		as_text = copytext(as_text, last_slash + 1)
	as_text = replacetext(as_text, "_", " ")
	if(!length(as_text))
		return fallback
	return capitalize(as_text)

/datum/manor_panel/proc/get_patron_key(patron_value)
	var/as_text = lowertext("[patron_value]")
	var/last_slash = findlasttext(as_text, "/")
	if(last_slash)
		as_text = copytext(as_text, last_slash + 1)
	if(!length(as_text))
		return "astrata"
	return as_text

/datum/manor_panel/proc/serialize_workstation(datum/workstation/workstation, index)
	var/list/produce_names = list()
	var/list/already_added = list()

	for(var/stock_type in workstation.produce)
		var/stock_name = get_readable_type_name(stock_type, "Ресурс")
		if(stock_name in already_added)
			continue
		already_added += stock_name
		produce_names += stock_name

	return list(
		"id" = index,
		"name" = workstation.workstation_name,
		"workers_employed" = workstation.workers_employed,
		"workers_max" = workstation.workstation_size,
		"produce" = produce_names,
		"kind" = workstation.get_theme_key(),
		"type_of_produce" = workstation.type_of_produce,
		"production_bonus" = workstation.production_modifier
	)

/datum/manor_panel/ui_data(mob/user)
	var/datum/manor/manor = get_manor_for_user(user)
	if(!manor)
		return list(
			"manor_name" = "Нет доступного владения",
			"manor_type" = "manor",
			"manor_patron_key" = "astrata",
			"manor_origin" = "Неизвестно",
			"total_workers" = 0,
			"workers_assigned" = 0,
			"workers_free" = 0,
			"productivity_last_cycle" = 0,
			"workstations" = list()
		)

	var/list/workstations_data = list()
	var/index = 1
	for(var/datum/workstation/workstation in manor.workstations)
		workstations_data += list(serialize_workstation(workstation, index))
		index += 1
	var/origin
	if(manor.virtue_origin)
		origin = manor.virtue_origin.map_state_name

	return list(
		"manor_name" = manor.manor_name,
		"manor_type" = manor.manor_type,
		"manor_patron_key" = get_patron_key(manor.patron),
		"manor_origin" = origin,
		"total_workers" = manor.total_workers,
		"workers_assigned" = manor.get_assigned_workers(),
		"workers_free" = manor.get_free_workers(),
		"productivity_last_cycle" = manor.last_cycle_productivity,
		"workstations" = workstations_data
	)
