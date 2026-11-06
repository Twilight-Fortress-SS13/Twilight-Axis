/obj/item/natural/stone/sending/attack_self(mob/user)
	if(!paired_with)
		to_chat(user, span_warning("The stone feels inert... it has no pair."))
		return

	var/input_text = input(user, "Enter your message:", "Message")
	if(!input_text)
		return

	// Шёпот от камня: слышно в радиусе 1 тайла
	paired_with.say(input_text, message_range = 1, message_mode = MODE_WHISPER)

	// Звук только владельцу второго камня
	var/mob/living/receiver = get_holder_of(paired_with)
	if(receiver)
		playsound(receiver, 'sound/magic/mindlink.ogg', 50, FALSE)

	to_chat(user, span_notice("You send a message through the stone."))

/obj/item/natural/stone/sending/proc/get_holder_of(atom/A)
	var/atom/current = A
	while(current && !ismob(current))
		current = current.loc
	if(ismob(current))
		return current
	return null
