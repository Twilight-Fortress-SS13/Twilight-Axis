/client/proc/view_rogue_manifest()
	var/list/dat = list()
	dat += "<h3>Round ID: [GLOB.rogue_round_id]</h3>"
	for(var/X in GLOB.character_list)
		dat += "[GLOB.character_list[X]]"

	var/datum/browser/popup = new(src, "actors", "<center>Inhabitants of Twilight Axis</center>", 387, 420)
	popup.set_content(dat.Join(""))
	popup.open(FALSE)

/client/verb/view_actors_manifest()
	set category = "OOC"
	set name = "View Actors"

	if(!holder && !isobserver(mob) && SSticker.current_state < GAME_STATE_FINISHED && !istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I can't use this while alive. No spoilers!"))
		return

	var/list/dat = list()
	var/list/department_display_order = list(
		"Noblemen",
		"Courtiers",
		"Garrison",
		"Church",
		"Burghers",
		"Peasants",
		"Inquisition",
		"Sidefolk",
		"Wanderers"
	)
	var/list/normalized_actors_list = list()
	var/list/extra_departments = list()

	for(var/department in department_display_order)
		normalized_actors_list[department] = list()

	for(var/department in GLOB.actors_list)
		var/normalized_department = department
		if(normalized_department == "City Watch" || normalized_department == "Vanguard" || normalized_department == "Retinue")
			normalized_department = "Garrison"

		if(isnull(normalized_actors_list[normalized_department]))
			normalized_actors_list[normalized_department] = list()
			extra_departments += normalized_department

		var/list/normalized_department_entries = normalized_actors_list[normalized_department]
		for(var/X in GLOB.actors_list[department])
			var/entry = GLOB.actors_list[department][X]
			if(!entry || normalized_department_entries.Find(entry))
				continue
			normalized_department_entries += entry

	for(var/department in department_display_order)
		var/list/actors_under_department = normalized_actors_list[department]
		if(actors_under_department.len)
			var/department_color = JCOLOR_BY_DEPARTMENT[department] || "#ffffff"
			dat += "<h2><font color='[department_color]'>[department]</font></h2><hr>"
			for(var/entry in actors_under_department)
				dat += "[entry]"

	for(var/department in extra_departments)
		var/list/actors_under_department = normalized_actors_list[department]
		if(actors_under_department.len)
			var/department_color = JCOLOR_BY_DEPARTMENT[department] || "#ffffff"
			dat += "<h2><font color='[department_color]'>[department]</font></h2><hr>"
			for(var/entry in actors_under_department)
				dat += "[entry]"

	var/datum/browser/popup = new(src, "actors", "<center>This Story's Actors</center>", 387, 420)
	popup.set_content(dat.Join(""))
	popup.open(FALSE)

/client/proc/view_roleplay_ads()
	var/list/dat = list()
	for(var/X in GLOB.roleplay_ads)
		dat += "[GLOB.roleplay_ads[X]]"

	var/datum/browser/popup = new(src, "actors", "<center>Roleplay Ads</center>", 500, 600)
	popup.set_content(dat.Join(""))
	popup.open(FALSE)