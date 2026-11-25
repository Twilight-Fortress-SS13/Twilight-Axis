/datum/keybinding/living/sprint_hold
	hotkey_keys = list()
	name = "sprint_hold"
	full_name = "Sprint (Hold)"
	description = "Sprinting can be dangerous to your health if you aren't careful. This requires a constant hold input."

/datum/keybinding/living/sprint_hold/down(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_WALK)
		M.toggle_rogmove_intent(MOVE_INTENT_RUN)
	return TRUE

/datum/keybinding/living/sprint_hold/up(client/user)
	var/mob/M = user.mob
	if(!isliving(M))
		return
	if(M.m_intent == MOVE_INTENT_RUN)
		M.toggle_rogmove_intent(MOVE_INTENT_WALK)
	return TRUE

/datum/keybinding/living/jump_hold
	hotkey_keys = list()
	name = "jump_hold"
	full_name = "Jump (Hold)"
	description = "Selects Jump Intent. This requires a constant hold input."

/datum/keybinding/living/jump_hold/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP) //These detoggle each other as needed
	return TRUE

/datum/keybinding/living/jump_hold/up(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE

/datum/keybinding/carbon/throw_hold
	name = "toggle_throw_mode_hold"
	full_name = "Throw Mode (Hold)"
	description = "Toggle throwing the current item or not. Requires a held input."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/throw_hold/down(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.throw_mode_on()
	return TRUE

/datum/keybinding/carbon/throw_hold/up(client/user)
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.throw_mode_off()
	return TRUE
