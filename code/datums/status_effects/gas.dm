/datum/status_effect/freon
	id = "frozen"
	duration = 100
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/freon
	mob_effect_icon = 'modular_twilight_axis/icons/effects/freeze.dmi' //TA EDIT
	mob_effect_icon_state = "ice_cube" //TA EDIT

	var/can_melt = TRUE

/atom/movable/screen/alert/status_effect/freon
	name = "Frozen Solid"
	desc = ""
	icon_state = "frozen"

/datum/status_effect/freon/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_RESIST, PROC_REF(owner_resist))
	if(!owner.stat)
		to_chat(owner, span_danger("I become frozen in a cube!"))
	
	owner.update_mobility()
	owner.appearance = owner.appearance //TA EDIT
	return ..()

/datum/status_effect/freon/tick()
	owner.update_mobility()
	if(can_melt && owner.bodytemperature >= BODYTEMP_NORMAL)
		qdel(src)

/datum/status_effect/freon/proc/owner_resist()
	to_chat(owner, span_notice("I start breaking out of the ice cube..."))
	if(do_mob(owner, owner, 40))
		if(!QDELETED(src))
			to_chat(owner, span_notice("I break out of the ice cube!"))
			owner.remove_status_effect(/datum/status_effect/freon)
			owner.update_mobility()

/datum/status_effect/freon/on_remove()
	if(!owner.stat)
		to_chat(owner, span_notice("The cube melts!"))
	..() //TA EDIT START

	if(mob_effect && !QDELETED(mob_effect))
		qdel(mob_effect)
		mob_effect = null

	if(owner)
		owner.appearance = owner.appearance
		if(hascall(owner, "update_icon"))
			call(owner, "update_icon")() //TA EDIT END

	owner.adjust_bodytemperature(100)
	owner.update_mobility()
	UnregisterSignal(owner, COMSIG_LIVING_RESIST)

/datum/status_effect/freon/watcher
	duration = 8
	can_melt = FALSE

/datum/status_effect/freon/freezing
	duration = 10 SECONDS
	can_melt = FALSE
