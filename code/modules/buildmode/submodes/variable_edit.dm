/datum/buildmode_mode/varedit
	key = "edit"
	// Varedit mode
	var/varholder = null
	var/valueholder = null

/datum/buildmode_mode/varedit/Destroy()
	varholder = null
	valueholder = null
	return ..()

/datum/buildmode_mode/varedit/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("Right Mouse Button on buildmode button = Select var(type) & value"))
	to_chat(c, span_notice("Left Mouse Button on turf/obj/mob		= Set var(type) & value"))
	to_chat(c, span_notice("Right Mouse Button on turf/obj/mob		= Reset var's value"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/varedit/Reset()
	. = ..()
	varholder = null
	valueholder = null

/datum/buildmode_mode/varedit/change_settings(client/c)
	varholder = input(c, "Enter variable name:" ,"Name", "name")

	if(!vv_varname_lockcheck(varholder))
		return

	var/temp_value = c.vv_get_value()
	if(isnull(temp_value["class"]))
		Reset()
		to_chat(c, span_notice("Variable unset."))
		BM.log_action("cleared variable edit configuration.") // TA EDIT
		return
	valueholder = temp_value["value"]
	BM.log_action("configured variable edit: var '[varholder]' with value '[valueholder]'.") // TA EDIT

/datum/buildmode_mode/varedit/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(isnull(varholder))
		to_chat(c, span_warning("Choose a variable to modify first."))
		return
	if(left_click)
		if(object.vars.Find(varholder))
			var/old_value = object.vars[varholder] // TA EDIT
			if(object.vv_edit_var(varholder, valueholder) == FALSE)
				to_chat(c, span_warning("My edit was rejected by the object."))
				return
			BM.log_action("changed [object] ([object.type]) var '[varholder]' from '[old_value]' to '[valueholder]' at [AREACOORD(object)] using variable edit mode.") // TA EDIT
		else
			to_chat(c, span_warning("[initial(object.name)] does not have a var called '[varholder]'"))
	if(right_click)
		if(object.vars.Find(varholder))
			var/old_reset_value = object.vars[varholder] // TA EDIT
			var/reset_value = initial(object.vars[varholder])
			if(object.vv_edit_var(varholder, reset_value) == FALSE)
				to_chat(c, span_warning("My edit was rejected by the object."))
				return
			BM.log_action("reset [object] ([object.type]) var '[varholder]' from '[old_reset_value]' to initial value '[reset_value]' at [AREACOORD(object)] using variable edit mode.") // TA EDIT
		else
			to_chat(c, span_warning("[initial(object.name)] does not have a var called '[varholder]'"))
