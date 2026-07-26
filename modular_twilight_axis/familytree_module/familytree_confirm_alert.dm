#define FAMILYTREE_CONFIRM_ALERT_CATEGORY "familytree_confirm"

/atom/movable/screen/alert/familytree_confirm
	name = "Семейная связь"
	desc = "Система нашла для вас семейную связь. Нажмите, чтобы открыть меню принятия или отказа."
	icon_state = "buff"
	alert_group = ALERT_BUFF
	// Render above the rest of the HUD and get a fixed prominent spot (see the
	// reorganize_alerts override below) so it isn't buried among other alerts.
	plane = ABOVE_HUD_PLANE
	layer = ABOVE_HUD_LAYER
	var/datum/callback/on_open

/atom/movable/screen/alert/familytree_confirm/Destroy()
	on_open = null
	return ..()

/atom/movable/screen/alert/familytree_confirm/Click(location, control, params)
	var/mob/user = usr
	if(!user || !user.client)
		return
	if(user.alerts[FAMILYTREE_CONFIRM_ALERT_CATEGORY] != src)
		return
	var/datum/callback/cb = on_open
	on_open = null
	user.clear_alert(FAMILYTREE_CONFIRM_ALERT_CATEGORY)
	if(cb)
		cb.Invoke()

/mob/living/carbon/human/proc/familytree_show_confirm_button(button_desc, datum/callback/on_open)
	if(!client || !hud_used)
		return FALSE
	clear_alert(FAMILYTREE_CONFIRM_ALERT_CATEGORY)
	var/atom/movable/screen/alert/familytree_confirm/alert = throw_alert(FAMILYTREE_CONFIRM_ALERT_CATEGORY, /atom/movable/screen/alert/familytree_confirm)
	if(!istype(alert))
		return FALSE
	alert.on_open = on_open
	if(button_desc)
		alert.desc = "[button_desc]\n\nНажмите, чтобы открыть меню принятия или отказа."
	alert.add_filter("familytree_glow", 2, list("type" = "outline", "size" = 1, "color" = "#e8b923"))
	animate(alert, alpha = 150, time = 8 SECONDS, loop = -1, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
	animate(alpha = 255, time = 8 SECONDS, easing = SINE_EASING)
	return TRUE

/mob/living/carbon/human/proc/familytree_clear_confirm_button()
	if(alerts && alerts[FAMILYTREE_CONFIRM_ALERT_CATEGORY])
		clear_alert(FAMILYTREE_CONFIRM_ALERT_CATEGORY)

#undef FAMILYTREE_CONFIRM_ALERT_CATEGORY
