/obj/effect/proc_holder/spell/invoked/shrink
	name = "Shrink"
	desc = "For a time shrinks your target, forcing them to realize their pitifulness."
	cost = 2
	overlay_state = "rune3"
	releasedrain = 35
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 3 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 4
	invocations = list("Miserrimus!")
	invocation_type = "shout"
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	range = 7

/obj/effect/proc_holder/spell/invoked/shrink/cast(list/targets, mob/user = usr)
	if(!length(targets) || !isliving(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	if(target.has_status_effect(/datum/status_effect/debuff/shrink))
		to_chat(user, span_warning("They're already too small to shrink further!"))
		revert_cast()
		return FALSE
	var/current_yscale = sqrt(target.transform.b**2 + target.transform.d**2) || 1
	var/applied_scale = 0.5
	var/matrix/M = matrix(target.transform)
	M.Scale(applied_scale, applied_scale)
	var/shift_y = -16 * current_yscale * applied_scale
	if(target.lying)
		shift_y = -8 * current_yscale * applied_scale   
	target.pixel_y += shift_y
	animate(target, transform = M, pixel_y = target.pixel_y, time = 0.3 SECONDS, easing = EASE_IN)
	to_chat(target, span_warning("You rapidly shrink! Everything is getting huge!"))
	target.visible_message(span_notice("[target] shrinks down to half size!"))
	playsound(target, 'sound/misc/portal_enter.ogg', 50, TRUE, -2)
	target.apply_status_effect(/datum/status_effect/debuff/shrink)
	addtimer(CALLBACK(src, PROC_REF(remove_debuff), target, applied_scale), 2 MINUTES)  
	return TRUE

/obj/effect/proc_holder/spell/invoked/shrink/proc/remove_debuff(mob/living/carbon/target, applied_scale)
	if(QDELETED(target) || !target.has_status_effect(/datum/status_effect/debuff/shrink))
		return
	var/matrix/current = matrix(target.transform)
	current.Scale(1 / applied_scale, 1 / applied_scale)
	animate(target, transform = current, time = 0.8 SECONDS, easing = EASE_OUT)
	addtimer(CALLBACK(src, PROC_REF(reset_pixel_position), target), 0.9 SECONDS)
	target.remove_status_effect(/datum/status_effect/debuff/shrink)
	to_chat(target, span_notice("You suddenly grow back to normal size!"))
	target.visible_message(span_notice("[target] grows back to normal size!"))

/obj/effect/proc_holder/spell/invoked/shrink/proc/reset_pixel_position(mob/living/carbon/target)
	if(QDELETED(target))
		return
	if(target.lying)          
		target.pixel_y = -8    
	else                       
		target.pixel_y = 0    
	animate(target, pixel_y = target.pixel_y, time = 0.1)
