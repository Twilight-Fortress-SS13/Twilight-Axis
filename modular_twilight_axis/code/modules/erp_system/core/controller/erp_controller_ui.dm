/datum/erp_controller_ui
	var/datum/erp_controller/controller

/datum/erp_controller_ui/New(datum/erp_controller/C)
	. = ..()
	controller = C

/// Opens UI for owner client.
/datum/erp_controller_ui/proc/open_ui(mob/user = null)
	if(!controller.ui)
		return

	var/mob/M = controller._get_ui_user(user)
	if(!M || !M.client)
		return

	controller.owner_client?.prefs?.apply_erp_kinks_to_mob(M)
	controller.ui.ui_interact(M)

/// Builds controller payload and injects partners + active partner info.
/datum/erp_controller_ui/proc/build_ui_payload()
	if(!controller.ui)
		return null

	var/list/p = controller.ui.build_payload()
	if(!islist(p))
		p = list()

	p["partners"] = controller.get_partners_ui()

	if(controller.active_partner)
		p["active_partner_ref"] = controller.active_partner.get_ref()
		p["active_partner_name"] = controller.active_partner.get_display_name()
		p["active_partner_is_self"] = (controller.active_partner == controller.owner) ? TRUE : FALSE
	else
		p["active_partner_ref"] = null
		p["active_partner_name"] = null
		p["active_partner_is_self"] = FALSE

	return p

/// Requests UI update on arousal changes.
/datum/erp_controller_ui/proc/on_arousal_changed(datum/source)
	controller.ui?.request_update()

/// Returns arousal data list from COMSIG.
/datum/erp_controller_ui/proc/get_arousal_data(mob/living/carbon/human/H)
	if(!istype(H))
		return null

	var/list/data = list()
	SEND_SIGNAL(H, COMSIG_SEX_GET_AROUSAL, data)

	if(!length(data))
		return null

	return data

/// Returns owner arousal value for UI.
/datum/erp_controller_ui/proc/get_actor_arousal_ui(mob/user)
	var/mob/living/A = controller._get_owner_effect_mob()
	if(!istype(A))
		return 0

	var/list/data = get_arousal_data(A)
	return data ? (data["arousal"] || 0) : 0

/// Returns partner arousal value for UI (or null if hidden).
/datum/erp_controller_ui/proc/get_partner_arousal_ui(mob/user)
	var/mob/living/B = controller._get_partner_effect_mob()
	if(!istype(B))
		return 0

	if(controller.is_partner_arousal_hidden(B))
		return null

	var/list/data = get_arousal_data(B)
	return data ? (data["arousal"] || 0) : 0

/// Sets owner arousal directly.
/datum/erp_controller_ui/proc/set_actor_arousal(actor, value = 0)
	var/mob/living/carbon/human/owner_mob = controller.owner?.physical
	if(!istype(owner_mob) || !owner_mob.client)
		return FALSE

	var/mob/living/carbon/human/H = null
	if(istype(actor,/datum/erp_actor))
		var/datum/erp_actor/A = actor
		H = A.physical
	else if(istype(actor, /mob/living/carbon/human))
		H = actor
	else if(istext(actor))
		if("\ref[owner_mob]" == "[actor]" || "[owner_mob]" == "[actor]")
			H = owner_mob

	if(H != owner_mob)
		return FALSE

	var/n = isnum(value) ? value : text2num("[value]")
	if(!isnum(n))
		return FALSE

	n = clamp(round(n), 0, MAX_AROUSAL)
	SEND_SIGNAL(owner_mob, COMSIG_SEX_SET_AROUSAL, n, TRUE)
	return TRUE

/// Requests throttled UI update.
/datum/erp_controller_ui/proc/request_ui_update()
	if(controller.ui_update_scheduled)
		if(world.time >= controller.next_ui_update)
			_do_ui_update()
		return

	if(world.time < controller.next_ui_update)
		controller.ui_update_scheduled = TRUE
		return

	_do_ui_update()

/// Updates UI now with throttle window.
/datum/erp_controller_ui/proc/_do_ui_update()
	var/min_delay = 2
	if(world.time < controller.next_ui_update)
		controller.ui_update_scheduled = TRUE
		return

	controller.ui_update_scheduled = FALSE
	controller.next_ui_update = world.time + min_delay
	SStgui.update_uis(controller.ui)
