// ADMIN COMMANDS FOR DISEASE INFECTION

/client/proc/infect()
	set category = "-Fun-"
	set name = "Infect"

	if(!mob || !isliving(mob))
		alert("You must be in a living mob to infect.")
		return

	infect_target_internal(mob)

/client/proc/infect_target(mob/living/carbon/M in GLOB.mob_list)
	set category = "-Fun-"
	set name = "Infect"

	if(!M)
		return
	infect_target_internal(M)

/client/proc/infect_target_internal(mob/living/target)
	set hidden = TRUE

	if(!check_rights(R_FUN))
		return
	if(!target || !isliving(target))
		alert("You must target a living mob to infect.")
		return

	var/list/choices = list()
	for(var/disease_type in subtypesof(/datum/disease))
		if(disease_type == /datum/disease)
			continue
		var/datum/disease/prototype = new disease_type()
		var/display_name = prototype.name
		qdel(prototype)
		if(!display_name || display_name == "No disease")
			continue
		choices[display_name] = disease_type

	if(!length(choices))
		alert("No diseases available.")
		return

	var/choice = input("Choose a disease", "Infect") as null|anything in sortList(choices)
	if(!choice)
		return

	var/disease_type = choices[choice]
	var/datum/disease/D = new disease_type()
	var/mob/living/L = target
	L.ForceContractDisease(D, FALSE, TRUE)
	log_admin("[key_name(src)] infected [key_name(L)] with [choice].")
	message_admins("[key_name_admin(src)] infected [key_name_admin(L)] with [choice].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Infect")
