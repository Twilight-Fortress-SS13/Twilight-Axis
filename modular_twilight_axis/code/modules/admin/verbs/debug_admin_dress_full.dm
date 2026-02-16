/client/proc/cmd_admin_dress_full(mob/M in GLOB.mob_list)
	set category = "-Fun-"
	set name = "Select equipment (full)"
	if(!(ishuman(M) || isobserver(M)))
		alert("Invalid mob")
		return

	var/result = robust_dress_shop_full()

	if(!result)
		return

	var/delete_pocket
	var/mob/living/carbon/human/H
	if(isobserver(M))
		H = M.change_mob_type(/mob/living/carbon/human, null, null, TRUE)
	else
		H = M
		if(H.l_store || H.r_store || H.s_store) //saves a lot of time for admins and coders alike
			if(alert("Drop Items in Pockets? No will delete them.", "Robust quick dress shop", "Yes", "No") == "No")
				delete_pocket = TRUE

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Select Equipment (Full)") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	for (var/obj/item/I in H.get_equipped_items(delete_pocket))
		qdel(I)

	var/display_name = "Naked"
	if(result != "Naked")
		// If admin selected a job title (from robust_dress_shop_full), invoke class handler to allow subclass pick
		var/datum/job/J = SSjob.GetJob(result)
		if(J)
			// set the mob's job so the handler knows which categories to show
			H.job = result
			// Apply job-level traits (jobs declare `job_traits`) so admin assignment behaves like normal spawn
			if(length(J.job_traits))
				for(var/trait in J.job_traits)
					ADD_TRAIT(H, trait, JOB_TRAIT)
			if(!H.client)
				alert("Target mob has no client attached; cannot show subclass selection.")
			else
				SSrole_class_handler.setup_class_handler(H, null, null, TRUE, TRUE)
			// don't equip here; the class handler will call equipme when finished
			display_name = result
		else if(istype(result, /datum/advclass))
			// Apply advclass with all its stats, traits, and skills
			var/datum/advclass/AC = result
			display_name = AC.name
			AC.equipme(H)
		else
			// Regular outfit
			H.equipOutfit(result)
			display_name = "[result]"

	H.regenerate_icons()
	LAZYREMOVE(GLOB.actors_list, H.mobid)

	log_admin("[key_name(usr)] changed the equipment of [key_name(H)] to [display_name].")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] changed the equipment of [ADMIN_LOOKUPFLW(H)] to [display_name].</span>")

/client/proc/robust_dress_shop_full()

	var/list/baseoutfits = list("Naked","Custom", "As Roguetown Job (Full)...")
	var/list/outfits = list()
	var/list/paths = subtypesof(/datum/outfit) - typesof(/datum/outfit/job)  - typesof(/datum/outfit/job/roguetown)

	for(var/path in paths)
		var/datum/outfit/O = path //not much to initalize here but whatever
		if(initial(O.can_be_admin_equipped))
			outfits[initial(O.name)] = path

	var/selection = input("Select outfit", "Robust quick dress shop (full)") as null|anything in baseoutfits + sortList(outfits)
	if (isnull(selection))
		return

	if (outfits[selection])
		return outfits[selection]

	if (selection == "Custom")
		var/list/custom_names = list()
		for(var/datum/outfit/D in GLOB.custom_outfits)
			custom_names[D.name] = D
		var/selected_name = input("Select outfit", "Robust quick dress shop") as null|anything in sortList(custom_names)
		var/selected = custom_names[selected_name]
		if(isnull(selected))
			return
		return selected

	if (selection == "As Roguetown Job (Full)...")
		var/list/job_names = list()
		var/list/all_jobs = subtypesof(/datum/job/roguetown)
		for(var/jobpath in all_jobs)
			var/datum/job/J = jobpath
			if(initial(J.title))
				job_names[initial(J.title)] = jobpath

		var/selected_job = input("Select job (full)", "Robust quick dress shop (full)") as null|anything in sortList(job_names)
		if(isnull(selected_job))
			return

		var/selected_job_path = job_names[selected_job]
		if(isnull(selected_job_path))
			return

		// Return the job title to the caller so the admin proc can invoke the class handler
		return selected_job

	if (selection == "Naked")
		return "Naked"

	return null
