/datum/buildmode_mode/throwing
	key = "throw"

	var/atom/movable/throw_atom = null

/datum/buildmode_mode/throwing/Destroy()
	throw_atom = null
	return ..()

/datum/buildmode_mode/throwing/show_help(client/c)
	to_chat(c, span_notice("***********************************************************"))
	to_chat(c, span_notice("Left Mouse Button on turf/obj/mob		= Select"))
	to_chat(c, span_notice("Right Mouse Button on turf/obj/mob		= Throw"))
	to_chat(c, span_notice("***********************************************************"))

/datum/buildmode_mode/throwing/handle_click(client/c, params, obj/object)
	var/list/pa = params2list(params)
	var/left_click = pa.Find("left")
	var/right_click = pa.Find("right")

	if(left_click)
		if(isturf(object))
			return
		throw_atom = object
		to_chat(c, "Selected object '[throw_atom]'")
		BM.log_action("selected [throw_atom] ([throw_atom.type]) at [AREACOORD(throw_atom)] for throw mode.") // TA EDIT
	if(right_click)
		if(throw_atom)
			var/throw_desc = "[throw_atom]" // TA EDIT START
			var/throw_type = "[throw_atom.type]"
			var/source_location = AREACOORD(throw_atom)
			var/target_desc = "[object]"
			var/target_type = "[object.type]"
			var/target_location = AREACOORD(object) // TA EDIT END
			throw_atom.throw_at(object, 10, 1, c.mob)
			BM.log_action("threw [throw_desc] ([throw_type]) from [source_location] toward [target_desc] ([target_type]) at [target_location].") // TA EDIT
