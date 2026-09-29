/datum/buildmode_mode/advanced
	key = "advanced"
	var/objholder = null

// FIXME: add logic which adds a button displaying the icon
// of the currently selected path

/datum/buildmode_mode/advanced/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("Right Mouse Button on buildmode button = Set object type"))
	to_chat(c, span_notice("Left Mouse Button + alt on turf/obj	= Copy object type"))
	to_chat(c, span_notice("Left Mouse Button on turf/obj			= Place objects"))
	to_chat(c, span_notice("Right Mouse Button						= Delete objects"))
	to_chat(c, "")
	to_chat(c, span_notice("Use the button in the upper left corner to"))
	to_chat(c, span_notice("change the direction of built objects."))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/advanced/change_settings(client/c)
	var/target_path = input(c, "Enter typepath:", "Typepath", "/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			alert(c, "No path was selected")
			return
		else if(ispath(objholder, /area))
			objholder = null
			alert(c, "That path is not allowed.")
			return
	BM.log_action("configured advanced mode object type as [objholder].") // TA EDIT

/datum/buildmode_mode/advanced/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")
	var/alt_click = pa.Find("alt")

	if(left_click && alt_click)
		if (istype(object, /turf) || istype(object, /obj) || istype(object, /mob))
			objholder = object.type
			to_chat(c, span_notice("[initial(object.name)] ([object.type]) selected."))
			BM.log_action("copied object type [object.type] from [object] at [AREACOORD(object)] for advanced mode.") // TA EDIT
		else
			to_chat(c, span_notice("[initial(object.name)] is not a turf, object, or mob! Please select again."))
	else if(left_click)
		if(ispath(objholder,/turf))
			var/turf/T = get_turf(object)
			var/old_type = T.type // TA EDIT
			var/location_desc = AREACOORD(T) // TA EDIT
			T.ChangeTurf(objholder)
			BM.log_action("changed turf at [location_desc] from [old_type] to [objholder] using advanced mode.") // TA EDIT
		else if(!isnull(objholder))
			var/obj/A = new objholder (get_turf(object))
			A.setDir(BM.build_dir)
			BM.log_action("created [A] ([A.type]) at [AREACOORD(A)] facing [dir2text(BM.build_dir)] ([BM.build_dir]) using advanced mode.") // TA EDIT
		else
			to_chat(c, span_warning("Select object type first."))
	else if(right_click)
		if(isobj(object))
			BM.log_action("deleted [object] ([object.type]) at [AREACOORD(object)] using advanced mode.") // TA EDIT
			qdel(object)
