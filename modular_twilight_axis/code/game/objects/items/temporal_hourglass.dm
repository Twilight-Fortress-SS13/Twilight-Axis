/obj/item/hourglass/temporal
	var/cooldown = 0
	var/cooldown_time = 3 MINUTES

/obj/item/hourglass/temporal/toggle(mob/user)
	if(!user)
		return
	if(!user.mind)
		return

	// Запрет для Lich и Vampire Lord
	if(user.mind.has_antag_datum(/datum/antagonist/lich) || user.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		to_chat(user, span_warning("The power of MY essence is so great that the temporal sands are unable to affect me."))
		return

	if(user.mind.special_role == "Lich" || user.mind.special_role == "Vampire Lord")
		to_chat(user, span_warning("The power of MY essence is so great that the temporal sands are unable to affect me."))
		return

	// Кулдаун
	if(cooldown > world.time)
		to_chat(user, span_warning("The hourglass is still recharging. ([DisplayTimeText(cooldown - world.time)] remaining)"))
		return

	if(!timing_id)
		to_chat(user, span_notice("I flip the [src]."))
		start()
		flick("hourglass_flip", src)
		target = get_turf(src)
		victim = user
		// Звук активации
		playsound(src, 'sound/magic/timeforward.ogg', 50, FALSE, 5)
	else
		to_chat(user, span_notice("I stop the [src]."))
		stop()

/obj/item/hourglass/temporal/stop()
	// Звук окончания
	playsound(src, 'sound/magic/timereverse.ogg', 50, FALSE, 5)

	var/mob/living/teleport_victim = victim
	var/turf/teleport_target = target

	..() // родительский stop (сброс таймера)

	if(teleport_victim && teleport_target)
		do_teleport(teleport_victim, teleport_target, channel = TELEPORT_CHANNEL_QUANTUM)

	// Кулдаун после использования
	cooldown = world.time + cooldown_time
	victim = null
	target = null

/obj/item/hourglass/temporal/examine(mob/user)
	. = ..()
	if(cooldown > world.time)
		. += span_warning("It is still recharging. ([DisplayTimeText(cooldown - world.time)] remaining)")
	else if(!timing_id)
		. += span_notice("It is ready to be used.")
