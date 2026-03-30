#define TAT_TRAIT_SOURCE "tat_build"

/datum/tat_build
	var/list/available_stats = list()
	var/list/available_skills = list()
	var/list/available_traits = list()
	var/list/available_items = list()

	var/points_stats = 0
	var/points_skills = 0
	var/points_traits = 0
	var/points_items = 0

	var/list/stats = list()
	var/list/skills = list()
	var/list/traits = list()
	var/list/items = list()

	var/dirty = FALSE

/datum/tat_build/New()
	. = ..()
	reset_build()

/datum/tat_build/proc/reset_build()
	reset_stats()
	reset_skills()
	reset_traits()
	reset_items()
	dirty = TRUE

/datum/tat_build/proc/reset_stats()
	stats = list()
	dirty = TRUE

/datum/tat_build/proc/reset_skills()
	skills = list()
	dirty = TRUE

/datum/tat_build/proc/reset_traits()
	traits = list()
	dirty = TRUE

/datum/tat_build/proc/reset_items()
	items = list()
	dirty = TRUE

/datum/tat_build/proc/add_stat(id, amount)
	if(!id || !isnum(amount)) return FALSE
	stats[id] = (stats[id] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_stat(id)
	if(!id) return FALSE
	stats -= id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_skill(skill_type, amount)
	if(!ispath(skill_type) || !isnum(amount)) return FALSE
	skills[skill_type] = (skills[skill_type] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_skill(skill_type)
	if(!ispath(skill_type)) return FALSE
	skills -= skill_type
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_trait(trait_id)
	if(!trait_id) return FALSE
	if(!(trait_id in traits))
		traits += trait_id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_trait(trait_id)
	if(!trait_id) return FALSE
	traits -= trait_id
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/add_item(path, amount)
	if(!ispath(path) || !isnum(amount)) return FALSE
	items[path] = (items[path] || 0) + amount
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/remove_item(path)
	if(!ispath(path)) return FALSE
	items -= path
	dirty = TRUE
	return TRUE

/datum/tat_build/proc/apply_stats(mob/living/carbon/human/H)
	if(!H) return
	for(var/id in stats)
		H.change_stat(id, stats[id])

/datum/tat_build/proc/apply_skills(mob/living/carbon/human/H)
	if(!H) return
	for(var/skill_type in skills)
		var/level = skills[skill_type]
		if(level > 0)
			H.adjust_skillrank(skill_type, level, TRUE)

/datum/tat_build/proc/apply_traits(mob/living/carbon/human/H)
	if(!H) return
	for(var/trait_id in traits)
		ADD_TRAIT(H, trait_id, TAT_TRAIT_SOURCE)

/datum/tat_build/proc/apply_items(mob/living/carbon/human/H)
	if(!H) return
	var/turf/T = get_turf(H)
	for(var/path in items)
		var/amount = items[path]
		for(var/i in 1 to amount)
			new path(T)

/datum/tat_build/proc/apply_to_human(mob/living/carbon/human/H)
	if(!H) return
	apply_stats(H)
	apply_skills(H)
	apply_traits(H)
	apply_items(H)

/datum/tat_build/ui_state(mob/user)
	return GLOB.always_state

/datum/tat_build/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TATBuild")
		ui.open()

/datum/tat_build/ui_static_data(mob/user)
	return list(
		"available_stats" = available_stats,
		"available_skills" = available_skills,
		"available_traits" = available_traits,
		"available_items" = available_items,
	)

/datum/tat_build/ui_data(mob/user)
	return list(
		"stats" = stats,
		"skills" = skills,
		"traits" = traits,
		"items" = items,
		"points_stats" = points_stats,
		"points_skills" = points_skills,
		"points_traits" = points_traits,
		"points_items" = points_items,
		"dirty" = dirty,
	)

/datum/tat_build/ui_act(action, list/params)
	. = ..()
	switch(action)
		if("add_stat")
			add_stat(params["id"], text2num(params["amount"]))
		if("remove_stat")
			remove_stat(params["id"])

		if("add_skill")
			add_skill(text2path(params["path"]), text2num(params["amount"]))
		if("remove_skill")
			remove_skill(text2path(params["path"]))

		if("add_trait")
			add_trait(params["id"])
		if("remove_trait")
			remove_trait(params["id"])

		if("add_item")
			add_item(text2path(params["path"]), text2num(params["amount"]))
		if("remove_item")
			remove_item(text2path(params["path"]))

		if("reset_all")
			reset_build()
		if("reset_stats")
			reset_stats()
		if("reset_skills")
			reset_skills()
		if("reset_traits")
			reset_traits()
		if("reset_items")
			reset_items()

	return TRUE

/datum/tat_build/proc/load_from_list(list/L)
	reset_build()

	if(!islist(L))
		dirty = FALSE
		return

	var/list/_stats = L["stats"]
	var/list/_skills = L["skills"]
	var/list/_traits = L["traits"]
	var/list/_items = L["items"]

	if(islist(_stats))
		for(var/id in _stats)
			if(istext(id) && isnum(_stats[id]))
				stats[id] = _stats[id]

	if(islist(_skills))
		for(var/skill_type in _skills)
			if(ispath(skill_type) && isnum(_skills[skill_type]))
				skills[skill_type] = _skills[skill_type]

	if(islist(_traits))
		for(var/trait_id in _traits)
			if(!isnull(trait_id))
				traits += trait_id

	if(islist(_items))
		for(var/item_path in _items)
			if(ispath(item_path) && isnum(_items[item_path]))
				items[item_path] = _items[item_path]

	dirty = FALSE

/datum/tat_build/proc/export_to_list()
	return list(
		"stats" = stats.Copy(),
		"skills" = skills.Copy(),
		"traits" = traits.Copy(),
		"items" = items.Copy(),
	)

#undef TAT_TRAIT_SOURCE

/datum/preferences/proc/sanitize_tat_build(list/tat_data)
	if(!tat_build)
		tat_build = new()

	tat_build.reset_build()

	if(!islist(tat_data))
		tat_build.dirty = FALSE
		return

	var/list/stats = tat_data["stats"]
	var/list/skills = tat_data["skills"]
	var/list/traits = tat_data["traits"]
	var/list/items = tat_data["items"]

	if(islist(stats))
		for(var/id in stats)
			if(istext(id) && isnum(stats[id]))
				tat_build.stats[id] = stats[id]

	if(islist(skills))
		for(var/skill_type in skills)
			if(ispath(skill_type) && isnum(skills[skill_type]))
				tat_build.skills[skill_type] = skills[skill_type]

	if(islist(traits))
		for(var/trait_id in traits)
			if(!isnull(trait_id))
				tat_build.traits += trait_id

	if(islist(items))
		for(var/item_path in items)
			if(ispath(item_path) && isnum(items[item_path]))
				tat_build.items[item_path] = items[item_path]

	tat_build.dirty = FALSE
