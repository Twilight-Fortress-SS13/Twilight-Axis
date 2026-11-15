/client/proc/view_rogue_manifest()
	var/list/dat = list()
	dat += "<h3>Round ID: [GLOB.rogue_round_id]</h3>"
	for(var/X in GLOB.character_list)
		dat += "[GLOB.character_list[X]]"

	var/datum/browser/popup = new(src, "actors", "<center>Inhabitants of Twilight Axis</center>", 500, 600)
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
	var/list/actors_by_department = list()
	var/list/extra_departments = list()

	for(var/department in department_display_order)
		actors_by_department[department] = list()

	for(var/mob_id in GLOB.actors_list)
		var/list/actor_data = GLOB.actors_list[mob_id]
		if(!islist(actor_data))
			continue

		var/actor_name = actor_data["name"]
		var/actor_rank = actor_data["rank"]
		if(!actor_name || !actor_rank)
			continue

		var/department = "Wanderers"
		var/datum/job/actor_job = SSjob.GetJob(actor_rank)
		if(actor_job)
			department = SSjob.bitflag_to_department(actor_job.department_flag, actor_job.obfuscated_job)

		if(department == "City Watch" || department == "Vanguard" || department == "Retinue")
			department = "Garrison"

		if(isnull(actors_by_department[department]))
			actors_by_department[department] = list()
			extra_departments += department

		var/list/department_entries = actors_by_department[department]
		var/entry = "[actor_name] as the [actor_rank]<BR>"
		if(!(entry in department_entries))
			department_entries += entry

	for(var/department in department_display_order)
		var/list/actors_under_department = actors_by_department[department]
		if(actors_under_department.len)
			var/department_color = JCOLOR_BY_DEPARTMENT[department] || "#ffffff"
			dat += "<h2><font color='[department_color]'>[department]</font></h2><hr>"
			for(var/entry in actors_under_department)
				dat += "[entry]"

	for(var/department in extra_departments)
		var/list/actors_under_department = actors_by_department[department]
		if(actors_under_department.len)
			var/department_color = JCOLOR_BY_DEPARTMENT[department] || "#ffffff"
			dat += "<h2><font color='[department_color]'>[department]</font></h2><hr>"
			for(var/entry in actors_under_department)
				dat += "[entry]"

	var/datum/browser/popup = new(src, "actors", "<center>This Story's Actors</center>", 500, 600)
	popup.set_content(dat.Join(""))
	popup.open(FALSE)
