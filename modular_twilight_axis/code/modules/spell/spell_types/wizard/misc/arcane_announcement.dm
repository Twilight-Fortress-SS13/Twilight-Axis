/obj/effect/proc_holder/spell/self/arcane_announcement
	name = "Arcane Proclamation"
	desc = "Project your voice across the entire realm using arcane power. Your message will be heard by all."
	overlay_state = "paper"
	action_icon = 'modular_twilight_axis/icons/mob/actions/roguespells.dmi'
	sound = list('sound/magic/whiteflame.ogg')
	releasedrain = 40
	chargetime = 3 SECONDS
	recharge_time = 5 MINUTES
	invocations = list("VOX MAGI!")
	invocation_type = "shout"
	cost = 2
	spell_tier = 3
	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/self/arcane_announcement/cast(list/targets, mob/living/user = usr)

	if(!SScommunications.can_announce(user, FALSE))
		to_chat(user, span_warning("The arcane winds are too turbulent for a proclamation right now!"))
		revert_cast()
		return FALSE


	var/message = stripped_input(user, "What message do you wish to broadcast to the realm?", "Arcane Proclamation", "")
	

	if(!message || QDELETED(src) || user.stat != CONSCIOUS)
		revert_cast()
		return FALSE

	
	var/used_title = "Court Magician"

	
	priority_announce(html_decode(user.treat_message(message)), "[used_title] Speak", 'sound/misc/bellold.ogg', sender = user)

	log_game("[key_name(user)] cast Arcane Proclamation: [message]")
	
	do_sparks(5, FALSE, user)
	
	return TRUE
