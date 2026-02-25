/datum/crafting_stage
	var/icon_state = ""
	var/description = ""
	var/datum/crafting_recipe/recipe 

/obj/structure/multistage
	name = "unfinished structure"
	desc = "A skeleton of a structure in progress."
	icon = 'icons/obj/structures.dmi'
	icon_state = "state0"
	anchored = TRUE
	density = TRUE
	max_integrity = 300

	var/stage = 1
	var/list/stage_types = list() 
	var/list/stages_cache        
	var/final_product_type       
	var/base_desc = "An unfinished structure."

/obj/structure/multistage/Initialize()
	. = ..()
	stages_cache = list()
	
	
	for(var/S in stage_types)
		var/datum/crafting_stage/CS = new S()
		if(ispath(CS.recipe))
			CS.recipe = new CS.recipe() 
		stages_cache += CS
	
	update_stage_appearance()

/obj/structure/multistage/Destroy()
	
	if(stages_cache)
		for(var/datum/crafting_stage/CS in stages_cache)
			if(CS.recipe)
				qdel(CS.recipe)
			qdel(CS)
		stages_cache = null
	return ..()

/obj/structure/multistage/proc/update_stage_appearance()
	if(stage <= length(stages_cache))
		var/datum/crafting_stage/S = stages_cache[stage]
		icon_state = S.icon_state
		desc = "[base_desc] [S.description]"
	else
		desc = base_desc

/obj/structure/multistage/attackby(obj/item/I, mob/living/carbon/user)
	
	if(!istype(user) || !user.craftingthing)
		return ..()
		
	if(try_progress_stage(user, I))
		return
	return ..()

/obj/structure/multistage/proc/try_progress_stage(mob/living/carbon/user, obj/item/tool)
	if(user.doing)
		return FALSE
	
	var/datum/component/personal_crafting/PC = user.craftingthing
	if(!PC)
		return FALSE

	
	if(stage > length(stages_cache))
		finish_construction(user)
		return TRUE

	var/datum/crafting_stage/current_stage_datum = stages_cache[stage]
	var/datum/crafting_recipe/R = current_stage_datum.recipe 
	
	if(!R)
		return FALSE

	var/list/surroundings = PC.get_surroundings(user)

	
	if(!PC.check_contents(R, surroundings) || !PC.check_tools(user, R, surroundings))
		var/report = get_missing_report(R, surroundings, user)
		to_chat(user, span_warning("You are missing requirements for the next stage: [report]."))
		return FALSE

	
	user.visible_message(span_notice("[user] starts working on [src]..."), span_notice("You start working on [src]..."))
	
	if(R.craftsound)
		playsound(src, R.craftsound, 50, TRUE)

	if(do_after(user, 30, target = src))
		
		surroundings = PC.get_surroundings(user)
		if(!PC.check_contents(R, surroundings) || !PC.check_tools(user, R, surroundings))
			to_chat(user, span_warning("Conditions changed, construction failed."))
			return FALSE

		
		PC.del_reqs(R, user)
		
		
		if(user.mind && R.skillcraft && R.craftdiff)
			user.mind.add_sleep_experience(R.skillcraft, R.craftdiff * 10, FALSE)

		stage++
		user.visible_message(span_notice("[user] completes a stage of [src]."), span_notice("You complete a stage."))
		
		if(stage > length(stages_cache))
			finish_construction(user)
		else
			update_stage_appearance()
		
		return TRUE

	return FALSE

/obj/structure/multistage/proc/get_missing_report(datum/crafting_recipe/R, list/surroundings, mob/living/carbon/user)
	var/list/missing = list()
	var/list/contents = surroundings["other"]

	
	for(var/path in R.reqs)
		var/needed = R.reqs[path]
		var/found = 0
		for(var/check_path in contents)
			if(ispath(check_path, path))
				found += contents[check_path]
		
		if(found < needed)
			var/atom/A = path
			missing += "[needed - found]x [initial(A.name)]"

	
	var/datum/component/personal_crafting/PC = user.craftingthing
	if(PC && !PC.check_tools(user, R, surroundings))
		for(var/tool_path in R.tools)
			
			if(!(locate(tool_path) in user.contents))
				var/obj/O = tool_path
				missing += "[initial(O.name)] (tool)"

	return missing.Join(", ")

/obj/structure/multistage/proc/finish_construction(mob/user)
	if(final_product_type)
		new final_product_type(loc)
		user.visible_message(span_nicegreen("[user] finishes the construction of [src]!"))
		qdel(src)
