/obj/effect/proc_holder/spell/self/mist_form
	name = "Mist Form"
	desc = "Dissolve into a pale mist. Projectiles and melee attacks will pass through your body. You cannot attack others in this state."
	overlay_state = "speakwithdead"
	releasedrain = 40
	chargedrain = 1
	chargetime = 3
	range = 2
	cost = 6
	spell_tier = 3
	recharge_time = 50 SECONDS
	warnie = "spellwarning"
	invocations = list("NUNELOS!")
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	ignore_los = FALSE
	var/duration = 120

/obj/effect/proc_holder/spell/self/mist_form/cast(list/targets, mob/living/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/mist_form))
		to_chat(user, span_warning("I am already in mist form!"))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user] dissolves into a ghostly mist!"), \
						 span_notice("I shift my body into the ethereal plane."))
	

	user.apply_status_effect(/datum/status_effect/buff/mist_form, duration)
	
	playsound(user, 'sound/magic/swap.ogg', 75, TRUE)
	return TRUE
